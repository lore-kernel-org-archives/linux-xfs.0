Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BFEDB7F47
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2015 11:23:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A2CC930406B
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2015 09:23:57 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id WNVXuDRmdncTIET1 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 17 Aug 2015 09:23:56 -0700 (PDT)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 08/11] xfsprogs: replace obsolete memalign with posix_memalign
Date: Mon, 17 Aug 2015 18:23:23 +0200
Message-Id: <1439828606-7886-9-git-send-email-jtulak@redhat.com>
In-Reply-To: <1439828606-7886-1-git-send-email-jtulak@redhat.com>
References: <1439828606-7886-1-git-send-email-jtulak@redhat.com>
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
Cc: hch@infradead.org, Jan Tulak <jtulak@redhat.com>

Memalign from <malloc.h> was marked obsolete in favor of a posix
variant from <stdlib.h>. So replace all calls and remove <malloc.h>
includes. This also enhances support on other posix platforms,
which doesn't have <malloc.h>.

Because posix_memalign returns any error as a return code, not in
errno, change relevant checks in code (and add a missing one).

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 copy/xfs_copy.c       |  2 +-
 db/attrset.c          |  2 +-
 fsr/xfs_fsr.c         |  3 ++-
 include/darwin.h      |  1 -
 include/freebsd.h     |  1 -
 include/gnukfreebsd.h |  1 -
 include/linux.h       |  1 -
 io/pread.c            |  4 ++--
 libxfs/rdwr.c         | 12 ++++++++----
 mkfs/xfs_mkfs.c       |  3 ++-
 repair/incore.c       |  2 +-
 repair/incore_ino.c   |  7 ++++---
 repair/phase1.c       |  2 +-
 repair/prefetch.c     |  7 +++----
 repair/sb.c           | 10 +++++-----
 rtcp/xfs_rtcp.c       |  7 ++++++-
 16 files changed, 36 insertions(+), 29 deletions(-)

diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index e13f468..8109ac5 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -333,7 +333,7 @@ wbuf *
 wbuf_init(wbuf *buf, int data_size, int data_align, int min_io_size, int id)
 {
 	ASSERT(data_size % BBSIZE == 0);
-	while ((buf->data = memalign(data_align, data_size)) == NULL) {
+	while (posix_memalign((void**)&(buf->data), data_align, data_size)) {
 		data_size >>= 1;
 		if (data_size < min_io_size)
 			return NULL;
diff --git a/db/attrset.c b/db/attrset.c
index ec9da5a..539765f 100644
--- a/db/attrset.c
+++ b/db/attrset.c
@@ -141,7 +141,7 @@ attr_set_f(
 	name = argv[optind];
 
 	if (valuelen) {
-		value = (char *)memalign(getpagesize(), valuelen);
+		posix_memalign((void**)&value, getpagesize(), valuelen);
 		if (!value) {
 			dbprintf(_("cannot allocate buffer (%d)\n"), valuelen);
 			goto out;
diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index 4912b73..ad52990 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -1306,7 +1306,8 @@ packfile(char *fname, char *tname, int fd,
 			dio.d_maxiosz, pagesize);
 	}
 
-	if (!(fbuf = (char *)memalign(dio.d_mem, blksz_dio))) {
+	posix_memalign((void **)&fbuf, dio.d_mem, blksz_dio);
+	if (!fbuf) {
 		fsrprintf(_("could not allocate buf: %s\n"), tname);
 		goto out;
 	}
diff --git a/include/darwin.h b/include/darwin.h
index 775dfc8..e3ec863 100644
--- a/include/darwin.h
+++ b/include/darwin.h
@@ -141,7 +141,6 @@ typedef int64_t		xfs_daddr_t;
 #define pwrite64	pwrite
 #define ftruncate64	ftruncate
 #define fdatasync	fsync
-#define memalign(a,sz)	valloc(sz)
 
 #define O_LARGEFILE     0
 #ifndef O_DIRECT
diff --git a/include/freebsd.h b/include/freebsd.h
index 902b940..7289159 100644
--- a/include/freebsd.h
+++ b/include/freebsd.h
@@ -40,7 +40,6 @@
 #define pwrite64	pwrite
 #define pread64		pread
 #define fdatasync	fsync
-#define memalign(a,sz)	valloc(sz)
 
 #define constpp	char * const *
 
diff --git a/include/gnukfreebsd.h b/include/gnukfreebsd.h
index 95c4c13..4605234 100644
--- a/include/gnukfreebsd.h
+++ b/include/gnukfreebsd.h
@@ -22,7 +22,6 @@
 #include <sys/vfs.h>
 #include <sys/ioctl.h>
 #include <sys/sysmacros.h>
-#include <malloc.h>
 #include <getopt.h>
 #include <endian.h>
 #include <sys/stat.h>
diff --git a/include/linux.h b/include/linux.h
index 8804c2d..7493b76 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -24,7 +24,6 @@
 #include <sys/sysmacros.h>
 #include <sys/stat.h>
 #include <inttypes.h>
-#include <malloc.h>
 #include <getopt.h>
 #include <errno.h>
 #include <endian.h>
diff --git a/io/pread.c b/io/pread.c
index 1c77c41..74ba47e 100644
--- a/io/pread.c
+++ b/io/pread.c
@@ -77,7 +77,7 @@ alloc_iovec(
 
 	buffersize = 0;
 	for (i = 0; i < vectors; i++) {
-		iov[i].iov_base = memalign(pagesize, bsize);
+		posix_memalign((void**)&(iov[i].iov_base), pagesize, bsize);
 		if (!iov[i].iov_base) {
 			perror("memalign");
 			goto unwind;
@@ -108,7 +108,7 @@ alloc_buffer(
 	if (bsize > highwater) {
 		if (buffer)
 			free(buffer);
-		buffer = memalign(pagesize, bsize);
+		posix_memalign((void**)&buffer, pagesize, bsize);
 		if (!buffer) {
 			perror("memalign");
 			highwater = buffersize = 0;
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 4f8212f..7884cf8 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -74,12 +74,14 @@ libxfs_device_zero(struct xfs_buftarg *btp, xfs_daddr_t start, uint len)
 	ssize_t		zsize, bytes;
 	char		*z;
 	int		fd;
+	int ret;
 
 	zsize = min(BDSTRAT_SIZE, BBTOB(len));
-	if ((z = memalign(libxfs_device_alignment(), zsize)) == NULL) {
+	ret = posix_memalign((void **)&z, libxfs_device_alignment(), zsize);
+	if (!z) {
 		fprintf(stderr,
 			_("%s: %s can't memalign %d bytes: %s\n"),
-			progname, __FUNCTION__, (int)zsize, strerror(errno));
+			progname, __FUNCTION__, (int)zsize, strerror(ret));
 		exit(1);
 	}
 	memset(z, 0, zsize);
@@ -409,6 +411,7 @@ static void
 __initbuf(xfs_buf_t *bp, struct xfs_buftarg *btp, xfs_daddr_t bno,
 		unsigned int bytes)
 {
+	int ret;
 	bp->b_flags = 0;
 	bp->b_bn = bno;
 	bp->b_bcount = bytes;
@@ -416,12 +419,13 @@ __initbuf(xfs_buf_t *bp, struct xfs_buftarg *btp, xfs_daddr_t bno,
 	bp->b_target = btp;
 	bp->b_error = 0;
 	if (!bp->b_addr)
-		bp->b_addr = memalign(libxfs_device_alignment(), bytes);
+		ret = posix_memalign((void**)&(bp->b_addr),
+					libxfs_device_alignment(), bytes);
 	if (!bp->b_addr) {
 		fprintf(stderr,
 			_("%s: %s can't memalign %u bytes: %s\n"),
 			progname, __FUNCTION__, bytes,
-			strerror(errno));
+			strerror(ret));
 		exit(1);
 	}
 	memset(bp->b_addr, 0, bytes);
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 69d61c7..d349b4f 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -770,7 +770,8 @@ zero_old_xfs_structures(
 	 * read in existing filesystem superblock, use its geometry
 	 * settings and zero the existing secondary superblocks.
 	 */
-	buf = memalign(libxfs_device_alignment(), new_sb->sb_sectsize);
+	posix_memalign((void**)&buf, libxfs_device_alignment(),
+		       new_sb->sb_sectsize);
 	if (!buf) {
 		fprintf(stderr,
 	_("error reading existing superblock -- failed to memalign buffer\n"));
diff --git a/repair/incore.c b/repair/incore.c
index cb57316..81d3b8c 100644
--- a/repair/incore.c
+++ b/repair/incore.c
@@ -224,7 +224,7 @@ init_rt_bmap(
 	rt_bmap_size = roundup(mp->m_sb.sb_rextents / (NBBY / XR_BB),
 			       sizeof(__uint64_t));
 
-	rt_bmap = memalign(sizeof(__uint64_t), rt_bmap_size);
+	posix_memalign((void**)&rt_bmap, sizeof(__uint64_t), rt_bmap_size);
 	if (!rt_bmap) {
 		do_error(
 	_("couldn't allocate realtime block map, size = %" PRIu64 "\n"),
diff --git a/repair/incore_ino.c b/repair/incore_ino.c
index 32d7678..dd95996 100644
--- a/repair/incore_ino.c
+++ b/repair/incore_ino.c
@@ -626,8 +626,8 @@ set_inode_parent(
 			irec->ino_un.plist = ptbl;
 
 		ptbl->pmask = 1LL << offset;
-		ptbl->pentries = (xfs_ino_t*)memalign(sizeof(xfs_ino_t),
-							sizeof(xfs_ino_t));
+		posix_memalign((void**)&(ptbl->pentries),sizeof(xfs_ino_t),
+				sizeof(xfs_ino_t));
 		if (!ptbl->pentries)
 			do_error(_("couldn't memalign pentries table\n"));
 #ifdef DEBUG
@@ -673,7 +673,8 @@ set_inode_parent(
 #endif
 	ASSERT(cnt >= target);
 
-	tmp = (xfs_ino_t*)memalign(sizeof(xfs_ino_t), (cnt + 1) * sizeof(xfs_ino_t));
+	posix_memalign((void**)&tmp, sizeof(xfs_ino_t),
+		       (cnt + 1) * sizeof(xfs_ino_t));
 	if (!tmp)
 		do_error(_("couldn't memalign pentries table\n"));
 
diff --git a/repair/phase1.c b/repair/phase1.c
index 126d0b3..7a1fc7d 100644
--- a/repair/phase1.c
+++ b/repair/phase1.c
@@ -35,7 +35,7 @@ alloc_ag_buf(int size)
 {
 	char	*bp;
 
-	bp = (char *)memalign(libxfs_device_alignment(), size);
+	posix_memalign((void**)&bp, libxfs_device_alignment(), size);
 	if (!bp)
 		do_error(_("could not allocate ag header buffer (%d bytes)\n"),
 			size);
diff --git a/repair/prefetch.c b/repair/prefetch.c
index 8b261ae..c6c9450 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -631,10 +631,9 @@ pf_io_worker(
 	void			*param)
 {
 	prefetch_args_t		*args = param;
-	void			*buf = memalign(libxfs_device_alignment(),
-						pf_max_bytes);
-
-	if (buf == NULL)
+	void			*buf;
+	posix_memalign((void**)&buf, libxfs_device_alignment(), pf_max_bytes);
+	if (!buf)
 		return NULL;
 
 	pthread_mutex_lock(&args->lock);
diff --git a/repair/sb.c b/repair/sb.c
index 4eef14a..cf1ea8b 100644
--- a/repair/sb.c
+++ b/repair/sb.c
@@ -102,7 +102,7 @@ find_secondary_sb(xfs_sb_t *rsb)
 
 	do_warn(_("\nattempting to find secondary superblock...\n"));
 
-	sb = (xfs_sb_t *)memalign(libxfs_device_alignment(), BSIZE);
+	posix_memalign((void**)&sb, libxfs_device_alignment(), BSIZE);
 	if (!sb) {
 		do_error(
 	_("error finding secondary superblock -- failed to memalign buffer\n"));
@@ -438,8 +438,8 @@ write_primary_sb(xfs_sb_t *sbp, int size)
 	if (no_modify)
 		return;
 
-	buf = memalign(libxfs_device_alignment(), size);
-	if (buf == NULL) {
+	posix_memalign((void**)&buf, libxfs_device_alignment(), size);
+	if (!buf) {
 		do_error(_("failed to memalign superblock buffer\n"));
 		return;
 	}
@@ -472,8 +472,8 @@ get_sb(xfs_sb_t *sbp, xfs_off_t off, int size, xfs_agnumber_t agno)
 	int error, rval;
 	xfs_dsb_t *buf;
 
-	buf = memalign(libxfs_device_alignment(), size);
-	if (buf == NULL) {
+	posix_memalign((void**)&buf, libxfs_device_alignment(), size);
+	if (!buf) {
 		do_error(
 	_("error reading superblock %u -- failed to memalign buffer\n"),
 			agno);
diff --git a/rtcp/xfs_rtcp.c b/rtcp/xfs_rtcp.c
index f604b46..e2e3ece 100644
--- a/rtcp/xfs_rtcp.c
+++ b/rtcp/xfs_rtcp.c
@@ -327,7 +327,12 @@ rtcp( char *source, char *target, int fextsize)
 	}
 
 	iosz =  dioattr.d_miniosz;
-	fbuf = memalign( dioattr.d_mem, iosz);
+	posix_memalign((void**)&fbuf, dioattr.d_mem, iosz);
+	if (!fbuf) {
+		perror(
+	_("error finding secondary superblock -- failed to memalign buffer\n"));
+		exit(1);
+	}
 	memset(fbuf, 0, iosz);
 
 	/*
-- 
2.4.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
