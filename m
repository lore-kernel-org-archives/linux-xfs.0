Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46371 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751995AbdHKLze (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 11 Aug 2017 07:55:34 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A2332ABF3
        for <linux-xfs@vger.kernel.org>; Fri, 11 Aug 2017 11:55:32 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] fiemap: Refactor fiemap + implement range parameters
Date: Fri, 11 Aug 2017 14:55:29 +0300
Message-Id: <1502452529-19437-1-git-send-email-nborisov@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>

fiemap's code was rather complicated for the simple task it did so this
patch aims to rectify the situation. The main changes are:

* Add a start_offset, len parameters, this allows to specify a range of the
file for which we want information, if those parameters are omitted the old
behavior is retained i.e. we get information for the whole file.

* We now always allocate as many struct fiemap_extent structs as necessary
to hold the information for the passed range (or the whole file)

* Made max_extents, blocksize global variables. They are never modified apart
from the initilization of the program.

* Eliminated the outer while loop, now that we allocate enough extent to
perform a single fiemap ioctl call there is no need for it.

* As a result the -n parameter works correctly for -n 1

* Also changed the way the last hole is being calculated, so far every time
the outter while loop finished the extenet from last_logical .. file size would
be output as a hole. This was not always true

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---

Hello, 

Here is more or less a major cleanup of the fiemap code. I've tested it with a 
file with with the following layout HDHDHDHDHDHD (H - hole, D-data) and 
varying permutation of the arguments and so far everthing seems to work as 
expected. The biggest benefit I see is that the code is easier to follow now.


 io/fiemap.c       | 187 +++++++++++++++++++++++++++++-------------------------
 man/man8/xfs_io.8 |   5 +-
 2 files changed, 104 insertions(+), 88 deletions(-)

diff --git a/io/fiemap.c b/io/fiemap.c
index 75e882057362..5659f16d767d 100644
--- a/io/fiemap.c
+++ b/io/fiemap.c
@@ -24,6 +24,8 @@
 #include "io.h"
 
 static cmdinfo_t fiemap_cmd;
+static const __u64 blocksize = 512;
+static int max_extents = 0;
 
 static void
 fiemap_help(void)
@@ -34,6 +36,7 @@ fiemap_help(void)
 "\n"
 " Example:\n"
 " 'fiemap -v' - tabular format verbose map\n"
+" 'fiemap 0 4k' - print fiemap extents for 0-4k range\n"
 "\n"
 " fiemap prints the map of disk blocks used by the current file.\n"
 " The map lists each extent used by the file, as well as regions in the\n"
@@ -52,12 +55,10 @@ fiemap_help(void)
 static void
 print_verbose(
 	struct fiemap_extent	*extent,
-	int			blocksize,
 	int			foff_w,
 	int			boff_w,
 	int			tot_w,
 	int			flg_w,
-	int			max_extents,
 	int			*cur_extent,
 	__u64			*last_logical)
 {
@@ -85,6 +86,7 @@ print_verbose(
 			flg_w, _("FLAGS"));
 	}
 
+
 	if (lstart != llast) {
 		snprintf(lbuf, sizeof(lbuf), "[%llu..%llu]:", llast,
 			 lstart - 1ULL);
@@ -94,7 +96,7 @@ print_verbose(
 		memset(lbuf, 0, sizeof(lbuf));
 	}
 
-	if ((*cur_extent + 1) == max_extents)
+	if (max_extents && *cur_extent == max_extents)
 		return;
 
 	snprintf(lbuf, sizeof(lbuf), "[%llu..%llu]:", lstart,
@@ -112,8 +114,6 @@ static void
 print_plain(
 	struct fiemap_extent	*extent,
 	int			lflag,
-	int			blocksize,
-	int			max_extents,
 	int			*cur_extent,
 	__u64			*last_logical)
 {
@@ -137,7 +137,7 @@ print_plain(
 		(*cur_extent)++;
 	}
 
-	if ((*cur_extent + 1) == max_extents)
+	if (max_extents && *cur_extent == max_extents)
 		return;
 
 	printf("\t%d: [%llu..%llu]: %llu..%llu", *cur_extent,
@@ -159,13 +159,12 @@ print_plain(
 static void
 calc_print_format(
 	struct fiemap		*fiemap,
-	__u64			blocksize,
 	int			*foff_w,
 	int			*boff_w,
 	int			*tot_w,
 	int			*flg_w)
 {
-	int 			i;
+	int			i;
 	char			lbuf[32];
 	char			bbuf[32];
 	__u64			logical;
@@ -193,15 +192,28 @@ calc_print_format(
 	}
 }
 
+static ssize_t
+get_extent_num(int fd, __u64 startoffset, __u64 len)
+{
+	struct fiemap fiemap = { 0 } ;
+	fiemap.fm_start = startoffset;
+	fiemap.fm_length = len;
+	if (ioctl(fd, FS_IOC_FIEMAP, (unsigned long)&fiemap) < 0) {
+		fprintf(stderr, _("%s: Failed to query fiemap extent count.\n"),
+			progname);
+		return -1;
+	}
+
+	return fiemap.fm_mapped_extents;
+}
+
 int
 fiemap_f(
 	int		argc,
 	char		**argv)
 {
 	struct fiemap	*fiemap;
-	int		max_extents = 0;
-	int		num_extents = 32;
-	int		last = 0;
+	int		num_extents;
 	int		lflag = 0;
 	int		vflag = 0;
 	int		fiemap_flags = FIEMAP_FLAG_SYNC;
@@ -210,24 +222,29 @@ fiemap_f(
 	int		map_size;
 	int		ret;
 	int		cur_extent = 0;
-	int		foff_w = 16;	/* 16 just for a good minimum range */
+	int		foff_w = 16; /* 16 just for a good minimum range */
 	int		boff_w = 16;
 	int		tot_w = 5;	/* 5 since its just one number */
 	int		flg_w = 5;
-	__u64		blocksize = 512;
 	__u64		last_logical = 0;
-	struct stat	st;
+	__u64		len = -1LL;
+	size_t		fsblocksize, fssectsize;
+	off64_t		start_offset = 0;
+	__u64		end_offset;
+	__u64		llast;
+	bool		last_extent = false;
+
+	init_cvtnum(&fsblocksize, &fssectsize);
 
 	while ((c = getopt(argc, argv, "aln:v")) != EOF) {
 		switch (c) {
 		case 'a':
 			fiemap_flags |= FIEMAP_FLAG_XATTR;
 			break;
-		case 'l':
-			lflag = 1;
-			break;
 		case 'n':
 			max_extents = atoi(optarg);
+		case 'l':
+			lflag = 1;
 			break;
 		case 'v':
 			vflag++;
@@ -237,8 +254,35 @@ fiemap_f(
 		}
 	}
 
-	if (max_extents)
-		num_extents = min(num_extents, max_extents);
+	if (optind < argc) {
+		start_offset = cvtnum(fsblocksize, fssectsize, argv[optind]);
+		if (start_offset < 0) {
+			printf("non-numeric offset argument -- %s\n", argv[optind]);
+			return 0;
+		}
+		last_logical = start_offset;
+		optind++;
+	}
+
+	if (optind < argc) {
+		off64_t length = cvtnum(fsblocksize, fssectsize, argv[optind]);
+		if (length < 0) {
+			printf("non-numeric len argument -- %s\n", argv[optind]);
+			return 0;
+		}
+		len = length;
+	}
+
+
+	end_offset = (start_offset + len) / blocksize;
+
+	ret = get_extent_num(file->fd, last_logical, len);
+	if (ret < 0) {
+		exitcode = 1;
+		return 0;
+	}
+	num_extents = ret;
+
 	map_size = sizeof(struct fiemap) +
 		(num_extents * sizeof(struct fiemap_extent));
 	fiemap = malloc(map_size);
@@ -251,92 +295,63 @@ fiemap_f(
 
 	printf("%s:\n", file->name);
 
-	while (!last && ((cur_extent + 1) != max_extents)) {
-		if (max_extents)
-			num_extents = min(num_extents,
-					  max_extents - (cur_extent + 1));
-
-		memset(fiemap, 0, map_size);
-		fiemap->fm_flags = fiemap_flags;
-		fiemap->fm_start = last_logical;
-		fiemap->fm_length = -1LL;
-		fiemap->fm_extent_count = num_extents;
-
-		ret = ioctl(file->fd, FS_IOC_FIEMAP, (unsigned long)fiemap);
-		if (ret < 0) {
-			fprintf(stderr, "%s: ioctl(FS_IOC_FIEMAP) [\"%s\"]: "
-				"%s\n", progname, file->name, strerror(errno));
-			free(fiemap);
-			exitcode = 1;
-			return 0;
-		}
+	memset(fiemap, 0, map_size);
+	fiemap->fm_flags = fiemap_flags;
+	fiemap->fm_start = last_logical;
+	fiemap->fm_length = len;
+	fiemap->fm_extent_count = num_extents;
 
-		/* No more extents to map, exit */
-		if (!fiemap->fm_mapped_extents)
-			break;
+	ret = ioctl(file->fd, FS_IOC_FIEMAP, (unsigned long)fiemap);
+	if (ret < 0) {
+		fprintf(stderr, "%s: ioctl(FS_IOC_FIEMAP) [\"%s\"]: "
+			"%s\n", progname, file->name, strerror(errno));
+		free(fiemap);
+		exitcode = 1;
+		return 0;
+	}
+
+	for (i = 0; i < fiemap->fm_mapped_extents; i++) {
+		struct fiemap_extent	*extent;
 
-		for (i = 0; i < fiemap->fm_mapped_extents; i++) {
-			struct fiemap_extent	*extent;
-
-			extent = &fiemap->fm_extents[i];
-			if (vflag) {
-				if (cur_extent == 0) {
-					calc_print_format(fiemap, blocksize,
-							  &foff_w, &boff_w,
-							  &tot_w, &flg_w);
-				}
-
-				print_verbose(extent, blocksize, foff_w,
-					      boff_w, tot_w, flg_w,
-					      max_extents, &cur_extent,
-					      &last_logical);
-			} else
-				print_plain(extent, lflag, blocksize,
-					    max_extents, &cur_extent,
-					    &last_logical);
-
-			if (extent->fe_flags & FIEMAP_EXTENT_LAST) {
-				last = 1;
-				break;
+		extent = &fiemap->fm_extents[i];
+		if (vflag) {
+			if (cur_extent == 0) {
+				calc_print_format(fiemap, &foff_w, &boff_w,
+						  &tot_w, &flg_w);
 			}
 
-			if ((cur_extent + 1) == max_extents)
-				break;
-		}
-	}
+			print_verbose(extent, foff_w, boff_w, tot_w, flg_w,
+				      &cur_extent, &last_logical);
+		} else
+			print_plain(extent, lflag, &cur_extent, &last_logical);
 
-	if ((cur_extent + 1) == max_extents)
-		goto out;
+		if (max_extents && cur_extent == max_extents)
+			goto out;
+
+		if (extent->fe_flags & FIEMAP_EXTENT_LAST)
+			last_extent = true;
 
-	memset(&st, 0, sizeof(st));
-	if (fstat(file->fd, &st)) {
-		fprintf(stderr, "%s: fstat failed: %s\n", progname,
-			strerror(errno));
-		free(fiemap);
-		exitcode = 1;
-		return 0;
 	}
 
-	if (cur_extent && last_logical < st.st_size) {
-		char	lbuf[32];
+	llast = last_logical / blocksize;
+	if (!last_extent && llast < end_offset) {
+		char lbuf[32];
+		__u64 difference = end_offset - llast;
+		snprintf(lbuf, sizeof(lbuf), "[%llu..%llu]:", llast, llast + difference);
 
-		snprintf(lbuf, sizeof(lbuf), "[%llu..%llu]:",
-			 last_logical / blocksize, (st.st_size / blocksize) - 1);
 		if (vflag) {
 			printf("%4d: %-*s %-*s %*llu\n", cur_extent,
 			       foff_w, lbuf, boff_w, _("hole"), tot_w,
-			       (st.st_size - last_logical) / blocksize);
+			       difference);
 		} else {
 			printf("\t%d: %s %s", cur_extent, lbuf,
 			       _("hole"));
 			if (lflag)
-				printf(_(" %llu blocks\n"),
-				       (st.st_size - last_logical) / blocksize);
+				printf(_(" %llu blocks\n"), len / blocksize);
 			else
 				printf("\n");
 		}
 	}
-
 out:
 	free(fiemap);
 	return 0;
@@ -350,7 +365,7 @@ fiemap_init(void)
 	fiemap_cmd.argmin = 0;
 	fiemap_cmd.argmax = -1;
 	fiemap_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
-	fiemap_cmd.args = _("[-alv] [-n nx]");
+	fiemap_cmd.args = _("[-alv] [-n nx] [start offset [len]]");
 	fiemap_cmd.oneline = _("print block mapping for a file");
 	fiemap_cmd.help = fiemap_help;
 
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 273b9c54c52d..125db9181851 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -295,11 +295,12 @@ Prints the block mapping for the current open file. Refer to the
 .BR xfs_bmap (8)
 manual page for complete documentation.
 .TP
-.BI "fiemap [ \-alv ] [ \-n " nx " ]"
+.BI "fiemap [ \-alv ] [ \-n " nx " ] [ " offset " [ " len " ]]"
 Prints the block mapping for the current open file using the fiemap
 ioctl.  Options behave as described in the
 .BR xfs_bmap (8)
-manual page.
+manual page. Optionally, this command also supports passing the start offset 
+from where to begin the fiemap and the length of that region.
 .TP
 .BI "fsmap [ \-d | \-l | \-r ] [ \-m | \-v ] [ \-n " nx " ] [ " start " ] [ " end " ]
 Prints the mapping of disk blocks used by the filesystem hosting the current
-- 
2.7.4

