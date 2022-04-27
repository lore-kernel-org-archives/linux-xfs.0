Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5243C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Apr 2022 03:18:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233349AbiD0DWF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Apr 2022 23:22:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiD0DWE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Apr 2022 23:22:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AAFC26575
        for <linux-xfs@vger.kernel.org>; Tue, 26 Apr 2022 20:18:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1A0FAB822A9
        for <linux-xfs@vger.kernel.org>; Wed, 27 Apr 2022 03:18:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A802CC385A4;
        Wed, 27 Apr 2022 03:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651029531;
        bh=o7bKFzF+uI+Y50+3Rmt6WzbuVecOxhSqbJftg4t1Z60=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bnOANiFvDNvS1seLIcytxuGMi3sCDUN8KeQVmBMETeoaAwOHzA00s95ZXoNV56ubS
         HthFKNFIrutFYZXMHMw+DmgPzfdfBGPMHSwJw4AwEM/t83jwFxDeFsWZlTldgE2g6d
         iU7itIypuow1/eHZexUxOMZf/eomrGKTVWELYeZtxHZK0zsn7LjgVTiPZvHbMFAyBD
         l1aP82Cx7FQFsa70KXx78FzwoOTAIEZ8u3Y3cFRF53Vvi2uS9+PuvGd9ztW8CceCpV
         uyKIWf0llzJnZNVwR/KZkhh+JCG2JvfMrA52XFxaZ7kUJ76gAlXr/9AYEiGnzS8oXG
         Ol2OMEqRSpGxg==
Date:   Tue, 26 Apr 2022 20:18:51 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/8] xfs: add log item method to return related intents
Message-ID: <20220427031851.GF17025@magnolia>
References: <20220427022259.695399-1-david@fromorbit.com>
 <20220427022259.695399-7-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427022259.695399-7-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 27, 2022 at 12:22:57PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> To apply a whiteout to an intent item when an intent done item is
> committed, we need to be able to retrieve the intent item from the
> the intent done item. Add a log item op method for doing this, and
> wire all the intent done items up to it.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

We'll see what I think about the last patch, but the code changes here
look acceptable.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_bmap_item.c     | 8 ++++++++
>  fs/xfs/xfs_extfree_item.c  | 8 ++++++++
>  fs/xfs/xfs_refcount_item.c | 8 ++++++++
>  fs/xfs/xfs_rmap_item.c     | 8 ++++++++
>  fs/xfs/xfs_trans.h         | 1 +
>  5 files changed, 33 insertions(+)
> 
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index 3b968b31911b..e1b0e321d604 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -201,12 +201,20 @@ xfs_bud_item_release(
>  	kmem_cache_free(xfs_bud_cache, budp);
>  }
>  
> +static struct xfs_log_item *
> +xfs_bud_item_intent(
> +	struct xfs_log_item	*lip)
> +{
> +	return &BUD_ITEM(lip)->bud_buip->bui_item;
> +}
> +
>  static const struct xfs_item_ops xfs_bud_item_ops = {
>  	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED |
>  			  XFS_ITEM_INTENT_DONE,
>  	.iop_size	= xfs_bud_item_size,
>  	.iop_format	= xfs_bud_item_format,
>  	.iop_release	= xfs_bud_item_release,
> +	.iop_intent	= xfs_bud_item_intent,
>  };
>  
>  static struct xfs_bud_log_item *
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index 96735f23d12d..032db5269e97 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -306,12 +306,20 @@ xfs_efd_item_release(
>  	xfs_efd_item_free(efdp);
>  }
>  
> +static struct xfs_log_item *
> +xfs_efd_item_intent(
> +	struct xfs_log_item	*lip)
> +{
> +	return &EFD_ITEM(lip)->efd_efip->efi_item;
> +}
> +
>  static const struct xfs_item_ops xfs_efd_item_ops = {
>  	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED |
>  			  XFS_ITEM_INTENT_DONE,
>  	.iop_size	= xfs_efd_item_size,
>  	.iop_format	= xfs_efd_item_format,
>  	.iop_release	= xfs_efd_item_release,
> +	.iop_intent	= xfs_efd_item_intent,
>  };
>  
>  /*
> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> index b523ce2c775b..a2213b5ee344 100644
> --- a/fs/xfs/xfs_refcount_item.c
> +++ b/fs/xfs/xfs_refcount_item.c
> @@ -207,12 +207,20 @@ xfs_cud_item_release(
>  	kmem_cache_free(xfs_cud_cache, cudp);
>  }
>  
> +static struct xfs_log_item *
> +xfs_cud_item_intent(
> +	struct xfs_log_item	*lip)
> +{
> +	return &CUD_ITEM(lip)->cud_cuip->cui_item;
> +}
> +
>  static const struct xfs_item_ops xfs_cud_item_ops = {
>  	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED |
>  			  XFS_ITEM_INTENT_DONE,
>  	.iop_size	= xfs_cud_item_size,
>  	.iop_format	= xfs_cud_item_format,
>  	.iop_release	= xfs_cud_item_release,
> +	.iop_intent	= xfs_cud_item_intent,
>  };
>  
>  static struct xfs_cud_log_item *
> diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> index b269e68407b9..053eb135380c 100644
> --- a/fs/xfs/xfs_rmap_item.c
> +++ b/fs/xfs/xfs_rmap_item.c
> @@ -230,12 +230,20 @@ xfs_rud_item_release(
>  	kmem_cache_free(xfs_rud_cache, rudp);
>  }
>  
> +static struct xfs_log_item *
> +xfs_rud_item_intent(
> +	struct xfs_log_item	*lip)
> +{
> +	return &RUD_ITEM(lip)->rud_ruip->rui_item;
> +}
> +
>  static const struct xfs_item_ops xfs_rud_item_ops = {
>  	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED |
>  			  XFS_ITEM_INTENT_DONE,
>  	.iop_size	= xfs_rud_item_size,
>  	.iop_format	= xfs_rud_item_format,
>  	.iop_release	= xfs_rud_item_release,
> +	.iop_intent	= xfs_rud_item_intent,
>  };
>  
>  static struct xfs_rud_log_item *
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index f68e74e46026..d72a5995d33e 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -78,6 +78,7 @@ struct xfs_item_ops {
>  	bool (*iop_match)(struct xfs_log_item *item, uint64_t id);
>  	struct xfs_log_item *(*iop_relog)(struct xfs_log_item *intent,
>  			struct xfs_trans *tp);
> +	struct xfs_log_item *(*iop_intent)(struct xfs_log_item *intent_done);
>  };
>  
>  /*
> -- 
> 2.35.1
> 
