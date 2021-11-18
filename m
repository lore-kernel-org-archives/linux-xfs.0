Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E821FC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Nov 2021 23:15:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CAFEC61A86
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Nov 2021 23:15:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbhKRXS4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Nov 2021 18:18:56 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:48882 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229754AbhKRXS4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Nov 2021 18:18:56 -0500
Received: from dread.disaster.area (pa49-195-103-97.pa.nsw.optusnet.com.au [49.195.103.97])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id B96E8105E69F
        for <linux-xfs@vger.kernel.org>; Fri, 19 Nov 2021 10:15:54 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mnqdG-00ATjn-5t
        for linux-xfs@vger.kernel.org; Fri, 19 Nov 2021 10:15:54 +1100
Date:   Fri, 19 Nov 2021 10:15:54 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 00/14 v6] xfs: improve CIL scalability
Message-ID: <20211118231554.GY449541@dread.disaster.area>
References: <20211109015240.1547991-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211109015240.1547991-1-david@fromorbit.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=6196deaa
        a=fP9RlOTWD4uZJjPSFnn6Ew==:117 a=fP9RlOTWD4uZJjPSFnn6Ew==:17
        a=kj9zAlcOel0A:10 a=vIxV3rELxO4A:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=fcR5QpBUM8123QvTjT4A:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

FYI: I've just rebased the git tree branch containing this code
on the V7 version of the xlog_write() rework patch set I just
posted.

No changes to this series were made in the rebase.

Cheers,

Dave.

On Tue, Nov 09, 2021 at 12:52:26PM +1100, Dave Chinner wrote:
> Time to try again to get this code merged.
> 
> This series aims to improve the scalability of XFS transaction
> commits on large CPU count machines. My 32p machine hits contention
> limits in xlog_cil_commit() at about 700,000 transaction commits a
> section. It hits this at 16 thread workloads, and 32 thread
> workloads go no faster and just burn CPU on the CIL spinlocks.
> 
> This patchset gets rid of spinlocks and global serialisation points
> in the xlog_cil_commit() path. It does this by moving to a
> combination of per-cpu counters, unordered per-cpu lists and
> post-ordered per-cpu lists.
> 
> This results in transaction commit rates exceeding 1.6 million
> commits/s under unlink certain workloads, and while the log lock
> contention is largely gone there is still significant lock
> contention at the VFS at 600,000 transactions/s:
> 
>   19.39%  [kernel]  [k] __pv_queued_spin_lock_slowpath
>    6.40%  [kernel]  [k] do_raw_spin_lock
>    4.07%  [kernel]  [k] __raw_callee_save___pv_queued_spin_unlock
>    3.08%  [kernel]  [k] memcpy_erms
>    1.93%  [kernel]  [k] xfs_buf_find
>    1.69%  [kernel]  [k] xlog_cil_commit
>    1.50%  [kernel]  [k] syscall_exit_to_user_mode
>    1.18%  [kernel]  [k] memset_erms
> 
> 
> -   64.23%     0.22%  [kernel]            [k] path_openat
>    - 64.01% path_openat
>       - 48.69% xfs_vn_create
>          - 48.60% xfs_generic_create
>             - 40.96% xfs_create
>                - 20.39% xfs_dir_ialloc
>                   - 7.05% xfs_setup_inode
> >>>>>                - 6.87% inode_sb_list_add
>                         - 6.54% _raw_spin_lock
>                            - 6.53% do_raw_spin_lock
>                                 6.08% __pv_queued_spin_lock_slowpath
> .....
>                - 11.27% xfs_trans_commit
>                   - 11.23% __xfs_trans_commit
>                      - 10.85% xlog_cil_commit
>                           2.47% memcpy_erms
>                         - 1.77% xfs_buf_item_committing
>                            - 1.70% xfs_buf_item_release
>                               - 0.79% xfs_buf_unlock
>                                    0.68% up
>                                 0.61% xfs_buf_rele
>                           0.80% xfs_buf_item_format
>                           0.73% xfs_inode_item_format
>                           0.68% xfs_buf_item_size
>                         - 0.55% kmem_alloc_large
>                            - 0.55% kmem_alloc
>                                 0.52% __kmalloc
> .....
>             - 7.08% d_instantiate
>                - 6.66% security_d_instantiate
> >>>>>>            - 6.63% selinux_d_instantiate
>                      - 6.48% inode_doinit_with_dentry
>                         - 6.11% _raw_spin_lock
>                            - 6.09% do_raw_spin_lock
>                                 5.60% __pv_queued_spin_lock_slowpath
> ....
>       - 1.77% terminate_walk
> >>>>>>   - 1.69% dput
>             - 1.55% _raw_spin_lock
>                - do_raw_spin_lock
>                     1.19% __pv_queued_spin_lock_slowpath
> 
> 
> But when we extend out to 1.5M commits/s we see that the contention
> starts to shift to the atomics in the lockless log reservation path:
> 
>   14.81%  [kernel]  [k] __pv_queued_spin_lock_slowpath
>    7.88%  [kernel]  [k] xlog_grant_add_space
>    7.18%  [kernel]  [k] xfs_log_ticket_ungrant
>    4.82%  [kernel]  [k] do_raw_spin_lock
>    3.58%  [kernel]  [k] xlog_space_left
>    3.51%  [kernel]  [k] xlog_cil_commit
> 
> There's still substantial spin lock contention occurring at the VFS,
> too, but it's indicating that multiple atomic variable updates per
> transaction reservation/commit pair is starting to reach scalability
> limits here.
> 
> This is largely a re-implementation of a past RFC patchsets. While
> that were good enough proof of concept to perf test, they did not
> preserve transaction order correctly and failed shutdown tests all
> the time. The changes to the CIL accounting and behaviour, combined
> with the structural changes to xlog_write() in prior patchsets make
> the per-cpu restructuring possible and sane.
> 
> Instead of trying to account for continuation log opheaders on a
> "growth" basis, we pre-calculate how many iclogs we'll need to write
> out a maximally sized CIL checkpoint and just reserve that space one
> per commit until the CIL has a full reservation. If we ever run a
> commit when we are already at the hard limit (because
> post-throttling) we simply take an extra reservation from each
> commit that is run when over the limit. Hence we don't need to do
> space usage math in the fast path and so never need to sum the
> per-cpu counters in this path.
> 
> Similarly, per-cpu lists have the problem of ordering - we can't
> remove an item from a per-cpu list if we want to move it forward in
> the CIL. We solve this problem by using an atomic counter to give
> every commit a sequence number that is copied into the log items in
> that transaction. Hence relogging items just overwrites the sequence
> number in the log item, and does not move it in the per-cpu lists.
> Once we reaggregate the per-cpu lists back into a single list in the
> CIL push work, we can run it through list-sort() and reorder it back
> into a globally ordered list. This costs a bit of CPU time, but now
> that the CIL can run multiple works and pipelines properly, this is
> not a limiting factor for performance. It does increase fsync
> latency when the CIL is full, but workloads issuing large numbers of
> fsync()s or sync transactions end up with very small CILs and so the
> latency impact or sorting is not measurable for such workloads.
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git xfs-cil-scale-3
> 
> Version 6:
> - split out from aggregated patchset
> - rebase on linux-xfs/for-next + dgc/xlog-write-rework
> 
> Version 5:
> - https://lore.kernel.org/linux-xfs/20210603052240.171998-1-david@fromorbit.com/
> 
> 

-- 
Dave Chinner
david@fromorbit.com
