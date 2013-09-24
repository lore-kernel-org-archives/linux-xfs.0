Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0E3C47CBF
	for <xfs@oss.sgi.com>; Tue, 24 Sep 2013 01:01:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 90BD2AC006
	for <xfs@oss.sgi.com>; Mon, 23 Sep 2013 23:01:54 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	SuTMX4x5xi5pQCY1 for <xfs@oss.sgi.com>;
	Mon, 23 Sep 2013 23:01:52 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VOLgV-0007K8-0W
	for xfs@oss.sgi.com; Tue, 24 Sep 2013 16:01:19 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VOLgU-0004ut-Vg
	for xfs@oss.sgi.com; Tue, 24 Sep 2013 16:01:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5/5] xfs: log recovery lsn ordering needs uuid check
Date: Tue, 24 Sep 2013 16:01:16 +1000
Message-Id: <1380002476-18839-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1380002476-18839-1-git-send-email-david@fromorbit.com>
References: <1380002476-18839-1-git-send-email-david@fromorbit.com>
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

After a fair number of xfstests runs, xfs/182 started to fail
regularly with a corrupted directory - a directory read verifier was
failing after recovery because it found a block with a XARM magic
number (remote attribute block) rather than a directory data block.

The first time I saw this repeated failure I did /something/ and the
problem went away, so I was never able to find the underlying
problem. Test xfs/182 failed again today, and I found the root
cause before I did /something else/ that made it go away.

Tracing indicated that the block in question was being correctly
logged, the log was being flushed by sync, but the buffer was not
being written back before the shutdown occurred. Tracing also
indicated that log recovery was also reading the block, but then
never writing it before log recovery invalidated the cache,
indicating that it was not modified by log recovery.

More detailed analysis of the corpse indicated that the filesystem
had a uuid of "a4131074-1872-4cac-9323-2229adbcb886" but the XARM
block had a uuid of "8f32f043-c3c9-e7f8-f947-4e7f989c05d3", which
indicated it was a block from an older filesystem. The reason that
log recovery didn't replay it was that the LSN in the XARM block was
larger than the LSN of the transaction being replayed, and so the
block was not overwritten by log recovery.

Hence, log recovery cant blindly trust the magic number and LSN in
the block - it must verify that it belongs to the filesystem being
recovered before using the LSN. i.e. if the UUIDs don't match, we
need to unconditionally recovery the change held in the log.

This patch was first tested on a block device that was repeatedly
causing xfs/182 to fail with the same failure on the same block with
the same directory read corruption signature (i.e. XARM block). It
did not fail, and hasn't failed since.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log_recover.c | 73 ++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 59 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index dabda95..cc17987 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1970,6 +1970,13 @@ xlog_recover_do_inode_buffer(
  * magic number.  If we don't recognise the magic number in the buffer, then
  * return a LSN of -1 so that the caller knows it was an unrecognised block and
  * so can recover the buffer.
+ *
+ * Note: we cannot rely solely on magic number matches to determine that the
+ * buffer has a valid LSN - we also need to verify that it belongs to this
+ * filesystem, so we need to extract the object's LSN and compare it to that
+ * which we read from the superblock. If the UUIDs don't match, then we've got a
+ * stale metadata block from an old filesystem instance that we need to recover
+ * over the top of.
  */
 static xfs_lsn_t
 xlog_recover_get_buf_lsn(
@@ -1980,6 +1987,8 @@ xlog_recover_get_buf_lsn(
 	__uint16_t		magic16;
 	__uint16_t		magicda;
 	void			*blk = bp->b_addr;
+	uuid_t			*uuid;
+	xfs_lsn_t		lsn = -1;
 
 	/* v4 filesystems always recover immediately */
 	if (!xfs_sb_version_hascrc(&mp->m_sb))
@@ -1992,43 +2001,79 @@ xlog_recover_get_buf_lsn(
 	case XFS_ABTB_MAGIC:
 	case XFS_ABTC_MAGIC:
 	case XFS_IBT_CRC_MAGIC:
-	case XFS_IBT_MAGIC:
-		return be64_to_cpu(
-				((struct xfs_btree_block *)blk)->bb_u.s.bb_lsn);
+	case XFS_IBT_MAGIC: {
+		struct xfs_btree_block *btb = blk;
+
+		lsn = be64_to_cpu(btb->bb_u.s.bb_lsn);
+		uuid = &btb->bb_u.s.bb_uuid;
+		break;
+	}
 	case XFS_BMAP_CRC_MAGIC:
-	case XFS_BMAP_MAGIC:
-		return be64_to_cpu(
-				((struct xfs_btree_block *)blk)->bb_u.l.bb_lsn);
+	case XFS_BMAP_MAGIC: {
+		struct xfs_btree_block *btb = blk;
+
+		lsn = be64_to_cpu(btb->bb_u.l.bb_lsn);
+		uuid = &btb->bb_u.l.bb_uuid;
+		break;
+	}
 	case XFS_AGF_MAGIC:
-		return be64_to_cpu(((struct xfs_agf *)blk)->agf_lsn);
+		lsn = be64_to_cpu(((struct xfs_agf *)blk)->agf_lsn);
+		uuid = &((struct xfs_agf *)blk)->agf_uuid;
+		break;
 	case XFS_AGFL_MAGIC:
-		return be64_to_cpu(((struct xfs_agfl *)blk)->agfl_lsn);
+		lsn = be64_to_cpu(((struct xfs_agfl *)blk)->agfl_lsn);
+		uuid = &((struct xfs_agfl *)blk)->agfl_uuid;
+		break;
 	case XFS_AGI_MAGIC:
-		return be64_to_cpu(((struct xfs_agi *)blk)->agi_lsn);
+		lsn = be64_to_cpu(((struct xfs_agi *)blk)->agi_lsn);
+		uuid = &((struct xfs_agi *)blk)->agi_uuid;
+		break;
 	case XFS_SYMLINK_MAGIC:
-		return be64_to_cpu(((struct xfs_dsymlink_hdr *)blk)->sl_lsn);
+		lsn = be64_to_cpu(((struct xfs_dsymlink_hdr *)blk)->sl_lsn);
+		uuid = &((struct xfs_dsymlink_hdr *)blk)->sl_uuid;
+		break;
 	case XFS_DIR3_BLOCK_MAGIC:
 	case XFS_DIR3_DATA_MAGIC:
 	case XFS_DIR3_FREE_MAGIC:
-		return be64_to_cpu(((struct xfs_dir3_blk_hdr *)blk)->lsn);
+		lsn = be64_to_cpu(((struct xfs_dir3_blk_hdr *)blk)->lsn);
+		uuid = &((struct xfs_dir3_blk_hdr *)blk)->uuid;
+		break;
 	case XFS_ATTR3_RMT_MAGIC:
-		return be64_to_cpu(((struct xfs_attr3_rmt_hdr *)blk)->rm_lsn);
+		lsn = be64_to_cpu(((struct xfs_attr3_rmt_hdr *)blk)->rm_lsn);
+		uuid = &((struct xfs_attr3_rmt_hdr *)blk)->rm_uuid;
+		break;
 	case XFS_SB_MAGIC:
-		return be64_to_cpu(((struct xfs_dsb *)blk)->sb_lsn);
+		lsn = be64_to_cpu(((struct xfs_dsb *)blk)->sb_lsn);
+		uuid = &((struct xfs_dsb *)blk)->sb_uuid;
+		break;
 	default:
 		break;
 	}
 
+	if (lsn != (xfs_lsn_t)-1) {
+		if (!uuid_equal(&mp->m_sb.sb_uuid, uuid))
+			goto recover_immediately;
+		return lsn;
+	}
+
 	magicda = be16_to_cpu(((struct xfs_da_blkinfo *)blk)->magic);
 	switch (magicda) {
 	case XFS_DIR3_LEAF1_MAGIC:
 	case XFS_DIR3_LEAFN_MAGIC:
 	case XFS_DA3_NODE_MAGIC:
-		return be64_to_cpu(((struct xfs_da3_blkinfo *)blk)->lsn);
+		lsn = be64_to_cpu(((struct xfs_da3_blkinfo *)blk)->lsn);
+		uuid = &((struct xfs_da3_blkinfo *)blk)->uuid;
+		break;
 	default:
 		break;
 	}
 
+	if (lsn != (xfs_lsn_t)-1) {
+		if (!uuid_equal(&mp->m_sb.sb_uuid, uuid))
+			goto recover_immediately;
+		return lsn;
+	}
+
 	/*
 	 * We do individual object checks on dquot and inode buffers as they
 	 * have their own individual LSN records. Also, we could have a stale
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
