Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33009 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752148AbdBFOHa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Feb 2017 09:07:30 -0500
From: Michal Hocko <mhocko@kernel.org>
Subject: [PATCH 0/6 v4] scope GFP_NOFS api
Date: Mon,  6 Feb 2017 15:07:12 +0100
Message-Id: <20170206140718.16222-1-mhocko@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org, Dave Chinner <david@fromorbit.com>, djwong@kernel.org, Theodore Ts'o <tytso@mit.edu>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.cz>, Jan Kara <jack@suse.cz>, ceph-devel@vger.kernel.org, cluster-devel@redhat.com, linux-nfs@vger.kernel.org, logfs@logfs.org, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-mtd@lists.infradead.org, reiserfs-devel@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net, linux-f2fs-devel@lists.sourceforge.net, linux-afs@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>, Brian Foster <bfoster@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Michal Hocko <mhocko@suse.com>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, Vlastimil Babka <vbabka@suse.cz>

Hi,
I have posted the previous version here [1]. There are no real changes
in the implementation since then. Few acks added and one new user of
memalloc_noio_flags (in alloc_contig_range) converted. I have decided
to drop the last two ext4 related patches. One of them will be picked up
by Ted [2] and the other one will probably need more time to settle down.
I believe it is OK as is but let's not block the whole thing just because
of it.

There didn't seem to be any real objections and so I think we should
go and merge this to mmotm tree and target the next merge window. The
risk of regressions is really small because we do not remove any real
GFP_NOFS users yet.

I hope to get ext4 parts resolved in the follow up patches as well as
pull other filesystems in. There is still a lot work to do but having
the infrastructure in place should be very useful already.

The patchset is based on next-20170206

Diffstat says
 fs/jbd2/journal.c         |  7 +++++++
 fs/jbd2/transaction.c     | 11 +++++++++++
 fs/xfs/kmem.c             | 12 ++++++------
 fs/xfs/kmem.h             |  2 +-
 fs/xfs/libxfs/xfs_btree.c |  2 +-
 fs/xfs/xfs_aops.c         |  6 +++---
 fs/xfs/xfs_buf.c          |  8 ++++----
 fs/xfs/xfs_trans.c        | 12 ++++++------
 include/linux/gfp.h       | 18 +++++++++++++++++-
 include/linux/jbd2.h      |  2 ++
 include/linux/sched.h     | 32 ++++++++++++++++++++++++++------
 kernel/locking/lockdep.c  |  6 +++++-
 lib/radix-tree.c          |  2 ++
 mm/page_alloc.c           | 10 ++++++----
 mm/vmscan.c               |  6 +++---
 15 files changed, 100 insertions(+), 36 deletions(-)

Shortlog:
Michal Hocko (6):
      lockdep: allow to disable reclaim lockup detection
      xfs: abstract PF_FSTRANS to PF_MEMALLOC_NOFS
      mm: introduce memalloc_nofs_{save,restore} API
      xfs: use memalloc_nofs_{save,restore} instead of memalloc_noio*
      jbd2: mark the transaction context with the scope GFP_NOFS context
      jbd2: make the whole kjournald2 kthread NOFS safe

[1] http://lkml.kernel.org/r/20170106141107.23953-1-mhocko@kernel.org
[2] http://lkml.kernel.org/r/20170117030118.727jqyamjhojzajb@thunk.org

