Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35485 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752365AbdHXLr6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 24 Aug 2017 07:47:58 -0400
From: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 4/6] fiemap: De-obfuscate last_logical and cur_extent manipulation
Date: Thu, 24 Aug 2017 14:47:50 +0300
Message-Id: <1503575272-28263-5-git-send-email-nborisov@suse.com>
In-Reply-To: <1503575272-28263-1-git-send-email-nborisov@suse.com>
References: <1503575272-28263-1-git-send-email-nborisov@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: sandeen@redhat.com, Nikolay Borisov <nborisov@suse.com>

last_logical and cur_extent are being passed by reference to the printing
functions and the in turn modify those variables. This makes it a bit harder to
reason about the code. So change the printing function to take those 2 arguemnts
by value and move the manipulation logic in fiemap_f. Furthermore, the printing
function now return the number of extents they have printed (either 1 or 2,
dependent on whether we've hit the -n limit). No functional changes

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 io/fiemap.c | 60 ++++++++++++++++++++++++++++++++----------------------------
 1 file changed, 32 insertions(+), 28 deletions(-)

diff --git a/io/fiemap.c b/io/fiemap.c
index a31db790c86d..0f04b874fd5f 100644
--- a/io/fiemap.c
+++ b/io/fiemap.c
@@ -52,15 +52,15 @@ fiemap_help(void)
 "\n"));
 }
 
-static void
+static int
 print_verbose(
 	struct fiemap_extent	*extent,
 	int			foff_w,
 	int			boff_w,
 	int			tot_w,
 	int			flg_w,
-	int			*cur_extent,
-	__u64			*last_logical)
+	int			cur_extent,
+	__u64			last_logical)
 {
 	__u64			lstart;
 	__u64			llast;
@@ -70,7 +70,7 @@ print_verbose(
 	char			bbuf[48];
 	char			flgbuf[16];
 
-	llast = BTOBBT(*last_logical);
+	llast = BTOBBT(last_logical);
 	lstart = BTOBBT(extent->fe_logical);
 	len = BTOBBT(extent->fe_length);
 	block = BTOBBT(extent->fe_physical);
@@ -78,7 +78,7 @@ print_verbose(
 	memset(lbuf, 0, sizeof(lbuf));
 	memset(bbuf, 0, sizeof(bbuf));
 
-	if (*cur_extent == 0) {
+	if (cur_extent == 0) {
 		printf("%4s: %-*s %-*s %*s %*s\n", _("EXT"),
 			foff_w, _("FILE-OFFSET"),
 			boff_w, _("BLOCK-RANGE"),
@@ -89,57 +89,56 @@ print_verbose(
 	if (lstart != llast) {
 		snprintf(lbuf, sizeof(lbuf), "[%llu..%llu]:", llast,
 			 lstart - 1ULL);
-		printf("%4d: %-*s %-*s %*llu\n", *cur_extent, foff_w, lbuf,
+		printf("%4d: %-*s %-*s %*llu\n", cur_extent, foff_w, lbuf,
 		       boff_w, _("hole"), tot_w, lstart - llast);
-		(*cur_extent)++;
 		memset(lbuf, 0, sizeof(lbuf));
+		cur_extent++;
 	}
 
-	if ((*cur_extent + 1) == max_extents)
-		return;
+	if ((cur_extent + 1) == max_extents)
+		return 1;
 
 	snprintf(lbuf, sizeof(lbuf), "[%llu..%llu]:", lstart,
 		 lstart + len - 1ULL);
 	snprintf(bbuf, sizeof(bbuf), "%llu..%llu", block, block + len - 1ULL);
 	snprintf(flgbuf, sizeof(flgbuf), "0x%x", extent->fe_flags);
-	printf("%4d: %-*s %-*s %*llu %*s\n", *cur_extent, foff_w, lbuf,
+	printf("%4d: %-*s %-*s %*llu %*s\n", cur_extent, foff_w, lbuf,
 	       boff_w, bbuf, tot_w, len, flg_w, flgbuf);
 
-	(*cur_extent)++;
-	*last_logical = extent->fe_logical + extent->fe_length;
+	return 2;
 }
 
-static void
+static int
 print_plain(
 	struct fiemap_extent	*extent,
 	int			lflag,
-	int			*cur_extent,
-	__u64			*last_logical)
+	int			cur_extent,
+	__u64			last_logical)
 {
 	__u64			lstart;
 	__u64			llast;
 	__u64			block;
 	__u64			len;
 
-	llast = BTOBBT(*last_logical);
+	llast = BTOBBT(last_logical);
 	lstart = BTOBBT(extent->fe_logical);
 	len = BTOBBT(extent->fe_length);
 	block = BTOBBT(extent->fe_physical);
 
 	if (lstart != llast) {
-		printf("\t%d: [%llu..%llu]: hole", *cur_extent,
+		printf("\t%d: [%llu..%llu]: hole", cur_extent,
 		       llast, lstart - 1ULL);
 		if (lflag)
 			printf(_(" %llu blocks\n"), lstart - llast);
 		else
 			printf("\n");
-		(*cur_extent)++;
+		cur_extent++;
 	}
 
-	if ((*cur_extent + 1) == max_extents)
-		return;
+	if ((cur_extent + 1) == max_extents)
+		return 1;
 
-	printf("\t%d: [%llu..%llu]: %llu..%llu", *cur_extent,
+	printf("\t%d: [%llu..%llu]: %llu..%llu", cur_extent,
 	       lstart, lstart + len - 1ULL, block,
 	       block + len - 1ULL);
 
@@ -147,8 +146,7 @@ print_plain(
 		printf(_(" %llu blocks\n"), len);
 	else
 		printf("\n");
-	(*cur_extent)++;
-	*last_logical = extent->fe_logical + extent->fe_length;
+	return 2;
 }
 
 /*
@@ -267,6 +265,7 @@ fiemap_f(
 
 		for (i = 0; i < fiemap->fm_mapped_extents; i++) {
 			struct fiemap_extent	*extent;
+			int num_printed = 0;
 
 			extent = &fiemap->fm_extents[i];
 			if (vflag) {
@@ -276,12 +275,17 @@ fiemap_f(
 							  &flg_w);
 				}
 
-				print_verbose(extent, foff_w, boff_w, tot_w,
-					      flg_w, &cur_extent,
-					      &last_logical);
+				num_printed = print_verbose(extent, foff_w,
+							    boff_w, tot_w,
+							    flg_w, cur_extent,
+							    last_logical);
 			} else
-				print_plain(extent, lflag, &cur_extent,
-					    &last_logical);
+				num_printed = print_plain(extent, lflag,
+							  cur_extent,
+							  last_logical);
+
+			cur_extent += num_printed;
+			last_logical = extent->fe_logical + extent->fe_length;
 
 			if (extent->fe_flags & FIEMAP_EXTENT_LAST) {
 				last = 1;
-- 
2.7.4

