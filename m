Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D12B77CE9
	for <xfs@oss.sgi.com>; Sun,  7 Aug 2016 02:35:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 93C65304048
	for <xfs@oss.sgi.com>; Sun,  7 Aug 2016 00:35:53 -0700 (PDT)
Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66]) by
	cuda.sgi.com with ESMTP id ynZs9OH7eYvoBoTX (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 07 Aug 2016 00:35:50 -0700 (PDT)
Received: from submission (posteo.de [89.146.220.130])
	by mout02.posteo.de (Postfix) with ESMTPS id 3546220A8B
	for <xfs@oss.sgi.com>; Sun,  7 Aug 2016 09:35:49 +0200 (CEST)
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 3s6XQX5Fx4z1043
	for <xfs@oss.sgi.com>; Sun,  7 Aug 2016 09:35:48 +0200 (CEST)
Message-Id: <638a270f0a8291a42e30adb8abd56224664931e5.1470555003.git.felix.janda@posteo.de>
In-Reply-To: <cover.1470555003.git.felix.janda@posteo.de>
References: <cover.1470555003.git.felix.janda@posteo.de>
From: Felix Janda <felix.janda@posteo.de>
Date: Sat, 6 Aug 2016 12:52:31 +0200
Subject: [PATCH xfsprogs 12/14] replace off64_t by off_t outside of public
	headers
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

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
 copy/xfs_copy.c           |  2 +-
 fsr/xfs_fsr.c             |  2 +-
 io/bmap.c                 | 10 +++++-----
 io/copy_file_range.c      |  2 +-
 io/fadvise.c              |  2 +-
 io/io.h                   | 10 +++++-----
 io/madvise.c              |  2 +-
 io/mincore.c              |  2 +-
 io/mmap.c                 | 12 ++++++------
 io/open.c                 |  2 +-
 io/pread.c                | 22 +++++++++++-----------
 io/pwrite.c               | 18 +++++++++---------
 io/reflink.c              |  4 ++--
 io/seek.c                 |  6 +++---
 io/sendfile.c             |  6 +++---
 io/sync_file_range.c      |  2 +-
 io/truncate.c             |  2 +-
 libxfs/rdwr.c             |  8 ++++----
 mdrestore/xfs_mdrestore.c |  2 +-
 repair/prefetch.c         |  2 +-
 20 files changed, 59 insertions(+), 59 deletions(-)

diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index 816ab29..a8a7b4e 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -854,7 +854,7 @@ main(int argc, char **argv)
 			}
 		} else  {
 			char	*lb[XFS_MAX_SECTORSIZE] = { NULL };
-			off64_t	off;
+			off_t	off;
 
 			/* ensure device files are sufficiently large */
 
diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index f3cc07e..ce89433 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -1214,7 +1214,7 @@ packfile(char *fname, char *tname, int fd,
 	struct dioattr	dio;
 	static xfs_swapext_t   sx;
 	struct xfs_flock64  space;
-	off64_t 	cnt, pos;
+	off_t	 	cnt, pos;
 	void 		*fbuf = NULL;
 	int 		ct, wc, wc_b4;
 	char		ffname[SMBUFSZ];
diff --git a/io/bmap.c b/io/bmap.c
index 04d04c7..a7ad8ff 100644
--- a/io/bmap.c
+++ b/io/bmap.c
@@ -53,9 +53,9 @@ bmap_help(void)
 
 static int
 numlen(
-	off64_t	val)
+	off_t	val)
 {
-	off64_t	tmp;
+	off_t	tmp;
 	int	len;
 
 	for (len = 0, tmp = val; tmp > 0; tmp = tmp/10)
@@ -279,7 +279,7 @@ bmap_f(
 #define	FLG_BSW		000010	/* Not on begin of stripe width */
 #define	FLG_ESW		000001	/* Not on end   of stripe width */
 		int	agno;
-		off64_t agoff, bbperag;
+		off_t	agoff, bbperag;
 		int	foff_w, boff_w, aoff_w, tot_w, agno_w;
 		char	rbuf[32], bbuf[32], abuf[32];
 		int	sunit, swidth;
@@ -289,8 +289,8 @@ bmap_f(
 		if (is_rt)
 			sunit = swidth = bbperag = 0;
 		else {
-			bbperag = (off64_t)fsgeo.agblocks *
-				  (off64_t)fsgeo.blocksize / BBSIZE;
+			bbperag = (off_t)fsgeo.agblocks *
+				  (off_t)fsgeo.blocksize / BBSIZE;
 			sunit = (fsgeo.sunit * fsgeo.blocksize) / BBSIZE;
 			swidth = (fsgeo.swidth * fsgeo.blocksize) / BBSIZE;
 		}
diff --git a/io/copy_file_range.c b/io/copy_file_range.c
index 88203e9..d1473bb 100644
--- a/io/copy_file_range.c
+++ b/io/copy_file_range.c
@@ -57,7 +57,7 @@ copy_file_range(int fd, loff_t *src, loff_t *dst, size_t len)
 	return 0;
 }
 
-static off64_t
+static off_t
 copy_src_filesize(int fd)
 {
 	struct stat st;
diff --git a/io/fadvise.c b/io/fadvise.c
index d59d1ff..d8195a0 100644
--- a/io/fadvise.c
+++ b/io/fadvise.c
@@ -51,7 +51,7 @@ fadvise_f(
 	int		argc,
 	char		**argv)
 {
-	off64_t		offset = 0, length = 0;
+	off_t		offset = 0, length = 0;
 	int		c, range = 0, advise = POSIX_FADV_NORMAL;
 
 	while ((c = getopt(argc, argv, "dnrsw")) != EOF) {
diff --git a/io/io.h b/io/io.h
index 2bc7ac4..1a38aca 100644
--- a/io/io.h
+++ b/io/io.h
@@ -60,7 +60,7 @@ extern int filelist_f(void);
 typedef struct mmap_region {
 	void		*addr;		/* address of start of mapping */
 	size_t		length;		/* length of mapping */
-	off64_t		offset;		/* start offset into backing file */
+	off_t		offset;		/* start offset into backing file */
 	int		prot;		/* protection mode of the mapping */
 	char		*name;		/* name of backing file */
 } mmap_region_t;
@@ -69,13 +69,13 @@ extern mmap_region_t	*maptable;	/* mmap'd region array */
 extern int		mapcount;	/* #entries in the mapping table */
 extern mmap_region_t	*mapping;	/* active mapping table entry */
 extern int maplist_f(void);
-extern void *check_mapping_range(mmap_region_t *, off64_t, size_t, int);
+extern void *check_mapping_range(mmap_region_t *, off_t, size_t, int);
 
 /*
  * Various xfs_io helper routines/globals
  */
 
-extern off64_t		filesize(void);
+extern off_t		filesize(void);
 extern int		openfile(char *, xfs_fsop_geom_t *, int, mode_t);
 extern int		addfile(char *, int , xfs_fsop_geom_t *, int);
 extern void		printxattr(uint, int, int, const char *, int, int);
@@ -88,9 +88,9 @@ extern size_t		buffersize;
 extern int		vectors;
 extern struct iovec	*iov;
 extern int		alloc_buffer(size_t, int, unsigned int);
-extern int		read_buffer(int, off64_t, long long, long long *,
+extern int		read_buffer(int, off_t, long long, long long *,
 					int, int);
-extern void		dump_buffer(off64_t, ssize_t);
+extern void		dump_buffer(off_t, ssize_t);
 
 extern void		attr_init(void);
 extern void		bmap_init(void);
diff --git a/io/madvise.c b/io/madvise.c
index 1d8b53c..5aacbb5 100644
--- a/io/madvise.c
+++ b/io/madvise.c
@@ -51,7 +51,7 @@ madvise_f(
 	int		argc,
 	char		**argv)
 {
-	off64_t		offset, llength;
+	off_t		offset, llength;
 	size_t		length;
 	void		*start;
 	int		advise = MADV_NORMAL, c;
diff --git a/io/mincore.c b/io/mincore.c
index 9e0d3a6..4a4781f 100644
--- a/io/mincore.c
+++ b/io/mincore.c
@@ -29,7 +29,7 @@ mincore_f(
 	int		argc,
 	char		**argv)
 {
-	off64_t		offset, llength;
+	off_t		offset, llength;
 	size_t		length;
 	size_t		blocksize, sectsize;
 	void		*start;
diff --git a/io/mmap.c b/io/mmap.c
index dc188d0..a8d8197 100644
--- a/io/mmap.c
+++ b/io/mmap.c
@@ -68,11 +68,11 @@ print_mapping(
 void *
 check_mapping_range(
 	mmap_region_t	*map,
-	off64_t		offset,
+	off_t		offset,
 	size_t		length,
 	int		pagealign)
 {
-	off64_t		relative;
+	off_t		relative;
 
 	if (offset < mapping->offset) {
 		printf(_("offset (%lld) is before start of mapping (%lld)\n"),
@@ -156,7 +156,7 @@ mmap_f(
 	int		argc,
 	char		**argv)
 {
-	off64_t		offset;
+	off_t		offset;
 	ssize_t		length = 0, length2 = 0;
 	void		*address = NULL;
 	char		*filename;
@@ -288,7 +288,7 @@ msync_f(
 	int		argc,
 	char		**argv)
 {
-	off64_t		offset;
+	off_t		offset;
 	ssize_t		length;
 	void		*start;
 	int		c, flags = 0;
@@ -372,7 +372,7 @@ mread_f(
 	int		argc,
 	char		**argv)
 {
-	off64_t		offset, tmp, dumpoffset, printoffset;
+	off_t		offset, tmp, dumpoffset, printoffset;
 	ssize_t		length;
 	size_t		dumplen, cnt = 0;
 	char		*bp;
@@ -529,7 +529,7 @@ mwrite_f(
 	int		argc,
 	char		**argv)
 {
-	off64_t		offset, tmp;
+	off_t		offset, tmp;
 	ssize_t		length;
 	void		*start;
 	char		*sp;
diff --git a/io/open.c b/io/open.c
index d4ec13c..aded8a6 100644
--- a/io/open.c
+++ b/io/open.c
@@ -49,7 +49,7 @@ static cmdinfo_t inode_cmd;
 static prid_t prid;
 static long extsize;
 
-off64_t
+off_t
 filesize(void)
 {
 	struct stat	st;
diff --git a/io/pread.c b/io/pread.c
index 3395503..da42b8f 100644
--- a/io/pread.c
+++ b/io/pread.c
@@ -125,7 +125,7 @@ alloc_buffer(
 void
 __dump_buffer(
 	void		*buf,
-	off64_t		offset,
+	off_t		offset,
 	ssize_t		len)
 {
 	int		i, j;
@@ -150,7 +150,7 @@ __dump_buffer(
 
 void
 dump_buffer(
-	off64_t		offset,
+	off_t		offset,
 	ssize_t		len)
 {
 	int		i, l;
@@ -173,7 +173,7 @@ dump_buffer(
 static int
 do_preadv(
 	int		fd,
-	off64_t		offset,
+	off_t		offset,
 	ssize_t		count,
 	ssize_t		buffer_size)
 {
@@ -209,7 +209,7 @@ do_preadv(
 static int
 do_pread(
 	int		fd,
-	off64_t		offset,
+	off_t		offset,
 	ssize_t		count,
 	ssize_t		buffer_size)
 {
@@ -222,13 +222,13 @@ do_pread(
 static int
 read_random(
 	int		fd,
-	off64_t		offset,
+	off_t		offset,
 	long long	count,
 	long long	*total,
 	unsigned int	seed,
 	int		eof)
 {
-	off64_t		end, off, range;
+	off_t		end, off, range;
 	ssize_t		bytes;
 	int		ops = 0;
 
@@ -269,12 +269,12 @@ read_random(
 static int
 read_backward(
 	int		fd,
-	off64_t		*offset,
+	off_t		*offset,
 	long long	*count,
 	long long	*total,
 	int		eof)
 {
-	off64_t		end, off = *offset;
+	off_t		end, off = *offset;
 	ssize_t		bytes = 0, bytes_requested;
 	long long	cnt = *count;
 	int		ops = 0;
@@ -329,7 +329,7 @@ read_backward(
 static int
 read_forward(
 	int		fd,
-	off64_t		offset,
+	off_t		offset,
 	long long	count,
 	long long	*total,
 	int		verbose,
@@ -363,7 +363,7 @@ read_forward(
 int
 read_buffer(
 	int		fd,
-	off64_t		offset,
+	off_t		offset,
 	long long	count,
 	long long	*total,
 	int		verbose,
@@ -378,7 +378,7 @@ pread_f(
 	char		**argv)
 {
 	size_t		bsize;
-	off64_t		offset;
+	off_t		offset;
 	unsigned int	zeed = 0;
 	long long	count, total, tmp;
 	size_t		fsblocksize, fssectsize;
diff --git a/io/pwrite.c b/io/pwrite.c
index 7c0bb7f..d2cbafb 100644
--- a/io/pwrite.c
+++ b/io/pwrite.c
@@ -60,7 +60,7 @@ pwrite_help(void)
 static int
 do_pwritev(
 	int		fd,
-	off64_t		offset,
+	off_t		offset,
 	ssize_t		count,
 	ssize_t		buffer_size)
 {
@@ -96,7 +96,7 @@ do_pwritev(
 static int
 do_pwrite(
 	int		fd,
-	off64_t		offset,
+	off_t		offset,
 	ssize_t		count,
 	ssize_t		buffer_size)
 {
@@ -108,12 +108,12 @@ do_pwrite(
 
 static int
 write_random(
-	off64_t		offset,
+	off_t		offset,
 	long long	count,
 	unsigned int	seed,
 	long long	*total)
 {
-	off64_t		off, range;
+	off_t		off, range;
 	ssize_t		bytes;
 	int		ops = 0;
 
@@ -151,11 +151,11 @@ write_random(
 
 static int
 write_backward(
-	off64_t		offset,
+	off_t		offset,
 	long long	*count,
 	long long	*total)
 {
-	off64_t		end, off = offset;
+	off_t		end, off = offset;
 	ssize_t		bytes = 0, bytes_requested;
 	long long	cnt = *count;
 	int		ops = 0;
@@ -207,11 +207,11 @@ write_backward(
 
 static int
 write_buffer(
-	off64_t		offset,
+	off_t		offset,
 	long long	count,
 	size_t		bs,
 	int		fd,
-	off64_t		skip,
+	off_t		skip,
 	long long	*total)
 {
 	ssize_t		bytes;
@@ -249,7 +249,7 @@ pwrite_f(
 	char		**argv)
 {
 	size_t		bsize;
-	off64_t		offset, skip = 0;
+	off_t		offset, skip = 0;
 	long long	count, total, tmp;
 	unsigned int	zeed = 0, seed = 0xcdcdcdcd;
 	size_t		fsblocksize, fssectsize;
diff --git a/io/reflink.c b/io/reflink.c
index a09e82d..6becd12 100644
--- a/io/reflink.c
+++ b/io/reflink.c
@@ -109,7 +109,7 @@ dedupe_f(
 	int		argc,
 	char		**argv)
 {
-	off64_t		soffset, doffset;
+	off_t		soffset, doffset;
 	long long	count, total;
 	char		*infile;
 	int		condensed, quiet_flag;
@@ -229,7 +229,7 @@ reflink_f(
 	int		argc,
 	char		**argv)
 {
-	off64_t		soffset, doffset;
+	off_t		soffset, doffset;
 	long long	count = 0, total;
 	char		*infile = NULL;
 	int		condensed, quiet_flag;
diff --git a/io/seek.c b/io/seek.c
index d06375d..36403a3 100644
--- a/io/seek.c
+++ b/io/seek.c
@@ -75,8 +75,8 @@ void
 seek_output(
 	int	startflag,
 	char	*type,
-	off64_t	start,
-	off64_t	offset)
+	off_t	start,
+	off_t	offset)
 {
 	if (offset == -1) {
 		if (errno == ENXIO) {
@@ -104,7 +104,7 @@ seek_f(
 	int	argc,
 	char	**argv)
 {
-	off64_t		offset, start;
+	off_t		offset, start;
 	size_t		fsblocksize, fssectsize;
 	int		c;
 	int		current;	/* specify data or hole */
diff --git a/io/sendfile.c b/io/sendfile.c
index edd31c9..3463820 100644
--- a/io/sendfile.c
+++ b/io/sendfile.c
@@ -45,12 +45,12 @@ sendfile_help(void)
 
 static int
 send_buffer(
-	off64_t		offset,
+	off_t		offset,
 	size_t		count,
 	int		fd,
 	long long	*total)
 {
-	off64_t		off = offset;
+	off_t		off = offset;
 	ssize_t		bytes, bytes_remaining = count;
 	int		ops = 0;
 
@@ -77,7 +77,7 @@ sendfile_f(
 	int		argc,
 	char		**argv)
 {
-	off64_t		offset = 0;
+	off_t		offset = 0;
 	long long	count, total;
 	size_t		blocksize, sectsize;
 	struct timeval	t1, t2;
diff --git a/io/sync_file_range.c b/io/sync_file_range.c
index 7e4f3e6..3b1f9c2 100644
--- a/io/sync_file_range.c
+++ b/io/sync_file_range.c
@@ -42,7 +42,7 @@ sync_range_f(
 	int		argc,
 	char		**argv)
 {
-	off64_t		offset = 0, length = 0;
+	off_t		offset = 0, length = 0;
 	int		c, sync_mode = 0;
 	size_t		blocksize, sectsize;
 
diff --git a/io/truncate.c b/io/truncate.c
index 20bada8..480574a 100644
--- a/io/truncate.c
+++ b/io/truncate.c
@@ -28,7 +28,7 @@ truncate_f(
 	int		argc,
 	char		**argv)
 {
-	off64_t		offset;
+	off_t		offset;
 	size_t		blocksize, sectsize;
 
 	init_cvtnum(&blocksize, &sectsize);
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 8e9d86a..265f26a 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -911,7 +911,7 @@ libxfs_balloc(cache_key_t key)
 
 
 static int
-__read_buf(int fd, void *buf, int len, off64_t offset, int flags)
+__read_buf(int fd, void *buf, int len, off_t offset, int flags)
 {
 	int	sts;
 
@@ -1024,7 +1024,7 @@ libxfs_readbufr_map(struct xfs_buftarg *btp, struct xfs_buf *bp, int flags)
 	fd = libxfs_device_to_fd(btp->dev);
 	buf = bp->b_addr;
 	for (i = 0; i < bp->b_nmaps; i++) {
-		off64_t	offset = LIBXFS_BBTOOFF64(bp->b_map[i].bm_bn);
+		off_t	offset = LIBXFS_BBTOOFF64(bp->b_map[i].bm_bn);
 		int len = BBTOB(bp->b_map[i].bm_len);
 
 		error = __read_buf(fd, buf, len, offset, flags);
@@ -1079,7 +1079,7 @@ libxfs_readbuf_map(struct xfs_buftarg *btp, struct xfs_buf_map *map, int nmaps,
 }
 
 static int
-__write_buf(int fd, void *buf, int len, off64_t offset, int flags)
+__write_buf(int fd, void *buf, int len, off_t offset, int flags)
 {
 	int	sts;
 
@@ -1142,7 +1142,7 @@ libxfs_writebufr(xfs_buf_t *bp)
 		char	*buf = bp->b_addr;
 
 		for (i = 0; i < bp->b_nmaps; i++) {
-			off64_t	offset = LIBXFS_BBTOOFF64(bp->b_map[i].bm_bn);
+			off_t	offset = LIBXFS_BBTOOFF64(bp->b_map[i].bm_bn);
 			int len = BBTOB(bp->b_map[i].bm_len);
 
 			bp->b_error = __write_buf(fd, buf, len, offset,
diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index 0d399f1..e1d8b6b 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -131,7 +131,7 @@ perform_restore(
 		/* ensure device is sufficiently large enough */
 
 		char		*lb[XFS_MAX_SECTORSIZE] = { NULL };
-		off64_t		off;
+		off_t		off;
 
 		off = sb.sb_dblocks * sb.sb_blocksize - sizeof(lb);
 		if (pwrite(dst_fd, lb, sizeof(lb), off) < 0)
diff --git a/repair/prefetch.c b/repair/prefetch.c
index 175594c..318cea1 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -465,7 +465,7 @@ pf_batch_read(
 {
 	xfs_buf_t		*bplist[MAX_BUFS];
 	unsigned int		num;
-	off64_t			first_off, last_off, next_off;
+	off_t			first_off, last_off, next_off;
 	int			len, size;
 	int			i;
 	int			inode_bufs;
-- 
2.7.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
