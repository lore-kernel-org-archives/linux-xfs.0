Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FC10C4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 08:05:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09DEA60EB9
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 08:05:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235037AbhHLIFn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Aug 2021 04:05:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234944AbhHLIFn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Aug 2021 04:05:43 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68A87C061765
        for <linux-xfs@vger.kernel.org>; Thu, 12 Aug 2021 01:05:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Lcc6rdPhafMP2TGOEhGfhjGm0VanKD9I7Ws/4ni8rkU=; b=AP+6SAL+jnr6OQaDAaq1XqHNiB
        sT2QY5R2zgdzptnU6fRD40F7lhQrTdFpTzcUG7hv3wlyi+u5gd3N5e7CCbQ5qq7hDbSSo3g8gLYEW
        iyMvnbCVG6mmUj3l7ULmJzaUGebvjr+Y7dKJ4RKS8i/Jp1EjKHEX510fI6nS4vfNBraUAAE1vpoax
        hAvnzNqx9yGqifjfyq5r4sGKWskq7acTz3hkXXjyjj4+7tWLlkmuASXE5fgT0MC64cZYePTyeItAk
        FVpEh62woJltzBN4rqImJFGldbPPXWTi1/BfV2GGYnQR5nrjGR8AkfMZtLmMvFQ4rFOg2mTSy6BJN
        5nGclZbg==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mE5gc-00EKFr-BZ; Thu, 12 Aug 2021 08:04:05 +0000
Date:   Thu, 12 Aug 2021 09:03:34 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/16] xfs: rename xfs_has_attr()
Message-ID: <YRTV1pa3dQaKLwBi@infradead.org>
References: <20210810052451.41578-1-david@fromorbit.com>
 <20210810052451.41578-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210810052451.41578-3-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 10, 2021 at 03:24:37PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> xfs_has_attr() is poorly named. It has global scope as it is defined
> in a header file, but it has no namespace scope that tells us what
> it is checking has attributes. It's not even clear what "has_attr"
> means, because what it is actually doing is an attribute fork lookup
> to see if the attribute exists.
> 
> Upcoming patches use this "xfs_has_<foo>" namespace for global
> filesystem features, which conflicts with this function.
> 
> Rename xfs_has_attr() to xfs_attr_lookup() and make it a static
> function, freeing up the "xfs_has_" namespace for global scope
> usage.

Why not kill this function entirely as I suggested last time?

---
From 154d64990a9f410200a117729149dc1febb02458 Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@lst.de>
Date: Thu, 12 Aug 2021 10:01:08 +0200
Subject: xfs: remove xfs_has_attr

xfs_has_attr() is poorly named. It has global scope as it is defined
in a header file, but it has no namespace scope that tells us what
it is checking has attributes. It's not even clear what "has_attr"
means, because what it is actually doing is an attribute fork lookup
to see if the attribute exists.

Fold it into the only caller.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr.c | 46 ++++++++++++----------------------------
 fs/xfs/libxfs/xfs_attr.h |  1 -
 2 files changed, 14 insertions(+), 33 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 010d499b237c55..939afdcec634be 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -638,36 +638,6 @@ xfs_attr_set_iter(
 	return error;
 }
 
-
-/*
- * Return EEXIST if attr is found, or ENOATTR if not
- */
-int
-xfs_has_attr(
-	struct xfs_da_args	*args)
-{
-	struct xfs_inode	*dp = args->dp;
-	struct xfs_buf		*bp = NULL;
-	int			error;
-
-	if (!xfs_inode_hasattr(dp))
-		return -ENOATTR;
-
-	if (dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL)
-		return xfs_attr_sf_findname(args, NULL, NULL);
-
-	if (xfs_attr_is_leaf(dp)) {
-		error = xfs_attr_leaf_hasname(args, &bp);
-
-		if (bp)
-			xfs_trans_brelse(args->trans, bp);
-
-		return error;
-	}
-
-	return xfs_attr_node_hasname(args, NULL);
-}
-
 /*
  * Remove the attribute specified in @args.
  */
@@ -780,8 +750,21 @@ xfs_attr_set(
 			goto out_trans_cancel;
 	}
 
+	if (!xfs_inode_hasattr(dp)) {
+		error = -ENOATTR;
+	} else if (dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL) {
+		error = xfs_attr_sf_findname(args, NULL, NULL);
+	} else if (xfs_attr_is_leaf(dp)) {
+		struct xfs_buf		*bp = NULL;
+
+		error = xfs_attr_leaf_hasname(args, &bp);
+		if (bp)
+			xfs_trans_brelse(args->trans, bp);
+	} else {
+		error = xfs_attr_node_hasname(args, NULL);
+	}
+
 	if (args->value) {
-		error = xfs_has_attr(args);
 		if (error == -EEXIST && (args->attr_flags & XATTR_CREATE))
 			goto out_trans_cancel;
 		if (error == -ENOATTR && (args->attr_flags & XATTR_REPLACE))
@@ -796,7 +779,6 @@ xfs_attr_set(
 		if (!args->trans)
 			goto out_unlock;
 	} else {
-		error = xfs_has_attr(args);
 		if (error != -EEXIST)
 			goto out_trans_cancel;
 
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 8de5d1d2733ead..5e71f719bdd52b 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -490,7 +490,6 @@ int xfs_attr_get_ilocked(struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_args(struct xfs_da_args *args);
-int xfs_has_attr(struct xfs_da_args *args);
 int xfs_attr_remove_args(struct xfs_da_args *args);
 int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
 bool xfs_attr_namecheck(const void *name, size_t length);
-- 
2.30.2

