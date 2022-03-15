Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1791C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Mar 2022 19:17:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241304AbiCOTSu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Mar 2022 15:18:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234545AbiCOTSu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Mar 2022 15:18:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FF48F31
        for <linux-xfs@vger.kernel.org>; Tue, 15 Mar 2022 12:17:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE38E616DC
        for <linux-xfs@vger.kernel.org>; Tue, 15 Mar 2022 19:17:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12115C340E8;
        Tue, 15 Mar 2022 19:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647371856;
        bh=P7tYMoGzPaszYOEistDg2lTkm9tmT/y6sCSZbUGv+I0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h05HwVqwqRAYzowRIbqTrF+YyvCsSNj9ZNrTaWNgwFIkjj0cJQVur6AiemWIXRzJz
         XrUV3iID2jO0yui/Vy2y2m316b737kJkStbFTOZiuvuJkp1EWh/9B0aL+68oNf1Fvu
         KUEifEf4/B9b5yyZhPBKhIgcKyG2GpWSToFYaE99VgqNcZ4DesXY7t0uZS+DA/mAtl
         fydSJX2qG2r7+v51MfPgCaCstYHzXF/pA4XVAkwuYe81rDKNzluZ4u/JaeMRcv2ZmT
         tzLO2WkWPHVJEKsndeYnIqyAnjX0V82uEiwtxsCshxyCULQRFlF+KaKDoUM14b99hy
         ZBJr13MigRN4w==
Date:   Tue, 15 Mar 2022 12:17:35 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/7] xfs: xfs_ail_push_all_sync() stalls when racing with
 updates
Message-ID: <20220315191735.GO8224@magnolia>
References: <20220315064241.3133751-1-david@fromorbit.com>
 <20220315064241.3133751-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220315064241.3133751-4-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 15, 2022 at 05:42:37PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> xfs_ail_push_all_sync() has a loop like this:
> 
> while max_ail_lsn {
> 	prepare_to_wait(ail_empty)
> 	target = max_ail_lsn
> 	wake_up(ail_task);
> 	schedule()
> }
> 
> Which is designed to sleep until the AIL is emptied. When
> xfs_ail_finish_update() moves the tail of the log, it does:
> 
> 	if (list_empty(&ailp->ail_head))
> 		wake_up_all(&ailp->ail_empty);
> 
> So it will only wake up the sync push waiter when the AIL goes
> empty. If, by the time the push waiter has woken, the AIL has more
> in it, it will reset the target, wake the push task and go back to
> sleep.
> 
> The problem here is that if the AIL is having items added to it
> when xfs_ail_push_all_sync() is called, then they may get inserted
> into the AIL at a LSN higher than the target LSN. At this point,
> xfsaild_push() will see that the target is X, the item LSNs are
> (X+N) and skip over them, hence never pushing the out.
> 
> The result of this the AIL will not get emptied by the AIL push
> thread, hence xfs_ail_finish_update() will never see the AIL being
> empty even if it moves the tail. Hence xfs_ail_push_all_sync() never
> gets woken and hence cannot update the push target to capture the
> items beyond the current target on the LSN.
> 
> This is a TOCTOU type of issue so the way to avoid it is to not
> use the push target at all for sync pushes. We know that a sync push
> is being requested by the fact the ail_empty wait queue is active,
> hence the xfsaild can just set the target to max_ail_lsn on every
> push that we see the wait queue active. Hence we no longer will
> leave items on the AIL that are beyond the LSN sampled at the start
> of a sync push.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_trans_ail.c | 21 ++++++++++++++++-----
>  1 file changed, 16 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index 2a8c8dc54c95..1b52952097c1 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -448,10 +448,22 @@ xfsaild_push(
>  
>  	spin_lock(&ailp->ail_lock);
>  
> -	/* barrier matches the ail_target update in xfs_ail_push() */
> -	smp_rmb();
> -	target = ailp->ail_target;
> -	ailp->ail_target_prev = target;
> +	/*
> +	 * If we have a sync push waiter, we always have to push till the AIL is
> +	 * empty. Update the target to point to the end of the AIL so that
> +	 * capture updates that occur after the sync push waiter has gone to
> +	 * sleep.
> +	 */
> +	if (waitqueue_active(&ailp->ail_empty)) {
> +		lip = xfs_ail_max(ailp);
> +		if (lip)
> +			target = lip->li_lsn;
> +	} else {
> +		/* barrier matches the ail_target update in xfs_ail_push() */
> +		smp_rmb();

Doesn't the spin_lock provide the required rmb?  I think it's
unnecessary given that, but I also don't think it hurts anything, so:

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> +		target = ailp->ail_target;
> +		ailp->ail_target_prev = target;
> +	}
>  
>  	/* we're done if the AIL is empty or our push has reached the end */
>  	lip = xfs_trans_ail_cursor_first(ailp, &cur, ailp->ail_last_pushed_lsn);
> @@ -724,7 +736,6 @@ xfs_ail_push_all_sync(
>  	spin_lock(&ailp->ail_lock);
>  	while ((lip = xfs_ail_max(ailp)) != NULL) {
>  		prepare_to_wait(&ailp->ail_empty, &wait, TASK_UNINTERRUPTIBLE);
> -		ailp->ail_target = lip->li_lsn;
>  		wake_up_process(ailp->ail_task);
>  		spin_unlock(&ailp->ail_lock);
>  		schedule();
> -- 
> 2.35.1
> 
