Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56594 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750772AbdKUQCI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 21 Nov 2017 11:02:08 -0500
Subject: [PATCH v6] xfs_io: implement ranged fiemap query
References: <1511277416-3191-1-git-send-email-nborisov@suse.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <2ff0137c-85ff-fdb8-3ae8-da599ea75200@sandeen.net>
Date: Tue, 21 Nov 2017 10:02:07 -0600
MIME-Version: 1.0
In-Reply-To: <1511277416-3191-1-git-send-email-nborisov@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nikolay Borisov <nborisov@suse.com>, linux-xfs@vger.kernel.org
Cc: fstests@vger.kernel.org, eguan@redhat.com, Eric Sandeen <sandeen@redhat.com>

Currently the fiemap implementation of xfs_io doesn't support making ranged
queries. This patch implements two optional arguments which take the starting
offset and the length of the region to be queried.

When the end of the requested region falls within an extent boundary then we
print the whole extent (i.e. return all the information that the kernel has given
us). When the end offset falls within a hole then the printed hole range is
truncated to the requested one since we do not have information how long the
hole is.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
[sandeen: simplify/rewrite ranged logic]
Signed-off-by: Eric Sandeen <sandeen@redhat.com>

---
V6: <sandeen>
 * Update V5 changelog re: printed extents & end of range ;)
 * rename "last" to "done"
 * simplify loop control by setting done=1 in inner loop for all terminal conditions
 * update manpage re: behavior details for ranged queries

V5: 
 * Now based on Eric's simpler approach. 
 * Fix printed-extent counting in print_plain & print_verbose
 * Change while loop conditions to stop if full range has been mapped

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

diff --git a/io/fiemap.c b/io/fiemap.c
index bdcfacd..2f12652 100644
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
@@ -222,7 +232,7 @@ fiemap_f(
 	char		**argv)
 {
 	struct fiemap	*fiemap;
-	int		last = 0;
+	int		done = 0;
 	int		lflag = 0;
 	int		vflag = 0;
 	int		fiemap_flags = FIEMAP_FLAG_SYNC;
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
@@ -269,12 +306,11 @@ fiemap_f(
 
 	printf("%s:\n", file->name);
 
-	while (!last && (cur_extent != max_extents)) {
-
+	while (!done) {
 		memset(fiemap, 0, map_size);
 		fiemap->fm_flags = fiemap_flags;
 		fiemap->fm_start = last_logical;
-		fiemap->fm_length = -1LL;
+		fiemap->fm_length = range_end - last_logical;
 		fiemap->fm_extent_count = EXTENT_BATCH;
 
 		ret = ioctl(file->fd, FS_IOC_FIEMAP, (unsigned long)fiemap);
@@ -314,13 +350,23 @@ fiemap_f(
 			cur_extent += num_printed;
 			last_logical = extent->fe_logical + extent->fe_length;
 
+			/* Kernel has told us there are no more extents */
 			if (extent->fe_flags & FIEMAP_EXTENT_LAST) {
-				last = 1;
+				done = 1;
+				break;
+			}
+
+			/* We have exhausted the requested range */
+			if (last_logical >= range_end) {
+				done = 1;
 				break;
 			}
 
-			if (cur_extent == max_extents)
+			/* We have printed requested nr of extents */
+			if (cur_extent == max_extents) {
+				done = 1;
 				break;
+			}
 		}
 	}
 
@@ -336,9 +382,12 @@ fiemap_f(
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
@@ -353,7 +402,7 @@ fiemap_init(void)
 	fiemap_cmd.argmin = 0;
 	fiemap_cmd.argmax = -1;
 	fiemap_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
-	fiemap_cmd.args = _("[-alv] [-n nx]");
+	fiemap_cmd.args = _("[-alv] [-n nx] [offset [len]]");
 	fiemap_cmd.oneline = _("print block mapping for a file");
 	fiemap_cmd.help = fiemap_help;
 
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 9bf1a47..fabf92f 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -304,11 +304,23 @@ Prints the block mapping for the current open file. Refer to the
 .BR xfs_bmap (8)
 manual page for complete documentation.
 .TP
-.BI "fiemap [ \-alv ] [ \-n " nx " ]"
+.BI "fiemap [ \-alv ] [ \-n " nx " ] [ " offset " [ " len " ]]"
 Prints the block mapping for the current open file using the fiemap
 ioctl.  Options behave as described in the
 .BR xfs_bmap (8)
 manual page.
+.PP
+.RS
+Optionally, this command also supports passing the start offset
+from where to begin the mapping and the length of that region.
+The kernel will return any full extents which intersect with the requested
+range, and the
+.B fiemap
+command will print them in their entirety.  If the requested range starts
+or ends in a hole,
+.B fiemap
+will print the hole, truncated to the requested range.
+.RE
 .TP
 .BI "fsmap [ \-d | \-l | \-r ] [ \-m | \-v ] [ \-n " nx " ] [ " start " ] [ " end " ]
 Prints the mapping of disk blocks used by the filesystem hosting the current
