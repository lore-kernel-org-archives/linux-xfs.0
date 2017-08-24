Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35471 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751422AbdHXLr5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 24 Aug 2017 07:47:57 -0400
From: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 1/6] fiemap: Remove blocksize variable
Date: Thu, 24 Aug 2017 14:47:47 +0300
Message-Id: <1503575272-28263-2-git-send-email-nborisov@suse.com>
In-Reply-To: <1503575272-28263-1-git-send-email-nborisov@suse.com>
References: <1503575272-28263-1-git-send-email-nborisov@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: sandeen@redhat.com, Nikolay Borisov <nborisov@suse.com>

The blocksize variable was hardcoded to 512 bytes and was passed to various
functions. This introduced a lot of redundancy since we can just as well use
the BTOBBT macro. So let's do that and eliminate all usage of the blocksize var.
No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 io/fiemap.c | 50 ++++++++++++++++++++++----------------------------
 1 file changed, 22 insertions(+), 28 deletions(-)

diff --git a/io/fiemap.c b/io/fiemap.c
index 75e882057362..ed3a8be1dcc4 100644
--- a/io/fiemap.c
+++ b/io/fiemap.c
@@ -52,7 +52,6 @@ fiemap_help(void)
 static void
 print_verbose(
 	struct fiemap_extent	*extent,
-	int			blocksize,
 	int			foff_w,
 	int			boff_w,
 	int			tot_w,
@@ -69,10 +68,10 @@ print_verbose(
 	char			bbuf[48];
 	char			flgbuf[16];
 
-	llast = *last_logical / blocksize;
-	lstart = extent->fe_logical / blocksize;
-	len = extent->fe_length / blocksize;
-	block = extent->fe_physical / blocksize;
+	llast = BTOBBT(*last_logical);
+	lstart = BTOBBT(extent->fe_logical);
+	len = BTOBBT(extent->fe_length);
+	block = BTOBBT(extent->fe_physical);
 
 	memset(lbuf, 0, sizeof(lbuf));
 	memset(bbuf, 0, sizeof(bbuf));
@@ -112,7 +111,6 @@ static void
 print_plain(
 	struct fiemap_extent	*extent,
 	int			lflag,
-	int			blocksize,
 	int			max_extents,
 	int			*cur_extent,
 	__u64			*last_logical)
@@ -122,10 +120,10 @@ print_plain(
 	__u64			block;
 	__u64			len;
 
-	llast = *last_logical / blocksize;
-	lstart = extent->fe_logical / blocksize;
-	len = extent->fe_length / blocksize;
-	block = extent->fe_physical / blocksize;
+	llast = BTOBBT(*last_logical);
+	lstart = BTOBBT(extent->fe_logical);
+	len = BTOBBT(extent->fe_length);
+	block = BTOBBT(extent->fe_physical);
 
 	if (lstart != llast) {
 		printf("\t%d: [%llu..%llu]: hole", *cur_extent,
@@ -159,13 +157,12 @@ print_plain(
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
@@ -176,9 +173,9 @@ calc_print_format(
 	for (i = 0; i < fiemap->fm_mapped_extents; i++) {
 
 		extent = &fiemap->fm_extents[i];
-		logical = extent->fe_logical / blocksize;
-		len = extent->fe_length / blocksize;
-		block = extent->fe_physical / blocksize;
+		logical = BTOBBT(extent->fe_logical);
+		len = BTOBBT(extent->fe_length);
+		block = BTOBBT(extent->fe_physical);
 
 		snprintf(lbuf, sizeof(lbuf), "[%llu..%llu]", logical,
 			 logical + len - 1);
@@ -214,7 +211,6 @@ fiemap_f(
 	int		boff_w = 16;
 	int		tot_w = 5;	/* 5 since its just one number */
 	int		flg_w = 5;
-	__u64		blocksize = 512;
 	__u64		last_logical = 0;
 	struct stat	st;
 
@@ -281,19 +277,17 @@ fiemap_f(
 			extent = &fiemap->fm_extents[i];
 			if (vflag) {
 				if (cur_extent == 0) {
-					calc_print_format(fiemap, blocksize,
-							  &foff_w, &boff_w,
-							  &tot_w, &flg_w);
+					calc_print_format(fiemap, &foff_w,
+							  &boff_w, &tot_w,
+							  &flg_w);
 				}
 
-				print_verbose(extent, blocksize, foff_w,
-					      boff_w, tot_w, flg_w,
-					      max_extents, &cur_extent,
+				print_verbose(extent, foff_w, boff_w, tot_w,
+					      flg_w, max_extents, &cur_extent,
 					      &last_logical);
 			} else
-				print_plain(extent, lflag, blocksize,
-					    max_extents, &cur_extent,
-					    &last_logical);
+				print_plain(extent, lflag, max_extents,
+					    &cur_extent, &last_logical);
 
 			if (extent->fe_flags & FIEMAP_EXTENT_LAST) {
 				last = 1;
@@ -321,17 +315,17 @@ fiemap_f(
 		char	lbuf[32];
 
 		snprintf(lbuf, sizeof(lbuf), "[%llu..%llu]:",
-			 last_logical / blocksize, (st.st_size / blocksize) - 1);
+			 BTOBBT(last_logical), BTOBBT(st.st_size) - 1);
 		if (vflag) {
 			printf("%4d: %-*s %-*s %*llu\n", cur_extent,
 			       foff_w, lbuf, boff_w, _("hole"), tot_w,
-			       (st.st_size - last_logical) / blocksize);
+			       BTOBBT(st.st_size - last_logical));
 		} else {
 			printf("\t%d: %s %s", cur_extent, lbuf,
 			       _("hole"));
 			if (lflag)
 				printf(_(" %llu blocks\n"),
-				       (st.st_size - last_logical) / blocksize);
+				       BTOBBT(st.st_size - last_logical));
 			else
 				printf("\n");
 		}
-- 
2.7.4

