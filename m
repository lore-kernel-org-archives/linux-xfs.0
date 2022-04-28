Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 291DDC4332F
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Apr 2022 13:03:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346514AbiD1NGN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Apr 2022 09:06:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346679AbiD1NGN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Apr 2022 09:06:13 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3F3284ED0
        for <linux-xfs@vger.kernel.org>; Thu, 28 Apr 2022 06:02:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=gr52x/PwLokvj3fwKwSJcIGNR7rYObtwHiKaxH/iI34=; b=IZRkBThPgFqcQb1KO+/peIBo43
        TWim71QnD+rlV/14aCL81ZazgdmxPTP3gni+uaXvb7SGB6Usar/e/p0QRKL9NZBYHiwdydsLeuG1a
        9aNKsT1v3kZFaLZ46hWciHU+Yd4d9Udst3Acdnzy0XA617UUP3ox0zo6WiAMqeIE7iXWwEQicde3N
        zRFzWvidgG5g9nxGw6re1A+B4CykMpdsEPbTTO88wfvMzJfyf9MBIm2tA4SQJni0zAwXhBMBOc7Br
        97umFzaFKutxnRA6CMtfGQxpus0TnjE03dAhwGVuE6lZrQa3EeeQcT5LN/xNvE9qVs4d7aieW2A/f
        0lT+iMWQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nk3nO-006vTy-JH; Thu, 28 Apr 2022 13:02:58 +0000
Date:   Thu, 28 Apr 2022 06:02:58 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/8] xfs: don't commit the first deferred transaction
 without intents
Message-ID: <YmqQguDNU55MA+5p@infradead.org>
References: <20220427022259.695399-1-david@fromorbit.com>
 <20220427022259.695399-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427022259.695399-3-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 27, 2022 at 12:22:53PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> If the first operation in a string of defer ops has no intents,
> then there is no reason to commit it before running the first call
> to xfs_defer_finish_one(). This allows the defer ops to be used
> effectively for non-intent based operations without requiring an
> unnecessary extra transaction commit when first called.
> 
> This fixes a regression in per-attribute modification transaction
> count when delayed attributes are not being used.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_defer.c | 29 +++++++++++++++++------------
>  1 file changed, 17 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index 0805ade2d300..66b4555bda8e 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -186,7 +186,7 @@ static const struct xfs_defer_op_type *defer_op_types[] = {
>  	[XFS_DEFER_OPS_TYPE_AGFL_FREE]	= &xfs_agfl_free_defer_type,
>  };
>  
> -static void
> +static bool
>  xfs_defer_create_intent(
>  	struct xfs_trans		*tp,
>  	struct xfs_defer_pending	*dfp,
> @@ -197,6 +197,7 @@ xfs_defer_create_intent(
>  	if (!dfp->dfp_intent)
>  		dfp->dfp_intent = ops->create_intent(tp, &dfp->dfp_work,
>  						     dfp->dfp_count, sort);
> +	return dfp->dfp_intent;
>  }
>  
>  /*
> @@ -204,16 +205,18 @@ xfs_defer_create_intent(
>   * associated extents, then add the entire intake list to the end of
>   * the pending list.
>   */
> -STATIC void
> +static bool
>  xfs_defer_create_intents(
>  	struct xfs_trans		*tp)
>  {
>  	struct xfs_defer_pending	*dfp;
> +	bool				ret = false;
>  
>  	list_for_each_entry(dfp, &tp->t_dfops, dfp_list) {
>  		trace_xfs_defer_create_intent(tp->t_mountp, dfp);
> -		xfs_defer_create_intent(tp, dfp, true);
> +		ret |= xfs_defer_create_intent(tp, dfp, true);
>  	}
> +	return ret;
>  }
>  
>  /* Abort all the intents that were committed. */
> @@ -487,7 +490,7 @@ int
>  xfs_defer_finish_noroll(
>  	struct xfs_trans		**tp)
>  {
> -	struct xfs_defer_pending	*dfp;
> +	struct xfs_defer_pending	*dfp = NULL;
>  	int				error = 0;
>  	LIST_HEAD(dop_pending);
>  
> @@ -506,17 +509,19 @@ xfs_defer_finish_noroll(
>  		 * of time that any one intent item can stick around in memory,
>  		 * pinning the log tail.
>  		 */
> -		xfs_defer_create_intents(*tp);
> +		bool has_intents = xfs_defer_create_intents(*tp);
>  		list_splice_init(&(*tp)->t_dfops, &dop_pending);

While we're nitpicking:  an emptry line under the variable declaration
would be nice to have.

> +			/* Possibly relog intent items to keep the log moving. */

And a really annoying 81 character line that just wraps around here.

But except for the nitpicks this looks good to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>
