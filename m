Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, for-next,
	updated. xfs-for-linus-3.16-rc1-13101-ga497c3b
Message-Id: <20140623030053.85E227F51@oss.sgi.com>
Date: Sun, 22 Jun 2014 22:00:52 -0500 (CDT)
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

The branch, for-next has been updated
  16b9057 Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs
  9c1d528 Merge commit '9f12600fe425bc28f0ccba034a77783c09c15af4' into for-linus
  8d02076 ->splice_write() via ->write_iter()
  412dd3a Merge tag 'xfs-for-linus-3.16-rc1' of git://oss.sgi.com/xfs/xfs
  23adbe1 fs,userns: Change inode_capable to capable_wrt_inode_uidgid
  bf97f3b xfs: switch to ->write_iter()
  b4f5d2c xfs: switch to ->read_iter()
  b318891 xfs: trim the argument lists of xfs_file_{dio,buffered}_aio_write()
  0c94933 iov_iter_truncate()
  71d8e53 start adding the tag to iov_iter
  31b1403 switch {__,}blockdev_direct_IO() to iov_iter
  a6cbcd4 get rid of pointless iov_length() in ->direct_IO()
  d8d3d94 pass iov_iter to ->direct_IO()
  cb66a7a kill generic_segment_checks()
  f8579f8 generic_file_direct_write(): switch to iov_iter
      from  7691283d0561a350b7517be94818669fb5e3d910 (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit 16b9057804c02e2d351e9c8f606e909b43cbd9e7
Merge: 5c02c39 c2338f2
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu Jun 12 10:30:18 2014 -0700

    Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs
    
    Pull vfs updates from Al Viro:
     "This the bunch that sat in -next + lock_parent() fix.  This is the
      minimal set; there's more pending stuff.
    
      In particular, I really hope to get acct.c fixes merged this cycle -
      we need that to deal sanely with delayed-mntput stuff.  In the next
      pile, hopefully - that series is fairly short and localized
      (kernel/acct.c, fs/super.c and fs/namespace.c).  In this pile: more
      iov_iter work.  Most of prereqs for ->splice_write with sane locking
      order are there and Kent's dio rewrite would also fit nicely on top of
      this pile"
    
    * 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs: (70 commits)
      lock_parent: don't step on stale ->d_parent of all-but-freed one
      kill generic_file_splice_write()
      ceph: switch to iter_file_splice_write()
      shmem: switch to iter_file_splice_write()
      nfs: switch to iter_splice_write_file()
      fs/splice.c: remove unneeded exports
      ocfs2: switch to iter_file_splice_write()
      ->splice_write() via ->write_iter()
      bio_vec-backed iov_iter
      optimize copy_page_{to,from}_iter()
      bury generic_file_aio_{read,write}
      lustre: get rid of messing with iovecs
      ceph: switch to ->write_iter()
      ceph_sync_direct_write: stop poking into iov_iter guts
      ceph_sync_read: stop poking into iov_iter guts
      new helper: copy_page_from_iter()
      fuse: switch to ->write_iter()
      btrfs: switch to ->write_iter()
      ocfs2: switch to ->write_iter()
      xfs: switch to ->write_iter()
      ...

commit 9c1d5284c79fea050f115eadeec1dd1758e5c630
Merge: 5f07385 9f12600
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Thu Jun 12 00:27:11 2014 -0400

    Merge commit '9f12600fe425bc28f0ccba034a77783c09c15af4' into for-linus
    
    Backmerge of dcache.c changes from mainline.  It's that, or complete
    rebase...
    
    Conflicts:
    	fs/splice.c
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit 8d0207652cbe27d1f962050737848e5ad4671958
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Sat Apr 5 04:27:08 2014 -0400

    ->splice_write() via ->write_iter()
    
    iter_file_splice_write() - a ->splice_write() instance that gathers the
    pipe buffers, builds a bio_vec-based iov_iter covering those and feeds
    it to ->write_iter().  A bunch of simple cases coverted to that...
    
    [AV: fixed the braino spotted by Cyrill]
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit 412dd3a6daf0cadce1b2d6a34fa3713f40255579
Merge: 23d4ed5 7691283
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed Jun 11 09:03:47 2014 -0700

    Merge tag 'xfs-for-linus-3.16-rc1' of git://oss.sgi.com/xfs/xfs
    
    Pull xfs updates from Dave Chinner:
     "This update contains:
       - cleanup removing unused function args
       - rework of the filestreams allocator to use dentry cache parent
         lookups
       - new on-disk free inode btree and optimised inode allocator
       - various bug fixes
       - rework of internal attribute API
       - cleanup of superblock feature bit support to remove historic cruft
       - more fixes and minor cleanups
       - added a new directory/attribute geometry abstraction
       - yet more fixes and minor cleanups"
    
    * tag 'xfs-for-linus-3.16-rc1' of git://oss.sgi.com/xfs/xfs: (86 commits)
      xfs: fix xfs_da_args sparse warning in xfs_readdir
      xfs: Fix rounding in xfs_alloc_fix_len()
      xfs: tone down writepage/releasepage WARN_ONs
      xfs: small cleanup in xfs_lowbit64()
      xfs: kill xfs_buf_geterror()
      xfs: xfs_readsb needs to check for magic numbers
      xfs: block allocation work needs to be kswapd aware
      xfs: remove redundant geometry information from xfs_da_state
      xfs: replace attr LBSIZE with xfs_da_geometry
      xfs: pass xfs_da_args to xfs_attr_leaf_newentsize
      xfs: use xfs_da_geometry for block size in attr code
      xfs: remove mp->m_dir_geo from directory logging
      xfs: reduce direct usage of mp->m_dir_geo
      xfs: move node entry counts to xfs_da_geometry
      xfs: convert dir/attr btree threshold to xfs_da_geometry
      xfs: convert m_dirblksize to xfs_da_geometry
      xfs: convert m_dirblkfsbs to xfs_da_geometry
      xfs: convert directory segment limits to xfs_da_geometry
      xfs: convert directory db conversion to xfs_da_geometry
      xfs: convert directory dablk conversion to xfs_da_geometry
      ...

commit 23adbe12ef7d3d4195e80800ab36b37bee28cd03
Author: Andy Lutomirski <luto@amacapital.net>
Date:   Tue Jun 10 12:45:42 2014 -0700

    fs,userns: Change inode_capable to capable_wrt_inode_uidgid
    
    The kernel has no concept of capabilities with respect to inodes; inodes
    exist independently of namespaces.  For example, inode_capable(inode,
    CAP_LINUX_IMMUTABLE) would be nonsense.
    
    This patch changes inode_capable to check for uid and gid mappings and
    renames it to capable_wrt_inode_uidgid, which should make it more
    obvious what it does.
    
    Fixes CVE-2014-4014.
    
    Cc: Theodore Ts'o <tytso@mit.edu>
    Cc: Serge Hallyn <serge.hallyn@ubuntu.com>
    Cc: "Eric W. Biederman" <ebiederm@xmission.com>
    Cc: Dave Chinner <david@fromorbit.com>
    Cc: stable@vger.kernel.org
    Signed-off-by: Andy Lutomirski <luto@amacapital.net>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

commit bf97f3bc0c32140c43fe5ca53d23514ea46a54ca
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Thu Apr 3 14:20:23 2014 -0400

    xfs: switch to ->write_iter()
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit b4f5d2c6d1f88c79e48f1296076b3a6a22f58c0f
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Wed Apr 2 14:37:59 2014 -0400

    xfs: switch to ->read_iter()
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit b318891929c2750055a4002bee3e7636ca3684de
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Wed Apr 2 07:06:30 2014 -0400

    xfs: trim the argument lists of xfs_file_{dio,buffered}_aio_write()
    
    pos is redundant (it's iocb->ki_pos), and iov/nr_segs/count are taken
    care of by lifting iov_iter into the caller.
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit 0c949334a9e2581646c6ff0d1470a805b1e5be99
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Sat Mar 22 06:51:37 2014 -0400

    iov_iter_truncate()
    
    Now It Can Be Done(tm) - we don't need to do iov_shorten() in
    generic_file_direct_write() anymore, now that all ->direct_IO()
    instances are converted to proper iov_iter methods and honour
    iter->count and iter->iov_offset properly.
    
    Get rid of count/ocount arguments of generic_file_direct_write(),
    while we are at it.
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit 71d8e532b1549a478e6a6a8a44f309d050294d00
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Wed Mar 5 19:28:09 2014 -0500

    start adding the tag to iov_iter
    
    For now, just use the same thing we pass to ->direct_IO() - it's all
    iovec-based at the moment.  Pass it explicitly to iov_iter_init() and
    account for kvec vs. iovec in there, by the same kludge NFS ->direct_IO()
    uses.
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit 31b140398ce56ab41646eda7f02bcb78d6a4c916
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Wed Mar 5 01:33:16 2014 -0500

    switch {__,}blockdev_direct_IO() to iov_iter
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit a6cbcd4a4a85e2fdb0b3344b88df2e8b3d526b9e
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Tue Mar 4 22:38:00 2014 -0500

    get rid of pointless iov_length() in ->direct_IO()
    
    all callers have iov_length(iter->iov, iter->nr_segs) == iov_iter_count(iter)
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit d8d3d94b80aa1a1c0ca75c58b8abdc7356f38418
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Tue Mar 4 21:27:34 2014 -0500

    pass iov_iter to ->direct_IO()
    
    unmodified, for now
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit cb66a7a1f149ff705fa37cad6d1252b046e0ad4f
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Tue Mar 4 15:24:06 2014 -0500

    kill generic_segment_checks()
    
    all callers of ->aio_read() and ->aio_write() have iov/nr_segs already
    checked - generic_segment_checks() done after that is just an odd way
    to spell iov_length().
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit f8579f8673b7ecdb7a81d5d5bb1d981093d9aa94
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Mon Mar 3 22:03:20 2014 -0500

    generic_file_direct_write(): switch to iov_iter
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/xfs_aops.c  |  17 ++++----
 fs/xfs/xfs_file.c  | 119 ++++++++++++-----------------------------------------
 fs/xfs/xfs_ioctl.c |   2 +-
 fs/xfs/xfs_trace.h |   1 -
 4 files changed, 35 insertions(+), 104 deletions(-)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
