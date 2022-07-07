Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47559C433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Jul 2022 23:33:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236418AbiGGXdw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Jul 2022 19:33:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236397AbiGGXdw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Jul 2022 19:33:52 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2DFE325284
        for <linux-xfs@vger.kernel.org>; Thu,  7 Jul 2022 16:33:50 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 4629962C359;
        Fri,  8 Jul 2022 09:33:49 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o9b0F-00FoJ7-0c; Fri, 08 Jul 2022 09:33:47 +1000
Date:   Fri, 8 Jul 2022 09:33:47 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: [GIT PULL] xfs: Improve CIL scalability
Message-ID: <20220707233347.GO227878@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=OJNEYQWB c=1 sm=1 tr=0 ts=62c76d5d
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=RgO8CyIxsXoA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=21Fjjr3P_AKPwVoFQHIA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick,

Can you please pull the CIL scalability improvements for 5.20 from
the tag below? This branch is based on the linux-xfs/for-next branch
as of 2 days ago, so should apply without any merge issues at all.

Cheers,

Dave.

The following changes since commit 7561cea5dbb97fecb952548a0fb74fb105bf4664:

  xfs: prevent a UAF when log IO errors race with unmount (2022-07-01 09:09:52 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs tags/xfs-cil-scale-5.20

for you to fetch changes up to 51a117edff133a1ea8cb0fcbc599b8d5a34414e9:

  xfs: expanding delayed logging design with background material (2022-07-07 18:56:09 +1000)

----------------------------------------------------------------
xfs: improve CIL scalability

This series aims to improve the scalability of XFS transaction
commits on large CPU count machines. My 32p machine hits contention
limits in xlog_cil_commit() at about 700,000 transaction commits a
section. It hits this at 16 thread workloads, and 32 thread
workloads go no faster and just burn CPU on the CIL spinlocks.

This patchset gets rid of spinlocks and global serialisation points
in the xlog_cil_commit() path. It does this by moving to a
combination of per-cpu counters, unordered per-cpu lists and
post-ordered per-cpu lists.

This results in transaction commit rates exceeding 1.4 million
commits/s under unlink certain workloads, and while the log lock
contention is largely gone there is still significant lock
contention in the VFS (dentry cache, inode cache and security layers)
at >600,000 transactions/s that still limit scalability.

The changes to the CIL accounting and behaviour, combined with the
structural changes to xlog_write() in prior patchsets make the
per-cpu restructuring possible and sane. This allows us to move to
precalculated reservation requirements that allow for reservation
stealing to be accounted across multiple CPUs accurately.

That is, instead of trying to account for continuation log opheaders
on a "growth" basis, we pre-calculate how many iclogs we'll need to
write out a maximally sized CIL checkpoint and steal that reserveD
that space one commit at a time until the CIL has a full
reservation. If we ever run a commit when we are already at the hard
limit (because post-throttling) we simply take an extra reservation
from each commit that is run when over the limit. Hence we don't
need to do space usage math in the fast path and so never need to
sum the per-cpu counters in this fast path.

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

OVerall, this pushes the transaction commit bottleneck out to the
lockless reservation grant head updates. These atomic updates don't
start to be a limiting fact until > 1.5 million transactions/s are
being run, at which point the accounting functions start to show up
in profiles as the highest CPU users. Still, this series doubles
transaction throughput without increasing CPU usage before we get
to that cacheline contention breakdown point...
`
Signed-off-by: Dave Chinner <dchinner@redhat.com>

----------------------------------------------------------------
Dave Chinner (14):
      xfs: use the CIL space used counter for emptiness checks
      xfs: lift init CIL reservation out of xc_cil_lock
      xfs: rework per-iclog header CIL reservation
      xfs: introduce per-cpu CIL tracking structure
      xfs: implement percpu cil space used calculation
      xfs: track CIL ticket reservation in percpu structure
      xfs: convert CIL busy extents to per-cpu
      xfs: Add order IDs to log items in CIL
      xfs: convert CIL to unordered per cpu lists
      xfs: convert log vector chain to use list heads
      xfs: move CIL ordering to the logvec chain
      xfs: avoid cil push lock if possible
      xfs: xlog_sync() manually adjusts grant head space
      xfs: expanding delayed logging design with background material

 Documentation/filesystems/xfs-delayed-logging-design.rst | 361 +++++++++++++++++++++++++++++++++++++++++++++++------
 fs/xfs/xfs_log.c                                         |  55 ++++++---
 fs/xfs/xfs_log.h                                         |   3 +-
 fs/xfs/xfs_log_cil.c                                     | 472 +++++++++++++++++++++++++++++++++++++++++++++++++++++-----------------
 fs/xfs/xfs_log_priv.h                                    |  58 ++++++---
 fs/xfs/xfs_super.c                                       |   1 +
 fs/xfs/xfs_trans.c                                       |   4 +-
 fs/xfs/xfs_trans.h                                       |   1 +
 fs/xfs/xfs_trans_priv.h                                  |   3 +-
 9 files changed, 768 insertions(+), 190 deletions(-)

-- 
Dave Chinner
david@fromorbit.com
