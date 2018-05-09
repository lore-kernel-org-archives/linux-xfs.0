Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:59760 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934517AbeEIOw0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 May 2018 10:52:26 -0400
Date: Wed, 9 May 2018 07:52:22 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 4/9] xfs: don't assert fail with AIL lock held
Message-ID: <20180509145222.GL11261@magnolia>
References: <20180508034202.10136-1-david@fromorbit.com>
 <20180508034202.10136-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180508034202.10136-5-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Tue, May 08, 2018 at 01:41:57PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Been hitting AIL ordering assert failures recently, but been unable
> to trace them down because the system immediately hangs up onteh
> spinlock that was held when this assert fires:
> 
> XFS: Assertion failed: XFS_LSN_CMP(prev_lip->li_lsn, lip->li_lsn) <= 0, file: fs/xfs/xfs_trans_ail.c, line: 52
> 
> Move the assertions outside of the spinlock so the corpse can
> be dissected. Thanks to Brian Foster for supplying a clean
> way of doing this.
> 
> Signed-Off-By: Dave Chinner <dchinner@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_trans_ail.c | 43 +++++++++++++++++++++++++++++++-----------
>  1 file changed, 32 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index 50611d2bcbc2..41e280ef1483 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -32,30 +32,51 @@
>  #ifdef DEBUG
>  /*
>   * Check that the list is sorted as it should be.
> + *
> + * Called with the ail lock held, but we don't want to assert fail with it
> + * held otherwise we'll lock everything up and won't be able to debug the
> + * cause. Hence we sample and check the state under the AIL lock and return if
> + * everything is fine, otherwise we drop the lock and run the ASSERT checks.
> + * Asserts may not be fatal, so pick the lock back up and continue onwards.
>   */
>  STATIC void
>  xfs_ail_check(
> -	struct xfs_ail	*ailp,
> -	xfs_log_item_t	*lip)
> +	struct xfs_ail		*ailp,
> +	struct xfs_log_item	*lip)
>  {
> -	xfs_log_item_t	*prev_lip;
> +	struct xfs_log_item	*prev_lip;
> +	struct xfs_log_item	*next_lip;
> +	xfs_lsn_t		prev_lsn = NULLCOMMITLSN;
> +	xfs_lsn_t		next_lsn = NULLCOMMITLSN;
> +	xfs_lsn_t		lsn;
> +	bool			in_ail;
> +
>  
>  	if (list_empty(&ailp->ail_head))
>  		return;
>  
>  	/*
> -	 * Check the next and previous entries are valid.
> +	 * Sample then check the next and previous entries are valid.
>  	 */
> -	ASSERT(test_bit(XFS_LI_IN_AIL, &lip->li_flags));
> -	prev_lip = list_entry(lip->li_ail.prev, xfs_log_item_t, li_ail);
> +	in_ail = test_bit(XFS_LI_IN_AIL, &lip->li_flags);
> +	prev_lip = list_entry(lip->li_ail.prev, struct xfs_log_item, li_ail);
>  	if (&prev_lip->li_ail != &ailp->ail_head)
> -		ASSERT(XFS_LSN_CMP(prev_lip->li_lsn, lip->li_lsn) <= 0);
> -
> -	prev_lip = list_entry(lip->li_ail.next, xfs_log_item_t, li_ail);
> -	if (&prev_lip->li_ail != &ailp->ail_head)
> -		ASSERT(XFS_LSN_CMP(prev_lip->li_lsn, lip->li_lsn) >= 0);
> +		prev_lsn = prev_lip->li_lsn;
> +	next_lip = list_entry(lip->li_ail.next, struct xfs_log_item, li_ail);
> +	if (&next_lip->li_ail != &ailp->ail_head)
> +		next_lsn = next_lip->li_lsn;
> +	lsn = lip->li_lsn;
>  
> +	if (in_ail &&
> +	    (prev_lsn == NULLCOMMITLSN || XFS_LSN_CMP(prev_lsn, lsn) <= 0) &&
> +	    (next_lsn == NULLCOMMITLSN || XFS_LSN_CMP(next_lsn, lsn) >= 0))
> +		return;
>  
> +	spin_unlock(&ailp->ail_lock);
> +	ASSERT(in_ail);
> +	ASSERT(prev_lsn == NULLCOMMITLSN || XFS_LSN_CMP(prev_lsn, lsn) <= 0);
> +	ASSERT(next_lsn == NULLCOMMITLSN || XFS_LSN_CMP(next_lsn, lsn) >= 0);
> +	spin_lock(&ailp->ail_lock);
>  }
>  #else /* !DEBUG */
>  #define	xfs_ail_check(a,l)
> -- 
> 2.17.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
