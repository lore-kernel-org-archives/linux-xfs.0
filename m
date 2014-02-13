Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6B9737F5D
	for <xfs@oss.sgi.com>; Thu, 13 Feb 2014 17:32:16 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E1D1EAC005
	for <xfs@oss.sgi.com>; Thu, 13 Feb 2014 15:32:15 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id p1HkgInL33NGuOx5 for <xfs@oss.sgi.com>;
	Thu, 13 Feb 2014 15:32:13 -0800 (PST)
Message-ID: <52FD55FC.1000103@sandeen.net>
Date: Thu, 13 Feb 2014 17:32:12 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH V3] xfs: skip verification on initial "guess" superblock read
References: <52FD3C59.3050400@redhat.com>
In-Reply-To: <52FD3C59.3050400@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

When xfs_readsb() does the very first read of the superblock,
it makes a guess at the length of the buffer, based on the
sector size of the underlying storage.  This may or may
not match the filesystem sector size in sb_sectsize, so
we can't i.e. do a CRC check on it; it might be too short.

In fact, mounting a filesystem with sb_sectsize larger
than the device sector size will cause a mount failure
if CRCs are enabled, because we are checksumming a length
which exceeds the buffer passed to it.

So always read twice; the first time we read with NULL
buffer ops to skip verification; then set the proper
read length, hook up the proper verifier, and give it
another go.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V3: Go back to always reading twice, to avoid the need for
duplicating the code that handles verifier errors.

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 02df7b4..f96c056 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -282,22 +282,29 @@ xfs_readsb(
 	struct xfs_sb	*sbp = &mp->m_sb;
 	int		error;
 	int		loud = !(flags & XFS_MFSI_QUIET);
+	const struct xfs_buf_ops *buf_ops;
 
 	ASSERT(mp->m_sb_bp == NULL);
 	ASSERT(mp->m_ddev_targp != NULL);
 
 	/*
+	 * For the initial read, we must guess at the sector
+	 * size based on the block device.  It's enough to
+	 * get the sb_sectsize out of the superblock and
+	 * then we can reread with the proper length.
+	 * We don't verify it yet, because it may not be complete.
+	 */
+	sector_size = xfs_getsize_buftarg(mp->m_ddev_targp);
+	buf_ops = NULL;
+
+	/*
 	 * Allocate a (locked) buffer to hold the superblock.
 	 * This will be kept around at all times to optimize
 	 * access to the superblock.
 	 */
-	sector_size = xfs_getsize_buftarg(mp->m_ddev_targp);
-
 reread:
 	bp = xfs_buf_read_uncached(mp->m_ddev_targp, XFS_SB_DADDR,
-				   BTOBB(sector_size), 0,
-				   loud ? &xfs_sb_buf_ops
-				        : &xfs_sb_quiet_buf_ops);
+				   BTOBB(sector_size), 0, buf_ops);
 	if (!bp) {
 		if (loud)
 			xfs_warn(mp, "SB buffer read failed");
@@ -328,12 +335,13 @@ reread:
 	}
 
 	/*
-	 * If device sector size is smaller than the superblock size,
-	 * re-read the superblock so the buffer is correctly sized.
+	 * Re-read the superblock so the buffer is correctly sized,
+	 * and properly verified.
 	 */
-	if (sector_size < sbp->sb_sectsize) {
+	if (buf_ops == NULL) {
 		xfs_buf_relse(bp);
 		sector_size = sbp->sb_sectsize;
+		buf_ops = loud ? &xfs_sb_buf_ops : &xfs_sb_quiet_buf_ops;
 		goto reread;
 	}
 
diff --git a/fs/xfs/xfs_sb.c b/fs/xfs/xfs_sb.c
index 5071ccb..1b0b503 100644
--- a/fs/xfs/xfs_sb.c
+++ b/fs/xfs/xfs_sb.c
@@ -644,7 +644,6 @@ xfs_sb_quiet_read_verify(
 {
 	struct xfs_dsb	*dsb = XFS_BUF_TO_SBP(bp);
 
-
 	if (dsb->sb_magicnum == cpu_to_be32(XFS_SB_MAGIC)) {
 		/* XFS filesystem, verify noisily! */
 		xfs_sb_read_verify(bp);


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
