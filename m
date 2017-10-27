Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46970 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752589AbdJ0MhU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 27 Oct 2017 08:37:20 -0400
From: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 2/2] fiemap: Implement ranged query
Date: Fri, 27 Oct 2017 15:37:11 +0300
Message-Id: <1509107832-22286-4-git-send-email-nborisov@suse.com>
In-Reply-To: <1509107832-22286-1-git-send-email-nborisov@suse.com>
References: <1509107832-22286-1-git-send-email-nborisov@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: fstests@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>

Currently the fiemap implementation of xfs_io doesn't support making ranged
queries. This patch implements two optional arguments which take the starting
offset and the length of the region to be queried. This also requires changing
of how the final hole range is calculated. Namely, it's now being done as
[last_logical, logical addres of next extent] rather than being statically
determined by [last_logical, filesize]. Also now fiemap explicitly 
prints if a file consists of only a hole rather than staying silent.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 io/fiemap.c       | 72 +++++++++++++++++++++++++++++++++++++++++++++++--------
 man/man8/xfs_io.8 |  5 ++--
 2 files changed, 65 insertions(+), 12 deletions(-)

diff --git a/io/fiemap.c b/io/fiemap.c
index 4a52bff974e8..56bfb1a5f2d5 100644
--- a/io/fiemap.c
+++ b/io/fiemap.c
@@ -27,6 +27,9 @@
 
 static cmdinfo_t fiemap_cmd;
 static int max_extents = -1;
+static __u64 covered_length = 0;
+static __u64 len = -1LL;
+static bool range_limit = false;
 
 static void
 fiemap_help(void)
@@ -79,7 +82,7 @@ print_hole(
 		       boff_w, _("hole"), tot_w, lstart - llast);
 	   }
 
-
+	   covered_length += BBTOB(lstart - llast);
 }
 
 static int
@@ -90,7 +93,8 @@ print_verbose(
 	int			tot_w,
 	int			flg_w,
 	int			cur_extent,
-	__u64			last_logical)
+	__u64			last_logical,
+	__u64			limit)
 {
 	__u64			lstart;
 	__u64			llast;
@@ -122,7 +126,7 @@ print_verbose(
 		cur_extent++;
 	}
 
-	if (cur_extent == max_extents)
+	if (cur_extent == max_extents || (range_limit && covered_length >= limit))
 		return 1;
 
 	snprintf(lbuf, sizeof(lbuf), "[%llu..%llu]:", lstart,
@@ -140,7 +144,8 @@ print_plain(
 	struct fiemap_extent	*extent,
 	int			lflag,
 	int			cur_extent,
-	__u64			last_logical)
+	__u64			last_logical,
+	__u64			limit)
 {
 	__u64			lstart;
 	__u64			llast;
@@ -157,7 +162,7 @@ print_plain(
 		cur_extent++;
 	}
 
-	if (cur_extent == max_extents)
+	if (cur_extent == max_extents || (range_limit && covered_length >= limit))
 		return 1;
 
 	printf("\t%d: [%llu..%llu]: %llu..%llu", cur_extent,
@@ -255,8 +260,11 @@ fiemap_f(
 	int		tot_w = 5;	/* 5 since its just one number */
 	int		flg_w = 5;
 	__u64		last_logical = 0;
+	size_t		fsblocksize, fssectsize;
 	struct stat	st;
 
+	init_cvtnum(&fsblocksize, &fssectsize);
+
 	while ((c = getopt(argc, argv, "aln:v")) != EOF) {
 		switch (c) {
 		case 'a':
@@ -276,6 +284,26 @@ fiemap_f(
 		}
 	}
 
+	if (optind < argc) {
+		off64_t start_offset = cvtnum(fsblocksize, fssectsize, argv[optind]);
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
+		range_limit = true;
+	}
+
 	map_size = sizeof(struct fiemap) +
 		(EXTENT_BATCH * sizeof(struct fiemap_extent));
 	fiemap = malloc(map_size);
@@ -316,14 +344,18 @@ fiemap_f(
 				num_printed = print_verbose(extent, foff_w,
 							    boff_w, tot_w,
 							    flg_w, cur_extent,
-							    last_logical);
+							    last_logical,
+							    len);
 			} else
 				num_printed = print_plain(extent, lflag,
 							  cur_extent,
-							  last_logical);
+							  last_logical,
+							  len);
 
 			cur_extent += num_printed;
 			last_logical = extent->fe_logical + extent->fe_length;
+			if (num_printed == 2)
+				covered_length += extent->fe_length;
 
 			if (extent->fe_flags & FIEMAP_EXTENT_LAST) {
 				last = 1;
@@ -332,6 +364,9 @@ fiemap_f(
 
 			if (cur_extent == max_extents)
 				break;
+
+			if (range_limit && covered_length >= len)
+				goto out;
 		}
 	}
 
@@ -347,9 +382,26 @@ fiemap_f(
 		return 0;
 	}
 
-	if (cur_extent && last_logical < st.st_size)
+	if (last_logical < st.st_size &&
+	    (!range_limit || covered_length < len)) {
+		int end;
+
+		ret = __fiemap(fiemap, map_size, fiemap_flags, last_logical,
+			       st.st_size);
+		if (ret < 0) {
+			exitcode = 1;
+			goto out;
+		}
+
+		if (!fiemap->fm_mapped_extents)
+			end = BTOBBT(st.st_size);
+		else
+			end = BTOBBT(fiemap->fm_extents[0].fe_logical);
+
+
 		print_hole(foff_w, boff_w, tot_w, cur_extent, lflag, !vflag,
-			   BTOBBT(last_logical), BTOBBT(st.st_size));
+			   BTOBBT(last_logical), end);
+	}
 
 out:
 	free(fiemap);
@@ -364,7 +416,7 @@ fiemap_init(void)
 	fiemap_cmd.argmin = 0;
 	fiemap_cmd.argmax = -1;
 	fiemap_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
-	fiemap_cmd.args = _("[-alv] [-n nx]");
+	fiemap_cmd.args = _("[-alv] [-n nx] [offset [len]]");
 	fiemap_cmd.oneline = _("print block mapping for a file");
 	fiemap_cmd.help = fiemap_help;
 
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 0fd9b951199c..27f1ae163913 100644
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

