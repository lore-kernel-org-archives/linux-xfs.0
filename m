Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, master,
	updated. xfs-for-linus-3.15-rc5-1266-gd6d211d
Message-Id: <20140514232718.68A377F47@oss.sgi.com>
Date: Wed, 14 May 2014 18:27:17 -0500 (CDT)
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is an automated email from the git hooks/post-receive script. It was
generated because a ref change was pushed to the repository containing
the project "XFS development tree".

The branch, master has been updated
  afcf0a2 Merge tag 'xfs-for-linus-3.15-rc5' of git://oss.sgi.com/xfs/xfs
  8275cdd xfs: remote attribute overwrite causes transaction overrun
  d540e43 xfs: initialize default acls for ->tmpfile()
  c99d609 xfs: fully support v5 format filesystems
  9ac0367 Merge tag 'ext4_for_linus_stable' of git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4
  330033d xfs: fix tmpfile/selinux deadlock and initialize security
  8d6c121 xfs: fix buffer use after free on IO error
  07d5035 xfs: wrong error sign conversion during failed DIO writes
  9c23ecc xfs: unmount does not wait for shutdown during unmount
  d39a2ce xfs: collapse range is delalloc challenged
  0e1f789 xfs: don't map ranges that span EOF for direct IO
  897b73b xfs: zeroing space needs to punch delalloc blocks
  aad3f37 xfs: xfs_vm_write_end truncates too much on failure
  72ab70a xfs: write failure beyond EOF truncates too much data
  4ab9ed5 xfs: kill buffers over failed write ranges properly
  23fffa9 fs: move falloc collapse range check into the filesystem methods
      from  c9eaa447e77efe77b7fa4c953bd62de8297fd6c5 (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit afcf0a2d9289bbe50aab362e6fb2798038815973
Merge: f322e26 8275cdd
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu May 8 19:20:45 2014 -0700

    Merge tag 'xfs-for-linus-3.15-rc5' of git://oss.sgi.com/xfs/xfs
    
    Pull xfs fixes from Dave Chinner:
     "The main fix is adding support for default ACLs on O_TMPFILE opened
      inodes to bring XFS into line with other filesystems.  Metadata CRCs
      are now also considered well enough tested to be fully supported, so
      we're removing the shouty warnings issued at mount time for
      filesystems with that format.  And there's transaction block
      reservation overrun fix.
    
      Summary:
       - fix a remote attribute size calculation bug that leads to a
         transaction overrun
       - add default ACLs to O_TMPFILE files
       - Remove the EXPERIMENTAL tag from filesystems with metadata CRC
         support"
    
    * tag 'xfs-for-linus-3.15-rc5' of git://oss.sgi.com/xfs/xfs:
      xfs: remote attribute overwrite causes transaction overrun
      xfs: initialize default acls for ->tmpfile()
      xfs: fully support v5 format filesystems

commit 9ac03675010a69507c0a9d832d6a722e07d35cc6
Merge: a798c10 0a04b24
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun Apr 20 20:43:47 2014 -0700

    Merge tag 'ext4_for_linus_stable' of git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4
    
    Pull ext4 fixes from Ted Ts'o:
     "These are regression and bug fixes for ext4.
    
      We had a number of new features in ext4 during this merge window
      (ZERO_RANGE and COLLAPSE_RANGE fallocate modes, renameat, etc.) so
      there were many more regression and bug fixes this time around.  It
      didn't help that xfstests hadn't been fully updated to fully stress
      test COLLAPSE_RANGE until after -rc1"
    
    * tag 'ext4_for_linus_stable' of git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4: (31 commits)
      ext4: disable COLLAPSE_RANGE for bigalloc
      ext4: fix COLLAPSE_RANGE failure with 1KB block size
      ext4: use EINVAL if not a regular file in ext4_collapse_range()
      ext4: enforce we are operating on a regular file in ext4_zero_range()
      ext4: fix extent merging in ext4_ext_shift_path_extents()
      ext4: discard preallocations after removing space
      ext4: no need to truncate pagecache twice in collapse range
      ext4: fix removing status extents in ext4_collapse_range()
      ext4: use filemap_write_and_wait_range() correctly in collapse range
      ext4: use truncate_pagecache() in collapse range
      ext4: remove temporary shim used to merge COLLAPSE_RANGE and ZERO_RANGE
      ext4: fix ext4_count_free_clusters() with EXT4FS_DEBUG and bigalloc enabled
      ext4: always check ext4_ext_find_extent result
      ext4: fix error handling in ext4_ext_shift_extents
      ext4: silence sparse check warning for function ext4_trim_extent
      ext4: COLLAPSE_RANGE only works on extent-based files
      ext4: fix byte order problems introduced by the COLLAPSE_RANGE patches
      ext4: use i_size_read in ext4_unaligned_aio()
      fs: disallow all fallocate operation on active swapfile
      fs: move falloc collapse range check into the filesystem methods
      ...

commit 23fffa925ea2c9a2bcb1a4453e2c542635aa3545
Author: Lukas Czerner <lczerner@redhat.com>
Date:   Sat Apr 12 09:56:41 2014 -0400

    fs: move falloc collapse range check into the filesystem methods
    
    Currently in do_fallocate in collapse range case we're checking
    whether offset + len is not bigger than i_size.  However there is
    nothing which would prevent i_size from changing so the check is
    pointless.  It should be done in the file system itself and the file
    system needs to make sure that i_size is not going to change.  The
    i_size check for the other fallocate modes are also done in the
    filesystems.
    
    As it is now we can easily crash the kernel by having two processes
    doing truncate and fallocate collapse range at the same time.  This
    can be reproduced on ext4 and it is theoretically possible on xfs even
    though I was not able to trigger it with this simple test.
    
    This commit removes the check from do_fallocate and adds it to the
    file system.
    
    Signed-off-by: Lukas Czerner <lczerner@redhat.com>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
    Acked-by: Dave Chinner <david@fromorbit.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/xfs_aops.c        | 51 ++++++++++++++++++++++++++++++++++-----
 fs/xfs/xfs_attr.c        | 24 +++++++++++++++++-
 fs/xfs/xfs_attr_leaf.c   | 21 ++++++++--------
 fs/xfs/xfs_attr_list.c   |  1 +
 fs/xfs/xfs_attr_remote.c |  8 +++---
 fs/xfs/xfs_bmap.c        | 17 ++++++++-----
 fs/xfs/xfs_bmap_util.c   | 13 +++++++++-
 fs/xfs/xfs_buf.c         | 16 +++++++++---
 fs/xfs/xfs_da_btree.h    |  2 ++
 fs/xfs/xfs_file.c        | 12 +++++++--
 fs/xfs/xfs_inode.c       |  5 ++--
 fs/xfs/xfs_inode.h       |  2 +-
 fs/xfs/xfs_iops.c        | 41 ++++++++++++++++++++++---------
 fs/xfs/xfs_log.c         | 63 ++++++++++++++++++++++++++++++++++++++----------
 fs/xfs/xfs_mount.c       |  2 --
 fs/xfs/xfs_sb.c          |  4 ---
 fs/xfs/xfs_trace.h       |  1 +
 17 files changed, 216 insertions(+), 67 deletions(-)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
