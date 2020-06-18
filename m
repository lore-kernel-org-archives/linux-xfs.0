Return-Path: <SRS0=OEwr=77=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 004C3C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Jun 2020 00:46:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE1252168B
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Jun 2020 00:46:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726854AbgFRAqB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 17 Jun 2020 20:46:01 -0400
Received: from [211.29.132.246] ([211.29.132.246]:55447 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-FAIL-FAIL-OK-OK)
        by vger.kernel.org with ESMTP id S1726848AbgFRAqB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Jun 2020 20:46:01 -0400
Received: from dread.disaster.area (unknown [49.180.124.177])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 3754F52E54D;
        Thu, 18 Jun 2020 10:45:09 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jlifx-0001W3-Cu; Thu, 18 Jun 2020 10:45:05 +1000
Date:   Thu, 18 Jun 2020 10:45:05 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Waiman Long <longman@redhat.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Qian Cai <cai@lca.pw>, Eric Sandeen <sandeen@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 2/2] xfs: Fix false positive lockdep warning with
 sb_internal & fs_reclaim
Message-ID: <20200618004505.GG2005@dread.disaster.area>
References: <20200617175310.20912-1-longman@redhat.com>
 <20200617175310.20912-3-longman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200617175310.20912-3-longman@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=k3aV/LVJup6ZGWgigO6cSA==:117 a=k3aV/LVJup6ZGWgigO6cSA==:17
        a=kj9zAlcOel0A:10 a=nTHF0DUjJn0A:10 a=7-415B0cAAAA:8
        a=hXDGzopf8riABYrvaZEA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 17, 2020 at 01:53:10PM -0400, Waiman Long wrote:
>  fs/xfs/xfs_log.c   |  9 +++++++++
>  fs/xfs/xfs_trans.c | 31 +++++++++++++++++++++++++++----
>  2 files changed, 36 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 00fda2e8e738..33244680d0d4 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -830,8 +830,17 @@ xlog_unmount_write(
>  	xfs_lsn_t		lsn;
>  	uint			flags = XLOG_UNMOUNT_TRANS;
>  	int			error;
> +	unsigned long		pflags;
>  
> +	/*
> +	 * xfs_log_reserve() allocates memory. This can lead to fs reclaim
> +	 * which may conflicts with the unmount process. To avoid that,
> +	 * disable fs reclaim for this allocation.
> +	 */
> +	current_set_flags_nested(&pflags, PF_MEMALLOC_NOFS);
>  	error = xfs_log_reserve(mp, 600, 1, &tic, XFS_LOG, 0);
> +	current_restore_flags_nested(&pflags, PF_MEMALLOC_NOFS);
> +
>  	if (error)
>  		goto out_err;

The more I look at this, the more I think Darrick is right and I
somewhat misinterpretted what he meant by "the top of the freeze
path".

i.e. setting PF_MEMALLOC_NOFS here is out of place - only one caller
of xlog_unmount_write requires PF_MEMALLOC_NOFS
context. That context should be set in the caller that requires this
context, and in this case it is xfs_fs_freeze(). This is top of the
final freeze state processing (what I think Darrick meant), not the
top of the freeze syscall call chain (what I thought he meant).

So if set PF_MEMALLOC_NOFS setting in xfs_fs_freeze(), it covers all
the allocations in this problematic path, and it should obliviates
the need for the first patch in the series altogether.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
