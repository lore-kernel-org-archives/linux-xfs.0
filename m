Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAG6nGRk068104 for <xfs@oss.sgi.com>; Fri, 16 Nov 2012 00:49:16 -0600
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id cP5C8KV1GjfEdlXq (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 15 Nov 2012 22:51:19 -0800 (PST)
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with
	ESMTP id qAG6pH6W008269
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 16 Nov 2012 06:51:18 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	qAG6pHco029897
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 16 Nov 2012 06:51:17 GMT
Received: from abhmt101.oracle.com (abhmt101.oracle.com [141.146.116.53])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id
	qAG6pHlj013327 for <xfs@oss.sgi.com>; Fri, 16 Nov 2012 00:51:17 -0600
Message-ID: <50A5E25F.8020900@oracle.com>
Date: Fri, 16 Nov 2012 14:51:11 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH 2/2] xfsprogs: xfs_shrinkfs(8)
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

xfs_shrinkfs(8) for xfsprogs.

This version does not really works for data moving, it only would be used for reflect
my current thoughts for implementing this utility.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>

---
 Makefile                 |    3 +-
 include/xfs_dfrag.h      |   20 +
 include/xfs_fs.h         |    6 +
 shrinkfs/Makefile        |   30 ++
 shrinkfs/xfs_shrink.c    | 1184 ++++++++++++++++++++++++++++++++++++++++++++++
 shrinkfs/xfs_shrinkfs.sh |   99 ++++
 6 files changed, 1341 insertions(+), 1 deletion(-)
 create mode 100644 shrinkfs/Makefile
 create mode 100644 shrinkfs/xfs_shrink.c
 create mode 100755 shrinkfs/xfs_shrinkfs.sh

diff --git a/Makefile b/Makefile
index 0bdc5e8..c30ea21 100644
--- a/Makefile
+++ b/Makefile
@@ -41,7 +41,7 @@ endif
 
 LIB_SUBDIRS = libxfs libxlog libxcmd libhandle libdisk
 TOOL_SUBDIRS = copy db estimate fsck fsr growfs io logprint mkfs quota \
-		mdrestore repair rtcp m4 man doc po debian
+		mdrestore repair rtcp m4 man doc po debian shrinkfs
 
 SUBDIRS = include $(LIB_SUBDIRS) $(TOOL_SUBDIRS)
 
@@ -62,6 +62,7 @@ io: libxcmd libhandle
 mkfs: libxfs
 quota: libxcmd
 repair: libxfs libxlog
+shrinkfs: libxfs libxcmd
 
 ifneq ($(ENABLE_BLKID), yes)
 mkfs: libdisk
diff --git a/include/xfs_dfrag.h b/include/xfs_dfrag.h
index 20bdd93..17a076b 100644
--- a/include/xfs_dfrag.h
+++ b/include/xfs_dfrag.h
@@ -38,6 +38,21 @@ typedef struct xfs_swapext
  */
 #define XFS_SX_VERSION		0
 
+/*
+ * Structure passed to xfs_swapino.
+ */
+typedef struct xfs_swapino {
+	__int64_t	si_version;	/* version */
+	__int64_t	si_fdtarget;	/* fd of target file */
+	__int64_t	si_fdtmp;	/* fd of temp file */
+	char		si_pad[16];	/* pad space, unused */
+} xfs_swapino_t;
+
+/*
+ * Version flag.
+ */
+#define XFS_SI_VERSION          0
+
 #ifdef __KERNEL__
 /*
  * Prototypes for visible xfs_dfrag.c routines.
@@ -48,6 +63,11 @@ typedef struct xfs_swapext
  */
 int	xfs_swapext(struct xfs_swapext *sx);
 
+/*
+ * Syscall interface for xfs_swapino
+ */
+int	xfs_swapino(struct xfs_swapino *si);
+
 #endif	/* __KERNEL__ */
 
 #endif	/* __XFS_DFRAG_H__ */
diff --git a/include/xfs_fs.h b/include/xfs_fs.h
index c749474..5b9c1b4 100644
--- a/include/xfs_fs.h
+++ b/include/xfs_fs.h
@@ -267,6 +267,10 @@ typedef struct xfs_growfs_rt {
 	__u32		extsize;	/* new realtime extent size, fsblocks */
 } xfs_growfs_rt_t;
 
+typedef struct xfs_shrinkfs_data {
+	__u64		newblocks;
+	__u32		imaxpct;
+} xfs_shrinkfs_data_t;
 
 /*
  * Structures returned from ioctl XFS_IOC_FSBULKSTAT & XFS_IOC_FSBULKSTAT_SINGLE
@@ -485,6 +489,8 @@ typedef struct xfs_handle {
 #define XFS_IOC_GOINGDOWN	     _IOR ('X', 125, __uint32_t)
 #define XFS_IOC_SET_AGSTATE	     _IOW ('X', 126, struct xfs_ioc_agstate)
 #define XFS_IOC_GET_AGSTATE	     _IOR ('X', 127, struct xfs_ioc_agstate)
+#define XFS_IOC_SWAPINO		     _IOWR ('X', 128, struct xfs_swapino)
+#define XFS_IOC_FSSHRINKFS_DATA	     _IOW ('X', 129, struct xfs_shrinkfs_data)
 /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
 
 
diff --git a/shrinkfs/Makefile b/shrinkfs/Makefile
new file mode 100644
index 0000000..48a623e
--- /dev/null
+++ b/shrinkfs/Makefile
@@ -0,0 +1,30 @@
+TOPDIR = ..
+include $(TOPDIR)/include/builddefs
+
+LTCOMMAND = xfs_shrink
+
+CFILES = xfs_shrink.c
+
+LLDLIBS = $(LIBXFS) $(LIBXCMD) $(LIBUUID) $(LIBRT) $(LIBPTHREAD)
+ifeq ($(ENABLE_READLINE),yes)
+LLDLIBS += $(LIBREADLINE) $(LIBTERMCAP)
+endif
+
+ifeq ($(ENABLE_EDITLINE),yes)
+LLDLIBS += $(LIBEDITLINE) $(LIBTERMCAP)
+endif
+
+LTDEPENDENCIES = $(LIBXFS) $(LIBXCMD)
+LLDFLAGS = -static
+
+default: depend $(LTCOMMAND)
+
+include $(BUILDRULES)
+
+install: default
+	$(INSTALL) -m 755 -d $(PKG_SBIN_DIR)
+	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_SBIN_DIR)
+	$(INSTALL) -m 755 xfs_shrinkfs.sh $(PKG_SBIN_DIR)/xfs_shrinkfs
+install-dev:
+
+-include .dep
diff --git a/shrinkfs/xfs_shrink.c b/shrinkfs/xfs_shrink.c
new file mode 100644
index 0000000..6f72063
--- /dev/null
+++ b/shrinkfs/xfs_shrink.c
@@ -0,0 +1,1184 @@
+#include <xfs/xfs.h>
+#include <xfs/libxfs.h>
+#include <xfs/xfs_types.h>
+#include <xfs/xfs_dfrag.h>
+#include <xfs/xfs_bmap_btree.h>
+#include <xfs/jdm.h>
+#include <libxfs.h>
+
+#include <path.h>
+#include <fcntl.h>
+#include <ftw.h>
+#include <libgen.h>
+#include <malloc.h>
+#include <mntent.h>
+#include <sys/ioctl.h>
+#include <sys/vfs.h>
+#include <sys/statvfs.h>
+#include <errno.h>
+
+#define MNTTYPE_XFS	"xfs"
+#define ECBUFSZ		4096
+#define SMBUFSZ		1024
+
+const char		*program = "xfs_shrinkfs";
+int			vflag = 0; /* -v flag print verbose data moving info */
+int			mflag = 0;
+int			offline_agcount = 0;
+int			imaxpct;
+long int		end_ag_freesize = -1; /* a.g. free blocks in the last one */
+static __uint8_t	aginolog;
+xfs_agnumber_t		*offline_aglist = NULL;
+xfs_agnumber_t		first_offline_agno = 0; /* the 1st AG in offline state */
+xfs_fsop_geom_t		geom; /* old filesystem geometry */
+
+/*
+ * Which kind of volume to be shrink?
+ */
+enum {
+	DVOLUME = 0,
+	LVOLUME,
+	RVOLUME,
+};
+
+__uint8_t
+get_aginolog(void)
+{
+	int		blocklog;
+	int		inodelog;
+	int		inopblog;
+	int		agblklog;
+
+	blocklog = libxfs_highbit32(geom.blocksize);
+	inodelog = libxfs_highbit32(geom.inodesize);
+	inopblog = blocklog - inodelog;
+	agblklog = (__uint8_t)libxfs_log2_roundup((unsigned int)geom.agblocks);
+
+	return (__uint8_t)(inopblog + agblklog);
+}
+
+static int
+ino_to_agno(
+	ino_t		st_ino)
+{
+	xfs_ino_t	ino;
+
+	ino = (xfs_ino_t)st_ino;
+	return ino >> aginolog;
+}
+
+static uint32_t
+get_ag_state(
+	const char		*fname,
+	int			fd,
+	xfs_agnumber_t		agno)
+{
+	xfs_ioc_agstate_t	agstate;
+
+	agstate.agno = agno;
+	if (xfsctl(fname, fd, XFS_IOC_GET_AGSTATE, &agstate) < 0) {
+		fprintf(stderr, _("unable to get state of ag %u\n"), agno);
+		return -1;
+	}
+
+	return agstate.state;
+}
+
+static int
+change_ag_state(
+	const char		*fname,
+	int			fd,
+	xfs_agnumber_t		agno,
+	unsigned int		state)
+{
+	xfs_ioc_agstate_t	agstate;
+
+	agstate.agno = agno;
+	agstate.state = state;
+	if (xfsctl(fname, fd, XFS_IOC_SET_AGSTATE, &agstate) < 0) {
+		fprintf(stderr, _("unable to change state for ag %u\n"), agno);
+		return -errno;
+	}
+
+	return 0;
+}
+
+static int
+aglist_add(
+	xfs_agnumber_t	agno)
+{
+	offline_aglist = realloc(offline_aglist,
+				 (offline_agcount + 1) *
+				 sizeof(*offline_aglist));
+	if (!offline_aglist)
+		return -ENOMEM;
+
+	offline_aglist[offline_agcount] = agno;
+	offline_agcount++;
+
+	return 0;
+}
+
+static void
+aglist_free(void)
+{
+	int	agno;
+
+	for (agno = 0; agno < offline_agcount; agno++)
+		free(&offline_aglist[agno]);
+	free(offline_aglist);
+}
+
+void
+report_info(
+	char		*mntpoint,
+	int		isint,
+	char		*logname,
+	char		*rtname,
+	int		lazycount,
+	int		dirversion,
+	int		logversion,
+	int		attrversion,
+	int		cimode)
+{
+	printf(_(
+		"meta-data=%-22s isize=%-6u agcount=%u, agsize=%u blks\n"
+		"         =%-22s sectsz=%-5u attr=%u\n"
+		"data     =%-22s bsize=%-6u blocks=%llu, imaxpct=%u\n"
+		"         =%-22s sunit=%-6u swidth=%u blks\n"
+		"naming   =version %-14u bsize=%-6u ascii-ci=%d\n"
+		"log      =%-22s bsize=%-6u blocks=%u, version=%u\n"
+		"         =%-22s sectsz=%-5u sunit=%u blks, lazy-count=%u\n"
+		"realtime =%-22s extsz=%-6u blocks=%llu, rtextents=%llu\n"),
+		mntpoint, geom.inodesize, geom.agcount, geom.agblocks,
+		"", geom.sectsize, attrversion,
+		"", geom.blocksize, (unsigned long long)geom.datablocks,
+		    geom.imaxpct,
+		"", geom.sunit, geom.swidth,
+		dirversion, geom.dirblocksize, cimode,
+		isint ? _("internal") : logname ? logname : _("external"),
+			geom.blocksize, geom.logblocks, logversion,
+		"", geom.logsectsize, geom.logsunit / geom.blocksize,
+		    lazycount,
+		!geom.rtblocks ? _("none") : rtname ? rtname : _("external"),
+		geom.rtextsize * geom.blocksize,
+		(unsigned long long)geom.rtblocks,
+		(unsigned long long)geom.rtextents);
+}
+
+int
+xfs_bulkstat_single(
+	int		fd,
+	xfs_ino_t	*lastip,
+	xfs_bstat_t	*ubuffer)
+{
+    xfs_fsop_bulkreq_t  bulkreq;
+
+    bulkreq.lastip = (__u64 *)lastip;
+    bulkreq.icount = 1;
+    bulkreq.ubuffer = ubuffer;
+    bulkreq.ocount = NULL;
+
+    return ioctl(fd, XFS_IOC_FSBULKSTAT_SINGLE, &bulkreq);
+}
+
+int
+xfs_bulkstat(
+	int		fd,
+	xfs_ino_t	*lastip,
+	int		icount,
+	xfs_bstat_t	*ubuffer,
+	__s32		*ocount)
+{
+    xfs_fsop_bulkreq_t  bulkreq;
+
+    bulkreq.lastip = (__u64 *)lastip;
+    bulkreq.icount = icount;
+    bulkreq.ubuffer = ubuffer;
+    bulkreq.ocount = ocount;
+    return ioctl(fd, XFS_IOC_FSBULKSTAT, &bulkreq);
+}
+
+static int
+xfs_swapino(
+	int		fd,
+	xfs_swapino_t	*si)
+{
+	return ioctl(fd, XFS_IOC_SWAPINO, si);
+}
+
+int
+xfs_fscounts(
+	int			fd,
+	xfs_fsop_counts_t	*counts)
+{
+    return ioctl(fd, XFS_IOC_FSCOUNTS, counts);
+}
+
+static int
+xfs_getxattr(int fd, struct fsxattr *attr)
+{
+	return ioctl(fd, XFS_IOC_FSGETXATTR, attr);
+}
+
+static int
+move_dir(
+	const char		*srcname,
+	const struct stat64	*st)
+{
+	xfs_swapino_t		si;
+	xfs_bstat_t		bstatbuf;
+	struct fsxattr		fsx;
+	char			target[PATH_MAX] = "";
+	char			*pname = NULL;
+	int			sfd = -1;
+	int			tfd = -1;
+	int			error = -1;
+
+	sfd = open(srcname, O_RDONLY);
+	if (sfd < 0) {
+		fprintf(stderr,
+			_("unable to open source directory %s: %s\n"),
+			srcname, strerror(errno));
+		goto out;
+	}
+
+	if (!platform_test_xfs_fd(sfd)) {
+		fprintf(stderr, _("%s is not an xfs file\n"), srcname);
+		goto out;
+	}
+
+	if (xfs_getxattr(sfd, &fsx) < 0) {
+		fprintf(stderr,
+			_("unable to get source directory %s attrs\n"),
+			srcname);
+		goto out;
+	}
+	if (fsx.fsx_xflags & (XFS_XFLAG_IMMUTABLE | XFS_XFLAG_APPEND)) {
+		fprintf(stderr, _("%s: immutable/append, ignoring\n"),
+			srcname);
+		goto out;
+	}
+
+	/* mkdir parent/target */
+	pname = strdup(srcname);
+	if (!pname) {
+		fprintf(stderr,
+			_("unable to duplicate source directory %s: %s\n"),
+			pname, strerror(ENOMEM));
+		goto out;
+	}
+
+	dirname(pname);
+	sprintf(target, "%s/shrinkXXXXXX", pname);
+	if (!mkdtemp(target)) {
+		fprintf(stderr,
+			_("unable to create temp directory for target %s\n"),
+			target);
+		goto out;
+	}
+
+	tfd = open(target, O_RDONLY);
+	if (tfd < 0) {
+		fprintf(stderr,
+			_("Unable to create target directory %s\n"),
+			target);
+		goto out;
+	}
+
+	/* swap inodes src->target */
+	si.si_version	= XFS_SI_VERSION;
+	si.si_fdtarget	= tfd;
+	si.si_fdtmp	= sfd;
+	error = xfs_swapino(tfd, &si);
+	if (error < 0) {
+		fprintf(stderr,
+			_("unable to swap inodes from %s to target %s: %s\n"),
+			srcname, target, strerror(errno));
+		goto out_unlink;
+	}
+
+	/* verify swapino result */
+	if (xfs_bulkstat_single(sfd, (xfs_ino_t *)&st->st_ino, &bstatbuf) < 0) {
+		fprintf(stderr,
+			_("unable to bulkstat source file %s\n"),
+			srcname);
+		unlink(target);
+		goto out;
+	}
+	if (bstatbuf.bs_ino != st->st_ino) {
+		fprintf(stderr,
+			_("bulkstat of source directory %s returned wrong inode\n"),
+			srcname);
+		goto out;
+	}
+
+	ftruncate64(tfd, bstatbuf.bs_size);
+
+	/* remove source directory */
+	error = rmdir(srcname);
+	if (error < 0) {
+		fprintf(stderr,
+			_("unable to remove source directory %s\n"),
+			srcname);
+		goto out;
+	}
+
+	/* rename current target to source */
+	error = rename(target, srcname);
+	if (error < 0) {
+		/*
+		 * We can't abort since the source directory is gone now.
+		 * Let the admin clean this one up.
+		 */
+		fprintf(stderr,
+			_("unable to rename directory from %s to %s\n"),
+			target, srcname);
+	}
+	goto out;
+
+out_unlink:
+	error = rmdir(target);
+	if (error < 0) {
+		fprintf(stderr,
+			_("unable to remove target directory %s\n"),
+			target);
+	}
+
+out:
+	if (sfd >= 0)
+		close(sfd);
+	if (tfd >= 0)
+		close(tfd);
+
+	free(pname);
+	return error;
+}
+
+static int
+move_slink(
+	const char		*srcname,
+	const struct stat64	*st)
+{
+	xfs_swapino_t		si;
+	char			target[PATH_MAX] = "";
+	char			linkbuf[PATH_MAX];
+	char			*pname = NULL;
+	int			i = 0;
+	int			sfd = -1;
+	int			tfd = -1;
+	int			error = -1;
+
+	sfd = open(srcname, O_RDWR | O_DIRECT);
+	if (sfd < 0) {
+		fprintf(stderr,
+			_("unable to open source file %s as %s\n"),
+			srcname, strerror(errno));
+		goto out;
+	}
+
+	i = readlink(srcname, linkbuf, sizeof(linkbuf) - 1);
+	if (i < 0) {
+		fprintf(stderr,
+			_("unable to read link of source file %s as %s\n"),
+			srcname, strerror(errno));
+		goto out;
+	}
+	linkbuf[i] = '\0';
+
+	error = -1;
+	pname = strdup(srcname);
+	if (!pname) {
+		fprintf(stderr,
+			_("unable to duplicate source file %s as %s\n"),
+			srcname, strerror(ENOMEM));
+		goto out;
+	}
+
+	dirname(pname);
+	sprintf(target, "%s/shrinkXXXXXX", pname);
+	tfd = mkstemp(target);
+	if (tfd < 0) {
+		fprintf(stderr,
+			_("unable to create target file %s\n"),
+			target);
+		goto out;
+	}
+
+	if (symlink(linkbuf, target) != 0) {
+		fprintf(stderr,
+			_("unable to create source symbol link %s to %s\n"),
+			linkbuf, target);
+		goto out;
+	}
+
+	/* swap inode src->target */
+	si.si_version	= XFS_SI_VERSION;
+	si.si_fdtarget	= sfd;
+	si.si_fdtmp	= tfd;
+	error = xfs_swapino(sfd, &si);
+	if (error < 0) {
+		fprintf(stderr, _("unable to swap inodes from %s to %s: %s\n"),
+			srcname, target, strerror(errno));
+		goto out;
+	}
+
+	error = unlink(srcname);
+	if (error < 0) {
+		fprintf(stderr, _("unable to unlink source file %s: %s\n"),
+			srcname, strerror(errno));
+		goto out;
+	}
+
+	error = rename(target, srcname);
+	if (error < 0)
+		fprintf(stderr, _("unable to rename %s to %s\n"),
+			target, srcname);
+
+out:
+	if (sfd > 0)
+		close(sfd);
+	if (tfd > 0)
+		close(tfd);
+
+	free(pname);
+	return error;
+}
+
+static int
+move_file(
+	const char		*srcname,
+	const struct stat64	*st)
+{
+	xfs_swapino_t		si;
+	xfs_bstat_t		bstatbuf;
+	struct fsxattr		fsx;
+	char			target[SMBUFSZ];
+	char			*pname = NULL;
+	int			sfd = -1;
+	int			tfd = -1;
+	int			error = -1;
+
+	sfd = open(srcname, O_RDWR | O_DIRECT);
+	if (sfd < 0) {
+		fprintf(stderr,
+			_("count not open source source file: %s: %s\n"),
+			srcname, strerror(errno));
+		goto out;
+	}
+
+	if (!platform_test_xfs_fd(sfd)) {
+		fprintf(stderr,
+			_("specified file [\"%s\"] is not on an XFS filesystem\n"),
+			srcname);
+		goto out;
+	}
+
+	if (fsync(sfd) < 0) {
+		fprintf(stderr, _("sync failed: %s: %s\n"),
+			srcname, strerror(errno));
+		goto out;
+	}
+
+	/*
+	 * Check if a mandatory lock is set on the file to try and avoid
+	 * blocking indefinitely on the reads later.  Note that someone
+	 * could still set a mandatory lock after this check but before
+	 * all reads have completed to block xfs_shrinkfs reads.  This
+	 * change just closes the window a bit.
+	 */
+	if ((st->st_mode & S_ISGID) && !(st->st_mode & S_IXGRP)) {
+		struct flock fl;
+
+		fl.l_type = F_RDLCK;
+		fl.l_whence = SEEK_SET;
+		fl.l_start = (off_t)0;
+		fl.l_len = 0;
+		if (fcntl(sfd, F_GETLK, &fl) < 0) {
+			fprintf(stderr, _("locking check failed: %s\n"),
+				srcname);
+			goto out;
+		}
+		if (fl.l_type != F_UNLCK) {
+			fprintf(stderr, _("mandatory lock: %s: ignoring\n"),
+				srcname);
+			goto out;
+		}
+	}
+
+	if (xfs_getxattr(sfd, &fsx) < 0) {
+		fprintf(stderr, _("unable to get the attrs of source file %s\n"),
+			srcname);
+		goto out;
+	}
+
+	if (fsx.fsx_xflags & (XFS_XFLAG_IMMUTABLE | XFS_XFLAG_APPEND)) {
+		fprintf(stderr, _("skip to move immutable file %s\n"),
+			srcname);
+		goto out;
+	}
+
+	/* create target */
+	pname = strdup(srcname);
+	if (!pname) {
+		fprintf(stderr, _("unable to duplate source file %s: %s\n"),
+			srcname, strerror(ENOMEM));
+		goto out;
+	}
+	dirname(pname);
+
+	sprintf(target, "%s/shrinkXXXXXX", pname);
+	tfd = mkstemp(target);
+	if (tfd < 0) {
+		fprintf(stderr, _("unable to create target file %s\n"),
+			target);
+		goto out;
+	}
+
+	/* swap inode source->target */
+	si.si_version = XFS_SI_VERSION;
+	si.si_fdtarget = sfd;
+	si.si_fdtmp = tfd;
+	error = xfs_swapino(sfd, &si);
+	if (error < 0) {
+		fprintf(stderr,
+			_("unable to swap inodes from %s to %s: %s\n"),
+			srcname, target, strerror(errno));
+		goto out_unlink;
+	}
+
+	if (xfs_bulkstat_single(sfd, (xfs_ino_t*)&st->st_ino, &bstatbuf) < 0) {
+		fprintf(stderr, _("unable to bulkstat source file: %s\n"),
+			srcname);
+		unlink(target);
+		goto out;
+	}
+
+	if (bstatbuf.bs_ino != st->st_ino) {
+		fprintf(stderr,
+			_("bulkstat of source file returned wrong inode: %s\n"),
+			srcname);
+		unlink(target);
+		goto out;
+	}
+
+	/* switch to the owner's id, to keep quota in line */
+	if (fchown(tfd, bstatbuf.bs_uid, bstatbuf.bs_gid) < 0) {
+		fprintf(stderr, _("failed to fchown tmpfile %s: %s\n"),
+			target, strerror(errno));
+		close(tfd);
+		goto out;
+	}
+
+	/* unlink src */
+	error = unlink(srcname);
+        if (error < 0) {
+                fprintf(stderr, _("unable to remove source file: %s"),
+			srcname);
+                goto out;
+        }
+
+	/* rename target source */
+	error = rename(target, srcname);
+	if (error < 0) {
+		/*
+		 * We can't abort since the source file is gone now.
+		 * Let the admin clean this one up.
+		 */
+		fprintf(stderr, _("unable to rename file %s to %s\n"),
+			target, srcname);
+	}
+
+out_unlink:
+	error = unlink(target);
+        if (error < 0)
+		fprintf(stderr, _("unable to remove file %s\n"), target);
+
+out:
+	if (sfd >= 0)
+		close(sfd);
+	if (tfd >= 0)
+		close(tfd);
+	if (pname)
+		free(pname);
+
+	return error;
+}
+
+static int
+move_item_common(
+	const char		*item_path,
+	const struct stat64	*st,
+	int			type,
+	struct FTW		*sntfw)
+{
+	xfs_agnumber_t		agno;
+	int			error = 0;
+
+	/* Skip item if is not located at an offline ag */
+	agno = ino_to_agno(st->st_ino);
+	if (agno < first_offline_agno)
+		return error;
+
+	if (vflag)
+		fprintf(stderr, _("start moving %s out of ag %d\n"),
+			item_path, agno);
+
+	switch (type) {
+	case FTW_D:
+		error = move_dir(item_path, st);
+		break;
+	case FTW_F:
+		error = move_file(item_path, st);
+		break;
+	case FTW_SL:
+		error = move_slink(item_path, st);
+		break;
+	default:
+		if (vflag) {
+			fprintf(stderr, _("skip file %s for data moving.\n"),
+				item_path);
+		}
+		/* FIXME: how to deal with such kind of file? */
+		break;
+	}
+
+	return error;
+}
+
+static int
+shrinkfs_init(
+	const char		*mntdir,	/* filesystem mount path */
+	int			ffd,		/* filesystem fd */
+	unsigned int		vtype,		/* which kind of volume to shrink(data/log/realtime) */
+	long long		fs_freesize,	/* filesystem free space in blocks */
+	long long		newsize)	/* volume size to be shrink up to */
+{
+	xfs_agnumber_t		start_agno;	/* start agno to truncate */
+	xfs_agnumber_t		agno;		/* agno index variable */
+	xfs_agnumber_t		temp;		/* temporary agno variable */
+	__uint32_t		agcount;	/* # of ag in filesystem */
+	__uint32_t		agblocks;	/* # of blocks per ag */
+	__uint64_t		totalsize;	/* volume size */
+	int			error = -1;
+
+	agcount = geom.agcount;
+	agblocks = geom.agblocks;
+
+	switch (vtype) {
+	case DVOLUME:
+		totalsize = geom.datablocks;
+		break;
+	case LVOLUME:
+		totalsize = geom.logblocks;
+		break;
+	case RVOLUME:
+		totalsize = geom.rtblocks;
+		break;
+	default:
+		fprintf(stderr, _("Invalid volume type\n"));
+		return -1;
+	}
+
+	if (newsize > totalsize) {
+		fprintf(stderr,
+	_("the new data section size %lld should less than old size %lld\n"),
+			(long long)newsize, (long long)geom.datablocks);
+		goto out;
+	} else if (newsize == totalsize) {
+		fprintf(stderr, _("data section size keep unchanged\n"));
+		goto out;
+	}
+
+	/*
+	 * There is no enough free space to truncate for shrinkfs, or we
+	 * can not save up the required space accrording to the new size.
+	 */
+	if (newsize < (totalsize - fs_freesize)) {
+		fprintf(stderr,
+	_("can't shrink filesystem %s: no enough free space\n"),
+			mntdir);
+		goto out;
+	}
+
+	start_agno = ((newsize / agblocks) + (newsize % agblocks != 0));
+	if (vflag) {
+		fprintf(stderr,
+	_("shrinkfs will make ag to be offline starting from: %d\n"),
+			start_agno);
+	}
+
+	first_offline_agno = --start_agno;
+	/*
+	 * Start to set those affected AGs to be offline.
+	 */
+	for (agno = first_offline_agno; agno < agcount; agno++) {
+		error = change_ag_state(mntdir, ffd, agno,
+					XFS_AG_STATE_ALLOC_DENY);
+		if (error) {
+			temp = agno;
+			goto out_cancel;
+		}
+
+		aglist_add(agno);
+		if (vflag) {
+			fprintf(stderr, _("ag %d is offline for moving data\n"),
+				agno);
+		}
+	}
+
+	/*
+	 * That's would be great if the truncated size is less that
+	 * the free blocks in the latest AG, so that we can avoid
+	 * going through the overall filesystem for moving data and
+	 * metadata to save up spaces.
+	 */
+	if (totalsize - newsize < end_ag_freesize)
+		goto out;
+
+	/*
+	 * Starting to move items from offline a.g. to others.
+	 */
+	error = nftw64(mntdir, move_item_common, 100, FTW_PHYS | FTW_MOUNT);
+	goto out;
+
+out_cancel:
+	for (agno = first_offline_agno; agno < temp; agno++) {
+		error = change_ag_state(mntdir, ffd, agno,
+					!XFS_AG_STATE_ALLOC_DENY);
+		if (error) {
+			fprintf(stderr, _("unable to set ag %d back to online\n"),
+				agno);
+			goto out_free;
+		}
+		offline_agcount--;
+		if (vflag)
+			fprintf(stderr, _("ag %d is back to be online\n"),
+				agno);
+	}
+
+out_free:
+	aglist_free();
+
+out:
+	return error;
+}
+
+static int
+shrinkfs(
+	const char		*mntdir,
+	int			ffd,
+	int			vtype,
+	__uint64_t		newsize)
+{
+	xfs_shrinkfs_data_t	in;
+	int			error;
+
+	if (vtype != DVOLUME) {
+		fprintf(stderr,
+			_("only support data volume shrink up for now\n"));
+		return -1;
+	}
+
+	in.newblocks = newsize;
+	in.imaxpct = mflag ? imaxpct : geom.imaxpct;
+	error = xfsctl(mntdir, ffd, XFS_IOC_FSSHRINKFS_DATA, &in);
+	if (error < 0) {
+		if (errno == EWOULDBLOCK) {
+			fprintf(stderr, _(
+		"%s: shrinkfs operation in progress already\n"),
+				progname);
+		} else {
+			fprintf(stderr, _(
+				"%s: XFS_IOC_FSSHRINKFS_DATA xfsctl failed: %s\n"),
+				progname, strerror(errno));
+		}
+	}
+
+	return error;
+}
+
+/*
+ * Show filesystem statistics after shrinking up.
+ */
+static int
+shrinkfs_done(
+	const char		*fname,
+	int			ffd)
+{
+	xfs_fsop_geom_v1_t	ngeom;	/* new fs geometry */
+	__uint32_t		state;
+	int			agno;
+	int			error;
+
+	/*
+	 * Free those affected AGs from the list and turn them back
+	 * to online.
+	 */
+	for (agno = first_offline_agno; agno < offline_agcount; agno++) {
+		error = change_ag_state(fname, ffd, agno,
+					!XFS_AG_STATE_ALLOC_DENY);
+		if (error)
+			goto out_free_aglist;
+	}
+
+	/*
+	 * Verify that if those AGs state are changed back to online.
+	 */
+	for (agno = first_offline_agno; agno < offline_agcount; agno++) {
+		state = get_ag_state(fname, ffd, agno);
+		if (state < 0)
+			goto out_free_aglist;
+		if (state != 0) {
+			fprintf(stderr, _("ag %d state: %d is wrong\n"),
+				agno, state);
+			goto out_free_aglist;
+		}
+
+		if (vflag) {
+			fprintf(stderr, _("ag %d is back to online\n"),
+				agno);
+		}
+	}
+
+	/*
+	 * Show current filesystem geomerty.
+	 */
+	if (xfsctl(fname, ffd, XFS_IOC_FSGEOMETRY_V1, &ngeom) < 0) {
+		fprintf(stderr,
+			_("XFS_IOC_FSGEOMETRY xfsctl failed: %s\n"),
+			strerror(errno));
+		error = -1;
+		goto out;
+	}
+
+	if (geom.datablocks != ngeom.datablocks)
+		fprintf(stderr, _("data blocks changed from %lld to %lld\n"),
+			(long long)geom.datablocks, (long long)ngeom.datablocks);
+	if (geom.imaxpct != ngeom.imaxpct)
+		fprintf(stderr, _("inode max percent changed from %d to %d\n"),
+			geom.imaxpct, ngeom.imaxpct);
+	if (geom.logblocks != ngeom.logblocks)
+		fprintf(stderr, _("log blocks changed from %d to %d\n"),
+			geom.logblocks, ngeom.logblocks);
+	if ((geom.logstart == 0) != (ngeom.logstart == 0))
+		fprintf(stderr, _("log changed from %s to %s\n"),
+			geom.logstart ? _("internal") : _("external"),
+			ngeom.logstart ? _("internal") : _("external"));
+	if (geom.rtblocks != ngeom.rtblocks)
+		fprintf(stderr, _("realtime blocks changed from %lld to %lld\n"),
+			(long long)geom.rtblocks, (long long)ngeom.rtblocks);
+	if (geom.rtextsize != ngeom.rtextsize)
+		fprintf(stderr, _("realtime extent size changed from %d to %d\n"),
+			geom.rtextsize, ngeom.rtextsize);
+
+	goto out;
+
+out_free_aglist:
+	aglist_free();
+
+out:
+	return error;
+}
+
+int
+get_fsgeom(
+	const char	*mntdir,
+	int		ffd)
+{
+	/* Get the current filesystem size & geometry */
+	if (xfsctl(mntdir, ffd, XFS_IOC_FSGEOMETRY, &geom) < 0) {
+		/*
+		 * OK, new xfsctl barfed - back off and try earlier version
+		 * as we're probably running an older kernel version.
+		 * Only field added in the v2 geometry xfsctl is "logsunit"
+		 * so we'll zero that out for later display (as zero).
+		 */
+		geom.logsunit = 0;
+		if (xfsctl(mntdir, ffd, XFS_IOC_FSGEOMETRY_V1, &geom) < 0) {
+			fprintf(stderr, _(
+		"%s: cannot determine geometry of filesystem mounted at %s: %s\n"),
+				progname, mntdir, strerror(errno));
+			close(ffd);
+			return -1;
+		}
+	}
+
+	return 0;
+}
+
+void
+usage(void)
+{
+	fprintf(stderr, _(
+"Usage: %s [options] device mountpoint\n\n"
+"Options:\n\
+	-d          shrink data/metadata section\n\
+	-l          shrink log section\n\
+	-r          shrink realtime section\n\
+	-n          don't change anything, just show geometry\n\
+	-D size     shrink data/metadata section to size blks\n\
+	-L size     shrink log section to size blks\n\
+	-R size     shrink realtime section to size blks\n\
+	-m imaxpct  set inode max percent to imaxpct\n\
+	-v	    print verbose shrinking info\n\
+	-V          print version information\n"),
+		program);
+	exit(2);
+}
+
+int
+main(
+	int			argc,
+	char			**argv)
+{
+	libxfs_init_t		xi;		/* libxfs structure */
+	fs_path_t		*fs;		/* mount point information */
+	long long		dsize = 0;	/* new data size in fs blocks */
+	long long		lsize = 0;	/* new log size in fs blocks */
+	long long		rsize = 0;	/* new realtime size in fs blocks */
+	long long		fs_freesize = 0;/* device size in 512-byte blocks */
+	char			*device;	/* data device name */
+	char			*mntdir;	/* mount point name */
+	char			*fsname;	/* filesystem name*/
+	char			*datadev;	/* data device name */
+	char			*logdev;	/* log device name */
+	char			*rtdev;		/* realtime device name */
+	int			attrversion;	/* attribute version number */
+	int			dirversion;	/* directory version number */
+	int			logversion;	/* log version number */
+	int			ffd = 0;	/* mount point file descriptor */
+	int			dflag = 0;	/* -d flag, shrink data area */
+	int			lflag = 0;	/* -l flag, shrink log area */
+	int			rflag = 0;	/* -r flag, shrink realtime area */
+	int			nflag = 0;	/* -n flag */
+	int			done = 0;	/* shrinkfs performed? */
+	int			isint;		/* log is currently internal */
+	int			ci;		/* ASCII case-insensitive fs */
+	int			c;		/* current option character */
+	int			lazycount;	/* lazy superblock counters */
+	int			error = 0;	/* we have hit an error */
+
+	while ((c = getopt(argc, argv, "dlnrvVF:f:m:D:L:R:")) != EOF) {
+		switch (c) {
+		case 'F':
+			fs_freesize = strtoll(optarg, NULL, 10);
+			break;
+		case 'f':
+			end_ag_freesize = strtol(optarg, NULL, 10);
+			break;
+		case 'D':
+			dsize = strtoll(optarg, NULL, 10);
+			break;
+		case 'L':
+			lsize = strtoll(optarg, NULL, 10);
+			break;
+		case 'R':
+			rsize = strtoll(optarg, NULL, 10);
+			break;
+		case 'm':
+			mflag = 1;
+			imaxpct = atoi(optarg);
+			break;
+		case 'd':
+			dflag = 1;
+			break;
+		case 'l':
+			lflag = 1;
+			break;
+		case 'r':
+			rflag = 1;
+			break;
+		case 'n':
+			nflag = 1;
+			break;
+		case 'v':
+			vflag = 1;
+			break;
+		case 'V':
+			printf(_("%s version %s\n"), program, VERSION);
+			exit(0);
+		case '?':
+		default:
+			usage();
+		}
+	}
+
+	if (argc - optind != 2)
+		usage();
+
+	if (dflag + lflag + rflag > 1) {
+		fprintf(stderr,
+			_("cannot shrink multiple filesystems for one time\n"));
+		exit(1);
+	}
+
+	if (!fs_freesize || end_ag_freesize < 0) {
+		fprintf(stderr, _("Invalid options\n"));
+		exit(1);
+	}
+
+	device = argv[optind++];
+	mntdir = argv[optind];
+	if (!device || !mntdir) {
+		fprintf(stderr, _("Invalid options\n"));
+		exit(1);
+	}
+
+	fs_table_initialise(0, NULL, 0, NULL);
+	fs = fs_table_lookup(mntdir, FS_MOUNT_POINT);
+	if (!fs) {
+		fprintf(stderr,
+		_("%s: %s is not a mounted XFS filesystem\n"),
+			progname, argv[optind]);
+		goto out;
+	}
+
+	fsname = fs->fs_dir;
+	datadev = fs->fs_name;
+	logdev = fs->fs_log;
+	rtdev = fs->fs_rt;
+
+	if (strcmp(fsname, mntdir)) {
+		fprintf(stderr, _("mount point %s is invalid\n"), mntdir);
+		goto out;
+	}
+	if (dflag && strcmp(datadev, device)) {
+		fprintf(stderr, _("device %s is invalid\n"), device);
+		goto out;
+	}
+	if (lflag && logdev && strcmp(logdev, device)) {
+		fprintf(stderr, _("device %s is invalid\n"), device);
+		goto out;
+	}
+	if (rflag && rtdev && strcmp(rtdev, device)) {
+		fprintf(stderr, _("device %s is invalid\n"), device);
+		goto out;
+	}
+
+	ffd = open(mntdir, O_RDONLY);
+	if (ffd < 0) {
+		fprintf(stderr, _("cannot open %s: %s\n"),
+			mntdir, strerror(errno));
+		goto out;
+	}
+
+	if (!platform_test_xfs_fd(ffd)) {
+		fprintf(stderr,
+	_("%s: specified file [\"%s\"] is not on an XFS filesystem\n"),
+			progname, mntdir);
+		goto out;
+	}
+
+	if (get_fsgeom(mntdir, ffd) < 0)
+		goto out;
+
+	isint = geom.logstart > 0;
+	lazycount = geom.flags & XFS_FSOP_GEOM_FLAGS_LAZYSB ? 1 : 0;
+	dirversion = geom.flags & XFS_FSOP_GEOM_FLAGS_DIRV2 ? 2 : 1;
+	logversion = geom.flags & XFS_FSOP_GEOM_FLAGS_LOGV2 ? 2 : 1;
+	attrversion = geom.flags & XFS_FSOP_GEOM_FLAGS_ATTR2 ? 2 : \
+			(geom.flags & XFS_FSOP_GEOM_FLAGS_ATTR ? 1 : 0);
+	ci = geom.flags & XFS_FSOP_GEOM_FLAGS_DIRV2CI ? 1 : 0;
+
+	/*
+	 * Specifies that no change to the filesystem is to be made.
+	 * The filesystem geometry is printed, but no shrink ocurrs.
+	 */
+	if (nflag) {
+		report_info(datadev, isint, logdev, rtdev, lazycount,
+			    dirversion, logversion, attrversion, ci);
+		goto out;
+	}
+
+	if (getuid() != 0) {
+		fprintf(stderr,
+	_("cannot shrink filesystem %s: Permission denied\n"),
+			mntdir);
+		goto out;
+	}
+
+	/*
+	 * Need root access from here on (using raw devices)...
+	 */
+	memset(&xi, 0, sizeof(xi));
+	xi.dname = datadev;
+	xi.logname = logdev;
+	xi.rtname = rtdev;
+	xi.isreadonly = LIBXFS_ISREADONLY;
+	if (!libxfs_init(&xi))
+		goto out;
+
+	/*
+	 * Check we got the info for all the sections we are trying to modify.
+	 */
+	if (dflag && !xi.ddev) {
+		fprintf(stderr,
+			_("%s: failed to access data device for %s\n"),
+			progname, fsname);
+		goto out;
+	} else if (lflag && !xi.logdev) {
+		fprintf(stderr,
+			_("%s: failed to access log device for %s\n"),
+			progname, fsname);
+		goto out;
+	} else if (rflag && !xi.rtdev) {
+		fprintf(stderr,
+			_("%s: failed to access realtime device for %s\n"),
+			progname, fsname);
+		goto out;
+	}
+
+	report_info(datadev, isint, logdev, rtdev, lazycount,
+		    dirversion, logversion, attrversion, ci);
+
+	/* Get agino_log which would be used at ino_to_agno() */
+	get_aginolog();
+
+	if (dflag && dsize > 0) {
+		error = shrinkfs_init(fsname, ffd, DVOLUME,
+				      fs_freesize, dsize);
+		if (error)
+			goto out;
+
+		error = shrinkfs(fsname, ffd, DVOLUME, dsize);
+		if (error)
+			goto out;
+		done = 1;
+	} else if (lflag && lsize > 0) {
+		error = shrinkfs_init(fsname, ffd, LVOLUME,
+				      fs_freesize, lsize);
+		if (error)
+			goto out;
+
+		error = shrinkfs(fsname, ffd, LVOLUME, lsize);
+		if (error)
+			goto out;
+		done = 1;
+	} else if (rflag && rsize > 0) {
+		error = shrinkfs_init(fsname, ffd, RVOLUME,
+				      fs_freesize, rsize);
+		if (error)
+			goto out;
+
+		error = shrinkfs(fsname, ffd, RVOLUME, rsize);
+		if (error)
+			goto out;
+		done = 1;
+	}
+
+	/* options are invalid */
+	if (!done) {
+		fprintf(stderr, _("%s: Invalid arguments %s\n"),
+			program, fsname);
+		goto out;
+	}
+
+	error = shrinkfs_done(fsname, ffd);
+
+out:
+	if (ffd > 0)
+		close(ffd);
+
+	return error;
+}
diff --git a/shrinkfs/xfs_shrinkfs.sh b/shrinkfs/xfs_shrinkfs.sh
new file mode 100755
index 0000000..319f09b
--- /dev/null
+++ b/shrinkfs/xfs_shrinkfs.sh
@@ -0,0 +1,99 @@
+#!/bin/sh -f
+
+DEVICE=""
+declare -A FSINFO
+FS_FREEBLKS=0;
+END_AG_FREEBLKS=0;
+
+_check_permission()
+{
+	[ `id -u ` -ne 0 ] && {
+		echo "Abort shrinking: permission denied" && exit 1
+	}
+}
+
+_get_ag_freeblks()
+{
+	local __agno=$1
+	local -a __temp
+
+	__temp=(`xfs_db -r -c "agf $__agno" -c 'p freeblks' -c 'p btreeblks' \
+		$DEVICE|cut -d' ' -f 3,6`)
+	echo $((${__temp[0]}-${__temp[1]}))
+}
+
+#
+# Fetch the free blocks of lastest A.G.
+#
+_get_lastest_agfreeblks()
+{
+	local __agcount=0
+	local __agno=0
+
+	__agcount=`xfs_db -r -c 'sb' -c 'p agcount' $DEVICE|cut -d' ' -f 3`
+	__agno=$(($__agcount - 1))
+
+	END_AG_FREEBLKS=$(_get_ag_freeblks $__agno)
+}
+
+_get_fsfreeblks()
+{
+	local __fs_freebllks=0
+	local __ag_freeblks=0
+	local __agcount=0
+	local __i=0
+
+	__agcount=`xfs_db -r -c 'sb' -c 'p agcount' $DEVICE|cut -d' ' -f 3`
+	while [ $__i -lt ${__agcount} ]
+	do
+		__ag_freeblks=$(_get_ag_freeblks $__i)
+		let "__fs_freeblks += __ag_freeblks"
+		let "__i += 1"
+	done
+
+	FS_FREEBLKS=${__fs_freeblks}
+}
+
+OPTS=" "
+USAGE="Usage: xfs_shrinkfs [-V] [options] device mountpoint"
+
+while getopts "dlrnvD:L:R:V" c
+do
+	case $c in
+	d)	OPTS=$OPTS"-d ";;
+	l)	OPTS=$OPTS"-l ";;
+	r)	OPTS=$OPTS"-r ";;
+	m)	OPTS=$OPTS"-m ";;
+	n)	OPTS=$OPTS"-n ";;
+	v)	OPTS=$OPTS"-v ";;
+	D)	OPTS=$OPTS"-D $OPTARG";;
+	L)	OPTS=$OPTS"-L $OPTARG";;
+	R)	OPTS=$OPTS"-R $OPTARG";;
+	V)	xfs_shrink -V
+		status=$?
+		exit $status
+		;;
+	\?)	echo $USAGE 1>&2
+		exit 2
+		;;
+	esac
+done
+
+set -- extra $@
+shift $OPTIND
+case $# in
+	2)
+		DEVICE="$1"
+		MNTDIR="$2"
+		_check_permission
+		_get_fsfreeblks "${DEVICE}"
+		_get_lastest_agfreeblks
+		echo ${FS_FREEBLKS} ${END_AG_FREEBLKS} ${OPTS}
+		xfs_shrink -F "$FS_FREEBLKS" -f "$END_AG_FREEBLKS" $OPTS "${DEVICE}" "${MNTDIR}"
+		status=$?
+		;;
+	*)	echo $USAGE 1>&2
+		exit 2
+		;;
+esac
+exit $status
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
