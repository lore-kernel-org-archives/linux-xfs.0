Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE923C07E9A
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 06:50:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C655E6136E
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 06:50:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238118AbhGNGwx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Jul 2021 02:52:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238179AbhGNGwx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Jul 2021 02:52:53 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ABB9C061762
        for <linux-xfs@vger.kernel.org>; Tue, 13 Jul 2021 23:50:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=bCO5Wt5iCjSXmFDBfWhWEo6/CQNTsKsFRwo2+9TAm4w=; b=d634mYrGFjGfkck9snOXiQzYIU
        xz949C0SH0/vjW5Hgna8GL+dI5Y9VerwqWCrRVkvENfW9AoNZEzfA4si4xRQA6Lfeok2TQ2ryYk1/
        aHLcuLfSVD6ZKL4yvjWqViznt9T5tiym7EN09kYVWUMUl09uNYK/LehQrY9OiI55LKWEImP8aWVkA
        xbYwbCLcSp18xJnUdLLKewi34ZuBijx2+NWcrFitblTswex2Cq7vAPJv4v8aVSMDjC4Jf12Kjff1c
        VP6Db0fOJQOXXWYIUZTfe/HEHwCcxp0EBC2KyWbHAx1xFoF2l8A/06Po1w7d1JENDJcalssIiIFfi
        H0d4EsCA==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m3Yhv-001w2h-Iw; Wed, 14 Jul 2021 06:49:29 +0000
Date:   Wed, 14 Jul 2021 07:49:23 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/16] xfs: rename xfs_has_attr()
Message-ID: <YO6I80f+DVl3extQ@infradead.org>
References: <20210714041912.2625692-1-david@fromorbit.com>
 <20210714041912.2625692-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210714041912.2625692-3-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 14, 2021 at 02:18:58PM +1000, Dave Chinner wrote:
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

I agree with all the problems, and add to it that the calling
conventions are a little stupid, and the new name isn't all the great
either. I'd suggest to just remove it entirely:

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index d9d7d5137b73f6..181d3ad2239bc3 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -620,35 +620,6 @@ xfs_attr_set_iter(
 }
 
 
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
@@ -761,8 +732,21 @@ xfs_attr_set(
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
@@ -777,7 +761,6 @@ xfs_attr_set(
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
