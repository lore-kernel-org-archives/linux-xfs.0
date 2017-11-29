Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752787AbdK2XYB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 29 Nov 2017 18:24:01 -0500
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH 00/11] fs: use freeze_fs on suspend/hibernate
Date: Wed, 29 Nov 2017 15:23:45 -0800
Message-Id: <20171129232356.28296-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: viro@zeniv.linux.org.uk, bart.vanassche@wdc.com, ming.lei@redhat.com, tytso@mit.edu, darrick.wong@oracle.com, jikos@kernel.org, rjw@rjwysocki.net, pavel@ucw.cz, len.brown@intel.com, linux-fsdevel@vger.kernel.org
Cc: boris.ostrovsky@oracle.com, jgross@suse.com, todd.e.brandt@linux.intel.com, nborisov@suse.com, jack@suse.cz, martin.petersen@oracle.com, ONeukum@suse.com, oleksandr@natalenko.name, oleg.b.antonyan@gmail.com, yu.chen.surf@gmail.com, dan.j.williams@intel.com, linux-pm@vger.kernel.org, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@kernel.org>

This is a followup from the original RFC which proposed to start
to kill kthread freezing all together [0]. Instead of going straight
out to the jugular for kthread freezing this series only addresses
killing freezer calls on filesystems which implement freeze_fs, after
we let the kernel freeze these filesystems for us on suspend.

This approach puts on a slow but steady path towards the original goal
though. Each subsystem could look for similar solutions. Even with
filesystems we're not all done yet, after this we'll still have to
decide what to do about filesystems which do not implement freeze_fs().

Motivation and problem:

kthreads have some semantics for freezing, which helps the kernel
freeze them when a system is going to suspend or hibernation. These
semantics are not well defined though, and it actually turns out
pretty hard to get it right.

Without a proper solution suspend and hibernation are fragile on filesystems,
it can easily break suspend and fixing such issues are in no way trivial [1]
[2].

Proposed solution:

Instead of fixing such semantics and trying to get all filesystems to do it
right, we can easily do away with all freezing calls if the filesystem
implements a proper freeze_fs() callback. The following 9 filesystems have
freeze_fs() implemented as such we can let the kernel issue the callback upon
suspend and thaw on resume automatically on our behalf.

  o xfs
  o reiserfs
  o nilfs2
  o jfs
  o f2fs
  o ext4
  o ext2
  o btrfs

Of these, the following have freezer helpers, which can then be removed
after the kernel automaticaly calls freeze_fs for us on suspend:

  o xfs
  o nilfs2
  o jfs
  o f2fs
  o ext4

I've tested this on a system with ext4 and XFS, and have let 0-day go at
without issues. I have branches availabe for linux-next [3] and Linus'
latest tree [4].

Further testing, thoughts, reviews, flames are all equally appreciated.

[0] https://lkml.kernel.org/r/20171003185313.1017-1-mcgrof@kernel.org
[1] https://bugzilla.suse.com/show_bug.cgi?id=1043449
[2] https://lkml.kernel.org/r/20171113103139.GA18936@yu-chen.sh.intel.com
[3] https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux-next.git/log/?h=20171129-fs-freeze-cleanup
[4] https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux.git/log/?h=20171129-fs-freeze-cleanup

Luis R. Rodriguez (11):
  fs: provide unlocked helper for freeze_super()
  fs: provide unlocked helper thaw_super()
  fs: add frozen sb state helpers
  fs: distinguish between user initiated freeze and kernel initiated
    freeze
  fs: add iterate_supers_excl() and iterate_supers_reverse_excl()
  fs: freeze on suspend and thaw on resume
  xfs: remove not needed freezing calls
  ext4: remove not needed freezing calls
  f2fs: remove not needed freezing calls
  nilfs2: remove not needed freezing calls
  jfs: remove not needed freezing calls

 fs/ext4/ext4_jbd2.c    |   2 +-
 fs/ext4/super.c        |   2 -
 fs/f2fs/gc.c           |   5 +-
 fs/f2fs/segment.c      |   6 +-
 fs/jfs/jfs_logmgr.c    |  11 +-
 fs/jfs/jfs_txnmgr.c    |  31 ++---
 fs/nilfs2/segment.c    |  48 ++++----
 fs/super.c             | 320 ++++++++++++++++++++++++++++++++++++++++---------
 fs/xfs/xfs_trans.c     |   2 +-
 fs/xfs/xfs_trans_ail.c |   7 +-
 include/linux/fs.h     |  63 +++++++++-
 kernel/power/process.c |  15 ++-
 12 files changed, 378 insertions(+), 134 deletions(-)

-- 
2.15.0

