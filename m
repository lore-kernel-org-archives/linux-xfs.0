Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51907 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031697AbdAJTnB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Jan 2017 14:43:01 -0500
Date: Tue, 10 Jan 2017 11:42:49 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [RFC PATCH] xfs_db: sanitize geometry on load
Message-ID: <20170110194249.GK14038@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org, Eryu Guan <eguan@redhat.com>

xfs_db doesn't check the filesystem geometry when it's mounting, which
means that garbage agcount values can cause OOMs when we try to allocate
all the per-AG incore metadata.  If we see geometry that looks
suspicious, try to derive the actual AG geometry to avoid crashing the
system.  This should help with xfs/1301 fuzzing.

Also fix up xfs_repair to use the min/max dblocks macros.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/init.c   |   91 +++++++++++++++++++++++++++++++++++++++++++++++++++++------
 repair/sb.c |    7 +----
 2 files changed, 83 insertions(+), 15 deletions(-)

diff --git a/db/init.c b/db/init.c
index ec1e274..7e66d14 100644
--- a/db/init.c
+++ b/db/init.c
@@ -51,13 +51,90 @@ usage(void)
 	exit(1);
 }
 
+/* Try to load an AG's superblock, no verifiers. */
+static bool
+load_sb(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	struct xfs_sb		*sbp)
+{
+	struct xfs_buf		*bp;
+
+	bp = libxfs_readbuf(mp->m_ddev_targp,
+			    XFS_AG_DADDR(mp, agno, XFS_SB_DADDR),
+			    1 << (XFS_MAX_SECTORSIZE_LOG - BBSHIFT), 0, NULL);
+
+	if (!bp || bp->b_error)
+		return false;
+
+	/* copy SB from buffer to in-core, converting architecture as we go */
+	libxfs_sb_from_disk(sbp, XFS_BUF_TO_SBP(bp));
+	libxfs_putbuf(bp);
+	libxfs_purgebuf(bp);
+
+	return true;
+}
+
+/* If the geometry doesn't look sane, try to figure out the real geometry. */
+static void
+sanitize_geometry(
+	struct xfs_mount	*mp,
+	struct xfs_sb		*sbp)
+{
+	struct xfs_sb		sb;
+	xfs_agblock_t		agblocks;
+
+	/* If the geometry looks ok, we're done. */
+	if (sbp->sb_blocklog >= XFS_MIN_BLOCKSIZE_LOG &&
+	    sbp->sb_blocklog <= XFS_MAX_BLOCKSIZE_LOG &&
+	    sbp->sb_blocksize == (1 << sbp->sb_blocklog) &&
+	    sbp->sb_dblocks * sbp->sb_blocksize <= x.dsize * x.dbsize &&
+	    sbp->sb_dblocks <= XFS_MAX_DBLOCKS(sbp) &&
+	    sbp->sb_dblocks >= XFS_MIN_DBLOCKS(sbp))
+		return;
+
+	/* Check blocklog and blocksize */
+	if (sbp->sb_blocklog < XFS_MIN_BLOCKSIZE_LOG ||
+	    sbp->sb_blocklog > XFS_MAX_BLOCKSIZE_LOG)
+		sbp->sb_blocklog = libxfs_log2_roundup(sbp->sb_blocksize);
+	if (sbp->sb_blocksize != (1 << sbp->sb_blocklog))
+		sbp->sb_blocksize = (1 << sbp->sb_blocksize);
+
+	/* Clamp dblocks to the size of the device. */
+	if (sbp->sb_dblocks > x.dsize * x.dbsize / sbp->sb_blocksize)
+		sbp->sb_dblocks = x.dsize * x.dbsize / sbp->sb_blocksize;
+
+	/* See if agblocks helps us find a superblock. */
+	mp->m_blkbb_log = sbp->sb_blocklog - BBSHIFT;
+	if (load_sb(mp, 1, &sb) && sb.sb_magicnum == XFS_SB_MAGIC) {
+		sbp->sb_agcount = sbp->sb_dblocks / sbp->sb_agblocks;
+		goto out;
+	}
+
+	/* See if agcount helps us find a superblock. */
+	agblocks = sbp->sb_agblocks;
+	sbp->sb_agblocks = sbp->sb_dblocks / sbp->sb_agcount;
+	if (sbp->sb_agblocks != 0 &&
+	    load_sb(mp, 1, &sb) &&
+	    sb.sb_magicnum == XFS_SB_MAGIC) {
+		goto out;
+	}
+
+	/* Both are nuts, assume 1 AG. */
+	sbp->sb_agblocks = agblocks;
+	sbp->sb_agcount = 1;
+out:
+	fprintf(stderr,
+		_("%s: device %s AG geometry is insane.  Using agcount=%u.\n"),
+		progname, fsdevice, sbp->sb_agcount);
+}
+
 void
 init(
 	int		argc,
 	char		**argv)
 {
 	struct xfs_sb	*sbp;
-	struct xfs_buf	*bp;
 	int		c;
 
 	setlocale(LC_ALL, "");
@@ -124,20 +201,12 @@ init(
 	 */
 	memset(&xmount, 0, sizeof(struct xfs_mount));
 	libxfs_buftarg_init(&xmount, x.ddev, x.logdev, x.rtdev);
-	bp = libxfs_readbuf(xmount.m_ddev_targp, XFS_SB_DADDR,
-			    1 << (XFS_MAX_SECTORSIZE_LOG - BBSHIFT), 0, NULL);
-
-	if (!bp || bp->b_error) {
+	if (!load_sb(&xmount, 0, &xmount.m_sb)) {
 		fprintf(stderr, _("%s: %s is invalid (cannot read first 512 "
 			"bytes)\n"), progname, fsdevice);
 		exit(1);
 	}
 
-	/* copy SB from buffer to in-core, converting architecture as we go */
-	libxfs_sb_from_disk(&xmount.m_sb, XFS_BUF_TO_SBP(bp));
-	libxfs_putbuf(bp);
-	libxfs_purgebuf(bp);
-
 	sbp = &xmount.m_sb;
 	if (sbp->sb_magicnum != XFS_SB_MAGIC) {
 		fprintf(stderr, _("%s: %s is not a valid XFS filesystem (unexpected SB magic number 0x%08x)\n"),
@@ -148,6 +217,8 @@ init(
 		}
 	}
 
+	sanitize_geometry(&xmount, sbp);
+
 	mp = libxfs_mount(&xmount, sbp, x.ddev, x.logdev, x.rtdev,
 			  LIBXFS_MOUNT_DEBUGGER);
 	if (!mp) {
diff --git a/repair/sb.c b/repair/sb.c
index 1b352e8..e108613 100644
--- a/repair/sb.c
+++ b/repair/sb.c
@@ -398,11 +398,8 @@ verify_sb(char *sb_buf, xfs_sb_t *sb, int is_primary_sb)
 	/* sanity check ag count, size fields against data size field */
 
 	if (sb->sb_dblocks == 0 ||
-		sb->sb_dblocks >
-			((__uint64_t)sb->sb_agcount * sb->sb_agblocks) ||
-		sb->sb_dblocks <
-			((__uint64_t)(sb->sb_agcount - 1) * sb->sb_agblocks
-			+ XFS_MIN_AG_BLOCKS))
+		sb->sb_dblocks > XFS_MAX_DBLOCKS(sb) ||
+		sb->sb_dblocks < XFS_MIN_DBLOCKS(sb))
 		return(XR_BAD_FS_SIZE_DATA);
 
 	if (sb->sb_agblklog != (__uint8_t)libxfs_log2_roundup(sb->sb_agblocks))
