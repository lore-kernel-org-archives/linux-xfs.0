Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACAE3C4332B
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 03:38:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B3EB64EDD
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 03:38:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232870AbhBYDiO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Feb 2021 22:38:14 -0500
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:60185 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232744AbhBYDiJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Feb 2021 22:38:09 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 1EF354816E
        for <linux-xfs@vger.kernel.org>; Thu, 25 Feb 2021 14:37:27 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lF7Sw-0038Ab-8Z
        for linux-xfs@vger.kernel.org; Thu, 25 Feb 2021 14:37:26 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lF7Sv-00Evj5-Uq
        for linux-xfs@vger.kernel.org; Thu, 25 Feb 2021 14:37:26 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 00/12] xfs: Improve CIL scalability
Date:   Thu, 25 Feb 2021 14:37:13 +1100
Message-Id: <20210225033725.3558450-1-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=qa6Q16uM49sA:10 a=URmZzcK003UqtAgA6nYA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This series aims to improve the scalability of XFS transaction
commits on large CPU count machines. My 32p machine hits contention
limits in xlog_cil_commit() at about 700,000 transaction commits a
section. It hits this at 16 thread workloads, and 32 thread
workloads go no faster and just burn CPU on the CIL spinlocks.

This patchset gets rid of spinlocks and global serialisation points
in the xlog_cil_commit() path. It does this by moving to a
combination of per-cpu counters, unordered per-cpu lists and
post-ordered per-cpu lists.

This results in transaction commit rates exceeding 1.6 million
commits/s under unlink certain workloads, and while the log lock
contention is largely gone there is still significant lock
contention at the VFS at 600,000 transactions/s:

  19.39%  [kernel]  [k] __pv_queued_spin_lock_slowpath
   6.40%  [kernel]  [k] do_raw_spin_lock
   4.07%  [kernel]  [k] __raw_callee_save___pv_queued_spin_unlock
   3.08%  [kernel]  [k] memcpy_erms
   1.93%  [kernel]  [k] xfs_buf_find
   1.69%  [kernel]  [k] xlog_cil_commit
   1.50%  [kernel]  [k] syscall_exit_to_user_mode
   1.18%  [kernel]  [k] memset_erms


-   64.23%     0.22%  [kernel]            [k] path_openat
   - 64.01% path_openat
      - 48.69% xfs_vn_create
         - 48.60% xfs_generic_create
            - 40.96% xfs_create
               - 20.39% xfs_dir_ialloc
                  - 7.05% xfs_setup_inode
>>>>>                - 6.87% inode_sb_list_add
                        - 6.54% _raw_spin_lock
                           - 6.53% do_raw_spin_lock
                                6.08% __pv_queued_spin_lock_slowpath
.....
               - 11.27% xfs_trans_commit
                  - 11.23% __xfs_trans_commit
                     - 10.85% xlog_cil_commit
                          2.47% memcpy_erms
                        - 1.77% xfs_buf_item_committing
                           - 1.70% xfs_buf_item_release
                              - 0.79% xfs_buf_unlock
                                   0.68% up
                                0.61% xfs_buf_rele
                          0.80% xfs_buf_item_format
                          0.73% xfs_inode_item_format
                          0.68% xfs_buf_item_size
                        - 0.55% kmem_alloc_large
                           - 0.55% kmem_alloc
                                0.52% __kmalloc
.....
            - 7.08% d_instantiate
               - 6.66% security_d_instantiate
>>>>>>            - 6.63% selinux_d_instantiate
                     - 6.48% inode_doinit_with_dentry
                        - 6.11% _raw_spin_lock
                           - 6.09% do_raw_spin_lock
                                5.60% __pv_queued_spin_lock_slowpath
....
      - 1.77% terminate_walk
>>>>>>   - 1.69% dput
            - 1.55% _raw_spin_lock
               - do_raw_spin_lock
                    1.19% __pv_queued_spin_lock_slowpath


But when we extend out to 1.5M commits/s we see that the contention
starts to shift to the atomics in the lockless log reservation path:

  14.81%  [kernel]  [k] __pv_queued_spin_lock_slowpath
   7.88%  [kernel]  [k] xlog_grant_add_space
   7.18%  [kernel]  [k] xfs_log_ticket_ungrant
   4.82%  [kernel]  [k] do_raw_spin_lock
   3.58%  [kernel]  [k] xlog_space_left
   3.51%  [kernel]  [k] xlog_cil_commit

There's still substantial spin lock contention occurring at the VFS,
too, but it's indicating that multiple atomic variable updates per
transaction reservation/commit pair is starting to reach scalability
limits here.

This is largely a re-implementation of a past RFC patchsets. While
that were good enough proof of concept to perf test, they did not
preserve transaction order correctly and failed shutdown tests all
the time. The changes to the CIL accounting and behaviour, combined
with the structural changes to xlog_write() in prior patchsets make
the per-cpu restructuring possible and sane.

Instead of trying to account for continuation log opheaders on a "growth" basis,
we pre-calculate how many iclogs we'll need to write out a maximally
sized CIL checkpoint and just reserve that space one per commit
until the CIL has a full reservation. If we ever run a commit when
we are already at the hard limit (because post-throttling) we simply
take an extra reservation from each commit that is run when over the
limit. Hence we don't need to do space usage math in the fast path
and so never need to sum the per-cpu counters in this path.

Similarly, per-cpu lists have the problem of ordering - we can't
remove an item from a per-cpu list if we want to move it forward in
the CIL. We solve this problem by using an atomic counter to give
every commit a sequence number that is copied into the log items in
that transaction. Hence relogging items just overwrites the sequence
number in the log item, and does not move it in the per-cpu lists.
Once we reaggregate the per-cpu lists back into a single list in the
CIL push work, we can run it through list-sort() and reorder it back
into a globally ordered list. This costs a bit of CPU time, but now
that the CIL can run multiple works and pipelines properly, this is
not a limiting factor for performance. It does increase fsync
latency when the CIL is full, but workloads issuing large numbers of
fsync()s or sync transactions end up with very small CILs and so the
latency impact or sorting is not measurable for such workloads.

This seems to be solid so far. It passes fstests on top of all the
patchsets that it is built on and I've posted in the past couple of
days. The performance is good, but largely limited now by VFS lock
contention issues that are outside the scope of this work.

Thoughts, comments?

-Dave.


Dave Chinner (12):
  xfs: use the CIL space used counter for emptiness checks
  xfs: lift init CIL reservation out of xc_cil_lock
  xfs: rework per-iclog header CIL reservation
  xfs: introduce per-cpu CIL tracking sructure
  xfs: implement percpu cil space used calculation
  xfs: track CIL ticket reservation in percpu structure
  xfs: convert CIL busy extents to per-cpu
  xfs: Add order IDs to log items in CIL
  xfs: convert CIL to unordered per cpu lists
  xfs: move CIL ordering to the logvec chain
  xfs: __percpu_counter_compare() inode count debug too expensive
  xfs: avoid cil push lock if possible

 fs/xfs/libxfs/xfs_log_rlimit.c |   2 +-
 fs/xfs/libxfs/xfs_shared.h     |   3 +-
 fs/xfs/xfs_log.c               |  55 +++--
 fs/xfs/xfs_log.h               |   3 +-
 fs/xfs/xfs_log_cil.c           | 388 +++++++++++++++++++++++++--------
 fs/xfs/xfs_log_priv.h          |  48 ++--
 fs/xfs/xfs_trans.c             |  15 +-
 fs/xfs/xfs_trans.h             |   1 +
 fs/xfs/xfs_trans_priv.h        |   4 +-
 include/linux/cpuhotplug.h     |   1 +
 10 files changed, 380 insertions(+), 140 deletions(-)

-- 
2.28.0

