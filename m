Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:57067 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932134AbeCABgj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Feb 2018 20:36:39 -0500
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1erD97-0000S0-Ii
        for linux-xfs@vger.kernel.org; Thu, 01 Mar 2018 12:36:33 +1100
Received: from dave by discord.disaster.area with local (Exim 4.90_1)
        (envelope-from <david@fromorbit.com>)
        id 1erD97-0007OC-HN
        for linux-xfs@vger.kernel.org; Thu, 01 Mar 2018 12:36:33 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs_io: add RWF_DSYNC support to pwrite
Date: Thu,  1 Mar 2018 12:36:33 +1100
Message-Id: <20180301013633.28364-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Enable testing write behaviour with the per-io RWF_DSYNC flag.

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 io/pwrite.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/io/pwrite.c b/io/pwrite.c
index a89edfd0496f..58867b764635 100644
--- a/io/pwrite.c
+++ b/io/pwrite.c
@@ -56,6 +56,7 @@ pwrite_help(void)
 #endif
 #ifdef HAVE_PWRITEV2
 " -N   -- Perform the pwritev2() with RWF_NOWAIT\n"
+" -D   -- Perform the pwritev2() with RWF_DSYNC\n"
 #endif
 "\n"));
 }
@@ -299,7 +300,7 @@ pwrite_f(
 	init_cvtnum(&fsblocksize, &fssectsize);
 	bsize = fsblocksize;
 
-	while ((c = getopt(argc, argv, "b:BCdf:Fi:NqRs:OS:uV:wWZ:")) != EOF) {
+	while ((c = getopt(argc, argv, "b:BCdDf:Fi:NqRs:OS:uV:wWZ:")) != EOF) {
 		switch (c) {
 		case 'b':
 			tmp = cvtnum(fsblocksize, fssectsize, optarg);
@@ -335,6 +336,9 @@ pwrite_f(
 		case 'N':
 			pwritev2_flags |= RWF_NOWAIT;
 			break;
+		case 'D':
+			pwritev2_flags |= RWF_DSYNC;
+			break;
 #endif
 		case 's':
 			skip = cvtnum(fsblocksize, fssectsize, optarg);
-- 
2.16.1

