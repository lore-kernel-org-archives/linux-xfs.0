Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAG6xsUk068857 for <xfs@oss.sgi.com>; Fri, 16 Nov 2012 00:59:54 -0600
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id DmNt00itFjTdaEuH (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 15 Nov 2012 23:01:56 -0800 (PST)
Message-ID: <50A5E4DA.4090609@oracle.com>
Date: Fri, 16 Nov 2012 15:01:46 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH] xfsprogs: xfs_reno(8)
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
Cc: bnaujok@sgi.com

Hello,

This is a revised version of xfs_reno(8), originally from Barry.
Currently, it works for regular files but failed for swapping directories.
I post it here since I tried to test the inode swap ioctl(2) via this program,
but it does not means that I took over this task.

I'll only continue to improve it if nobody is working on this tools.


Thanks,
-Jeff


Signed-off-by: Barry Naujok <bnaujok@sgi.com>
Signed-off-by: Jie Liu <jeff.liu@oracle.com>

---
 Makefile            |    2 +-
 include/xfs_dfrag.h |   20 +
 include/xfs_fs.h    |    8 +
 reno/Makefile       |   34 ++
 reno/xfs_reno.c     | 1647 +++++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 1710 insertions(+), 1 deletion(-)
 create mode 100644 reno/Makefile
 create mode 100644 reno/xfs_reno.c

diff --git a/Makefile b/Makefile
index 0bdc5e8..24c0997 100644
--- a/Makefile
+++ b/Makefile
@@ -41,7 +41,7 @@ endif
 
 LIB_SUBDIRS = libxfs libxlog libxcmd libhandle libdisk
 TOOL_SUBDIRS = copy db estimate fsck fsr growfs io logprint mkfs quota \
-		mdrestore repair rtcp m4 man doc po debian
+		mdrestore repair rtcp reno m4 man doc po debian
 
 SUBDIRS = include $(LIB_SUBDIRS) $(TOOL_SUBDIRS)
 
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
index faac5af..5b9c1b4 100644
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
@@ -483,6 +487,10 @@ typedef struct xfs_handle {
 #define XFS_IOC_ATTRMULTI_BY_HANDLE  _IOW ('X', 123, struct xfs_fsop_attrmulti_handlereq)
 #define XFS_IOC_FSGEOMETRY	     _IOR ('X', 124, struct xfs_fsop_geom)
 #define XFS_IOC_GOINGDOWN	     _IOR ('X', 125, __uint32_t)
+#define XFS_IOC_SET_AGSTATE	     _IOW ('X', 126, struct xfs_ioc_agstate)
+#define XFS_IOC_GET_AGSTATE	     _IOR ('X', 127, struct xfs_ioc_agstate)
+#define XFS_IOC_SWAPINO		     _IOWR ('X', 128, struct xfs_swapino)
+#define XFS_IOC_FSSHRINKFS_DATA	     _IOW ('X', 129, struct xfs_shrinkfs_data)
 /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
 
 
diff --git a/reno/Makefile b/reno/Makefile
new file mode 100644
index 0000000..3d9f165
--- /dev/null
+++ b/reno/Makefile
@@ -0,0 +1,34 @@
+#
+# Copyright (c) 2000-2001,2004-2005 Silicon Graphics, Inc.  All Rights Reserved.
+#
+
+TOPDIR = ..
+include $(TOPDIR)/include/builddefs
+
+LTCOMMAND = xfs_reno
+
+CFILES = xfs_reno.c
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
+	$(INSTALL) -m 755 xfs_reno $(PKG_SBIN_DIR)/xfs_reno
+install-dev:
+
+-include .dep
diff --git a/reno/xfs_reno.c b/reno/xfs_reno.c
new file mode 100644
index 0000000..0d7ab20
--- /dev/null
+++ b/reno/xfs_reno.c
@@ -0,0 +1,1647 @@
+/*
+ * Copyright (c) 2007 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+/*
+ * xfs_reno - renumber 64-bit inodes
+ *
+ * xfs_reno [-f] [-n] [-p] [-q] [-v] [-P seconds] path ...
+ * xfs_reno [-r] path ...
+ *
+ * Renumbers all inodes > 32 bits into 32 bit space. Requires the filesytem
+ * to be mounted with inode32.
+ *
+ *	-f		force conversion on all inodes rather than just
+ *			those with a 64bit inode number.
+ *	-n		nothing, do not renumber inodes
+ *	-p		show progress status.
+ *	-q		quiet, do not report progress, only errors.
+ *	-v		verbose, more -v's more verbose.
+ *	-P seconds	set the interval for the progress status in seconds.
+ *	-r		recover from an interrupted run.
+ */
+
+#include <xfs/xfs.h>
+
+#include <dirent.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <ftw.h>
+#include <libgen.h>
+#include <malloc.h>
+#include <signal.h>
+#include <stdint.h>
+#include <sys/ioctl.h>
+#include <attr/attributes.h>
+#include <xfs/xfs_dfrag.h>
+#include <xfs/xfs_inum.h>
+
+#define SCAN_PHASE	0x00
+#define DIR_PHASE	0x10	/* nothing done or all done */
+#define DIR_PHASE_1	0x11	/* temp dir created */
+#define DIR_PHASE_2	0x12	/* swapped extents and inodes */
+#define DIR_PHASE_3	0x13	/* src dir removed */
+#define DIR_PHASE_MAX	0x13	/* renamed temp to source name */
+#define FILE_PHASE	0x20	/* nothing done or all done */
+#define FILE_PHASE_1	0x21	/* temp file created */
+#define FILE_PHASE_2	0x22	/* swapped extents and inodes */
+#define FILE_PHASE_3	0x23	/* unlinked source */
+#define FILE_PHASE_4	0x24	/* hard links copied */
+#define FILE_PHASE_MAX	0x24	/* renamed temp to source name */
+#define SLINK_PHASE	0x30	/* nothing done or all done */
+#define SLINK_PHASE_1	0x31	/* temp symlink created */
+#define SLINK_PHASE_2	0x32	/* symlink attrs copied */
+#define SLINK_PHASE_3	0x33	/* unlinked source */
+#define SLINK_PHASE_4	0x34	/* hard links copied */
+#define SLINK_PHASE_MAX	0x34	/* renamed temp to source name */
+
+static void update_recoverfile(void);
+#define SET_PHASE(x)	(cur_phase = x, update_recoverfile())
+
+#define LOG_ERR		0
+#define LOG_NORMAL	1
+#define LOG_INFO	2
+#define LOG_DEBUG	3
+#define LOG_NITTY	4
+
+#define NH_BUCKETS	65536
+#define NH_HASH(ino)	(nodehash + ((ino) % NH_BUCKETS))
+
+typedef struct {
+	xfs_ino_t	ino;
+	int		ftw_flags;
+	nlink_t		numpaths;
+	char		**paths;
+} bignode_t;
+
+typedef struct {
+	bignode_t	*nodes;
+	uint64_t	listlen;
+	uint64_t	lastnode;
+} nodelist_t;
+
+static const char	*cmd_prefix = "xfs_reno_";
+
+static char		*progname;
+static int		log_level = LOG_NORMAL;
+static int		force_all;
+static nodelist_t	*nodehash;
+static int		realuid;
+static uint64_t		numdirnodes;
+static uint64_t		numfilenodes;
+static uint64_t		numslinknodes;
+static uint64_t		numdirsdone;
+static uint64_t		numfilesdone;
+static uint64_t		numslinksdone;
+static int		poll_interval;
+static time_t		starttime;
+static bignode_t	*cur_node;
+static char		*cur_target;
+static int		cur_phase;
+static int		highest_numpaths;
+static char		*recover_file;
+static int		recover_fd;
+static volatile int	poll_output;
+static int		global_rval;
+
+/*
+ * message handling
+ */
+static void
+log_message(
+	int		level,
+	char		*fmt, ...)
+{
+	char		buf[1024];
+	va_list		ap;
+
+	if (log_level < level)
+		return;
+
+	va_start(ap, fmt);
+	vsnprintf(buf, 1024, fmt, ap);
+	va_end(ap);
+
+	printf("%c%s: %s\n", poll_output ? '\n' : '\r', progname, buf);
+	poll_output = 0;
+}
+
+static void
+err_message(
+	char		*fmt, ...)
+{
+	char		buf[1024];
+	va_list		ap;
+
+	va_start(ap, fmt);
+	vsnprintf(buf, 1024, fmt, ap);
+	va_end(ap);
+
+	fprintf(stderr, "%c%s: %s\n", poll_output ? '\n' : '\r', progname, buf);
+	poll_output = 0;
+}
+
+static void
+err_nomem(void)
+{
+	err_message(_("Out of memory"));
+}
+
+static void
+err_open(
+	const char	*s)
+{
+	err_message(_("Cannot open %s: %s"), s, strerror(errno));
+}
+
+static void
+err_not_xfs(
+	const char 	*s)
+{
+	err_message(_("%s is not on an XFS filesystem"), s);
+}
+
+static void
+err_stat(
+	const char	*s)
+{
+	err_message(_("Cannot stat %s: %s\n"), s, strerror(errno));
+}
+
+static void
+err_swapino(
+	    int err,
+	    const char *srcname)
+{
+	if (log_level >= LOG_DEBUG) {
+		switch (err) {
+		case EIO:
+			err_message(_("Filesystem is going down: %s: %s"),
+				srcname, strerror(err));
+			break;
+
+		default:
+			err_message(_("Swap inode failed: %s: %s"),
+				srcname, strerror(err));
+			break;
+		}
+	} else
+		err_message(_("Swap inode failed: %s: %s"),
+				srcname, strerror(err));
+}
+
+/*
+ * usage message
+ */
+static void
+usage(void)
+{
+	fprintf(stderr, _("%s [-fnpqv] [-P <interval>] [-r] <path>\n"),
+			progname);
+	exit(1);
+}
+
+
+/*
+ * XFS interface functions
+ */
+
+static int
+xfs_bulkstat_single(int fd, xfs_ino_t *lastip, xfs_bstat_t *ubuffer)
+{
+	xfs_fsop_bulkreq_t  bulkreq;
+
+	bulkreq.lastip = (__u64 *)lastip;
+	bulkreq.icount = 1;
+	bulkreq.ubuffer = ubuffer;
+	bulkreq.ocount = NULL;
+	return ioctl(fd, XFS_IOC_FSBULKSTAT_SINGLE, &bulkreq);
+}
+
+static int
+xfs_swapino(int fd, xfs_swapino_t *iu)
+{
+	return ioctl(fd, XFS_IOC_SWAPINO, iu);
+}
+
+static int
+xfs_getxattr(int fd, struct fsxattr *attr)
+{
+	return ioctl(fd, XFS_IOC_FSGETXATTR, attr);
+}
+
+/*
+ * A hash table of inode numbers and associated paths.
+ */
+static nodelist_t *
+init_nodehash(void)
+{
+	int		i;
+
+	nodehash = calloc(NH_BUCKETS, sizeof(nodelist_t));
+	if (nodehash == NULL) {
+		err_nomem();
+		return NULL;
+	}
+
+	for (i = 0; i < NH_BUCKETS; i++) {
+		nodehash[i].nodes = NULL;
+		nodehash[i].lastnode = 0;
+		nodehash[i].listlen = 0;
+	}
+
+	return nodehash;
+}
+
+static void
+free_nodehash(void)
+{
+	int		i, j, k;
+
+	for (i = 0; i < NH_BUCKETS; i++) {
+		bignode_t *nodes = nodehash[i].nodes;
+
+		for (j = 0; j < nodehash[i].lastnode; j++) {
+			for (k = 0; k < nodes[j].numpaths; k++) {
+				free(nodes[j].paths[k]);
+			}
+			free(nodes[j].paths);
+		}
+
+		free(nodes);
+	}
+	free(nodehash);
+}
+
+static nlink_t
+add_path(
+	bignode_t	*node,
+	const char	*path)
+{
+	node->paths = realloc(node->paths,
+			      sizeof(char *) * (node->numpaths + 1));
+	if (node->paths == NULL) {
+		err_nomem();
+		exit(1);
+	}
+
+	node->paths[node->numpaths] = strdup(path);
+	if (node->paths[node->numpaths] == NULL) {
+		err_nomem();
+		exit(1);
+	}
+
+	node->numpaths++;
+	if (node->numpaths > highest_numpaths)
+		highest_numpaths = node->numpaths;
+
+	return node->numpaths;
+}
+
+static bignode_t *
+add_node(
+	nodelist_t	*list,
+	xfs_ino_t	ino,
+	int		ftw_flags,
+	const char	*path)
+{
+	bignode_t	*node;
+
+	if (list->lastnode >= list->listlen) {
+		list->listlen += 500;
+		list->nodes = realloc(list->nodes,
+					sizeof(bignode_t) * list->listlen);
+		if (list->nodes == NULL) {
+			err_nomem();
+			return NULL;
+		}
+	}
+
+	node = list->nodes + list->lastnode;
+
+	node->ino = ino;
+	node->ftw_flags = ftw_flags;
+	node->paths = NULL;
+	node->numpaths = 0;
+	add_path(node, path);
+
+	list->lastnode++;
+
+	return node;
+}
+
+static bignode_t *
+find_node(
+	xfs_ino_t	ino)
+{
+	int		i;
+	nodelist_t	*nodelist;
+	bignode_t	*nodes;
+
+	nodelist = NH_HASH(ino);
+	nodes = nodelist->nodes;
+
+	for(i = 0; i < nodelist->lastnode; i++) {
+		if (nodes[i].ino == ino) {
+			return &nodes[i];
+		}
+	}
+
+	return NULL;
+}
+
+static bignode_t *
+add_node_path(
+	xfs_ino_t	ino,
+	int		ftw_flags,
+	const char	*path)
+{
+	nodelist_t	*nodelist;
+	bignode_t	*node;
+
+	log_message(LOG_NITTY, "add_node_path: ino %llu, path %s", ino, path);
+
+	node = find_node(ino);
+	if (node == NULL) {
+		nodelist = NH_HASH(ino);
+		return add_node(nodelist, ino, ftw_flags, path);
+	}
+
+	add_path(node, path);
+	return node;
+}
+
+static void
+dump_node(
+	char		*msg,
+	bignode_t	*node)
+{
+	int		k;
+
+	if (log_level < LOG_DEBUG)
+		return;
+
+	log_message(LOG_DEBUG, "%s: %llu %llu %s", msg, node->ino,
+			node->numpaths, node->paths[0]);
+
+	for (k = 1; k < node->numpaths; k++)
+		log_message(LOG_DEBUG, "\t%s", node->paths[k]);
+}
+
+static void
+dump_nodehash(void)
+{
+	int		i, j;
+
+	if (log_level < LOG_NITTY)
+		return;
+
+	for (i = 0; i < NH_BUCKETS; i++) {
+		bignode_t	*nodes = nodehash[i].nodes;
+		for (j = 0; j < nodehash[i].lastnode; j++, nodes++)
+			dump_node("nodehash", nodes);
+	}
+}
+
+static int
+for_all_nodes(
+	int		(*fn)(bignode_t *node),
+	int		ftw_flags,
+	int		quit_on_error)
+{
+	int		i;
+	int		j;
+	int		rval = 0;
+
+	for (i = 0; i < NH_BUCKETS; i++) {
+		bignode_t	*nodes = nodehash[i].nodes;
+
+		for (j = 0; j < nodehash[i].lastnode; j++, nodes++) {
+			if (nodes->ftw_flags == ftw_flags) {
+				rval = fn(nodes);
+				if (rval && quit_on_error)
+					goto quit;
+			}
+		}
+	}
+
+quit:
+	return rval;
+}
+
+/*
+ * Adds appropriate files to the inode hash table
+ */
+static int
+nftw_addnodes(
+	const char	*path,
+	const struct stat64 *st,
+	int		flags,
+	struct FTW	*sntfw)
+{
+	if (st->st_ino <= XFS_MAXINUMBER_32 && !force_all)
+		return 0;
+
+	if (flags == FTW_F)
+		numfilenodes++;
+	else if (flags == FTW_D)
+		numdirnodes++;
+	else if (flags == FTW_SL)
+		numslinknodes++;
+	else
+		return 0;
+
+	add_node_path(st->st_ino, flags, path);
+
+	return 0;
+}
+
+static int
+process_dir(
+	bignode_t	*node)
+{
+	xfs_bstat_t	bstatbuf;
+	xfs_swapino_t	si;
+	struct stat64	st;
+	struct fsxattr  fsx;
+	char		*srcname = NULL;
+	char		*pname = NULL;
+	char		target[PATH_MAX] = "";
+	int		sfd = -1;
+	int		tfd = -1;
+	int		rval = 0;
+
+	SET_PHASE(DIR_PHASE);
+
+	dump_node("directory", node);
+
+	cur_node = node;
+	srcname = node->paths[0];
+
+	if (stat64(srcname, &st) < 0) {
+		if (errno != ENOENT) {
+			err_stat(srcname);
+			global_rval |= 2;
+		}
+		goto quit;
+	}
+	if (st.st_ino <= XFS_MAXINUMBER_32 && !force_all) {
+		/*
+		 * This directory has already changed ino's, probably due
+		 * to being moved during processing of a parent directory.
+		 */
+		log_message(LOG_DEBUG, "process_dir: skipping %s", srcname);
+		goto quit;
+	}
+
+	rval = 1;
+
+	sfd = open(srcname, O_RDONLY);
+	if (sfd == -1) {
+		err_open(srcname);
+		goto quit;
+	}
+
+	if (!platform_test_xfs_fd(sfd)) {
+		err_not_xfs(srcname);
+		goto quit;
+	}
+
+	if (fsync(sfd) < 0) {
+		err_message(_("sync failed: %s: %s"),
+				srcname, strerror(errno));
+		goto quit;
+	}
+
+	if (xfs_getxattr(sfd, &fsx) < 0) {
+		err_message(_("failed to get inode attrs: %s"), srcname);
+		goto quit;
+	}
+	if (fsx.fsx_xflags & (XFS_XFLAG_IMMUTABLE | XFS_XFLAG_APPEND)) {
+		err_message(_("%s: immutable/append, ignoring"), srcname);
+		global_rval |= 2;
+		goto quit;
+	}
+
+	if (realuid != 0 && realuid != st.st_uid) {
+		errno = EACCES;
+		err_open(srcname);
+		goto quit;
+	}
+
+	/* mkdir parent/target */
+	pname = strdup(srcname);
+	if (pname == NULL) {
+		err_nomem();
+		goto quit;
+	}
+	dirname(pname);
+	sprintf(target, "%s/%sXXXXXX", pname, cmd_prefix);
+	if (mkdtemp(target) == NULL) {
+		err_message(_("Unable to create directory copy: %s"), srcname);
+		goto quit;
+	}
+	tfd = open(target, O_RDONLY);
+	if (tfd == -1) {
+		err_open(target);
+		goto quit;
+	}
+
+	cur_target = strdup(target);
+	if (!cur_target) {
+		err_nomem();
+		goto quit;
+	}
+
+	SET_PHASE(DIR_PHASE_1);
+
+	if (xfs_bulkstat_single(sfd, &st.st_ino, &bstatbuf) < 0) {
+		err_message(_("unable to bulkstat source file: %s"),
+				srcname);
+		unlink(target);
+		goto quit;
+	}
+
+        /* switch to the owner's id, to keep quota in line */
+        if (fchown(tfd, bstatbuf.bs_uid, bstatbuf.bs_gid) < 0) {
+		err_message(_("unable to swith to the owner's id: %s"),
+				target);
+                close(tfd);
+                return -1;
+        }
+
+	/* swap the inodes */
+	si.si_version  = XFS_SI_VERSION;
+	si.si_fdtarget = tfd;
+	si.si_fdtmp    = sfd;
+	rval = xfs_swapino(tfd, &si);
+	if (rval < 0) {
+		err_swapino(rval, srcname);
+		goto quit_unlink;
+	}
+
+	fsync(sfd);
+	fsync(tfd);
+
+	SET_PHASE(DIR_PHASE_2);
+
+	/* rmdir source directory */
+	rval = execlp("rm", "rm", "-rf", srcname, (char *)0);
+	if (rval < 0) {
+		err_message(_("unable to remove directory %s as %s"),
+				srcname, strerror(errno));
+		goto quit_unlink;
+	}
+
+	SET_PHASE(DIR_PHASE_3);
+	/* rename cur_target src */
+	rval = rename(target, srcname);
+	if (rval != 0) {
+		/*
+		 * we can't abort since the src dir is now gone.
+		 * let the admin clean this one up
+		 */
+		err_message(_("unable to rename directory: %s to %s"),
+				cur_target, srcname);
+	}
+	goto quit;
+
+quit_unlink:
+	rval = rmdir(target);
+	if (rval != 0)
+		err_message(_("unable to remove directory: %s"), target);
+
+quit:
+	SET_PHASE(DIR_PHASE);
+
+	if (sfd >= 0)
+		close(sfd);
+	if (tfd >= 0)
+		close(tfd);
+
+	free(pname);
+	free(cur_target);
+
+	cur_target = NULL;
+	cur_node = NULL;
+
+	numdirsdone++;
+	return rval;
+}
+
+static int
+process_file(
+	bignode_t	*node)
+{
+	int		sfd = -1;
+	int		tfd = -1;
+	int		i = 0;
+	int		rval = 0;
+	struct stat64	st;
+	char		*srcname = NULL;
+	char		*pname = NULL;
+	xfs_swapino_t	si;
+	xfs_bstat_t	bstatbuf;
+	struct fsxattr  fsx;
+	char		target[PATH_MAX] = "";
+
+	cur_node = node;
+	srcname = node->paths[0];
+
+	if (stat64(srcname, &st) < 0) {
+		if (errno != ENOENT) {
+			err_stat(srcname);
+			global_rval |= 2;
+		}
+		goto quit;
+	}
+
+	/* this file has changed, and no longer needs processing */
+	if (st.st_ino <= XFS_MAXINUMBER_32 && !force_all)
+		goto quit;
+
+	rval = 1;
+	/* open and sync source */
+	sfd = open(srcname, O_RDWR | O_DIRECT);
+	if (sfd < 0) {
+		err_open(srcname);
+		goto quit;
+	}
+
+	if (!platform_test_xfs_fd(sfd)) {
+		err_not_xfs(srcname);
+		goto quit;
+	}
+
+	if (fsync(sfd) < 0) {
+		err_message(_("sync failed: %s: %s"),
+				srcname, strerror(errno));
+		goto quit;
+	}
+
+
+	/*
+	 * Check if a mandatory lock is set on the file to try and
+	 * avoid blocking indefinitely on the reads later. Note that
+	 * someone could still set a mandatory lock after this check
+	 * but before all reads have completed to block xfs_reno reads.
+	 * This change just closes the window a bit.
+	 */
+	if ((st.st_mode & S_ISGID) && !(st.st_mode & S_IXGRP)) {
+		struct flock fl;
+
+		fl.l_type = F_RDLCK;
+		fl.l_whence = SEEK_SET;
+		fl.l_start = (off_t)0;
+		fl.l_len = 0;
+		if (fcntl(sfd, F_GETLK, &fl) < 0 ) {
+			if (log_level >= LOG_DEBUG)
+				err_message("locking check failed: %s",
+						srcname);
+			global_rval |= 2;
+			goto quit;
+		}
+		if (fl.l_type != F_UNLCK) {
+			if (log_level >= LOG_DEBUG)
+				err_message("mandatory lock: %s: ignoring",
+						srcname);
+			global_rval |= 2;
+			goto quit;
+		}
+	}
+
+	if (xfs_getxattr(sfd, &fsx) < 0) {
+		err_message(_("failed to get inode attrs: %s"), srcname);
+		goto quit;
+	}
+	if (fsx.fsx_xflags & (XFS_XFLAG_IMMUTABLE | XFS_XFLAG_APPEND)) {
+		err_message(_("%s: immutable/append, ignoring"), srcname);
+		global_rval |= 2;
+		goto quit;
+	}
+
+	if (realuid != 0 && realuid != st.st_uid) {
+		errno = EACCES;
+		err_open(srcname);
+		goto quit;
+	}
+
+	/* creat target */
+	pname = strdup(srcname);
+	if (pname == NULL) {
+		err_nomem();
+		goto quit;
+	}
+	dirname(pname);
+
+	sprintf(target, "%s/%sXXXXXX", pname, cmd_prefix);
+	tfd = mkstemp(target);
+	if (tfd == -1) {
+		err_message("unable to create file copy");
+		goto quit;
+	}
+	cur_target = strdup(target);
+	if (cur_target == NULL) {
+		err_nomem();
+		goto quit;
+	}
+
+	SET_PHASE(FILE_PHASE_1);
+
+	if (xfs_bulkstat_single(sfd, &st.st_ino, &bstatbuf) < 0) {
+		err_message(_("unable to bulkstat source file: %s"),
+				srcname);
+		unlink(target);
+		goto quit;
+	}
+	if (bstatbuf.bs_ino != st.st_ino) {
+		err_message(_("bulkstat of source file returned wrong inode: %s"),
+				srcname);
+		unlink(target);
+		goto quit;
+	}
+
+	ftruncate64(tfd, bstatbuf.bs_size);
+
+        /* switch to the owner's id, to keep quota in line */
+        if (fchown(tfd, bstatbuf.bs_uid, bstatbuf.bs_gid) < 0) {
+		err_message(_("unable to swith to the owner's id: %s"),
+				target);
+                close(tfd);
+                return -1;
+        }
+
+	/* swapino src target */
+	si.si_version  = XFS_SI_VERSION;
+	si.si_fdtarget = tfd;
+	si.si_fdtmp    = sfd;
+
+	/* swap the inodes */
+	rval = xfs_swapino(tfd, &si);
+	if (rval < 0) {
+		err_swapino(rval, srcname);
+		goto quit_unlink;
+	}
+
+	SET_PHASE(FILE_PHASE_2);
+
+	/* unlink src */
+	rval = unlink(srcname);
+	if (rval != 0) {
+		err_message(_("unable to remove file %s: %s"),
+				srcname, strerror(errno));
+		goto quit;
+	}
+
+	SET_PHASE(FILE_PHASE_3);
+
+	/* rename target src */
+	rval = rename(target, srcname);
+	if (rval != 0) {
+		/*
+		 * we can't abort since the src file is now gone.
+		 * let the admin clean this one up
+		 */
+		err_message(_("unable to rename file: %s to %s"),
+				target, srcname);
+		goto quit;
+	}
+
+	SET_PHASE(FILE_PHASE_4);
+
+	/* for each hardlink, unlink and creat pointing to target */
+	for (i = 1; i < node->numpaths; i++) {
+		/* unlink src */
+		rval = unlink(node->paths[i]);
+		if (rval != 0) {
+			err_message(_("unable to remove file: %s"),
+				       node->paths[i]);
+			goto quit;
+		}
+
+		rval = link(srcname, node->paths[i]);
+		if (rval != 0) {
+			err_message("unable to link to file: %s", srcname);
+			goto quit;
+		}
+		numfilesdone++;
+	}
+	goto quit;
+
+quit_unlink:
+	rval = unlink(target);
+	if (rval != 0)
+		err_message(_("unable to remove file: %s"), target);
+
+quit:
+
+	SET_PHASE(FILE_PHASE);
+
+	if (sfd >= 0)
+		close(sfd);
+	if (tfd >= 0)
+		close(tfd);
+
+	free(pname);
+	free(cur_target);
+
+	cur_target = NULL;
+	cur_node = NULL;
+
+	numfilesdone++;
+	return rval;
+}
+
+
+static int
+process_slink(
+	bignode_t	*node)
+{
+	struct stat64	st;
+	xfs_swapino_t	si;
+	char		*srcname = NULL;
+	char		*pname = NULL;
+	char		target[PATH_MAX] = "";
+	char		linkbuf[PATH_MAX];
+	int		i = 0;
+	int		sfd = -1;
+	int		tfd = -1;
+	int		rval = 0;
+
+	SET_PHASE(SLINK_PHASE);
+
+	dump_node("symlink", node);
+
+	cur_node = node;
+	srcname = node->paths[0];
+
+	bzero(&st, sizeof(st));
+	bzero(&si, sizeof(si));
+
+	if (lstat64(srcname, &st) < 0) {
+		if (errno != ENOENT) {
+			err_stat(srcname);
+			global_rval |= 2;
+		}
+		goto quit;
+	}
+	if (st.st_ino <= XFS_MAXINUMBER_32 && !force_all)
+		/* this file has changed, and no longer needs processing */
+		goto quit;
+
+	rval = 1;
+
+	/* open source */
+	sfd = open(srcname, O_RDWR | O_DIRECT);
+	if (sfd < 0) {
+		err_open(srcname);
+		goto quit;
+	}
+
+	i = readlink(srcname, linkbuf, sizeof(linkbuf) - 1);
+	if (i < 0) {
+		err_message(_("unable to read symlink: %s"), srcname);
+		goto quit;
+	}
+	linkbuf[i] = '\0';
+
+	if (realuid != 0 && realuid != st.st_uid) {
+		errno = EACCES;
+		err_open(srcname);
+		goto quit;
+	}
+
+	/* create target */
+	pname = strdup(srcname);
+	if (pname == NULL) {
+		err_nomem();
+		goto quit;
+	}
+	dirname(pname);
+
+	sprintf(target, "%s/%sXXXXXX", pname, cmd_prefix);
+	tfd = mkstemp(target);
+	if (tfd == -1) {
+		err_message(_("unable to create temp symlink name"));
+		goto quit;
+	}
+	cur_target = strdup(target);
+	if (cur_target == NULL) {
+		err_nomem();
+		goto quit;
+	}
+
+	if (symlink(linkbuf, target) != 0) {
+		err_message(_("unable to create symlink: %s"), target);
+		goto quit;
+	}
+
+	SET_PHASE(SLINK_PHASE_1);
+
+	/* swapino src target */
+	si.si_version  = XFS_SI_VERSION;
+	si.si_fdtarget = tfd;
+	si.si_fdtmp    = sfd;
+
+	/* swap the inodes */
+	rval = xfs_swapino(tfd, &si);
+	if (rval < 0) {
+		err_swapino(rval, srcname);
+		goto quit;
+	}
+
+	SET_PHASE(SLINK_PHASE_2);
+
+	/* unlink src */
+	rval = unlink(srcname);
+	if (rval != 0) {
+		err_message(_("unable to remove symlink: %s"), srcname);
+		goto quit;
+	}
+
+	SET_PHASE(SLINK_PHASE_3);
+
+	/* rename target src */
+	rval = rename(target, srcname);
+	if (rval != 0) {
+		/*
+		 * we can't abort since the src file is now gone.
+		 * let the admin clean this one up
+		 */
+		err_message(_("unable to rename symlink: %s to %s"),
+				target, srcname);
+		goto quit;
+	}
+
+	SET_PHASE(SLINK_PHASE_4);
+
+	/* for each hardlink, unlink and creat pointing to target */
+	for (i = 1; i < node->numpaths; i++) {
+		/* unlink src */
+		rval = unlink(node->paths[i]);
+		if (rval != 0) {
+			err_message(_("unable to remove symlink: %s"),
+				       node->paths[i]);
+			goto quit;
+		}
+
+		rval = link(srcname, node->paths[i]);
+		if (rval != 0) {
+			err_message("unable to link to symlink: %s", srcname);
+			goto quit;
+		}
+		numslinksdone++;
+	}
+
+quit:
+	cur_node = NULL;
+
+	SET_PHASE(SLINK_PHASE);
+
+	free(pname);
+	free(cur_target);
+
+	cur_target = NULL;
+
+	numslinksdone++;
+	return rval;
+}
+
+static int
+open_recoverfile(void)
+{
+	recover_fd = open(recover_file, O_RDWR | O_SYNC | O_CREAT | O_EXCL,
+			0600);
+	if (recover_fd < 0) {
+		if (errno == EEXIST)
+			err_message(_("Recovery file already exists, either "
+				"run '%s -r %s' or remove the file."),
+				progname, recover_file);
+		else
+			err_open(recover_file);
+		return 1;
+	}
+
+	if (!platform_test_xfs_fd(recover_fd)) {
+		err_not_xfs(recover_file);
+		close(recover_fd);
+		return 1;
+	}
+
+	return 0;
+}
+
+static void
+update_recoverfile(void)
+{
+	static const char null_file[] = "0\n0\n0\n\ntarget: \ntemp: \nend\n";
+	static size_t	buf_size = 0;
+	static char	*buf = NULL;
+	int 		i, len;
+
+	if (recover_fd <= 0)
+		return;
+
+	if (cur_node == NULL || cur_phase == 0) {
+		/* inbetween processing or still scanning */
+		lseek(recover_fd, 0, SEEK_SET);
+		write(recover_fd, null_file, sizeof(null_file));
+		return;
+	}
+
+	ASSERT(highest_numpaths > 0);
+	if (buf == NULL) {
+		buf_size = (highest_numpaths + 3) * PATH_MAX;
+		buf = malloc(buf_size);
+		if (buf == NULL) {
+			err_nomem();
+			exit(1);
+		}
+	}
+
+	len = sprintf(buf, "%d\n%llu\n%d\n", cur_phase,
+			(long long)cur_node->ino, cur_node->ftw_flags);
+
+	for (i = 0; i < cur_node->numpaths; i++)
+		len += sprintf(buf + len, "%s\n", cur_node->paths[i]);
+
+	ASSERT(len < buf_size);
+
+	lseek(recover_fd, 0, SEEK_SET);
+	ftruncate(recover_fd, 0);
+	write(recover_fd, buf, len);
+}
+
+static void
+cleanup(void)
+{
+	log_message(LOG_NORMAL, _("Interrupted -- cleaning up..."));
+
+	free_nodehash();
+
+	log_message(LOG_NORMAL, _("Done."));
+}
+
+static void
+sighandler(int sig)
+{
+	static char	cycle[4] = "-\\|/";
+	static uint64_t	cur_cycle = 0;
+	double		percent;
+	char		*typename;
+	uint64_t	nodes, done;
+
+	alarm(0);
+
+	if (sig != SIGALRM) {
+		cleanup();
+		exit(1);
+	}
+
+	if (cur_phase == SCAN_PHASE) {
+		if (log_level >= LOG_INFO)
+			fprintf(stderr, _("\r%llu files, %llu dirs and %llu "
+				"symlinks to renumber found... %c"),
+				(long long)numfilenodes,
+				(long long)numdirnodes,
+				(long long)numslinknodes,
+				cycle[cur_cycle % 4]);
+		else
+			fprintf(stderr, "\r%c",
+				cycle[cur_cycle % 4]);
+		cur_cycle++;
+	} else {
+		if (cur_phase >= DIR_PHASE && cur_phase <= DIR_PHASE_MAX) {
+			nodes = numdirnodes;
+			done = numdirsdone;
+			typename = _("dirs");
+		} else if (cur_phase >= FILE_PHASE && cur_phase <= FILE_PHASE_MAX) {
+			nodes = numfilenodes;
+			done = numfilesdone;
+			typename = _("files");
+		} else {
+			nodes = numslinknodes;
+			done = numslinksdone;
+			typename = _("symlinks");
+		}
+		percent = 100.0 * (double)done / (double)nodes;
+		if (percent > 100.0)
+			percent = 100.0;
+		if (log_level >= LOG_INFO)
+			fprintf(stderr, _("\r%.1f%%, %llu of %llu %s, "
+					"%u seconds elapsed"), percent,
+					(long long)done, (long long)nodes,
+					typename, (int)(time(0) - starttime));
+		else
+			fprintf(stderr, "\r%.1f%%", percent);
+	}
+	poll_output = 1;
+	signal(SIGALRM, sighandler);
+
+	if (poll_interval)
+		alarm(poll_interval);
+}
+
+static int
+read_recover_file(
+	char		*recover_file,
+	bignode_t	**node,
+	char		**target,
+	char		**temp,
+	int		*phase)
+{
+	FILE		*file;
+	int		rval = 1;
+	ino_t		ino;
+	int		ftw_flags;
+	char		buf[PATH_MAX + 10]; /* path + "target: " */
+	struct stat64	st;
+	int		first_path;
+
+	/*
+
+	A recovery file should look like:
+
+	<phase>
+	<ino number>
+	<ftw flags>
+	<first path to inode>
+	<hardlinks to inode>
+	target: <path to target dir or file>
+	temp: <path to temp dir if dir phase>
+	end
+	*/
+
+	file = fopen(recover_file, "r");
+	if (file == NULL) {
+		err_open(recover_file);
+		return 1;
+	}
+
+	/* read phase */
+	*phase = 0;
+	if (fgets(buf, PATH_MAX + 10, file) == NULL) {
+		err_message("Recovery failed: unable to read phase");
+		goto quit;
+	}
+	buf[strlen(buf) - 1] = '\0';
+	*phase = atoi(buf);
+	if (*phase == SCAN_PHASE) {
+		fclose(file);
+		return 0;
+	}
+	if ((*phase < DIR_PHASE || *phase > DIR_PHASE_MAX) &&
+			(*phase < FILE_PHASE || *phase > FILE_PHASE_MAX)) {
+		err_message("Recovery failed: failed to read valid recovery phase");
+		goto quit;
+	}
+
+	/* read inode number */
+	if (fgets(buf, PATH_MAX + 10, file) == NULL) {
+		err_message("Recovery failed: unable to read inode number");
+		goto quit;
+	}
+	buf[strlen(buf) - 1] = '\0';
+	ino = strtoull(buf, NULL, 10);
+	if (ino == 0) {
+		err_message("Recovery failed: unable to read inode number");
+		goto quit;
+	}
+
+	/* read ftw_flags */
+	if (fgets(buf, PATH_MAX + 10, file) == NULL) {
+		err_message("Recovery failed: unable to read flags");
+		goto quit;
+	}
+	buf[strlen(buf) - 1] = '\0';
+	if (buf[1] != '\0' || (buf[0] != '0' && buf[0] != '1')) {
+		err_message("Recovery failed: unable to read flags: '%s'", buf);
+		goto quit;
+	}
+	ftw_flags = atoi(buf);
+
+	/* read paths and target path */
+	*node = NULL;
+	*target = NULL;
+	first_path = 1;
+	while (fgets(buf, PATH_MAX + 10, file) != NULL) {
+		buf[strlen(buf) - 1] = '\0';
+
+		log_message(LOG_DEBUG, "path: '%s'", buf);
+
+		if (buf[0] == '/') {
+			if (stat64(buf, &st) < 0) {
+				err_message(_("Recovery failed: cannot "
+						"stat '%s'"), buf);
+				goto quit;
+			}
+			if (st.st_ino != ino) {
+				err_message(_("Recovery failed: inode "
+						"number for '%s' does not "
+						"match recorded number"), buf);
+				goto quit;
+			}
+
+			if (first_path) {
+				first_path = 0;
+				*node = add_node_path(ino, ftw_flags, buf);
+			} else {
+				add_path(*node, buf);
+			}
+		} else if (strncmp(buf, "target: ", 8) == 0) {
+			*target = strdup(buf + 8);
+			if (*target == NULL) {
+				err_nomem();
+				goto quit;
+			}
+			if (stat64(*target, &st) < 0) {
+				err_message(_("Recovery failed: cannot "
+						"stat '%s'"), *target);
+				goto quit;
+			}
+		} else if (strncmp(buf, "temp: ", 6) == 0) {
+			*temp = strdup(buf + 6);
+			if (*temp == NULL) {
+				err_nomem();
+				goto quit;
+			}
+		} else if (strcmp(buf, "end") == 0) {
+			rval = 0;
+			goto quit;
+		} else {
+			err_message(_("Recovery failed: unrecognised "
+					"string: '%s'"), buf);
+			goto quit;
+		}
+	}
+
+	err_message(_("Recovery failed: end of recovery file not found"));
+
+ quit:
+	if (*node == NULL) {
+		err_message(_("Recovery failed: no valid inode or paths "
+				"specified"));
+		rval = 1;
+	}
+
+	if (*target == NULL) {
+		err_message(_("Recovery failed: no inode target specified"));
+		rval = 1;
+	}
+
+	fclose(file);
+
+	return rval;
+}
+
+int
+recover(
+	bignode_t	*node,
+	char		*target,
+	char		*tname,
+	int		phase)
+{
+	char		*srcname = NULL;
+	int		rval = 0;
+	int		i;
+	int		dir;
+
+	dump_node("recover", node);
+	log_message(LOG_DEBUG, "target: %s, phase: %x", target, phase);
+
+	if (node)
+		srcname = node->paths[0];
+
+	dir = (phase < DIR_PHASE || phase > DIR_PHASE_MAX);
+
+	switch (phase) {
+
+	case DIR_PHASE_1:
+	case FILE_PHASE_1:
+	case SLINK_PHASE_1:
+		log_message(LOG_NORMAL, _("Unlinking temporary %s: \'%s\'"),
+			    dir ? "directory" : "file", target);
+
+		rval = dir ? rmdir(target) : unlink(target);
+
+		if ( rval < 0 && errno != ENOENT)
+			err_message(_("unable to remove %s: %s"),
+				    dir ? "directory" : "file", target);
+
+		break;
+
+	case DIR_PHASE_2:
+	case FILE_PHASE_2:
+	case SLINK_PHASE_2:
+		log_message(LOG_NORMAL, _("Unlinking old %s: \'%s\'"),
+				dir ? "directory" : "file", srcname);
+
+		rval = dir ? rmdir(target) : unlink(srcname);
+
+		if (rval < 0 && errno != ENOENT) {
+			err_message(_("unable to remove %s: %s"),
+				    dir ? "directory" : "file", srcname);
+			break;
+		}
+		/* FALL THRU */
+	case DIR_PHASE_3:
+	case FILE_PHASE_3:
+	case SLINK_PHASE_3:
+		log_message(LOG_NORMAL, _("Renaming: "
+				"\'%s\' -> \'%s\'"), target, srcname);
+		rval = rename(target, srcname);
+		if (rval != 0) {
+			/* we can't abort since the src file is now gone.
+			 * let the admin clean this one up
+			 */
+			err_message(_("unable to rename: %s to %s"),
+					target, srcname);
+			break;
+		}
+		if (dir)
+			break;
+		/* FALL THRU */
+	case FILE_PHASE_4:
+	case SLINK_PHASE_4:
+		/* for each hardlink, unlink and creat pointing to target */
+		for (i = 1; i < node->numpaths; i++) {
+			if (i == 1)
+				log_message(LOG_NORMAL, _("Resetting hardlinks "
+						"to new file"));
+
+			rval = unlink(node->paths[i]);
+			if (rval != 0) {
+				err_message(_("unable to remove file: %s"),
+						node->paths[i]);
+				break;
+			}
+			rval = link(srcname, node->paths[i]);
+			if (rval != 0) {
+				err_message(_("unable to link to file: %s"),
+						srcname);
+				break;
+			}
+		}
+		break;
+	}
+
+	if (rval == 0) {
+		log_message(LOG_NORMAL, _("Removing recover file: \'%s\'"),
+				recover_file);
+		unlink(recover_file);
+		log_message(LOG_NORMAL, _("Recovery done."));
+	} else {
+		log_message(LOG_NORMAL, _("Leaving recover file: \'%s\'"),
+				recover_file);
+		log_message(LOG_NORMAL, _("Recovery failed."));
+	}
+
+	return rval;
+}
+
+int
+main(
+	int		argc,
+	char		*argv[])
+{
+	int		c = 0;
+	int		rval = 0;
+	int		q_opt = 0;
+	int		v_opt = 0;
+	int		p_opt = 0;
+	int		n_opt = 0;
+	char		pathname[PATH_MAX];
+	struct stat64	st;
+
+	progname = basename(argv[0]);
+
+	setlocale(LC_ALL, "");
+	bindtextdomain(PACKAGE, LOCALEDIR);
+	textdomain(PACKAGE);
+
+	while ((c = getopt(argc, argv, "fnpqvP:r:")) != -1) {
+		switch (c) {
+		case 'f':
+			force_all = 1;
+			break;
+		case 'n':
+			n_opt++;
+			break;
+		case 'p':
+			p_opt++;
+			break;
+		case 'q':
+			if (v_opt)
+				err_message(_("'q' option incompatible "
+						"with 'v' option"));
+			q_opt++;
+			log_level=0;
+			break;
+		case 'v':
+			if (q_opt)
+				err_message(_("'v' option incompatible "
+						"with 'q' option"));
+			v_opt++;
+			log_level++;
+			break;
+		case 'P':
+			poll_interval = atoi(optarg);
+			break;
+		case 'r':
+			recover_file = optarg;
+			break;
+		default:
+			err_message(_("%s: illegal option -- %c\n"), progname, c);
+			usage();
+			/* NOTREACHED */
+			break;
+		}
+	}
+
+	if (optind != argc - 1 && recover_file == NULL) {
+		usage();
+		exit(1);
+	}
+
+	realuid = getuid();
+	starttime = time(0);
+
+	init_nodehash();
+
+	signal(SIGALRM, sighandler);
+	signal(SIGABRT, sighandler);
+	signal(SIGHUP, sighandler);
+	signal(SIGINT, sighandler);
+	signal(SIGQUIT, sighandler);
+	signal(SIGTERM, sighandler);
+
+	if (p_opt && poll_interval == 0)
+		poll_interval = 1;
+
+	if (poll_interval)
+		alarm(poll_interval);
+
+	if (recover_file) {
+		bignode_t	*node = NULL;
+		char		*target = NULL;
+		char		*tname = NULL;
+		int		phase = 0;
+
+		if (n_opt)
+			goto quit;
+
+		/* read node info from recovery file */
+		if (read_recover_file(recover_file, &node, &target,
+				&tname, &phase) != 0)
+			exit(1);
+
+		rval = recover(node, target, tname, phase);
+
+		free(target);
+		free(tname);
+
+		return rval;
+	}
+
+	recover_file = malloc(PATH_MAX);
+	if (recover_file == NULL) {
+		err_nomem();
+		exit(1);
+	}
+	recover_file[0] = '\0';
+
+	strcpy(pathname, argv[optind]);
+	if (pathname[0] != '/') {
+		err_message(_("pathname must begin with a slash ('/')"));
+		exit(1);
+	}
+
+	if (stat64(pathname, &st) < 0) {
+		err_stat(pathname);
+		exit(1);
+	}
+	if (S_ISREG(st.st_mode)) {
+		/* single file specified */
+		if (st.st_nlink > 1) {
+			err_message(_("cannot process single file with a "
+					"link count greater than 1"));
+			exit(1);
+		}
+
+		strcpy(recover_file, pathname);
+		dirname(recover_file);
+
+		strcpy(recover_file + strlen(recover_file), "/xfs_reno.recover");
+		if (!n_opt) {
+			if (open_recoverfile() != 0)
+				exit(1);
+		}
+		add_node_path(st.st_ino, FTW_F, pathname);
+	} else if (S_ISDIR(st.st_mode)) {
+		/* directory tree specified */
+		strcpy(recover_file, pathname);
+
+		strcpy(recover_file + strlen(recover_file), "/xfs_reno.recover");
+		if (!n_opt) {
+			if (open_recoverfile() != 0)
+				exit(1);
+		}
+
+		/* directory scan */
+		log_message(LOG_INFO, _("\rScanning directory tree..."));
+		SET_PHASE(SCAN_PHASE);
+		nftw64(pathname, nftw_addnodes, 100, FTW_PHYS | FTW_MOUNT);
+	} else {
+		err_message(_("pathname must be either a regular file "
+				"or directory"));
+		exit(1);
+	}
+
+	dump_nodehash();
+
+	if (n_opt) {
+		/* n flag set, don't do anything */
+		if (numdirnodes)
+			log_message(LOG_NORMAL, "\rWould process %d %s",
+					numdirnodes, numdirnodes == 1 ?
+						"directory" : "directories");
+		else
+			log_message(LOG_NORMAL, "\rNo directories to process");
+
+		if (numfilenodes)
+			/* process files */
+			log_message(LOG_NORMAL, "\rWould process %d %s",
+					numfilenodes, numfilenodes == 1 ?
+						"file" : "files");
+		else
+			log_message(LOG_NORMAL, "\rNo files to process");
+		if (numslinknodes)
+			/* process files */
+			log_message(LOG_NORMAL, "\rWould process %d %s",
+					numslinknodes, numslinknodes == 1 ?
+						"symlinx" : "symlinks");
+		else
+			log_message(LOG_NORMAL, "\rNo symlinks to process");
+	} else {
+		/* process directories */
+		if (numdirnodes) {
+			log_message(LOG_INFO, _("\rProcessing %d %s..."),
+					numdirnodes, numdirnodes == 1 ?
+					    _("directory") : _("directories"));
+			cur_phase = DIR_PHASE;
+			rval = for_all_nodes(process_dir, FTW_D, 1);
+			if (rval != 0)
+				goto quit;
+		} else {
+			log_message(LOG_INFO, _("\rNo directories to process..."));
+		}
+
+		if (numfilenodes) {
+			/* process files */
+			log_message(LOG_INFO, _("\rProcessing %d %s..."),
+					numfilenodes, numfilenodes == 1 ?
+						_("file") : _("files"));
+			cur_phase = FILE_PHASE;
+			for_all_nodes(process_file, FTW_F, 0);
+		} else {
+			log_message(LOG_INFO, _("\rNo files to process..."));
+		}
+
+		if (numslinknodes) {
+			/* process symlinks */
+			log_message(LOG_INFO, _("\rProcessing %d %s..."),
+					numslinknodes, numslinknodes == 1 ?
+						_("symlink") : _("symlinks"));
+			cur_phase = SLINK_PHASE;
+			for_all_nodes(process_slink, FTW_SL, 0);
+		} else {
+			log_message(LOG_INFO, _("\rNo symlinks to process..."));
+		}
+	}
+quit:
+	free_nodehash();
+
+	close(recover_fd);
+
+	if (rval == 0)
+		unlink(recover_file);
+
+	log_message(LOG_DEBUG, "\r%u seconds elapsed", time(0) - starttime);
+	log_message(LOG_INFO, _("\rDone.     "));
+
+	return rval | global_rval;
+}
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
