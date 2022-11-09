Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3941BC433FE
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Nov 2022 02:07:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbiKICHo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Nov 2022 21:07:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiKICHn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Nov 2022 21:07:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEFCE686AB
        for <linux-xfs@vger.kernel.org>; Tue,  8 Nov 2022 18:07:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A0035B81CF3
        for <linux-xfs@vger.kernel.org>; Wed,  9 Nov 2022 02:07:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52247C433D7;
        Wed,  9 Nov 2022 02:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667959660;
        bh=FXMgiDkqv5NPtn5B85dCpaCKfLmYbCaU0Daq7lRJY5A=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ralFth5xk6xiq9L8SRhNBAkqNZ9Gi6lyrgQL9Yy1DN91oBO1r2ZHAzZFLccewXpJq
         N5k7vZlX3whPgyCMjtP9ziu+c6FZtpVPvTi6eo3BwvfMJCJfWW+SZcZlk7E7XjZeLL
         dOW+AdItr3018YU2tDf/0mTN7cihCTSmJ51MEbgc4+/HeZ3fI4NUP5v02l/T9VZiL7
         h9RN0EyFbHQARsduW62gb0CIG1c+iVqSmru88nj5Nu0TT4a4/IeBnHQkMO8PkNUXXT
         8S6SXquVUdW+FguaIbReBBSuBx8uuEqnIDZUH4LShUobSMAbtV9ELGur6e58RabO6l
         BINswHNNr13Rg==
Subject: [PATCH 21/24] xfs: fix uninitialized list head in struct
 xfs_refcount_recovery
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Tue, 08 Nov 2022 18:07:39 -0800
Message-ID: <166795965990.3761583.13864634191918555385.stgit@magnolia>
In-Reply-To: <166795954256.3761583.3551179546135782562.stgit@magnolia>
References: <166795954256.3761583.3551179546135782562.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 55bb7e256b78994d756c40b0c8f05fc53c12532c

We're supposed to initialize the list head of an object before adding it
to another list.  Fix that, and stop using the kmem_{alloc,free} calls
from the Irix days.

Fixes: 174edb0e46e5 ("xfs: store in-progress CoW allocations in the refcount btree")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 include/kmem.h        |   10 ++++++++++
 libxfs/xfs_refcount.c |   10 ++++++----
 2 files changed, 16 insertions(+), 4 deletions(-)


diff --git a/include/kmem.h b/include/kmem.h
index 20e4bfe3c0..8ae919c706 100644
--- a/include/kmem.h
+++ b/include/kmem.h
@@ -60,4 +60,14 @@ kmem_free(const void *ptr) {
 
 extern void	*krealloc(void *, size_t, int);
 
+static inline void *kmalloc(size_t size, gfp_t flags)
+{
+	return kvmalloc(size, flags);
+}
+
+static inline void kfree(const void *ptr)
+{
+	return kmem_free(ptr);
+}
+
 #endif
diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index 52983aeef1..0a934aecc6 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -1766,12 +1766,14 @@ xfs_refcount_recover_extent(
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
 
@@ -1858,7 +1860,7 @@ xfs_refcount_recover_cow_leftovers(
 			goto out_free;
 
 		list_del(&rr->rr_list);
-		kmem_free(rr);
+		kfree(rr);
 	}
 
 	return error;
@@ -1868,7 +1870,7 @@ xfs_refcount_recover_cow_leftovers(
 	/* Free the leftover list */
 	list_for_each_entry_safe(rr, n, &debris, rr_list) {
 		list_del(&rr->rr_list);
-		kmem_free(rr);
+		kfree(rr);
 	}
 	return error;
 }

