Return-Path: <SRS0=Ng9j=2Z=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EBCFC00523
	for <linux-xfs@archiver.kernel.org>; Sat,  4 Jan 2020 02:37:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 490C52464B
	for <linux-xfs@archiver.kernel.org>; Sat,  4 Jan 2020 02:37:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727194AbgADChF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Jan 2020 21:37:05 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:42361 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727074AbgADChF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Jan 2020 21:37:05 -0500
Received: from dread.disaster.area (pa49-180-68-255.pa.nsw.optusnet.com.au [49.180.68.255])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id BA89C7EA31B;
        Sat,  4 Jan 2020 13:36:59 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1inZJB-0007xP-34; Sat, 04 Jan 2020 13:36:57 +1100
Date:   Sat, 4 Jan 2020 13:36:57 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Waiman Long <longman@redhat.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Qian Cai <cai@lca.pw>, Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] xfs: Fix false positive lockdep warning with sb_internal
 & fs_reclaim
Message-ID: <20200104023657.GA23128@dread.disaster.area>
References: <20200102155208.8977-1-longman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200102155208.8977-1-longman@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=sbdTpStuSq8iNQE8viVliQ==:117 a=sbdTpStuSq8iNQE8viVliQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=Jdjhy38mL1oA:10
        a=7-415B0cAAAA:8 a=dPlFEQSpBE27FshsoEkA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 02, 2020 at 10:52:08AM -0500, Waiman Long wrote:
> Depending on the workloads, the following circular locking dependency
> warning between sb_internal (a percpu rwsem) and fs_reclaim (a pseudo
> lock) may show up:
> 
> ======================================================
> WARNING: possible circular locking dependency detected
> 5.0.0-rc1+ #60 Tainted: G        W
> ------------------------------------------------------
> fsfreeze/4346 is trying to acquire lock:
> 0000000026f1d784 (fs_reclaim){+.+.}, at:
> fs_reclaim_acquire.part.19+0x5/0x30
> 
> but task is already holding lock:
> 0000000072bfc54b (sb_internal){++++}, at: percpu_down_write+0xb4/0x650
> 
> which lock already depends on the new lock.
>   :
>  Possible unsafe locking scenario:
> 
>        CPU0                    CPU1
>        ----                    ----
>   lock(sb_internal);
>                                lock(fs_reclaim);
>                                lock(sb_internal);
>   lock(fs_reclaim);
> 
>  *** DEADLOCK ***
> 
> 4 locks held by fsfreeze/4346:
>  #0: 00000000b478ef56 (sb_writers#8){++++}, at: percpu_down_write+0xb4/0x650
>  #1: 000000001ec487a9 (&type->s_umount_key#28){++++}, at: freeze_super+0xda/0x290
>  #2: 000000003edbd5a0 (sb_pagefaults){++++}, at: percpu_down_write+0xb4/0x650
>  #3: 0000000072bfc54b (sb_internal){++++}, at: percpu_down_write+0xb4/0x650
> 
> stack backtrace:
> Call Trace:
>  dump_stack+0xe0/0x19a
>  print_circular_bug.isra.10.cold.34+0x2f4/0x435
>  check_prev_add.constprop.19+0xca1/0x15f0
>  validate_chain.isra.14+0x11af/0x3b50
>  __lock_acquire+0x728/0x1200
>  lock_acquire+0x269/0x5a0
>  fs_reclaim_acquire.part.19+0x29/0x30
>  fs_reclaim_acquire+0x19/0x20
>  kmem_cache_alloc+0x3e/0x3f0
>  kmem_zone_alloc+0x79/0x150
>  xfs_trans_alloc+0xfa/0x9d0
>  xfs_sync_sb+0x86/0x170
>  xfs_log_sbcount+0x10f/0x140
>  xfs_quiesce_attr+0x134/0x270
>  xfs_fs_freeze+0x4a/0x70
>  freeze_super+0x1af/0x290
>  do_vfs_ioctl+0xedc/0x16c0
>  ksys_ioctl+0x41/0x80
>  __x64_sys_ioctl+0x73/0xa9
>  do_syscall_64+0x18f/0xd23
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 
> According to Dave Chinner:
> 
>   Freezing the filesystem, after all the data has been cleaned. IOWs
>   memory reclaim will never run the above writeback path when
>   the freeze process is trying to allocate a transaction here because
>   there are no dirty data pages in the filesystem at this point.
> 
>   Indeed, this xfs_sync_sb() path sets XFS_TRANS_NO_WRITECOUNT so that
>   it /doesn't deadlock/ by taking freeze references for the
>   transaction. We've just drained all the transactions
>   in progress and written back all the dirty metadata, too, and so the
>   filesystem is completely clean and only needs the superblock to be
>   updated to complete the freeze process. And to do that, it does not
>   take a freeze reference because calling sb_start_intwrite() here
>   would deadlock.
> 
>   IOWs, this is a false positive, caused by the fact that
>   xfs_trans_alloc() is called from both above and below memory reclaim
>   as well as within /every level/ of freeze processing. Lockdep is
>   unable to describe the staged flush logic in the freeze process that
>   prevents deadlocks from occurring, and hence we will pretty much
>   always see false positives in the freeze path....
> 
> Perhaps breaking the fs_reclaim pseudo lock into a per filesystem lock
> may fix the issue. However, that will greatly complicate the logic and
> may not be worth it.

ANd it won't work, because now we'll just get lockedp warnings on
the per-fs reclaim lockdep context.

> Another way to fix it is to disable the taking of the fs_reclaim
> pseudo lock when in the freezing code path as a reclaim on the freezed
> filesystem is not possible as stated above. This patch takes this
> approach by setting the __GFP_NOLOCKDEP flag in the slab memory
> allocation calls when the filesystem has been freezed.

IOWs, "fix" it by stating that "lockdep can't track freeze
dependencies correctly"?

In the past we have just used KM_NOFS for that, because
__GFP_NOLOCKDEP didn't exist. But that has just been a nasty hack
because lockdep isn't capable of understanding allocation context
constraints because allocation contexts are much more complex than a
"lock"....


> --- a/fs/xfs/kmem.h
> +++ b/fs/xfs/kmem.h
> @@ -20,6 +20,12 @@ typedef unsigned __bitwise xfs_km_flags_t;
>  #define KM_MAYFAIL	((__force xfs_km_flags_t)0x0008u)
>  #define KM_ZERO		((__force xfs_km_flags_t)0x0010u)
>  
> +#ifdef CONFIG_LOCKDEP
> +#define KM_NOLOCKDEP	((__force xfs_km_flags_t)0x0020u)
> +#else
> +#define KM_NOLOCKDEP	((__force xfs_km_flags_t)0)
> +#endif

Nope. We are getting rid of kmem_alloc wrappers and all the
associated flags, not adding new ones. Part of that process is
identifying all the places we currently use KM_NOFS to "shut up
lockdep" and converting them to explicit __GFP_NOLOCKDEP flags.

So right now, this change needs to be queued up behind the API
changes that are currently in progress...

> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index f6006d94a581..b1997649ecd8 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -454,7 +454,8 @@ xfs_log_reserve(
>  	XFS_STATS_INC(mp, xs_try_logspace);
>  
>  	ASSERT(*ticp == NULL);
> -	tic = xlog_ticket_alloc(log, unit_bytes, cnt, client, permanent, 0);
> +	tic = xlog_ticket_alloc(log, unit_bytes, cnt, client, permanent,
> +			mp->m_super->s_writers.frozen ? KM_NOLOCKDEP : 0);

This is pretty nasty. Having to spew conditional code like this
across every allocation that could be done in freeze conditions is
a non-starter.

We already have a flag to tell us we are doing a transaction in a
freeze state, so use that to turn off lockdep. That is:

>  	*ticp = tic;
>  
>  	xlog_grant_push_ail(log, tic->t_cnt ? tic->t_unit_res * tic->t_cnt
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 3b208f9a865c..c0e42e4f5b77 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -262,8 +262,14 @@ xfs_trans_alloc(
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
>  		sb_start_intwrite(mp->m_super);

This code here should be setting PF_GFP_NOLOCKDEP state to turn off
lockdep for all allocations in this context, similar to the way we
use memalloc_nofs_save/restore so that all nested allocations
inherit GFP_NOFS state...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
