Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0687C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:48:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236067AbiLaBsG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:48:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236064AbiLaBsF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:48:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D52C81DDD1
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:48:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9307BB81DF6
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:48:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5732DC433D2;
        Sat, 31 Dec 2022 01:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672451282;
        bh=p+KS59amF+oAxHfLW/1JmQQ9nkjbjK0kW6S5zHbz820=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=JDhUL5vXvtWHEzBqWjEIgEvnZIxEwr4iF3o3ZXBS0ucXalo5UdkkU736XCp+0d5c0
         5YAZTmnGGA5om6Xme2O+V76OrXqDZXwsG8GCvJM5PyB8iHxudvXBdLhPmUWoR1xDuk
         udxSqp1y0bl2Jo0A/2iRAjNu13QRNBYn7G5qDuXgahHNO+jhPtsxlw4+m9z/lrK18n
         DlrGbPtWbubv6eIx0AGpDbIfLPnyjB9z5H7fva1f1AGeBXtYBt5CK2puhq0KJKlEw2
         +1aQ0h9sDAseA0w2J1kTcBYKbqpFLqpvRkOViwarmc9A/dXYxuKLAV/W6CaiJf1n+c
         kQMvZUUWewbvA==
Subject: [PATCH 5/5] xfs: remove xfs_trans_set_refcount_flags
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:25 -0800
Message-ID: <167243870516.716629.2373444330153950396.stgit@magnolia>
In-Reply-To: <167243870440.716629.17983217257958002785.stgit@magnolia>
References: <167243870440.716629.17983217257958002785.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Remove this single-use helper.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_refcount_item.c |   32 ++++++++++++--------------------
 1 file changed, 12 insertions(+), 20 deletions(-)


diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 5c6eecc5318a..ccc334d482a4 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -289,25 +289,6 @@ xfs_refcount_update_diff_items(
 	return ra->ri_pag->pag_agno - rb->ri_pag->pag_agno;
 }
 
-/* Set the phys extent flags for this reverse mapping. */
-static void
-xfs_trans_set_refcount_flags(
-	struct xfs_phys_extent		*pmap,
-	enum xfs_refcount_intent_type	type)
-{
-	pmap->pe_flags = 0;
-	switch (type) {
-	case XFS_REFCOUNT_INCREASE:
-	case XFS_REFCOUNT_DECREASE:
-	case XFS_REFCOUNT_ALLOC_COW:
-	case XFS_REFCOUNT_FREE_COW:
-		pmap->pe_flags |= type;
-		break;
-	default:
-		ASSERT(0);
-	}
-}
-
 /* Log refcount updates in the intent item. */
 STATIC void
 xfs_refcount_update_log_item(
@@ -331,7 +312,18 @@ xfs_refcount_update_log_item(
 	pmap = &cuip->cui_format.cui_extents[next_extent];
 	pmap->pe_startblock = ri->ri_startblock;
 	pmap->pe_len = ri->ri_blockcount;
-	xfs_trans_set_refcount_flags(pmap, ri->ri_type);
+
+	pmap->pe_flags = 0;
+	switch (ri->ri_type) {
+	case XFS_REFCOUNT_INCREASE:
+	case XFS_REFCOUNT_DECREASE:
+	case XFS_REFCOUNT_ALLOC_COW:
+	case XFS_REFCOUNT_FREE_COW:
+		pmap->pe_flags |= ri->ri_type;
+		break;
+	default:
+		ASSERT(0);
+	}
 }
 
 static struct xfs_log_item *

