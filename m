Return-Path: <SRS0=kcSc=DG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 731A6C4742B
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Sep 2020 20:48:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24FF62072E
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Sep 2020 20:48:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728301AbgI2UsP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Sep 2020 16:48:15 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:46280 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728907AbgI2UsP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Sep 2020 16:48:15 -0400
Received: from dread.disaster.area (pa49-195-191-192.pa.nsw.optusnet.com.au [49.195.191.192])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id F07718281D9;
        Wed, 30 Sep 2020 06:48:09 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kNMXg-0000nQ-L2; Wed, 30 Sep 2020 06:48:08 +1000
Date:   Wed, 30 Sep 2020 06:48:08 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH RFC 3/3] xfs: rework quotaoff logging to avoid log
 deadlock on active fs
Message-ID: <20200929204808.GI14422@dread.disaster.area>
References: <20200929141228.108688-1-bfoster@redhat.com>
 <20200929141228.108688-4-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200929141228.108688-4-bfoster@redhat.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=vvDRHhr1aDYKXl+H6jx2TA==:117 a=vvDRHhr1aDYKXl+H6jx2TA==:17
        a=kj9zAlcOel0A:10 a=reM5J-MqmosA:10 a=7-415B0cAAAA:8 a=20KFwNOVAAAA:8
        a=DdWI9KI5RQuBkYierZMA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 29, 2020 at 10:12:28AM -0400, Brian Foster wrote:
> The quotaoff operation logs two log items. The start item is
> committed first, followed by the bulk of the in-core quotaoff
> processing, and then the quotaoff end item is committed to release
> the start item from the log. The problem with this mechanism is that
> quite a bit of processing can be required to release dquots from all
> in-core inodes and subsequently flush/purge all dquots in the
> system. This processing work doesn't generally generate much log
> traffic itself, but the start item pins the tail of the log. If an
> external workload consumes the remaining log space before the
> transaction for the end item is allocated, a log deadlock can occur.
> 
> The purpose of the separate start and end log items is primarily to
> ensure that log recovery does not incorrectly recover dquot data
> after an fs crash where a quotaoff was in progress. If we only
> logged a single quotaoff item, for example, it could fall behind the
> tail of the log before the last dquot modification was made and
> incorrectly replay dquot changes that might have occurred after the
> start item committed but before quotaoff deactivated the quota.
> 
> With that context, we can make some small changes to the quotaoff
> algorithm to provide the same general log ordering guarantee without
> such a large window to create a log deadlock vector. Rather than
> place a start item in the log for the duration of quotaoff
> processing, we can quiesce the transaction subsystem up front to
> guarantee that no further dquots are logged from that point forward.
> IOW, we freeze the transaction subsystem, commit the start item in a
> synchronous transaction that forces the log, deactivate the
> associated quota such that subsequent transactions no longer modify
> associated dquots, unfreeze the transaction subsystem and finally
> commit the quotaoff end item. The transaction freeze is somewhat of
> a heavy weight operation, but quotaoff is already a rare, slow and
> performance disruptive operation.
> 
> Altogether, this means that the dquot rele/purge sequence occurs
> after the quotaoff end item has committed and thus can technically
> fall off the active range of the log. This is safe because the
> remaining processing is all in-core work that doesn't involve
> logging dquots and we've guaranteed that no further dquots can be
> modified by external transactions. This allows quotaoff to complete
> without risking log deadlock regardless of how much dquot processing
> is required.
> 
> Suggested-by: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_qm_syscalls.c | 36 ++++++++++++++++--------------------
>  fs/xfs/xfs_trans_dquot.c |  2 ++
>  2 files changed, 18 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index ca1b57d291dc..97844f33f70f 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -29,7 +29,8 @@ xfs_qm_log_quotaoff(
>  	int			error;
>  	struct xfs_qoff_logitem	*qoffi;
>  
> -	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_quotaoff, 0, 0, 0, &tp);
> +	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_quotaoff, 0, 0,
> +				XFS_TRANS_NO_WRITECOUNT, &tp);
>  	if (error)
>  		goto out;
>  
> @@ -169,14 +170,18 @@ xfs_qm_scall_quotaoff(
>  	if ((mp->m_qflags & flags) == 0)
>  		goto out_unlock;
>  
> +	xfs_trans_freeze(mp);
> +
>  	/*
>  	 * Write the LI_QUOTAOFF log record, and do SB changes atomically,
>  	 * and synchronously. If we fail to write, we should abort the
>  	 * operation as it cannot be recovered safely if we crash.
>  	 */
>  	error = xfs_qm_log_quotaoff(mp, &qoffstart, flags);
> -	if (error)
> +	if (error) {
> +		xfs_trans_unfreeze(mp);
>  		goto out_unlock;
> +	}
>  
>  	/*
>  	 * Next we clear the XFS_MOUNT_*DQ_ACTIVE bit(s) in the mount struct
> @@ -191,6 +196,15 @@ xfs_qm_scall_quotaoff(
>  	 */
>  	mp->m_qflags &= ~inactivate_flags;
>  
> +	xfs_trans_unfreeze(mp);
> +
> +	error = xfs_qm_log_quotaoff_end(mp, &qoffstart, flags);
> +	if (error) {
> +		/* We're screwed now. Shutdown is the only option. */
> +		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> +		goto out_unlock;
> +	}
> +

The m_qflags update is racy. There's no memory barriers or locks
here to order the mp->m_qflags update with other CPUs, so there's no
guarantee that an incoming transaction will see the m_qflags change
that disables quotas.

Also, we can now race with other transaction reservations to log the
quota off end item, which means that if there are enough pending
transactions reservations queued before the quotaoff_end transaction
is started, the quotaoff item can pin the tail of the log and we
deadlock.

That was the reason why I logged both quota off items in the same
transaction in the prototype code I send out - we have to log both
quota-off items while the transaction subsystem is quiesced
otherwise we don't fix the original problem (that the quotaoff
item can pin the tail of the log and deadlock).....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
