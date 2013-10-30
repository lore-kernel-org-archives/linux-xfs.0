Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0F3B87F5A
	for <xfs@oss.sgi.com>; Tue, 29 Oct 2013 23:31:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E8A278F8059
	for <xfs@oss.sgi.com>; Tue, 29 Oct 2013 21:31:34 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	GvIcM9QRLUedwSH4 for <xfs@oss.sgi.com>;
	Tue, 29 Oct 2013 21:31:33 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VbNRG-0002z6-2N
	for xfs@oss.sgi.com; Wed, 30 Oct 2013 15:31:26 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VbNRG-0007fd-16
	for xfs@oss.sgi.com; Wed, 30 Oct 2013 15:31:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 28/30] db: enable metadump on CRC filesystems
Date: Wed, 30 Oct 2013 15:31:19 +1100
Message-Id: <1383107481-28937-29-git-send-email-david@fromorbit.com>
In-Reply-To: <1383107481-28937-1-git-send-email-david@fromorbit.com>
References: <1383107481-28937-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Now that we can calculate CRCs through xfs_db, we can add support
for recalculating CRCs on obfuscated metadump images. This simply
requires us to call the write verifier manually before writing the
buffer to the metadump image.

We don't need to do anything special to mdrestore, as the metadata
blocks it reads from the image file should already have all the
correct CRCs in them. hence it can be mostly oblivious to the fact
that the filesystem it is resotring contains CRCs.

While there, add IO stack unwinding to xfs_db to prevent metadump
and other db programs from exiting with unreleased buffers in the IO
stack and hence emitting warnings like:

cache_purge: shake on cache 0x69e4f0 left 7 nodes!?

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 db/init.c                 |  5 ++++-
 db/metadump.c             | 24 +++++++++++++++++++-----
 mdrestore/xfs_mdrestore.c |  3 ---
 3 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/db/init.c b/db/init.c
index 2b643f9..dc915fb 100644
--- a/db/init.c
+++ b/db/init.c
@@ -173,9 +173,11 @@ main(
 	int	c, i, done = 0;
 	char	*input;
 	char	**v;
+	int	start_iocur_sp;
 
 	pushfile(stdin);
 	init(argc, argv);
+	start_iocur_sp = iocur_sp;
 
 	for (i = 0; !done && i < ncmdline; i++) {
 		v = breakline(cmdline[i], &c);
@@ -202,7 +204,8 @@ close_devices:
 	 * make sure that we pop the last buffer context we held so that the
 	 * buffer is released before purge the caches during unmount.
 	 */
-	pop_cur();
+	while (iocur_sp > start_iocur_sp)
+		pop_cur();
 	libxfs_umount(mp);
 	if (x.ddev)
 		libxfs_device_close(x.ddev);
diff --git a/db/metadump.c b/db/metadump.c
index ac6a4d6..117dc42 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -172,6 +172,22 @@ write_buf(
 	__int64_t	off;
 	int		i;
 
+	/*
+	 * Run the write verifier to recalculate the buffer CRCs and check
+	 * we are writing something valid to disk
+	 */
+	if (buf->bp && buf->bp->b_ops) {
+		buf->bp->b_error = 0;
+		buf->bp->b_ops->verify_write(buf->bp);
+		if (buf->bp->b_error) {
+			fprintf(stderr,
+	_("%s: write verifer failed on bno 0x%llx/0x%x\n"),
+				__func__, (long long)buf->bp->b_bn,
+				buf->bp->b_bcount);
+			return buf->bp->b_error;
+		}
+	}
+
 	for (i = 0, off = buf->bb, data = buf->data;
 			i < buf->blen;
 			i++, off++, data += BBSIZE) {
@@ -1727,6 +1743,9 @@ copy_inode_chunk(
 
 		if (!process_inode(agno, agino + i, dip))
 			goto pop_out;
+
+		/* calculate the new CRC for the inode */
+		xfs_dinode_calc_crc(mp, dip);
 	}
 skip_processing:
 	if (!write_buf(iocur_top))
@@ -2053,11 +2072,6 @@ metadump_f(
 		return 0;
 	}
 
-	if (xfs_sb_version_hascrc(&mp->m_sb) && dont_obfuscate == 0) {
-		print_warning("Can't obfuscate CRC enabled filesystems yet.");
-		return 0;
-	}
-
 	metablock = (xfs_metablock_t *)calloc(BBSIZE + 1, BBSIZE);
 	if (metablock == NULL) {
 		print_warning("memory allocation failure");
diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index fe61766..e57bdb2 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -109,9 +109,6 @@ perform_restore(
 	if (sb.sb_magicnum != XFS_SB_MAGIC)
 		fatal("bad magic number for primary superblock\n");
 
-	if (xfs_sb_version_hascrc(&sb))
-		fatal("Can't restore CRC enabled filesystems yet.\n");
-
 	((xfs_dsb_t*)block_buffer)->sb_inprogress = 1;
 
 	if (is_target_file)  {
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
