Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4SFHpea260415 for <xfs@oss.sgi.com>; Thu, 28 May 2009 10:17:51 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EEDCCFAED92
	for <xfs@oss.sgi.com>; Thu, 28 May 2009 08:24:06 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Eyjow5DMslHF2Gl8 for
	<xfs@oss.sgi.com>; Thu, 28 May 2009 08:24:06 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1M9hMq-0000oO-Lj
	for xfs@oss.sgi.com; Thu, 28 May 2009 15:18:04 +0000
Date: Thu, 28 May 2009 11:18:04 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH, RFC] xfsprogs: add xfs_reno(8)
Message-ID: <20090528151804.GA31976@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
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

The Linux port of xfs_reno has been lingering around for a while, and
I think we'd be better off just merging it into xfsprogs.  The only
issue is that it requires libtattr and thuse we would add a libattr
dependency to xfsprogs.  But given that libattr is part of even the
most minimal Linux installations these days and used by thinks as
basic as cp or ls from coreutils I don't think that's an issue.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfsprogs-dev/Makefile
===================================================================
--- xfsprogs-dev.orig/Makefile	2009-05-10 16:42:02.000000000 +0000
+++ xfsprogs-dev/Makefile	2009-05-28 13:56:43.000000000 +0000
@@ -20,7 +20,7 @@
 
 LIB_SUBDIRS = libxfs libxlog libxcmd libhandle libdisk
 TOOL_SUBDIRS = copy db estimate fsck fsr growfs io logprint mkfs quota \
-		mdrestore repair rtcp m4 man doc po debian build
+		mdrestore repair rtcp reno m4 man doc po debian build
 
 SUBDIRS = include $(LIB_SUBDIRS) $(TOOL_SUBDIRS)
 
Index: xfsprogs-dev/man/man8/xfs_reno.8
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ xfsprogs-dev/man/man8/xfs_reno.8	2009-05-28 13:56:08.000000000 +0000
@@ -0,0 +1,117 @@
+.TH xfs_reno 8
+.SH NAME
+xfs_reno \- renumber XFS inodes
+.SH SYNOPSIS
+.B xfs_reno
+[
+.B \-fnpqv
+] [
+.B \-P
+.I interval
+]
+.I path
+.br
+.B xfs_reno \-r
+.I recover_file
+.SH DESCRIPTION
+.B xfs_reno
+is applicable only to XFS filesystems.
+.PP
+.B xfs_reno
+renumbers inodes. XFS supports 64-bit inode numbers, although by
+default it will avoid creating inodes with numbers greater than
+what can be contained within a 32-bit number. If a filesystem does
+contain inode numbers greater than 32-bits, then this can conflict with
+applications that do not support them.
+To recover from this situation previously, affected files would need
+to be copied (and so get a new inode number) and the old version
+removed. This can be time consuming and impractical for very large
+files and filesystems.
+.B xfs_reno
+can be used to renumber such inodes quickly.
+.B xfs_reno
+will copy the inodes of affected files and move the data from the old
+inode to the new without having to copy the data.
+.B xfs_reno
+relies on XFS in the kernel to allocate a new inode number, so if the
+filesystem has been mounted with the
+.I inode64
+mount option, the new inodes will quite possibly have inode numbers
+greater than 32-bits.
+.PP
+.B xfs_reno
+should only be used on a filesystem where it is necessary to
+renumber inodes. Use of
+.B xfs_reno
+on a regular basis is
+.IR "not recommended" .
+Apart from application compatibility, there is no particular advantage
+to be had from renumbering inodes.
+.PP
+.B xfs_reno
+works by traversing a directory tree, scanning all the directories
+and noting which files require renumbering. Once the scanning phase
+is done, it will process the appropriate files and directories. The
+directory's absolute pathname must be given to
+.BR xfs_reno .
+The following options are accepted by
+.BR xfs_reno .
+.TP
+.B \-f
+Force conversion on all inodes, rather than just those with a 64-bit
+inode number. This is not particularly useful except for debugging
+purposes.
+.TP
+.B \-n
+Do nothing, perform a trial run.
+.TP
+.B \-v
+Increases the verbosity of progress and error messages.  Additional
+.BR \-v 's
+can be used to further increase verbosity.
+.TP
+.B \-q
+Do not report progress, only errors.
+.TP
+.B \-p
+Show progress status.
+.TP
+.BI \-P " seconds"
+Set the interval for the progress status in seconds.  The default is 1
+second.
+.TP
+.B \-r
+Recover from an interrupted run.  If
+.B xfs_reno
+is interrupted, it will leave a file called
+.I xfs_reno.recover
+in the directory specified on the command line.  This file will
+contain enough information so that
+.B xfs_reno
+can either finish processing the file it was working on when
+interrupted or back out the last change it made, depending on how far
+through the process it had progressed.
+.B xfs_reno
+will only recover the single file it was working on so it will need
+to be run again on the directory to be sure that all the appropriate
+inodes have been converted.
+.SH EXAMPLES
+To renumber inodes with 64-bit inode numbers:
+.IP
+.B # xfs_reno -p /path/to/directory
+.PP
+To recover from an interrupted run:
+.IP
+.B # xfs_reno -r /path/to/directory/xfs_reno.recover
+.PP
+.SH FILES
+.PD
+.TP
+.I /path/xfs_reno.recover
+records the state where renumbering was interrupted.
+.PD
+.SH SEE ALSO
+.BR xfs_fsr (8),
+.BR xfs_ncheck (8),
+.BR fstab (5),
+.BR xfs (5).
Index: xfsprogs-dev/reno/Makefile
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ xfsprogs-dev/reno/Makefile	2009-05-28 13:56:08.000000000 +0000
@@ -0,0 +1,19 @@
+#
+# Copyright (c) 2007 Silicon Graphics, Inc.  All Rights Reserved.
+#
+
+TOPDIR = ..
+include $(TOPDIR)/include/builddefs
+
+LTCOMMAND = xfs_reno
+CFILES = xfs_reno.c
+LLDLIBS = $(LIBATTR)
+
+default: $(LTCOMMAND)
+
+include $(BUILDRULES)
+
+install: default
+	$(INSTALL) -m 755 -d $(PKG_BIN_DIR)
+	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_BIN_DIR)
+install-dev:
Index: xfsprogs-dev/reno/xfs_reno.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ xfsprogs-dev/reno/xfs_reno.c	2009-05-28 15:11:42.000000000 +0000
@@ -0,0 +1,2040 @@
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
+#define ATTRBUFSIZE	1024
+
+#define SCAN_PHASE	0x00
+#define DIR_PHASE	0x10	/* nothing done or all done */
+#define DIR_PHASE_1	0x11	/* target dir created */
+#define DIR_PHASE_2	0x12	/* temp dir created */
+#define DIR_PHASE_3	0x13	/* attributes backed up to temp */
+#define DIR_PHASE_4	0x14	/* dirents moved to target dir */
+#define DIR_PHASE_5	0x15	/* attributes applied to target dir */
+#define DIR_PHASE_6	0x16	/* src dir removed */
+#define DIR_PHASE_7	0x17	/* temp dir removed */
+#define DIR_PHASE_MAX	0x17
+#define FILE_PHASE	0x20	/* nothing done or all done */
+#define FILE_PHASE_1	0x21	/* temp file created */
+#define FILE_PHASE_2	0x22	/* swapped extents */
+#define FILE_PHASE_3	0x23	/* unlinked source */
+#define FILE_PHASE_4	0x24	/* renamed temp to source name */
+#define FILE_PHASE_MAX	0x24
+#define SLINK_PHASE	0x30	/* nothing done or all done */
+#define SLINK_PHASE_1	0x31	/* temp symlink created */
+#define SLINK_PHASE_2	0x32	/* symlink attrs copied */
+#define SLINK_PHASE_3	0x33	/* unlinked source */
+#define SLINK_PHASE_4	0x34	/* renamed temp to source name */
+#define SLINK_PHASE_MAX	0x34
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
+static char		*cur_temp;
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
+xfs_swapext(int fd, xfs_swapext_t *sx)
+{
+	return ioctl(fd, XFS_IOC_SWAPEXT, sx);
+}
+
+static int
+xfs_getxattr(int fd, struct fsxattr *attr)
+{
+	return ioctl(fd, XFS_IOC_FSGETXATTR, attr);
+}
+
+static int
+xfs_setxattr(int fd, struct fsxattr *attr)
+{
+	return ioctl(fd, XFS_IOC_FSSETXATTR, attr);
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
+/*
+ * Attribute cloning code - most of this is here because attr_copy does not
+ * let us pick and choose which attributes we want to copy.
+ */
+
+attr_multiop_t	attr_ops[ATTR_MAX_MULTIOPS];
+
+/*
+ * Grab attributes specified in attr_ops from source file and write them
+ * out on the destination file.
+ */
+
+static int
+attr_replicate(
+	char		*source,
+	char		*target,
+	int		count)
+{
+	int		j, k;
+
+	if (attr_multi(source, attr_ops, count, ATTR_DONTFOLLOW) < 0)
+		return -1;
+
+	for (k = 0; k < count; k++) {
+		if (attr_ops[k].am_error) {
+			err_message(_("Error %d getting attribute"),
+					attr_ops[k].am_error);
+			break;
+		}
+		attr_ops[k].am_opcode = ATTR_OP_SET;
+	}
+	if (attr_multi(target, attr_ops, k, ATTR_DONTFOLLOW) < 0)
+		err_message("on attr_multif set");
+	for (j = 0; j < k; j++) {
+		if (attr_ops[j].am_error) {
+			err_message(_("Error %d setting attribute"),
+					attr_ops[j].am_error);
+			return -1;
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * Copy all the attributes specified from src to dst.
+ */
+
+static int
+attr_clone_copy(
+	char		*source,
+	char		*target,
+	char		*list_buf,
+	char		*attr_buf,
+	int		buf_len,
+	int		flags)
+{
+        attrlist_t 	*alist;
+        attrlist_ent_t	*attr;
+        attrlist_cursor_t cursor;
+        int		space, i, j;
+	char		*ptr;
+
+        bzero((char *)&cursor, sizeof(cursor));
+        do {
+                if (attr_list(source, list_buf, ATTRBUFSIZE,
+                		flags | ATTR_DONTFOLLOW, &cursor) < 0) {
+			err_message("on attr_listf");
+                        return -1;
+		}
+
+                alist = (attrlist_t *)list_buf;
+
+		space = buf_len;
+		ptr = attr_buf;
+                for (j = 0, i = 0; i < alist->al_count; i++) {
+                        attr = ATTR_ENTRY(list_buf, i);
+			if (space < attr->a_valuelen) {
+				if (attr_replicate(source, target, j) < 0)
+					return -1;
+				j = 0;
+				space = buf_len;
+				ptr = attr_buf;
+			}
+			attr_ops[j].am_opcode = ATTR_OP_GET;
+			attr_ops[j].am_attrname = attr->a_name;
+			attr_ops[j].am_attrvalue = ptr;
+			attr_ops[j].am_length = (int) attr->a_valuelen;
+			attr_ops[j].am_flags = flags;
+			attr_ops[j].am_error = 0;
+			j++;
+			ptr += attr->a_valuelen;
+			space -= attr->a_valuelen;
+                }
+
+		log_message(LOG_NITTY, "copying attribute %d", i);
+
+		if (j) {
+			if (attr_replicate(source, target, j) < 0)
+				return -1;
+		}
+
+        } while (alist->al_more);
+
+        return 0;
+}
+
+static int
+clone_attribs(
+	char		*source,
+	char		*target)
+{
+	char		list_buf[ATTRBUFSIZE];
+	char		*attr_buf;
+	int		rval;
+
+	attr_buf = malloc(ATTR_MAX_VALUELEN * 2);
+	if (attr_buf == NULL) {
+		err_nomem();
+		return -1;
+	}
+	rval = attr_clone_copy(source, target, list_buf, attr_buf,
+			ATTR_MAX_VALUELEN * 2, 0);
+	if (rval == 0)
+		rval = attr_clone_copy(source, target, list_buf, attr_buf,
+				ATTR_MAX_VALUELEN * 2, ATTR_ROOT);
+	if (rval == 0)
+		rval = attr_clone_copy(source, target, list_buf, attr_buf,
+				ATTR_MAX_VALUELEN * 2, ATTR_SECURE);
+	free(attr_buf);
+	return rval;
+}
+
+static int
+dup_attributes(
+	char		*source,
+	int		sfd,
+	char		*target,
+	int		tfd)
+{
+	struct stat64	st;
+	struct timeval	tv[2];
+	struct fsxattr	fsx;
+
+	if (fstat64(sfd, &st) < 0) {
+		err_stat(source);
+		return -1;
+	}
+
+	if (xfs_getxattr(sfd, &fsx) < 0) {
+		err_stat(source);
+		return -1;
+	}
+
+	tv[0].tv_sec = st.st_atim.tv_sec;
+	tv[0].tv_usec = st.st_atim.tv_nsec / 1000;
+	tv[1].tv_sec = st.st_mtim.tv_sec;
+	tv[1].tv_usec = st.st_mtim.tv_nsec / 1000;
+
+	if (futimes(tfd, tv) < 0)
+		err_message(_("%s: Cannot update target times"), target);
+
+	if (fchown(tfd, st.st_uid, st.st_gid) < 0) {
+		err_message(_("%s: Cannot change target ownership to "
+				"uid(%d) gid(%d)"), target,
+				st.st_uid, st.st_gid);
+
+		if (fchmod(tfd, st.st_mode & ~(S_ISUID | S_ISGID)) < 0)
+			err_message(_("%s: Cannot change target mode "
+					"to (%o)"), target, st.st_mode);
+	} else if (fchmod(tfd, st.st_mode) < 0)
+		err_message(_("%s: Cannot change target mode to (%o)"),
+				target, st.st_mode);
+
+	if (xfs_setxattr(tfd, &fsx) < 0)
+		err_message(_("%s: Cannet set target extended "
+				"attributes"), target);
+
+	return clone_attribs(source, target);
+}
+
+static int
+move_dirents(
+	char		*srcpath,
+	char		*targetpath,
+	int		*move_count)
+{
+	int		rval = 0;
+	DIR		*srcd;
+	struct dirent64	*dp;
+	char		srcname[PATH_MAX];
+	char		targetname[PATH_MAX];
+
+	*move_count = 0;
+
+	srcd = opendir(srcpath);
+	if (srcd == NULL) {
+		err_open(srcpath);
+		return 1;
+	}
+
+	while ((dp = readdir64(srcd)) != NULL) {
+		if (dp->d_ino == 0 || !strcmp(dp->d_name, ".") ||
+				!strcmp(dp->d_name, ".."))
+			continue;
+
+		if (strlen(srcpath) + 1 + strlen(dp->d_name) >=
+				sizeof(srcname) - 1) {
+
+			err_message(_("%s/%s: Name too long"), srcpath,
+					dp->d_name);
+			rval = 1;
+			goto quit;
+		}
+
+		sprintf(srcname, "%s/%s", srcpath, dp->d_name);
+		sprintf(targetname, "%s/%s", targetpath, dp->d_name);
+
+		rval = rename(srcname, targetname);
+		if (rval != 0) {
+			err_message(_("failed to rename: \'%s\' to \'%s\'"),
+					srcname, targetname);
+			goto quit;
+		}
+
+		log_message(LOG_DEBUG, "rename %s -> %s", srcname, targetname);
+
+		(*move_count)++;
+	}
+
+quit:
+	closedir(srcd);
+	return rval;
+}
+
+static int
+process_dir(
+	bignode_t	*node)
+{
+	int		sfd = -1;
+	int		tfd = -1;
+	int		targetfd = -1;
+	int		rval = 0;
+	int		move_count = 0;
+	char		*srcname = NULL;
+	char		*pname = NULL;
+	struct stat64	s1;
+	struct fsxattr  fsx;
+	char		target[PATH_MAX] = "";
+
+	SET_PHASE(DIR_PHASE);
+
+	dump_node("directory", node);
+
+	cur_node = node;
+	srcname = node->paths[0];
+
+	if (stat64(srcname, &s1) < 0) {
+		if (errno != ENOENT) {
+			err_stat(srcname);
+			global_rval |= 2;
+		}
+		goto quit;
+	}
+	if (s1.st_ino <= XFS_MAXINUMBER_32 && !force_all) {
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
+	if (xfs_getxattr(sfd, &fsx) < 0) {
+		err_message(_("failed to get inode attrs: %s"), srcname);
+		goto quit;
+	}
+	if (fsx.fsx_xflags & (XFS_XFLAG_IMMUTABLE | XFS_XFLAG_APPEND)) {
+		err_message(_("%s: immutable/append, ignoring"), srcname);
+		global_rval |= 2;
+		rval = 0;
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
+	SET_PHASE(DIR_PHASE_1);
+
+	cur_target = strdup(target);
+	if (!cur_target) {
+		err_nomem();
+		goto quit;
+	}
+
+	sprintf(target, "%s/%sXXXXXX", pname, cmd_prefix);
+	if (mkdtemp(target) == NULL) {
+		err_message(_("unable to create tmp directory copy"));
+		goto quit;
+	}
+	SET_PHASE(DIR_PHASE_2);
+
+	cur_temp = strdup(target);
+	if (!cur_temp) {
+		err_nomem();
+		goto quit;
+	}
+
+	tfd = open(cur_temp, O_RDONLY);
+	if (tfd < 0) {
+		err_open(cur_temp);
+		goto quit;
+	}
+
+	targetfd = open(cur_target, O_RDONLY);
+	if (tfd < 0) {
+		err_open(cur_target);
+		goto quit;
+	}
+
+
+	/* copy timestamps, attribs and EAs, to cur_temp */
+	rval = dup_attributes(srcname, sfd, cur_temp, tfd);
+	if (rval != 0) {
+		err_message(_("unable to duplicate directory attributes: %s"),
+			    srcname);
+		goto quit_unlink;
+	}
+
+	SET_PHASE(DIR_PHASE_3);
+
+	/* move src dirents to cur_target (this changes timestamps on src) */
+	rval = move_dirents(srcname, cur_target, &move_count);
+	if (rval != 0) {
+		err_message(_("unable to move directory contents: %s to %s"),
+				srcname, cur_target);
+		/* uh oh, move everything back... */
+		if (move_count > 0)
+			goto quit_undo;
+	}
+
+	SET_PHASE(DIR_PHASE_4);
+
+	/* copy timestamps, attribs and EAs from cur_temp to cur_target */
+	rval = dup_attributes(cur_temp, tfd, cur_target, targetfd);
+	if (rval != 0) {
+		err_message(_("unable to duplicate directory attributes: %s"),
+				cur_temp);
+		goto quit_unlink;
+	}
+
+	SET_PHASE(DIR_PHASE_5);
+
+	/* rmdir src */
+	rval = rmdir(srcname);
+	if (rval != 0) {
+		err_message(_("unable to remove directory: %s"), srcname);
+		goto quit_undo;
+	}
+
+	SET_PHASE(DIR_PHASE_6);
+
+	rval = rmdir(cur_temp);
+	if (rval != 0)
+		err_message(_("unable to remove tmp directory: %s"), cur_temp);
+
+	SET_PHASE(DIR_PHASE_7);
+
+	/* rename cur_target src */
+	rval = rename(cur_target, srcname);
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
+ quit_undo:
+	if (move_dirents(cur_target, srcname, &move_count) != 0) {
+		/* oh, dear lord... let the admin clean this one up */
+		err_message(_("unable to move directory contents back: %s to %s"),
+				cur_target, srcname);
+		goto quit;
+	}
+	SET_PHASE(DIR_PHASE_3);
+
+ quit_unlink:
+	rmdir(cur_target);
+	rmdir(cur_temp);
+
+ quit:
+
+	SET_PHASE(DIR_PHASE);
+
+	if (sfd >= 0)
+		close(sfd);
+	if (tfd >= 0)
+		close(tfd);
+	if (targetfd >= 0)
+		close(targetfd);
+
+	free(pname);
+	free(cur_target);
+	free(cur_temp);
+
+	cur_target = NULL;
+	cur_temp = NULL;
+	cur_node = NULL;
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
+	struct stat64	s1;
+	char		*srcname = NULL;
+	char		*pname = NULL;
+	xfs_swapext_t	sx;
+	xfs_bstat_t	bstatbuf;
+	struct fsxattr  fsx;
+	char		target[PATH_MAX] = "";
+
+	SET_PHASE(FILE_PHASE);
+
+	dump_node("file", node);
+
+	cur_node = node;
+	srcname = node->paths[0];
+
+	bzero(&s1, sizeof(s1));
+	bzero(&bstatbuf, sizeof(bstatbuf));
+	bzero(&sx, sizeof(sx));
+
+	if (stat64(srcname, &s1) < 0) {
+		if (errno != ENOENT) {
+			err_stat(srcname);
+			global_rval |= 2;
+		}
+		goto quit;
+	}
+	if (s1.st_ino <= XFS_MAXINUMBER_32 && !force_all)
+		/* this file has changed, and no longer needs processing */
+		goto quit;
+
+	/* open and sync source */
+	sfd = open(srcname, O_RDWR | O_DIRECT);
+	if (sfd < 0) {
+		err_open(srcname);
+		rval = 1;
+		goto quit;
+	}
+	if (!platform_test_xfs_fd(sfd)) {
+		err_not_xfs(srcname);
+		rval = 1;
+		goto quit;
+	}
+	if (fsync(sfd) < 0) {
+		err_message(_("sync failed: %s: %s"),
+				srcname, strerror(errno));
+		rval = 1;
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
+	if ((s1.st_mode & S_ISGID) && !(s1.st_mode & S_IXGRP)) {
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
+		rval = 1;
+		goto quit;
+	}
+	if (fsx.fsx_xflags & (XFS_XFLAG_IMMUTABLE | XFS_XFLAG_APPEND)) {
+		err_message(_("%s: immutable/append, ignoring"), srcname);
+		global_rval |= 2;
+		goto quit;
+	}
+
+	rval = 1;
+
+	if (realuid != 0 && realuid != s1.st_uid) {
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
+	sprintf(target, "%s/%sXXXXXX", pname, cmd_prefix);
+	tfd = mkstemp(target);
+	if (tfd < 0) {
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
+	/* Setup direct I/O */
+	if (fcntl(tfd, F_SETFL, O_DIRECT) < 0 ) {
+		err_message(_("could not set O_DIRECT for %s on tmp: %s"),
+				srcname, target);
+		unlink(target);
+		goto quit;
+	}
+
+	/* copy attribs & EAs to target */
+	if (dup_attributes(srcname, sfd, target, tfd) != 0) {
+		err_message(_("unable to duplicate file attributes: %s"),
+				srcname);
+		unlink(target);
+		goto quit;
+	}
+
+	if (xfs_bulkstat_single(sfd, &s1.st_ino, &bstatbuf) < 0) {
+		err_message(_("unable to bulkstat source file: %s"),
+				srcname);
+		unlink(target);
+		goto quit;
+	}
+
+	if (bstatbuf.bs_ino != s1.st_ino) {
+		err_message(_("bulkstat of source file returned wrong inode: %s"),
+				srcname);
+		unlink(target);
+		goto quit;
+	}
+
+	ftruncate64(tfd, bstatbuf.bs_size);
+
+	/* swapextents src target */
+	sx.sx_stat     = bstatbuf; /* struct copy */
+	sx.sx_version  = XFS_SX_VERSION;
+	sx.sx_fdtarget = sfd;
+	sx.sx_fdtmp    = tfd;
+	sx.sx_offset   = 0;
+	sx.sx_length   = bstatbuf.bs_size;
+
+	/* Swap the extents */
+	rval = xfs_swapext(sfd, &sx);
+	if (rval < 0) {
+		if (log_level >= LOG_DEBUG) {
+			switch (errno) {
+			case ENOTSUP:
+				err_message("%s: file type not supported",
+					srcname);
+				break;
+			case EFAULT:
+				/* The file has changed since we started the copy */
+				err_message("%s: file modified, "
+					 "inode renumber aborted: %ld",
+					 srcname, bstatbuf.bs_size);
+				break;
+			case EBUSY:
+				/* Timestamp has changed or mmap'ed file */
+				err_message("%s: file busy", srcname);
+				break;
+			default:
+				err_message(_("Swap extents failed: %s: %s"),
+					srcname, strerror(errno));
+				break;
+			}
+		} else
+			err_message(_("Swap extents failed: %s: %s"),
+					srcname, strerror(errno));
+		goto quit;
+	}
+
+	if (bstatbuf.bs_dmevmask | bstatbuf.bs_dmstate) {
+		struct fsdmidata fssetdm;
+
+		/* Set the DMAPI Fields. */
+		fssetdm.fsd_dmevmask = bstatbuf.bs_dmevmask;
+		fssetdm.fsd_padding = 0;
+		fssetdm.fsd_dmstate = bstatbuf.bs_dmstate;
+
+		if (ioctl(tfd, XFS_IOC_FSSETDM, (void *)&fssetdm ) < 0)
+			err_message(_("attempt to set DMI attributes "
+					"of %s failed"), target);
+	}
+
+	SET_PHASE(FILE_PHASE_2);
+
+	/* unlink src */
+	rval = unlink(srcname);
+	if (rval != 0) {
+		err_message(_("unable to remove file: %s"), srcname);
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
+
+ quit:
+	cur_node = NULL;
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
+	int		i = 0;
+	int		rval = 0;
+	struct stat64	st;
+	char		*srcname = NULL;
+	char		*pname = NULL;
+	char		target[PATH_MAX] = "";
+	char		linkbuf[PATH_MAX];
+
+	SET_PHASE(SLINK_PHASE);
+
+	dump_node("symlink", node);
+
+	cur_node = node;
+	srcname = node->paths[0];
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
+	if (mktemp(target) == NULL) {
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
+	/* copy ownership & EAs to target */
+	if (lchown(target, st.st_uid, st.st_gid) < 0) {
+		err_message(_("%s: Cannot change target ownership to "
+				"uid(%d) gid(%d)"), target,
+				st.st_uid, st.st_gid);
+		unlink(target);
+		goto quit;
+	}
+
+	if (clone_attribs(srcname, target) != 0) {
+		err_message(_("unable to duplicate symlink attributes: %s"),
+				srcname);
+		unlink(target);
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
+ quit:
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
+	len += sprintf(buf + len, "target: %s\ntemp: %s\nend\n",
+			cur_target, cur_temp);
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
+	 	} else
+	 	if (cur_phase >= FILE_PHASE && cur_phase <= FILE_PHASE_MAX) {
+			nodes = numfilenodes;
+			done = numfilesdone;
+			typename = _("files");
+	  	} else {
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
+	struct stat64	s;
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
+			if (stat64(buf, &s) < 0) {
+				err_message(_("Recovery failed: cannot "
+						"stat '%s'"), buf);
+				goto quit;
+			}
+			if (s.st_ino != ino) {
+				err_message(_("Recovery failed: inode "
+						"number for '%s' does not "
+						"match recorded number"), buf);
+				goto quit;
+			}
+
+			if (first_path) {
+				first_path = 0;
+				*node = add_node_path(ino, ftw_flags, buf);
+			}
+			else {
+				add_path(*node, buf);
+			}
+		}
+		else if (strncmp(buf, "target: ", 8) == 0) {
+			*target = strdup(buf + 8);
+			if (*target == NULL) {
+				err_nomem();
+				goto quit;
+			}
+			if (stat64(*target, &s) < 0) {
+				err_message(_("Recovery failed: cannot "
+						"stat '%s'"), *target);
+				goto quit;
+			}
+		}
+		else if (strncmp(buf, "temp: ", 6) == 0) {
+			*temp = strdup(buf + 6);
+			if (*temp == NULL) {
+				err_nomem();
+				goto quit;
+			}
+		}
+		else if (strcmp(buf, "end") == 0) {
+			rval = 0;
+			goto quit;
+	 	}
+	 	else {
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
+	int		tfd = -1;
+	int		targetfd = -1;
+	char		*srcname = NULL;
+	int		rval = 0;
+	int		i;
+	int		move_count = 0;
+
+	dump_node("recover", node);
+	log_message(LOG_DEBUG, "target: %s, phase: %x", target, phase);
+
+	if (node)
+		srcname = node->paths[0];
+
+	switch (phase) {
+
+	case DIR_PHASE_2:
+rmtemps:
+		log_message(LOG_NORMAL, _("Removing temporary directory: '%s'"),
+				tname);
+		if (rmdir(tname) < 0 && errno != ENOENT) {
+			err_message(_("unable to remove directory: %s"), tname);
+			rval = 1;
+		}
+		/* FALL THRU */
+	case DIR_PHASE_1:
+		log_message(LOG_NORMAL, _("Removing target directory: '%s'"),
+				target);
+		if (rmdir(target) < 0 && errno != ENOENT) {
+			err_message(_("unable to remove directory: %s"),
+					target);
+			rval = 1;
+		}
+		break;
+
+	case DIR_PHASE_3:
+		log_message(LOG_NORMAL, _("Completing moving directory "
+				"contents: '%s' to '%s'"), srcname, target);
+		if (move_dirents(srcname, target, &move_count) != 0) {
+			err_message(_("unable to move directory contents: "
+					"%s to %s"), srcname, target);
+			/* uh oh, move everything back... */
+			if (move_count > 0) {
+				if (move_dirents(target, srcname,
+						&move_count) != 0) {
+					/* oh, dear lord... let the admin
+					 * clean this one up */
+					err_message(_("unable to move directory "
+						"contents back: %s to %s"),
+						target, srcname);
+					exit(1);
+				}
+			}
+			goto rmtemps;
+		}
+		/* FALL THRU */
+	case DIR_PHASE_4:
+		log_message(LOG_NORMAL, _("Setting attributes for target "
+				"directory: \'%s\'"), target);
+		tfd = open(tname, O_RDONLY);
+		if (tfd < 0) {
+			err_open(tname);
+			rval = 1;
+			break;
+		}
+		targetfd = open(target, O_RDONLY);
+		if (targetfd < 0) {
+			err_open(target);
+			rval = 1;
+			break;
+		}
+		rval = dup_attributes(tname, tfd, target, targetfd);
+		if (rval != 0) {
+			err_message(_("unable to duplicate directory "
+					"attributes: %s"), tname);
+			break;
+		}
+		close(tfd);
+		close(targetfd);
+		/* FALL THRU */
+	case DIR_PHASE_6:
+		log_message(LOG_NORMAL, _("Removing temporary directory: \'%s\'"),
+				tname);
+		if (rmdir(tname) < 0 && errno != ENOENT) {
+			err_message(_("unable to remove directory: %s"),
+					tname);
+			rval = 1;
+			break;
+		}
+		/* FALL THRU */
+	case DIR_PHASE_5:
+		log_message(LOG_NORMAL, _("Removing old directory: \'%s\'"),
+				srcname);
+		if (rmdir(srcname) < 0 && errno != ENOENT) {
+			err_message(_("unable to remove directory: %s"),
+					srcname);
+			rval = 1;
+			break;
+		}
+		/* FALL THRU */
+	case DIR_PHASE_7:
+		log_message(LOG_NORMAL, _("Renaming new directory to old "
+			"directory: \'%s\' -> \'%s\'"), target, srcname);
+		rval = rename(target, srcname);
+		if (rval != 0) {
+			/* we can't abort since the src dir is now gone.
+			 * let the admin clean this one up
+			 */
+			err_message(_("unable to rename directory: %s to %s"),
+					target, srcname);
+			break;
+		}
+		break;
+
+
+	case FILE_PHASE_1:
+	case SLINK_PHASE_1:
+		log_message(LOG_NORMAL, _("Unlinking temporary file: \'%s\'"),
+				target);
+		unlink(target);
+		break;
+
+	case FILE_PHASE_2:
+	case SLINK_PHASE_2:
+		log_message(LOG_NORMAL, _("Unlinking old file: \'%s\'"),
+				srcname);
+		rval = unlink(srcname);
+		if (rval != 0) {
+			err_message(_("unable to remove file: %s"), srcname);
+			break;
+		}
+		/* FALL THRU */
+	case FILE_PHASE_3:
+	case SLINK_PHASE_3:
+		log_message(LOG_NORMAL, _("Renaming new file to old file: "
+				"\'%s\' -> \'%s\'"), target, srcname);
+		rval = rename(target, srcname);
+		if (rval != 0) {
+			/* we can't abort since the src file is now gone.
+			 * let the admin clean this one up
+			 */
+			err_message(_("unable to rename file: %s to %s"),
+					target, srcname);
+			break;
+		}
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
+	}
+	else {
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
+			err_message(_("%s: illegal option -- %c\n"), c);
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
+	if (p_opt && poll_interval == 0) {
+		poll_interval = 1;
+	}
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
+	}
+	else if (S_ISDIR(st.st_mode)) {
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
+	}
+	else {
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
+		}
+		else
+			log_message(LOG_INFO, _("\rNo directories to process..."));
+
+		if (numfilenodes) {
+			/* process files */
+			log_message(LOG_INFO, _("\rProcessing %d %s..."),
+					numfilenodes, numfilenodes == 1 ?
+						_("file") : _("files"));
+			cur_phase = FILE_PHASE;
+			for_all_nodes(process_file, FTW_F, 0);
+		}
+		else
+			log_message(LOG_INFO, _("\rNo files to process..."));
+
+		if (numslinknodes) {
+			/* process symlinks */
+			log_message(LOG_INFO, _("\rProcessing %d %s..."),
+					numslinknodes, numslinknodes == 1 ?
+						_("symlink") : _("symlinks"));
+			cur_phase = SLINK_PHASE;
+			for_all_nodes(process_slink, FTW_SL, 0);
+		}
+		else
+			log_message(LOG_INFO, _("\rNo symlinks to process..."));
+
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
Index: xfsprogs-dev/configure.in
===================================================================
--- xfsprogs-dev.orig/configure.in	2009-05-28 15:07:16.000000000 +0000
+++ xfsprogs-dev/configure.in	2009-05-28 15:07:25.000000000 +0000
@@ -60,6 +60,10 @@
 AC_PACKAGE_NEED_PTHREAD_H
 AC_PACKAGE_NEED_PTHREADMUTEXINIT
 
+AC_PACKAGE_NEED_ATTRIBUTES_H
+AC_PACKAGE_NEED_ATTRIBUTES_MACROS
+AC_PACKAGE_NEED_ATTRGET_LIBATTR
+
 AC_HAVE_FADVISE
 AC_HAVE_MADVISE
 AC_HAVE_MINCORE
Index: xfsprogs-dev/include/builddefs.in
===================================================================
--- xfsprogs-dev.orig/include/builddefs.in	2009-05-28 14:58:15.000000000 +0000
+++ xfsprogs-dev/include/builddefs.in	2009-05-28 14:58:38.000000000 +0000
@@ -25,6 +25,7 @@
 MALLOCLIB = @malloc_lib@
 LOADERFLAGS = @LDFLAGS@
 
+LIBATTR = @libattr@
 LIBRT = @librt@
 LIBUUID = @libuuid@
 LIBPTHREAD = @libpthread@
Index: xfsprogs-dev/m4/Makefile
===================================================================
--- xfsprogs-dev.orig/m4/Makefile	2009-05-28 14:57:04.000000000 +0000
+++ xfsprogs-dev/m4/Makefile	2009-05-28 14:57:10.000000000 +0000
@@ -8,6 +8,7 @@
 LSRCFILES = \
 	manual_format.m4 \
 	package_aiodev.m4 \
+	package_attrdev.m4 \
 	package_globals.m4 \
 	package_libcdev.m4 \
 	package_pthread.m4 \
Index: xfsprogs-dev/m4/package_attrdev.m4
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ xfsprogs-dev/m4/package_attrdev.m4	2009-05-28 14:56:47.000000000 +0000
@@ -0,0 +1,83 @@
+AC_DEFUN([AC_PACKAGE_NEED_ATTR_XATTR_H],
+  [ AC_CHECK_HEADERS([attr/xattr.h])
+    if test "$ac_cv_header_attr_xattr_h" != "yes"; then
+        echo
+        echo 'FATAL ERROR: attr/xattr.h does not exist.'
+        echo 'Install the extended attributes (attr) development package.'
+        echo 'Alternatively, run "make install-dev" from the attr source.'
+        exit 1
+    fi
+  ])
+
+AC_DEFUN([AC_PACKAGE_NEED_ATTR_ERROR_H],
+  [ AC_CHECK_HEADERS([attr/error_context.h])
+    if test "$ac_cv_header_attr_error_context_h" != "yes"; then
+        echo
+        echo 'FATAL ERROR: attr/error_context.h does not exist.'
+        echo 'Install the extended attributes (attr) development package.'
+        echo 'Alternatively, run "make install-dev" from the attr source.'
+        exit 1
+    fi
+  ])
+
+AC_DEFUN([AC_PACKAGE_NEED_ATTRIBUTES_H],
+  [ have_attributes_h=false
+    AC_CHECK_HEADERS([attr/attributes.h sys/attributes.h], [have_attributes_h=true], )
+    if test "$have_attributes_h" = "false"; then
+        echo
+        echo 'FATAL ERROR: attributes.h does not exist.'
+        echo 'Install the extended attributes (attr) development package.'
+        echo 'Alternatively, run "make install-dev" from the attr source.'
+        exit 1
+    fi
+  ])
+
+AC_DEFUN([AC_PACKAGE_WANT_ATTRLIST_LIBATTR],
+  [ AC_CHECK_LIB(attr, attr_list, [have_attr_list=true], [have_attr_list=false])
+    AC_SUBST(have_attr_list)
+  ])
+
+AC_DEFUN([AC_PACKAGE_NEED_GETXATTR_LIBATTR],
+  [ AC_CHECK_LIB(attr, getxattr,, [
+        echo
+        echo 'FATAL ERROR: could not find a valid Extended Attributes library.'
+        echo 'Install the extended attributes (attr) development package.'
+        echo 'Alternatively, run "make install-lib" from the attr source.'
+        exit 1
+    ])
+    libattr="-lattr"
+    test -f `pwd`/../attr/libattr/libattr.la && \
+        libattr="`pwd`/../attr/libattr/libattr.la"
+    test -f ${libexecdir}${libdirsuffix}/libattr.la && \
+	libattr="${libexecdir}${libdirsuffix}/libattr.la"
+    AC_SUBST(libattr)
+  ])
+
+AC_DEFUN([AC_PACKAGE_NEED_ATTRGET_LIBATTR],
+  [ AC_CHECK_LIB(attr, attr_get,, [
+        echo
+        echo 'FATAL ERROR: could not find a valid Extended Attributes library.'
+        echo 'Install the extended attributes (attr) development package.'
+        echo 'Alternatively, run "make install-lib" from the attr source.'
+        exit 1
+    ])
+    libattr="-lattr"
+    test -f `pwd`/../attr/libattr/libattr.la && \
+        libattr="`pwd`/../attr/libattr/libattr.la"
+    test -f ${libexecdir}${libdirsuffix}/libattr.la && \
+	libattr="${libexecdir}${libdirsuffix}/libattr.la"
+    AC_SUBST(libattr)
+  ])
+
+AC_DEFUN([AC_PACKAGE_NEED_ATTRIBUTES_MACROS],
+  [ AC_MSG_CHECKING([macros in attr/attributes.h])
+    AC_TRY_LINK([
+#include <sys/types.h>
+#include <attr/attributes.h>],
+    [ int x = ATTR_SECURE; ], [ echo ok ], [
+        echo
+	echo 'FATAL ERROR: could not find a current attributes header.'
+        echo 'Upgrade the extended attributes (attr) development package.'
+        echo 'Alternatively, run "make install-dev" from the attr source.'
+	exit 1 ])
+  ])

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
