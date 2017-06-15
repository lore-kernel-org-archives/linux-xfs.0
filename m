Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33314 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751677AbdFOUg4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Jun 2017 16:36:56 -0400
Subject: [PATCH 10/12] xfs_spaceman: Free space mapping command
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 15 Jun 2017 13:36:50 -0700
Message-ID: <149755901081.3625.5954731653566094388.stgit@birch.djwong.org>
In-Reply-To: <149755894900.3625.8076720525369136771.stgit@birch.djwong.org>
References: <149755894900.3625.8076720525369136771.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

From: Dave Chinner <dchinner@redhat.com>

Add freespace mapping tool modelled on the xfs_db freesp command.
The advantage of this command over xfs_db is that it can be done
online and is coherent with concurrent modifications to the
filesystem.

This requires the kernel to support the XFS_IOC_GETFSMAP ioctl to map
free space indexes.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
[darrick: port from FIEMAPFS to GETFSMAP]
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 spaceman/Makefile   |    7 +
 spaceman/file.c     |   19 ++
 spaceman/freesp.c   |  392 +++++++++++++++++++++++++++++++++++++++++++++++++++
 spaceman/init.c     |    8 +
 spaceman/prealloc.c |    1 
 spaceman/space.h    |   10 +
 spaceman/trim.c     |    1 
 7 files changed, 432 insertions(+), 6 deletions(-)
 create mode 100644 spaceman/freesp.c


diff --git a/spaceman/Makefile b/spaceman/Makefile
index 6aad746..95ec3c0 100644
--- a/spaceman/Makefile
+++ b/spaceman/Makefile
@@ -21,6 +21,13 @@ ifeq ($(ENABLE_EDITLINE),yes)
 LLDLIBS += $(LIBEDITLINE) $(LIBTERMCAP)
 endif
 
+# On linux we get fsmap from the system or define it ourselves
+# so include this based on platform type.  If this reverts to only
+# the autoconf check w/o local definition, change to testing HAVE_GETFSMAP
+ifeq ($(PKG_PLATFORM),linux)
+CFILES += freesp.c
+endif
+
 default: depend $(LTCOMMAND)
 
 include $(BUILDRULES)
diff --git a/spaceman/file.c b/spaceman/file.c
index beca5ba..4ab3090 100644
--- a/spaceman/file.c
+++ b/spaceman/file.c
@@ -22,6 +22,7 @@
 #include "command.h"
 #include "input.h"
 #include "init.h"
+#include "path.h"
 #include "space.h"
 
 static cmdinfo_t print_cmd;
@@ -55,8 +56,10 @@ print_f(
 int
 openfile(
 	char		*path,
-	xfs_fsop_geom_t	*geom)
+	xfs_fsop_geom_t	*geom,
+	struct fs_path	*fs_path)
 {
+	struct fs_path	*fsp;
 	int		fd;
 
 	fd = open(path, 0);
@@ -70,6 +73,16 @@ openfile(
 		close(fd);
 		return -1;
 	}
+
+	if (fs_path) {
+		fsp = fs_table_lookup(path, FS_MOUNT_POINT);
+		if (!fsp) {
+			fprintf(stderr, _("%s: cannot find mount point."),
+				path);
+			return -1;
+		}
+		memcpy(fs_path, fsp, sizeof(struct fs_path));
+	}
 	return fd;
 }
 
@@ -77,7 +90,8 @@ int
 addfile(
 	char		*name,
 	int		fd,
-	xfs_fsop_geom_t	*geometry)
+	xfs_fsop_geom_t	*geometry,
+	struct fs_path	*fs_path)
 {
 	char		*filename;
 
@@ -104,6 +118,7 @@ addfile(
 	file->fd = fd;
 	file->name = filename;
 	file->geom = *geometry;
+	memcpy(&file->fs_path, fs_path, sizeof(file->fs_path));
 	return 0;
 }
 
diff --git a/spaceman/freesp.c b/spaceman/freesp.c
new file mode 100644
index 0000000..99e50cf
--- /dev/null
+++ b/spaceman/freesp.c
@@ -0,0 +1,392 @@
+/*
+ * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
+ * Copyright (c) 2012 Red Hat, Inc.
+ * Copyright (c) 2017 Oracle.
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
+#include "libxfs.h"
+#include <linux/fiemap.h>
+#include "command.h"
+#include "init.h"
+#include "path.h"
+#include "space.h"
+#include "input.h"
+
+typedef struct histent
+{
+	long long	low;
+	long long	high;
+	long long	count;
+	long long	blocks;
+} histent_t;
+
+static int		agcount;
+static xfs_agnumber_t	*aglist;
+static histent_t	*hist;
+static int		dumpflag;
+static long long	equalsize;
+static long long	multsize;
+static int		histcount;
+static int		seen1;
+static int		summaryflag;
+static bool		rtflag;
+static long long	totblocks;
+static long long	totexts;
+
+static cmdinfo_t freesp_cmd;
+
+static void
+addhistent(
+	long long	h)
+{
+	if (histcount == INT_MAX) {
+		printf(_("Too many histogram buckets.\n"));
+		return;
+	}
+	hist = realloc(hist, (histcount + 1) * sizeof(*hist));
+	if (h == 0)
+		h = 1;
+	hist[histcount].low = h;
+	hist[histcount].count = hist[histcount].blocks = 0;
+	histcount++;
+	if (h == 1)
+		seen1 = 1;
+}
+
+static void
+addtohist(
+	xfs_agnumber_t	agno,
+	xfs_agblock_t	agbno,
+	off64_t		len)
+{
+	long		i;
+
+	if (dumpflag)
+		printf("%8d %8d %8"PRId64"\n", agno, agbno, len);
+	totexts++;
+	totblocks += len;
+	for (i = 0; i < histcount; i++) {
+		if (hist[i].high >= len) {
+			hist[i].count++;
+			hist[i].blocks += len;
+			break;
+		}
+	}
+}
+
+static int
+hcmp(
+	const void	*a,
+	const void	*b)
+{
+	return ((histent_t *)a)->low - ((histent_t *)b)->low;
+}
+
+static void
+histinit(
+	long long	maxlen)
+{
+	long long	i;
+
+	if (equalsize) {
+		for (i = 1; i < maxlen; i += equalsize)
+			addhistent(i);
+	} else if (multsize) {
+		for (i = 1; i < maxlen; i *= multsize)
+			addhistent(i);
+	} else {
+		if (!seen1)
+			addhistent(1);
+		qsort(hist, histcount, sizeof(*hist), hcmp);
+	}
+	for (i = 0; i < histcount; i++) {
+		if (i < histcount - 1)
+			hist[i].high = hist[i + 1].low - 1;
+		else
+			hist[i].high = maxlen;
+	}
+}
+
+static void
+printhist(void)
+{
+	int	i;
+
+	printf("%7s %7s %7s %7s %6s\n",
+		_("from"), _("to"), _("extents"), _("blocks"), _("pct"));
+	for (i = 0; i < histcount; i++) {
+		if (hist[i].count)
+			printf("%7lld %7lld %7lld %7lld %6.2f\n", hist[i].low,
+				hist[i].high, hist[i].count, hist[i].blocks,
+				hist[i].blocks * 100.0 / totblocks);
+	}
+}
+
+static int
+inaglist(
+	xfs_agnumber_t	agno)
+{
+	int		i;
+
+	if (agcount == 0)
+		return 1;
+	for (i = 0; i < agcount; i++)
+		if (aglist[i] == agno)
+			return 1;
+	return 0;
+}
+
+#define NR_EXTENTS 128
+
+static void
+scan_ag(
+	xfs_agnumber_t		agno)
+{
+	struct fsmap_head	*fsmap;
+	struct fsmap		*extent;
+	struct fsmap		*l, *h;
+	struct fsmap		*p;
+	off64_t			blocksize = file->geom.blocksize;
+	off64_t			bperag;
+	off64_t			aglen;
+	xfs_agblock_t		agbno;
+	int			ret;
+	int			i;
+
+	bperag = (off64_t)file->geom.agblocks * blocksize;
+
+	fsmap = malloc(fsmap_sizeof(NR_EXTENTS));
+	if (!fsmap) {
+		fprintf(stderr, _("%s: fsmap malloc failed.\n"), progname);
+		exitcode = 1;
+		return;
+	}
+
+	memset(fsmap, 0, sizeof(*fsmap));
+	fsmap->fmh_count = NR_EXTENTS;
+	l = fsmap->fmh_keys;
+	h = fsmap->fmh_keys + 1;
+	if (agno != NULLAGNUMBER) {
+		l->fmr_physical = agno * bperag;
+		h->fmr_physical = ((agno + 1) * bperag) - 1;
+		l->fmr_device = h->fmr_device = file->fs_path.fs_datadev;
+	} else {
+		l->fmr_physical = 0;
+		h->fmr_physical = ULLONG_MAX;
+		l->fmr_device = h->fmr_device = file->fs_path.fs_rtdev;
+	}
+	h->fmr_owner = ULLONG_MAX;
+	h->fmr_flags = UINT_MAX;
+	h->fmr_offset = ULLONG_MAX;
+
+	while (true) {
+		ret = ioctl(file->fd, FS_IOC_GETFSMAP, fsmap);
+		if (ret < 0) {
+			fprintf(stderr, _("%s: FS_IOC_GETFSMAP [\"%s\"]: %s\n"),
+				progname, file->name, strerror(errno));
+			free(fsmap);
+			exitcode = 1;
+			return;
+		}
+
+		/* No more extents to map, exit */
+		if (!fsmap->fmh_entries)
+			break;
+
+		for (i = 0, extent = fsmap->fmh_recs;
+		     i < fsmap->fmh_entries;
+		     i++, extent++) {
+			if (!(extent->fmr_flags & FMR_OF_SPECIAL_OWNER) ||
+			    extent->fmr_owner != XFS_FMR_OWN_FREE)
+				continue;
+			agbno = (extent->fmr_physical - (bperag * agno)) /
+								blocksize;
+			aglen = extent->fmr_length / blocksize;
+
+			addtohist(agno, agbno, aglen);
+		}
+
+		p = &fsmap->fmh_recs[fsmap->fmh_entries - 1];
+		if (p->fmr_flags & FMR_OF_LAST)
+			break;
+		fsmap_advance(fsmap);
+	}
+}
+static void
+aglistadd(
+	char		*a)
+{
+	xfs_agnumber_t	x;
+
+	aglist = realloc(aglist, (agcount + 1) * sizeof(*aglist));
+	x = cvt_u32(a, 0);
+	if (errno) {
+		printf(_("Unrecognized AG number: %s\n"), a);
+		return;
+	}
+	aglist[agcount] = x;
+	agcount++;
+}
+
+static int
+init(
+	int		argc,
+	char		**argv)
+{
+	long long	x;
+	int		c;
+	int		speced = 0;	/* only one of -b -e -h or -m */
+
+	agcount = dumpflag = equalsize = multsize = optind = 0;
+	histcount = seen1 = summaryflag = 0;
+	totblocks = totexts = 0;
+	aglist = NULL;
+	hist = NULL;
+	rtflag = false;
+
+	while ((c = getopt(argc, argv, "a:bde:h:m:rs")) != EOF) {
+		switch (c) {
+		case 'a':
+			aglistadd(optarg);
+			break;
+		case 'b':
+			if (speced)
+				goto many_spec;
+			multsize = 2;
+			speced = 1;
+			break;
+		case 'd':
+			dumpflag = 1;
+			break;
+		case 'e':
+			if (speced)
+				goto many_spec;
+			equalsize = cvt_s64(optarg, 0);
+			if (errno)
+				return command_usage(&freesp_cmd);
+			speced = 1;
+			break;
+		case 'h':
+			if (speced && !histcount)
+				goto many_spec;
+			/* addhistent increments histcount */
+			x = cvt_s64(optarg, 0);
+			if (errno)
+				return command_usage(&freesp_cmd);
+			addhistent(x);
+			speced = 1;
+			break;
+		case 'm':
+			if (speced)
+				goto many_spec;
+			multsize = cvt_s64(optarg, 0);
+			if (errno)
+				return command_usage(&freesp_cmd);
+			speced = 1;
+			break;
+		case 'r':
+			rtflag = true;
+			break;
+		case 's':
+			summaryflag = 1;
+			break;
+		case '?':
+		default:
+			return command_usage(&freesp_cmd);
+		}
+	}
+	if (optind != argc)
+		return 0;
+	if (!speced)
+		multsize = 2;
+	histinit(file->geom.agblocks);
+	return 1;
+many_spec:
+	return command_usage(&freesp_cmd);
+}
+
+/*
+ * Report on freespace usage in xfs filesystem.
+ */
+static int
+freesp_f(
+	int		argc,
+	char		**argv)
+{
+	xfs_agnumber_t	agno;
+
+	if (!init(argc, argv))
+		return 0;
+	if (rtflag)
+		scan_ag(NULLAGNUMBER);
+	for (agno = 0; !rtflag && agno < file->geom.agcount; agno++)  {
+		if (inaglist(agno))
+			scan_ag(agno);
+	}
+	if (histcount)
+		printhist();
+	if (summaryflag) {
+		printf(_("total free extents %lld\n"), totexts);
+		printf(_("total free blocks %lld\n"), totblocks);
+		printf(_("average free extent size %g\n"),
+			(double)totblocks / (double)totexts);
+	}
+	if (aglist)
+		free(aglist);
+	if (hist)
+		free(hist);
+	return 0;
+}
+
+static void
+freesp_help(void)
+{
+	printf(_(
+"\n"
+"Examine filesystem free space\n"
+"\n"
+" -a agno  -- Scan only the given AG agno.\n"
+" -b       -- binary histogram bin size\n"
+" -d       -- debug output\n"
+" -e bsize -- Use fixed histogram bin size of bsize\n"
+" -h hbsz  -- Use custom histogram bin size of h1.\n"
+"             Multiple specifications are allowed.\n"
+" -m bmult -- Use histogram bin size multiplier of bmult.\n"
+" -r       -- Display realtime device free space information.\n"
+" -s       -- Emit freespace summary information.\n"
+"\n"
+"Only one of -b, -e, -h, or -m may be specified.\n"
+"\n"));
+
+}
+
+void
+freesp_init(void)
+{
+	freesp_cmd.name = "freesp";
+	freesp_cmd.altname = "fsp";
+	freesp_cmd.cfunc = freesp_f;
+	freesp_cmd.argmin = 0;
+	freesp_cmd.argmax = -1;
+	freesp_cmd.args = "[-drs] [-a agno]... [ -b | -e bsize | -h h1... | -m bmult ]";
+	freesp_cmd.flags = CMD_FLAG_ONESHOT;
+	freesp_cmd.oneline = _("Examine filesystem free space");
+	freesp_cmd.help = freesp_help;
+
+	add_command(&freesp_cmd);
+}
+
diff --git a/spaceman/init.c b/spaceman/init.c
index a51007d..b3eface 100644
--- a/spaceman/init.c
+++ b/spaceman/init.c
@@ -20,6 +20,7 @@
 #include "command.h"
 #include "input.h"
 #include "init.h"
+#include "path.h"
 #include "space.h"
 
 char	*progname;
@@ -42,6 +43,7 @@ init_commands(void)
 	prealloc_init();
 	quit_init();
 	trim_init();
+	freesp_init();
 }
 
 static int
@@ -70,12 +72,14 @@ init(
 {
 	int		c;
 	xfs_fsop_geom_t	geometry = { 0 };
+	struct fs_path	fsp;
 
 	progname = basename(argv[0]);
 	setlocale(LC_ALL, "");
 	bindtextdomain(PACKAGE, LOCALEDIR);
 	textdomain(PACKAGE);
 
+	fs_table_initialise(0, NULL, 0, NULL);
 	while ((c = getopt(argc, argv, "c:V")) != EOF) {
 		switch (c) {
 		case 'c':
@@ -92,11 +96,11 @@ init(
 	if (optind != argc - 1)
 		usage();
 
-	if ((c = openfile(argv[optind], &geometry)) < 0)
+	if ((c = openfile(argv[optind], &geometry, &fsp)) < 0)
 		exit(1);
 	if (!platform_test_xfs_fd(c))
 		printf(_("Not an XFS filesystem!\n"));
-	if (addfile(argv[optind], c, &geometry) < 0)
+	if (addfile(argv[optind], c, &geometry, &fsp) < 0)
 		exit(1);
 
 	init_commands();
diff --git a/spaceman/prealloc.c b/spaceman/prealloc.c
index 439a9e8..689ed05 100644
--- a/spaceman/prealloc.c
+++ b/spaceman/prealloc.c
@@ -20,6 +20,7 @@
 #include "command.h"
 #include "input.h"
 #include "init.h"
+#include "path.h"
 #include "space.h"
 
 static cmdinfo_t prealloc_cmd;
diff --git a/spaceman/space.h b/spaceman/space.h
index de97139..5f4a8a0 100644
--- a/spaceman/space.h
+++ b/spaceman/space.h
@@ -20,6 +20,7 @@
 
 typedef struct fileio {
 	xfs_fsop_geom_t	geom;		/* XFS filesystem geometry */
+	struct fs_path	fs_path;	/* XFS path information */
 	char		*name;		/* file name at time of open */
 	int		fd;		/* open file descriptor */
 } fileio_t;
@@ -28,13 +29,18 @@ extern fileio_t		*filetable;	/* open file table */
 extern int		filecount;	/* number of open files */
 extern fileio_t		*file;		/* active file in file table */
 
-extern int	openfile(char *, xfs_fsop_geom_t *);
-extern int	addfile(char *, int , xfs_fsop_geom_t *);
+extern int	openfile(char *, xfs_fsop_geom_t *, struct fs_path *);
+extern int	addfile(char *, int , xfs_fsop_geom_t *, struct fs_path *);
 
 extern void	print_init(void);
 extern void	help_init(void);
 extern void	prealloc_init(void);
 extern void	quit_init(void);
 extern void	trim_init(void);
+#ifdef HAVE_GETFSMAP
+extern void	freesp_init(void);
+#else
+# define freesp_init()	do { } while (0)
+#endif
 
 #endif /* XFS_SPACEMAN_SPACE_H_ */
diff --git a/spaceman/trim.c b/spaceman/trim.c
index c0bc7f2..c20d2fe 100644
--- a/spaceman/trim.c
+++ b/spaceman/trim.c
@@ -20,6 +20,7 @@
 #include <linux/fs.h>
 #include "command.h"
 #include "init.h"
+#include "path.h"
 #include "space.h"
 #include "input.h"
 

