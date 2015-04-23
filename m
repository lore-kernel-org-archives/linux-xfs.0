Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 748957F37
	for <xfs@oss.sgi.com>; Wed, 22 Apr 2015 21:12:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 44D3B8F8040
	for <xfs@oss.sgi.com>; Wed, 22 Apr 2015 19:12:20 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	ATrl2QOEebxQNr0s for <xfs@oss.sgi.com>;
	Wed, 22 Apr 2015 19:12:14 -0700 (PDT)
Date: Thu, 23 Apr 2015 12:12:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [GIT PULL] xfs: updates for 4.1-rc1
Message-ID: <20150423021211.GI15810@dastard>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Hi Linus,

Can you please pull the XFS updates from the tag below? The changes
are detailed in the tag message, so I won't go over them again here.
The only thing of note is the direct IO fixes that we merged last
week after the window opened. Even though a little late, they fix a
user reported data corruption and have been pretty well tested. I
figured there was not much point waiting another 2 weeks for -rc1 to
be released just so I could send them to you....

Note that there will be merge conflicts when you merge this tag. The
resolution is pretty straight forward but there's also a direct IO
API change that will throw build errors if not fixed during the
merge.  From Stephen Rothwell's linux-next merge/build process, the
DIO API fix that needs to be made is here:

http://oss.sgi.com/archives/xfs/2015-04/msg00206.html

And the merge resolution is here:

http://oss.sgi.com/archives/xfs/2015-04/msg00207.html

I would have simple attached a merge commit patch if I could have
worked out how to get just the above changes from the merge commit.
I can get a combined diff that has lots of noise in it via git show,
but I couldn't find a way just to output a simple unified diff. Is
there any trick to this, or any specific way you'd prefer that I
communicate such issues in future?

-Dave.

The following changes since commit c517d838eb7d07bbe9507871fab3931deccff539:

  Linux 4.0-rc1 (2015-02-22 18:21:14 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git tags/xfs-for-linus-4.1-rc1

for you to fetch changes up to 542c311813d5cb2e6f0dfa9557f41c829b8fb6a0:

  Merge branch 'xfs-dio-extend-fix' into for-next (2015-04-16 22:13:18 +1000)

----------------------------------------------------------------

xfs: update for 4.1-rc1

This update contains:
o RENAME_WHITEOUT support
o conversion of per-cpu superblock accounting to use generic counters
o new inode mmap lock so that we can lock page faults out of truncate, hole
  punch and other direct extent manipulation functions to avoid racing mmap
  writes from causing data corruption
o rework of direct IO submission and completion to solve data corruption issue
  when running concurrent extending DIO writes. Also solves problem of running
  IO completion transactions in interrupt context during size extending AIO
  writes.
o FALLOC_FL_INSERT_RANGE support for inserting holes into a file via direct
  extent manipulation to avoid needing to copy data within the file
o attribute block header field overflow fix for 64k block size filesystems
o Lots of changes to log messaging to be more informative and concise when
  errors occur. Also prevent a lot of unnecessary log spamming due to cascading
  failures in error conditions.
o lots of cleanups and bug fixes

----------------------------------------------------------------
Brian Foster (3):
      xfs: pass attr geometry to attr leaf header conversion functions
      xfs: use larger in-core attr firstused field and detect overflow
      xfs: kill unnecessary firstused overflow check on attr3 leaf removal

Byoungyoung Lee (1):
      xfs: xfs_mru_cache_insert() should use GFP_NOFS

Christoph Hellwig (1):
      xfs: unlock i_mutex in xfs_break_layouts

Dave Chinner (38):
      xfs: use generic percpu counters for inode counter
      xfs: use generic percpu counters for free inode counter
      xfs: use generic percpu counters for free block counter
      xfs: Remove icsb infrastructure
      xfs: introduce xfs_mod_frextents
      xfs: replace xfs_mod_incore_sb_batched
      xfs: remove xfs_mod_incore_sb API
      xfs: introduce mmap/truncate lock
      xfs: use i_mmaplock on read faults
      xfs: use i_mmaplock on write faults
      xfs: take i_mmap_lock on extent manipulation operations
      xfs: xfs_setattr_size no longer races with page faults
      xfs: lock out page faults from extent swap operations
      xfs: ensure truncate forces zeroed blocks to disk
      xfs: inodes are new until the dentry cache is set up
      xfs: xfs_alloc_fix_minleft can underflow near ENOSPC
      Merge branch 'xfs-misc-fixes-for-4.1' into for-next
      Merge branch 'xfs-generic-sb-counters' into for-next
      Merge branch 'xfs-mmap-lock' into for-next
      xfs: clean up inode locking for RENAME_WHITEOUT
      xfs: cleanup xfs_rename error handling
      xfs: factor out xfs_finish_rename()
      xfs: make xfs_cross_rename() complete fully
      xfs: add RENAME_WHITEOUT support
      Merge branch 'xfs-rename-whiteout' into for-next
      xfs: remove xfs_bmap_sanity_check()
      Merge branch 'xfs-misc-fixes-for-4.1-2' into for-next
      Merge branch 'fallocate-insert-range' into for-next
      Merge branch 'xfs-misc-fixes-for-4.1-3' into for-next
      xfs: factor DIO write mapping from get_blocks
      xfs: move DIO mapping size calculation
      xfs: DIO needs an ioend for writes
      xfs: handle DIO overwrite EOF update completion correctly
      xfs: DIO writes within EOF don't need an ioend
      xfs: DIO write completion size updates race
      xfs: direct IO EOF zeroing needs to drain AIO
      xfs: using generic_file_direct_write() is unnecessary
      Merge branch 'xfs-dio-extend-fix' into for-next

Eric Sandeen (9):
      xfs: pass mp to XFS_WANT_CORRUPTED_GOTO
      xfs: pass mp to XFS_WANT_CORRUPTED_RETURN
      xfs: Ensure we have target_ip for RENAME_EXCHANGE
      xfs: log unmount events on console
      xfs: clarify async write failure ratelimit message
      xfs: cancel failed transaction in xfs_fs_commit_blocks()
      xfs: remove deprecated mount options
      xfs: fix NULL pointer dereference in xfs_filestream_lookup_ag()
      xfs: disallow ro->rw remount on norecovery mount

Fabian Frederick (2):
      xfs: use bool instead of int in xfs_rename()
      xfs: fix shadow warning in xfs_da3_root_split()

Jan Kara (1):
      xfs: Fix quota type in quota structures when reusing quota file

Joe Perches (1):
      xfs: Fix incorrect positive ENOMEM return

Namjae Jeon (2):
      fs: Add support FALLOC_FL_INSERT_RANGE for fallocate
      xfs: Add support FALLOC_FL_INSERT_RANGE for fallocate

Scott Wood (1):
      xfs: %pF is only for function pointers

Wang Sheng-Hui (1):
      xfs: remove old and redundant comment in xfs_mount_validate_sb

kbuild test robot (1):
      xfs: xfs_shift_file_space can be static

 Documentation/filesystems/xfs.txt |   29 +-
 fs/open.c                         |    8 +-
 fs/xfs/libxfs/xfs_alloc.c         |  104 +++--
 fs/xfs/libxfs/xfs_attr_leaf.c     |  150 ++++--
 fs/xfs/libxfs/xfs_attr_leaf.h     |    6 +-
 fs/xfs/libxfs/xfs_bmap.c          |  554 +++++++++++++++-------
 fs/xfs/libxfs/xfs_bmap.h          |   13 +-
 fs/xfs/libxfs/xfs_btree.c         |   24 +-
 fs/xfs/libxfs/xfs_da_btree.c      |    8 +-
 fs/xfs/libxfs/xfs_da_format.h     |   14 +-
 fs/xfs/libxfs/xfs_dir2_data.c     |   39 +-
 fs/xfs/libxfs/xfs_format.h        |   62 ---
 fs/xfs/libxfs/xfs_ialloc.c        |   48 +-
 fs/xfs/libxfs/xfs_sb.c            |   20 +-
 fs/xfs/xfs_aops.c                 |  270 +++++++----
 fs/xfs/xfs_attr_inactive.c        |    3 +-
 fs/xfs/xfs_attr_list.c            |    9 +-
 fs/xfs/xfs_bmap_util.c            |  164 ++++---
 fs/xfs/xfs_bmap_util.h            |    2 +
 fs/xfs/xfs_buf_item.c             |    4 +-
 fs/xfs/xfs_discard.c              |    2 +-
 fs/xfs/xfs_error.c                |    2 +-
 fs/xfs/xfs_error.h                |    8 +-
 fs/xfs/xfs_file.c                 |  175 +++++--
 fs/xfs/xfs_filestream.c           |    2 +-
 fs/xfs/xfs_fsops.c                |   20 +-
 fs/xfs/xfs_icache.c               |    4 +-
 fs/xfs/xfs_inode.c                |  554 +++++++++++++---------
 fs/xfs/xfs_inode.h                |   58 ++-
 fs/xfs/xfs_ioctl.c                |    7 +-
 fs/xfs/xfs_iomap.c                |    3 +-
 fs/xfs/xfs_iops.c                 |  127 ++---
 fs/xfs/xfs_iops.h                 |    2 -
 fs/xfs/xfs_itable.c               |    2 +-
 fs/xfs/xfs_linux.h                |    9 -
 fs/xfs/xfs_log_recover.c          |    4 +-
 fs/xfs/xfs_mount.c                |  918 +++++--------------------------------
 fs/xfs/xfs_mount.h                |   95 +---
 fs/xfs/xfs_mru_cache.c            |    2 +-
 fs/xfs/xfs_pnfs.c                 |   11 +-
 fs/xfs/xfs_pnfs.h                 |    5 +-
 fs/xfs/xfs_qm.c                   |   18 +-
 fs/xfs/xfs_super.c                |  132 ++++--
 fs/xfs/xfs_super.h                |    2 +
 fs/xfs/xfs_symlink.c              |   58 ++-
 fs/xfs/xfs_trace.h                |   29 +-
 fs/xfs/xfs_trans.c                |  234 ++++++----
 include/linux/falloc.h            |    6 +
 include/uapi/linux/falloc.h       |   17 +
 49 files changed, 2061 insertions(+), 1976 deletions(-)
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
