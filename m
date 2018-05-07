Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4388 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751978AbeEGMSI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 7 May 2018 08:18:08 -0400
Date: Mon, 7 May 2018 08:18:06 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 05/10] xfs: don't assert fail with AIL lock held
Message-ID: <20180507121806.GF38916@bfoster.bfoster>
References: <20180502080157.11386-1-david@fromorbit.com>
 <20180502080157.11386-6-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180502080157.11386-6-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Wed, May 02, 2018 at 06:01:52PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Been hitting AIL ordering assert failures recently, but been unable
> to trace them down because the system immediately hangs up onteh

							     on the

> spinlock that was held when this assert fires:
> 
> XFS: Assertion failed: XFS_LSN_CMP(prev_lip->li_lsn, lip->li_lsn) <= 0, file: fs/xfs/xfs_trans_ail.c, line: 52
> 
> Move the assertions outside of the spinlock so the corpse can
> be dissected.
> 
> Signed-Off-By: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_trans_ail.c | 40 ++++++++++++++++++++++++++++++----------
>  1 file changed, 30 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index 50611d2bcbc2..58a2cf6fd4d9 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -32,13 +32,19 @@
>  #ifdef DEBUG
>  /*
>   * Check that the list is sorted as it should be.
> + *
> + * Called with the ail lock held, but we don't want to assert fail with it
> + * held otherwise we'll lock everything up and won't be able to debug the
> + * cause. Hence jump through hoops to drop teh lock before assert failing.

					      the

> + * Asserts may not be fatal, so pick teh lock back up and continue onwards.

					the

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
>  
>  	if (list_empty(&ailp->ail_head))
>  		return;
> @@ -46,15 +52,29 @@ xfs_ail_check(
>  	/*
>  	 * Check the next and previous entries are valid.
>  	 */
> -	ASSERT(test_bit(XFS_LI_IN_AIL, &lip->li_flags));
> -	prev_lip = list_entry(lip->li_ail.prev, xfs_log_item_t, li_ail);
> -	if (&prev_lip->li_ail != &ailp->ail_head)
> -		ASSERT(XFS_LSN_CMP(prev_lip->li_lsn, lip->li_lsn) <= 0);
> +	if (!test_bit(XFS_LI_IN_AIL, &lip->li_flags)) {
> +		spin_unlock(&ailp->ail_lock);
> +		ASSERT(0);
> +		spin_lock(&ailp->ail_lock);
> +	}
>  
> -	prev_lip = list_entry(lip->li_ail.next, xfs_log_item_t, li_ail);
> -	if (&prev_lip->li_ail != &ailp->ail_head)
> -		ASSERT(XFS_LSN_CMP(prev_lip->li_lsn, lip->li_lsn) >= 0);
> +	prev_lip = list_entry(lip->li_ail.prev, xfs_log_item_t, li_ail);
> +	if (&prev_lip->li_ail != &ailp->ail_head) {
> +		if (XFS_LSN_CMP(prev_lip->li_lsn, lip->li_lsn) > 0) {
> +			spin_unlock(&ailp->ail_lock);
> +			ASSERT(0);
> +			spin_lock(&ailp->ail_lock);
> +		}
> +	}
>  
> +	next_lip = list_entry(lip->li_ail.next, xfs_log_item_t, li_ail);
> +	if (&next_lip->li_ail != &ailp->ail_head) {
> +		if (XFS_LSN_CMP(next_lip->li_lsn, lip->li_lsn) < 0) {
> +			spin_unlock(&ailp->ail_lock);
> +			ASSERT(0);
> +			spin_lock(&ailp->ail_lock);
> +		}
> +	}

Otherwise seems Ok, but kind of ugly. What about something like the
following diff (applied on top of this patch)? Still hacky, but it
avoids the multiple lock cycles for each check failure and preserves the
actual assert strings. (Untested and probably could use comment
updates..).

Brian

--- 8< ---

diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 58a2cf6fd4d9..98798d15b863 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -45,37 +45,36 @@ xfs_ail_check(
 {
 	struct xfs_log_item	*prev_lip;
 	struct xfs_log_item	*next_lip;
+	xfs_lsn_t		prev_lsn = NULLCOMMITLSN;
+	xfs_lsn_t		next_lsn = NULLCOMMITLSN;
+	xfs_lsn_t		lsn;
+	bool			in_ail;
 
 	if (list_empty(&ailp->ail_head))
 		return;
 
+	in_ail = test_bit(XFS_LI_IN_AIL, &lip->li_flags);
+	prev_lip = list_entry(lip->li_ail.prev, struct xfs_log_item, li_ail);
+	if (&prev_lip->li_ail != &ailp->ail_head)
+		prev_lsn = prev_lip->li_lsn;
+	next_lip = list_entry(lip->li_ail.next, struct xfs_log_item, li_ail);
+	if (&next_lip->li_ail != &ailp->ail_head)
+		next_lsn = next_lip->li_lsn;
+	lsn = lip->li_lsn;
+
 	/*
 	 * Check the next and previous entries are valid.
 	 */
-	if (!test_bit(XFS_LI_IN_AIL, &lip->li_flags)) {
-		spin_unlock(&ailp->ail_lock);
-		ASSERT(0);
-		spin_lock(&ailp->ail_lock);
-	}
-
-	prev_lip = list_entry(lip->li_ail.prev, xfs_log_item_t, li_ail);
-	if (&prev_lip->li_ail != &ailp->ail_head) {
-		if (XFS_LSN_CMP(prev_lip->li_lsn, lip->li_lsn) > 0) {
-			spin_unlock(&ailp->ail_lock);
-			ASSERT(0);
-			spin_lock(&ailp->ail_lock);
-		}
-	}
-
-	next_lip = list_entry(lip->li_ail.next, xfs_log_item_t, li_ail);
-	if (&next_lip->li_ail != &ailp->ail_head) {
-		if (XFS_LSN_CMP(next_lip->li_lsn, lip->li_lsn) < 0) {
-			spin_unlock(&ailp->ail_lock);
-			ASSERT(0);
-			spin_lock(&ailp->ail_lock);
-		}
-	}
+	if (in_ail &&
+	    (prev_lsn == NULLCOMMITLSN || XFS_LSN_CMP(prev_lsn, lsn) <= 0) &&
+	    (next_lsn == NULLCOMMITLSN || XFS_LSN_CMP(next_lsn, lsn) >= 0))
+		return;
 
+	spin_unlock(&ailp->ail_lock);
+	ASSERT(in_ail);
+	ASSERT(prev_lsn == NULLCOMMITLSN || XFS_LSN_CMP(prev_lsn, lsn) <= 0);
+	ASSERT(next_lsn == NULLCOMMITLSN || XFS_LSN_CMP(next_lsn, lsn) >= 0);
+	spin_lock(&ailp->ail_lock);
 }
 #else /* !DEBUG */
 #define	xfs_ail_check(a,l)
