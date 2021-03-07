Return-Path: <SRS0=xiMZ=IF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8B83C433E0
	for <linux-xfs@archiver.kernel.org>; Sun,  7 Mar 2021 23:07:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71BB664FE9
	for <linux-xfs@archiver.kernel.org>; Sun,  7 Mar 2021 23:07:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233241AbhCGXGd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 7 Mar 2021 18:06:33 -0500
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:50077 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233244AbhCGXGD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 7 Mar 2021 18:06:03 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 55933FADBED;
        Mon,  8 Mar 2021 10:05:56 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lJ2TD-0022jD-Mq; Mon, 08 Mar 2021 10:05:55 +1100
Date:   Mon, 8 Mar 2021 10:05:55 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@lst.de, dchinner@redhat.com,
        christian.brauner@ubuntu.com
Subject: Re: [PATCH 4/4] xfs: drop freeze protection when running GETFSMAP
Message-ID: <20210307230555.GZ4662@dread.disaster.area>
References: <161514874040.698643.2749449122589431232.stgit@magnolia>
 <161514876275.698643.12226309352552265069.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161514876275.698643.12226309352552265069.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=kj9zAlcOel0A:10 a=dESyimp9J3IA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=GaK7ECep2s3NIUxSJMUA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Mar 07, 2021 at 12:26:02PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> A recent log refactoring patchset from Brian Foster relaxed fsfreeze
> behavior with regards to the buffer cache -- now freeze only waits for
> pending buffer IO to finish, and does not try to drain the buffer cache
> LRU.  As a result, fsfreeze should no longer stall indefinitely while
> fsmap runs.  Drop the sb_start_write calls around fsmap invocations.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_fsmap.c |   14 +++++---------
>  1 file changed, 5 insertions(+), 9 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
> index 9ce5e7d5bf8f..34f2b971ce43 100644
> --- a/fs/xfs/xfs_fsmap.c
> +++ b/fs/xfs/xfs_fsmap.c
> @@ -904,14 +904,6 @@ xfs_getfsmap(
>  	info.fsmap_recs = fsmap_recs;
>  	info.head = head;
>  
> -	/*
> -	 * If fsmap runs concurrently with a scrub, the freeze can be delayed
> -	 * indefinitely as we walk the rmapbt and iterate over metadata
> -	 * buffers.  Freeze quiesces the log (which waits for the buffer LRU to
> -	 * be emptied) and that won't happen while we're reading buffers.
> -	 */
> -	sb_start_write(mp->m_super);
> -
>  	/* For each device we support... */
>  	for (i = 0; i < XFS_GETFSMAP_DEVS; i++) {
>  		/* Is this device within the range the user asked for? */
> @@ -934,6 +926,11 @@ xfs_getfsmap(
>  		if (handlers[i].dev > head->fmh_keys[0].fmr_device)
>  			memset(&dkeys[0], 0, sizeof(struct xfs_fsmap));
>  
> +		/*
> +		 * Grab an empty transaction so that we can use its recursive
> +		 * buffer locking abilities to detect cycles in the rmapbt
> +		 * without deadlocking.
> +		 */
>  		error = xfs_trans_alloc_empty(mp, &tp);
>  		if (error)
>  			break;

Took me a moment to work out that this is just adding a comment
because it wasn't mentioned in the commit log. Somewhat unrelated to
the bug fix but it's harmless so I don't see any need for you to
do any extra work to respin this patch to remove it.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
