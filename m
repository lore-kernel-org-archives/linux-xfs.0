Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A480BCCA480
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jun 2022 07:53:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245355AbiFOHxl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jun 2022 03:53:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343550AbiFOHxi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jun 2022 03:53:38 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 11F6341335
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jun 2022 00:53:37 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 404BD10E74F9
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jun 2022 17:53:34 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o1NqG-006rR2-HC
        for linux-xfs@vger.kernel.org; Wed, 15 Jun 2022 17:53:32 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1o1NqG-00FJxV-Fr
        for linux-xfs@vger.kernel.org;
        Wed, 15 Jun 2022 17:53:32 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 00/14 v8] xfs: improve CIL scalability
Date:   Wed, 15 Jun 2022 17:53:16 +1000
Message-Id: <20220615075330.3651541-1-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62a98ffe
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=JPEYwPQDsx4A:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=OzqxrxPJ0V4mudwBAf0A:9 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
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

Instead of trying to account for continuation log opheaders on a
"growth" basis, we pre-calculate how many iclogs we'll need to write
out a maximally sized CIL checkpoint and just reserve that space one
per commit until the CIL has a full reservation. If we ever run a
commit when we are already at the hard limit (because
post-throttling) we simply take an extra reservation from each
commit that is run when over the limit. Hence we don't need to do
space usage math in the fast path and so never need to sum the
per-cpu counters in this path.

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

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git xfs-cil-scale-3

Version 8:
- rebase on 5.19-rc2

Version 7:
- not published.
- fixed per-emption bug when sampling first CIL context reservation after
  clearing XLOG_CIL_EMPTY. Pre-emption between clearing and sampling could
  result in other racing updates modifying t_unit_res and so the ctx_res could
  be larger than the reservations of the transaction being committed leading to
  transaction overrun and shutdown.
- fixed a percpu used space accounting bug where folding used the hard limit
  instead of the soft limit for the per-cpu proportion of the space used. This
  could lead to context ticket overruns.
- fixed hard limit overrun detection for extra reservations to check the push
  waitqueue to capture cases where log space is freed by a transaction commit.
  This could lead to context ticket overruns.

Version 6:
- https://lore.kernel.org/linux-xfs/20211109015240.1547991-1-david@fromorbit.com/
- split out from aggregated patchset
- rebase on linux-xfs/for-next + dgc/xlog-write-rework

Version 5:
- https://lore.kernel.org/linux-xfs/20210603052240.171998-1-david@fromorbit.com/

