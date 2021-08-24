Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16ACFC4338F
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Aug 2021 02:32:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCBF661406
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Aug 2021 02:32:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233759AbhHXCc4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Aug 2021 22:32:56 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:60855 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230141AbhHXCcz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Aug 2021 22:32:55 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 2C4F180C334
        for <linux-xfs@vger.kernel.org>; Tue, 24 Aug 2021 12:32:10 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mIMES-004Fms-Me
        for linux-xfs@vger.kernel.org; Tue, 24 Aug 2021 12:32:08 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1mIMES-001eA9-Ei
        for linux-xfs@vger.kernel.org; Tue, 24 Aug 2021 12:32:08 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: fix I_DONTCACHE
Date:   Tue, 24 Aug 2021 12:32:08 +1000
Message-Id: <20210824023208.392670-1-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=MhDmnRu9jo8A:10 a=20KFwNOVAAAA:8 a=yXLLH8rWuITxDD1mAVsA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Yup, the VFS hoist broke it, and nobody noticed. Bulkstat workloads
make it clear that it doesn't work as it should.

Fixes: dae2f8ed7992 ("fs: Lift XFS_IDONTCACHE to the VFS layer")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_icache.c | 3 ++-
 fs/xfs/xfs_iops.c   | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index a3fe4c5307d3..f2210d927481 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -84,8 +84,9 @@ xfs_inode_alloc(
 		return NULL;
 	}
 
-	/* VFS doesn't initialise i_mode! */
+	/* VFS doesn't initialise i_mode or i_state! */
 	VFS_I(ip)->i_mode = 0;
+	VFS_I(ip)->i_state = 0;
 
 	XFS_STATS_INC(mp, vn_active);
 	ASSERT(atomic_read(&ip->i_pincount) == 0);
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 0ff0cca94092..a607d6aca5c4 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1344,7 +1344,7 @@ xfs_setup_inode(
 	gfp_t			gfp_mask;
 
 	inode->i_ino = ip->i_ino;
-	inode->i_state = I_NEW;
+	inode->i_state |= I_NEW;
 
 	inode_sb_list_add(inode);
 	/* make the inode look hashed for the writeback code */
-- 
2.31.1

