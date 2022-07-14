Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12ADBC43334
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Jul 2022 07:17:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbiGNHQ7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Jul 2022 03:16:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231887AbiGNHQ4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Jul 2022 03:16:56 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E2DC0193FB
        for <linux-xfs@vger.kernel.org>; Thu, 14 Jul 2022 00:16:52 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id DB9BE10E8022;
        Thu, 14 Jul 2022 17:16:51 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oBt5e-000hnS-P8; Thu, 14 Jul 2022 17:16:50 +1000
Date:   Thu, 14 Jul 2022 17:16:50 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: [GIT PULL] xfs: lockless buffer cache lookups
Message-ID: <20220714071650.GR3861211@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62cfc2e3
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=RgO8CyIxsXoA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=Kn_GP7nZMMIQIozp12oA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick,

Can you please pull the new lockless buffer cache lookup code from
the tag below? THis contains all the little remaining cleanups
(rvbs, typos, etc) I've made since the last version posted to the
list. It merges cleanly against a current for-next tree, with out
without the iunlink item branch merged into it.

Cheers,

Dave.

------

The following changes since commit 7561cea5dbb97fecb952548a0fb74fb105bf4664:

  xfs: prevent a UAF when log IO errors race with unmount (2022-07-01 09:09:52 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs tags/xfs-buf-lockless-lookup-5.20

for you to fetch changes up to 298f342245066309189d8637ca7339d56840c3e1:

  xfs: lockless buffer lookup (2022-07-14 12:05:07 +1000)

----------------------------------------------------------------
xfs: lockless buffer cache lookups

Current work to merge the XFS inode life cycle with the VFS inode
life cycle is finding some interesting issues. If we have a path
that hits buffer trylocks fairly hard (e.g. a non-blocking
background inode freeing function), we end up hitting massive
contention on the buffer cache hash locks:

-   92.71%     0.05%  [kernel]                  [k] xfs_inodegc_worker
   - 92.67% xfs_inodegc_worker
      - 92.13% xfs_inode_unlink
         - 91.52% xfs_inactive_ifree
            - 85.63% xfs_read_agi
               - 85.61% xfs_trans_read_buf_map
                  - 85.59% xfs_buf_read_map
                     - xfs_buf_get_map
                        - 85.55% xfs_buf_find
                           - 72.87% _raw_spin_lock
                              - do_raw_spin_lock
                                   71.86% __pv_queued_spin_lock_slowpath
                           - 8.74% xfs_buf_rele
                              - 7.88% _raw_spin_lock
                                 - 7.88% do_raw_spin_lock
                                      7.63% __pv_queued_spin_lock_slowpath
                           - 1.70% xfs_buf_trylock
                              - 1.68% down_trylock
                                 - 1.41% _raw_spin_lock_irqsave
                                    - 1.39% do_raw_spin_lock
                                         __pv_queued_spin_lock_slowpath
                           - 0.76% _raw_spin_unlock
                                0.75% do_raw_spin_unlock

This is basically hammering the pag->pag_buf_lock from lots of CPUs
doing trylocks at the same time. Most of the buffer trylock
operations ultimately fail after we've done the lookup, so we're
really hammering the buf hash lock whilst making no progress.

We can also see significant spinlock traffic on the same lock just
under normal operation when lots of tasks are accessing metadata
from the same AG, so let's avoid all this by creating a lookup fast
path which leverages the rhashtable's ability to do RCU protected
lookups.

Signed-off-by: Dave Chinner <dchinner@redhat.com>

----------------------------------------------------------------
Dave Chinner (6):
      xfs: rework xfs_buf_incore() API
      xfs: break up xfs_buf_find() into individual pieces
      xfs: merge xfs_buf_find() and xfs_buf_get_map()
      xfs: reduce the number of atomic when locking a buffer after lookup
      xfs: remove a superflous hash lookup when inserting new buffers
      xfs: lockless buffer lookup

 fs/xfs/libxfs/xfs_attr_remote.c |  15 ++++--
 fs/xfs/scrub/repair.c           |  15 +++---
 fs/xfs/xfs_buf.c                | 263 +++++++++++++++++++++++++++++++++++++++++++++++++++++------------------------------------------
 fs/xfs/xfs_buf.h                |  21 ++++++--
 fs/xfs/xfs_qm.c                 |   9 ++--
 5 files changed, 188 insertions(+), 135 deletions(-)

-- 
Dave Chinner
david@fromorbit.com
