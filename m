Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1000AC433FE
	for <linux-xfs@archiver.kernel.org>; Tue,  3 May 2022 22:17:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235028AbiECWVJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 May 2022 18:21:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235359AbiECWVG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 May 2022 18:21:06 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 573BC3F33A
        for <linux-xfs@vger.kernel.org>; Tue,  3 May 2022 15:17:33 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 1D9F610E6188
        for <linux-xfs@vger.kernel.org>; Wed,  4 May 2022 08:17:31 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nm0pm-007gGA-03
        for linux-xfs@vger.kernel.org; Wed, 04 May 2022 08:17:30 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nm0pl-000mGB-V0
        for linux-xfs@vger.kernel.org;
        Wed, 04 May 2022 08:17:29 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 01/10] xfs: zero inode fork buffer at allocation
Date:   Wed,  4 May 2022 08:17:19 +1000
Message-Id: <20220503221728.185449-2-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220503221728.185449-1-david@fromorbit.com>
References: <20220503221728.185449-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=6271a9fb
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=oZkIemNP1mAA:10 a=20KFwNOVAAAA:8 a=Rdbp8xITySdt82h7jNoA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

When we first allocate or resize an inline inode fork, we round up
the allocation to 4 byte alingment to make journal alignment
constraints. We don't clear the unused bytes, so we can copy up to
three uninitialised bytes into the journal. Zero those bytes so we
only ever copy zeros into the journal.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_inode_fork.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 9aee4a1e2fe9..a15ff38c3d41 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -50,8 +50,13 @@ xfs_init_local_fork(
 		mem_size++;
 
 	if (size) {
+		/*
+		 * As we round up the allocation here, we need to ensure the
+		 * bytes we don't copy data into are zeroed because the log
+		 * vectors still copy them into the journal.
+		 */
 		real_size = roundup(mem_size, 4);
-		ifp->if_u1.if_data = kmem_alloc(real_size, KM_NOFS);
+		ifp->if_u1.if_data = kmem_zalloc(real_size, KM_NOFS);
 		memcpy(ifp->if_u1.if_data, data, size);
 		if (zero_terminate)
 			ifp->if_u1.if_data[size] = '\0';
@@ -500,10 +505,11 @@ xfs_idata_realloc(
 	/*
 	 * For inline data, the underlying buffer must be a multiple of 4 bytes
 	 * in size so that it can be logged and stay on word boundaries.
-	 * We enforce that here.
+	 * We enforce that here, and use __GFP_ZERO to ensure that size
+	 * extensions always zero the unused roundup area.
 	 */
 	ifp->if_u1.if_data = krealloc(ifp->if_u1.if_data, roundup(new_size, 4),
-				      GFP_NOFS | __GFP_NOFAIL);
+				      GFP_NOFS | __GFP_NOFAIL | __GFP_ZERO);
 	ifp->if_bytes = new_size;
 }
 
-- 
2.35.1

