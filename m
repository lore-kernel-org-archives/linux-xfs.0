Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35488 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752650AbdHXLr6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 24 Aug 2017 07:47:58 -0400
From: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 5/6] fiemap: Factor out common code used for printing holes
Date: Thu, 24 Aug 2017 14:47:51 +0300
Message-Id: <1503575272-28263-6-git-send-email-nborisov@suse.com>
In-Reply-To: <1503575272-28263-1-git-send-email-nborisov@suse.com>
References: <1503575272-28263-1-git-send-email-nborisov@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: sandeen@redhat.com, Nikolay Borisov <nborisov@suse.com>

The code responsible for printing holes is scattered across 3 places:
plain print function, verbose print function and in the block handling EOF hole.
Introduce a new function factoring out the common code and replace the 3 sites
where the code is used with it. This reduces duplication and makes it apparent
when we are printing holes. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 io/fiemap.c | 66 +++++++++++++++++++++++++++++++++----------------------------
 1 file changed, 36 insertions(+), 30 deletions(-)

diff --git a/io/fiemap.c b/io/fiemap.c
index 0f04b874fd5f..44a64870d711 100644
--- a/io/fiemap.c
+++ b/io/fiemap.c
@@ -52,6 +52,36 @@ fiemap_help(void)
 "\n"));
 }
 
+static void
+print_hole(
+	   int		foff_w,
+	   int		boff_w,
+	   int		tot_w,
+	   int		cur_extent,
+	   int		lflag,
+	   bool		plain,
+	   __u64	llast,
+	   __u64	lstart)
+{
+	   char		lbuf[48];
+
+	   if (plain) {
+		printf("\t%d: [%llu..%llu]: hole", cur_extent,
+		       llast, lstart - 1ULL);
+		if (lflag)
+			printf(_(" %llu blocks\n"), lstart - llast);
+		else
+			printf("\n");
+	   } else {
+		snprintf(lbuf, sizeof(lbuf), "[%llu..%llu]:", llast,
+			 lstart - 1ULL);
+		printf("%4d: %-*s %-*s %*llu\n", cur_extent, foff_w, lbuf,
+		       boff_w, _("hole"), tot_w, lstart - llast);
+	   }
+
+
+}
+
 static int
 print_verbose(
 	struct fiemap_extent	*extent,
@@ -87,11 +117,8 @@ print_verbose(
 	}
 
 	if (lstart != llast) {
-		snprintf(lbuf, sizeof(lbuf), "[%llu..%llu]:", llast,
-			 lstart - 1ULL);
-		printf("%4d: %-*s %-*s %*llu\n", cur_extent, foff_w, lbuf,
-		       boff_w, _("hole"), tot_w, lstart - llast);
-		memset(lbuf, 0, sizeof(lbuf));
+		print_hole(foff_w, boff_w, tot_w, cur_extent, 0, false, llast,
+			   lstart);
 		cur_extent++;
 	}
 
@@ -126,12 +153,7 @@ print_plain(
 	block = BTOBBT(extent->fe_physical);
 
 	if (lstart != llast) {
-		printf("\t%d: [%llu..%llu]: hole", cur_extent,
-		       llast, lstart - 1ULL);
-		if (lflag)
-			printf(_(" %llu blocks\n"), lstart - llast);
-		else
-			printf("\n");
+		print_hole(0, 0, 0, cur_extent, lflag, true, llast, lstart);
 		cur_extent++;
 	}
 
@@ -309,25 +331,9 @@ fiemap_f(
 		return 0;
 	}
 
-	if (cur_extent && last_logical < st.st_size) {
-		char	lbuf[32];
-
-		snprintf(lbuf, sizeof(lbuf), "[%llu..%llu]:",
-			 BTOBBT(last_logical), BTOBBT(st.st_size) - 1);
-		if (vflag) {
-			printf("%4d: %-*s %-*s %*llu\n", cur_extent,
-			       foff_w, lbuf, boff_w, _("hole"), tot_w,
-			       BTOBBT(st.st_size - last_logical));
-		} else {
-			printf("\t%d: %s %s", cur_extent, lbuf,
-			       _("hole"));
-			if (lflag)
-				printf(_(" %llu blocks\n"),
-				       BTOBBT(st.st_size - last_logical));
-			else
-				printf("\n");
-		}
-	}
+	if (cur_extent && last_logical < st.st_size)
+		print_hole(foff_w, boff_w, tot_w, cur_extent, lflag, !vflag,
+			   BTOBBT(last_logical), BTOBBT(st.st_size));
 
 out:
 	free(fiemap);
-- 
2.7.4

