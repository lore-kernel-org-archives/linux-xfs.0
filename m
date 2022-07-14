Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A65A3C43334
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Jul 2022 07:12:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231127AbiGNHMF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Jul 2022 03:12:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230038AbiGNHMF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Jul 2022 03:12:05 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 97A9C2DAB1
        for <linux-xfs@vger.kernel.org>; Thu, 14 Jul 2022 00:12:03 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 1403762C8BC;
        Thu, 14 Jul 2022 17:12:02 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oBt0y-000hjR-DB; Thu, 14 Jul 2022 17:12:00 +1000
Date:   Thu, 14 Jul 2022 17:12:00 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: [GIT PULL] xfs: in-memory iunlink log items
Message-ID: <20220714071200.GQ3861211@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=OJNEYQWB c=1 sm=1 tr=0 ts=62cfc1c2
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=RgO8CyIxsXoA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=I1SXNrbl4yWeo68eQgIA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick,

Can you please pull the new iunlink item functionality from the tag
below? The branch contains all the remaining little cleanups (rvb
tags, typo fixes, etc) and it also contains the iunlink recovery vs
inodegc fix from Zhang Yi which I then rebased the series on top of.

It merged cleanly with the current for-next tree, so I don't
anticipate any problems pulling it straight in.

Cheers,

Dave.

------

The following changes since commit 36029dee382a20cf515494376ce9f0d5949944eb:

  xfs: make is_log_ag() a first class helper (2022-07-07 19:13:21 +1000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs tags/xfs-iunlink-item-5.20

for you to fetch changes up to 784eb7d8dd4163b82a19b914f76b2834a58a3e4c:

  xfs: add in-memory iunlink log item (2022-07-14 11:47:42 +1000)

----------------------------------------------------------------
xfs: introduce in-memory inode unlink log items

To facilitate future improvements in inode logging and improving
inode cluster buffer locking order consistency, we need a new
mechanism for defering inode cluster buffer modifications during
unlinked list modifications.

The unlinked inode list buffer locking is complex. The unlinked
list is unordered - we add to the tail, remove from where-ever the
inode is in the list. Hence we might need to lock two inode buffers
here (previous inode in list and the one being removed). While we
can order the locking of these buffers correctly within the confines
of the unlinked list, there may be other inodes that need buffer
locking in the same transaction. e.g. O_TMPFILE being linked into a
directory also modifies the directory inode.

Hence we need a mechanism for defering unlinked inode list updates
until a point where we know that all modifications have been made
and all that remains is to lock and modify the cluster buffers.

We can do this by first observing that we serialise unlinked list
modifications by holding the AGI buffer lock. IOWs, the AGI is going
to be locked until the transaction commits any time we modify the
unlinked list. Hence it doesn't matter when in the unlink
transactions that we actually load, lock and modify the inode
cluster buffer.

We add an in-memory unlinked inode log item to defer the inode
cluster buffer update to transaction commit time where it can be
ordered with all the other inode cluster operations that need to be
done. Essentially all we need to do is record the inodes that need
to have their unlinked list pointer updated in a new log item that
we attached to the transaction.

This log item exists purely for the purpose of delaying the update
of the unlinked list pointer until the inode cluster buffer can be
locked in the correct order around the other inode cluster buffers.
It plays no part in the actual commit, and there's no change to
anything that is written to the log. i.e. the inode cluster buffers
still have to be fully logged here (not just ordered) as log
recovery depedends on this to replay mods to the unlinked inode
list.

Hence if we add a "precommit" hook into xfs_trans_commit()
to run a "precommit" operation on these iunlink log items, we can
delay the locking, modification and logging of the inode cluster
buffer until after all other modifications have been made. The
precommit hook reuires us to sort the items that are going to be run
so that we can lock precommit items in the correct order as we
perform the modifications they describe.

To make this unlinked inode list processing simpler and easier to
implement as a log item, we need to change the way we track the
unlinked list in memory. Starting from the observation that an inode
on the unlinked list is pinned in memory by the VFS, we can use the
xfs_inode itself to track the unlinked list. To do this efficiently,
we want the unlinked list to be a double linked list. The problem
here is that we need a list per AGI unlinked list, and there are 64
of these per AGI. The approach taken in this patchset is to shadow
the AGI unlinked list heads in the perag, and link inodes by agino,
hence requiring only 8 extra bytes per inode to track this state.

We can then use the agino pointers for lockless inode cache lookups
to retreive the inode. The aginos in the inode are modified only
under the AGI lock, just like the cluster buffer pointers, so we
don't need any extra locking here.  The i_next_unlinked field tracks
the on-disk value of the unlinked list, and the i_prev_unlinked is a
purely in-memory pointer that enables us to efficiently remove
inodes from the middle of the list.

This results in moving a lot of the unlink modification work into
the precommit operations on the unlink log item. Tracking all the
unlinked inodes in the inodes themselves also gets rid of the
unlinked list reference hash table that is used to track this back
pointer relationship. This greatly simplifies the the unlinked list
modification code, and removes memory allocations in this hot path
to track back pointers. This, overall, slightly reduces the CPU
overhead of the unlink path.

The result of this log item means that we move all the actual
manipulation of objects to be logged out of the iunlink path and
into the iunlink item. This allows for future optimisation of this
mechanism without needing changes to high level unlink path, as
well as making the unlink lock ordering predictable and synchronised
with other operations that may require inode cluster locking.

Signed-off-by: Dave Chinner <dchinner@redhat.com>

----------------------------------------------------------------
Dave Chinner (9):
      xfs: factor the xfs_iunlink functions
      xfs: track the iunlink list pointer in the xfs_inode
      xfs: refactor xlog_recover_process_iunlinks()
      xfs: introduce xfs_iunlink_lookup
      xfs: double link the unlinked inode list
      xfs: clean up xfs_iunlink_update_inode()
      xfs: combine iunlink inode update functions
      xfs: add log item precommit operation
      xfs: add in-memory iunlink log item

Zhang Yi (1):
      xfs: flush inode gc workqueue before clearing agi bucket

 fs/xfs/Makefile               |   1 +
 fs/xfs/libxfs/xfs_ag.c        |   8 --
 fs/xfs/libxfs/xfs_ag.h        |   6 --
 fs/xfs/libxfs/xfs_inode_buf.c |   3 +-
 fs/xfs/xfs_icache.c           |   3 +
 fs/xfs/xfs_inode.c            | 570 ++++++++++++++++++++++---------------------------------------------------------------------------
 fs/xfs/xfs_inode.h            |   7 +-
 fs/xfs/xfs_iunlink_item.c     | 180 +++++++++++++++++++++++++++++++
 fs/xfs/xfs_iunlink_item.h     |  27 +++++
 fs/xfs/xfs_log_recover.c      | 171 +++++++++++++++--------------
 fs/xfs/xfs_super.c            |  10 ++
 fs/xfs/xfs_trace.h            |   1 -
 fs/xfs/xfs_trans.c            |  91 ++++++++++++++++
 fs/xfs/xfs_trans.h            |   6 +-
 14 files changed, 539 insertions(+), 545 deletions(-)
 create mode 100644 fs/xfs/xfs_iunlink_item.c
 create mode 100644 fs/xfs/xfs_iunlink_item.h

-- 
Dave Chinner
david@fromorbit.com
