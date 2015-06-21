Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9650529E07
	for <xfs@oss.sgi.com>; Sun, 21 Jun 2015 04:24:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 14C46AC003
	for <xfs@oss.sgi.com>; Sun, 21 Jun 2015 02:24:41 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id siad5sxEy7RB2Wca (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 21 Jun 2015 02:24:38 -0700 (PDT)
Received: from smtpout2.drei.com ([109.126.64.2] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Z6bUT-00020x-8w
	for xfs@oss.sgi.com; Sun, 21 Jun 2015 09:24:38 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 8/8] xfsprogs: remove xfs_caddr_t
Date: Sun, 21 Jun 2015 11:22:04 +0200
Message-Id: <1434878524-18176-9-git-send-email-hch@lst.de>
In-Reply-To: <1434878524-18176-1-git-send-email-hch@lst.de>
References: <1434878524-18176-1-git-send-email-hch@lst.de>
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

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 copy/xfs_copy.c           |  6 +++---
 include/darwin.h          |  1 -
 include/freebsd.h         |  1 -
 include/gnukfreebsd.h     |  1 -
 include/irix.h            |  1 -
 include/libxfs.h          |  4 ++--
 include/libxlog.h         |  4 ++--
 include/linux.h           |  1 -
 libxfs/rdwr.c             |  6 +++---
 libxlog/xfs_log_recover.c | 40 ++++++++++++++++++++--------------------
 logprint/log_misc.c       | 34 +++++++++++++++++-----------------
 logprint/log_print_all.c  |  4 ++--
 12 files changed, 49 insertions(+), 54 deletions(-)

diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index 279527c..690ef80 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -1141,8 +1141,8 @@ main(int argc, char **argv)
 	return 0;
 }
 
-xfs_caddr_t
-next_log_chunk(xfs_caddr_t p, int offset, void *private)
+char *
+next_log_chunk(char *p, int offset, void *private)
 {
 	wbuf	*buf = (wbuf *)private;
 
@@ -1165,7 +1165,7 @@ next_log_chunk(xfs_caddr_t p, int offset, void *private)
 xfs_off_t
 write_log_header(int fd, wbuf *buf, xfs_mount_t *mp)
 {
-	xfs_caddr_t	p = buf->data;
+	char		*p = buf->data;
 	xfs_off_t	logstart;
 	int		offset;
 
diff --git a/include/darwin.h b/include/darwin.h
index ec8cb4f..30f0052 100644
--- a/include/darwin.h
+++ b/include/darwin.h
@@ -124,7 +124,6 @@ typedef off_t		xfs_off_t;
 typedef u_int64_t	xfs_ino_t;
 typedef u_int32_t	xfs_dev_t;
 typedef int64_t		xfs_daddr_t;
-typedef char*		xfs_caddr_t;
 
 #define stat64		stat
 #define fstat64		fstat
diff --git a/include/freebsd.h b/include/freebsd.h
index 0ae1262..e59b1e8 100644
--- a/include/freebsd.h
+++ b/include/freebsd.h
@@ -52,7 +52,6 @@ typedef off_t		off64_t;
 typedef __uint64_t	xfs_ino_t;
 typedef __uint32_t	xfs_dev_t;
 typedef __int64_t	xfs_daddr_t;
-typedef char*		xfs_caddr_t;
 
 #define	O_LARGEFILE	0
 
diff --git a/include/gnukfreebsd.h b/include/gnukfreebsd.h
index 6882cfe..d342595 100644
--- a/include/gnukfreebsd.h
+++ b/include/gnukfreebsd.h
@@ -42,7 +42,6 @@ typedef off_t		xfs_off_t;
 typedef __uint64_t	xfs_ino_t;
 typedef __uint32_t	xfs_dev_t;
 typedef __int64_t	xfs_daddr_t;
-typedef char*		xfs_caddr_t;
 
 #define HAVE_FID	1
 
diff --git a/include/irix.h b/include/irix.h
index ea1f219..31050c4 100644
--- a/include/irix.h
+++ b/include/irix.h
@@ -46,7 +46,6 @@ typedef off64_t		xfs_off_t;
 typedef __int64_t	xfs_ino_t;
 typedef __int32_t	xfs_dev_t;
 typedef __int64_t	xfs_daddr_t;
-typedef char*		xfs_caddr_t;
 
 #define xfs_flock64	flock64
 #define xfs_flock64_t	struct flock64
diff --git a/include/libxfs.h b/include/libxfs.h
index e12cd5a..1c7b1fa 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -146,11 +146,11 @@ extern void	platform_findsizes(char *path, int fd, long long *sz, int *bsz);
 extern int	platform_nproc(void);
 
 /* check or write log footer: specify device, log size in blocks & uuid */
-typedef xfs_caddr_t (libxfs_get_block_t)(xfs_caddr_t, int, void *);
+typedef char	*(libxfs_get_block_t)(char *, int, void *);
 
 extern int	libxfs_log_clear (struct xfs_buftarg *, xfs_daddr_t, uint,
 				uuid_t *, int, int, int);
-extern int	libxfs_log_header (xfs_caddr_t, uuid_t *, int, int, int,
+extern int	libxfs_log_header (char *, uuid_t *, int, int, int,
 				libxfs_get_block_t *, void *);
 
 
diff --git a/include/libxlog.h b/include/libxlog.h
index c6640a8..e3badf3 100644
--- a/include/libxlog.h
+++ b/include/libxlog.h
@@ -88,7 +88,7 @@ extern int xlog_is_dirty(xfs_mount_t *mp, libxfs_init_t *x, int verbose);
 extern struct xfs_buf *xlog_get_bp(struct xlog *, int);
 extern void	xlog_put_bp(struct xfs_buf *);
 extern int	xlog_bread(struct xlog *log, xfs_daddr_t blk_no, int nbblks,
-				xfs_buf_t *bp, xfs_caddr_t *offset);
+				xfs_buf_t *bp, char **offset);
 extern int	xlog_bread_noalign(struct xlog *log, xfs_daddr_t blk_no,
 				int nbblks, xfs_buf_t *bp);
 
@@ -101,7 +101,7 @@ extern int	xlog_find_tail(struct xlog *log, xfs_daddr_t *head_blk,
 
 extern int	xlog_test_footer(struct xlog *log);
 extern int	xlog_recover(struct xlog *log, int readonly);
-extern void	xlog_recover_print_data(xfs_caddr_t p, int len);
+extern void	xlog_recover_print_data(char *p, int len);
 extern void	xlog_recover_print_logitem(xlog_recover_item_t *item);
 extern void	xlog_recover_print_trans_head(xlog_recover_t *tr);
 extern int	xlog_print_find_oldest(struct xlog *log, xfs_daddr_t *last_blk);
diff --git a/include/linux.h b/include/linux.h
index e7a3cb2..31c077a 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -142,6 +142,5 @@ typedef loff_t		xfs_off_t;
 typedef __uint64_t	xfs_ino_t;
 typedef __uint32_t	xfs_dev_t;
 typedef __int64_t	xfs_daddr_t;
-typedef char*		xfs_caddr_t;
 
 #endif	/* __XFS_LINUX_H__ */
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index cb17206..ff56824 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -132,7 +132,7 @@ static void unmount_record(void *p)
 	memcpy((char *)p + sizeof(xlog_op_header_t), &magic, sizeof(magic));
 }
 
-static xfs_caddr_t next(xfs_caddr_t ptr, int offset, void *private)
+static char *next(char *ptr, int offset, void *private)
 {
 	xfs_buf_t	*buf = (xfs_buf_t *)private;
 
@@ -173,7 +173,7 @@ libxfs_log_clear(
 
 int
 libxfs_log_header(
-	xfs_caddr_t		caddr,
+	char			*caddr,
 	uuid_t			*fs_uuid,
 	int			version,
 	int			sunit,
@@ -182,7 +182,7 @@ libxfs_log_header(
 	void			*private)
 {
 	xlog_rec_header_t	*head = (xlog_rec_header_t *)caddr;
-	xfs_caddr_t		p = caddr;
+	char			*p = caddr;
 	__be32			cycle_lsn;
 	int			i, len;
 
diff --git a/libxlog/xfs_log_recover.c b/libxlog/xfs_log_recover.c
index cc8aff8..bf379f8 100644
--- a/libxlog/xfs_log_recover.c
+++ b/libxlog/xfs_log_recover.c
@@ -93,7 +93,7 @@ xlog_put_bp(
  * Return the address of the start of the given block number's data
  * in a log buffer.  The buffer covers a log sector-aligned region.
  */
-STATIC xfs_caddr_t
+STATIC char *
 xlog_align(
 	struct xlog	*log,
 	xfs_daddr_t	blk_no,
@@ -143,7 +143,7 @@ xlog_bread(
 	xfs_daddr_t	blk_no,
 	int		nbblks,
 	struct xfs_buf	*bp,
-	xfs_caddr_t	*offset)
+	char		**offset)
 {
 	int		error;
 
@@ -165,9 +165,9 @@ xlog_bread_offset(
 	xfs_daddr_t	blk_no,		/* block to read from */
 	int		nbblks,		/* blocks to read */
 	struct xfs_buf	*bp,
-	xfs_caddr_t	offset)
+	char		*offset)
 {
-	xfs_caddr_t	orig_offset = bp->b_addr;
+	char		*orig_offset = bp->b_addr;
 	int		orig_len = bp->b_bcount;
 	int		error, error2;
 
@@ -198,7 +198,7 @@ xlog_find_cycle_start(
 	xfs_daddr_t	*last_blk,
 	uint		cycle)
 {
-	xfs_caddr_t	offset;
+	char		*offset;
 	xfs_daddr_t	mid_blk;
 	xfs_daddr_t	end_blk;
 	uint		mid_cycle;
@@ -245,7 +245,7 @@ xlog_find_verify_cycle(
 	uint		cycle;
 	xfs_buf_t	*bp;
 	xfs_daddr_t	bufblks;
-	xfs_caddr_t	buf = NULL;
+	char		*buf = NULL;
 	int		error = 0;
 
 	/*
@@ -311,7 +311,7 @@ xlog_find_verify_log_record(
 {
 	xfs_daddr_t		i;
 	xfs_buf_t		*bp;
-	xfs_caddr_t		offset = NULL;
+	char			*offset = NULL;
 	xlog_rec_header_t	*head = NULL;
 	int			error = 0;
 	int			smallmem = 0;
@@ -418,7 +418,7 @@ xlog_find_head(
 	xfs_daddr_t	*return_head_blk)
 {
 	xfs_buf_t	*bp;
-	xfs_caddr_t	offset;
+	char		*offset;
 	xfs_daddr_t	new_blk, first_blk, start_blk, last_blk, head_blk;
 	int		num_scan_bblks;
 	uint		first_half_cycle, last_half_cycle;
@@ -691,7 +691,7 @@ xlog_find_tail(
 {
 	xlog_rec_header_t	*rhead;
 	xlog_op_header_t	*op_head;
-	xfs_caddr_t		offset = NULL;
+	char			*offset = NULL;
 	xfs_buf_t		*bp;
 	int			error, i, found;
 	xfs_daddr_t		umount_data_blk;
@@ -899,7 +899,7 @@ xlog_find_zeroed(
 	xfs_daddr_t	*blk_no)
 {
 	xfs_buf_t	*bp;
-	xfs_caddr_t	offset;
+	char		*offset;
 	uint	        first_cycle, last_cycle;
 	xfs_daddr_t	new_blk, last_blk, start_blk;
 	xfs_daddr_t     num_scan_bblks;
@@ -1041,17 +1041,17 @@ STATIC int
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
+		ptr = (char *) &trans->r_theader +
 				sizeof(xfs_trans_header_t) - len;
 		memcpy(ptr, dp, len); /* d, s, l */
 		return 0;
@@ -1087,12 +1087,12 @@ STATIC int
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
@@ -1219,10 +1219,10 @@ xlog_recover_process_data(
 	struct xlog		*log,
 	struct hlist_head	rhash[],
 	struct xlog_rec_header	*rhead,
-	xfs_caddr_t		dp,
+	char			*dp,
 	int			pass)
 {
-	xfs_caddr_t		lp;
+	char			*lp;
 	int			num_logops;
 	xlog_op_header_t	*ohead;
 	xlog_recover_t		*trans;
@@ -1322,7 +1322,7 @@ xlog_recover_process_data(
 STATIC int
 xlog_unpack_data_crc(
 	struct xlog_rec_header	*rhead,
-	xfs_caddr_t		dp,
+	char			*dp,
 	struct xlog		*log)
 {
 	__le32			crc;
@@ -1352,7 +1352,7 @@ xlog_unpack_data_crc(
 STATIC int
 xlog_unpack_data(
 	struct xlog_rec_header	*rhead,
-	xfs_caddr_t		dp,
+	char			*dp,
 	struct xlog		*log)
 {
 	int			i, j, k;
@@ -1434,7 +1434,7 @@ xlog_do_recovery_pass(
 {
 	xlog_rec_header_t	*rhead;
 	xfs_daddr_t		blk_no;
-	xfs_caddr_t		offset;
+	char			*offset;
 	xfs_buf_t		*hbp, *dbp;
 	int			error = 0, h_size;
 	int			bblks, split_bblks;
diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index 708a513..790abd9 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -119,7 +119,7 @@ print_stars(void)
 void
 xlog_print_op_header(xlog_op_header_t	*op_head,
 		     int		i,
-		     xfs_caddr_t	*ptr)
+		     char		**ptr)
 {
     xlog_op_header_t hbuf;
 
@@ -208,10 +208,10 @@ xlog_print_find_tid(xlog_tid_t tid, uint was_cont)
 }	/* xlog_print_find_tid */
 
 int
-xlog_print_trans_header(xfs_caddr_t *ptr, int len)
+xlog_print_trans_header(char **ptr, int len)
 {
     xfs_trans_header_t  *h;
-    xfs_caddr_t		cptr = *ptr;
+    char		*cptr = *ptr;
     __uint32_t          magic;
     char                *magic_c = (char *)&magic;
 
@@ -240,7 +240,7 @@ xlog_print_trans_header(xfs_caddr_t *ptr, int len)
 
 
 int
-xlog_print_trans_buffer(xfs_caddr_t *ptr, int len, int *i, int num_ops)
+xlog_print_trans_buffer(char **ptr, int len, int *i, int num_ops)
 {
     xfs_buf_log_format_t *f;
     xfs_agi_t		 *agi;
@@ -466,7 +466,7 @@ xlog_print_trans_buffer(xfs_caddr_t *ptr, int len, int *i, int num_ops)
 
 
 int
-xlog_print_trans_efd(xfs_caddr_t *ptr, uint len)
+xlog_print_trans_efd(char **ptr, uint len)
 {
     xfs_efd_log_format_t *f;
     xfs_efd_log_format_t lbuf;
@@ -496,7 +496,7 @@ xlog_print_trans_efd(xfs_caddr_t *ptr, uint len)
 
 int
 xlog_print_trans_efi(
-	xfs_caddr_t *ptr,
+	char **ptr,
 	uint src_len,
 	int continued)
 {
@@ -560,7 +560,7 @@ error:
 
 
 int
-xlog_print_trans_qoff(xfs_caddr_t *ptr, uint len)
+xlog_print_trans_qoff(char **ptr, uint len)
 {
     xfs_qoff_logformat_t *f;
     xfs_qoff_logformat_t lbuf;
@@ -637,7 +637,7 @@ xlog_print_dir2_sf(
 int
 xlog_print_trans_inode(
 	struct xlog	*log,
-	xfs_caddr_t	*ptr,
+	char		**ptr,
 	int		len,
 	int		*i,
 	int		num_ops,
@@ -778,7 +778,7 @@ xlog_print_trans_inode(
 
 
 int
-xlog_print_trans_dquot(xfs_caddr_t *ptr, int len, int *i, int num_ops)
+xlog_print_trans_dquot(char **ptr, int len, int *i, int num_ops)
 {
     xfs_dq_logformat_t	*f;
     xfs_dq_logformat_t	lbuf = {0};
@@ -834,7 +834,7 @@ xlog_print_trans_dquot(xfs_caddr_t *ptr, int len, int *i, int num_ops)
 
 STATIC int
 xlog_print_trans_icreate(
-	xfs_caddr_t	*ptr,
+	char		**ptr,
 	int		len,
 	int		*i,
 	int		num_ops)
@@ -886,7 +886,7 @@ xlog_print_lseek(struct xlog *log, int fd, xfs_daddr_t blkno, int whence)
 
 
 void
-print_lsn(xfs_caddr_t	string,
+print_lsn(char		*string,
 	  __be64	*lsn)
 {
     printf("%s: %u,%u", string,
@@ -901,12 +901,12 @@ xlog_print_record(
 	int			num_ops,
 	int			len,
 	int			*read_type,
-	xfs_caddr_t		*partial_buf,
+	char			**partial_buf,
 	xlog_rec_header_t	*rhead,
 	xlog_rec_ext_header_t	*xhdrs,
 	int			bad_hdr_warn)
 {
-    xfs_caddr_t		buf, ptr;
+    char		*buf, *ptr;
     int			read_len, skip, lost_context = 0;
     int			ret, n, i, j, k;
 
@@ -923,13 +923,13 @@ xlog_print_record(
 
     /* read_type => don't malloc() new buffer, use old one */
     if (*read_type == FULL_READ) {
-	if ((ptr = buf = (xfs_caddr_t)malloc(read_len)) == NULL) {
+	if ((ptr = buf = malloc(read_len)) == NULL) {
 	    fprintf(stderr, _("%s: xlog_print_record: malloc failed\n"), progname);
 	    exit(1);
 	}
     } else {
 	read_len -= *read_type;
-	buf = (xfs_caddr_t)((intptr_t)(*partial_buf) + (intptr_t)(*read_type));
+	buf = (char *)((intptr_t)(*partial_buf) + (intptr_t)(*read_type));
 	ptr = *partial_buf;
     }
     if ((ret = (int) read(fd, buf, read_len)) == -1) {
@@ -1220,7 +1220,7 @@ print_xlog_bad_zeroed(xfs_daddr_t blkno)
 }	/* print_xlog_bad_zeroed */
 
 static void
-print_xlog_bad_header(xfs_daddr_t blkno, xfs_caddr_t buf)
+print_xlog_bad_header(xfs_daddr_t blkno, char *buf)
 {
 	print_stars();
 	printf(_("* ERROR: header cycle=%-11d block=%-21lld        *\n"),
@@ -1358,7 +1358,7 @@ void xfs_log_print(struct xlog  *log,
     xfs_daddr_t			block_end = 0, block_start, blkno, error;
     xfs_daddr_t			zeroed_blkno = 0, cleared_blkno = 0;
     int				read_type = FULL_READ;
-    xfs_caddr_t			partial_buf;
+    char			*partial_buf;
     int				zeroed = 0;
     int				cleared = 0;
     int				first_hdr_found = 0;
diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
index a02c71a..d8eb7e2 100644
--- a/logprint/log_print_all.c
+++ b/logprint/log_print_all.c
@@ -57,7 +57,7 @@ xlog_print_find_oldest(
 
 void
 xlog_recover_print_data(
-	xfs_caddr_t	p,
+	char		*p,
 	int		len)
 {
 	if (print_data) {
@@ -85,7 +85,7 @@ xlog_recover_print_buffer(
 	xfs_agi_t		*agi;
 	xfs_agf_t		*agf;
 	xfs_buf_log_format_t	*f;
-	xfs_caddr_t		p;
+	char			*p;
 	int			len, num, i;
 	xfs_daddr_t		blkno;
 	xfs_disk_dquot_t	*ddq;
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
