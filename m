Return-Path: <SRS0=cXLJ=75=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91236C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Jun 2020 16:32:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62C19208B3
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Jun 2020 16:32:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="w2JF/HtV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729852AbgFPQcP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Jun 2020 12:32:15 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51346 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729167AbgFPQcO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Jun 2020 12:32:14 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05GGRggB090207;
        Tue, 16 Jun 2020 16:32:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=iGPIvJn8jlhE50vAJGlUGCgtoy3/I45W7Z0/PlOasX0=;
 b=w2JF/HtVXhLwfJQ3TTg+ggbNkS8gFMJDDIvvcQYifD7udfPJy3JQa5+DwjE3bB9jIEU3
 qftzeZKhTHVNSFvJ95n5rxqbE8kFLvxFqvDzLdeu4Q7zXpReG/KNOgKtiSC7MjRbSz2Q
 Gi0m5k5AK5NJppR35UPEcHA0NrWc+B+Oa1Gd+KaH3aCMDR9xG1D4cdU8lbf0zmzDi4GW
 kF1bOBVjpE1FiGQoPoKhvkZQMCSCxndfTgUtX2RoAjSjMD14mbnhxp3tkfKyYF8uTl4a
 zl5ReyJBQi+jkGGqP3xA9SdID27nOyuJAr8TxWu36paOaoUPFFHICZliXpGGn/htagoa fQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 31p6e7yv80-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 16 Jun 2020 16:32:00 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05GGT38t144679;
        Tue, 16 Jun 2020 16:30:00 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 31p6dh2n50-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jun 2020 16:30:00 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05GGTwKo016199;
        Tue, 16 Jun 2020 16:29:58 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 16 Jun 2020 09:29:58 -0700
Date:   Tue, 16 Jun 2020 09:29:57 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Waiman Long <longman@redhat.com>
Cc:     Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>, Qian Cai <cai@lca.pw>,
        Eric Sandeen <sandeen@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] xfs: Fix false positive lockdep warning with
 sb_internal & fs_reclaim
Message-ID: <20200616162957.GO11245@magnolia>
References: <20200615160830.8471-1-longman@redhat.com>
 <20200615160830.8471-3-longman@redhat.com>
 <20200615164351.GF11255@magnolia>
 <2f03b074-4732-01e4-b0ff-482bb4bb44ce@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f03b074-4732-01e4-b0ff-482bb4bb44ce@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9654 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=5 adultscore=0 bulkscore=0
 phishscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006160117
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9654 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0
 impostorscore=0 bulkscore=0 clxscore=1015 malwarescore=0 suspectscore=5
 mlxscore=0 phishscore=0 mlxlogscore=999 lowpriorityscore=0
 cotscore=-2147483648 priorityscore=1501 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006160117
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 15, 2020 at 04:53:38PM -0400, Waiman Long wrote:
> On 6/15/20 12:43 PM, Darrick J. Wong wrote:
> > On Mon, Jun 15, 2020 at 12:08:30PM -0400, Waiman Long wrote:
> > > Depending on the workloads, the following circular locking dependency
> > > warning between sb_internal (a percpu rwsem) and fs_reclaim (a pseudo
> > > lock) may show up:
> > > 
> > > ======================================================
> > > WARNING: possible circular locking dependency detected
> > > 5.0.0-rc1+ #60 Tainted: G        W
> > > ------------------------------------------------------
> > > fsfreeze/4346 is trying to acquire lock:
> > > 0000000026f1d784 (fs_reclaim){+.+.}, at:
> > > fs_reclaim_acquire.part.19+0x5/0x30
> > > 
> > > but task is already holding lock:
> > > 0000000072bfc54b (sb_internal){++++}, at: percpu_down_write+0xb4/0x650
> > > 
> > > which lock already depends on the new lock.
> > >    :
> > >   Possible unsafe locking scenario:
> > > 
> > >         CPU0                    CPU1
> > >         ----                    ----
> > >    lock(sb_internal);
> > >                                 lock(fs_reclaim);
> > >                                 lock(sb_internal);
> > >    lock(fs_reclaim);
> > > 
> > >   *** DEADLOCK ***
> > > 
> > > 4 locks held by fsfreeze/4346:
> > >   #0: 00000000b478ef56 (sb_writers#8){++++}, at: percpu_down_write+0xb4/0x650
> > >   #1: 000000001ec487a9 (&type->s_umount_key#28){++++}, at: freeze_super+0xda/0x290
> > >   #2: 000000003edbd5a0 (sb_pagefaults){++++}, at: percpu_down_write+0xb4/0x650
> > >   #3: 0000000072bfc54b (sb_internal){++++}, at: percpu_down_write+0xb4/0x650
> > > 
> > > stack backtrace:
> > > Call Trace:
> > >   dump_stack+0xe0/0x19a
> > >   print_circular_bug.isra.10.cold.34+0x2f4/0x435
> > >   check_prev_add.constprop.19+0xca1/0x15f0
> > >   validate_chain.isra.14+0x11af/0x3b50
> > >   __lock_acquire+0x728/0x1200
> > >   lock_acquire+0x269/0x5a0
> > >   fs_reclaim_acquire.part.19+0x29/0x30
> > >   fs_reclaim_acquire+0x19/0x20
> > >   kmem_cache_alloc+0x3e/0x3f0
> > >   kmem_zone_alloc+0x79/0x150
> > >   xfs_trans_alloc+0xfa/0x9d0
> > >   xfs_sync_sb+0x86/0x170
> > >   xfs_log_sbcount+0x10f/0x140
> > >   xfs_quiesce_attr+0x134/0x270
> > >   xfs_fs_freeze+0x4a/0x70
> > >   freeze_super+0x1af/0x290
> > >   do_vfs_ioctl+0xedc/0x16c0
> > >   ksys_ioctl+0x41/0x80
> > >   __x64_sys_ioctl+0x73/0xa9
> > >   do_syscall_64+0x18f/0xd23
> > >   entry_SYSCALL_64_after_hwframe+0x49/0xbe
> > > 
> > > This is a false positive as all the dirty pages are flushed out before
> > > the filesystem can be frozen.
> > > 
> > > Perhaps breaking the fs_reclaim pseudo lock into a per filesystem lock
> > > may fix the issue. However, that will greatly complicate the logic and
> > > may not be worth it.
> > > 
> > > Another way to fix it is to disable the taking of the fs_reclaim
> > > pseudo lock when in the freezing code path as a reclaim on the
> > > freezed filesystem is not possible. By using the newly introduced
> > > PF_MEMALLOC_NOLOCKDEP flag, lockdep checking is disabled in
> > > xfs_trans_alloc() if XFS_TRANS_NO_WRITECOUNT flag is set.
> > > 
> > > In the freezing path, there is another path where memory allocation
> > > is being done without the XFS_TRANS_NO_WRITECOUNT flag:
> > > 
> > >    xfs_fs_freeze()
> > >    => xfs_quiesce_attr()
> > >       => xfs_log_quiesce()
> > >          => xfs_log_unmount_write()
> > >             => xlog_unmount_write()
> > >                => xfs_log_reserve()
> > > 	         => xlog_ticket_alloc()
> > > 
> > > In this case, we just disable fs reclaim for this particular 600 bytes
> > > memory allocation.
> > > 
> > > Without this patch, the command sequence below will show that the lock
> > > dependency chain sb_internal -> fs_reclaim exists.
> > > 
> > >   # fsfreeze -f /home
> > >   # fsfreeze --unfreeze /home
> > >   # grep -i fs_reclaim -C 3 /proc/lockdep_chains | grep -C 5 sb_internal
> > > 
> > > After applying the patch, such sb_internal -> fs_reclaim lock dependency
> > > chain can no longer be found. Because of that, the locking dependency
> > > warning will not be shown.
> > > 
> > > Suggested-by: Dave Chinner <david@fromorbit.com>
> > > Signed-off-by: Waiman Long <longman@redhat.com>
> > > ---
> > >   fs/xfs/xfs_log.c   |  9 +++++++++
> > >   fs/xfs/xfs_trans.c | 30 ++++++++++++++++++++++++++----
> > >   2 files changed, 35 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > > index 00fda2e8e738..33244680d0d4 100644
> > > --- a/fs/xfs/xfs_log.c
> > > +++ b/fs/xfs/xfs_log.c
> > > @@ -830,8 +830,17 @@ xlog_unmount_write(
> > >   	xfs_lsn_t		lsn;
> > >   	uint			flags = XLOG_UNMOUNT_TRANS;
> > >   	int			error;
> > > +	unsigned long		pflags;
> > > +	/*
> > > +	 * xfs_log_reserve() allocates memory. This can lead to fs reclaim
> > > +	 * which may conflicts with the unmount process. To avoid that,
> > > +	 * disable fs reclaim for this allocation.
> > > +	 */
> > > +	current_set_flags_nested(&pflags, PF_MEMALLOC_NOFS);
> > >   	error = xfs_log_reserve(mp, 600, 1, &tic, XFS_LOG, 0);
> > > +	current_restore_flags_nested(&pflags, PF_MEMALLOC_NOFS);
> > > +
> > >   	if (error)
> > >   		goto out_err;
> > > diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> > > index 3c94e5ff4316..ddb10ad3f51f 100644
> > > --- a/fs/xfs/xfs_trans.c
> > > +++ b/fs/xfs/xfs_trans.c
> > > @@ -255,7 +255,27 @@ xfs_trans_alloc(
> > >   	struct xfs_trans	**tpp)
> > >   {
> > >   	struct xfs_trans	*tp;
> > > -	int			error;
> > > +	int			error = 0;
> > > +	unsigned long		pflags = -1;
> > > +
> > > +	/*
> > > +	 * When XFS_TRANS_NO_WRITECOUNT is set, it means there are no dirty
> > > +	 * data pages in the filesystem at this point.
> > That's not true.  Look at the other callers of xfs_trans_alloc_empty.
> Yes, I am aware of that. I can change it to check the freeze state.

<nod>

> > Also: Why not set PF_MEMALLOC_NOFS at the start of the freeze call
> > chain?
> 
> I guess we can do that, but it eliminates a potential source for memory
> reclaim leading to freeze error when not much free memory is left. We can go
> this route if you think this is not a problem.

<shrug> It sounds like you & Dave had already worked that out, so we can
leave this as it is.  I saw the untrue claim in the code comment and
started asking more questions. ;)

(Says me who has been checked out the last few days, not following
the various lockdep shuttup patch threads...)

--D

> Cheers,
> Longman
> 
