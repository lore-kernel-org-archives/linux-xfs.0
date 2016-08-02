Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C54067CA4
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 13:47:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9741A304039
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 11:47:38 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Shfqvs9EJQuMe06u (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 02 Aug 2016 11:47:37 -0700 (PDT)
Date: Tue, 2 Aug 2016 14:47:34 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 18/47] xfs: refactor redo intent item processing
Message-ID: <20160802184734.GA58152@bfoster.bfoster>
References: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
	<146907708421.25461.405239727630066080.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <146907708421.25461.405239727630066080.stgit@birch.djwong.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, xfs@oss.sgi.com

On Wed, Jul 20, 2016 at 09:58:04PM -0700, Darrick J. Wong wrote:
> Refactor the EFI intent item recovery (and cancellation) functions
> into a general function that scans the AIL and an intent item type
> specific handler.  Move the function that recovers a single EFI item
> into the extent free item code.  We'll want the generalized function
> when we start wiring up more redo item types.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_extfree_item.c |   65 ++++++++++++++++
>  fs/xfs/xfs_extfree_item.h |    3 +
>  fs/xfs/xfs_log_recover.c  |  182 +++++++++++++++++++++------------------------
>  3 files changed, 151 insertions(+), 99 deletions(-)
> 
> 
...
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 080b54b..af608aa 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -24,7 +24,6 @@
>  #include "xfs_bit.h"
>  #include "xfs_sb.h"
>  #include "xfs_mount.h"
> -#include "xfs_defer.h"
>  #include "xfs_da_format.h"
>  #include "xfs_da_btree.h"
>  #include "xfs_inode.h"
> @@ -4165,126 +4164,112 @@ xlog_recover_process_data(
...
>  STATIC int
> -xlog_recover_process_efis(
> +xlog_recover_process_intents(
>  	struct xlog		*log)
>  {
>  	struct xfs_log_item	*lip;
> -	struct xfs_efi_log_item	*efip;
>  	int			error = 0;
>  	struct xfs_ail_cursor	cur;
>  	struct xfs_ail		*ailp;
> +	xfs_lsn_t		last_lsn;
>  
>  	ailp = log->l_ailp;
>  	spin_lock(&ailp->xa_lock);
>  	lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
> +	last_lsn = xlog_assign_lsn(log->l_curr_cycle, log->l_curr_block);
>  	while (lip != NULL) {
>  		/*
> -		 * We're done when we see something other than an EFI.
> -		 * There should be no EFIs left in the AIL now.
> +		 * We're done when we see something other than an intent.
> +		 * There should be no intents left in the AIL now.
>  		 */
> -		if (lip->li_type != XFS_LI_EFI) {
> +		if (!xlog_item_is_intent(lip)) {
>  #ifdef DEBUG
>  			for (; lip; lip = xfs_trans_ail_cursor_next(ailp, &cur))
> -				ASSERT(lip->li_type != XFS_LI_EFI);
> +				ASSERT(!xlog_item_is_intent(lip));
>  #endif
>  			break;
>  		}
>  
>  		/*
> -		 * Skip EFIs that we've already processed.
> +		 * We should never see a redo item with a LSN higher than
> +		 * the last transaction we found in the log at the start
> +		 * of recovery.
>  		 */
> -		efip = container_of(lip, struct xfs_efi_log_item, efi_item);
> -		if (test_bit(XFS_EFI_RECOVERED, &efip->efi_flags)) {
> -			lip = xfs_trans_ail_cursor_next(ailp, &cur);
> -			continue;
> -		}
> +		ASSERT(XFS_LSN_CMP(last_lsn, lip->li_lsn) >= 0);
>  
> -		spin_unlock(&ailp->xa_lock);
> -		error = xlog_recover_process_efi(log->l_mp, efip);
> -		spin_lock(&ailp->xa_lock);
> +		switch (lip->li_type) {
> +		case XFS_LI_EFI:
> +			error = xlog_recover_process_efi(log->l_mp, ailp, lip);
> +			break;
> +		}

I think I'd prefer to see the locking remain here rather than get buried
in the helper functions. That said, this allows us to check the
recovered bit without a lock cycle. Meh, either way:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  		if (error)
>  			goto out;
>  		lip = xfs_trans_ail_cursor_next(ailp, &cur);
> @@ -4296,15 +4281,14 @@ out:
>  }
>  
>  /*
> - * A cancel occurs when the mount has failed and we're bailing out. Release all
> - * pending EFIs so they don't pin the AIL.
> + * A cancel occurs when the mount has failed and we're bailing out.
> + * Release all pending log intent items so they don't pin the AIL.
>   */
>  STATIC int
> -xlog_recover_cancel_efis(
> +xlog_recover_cancel_intents(
>  	struct xlog		*log)
>  {
>  	struct xfs_log_item	*lip;
> -	struct xfs_efi_log_item	*efip;
>  	int			error = 0;
>  	struct xfs_ail_cursor	cur;
>  	struct xfs_ail		*ailp;
> @@ -4314,22 +4298,22 @@ xlog_recover_cancel_efis(
>  	lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
>  	while (lip != NULL) {
>  		/*
> -		 * We're done when we see something other than an EFI.
> -		 * There should be no EFIs left in the AIL now.
> +		 * We're done when we see something other than an intent.
> +		 * There should be no intents left in the AIL now.
>  		 */
> -		if (lip->li_type != XFS_LI_EFI) {
> +		if (!xlog_item_is_intent(lip)) {
>  #ifdef DEBUG
>  			for (; lip; lip = xfs_trans_ail_cursor_next(ailp, &cur))
> -				ASSERT(lip->li_type != XFS_LI_EFI);
> +				ASSERT(!xlog_item_is_intent(lip));
>  #endif
>  			break;
>  		}
>  
> -		efip = container_of(lip, struct xfs_efi_log_item, efi_item);
> -
> -		spin_unlock(&ailp->xa_lock);
> -		xfs_efi_release(efip);
> -		spin_lock(&ailp->xa_lock);
> +		switch (lip->li_type) {
> +		case XFS_LI_EFI:
> +			xlog_recover_cancel_efi(log->l_mp, ailp, lip);
> +			break;
> +		}
>  
>  		lip = xfs_trans_ail_cursor_next(ailp, &cur);
>  	}
> @@ -5140,16 +5124,16 @@ xlog_recover_finish(
>  	 */
>  	if (log->l_flags & XLOG_RECOVERY_NEEDED) {
>  		int	error;
> -		error = xlog_recover_process_efis(log);
> +		error = xlog_recover_process_intents(log);
>  		if (error) {
> -			xfs_alert(log->l_mp, "Failed to recover EFIs");
> +			xfs_alert(log->l_mp, "Failed to recover intents");
>  			return error;
>  		}
>  		/*
> -		 * Sync the log to get all the EFIs out of the AIL.
> +		 * Sync the log to get all the intents out of the AIL.
>  		 * This isn't absolutely necessary, but it helps in
>  		 * case the unlink transactions would have problems
> -		 * pushing the EFIs out of the way.
> +		 * pushing the intents out of the way.
>  		 */
>  		xfs_log_force(log->l_mp, XFS_LOG_SYNC);
>  
> @@ -5174,7 +5158,7 @@ xlog_recover_cancel(
>  	int		error = 0;
>  
>  	if (log->l_flags & XLOG_RECOVERY_NEEDED)
> -		error = xlog_recover_cancel_efis(log);
> +		error = xlog_recover_cancel_intents(log);
>  
>  	return error;
>  }
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
