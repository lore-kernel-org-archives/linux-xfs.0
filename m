Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33362 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752767AbdCFNlx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Mar 2017 08:41:53 -0500
From: Michal Hocko <mhocko@kernel.org>
Subject: [PATCH 0/7 v5] scope GFP_NOFS api
Date: Mon,  6 Mar 2017 14:14:01 +0100
Message-Id: <20170306131408.9828-1-mhocko@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org, Dave Chinner <david@fromorbit.com>, djwong@kernel.org, Theodore Ts'o <tytso@mit.edu>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.cz>, Jan Kara <jack@suse.cz>, ceph-devel@vger.kernel.org, cluster-devel@redhat.com, linux-nfs@vger.kernel.org, logfs@logfs.org, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-mtd@lists.infradead.org, reiserfs-devel@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net, linux-f2fs-devel@lists.sourceforge.net, linux-afs@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>, Brian Foster <bfoster@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Michal Hocko <mhocko@suse.com>, Michal Hocko <mhocko@suse.cz>, Nikolay Borisov <nborisov@suse.com>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, Vlastimil Babka <vbabka@suse.cz>

Hi,
I have posted the previous version here [1]. There are no real changes
in the implementation since then. I've just added "lockdep: teach
lockdep about memalloc_noio_save" from Nikolay which is a lockdep bugfix
developed independently but "mm: introduce memalloc_nofs_{save,restore}
API" depends on it so I added it here. Then I've rebased the series on
top of 4.11-rc1 which contains sched.h split up which required to add
sched/mm.h include.

There didn't seem to be any real objections and so I think we should go
and finally merge this - ideally in this release cycle as it doesn't
really introduce any functional changes. Those were separated out and
will be posted later. The risk of regressions should really be small
because we do not remove any real GFP_NOFS users yet.

Diffstat says
 fs/jbd2/journal.c         |  8 ++++++++
 fs/jbd2/transaction.c     | 12 ++++++++++++
 fs/xfs/kmem.c             | 12 ++++++------
 fs/xfs/kmem.h             |  2 +-
 fs/xfs/libxfs/xfs_btree.c |  2 +-
 fs/xfs/xfs_aops.c         |  6 +++---
 fs/xfs/xfs_buf.c          |  8 ++++----
 fs/xfs/xfs_trans.c        | 12 ++++++------
 include/linux/gfp.h       | 18 +++++++++++++++++-
 include/linux/jbd2.h      |  2 ++
 include/linux/sched.h     |  6 +++---
 include/linux/sched/mm.h  | 26 +++++++++++++++++++++++---
 kernel/locking/lockdep.c  | 11 +++++++++--
 lib/radix-tree.c          |  2 ++
 mm/page_alloc.c           | 10 ++++++----
 mm/vmscan.c               |  6 +++---
 16 files changed, 106 insertions(+), 37 deletions(-)

Shortlog:
Michal Hocko (6):
      lockdep: allow to disable reclaim lockup detection
      xfs: abstract PF_FSTRANS to PF_MEMALLOC_NOFS
      mm: introduce memalloc_nofs_{save,restore} API
      xfs: use memalloc_nofs_{save,restore} instead of memalloc_noio*
      jbd2: mark the transaction context with the scope GFP_NOFS context
      jbd2: make the whole kjournald2 kthread NOFS safe

Nikolay Borisov (1):
      lockdep: teach lockdep about memalloc_noio_save


[1] http://lkml.kernel.org/r/20170206140718.16222-1-mhocko@kernel.org
[2] http://lkml.kernel.org/r/20170117030118.727jqyamjhojzajb@thunk.org
