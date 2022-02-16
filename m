Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE22EC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Feb 2022 02:30:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241563AbiBPCai (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Feb 2022 21:30:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233821AbiBPCai (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Feb 2022 21:30:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE39FF5426
        for <linux-xfs@vger.kernel.org>; Tue, 15 Feb 2022 18:30:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A42961852
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 02:30:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D45B3C340EB;
        Wed, 16 Feb 2022 02:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644978625;
        bh=HEmmx8iFsnbfmntW8Kl9vWzvlpWAvBVX00ejWk6YbF8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=crEYPL6zIswcXOY/gB5S8VHoHQIucJ4nnHTre5OAj7HHjZHmbW7iGpScXyJMNpahj
         cPOHoX6aVZbK1sF9I9dKGPLCMG5MP/PCIZtPKRQDfOhMdh8i6wjuepA2dBC0iE+/UC
         u8uODTCQPMW88J3rwm8MpEhMHB7ViSOgIN+dKtMtEcCaZPwutsXSif4OkZwHtd1R5N
         6OP21pYTEKVUFP4oCQVWHNh+96MmIUZefLOBq7kZHLx1+H6EWNTLsgaV46yoBhRxcJ
         ZKmSLJ13kLtP/YBxBKiXybV5mgaCZqxiPHaAyjKitJi1eBn3czDo0w2qAFc3wvunKZ
         QXsN+/+MqLCaA==
Date:   Tue, 15 Feb 2022 18:30:25 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v27 13/15] xfs: Add helper function xfs_init_attr_trans
Message-ID: <20220216023025.GK8313@magnolia>
References: <20220216013713.1191082-1-allison.henderson@oracle.com>
 <20220216013713.1191082-14-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220216013713.1191082-14-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 15, 2022 at 06:37:11PM -0700, Allison Henderson wrote:
> Quick helper function to collapse duplicate code to initialize
> transactions for attributes
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> Suggested-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 32 ++++++++++++++++++++++----------
>  fs/xfs/libxfs/xfs_attr.h |  2 ++
>  fs/xfs/xfs_attr_item.c   | 12 ++----------
>  3 files changed, 26 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 7d6ad1d0e10b..d51aea332ca1 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -202,6 +202,27 @@ xfs_attr_calc_size(
>  	return nblks;
>  }
>  
> +/* Initialize transaction reservation for attr operations */
> +void xfs_init_attr_trans(

Nit: start the function name on a separate line.

With that fixed,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> +	struct xfs_da_args	*args,
> +	struct xfs_trans_res	*tres,
> +	unsigned int		*total)
> +{
> +	struct xfs_mount	*mp = args->dp->i_mount;
> +
> +	if (args->value) {
> +		tres->tr_logres = M_RES(mp)->tr_attrsetm.tr_logres +
> +				 M_RES(mp)->tr_attrsetrt.tr_logres *
> +				 args->total;
> +		tres->tr_logcount = XFS_ATTRSET_LOG_COUNT;
> +		tres->tr_logflags = XFS_TRANS_PERM_LOG_RES;
> +		*total = args->total;
> +	} else {
> +		*tres = M_RES(mp)->tr_attrrm;
> +		*total = XFS_ATTRRM_SPACE_RES(mp);
> +	}
> +}
> +
>  STATIC int
>  xfs_attr_try_sf_addname(
>  	struct xfs_inode	*dp,
> @@ -701,20 +722,10 @@ xfs_attr_set(
>  				return error;
>  		}
>  
> -		tres.tr_logres = M_RES(mp)->tr_attrsetm.tr_logres +
> -				 M_RES(mp)->tr_attrsetrt.tr_logres *
> -					args->total;
> -		tres.tr_logcount = XFS_ATTRSET_LOG_COUNT;
> -		tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
> -		total = args->total;
> -
>  		if (!local)
>  			rmt_blks = xfs_attr3_rmt_blocks(mp, args->valuelen);
>  	} else {
>  		XFS_STATS_INC(mp, xs_attr_remove);
> -
> -		tres = M_RES(mp)->tr_attrrm;
> -		total = XFS_ATTRRM_SPACE_RES(mp);
>  		rmt_blks = xfs_attr3_rmt_blocks(mp, XFS_XATTR_SIZE_MAX);
>  	}
>  
> @@ -728,6 +739,7 @@ xfs_attr_set(
>  	 * Root fork attributes can use reserved data blocks for this
>  	 * operation if necessary
>  	 */
> +	xfs_init_attr_trans(args, &tres, &total);
>  	error = xfs_trans_alloc_inode(dp, &tres, total, 0, rsvd, &args->trans);
>  	if (error)
>  		goto drop_incompat;
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index 1ef58d34eb59..f6c13d2bfbcd 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -519,6 +519,8 @@ int xfs_attr_set_iter(struct xfs_attr_item *attr);
>  int xfs_attr_remove_iter(struct xfs_attr_item *attr);
>  bool xfs_attr_namecheck(const void *name, size_t length);
>  int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
> +void xfs_init_attr_trans(struct xfs_da_args *args, struct xfs_trans_res *tres,
> +			 unsigned int *total);
>  int xfs_attr_set_deferred(struct xfs_da_args *args);
>  int xfs_attr_remove_deferred(struct xfs_da_args *args);
>  
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index 878f50babb23..5aa7a764d95e 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -532,17 +532,9 @@ xfs_attri_item_recover(
>  		args->value = attrip->attri_value;
>  		args->valuelen = attrp->alfi_value_len;
>  		args->total = xfs_attr_calc_size(args, &local);
> -
> -		tres.tr_logres = M_RES(mp)->tr_attrsetm.tr_logres +
> -				 M_RES(mp)->tr_attrsetrt.tr_logres *
> -					args->total;
> -		tres.tr_logcount = XFS_ATTRSET_LOG_COUNT;
> -		tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
> -		total = args->total;
> -	} else {
> -		tres = M_RES(mp)->tr_attrrm;
> -		total = XFS_ATTRRM_SPACE_RES(mp);
>  	}
> +
> +	xfs_init_attr_trans(args, &tres, &total);
>  	error = xfs_trans_alloc(mp, &tres, total, 0, XFS_TRANS_RESERVE, &tp);
>  	if (error)
>  		goto out;
> -- 
> 2.25.1
> 
