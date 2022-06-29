Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C5DEC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jun 2022 20:48:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbiF2Usm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 16:48:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbiF2Usl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 16:48:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E80D140AF
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 13:48:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4199AB8249B
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 20:48:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E349AC34114;
        Wed, 29 Jun 2022 20:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656535718;
        bh=5wMV8Z13XiXm4jwCwPoGpTfriqYTtRju02EJNmDhlQ4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gZfa72c671vD+HvkDXK2pGeQZk5OWx1vZJD0jCC11OGvaEBEk1oRkBGyQt0V+541A
         OD2MKvis07B5fVi9ophTCAlu/MgSaUQPV8FvtnSGP03igqslv5lvRQrTnMXU9c2X+D
         ZmQS6ZFVFruLg3mff3Z5YCLNRgMopjhdSjj9SuqjfoygvJaoLXTTLRbOslIvMEVQLa
         FPTjMI4CSYOQ9pJ/eCX6E1rWaDy5hEUxpnJo1llhPmjfnK09jqj8teo2gM6KQLuQko
         XRwQvN0W6vL6hVyWZYjBCaqDDSuDwrTCW4UoUkXW2O15dRd1bizunM28MVCd34rF4D
         R8ORvnLh8hoqQ==
Date:   Wed, 29 Jun 2022 13:48:37 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/9] xfs: factor the xfs_iunlink functions
Message-ID: <Yry6pfHy3lv7ptyh@magnolia>
References: <20220627004336.217366-1-david@fromorbit.com>
 <20220627004336.217366-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220627004336.217366-2-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 27, 2022 at 10:43:28AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Prep work that separates the locking that protects the unlinked list
> from the actual operations being performed. This also helps document
> the fact they are performing list insert  and remove operations. No
> functional code change.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

With the whitespace damage fixed,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_inode.c | 113 +++++++++++++++++++++++++++------------------
>  1 file changed, 68 insertions(+), 45 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 52d6f2c7d58b..2a371c3431c9 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2129,39 +2129,20 @@ xfs_iunlink_update_inode(
>  	return error;
>  }
>  
> -/*
> - * This is called when the inode's link count has gone to 0 or we are creating
> - * a tmpfile via O_TMPFILE.  The inode @ip must have nlink == 0.
> - *
> - * We place the on-disk inode on a list in the AGI.  It will be pulled from this
> - * list when the inode is freed.
> - */
> -STATIC int
> -xfs_iunlink(
> +static int
> +xfs_iunlink_insert_inode(
>  	struct xfs_trans	*tp,
> +	struct xfs_perag	*pag,
> +	struct xfs_buf		*agibp,
>  	struct xfs_inode	*ip)
> -{
> + {
>  	struct xfs_mount	*mp = tp->t_mountp;
> -	struct xfs_perag	*pag;
> -	struct xfs_agi		*agi;
> -	struct xfs_buf		*agibp;
> +	struct xfs_agi		*agi = agibp->b_addr;
>  	xfs_agino_t		next_agino;
>  	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
>  	short			bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
>  	int			error;
>  
> -	ASSERT(VFS_I(ip)->i_nlink == 0);
> -	ASSERT(VFS_I(ip)->i_mode != 0);
> -	trace_xfs_iunlink(ip);
> -
> -	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
> -
> -	/* Get the agi buffer first.  It ensures lock ordering on the list. */
> -	error = xfs_read_agi(mp, tp, pag->pag_agno, &agibp);
> -	if (error)
> -		goto out;
> -	agi = agibp->b_addr;
> -
>  	/*
>  	 * Get the index into the agi hash table for the list this inode will
>  	 * go on.  Make sure the pointer isn't garbage and that this inode
> @@ -2171,8 +2152,7 @@ xfs_iunlink(
>  	if (next_agino == agino ||
>  	    !xfs_verify_agino_or_null(mp, pag->pag_agno, next_agino)) {
>  		xfs_buf_mark_corrupt(agibp);
> -		error = -EFSCORRUPTED;
> -		goto out;
> +		return -EFSCORRUPTED;
>  	}
>  
>  	if (next_agino != NULLAGINO) {
> @@ -2185,7 +2165,7 @@ xfs_iunlink(
>  		error = xfs_iunlink_update_inode(tp, ip, pag, next_agino,
>  				&old_agino);
>  		if (error)
> -			goto out;
> +			return error;
>  		ASSERT(old_agino == NULLAGINO);
>  
>  		/*
> @@ -2194,11 +2174,42 @@ xfs_iunlink(
>  		 */
>  		error = xfs_iunlink_add_backref(pag, agino, next_agino);
>  		if (error)
> -			goto out;
> +			return error;
>  	}
>  
>  	/* Point the head of the list to point to this inode. */
> -	error = xfs_iunlink_update_bucket(tp, pag, agibp, bucket_index, agino);
> +	return xfs_iunlink_update_bucket(tp, pag, agibp, bucket_index, agino);
> +}
> +
> +/*
> + * This is called when the inode's link count has gone to 0 or we are creating
> + * a tmpfile via O_TMPFILE.  The inode @ip must have nlink == 0.
> + *
> + * We place the on-disk inode on a list in the AGI.  It will be pulled from this
> + * list when the inode is freed.
> + */
> +STATIC int
> +xfs_iunlink(
> +	struct xfs_trans	*tp,
> +	struct xfs_inode	*ip)
> +{
> +	struct xfs_mount	*mp = tp->t_mountp;
> +	struct xfs_perag	*pag;
> +	struct xfs_buf		*agibp;
> +	int			error;
> +
> +	ASSERT(VFS_I(ip)->i_nlink == 0);
> +	ASSERT(VFS_I(ip)->i_mode != 0);
> +	trace_xfs_iunlink(ip);
> +
> +	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
> +
> +	/* Get the agi buffer first.  It ensures lock ordering on the list. */
> +	error = xfs_read_agi(mp, tp, pag->pag_agno, &agibp);
> +	if (error)
> +		goto out;
> +
> +	error = xfs_iunlink_insert_inode(tp, pag, agibp, ip);
>  out:
>  	xfs_perag_put(pag);
>  	return error;
> @@ -2319,18 +2330,15 @@ xfs_iunlink_map_prev(
>  	return 0;
>  }
>  
> -/*
> - * Pull the on-disk inode from the AGI unlinked list.
> - */
> -STATIC int
> -xfs_iunlink_remove(
> +static int
> +xfs_iunlink_remove_inode(
>  	struct xfs_trans	*tp,
>  	struct xfs_perag	*pag,
> +	struct xfs_buf		*agibp,
>  	struct xfs_inode	*ip)
>  {
>  	struct xfs_mount	*mp = tp->t_mountp;
> -	struct xfs_agi		*agi;
> -	struct xfs_buf		*agibp;
> +	struct xfs_agi		*agi = agibp->b_addr;
>  	struct xfs_buf		*last_ibp;
>  	struct xfs_dinode	*last_dip = NULL;
>  	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
> @@ -2339,14 +2347,6 @@ xfs_iunlink_remove(
>  	short			bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
>  	int			error;
>  
> -	trace_xfs_iunlink_remove(ip);
> -
> -	/* Get the agi buffer first.  It ensures lock ordering on the list. */
> -	error = xfs_read_agi(mp, tp, pag->pag_agno, &agibp);
> -	if (error)
> -		return error;
> -	agi = agibp->b_addr;
> -
>  	/*
>  	 * Get the index into the agi hash table for the list this inode will
>  	 * go on.  Make sure the head pointer isn't garbage.
> @@ -2411,6 +2411,29 @@ xfs_iunlink_remove(
>  			next_agino);
>  }
>  
> +/*
> + * Pull the on-disk inode from the AGI unlinked list.
> + */
> +STATIC int
> +xfs_iunlink_remove(
> +	struct xfs_trans	*tp,
> +	struct xfs_perag	*pag,
> +	struct xfs_inode	*ip)
> +{
> +	struct xfs_mount	*mp = tp->t_mountp;
> +	struct xfs_buf		*agibp;
> +	int			error;
> +
> +	trace_xfs_iunlink_remove(ip);
> +
> +	/* Get the agi buffer first.  It ensures lock ordering on the list. */
> +	error = xfs_read_agi(mp, tp, pag->pag_agno, &agibp);
> +	if (error)
> +		return error;
> +
> +	return xfs_iunlink_remove_inode(tp, pag, agibp, ip);
> +}
> +
>  /*
>   * Look up the inode number specified and if it is not already marked XFS_ISTALE
>   * mark it stale. We should only find clean inodes in this lookup that aren't
> -- 
> 2.36.1
> 
