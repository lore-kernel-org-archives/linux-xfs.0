Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oACHQpd5144839 for <xfs@oss.sgi.com>; Fri, 12 Nov 2010 11:26:52 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 157AD1C39C3C
	for <xfs@oss.sgi.com>; Fri, 12 Nov 2010 09:28:20 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id llL3vMzM372osPpy for
	<xfs@oss.sgi.com>; Fri, 12 Nov 2010 09:28:20 -0800 (PST)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oACHSKwY009294
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 12 Nov 2010 12:28:20 -0500
Received: from localhost.localdomain (test1244.test.redhat.com [10.10.10.244])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with
	ESMTP id oACHSJsU023874
	for <xfs@oss.sgi.com>; Fri, 12 Nov 2010 12:28:20 -0500
From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Xfsprogs: add fiemap command to xfs_io V2
Date: Fri, 12 Nov 2010 12:19:34 -0500
Message-Id: <1289582374-19324-1-git-send-email-josef@redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

When trying to add a test for hole punching I noticed that the "bmap" command
only works on XFS, which makes testing hole punching on other fs's kind of
difficult.  To fix this I've added an fiemap command that works almost exactly
like bmap.  It is formatted similarly and takes similar flags, the only thing
thats different is obviously it doesn't spit out AG info and it doesn't make
finding prealloc space optional.  This is my first foray into all of this stuff
so a good hard look would be appreciated.  I tested it with a few different
files to make sure bmap and fiemap both looked the same.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
V1->V2: add checks to make sure the system supports fiemap so xfsprogs builds on
things other than linux :).

 configure.in          |    1 +
 include/builddefs.in  |    1 +
 io/Makefile           |    7 +
 io/fiemap.c           |  342 +++++++++++++++++++++++++++++++++++++++++++++++++
 io/init.c             |    1 +
 io/io.h               |    6 +
 m4/package_libcdev.m4 |    8 +
 7 files changed, 366 insertions(+), 0 deletions(-)
 create mode 100644 io/fiemap.c

diff --git a/configure.in b/configure.in
index 30907de..16441ce 100644
--- a/configure.in
+++ b/configure.in
@@ -103,6 +103,7 @@ AC_HAVE_SENDFILE
 AC_HAVE_GETMNTENT
 AC_HAVE_GETMNTINFO
 AC_HAVE_FALLOCATE
+AC_HAVE_FIEMAP
 AC_HAVE_BLKID_TOPO($enable_blkid)
 
 AC_TYPE_PSINT
diff --git a/include/builddefs.in b/include/builddefs.in
index 93d1e67..f895ed9 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -98,6 +98,7 @@ HAVE_SENDFILE = @have_sendfile@
 HAVE_GETMNTENT = @have_getmntent@
 HAVE_GETMNTINFO = @have_getmntinfo@
 HAVE_FALLOCATE = @have_fallocate@
+HAVE_FIEMAP = @have_fiemap@
 
 GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall 
 #	   -Wbitwise -Wno-transparent-union -Wno-old-initializer -Wno-decl
diff --git a/io/Makefile b/io/Makefile
index fc98166..9d79dca 100644
--- a/io/Makefile
+++ b/io/Makefile
@@ -44,6 +44,13 @@ else
 LSRCFILES += sendfile.c
 endif
 
+ifeq ($(HAVE_FIEMAP),yes)
+CFILES += fiemap.c
+LCFLAGS += -DHAVE_FIEMAP
+else
+LSRCFILES += fiemap.c
+endif
+
 ifeq ($(PKG_PLATFORM),irix)
 LSRCFILES += inject.c resblks.c
 else
diff --git a/io/fiemap.c b/io/fiemap.c
new file mode 100644
index 0000000..0d9894a
--- /dev/null
+++ b/io/fiemap.c
@@ -0,0 +1,342 @@
+/*
+ * Copyright (c) 2010 Red Hat, Inc.
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
+#include <xfs/xfs.h>
+#include <xfs/command.h>
+#include <linux/fiemap.h>
+#include <linux/fs.h>
+#include "init.h"
+#include "io.h"
+
+static cmdinfo_t fiemap_cmd;
+
+static void
+fiemap_help(void)
+{
+	printf(_(
+"\n"
+" prints the block mapping for a file's data or attribute forks"
+"\n"
+" Example:\n"
+" 'bmap -vp' - tabular format verbose map, including unwritten extents\n"
+"\n"
+" bmap prints the map of disk blocks used by the current file.\n"
+" The map lists each extent used by the file, as well as regions in the\n"
+" file that do not have any corresponding blocks (holes).\n"
+" By default, each line of the listing takes the following form:\n"
+"     extent: [startoffset..endoffset]: startblock..endblock\n"
+" Holes are marked by replacing the startblock..endblock with 'hole'.\n"
+" All the file offsets and disk blocks are in units of 512-byte blocks.\n"
+" -a -- prints the attribute fork map instead of the data fork.\n"
+" -l -- also displays the length of each extent in 512-byte blocks.\n"
+" -n -- query n extents.\n"
+" -v -- Verbose information\n"
+" Note: the bmap for non-regular files can be obtained provided the file\n"
+" was opened appropriately (in particular, must be opened read-only).\n"
+"\n"));
+}
+
+static int
+numlen(
+	__u64	val,
+	int	base)
+{
+	__u64	tmp;
+	int	len;
+
+	for (len = 0, tmp = val; tmp > 0; tmp = tmp/base)
+		len++;
+	return (len == 0 ? 1 : len);
+}
+
+static void
+print_verbose(
+	struct fiemap_extent	*extent,
+	int			blocksize,
+	int			foff_w,
+	int			boff_w,
+	int			tot_w,
+	int			flg_w,
+	int			*cur_extent,
+	__u64			*last_logical)
+{
+	__u64			lstart;
+	__u64			len;
+	__u64			block;
+	char			lbuf[32];
+	char			bbuf[32];
+	char			flgbuf[16];
+
+	lstart = extent->fe_logical / blocksize;
+	len = extent->fe_length / blocksize;
+	block = extent->fe_physical / blocksize;
+
+	memset(lbuf, 0, sizeof(lbuf));
+	memset(bbuf, 0, sizeof(bbuf));
+
+	if (lstart != *last_logical) {
+		snprintf(lbuf, sizeof(lbuf), "[%llu..%llu]:", *last_logical,
+			 lstart - 1);
+		printf("%4d: %-*s %-*s %-*llu\n", *cur_extent, foff_w, lbuf,
+		       boff_w, _("hole"), tot_w, lstart - *last_logical);
+		(*cur_extent)++;
+		memset(lbuf, 0, sizeof(lbuf));
+	}
+	snprintf(lbuf, sizeof(lbuf), "[%llu..%llu]:", lstart,
+		 lstart + len - 1);
+	snprintf(bbuf, sizeof(bbuf), "%llu..%llu", block, block + len - 1);
+	snprintf(flgbuf, sizeof(flgbuf), "0x%x", extent->fe_flags);
+	printf("%4d: %-*s %-*s %*llu %*s\n", *cur_extent, foff_w, lbuf,
+	       boff_w, bbuf, tot_w, len, flg_w, flgbuf);
+
+	(*cur_extent)++;
+	*last_logical = lstart + len;
+}
+
+static void
+print_plain(
+	struct fiemap_extent	*extent,
+	int			lflag,
+	int			blocksize,
+	int			*cur_extent,
+	__u64			*last_logical)
+{
+	__u64			lstart;
+	__u64			block;
+	__u64			len;
+
+	lstart = extent->fe_logical / blocksize;
+	len = extent->fe_length / blocksize;
+	block = extent->fe_physical / blocksize;
+
+	if (lstart != *last_logical) {
+		printf("\t%d: [%llu..%llu]: hole", *cur_extent,
+		       *last_logical, lstart - 1LL);
+		if (lflag)
+			printf(_(" %llu blocks\n"),
+			       lstart - *last_logical);
+		else
+			printf("\n");
+		(*cur_extent)++;
+	}
+
+	printf("\t%d: [%llu..%llu]: %llu..%llu", *cur_extent,
+	       lstart, lstart + len - 1LL, block,
+	       block + len - 1);
+
+	if (lflag)
+		printf(_(" %llu blocks\n"), len);
+	else
+		printf("\n");
+	(*cur_extent)++;
+	*last_logical = lstart + len;
+}
+
+int
+fiemap_f(
+	int		argc,
+	char		**argv)
+{
+	struct fiemap	*fiemap;
+	int		num_extents = 32;
+	int		nflag = 0;
+	int		lflag = 0;
+	int		vflag = 0;
+	int		fiemap_flags = FIEMAP_FLAG_SYNC;
+	int		c;
+	int		i;
+	int		map_size;
+	int		ret;
+	int		cur_extent = 0;
+	int		foff_w = 16;	/* 16 just for a good minimum range */
+	int		boff_w = 16;
+	int		tot_w = 5;	/* 5 since its just one number */
+	int		flg_w = 5;
+	__u64		blocksize = 512;
+	__u64		last_logical = 0;
+	struct stat	st;
+
+	while ((c = getopt(argc, argv, "aln:v")) != EOF) {
+		switch (c) {
+		case 'a':
+			fiemap_flags |= FIEMAP_FLAG_XATTR;
+			break;
+		case 'l':
+			lflag = 1;
+			break;
+		case 'n':
+			num_extents = atoi(optarg);
+			nflag = 1;
+			break;
+		case 'v':
+			vflag++;
+			break;
+		default:
+			return command_usage(&fiemap_cmd);
+		}
+	}
+
+	map_size = sizeof(struct fiemap) +
+		(num_extents * sizeof(struct fiemap_extent));
+	fiemap = malloc(map_size);
+	if (!fiemap) {
+		fprintf(stderr, _("%s: malloc of %d bytes failed.\n"),
+			progname, map_size);
+		exitcode = 1;
+		return 0;
+	}
+
+	memset(fiemap, 0, map_size);
+	fiemap->fm_flags = fiemap_flags;
+	fiemap->fm_length = -1;
+	fiemap->fm_extent_count = nflag ? 0 : num_extents;
+
+	ret = ioctl(file->fd, FS_IOC_FIEMAP, (unsigned long)fiemap);
+	if (ret < 0) {
+		fprintf(stderr, "%s: ioctl(FS_IOC_FIEMAP) [\"%s\"]: "
+			"%s\n", progname, file->name, strerror(errno));
+		free(fiemap);
+		exitcode = 1;
+		return 0;
+	}
+
+	if (!nflag) {
+		if (fiemap->fm_mapped_extents > num_extents) {
+			num_extents = fiemap->fm_mapped_extents;
+			map_size = sizeof(struct fiemap) +
+				(num_extents * sizeof(struct fiemap_extent));
+			fiemap = realloc(fiemap, map_size);
+			if (!fiemap) {
+				fprintf(stderr, _("%s: realloc of %d bytes "
+						  "failed.\n"), progname,
+						  map_size);
+				exitcode = 1;
+				return 0;
+			}
+		}
+		memset(fiemap, 0, map_size);
+		fiemap->fm_flags = fiemap_flags;
+		fiemap->fm_length = -1;
+		fiemap->fm_extent_count = num_extents;
+
+		ret = ioctl(file->fd, FS_IOC_FIEMAP, (unsigned long)fiemap);
+		if (ret < 0) {
+			fprintf(stderr, "%s: ioctl(FS_IOC_FIEMAP) [\"%s\"]: "
+				"%s\n", progname, file->name, strerror(errno));
+			free(fiemap);
+			exitcode = 1;
+			return 0;
+		}
+	}
+
+	printf("%s:\n", file->name);
+
+	if (vflag) {
+		for (i = 0; i < fiemap->fm_mapped_extents; i++) {
+			char			lbuf[32];
+			char			bbuf[32];
+			__u64			logical;
+			__u64			block;
+			__u64			len;
+			struct fiemap_extent	*extent;
+
+			extent = &fiemap->fm_extents[i];
+			logical = extent->fe_logical / blocksize;
+			len = extent->fe_length / blocksize;
+			block = extent->fe_physical / blocksize;
+
+			snprintf(lbuf, sizeof(lbuf), "[%llu..%llu]", logical,
+				 logical + len - 1);
+			snprintf(bbuf, sizeof(bbuf), "%llu..%llu", block,
+				 block + len - 1);
+			foff_w = max(foff_w, strlen(lbuf));
+			boff_w = max(boff_w, strlen(bbuf));
+			tot_w = max(tot_w, numlen(len, 10));
+			flg_w = max(flg_w, numlen(extent->fe_flags, 16));
+			if (extent->fe_flags & FIEMAP_EXTENT_LAST)
+				break;
+		}
+		printf("%4s: %-*s %-*s %*s %*s\n", _("EXT"),
+		       foff_w, _("FILE-OFFSET"),
+		       boff_w, _("BLOCK-RANGE"),
+		       tot_w, _("TOTAL"),
+		       flg_w, _("FLAGS"));
+	}
+
+	for (i = 0; i < fiemap->fm_mapped_extents; i++) {
+		struct fiemap_extent	*extent;
+
+		extent = &fiemap->fm_extents[i];
+		if (vflag)
+			print_verbose(extent, blocksize, foff_w, boff_w, tot_w,
+				      flg_w, &cur_extent, &last_logical);
+		else
+			print_plain(extent, lflag, blocksize,
+				    &cur_extent, &last_logical);
+		if (extent->fe_flags & FIEMAP_EXTENT_LAST)
+			break;
+	}
+
+	memset(&st, 0, sizeof(st));
+	if (fstat(file->fd, &st)) {
+		fprintf(stderr, "%s: fstat failed: %s\n", progname,
+			strerror(errno));
+		free(fiemap);
+		exitcode = 1;
+		return 0;
+	}
+
+	if (cur_extent && last_logical < (st.st_size / blocksize)) {
+		char	lbuf[32];
+
+		snprintf(lbuf, sizeof(lbuf), "[%llu..%llu]:",
+			 last_logical, (st.st_size / blocksize) - 1);
+		if (vflag) {
+			printf("%4d: %-*s %-*s %*llu\n", cur_extent,
+			       foff_w, lbuf, boff_w, _("hole"), tot_w,
+			       (st.st_size / blocksize) - last_logical);
+		} else {
+			printf("\t%d: %s %s", cur_extent, lbuf,
+			       _("hole"));
+			if (lflag)
+				printf(_(" %llu blocks\n"),
+				       (st.st_size / blocksize) -
+				       last_logical);
+			else
+				printf("\n");
+		}
+	}
+
+	free(fiemap);
+	return 0;
+}
+
+void
+fiemap_init(void)
+{
+	fiemap_cmd.name = "fiemap";
+	fiemap_cmd.cfunc = fiemap_f;
+	fiemap_cmd.argmin = 0;
+	fiemap_cmd.argmax = -1;
+	fiemap_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
+	fiemap_cmd.args = _("[-alv] [-n nx]");
+	fiemap_cmd.oneline = _("print block mapping for a file");
+	fiemap_cmd.help = fiemap_help;
+
+	add_command(&fiemap_cmd);
+}
diff --git a/io/init.c b/io/init.c
index f8fc25d..a166ad1 100644
--- a/io/init.c
+++ b/io/init.c
@@ -71,6 +71,7 @@ init_commands(void)
 	parent_init();
 	pread_init();
 	prealloc_init();
+	fiemap_init();
 	pwrite_init();
 	quit_init();
 	resblks_init();
diff --git a/io/io.h b/io/io.h
index 630897d..2923362 100644
--- a/io/io.h
+++ b/io/io.h
@@ -135,3 +135,9 @@ extern void		mincore_init(void);
 #else
 #define mincore_init()	do { } while (0)
 #endif
+
+#ifdef HAVE_FIEMAP
+extern void		fiemap_init(void);
+#else
+#define fiemap_init()	do { } while (0)
+#endif
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index 1c1859d..8192181 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -116,3 +116,11 @@ AC_DEFUN([AC_HAVE_FALLOCATE],
        AC_MSG_RESULT(no))
     AC_SUBST(have_fallocate)
   ])
+
+#
+# Check if we have the fiemap ioctl (Linux)
+#
+AC_DEFUN([AC_HAVE_FIEMAP],
+  [ AC_CHECK_HEADERS([linux/fiemap.h], [ have_fiemap=yes ], [ have_fiemap=no ])
+    AC_SUBST(have_fiemap)
+  ])
-- 
1.6.6.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
