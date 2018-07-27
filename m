Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:37604 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730636AbeG0X4U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 Jul 2018 19:56:20 -0400
Subject: [PATCH ] misc: clean up MIN/MAX in the utilities
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 27 Jul 2018 15:32:14 -0700
Message-ID: <153273073460.1594.8379497525888711422.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Get rid of the MIN/MAX macros and just use the native min/max macros
directly in the XFS code, just like we did for libxfs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 copy/xfs_copy.c      |   10 +++++-----
 db/check.c           |    4 ++--
 libxfs/rdwr.c        |    8 ++++----
 logprint/log_misc.c  |   12 ++++++------
 logprint/log_redo.c  |    8 ++++----
 man/man5/xfs.5       |    2 +-
 mkfs/xfs_mkfs.c      |   18 +++++++++---------
 quota/util.c         |    2 +-
 repair/attr_repair.c |    2 +-
 repair/bmap.c        |    2 +-
 repair/btree.c       |    4 ++--
 repair/dinode.c      |    6 +++---
 repair/incore.c      |    4 ++--
 repair/incore_ino.c  |    2 +-
 repair/prefetch.c    |    2 +-
 repair/xfs_repair.c  |    6 +++---
 16 files changed, 46 insertions(+), 46 deletions(-)


diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index 29618aec..a7b46566 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -665,7 +665,7 @@ main(int argc, char **argv)
 		}
 
 		wbuf_align = d.d_mem;
-		wbuf_size = MIN(d.d_maxiosz, 1 * 1024 * 1024);
+		wbuf_size = min(d.d_maxiosz, 1 * 1024 * 1024);
 		wbuf_miniosize = d.d_miniosz;
 	} else  {
 		/* set arbitrary I/O params, miniosize at least 1 disk block */
@@ -848,9 +848,9 @@ main(int argc, char **argv)
 						progname, target[i].name);
 					die_perror();
 				} else {
-					wbuf_align = MAX(wbuf_align, d.d_mem);
-					wbuf_size = MIN(d.d_maxiosz, wbuf_size);
-					wbuf_miniosize = MAX(d.d_miniosz,
+					wbuf_align = max(wbuf_align, d.d_mem);
+					wbuf_size = min(d.d_maxiosz, wbuf_size);
+					wbuf_miniosize = max(d.d_miniosz,
 								wbuf_miniosize);
 				}
 			}
@@ -888,7 +888,7 @@ main(int argc, char **argv)
 
 	wblocks = wbuf_size / BBSIZE;
 
-	if (wbuf_init(&btree_buf, MAX(source_blocksize, wbuf_miniosize),
+	if (wbuf_init(&btree_buf, max(source_blocksize, wbuf_miniosize),
 				wbuf_align, wbuf_miniosize, 1) == NULL)  {
 		do_log(_("Error initializing btree buf 1\n"));
 		die_perror();
diff --git a/db/check.c b/db/check.c
index 76c28d49..e85afb9e 100644
--- a/db/check.c
+++ b/db/check.c
@@ -1853,7 +1853,7 @@ init(
 	inomap = xmalloc((mp->m_sb.sb_agcount + rt) * sizeof(*inomap));
 	inodata = xmalloc(mp->m_sb.sb_agcount * sizeof(*inodata));
 	inodata_hash_size =
-		(int)MAX(MIN(mp->m_sb.sb_icount /
+		(int)max(min(mp->m_sb.sb_icount /
 				(INODATA_AVG_HASH_LENGTH * mp->m_sb.sb_agcount),
 			     MAX_INODATA_HASH_SIZE),
 			 MIN_INODATA_HASH_SIZE);
@@ -4581,7 +4581,7 @@ scanfunc_fino(
 					goto next_buf;
 
                                 check_set_dbmap(seqno, agbno,
-                                        (xfs_extlen_t)MAX(1,
+                                        (xfs_extlen_t)max(1,
                                                 inodes_per_buf >>
                                                 mp->m_sb.sb_inopblog),
                                         DBM_INODE, DBM_INODE, seqno, bno);
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index f50876b0..14a4633e 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -181,7 +181,7 @@ libxfs_log_clear(
 	 * previous cycle.
 	 */
 	len = ((version == 2) && sunit) ? BTOBB(sunit) : 2;
-	len = MAX(len, 2);
+	len = max(len, 2);
 	lsn = xlog_assign_lsn(cycle, 0);
 	if (cycle == XLOG_INIT_CYCLE)
 		tail_lsn = lsn;
@@ -295,7 +295,7 @@ libxfs_log_header(
 	head->h_prev_block = cpu_to_be32(-1);
 	head->h_num_logops = cpu_to_be32(1);
 	head->h_fmt = cpu_to_be32(fmt);
-	head->h_size = cpu_to_be32(MAX(sunit, XLOG_BIG_RECORD_BSIZE));
+	head->h_size = cpu_to_be32(max(sunit, XLOG_BIG_RECORD_BSIZE));
 
 	head->h_lsn = cpu_to_be64(lsn);
 	head->h_tail_lsn = cpu_to_be64(tail_lsn);
@@ -346,7 +346,7 @@ libxfs_log_header(
 	 * minimum (1 hdr blk + 1 data blk). The record length is the total
 	 * minus however many header blocks are required.
 	 */
-	head->h_len = cpu_to_be32(MAX(BBTOB(2), sunit) - hdrs * BBSIZE);
+	head->h_len = cpu_to_be32(max(BBTOB(2), sunit) - hdrs * BBSIZE);
 
 	/*
 	 * Write out the unmount record, pack the first word into the record
@@ -363,7 +363,7 @@ libxfs_log_header(
 	 * the cycle. We don't need to pack any of these blocks because the
 	 * cycle data in the headers has already been zeroed.
 	 */
-	len = MAX(len, hdrs + 1);
+	len = max(len, hdrs + 1);
 	for (i = hdrs + 1; i < len; i++) {
 		p = nextfunc(p, BBSIZE, private);
 		memset(p, 0, BBSIZE);
diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index 92c50095..640c00ef 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -199,7 +199,7 @@ xlog_print_trans_buffer(char **ptr, int len, int *i, int num_ops)
      * memmove to ensure 8-byte alignment for the long longs in
      * buf_log_format_t structure
      */
-    memmove(&lbuf, *ptr, MIN(sizeof(xfs_buf_log_format_t), len));
+    memmove(&lbuf, *ptr, min(sizeof(xfs_buf_log_format_t), len));
     f = &lbuf;
     *ptr += len;
 
@@ -422,7 +422,7 @@ xlog_print_trans_qoff(char **ptr, uint len)
     xfs_qoff_logformat_t *f;
     xfs_qoff_logformat_t lbuf;
 
-    memmove(&lbuf, *ptr, MIN(sizeof(xfs_qoff_logformat_t), len));
+    memmove(&lbuf, *ptr, min(sizeof(xfs_qoff_logformat_t), len));
     f = &lbuf;
     *ptr += len;
     if (len >= sizeof(xfs_qoff_logformat_t)) {
@@ -523,7 +523,7 @@ xlog_print_trans_inode(
      * len can be smaller than struct xfs_inode_log_format
      * if format data is split over operations
      */
-    memmove(&src_lbuf, *ptr, MIN(sizeof(src_lbuf), len));
+    memmove(&src_lbuf, *ptr, min(sizeof(src_lbuf), len));
     (*i)++;					/* bump index */
     *ptr += len;
     if (!continued &&
@@ -662,7 +662,7 @@ xlog_print_trans_dquot(char **ptr, int len, int *i, int num_ops)
      * memmove to ensure 8-byte alignment for the long longs in
      * xfs_dq_logformat_t structure
      */
-    memmove(&lbuf, *ptr, MIN(sizeof(xfs_dq_logformat_t), len));
+    memmove(&lbuf, *ptr, min(sizeof(xfs_dq_logformat_t), len));
     f = &lbuf;
     (*i)++;					/* bump index */
     *ptr += len;
@@ -712,7 +712,7 @@ xlog_print_trans_icreate(
 	struct xfs_icreate_log	icl_buf = {0};
 	struct xfs_icreate_log	*icl;
 
-	memmove(&icl_buf, *ptr, MIN(sizeof(struct xfs_icreate_log), len));
+	memmove(&icl_buf, *ptr, min(sizeof(struct xfs_icreate_log), len));
 	icl = &icl_buf;
 	*ptr += len;
 
@@ -1061,7 +1061,7 @@ xlog_print_rec_head(xlog_rec_header_t *head, int *len, int bad_hdr_warn)
 
     if (print_overwrite) {
 	printf(_("cycle num overwrites: "));
-	for (i=0; i< MIN(bbs, XLOG_HEADER_CYCLE_SIZE / BBSIZE); i++)
+	for (i=0; i< min(bbs, XLOG_HEADER_CYCLE_SIZE / BBSIZE); i++)
 	    printf("%d - 0x%x  ",
 		    i,
 		    be32_to_cpu(head->h_cycle_data[i]));
diff --git a/logprint/log_redo.c b/logprint/log_redo.c
index d1952b02..f1f690ef 100644
--- a/logprint/log_redo.c
+++ b/logprint/log_redo.c
@@ -183,7 +183,7 @@ xlog_print_trans_efd(char **ptr, uint len)
 	 * memmove to ensure 8-byte alignment for the long longs in
 	 * xfs_efd_log_format_t structure
 	 */
-	memmove(&lbuf, *ptr, MIN(core_size, len));
+	memmove(&lbuf, *ptr, min(core_size, len));
 	f = &lbuf;
 	*ptr += len;
 	if (len >= core_size) {
@@ -340,7 +340,7 @@ xlog_print_trans_rud(
 	 * memmove to ensure 8-byte alignment for the long longs in
 	 * xfs_efd_log_format_t structure
 	 */
-	memmove(&lbuf, *ptr, MIN(core_size, len));
+	memmove(&lbuf, *ptr, min(core_size, len));
 	f = &lbuf;
 	*ptr += len;
 	if (len >= core_size) {
@@ -483,7 +483,7 @@ xlog_print_trans_cud(
 	/* size without extents at end */
 	uint core_size = sizeof(struct xfs_cud_log_format);
 
-	memcpy(&lbuf, *ptr, MIN(core_size, len));
+	memcpy(&lbuf, *ptr, min(core_size, len));
 	f = &lbuf;
 	*ptr += len;
 	if (len >= core_size) {
@@ -627,7 +627,7 @@ xlog_print_trans_bud(
 	/* size without extents at end */
 	uint core_size = sizeof(struct xfs_bud_log_format);
 
-	memcpy(&lbuf, *ptr, MIN(core_size, len));
+	memcpy(&lbuf, *ptr, min(core_size, len));
 	f = &lbuf;
 	*ptr += len;
 	if (len >= core_size) {
diff --git a/man/man5/xfs.5 b/man/man5/xfs.5
index 745dad4b..faaad900 100644
--- a/man/man5/xfs.5
+++ b/man/man5/xfs.5
@@ -233,7 +233,7 @@ logbsize must be an integer multiple of the log
 stripe unit configured at mkfs time.
 .sp
 The default value for version 1 logs is 32768, while the
-default value for version 2 logs is MAX(32768, log_sunit).
+default value for version 2 logs is max(32768, log_sunit).
 .TP
 .BR logdev=device " and " rtdev=device
 Use an external log (metadata journal) and/or real-time device.
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index d2655535..1074886a 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2097,7 +2097,7 @@ validate_inodesize(
 		int	maxsz;
 
 		fprintf(stderr, _("illegal inode size %d\n"), cfg->inodesize);
-		maxsz = MIN(cfg->blocksize / XFS_MIN_INODE_PERBLOCK,
+		maxsz = min(cfg->blocksize / XFS_MIN_INODE_PERBLOCK,
 			    XFS_DINODE_MAX_SIZE);
 		if (XFS_DINODE_MIN_SIZE == maxsz)
 			fprintf(stderr,
@@ -2406,10 +2406,10 @@ open_devices(
 	 * So, we reduce the size (in basic blocks) to a perfect
 	 * multiple of the sector size, or 1024, whichever is larger.
 	 */
-	sector_mask = (uint64_t)-1 << (MAX(cfg->sectorlog, 10) - BBSHIFT);
+	sector_mask = (uint64_t)-1 << (max(cfg->sectorlog, 10) - BBSHIFT);
 	xi->dsize &= sector_mask;
 	xi->rtsize &= sector_mask;
-	xi->logBBsize &= (uint64_t)-1 << (MAX(cfg->lsectorlog, 10) - BBSHIFT);
+	xi->logBBsize &= (uint64_t)-1 << (max(cfg->lsectorlog, 10) - BBSHIFT);
 
 
 	if (!discard)
@@ -2993,12 +2993,12 @@ calculate_log_size(
 	libxfs_umount(&mount);
 
 	ASSERT(min_logblocks);
-	min_logblocks = MAX(XFS_MIN_LOG_BLOCKS, min_logblocks);
+	min_logblocks = max(XFS_MIN_LOG_BLOCKS, min_logblocks);
 
 	/* if we have lots of blocks, check against XFS_MIN_LOG_BYTES, too */
 	if (!cli->logsize &&
 	    cfg->dblocks >= (1024*1024*1024) >> cfg->blocklog)
-		min_logblocks = MAX(min_logblocks,
+		min_logblocks = max(min_logblocks,
 				    XFS_MIN_LOG_BYTES >> cfg->blocklog);
 
 	/*
@@ -3034,7 +3034,7 @@ _("external log device %lld too small, must be at least %lld blocks\n"),
 			 * XFS_MIN_LOG_BYTES for filesystems smaller than 16G if
 			 * at all possible, ramping up to 128MB at 256GB.
 			 */
-			cfg->logblocks = MIN(XFS_MIN_LOG_BYTES >> cfg->blocklog,
+			cfg->logblocks = min(XFS_MIN_LOG_BYTES >> cfg->blocklog,
 					min_logblocks * XFS_DFL_LOG_FACTOR);
 		} else {
 			/*
@@ -3048,7 +3048,7 @@ _("external log device %lld too small, must be at least %lld blocks\n"),
 		}
 
 		/* Ensure the chosen size meets minimum log size requirements */
-		cfg->logblocks = MAX(min_logblocks, cfg->logblocks);
+		cfg->logblocks = max(min_logblocks, cfg->logblocks);
 
 		/*
 		 * Make sure the log fits wholly within an AG
@@ -3060,11 +3060,11 @@ _("external log device %lld too small, must be at least %lld blocks\n"),
 		 * opened to decide what is the valid maximum size of a log in
 		 * an AG.
 		 */
-		cfg->logblocks = MIN(cfg->logblocks,
+		cfg->logblocks = min(cfg->logblocks,
 				     libxfs_alloc_ag_max_usable(mp) - 1);
 
 		/* and now clamp the size to the maximum supported size */
-		cfg->logblocks = MIN(cfg->logblocks, XFS_MAX_LOG_BLOCKS);
+		cfg->logblocks = min(cfg->logblocks, XFS_MAX_LOG_BLOCKS);
 		if ((cfg->logblocks << cfg->blocklog) > XFS_MAX_LOG_BYTES)
 			cfg->logblocks = XFS_MAX_LOG_BYTES >> cfg->blocklog;
 
diff --git a/quota/util.c b/quota/util.c
index c7f64121..50470aba 100644
--- a/quota/util.c
+++ b/quota/util.c
@@ -29,7 +29,7 @@ time_to_string(
 		timer = origin;
 	} else {
 		time(&now);
-		timer = MAX(origin - now, 0);
+		timer = max(origin - now, 0);
 	}
 
 	/*
diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index d078522b..1098a5a2 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -428,7 +428,7 @@ rmtval_get(xfs_mount_t *mp, xfs_ino_t ino, blkmap_t *blkmap,
 
 		ASSERT(mp->m_sb.sb_blocksize == bp->b_bcount);
 
-		length = MIN(bp->b_bcount - hdrsize, valuelen - amountdone);
+		length = min(bp->b_bcount - hdrsize, valuelen - amountdone);
 		memmove(value, bp->b_addr + hdrsize, length);
 		amountdone += length;
 		value += length;
diff --git a/repair/bmap.c b/repair/bmap.c
index 375098a9..44e43ab4 100644
--- a/repair/bmap.c
+++ b/repair/bmap.c
@@ -178,7 +178,7 @@ blkmap_getn(
 						nb * sizeof(bmap_ext_t));
 
 		bmp[nex].startblock = ext->startblock + (o - ext->startoff);
-		bmp[nex].blockcount = MIN(nb, ext->blockcount -
+		bmp[nex].blockcount = min(nb, ext->blockcount -
 				(bmp[nex].startblock - ext->startblock));
 		o += bmp[nex].blockcount;
 		nb -= bmp[nex].blockcount;
diff --git a/repair/btree.c b/repair/btree.c
index 34f197bb..dd7717be 100644
--- a/repair/btree.c
+++ b/repair/btree.c
@@ -846,7 +846,7 @@ btree_insert_shift_to_prev(
 	if (!btree_copy_cursor_prev(root, tmp_cursor, level + 1))
 		return -1;
 
-	n = MIN(*index, (BTREE_PTR_MAX - tmp_cursor[level].node->num_keys) / 2);
+	n = min(*index, (BTREE_PTR_MAX - tmp_cursor[level].node->num_keys) / 2);
 	if (!n || !btree_shift_to_prev(root, level, tmp_cursor, n))
 		return -1;
 
@@ -869,7 +869,7 @@ btree_insert_shift_to_next(
 	if (!btree_copy_cursor_next(root, tmp_cursor, level + 1))
 		return -1;
 
-	n = MIN(BTREE_KEY_MAX - *index,
+	n = min(BTREE_KEY_MAX - *index,
 		(BTREE_PTR_MAX - tmp_cursor[level].node->num_keys) / 2);
 	if (!n || !btree_shift_to_next(root, level, tmp_cursor, n))
 		return -1;
diff --git a/repair/dinode.c b/repair/dinode.c
index 036f4845..fb65ee22 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -909,10 +909,10 @@ get_agino_buf(
 	 * we must find the buffer for its cluster, add the appropriate
 	 * offset, and return that.
 	 */
-	cluster_size = MAX(mp->m_inode_cluster_size, mp->m_sb.sb_blocksize);
+	cluster_size = max(mp->m_inode_cluster_size, mp->m_sb.sb_blocksize);
 	ino_per_cluster = cluster_size / mp->m_sb.sb_inodesize;
 	cluster_agino = agino & ~(ino_per_cluster - 1);
-	cluster_blks = XFS_FSB_TO_DADDR(mp, MAX(1,
+	cluster_blks = XFS_FSB_TO_DADDR(mp, max(1,
 			mp->m_inode_cluster_size >> mp->m_sb.sb_blocklog));
 	cluster_daddr = XFS_AGB_TO_DADDR(mp, agno,
 			XFS_AGINO_TO_AGBNO(mp, cluster_agino));
@@ -1482,7 +1482,7 @@ _("Bad symlink buffer CRC, block %" PRIu64 ", inode %" PRIu64 ".\n"
 		}
 
 		byte_cnt = XFS_SYMLINK_BUF_SPACE(mp, byte_cnt);
-		byte_cnt = MIN(pathlen, byte_cnt);
+		byte_cnt = min(pathlen, byte_cnt);
 
 		src = bp->b_addr;
 		if (xfs_sb_version_hascrc(&mp->m_sb)) {
diff --git a/repair/incore.c b/repair/incore.c
index 818e4f67..1374ddef 100644
--- a/repair/incore.c
+++ b/repair/incore.c
@@ -150,7 +150,7 @@ get_bmap_ext(
 		if (blen) {
 			if (!btree_peek_next(ag_bmap[agno], &key))
 				return -1;
-			*blen = MIN(maxbno, key) - agbno;
+			*blen = min(maxbno, key) - agbno;
 		}
 		return *statep;
 	}
@@ -159,7 +159,7 @@ get_bmap_ext(
 	if (!statep)
 		return -1;
 	if (blen)
-		*blen = MIN(maxbno, key) - agbno;
+		*blen = min(maxbno, key) - agbno;
 
 	return *statep;
 }
diff --git a/repair/incore_ino.c b/repair/incore_ino.c
index fe41853b..ed10d064 100644
--- a/repair/incore_ino.c
+++ b/repair/incore_ino.c
@@ -430,7 +430,7 @@ clear_uncertain_ino_cache(xfs_agnumber_t agno)
  * XFS_INODES_PER_CHUNK (64) inode chunk
  *
  * Each inode resides in a 64-inode chunk which can be part one or more chunks
- * (MAX(64, inodes-per-block).  The fs allocates in chunks (as opposed to 1
+ * (max(64, inodes-per-block).  The fs allocates in chunks (as opposed to 1
  * chunk) when a block can hold more than one chunk (inodes per block > 64).
  * Allocating in one chunk pieces causes us problems when it takes more than
  * one fs block to contain an inode chunk because the chunks can start on
diff --git a/repair/prefetch.c b/repair/prefetch.c
index ebfcac2d..9571b249 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -479,7 +479,7 @@ pf_batch_read(
 		num = 0;
 		if (which == PF_SECONDARY) {
 			bplist[0] = btree_find(args->io_queue, 0, &fsbno);
-			max_fsbno = MIN(fsbno + pf_max_fsbs,
+			max_fsbno = min(fsbno + pf_max_fsbs,
 							args->last_bno_read);
 		} else {
 			bplist[0] = btree_find(args->io_queue,
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index de3b3363..e72499f1 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -752,7 +752,7 @@ main(int argc, char **argv)
 
 	chunks_pblock = mp->m_sb.sb_inopblock / XFS_INODES_PER_CHUNK;
 	max_symlink_blocks = libxfs_symlink_blocks(mp, XFS_SYMLINK_MAXLEN);
-	inodes_per_cluster = MAX(mp->m_sb.sb_inopblock,
+	inodes_per_cluster = max(mp->m_sb.sb_inopblock,
 			mp->m_inode_cluster_size >> mp->m_sb.sb_inodelog);
 
 	/*
@@ -850,9 +850,9 @@ main(int argc, char **argv)
 			rlim.rlim_cur = rlim.rlim_max;
 			setrlimit(RLIMIT_AS, &rlim);
 			/* use approximately 80% of rlimit to avoid overrun */
-			max_mem = MIN(max_mem, rlim.rlim_cur / 1280);
+			max_mem = min(max_mem, rlim.rlim_cur / 1280);
 		} else
-			max_mem = MIN(max_mem, (LONG_MAX >> 10) + 1);
+			max_mem = min(max_mem, (LONG_MAX >> 10) + 1);
 
 		if (verbose > 1)
 			do_log(

