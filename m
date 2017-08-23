Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37208 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753985AbdHWPL1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 23 Aug 2017 11:11:27 -0400
From: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 1/4] fiemap: Move global variables out of function scope
Date: Wed, 23 Aug 2017 18:11:19 +0300
Message-Id: <1503501082-16983-1-git-send-email-nborisov@suse.com>
In-Reply-To: <5fc15693-7df3-c1bf-9f78-020eed30b567@sandeen.net>
References: <5fc15693-7df3-c1bf-9f78-020eed30b567@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net
Cc: linux-xfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>

Move the blocksize and max_extent variables to the top of the file since they
are globals. Also blocksize never changes to mark it const. Also stop passing
max_extents around and refer to it directly.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 io/fiemap.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/io/fiemap.c b/io/fiemap.c
index 75e882057362..d1584aba7818 100644
--- a/io/fiemap.c
+++ b/io/fiemap.c
@@ -24,6 +24,8 @@
 #include "io.h"
 
 static cmdinfo_t fiemap_cmd;
+static const __u64 blocksize = 512;
+static int max_extents = 0;
 
 static void
 fiemap_help(void)
@@ -57,7 +59,6 @@ print_verbose(
 	int			boff_w,
 	int			tot_w,
 	int			flg_w,
-	int			max_extents,
 	int			*cur_extent,
 	__u64			*last_logical)
 {
@@ -113,7 +114,6 @@ print_plain(
 	struct fiemap_extent	*extent,
 	int			lflag,
 	int			blocksize,
-	int			max_extents,
 	int			*cur_extent,
 	__u64			*last_logical)
 {
@@ -165,7 +165,7 @@ calc_print_format(
 	int			*tot_w,
 	int			*flg_w)
 {
-	int 			i;
+	int			i;
 	char			lbuf[32];
 	char			bbuf[32];
 	__u64			logical;
@@ -199,7 +199,6 @@ fiemap_f(
 	char		**argv)
 {
 	struct fiemap	*fiemap;
-	int		max_extents = 0;
 	int		num_extents = 32;
 	int		last = 0;
 	int		lflag = 0;
@@ -214,7 +213,6 @@ fiemap_f(
 	int		boff_w = 16;
 	int		tot_w = 5;	/* 5 since its just one number */
 	int		flg_w = 5;
-	__u64		blocksize = 512;
 	__u64		last_logical = 0;
 	struct stat	st;
 
@@ -288,12 +286,10 @@ fiemap_f(
 
 				print_verbose(extent, blocksize, foff_w,
 					      boff_w, tot_w, flg_w,
-					      max_extents, &cur_extent,
-					      &last_logical);
+					      &cur_extent, &last_logical);
 			} else
 				print_plain(extent, lflag, blocksize,
-					    max_extents, &cur_extent,
-					    &last_logical);
+					    &cur_extent, &last_logical);
 
 			if (extent->fe_flags & FIEMAP_EXTENT_LAST) {
 				last = 1;
-- 
2.7.4

