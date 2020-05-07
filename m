Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5061BC38A24
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 11:54:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 227E82075E
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 11:54:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H/2F6JNe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726134AbgEGLyU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 May 2020 07:54:20 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:55597 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725879AbgEGLyU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 May 2020 07:54:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588852458;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=70rdTsaqoYEnuGMqL9YQ/5ddCwKpgdYxqvSUVZ+BQXI=;
        b=H/2F6JNecnkHqCMhAe7RbEzEvs1C3lShBTgUMleSmqbmznlhtV/MQ+qgoghtKrtfPEmOKc
        jNAExaUwd63eIAsUrSIdnw03s01KU/XVnM6WH9P5ShXsLlGnkzgmSq8snko5+7UqlLhys9
        UwIQlAyx5N0rDFziMOQzX/Sb8Rgsxk0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-358-a-4c6KlMMCSgITkwFKRaGw-1; Thu, 07 May 2020 07:54:16 -0400
X-MC-Unique: a-4c6KlMMCSgITkwFKRaGw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 409641005510;
        Thu,  7 May 2020 11:54:15 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DE8BB707AF;
        Thu,  7 May 2020 11:54:14 +0000 (UTC)
Date:   Thu, 7 May 2020 07:54:13 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v9 22/24] xfs: Add delay ready attr remove routines
Message-ID: <20200507115413.GD9003@bfoster>
References: <20200430225016.4287-1-allison.henderson@oracle.com>
 <20200430225016.4287-23-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430225016.4287-23-allison.henderson@oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 30, 2020 at 03:50:14PM -0700, Allison Collins wrote:
...
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c        | 159 ++++++++++++++++++++++++++++++----------
>  fs/xfs/libxfs/xfs_attr.h        |  73 ++++++++++++++++++
>  fs/xfs/libxfs/xfs_attr_leaf.c   |   2 +-
>  fs/xfs/libxfs/xfs_attr_remote.c |  31 ++++----
>  fs/xfs/libxfs/xfs_attr_remote.h |   2 +-
>  fs/xfs/xfs_attr_inactive.c      |   2 +-
>  6 files changed, 215 insertions(+), 54 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index c8cae68..7213589 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
...
> @@ -363,23 +384,57 @@ xfs_has_attr(
...
> +/*
> + * Remove the attribute specified in @args.
> + *
> + * This function may return -EAGAIN to signal that the transaction needs to be
> + * rolled.  Callers should continue calling this function until they receive a
> + * return value other than -EAGAIN.
> + */
> +int
> +xfs_attr_remove_iter(
> +	struct xfs_delattr_context *dac)
>  {
> +	struct xfs_da_args	*args = dac->da_args;
>  	struct xfs_inode	*dp = args->dp;
> -	int			error;
> +
> +	if (dac->dela_state == XFS_DAS_RM_SHRINK)
> +		goto node;

If we're in the above state, doesn't that mean we're in node format and
should fall through to the node function based on the logic below
anyways?

>  
>  	if (!xfs_inode_hasattr(dp)) {
> -		error = -ENOATTR;
> +		return -ENOATTR;
>  	} else if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
>  		ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
> -		error = xfs_attr_shortform_remove(args);
> +		return xfs_attr_shortform_remove(args);
>  	} else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
> -		error = xfs_attr_leaf_removename(args);
> -	} else {
> -		error = xfs_attr_node_removename(args);
> +		return xfs_attr_leaf_removename(args);
>  	}
> -
> -	return error;
> +node:
> +	return  xfs_attr_node_removename(dac);
>  }
>  
>  /*
...
> @@ -1232,21 +1299,35 @@ xfs_attr_node_removename_rmt (
>   * This will involve walking down the Btree, and may involve joining
>   * leaf nodes and even joining intermediate nodes up to and including
>   * the root node (a special case of an intermediate node).
> + *
> + * This routine is meant to function as either an inline or delayed operation,
> + * and may return -EAGAIN when the transaction needs to be rolled.  Calling
> + * functions will need to handle this, and recall the function until a
> + * successful error code is returned.
>   */
>  STATIC int
>  xfs_attr_node_removename(
> -	struct xfs_da_args	*args)
> +	struct xfs_delattr_context	*dac)
>  {
> -	struct xfs_da_state	*state;
> -	struct xfs_da_state_blk	*blk;
> -	int			retval, error;
> -	struct xfs_inode	*dp = args->dp;
> +	struct xfs_da_args		*args = dac->da_args;
> +	struct xfs_da_state		*state;
> +	struct xfs_da_state_blk		*blk;
> +	int				retval, error;
> +	struct xfs_inode		*dp = args->dp;
>  
>  	trace_xfs_attr_node_removename(args);
> +	state = dac->da_state;
> +	blk = dac->blk;
>  
> -	error = xfs_attr_node_removename_setup(args, &state);
> -	if (error)
> -		goto out;
> +	if (dac->dela_state == XFS_DAS_RM_SHRINK)
> +		goto das_rm_shrink;
> +
> +	if ((dac->flags & XFS_DAC_NODE_RMVNAME_INIT) == 0) {
> +		dac->flags |= XFS_DAC_NODE_RMVNAME_INIT;
> +		error = xfs_attr_node_removename_setup(dac, &state);
> +		if (error)
> +			goto out;
> +	}

Now that we've factored out this state with the flag, I wonder if we
could factor out this logic and pull it all the way up to
xfs_attr_remove_args(). That would remove the init flag, we'd presumably
just have to duplicate the format checks to make sure the fork is in
node format.

I'd consider that a followup patch, btw. I know it's a bit circuitous to
add the flag only to then remove it, but I think there's value in making
simple, incremental changes. ;)

>  
>  	/*
>  	 * If there is an out-of-line value, de-allocate the blocks.
> @@ -1254,8 +1335,13 @@ xfs_attr_node_removename(
>  	 * overflow the maximum size of a transaction and/or hit a deadlock.
>  	 */
>  	if (args->rmtblkno > 0) {
> -		error = xfs_attr_node_removename_rmt(args, state);
> -		if (error)
> +		/*
> +		 * May return -EAGAIN. Remove blocks until args->rmtblkno == 0
> +		 */
> +		error = xfs_attr_node_removename_rmt(dac, state);
> +		if (error == -EAGAIN)
> +			return error;
> +		else if (error)
>  			goto out;
>  	}
>  
> @@ -1274,17 +1360,14 @@ xfs_attr_node_removename(
>  		error = xfs_da3_join(state);
>  		if (error)
>  			goto out;
> -		error = xfs_defer_finish(&args->trans);
> -		if (error)
> -			goto out;
> -		/*
> -		 * Commit the Btree join operation and start a new trans.
> -		 */
> -		error = xfs_trans_roll_inode(&args->trans, dp);
> -		if (error)
> -			goto out;
> +
> +		dac->flags |= XFS_DAC_DEFER_FINISH;
> +		dac->dela_state = XFS_DAS_RM_SHRINK;
> +		return -EAGAIN;
>  	}
>  
> +das_rm_shrink:
> +

Alternatively to the state question in xfs_attr_remove_iter(), I wonder
if we could lift the bottom part of this function (that does the tree
collapse and potential node shrink) into the caller. AFAICT that would
isolate all of the xattr remove state tracking code to
xfs_attr_remove_iter(), which would be a pretty nice result IMO.

>  	/*
>  	 * If the result is small enough, push it all into the inode.
>  	 */
...
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> index f770159..f2d46c7 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
...
> @@ -691,10 +693,14 @@ xfs_attr_rmtval_remove(
>  	lblkno = args->rmtblkno;
>  	blkcnt = args->rmtblkcnt;
>  	do {
> -		retval = __xfs_attr_rmtval_remove(args);
> +		retval = __xfs_attr_rmtval_remove(&dac);
>  		if (retval && retval != EAGAIN)
>  			return retval;
>  
> +		error = xfs_attr_defer_finish(&dac);
> +		if (error)
> +			break;
> +

This seems to come out of nowhere..?

Brian

>  		/*
>  		 * Close out trans and start the next one in the chain.
>  		 */
> @@ -713,9 +719,10 @@ xfs_attr_rmtval_remove(
>   */
>  int
>  __xfs_attr_rmtval_remove(
> -	struct xfs_da_args	*args)
> +	struct xfs_delattr_context	*dac)
>  {
> -	int			error, done;
> +	struct xfs_da_args		*args = dac->da_args;
> +	int				error, done;
>  
>  	/*
>  	 * Unmap value blocks for this attr.
> @@ -725,12 +732,10 @@ __xfs_attr_rmtval_remove(
>  	if (error)
>  		return error;
>  
> -	error = xfs_defer_finish(&args->trans);
> -	if (error)
> -		return error;
> -
> -	if (!done)
> +	if (!done) {
> +		dac->flags &= ~XFS_DAC_DEFER_FINISH;
>  		return -EAGAIN;
> +	}
>  
>  	return error;
>  }
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
> index ee3337b..351da00 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.h
> +++ b/fs/xfs/libxfs/xfs_attr_remote.h
> @@ -14,5 +14,5 @@ int xfs_attr_rmtval_remove(struct xfs_da_args *args);
>  int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
>  		xfs_buf_flags_t incore_flags);
>  int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
> -int __xfs_attr_rmtval_remove(struct xfs_da_args *args);
> +int __xfs_attr_rmtval_remove(struct xfs_delattr_context *dac);
>  #endif /* __XFS_ATTR_REMOTE_H__ */
> diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
> index c42f90e..b2150fa 100644
> --- a/fs/xfs/xfs_attr_inactive.c
> +++ b/fs/xfs/xfs_attr_inactive.c
> @@ -15,10 +15,10 @@
>  #include "xfs_da_format.h"
>  #include "xfs_da_btree.h"
>  #include "xfs_inode.h"
> +#include "xfs_attr.h"
>  #include "xfs_attr_remote.h"
>  #include "xfs_trans.h"
>  #include "xfs_bmap.h"
> -#include "xfs_attr.h"
>  #include "xfs_attr_leaf.h"
>  #include "xfs_quota.h"
>  #include "xfs_dir2.h"
> -- 
> 2.7.4
> 

