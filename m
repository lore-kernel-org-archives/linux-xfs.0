Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03CCEC433F5
	for <linux-xfs@archiver.kernel.org>; Tue,  3 May 2022 22:44:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236979AbiECWrl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 May 2022 18:47:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232766AbiECWrk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 May 2022 18:47:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A7A2427FB
        for <linux-xfs@vger.kernel.org>; Tue,  3 May 2022 15:44:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD2D161764
        for <linux-xfs@vger.kernel.org>; Tue,  3 May 2022 22:44:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38B6DC385AE;
        Tue,  3 May 2022 22:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651617846;
        bh=31yB4syE5nNhOo176vHA5eHS3X3kME8m+/RB6E6uNqY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JrAhz2J37gFevjZTX3T20lv9eHDwz27FvjEI+lTay2lgyupvGRULjh8pADIAd7z9n
         wGIFgfOj1GGCqLexUzY2ZPxLnX7YIB9KV0FFkk3sjPA6+PSyslKV25cqi35lCivrUg
         yl8TdY0kjPeHnS++RVGYCXUdvPiNGBn24409dBdIH/AJllT+JnZPA/LDGzvzpro4bZ
         rhO5Nc6MXu2wbEMie8nc0iAkaKKyIf01rXRBWRAn3Bu3oCVZjoZoBXBwfgPi2SgX9R
         1dyOb09MbYIGHs8QHWcU+s3016JNTKg8kca4nyy/DyskN14k4cYeXAIOk0ywGu+ARy
         KFkFq3/8hz4/Q==
Date:   Tue, 3 May 2022 15:44:05 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/10] xfs: fix potential log item leak
Message-ID: <20220503224405.GC8265@magnolia>
References: <20220503221728.185449-1-david@fromorbit.com>
 <20220503221728.185449-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220503221728.185449-3-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 04, 2022 at 08:17:20AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Ever since we added shadown format buffers to the log items, log
> items need to handle the item being released with shadow buffers
> attached. Due to the fact this requirement was added at the same
> time we added new rmap/reflink intents, we missed the cleanup of
> those items.
> 
> In theory, this means shadow buffers can be leaked in a very small
> window when a shutdown is initiated. Testing with KASAN shows this
> leak does not happen in practice - we haven't identified a single
> leak in several years of shutdown testing since ~v4.8 kernels.
> 
> However, the intent whiteout cleanup mechanism results in every
> cancelled intent in exactly the same state as this tiny race window
> creates and so if intents down clean up shadow buffers on final
> release we will leak the shadow buffer for just about every intent
> we create.
> 
> Hence we start with this patch to close this condition off and
> ensure that when whiteouts start to be used we don't leak lots of
> memory.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_bmap_item.c     | 2 ++
>  fs/xfs/xfs_icreate_item.c  | 1 +
>  fs/xfs/xfs_refcount_item.c | 2 ++
>  fs/xfs/xfs_rmap_item.c     | 2 ++
>  4 files changed, 7 insertions(+)
> 
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index 593ac29cffc7..2c8b686e2a11 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -39,6 +39,7 @@ STATIC void
>  xfs_bui_item_free(
>  	struct xfs_bui_log_item	*buip)
>  {
> +	kmem_free(buip->bui_item.li_lv_shadow);
>  	kmem_cache_free(xfs_bui_cache, buip);
>  }
>  
> @@ -198,6 +199,7 @@ xfs_bud_item_release(
>  	struct xfs_bud_log_item	*budp = BUD_ITEM(lip);
>  
>  	xfs_bui_release(budp->bud_buip);
> +	kmem_free(budp->bud_item.li_lv_shadow);
>  	kmem_cache_free(xfs_bud_cache, budp);
>  }
>  
> diff --git a/fs/xfs/xfs_icreate_item.c b/fs/xfs/xfs_icreate_item.c
> index 508e184e3b8f..b05314d48176 100644
> --- a/fs/xfs/xfs_icreate_item.c
> +++ b/fs/xfs/xfs_icreate_item.c
> @@ -63,6 +63,7 @@ STATIC void
>  xfs_icreate_item_release(
>  	struct xfs_log_item	*lip)
>  {
> +	kmem_free(ICR_ITEM(lip)->ic_item.li_lv_shadow);

Oh hey, I missed one.  Good catch!

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>  	kmem_cache_free(xfs_icreate_cache, ICR_ITEM(lip));
>  }
>  
> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> index 0d868c93144d..10474fe389e1 100644
> --- a/fs/xfs/xfs_refcount_item.c
> +++ b/fs/xfs/xfs_refcount_item.c
> @@ -35,6 +35,7 @@ STATIC void
>  xfs_cui_item_free(
>  	struct xfs_cui_log_item	*cuip)
>  {
> +	kmem_free(cuip->cui_item.li_lv_shadow);
>  	if (cuip->cui_format.cui_nextents > XFS_CUI_MAX_FAST_EXTENTS)
>  		kmem_free(cuip);
>  	else
> @@ -204,6 +205,7 @@ xfs_cud_item_release(
>  	struct xfs_cud_log_item	*cudp = CUD_ITEM(lip);
>  
>  	xfs_cui_release(cudp->cud_cuip);
> +	kmem_free(cudp->cud_item.li_lv_shadow);
>  	kmem_cache_free(xfs_cud_cache, cudp);
>  }
>  
> diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> index a22b2d19ef91..6c0b56ebdbe1 100644
> --- a/fs/xfs/xfs_rmap_item.c
> +++ b/fs/xfs/xfs_rmap_item.c
> @@ -35,6 +35,7 @@ STATIC void
>  xfs_rui_item_free(
>  	struct xfs_rui_log_item	*ruip)
>  {
> +	kmem_free(ruip->rui_item.li_lv_shadow);
>  	if (ruip->rui_format.rui_nextents > XFS_RUI_MAX_FAST_EXTENTS)
>  		kmem_free(ruip);
>  	else
> @@ -227,6 +228,7 @@ xfs_rud_item_release(
>  	struct xfs_rud_log_item	*rudp = RUD_ITEM(lip);
>  
>  	xfs_rui_release(rudp->rud_ruip);
> +	kmem_free(rudp->rud_item.li_lv_shadow);
>  	kmem_cache_free(xfs_rud_cache, rudp);
>  }
>  
> -- 
> 2.35.1
> 
