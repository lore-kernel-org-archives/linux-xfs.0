Return-Path: <SRS0=CuST=WZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 586B5C3A59F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 07:41:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E43822CF5
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 07:41:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="eP+E4Ipa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725853AbfH2Hlk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Aug 2019 03:41:40 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:44942 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725807AbfH2Hlk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Aug 2019 03:41:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=/9ob14vegRPsXYEWs7PbEGzb5k9TlSldwi8L/cudB9Q=; b=eP+E4IpanqCZ3bloJps9vaFT5
        sr/1pyZQ4iRvlsema/by4/b1O1EDNd8DjLTPI8AQCgIyFemwBEZV8LTt0TD3GmkANyMNw0LovLGRY
        57D1On0LfabTCLSn3o7kltjNxbU70QbVKn/gwGRcm0SuALlmb4WAw/73Hgde8ZUnlkawY47mV3L7t
        ww+lu/oDuQ1kN7q7qg3U2w8gkldw+2jZBMIxNNZXOwLQONuoiNAN7l4yaC1F952+7ynHGhpGVZNnA
        V8mncYHKEUd8RGFCml1GivdgdfhLirBh7+cv9DEKDC+3ENrr0+d6QUyATPNqyjBZ/epqiIh3lpS/A
        TXx5xzBMQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i3F3s-0007ZH-0m; Thu, 29 Aug 2019 07:41:40 +0000
Date:   Thu, 29 Aug 2019 00:41:39 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: make attr lookup returns consistent
Message-ID: <20190829074139.GA18966@infradead.org>
References: <20190828042350.6062-1-david@fromorbit.com>
 <20190828042350.6062-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190828042350.6062-2-david@fromorbit.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 28, 2019 at 02:23:48PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Shortform, leaf and remote value attr value retrieval return
> different values for success. This makes it more complex to handle
> actual errors xfs_attr_get() as some errors mean success and some
> mean failure. Make the return values consistent for success and
> failure consistent for all attribute formats.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c        | 57 +++++++++++++++++++++------------
>  fs/xfs/libxfs/xfs_attr_leaf.c   | 15 ++++++---
>  fs/xfs/libxfs/xfs_attr_remote.c |  2 ++
>  fs/xfs/scrub/attr.c             |  2 --
>  4 files changed, 49 insertions(+), 27 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index d48fcf11cc35..776343c4f22b 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -97,7 +97,10 @@ xfs_inode_hasattr(
>   * Overall external interface routines.
>   *========================================================================*/
>  
> -/* Retrieve an extended attribute and its value.  Must have ilock. */
> +/*
> + * Retrieve an extended attribute and its value.  Must have ilock.
> + * Returns 0 on successful retrieval, otherwise an error.
> + */
>  int
>  xfs_attr_get_ilocked(
>  	struct xfs_inode	*ip,
> @@ -147,7 +150,7 @@ xfs_attr_get(
>  	xfs_iunlock(ip, lock_mode);
>  
>  	*valuelenp = args.valuelen;
> -	return error == -EEXIST ? 0 : error;
> +	return error;
>  }
>  
>  /*
> @@ -768,6 +771,8 @@ xfs_attr_leaf_removename(
>   *
>   * This leaf block cannot have a "remote" value, we only call this routine
>   * if bmap_one_block() says there is only one block (ie: no remote blks).
> + *
> + * Returns 0 on successful retrieval, otherwise an error.
>   */
>  STATIC int
>  xfs_attr_leaf_get(xfs_da_args_t *args)
> @@ -789,10 +794,15 @@ xfs_attr_leaf_get(xfs_da_args_t *args)
>  	}
>  	error = xfs_attr3_leaf_getvalue(bp, args);
>  	xfs_trans_brelse(args->trans, bp);
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
>  }
>  
>  /*========================================================================
> @@ -1268,11 +1278,13 @@ xfs_attr_refillstate(xfs_da_state_t *state)
>  }
>  
>  /*
> - * Look up a filename in a node attribute list.
> + * Retreive the attribute data from a node attribute list.
>   *
>   * This routine gets called for any attribute fork that has more than one
>   * block, ie: both true Btree attr lists and for single-leaf-blocks with
>   * "remote" values taking up more blocks.
> + *
> + * Returns 0 on successful retrieval, otherwise an error.
>   */
>  STATIC int
>  xfs_attr_node_get(xfs_da_args_t *args)
> @@ -1289,29 +1301,32 @@ xfs_attr_node_get(xfs_da_args_t *args)
>  	state->mp = args->dp->i_mount;
>  
>  	/*
> -	 * Search to see if name exists, and get back a pointer to it.
> +	  Search to see if name exists, and get back a pointer to it.
>  	 */
>  	error = xfs_da3_node_lookup_int(state, &retval);
>  	if (error) {
>  		retval = error;

Given that you are cleaning up this mess, can you check if there
is any point in the weird xfs_da3_node_lookup_int calling conventions?
It looks like it can return errnos in both the return value and
*revtval, and from a quick check it seems like all callers treat them
more or less the same.
