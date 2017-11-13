Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33283 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753296AbdKMPsC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 13 Nov 2017 10:48:02 -0500
From: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v3 2/2] fiemap: Implement ranged query
Date: Mon, 13 Nov 2017 17:47:53 +0200
Message-Id: <1510588073-5665-2-git-send-email-nborisov@suse.com>
In-Reply-To: <1510588073-5665-1-git-send-email-nborisov@suse.com>
References: <1510588073-5665-1-git-send-email-nborisov@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: fstests@vger.kernel.org, eguan@redhat.com, david@fromorbit.com, darrick.wong@oracle.com, Nikolay Borisov <nborisov@suse.com>

Currently the fiemap implementation of xfs_io doesn't support making ranged
queries. This patch implements the '-r' parameter, taking up to 2 arguments - 
the starting offset and the length of the region to be queried. This also 
requires changing of the final hole range is calculated. Namely, it's now being
done as [last_logical, logical addres of next extent] rather than being
statically determined by [last_logical, filesize].

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
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

 io/fiemap.c       | 119 +++++++++++++++++++++++++++++++++++++++++++++++-------
 man/man8/xfs_io.8 |   5 ++-
 2 files changed, 107 insertions(+), 17 deletions(-)

diff --git a/io/fiemap.c b/io/fiemap.c
index 08391f69d9bd..018f3d064ab2 100644
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
@@ -99,6 +103,7 @@ print_verbose(
 	char			lbuf[48];
 	char			bbuf[48];
 	char			flgbuf[16];
+	int			num_printed = 0;
 
 	llast = BTOBBT(last_logical);
 	lstart = BTOBBT(extent->fe_logical);
@@ -120,10 +125,11 @@ print_verbose(
 		print_hole(foff_w, boff_w, tot_w, cur_extent, 0, false, llast,
 			   lstart);
 		cur_extent++;
+		num_printed = 1;
 	}
 
-	if (cur_extent == max_extents)
-		return 1;
+	if (cur_extent == max_extents || (range_limit && covered_length >= limit))
+		return num_printed;
 
 	snprintf(lbuf, sizeof(lbuf), "[%llu..%llu]:", lstart,
 		 lstart + len - 1ULL);
@@ -132,7 +138,9 @@ print_verbose(
 	printf("%4d: %-*s %-*s %*llu %*s\n", cur_extent, foff_w, lbuf,
 	       boff_w, bbuf, tot_w, len, flg_w, flgbuf);
 
-	return 2;
+	num_printed++;
+
+	return num_printed;
 }
 
 static int
@@ -140,12 +148,14 @@ print_plain(
 	struct fiemap_extent	*extent,
 	int			lflag,
 	int			cur_extent,
-	__u64			last_logical)
+	__u64			last_logical,
+	__u64			limit)
 {
 	__u64			lstart;
 	__u64			llast;
 	__u64			block;
 	__u64			len;
+	int			num_printed = 0;
 
 	llast = BTOBBT(last_logical);
 	lstart = BTOBBT(extent->fe_logical);
@@ -155,20 +165,23 @@ print_plain(
 	if (lstart != llast) {
 		print_hole(0, 0, 0, cur_extent, lflag, true, llast, lstart);
 		cur_extent++;
+		num_printed = 1;
 	}
 
-	if (cur_extent == max_extents)
-		return 1;
+	if (cur_extent == max_extents || (range_limit && covered_length >= limit))
+		return num_printed;
 
 	printf("\t%d: [%llu..%llu]: %llu..%llu", cur_extent,
 	       lstart, lstart + len - 1ULL, block,
 	       block + len - 1ULL);
 
+	num_printed++;
+
 	if (lflag)
 		printf(_(" %llu blocks\n"), len);
 	else
 		printf("\n");
-	return 2;
+	return num_printed;
 }
 
 /*
@@ -256,9 +269,12 @@ fiemap_f(
 	int		tot_w = 5;	/* 5 since its just one number */
 	int		flg_w = 5;
 	__u64		last_logical = 0;
+	size_t		fsblocksize, fssectsize;
 	struct stat	st;
 
-	while ((c = getopt(argc, argv, "aln:v")) != EOF) {
+	init_cvtnum(&fsblocksize, &fssectsize);
+
+	while ((c = getopt(argc, argv, "aln:vr")) != EOF) {
 		switch (c) {
 		case 'a':
 			fiemap_flags |= FIEMAP_FLAG_XATTR;
@@ -272,6 +288,50 @@ fiemap_f(
 		case 'v':
 			vflag++;
 			break;
+		case 'r':
+			/* Parse the first option which is mandatory */
+			if (optind < argc && argv[optind][0] != '-') {
+				off64_t start_offset = cvtnum(fsblocksize,
+							      fssectsize,
+							      argv[optind]);
+				if (start_offset < 0) {
+					printf("non-numeric offset argument -- "
+					       "%s\n", argv[optind]);
+					return 0;
+				}
+				last_logical = start_offset;
+				optind++;
+			} else {
+				fprintf(stderr, _("Invalid offset argument for"
+						  " -r\n"));
+				exitcode = 1;
+				return 0;
+			}
+
+			if (optind < argc) {
+				/* first check if what follows doesn't begin
+				 * with '-' which means it would be a param and
+				 * not an argument
+				 */
+				if (argv[optind][0] == '-') {
+					optind--;
+					break;
+
+				}
+
+				off64_t length = cvtnum(fsblocksize,
+							fssectsize,
+							argv[optind]);
+				if (length < 0) {
+					printf("non-numeric len argument --"
+					       " %s\n", argv[optind]);
+					return 0;
+				}
+				len = length;
+				range_limit = true;
+			}
+			break;
+
 		default:
 			return command_usage(&fiemap_cmd);
 		}
@@ -317,14 +377,23 @@ fiemap_f(
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
+			/* If num_printed > 0 then we dunno if we have printed
+			 * a hole or an extent and a hole but we don't really
+			 * care. Termination of the loop is still going to be
+			 * correct
+			 */
+			if (num_printed)
+				covered_length += extent->fe_length;
 
 			if (extent->fe_flags & FIEMAP_EXTENT_LAST) {
 				last = 1;
@@ -333,6 +402,9 @@ fiemap_f(
 
 			if (cur_extent == max_extents)
 				break;
+
+			if (range_limit && covered_length >= len)
+				goto out;
 		}
 	}
 
@@ -348,9 +420,26 @@ fiemap_f(
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
@@ -365,7 +454,7 @@ fiemap_init(void)
 	fiemap_cmd.argmin = 0;
 	fiemap_cmd.argmax = -1;
 	fiemap_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
-	fiemap_cmd.args = _("[-alv] [-n nx]");
+	fiemap_cmd.args = _("[-alv] [-n nx] [-r offset [len]]");
 	fiemap_cmd.oneline = _("print block mapping for a file");
 	fiemap_cmd.help = fiemap_help;
 
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 0fd9b951199c..5a00e02c94b7 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -295,11 +295,12 @@ Prints the block mapping for the current open file. Refer to the
 .BR xfs_bmap (8)
 manual page for complete documentation.
 .TP
-.BI "fiemap [ \-alv ] [ \-n " nx " ]"
+.BI "fiemap [ \-alv ] [ \-n " nx " ] [ \-r " offset " [ " len " ]]"
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

