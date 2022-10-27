Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFC49ECAAA1
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Oct 2022 17:15:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235239AbiJ0RPJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Oct 2022 13:15:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235800AbiJ0RPH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Oct 2022 13:15:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76EB445211
        for <linux-xfs@vger.kernel.org>; Thu, 27 Oct 2022 10:15:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 11E89623F9
        for <linux-xfs@vger.kernel.org>; Thu, 27 Oct 2022 17:15:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CEF7C433C1;
        Thu, 27 Oct 2022 17:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666890905;
        bh=Ldp7kFy7piJf2NdL2Wk9lzCchQAh/FvZDlobY3fflJw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=sMj52mk8AWP1njnQOoVnZX+4sk/dtPWEfGqEKUduPw0/KzOmDJ3za3B7qYz/2Awk6
         TqxZoMIhboxh+uDl0KNNlgcoMtFbv1tAc5fKQ2JVMUbdgu9Fo2RsZ2wvv1t/Y9jUUl
         7CifZHKo+cNuhp3XOTdqNndtTxwsldY/Soj64aOnuHs6ZhzkXUQ9iU+mT4Tc6kwT3U
         VlUQut6Gt5Sldo7PboamcTYWER+5NYx7tDLxvMtlPgzB9VzrfeVG3k8uE8cXYnttV4
         oLQCKtB4ETU0mGhvpKb+KyiLS5ovOADCBzWZ1xeqASpjDQk/037wy+HXZ9WTi8mHcT
         o1M/6tx949jkQ==
Subject: [PATCH 11/12] xfs: fix uninitialized list head in struct
 xfs_refcount_recovery
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 27 Oct 2022 10:15:05 -0700
Message-ID: <166689090501.3788582.3070018636850468687.stgit@magnolia>
In-Reply-To: <166689084304.3788582.15155501738043912776.stgit@magnolia>
References: <166689084304.3788582.15155501738043912776.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

We're supposed to initialize the list head of an object before adding it
to another list.  Fix that, and stop using the kmem_{alloc,free} calls
from the Irix days.

Fixes: 174edb0e46e5 ("xfs: store in-progress CoW allocations in the refcount btree")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_refcount.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 529968b3b9c3..05fa18b9e0ed 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -1782,12 +1782,14 @@ xfs_refcount_recover_extent(
 			   be32_to_cpu(rec->refc.rc_refcount) != 1))
 		return -EFSCORRUPTED;
 
-	rr = kmem_alloc(sizeof(struct xfs_refcount_recovery), 0);
+	rr = kmalloc(sizeof(struct xfs_refcount_recovery),
+			GFP_KERNEL | __GFP_NOFAIL);
+	INIT_LIST_HEAD(&rr->rr_list);
 	xfs_refcount_btrec_to_irec(rec, &rr->rr_rrec);
 
 	if (XFS_IS_CORRUPT(cur->bc_mp,
 			   rr->rr_rrec.rc_domain != XFS_REFC_DOMAIN_COW)) {
-		kmem_free(rr);
+		kfree(rr);
 		return -EFSCORRUPTED;
 	}
 
@@ -1874,7 +1876,7 @@ xfs_refcount_recover_cow_leftovers(
 			goto out_free;
 
 		list_del(&rr->rr_list);
-		kmem_free(rr);
+		kfree(rr);
 	}
 
 	return error;
@@ -1884,7 +1886,7 @@ xfs_refcount_recover_cow_leftovers(
 	/* Free the leftover list */
 	list_for_each_entry_safe(rr, n, &debris, rr_list) {
 		list_del(&rr->rr_list);
-		kmem_free(rr);
+		kfree(rr);
 	}
 	return error;
 }

