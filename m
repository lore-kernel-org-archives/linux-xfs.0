Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6365C433E9
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 16:05:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D6A464F0B
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 16:05:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234591AbhBXQCo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Feb 2021 11:02:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43260 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233964AbhBXPiY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Feb 2021 10:38:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614181015;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Qr9IwLdW0yI8SyJKycfWmD9F+wy2DzPKsYLQWIaFAY4=;
        b=FG1qdJKpjmI7bqw2lCiJZyxpqu3nn745oMnhSUuf3TFkQ/qOhFEUplcTS0Dpfjy/x3yAID
        uYrwdY7SsBjc36auhWOrisIpb+jP9bER6rifNIsFQbQLK7fsm6KkRphcImCYEuWa7XMzfm
        GToBDjORdpVCXuu9LwtF2Gf0nKeRAUw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-365-BA2074O2OeCnuKIC9sC3Dw-1; Wed, 24 Feb 2021 10:36:20 -0500
X-MC-Unique: BA2074O2OeCnuKIC9sC3Dw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0D61C1269E4E;
        Wed, 24 Feb 2021 15:04:14 +0000 (UTC)
Received: from bfoster (ovpn-119-92.rdu2.redhat.com [10.10.119.92])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A6A9068D22;
        Wed, 24 Feb 2021 15:04:13 +0000 (UTC)
Date:   Wed, 24 Feb 2021 10:04:11 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v15 04/22] xfs: Hoist xfs_attr_set_shortform
Message-ID: <20210224150411.GE981777@bfoster>
References: <20210218165348.4754-1-allison.henderson@oracle.com>
 <20210218165348.4754-5-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210218165348.4754-5-allison.henderson@oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 18, 2021 at 09:53:30AM -0700, Allison Henderson wrote:
> This patch hoists xfs_attr_set_shortform into the calling function. This
> will help keep all state management code in the same scope.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---

LGTM:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_attr.c | 81 ++++++++++++++++--------------------------------
>  1 file changed, 27 insertions(+), 54 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 3cf76e2..a064c5b 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -217,53 +217,6 @@ xfs_attr_is_shortform(
>  }
>  
>  /*
> - * Attempts to set an attr in shortform, or converts short form to leaf form if
> - * there is not enough room.  If the attr is set, the transaction is committed
> - * and set to NULL.
> - */
> -STATIC int
> -xfs_attr_set_shortform(
> -	struct xfs_da_args	*args,
> -	struct xfs_buf		**leaf_bp)
> -{
> -	struct xfs_inode	*dp = args->dp;
> -	int			error, error2 = 0;
> -
> -	/*
> -	 * Try to add the attr to the attribute list in the inode.
> -	 */
> -	error = xfs_attr_try_sf_addname(dp, args);
> -	if (error != -ENOSPC) {
> -		error2 = xfs_trans_commit(args->trans);
> -		args->trans = NULL;
> -		return error ? error : error2;
> -	}
> -	/*
> -	 * It won't fit in the shortform, transform to a leaf block.  GROT:
> -	 * another possible req'mt for a double-split btree op.
> -	 */
> -	error = xfs_attr_shortform_to_leaf(args, leaf_bp);
> -	if (error)
> -		return error;
> -
> -	/*
> -	 * Prevent the leaf buffer from being unlocked so that a concurrent AIL
> -	 * push cannot grab the half-baked leaf buffer and run into problems
> -	 * with the write verifier. Once we're done rolling the transaction we
> -	 * can release the hold and add the attr to the leaf.
> -	 */
> -	xfs_trans_bhold(args->trans, *leaf_bp);
> -	error = xfs_defer_finish(&args->trans);
> -	xfs_trans_bhold_release(args->trans, *leaf_bp);
> -	if (error) {
> -		xfs_trans_brelse(args->trans, *leaf_bp);
> -		return error;
> -	}
> -
> -	return 0;
> -}
> -
> -/*
>   * Set the attribute specified in @args.
>   */
>  int
> @@ -272,7 +225,7 @@ xfs_attr_set_args(
>  {
>  	struct xfs_inode	*dp = args->dp;
>  	struct xfs_buf          *leaf_bp = NULL;
> -	int			error = 0;
> +	int			error2, error = 0;
>  
>  	/*
>  	 * If the attribute list is already in leaf format, jump straight to
> @@ -281,16 +234,36 @@ xfs_attr_set_args(
>  	 * again.
>  	 */
>  	if (xfs_attr_is_shortform(dp)) {
> +		/*
> +		 * Try to add the attr to the attribute list in the inode.
> +		 */
> +		error = xfs_attr_try_sf_addname(dp, args);
> +		if (error != -ENOSPC) {
> +			error2 = xfs_trans_commit(args->trans);
> +			args->trans = NULL;
> +			return error ? error : error2;
> +		}
> +
> +		/*
> +		 * It won't fit in the shortform, transform to a leaf block.
> +		 * GROT: another possible req'mt for a double-split btree op.
> +		 */
> +		error = xfs_attr_shortform_to_leaf(args, &leaf_bp);
> +		if (error)
> +			return error;
>  
>  		/*
> -		 * If the attr was successfully set in shortform, the
> -		 * transaction is committed and set to NULL.  Otherwise, is it
> -		 * converted from shortform to leaf, and the transaction is
> -		 * retained.
> +		 * Prevent the leaf buffer from being unlocked so that a
> +		 * concurrent AIL push cannot grab the half-baked leaf buffer
> +		 * and run into problems with the write verifier.
>  		 */
> -		error = xfs_attr_set_shortform(args, &leaf_bp);
> -		if (error || !args->trans)
> +		xfs_trans_bhold(args->trans, leaf_bp);
> +		error = xfs_defer_finish(&args->trans);
> +		xfs_trans_bhold_release(args->trans, leaf_bp);
> +		if (error) {
> +			xfs_trans_brelse(args->trans, leaf_bp);
>  			return error;
> +		}
>  	}
>  
>  	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
> -- 
> 2.7.4
> 

