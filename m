Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48951 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751591AbdFHODz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 8 Jun 2017 10:03:55 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9D9878E3DB
        for <linux-xfs@vger.kernel.org>; Thu,  8 Jun 2017 14:03:54 +0000 (UTC)
Date: Thu, 8 Jun 2017 16:03:49 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 2/2] xfs: remove bli from AIL before release on
 transaction abort
Message-ID: <20170608140349.6tfgxacurjpt2xna@eorzea.usersys.redhat.com>
References: <1496750930-53954-1-git-send-email-bfoster@redhat.com>
 <1496750930-53954-3-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1496750930-53954-3-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jun 06, 2017 at 08:08:50AM -0400, Brian Foster wrote:
> When a buffer is modified, logged and committed, it ultimately ends
> up sitting on the AIL with a dirty bli waiting for metadata
> writeback. If another transaction locks and invalidates the buffer
> (freeing an inode chunk, for example) in the meantime, the bli is
> flagged as stale, the dirty state is cleared and the bli remains in
> the AIL.
> 

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>


> If a shutdown occurs before the transaction that has invalidated the
> buffer is committed, the transaction is ultimately aborted. The log
> items are flagged as such and ->iop_unlock() handles the aborted
> items. Because the bli is clean (due to the invalidation),
> ->iop_unlock() unconditionally releases it. The log item may still
> reside in the AIL, however, which means the I/O completion handler
> may still run and attempt to access it. This results in assert
> failure due to the release of the bli while still present in the AIL
> and a subsequent NULL dereference and panic in the buffer I/O
> completion handling. This can be reproduced by running generic/388
> in repetition.
> 
> To avoid this problem, update xfs_buf_item_unlock() to first check
> whether the bli is aborted and if so, remove it from the AIL before
> it is released. This ensures that the bli is no longer accessed
> during the shutdown sequence after it has been freed.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_buf_item.c | 21 ++++++++++++---------
>  1 file changed, 12 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 0306168..f6a8422 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -636,20 +636,23 @@ xfs_buf_item_unlock(
>  
>  	/*
>  	 * Clean buffers, by definition, cannot be in the AIL. However, aborted
> -	 * buffers may be dirty and hence in the AIL. Therefore if we are
> -	 * aborting a buffer and we've just taken the last refernce away, we
> -	 * have to check if it is in the AIL before freeing it. We need to free
> -	 * it in this case, because an aborted transaction has already shut the
> -	 * filesystem down and this is the last chance we will have to do so.
> +	 * buffers may be in the AIL regardless of dirty state. An aborted
> +	 * transaction that invalidates a buffer already in the AIL may have
> +	 * marked it stale and cleared the dirty state, for example.
> +	 *
> +	 * Therefore if we are aborting a buffer and we've just taken the last
> +	 * reference away, we have to check if it is in the AIL before freeing
> +	 * it. We need to free it in this case, because an aborted transaction
> +	 * has already shut the filesystem down and this is the last chance we
> +	 * will have to do so.
>  	 */
>  	if (atomic_dec_and_test(&bip->bli_refcount)) {
> -		if (clean)
> -			xfs_buf_item_relse(bp);
> -		else if (aborted) {
> +		if (aborted) {
>  			ASSERT(XFS_FORCED_SHUTDOWN(lip->li_mountp));
>  			xfs_trans_ail_remove(lip, SHUTDOWN_LOG_IO_ERROR);
>  			xfs_buf_item_relse(bp);
> -		}
> +		} else if (clean)
> +			xfs_buf_item_relse(bp);
>  	}
>  
>  	if (!(flags & XFS_BLI_HOLD))
> -- 
> 2.7.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
