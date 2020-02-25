Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 868E0C35E01
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 16:27:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B88620CC7
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 16:27:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZQRqkwtL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730315AbgBYQ1x (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 11:27:53 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:47966 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728981AbgBYQ1w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 11:27:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582648071;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cfCRlE0+14qxvFTREfER9l6bK3IVw6KGSijIkbnJNZE=;
        b=ZQRqkwtLfpYbxU7W+GMiCmMLFHw+tvWtlnBBvfRgOdthid4pmg5PVES6nF/kxfmAu3LgtQ
        96Hm1BO0x+6IkYLmLIS52d7TinDMPgyQOM2GwXQhN7om+ic0owrVB+DkMkFlyLVLG8GGEs
        OPz1utw8HOBpHWQjINFJ+GVEcEj7H1Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-148-nJrRxTD2OT67KfG-6t_wRg-1; Tue, 25 Feb 2020 11:27:44 -0500
X-MC-Unique: nJrRxTD2OT67KfG-6t_wRg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7212318A6ECB;
        Tue, 25 Feb 2020 16:27:43 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 887371001902;
        Tue, 25 Feb 2020 16:27:42 +0000 (UTC)
Date:   Tue, 25 Feb 2020 11:27:40 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Chandan Rajendra <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        chandan@linux.ibm.com, darrick.wong@oracle.com, amir73il@gmail.com
Subject: Re: [PATCH V4 RESEND 4/7] xfs: Introduce struct xfs_attr_set_resv
Message-ID: <20200225162740.GD54181@bfoster>
References: <20200224040044.30923-1-chandanrlinux@gmail.com>
 <20200224040044.30923-5-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200224040044.30923-5-chandanrlinux@gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 24, 2020 at 09:30:41AM +0530, Chandan Rajendra wrote:
> The intermediate numbers calculated by xfs_attr_calc_size() will be needed by
> a future commit to correctly calculate log reservation for xattr set
> operation. Towards this goal, this commit introduces 'struct
> xfs_attr_set_resv' to collect,
> 1. Number of dabtree blocks.
> 2. Number of remote blocks.
> 3. Number of Bmbt blocks.
> 4. Total number of blocks we need to reserve.
> 
> This will be returned as an out argument by xfs_attr_calc_size().
> 
> Signed-off-by: Chandan Rajendra <chandanrlinux@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 50 ++++++++++++++++++++++------------------
>  fs/xfs/libxfs/xfs_attr.h | 13 +++++++++++
>  2 files changed, 40 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index a708b142f69b6..921acac71e5d9 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -136,16 +136,14 @@ xfs_attr_get(
>  /*
>   * Calculate how many blocks we need for the new attribute,
>   */
> -STATIC int
> +STATIC void
>  xfs_attr_calc_size(
> -	struct xfs_da_args	*args,
> -	int			*local)
> +	struct xfs_da_args		*args,
> +	struct xfs_attr_set_resv	*resv,
> +	int				*local)
>  {
> -	struct xfs_mount	*mp = args->dp->i_mount;
> -	unsigned int		total_dablks;
> -	unsigned int		bmbt_blks;
> -	unsigned int		rmt_blks;
> -	int			size;
> +	struct xfs_mount		*mp = args->dp->i_mount;
> +	int				size;
>  
>  	/*
>  	 * Determine space new attribute will use, and if it would be
> @@ -153,25 +151,27 @@ xfs_attr_calc_size(
>  	 */
>  	size = xfs_attr_leaf_newentsize(args->geo, args->namelen,
>  			args->valuelen, local);
> -	total_dablks = XFS_DAENTER_BLOCKS(mp, XFS_ATTR_FORK);
> +	resv->total_dablks = XFS_DAENTER_BLOCKS(mp, XFS_ATTR_FORK);
>  	if (*local) {
>  		if (size > (args->geo->blksize / 2)) {
>  			/* Double split possible */
> -			total_dablks *= 2;
> +			resv->total_dablks *= 2;
>  		}
> -		rmt_blks = 0;
> +		resv->rmt_blks = 0;
>  	} else {
>  		/*
>  		 * Out of line attribute, cannot double split, but
>  		 * make room for the attribute value itself.
>  		 */
> -		rmt_blks = xfs_attr3_rmt_blocks(mp, args->valuelen);
> +		resv->rmt_blks = xfs_attr3_rmt_blocks(mp, args->valuelen);
>  	}
>  
> -	bmbt_blks = XFS_NEXTENTADD_SPACE_RES(mp, total_dablks + rmt_blks,
> -			XFS_ATTR_FORK);
> +	resv->bmbt_blks = XFS_NEXTENTADD_SPACE_RES(mp,
> +				resv->total_dablks + resv->rmt_blks,
> +				XFS_ATTR_FORK);
>  
> -	return total_dablks + rmt_blks + bmbt_blks;
> +	resv->alloc_blks = resv->total_dablks + resv->rmt_blks +
> +		resv->bmbt_blks;

Do we really need a field to track the total of three other fields in
the same structure? I'd rather just let the caller add them up for
args.total if that's the only usage.

Brian

>  }
>  
>  STATIC int
> @@ -295,14 +295,17 @@ xfs_attr_remove_args(
>   */
>  int
>  xfs_attr_set(
> -	struct xfs_da_args	*args)
> +	struct xfs_da_args		*args)
>  {
> -	struct xfs_inode	*dp = args->dp;
> -	struct xfs_mount	*mp = dp->i_mount;
> -	struct xfs_trans_res	tres;
> -	bool			rsvd = (args->attr_namespace & XFS_ATTR_ROOT);
> -	int			error, local;
> -	unsigned int		total;
> +	struct xfs_inode		*dp = args->dp;
> +	struct xfs_mount		*mp = dp->i_mount;
> +	struct xfs_attr_set_resv	resv;
> +	struct xfs_trans_res		tres;
> +	bool				rsvd;
> +	int				error, local;
> +	unsigned int			total;
> +
> +	rsvd = (args->attr_namespace & XFS_ATTR_ROOT);
>  
>  	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
>  		return -EIO;
> @@ -326,7 +329,8 @@ xfs_attr_set(
>  		XFS_STATS_INC(mp, xs_attr_set);
>  
>  		args->op_flags |= XFS_DA_OP_ADDNAME;
> -		args->total = xfs_attr_calc_size(args, &local);
> +		xfs_attr_calc_size(args, &resv, &local);
> +		args->total = resv.alloc_blks;
>  
>  		/*
>  		 * If the inode doesn't have an attribute fork, add one.
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index 861c81f9bb918..dc08bdfbc9615 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -73,6 +73,19 @@ struct xfs_attr_list_context {
>  	int			index;		/* index into output buffer */
>  };
>  
> +struct xfs_attr_set_resv {
> +	/* Number of unlogged blocks needed to store the remote attr value. */
> +	unsigned int		rmt_blks;
> +
> +	/* Number of filesystem blocks to allocate for the da btree. */
> +	unsigned int		total_dablks;
> +
> +	/* Blocks we might need to create all the new attr fork mappings. */
> +	unsigned int		bmbt_blks;
> +
> +	/* Total number of blocks we might have to allocate. */
> +	unsigned int		alloc_blks;
> +};
>  
>  /*========================================================================
>   * Function prototypes for the kernel.
> -- 
> 2.19.1
> 

