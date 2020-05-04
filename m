Return-Path: <SRS0=lfYe=6S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74274C3A5A9
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 13:27:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D1A82073E
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 13:27:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DvBrjl/9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728028AbgEDN1p (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 May 2020 09:27:45 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:30981 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727104AbgEDN1o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 May 2020 09:27:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588598863;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kxRW28eh7Kxz70ojogBZCOh8B7YnGkAa6o5QxOI3pBk=;
        b=DvBrjl/9SVt7DbUYBPpsusJRUUvX/8SXTjHjNDUS5HBvuj6zcc1PXdN7J0sQqVR6bZoEeK
        Pz92ozoxcj2WfmpyIy8DVRloctosY3QLgErSuGKu+JNS/J4jc0ujfVBYZ/U737nRgCq8DR
        vLXYoQpWkfnnJBrhR6zh3XYW4pEnnM0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-84-cf-YrUPnO8W-KOxqD8hWdw-1; Mon, 04 May 2020 09:27:40 -0400
X-MC-Unique: cf-YrUPnO8W-KOxqD8hWdw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5E07418B6388;
        Mon,  4 May 2020 13:27:39 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0241610016DA;
        Mon,  4 May 2020 13:27:38 +0000 (UTC)
Date:   Mon, 4 May 2020 09:27:37 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v9 12/24] xfs: Add helper function xfs_attr_node_shrink
Message-ID: <20200504132737.GC54625@bfoster>
References: <20200430225016.4287-1-allison.henderson@oracle.com>
 <20200430225016.4287-13-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430225016.4287-13-allison.henderson@oracle.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 30, 2020 at 03:50:04PM -0700, Allison Collins wrote:
> This patch adds a new helper function xfs_attr_node_shrink used to
> shrink an attr name into an inode if it is small enough.  This helps to
> modularize the greater calling function xfs_attr_node_removename.
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_attr.c | 68 ++++++++++++++++++++++++++++++------------------
>  1 file changed, 42 insertions(+), 26 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 4fdfab9..d83443c 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -1108,6 +1108,45 @@ xfs_attr_node_addname(
>  }
>  
>  /*
> + * Shrink an attribute from leaf to shortform
> + */
> +STATIC int
> +xfs_attr_node_shrink(
> +	struct xfs_da_args	*args,
> +	struct xfs_da_state     *state)
> +{
> +	struct xfs_inode	*dp = args->dp;
> +	int			error, forkoff;
> +	struct xfs_buf		*bp;
> +
> +	/*
> +	 * Have to get rid of the copy of this dabuf in the state.
> +	 */
> +	ASSERT(state->path.active == 1);
> +	ASSERT(state->path.blk[0].bp);
> +	state->path.blk[0].bp = NULL;
> +
> +	error = xfs_attr3_leaf_read(args->trans, args->dp, 0, &bp);
> +	if (error)
> +		return error;
> +
> +	forkoff = xfs_attr_shortform_allfit(bp, dp);
> +	if (forkoff) {
> +		error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
> +		/* bp is gone due to xfs_da_shrink_inode */
> +		if (error)
> +			return error;
> +
> +		error = xfs_defer_finish(&args->trans);
> +		if (error)
> +			return error;
> +	} else
> +		xfs_trans_brelse(args->trans, bp);
> +
> +	return 0;
> +}
> +
> +/*
>   * Remove a name from a B-tree attribute list.
>   *
>   * This will involve walking down the Btree, and may involve joining
> @@ -1120,8 +1159,7 @@ xfs_attr_node_removename(
>  {
>  	struct xfs_da_state	*state;
>  	struct xfs_da_state_blk	*blk;
> -	struct xfs_buf		*bp;
> -	int			retval, error, forkoff;
> +	int			retval, error;
>  	struct xfs_inode	*dp = args->dp;
>  
>  	trace_xfs_attr_node_removename(args);
> @@ -1206,30 +1244,8 @@ xfs_attr_node_removename(
>  	/*
>  	 * If the result is small enough, push it all into the inode.
>  	 */
> -	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
> -		/*
> -		 * Have to get rid of the copy of this dabuf in the state.
> -		 */
> -		ASSERT(state->path.active == 1);
> -		ASSERT(state->path.blk[0].bp);
> -		state->path.blk[0].bp = NULL;
> -
> -		error = xfs_attr3_leaf_read(args->trans, args->dp, 0, &bp);
> -		if (error)
> -			goto out;
> -
> -		if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
> -			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
> -			/* bp is gone due to xfs_da_shrink_inode */
> -			if (error)
> -				goto out;
> -			error = xfs_defer_finish(&args->trans);
> -			if (error)
> -				goto out;
> -		} else
> -			xfs_trans_brelse(args->trans, bp);
> -	}
> -	error = 0;
> +	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
> +		error = xfs_attr_node_shrink(args, state);
>  
>  out:
>  	if (state)
> -- 
> 2.7.4
> 

