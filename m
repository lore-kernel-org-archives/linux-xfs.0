Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21C2AC433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 24 May 2022 02:22:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233253AbiEXCWK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 May 2022 22:22:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232750AbiEXCWI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 May 2022 22:22:08 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DD8E4644CB
        for <linux-xfs@vger.kernel.org>; Mon, 23 May 2022 19:22:02 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id D241D534681
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 12:22:01 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ntKBM-00Fexl-AJ
        for linux-xfs@vger.kernel.org; Tue, 24 May 2022 12:22:00 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1ntKBM-007lAn-9T
        for linux-xfs@vger.kernel.org;
        Tue, 24 May 2022 12:22:00 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/3] xfs: avoid unnecessary runtime sibling pointer endian conversions
Date:   Tue, 24 May 2022 12:21:56 +1000
Message-Id: <20220524022158.1849458-2-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220524022158.1849458-1-david@fromorbit.com>
References: <20220524022158.1849458-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=628c4149
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=oZkIemNP1mAA:10 a=20KFwNOVAAAA:8 a=QyXUC8HyAAAA:8
        a=r-jLJxhkb-MfgUJOZZ8A:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Commit dc04db2aa7c9 has caused a small aim7 regression, showing a
small increase in CPU usage in __xfs_btree_check_sblock() as a
result of the extra checking.

This is likely due to the endian conversion of the sibling poitners
being unconditional instead of relying on the compiler to endian
convert the NULL pointer at compile time and avoiding the runtime
conversion for this common case.

Rework the checks so that endian conversion of the sibling pointers
is only done if they are not null as the original code did.

.... and these need to be "inline" because the compiler completely
fails to inline them automatically like it should be doing.

$ size fs/xfs/libxfs/xfs_btree.o*
   text	   data	    bss	    dec	    hex	filename
  51874	    240	      0	  52114	   cb92 fs/xfs/libxfs/xfs_btree.o.orig
  51562	    240	      0	  51802	   ca5a fs/xfs/libxfs/xfs_btree.o.inline

Just when you think the tools have advanced sufficiently we don't
have to care about stuff like this anymore, along comes a reminder
that *our tools still suck*.

Fixes: dc04db2aa7c9 ("xfs: detect self referencing btree sibling pointers")
Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_btree.c | 47 +++++++++++++++++++++++++++------------
 1 file changed, 33 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 2aa300f7461f..786ec1cb1bba 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -51,16 +51,31 @@ xfs_btree_magic(
 	return magic;
 }
 
-static xfs_failaddr_t
+/*
+ * These sibling pointer checks are optimised for null sibling pointers. This
+ * happens a lot, and we don't need to byte swap at runtime if the sibling
+ * pointer is NULL.
+ *
+ * These are explicitly marked at inline because the cost of calling them as
+ * functions instead of inlining them is about 36 bytes extra code per call site
+ * on x86-64. Yes, gcc-11 fails to inline them, and explicit inlining of these
+ * two sibling check functions reduces the compiled code size by over 300
+ * bytes.
+ */
+static inline xfs_failaddr_t
 xfs_btree_check_lblock_siblings(
 	struct xfs_mount	*mp,
 	struct xfs_btree_cur	*cur,
 	int			level,
 	xfs_fsblock_t		fsb,
-	xfs_fsblock_t		sibling)
+	__be64			dsibling)
 {
-	if (sibling == NULLFSBLOCK)
+	xfs_fsblock_t		sibling;
+
+	if (dsibling == cpu_to_be64(NULLFSBLOCK))
 		return NULL;
+
+	sibling = be64_to_cpu(dsibling);
 	if (sibling == fsb)
 		return __this_address;
 	if (level >= 0) {
@@ -74,17 +89,21 @@ xfs_btree_check_lblock_siblings(
 	return NULL;
 }
 
-static xfs_failaddr_t
+static inline xfs_failaddr_t
 xfs_btree_check_sblock_siblings(
 	struct xfs_mount	*mp,
 	struct xfs_btree_cur	*cur,
 	int			level,
 	xfs_agnumber_t		agno,
 	xfs_agblock_t		agbno,
-	xfs_agblock_t		sibling)
+	__be32			dsibling)
 {
-	if (sibling == NULLAGBLOCK)
+	xfs_agblock_t		sibling;
+
+	if (dsibling == cpu_to_be32(NULLAGBLOCK))
 		return NULL;
+
+	sibling = be32_to_cpu(dsibling);
 	if (sibling == agbno)
 		return __this_address;
 	if (level >= 0) {
@@ -136,10 +155,10 @@ __xfs_btree_check_lblock(
 		fsb = XFS_DADDR_TO_FSB(mp, xfs_buf_daddr(bp));
 
 	fa = xfs_btree_check_lblock_siblings(mp, cur, level, fsb,
-			be64_to_cpu(block->bb_u.l.bb_leftsib));
+			block->bb_u.l.bb_leftsib);
 	if (!fa)
 		fa = xfs_btree_check_lblock_siblings(mp, cur, level, fsb,
-				be64_to_cpu(block->bb_u.l.bb_rightsib));
+				block->bb_u.l.bb_rightsib);
 	return fa;
 }
 
@@ -204,10 +223,10 @@ __xfs_btree_check_sblock(
 	}
 
 	fa = xfs_btree_check_sblock_siblings(mp, cur, level, agno, agbno,
-			be32_to_cpu(block->bb_u.s.bb_leftsib));
+			block->bb_u.s.bb_leftsib);
 	if (!fa)
 		fa = xfs_btree_check_sblock_siblings(mp, cur, level, agno,
-				 agbno, be32_to_cpu(block->bb_u.s.bb_rightsib));
+				 agbno, block->bb_u.s.bb_rightsib);
 	return fa;
 }
 
@@ -4523,10 +4542,10 @@ xfs_btree_lblock_verify(
 	/* sibling pointer verification */
 	fsb = XFS_DADDR_TO_FSB(mp, xfs_buf_daddr(bp));
 	fa = xfs_btree_check_lblock_siblings(mp, NULL, -1, fsb,
-			be64_to_cpu(block->bb_u.l.bb_leftsib));
+			block->bb_u.l.bb_leftsib);
 	if (!fa)
 		fa = xfs_btree_check_lblock_siblings(mp, NULL, -1, fsb,
-				be64_to_cpu(block->bb_u.l.bb_rightsib));
+				block->bb_u.l.bb_rightsib);
 	return fa;
 }
 
@@ -4580,10 +4599,10 @@ xfs_btree_sblock_verify(
 	agno = xfs_daddr_to_agno(mp, xfs_buf_daddr(bp));
 	agbno = xfs_daddr_to_agbno(mp, xfs_buf_daddr(bp));
 	fa = xfs_btree_check_sblock_siblings(mp, NULL, -1, agno, agbno,
-			be32_to_cpu(block->bb_u.s.bb_leftsib));
+			block->bb_u.s.bb_leftsib);
 	if (!fa)
 		fa = xfs_btree_check_sblock_siblings(mp, NULL, -1, agno, agbno,
-				be32_to_cpu(block->bb_u.s.bb_rightsib));
+				block->bb_u.s.bb_rightsib);
 	return fa;
 }
 
-- 
2.35.1

