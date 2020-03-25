Return-Path: <SRS0=vNgo=5K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0068DC10DCE
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 01:42:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C8CB12072E
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 01:42:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727239AbgCYBmP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Mar 2020 21:42:15 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:46860 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727315AbgCYBmP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Mar 2020 21:42:15 -0400
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id CA8397EB97D
        for <linux-xfs@vger.kernel.org>; Wed, 25 Mar 2020 12:42:06 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jGv3V-0006HH-Oz
        for linux-xfs@vger.kernel.org; Wed, 25 Mar 2020 12:42:05 +1100
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1jGv3V-000367-GH
        for linux-xfs@vger.kernel.org; Wed, 25 Mar 2020 12:42:05 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 5/8] xfs: correctly acount for reclaimable slabs
Date:   Wed, 25 Mar 2020 12:42:02 +1100
Message-Id: <20200325014205.11843-6-david@fromorbit.com>
X-Mailer: git-send-email 2.26.0.rc2
In-Reply-To: <20200325014205.11843-1-david@fromorbit.com>
References: <20200325014205.11843-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=SS2py6AdgQ4A:10 a=20KFwNOVAAAA:8
        a=yPCof4ZbAAAA:8 a=q-nAjRHzglZ9esTleQAA:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The XFS inode item slab actually reclaimed by inode shrinker
callbacks from the memory reclaim subsystem. These should be marked
as reclaimable so the mm subsystem has the full picture of how much
memory it can actually reclaim from the XFS slab caches.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_super.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 2094386af8aca..68fea439d9743 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1861,7 +1861,8 @@ xfs_init_zones(void)
 
 	xfs_ili_zone = kmem_cache_create("xfs_ili",
 					 sizeof(struct xfs_inode_log_item), 0,
-					 SLAB_MEM_SPREAD, NULL);
+					 SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD,
+					 NULL);
 	if (!xfs_ili_zone)
 		goto out_destroy_inode_zone;
 
-- 
2.26.0.rc2

