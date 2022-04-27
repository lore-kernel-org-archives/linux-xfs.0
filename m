Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E71ECC433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Apr 2022 03:07:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357353AbiD0DKQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Apr 2022 23:10:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357405AbiD0DHx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Apr 2022 23:07:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D433427F6
        for <linux-xfs@vger.kernel.org>; Tue, 26 Apr 2022 20:04:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2838BB8249E
        for <linux-xfs@vger.kernel.org>; Wed, 27 Apr 2022 03:04:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE34EC385A4;
        Wed, 27 Apr 2022 03:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651028679;
        bh=xaNBz4wsKPAVOywXsDPqLHXFEs9O95S/TsUMKtvW+GI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VUl+VOMekjyKMxGWw6RG6OZ/0vl3YBFH/hx+aVMRzMWrMIeyLpNRE5o1awVx1jSse
         R4wGdnwKur6pvgJv8PYuOdi7c3HmdFDfom71ayGYBrMyvnG9o4zA87IJlr4OWZx8VB
         fU6u6QEKsxkpxbLtLh3QFC7iiZpX2GbMsCbOr7iL0n+i/lpT+MYca1pYBjL7zVgrVL
         CdJHnbGAGKVgRar8sbRgdHr+lRoFSByOpTHeD+jqF560m11JQxM8KHEev057kmIo/C
         d2T32HMVpriPx31jl4f5e0XakBFg+9Z613i7O6a75wvJii1pcYY8+2tsgv5GPpnXOR
         71kceFjtKBAiA==
Date:   Tue, 26 Apr 2022 20:04:39 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/8] xfs: add log item flags to indicate intents
Message-ID: <20220427030439.GB17025@magnolia>
References: <20220427022259.695399-1-david@fromorbit.com>
 <20220427022259.695399-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427022259.695399-4-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 27, 2022 at 12:22:54PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We currently have a couple of helper functions that try to infer
> whether the log item is an intent or intent done item from the
> combinations of operations it supports.  This is incredibly fragile
> and not very efficient as it requires checking specific combinations
> of ops.
> 
> We need to be able to identify intent and intent done items quickly
> and easily in upcoming patches, so simply add intent and intent done
> type flags to the log item ops flags. These are static flags to
> begin with, so intent items should have been typed like this from
> the start.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

Heh, I remember being told to infer intentness or intentdoneness instead
of using explicit flags...

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_bmap_item.c     |  4 +++-
>  fs/xfs/xfs_extfree_item.c  |  4 +++-
>  fs/xfs/xfs_refcount_item.c |  4 +++-
>  fs/xfs/xfs_rmap_item.c     |  4 +++-
>  fs/xfs/xfs_trans.h         | 25 +++++++++++++------------
>  5 files changed, 25 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index 593ac29cffc7..ed67c0028a68 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -202,7 +202,8 @@ xfs_bud_item_release(
>  }
>  
>  static const struct xfs_item_ops xfs_bud_item_ops = {
> -	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED,
> +	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED |
> +			  XFS_ITEM_INTENT_DONE,
>  	.iop_size	= xfs_bud_item_size,
>  	.iop_format	= xfs_bud_item_format,
>  	.iop_release	= xfs_bud_item_release,
> @@ -586,6 +587,7 @@ xfs_bui_item_relog(
>  }
>  
>  static const struct xfs_item_ops xfs_bui_item_ops = {
> +	.flags		= XFS_ITEM_INTENT,
>  	.iop_size	= xfs_bui_item_size,
>  	.iop_format	= xfs_bui_item_format,
>  	.iop_unpin	= xfs_bui_item_unpin,
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index 0e50f2c9348e..21a159f9d8c5 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -307,7 +307,8 @@ xfs_efd_item_release(
>  }
>  
>  static const struct xfs_item_ops xfs_efd_item_ops = {
> -	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED,
> +	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED |
> +			  XFS_ITEM_INTENT_DONE,
>  	.iop_size	= xfs_efd_item_size,
>  	.iop_format	= xfs_efd_item_format,
>  	.iop_release	= xfs_efd_item_release,
> @@ -688,6 +689,7 @@ xfs_efi_item_relog(
>  }
>  
>  static const struct xfs_item_ops xfs_efi_item_ops = {
> +	.flags		= XFS_ITEM_INTENT,
>  	.iop_size	= xfs_efi_item_size,
>  	.iop_format	= xfs_efi_item_format,
>  	.iop_unpin	= xfs_efi_item_unpin,
> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> index 0d868c93144d..6536eea4c6ea 100644
> --- a/fs/xfs/xfs_refcount_item.c
> +++ b/fs/xfs/xfs_refcount_item.c
> @@ -208,7 +208,8 @@ xfs_cud_item_release(
>  }
>  
>  static const struct xfs_item_ops xfs_cud_item_ops = {
> -	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED,
> +	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED |
> +			  XFS_ITEM_INTENT_DONE,
>  	.iop_size	= xfs_cud_item_size,
>  	.iop_format	= xfs_cud_item_format,
>  	.iop_release	= xfs_cud_item_release,
> @@ -600,6 +601,7 @@ xfs_cui_item_relog(
>  }
>  
>  static const struct xfs_item_ops xfs_cui_item_ops = {
> +	.flags		= XFS_ITEM_INTENT,
>  	.iop_size	= xfs_cui_item_size,
>  	.iop_format	= xfs_cui_item_format,
>  	.iop_unpin	= xfs_cui_item_unpin,
> diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> index a22b2d19ef91..c2bb8cfc231e 100644
> --- a/fs/xfs/xfs_rmap_item.c
> +++ b/fs/xfs/xfs_rmap_item.c
> @@ -231,7 +231,8 @@ xfs_rud_item_release(
>  }
>  
>  static const struct xfs_item_ops xfs_rud_item_ops = {
> -	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED,
> +	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED |
> +			  XFS_ITEM_INTENT_DONE,
>  	.iop_size	= xfs_rud_item_size,
>  	.iop_format	= xfs_rud_item_format,
>  	.iop_release	= xfs_rud_item_release,
> @@ -630,6 +631,7 @@ xfs_rui_item_relog(
>  }
>  
>  static const struct xfs_item_ops xfs_rui_item_ops = {
> +	.flags		= XFS_ITEM_INTENT,
>  	.iop_size	= xfs_rui_item_size,
>  	.iop_format	= xfs_rui_item_format,
>  	.iop_unpin	= xfs_rui_item_unpin,
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index 87e940b5366e..f68e74e46026 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -80,28 +80,29 @@ struct xfs_item_ops {
>  			struct xfs_trans *tp);
>  };
>  
> -/* Is this log item a deferred action intent? */
> +/*
> + * Log item ops flags
> + */
> +/*
> + * Release the log item when the journal commits instead of inserting into the
> + * AIL for writeback tracking and/or log tail pinning.
> + */
> +#define XFS_ITEM_RELEASE_WHEN_COMMITTED	(1 << 0)
> +#define XFS_ITEM_INTENT			(1 << 1)
> +#define XFS_ITEM_INTENT_DONE		(1 << 2)
> +
>  static inline bool
>  xlog_item_is_intent(struct xfs_log_item *lip)
>  {
> -	return lip->li_ops->iop_recover != NULL &&
> -	       lip->li_ops->iop_match != NULL;
> +	return lip->li_ops->flags & XFS_ITEM_INTENT;
>  }
>  
> -/* Is this a log intent-done item? */
>  static inline bool
>  xlog_item_is_intent_done(struct xfs_log_item *lip)
>  {
> -	return lip->li_ops->iop_unpin == NULL &&
> -	       lip->li_ops->iop_push == NULL;
> +	return lip->li_ops->flags & XFS_ITEM_INTENT_DONE;
>  }
>  
> -/*
> - * Release the log item as soon as committed.  This is for items just logging
> - * intents that never need to be written back in place.
> - */
> -#define XFS_ITEM_RELEASE_WHEN_COMMITTED	(1 << 0)
> -
>  void	xfs_log_item_init(struct xfs_mount *mp, struct xfs_log_item *item,
>  			  int type, const struct xfs_item_ops *ops);
>  
> -- 
> 2.35.1
> 
