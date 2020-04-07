Return-Path: <SRS0=E2x8=5X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6A4CC2BA2B
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Apr 2020 15:23:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9DEA52072F
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Apr 2020 15:23:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bEMgdf3m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728917AbgDGPXM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Apr 2020 11:23:12 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:35700 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728306AbgDGPXM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Apr 2020 11:23:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586272990;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bwulcEeL9vUJgAwp8j/JrPmmY+J3I0wmNl4/cLf7h6c=;
        b=bEMgdf3m1nsfAJuqWKVB12beiHuOkqDC5uyEdWXhAK4cPZma1MTwDa4UFbKlzf+4DE0R+i
        34OyCO/u3Jzr0FyK6C6zLY2ajLxu7KGNu9IEUEeF6cAuwnpN91MInnFYnzrb3JkEKNAV+j
        qsj+O3/8m5MeSnqs7ZOVBDOIUahIvYI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-450--NYIUB9APLm8GLXOZbJVEA-1; Tue, 07 Apr 2020 11:23:04 -0400
X-MC-Unique: -NYIUB9APLm8GLXOZbJVEA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 50DC31005514;
        Tue,  7 Apr 2020 15:23:03 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E7150271BA;
        Tue,  7 Apr 2020 15:23:02 +0000 (UTC)
Date:   Tue, 7 Apr 2020 11:23:01 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v8 13/20] xfs: Add helpers xfs_attr_is_shortform and
 xfs_attr_set_shortform
Message-ID: <20200407152301.GE28936@bfoster>
References: <20200403221229.4995-1-allison.henderson@oracle.com>
 <20200403221229.4995-14-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200403221229.4995-14-allison.henderson@oracle.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 03, 2020 at 03:12:22PM -0700, Allison Collins wrote:
> In this patch, we hoist code from xfs_attr_set_args into two new helpers
> xfs_attr_is_shortform and xfs_attr_set_shortform.  These two will help
> to simplify xfs_attr_set_args when we get into delayed attrs later.
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 107 +++++++++++++++++++++++++++++++----------------
>  1 file changed, 72 insertions(+), 35 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 4225a94..ba26ffe 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -204,6 +204,66 @@ xfs_attr_try_sf_addname(
>  }
>  
>  /*
> + * Check to see if the attr should be upgraded from non-existent or shortform to
> + * single-leaf-block attribute list.
> + */
> +static inline bool
> +xfs_attr_is_shortform(
> +	struct xfs_inode    *ip)
> +{
> +	return ip->i_d.di_aformat == XFS_DINODE_FMT_LOCAL ||
> +	      (ip->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
> +	      ip->i_d.di_anextents == 0);

Logic should be indented similar to the original:

	return ip->i_d.di_aformat == XFS_DINODE_FMT_LOCAL ||
	       (ip->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
		ip->i_d.di_anextents == 0);

Otherwise looks good:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> +}
> +
> +/*
> + * Attempts to set an attr in shortform, or converts the tree to leaf form if
> + * there is not enough room.  If the attr is set, the transaction is committed
> + * and set to NULL.
> + */
> +STATIC int
> +xfs_attr_set_shortform(
> +	struct xfs_da_args	*args,
> +	struct xfs_buf		**leaf_bp)
> +{
> +	struct xfs_inode	*dp = args->dp;
> +	int			error, error2 = 0;
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
> +	/*
> +	 * It won't fit in the shortform, transform to a leaf block.  GROT:
> +	 * another possible req'mt for a double-split btree op.
> +	 */
> +	error = xfs_attr_shortform_to_leaf(args, leaf_bp);
> +	if (error)
> +		return error;
> +
> +	/*
> +	 * Prevent the leaf buffer from being unlocked so that a concurrent AIL
> +	 * push cannot grab the half-baked leaf buffer and run into problems
> +	 * with the write verifier. Once we're done rolling the transaction we
> +	 * can release the hold and add the attr to the leaf.
> +	 */
> +	xfs_trans_bhold(args->trans, *leaf_bp);
> +	error = xfs_defer_finish(&args->trans);
> +	xfs_trans_bhold_release(args->trans, *leaf_bp);
> +	if (error) {
> +		xfs_trans_brelse(args->trans, *leaf_bp);
> +		return error;
> +	}
> +
> +	return 0;
> +}
> +
> +/*
>   * Set the attribute specified in @args.
>   */
>  int
> @@ -212,48 +272,25 @@ xfs_attr_set_args(
>  {
>  	struct xfs_inode	*dp = args->dp;
>  	struct xfs_buf          *leaf_bp = NULL;
> -	int			error, error2 = 0;
> +	int			error = 0;
>  
>  	/*
> -	 * If the attribute list is non-existent or a shortform list,
> -	 * upgrade it to a single-leaf-block attribute list.
> +	 * If the attribute list is already in leaf format, jump straight to
> +	 * leaf handling.  Otherwise, try to add the attribute to the shortform
> +	 * list; if there's no room then convert the list to leaf format and try
> +	 * again.
>  	 */
> -	if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL ||
> -	    (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
> -	     dp->i_d.di_anextents == 0)) {
> -
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
> -			return error;
> +	if (xfs_attr_is_shortform(dp)) {
>  
>  		/*
> -		 * Prevent the leaf buffer from being unlocked so that a
> -		 * concurrent AIL push cannot grab the half-baked leaf
> -		 * buffer and run into problems with the write verifier.
> -		 * Once we're done rolling the transaction we can release
> -		 * the hold and add the attr to the leaf.
> +		 * If the attr was successfully set in shortform, the
> +		 * transaction is committed and set to NULL.  Otherwise, is it
> +		 * converted from shortform to leaf, and the transaction is
> +		 * retained.
>  		 */
> -		xfs_trans_bhold(args->trans, leaf_bp);
> -		error = xfs_defer_finish(&args->trans);
> -		xfs_trans_bhold_release(args->trans, leaf_bp);
> -		if (error) {
> -			xfs_trans_brelse(args->trans, leaf_bp);
> +		error = xfs_attr_set_shortform(args, &leaf_bp);
> +		if (error || !args->trans)
>  			return error;
> -		}
>  	}
>  
>  	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
> -- 
> 2.7.4
> 

