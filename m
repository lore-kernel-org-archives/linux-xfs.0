Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 327167F53
	for <xfs@oss.sgi.com>; Fri,  3 Oct 2014 17:14:20 -0500 (CDT)
Date: Fri, 3 Oct 2014 17:14:19 -0500
From: Ben Myers <bpm@sgi.com>
Subject: [PATCH 29/35] libxfs: rename XFS_IOC_FSGEOM to XFS_IOC_FSGEOM_V2
Message-ID: <20141003221419.GC1865@sgi.com>
References: <20141003214758.GY1865@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141003214758.GY1865@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-fsdevel@vger.kernel.org
Cc: olaf@sgi.com, xfs@oss.sgi.com

From: Ben Myers <bpm@sgi.com>

We'll be creating a new versioned XFS_IOC_FSGEOMETRY ioctl and structure
so rename the current revision to _V2.

Signed-off-by: Ben Myers <bpm@sgi.com>
---
 growfs/xfs_growfs.c |  8 ++++----
 include/xfs_fs.h    |  8 ++++----
 io/bmap.c           |  2 +-
 io/init.c           |  2 +-
 io/io.h             |  6 +++---
 io/open.c           | 10 +++++-----
 quota/free.c        |  2 +-
 7 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/growfs/xfs_growfs.c b/growfs/xfs_growfs.c
index 8e611b6..c3df0c0 100644
--- a/growfs/xfs_growfs.c
+++ b/growfs/xfs_growfs.c
@@ -44,7 +44,7 @@ Options:\n\
 
 void
 report_info(
-	xfs_fsop_geom_t	geo,
+	xfs_fsop_geom_v2_t	geo,
 	char		*mntpoint,
 	int		isint,
 	char		*logname,
@@ -101,7 +101,7 @@ main(int argc, char **argv)
 	int			error;	/* we have hit an error */
 	long			esize;	/* new rt extent size */
 	int			ffd;	/* mount point file descriptor */
-	xfs_fsop_geom_t		geo;	/* current fs geometry */
+	xfs_fsop_geom_v2_t	geo;	/* current fs geometry */
 	int			iflag;	/* -i flag */
 	int			isint;	/* log is currently internal */
 	int			lflag;	/* -l flag */
@@ -109,7 +109,7 @@ main(int argc, char **argv)
 	int			maxpct;	/* -m flag value */
 	int			mflag;	/* -m flag */
 	int			nflag;	/* -n flag */
-	xfs_fsop_geom_t		ngeo;	/* new fs geometry */
+	xfs_fsop_geom_v2_t	ngeo;	/* new fs geometry */
 	int			rflag;	/* -r flag */
 	long long		rsize;	/* new rt size in fs blocks */
 	int			ci;	/* ASCII case-insensitive fs */
@@ -220,7 +220,7 @@ main(int argc, char **argv)
 	}
 
 	/* get the current filesystem size & geometry */
-	if (xfsctl(fname, ffd, XFS_IOC_FSGEOMETRY, &geo) < 0) {
+	if (xfsctl(fname, ffd, XFS_IOC_FSGEOMETRY_V2, &geo) < 0) {
 		/*
 		 * OK, new xfsctl barfed - back off and try earlier version
 		 * as we're probably running an older kernel version.
diff --git a/include/xfs_fs.h b/include/xfs_fs.h
index c260ec6..38faf5d 100644
--- a/include/xfs_fs.h
+++ b/include/xfs_fs.h
@@ -180,9 +180,9 @@ typedef struct xfs_fsop_geom_v1 {
 } xfs_fsop_geom_v1_t;
 
 /*
- * Output for XFS_IOC_FSGEOMETRY
+ * Output for XFS_IOC_FSGEOMETRY_V2
  */
-typedef struct xfs_fsop_geom {
+typedef struct xfs_fsop_geom_v2 {
 	__u32		blocksize;	/* filesystem (data) block size */
 	__u32		rtextsize;	/* realtime extent size		*/
 	__u32		agblocks;	/* fsblocks in an AG		*/
@@ -204,7 +204,7 @@ typedef struct xfs_fsop_geom {
 	__u32		rtsectsize;	/* realtime sector size, bytes	*/
 	__u32		dirblocksize;	/* directory block size, bytes	*/
 	__u32		logsunit;	/* log stripe unit, bytes */
-} xfs_fsop_geom_t;
+} xfs_fsop_geom_v2_t;
 
 /* Output for XFS_FS_COUNTS */
 typedef struct xfs_fsop_counts {
@@ -553,7 +553,7 @@ typedef struct xfs_swapext
 #define XFS_IOC_FSSETDM_BY_HANDLE    _IOW ('X', 121, struct xfs_fsop_setdm_handlereq)
 #define XFS_IOC_ATTRLIST_BY_HANDLE   _IOW ('X', 122, struct xfs_fsop_attrlist_handlereq)
 #define XFS_IOC_ATTRMULTI_BY_HANDLE  _IOW ('X', 123, struct xfs_fsop_attrmulti_handlereq)
-#define XFS_IOC_FSGEOMETRY	     _IOR ('X', 124, struct xfs_fsop_geom)
+#define XFS_IOC_FSGEOMETRY_V2	     _IOR ('X', 124, struct xfs_fsop_geom_v2)
 #define XFS_IOC_GOINGDOWN	     _IOR ('X', 125, __uint32_t)
 /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
 
diff --git a/io/bmap.c b/io/bmap.c
index a78cbb1..614eba1 100644
--- a/io/bmap.c
+++ b/io/bmap.c
@@ -70,7 +70,7 @@ bmap_f(
 {
 	struct fsxattr		fsx;
 	struct getbmapx		*map;
-	struct xfs_fsop_geom	fsgeo;
+	struct xfs_fsop_geom_v2	fsgeo;
 	int			map_size;
 	int			loop = 0;
 	int			flg = 0;
diff --git a/io/init.c b/io/init.c
index bfc35bf..9622a6c 100644
--- a/io/init.c
+++ b/io/init.c
@@ -127,7 +127,7 @@ init(
 	int		c, flags = 0;
 	char		*sp;
 	mode_t		mode = 0600;
-	xfs_fsop_geom_t	geometry = { 0 };
+	xfs_fsop_geom_v2_t	geometry = { 0 };
 
 	progname = basename(argv[0]);
 	setlocale(LC_ALL, "");
diff --git a/io/io.h b/io/io.h
index 1b3bca1..1837fe4 100644
--- a/io/io.h
+++ b/io/io.h
@@ -44,7 +44,7 @@ typedef struct fileio {
 	int		fd;		/* open file descriptor */
 	int		flags;		/* flags describing file state */
 	char		*name;		/* file name at time of open */
-	xfs_fsop_geom_t	geom;		/* XFS filesystem geometry */
+	xfs_fsop_geom_v2_t	geom;	/* XFS filesystem geometry */
 } fileio_t;
 
 extern fileio_t		*filetable;	/* open file table */
@@ -74,8 +74,8 @@ extern void *check_mapping_range(mmap_region_t *, off64_t, size_t, int);
  */
 
 extern off64_t		filesize(void);
-extern int		openfile(char *, xfs_fsop_geom_t *, int, mode_t);
-extern int		addfile(char *, int , xfs_fsop_geom_t *, int);
+extern int		openfile(char *, xfs_fsop_geom_v2_t *, int, mode_t);
+extern int		addfile(char *, int , xfs_fsop_geom_v2_t *, int);
 extern void		printxattr(uint, int, int, const char *, int, int);
 
 extern unsigned int	recurse_all;
diff --git a/io/open.c b/io/open.c
index c106fa7..81c19c9 100644
--- a/io/open.c
+++ b/io/open.c
@@ -140,7 +140,7 @@ stat_f(
 int
 openfile(
 	char		*path,
-	xfs_fsop_geom_t	*geom,
+	xfs_fsop_geom_v2_t	*geom,
 	int		flags,
 	mode_t		mode)
 {
@@ -185,7 +185,7 @@ openfile(
 	if (!geom || !platform_test_xfs_fd(fd))
 		return fd;
 
-	if (xfsctl(path, fd, XFS_IOC_FSGEOMETRY, geom) < 0) {
+	if (xfsctl(path, fd, XFS_IOC_FSGEOMETRY_V2, geom) < 0) {
 		perror("XFS_IOC_FSGEOMETRY");
 		close(fd);
 		return -1;
@@ -215,7 +215,7 @@ int
 addfile(
 	char		*name,
 	int		fd,
-	xfs_fsop_geom_t	*geometry,
+	xfs_fsop_geom_v2_t	*geometry,
 	int		flags)
 {
 	char		*filename;
@@ -284,7 +284,7 @@ open_f(
 	int		c, fd, flags = 0;
 	char		*sp;
 	mode_t		mode = 0600;
-	xfs_fsop_geom_t	geometry = { 0 };
+	xfs_fsop_geom_v2_t	geometry = { 0 };
 
 	if (argc == 1) {
 		if (file)
@@ -701,7 +701,7 @@ statfs_f(
 	char			**argv)
 {
 	struct xfs_fsop_counts	fscounts;
-	struct xfs_fsop_geom	fsgeo;
+	struct xfs_fsop_geom_v2	fsgeo;
 	struct statfs		st;
 
 	printf(_("fd.path = \"%s\"\n"), file->name);
diff --git a/quota/free.c b/quota/free.c
index 79b52e9..b2e325b 100644
--- a/quota/free.c
+++ b/quota/free.c
@@ -59,7 +59,7 @@ mount_free_space_data(
 	__uint64_t		*rfree)
 {
 	struct xfs_fsop_counts	fscounts;
-	struct xfs_fsop_geom	fsgeo;
+	struct xfs_fsop_geom_v2	fsgeo;
 	struct statfs		st;
 	__uint64_t		logsize, count, free;
 	int			fd;
-- 
1.7.12.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
