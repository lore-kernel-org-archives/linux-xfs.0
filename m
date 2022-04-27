Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6976C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Apr 2022 03:07:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357357AbiD0DKV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Apr 2022 23:10:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357364AbiD0DJT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Apr 2022 23:09:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 025D43191D
        for <linux-xfs@vger.kernel.org>; Tue, 26 Apr 2022 20:06:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 681D8B81FE0
        for <linux-xfs@vger.kernel.org>; Wed, 27 Apr 2022 03:06:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24F68C385A4;
        Wed, 27 Apr 2022 03:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651028766;
        bh=xXb/H+SoJXn78D29Dz4bxAjQ18msRjqJX2Fsiqzg6SI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=K3Lls/LxdkLZua8FXHeSbQv9vTpnrtwnvrfkVD9f1izfoH47U/q/uOci6j+7GToxS
         XzCq/jAG0DwG/ayCuh8y1UDdUbLLPlz3WKB3YiK4GnYM9vsQQALHFQE2x2sIZRfs3n
         +5lkocG/OM7lV1TT7sYDhXiya5xnR4rLyCj6uIyLt+/Wtfx+r6Xzlr5AbSQXODqCxU
         toH9B+YBrhY2rmlfBlE0I7pzdwwwtSG/DQSgj1R/gLdKmwjhVmy8LEUW8WdxVpwSMc
         DrVfzQpnQAfqf274TZQ5XAIgaUumvcg9Iq4eX/Q2Z3TEPNm6WTXXeIVi1mRGoArkOW
         6ikt1b0jgmgIA==
Date:   Tue, 26 Apr 2022 20:06:05 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/8] xfs: tag transactions that contain intent done items
Message-ID: <20220427030605.GC17025@magnolia>
References: <20220427022259.695399-1-david@fromorbit.com>
 <20220427022259.695399-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427022259.695399-5-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 27, 2022 at 12:22:55PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Intent whiteouts will require extra work to be done during
> transaction commit if the transaction contains an intent done item.
> 
> To determine if a transaction contains an intent done item, we want
> to avoid having to walk all the items in the transaction to check if
> they are intent done items. Hence when we add an intent done item to
> a transaction, tag the transaction to indicate that it contains such
> an item.
> 
> We don't tag the transaction when the defer ops is relogging an
> intent to move it forward in the log. Whiteouts will never apply to
> these cases, so we don't need to bother looking for them.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_shared.h | 24 +++++++++++++++++-------
>  fs/xfs/xfs_bmap_item.c     |  2 +-
>  fs/xfs/xfs_extfree_item.c  |  2 +-
>  fs/xfs/xfs_refcount_item.c |  2 +-
>  fs/xfs/xfs_rmap_item.c     |  2 +-
>  5 files changed, 21 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
> index 25c4cab58851..c4381388c0c1 100644
> --- a/fs/xfs/libxfs/xfs_shared.h
> +++ b/fs/xfs/libxfs/xfs_shared.h
> @@ -54,13 +54,23 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
>  /*
>   * Values for t_flags.
>   */
> -#define	XFS_TRANS_DIRTY		0x01	/* something needs to be logged */
> -#define	XFS_TRANS_SB_DIRTY	0x02	/* superblock is modified */
> -#define	XFS_TRANS_PERM_LOG_RES	0x04	/* xact took a permanent log res */
> -#define	XFS_TRANS_SYNC		0x08	/* make commit synchronous */
> -#define XFS_TRANS_RESERVE	0x20    /* OK to use reserved data blocks */
> -#define XFS_TRANS_NO_WRITECOUNT 0x40	/* do not elevate SB writecount */
> -#define XFS_TRANS_RES_FDBLKS	0x80	/* reserve newly freed blocks */
> +/* Transaction needs to be logged */
> +#define XFS_TRANS_DIRTY			(1u << 0)
> +/* Superblock is dirty and needs to be logged */
> +#define XFS_TRANS_SB_DIRTY		(1u << 1)
> +/* Transaction took a permanent log reservation */
> +#define XFS_TRANS_PERM_LOG_RES		(1u << 2)
> +/* Synchronous transaction commit needed */
> +#define XFS_TRANS_SYNC			(1u << 3)
> +/* Transaction can use reserve block pool */
> +#define XFS_TRANS_RESERVE		(1u << 4)
> +/* Transaction should avoid VFS level superblock write accounting */
> +#define XFS_TRANS_NO_WRITECOUNT		(1u << 5)
> +/* Transaction has freed blocks returned to it's reservation */
> +#define XFS_TRANS_RES_FDBLKS		(1u << 6)

Yesssss documentation finally!

> +/* Transaction contains an intent done log item */
> +#define XFS_TRANS_HAS_INTENT_DONE	(1u << 7)

I guess I'll see what this one does in the next few patches.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> +
>  /*
>   * LOWMODE is used by the allocator to activate the lowspace algorithm - when
>   * free space is running low the extent allocator may choose to allocate an
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index ed67c0028a68..3b968b31911b 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -255,7 +255,7 @@ xfs_trans_log_finish_bmap_update(
>  	 * 1.) releases the BUI and frees the BUD
>  	 * 2.) shuts down the filesystem
>  	 */
> -	tp->t_flags |= XFS_TRANS_DIRTY;
> +	tp->t_flags |= XFS_TRANS_DIRTY | XFS_TRANS_HAS_INTENT_DONE;
>  	set_bit(XFS_LI_DIRTY, &budp->bud_item.li_flags);
>  
>  	return error;
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index 21a159f9d8c5..96735f23d12d 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -381,7 +381,7 @@ xfs_trans_free_extent(
>  	 * 1.) releases the EFI and frees the EFD
>  	 * 2.) shuts down the filesystem
>  	 */
> -	tp->t_flags |= XFS_TRANS_DIRTY;
> +	tp->t_flags |= XFS_TRANS_DIRTY | XFS_TRANS_HAS_INTENT_DONE;
>  	set_bit(XFS_LI_DIRTY, &efdp->efd_item.li_flags);
>  
>  	next_extent = efdp->efd_next_extent;
> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> index 6536eea4c6ea..b523ce2c775b 100644
> --- a/fs/xfs/xfs_refcount_item.c
> +++ b/fs/xfs/xfs_refcount_item.c
> @@ -260,7 +260,7 @@ xfs_trans_log_finish_refcount_update(
>  	 * 1.) releases the CUI and frees the CUD
>  	 * 2.) shuts down the filesystem
>  	 */
> -	tp->t_flags |= XFS_TRANS_DIRTY;
> +	tp->t_flags |= XFS_TRANS_DIRTY | XFS_TRANS_HAS_INTENT_DONE;
>  	set_bit(XFS_LI_DIRTY, &cudp->cud_item.li_flags);
>  
>  	return error;
> diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> index c2bb8cfc231e..b269e68407b9 100644
> --- a/fs/xfs/xfs_rmap_item.c
> +++ b/fs/xfs/xfs_rmap_item.c
> @@ -328,7 +328,7 @@ xfs_trans_log_finish_rmap_update(
>  	 * 1.) releases the RUI and frees the RUD
>  	 * 2.) shuts down the filesystem
>  	 */
> -	tp->t_flags |= XFS_TRANS_DIRTY;
> +	tp->t_flags |= XFS_TRANS_DIRTY | XFS_TRANS_HAS_INTENT_DONE;
>  	set_bit(XFS_LI_DIRTY, &rudp->rud_item.li_flags);
>  
>  	return error;
> -- 
> 2.35.1
> 
