Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wj0-f193.google.com ([209.85.210.193]:34598 "EHLO
        mail-wj0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752070AbcLOOHv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Dec 2016 09:07:51 -0500
From: Michal Hocko <mhocko@kernel.org>
Subject: [PATCH 0/9 v2] scope GFP_NOFS api
Date: Thu, 15 Dec 2016 15:07:06 +0100
Message-Id: <20161215140715.12732-1-mhocko@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, Theodore Ts'o <tytso@mit.edu>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.cz>, Jan Kara <jack@suse.cz>, ceph-devel@vger.kernel.org, cluster-devel@redhat.com, linux-nfs@vger.kernel.org, logfs@logfs.org, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-mtd@lists.infradead.org, reiserfs-devel@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net, linux-f2fs-devel@lists.sourceforge.net, linux-afs@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.com>, "Peter Zijlstra (Intel)" <peterz@infradead.org>

Hi,
I have posted the previous version here [1]. Since then I have added a
support to suppress reclaim lockdep warnings (__GFP_NOLOCKDEP) to allow
removing GFP_NOFS usage motivated by the lockdep false positives. On top
of that I've tried to convert few KM_NOFS usages to use the new flag in
the xfs code base. This would need a review from somebody familiar with
xfs of course.

Then I've added the new scope API to the jbd/ext transaction code +
reverted some explicit GFP_NOFS usages which are covered by the scope one
now. This also needs a deep review from ext developers. I have some more
patches which remove more explicit GFP_NOFS users but that is not really
ready yet. I would really appreciate if developers for other filesystems
joined me here as well. Maybe ext parts can help to show how to start.
Especially btrfs which uses GFP_NOFS a lot (and not with a good reason
in many cases I suspect).

The patchset is based on linux-next (next-20161214).

I think the GFP_NOIO should be seeing the same clean up but that is not
a part of this patchset.

Any feedback is highly appreciated of course.

Diffstat says
 fs/ext4/acl.c                |  6 +++---
 fs/ext4/extents.c            |  8 ++++----
 fs/ext4/resize.c             |  4 ++--
 fs/ext4/xattr.c              |  4 ++--
 fs/jbd2/journal.c            |  7 +++++++
 fs/jbd2/transaction.c        | 11 +++++++++++
 fs/xfs/kmem.c                | 10 +++++-----
 fs/xfs/kmem.h                |  6 +++++-
 fs/xfs/libxfs/xfs_btree.c    |  2 +-
 fs/xfs/libxfs/xfs_da_btree.c |  4 ++--
 fs/xfs/xfs_aops.c            |  6 +++---
 fs/xfs/xfs_buf.c             | 10 +++++-----
 fs/xfs/xfs_dir2_readdir.c    |  2 +-
 fs/xfs/xfs_trans.c           | 12 ++++++------
 include/linux/gfp.h          | 18 +++++++++++++++++-
 include/linux/jbd2.h         |  2 ++
 include/linux/sched.h        | 32 ++++++++++++++++++++++++++------
 kernel/locking/lockdep.c     |  6 +++++-
 lib/radix-tree.c             |  2 ++
 mm/page_alloc.c              |  8 +++++---
 mm/vmscan.c                  |  6 +++---
 21 files changed, 117 insertions(+), 49 deletions(-)

Shortlog:
Michal Hocko (9):
      lockdep: allow to disable reclaim lockup detection
      xfs: introduce and use KM_NOLOCKDEP to silence reclaim lockdep false positives
      xfs: abstract PF_FSTRANS to PF_MEMALLOC_NOFS
      mm: introduce memalloc_nofs_{save,restore} API
      xfs: use memalloc_nofs_{save,restore} instead of memalloc_noio*
      jbd2: mark the transaction context with the scope GFP_NOFS context
      jbd2: make the whole kjournald2 kthread NOFS safe
      Revert "ext4: avoid deadlocks in the writeback path by using sb_getblk_gfp"
      Revert "ext4: fix wrong gfp type under transaction"


[1] http://lkml.kernel.org/r/1461671772-1269-1-git-send-email-mhocko@kernel.org


