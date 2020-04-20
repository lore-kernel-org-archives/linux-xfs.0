Return-Path: <SRS0=5D7u=6E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5EE1C3815B
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Apr 2020 04:32:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1362206DD
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Apr 2020 04:32:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725815AbgDTEch (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Apr 2020 00:32:37 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:60926 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725710AbgDTEch (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Apr 2020 00:32:37 -0400
Received: from dread.disaster.area (pa49-180-0-232.pa.nsw.optusnet.com.au [49.180.0.232])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 6D86B3A3B41;
        Mon, 20 Apr 2020 14:32:34 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jQO6j-0008Vz-5w; Mon, 20 Apr 2020 14:32:33 +1000
Date:   Mon, 20 Apr 2020 14:32:33 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/12] xfs: clean up AIL log item removal functions
Message-ID: <20200420043233.GL9800@dread.disaster.area>
References: <20200417150859.14734-1-bfoster@redhat.com>
 <20200417150859.14734-11-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200417150859.14734-11-bfoster@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=XYjVcjsg+1UI/cdbgX7I7g==:117 a=XYjVcjsg+1UI/cdbgX7I7g==:17
        a=kj9zAlcOel0A:10 a=cl8xLZFz6L8A:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=ghj6jvPcsZKt3Z431NgA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 17, 2020 at 11:08:57AM -0400, Brian Foster wrote:
> We have two AIL removal functions with slightly different semantics.
> xfs_trans_ail_delete() expects the caller to have the AIL lock and
> for the associated item to be AIL resident. If not, the filesystem
> is shut down. xfs_trans_ail_remove() acquires the AIL lock, checks
> that the item is AIL resident and calls the former if so.
> 
> These semantics lead to confused usage between the two. For example,
> the _remove() variant takes a shutdown parameter to pass to the
> _delete() variant, but immediately returns if the AIL bit is not
> set. This means that _remove() would never shut down if an item is
> not AIL resident, even though it appears that many callers would
> expect it to.
> 
> Make the following changes to clean up both of these functions:
> 
> - Most callers of xfs_trans_ail_delete() acquire the AIL lock just
>   before the call. Update _delete() to acquire the lock and open
>   code the couple of callers that make additional checks under AIL
>   lock.
> - Drop the unnecessary ailp parameter from _delete().
> - Drop the unused shutdown parameter from _remove() and open code
>   the implementation.
> 
> In summary, this leaves a _delete() variant that expects an AIL
> resident item and a _remove() helper that checks the AIL bit. Audit
> the existing callsites for use of the appropriate function and
> update as necessary.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
....

Good start, but...

> @@ -1032,10 +1033,11 @@ xfs_qm_dqflush_done(
>  		goto out;
>  
>  	spin_lock(&ailp->ail_lock);
> -	if (lip->li_lsn == qip->qli_flush_lsn)
> -		/* xfs_trans_ail_delete() drops the AIL lock */
> -		xfs_trans_ail_delete(ailp, lip, SHUTDOWN_CORRUPT_INCORE);
> -	else
> +	if (lip->li_lsn == qip->qli_flush_lsn) {
> +		/* xfs_ail_update_finish() drops the AIL lock */
> +		tail_lsn = xfs_ail_delete_one(ailp, lip);
> +		xfs_ail_update_finish(ailp, tail_lsn);
> +	} else
>  		spin_unlock(&ailp->ail_lock);

This drops the shutdown if the dquot is not in the AIL. It should be
in the AIL, so if it isn't we should be shutting down...

> @@ -872,13 +872,14 @@ xfs_ail_delete_one(
>   */
>  void
>  xfs_trans_ail_delete(
> -	struct xfs_ail		*ailp,
>  	struct xfs_log_item	*lip,
>  	int			shutdown_type)
>  {
> +	struct xfs_ail		*ailp = lip->li_ailp;
>  	struct xfs_mount	*mp = ailp->ail_mount;
>  	xfs_lsn_t		tail_lsn;
>  
> +	spin_lock(&ailp->ail_lock);
>  	if (!test_bit(XFS_LI_IN_AIL, &lip->li_flags)) {
>  		spin_unlock(&ailp->ail_lock);
>  		if (!XFS_FORCED_SHUTDOWN(mp)) {
> diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
> index 9135afdcee9d..7563c78e2997 100644
> --- a/fs/xfs/xfs_trans_priv.h
> +++ b/fs/xfs/xfs_trans_priv.h
> @@ -94,22 +94,23 @@ xfs_trans_ail_update(
>  xfs_lsn_t xfs_ail_delete_one(struct xfs_ail *ailp, struct xfs_log_item *lip);
>  void xfs_ail_update_finish(struct xfs_ail *ailp, xfs_lsn_t old_lsn)
>  			__releases(ailp->ail_lock);
> -void xfs_trans_ail_delete(struct xfs_ail *ailp, struct xfs_log_item *lip,
> -		int shutdown_type);
> +void xfs_trans_ail_delete(struct xfs_log_item *lip, int shutdown_type);
>  
>  static inline void
>  xfs_trans_ail_remove(
> -	struct xfs_log_item	*lip,
> -	int			shutdown_type)
> +	struct xfs_log_item	*lip)
>  {
>  	struct xfs_ail		*ailp = lip->li_ailp;
> +	xfs_lsn_t		tail_lsn;
>  
>  	spin_lock(&ailp->ail_lock);
> -	/* xfs_trans_ail_delete() drops the AIL lock */
> -	if (test_bit(XFS_LI_IN_AIL, &lip->li_flags))
> -		xfs_trans_ail_delete(ailp, lip, shutdown_type);
> -	else
> +	/* xfs_ail_update_finish() drops the AIL lock */
> +	if (test_bit(XFS_LI_IN_AIL, &lip->li_flags)) {
> +		tail_lsn = xfs_ail_delete_one(ailp, lip);
> +		xfs_ail_update_finish(ailp, tail_lsn);
> +	} else {
>  		spin_unlock(&ailp->ail_lock);
> +	}
>  }

This makes xfs_trans_ail_delete() and xfs_trans_ail_remove() almost
identical, except one will shutdown if the item is not in the AIL
and the other won't. Wouldn't it be better to get it down to just
one function that does everything, and remove the confusion of which
to use altogether?

void
xfs_trans_ail_delete(
	struct xfs_log_item     *lip,
	int                     shutdown)
{
	struct xfs_ail		*ailp = lip->li_ailp;

	spin_lock(&ailp->ail_lock);
	if (test_bit(XFS_LI_IN_AIL, &lip->li_flags)) {
		xfs_lsn_t tail_lsn = xfs_ail_delete_one(ailp, lip);
		xfs_ail_update_finish(ailp, tail_lsn);
		return;
	}
	spin_unlock(&ailp->ail_lock);
	if (!shutdown)
		return;

	/* do shutdown stuff */
}

-Dave.

-- 
Dave Chinner
david@fromorbit.com
