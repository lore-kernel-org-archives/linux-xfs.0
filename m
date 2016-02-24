Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C47A67CB9
	for <xfs@oss.sgi.com>; Wed, 24 Feb 2016 13:48:45 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9860A30406A
	for <xfs@oss.sgi.com>; Wed, 24 Feb 2016 11:48:39 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id c4MgH90lcmeUDIQi (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 24 Feb 2016 11:48:37 -0800 (PST)
From: mchristi@redhat.com
Subject: [PATCH 05/35] fs: have ll_rw_block users pass in op and flags
	separately
Date: Wed, 24 Feb 2016 13:47:42 -0600
Message-Id: <1456343292-14535-6-git-send-email-mchristi@redhat.com>
In-Reply-To: <1456343292-14535-1-git-send-email-mchristi@redhat.com>
References: <1456343292-14535-1-git-send-email-mchristi@redhat.com>
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
To: linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org, konrad.wilk@oracle.com, drbd-dev@lists.linbit.com, philipp.reisner@linbit.com, lars.ellenberg@linbit.com, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-mtd@lists.infradead.org, target-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, osd-dev@open-osd.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com
Cc: Mike Christie <mchristi@redhat.com>

From: Mike Christie <mchristi@redhat.com>

This has ll_rw_block users pass in the operation and flags separately,
so we can setup the bio->bi_op and bio-bi_rw flags.

v2:

1. Fix for kbuild error in ll_rw_block comments.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 fs/buffer.c                 | 19 ++++++++++---------
 fs/ext4/inode.c             |  6 +++---
 fs/ext4/namei.c             |  3 ++-
 fs/ext4/super.c             |  2 +-
 fs/gfs2/bmap.c              |  2 +-
 fs/gfs2/meta_io.c           |  4 ++--
 fs/gfs2/quota.c             |  2 +-
 fs/isofs/compress.c         |  2 +-
 fs/jbd2/journal.c           |  2 +-
 fs/jbd2/recovery.c          |  4 ++--
 fs/ocfs2/aops.c             |  2 +-
 fs/ocfs2/super.c            |  2 +-
 fs/reiserfs/journal.c       |  8 ++++----
 fs/reiserfs/stree.c         |  4 ++--
 fs/reiserfs/super.c         |  2 +-
 fs/squashfs/block.c         |  4 ++--
 fs/udf/dir.c                |  2 +-
 fs/udf/directory.c          |  2 +-
 fs/udf/inode.c              |  2 +-
 fs/ufs/balloc.c             |  2 +-
 include/linux/buffer_head.h |  2 +-
 21 files changed, 40 insertions(+), 38 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 3492de4..5408ca6 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -588,7 +588,7 @@ void write_boundary_block(struct block_device *bdev,
 	struct buffer_head *bh = __find_get_block(bdev, bblock + 1, blocksize);
 	if (bh) {
 		if (buffer_dirty(bh))
-			ll_rw_block(WRITE, 1, &bh);
+			ll_rw_block(REQ_OP_WRITE, 0, 1, &bh);
 		put_bh(bh);
 	}
 }
@@ -1395,7 +1395,7 @@ void __breadahead(struct block_device *bdev, sector_t block, unsigned size)
 {
 	struct buffer_head *bh = __getblk(bdev, block, size);
 	if (likely(bh)) {
-		ll_rw_block(READA, 1, &bh);
+		ll_rw_block(REQ_OP_READ, READA, 1, &bh);
 		brelse(bh);
 	}
 }
@@ -1955,7 +1955,7 @@ int __block_write_begin(struct page *page, loff_t pos, unsigned len,
 		if (!buffer_uptodate(bh) && !buffer_delay(bh) &&
 		    !buffer_unwritten(bh) &&
 		     (block_start < from || block_end > to)) {
-			ll_rw_block(READ, 1, &bh);
+			ll_rw_block(REQ_OP_READ, 0, 1, &bh);
 			*wait_bh++=bh;
 		}
 	}
@@ -2852,7 +2852,7 @@ int block_truncate_page(struct address_space *mapping,
 
 	if (!buffer_uptodate(bh) && !buffer_delay(bh) && !buffer_unwritten(bh)) {
 		err = -EIO;
-		ll_rw_block(READ, 1, &bh);
+		ll_rw_block(REQ_OP_READ, 0, 1, &bh);
 		wait_on_buffer(bh);
 		/* Uhhuh. Read error. Complain and punt. */
 		if (!buffer_uptodate(bh))
@@ -3052,7 +3052,8 @@ EXPORT_SYMBOL(submit_bh);
 
 /**
  * ll_rw_block: low-level access to block devices (DEPRECATED)
- * @rw: whether to %READ or %WRITE or maybe %READA (readahead)
+ * @op: whether to %READ or %WRITE
+ * @op_flags: rq_flag_bits or %READA (readahead)
  * @nr: number of &struct buffer_heads in the array
  * @bhs: array of pointers to &struct buffer_head
  *
@@ -3075,7 +3076,7 @@ EXPORT_SYMBOL(submit_bh);
  * All of the buffers must be for the same device, and must also be a
  * multiple of the current approved size for the device.
  */
-void ll_rw_block(int rw, int nr, struct buffer_head *bhs[])
+void ll_rw_block(int op, int op_flags,  int nr, struct buffer_head *bhs[])
 {
 	int i;
 
@@ -3084,18 +3085,18 @@ void ll_rw_block(int rw, int nr, struct buffer_head *bhs[])
 
 		if (!trylock_buffer(bh))
 			continue;
-		if (rw == WRITE) {
+		if (op == WRITE) {
 			if (test_clear_buffer_dirty(bh)) {
 				bh->b_end_io = end_buffer_write_sync;
 				get_bh(bh);
-				submit_bh(rw, 0, bh);
+				submit_bh(op, op_flags, bh);
 				continue;
 			}
 		} else {
 			if (!buffer_uptodate(bh)) {
 				bh->b_end_io = end_buffer_read_sync;
 				get_bh(bh);
-				submit_bh(rw, 0, bh);
+				submit_bh(op, op_flags, bh);
 				continue;
 			}
 		}
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 8a91e98..d916f2c 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -838,7 +838,7 @@ struct buffer_head *ext4_bread(handle_t *handle, struct inode *inode,
 		return bh;
 	if (!bh || buffer_uptodate(bh))
 		return bh;
-	ll_rw_block(READ | REQ_META | REQ_PRIO, 1, &bh);
+	ll_rw_block(REQ_OP_READ, REQ_META | REQ_PRIO, 1, &bh);
 	wait_on_buffer(bh);
 	if (buffer_uptodate(bh))
 		return bh;
@@ -992,7 +992,7 @@ static int ext4_block_write_begin(struct page *page, loff_t pos, unsigned len,
 		if (!buffer_uptodate(bh) && !buffer_delay(bh) &&
 		    !buffer_unwritten(bh) &&
 		    (block_start < from || block_end > to)) {
-			ll_rw_block(READ, 1, &bh);
+			ll_rw_block(REQ_OP_READ, 0, 1, &bh);
 			*wait_bh++ = bh;
 			decrypt = ext4_encrypted_inode(inode) &&
 				S_ISREG(inode->i_mode);
@@ -3541,7 +3541,7 @@ static int __ext4_block_zero_page_range(handle_t *handle,
 
 	if (!buffer_uptodate(bh)) {
 		err = -EIO;
-		ll_rw_block(READ, 1, &bh);
+		ll_rw_block(REQ_OP_READ, 0, 1, &bh);
 		wait_on_buffer(bh);
 		/* Uhhuh. Read error. Complain and punt. */
 		if (!buffer_uptodate(bh))
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 48e4b89..a03d2e6 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1438,7 +1438,8 @@ restart:
 				}
 				bh_use[ra_max] = bh;
 				if (bh)
-					ll_rw_block(READ | REQ_META | REQ_PRIO,
+					ll_rw_block(REQ_OP_READ,
+						    REQ_META | REQ_PRIO,
 						    1, &bh);
 			}
 		}
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 9951dfe..23b706c 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4201,7 +4201,7 @@ static journal_t *ext4_get_dev_journal(struct super_block *sb,
 		goto out_bdev;
 	}
 	journal->j_private = sb;
-	ll_rw_block(READ | REQ_META | REQ_PRIO, 1, &journal->j_sb_buffer);
+	ll_rw_block(REQ_OP_READ, REQ_META | REQ_PRIO, 1, &journal->j_sb_buffer);
 	wait_on_buffer(journal->j_sb_buffer);
 	if (!buffer_uptodate(journal->j_sb_buffer)) {
 		ext4_msg(sb, KERN_ERR, "I/O error on journal device");
diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 29faf72..628d4a4 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -974,7 +974,7 @@ static int gfs2_block_truncate_page(struct address_space *mapping, loff_t from)
 
 	if (!buffer_uptodate(bh)) {
 		err = -EIO;
-		ll_rw_block(READ, 1, &bh);
+		ll_rw_block(REQ_OP_READ, 0, 1, &bh);
 		wait_on_buffer(bh);
 		/* Uhhuh. Read error. Complain and punt. */
 		if (!buffer_uptodate(bh))
diff --git a/fs/gfs2/meta_io.c b/fs/gfs2/meta_io.c
index dc1c9db..96c8140 100644
--- a/fs/gfs2/meta_io.c
+++ b/fs/gfs2/meta_io.c
@@ -448,7 +448,7 @@ struct buffer_head *gfs2_meta_ra(struct gfs2_glock *gl, u64 dblock, u32 extlen)
 	if (buffer_uptodate(first_bh))
 		goto out;
 	if (!buffer_locked(first_bh))
-		ll_rw_block(READ_SYNC | REQ_META, 1, &first_bh);
+		ll_rw_block(REQ_OP_READ, READ_SYNC | REQ_META, 1, &first_bh);
 
 	dblock++;
 	extlen--;
@@ -457,7 +457,7 @@ struct buffer_head *gfs2_meta_ra(struct gfs2_glock *gl, u64 dblock, u32 extlen)
 		bh = gfs2_getbuf(gl, dblock, CREATE);
 
 		if (!buffer_uptodate(bh) && !buffer_locked(bh))
-			ll_rw_block(READA | REQ_META, 1, &bh);
+			ll_rw_block(REQ_OP_READ, READA | REQ_META, 1, &bh);
 		brelse(bh);
 		dblock++;
 		extlen--;
diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index a398913..6ab01a6 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -730,7 +730,7 @@ static int gfs2_write_buf_to_page(struct gfs2_inode *ip, unsigned long index,
 		if (PageUptodate(page))
 			set_buffer_uptodate(bh);
 		if (!buffer_uptodate(bh)) {
-			ll_rw_block(READ | REQ_META, 1, &bh);
+			ll_rw_block(REQ_OP_READ, REQ_META, 1, &bh);
 			wait_on_buffer(bh);
 			if (!buffer_uptodate(bh))
 				goto unlock_out;
diff --git a/fs/isofs/compress.c b/fs/isofs/compress.c
index f311bf0..f9b5fc8 100644
--- a/fs/isofs/compress.c
+++ b/fs/isofs/compress.c
@@ -81,7 +81,7 @@ static loff_t zisofs_uncompress_block(struct inode *inode, loff_t block_start,
 	blocknum = block_start >> bufshift;
 	memset(bhs, 0, (needblocks + 1) * sizeof(struct buffer_head *));
 	haveblocks = isofs_get_blocks(inode, blocknum, bhs, needblocks);
-	ll_rw_block(READ, haveblocks, bhs);
+	ll_rw_block(REQ_OP_READ, 0, haveblocks, bhs);
 
 	curbh = 0;
 	curpage = 0;
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index a3e1776..8855f6b 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1496,7 +1496,7 @@ static int journal_get_superblock(journal_t *journal)
 
 	J_ASSERT(bh != NULL);
 	if (!buffer_uptodate(bh)) {
-		ll_rw_block(READ, 1, &bh);
+		ll_rw_block(REQ_OP_READ, 0, 1, &bh);
 		wait_on_buffer(bh);
 		if (!buffer_uptodate(bh)) {
 			printk(KERN_ERR
diff --git a/fs/jbd2/recovery.c b/fs/jbd2/recovery.c
index 08a456b..6daf0c9 100644
--- a/fs/jbd2/recovery.c
+++ b/fs/jbd2/recovery.c
@@ -104,7 +104,7 @@ static int do_readahead(journal_t *journal, unsigned int start)
 		if (!buffer_uptodate(bh) && !buffer_locked(bh)) {
 			bufs[nbufs++] = bh;
 			if (nbufs == MAXBUF) {
-				ll_rw_block(READ, nbufs, bufs);
+				ll_rw_block(REQ_OP_READ, 0, nbufs, bufs);
 				journal_brelse_array(bufs, nbufs);
 				nbufs = 0;
 			}
@@ -113,7 +113,7 @@ static int do_readahead(journal_t *journal, unsigned int start)
 	}
 
 	if (nbufs)
-		ll_rw_block(READ, nbufs, bufs);
+		ll_rw_block(REQ_OP_READ, 0, nbufs, bufs);
 	err = 0;
 
 failed:
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 56ce370..3497947 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -640,7 +640,7 @@ int ocfs2_map_page_blocks(struct page *page, u64 *p_blkno,
 			   !buffer_new(bh) &&
 			   ocfs2_should_read_blk(inode, page, block_start) &&
 			   (block_start < from || block_end > to)) {
-			ll_rw_block(READ, 1, &bh);
+			ll_rw_block(REQ_OP_READ, 0, 1, &bh);
 			*wait_bh++=bh;
 		}
 
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 7db631e..2bbf6b2 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1819,7 +1819,7 @@ static int ocfs2_get_sector(struct super_block *sb,
 	if (!buffer_dirty(*bh))
 		clear_buffer_uptodate(*bh);
 	unlock_buffer(*bh);
-	ll_rw_block(READ, 1, bh);
+	ll_rw_block(REQ_OP_READ, 0, 1, bh);
 	wait_on_buffer(*bh);
 	if (!buffer_uptodate(*bh)) {
 		mlog_errno(-EIO);
diff --git a/fs/reiserfs/journal.c b/fs/reiserfs/journal.c
index 688dce9..09682cc 100644
--- a/fs/reiserfs/journal.c
+++ b/fs/reiserfs/journal.c
@@ -870,7 +870,7 @@ loop_next:
 		 */
 		if (buffer_dirty(bh) && unlikely(bh->b_page->mapping == NULL)) {
 			spin_unlock(lock);
-			ll_rw_block(WRITE, 1, &bh);
+			ll_rw_block(REQ_OP_WRITE, 0, 1, &bh);
 			spin_lock(lock);
 		}
 		put_bh(bh);
@@ -1057,7 +1057,7 @@ static int flush_commit_list(struct super_block *s,
 		if (tbh) {
 			if (buffer_dirty(tbh)) {
 		            depth = reiserfs_write_unlock_nested(s);
-			    ll_rw_block(WRITE, 1, &tbh);
+			    ll_rw_block(REQ_OP_WRITE, 0, 1, &tbh);
 			    reiserfs_write_lock_nested(s, depth);
 			}
 			put_bh(tbh) ;
@@ -2244,7 +2244,7 @@ abort_replay:
 		}
 	}
 	/* read in the log blocks, memcpy to the corresponding real block */
-	ll_rw_block(READ, get_desc_trans_len(desc), log_blocks);
+	ll_rw_block(REQ_OP_READ, 0, get_desc_trans_len(desc), log_blocks);
 	for (i = 0; i < get_desc_trans_len(desc); i++) {
 
 		wait_on_buffer(log_blocks[i]);
@@ -2346,7 +2346,7 @@ static struct buffer_head *reiserfs_breada(struct block_device *dev,
 		} else
 			bhlist[j++] = bh;
 	}
-	ll_rw_block(READ, j, bhlist);
+	ll_rw_block(REQ_OP_READ, 0, j, bhlist);
 	for (i = 1; i < j; i++)
 		brelse(bhlist[i]);
 	bh = bhlist[0];
diff --git a/fs/reiserfs/stree.c b/fs/reiserfs/stree.c
index 24cbe01..5f9b6df 100644
--- a/fs/reiserfs/stree.c
+++ b/fs/reiserfs/stree.c
@@ -551,7 +551,7 @@ static int search_by_key_reada(struct super_block *s,
 		if (!buffer_uptodate(bh[j])) {
 			if (depth == -1)
 				depth = reiserfs_write_unlock_nested(s);
-			ll_rw_block(READA, 1, bh + j);
+			ll_rw_block(REQ_OP_READ, READA, 1, bh + j);
 		}
 		brelse(bh[j]);
 	}
@@ -660,7 +660,7 @@ int search_by_key(struct super_block *sb, const struct cpu_key *key,
 			if (!buffer_uptodate(bh) && depth == -1)
 				depth = reiserfs_write_unlock_nested(sb);
 
-			ll_rw_block(READ, 1, &bh);
+			ll_rw_block(REQ_OP_READ, 0, 1, &bh);
 			wait_on_buffer(bh);
 
 			if (depth != -1)
diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index b8f2d1e..9938a51 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -1661,7 +1661,7 @@ static int read_super_block(struct super_block *s, int offset)
 /* after journal replay, reread all bitmap and super blocks */
 static int reread_meta_blocks(struct super_block *s)
 {
-	ll_rw_block(READ, 1, &SB_BUFFER_WITH_SB(s));
+	ll_rw_block(REQ_OP_READ, 0, 1, &SB_BUFFER_WITH_SB(s));
 	wait_on_buffer(SB_BUFFER_WITH_SB(s));
 	if (!buffer_uptodate(SB_BUFFER_WITH_SB(s))) {
 		reiserfs_warning(s, "reiserfs-2504", "error reading the super");
diff --git a/fs/squashfs/block.c b/fs/squashfs/block.c
index 0cea9b9..59375be 100644
--- a/fs/squashfs/block.c
+++ b/fs/squashfs/block.c
@@ -124,7 +124,7 @@ int squashfs_read_data(struct super_block *sb, u64 index, int length,
 				goto block_release;
 			bytes += msblk->devblksize;
 		}
-		ll_rw_block(READ, b, bh);
+		ll_rw_block(REQ_OP_READ, 0, b, bh);
 	} else {
 		/*
 		 * Metadata block.
@@ -156,7 +156,7 @@ int squashfs_read_data(struct super_block *sb, u64 index, int length,
 				goto block_release;
 			bytes += msblk->devblksize;
 		}
-		ll_rw_block(READ, b - 1, bh + 1);
+		ll_rw_block(REQ_OP_READ, 0, b - 1, bh + 1);
 	}
 
 	for (i = 0; i < b; i++) {
diff --git a/fs/udf/dir.c b/fs/udf/dir.c
index b51b371..cfadce0 100644
--- a/fs/udf/dir.c
+++ b/fs/udf/dir.c
@@ -113,7 +113,7 @@ static int udf_readdir(struct file *file, struct dir_context *ctx)
 					brelse(tmp);
 			}
 			if (num) {
-				ll_rw_block(READA, num, bha);
+				ll_rw_block(REQ_OP_READ, READA, num, bha);
 				for (i = 0; i < num; i++)
 					brelse(bha[i]);
 			}
diff --git a/fs/udf/directory.c b/fs/udf/directory.c
index c763fda..71f3e0b 100644
--- a/fs/udf/directory.c
+++ b/fs/udf/directory.c
@@ -87,7 +87,7 @@ struct fileIdentDesc *udf_fileident_read(struct inode *dir, loff_t *nf_pos,
 					brelse(tmp);
 			}
 			if (num) {
-				ll_rw_block(READA, num, bha);
+				ll_rw_block(REQ_OP_READ, READA, num, bha);
 				for (i = 0; i < num; i++)
 					brelse(bha[i]);
 			}
diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 166d3ed..757e63b 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -1200,7 +1200,7 @@ struct buffer_head *udf_bread(struct inode *inode, int block,
 	if (buffer_uptodate(bh))
 		return bh;
 
-	ll_rw_block(READ, 1, &bh);
+	ll_rw_block(REQ_OP_READ, 0, 1, &bh);
 
 	wait_on_buffer(bh);
 	if (buffer_uptodate(bh))
diff --git a/fs/ufs/balloc.c b/fs/ufs/balloc.c
index dc5fae6..26a3bb1 100644
--- a/fs/ufs/balloc.c
+++ b/fs/ufs/balloc.c
@@ -292,7 +292,7 @@ static void ufs_change_blocknr(struct inode *inode, sector_t beg,
 			if (!buffer_mapped(bh))
 					map_bh(bh, inode->i_sb, oldb + pos);
 			if (!buffer_uptodate(bh)) {
-				ll_rw_block(READ, 1, &bh);
+				ll_rw_block(REQ_OP_READ, 0, 1, &bh);
 				wait_on_buffer(bh);
 				if (!buffer_uptodate(bh)) {
 					ufs_error(inode->i_sb, __func__,
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index 72ad52d..9ab27bb 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -187,7 +187,7 @@ struct buffer_head *alloc_buffer_head(gfp_t gfp_flags);
 void free_buffer_head(struct buffer_head * bh);
 void unlock_buffer(struct buffer_head *bh);
 void __lock_buffer(struct buffer_head *bh);
-void ll_rw_block(int, int, struct buffer_head * bh[]);
+void ll_rw_block(int, int, int, struct buffer_head * bh[]);
 int sync_dirty_buffer(struct buffer_head *bh);
 int __sync_dirty_buffer(struct buffer_head *bh, int op_flags);
 void write_dirty_buffer(struct buffer_head *bh, int op_flags);
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
