Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 63EF97F55
	for <xfs@oss.sgi.com>; Mon,  7 Sep 2015 04:42:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0C637AC004
	for <xfs@oss.sgi.com>; Mon,  7 Sep 2015 02:42:37 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	VL6UrA5nUSR9MSyC for <xfs@oss.sgi.com>;
	Mon, 07 Sep 2015 02:42:34 -0700 (PDT)
Date: Mon, 7 Sep 2015 19:42:32 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [GIT PULL] xfs: updates for 4.3
Message-ID: <20150907094232.GF3902@dastard>
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

Can you please pull the XFS updates from the tag below? There isn't
a whole lot to this update - it's mostly bug fixes and they are
spread pretty much all over XFS. There are some corruption fixes,
some fixes for log recovery, some fixes that prevent unount from
hanging, a lockdep annotation rework for inode locking to prevent
false positives and the usual random bunch of cleanups and minor
improvements.

There is a merge conflict with your current tree in
fs/xfs/xfs_aops.c. The merge diff in my tree is this:

--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@@ -353,7 -356,8 +353,8 @@@ xfs_end_bio
  {
  	xfs_ioend_t		*ioend = bio->bi_private;
  
- 	ioend->io_error = bio->bi_error;
 -	if (!ioend->io_error && !test_bit(BIO_UPTODATE, &bio->bi_flags))
 -		ioend->io_error = error;
++	if (!ioend->io_error)
++		ioend->io_error = bio->bi_error;
  
  	/* Toss bio and pass work off to an xfsdatad thread */
  	bio->bi_private = NULL;

-Dave.

The following changes since commit bc0195aad0daa2ad5b0d76cce22b167bc3435590:

  Linux 4.2-rc2 (2015-07-12 15:10:30 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git tags/xfs-for-linus-4.3

for you to fetch changes up to 5d54b8cdeaf4679c51a510dea3f8921992d0b064:

  Merge branch 'xfs-misc-fixes-for-4.3-4' into for-next (2015-09-01 10:30:11 +1000)

----------------------------------------------------------------

xfs: updates for 4.3-rc1

This update contains:
o large rework of EFI/EFD lifecycle handling to fix log recovery corruption
  issues, crashes and unmount hangs
o separate metadata UUID on disk to enable changing boot label UUID for v5
  filesystems
o fixes for gcc miscompilation on certain platforms and optimisation levels
o remote attribute allocation and recovery corruption fixes
o inode lockdep annotation rework to fix bugs with too many subclasses
o directory inode locking changes to prevent lockdep false positives
o a handful of minor corruption fixes
o various other small cleanups and bug fixes

----------------------------------------------------------------
Brian Foster (18):
      xfs: close xc_cil list_empty() races with cil commit sequence
      xfs: validate transaction header length on log recovery
      xfs: disentagle EFI release from the extent count
      xfs: return committed status from xfs_trans_roll()
      xfs: fix efi/efd error handling to avoid fs shutdown hangs
      xfs: ensure EFD trans aborts on log recovery extent free failure
      xfs: use EFI refcount consistently in log recovery
      xfs: don't leave EFIs on AIL on mount failure
      xfs: icreate log item recovery and cancellation tracepoints
      xfs: fix broken icreate log item cancellation
      xfs: checksum log record ext headers based on record size
      xfs: clean up root inode properly on mount failure
      xfs: fix btree cursor error cleanups
      xfs: add helper to conditionally remove items from the AIL
      xfs: add missing bmap cancel calls in error paths
      xfs: relocate sparse inode mount warning
      xfs: swap leaf buffer into path struct atomically during path shift
      xfs: flush entire file on dio read/write to cached file

Darrick J. Wong (2):
      libxfs: readahead of dir3 data blocks should use the read verifier
      libxfs: bad magic number should set da block buffer error

Dave Chinner (20):
      xfs: call dax_fault on read page faults for DAX
      xfs: remote attribute headers contain an invalid LSN
      xfs: remote attributes need to be considered data
      xfs: xfs_bunmapi() does not need XFS_BMAPI_METADATA flag
      libxfs: add xfs_bit.c
      Merge branch 'xfs-misc-fixes-for-4.3' into for-next
      Merge branch 'xfs-meta-uuid' into for-next
      Merge branch 'xfs-efi-rework' into for-next
      xfs: fix sb_meta_uuid usage
      xfs: growfs not aware of sb_meta_uuid
      xfs: log recovery needs to validate against sb_meta_uuid
      xfs: dquots should be stamped with sb_meta_uuid
      xfs: clean up inode lockdep annotations
      xfs: stop holding ILOCK over filldir callbacks
      xfs: inode lockdep annotations broke non-lockdep build
      Merge branch 'xfs-misc-fixes-for-4.3-2' into for-next
      xfs: lockdep annotations throw warnings on non-debug builds
      xfs: fix non-debug build warnings
      Merge branch 'xfs-misc-fixes-for-4.3-3' into for-next
      Merge branch 'xfs-misc-fixes-for-4.3-4' into for-next

David Jeffery (1):
      xfs: return errors from partial I/O failures to files

Eric Sandeen (4):
      xfs: create new metadata UUID field and incompat flag
      xfs: set XFS_DA_OP_OKNOENT in xfs_attr_get
      xfs: collapse allocsize and biosize mount option handling
      xfs: fix error gotos in xfs_setattr_nonsize

Jan Kara (4):
      xfs: Remove duplicate jumps to the same label
      xfs: Fix xfs_attr_leafblock definition
      xfs: Fix uninitialized return value in xfs_alloc_fix_freelist()
      xfs: Fix file type directory corruption for btree directories

Joe Perches (1):
      xfs: Use consistent logging message prefixes

Lucas Stach (1):
      xfs: add mssing inode cache attempts counter increment

 fs/dax.c                           |   14 ++-
 fs/xfs/Makefile                    |    2 +-
 fs/xfs/libxfs/xfs_alloc.c          |    6 +-
 fs/xfs/libxfs/xfs_alloc_btree.c    |    4 +-
 fs/xfs/libxfs/xfs_attr.c           |    2 +
 fs/xfs/libxfs/xfs_attr_leaf.c      |    4 +-
 fs/xfs/libxfs/xfs_attr_remote.c    |   53 ++++++---
 fs/xfs/{ => libxfs}/xfs_bit.c      |    0
 fs/xfs/libxfs/xfs_bmap.c           |    1 +
 fs/xfs/libxfs/xfs_bmap_btree.c     |    5 +-
 fs/xfs/libxfs/xfs_btree.c          |   10 +-
 fs/xfs/libxfs/xfs_da_btree.c       |   32 ++---
 fs/xfs/libxfs/xfs_da_format.h      |   11 +-
 fs/xfs/libxfs/xfs_dir2.c           |   36 +++---
 fs/xfs/libxfs/xfs_dir2_block.c     |    4 +-
 fs/xfs/libxfs/xfs_dir2_data.c      |    7 +-
 fs/xfs/libxfs/xfs_dir2_leaf.c      |    4 +-
 fs/xfs/libxfs/xfs_dir2_node.c      |   17 ++-
 fs/xfs/libxfs/xfs_dquot_buf.c      |    4 +-
 fs/xfs/libxfs/xfs_format.h         |   22 +++-
 fs/xfs/libxfs/xfs_ialloc.c         |    7 +-
 fs/xfs/libxfs/xfs_ialloc_btree.c   |    2 +-
 fs/xfs/libxfs/xfs_inode_buf.c      |    4 +-
 fs/xfs/libxfs/xfs_sb.c             |   27 +++--
 fs/xfs/libxfs/xfs_symlink_remote.c |    4 +-
 fs/xfs/xfs_aops.c                  |    3 +-
 fs/xfs/xfs_bmap_util.c             |   87 +++++++-------
 fs/xfs/xfs_buf.c                   |    9 +-
 fs/xfs/xfs_buf_item.c              |   26 +++--
 fs/xfs/xfs_buf_item.h              |    2 +-
 fs/xfs/xfs_dir2_readdir.c          |   11 +-
 fs/xfs/xfs_dquot.c                 |   10 +-
 fs/xfs/xfs_extfree_item.c          |  105 +++++++----------
 fs/xfs/xfs_extfree_item.h          |   26 ++++-
 fs/xfs/xfs_file.c                  |   72 +++++++-----
 fs/xfs/xfs_fsops.c                 |    6 +-
 fs/xfs/xfs_icache.c                |    2 +
 fs/xfs/xfs_inode.c                 |  141 +++++++++++++++-------
 fs/xfs/xfs_inode.h                 |   85 +++++++++-----
 fs/xfs/xfs_inode_item.c            |   11 +-
 fs/xfs/xfs_iops.c                  |    8 +-
 fs/xfs/xfs_itable.c                |    3 +-
 fs/xfs/xfs_log.c                   |   87 +++++++++-----
 fs/xfs/xfs_log.h                   |    1 +
 fs/xfs/xfs_log_cil.c               |    8 +-
 fs/xfs/xfs_log_priv.h              |    2 +
 fs/xfs/xfs_log_recover.c           |  227 ++++++++++++++++++++++++++++--------
 fs/xfs/xfs_mount.c                 |   28 +++--
 fs/xfs/xfs_rtalloc.c               |   57 ++++-----
 fs/xfs/xfs_super.c                 |   16 +--
 fs/xfs/xfs_symlink.c               |    9 +-
 fs/xfs/xfs_trace.h                 |   34 ++++++
 fs/xfs/xfs_trans.c                 |   15 ++-
 fs/xfs/xfs_trans.h                 |    9 +-
 fs/xfs/xfs_trans_extfree.c         |   32 +++--
 fs/xfs/xfs_trans_priv.h            |   15 +++
 56 files changed, 930 insertions(+), 499 deletions(-)
 rename fs/xfs/{ => libxfs}/xfs_bit.c (100%)
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
