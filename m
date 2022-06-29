Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 549DAC43334
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jun 2022 21:07:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbiF2VHJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 17:07:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbiF2VHI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 17:07:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B7D33C481
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 14:07:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F8F260F10
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 21:07:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE6F7C34114;
        Wed, 29 Jun 2022 21:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656536825;
        bh=ZU1Q7qo2Iez2xqav1UH1m+LXtMkui5svdL1WqxCxe14=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eWTlcjM+wUgg8iDXMSZg4ELI8clFWVccvSjaLM6MLHUhczsOG3v0leCO9ealHL5hS
         Tg9Js3QdhjT/j+fbf5/CvKpy59YYOZUpppnRyqrB7SQ39txz3Vlr9TNXM0QVnIZOtD
         KNEkLiEDeJeom9z+FDBpgApISW9yT6BflNrer6//xY/0jN6lS4oqSvWBddBanjNFT3
         8J77HvhEY7Qxav257XyB9UwQGycYgO90Khk529X3Wk7/G8Je2AGBdzYXbLz8lsjo74
         ehvBAOqJ9WLOFP3l17nozxuconrr3BFHNgJHbfqCP1IL9WaBE3qsYlR9wRp2D7FAU4
         G0t26m1xFIUhg==
Date:   Wed, 29 Jun 2022 14:07:05 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/9] xfs: clean up xfs_iunlink_update_inode()
Message-ID: <Yry++WEMMFvMtu/a@magnolia>
References: <20220627004336.217366-1-david@fromorbit.com>
 <20220627004336.217366-7-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220627004336.217366-7-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 27, 2022 at 10:43:33AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We no longer need to have this function return the previous next
> agino value from the on-disk inode as we have it in the in-core
> inode now.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_inode.c | 18 +++++-------------
>  1 file changed, 5 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index f390a91243bf..8d4edb8129b5 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1953,13 +1953,12 @@ xfs_iunlink_update_dinode(
>  }
>  
>  /* Set an in-core inode's unlinked pointer and return the old value. */
> -STATIC int
> +static int
>  xfs_iunlink_update_inode(
>  	struct xfs_trans	*tp,
>  	struct xfs_inode	*ip,
>  	struct xfs_perag	*pag,
> -	xfs_agino_t		next_agino,
> -	xfs_agino_t		*old_next_agino)
> +	xfs_agino_t		next_agino)
>  {
>  	struct xfs_mount	*mp = tp->t_mountp;
>  	struct xfs_dinode	*dip;
> @@ -1989,8 +1988,6 @@ xfs_iunlink_update_inode(
>  	 * current pointer is the same as the new value, unless we're
>  	 * terminating the list.
>  	 */
> -	if (old_next_agino)
> -		*old_next_agino = old_value;
>  	if (old_value == next_agino) {
>  		if (next_agino != NULLAGINO) {
>  			xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__,
> @@ -2044,17 +2041,13 @@ xfs_iunlink_insert_inode(
>  		return error;
>  
>  	if (next_agino != NULLAGINO) {
> -		xfs_agino_t		old_agino;
> -
>  		/*
>  		 * There is already another inode in the bucket, so point this
>  		 * inode to the current head of the list.
>  		 */
> -		error = xfs_iunlink_update_inode(tp, ip, pag, next_agino,
> -				&old_agino);
> +		error = xfs_iunlink_update_inode(tp, ip, pag, next_agino);
>  		if (error)
>  			return error;
> -		ASSERT(old_agino == NULLAGINO);
>  		ip->i_next_unlinked = next_agino;
>  	}
>  
> @@ -2106,7 +2099,6 @@ xfs_iunlink_remove_inode(
>  	struct xfs_mount	*mp = tp->t_mountp;
>  	struct xfs_agi		*agi = agibp->b_addr;
>  	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
> -	xfs_agino_t		next_agino;
>  	xfs_agino_t		head_agino;
>  	short			bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
>  	int			error;
> @@ -2127,7 +2119,7 @@ xfs_iunlink_remove_inode(
>  	 * the old pointer value so that we can update whatever was previous
>  	 * to us in the list to point to whatever was next in the list.
>  	 */
> -	error = xfs_iunlink_update_inode(tp, ip, pag, NULLAGINO, &next_agino);
> +	error = xfs_iunlink_update_inode(tp, ip, pag, NULLAGINO);
>  	if (error)
>  		return error;
>  
> @@ -2148,7 +2140,7 @@ xfs_iunlink_remove_inode(
>  			return -EFSCORRUPTED;
>  
>  		error = xfs_iunlink_update_inode(tp, prev_ip, pag,
> -				ip->i_next_unlinked, NULL);
> +				ip->i_next_unlinked);
>  		prev_ip->i_next_unlinked = ip->i_next_unlinked;
>  	} else {
>  		/* Point the head of the list to the next unlinked inode. */
> -- 
> 2.36.1
> 
