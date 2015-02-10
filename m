Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C11FB7FB4
	for <xfs@oss.sgi.com>; Mon,  9 Feb 2015 18:34:43 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 414BFAC002
	for <xfs@oss.sgi.com>; Mon,  9 Feb 2015 16:34:40 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	thERVi7YnDjdqZmx for <xfs@oss.sgi.com>;
	Mon, 09 Feb 2015 16:34:34 -0800 (PST)
Date: Tue, 10 Feb 2015 11:34:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [GIT PULL] xfs: updates for 3.20-rc1
Message-ID: <20150210003432.GZ12722@dastard>
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

Can you please pull the current XFS updates from the tree below?

It's a relatively small set of changes, mainly refactoring and bug
fixes, with a few small feature additions. The tag below describes
the changes in more detail.

There is one very recent commit in the tree - I found a regression
introduced in 3.19-rc1 on friday, and didn't get it reviewed in time
for the final 3.19 release.  Everything else has soaked in
linux-next for at least a week.

FYI, I'll also be sending a second pull request later in the merge
window for the XFS side of the PNFS block layout server support that
is in Bruce's tree. We didn't get our git trees in a pile quickly
enough once review was completed to merge stable commits between the
trees, so once the new PNFS server code is merged I'll send the XFS
changes that implement the new NFS server interfaces.

-Dave.

The following changes since commit 97bf6af1f928216fd6c5a66e8a57bfa95a659672:

  Linux 3.19-rc1 (2014-12-20 17:08:50 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git tags/xfs-for-linus-3.20-rc1

for you to fetch changes up to bad962662dbc60e76ec1baae34af56b1ba2dfa5f:

  Merge branch 'xfs-misc-fixes-for-3.20-4' into for-next (2015-02-10 09:24:25 +1100)

----------------------------------------------------------------

xfs: update for 3.20-rc1

This update contains:
o RENAME_EXCHANGE support
o Rework of the superblock logging infrastructure
o Rework of the XFS_IOCTL_SETXATTR implementation
	- enables use inside user namespaces
	- fixes inconsistencies setting extent size hints
o fixes for missing buffer type annotations used in log recovery
o more consolidation of libxfs headers
o preparation patches for block based PNFS support
o miscellaneous bug fixes and cleanups

----------------------------------------------------------------
Brian Foster (2):
      xfs: initialize log buf I/O completion wq on log alloc
      xfs: remove incorrect error negation in attr_multi ioctl

Carlos Maiolino (2):
      xfs: Make xfs_vn_rename compliant with renameat2() syscall
      xfs: Add support to RENAME_EXCHANGE flag

Christoph Hellwig (4):
      xfs: pass a 64-bit count argument to xfs_iomap_write_unwritten
      xfs: factor out a xfs_update_prealloc_flags() helper
      xfs: don't allocate an ioend for direct I/O completions
      xfs: growfs should use synchronous transactions

Dave Chinner (28):
      Merge branch 'xfs-misc-fixes-for-3.20-1' into for-next
      xfs: move xfs_fs.h to libxfs
      xfs: move xfs_types.h to libxfs
      xfs: move struct xfs_bmalloca to libxfs
      xfs: move xfs_bmap_finish prototype
      xfs: remove deprecated sysctls
      Merge branch 'xfs-misc-fixes-for-3.20-2' into for-next
      xfs: remove bitfield based superblock updates
      xfs: consolidate superblock logging functions
      xfs: sanitise sb_bad_features2 handling
      Merge branch 'xfs-sb-logging-rework' into for-next
      xfs: ensure buffer types are set correctly
      xfs: inode unlink does not set AGI buffer type
      xfs: set buf types when converting extent formats
      xfs: set superblock buffer type correctly
      Merge branch 'xfs-buf-type-fixes' into for-next
      Merge branch 'xfs-misc-fixes-for-3.20-3' into for-next
      xfs: FSX_NONBLOCK is not used
      xfs: separate xflags from xfs_ioctl_setattr
      xfs: factor out xfs_ioctl_setattr transaciton preamble
      xfs: disaggregate xfs_ioctl_setattr
      xfs: kill xfs_ioctl_setattr behaviour mask
      xfs: XFS_IOCTL_SETXATTR can run in user namespaces
      xfs: factor extsize hint checking out of xfs_ioctl_setattr
      xfs: factor projid hint checking out of xfs_ioctl_setattr
      Merge branch 'xfs-ioctl-setattr-cleanup' into for-next
      xfs: only trace buffer items if they exist
      Merge branch 'xfs-misc-fixes-for-3.20-4' into for-next

Eric Sandeen (3):
      xfs: remove extra newlines from xfs messages
      xfs: fix panic_mask documentation
      xfs: report proper f_files in statfs if we overshoot imaxpct

Iustin Pop (1):
      xfs: fix behaviour of XFS_IOC_FSSETXATTR on directories

Jan Kara (1):
      xfs: Keep sb_bad_features2 consistent with sb_features2

Nicholas Mc Guire (1):
      xfs: fix implicit bool to int conversion

Wang, Yalin (1):
      xfs: change kmem_free to use generic kvfree()

kbuild test robot (1):
      xfs: xfs_ioctl_setattr_check_projid can be static

 Documentation/filesystems/xfs.txt  |   22 +-
 fs/xfs/kmem.c                      |   10 -
 fs/xfs/kmem.h                      |    5 +-
 fs/xfs/libxfs/xfs_attr_leaf.c      |    2 +-
 fs/xfs/libxfs/xfs_bmap.c           |   20 +-
 fs/xfs/libxfs/xfs_bmap.h           |   33 +++
 fs/xfs/libxfs/xfs_format.h         |   24 +-
 fs/xfs/{ => libxfs}/xfs_fs.h       |    0
 fs/xfs/libxfs/xfs_sb.c             |  320 ++++++++++-------------
 fs/xfs/libxfs/xfs_sb.h             |   11 +-
 fs/xfs/libxfs/xfs_shared.h         |   33 ++-
 fs/xfs/libxfs/xfs_symlink_remote.c |    2 +
 fs/xfs/libxfs/xfs_trans_resv.c     |   14 -
 fs/xfs/libxfs/xfs_trans_resv.h     |    1 -
 fs/xfs/{ => libxfs}/xfs_types.h    |    0
 fs/xfs/xfs_aops.c                  |  149 +++++------
 fs/xfs/xfs_aops.h                  |    3 -
 fs/xfs/xfs_bmap_util.h             |   37 +--
 fs/xfs/xfs_buf_item.c              |    6 +-
 fs/xfs/xfs_dquot.h                 |    2 +-
 fs/xfs/xfs_file.c                  |   64 +++--
 fs/xfs/xfs_fsops.c                 |   34 +--
 fs/xfs/xfs_inode.c                 |  136 +++++++++-
 fs/xfs/xfs_inode.h                 |   11 +-
 fs/xfs/xfs_ioctl.c                 |  501 +++++++++++++++++-------------------
 fs/xfs/xfs_ioctl32.c               |    2 +-
 fs/xfs/xfs_iomap.c                 |    2 +-
 fs/xfs/xfs_iomap.h                 |    2 +-
 fs/xfs/xfs_iops.c                  |   21 +-
 fs/xfs/xfs_log.c                   |   28 +-
 fs/xfs/xfs_mount.c                 |  107 ++------
 fs/xfs/xfs_mount.h                 |    5 +-
 fs/xfs/xfs_qm.c                    |   43 +---
 fs/xfs/xfs_qm.h                    |    1 -
 fs/xfs/xfs_qm_syscalls.c           |   14 +-
 fs/xfs/xfs_super.c                 |   20 +-
 fs/xfs/xfs_sysctl.c                |   18 --
 fs/xfs/xfs_trans.c                 |    1 +
 fs/xfs/xfs_trans_buf.c             |    5 +-
 39 files changed, 817 insertions(+), 892 deletions(-)
 rename fs/xfs/{ => libxfs}/xfs_fs.h (100%)
 rename fs/xfs/{ => libxfs}/xfs_types.h (100%)
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
