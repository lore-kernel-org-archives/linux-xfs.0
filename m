Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04603C433C1
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Mar 2021 23:32:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C552D619A9
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Mar 2021 23:32:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbhCVXcJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Mar 2021 19:32:09 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:51284 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230393AbhCVXbl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Mar 2021 19:31:41 -0400
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 40F98829EAC;
        Tue, 23 Mar 2021 10:31:40 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lOU1L-005ck5-Jb; Tue, 23 Mar 2021 10:31:39 +1100
Date:   Tue, 23 Mar 2021 10:31:39 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/11] xfs: don't reclaim dquots with incore reservations
Message-ID: <20210322233139.GZ63242@dread.disaster.area>
References: <161543194009.1947934.9910987247994410125.stgit@magnolia>
 <161543195719.1947934.8218545606940173264.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161543195719.1947934.8218545606940173264.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=kj9zAlcOel0A:10 a=dESyimp9J3IA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=u-x0-HONdvJ1bNqI-wIA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 10, 2021 at 07:05:57PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If a dquot has an incore reservation that exceeds the ondisk count, it
> by definition has active incore state and must not be reclaimed.  Up to
> this point every inode with an incore dquot reservation has always
> retained a reference to the dquot so it was never possible for
> xfs_qm_dquot_isolate to be called on a dquot with active state and zero
> refcount, but this will soon change.
> 
> Deferred inode inactivation is about to reorganize how inodes are
> inactivated by shunting all that work to a background workqueue.  In
> order to avoid deadlocks with the quotaoff inode scan and reduce overall
> memory requirements (since inodes can spend a lot of time waiting for
> inactivation), inactive inodes will drop their dquot references while
> they're waiting to be inactivated.
> 
> However, inactive inodes can have delalloc extents in the data fork or
> any extents in the CoW fork.  Either of these contribute to the dquot's
> incore reservation being larger than the resource count (i.e. they're
> the reason the dquot still has active incore state), so we cannot allow
> the dquot to be reclaimed.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
.....
>  static enum lru_status
>  xfs_qm_dquot_isolate(
>  	struct list_head	*item,
> @@ -427,10 +441,15 @@ xfs_qm_dquot_isolate(
>  		goto out_miss_busy;
>  
>  	/*
> -	 * This dquot has acquired a reference in the meantime remove it from
> -	 * the freelist and try again.
> +	 * Either this dquot has incore reservations or it has acquired a
> +	 * reference.  Remove it from the freelist and try again.
> +	 *
> +	 * Inodes tagged for inactivation drop their dquot references to avoid
> +	 * deadlocks with quotaoff.  If these inodes have delalloc reservations
> +	 * in the data fork or any extents in the CoW fork, these contribute
> +	 * to the dquot's incore block reservation exceeding the count.
>  	 */
> -	if (dqp->q_nrefs) {
> +	if (xfs_dquot_has_incore_resv(dqp) || dqp->q_nrefs) {
>  		xfs_dqunlock(dqp);
>  		XFS_STATS_INC(dqp->q_mount, xs_qm_dqwants);
>  

This means we can have dquots with no references that aren't on
the free list and aren't actually referenced by any inode, either.

So if we now shut down the filesystem, what frees these dquots?
Are we relying on xfs_qm_dqpurge_all() to find all these dquots
and xfs_qm_dqpurge() guaranteeing that they are always cleaned
and freed?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
