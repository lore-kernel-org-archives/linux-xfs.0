Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37221 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754136AbdHWPL2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 23 Aug 2017 11:11:28 -0400
From: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 4/4] fiemap: Add support for ranged query
Date: Wed, 23 Aug 2017 18:11:22 +0300
Message-Id: <1503501082-16983-4-git-send-email-nborisov@suse.com>
In-Reply-To: <1503501082-16983-1-git-send-email-nborisov@suse.com>
References: <5fc15693-7df3-c1bf-9f78-020eed30b567@sandeen.net>
 <1503501082-16983-1-git-send-email-nborisov@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net
Cc: linux-xfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>

Introduce two optional arguments which can be used to perform fiemap queries
for a particular range in a file. Those are 'offset' and 'length' they can be
used like so:

xfs_io -c "fiemap 0 12k" - query for extents covering the first 12kb of the
target file.

Now that such queries are supposed also modify the logic for printing the last
hole to only cover the range which is asked. So if we ask for 0-10kb and the
range 8k-12k is actually a whole, then limit the last whole only to this range:

So for a file which has the following contents :

|-----hole-------|-------data--------|-----hole-----|
0                8k                  12k            16k

The output would be:

xfs_io -c "fiemap -v 0 13k" test-dir/fragmented-file
test-dir/fragmented-file:
 EXT: FILE-OFFSET      BLOCK-RANGE          TOTAL FLAGS
   0: [0..15]:         hole                    16
   1: [16..23]:        897847296..897847303     8   0x0
   2: [24..25]:        hole                     2

Furthermore in cases where the queried range is covered by a whole then the
existing while() loop would have never executed, due to num_exents = 0. Fix this
by converting it to a do {} while ()

_

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 io/fiemap.c       | 75 +++++++++++++++++++++++++++++++++++++++----------------
 man/man8/xfs_io.8 |  6 +++--
 2 files changed, 57 insertions(+), 24 deletions(-)

diff --git a/io/fiemap.c b/io/fiemap.c
index ef54b265ab91..2e03a81dc57a 100644
--- a/io/fiemap.c
+++ b/io/fiemap.c
@@ -27,7 +27,7 @@
 
 static cmdinfo_t fiemap_cmd;
 static const __u64 blocksize = 512;
-static int max_extents = 0;
+static int max_extents = -1;
 
 static void
 fiemap_help(void)
@@ -38,6 +38,7 @@ fiemap_help(void)
 "\n"
 " Example:\n"
 " 'fiemap -v' - tabular format verbose map\n"
+" 'fiemap 0 4k' - print fiemap extents for 0-4k range\n"
 "\n"
 " fiemap prints the map of disk blocks used by the current file.\n"
 " The map lists each extent used by the file, as well as regions in the\n"
@@ -231,9 +232,14 @@ fiemap_f(
 	int		boff_w = 16;
 	int		tot_w = 5;	/* 5 since its just one number */
 	int		flg_w = 5;
-	__u64		last_logical = 0;
+	__u64		start_offset = 0, last_logical = 0;
+	__u64		len = -1;
+	__u64		end_offset = 0, llast;
+	size_t		fsblocksize, fssectsize;
 	struct stat	st;
 
+	init_cvtnum(&fsblocksize, &fssectsize);
+
 	while ((c = getopt(argc, argv, "aln:v")) != EOF) {
 		switch (c) {
 		case 'a':
@@ -253,7 +259,41 @@ fiemap_f(
 		}
 	}
 
-	ret = get_extent_count(file->fd, last_logical, -1);
+
+	if (optind < argc) {
+	        off64_t start = cvtnum(fsblocksize, fssectsize, argv[optind]);
+	        if (start_offset < 0) {
+	                printf("non-numeric offset argument -- %s\n", argv[optind]);
+			exitcode = 1;
+	                return 0;
+	        }
+	        last_logical = start_offset = start;
+	        optind++;
+	}
+
+	if (optind < argc) {
+	        off64_t length = cvtnum(fsblocksize, fssectsize, argv[optind]);
+	        if (length < 0) {
+	                printf("non-numeric len argument -- %s\n", argv[optind]);
+			exitcode = 1;
+	                return 0;
+	        }
+	        len = length;
+		end_offset = (start_offset + len) / blocksize;
+	}
+
+	memset(&st, 0, sizeof(st));
+	if (fstat(file->fd, &st)) {
+		fprintf(stderr, "%s: fstat failed: %s\n", progname,
+			strerror(errno));
+		exitcode = 1;
+		return 0;
+	}
+
+	if (!end_offset)
+		end_offset = (start_offset + st.st_size) / blocksize;
+
+	ret = get_extent_count(file->fd, last_logical, len);
 	if (ret < 0) {
 		exitcode = 1;
 		return 0;
@@ -272,13 +312,12 @@ fiemap_f(
 
 	printf("%s:\n", file->name);
 
-	while (!last && num_extents) {
-
+	do {
 		/* Query a batch worth of extents */
 		memset(fiemap, 0, map_size);
 		fiemap->fm_flags = fiemap_flags;
 		fiemap->fm_start = last_logical;
-		fiemap->fm_length = -1LL;
+		fiemap->fm_length = len - (last_logical - start_offset);
 		fiemap->fm_extent_count = EXTENT_BATCH;
 
 		ret = ioctl(file->fd, FS_IOC_FIEMAP, (unsigned long)fiemap);
@@ -320,35 +359,27 @@ fiemap_f(
 		}
 
 		num_extents -= fiemap->fm_mapped_extents;
-	}
+	} while (!last && num_extents);
 
 	if (cur_extent == max_extents)
 		goto out;
 
-	memset(&st, 0, sizeof(st));
-	if (fstat(file->fd, &st)) {
-		fprintf(stderr, "%s: fstat failed: %s\n", progname,
-			strerror(errno));
-		free(fiemap);
-		exitcode = 1;
-		return 0;
-	}
-
-	if (cur_extent && last_logical < st.st_size) {
+	llast = last_logical / blocksize;
+	if (cur_extent && llast < end_offset) {
 		char	lbuf[32];
+		__u64 difference = end_offset - llast;
 
 		snprintf(lbuf, sizeof(lbuf), "[%llu..%llu]:",
-			 last_logical / blocksize, (st.st_size / blocksize) - 1);
+			 llast, llast + difference - 1);
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
@@ -367,7 +398,7 @@ fiemap_init(void)
 	fiemap_cmd.argmin = 0;
 	fiemap_cmd.argmax = -1;
 	fiemap_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
-	fiemap_cmd.args = _("[-alv] [-n nx]");
+	fiemap_cmd.args = _("[-alv] [-n nx] [offset [lenght]]");
 	fiemap_cmd.oneline = _("print block mapping for a file");
 	fiemap_cmd.help = fiemap_help;
 
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 273b9c54c52d..9b57aed1d8d6 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -295,11 +295,13 @@ Prints the block mapping for the current open file. Refer to the
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
+from where to begin the fiemap and the length of that region. It also supports
+the standard unit suffixes.
 .TP
 .BI "fsmap [ \-d | \-l | \-r ] [ \-m | \-v ] [ \-n " nx " ] [ " start " ] [ " end " ]
 Prints the mapping of disk blocks used by the filesystem hosting the current
-- 
2.7.4

