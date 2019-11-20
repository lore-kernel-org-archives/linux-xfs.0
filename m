Return-Path: <SRS0=ArDI=ZM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5A0EC432C0
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Nov 2019 21:24:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9CA002084D
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Nov 2019 21:24:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbfKTVYG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Nov 2019 16:24:06 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:49750 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725819AbfKTVYF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Nov 2019 16:24:05 -0500
Received: from dread.disaster.area (pa49-181-255-80.pa.nsw.optusnet.com.au [49.181.255.80])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id A13697E993C;
        Thu, 21 Nov 2019 08:24:01 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1iXXSD-0002CP-2V; Thu, 21 Nov 2019 08:24:01 +1100
Date:   Thu, 21 Nov 2019 08:24:01 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Carlos Maiolino <cmaiolino@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: remove kmem_zalloc() wrapper
Message-ID: <20191120212401.GC4614@dread.disaster.area>
References: <20191120104425.407213-1-cmaiolino@redhat.com>
 <20191120104425.407213-4-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191120104425.407213-4-cmaiolino@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=XqaD5fcB6dAc7xyKljs8OA==:117 a=XqaD5fcB6dAc7xyKljs8OA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=MeAgGD-zjQ4A:10
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=RgmFrBbF6wjprUVwLc8A:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 20, 2019 at 11:44:23AM +0100, Carlos Maiolino wrote:
> Use kzalloc() directly
> 
> Special attention goes to function xfs_buf_map_from_irec(). Giving the
> fact we are not allowed to fail there, I removed the 'if (!map)'
> conditional from there, I'd just like somebody to double check if it's
> fine as I believe it is
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

It looks good as a 1:1 translation, but I've noticed a few places we
actually have the context wrong and have been saved by the fact tehy
are called in transaction context (hence GFP_NOFS is enforced by
task flags).

This can be fixed in a separate patch, I've noted the ones I think
need changing below.

> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 795b9b21b64d..67de68584224 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -2253,7 +2253,8 @@ xfs_attr3_leaf_unbalance(
>  		struct xfs_attr_leafblock *tmp_leaf;
>  		struct xfs_attr3_icleaf_hdr tmphdr;
>  
> -		tmp_leaf = kmem_zalloc(state->args->geo->blksize, 0);
> +		tmp_leaf = kzalloc(state->args->geo->blksize,
> +				   GFP_KERNEL | __GFP_NOFAIL);

In a transaction, GFP_NOFS.

> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index dc39b2d1b351..4fea8e5e70fb 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -701,8 +701,8 @@ xfs_buf_item_get_format(
>  		return 0;
>  	}
>  
> -	bip->bli_formats = kmem_zalloc(count * sizeof(struct xfs_buf_log_format),
> -				0);
> +	bip->bli_formats = kzalloc(count * sizeof(struct xfs_buf_log_format),
> +				   GFP_KERNEL | __GFP_NOFAIL);
>  	if (!bip->bli_formats)
>  		return -ENOMEM;
>  	return 0;

In a transaction, GFP_NOFS.

> diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
> index 1b5e68ccef60..91bd47e8b832 100644
> --- a/fs/xfs/xfs_dquot_item.c
> +++ b/fs/xfs/xfs_dquot_item.c
> @@ -347,7 +347,8 @@ xfs_qm_qoff_logitem_init(
>  {
>  	struct xfs_qoff_logitem	*qf;
>  
> -	qf = kmem_zalloc(sizeof(struct xfs_qoff_logitem), 0);
> +	qf = kzalloc(sizeof(struct xfs_qoff_logitem),
> +		     GFP_KERNEL | __GFP_NOFAIL);

In a transaction, GFP_NOFS.

> diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
> index 9f0b99c7b34a..0ce50b47fc28 100644
> --- a/fs/xfs/xfs_extent_busy.c
> +++ b/fs/xfs/xfs_extent_busy.c
> @@ -33,7 +33,8 @@ xfs_extent_busy_insert(
>  	struct rb_node		**rbp;
>  	struct rb_node		*parent = NULL;
>  
> -	new = kmem_zalloc(sizeof(struct xfs_extent_busy), 0);
> +	new = kzalloc(sizeof(struct xfs_extent_busy),
> +		      GFP_KERNEL | __GFP_NOFAIL);

transaction, GFP_NOFS.

>  	new->agno = agno;
>  	new->bno = bno;
>  	new->length = len;
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index c3b8804aa396..872312029957 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -163,7 +163,7 @@ xfs_efi_init(
>  	if (nextents > XFS_EFI_MAX_FAST_EXTENTS) {
>  		size = (uint)(sizeof(xfs_efi_log_item_t) +
>  			((nextents - 1) * sizeof(xfs_extent_t)));
> -		efip = kmem_zalloc(size, 0);
> +		efip = kzalloc(size, GFP_KERNEL | __GFP_NOFAIL);
>  	} else {
>  		efip = kmem_cache_zalloc(xfs_efi_zone,
>  					 GFP_KERNEL | __GFP_NOFAIL);

Both of these GFP_NOFS.

> @@ -333,9 +333,9 @@ xfs_trans_get_efd(
>  	ASSERT(nextents > 0);
>  
>  	if (nextents > XFS_EFD_MAX_FAST_EXTENTS) {
> -		efdp = kmem_zalloc(sizeof(struct xfs_efd_log_item) +
> +		efdp = kzalloc(sizeof(struct xfs_efd_log_item) +
>  				(nextents - 1) * sizeof(struct xfs_extent),
> -				0);
> +				GFP_KERNEL | __GFP_NOFAIL);
>  	} else {
>  		efdp = kmem_cache_zalloc(xfs_efd_zone,
>  					 GFP_KERNEL | __GFP_NOFAIL);

Same here.

Hmmm. I guess I better go look at the kmem_cache_[z]alloc() patches,
too.

> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> index 76b39f2a0260..7ec70a5f1cb0 100644
> --- a/fs/xfs/xfs_refcount_item.c
> +++ b/fs/xfs/xfs_refcount_item.c
> @@ -143,8 +143,8 @@ xfs_cui_init(
>  
>  	ASSERT(nextents > 0);
>  	if (nextents > XFS_CUI_MAX_FAST_EXTENTS)
> -		cuip = kmem_zalloc(xfs_cui_log_item_sizeof(nextents),
> -				0);
> +		cuip = kzalloc(xfs_cui_log_item_sizeof(nextents),
> +			       GFP_KERNEL | __GFP_NOFAIL);
>  	else
>  		cuip = kmem_cache_zalloc(xfs_cui_zone,
>  					 GFP_KERNEL | __GFP_NOFAIL);

Both GFP_NOFS.

> diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> index 6aeb6745d007..82d822885996 100644
> --- a/fs/xfs/xfs_rmap_item.c
> +++ b/fs/xfs/xfs_rmap_item.c
> @@ -142,7 +142,8 @@ xfs_rui_init(
>  
>  	ASSERT(nextents > 0);
>  	if (nextents > XFS_RUI_MAX_FAST_EXTENTS)
> -		ruip = kmem_zalloc(xfs_rui_log_item_sizeof(nextents), 0);
> +		ruip = kzalloc(xfs_rui_log_item_sizeof(nextents),
> +			       GFP_KERNEL | __GFP_NOFAIL);
>  	else
>  		ruip = kmem_cache_zalloc(xfs_rui_zone,
>  					 GFP_KERNEL | __GFP_NOFAIL);

Both GFP_NOFS.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
