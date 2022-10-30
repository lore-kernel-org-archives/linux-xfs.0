Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 220F5C38A02
	for <linux-xfs@archiver.kernel.org>; Sun, 30 Oct 2022 23:42:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbiJ3Xme (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 30 Oct 2022 19:42:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiJ3Xmd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 30 Oct 2022 19:42:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F133F9FEA
        for <linux-xfs@vger.kernel.org>; Sun, 30 Oct 2022 16:42:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A27B4B810A3
        for <linux-xfs@vger.kernel.org>; Sun, 30 Oct 2022 23:42:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DB1CC433C1;
        Sun, 30 Oct 2022 23:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667173350;
        bh=FIpjGgcAe4oeLqI+VM9BIR3WtmBtsE/jNBV22lLcegk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=SHA1r77Tn/kDygFnxzuhtXo4YVzFG3Zo4m6na23yJvQXIamu+U/Qs0PPPhR0sb0wD
         gnJRKHIgt4mrBxLijDeaQWqydVJ7dBA+yOaRDI9d8W0mS0aRRyFc2uVXFEPmYtvLmZ
         IeNMTChj3I/0svQTSDwO48umL54PUx6V7GXbjNP6KAlmTUNqU2f187wV4hvNP5MqlN
         c4x74puYIGxdGARYt46CT4Yk6WFAVSuWiyaC0n/xEXFu8EC+U9UXd7Jsq1WXxNSFUZ
         5wF5+0OA1TOV4zwMqth2gCZGqnJQSZdTWtJgQ6icbOkUrI8R7plsce3Hw0aMC00kZR
         3WhMD15zFcFSw==
Subject: [PATCH 12/13] xfs: fix uninitialized list head in struct
 xfs_refcount_recovery
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Sun, 30 Oct 2022 16:42:29 -0700
Message-ID: <166717334983.417886.9035100485709362610.stgit@magnolia>
In-Reply-To: <166717328145.417886.10627661186183843873.stgit@magnolia>
References: <166717328145.417886.10627661186183843873.stgit@magnolia>
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
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_refcount.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index ad0fb6a7177b..44d4667d4301 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -1767,12 +1767,14 @@ xfs_refcount_recover_extent(
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
 
@@ -1859,7 +1861,7 @@ xfs_refcount_recover_cow_leftovers(
 			goto out_free;
 
 		list_del(&rr->rr_list);
-		kmem_free(rr);
+		kfree(rr);
 	}
 
 	return error;
@@ -1869,7 +1871,7 @@ xfs_refcount_recover_cow_leftovers(
 	/* Free the leftover list */
 	list_for_each_entry_safe(rr, n, &debris, rr_list) {
 		list_del(&rr->rr_list);
-		kmem_free(rr);
+		kfree(rr);
 	}
 	return error;
 }

