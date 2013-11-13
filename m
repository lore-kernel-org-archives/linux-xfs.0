Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9E98E7FA9
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 00:41:29 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 24511AC004
	for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 22:41:29 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	qbXNt9AzSMhDAKlM for <xfs@oss.sgi.com>;
	Tue, 12 Nov 2013 22:41:27 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VgU8O-0005cA-Eq
	for xfs@oss.sgi.com; Wed, 13 Nov 2013 17:41:04 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VgU8O-0006jp-Dm
	for xfs@oss.sgi.com; Wed, 13 Nov 2013 17:41:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 31/36] db: enable metadump on CRC filesystems
Date: Wed, 13 Nov 2013 17:40:55 +1100
Message-Id: <1384324860-25677-32-git-send-email-david@fromorbit.com>
In-Reply-To: <1384324860-25677-1-git-send-email-david@fromorbit.com>
References: <1384324860-25677-1-git-send-email-david@fromorbit.com>
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
blocks it reads from the image file will already have all the
correct CRCs in them. Hence it can be mostly oblivious to the fact
that the filesystem it is restoring contains CRCs.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 db/metadump.c             | 24 +++++++++++++++++++-----
 mdrestore/xfs_mdrestore.c |  3 ---
 2 files changed, 19 insertions(+), 8 deletions(-)

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
