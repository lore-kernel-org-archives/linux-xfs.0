Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4562DC433E6
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 16:02:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0585864F00
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 16:02:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233845AbhBXQBk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Feb 2021 11:01:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30421 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233365AbhBXPh2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Feb 2021 10:37:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614180960;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hsxiaFojL0jsVsikxfEZvSAD9aVQLbjrmQBT0h+qGdU=;
        b=bck2R4iToT3KBE2HBUZeNqPM2A67vdAJ/T5HZpNhos7sLz3q6+Sj01/A42dHZszcIbKyRr
        3qm+Cv+4iGzuRob1zyD9zQYCCHA9LJ42OpGMopWWO+L1VNRSfrTnKpY5dWJ/8CHkVa7smL
        BN/gk/4nOOSpDK/wbcfIikqAhmhNhN0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-557-Ue5sGqfwNS64wbK42d5zkA-1; Wed, 24 Feb 2021 10:35:58 -0500
X-MC-Unique: Ue5sGqfwNS64wbK42d5zkA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CB45DBC5E9F;
        Wed, 24 Feb 2021 15:04:21 +0000 (UTC)
Received: from bfoster (ovpn-119-92.rdu2.redhat.com [10.10.119.92])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 703625D9D3;
        Wed, 24 Feb 2021 15:04:21 +0000 (UTC)
Date:   Wed, 24 Feb 2021 10:04:19 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v15 05/22] xfs: Add helper xfs_attr_set_fmt
Message-ID: <20210224150419.GF981777@bfoster>
References: <20210218165348.4754-1-allison.henderson@oracle.com>
 <20210218165348.4754-6-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210218165348.4754-6-allison.henderson@oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 18, 2021 at 09:53:31AM -0700, Allison Henderson wrote:
> This patch adds a helper function xfs_attr_set_fmt.  This will help
> isolate the code that will require state management from the portions
> that do not.  xfs_attr_set_fmt returns 0 when the attr has been set and
> no further action is needed.  It returns -EAGAIN when shortform has been
> transformed to leaf, and the calling function should proceed the set the
> attr in leaf form.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_attr.c | 77 +++++++++++++++++++++++++++---------------------
>  1 file changed, 44 insertions(+), 33 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index a064c5b..205ad26 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -216,6 +216,46 @@ xfs_attr_is_shortform(
>  		ip->i_afp->if_nextents == 0);
>  }
>  
> +STATIC int
> +xfs_attr_set_fmt(
> +	struct xfs_da_args	*args)
> +{
> +	struct xfs_buf          *leaf_bp = NULL;
> +	struct xfs_inode	*dp = args->dp;
> +	int			error2, error = 0;
> +
> +	/*
> +	 * Try to add the attr to the attribute list in the inode.
> +	 */
> +	error = xfs_attr_try_sf_addname(dp, args);
> +	if (error != -ENOSPC) {
> +		error2 = xfs_trans_commit(args->trans);
> +		args->trans = NULL;
> +		return error ? error : error2;
> +	}
> +
> +	/*
> +	 * It won't fit in the shortform, transform to a leaf block.
> +	 * GROT: another possible req'mt for a double-split btree op.
> +	 */
> +	error = xfs_attr_shortform_to_leaf(args, &leaf_bp);
> +	if (error)
> +		return error;
> +
> +	/*
> +	 * Prevent the leaf buffer from being unlocked so that a
> +	 * concurrent AIL push cannot grab the half-baked leaf buffer
> +	 * and run into problems with the write verifier.
> +	 */
> +	xfs_trans_bhold(args->trans, leaf_bp);
> +	error = xfs_defer_finish(&args->trans);
> +	xfs_trans_bhold_release(args->trans, leaf_bp);
> +	if (error)
> +		xfs_trans_brelse(args->trans, leaf_bp);
> +
> +	return -EAGAIN;
> +}
> +
>  /*
>   * Set the attribute specified in @args.
>   */
> @@ -224,8 +264,7 @@ xfs_attr_set_args(
>  	struct xfs_da_args	*args)
>  {
>  	struct xfs_inode	*dp = args->dp;
> -	struct xfs_buf          *leaf_bp = NULL;
> -	int			error2, error = 0;
> +	int			error;
>  
>  	/*
>  	 * If the attribute list is already in leaf format, jump straight to
> @@ -234,36 +273,9 @@ xfs_attr_set_args(
>  	 * again.
>  	 */
>  	if (xfs_attr_is_shortform(dp)) {
> -		/*
> -		 * Try to add the attr to the attribute list in the inode.
> -		 */
> -		error = xfs_attr_try_sf_addname(dp, args);
> -		if (error != -ENOSPC) {
> -			error2 = xfs_trans_commit(args->trans);
> -			args->trans = NULL;
> -			return error ? error : error2;
> -		}
> -
> -		/*
> -		 * It won't fit in the shortform, transform to a leaf block.
> -		 * GROT: another possible req'mt for a double-split btree op.
> -		 */
> -		error = xfs_attr_shortform_to_leaf(args, &leaf_bp);
> -		if (error)
> +		error = xfs_attr_set_fmt(args);
> +		if (error != -EAGAIN)
>  			return error;
> -
> -		/*
> -		 * Prevent the leaf buffer from being unlocked so that a
> -		 * concurrent AIL push cannot grab the half-baked leaf buffer
> -		 * and run into problems with the write verifier.
> -		 */
> -		xfs_trans_bhold(args->trans, leaf_bp);
> -		error = xfs_defer_finish(&args->trans);
> -		xfs_trans_bhold_release(args->trans, leaf_bp);
> -		if (error) {
> -			xfs_trans_brelse(args->trans, leaf_bp);
> -			return error;
> -		}
>  	}
>  
>  	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
> @@ -297,8 +309,7 @@ xfs_attr_set_args(
>  			return error;
>  	}
>  
> -	error = xfs_attr_node_addname(args);
> -	return error;
> +	return xfs_attr_node_addname(args);
>  }
>  
>  /*
> -- 
> 2.7.4
> 

