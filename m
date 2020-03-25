Return-Path: <SRS0=vNgo=5K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84B24C54FCF
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 01:42:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 56C762073E
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 01:42:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbgCYBmK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Mar 2020 21:42:10 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:55258 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727290AbgCYBmJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Mar 2020 21:42:09 -0400
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id CBD3B3A3AD7
        for <linux-xfs@vger.kernel.org>; Wed, 25 Mar 2020 12:42:06 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jGv3V-0006HB-NU
        for linux-xfs@vger.kernel.org; Wed, 25 Mar 2020 12:42:05 +1100
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1jGv3V-000362-FK
        for linux-xfs@vger.kernel.org; Wed, 25 Mar 2020 12:42:05 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 4/8] xfs: Improve metadata buffer reclaim accountability
Date:   Wed, 25 Mar 2020 12:42:01 +1100
Message-Id: <20200325014205.11843-5-david@fromorbit.com>
X-Mailer: git-send-email 2.26.0.rc2
In-Reply-To: <20200325014205.11843-1-david@fromorbit.com>
References: <20200325014205.11843-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LYdCFQXi c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=SS2py6AdgQ4A:10 a=20KFwNOVAAAA:8
        a=1dk79d6Hl8FtNpQQbMkA:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The buffer cache shrinker frees more than just the xfs_buf slab
objects - it also frees the pages attached to the buffers. Make sure
the memory reclaim code accounts for this memory being freed
correctly, similar to how the inode shrinker accounts for pages
freed from the page cache due to mapping invalidation.

We also need to make sure that the mm subsystem knows these are
reclaimable objects. We provide the memory reclaim subsystem with a
a shrinker to reclaim xfs_bufs, so we should really mark the slab
that way.

We also have a lot of xfs_bufs in a busy system, spread them around
like we do inodes.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index f880141a22681..9ec3eaf1c618f 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -327,6 +327,9 @@ xfs_buf_free(
 
 			__free_page(page);
 		}
+		if (current->reclaim_state)
+			current->reclaim_state->reclaimed_slab +=
+							bp->b_page_count;
 	} else if (bp->b_flags & _XBF_KMEM)
 		kmem_free(bp->b_addr);
 	_xfs_buf_free_pages(bp);
@@ -2114,9 +2117,11 @@ xfs_buf_delwri_pushbuf(
 int __init
 xfs_buf_init(void)
 {
-	xfs_buf_zone = kmem_cache_create("xfs_buf",
-					 sizeof(struct xfs_buf), 0,
-					 SLAB_HWCACHE_ALIGN, NULL);
+	xfs_buf_zone = kmem_cache_create("xfs_buf", sizeof(struct xfs_buf), 0,
+					 SLAB_HWCACHE_ALIGN |
+					 SLAB_RECLAIM_ACCOUNT |
+					 SLAB_MEM_SPREAD,
+					 NULL);
 	if (!xfs_buf_zone)
 		goto out;
 
-- 
2.26.0.rc2

