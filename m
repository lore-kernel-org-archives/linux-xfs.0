Return-Path: <SRS0=uikP=7R=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28CEBC433DF
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Jun 2020 23:13:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08B5C20663
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Jun 2020 23:13:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726147AbgFDXNc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Jun 2020 19:13:32 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:42689 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725943AbgFDXNc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Jun 2020 19:13:32 -0400
Received: from dread.disaster.area (pa49-180-124-177.pa.nsw.optusnet.com.au [49.180.124.177])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 4CE42D58EA5;
        Fri,  5 Jun 2020 09:13:28 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jgz39-0001Dx-F2; Fri, 05 Jun 2020 09:13:27 +1000
Date:   Fri, 5 Jun 2020 09:13:27 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Waiman Long <longman@redhat.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Qian Cai <cai@lca.pw>, Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH v2] xfs: Fix false positive lockdep warning with
 sb_internal & fs_reclaim
Message-ID: <20200604231327.GV2040@dread.disaster.area>
References: <20200604210130.697-1-longman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200604210130.697-1-longman@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=k3aV/LVJup6ZGWgigO6cSA==:117 a=k3aV/LVJup6ZGWgigO6cSA==:17
        a=kj9zAlcOel0A:10 a=nTHF0DUjJn0A:10 a=7-415B0cAAAA:8
        a=BOxwD6q5GxyBsbH42-YA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 04, 2020 at 05:01:30PM -0400, Waiman Long wrote:
> ---
>  fs/xfs/xfs_log.c   | 3 ++-
>  fs/xfs/xfs_trans.c | 8 +++++++-
>  2 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 00fda2e8e738..d273d4e74ef8 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -433,7 +433,8 @@ xfs_log_reserve(
>  	XFS_STATS_INC(mp, xs_try_logspace);
>  
>  	ASSERT(*ticp == NULL);
> -	tic = xlog_ticket_alloc(log, unit_bytes, cnt, client, permanent, 0);
> +	tic = xlog_ticket_alloc(log, unit_bytes, cnt, client, permanent,
> +			mp->m_super->s_writers.frozen ? KM_NOLOCKDEP : 0);
>  	*ticp = tic;

Hi Waiman,

As I originally stated when you posted this the first time 6 months
ago: we are not going to spread this sort of conditional gunk though
the XFS codebase just to shut up lockdep false positives.

I pointed you at the way to conditionally turn of lockdep for
operations where we are doing transactions when the filesystem has
already frozen the transaction subsystem. That is:

>  
>  	xlog_grant_push_ail(log, tic->t_cnt ? tic->t_unit_res * tic->t_cnt
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 3c94e5ff4316..3a9f394a0f02 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -261,8 +261,14 @@ xfs_trans_alloc(
>  	 * Allocate the handle before we do our freeze accounting and setting up
>  	 * GFP_NOFS allocation context so that we avoid lockdep false positives
>  	 * by doing GFP_KERNEL allocations inside sb_start_intwrite().
> +	 *
> +	 * To prevent false positive lockdep warning of circular locking
> +	 * dependency between sb_internal and fs_reclaim, disable the
> +	 * acquisition of the fs_reclaim pseudo-lock when the superblock
> +	 * has been frozen or in the process of being frozen.
>  	 */
> -	tp = kmem_zone_zalloc(xfs_trans_zone, 0);
> +	tp = kmem_zone_zalloc(xfs_trans_zone,
> +		mp->m_super->s_writers.frozen ? KM_NOLOCKDEP : 0);
>  	if (!(flags & XFS_TRANS_NO_WRITECOUNT))

We only should be setting KM_NOLOCKDEP when XFS_TRANS_NO_WRITECOUNT
is set.  That's the flag that transactions set when they run in a
fully frozen context to avoid deadlocking with the freeze in
progress, and that's the only case where we should be turning off
lockdep.

And, as I also mentioned, this should be done via a process flag -
PF_MEMALLOC_NOLOCKDEP - so that it is automatically inherited by
all subsequent memory allocations done in this path. That way we
only need this wrapping code in xfs_trans_alloc():

	if (flags & XFS_TRANS_NO_WRITECOUNT)
		memalloc_nolockdep_save()

	.....

	if (flags & XFS_TRANS_NO_WRITECOUNT)
		memalloc_nolockdep_restore()

and nothing else needs to change.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
