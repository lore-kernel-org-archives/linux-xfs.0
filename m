Return-Path: <SRS0=FA12=W2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBF04C3A5A3
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 05:34:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B588B21721
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 05:34:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XO0XLxMB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727812AbfH3FeF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Aug 2019 01:34:05 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:50756 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727729AbfH3FeE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Aug 2019 01:34:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=sBgXOjiiykfUqa5x+UD5hJ52RiRdCybwCcosB2LKkPc=; b=XO0XLxMBsWJE43KAFgFBvRhh9
        Vw8I5fda6y7aJgiYIVpm2tCi9xkVIjOjZwBcV5e6hhfAuBmp1l9zrDwQ3jB7TCBVo2tMo6p/8wFyH
        LddCr1YXLTdWvRLb0TSYfRubBk4WqG270mjBZAsJcNGntXa0LXABeiV2JU/66yBMCrgOqGyylwUge
        1NONiAfxoyUSdQXcWMZGj3R2yV3Fl7/YMpBKlOSSz/YH0BBFepJa0BFYzdKWdZWsVzsVUX4EbMIRB
        nY1GPbNgSqvzE3XP8KvPOeKv2Ybdj6NAWqtx08baM4rJCk9ggDC9mgXTUtzukOnAIvLcQma3He5vp
        s7ZRpJTbw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i3ZXw-0005tH-4g; Fri, 30 Aug 2019 05:34:04 +0000
Date:   Thu, 29 Aug 2019 22:34:04 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs: make attr lookup returns consistent
Message-ID: <20190830053404.GD6077@infradead.org>
References: <20190829113505.27223-1-david@fromorbit.com>
 <20190829113505.27223-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829113505.27223-2-david@fromorbit.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 29, 2019 at 09:35:01PM +1000, Dave Chinner wrote:
> +/*
> + * Retrieve an extended attribute and its value.  Must have ilock.
> + * Returns 0 on successful retrieval, otherwise an error.
> + */
>  int
>  xfs_attr_get_ilocked(

This just updates a comment on xfs_attr_get_ilocked, no other change,
so looks good.

>
>  	struct xfs_inode	*ip,
> @@ -147,7 +150,7 @@ xfs_attr_get(
>  	xfs_iunlock(ip, lock_mode);
>  
>  	*valuelenp = args.valuelen;
> -	return error == -EEXIST ? 0 : error;
> +	return error;
>  }

This drops a conversion from -EEXIST to 0 at the very top of the
callchain.

> -	if (!error && (args->rmtblkno > 0) && !(args->flags & ATTR_KERNOVAL)) {
> -		error = xfs_attr_rmtval_get(args);
> -	}
> -	return error;
> +	if (error)
> +		return error;
> +
> +	/* check if we have to retrieve a remote attribute to get the value */
> +	if (args->flags & ATTR_KERNOVAL)
> +		return 0;
> +	if (!args->rmtblkno)
> +		return 0;
> +	return xfs_attr_rmtval_get(args);

No change at all here, just a more verbose style.

>  STATIC int
>  xfs_attr_node_get(xfs_da_args_t *args)
> @@ -1294,24 +1306,27 @@ xfs_attr_node_get(xfs_da_args_t *args)
>  	error = xfs_da3_node_lookup_int(state, &retval);
>  	if (error) {
>  		retval = error;
> -	} else if (retval == -EEXIST) {
> -		blk = &state->path.blk[ state->path.active-1 ];
> -		ASSERT(blk->bp != NULL);
> -		ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
> -
> -		/*
> -		 * Get the value, local or "remote"
> -		 */
> -		retval = xfs_attr3_leaf_getvalue(blk->bp, args);
> -		if (!retval && (args->rmtblkno > 0)
> -		    && !(args->flags & ATTR_KERNOVAL)) {
> -			retval = xfs_attr_rmtval_get(args);
> -		}
> +		goto out_release;
>  	}
> +	if (retval != -EEXIST)
> +		goto out_release;
> +
> +	/*
> +	 * Get the value, local or "remote"
> +	 */
> +	blk = &state->path.blk[state->path.active - 1];
> +	retval = xfs_attr3_leaf_getvalue(blk->bp, args);
> +	if (retval)
> +		goto out_release;
> +	if (args->flags & ATTR_KERNOVAL)
> +		goto out_release;
> +	if (args->rmtblkno > 0)
> +		retval = xfs_attr_rmtval_get(args);
>  
>  	/*
>  	 * If not in a transaction, we have to release all the buffers.
>  	 */
> +out_release:

No change at all here as far as I can tell, just using a goto to
unwind error handling, and rewriting some code to be less
dense/obsfucated.

>  int
>  xfs_attr_shortform_getvalue(xfs_da_args_t *args)
>  {
> @@ -743,7 +746,7 @@ xfs_attr_shortform_getvalue(xfs_da_args_t *args)
>  			continue;
>  		if (args->flags & ATTR_KERNOVAL) {
>  			args->valuelen = sfe->valuelen;
> -			return -EEXIST;
> +			return 0;
>  		}
>  		if (args->valuelen < sfe->valuelen) {
>  			args->valuelen = sfe->valuelen;
> @@ -752,7 +755,7 @@ xfs_attr_shortform_getvalue(xfs_da_args_t *args)
>  		args->valuelen = sfe->valuelen;
>  		memcpy(args->value, &sfe->nameval[args->namelen],
>  						    args->valuelen);
> -		return -EEXIST;
> +		return 0;

And here we have the first change - xfs_attr_shortform_getvalue now
returns 0 instead of -EEXIST when finding the xattr.  The old calling
conventions does indeed seem very odd.  As xfs_attr_shortform_getvalue
is directly called by the small xfs_attr_get_ilocked wrapper, which
only has two calers that fix up -EEXIST to 0 this looks safe.

So overall this looks good, but I think having this split into two
pure cleanups and one to actually switch this single case away from
-EEXIST (and document the chain as I wrote above while following it)
would have been more helpful.

So what:

Reviewed-by: Christoph Hellwig <hch@lst.de>
