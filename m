Return-Path: <SRS0=jVwY=2D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57407C2D0D6
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Dec 2019 20:37:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D1E824782
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Dec 2019 20:37:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Mf/phGt3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727507AbfLMOPU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Dec 2019 09:15:20 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:27761 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727497AbfLMOPU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Dec 2019 09:15:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576246518;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=N3B/6EqK3CORnVNpuwhx+Yrq7NsSF19lPGBNPUHwCAU=;
        b=Mf/phGt3tbyAnoYHht95n9o0WyXo3OYXxwI8xSTEgSFdyS48cl9ZMJtj4RzKNxjdMQVZ1D
        iNpopNALtEUizYwnegliqINne65zTv1qghoQrYvud6pAOTO6G96Ms06cIE++9e3/PINpRS
        2CtVGYOvHXnQwy8g+hOD3ahANeMKbMc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-252-qtUHOY9PPRGoGH7ZKeB8qw-1; Fri, 13 Dec 2019 09:15:17 -0500
X-MC-Unique: qtUHOY9PPRGoGH7ZKeB8qw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1E59D100550E;
        Fri, 13 Dec 2019 14:15:16 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B9A0110013A1;
        Fri, 13 Dec 2019 14:15:15 +0000 (UTC)
Date:   Fri, 13 Dec 2019 09:15:15 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v5 07/14] xfs: Factor out xfs_attr_leaf_addname helper
Message-ID: <20191213141515.GD43376@bfoster>
References: <20191212041513.13855-1-allison.henderson@oracle.com>
 <20191212041513.13855-8-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191212041513.13855-8-allison.henderson@oracle.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 11, 2019 at 09:15:06PM -0700, Allison Collins wrote:
> Factor out new helper function xfs_attr_leaf_try_add.
> Because new delayed attribute routines cannot roll
> transactions, we carve off the parts of
> xfs_attr_leaf_addname that we can use.  This will help
> to reduce repetitive code later when we introduce
> delayed attributes.
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 83 ++++++++++++++++++++++++++++--------------------
>  1 file changed, 49 insertions(+), 34 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index ee973d2..36f6a43 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -305,10 +305,30 @@ xfs_attr_set_args(
>  		}
>  	}
>  
> -	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
> +	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
>  		error = xfs_attr_leaf_addname(args);
> -	else
> -		error = xfs_attr_node_addname(args);
> +		if (error == 0 || error != -ENOSPC)
> +			return 0;

No need to check for 0 since 0 != -ENOSPC. We also probably want to
return error instead of zero. With that fixed up:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> +
> +		/*
> +		 * Commit that transaction so that the node_addname()
> +		 * call can manage its own transactions.
> +		 */
> +		error = xfs_defer_finish(&args->trans);
> +		if (error)
> +			return error;
> +
> +		/*
> +		 * Commit the current trans (including the inode) and
> +		 * start a new one.
> +		 */
> +		error = xfs_trans_roll_inode(&args->trans, dp);
> +		if (error)
> +			return error;
> +
> +	}
> +
> +	error = xfs_attr_node_addname(args);
>  	return error;
>  }
>  
> @@ -606,21 +626,12 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
>   * External routines when attribute list is one block
>   *========================================================================*/
>  
> -/*
> - * Add a name to the leaf attribute list structure
> - *
> - * This leaf block cannot have a "remote" value, we only call this routine
> - * if bmap_one_block() says there is only one block (ie: no remote blks).
> - */
>  STATIC int
> -xfs_attr_leaf_addname(
> -	struct xfs_da_args	*args)
> +xfs_attr_leaf_try_add(
> +	struct xfs_da_args	*args,
> +	struct xfs_buf		*bp)
>  {
> -	struct xfs_buf		*bp;
> -	int			retval, error, forkoff;
> -	struct xfs_inode	*dp = args->dp;
> -
> -	trace_xfs_attr_leaf_addname(args);
> +	int			retval, error;
>  
>  	/*
>  	 * Look up the given attribute in the leaf block.  Figure out if
> @@ -666,31 +677,35 @@ xfs_attr_leaf_addname(
>  	retval = xfs_attr3_leaf_add(bp, args);
>  	if (retval == -ENOSPC) {
>  		/*
> -		 * Promote the attribute list to the Btree format, then
> -		 * Commit that transaction so that the node_addname() call
> -		 * can manage its own transactions.
> +		 * Promote the attribute list to the Btree format.
> +		 * Unless an error occurs, retain the -ENOSPC retval
>  		 */
>  		error = xfs_attr3_leaf_to_node(args);
>  		if (error)
>  			return error;
> -		error = xfs_defer_finish(&args->trans);
> -		if (error)
> -			return error;
> +	}
> +	return retval;
> +}
>  
> -		/*
> -		 * Commit the current trans (including the inode) and start
> -		 * a new one.
> -		 */
> -		error = xfs_trans_roll_inode(&args->trans, dp);
> -		if (error)
> -			return error;
>  
> -		/*
> -		 * Fob the whole rest of the problem off on the Btree code.
> -		 */
> -		error = xfs_attr_node_addname(args);
> +/*
> + * Add a name to the leaf attribute list structure
> + *
> + * This leaf block cannot have a "remote" value, we only call this routine
> + * if bmap_one_block() says there is only one block (ie: no remote blks).
> + */
> +STATIC int
> +xfs_attr_leaf_addname(struct xfs_da_args	*args)
> +{
> +	int			error, forkoff;
> +	struct xfs_buf		*bp = NULL;
> +	struct xfs_inode	*dp = args->dp;
> +
> +	trace_xfs_attr_leaf_addname(args);
> +
> +	error = xfs_attr_leaf_try_add(args, bp);
> +	if (error)
>  		return error;
> -	}
>  
>  	/*
>  	 * Commit the transaction that added the attr name so that
> -- 
> 2.7.4
> 

