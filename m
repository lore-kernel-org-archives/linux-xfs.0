Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A98A77FA5
	for <xfs@oss.sgi.com>; Wed, 17 Jun 2015 05:57:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8FFF08F8078
	for <xfs@oss.sgi.com>; Wed, 17 Jun 2015 03:57:40 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id ULTgLF4tCW2Rmz2d (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 17 Jun 2015 03:57:38 -0700 (PDT)
Received: from [88.128.80.44] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Z5B2H-0003Yn-Ru
	for xfs@oss.sgi.com; Wed, 17 Jun 2015 10:57:38 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5/5] xfs: remove xfs_caddr_t
Date: Wed, 17 Jun 2015 12:55:32 +0200
Message-Id: <1434538532-6566-6-git-send-email-hch@lst.de>
In-Reply-To: <1434538532-6566-1-git-send-email-hch@lst.de>
References: <1434538532-6566-1-git-send-email-hch@lst.de>
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

Just use char pointers directly instead of the confusing typedef to a
pointer type.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_linux.h       |  1 -
 fs/xfs/xfs_log.c         |  4 ++--
 fs/xfs/xfs_log_recover.c | 54 ++++++++++++++++++++++++------------------------
 3 files changed, 29 insertions(+), 30 deletions(-)

diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index 3f48263..85f883d 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -35,7 +35,6 @@ typedef unsigned long long int	__uint64_t;
 typedef __s64			xfs_off_t;	/* <file offset> type */
 typedef unsigned long long	xfs_ino_t;	/* <inode> type */
 typedef __s64			xfs_daddr_t;	/* <disk address> type */
-typedef char *			xfs_caddr_t;	/* <core address> type */
 typedef __u32			xfs_dev_t;
 typedef __u32			xfs_nlink_t;
 
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 7b940c6..08d4fe4 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1599,7 +1599,7 @@ xlog_pack_data(
 	int			i, j, k;
 	int			size = iclog->ic_offset + roundoff;
 	__be32			cycle_lsn;
-	xfs_caddr_t		dp;
+	char			*dp;
 
 	cycle_lsn = CYCLE_LSN_DISK(iclog->ic_header.h_lsn);
 
@@ -3806,7 +3806,7 @@ xlog_verify_iclog(
 		if (!syncing || (field_offset & 0x1ff)) {
 			clientid = ophead->oh_clientid;
 		} else {
-			idx = BTOBBT((xfs_caddr_t)&(ophead->oh_clientid) - iclog->ic_datap);
+			idx = BTOBBT((char *)&ophead->oh_clientid - iclog->ic_datap);
 			if (idx >= (XLOG_HEADER_CYCLE_SIZE / BBSIZE)) {
 				j = idx / (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
 				k = idx % (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 214fd38..01dd228 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -147,7 +147,7 @@ xlog_put_bp(
  * Return the address of the start of the given block number's data
  * in a log buffer.  The buffer covers a log sector-aligned region.
  */
-STATIC xfs_caddr_t
+STATIC char *
 xlog_align(
 	struct xlog	*log,
 	xfs_daddr_t	blk_no,
@@ -203,7 +203,7 @@ xlog_bread(
 	xfs_daddr_t	blk_no,
 	int		nbblks,
 	struct xfs_buf	*bp,
-	xfs_caddr_t	*offset)
+	char		**offset)
 {
 	int		error;
 
@@ -225,9 +225,9 @@ xlog_bread_offset(
 	xfs_daddr_t	blk_no,		/* block to read from */
 	int		nbblks,		/* blocks to read */
 	struct xfs_buf	*bp,
-	xfs_caddr_t	offset)
+	char		*offset)
 {
-	xfs_caddr_t	orig_offset = bp->b_addr;
+	char		*orig_offset = bp->b_addr;
 	int		orig_len = BBTOB(bp->b_length);
 	int		error, error2;
 
@@ -396,7 +396,7 @@ xlog_find_cycle_start(
 	xfs_daddr_t	*last_blk,
 	uint		cycle)
 {
-	xfs_caddr_t	offset;
+	char		*offset;
 	xfs_daddr_t	mid_blk;
 	xfs_daddr_t	end_blk;
 	uint		mid_cycle;
@@ -443,7 +443,7 @@ xlog_find_verify_cycle(
 	uint		cycle;
 	xfs_buf_t	*bp;
 	xfs_daddr_t	bufblks;
-	xfs_caddr_t	buf = NULL;
+	char		*buf = NULL;
 	int		error = 0;
 
 	/*
@@ -509,7 +509,7 @@ xlog_find_verify_log_record(
 {
 	xfs_daddr_t		i;
 	xfs_buf_t		*bp;
-	xfs_caddr_t		offset = NULL;
+	char			*offset = NULL;
 	xlog_rec_header_t	*head = NULL;
 	int			error = 0;
 	int			smallmem = 0;
@@ -616,7 +616,7 @@ xlog_find_head(
 	xfs_daddr_t	*return_head_blk)
 {
 	xfs_buf_t	*bp;
-	xfs_caddr_t	offset;
+	char		*offset;
 	xfs_daddr_t	new_blk, first_blk, start_blk, last_blk, head_blk;
 	int		num_scan_bblks;
 	uint		first_half_cycle, last_half_cycle;
@@ -891,7 +891,7 @@ xlog_find_tail(
 {
 	xlog_rec_header_t	*rhead;
 	xlog_op_header_t	*op_head;
-	xfs_caddr_t		offset = NULL;
+	char			*offset = NULL;
 	xfs_buf_t		*bp;
 	int			error, i, found;
 	xfs_daddr_t		umount_data_blk;
@@ -1099,7 +1099,7 @@ xlog_find_zeroed(
 	xfs_daddr_t	*blk_no)
 {
 	xfs_buf_t	*bp;
-	xfs_caddr_t	offset;
+	char		*offset;
 	uint	        first_cycle, last_cycle;
 	xfs_daddr_t	new_blk, last_blk, start_blk;
 	xfs_daddr_t     num_scan_bblks;
@@ -1199,7 +1199,7 @@ bp_err:
 STATIC void
 xlog_add_record(
 	struct xlog		*log,
-	xfs_caddr_t		buf,
+	char			*buf,
 	int			cycle,
 	int			block,
 	int			tail_cycle,
@@ -1227,7 +1227,7 @@ xlog_write_log_records(
 	int		tail_cycle,
 	int		tail_block)
 {
-	xfs_caddr_t	offset;
+	char		*offset;
 	xfs_buf_t	*bp;
 	int		balign, ealign;
 	int		sectbb = log->l_sectBBsize;
@@ -2502,8 +2502,8 @@ xlog_recover_inode_pass2(
 	xfs_buf_t		*bp;
 	xfs_dinode_t		*dip;
 	int			len;
-	xfs_caddr_t		src;
-	xfs_caddr_t		dest;
+	char			*src;
+	char			*dest;
 	int			error;
 	int			attr_index;
 	uint			fields;
@@ -3373,17 +3373,17 @@ STATIC int
 xlog_recover_add_to_cont_trans(
 	struct xlog		*log,
 	struct xlog_recover	*trans,
-	xfs_caddr_t		dp,
+	char			*dp,
 	int			len)
 {
 	xlog_recover_item_t	*item;
-	xfs_caddr_t		ptr, old_ptr;
+	char			*ptr, *old_ptr;
 	int			old_len;
 
 	if (list_empty(&trans->r_itemq)) {
 		/* finish copying rest of trans header */
 		xlog_recover_add_item(&trans->r_itemq);
-		ptr = (xfs_caddr_t) &trans->r_theader +
+		ptr = (char *)&trans->r_theader +
 				sizeof(xfs_trans_header_t) - len;
 		memcpy(ptr, dp, len);
 		return 0;
@@ -3419,12 +3419,12 @@ STATIC int
 xlog_recover_add_to_trans(
 	struct xlog		*log,
 	struct xlog_recover	*trans,
-	xfs_caddr_t		dp,
+	char			*dp,
 	int			len)
 {
 	xfs_inode_log_format_t	*in_f;			/* any will do */
 	xlog_recover_item_t	*item;
-	xfs_caddr_t		ptr;
+	char			*ptr;
 
 	if (!len)
 		return 0;
@@ -3513,7 +3513,7 @@ STATIC int
 xlog_recovery_process_trans(
 	struct xlog		*log,
 	struct xlog_recover	*trans,
-	xfs_caddr_t		dp,
+	char			*dp,
 	unsigned int		len,
 	unsigned int		flags,
 	int			pass)
@@ -3620,8 +3620,8 @@ xlog_recover_process_ophdr(
 	struct hlist_head	rhash[],
 	struct xlog_rec_header	*rhead,
 	struct xlog_op_header	*ohead,
-	xfs_caddr_t		dp,
-	xfs_caddr_t		end,
+	char			*dp,
+	char			*end,
 	int			pass)
 {
 	struct xlog_recover	*trans;
@@ -3670,11 +3670,11 @@ xlog_recover_process_data(
 	struct xlog		*log,
 	struct hlist_head	rhash[],
 	struct xlog_rec_header	*rhead,
-	xfs_caddr_t		dp,
+	char			*dp,
 	int			pass)
 {
 	struct xlog_op_header	*ohead;
-	xfs_caddr_t		end;
+	char			*end;
 	int			num_logops;
 	int			error;
 
@@ -4019,7 +4019,7 @@ xlog_recover_process_iunlinks(
 STATIC int
 xlog_unpack_data_crc(
 	struct xlog_rec_header	*rhead,
-	xfs_caddr_t		dp,
+	char			*dp,
 	struct xlog		*log)
 {
 	__le32			crc;
@@ -4049,7 +4049,7 @@ xlog_unpack_data_crc(
 STATIC int
 xlog_unpack_data(
 	struct xlog_rec_header	*rhead,
-	xfs_caddr_t		dp,
+	char			*dp,
 	struct xlog		*log)
 {
 	int			i, j, k;
@@ -4131,7 +4131,7 @@ xlog_do_recovery_pass(
 {
 	xlog_rec_header_t	*rhead;
 	xfs_daddr_t		blk_no;
-	xfs_caddr_t		offset;
+	char			*offset;
 	xfs_buf_t		*hbp, *dbp;
 	int			error = 0, h_size;
 	int			bblks, split_bblks;
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
