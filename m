Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35475 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751462AbdHXLr5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 24 Aug 2017 07:47:57 -0400
From: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 2/6] fiemap: Make max_extents a global var
Date: Thu, 24 Aug 2017 14:47:48 +0300
Message-Id: <1503575272-28263-3-git-send-email-nborisov@suse.com>
In-Reply-To: <1503575272-28263-1-git-send-email-nborisov@suse.com>
References: <1503575272-28263-1-git-send-email-nborisov@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: sandeen@redhat.com, Nikolay Borisov <nborisov@suse.com>

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 io/fiemap.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/io/fiemap.c b/io/fiemap.c
index ed3a8be1dcc4..d284248e4fe1 100644
--- a/io/fiemap.c
+++ b/io/fiemap.c
@@ -24,6 +24,7 @@
 #include "io.h"
 
 static cmdinfo_t fiemap_cmd;
+static int max_extents = 0;
 
 static void
 fiemap_help(void)
@@ -56,7 +57,6 @@ print_verbose(
 	int			boff_w,
 	int			tot_w,
 	int			flg_w,
-	int			max_extents,
 	int			*cur_extent,
 	__u64			*last_logical)
 {
@@ -111,7 +111,6 @@ static void
 print_plain(
 	struct fiemap_extent	*extent,
 	int			lflag,
-	int			max_extents,
 	int			*cur_extent,
 	__u64			*last_logical)
 {
@@ -196,7 +195,6 @@ fiemap_f(
 	char		**argv)
 {
 	struct fiemap	*fiemap;
-	int		max_extents = 0;
 	int		num_extents = 32;
 	int		last = 0;
 	int		lflag = 0;
@@ -283,11 +281,11 @@ fiemap_f(
 				}
 
 				print_verbose(extent, foff_w, boff_w, tot_w,
-					      flg_w, max_extents, &cur_extent,
+					      flg_w, &cur_extent,
 					      &last_logical);
 			} else
-				print_plain(extent, lflag, max_extents,
-					    &cur_extent, &last_logical);
+				print_plain(extent, lflag, &cur_extent,
+					    &last_logical);
 
 			if (extent->fe_flags & FIEMAP_EXTENT_LAST) {
 				last = 1;
-- 
2.7.4

