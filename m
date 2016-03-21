Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 75BBC7CA0
	for <xfs@oss.sgi.com>; Sun, 20 Mar 2016 21:07:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1F2DF8F8049
	for <xfs@oss.sgi.com>; Sun, 20 Mar 2016 19:06:59 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	m5vXFVNBzocByWF6 for <xfs@oss.sgi.com>;
	Sun, 20 Mar 2016 19:06:55 -0700 (PDT)
Date: Mon, 21 Mar 2016 13:05:05 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [GIT PULL] xfs: updates for 4.6-rc1
Message-ID: <20160321020505.GJ11812@dastard>
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
Cc: tytso@mit.edu, akpm@linux-foundation.org, jack@suse.cz, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Hi Linus,

Can you please pull the XFS update from the location below? There's
quite a lot in this request, and there's some cross-over with ext4,
dax and quota code due to the nature of the changes being made.

There are conflicts with the ext4 code that has already been merged
this cycle. Ted didn't pull the stable xfs-dio-fixes-4.6 branch with
the DIO completion unwritten extent error handling fixes before
merging a rework of the ext4 unwritten extent code, so there's a
bunch of non-trivial conflicts in that.

The quota changes don't appear to have created any conflicts at this
point - I think Jan pulled the stable xfs-get-next-dquot-4.6 branch
to base his further work on that, so I don't expect merge problems
here.

Finally, there's a merge conflict between the XFS writepages rework
and the DAX flushing fixes that were merged in 4.5-rc6. That's a
trivial conflict to resolve, though.

I've attached the merge resolution diff from my local test merge at
the end after the pull-req output - the XFS part is correct, but I'm
not sure about the ext4 parts of it. If you need confirmation as to
whether that is the correct resolution, then Ted and/or Jan (cc'd)
will need to look at it....

As for the rest of the XFS changes, there are lots of little things
all over the place, which add up to a lot of changes in the end.
The major changes are that we've reduced the size of the struct
xfs_inode by ~100 bytes (gives an inode cache footprint reduction of
>10%), the writepage code now only does a single set of mapping tree
lockups so uses less CPU, delayed allocation reservations won't
overrun under random write loads anymore, and we added compile time
verification for on-disk structure sizes so we find out when a
commit or platform/compiler change breaks the on disk structure as
early as possible.

Cheers,

Dave.


The following changes since commit 7f6aff3a29b08fc4234c8136eb1ac31b4897522c:

  xfs: only run torn log write detection on dirty logs (2016-03-07 08:22:22 +1100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git tags/xfs-for-linus-4.6-rc1

for you to fetch changes up to 2cdb958aba6afbced5bc563167813b972b6acbfe:

  Merge branch 'xfs-misc-fixes-4.6-4' into for-next (2016-03-15 11:44:35 +1100)

----------------------------------------------------------------

xfs: Changes for 4.6-rc1

Change summary:
o error propagation for direct IO failures fixes for both XFS and ext4
o new quota interfaces and XFS implementation for iterating all the quota IDs
  in the filesystem
o locking fixes for real-time device extent allocation
o reduction of duplicate information in the xfs and vfs inode, saving roughly
  100 bytes of memory per cached inode.
o buffer flag cleanup
o rework of the writepage code to use the generic write clustering mechanisms
o several fixes for inode flag based DAX enablement
o rework of remount option parsing
o compile time verification of on-disk format structure sizes
o delayed allocation reservation overrun fixes
o lots of little error handling fixes
o small memory leak fixes
o enable xfsaild freezing again

----------------------------------------------------------------
Brian Foster (6):
      xfs: clean up unwritten buffers on write failure
      xfs: fix xfs_log_ticket leak in xfs_end_io() after fs shutdown
      xfs: debug mode forced buffered write failure
      xfs: update freeblocks counter after extent deletion
      xfs: refactor delalloc indlen reservation split into helper
      xfs: borrow indirect blocks from freed extent when available

Carlos Maiolino (1):
      xfs: Split default quota limits by quota type

Christoph Hellwig (8):
      direct-io: always call ->end_io if non-NULL
      xfs: don't use ioends for direct write completions
      xfs: fold xfs_vm_do_dio into xfs_vm_direct_IO
      xfs: handle errors from ->free_blocks in xfs_btree_kill_iroot
      xfs: factor btree block freeing into a helper
      xfs: move buffer invalidation to xfs_btree_free_block
      xfs: remove xfs_trans_get_block_res
      xfs: always set rvalp in xfs_dir2_node_trim_free

Colin Ian King (1):
      xfs: fix format specifier , should be %llx and not %llu

Darrick J. Wong (5):
      xfs: move struct xfs_attr_shortform to xfs_da_format.h
      xfs: fix computation of inode btree maxlevels
      xfs: use named array initializers for log item dumping
      xfs: ioends require logically contiguous file offsets
      xfs: check sizes of XFS on-disk structures at compile time

Dave Chinner (41):
      xfs: lock rt summary inode on allocation
      xfs: RT bitmap and summary buffers are not typed
      xfs: RT bitmap and summary buffers need verifiers
      xfs: introduce inode log format object
      xfs: remove timestamps from incore inode
      xfs: cull unnecessary icdinode fields
      xfs: move v1 inode conversion to xfs_inode_from_disk
      xfs: reinitialise recycled VFS inode correctly
      xfs: use vfs inode nlink field everywhere
      xfs: move inode generation count to VFS inode
      xfs: move di_changecount to VFS inode
      xfs: mode di_mode to vfs inode
      xfs: remove XBF_DONE flag wrapper macros
      xfs: remove XBF_ASYNC flag wrapper macros
      xfs: remove XBF_READ flag wrapper macros
      xfs: remove XBF_WRITE flag wrapper macros
      xfs: remove XBF_STALE flag wrapper macros
      xfs: remove XFS_BUF_ZEROFLAGS macro
      xfs: remove nonblocking mode from xfs_vm_writepage
      xfs: remove xfs_cancel_ioend
      xfs: Introduce writeback context for writepages
      xfs: xfs_cluster_write is redundant
      xfs: factor mapping out of xfs_do_writepage
      xfs: don't chain ioends during writepage submission
      xfs: XFS_DIFLAG_DAX is only for regular files or directories
      xfs: S_DAX is only for regular files
      xfs: dynamically switch modes when XFS_DIFLAG2_DAX is set/cleared
      xfs: XFS_DIFLAG2_DAX limited by PAGE_SIZE
      xfs: reinitialise per-AG structures if geometry changes during recovery
      Merge branch 'xfs-torn-log-fixes-4.5' into for-next
      Merge branch 'xfs-rt-fixes-4.6' into for-next
      Merge branch 'xfs-get-next-dquot-4.6' into for-next
      Merge branch 'xfs-dio-fix-4.6' into for-next
      Merge branch 'xfs-misc-fixes-4.6' into for-next
      Merge branch 'xfs-gut-icdinode-4.6' into for-next
      Merge branch 'xfs-buf-macro-cleanup-4.6' into for-next
      Merge branch 'xfs-writepage-rework-4.6' into for-next
      Merge branch 'xfs-dax-fixes-4.6' into for-next
      Merge branch 'xfs-misc-fixes-4.6-2' into for-next
      Merge branch 'xfs-misc-fixes-4.6-3' into for-next
      Merge branch 'xfs-misc-fixes-4.6-4' into for-next

Eric Sandeen (12):
      quota: remove unused cmd argument from quota_quotaon()
      quota: add new quotactl Q_XGETNEXTQUOTA
      quota: add new quotactl Q_GETNEXTQUOTA
      xfs: don't overflow quota ID when initializing dqblk
      xfs: get quota inode from mp & flags rather than dqp
      xfs: Factor xfs_seek_hole_data into helper
      xfs: wire up Q_XGETNEXTQUOTA / get_nextdqblk
      xfs: remove unused function definitions
      xfs: convert mount option parsing to tokens
      xfs: sanitize remount options
      xfs: fix up inode32/64 (re)mount handling
      xfs: ensure committed is initialized in xfs_trans_roll

Jan Kara (1):
      ext4: Fix data exposure after failed AIO DIO

Luis de Bethencourt (1):
      xfs: remove impossible condition

Mateusz Guzik (1):
      xfs: fix two memory leaks in xfs_attr_list.c error paths

Michal Hocko (1):
      xfs: Make xfsaild freezeable again

 fs/dax.c                         |    9 +-
 fs/direct-io.c                   |    9 +-
 fs/ext4/ext4.h                   |   30 +-
 fs/ext4/inode.c                  |   24 +-
 fs/ext4/page-io.c                |   10 -
 fs/ocfs2/aops.c                  |    7 +-
 fs/quota/quota.c                 |   66 ++-
 fs/xfs/libxfs/xfs_alloc_btree.c  |    2 -
 fs/xfs/libxfs/xfs_attr_sf.h      |   16 -
 fs/xfs/libxfs/xfs_bmap.c         |  172 +++++--
 fs/xfs/libxfs/xfs_bmap_btree.c   |    5 +-
 fs/xfs/libxfs/xfs_btree.c        |   32 +-
 fs/xfs/libxfs/xfs_da_format.h    |   16 +
 fs/xfs/libxfs/xfs_dir2.c         |   12 +-
 fs/xfs/libxfs/xfs_dir2_node.c    |    4 +-
 fs/xfs/libxfs/xfs_ialloc.c       |    4 +-
 fs/xfs/libxfs/xfs_ialloc_btree.c |   12 +-
 fs/xfs/libxfs/xfs_inode_buf.c    |  170 ++++---
 fs/xfs/libxfs/xfs_inode_buf.h    |   38 +-
 fs/xfs/libxfs/xfs_inode_fork.c   |    3 +-
 fs/xfs/libxfs/xfs_log_format.h   |   19 +-
 fs/xfs/libxfs/xfs_quota_defs.h   |    3 +-
 fs/xfs/libxfs/xfs_rtbitmap.c     |   32 +-
 fs/xfs/libxfs/xfs_sb.h           |    1 -
 fs/xfs/libxfs/xfs_shared.h       |    1 +
 fs/xfs/xfs_aops.c                | 1016 ++++++++++++++------------------------
 fs/xfs/xfs_aops.h                |    4 +-
 fs/xfs/xfs_attr_list.c           |   19 +-
 fs/xfs/xfs_bmap_util.c           |    8 +-
 fs/xfs/xfs_buf.c                 |    2 +-
 fs/xfs/xfs_buf.h                 |   26 +-
 fs/xfs/xfs_buf_item.c            |   10 +-
 fs/xfs/xfs_dir2_readdir.c        |    2 +-
 fs/xfs/xfs_discard.c             |    2 +-
 fs/xfs/xfs_dquot.c               |  129 ++++-
 fs/xfs/xfs_export.c              |    2 +-
 fs/xfs/xfs_file.c                |   88 ++--
 fs/xfs/xfs_filestream.c          |    4 +-
 fs/xfs/xfs_fsops.h               |    1 -
 fs/xfs/xfs_icache.c              |   43 +-
 fs/xfs/xfs_inode.c               |  174 +++----
 fs/xfs/xfs_inode.h               |   10 +-
 fs/xfs/xfs_inode_item.c          |   82 ++-
 fs/xfs/xfs_ioctl.c               |  121 ++++-
 fs/xfs/xfs_iops.c                |   59 +--
 fs/xfs/xfs_itable.c              |   22 +-
 fs/xfs/xfs_log.c                 |  152 +++---
 fs/xfs/xfs_log_recover.c         |  101 ++--
 fs/xfs/xfs_mount.c               |   24 +-
 fs/xfs/xfs_mount.h               |   31 +-
 fs/xfs/xfs_ondisk.h              |  117 +++++
 fs/xfs/xfs_qm.c                  |   55 ++-
 fs/xfs/xfs_qm.h                  |   48 +-
 fs/xfs/xfs_qm_syscalls.c         |   27 +-
 fs/xfs/xfs_quotaops.c            |   36 +-
 fs/xfs/xfs_rtalloc.c             |    2 +-
 fs/xfs/xfs_super.c               |  528 +++++++++++---------
 fs/xfs/xfs_super.h               |    4 +-
 fs/xfs/xfs_sysfs.c               |   78 ++-
 fs/xfs/xfs_trace.h               |    9 +-
 fs/xfs/xfs_trans.c               |    4 +-
 fs/xfs/xfs_trans.h               |    1 -
 fs/xfs/xfs_trans_ail.c           |    5 +-
 fs/xfs/xfs_trans_buf.c           |   10 +-
 fs/xfs/xfs_trans_dquot.c         |   15 +-
 fs/xfs/xfs_trans_inode.c         |   14 +-
 include/linux/fs.h               |    2 +-
 include/linux/quota.h            |    2 +
 include/uapi/linux/dqblk_xfs.h   |    1 +
 include/uapi/linux/quota.h       |   14 +
 70 files changed, 2198 insertions(+), 1603 deletions(-)
 create mode 100644 fs/xfs/xfs_ondisk.h


commit 05f470851a43827f51e7acb12282793a795f0690
Merge: 46e595a 2cdb958
Author: Dave Chinner <david@fromorbit.com>
Date:   Mon Mar 21 12:14:09 2016 +1100

    Merge branch 'for-next' into test-merge

diff --cc fs/ext4/inode.c
index b2e9576,2b98171..e5ba3b0
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@@ -3289,10 -3161,10 +3289,10 @@@ out
  }
  #endif
  
- static void ext4_end_io_dio(struct kiocb *iocb, loff_t offset,
+ static int ext4_end_io_dio(struct kiocb *iocb, loff_t offset,
  			    ssize_t size, void *private)
  {
 -        ext4_io_end_t *io_end = iocb->private;
 +        ext4_io_end_t *io_end = private;
  
  	/* if not async direct IO just return */
  	if (!io_end)
@@@ -3300,8 -3172,18 +3300,17 @@@
  
  	ext_debug("ext4_end_io_dio(): io_end 0x%p "
  		  "for inode %lu, iocb 0x%p, offset %llu, size %zd\n",
 - 		  iocb->private, io_end->inode->i_ino, iocb, offset,
 -		  size);
 +		  io_end, io_end->inode->i_ino, iocb, offset, size);
  
+ 	iocb->private = NULL;
+ 	/*
+ 	 * Error during AIO DIO. We cannot convert unwritten extents as the
+ 	 * data was not written. Just clear the unwritten flag and drop io_end.
+ 	 */
+ 	if (size <= 0) {
+ 		ext4_clear_io_unwritten_flag(io_end);
+ 		size = 0;
+ 	}
  	io_end->offset = offset;
  	io_end->size = size;
  	ext4_put_io_end(io_end);
diff --cc fs/xfs/xfs_aops.c
index 5c57b7b,7ba680e..d445a64
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@@ -1207,12 -1006,16 +1006,20 @@@ xfs_vm_writepages
  	struct address_space	*mapping,
  	struct writeback_control *wbc)
  {
+ 	struct xfs_writepage_ctx wpc = {
+ 		.io_type = XFS_IO_INVALID,
+ 	};
+ 	int			ret;
+ 
  	xfs_iflags_clear(XFS_I(mapping->host), XFS_ITRUNCATED);
 +	if (dax_mapping(mapping))
 +		return dax_writeback_mapping_range(mapping,
 +				xfs_find_bdev_for_inode(mapping->host), wbc);
 +
- 	return generic_writepages(mapping, wbc);
+ 	ret = write_cache_pages(mapping, wbc, xfs_do_writepage, &wpc);
+ 	if (wpc.ioend)
+ 		ret = xfs_submit_ioend(wbc, wpc.ioend, ret);
+ 	return ret;
  }
  
  /*

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
