Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56666 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751310AbdKUPRG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 21 Nov 2017 10:17:06 -0500
From: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v5] xfs_io: implement ranged fiemap query
Date: Tue, 21 Nov 2017 17:16:55 +0200
Message-Id: <1511277416-3191-1-git-send-email-nborisov@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: fstests@vger.kernel.org, eguan@redhat.com, sandeen@sandeen.net, Nikolay Borisov <nborisov@suse.com>, Eric Sandeen <sandeen@redhat.com>

Currently the fiemap implementation of xfs_io doesn't support making ranged
queries. This patch implements two optional arguments which take the starting
offset and the length of the region to be queried.

When the end of the requested region falls within an extend boundary then we
print the whole extent (i.e. return the information that the kernel has given
us). When the end offset falls within a hole then the printed range is
truncated to the requested one since we do not have information how long the
hole is

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
[sandeen: simplify/rewrite ranged logic]
Signed-off-by: Eric Sandeen <sandeen@redhat.com>

---
V5: 
 * Now based on Eric's simpler approach. 

V4: 
 * Don't do any fiemap processing if passed offset is past EOF. Filesystems
 might have custom handling for this. XFS for example pretends there is a 
 hole. 

 * Restore offset/len handling to using the optional params at the end of 
 getopt and not using an additional '-r' param

V3: 
 * Fixed a bug where incorrect extent index was shown if we didn't print a 
 hole. This was due to statically returning 2 at the end of print_(plain|verbose)
 Now, the actual number of printed extents inside the 2 functions is used. 
 This bug is visible only with the -r parameter

 * Fixed a bug where 1 additional extent would be printed. This was a result of 
 the aforementioned bug fix, since now printing function can return 1 and still
 have printed an extent and no hole. This can happen when you use -r parameter,
 this is now fixed and a comment explaining it is put. 

 * Reworked the handling of the new params by making them arguments to the 
 -r parameter. 

V2:
 * Incorporated Daricks feedback - removed variables which weren't introduced
  until the next patch as a result the build with this patch was broken. This is 
  fixed now
 io/fiemap.c       | 67 +++++++++++++++++++++++++++++++++++++++++++++----------
 man/man8/xfs_io.8 |  5 +++--
 2 files changed, 58 insertions(+), 14 deletions(-)

diff --git a/io/fiemap.c b/io/fiemap.c
index bdcfacdb2811..b94d6429566c 100644
--- a/io/fiemap.c
+++ b/io/fiemap.c
@@ -49,6 +49,8 @@ fiemap_help(void)
 " -l -- also displays the length of each extent in 512-byte blocks.\n"
 " -n -- query n extents.\n"
 " -v -- Verbose information\n"
+" offset is the starting offset to map, and is optional.  If offset is\n"
+" specified, mapping length may (optionally) be specified as well."
 "\n"));
 }
 
@@ -101,6 +103,7 @@ print_verbose(
 	char			lbuf[48];
 	char			bbuf[48];
 	char			flgbuf[16];
+	int			num_printed = 0;
 
 	llast = BTOBBT(last_logical);
 	lstart = BTOBBT(extent->fe_logical);
@@ -118,14 +121,15 @@ print_verbose(
 			flg_w, _("FLAGS"));
 	}
 
-	if (lstart != llast) {
+	if (lstart > llast) {
 		print_hole(foff_w, boff_w, tot_w, cur_extent, 0, false, llast,
 			   lstart);
 		cur_extent++;
+		num_printed++;
 	}
 
 	if (cur_extent == max_extents)
-		return 1;
+		return num_printed;
 
 	snprintf(lbuf, sizeof(lbuf), "[%llu..%llu]:",
 		 (unsigned long long)lstart, lstart + len - 1ULL);
@@ -135,7 +139,9 @@ print_verbose(
 	printf("%4d: %-*s %-*s %*llu %*s\n", cur_extent, foff_w, lbuf,
 	       boff_w, bbuf, tot_w, (unsigned long long)len, flg_w, flgbuf);
 
-	return 2;
+	num_printed++;
+
+	return num_printed;
 }
 
 static int
@@ -149,29 +155,33 @@ print_plain(
 	__u64			llast;
 	__u64			block;
 	__u64			len;
+	int			num_printed = 0;
 
 	llast = BTOBBT(last_logical);
 	lstart = BTOBBT(extent->fe_logical);
 	len = BTOBBT(extent->fe_length);
 	block = BTOBBT(extent->fe_physical);
 
-	if (lstart != llast) {
+	if (lstart > llast) {
 		print_hole(0, 0, 0, cur_extent, lflag, true, llast, lstart);
 		cur_extent++;
+		num_printed++;
 	}
 
 	if (cur_extent == max_extents)
-		return 1;
+		return num_printed;
 
 	printf("\t%d: [%llu..%llu]: %llu..%llu", cur_extent,
 	       (unsigned long long)lstart, lstart + len - 1ULL,
 	       (unsigned long long)block, block + len - 1ULL);
 
+	num_printed++;
+
 	if (lflag)
 		printf(_(" %llu blocks\n"), (unsigned long long)len);
 	else
 		printf("\n");
-	return 2;
+	return num_printed;
 }
 
 /*
@@ -235,9 +245,15 @@ fiemap_f(
 	int		boff_w = 16;
 	int		tot_w = 5;	/* 5 since its just one number */
 	int		flg_w = 5;
-	__u64		last_logical = 0;
+	__u64		last_logical = 0;	/* last extent offset handled */
+	off64_t		start_offset = 0;	/* mapping start */
+	off64_t		length = -1LL;		/* mapping length */
+	off64_t		range_end = -1LL;	/* mapping end*/
+	size_t		fsblocksize, fssectsize;
 	struct stat	st;
 
+	init_cvtnum(&fsblocksize, &fssectsize);
+
 	while ((c = getopt(argc, argv, "aln:v")) != EOF) {
 		switch (c) {
 		case 'a':
@@ -257,6 +273,27 @@ fiemap_f(
 		}
 	}
 
+	/* Range start (optional) */
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
+	/* Range length (optional if range start was specified) */
+	if (optind < argc) {
+		length = cvtnum(fsblocksize, fssectsize, argv[optind]);
+		if (length < 0) {
+			printf("non-numeric len argument -- %s\n", argv[optind]);
+			return 0;
+		}
+		range_end = start_offset + length;
+	}
+
 	map_size = sizeof(struct fiemap) +
 		(EXTENT_BATCH * sizeof(struct fiemap_extent));
 	fiemap = malloc(map_size);
@@ -269,12 +306,15 @@ fiemap_f(
 
 	printf("%s:\n", file->name);
 
-	while (!last && (cur_extent != max_extents)) {
+	while (!last /* last extent of file */
+	       && (cur_extent != max_extents) /* limit passed to -n */
+	       && last_logical < range_end /* printed requested range */
+	       ) {
 
 		memset(fiemap, 0, map_size);
 		fiemap->fm_flags = fiemap_flags;
 		fiemap->fm_start = last_logical;
-		fiemap->fm_length = -1LL;
+		fiemap->fm_length = range_end - last_logical;
 		fiemap->fm_extent_count = EXTENT_BATCH;
 
 		ret = ioctl(file->fd, FS_IOC_FIEMAP, (unsigned long)fiemap);
@@ -336,9 +376,12 @@ fiemap_f(
 		return 0;
 	}
 
-	if (cur_extent && last_logical < st.st_size)
+	/* Print last hole to EOF or to end of requested range */
+	range_end = min((uint64_t)range_end, st.st_size);
+
+	if (cur_extent && last_logical < range_end)
 		print_hole(foff_w, boff_w, tot_w, cur_extent, lflag, !vflag,
-			   BTOBBT(last_logical), BTOBBT(st.st_size));
+			   BTOBBT(last_logical), BTOBBT(range_end));
 
 out:
 	free(fiemap);
@@ -353,7 +396,7 @@ fiemap_init(void)
 	fiemap_cmd.argmin = 0;
 	fiemap_cmd.argmax = -1;
 	fiemap_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
-	fiemap_cmd.args = _("[-alv] [-n nx]");
+	fiemap_cmd.args = _("[-alv] [-n nx] [offset [len]]");
 	fiemap_cmd.oneline = _("print block mapping for a file");
 	fiemap_cmd.help = fiemap_help;
 
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 9bf1a4783c4f..76337346ca0c 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -304,11 +304,12 @@ Prints the block mapping for the current open file. Refer to the
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

