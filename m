Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:48106 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727599AbeJELAN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 5 Oct 2018 07:00:13 -0400
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 10/15] xfsprogs: make static things static
Date: Thu,  4 Oct 2018 23:03:11 -0500
Message-Id: <1538712196-13625-11-git-send-email-sandeen@sandeen.net>
In-Reply-To: <1538712196-13625-1-git-send-email-sandeen@sandeen.net>
References: <1538712196-13625-1-git-send-email-sandeen@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Eric Sandeen <sandeen@redhat.com>

There are tons of functions which can be static, make them so.

Fixes many sparse warnings about this.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---
 copy/xfs_copy.c           | 66 +++++++++++++++++++++++------------------------
 db/btblock.c              |  2 +-
 db/check.c                |  4 +--
 db/fsmap.c                |  2 +-
 db/init.c                 |  8 +++---
 db/input.c                |  6 ++---
 db/io.c                   |  2 +-
 db/logformat.c            |  2 +-
 estimate/xfs_estimate.c   | 34 ++++++++++++------------
 fsr/xfs_fsr.c             | 40 ++++++++++++++--------------
 io/bmap.c                 |  2 +-
 io/fiemap.c               |  2 +-
 io/freeze.c               |  4 +--
 io/fsmap.c                |  2 +-
 io/imap.c                 |  2 +-
 io/init.c                 | 10 +++----
 io/madvise.c              |  2 +-
 io/mincore.c              |  2 +-
 io/mmap.c                 | 10 +++----
 io/parent.c               |  2 +-
 io/readdir.c              |  2 +-
 io/seek.c                 |  4 +--
 io/stat.c                 |  8 +++---
 libxcmd/command.c         |  4 +--
 libxfs/cache.c            |  2 +-
 libxfs/init.c             |  2 +-
 libxfs/rdwr.c             |  6 ++---
 libxfs/util.c             |  6 ++---
 logprint/log_misc.c       | 34 ++++++++++++------------
 logprint/log_print_all.c  |  2 +-
 logprint/logprint.c       |  6 ++---
 mdrestore/xfs_mdrestore.c |  6 ++---
 mkfs/xfs_mkfs.c           | 26 +++++++++----------
 repair/btree.c            |  2 +-
 repair/incore_ext.c       | 10 +++----
 repair/incore_ino.c       |  4 +--
 repair/phase6.c           |  2 +-
 repair/progress.c         |  2 +-
 repair/sb.c               |  2 +-
 repair/scan.c             |  2 +-
 rtcp/xfs_rtcp.c           |  4 +--
 scrub/scrub.c             |  2 +-
 spaceman/init.c           |  4 +--
 43 files changed, 174 insertions(+), 172 deletions(-)

diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index 5fbc0f3..3f6535c 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -18,33 +18,32 @@
 
 extern int	platform_check_ismounted(char *, char *, struct stat *, int);
 
-int		logfd;
-char 		*logfile_name;
-FILE		*logerr;
-char		LOGFILE_NAME[] = "/var/tmp/xfs_copy.log.XXXXXX";
+static char 		*logfile_name;
+static FILE		*logerr;
+static char		LOGFILE_NAME[] = "/var/tmp/xfs_copy.log.XXXXXX";
 
-char		*source_name;
-int		source_fd;
+static char		*source_name;
+static int		source_fd;
 
-unsigned int	source_blocksize;	/* source filesystem blocksize */
-unsigned int	source_sectorsize;	/* source disk sectorsize */
+static unsigned int	source_blocksize;	/* source filesystem blocksize */
+static unsigned int	source_sectorsize;	/* source disk sectorsize */
 
-xfs_agblock_t	first_agbno;
+static xfs_agblock_t	first_agbno;
 
-uint64_t	barcount[11];
+static uint64_t	barcount[11];
 
-unsigned int	num_targets;
-target_control	*target;
+static unsigned int	num_targets;
+static target_control	*target;
 
-wbuf		w_buf;
-wbuf		btree_buf;
+static wbuf		w_buf;
+static wbuf		btree_buf;
 
-unsigned int	kids;
+static unsigned int	kids;
 
-thread_control	glob_masks;
-thread_args	*targ;
+static thread_control	glob_masks;
+static thread_args	*targ;
 
-pthread_mutex_t	mainwait;
+static pthread_mutex_t	mainwait;
 
 #define ACTIVE		1
 #define INACTIVE	2
@@ -61,7 +60,7 @@ static int	format_logs(struct xfs_mount *);
 #define PRE	0x08		/* append strerror string */
 #define LAST	0x10		/* final message we print */
 
-void
+static void
 signal_maskfunc(int addset, int newset)
 {
 	sigset_t set;
@@ -71,7 +70,7 @@ signal_maskfunc(int addset, int newset)
 	sigprocmask(newset, &set, NULL);
 }
 
-void
+static void
 do_message(int flags, int code, const char *fmt, ...)
 {
 	va_list	ap;
@@ -133,7 +132,7 @@ int xlog_recover_do_trans(struct xlog *log, struct xlog_recover *t, int p)
 	return 0;
 }
 
-void
+static void
 check_errors(void)
 {
 	int	i, first_error = 0;
@@ -167,7 +166,7 @@ check_errors(void)
  * don't have to worry about alignment and mins because those
  * are taken care of when the buffer's read in
  */
-int
+static int
 do_write(
 	thread_args	*args,
 	wbuf		*buf)
@@ -200,7 +199,7 @@ do_write(
 	return error;
 }
 
-void *
+static void *
 begin_reader(void *arg)
 {
 	thread_args	*args = arg;
@@ -228,7 +227,7 @@ handle_error:
 	return NULL;
 }
 
-void
+static void
 handler(int sig)
 {
 	pid_t	pid;
@@ -290,7 +289,7 @@ handler(int sig)
 	signal(SIGCHLD, handler);
 }
 
-void
+static void
 usage(void)
 {
 	fprintf(stderr,
@@ -299,7 +298,7 @@ usage(void)
 	exit(1);
 }
 
-void
+static void
 init_bar(uint64_t source_blocks)
 {
 	int	i;
@@ -308,7 +307,7 @@ init_bar(uint64_t source_blocks)
 		barcount[i] = (source_blocks/10)*i;
 }
 
-int
+static int
 bump_bar(int tenths, uint64_t numblocks)
 {
 	static char *bar[11] = {
@@ -340,7 +339,7 @@ bump_bar(int tenths, uint64_t numblocks)
 
 static xfs_off_t source_position = -1;
 
-wbuf *
+static wbuf *
 wbuf_init(wbuf *buf, int data_size, int data_align, int min_io_size, int id)
 {
 	ASSERT(data_size % BBSIZE == 0);
@@ -357,7 +356,7 @@ wbuf_init(wbuf *buf, int data_size, int data_align, int min_io_size, int id)
 	return buf;
 }
 
-void
+static void
 read_wbuf(int fd, wbuf *buf, xfs_mount_t *mp)
 {
 	int		res = 0;
@@ -412,7 +411,7 @@ read_wbuf(int fd, wbuf *buf, xfs_mount_t *mp)
 	buf->length = res;
 }
 
-void
+static void
 read_ag_header(int fd, xfs_agnumber_t agno, wbuf *buf, ag_header_t *ag,
 		xfs_mount_t *mp, int blocksize, int sectorsize)
 {
@@ -459,7 +458,7 @@ read_ag_header(int fd, xfs_agnumber_t agno, wbuf *buf, ag_header_t *ag,
 }
 
 
-void
+static void
 write_wbuf(void)
 {
 	int		i;
@@ -491,7 +490,7 @@ write_wbuf(void)
 	signal_maskfunc(SIGCHLD, SIG_BLOCK);
 }
 
-void
+static void
 sb_update_uuid(
 	xfs_sb_t	*sb,		/* Original fs superblock */
 	ag_header_t	*ag_hdr,	/* AG hdr to update for this copy */
@@ -528,6 +527,7 @@ int
 main(int argc, char **argv)
 {
 	int		i, j;
+	int		logfd;
 	int		howfar = 0;
 	int		open_flags;
 	xfs_off_t	pos;
@@ -1205,7 +1205,7 @@ main(int argc, char **argv)
 	return 0;
 }
 
-char *
+static char *
 next_log_chunk(char *p, int offset, void *private)
 {
 	wbuf	*buf = (wbuf *)private;
diff --git a/db/btblock.c b/db/btblock.c
index cbd2990..af42bf7 100644
--- a/db/btblock.c
+++ b/db/btblock.c
@@ -19,7 +19,7 @@
 /*
  * Definition of the possible btree block layouts.
  */
-struct xfs_db_btree {
+static struct xfs_db_btree {
 	uint32_t		magic;
 	size_t			block_len;
 	size_t			key_len;
diff --git a/db/check.c b/db/check.c
index 76a833a..754441c 100644
--- a/db/check.c
+++ b/db/check.c
@@ -996,7 +996,7 @@ blocktrash_b(
 		bit_offset / NBBY, bit_offset % NBBY, modestr[mode]);
 }
 
-int
+static int
 blocktrash_f(
 	int		argc,
 	char		**argv)
@@ -1204,7 +1204,7 @@ out:
 	return 0;
 }
 
-int
+static int
 blockuse_f(
 	int		argc,
 	char		**argv)
diff --git a/db/fsmap.c b/db/fsmap.c
index 4836381..29f3827 100644
--- a/db/fsmap.c
+++ b/db/fsmap.c
@@ -99,7 +99,7 @@ fsmap(
 	}
 }
 
-int
+static int
 fsmap_f(
 	int			argc,
 	char			**argv)
diff --git a/db/init.c b/db/init.c
index a70b02b..455220a 100644
--- a/db/init.c
+++ b/db/init.c
@@ -23,10 +23,10 @@ char			*fsdevice;
 int			blkbb;
 int			exitcode;
 int			expert_mode;
-int			force;
-struct xfs_mount	xmount;
+static int		force;
+static struct xfs_mount	xmount;
 struct xfs_mount	*mp;
-struct xlog		xlog;
+static struct xlog	xlog;
 libxfs_init_t		x;
 xfs_agnumber_t		cur_agno = NULLAGNUMBER;
 
@@ -39,7 +39,7 @@ usage(void)
 	exit(1);
 }
 
-void
+static void
 init(
 	int		argc,
 	char		**argv)
diff --git a/db/input.c b/db/input.c
index 9c59a56..4d6c737 100644
--- a/db/input.c
+++ b/db/input.c
@@ -20,9 +20,9 @@
 # include <histedit.h>
 #endif
 
-int	inputstacksize;
-FILE	**inputstack;
-FILE	*curinput;
+static int	inputstacksize;
+static FILE	**inputstack;
+static FILE	*curinput;
 
 static void	popfile(void);
 static int	source_f(int argc, char **argv);
diff --git a/db/io.c b/db/io.c
index 8c51b4d..0486ae2 100644
--- a/db/io.c
+++ b/db/io.c
@@ -155,7 +155,7 @@ print_iocur(
 		ioc->dirino, ioc->typ == NULL ? _("none") : ioc->typ->name);
 }
 
-void
+static void
 print_ring(void)
 {
 	int i;
diff --git a/db/logformat.c b/db/logformat.c
index 4bbab2a..42ce245 100644
--- a/db/logformat.c
+++ b/db/logformat.c
@@ -145,7 +145,7 @@ print_logres(
 		i, res->tr_logres, res->tr_logcount, res->tr_logflags);
 }
 
-int
+static int
 logres_f(
 	int			argc,
 	char			**argv)
diff --git a/estimate/xfs_estimate.c b/estimate/xfs_estimate.c
index eaa2cba..9e01cce 100644
--- a/estimate/xfs_estimate.c
+++ b/estimate/xfs_estimate.c
@@ -13,7 +13,7 @@
 #include <sys/stat.h>
 #include <ftw.h>
 
-unsigned long long
+static unsigned long long
 cvtnum(char *s)
 {
 	unsigned long long i;
@@ -43,22 +43,22 @@ int ffn(const char *, const struct stat *, int, struct FTW *);
 
 #define FBLOCKS(n)	((n)/blocksize)
 
-unsigned long long dirsize=0;		/* bytes */
-unsigned long long logsize=LOGSIZE*BLOCKSIZE;	/* bytes */
-unsigned long long fullblocks=0;	/* FS blocks */
-unsigned long long isize=0;		/* inodes bytes */
-unsigned long long blocksize=BLOCKSIZE;
-unsigned long long nslinks=0;		/* number of symbolic links */
-unsigned long long nfiles=0;		/* number of regular files */
-unsigned long long ndirs=0;		/* number of directories */
-unsigned long long nspecial=0;		/* number of special files */
-unsigned long long verbose=0;		/* verbose mode TRUE/FALSE */
-
-int __debug = 0;
-int ilog = 0;
-int elog = 0;
-
-void
+static unsigned long long dirsize=0;		/* bytes */
+static unsigned long long logsize=LOGSIZE*BLOCKSIZE;	/* bytes */
+static unsigned long long fullblocks=0;	/* FS blocks */
+static unsigned long long isize=0;		/* inodes bytes */
+static unsigned long long blocksize=BLOCKSIZE;
+static unsigned long long nslinks=0;		/* number of symbolic links */
+static unsigned long long nfiles=0;		/* number of regular files */
+static unsigned long long ndirs=0;		/* number of directories */
+static unsigned long long nspecial=0;		/* number of special files */
+static unsigned long long verbose=0;		/* verbose mode TRUE/FALSE */
+
+static int __debug = 0;
+static int ilog = 0;
+static  int elog = 0;
+
+static void
 usage(char *progname)
 {
 	fprintf(stderr,
diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index c8aea98..fef6262 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -28,21 +28,21 @@
 
 char *progname;
 
-int vflag;
-int gflag;
+static int vflag;
+static int gflag;
 static int Mflag;
 /* static int nflag; */
-int dflag = 0;
+static int dflag = 0;
 /* static int sflag; */
-int argv_blksz_dio;
+static int argv_blksz_dio;
 extern int max_ext_size;
 static int npasses = 10;
 static int startpass = 0;
 
-struct getbmap  *outmap = NULL;
-int             outmap_size = 0;
-int		RealUid;
-int		tmp_agi;
+static struct getbmap  *outmap = NULL;
+static int		outmap_size = 0;
+static int		RealUid;
+static int		tmp_agi;
 static int64_t		minimumfree = 2048;
 
 #define MNTTYPE_XFS             "xfs"
@@ -85,7 +85,7 @@ static char * tmp_next(char *mnt);
 static void tmp_close(char *mnt);
 int xfs_getgeom(int , xfs_fsop_geom_v1_t * );
 
-xfs_fsop_geom_v1_t fsgeom;	/* geometry of active mounted system */
+static xfs_fsop_geom_v1_t fsgeom;	/* geometry of active mounted system */
 
 #define NMOUNT 64
 static int numfs;
@@ -96,19 +96,19 @@ typedef struct fsdesc {
 	int  npass;
 } fsdesc_t;
 
-fsdesc_t	*fs, *fsbase, *fsend;
-int		fsbufsize = 10;	/* A starting value */
-int		nfrags = 0;	/* Debug option: Coerse into specific number
+static fsdesc_t	*fs, *fsbase, *fsend;
+static int	fsbufsize = 10;	/* A starting value */
+static int	nfrags = 0;	/* Debug option: Coerse into specific number
 				 * of extents */
-int		openopts = O_CREAT|O_EXCL|O_RDWR|O_DIRECT;
+static int	openopts = O_CREAT|O_EXCL|O_RDWR|O_DIRECT;
 
-int
+static int
 xfs_fsgeometry(int fd, xfs_fsop_geom_v1_t *geom)
 {
     return ioctl(fd, XFS_IOC_FSGEOMETRY_V1, geom);
 }
 
-int
+static int
 xfs_bulkstat_single(int fd, xfs_ino_t *lastip, xfs_bstat_t *ubuffer)
 {
     xfs_fsop_bulkreq_t  bulkreq;
@@ -120,7 +120,7 @@ xfs_bulkstat_single(int fd, xfs_ino_t *lastip, xfs_bstat_t *ubuffer)
     return ioctl(fd, XFS_IOC_FSBULKSTAT_SINGLE, &bulkreq);
 }
 
-int
+static int
 xfs_bulkstat(int fd, xfs_ino_t *lastip, int icount,
                     xfs_bstat_t *ubuffer, __s32 *ocount)
 {
@@ -133,19 +133,19 @@ xfs_bulkstat(int fd, xfs_ino_t *lastip, int icount,
     return ioctl(fd, XFS_IOC_FSBULKSTAT, &bulkreq);
 }
 
-int
+static int
 xfs_swapext(int fd, xfs_swapext_t *sx)
 {
     return ioctl(fd, XFS_IOC_SWAPEXT, sx);
 }
 
-int
+static int
 xfs_fscounts(int fd, xfs_fsop_counts_t *counts)
 {
     return ioctl(fd, XFS_IOC_FSCOUNTS, counts);
 }
 
-void
+static void
 aborter(int unused)
 {
 	fsrall_cleanup(1);
@@ -1586,7 +1586,7 @@ int	read_fd_bmap(int fd, xfs_bstat_t *sin, int *cur_nextents)
 /*
  * Read the block map and return the number of extents.
  */
-int
+static int
 getnextents(int fd)
 {
 	int		nextents;
diff --git a/io/bmap.c b/io/bmap.c
index f917831..d408826 100644
--- a/io/bmap.c
+++ b/io/bmap.c
@@ -43,7 +43,7 @@ bmap_help(void)
 "\n"));
 }
 
-int
+static int
 bmap_f(
 	int			argc,
 	char			**argv)
diff --git a/io/fiemap.c b/io/fiemap.c
index 8090dc4..485bae1 100644
--- a/io/fiemap.c
+++ b/io/fiemap.c
@@ -214,7 +214,7 @@ calc_print_format(
 	}
 }
 
-int
+static int
 fiemap_f(
 	int		argc,
 	char		**argv)
diff --git a/io/freeze.c b/io/freeze.c
index b52df91..3333b08 100644
--- a/io/freeze.c
+++ b/io/freeze.c
@@ -12,7 +12,7 @@
 static cmdinfo_t freeze_cmd;
 static cmdinfo_t thaw_cmd;
 
-int
+static int
 freeze_f(
 	int		argc,
 	char		**argv)
@@ -29,7 +29,7 @@ freeze_f(
 	return 0;
 }
 
-int
+static int
 thaw_f(
 	int		argc,
 	char		**argv)
diff --git a/io/fsmap.c b/io/fsmap.c
index 0bc8ae6..477c36f 100644
--- a/io/fsmap.c
+++ b/io/fsmap.c
@@ -364,7 +364,7 @@ dump_verbose_key(void)
 		NFLG+1, NFLG+1, FLG_ESW);
 }
 
-int
+static int
 fsmap_f(
 	int			argc,
 	char			**argv)
diff --git a/io/imap.c b/io/imap.c
index 048d1a4..fbc8e9e 100644
--- a/io/imap.c
+++ b/io/imap.c
@@ -11,7 +11,7 @@
 
 static cmdinfo_t imap_cmd;
 
-int
+static int
 imap_f(int argc, char **argv)
 {
 	int		count;
diff --git a/io/init.c b/io/init.c
index 29afe09..b5eade3 100644
--- a/io/init.c
+++ b/io/init.c
@@ -14,11 +14,11 @@
 char	*progname;
 int	exitcode;
 int	expert;
-int	idlethread;
+static int	idlethread;
 size_t	pagesize;
 struct timeval stopwatch;
 
-void
+static void
 usage(void)
 {
 	fprintf(stderr,
@@ -124,7 +124,7 @@ init_check_command(
 	return 1;
 }
 
-void
+static void
 init(
 	int		argc,
 	char		**argv)
@@ -235,7 +235,7 @@ init(
  * are not reference counted. Spawning an idle thread can help detecting file
  * struct reference leaks.
  */
-void *
+static void *
 idle_loop(void *arg)
 {
 	for (;;)
@@ -243,7 +243,7 @@ idle_loop(void *arg)
 	return NULL;
 }
 
-void
+static void
 start_idle_thread(void)
 {
 	pthread_t t;
diff --git a/io/madvise.c b/io/madvise.c
index c001a2f..9f6c010 100644
--- a/io/madvise.c
+++ b/io/madvise.c
@@ -34,7 +34,7 @@ madvise_help(void)
 "\n"));
 }
 
-int
+static int
 madvise_f(
 	int		argc,
 	char		**argv)
diff --git a/io/mincore.c b/io/mincore.c
index c4f354c..239134f 100644
--- a/io/mincore.c
+++ b/io/mincore.c
@@ -12,7 +12,7 @@
 
 static cmdinfo_t mincore_cmd;
 
-int
+static int
 mincore_f(
 	int		argc,
 	char		**argv)
diff --git a/io/mmap.c b/io/mmap.c
index dbfcca5..44749bb 100644
--- a/io/mmap.c
+++ b/io/mmap.c
@@ -290,7 +290,7 @@ msync_help(void)
 "\n"));
 }
 
-int
+static int
 msync_f(
 	int		argc,
 	char		**argv)
@@ -374,7 +374,7 @@ mread_help(void)
 "\n"));
 }
 
-int
+static int
 mread_f(
 	int		argc,
 	char		**argv)
@@ -477,7 +477,7 @@ mread_f(
 	return 0;
 }
 
-int
+static int
 munmap_f(
 	int		argc,
 	char		**argv)
@@ -531,7 +531,7 @@ mwrite_help(void)
 "\n"));
 }
 
-int
+static int
 mwrite_f(
 	int		argc,
 	char		**argv)
@@ -618,7 +618,7 @@ mremap_help(void)
 "\n"));
 }
 
-int
+static int
 mremap_f(
 	int		argc,
 	char		**argv)
diff --git a/io/parent.c b/io/parent.c
index 53ac659..ffa55f6 100644
--- a/io/parent.c
+++ b/io/parent.c
@@ -358,7 +358,7 @@ error:
 	return retval;
 }
 
-int
+static int
 parent_f(int argc, char **argv)
 {
 	int c;
diff --git a/io/readdir.c b/io/readdir.c
index 4321bde..2cb8977 100644
--- a/io/readdir.c
+++ b/io/readdir.c
@@ -18,7 +18,7 @@
 
 static struct cmdinfo readdir_cmd;
 
-const char *d_type_str(unsigned int type)
+static const char *d_type_str(unsigned int type)
 {
 	const char *str;
 
diff --git a/io/seek.c b/io/seek.c
index ae6e9f5..59ba1cf 100644
--- a/io/seek.c
+++ b/io/seek.c
@@ -49,7 +49,7 @@ seek_help(void)
 #define	DATA		0
 #define	HOLE		1
 
-struct seekinfo {
+static struct seekinfo {
 	char		*name;		/* display item name */
 	int		seektype;	/* data or hole */
 	int		mask;		/* compared for print and looping */
@@ -59,7 +59,7 @@ struct seekinfo {
 };
 
 /* print item type and offset. catch special cases of eof and error */
-void
+static void
 seek_output(
 	int	startflag,
 	char	*type,
diff --git a/io/stat.c b/io/stat.c
index cde7780..64662b4 100644
--- a/io/stat.c
+++ b/io/stat.c
@@ -77,7 +77,8 @@ dump_raw_stat(struct stat *st)
 	return 0;
 }
 
-void print_file_info(void)
+static void
+print_file_info(void)
 {
 	printf(_("fd.path = \"%s\"\n"), file->name);
 	printf(_("fd.flags = %s,%s,%s%s%s%s%s\n"),
@@ -90,7 +91,8 @@ void print_file_info(void)
 		file->flags & IO_TMPFILE ? _(",tmpfile") : "");
 }
 
-void print_xfs_info(int verbose)
+static void
+print_xfs_info(int verbose)
 {
 	struct dioattr	dio;
 	struct fsxattr	fsx, fsxa;
@@ -291,7 +293,7 @@ dump_raw_statx(struct statx *stx)
  * 	- output style for flags (and all else?) (chars vs. hex?)
  * 	- output - mask out incidental flag or not?
  */
-int
+static int
 statx_f(
 	int		argc,
 	char		**argv)
diff --git a/libxcmd/command.c b/libxcmd/command.c
index ceb359d..a76d151 100644
--- a/libxcmd/command.c
+++ b/libxcmd/command.c
@@ -19,8 +19,8 @@ struct cmdline {
 	bool	iterate;
 };
 
-static int	ncmdline;
-struct cmdline	*cmdline;
+static int		ncmdline;
+static struct cmdline	*cmdline;
 
 static int
 compare(const void *a, const void *b)
diff --git a/libxfs/cache.c b/libxfs/cache.c
index 77866bc..139c7c1 100644
--- a/libxfs/cache.c
+++ b/libxfs/cache.c
@@ -77,7 +77,7 @@ cache_init(
 	return cache;
 }
 
-void
+static void
 cache_expand(
 	struct cache *		cache)
 {
diff --git a/libxfs/init.c b/libxfs/init.c
index d7543d4..10dcbf3 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -37,7 +37,7 @@ static int manage_zones(int);	/* setup/teardown global zones */
  * dev_map - map open devices to fd.
  */
 #define MAX_DEVS 10	/* arbitary maximum */
-int nextfakedev = -1;	/* device number to give to next fake device */
+static int nextfakedev = -1;	/* device number to give to next fake device */
 static struct dev_to_fd {
 	dev_t	dev;
 	int	fd;
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index c160e20..753b939 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -544,7 +544,7 @@ libxfs_bcompare(struct cache_node *node, cache_key_t key)
 	return CACHE_MISS;
 }
 
-void
+static void
 libxfs_bprint(xfs_buf_t *bp)
 {
 	fprintf(stderr, "Buffer %p blkno=%llu bytes=%u flags=0x%x count=%u\n",
@@ -624,7 +624,7 @@ libxfs_initbuf_map(xfs_buf_t *bp, struct xfs_buftarg *btp,
 	bp->b_flags |= LIBXFS_B_DISCONTIG;
 }
 
-xfs_buf_t *
+static xfs_buf_t *
 __libxfs_getbufr(int blen)
 {
 	xfs_buf_t	*bp;
@@ -681,7 +681,7 @@ libxfs_getbufr(struct xfs_buftarg *btp, xfs_daddr_t blkno, int bblen)
 	return bp;
 }
 
-xfs_buf_t *
+static xfs_buf_t *
 libxfs_getbufr_map(struct xfs_buftarg *btp, xfs_daddr_t blkno, int bblen,
 		struct xfs_buf_map *map, int nmaps)
 {
diff --git a/libxfs/util.c b/libxfs/util.c
index eb99ef7..9932186 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -230,7 +230,7 @@ xfs_flags2diflags2(
  * This was once shared with the kernel, but has diverged to the point
  * where it's no longer worth the hassle of maintaining common code.
  */
-int
+static int
 libxfs_ialloc(
 	xfs_trans_t	*tp,
 	xfs_inode_t	*pip,
@@ -380,7 +380,7 @@ libxfs_ialloc(
 	return 0;
 }
 
-void
+static void
 libxfs_iprint(
 	xfs_inode_t		*ip)
 {
@@ -753,7 +753,7 @@ xfs_inode_verifier_error(
  * repair can validate it against the state of the log.
  */
 xfs_lsn_t	libxfs_max_lsn = 0;
-pthread_mutex_t	libxfs_max_lsn_lock = PTHREAD_MUTEX_INITIALIZER;
+static pthread_mutex_t	libxfs_max_lsn_lock = PTHREAD_MUTEX_INITIALIZER;
 
 bool
 xfs_log_check_lsn(
diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index c5dba30..e29366a 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -24,7 +24,7 @@ typedef struct xlog_split_item {
 	int			si_skip;
 } xlog_split_item_t;
 
-xlog_split_item_t *split_list = NULL;
+static xlog_split_item_t *split_list = NULL;
 
 void
 print_xlog_op_line(void)
@@ -33,7 +33,7 @@ print_xlog_op_line(void)
 	   "--------------------------------------\n");
 }	/* print_xlog_op_line */
 
-void
+static void
 print_xlog_xhdr_line(void)
 {
     printf("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
@@ -58,7 +58,7 @@ print_stars(void)
  * Given a pointer to a data segment, print out the data as if it were
  * a log operation header.
  */
-void
+static void
 xlog_print_op_header(xlog_op_header_t	*op_head,
 		     int		i,
 		     char		**ptr)
@@ -98,7 +98,7 @@ xlog_print_op_header(xlog_op_header_t	*op_head,
 }	/* xlog_print_op_header */
 
 
-void
+static void
 xlog_print_add_to_trans(xlog_tid_t	tid,
 			int		skip)
 {
@@ -115,7 +115,7 @@ xlog_print_add_to_trans(xlog_tid_t	tid,
 }	/* xlog_print_add_to_trans */
 
 
-int
+static int
 xlog_print_find_tid(xlog_tid_t tid, uint was_cont)
 {
     xlog_split_item_t *listp = split_list;
@@ -149,7 +149,7 @@ xlog_print_find_tid(xlog_tid_t tid, uint was_cont)
     return 1;
 }	/* xlog_print_find_tid */
 
-int
+static int
 xlog_print_trans_header(char **ptr, int len)
 {
     xfs_trans_header_t  *h;
@@ -181,7 +181,7 @@ xlog_print_trans_header(char **ptr, int len)
 }	/* xlog_print_trans_header */
 
 
-int
+static int
 xlog_print_trans_buffer(char **ptr, int len, int *i, int num_ops)
 {
     xfs_buf_log_format_t *f;
@@ -416,7 +416,7 @@ xlog_print_trans_buffer(char **ptr, int len, int *i, int num_ops)
 }	/* xlog_print_trans_buffer */
 
 
-int
+static int
 xlog_print_trans_qoff(char **ptr, uint len)
 {
     xfs_qoff_logformat_t *f;
@@ -435,7 +435,7 @@ xlog_print_trans_qoff(char **ptr, uint len)
 }	/* xlog_print_trans_qoff */
 
 
-void
+static void
 xlog_print_trans_inode_core(
 	struct xfs_log_dinode	*ip)
 {
@@ -461,7 +461,7 @@ xlog_print_trans_inode_core(
     }
 }
 
-void
+static void
 xlog_print_dir2_sf(
 	struct xlog	*log,
 	xfs_dir2_sf_hdr_t *sfp,
@@ -497,7 +497,7 @@ xlog_print_dir2_sf(
 	}
 }
 
-int
+static int
 xlog_print_trans_inode(
 	struct xlog		*log,
 	char			**ptr,
@@ -648,7 +648,7 @@ xlog_print_trans_inode(
 }	/* xlog_print_trans_inode */
 
 
-int
+static int
 xlog_print_trans_dquot(char **ptr, int len, int *i, int num_ops)
 {
     xfs_dq_logformat_t	*f;
@@ -756,7 +756,7 @@ xlog_print_lseek(struct xlog *log, int fd, xfs_daddr_t blkno, int whence)
 }	/* xlog_print_lseek */
 
 
-void
+static void
 print_lsn(char		*string,
 	  __be64	*lsn)
 {
@@ -765,7 +765,7 @@ print_lsn(char		*string,
 }
 
 
-int
+static int
 xlog_print_record(
 	struct xlog		*log,
 	int			fd,
@@ -1020,7 +1020,7 @@ xlog_print_record(
 }	/* xlog_print_record */
 
 
-int
+static int
 xlog_print_rec_head(xlog_rec_header_t *head, int *len, int bad_hdr_warn)
 {
     int i;
@@ -1094,7 +1094,7 @@ xlog_print_rec_head(xlog_rec_header_t *head, int *len, int bad_hdr_warn)
     return(be32_to_cpu(head->h_num_logops));
 }	/* xlog_print_rec_head */
 
-void
+static void
 xlog_print_rec_xhead(xlog_rec_ext_header_t *head, int coverage)
 {
     int i;
@@ -1134,7 +1134,7 @@ print_xlog_bad_header(xfs_daddr_t blkno, char *buf)
 	    xlog_exit("Bad log record header");
 }	/* print_xlog_bad_header */
 
-void
+static void
 print_xlog_bad_data(xfs_daddr_t blkno)
 {
 	print_stars();
diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
index cd47313..eafffe2 100644
--- a/logprint/log_print_all.c
+++ b/logprint/log_print_all.c
@@ -430,7 +430,7 @@ xlog_recover_print_logitem(
 	}
 }
 
-void
+static void
 xlog_recover_print_item(
 	xlog_recover_item_t	*item)
 {
diff --git a/logprint/logprint.c b/logprint/logprint.c
index 5aaa30c..7754a2a 100644
--- a/logprint/logprint.c
+++ b/logprint/logprint.c
@@ -25,9 +25,9 @@ int	print_overwrite;
 int     print_no_data;
 int     print_no_print;
 int     print_exit = 1; /* -e is now default. specify -c to override */
-int	print_operation = OP_PRINT;
+static int	print_operation = OP_PRINT;
 
-void
+static void
 usage(void)
 {
 	fprintf(stderr, _("Usage: %s [options...] <device>\n\n\
@@ -52,7 +52,7 @@ Options:\n\
 	exit(1);
 }
 
-int
+static int
 logstat(xfs_mount_t *mp)
 {
 	int		fd;
diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index bb4246f..3375e08 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -8,9 +8,9 @@
 #include "xfs_metadump.h"
 
 char 		*progname;
-int		show_progress = 0;
-int		show_info = 0;
-int		progress_since_warning = 0;
+static int	show_progress = 0;
+static int	show_info = 0;
+static int	progress_since_warning = 0;
 
 static void
 fatal(const char *msg, ...)
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 2eec005..9877959 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -31,8 +31,8 @@
  * XXX: The configured block and sector sizes are defined as global variables so
  * that they don't need to be passed to getnum/cvtnum().
  */
-unsigned int		blocksize;
-unsigned int		sectorsize;
+static unsigned int		blocksize;
+static unsigned int		sectorsize;
 
 /*
  * Enums for each CLI parameter type are declared first so we can calculate the
@@ -216,9 +216,9 @@ struct opt_params {
  * about tables that haven't yet been defined. Work around this ordering
  * issue with extern definitions here.
  */
-extern struct opt_params sopts;
+static struct opt_params sopts;
 
-struct opt_params bopts = {
+static struct opt_params bopts = {
 	.name = 'b',
 	.subopts = {
 		[B_SIZE] = "size",
@@ -235,7 +235,7 @@ struct opt_params bopts = {
 	},
 };
 
-struct opt_params dopts = {
+static struct opt_params dopts = {
 	.name = 'd',
 	.subopts = {
 		[D_AGCOUNT] = "agcount",
@@ -372,7 +372,7 @@ struct opt_params dopts = {
 };
 
 
-struct opt_params iopts = {
+static struct opt_params iopts = {
 	.name = 'i',
 	.subopts = {
 		[I_ALIGN] = "align",
@@ -433,7 +433,7 @@ struct opt_params iopts = {
 	},
 };
 
-struct opt_params lopts = {
+static struct opt_params lopts = {
 	.name = 'l',
 	.subopts = {
 		[L_AGNUM] = "agnum",
@@ -532,7 +532,7 @@ struct opt_params lopts = {
 	},
 };
 
-struct opt_params nopts = {
+static struct opt_params nopts = {
 	.name = 'n',
 	.subopts = {
 		[N_SIZE] = "size",
@@ -563,7 +563,7 @@ struct opt_params nopts = {
 	},
 };
 
-struct opt_params ropts = {
+static struct opt_params ropts = {
 	.name = 'r',
 	.subopts = {
 		[R_EXTSIZE] = "extsize",
@@ -613,7 +613,7 @@ struct opt_params ropts = {
 	},
 };
 
-struct opt_params sopts = {
+static struct opt_params sopts = {
 	.name = 's',
 	.subopts = {
 		[S_SIZE] = "size",
@@ -643,7 +643,7 @@ struct opt_params sopts = {
 	},
 };
 
-struct opt_params mopts = {
+static struct opt_params mopts = {
 	.name = 'm',
 	.subopts = {
 		[M_CRC] = "crc",
@@ -1658,7 +1658,7 @@ sector_opts_parser(
 	return 0;
 }
 
-struct subopts {
+static struct subopts {
 	char		opt;
 	struct opt_params *opts;
 	int		(*parser)(struct opt_params	*opts,
@@ -2964,7 +2964,7 @@ _("Due to stripe alignment, the internal log size (%lld) is too large.\n"
 	}
 }
 
-void
+static void
 validate_log_size(uint64_t logblocks, int blocklog, int min_logblocks)
 {
 	if (logblocks < min_logblocks) {
diff --git a/repair/btree.c b/repair/btree.c
index dd7717b..a402d0a 100644
--- a/repair/btree.c
+++ b/repair/btree.c
@@ -444,7 +444,7 @@ btree_lookup_prev(
 	return value;
 }
 
-void *
+static void *
 btree_uncached_lookup(
 	struct btree_root	*root,
 	unsigned long		key)
diff --git a/repair/incore_ext.c b/repair/incore_ext.c
index 0624d6d..e7ef9eb 100644
--- a/repair/incore_ext.c
+++ b/repair/incore_ext.c
@@ -144,7 +144,7 @@ release_extent_tree_node(extent_tree_node_t *node)
  * reused.  the duplicate and bno/bcnt extent trees for each AG
  * are recycled after they're no longer needed to save memory
  */
-void
+static void
 release_extent_tree(avltree_desc_t *tree)
 {
 	extent_tree_node_t	*ext;
@@ -517,12 +517,12 @@ avl_ext_bcnt_end(avlnode_t *node)
 	return((uintptr_t) ((extent_tree_node_t *)node)->ex_blockcount);
 }
 
-avlops_t avl_extent_bcnt_tree_ops = {
+static avlops_t avl_extent_bcnt_tree_ops = {
 	avl_ext_bcnt_start,
 	avl_ext_bcnt_end
 };
 
-avlops_t avl_extent_tree_ops = {
+static avlops_t avl_extent_tree_ops = {
 	avl_ext_start,
 	avl_ext_end
 };
@@ -714,7 +714,7 @@ avl64_ext_end(avl64node_t *node)
 		((rt_extent_tree_node_t *) node)->rt_blockcount);
 }
 
-avl64ops_t avl64_extent_tree_ops = {
+static avl64ops_t avl64_extent_tree_ops = {
 	avl64_rt_ext_start,
 	avl64_ext_end
 };
@@ -792,7 +792,7 @@ incore_ext_teardown(xfs_mount_t *mp)
 	extent_bno_ptrs = NULL;
 }
 
-int
+static int
 count_extents(xfs_agnumber_t agno, avltree_desc_t *tree, int whichtree)
 {
 	extent_tree_node_t *node;
diff --git a/repair/incore_ino.c b/repair/incore_ino.c
index ed10d06..82956ae 100644
--- a/repair/incore_ino.c
+++ b/repair/incore_ino.c
@@ -535,7 +535,7 @@ set_inode_free_alloc(struct xfs_mount *mp, xfs_agnumber_t agno, xfs_agino_t ino)
 	return(ino_rec);
 }
 
-void
+static void
 print_inode_list_int(xfs_agnumber_t agno, int uncertain)
 {
 	ino_tree_node_t *ino_rec;
@@ -776,7 +776,7 @@ avl_ino_end(avlnode_t *node)
 		XFS_INODES_PER_CHUNK));
 }
 
-avlops_t avl_ino_tree_ops = {
+static avlops_t avl_ino_tree_ops = {
 	avl_ino_start,
 	avl_ino_end
 };
diff --git a/repair/phase6.c b/repair/phase6.c
index e2e4446..e017326 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -513,7 +513,7 @@ res_failed(
 		do_error(_("xfs_trans_reserve returned %d\n"), err);
 }
 
-void
+static void
 mk_rbmino(xfs_mount_t *mp)
 {
 	xfs_trans_t	*tp;
diff --git a/repair/progress.c b/repair/progress.c
index b049fd1..5ee0822 100644
--- a/repair/progress.c
+++ b/repair/progress.c
@@ -81,7 +81,7 @@ progress_rpt_t progress_rpt_reports[] = {
 	&rpt_fmts[FMT1], &rpt_types[TYPE_AG]}
 };
 
-pthread_t	report_thread;
+static pthread_t	report_thread;
 
 typedef struct msg_block_s {
 	pthread_mutex_t	mutex;
diff --git a/repair/sb.c b/repair/sb.c
index 94a4726..059422c 100644
--- a/repair/sb.c
+++ b/repair/sb.c
@@ -71,7 +71,7 @@ copy_sb(xfs_sb_t *source, xfs_sb_t *dest)
 	memset(source->sb_fname, 0, 12);
 }
 
-int
+static int
 verify_sb_blocksize(xfs_sb_t *sb)
 {
 	/* check to make sure blocksize is legal 2^N, 9 <= N <= 16 */
diff --git a/repair/scan.c b/repair/scan.c
index 4bcc626..65a76e2 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -1449,7 +1449,7 @@ enum inobt_type {
 	INOBT,
 	FINOBT
 };
-const char *inobt_names[] =	{
+static const char *inobt_names[] = {
 	"inobt",
 	"finobt"
 };
diff --git a/rtcp/xfs_rtcp.c b/rtcp/xfs_rtcp.c
index a77561d..f928a86 100644
--- a/rtcp/xfs_rtcp.c
+++ b/rtcp/xfs_rtcp.c
@@ -9,10 +9,10 @@
 int rtcp(char *, char *, int);
 int xfsrtextsize(char *path);
 
-int pflag;
+static int pflag;
 char *progname;
 
-void
+static void
 usage(void)
 {
 	fprintf(stderr, _("%s [-e extsize] [-p] [-V] source target\n"), progname);
diff --git a/scrub/scrub.c b/scrub/scrub.c
index 0059adb..0f0c963 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -305,7 +305,7 @@ _("Optimizations of %s are possible."), scrubbers[i].name);
 }
 
 /* Save a scrub context for later repairs. */
-bool
+static bool
 xfs_scrub_save_repair(
 	struct scrub_ctx		*ctx,
 	struct xfs_action_list		*alist,
diff --git a/spaceman/init.c b/spaceman/init.c
index 68bd8a0..181a344 100644
--- a/spaceman/init.c
+++ b/spaceman/init.c
@@ -14,7 +14,7 @@
 char	*progname;
 int	exitcode;
 
-void
+static void
 usage(void)
 {
 	fprintf(stderr,
@@ -54,7 +54,7 @@ init_check_command(
 	return 1;
 }
 
-void
+static void
 init(
 	int		argc,
 	char		**argv)
-- 
1.8.3.1
