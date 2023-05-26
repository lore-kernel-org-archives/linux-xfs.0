Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 348B3C77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:05:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbjEZBFv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:05:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbjEZBFk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:05:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A40C194;
        Thu, 25 May 2023 18:05:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B2E4160C3F;
        Fri, 26 May 2023 01:05:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DA63C433EF;
        Fri, 26 May 2023 01:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685063138;
        bh=PZWZv0a4Q5qwiDZJNMurO2DnHLCJizoAxEAz53c/FcM=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=lF7YlJ3GlEBe+UV00uLomkBE6HTfXw+SceoYKGoNQfLUb9xrz2HrIFCixOqH/jMbb
         8BfdOEYz2g3LDVj7rrG9nJx64UZb/ikRFTgF5Kotoi+7MNC0O4Q9DtiYSbl7e0vH3w
         kP9Nu9+0fE6owi+azO5wkdOTJMerciXB1LviPgChiKKc2Z8PvSsWlb8ojNj8bELrM6
         LfBkobkFMVBeUDrHBgtyxloQ8rVPfwx9otxSSxbugZk2b2wzppfKc8F7U6oV0Ocjo7
         zycw3alX0d+XbbrspOjpkf20HXgrar1uRc2/lzoifRwETDzSEWmARSME91ro6etOkT
         hx/rGlvEbqteQ==
Date:   Thu, 25 May 2023 18:05:37 -0700
Subject: [PATCH 4/9] xfs: make GFP_ usage consistent when allocating buftargs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, willy@infradead.org,
        linux-fsdevel@vger.kernel.org
Message-ID: <168506061909.3733082.8525276312138360536.stgit@frogsfrogsfrogs>
In-Reply-To: <168506061839.3733082.9818919714772025609.stgit@frogsfrogsfrogs>
References: <168506061839.3733082.9818919714772025609.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Convert kmem_zalloc to kzalloc, and make it so that both memory
allocation functions in this function use GFP_NOFS.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_buf.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index dd16dfb669d8..19cefed4dca7 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1978,7 +1978,7 @@ xfs_free_buftarg(
 	invalidate_bdev(btp->bt_bdev);
 	fs_put_dax(btp->bt_daxdev, btp->bt_mount);
 
-	kmem_free(btp);
+	kvfree(btp);
 }
 
 int
@@ -2024,7 +2024,7 @@ xfs_alloc_buftarg_common(
 {
 	struct xfs_buftarg	*btp;
 
-	btp = kmem_zalloc(sizeof(*btp), KM_NOFS);
+	btp = kzalloc(sizeof(*btp), GFP_NOFS);
 	if (!btp)
 		return NULL;
 
@@ -2040,7 +2040,7 @@ xfs_alloc_buftarg_common(
 	if (list_lru_init(&btp->bt_lru))
 		goto error_free;
 
-	if (percpu_counter_init(&btp->bt_io_count, 0, GFP_KERNEL))
+	if (percpu_counter_init(&btp->bt_io_count, 0, GFP_NOFS))
 		goto error_lru;
 
 	btp->bt_shrinker.count_objects = xfs_buftarg_shrink_count;
@@ -2058,7 +2058,7 @@ xfs_alloc_buftarg_common(
 error_lru:
 	list_lru_destroy(&btp->bt_lru);
 error_free:
-	kmem_free(btp);
+	kvfree(btp);
 	return NULL;
 }
 

