Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, master,
	updated. for-linus-v3.11-rc1-2-12113-gad81f05
Message-Id: <20130715224010.A15327F3F@oss.sgi.com>
Date: Mon, 15 Jul 2013 17:40:08 -0500 (CDT)
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
  239dab4 Merge tag 'for-linus-v3.11-rc1-2' of git://oss.sgi.com/xfs/xfs
  da89bd2 Merge tag 'for-linus-v3.11-rc1' of git://oss.sgi.com/xfs/xfs
  790eac5 Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs
  46a1c2c vfs: export lseek_execute() to modules
  9e239bb Merge tag 'ext4_for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4
  b822755 [readdir] convert xfs
  d302cf1 xfs: don't shutdown log recovery on validation errors
  088c9f6 xfs: ensure btree root split sets blkno correctly
  5170711 xfs: fix implicit padding in directory and attr CRC formats
  47ad2fc xfs: don't emit v5 superblock warnings on write
  0a8aa19 xfs: increase number of ACL entries for V5 superblocks
  f763fd4 xfs: disable noattr2/attr2 mount options for CRC enabled filesystems
  ad868af xfs: inode unlinked list needs to recalculate the inode CRC
  7540617 xfs: fix log recovery transaction item reordering
  ea92953 xfs: fix remote attribute invalidation for a leaf
  bb9b8e8 xfs: rework dquot CRCs
  7bc0dc2 xfs: rework remote attr CRCs
  634fd53 xfs: fully initialise temp leaf in xfs_attr3_leaf_compact
  9e80c76 xfs: fully initialise temp leaf in xfs_attr3_leaf_unbalance
  58a7228 xfs: correctly map remote attr buffers during removal
  26f7144 xfs: remote attribute tail zeroing does too much
  551b382 xfs: remote attribute read too short
  9531e2d xfs: remote attribute allocation may be contiguous
  e400d27 xfs: fix dir3 freespace block corruption
  7c9950f xfs: disable swap extents ioctl on CRC enabled filesystems
  e7927e8 xfs: add fsgeom flag for v5 superblock support.
  1de09d1 xfs: fix incorrect remote symlink block count
  7d2ffe8 xfs: fix split buffer vector log recovery support
  2962f5a xfs: kill suid/sgid through the truncate path.
  08fb390 xfs: avoid nesting transactions in xfs_qm_scall_setqlim()
  7ae0778 xfs: remote attribute lookups require the value length
  cf257ab xfs: xfs_attr_shortform_allfit() does not handle attr3 format.
  7ced60c xfs: xfs_da3_node_read_verify() doesn't handle XFS_ATTR3_LEAF_MAGIC
  b17cb36 xfs: fix missing KM_NOFS tags to keep lockdep happy
  509e708 xfs: Don't reference the EFI after it is freed
  7031d0e xfs: fix rounding in xfs_free_file_space
  480d746 xfs: fix sub-page blocksize data integrity writes
  34097df xfs: use ->invalidatepage() length argument
  d47992f mm: change invalidatepage prototype to accept length
      from  c31ad439e8d111bf911c9cc80619cebde411a44d (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit 239dab4636f7f5f971ac39b5ca84254cff112cac
Merge: f1c4108 c31ad43
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat Jul 13 11:40:24 2013 -0700

    Merge tag 'for-linus-v3.11-rc1-2' of git://oss.sgi.com/xfs/xfs
    
    Pull more xfs updates from Ben Myers:
     "Here are a fix for xfs_fsr, a cleanup in bulkstat, a cleanup in
      xfs_open_by_handle, updated mount options documentation, a cleanup in
      xfs_bmapi_write, a fix for the size of dquot log reservations, a fix
      for sgid inheritance when acls are in use, a fix for cleaning up
      quotainfo structures, and some more of the work which allows group and
      project quotas to be used together.
    
      We had a few more in this last quota category that we might have liked
      to get in, but it looks there are still a few items that need to be
      addressed.
    
       - fix for xfs_fsr returning -EINVAL
       - cleanup in xfs_bulkstat
       - cleanup in xfs_open_by_handle
       - update mount options documentation
       - clean up local format handling in xfs_bmapi_write
       - fix dquot log reservations which were too small
       - fix sgid inheritance for subdirectories when default acls are in use
       - add project quota fields to various structures
       - fix teardown of quotainfo structures when quotas are turned off"
    
    * tag 'for-linus-v3.11-rc1-2' of git://oss.sgi.com/xfs/xfs:
      xfs: Fix the logic check for all quotas being turned off
      xfs: Add pquota fields where gquota is used.
      xfs: fix sgid inheritance for subdirectories inheriting default acls [V3]
      xfs: dquot log reservations are too small
      xfs: remove local fork format handling from xfs_bmapi_write()
      xfs: update mount options documentation
      xfs: use get_unused_fd_flags(0) instead of get_unused_fd()
      xfs: clean up unused codes at xfs_bulkstat()
      xfs: use XFS_BMAP_BMDR_SPACE vs. XFS_BROOT_SIZE_ADJ

commit da89bd213fe719ec3552abbeb8be12d0cc0337ca
Merge: be0c5d8 83e782e
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue Jul 9 12:29:12 2013 -0700

    Merge tag 'for-linus-v3.11-rc1' of git://oss.sgi.com/xfs/xfs
    
    Pull xfs update from Ben Myers:
     "This includes several bugfixes, part of the work for project quotas
      and group quotas to be used together, performance improvements for
      inode creation/deletion, buffer readahead, and bulkstat,
      implementation of the inode change count, an inode create transaction,
      and the removal of a bunch of dead code.
    
      There are also some duplicate commits that you already have from the
      3.10-rc series.
    
       - part of the work to allow project quotas and group quotas to be
         used together
       - inode change count
       - inode create transaction
       - block queue plugging in buffer readahead and bulkstat
       - ordered log vector support
       - removal of dead code in and around xfs_sync_inode_grab,
         xfs_ialloc_get_rec, XFS_MOUNT_RETERR, XFS_ALLOCFREE_LOG_RES,
         XFS_DIROP_LOG_RES, xfs_chash, ctl_table, and
         xfs_growfs_data_private
       - don't keep silent if sunit/swidth can not be changed via mount
       - fix a leak of remote symlink blocks into the filesystem when xattrs
         are used on symlinks
       - fix for fiemap to return FIEMAP_EXTENT_UNKOWN flag on delay extents
       - part of a fix for xfs_fsr
       - disable speculative preallocation with small files
       - performance improvements for inode creates and deletes"
    
    * tag 'for-linus-v3.11-rc1' of git://oss.sgi.com/xfs/xfs: (61 commits)
      xfs: Remove incore use of XFS_OQUOTA_ENFD and XFS_OQUOTA_CHKD
      xfs: Change xfs_dquot_acct to be a 2-dimensional array
      xfs: Code cleanup and removal of some typedef usage
      xfs: Replace macro XFS_DQ_TO_QIP with a function
      xfs: Replace macro XFS_DQUOT_TREE with a function
      xfs: Define a new function xfs_is_quota_inode()
      xfs: implement inode change count
      xfs: Use inode create transaction
      xfs: Inode create item recovery
      xfs: Inode create transaction reservations
      xfs: Inode create log items
      xfs: Introduce an ordered buffer item
      xfs: Introduce ordered log vector support
      xfs: xfs_ifree doesn't need to modify the inode buffer
      xfs: don't do IO when creating an new inode
      xfs: don't use speculative prealloc for small files
      xfs: plug directory buffer readahead
      xfs: add pluging for bulkstat readahead
      xfs: Remove dead function prototype xfs_sync_inode_grab()
      xfs: Remove the left function variable from xfs_ialloc_get_rec()
      ...

commit 790eac5640abf7a57fa3a644386df330e18c11b0
Merge: 0b0585c 48bde8d
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed Jul 3 09:10:19 2013 -0700

    Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs
    
    Pull second set of VFS changes from Al Viro:
     "Assorted f_pos race fixes, making do_splice_direct() safe to call with
      i_mutex on parent, O_TMPFILE support, Jeff's locks.c series,
      ->d_hash/->d_compare calling conventions changes from Linus, misc
      stuff all over the place."
    
    * 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs: (63 commits)
      Document ->tmpfile()
      ext4: ->tmpfile() support
      vfs: export lseek_execute() to modules
      lseek_execute() doesn't need an inode passed to it
      block_dev: switch to fixed_size_llseek()
      cpqphp_sysfs: switch to fixed_size_llseek()
      tile-srom: switch to fixed_size_llseek()
      proc_powerpc: switch to fixed_size_llseek()
      ubi/cdev: switch to fixed_size_llseek()
      pci/proc: switch to fixed_size_llseek()
      isapnp: switch to fixed_size_llseek()
      lpfc: switch to fixed_size_llseek()
      locks: give the blocked_hash its own spinlock
      locks: add a new "lm_owner_key" lock operation
      locks: turn the blocked_list into a hashtable
      locks: convert fl_link to a hlist_node
      locks: avoid taking global lock if possible when waking up blocked waiters
      locks: protect most of the file_lock handling with i_lock
      locks: encapsulate the fl_link list handling
      locks: make "added" in __posix_lock_file a bool
      ...

commit 46a1c2c7ae53de2a5676754b54a73c591a3951d2
Author: Jie Liu <jeff.liu@oracle.com>
Date:   Tue Jun 25 12:02:13 2013 +0800

    vfs: export lseek_execute() to modules
    
    For those file systems(btrfs/ext4/ocfs2/tmpfs) that support
    SEEK_DATA/SEEK_HOLE functions, we end up handling the similar
    matter in lseek_execute() to update the current file offset
    to the desired offset if it is valid, ceph also does the
    simliar things at ceph_llseek().
    
    To reduce the duplications, this patch make lseek_execute()
    public accessible so that we can call it directly from the
    underlying file systems.
    
    Thanks Dave Chinner for this suggestion.
    
    [AV: call it vfs_setpos(), don't bring the removed 'inode' argument back]
    
    v2->v1:
    - Add kernel-doc comments for lseek_execute()
    - Call lseek_execute() in ceph->llseek()
    
    Signed-off-by: Jie Liu <jeff.liu@oracle.com>
    Cc: Dave Chinner <dchinner@redhat.com>
    Cc: Al Viro <viro@zeniv.linux.org.uk>
    Cc: Andi Kleen <andi@firstfloor.org>
    Cc: Andrew Morton <akpm@linux-foundation.org>
    Cc: Christoph Hellwig <hch@lst.de>
    Cc: Chris Mason <chris.mason@fusionio.com>
    Cc: Josef Bacik <jbacik@fusionio.com>
    Cc: Ben Myers <bpm@sgi.com>
    Cc: Ted Tso <tytso@mit.edu>
    Cc: Hugh Dickins <hughd@google.com>
    Cc: Mark Fasheh <mfasheh@suse.com>
    Cc: Joel Becker <jlbec@evilplan.org>
    Cc: Sage Weil <sage@inktank.com>
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit 9e239bb93914e1c832d54161c7f8f398d0c914ab
Merge: 63580e5 6ae06ff
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue Jul 2 09:39:34 2013 -0700

    Merge tag 'ext4_for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4
    
    Pull ext4 update from Ted Ts'o:
     "Lots of bug fixes, cleanups and optimizations.  In the bug fixes
      category, of note is a fix for on-line resizing file systems where the
      block size is smaller than the page size (i.e., file systems 1k blocks
      on x86, or more interestingly file systems with 4k blocks on Power or
      ia64 systems.)
    
      In the cleanup category, the ext4's punch hole implementation was
      significantly improved by Lukas Czerner, and now supports bigalloc
      file systems.  In addition, Jan Kara significantly cleaned up the
      write submission code path.  We also improved error checking and added
      a few sanity checks.
    
      In the optimizations category, two major optimizations deserve
      mention.  The first is that ext4_writepages() is now used for
      nodelalloc and ext3 compatibility mode.  This allows writes to be
      submitted much more efficiently as a single bio request, instead of
      being sent as individual 4k writes into the block layer (which then
      relied on the elevator code to coalesce the requests in the block
      queue).  Secondly, the extent cache shrink mechanism, which was
      introduce in 3.9, no longer has a scalability bottleneck caused by the
      i_es_lru spinlock.  Other optimizations include some changes to reduce
      CPU usage and to avoid issuing empty commits unnecessarily."
    
    * tag 'ext4_for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4: (86 commits)
      ext4: optimize starting extent in ext4_ext_rm_leaf()
      jbd2: invalidate handle if jbd2_journal_restart() fails
      ext4: translate flag bits to strings in tracepoints
      ext4: fix up error handling for mpage_map_and_submit_extent()
      jbd2: fix theoretical race in jbd2__journal_restart
      ext4: only zero partial blocks in ext4_zero_partial_blocks()
      ext4: check error return from ext4_write_inline_data_end()
      ext4: delete unnecessary C statements
      ext3,ext4: don't mess with dir_file->f_pos in htree_dirblock_to_tree()
      jbd2: move superblock checksum calculation to jbd2_write_superblock()
      ext4: pass inode pointer instead of file pointer to punch hole
      ext4: improve free space calculation for inline_data
      ext4: reduce object size when !CONFIG_PRINTK
      ext4: improve extent cache shrink mechanism to avoid to burn CPU time
      ext4: implement error handling of ext4_mb_new_preallocation()
      ext4: fix corruption when online resizing a fs with 1K block size
      ext4: delete unused variables
      ext4: return FIEMAP_EXTENT_UNKNOWN for delalloc extents
      jbd2: remove debug dependency on debug_fs and update Kconfig help text
      jbd2: use a single printk for jbd_debug()
      ...

commit b8227554c951eb144e975c5e741d33f29c29596f
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Wed May 22 17:07:56 2013 -0400

    [readdir] convert xfs
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit d302cf1d316dca5f567e89872cf5d475c9a55f74
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Jun 12 12:19:06 2013 +1000

    xfs: don't shutdown log recovery on validation errors
    
    Unfortunately, we cannot guarantee that items logged multiple times
    and replayed by log recovery do not take objects back in time. When
    they are taken back in time, the go into an intermediate state which
    is corrupt, and hence verification that occurs on this intermediate
    state causes log recovery to abort with a corruption shutdown.
    
    Instead of causing a shutdown and unmountable filesystem, don't
    verify post-recovery items before they are written to disk. This is
    less than optimal, but there is no way to detect this issue for
    non-CRC filesystems If log recovery successfully completes, this
    will be undone and the object will be consistent by subsequent
    transactions that are replayed, so in most cases we don't need to
    take drastic action.
    
    For CRC enabled filesystems, leave the verifiers in place - we need
    to call them to recalculate the CRCs on the objects anyway. This
    recovery problem can be solved for such filesystems - we have a LSN
    stamped in all metadata at writeback time that we can to determine
    whether the item should be replayed or not. This is a separate piece
    of work, so is not addressed by this patch.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>
    
    (cherry picked from commit 9222a9cf86c0d64ffbedf567412b55da18763aa3)

commit 088c9f67c3f53339d2bc20b42a9cb904901fdc5d
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Jun 12 12:19:08 2013 +1000

    xfs: ensure btree root split sets blkno correctly
    
    For CRC enabled filesystems, the BMBT is rooted in an inode, so it
    passes through a different code path on root splits than the
    freespace and inode btrees. This is much less traversed by xfstests
    than the other trees. When testing on a 1k block size filesystem,
    I've been seeing ASSERT failures in generic/234 like:
    
    XFS: Assertion failed: cur->bc_btnum != XFS_BTNUM_BMAP || cur->bc_private.b.allocated == 0, file: fs/xfs/xfs_btree.c, line: 317
    
    which are generally preceded by a lblock check failure. I noticed
    this in the bmbt stats:
    
    $ pminfo -f xfs.btree.block_map
    
    xfs.btree.block_map.lookup
        value 39135
    
    xfs.btree.block_map.compare
        value 268432
    
    xfs.btree.block_map.insrec
        value 15786
    
    xfs.btree.block_map.delrec
        value 13884
    
    xfs.btree.block_map.newroot
        value 2
    
    xfs.btree.block_map.killroot
        value 0
    .....
    
    Very little coverage of root splits and merges. Indeed, on a 4k
    filesystem, block_map.newroot and block_map.killroot are both zero.
    i.e. the code is not exercised at all, and it's the only generic
    btree infrastructure operation that is not exercised by a default run
    of xfstests.
    
    Turns out that on a 1k filesystem, generic/234 accounts for one of
    those two root splits, and that is somewhat of a smoking gun. In
    fact, it's the same problem we saw in the directory/attr code where
    headers are memcpy()d from one block to another without updating the
    self describing metadata.
    
    Simple fix - when copying the header out of the root block, make
    sure the block number is updated correctly.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>
    
    (cherry picked from commit ade1335afef556df6538eb02e8c0dc91fbd9cc37)

commit 5170711df79b284cf95b3924322e8ac4c0fd6c76
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Jun 12 12:19:07 2013 +1000

    xfs: fix implicit padding in directory and attr CRC formats
    
    Michael L. Semon has been testing CRC patches on a 32 bit system and
    been seeing assert failures in the directory code from xfs/080.
    Thanks to Michael's heroic efforts with printk debugging, we found
    that the problem was that the last free space being left in the
    directory structure was too small to fit a unused tag structure and
    it was being corrupted and attempting to log a region out of bounds.
    Hence the assert failure looked something like:
    
    .....
    #5 calling xfs_dir2_data_log_unused() 36 32
    #1 4092 4095 4096
    #2 8182 8183 4096
    XFS: Assertion failed: first <= last && last < BBTOB(bp->b_length), file: fs/xfs/xfs_trans_buf.c, line: 568
    
    Where #1 showed the first region of the dup being logged (i.e. the
    last 4 bytes of a directory buffer) and #2 shows the corrupt values
    being calculated from the length of the dup entry which overflowed
    the size of the buffer.
    
    It turns out that the problem was not in the logging code, nor in
    the freespace handling code. It is an initial condition bug that
    only shows up on 32 bit systems. When a new buffer is initialised,
    where's the freespace that is set up:
    
    [  172.316249] calling xfs_dir2_leaf_addname() from xfs_dir_createname()
    [  172.316346] #9 calling xfs_dir2_data_log_unused()
    [  172.316351] #1 calling xfs_trans_log_buf() 60 63 4096
    [  172.316353] #2 calling xfs_trans_log_buf() 4094 4095 4096
    
    Note the offset of the first region being logged? It's 60 bytes into
    the buffer. Once I saw that, I pretty much knew that the bug was
    going to be caused by this.
    
    Essentially, all direct entries are rounded to 8 bytes in length,
    and all entries start with an 8 byte alignment. This means that we
    can decode inplace as variables are naturally aligned. With the
    directory data supposedly starting on a 8 byte boundary, and all
    entries padded to 8 bytes, the minimum freespace in a directory
    block is supposed to be 8 bytes, which is large enough to fit a
    unused data entry structure (6 bytes in size). The fact we only have
    4 bytes of free space indicates a directory data block alignment
    problem.
    
    And what do you know - there's an implicit hole in the directory
    data block header for the CRC format, which means the header is 60
    byte on 32 bit intel systems and 64 bytes on 64 bit systems. Needs
    padding. And while looking at the structures, I found the same
    problem in the attr leaf header. Fix them both.
    
    Note that this only affects 32 bit systems with CRCs enabled.
    Everything else is just fine. Note that CRC enabled filesystems created
    before this fix on such systems will not be readable with this fix
    applied.
    
    Reported-by: Michael L. Semon <mlsemon35@gmail.com>
    Debugged-by: Michael L. Semon <mlsemon35@gmail.com>
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>
    
    (cherry picked from commit 8a1fd2950e1fe267e11fc8c85dcaa6b023b51b60)

commit 47ad2fcba9ddd0630acccb13c71f19a818947751
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon May 27 16:38:19 2013 +1000

    xfs: don't emit v5 superblock warnings on write
    
    We write the superblock every 30s or so which results in the
    verifier being called. Right now that results in this output
    every 30s:
    
    XFS (vda): Version 5 superblock detected. This kernel has EXPERIMENTAL support enabled!
    Use of these features in this kernel is at your own risk!
    
    And spamming the logs.
    
    We don't need to check for whether we support v5 superblocks or
    whether there are feature bits we don't support set as these are
    only relevant when we first mount the filesytem. i.e. on superblock
    read. Hence for the write verification we can just skip all the
    checks (and hence verbose output) altogether.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>
    
    (cherry picked from commit 34510185abeaa5be9b178a41c0a03d30aec3db7e)

commit 0a8aa1939777dd114479677f0044652c1fd72398
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Jun 5 12:09:10 2013 +1000

    xfs: increase number of ACL entries for V5 superblocks
    
    The limit of 25 ACL entries is arbitrary, but baked into the on-disk
    format.  For version 5 superblocks, increase it to the maximum nuber
    of ACLs that can fit into a single xattr.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Mark Tinguely <tinuguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>
    
    (cherry picked from commit 5c87d4bc1a86bd6e6754ac3d6e111d776ddcfe57)

commit f763fd440e094be37b38596ee14f1d64caa9bf9c
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Jun 5 12:09:09 2013 +1000

    xfs: disable noattr2/attr2 mount options for CRC enabled filesystems
    
    attr2 format is always enabled for v5 superblock filesystems, so the
    mount options to enable or disable it need to be cause mount errors.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>
    
    (cherry picked from commit d3eaace84e40bf946129e516dcbd617173c1cf14)

commit ad868afddb908a5d4015c6b7637721b48fb9c8f9
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Jun 5 12:09:08 2013 +1000

    xfs: inode unlinked list needs to recalculate the inode CRC
    
    The inode unlinked list manipulations operate directly on the inode
    buffer, and so bypass the inode CRC calculation mechanisms. Hence an
    inode on the unlinked list has an invalid CRC. Fix this by
    recalculating the CRC whenever we modify an unlinked list pointer in
    an inode, ncluding during log recovery. This is trivial to do and
    results in  unlinked list operations always leaving a consistent
    inode in the buffer.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>
    
    (cherry picked from commit 0a32c26e720a8b38971d0685976f4a7d63f9e2ef)

commit 75406170751b4de88a01f73dda56efa617ddd5d7
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Jun 5 12:09:07 2013 +1000

    xfs: fix log recovery transaction item reordering
    
    There are several constraints that inode allocation and unlink
    logging impose on log recovery. These all stem from the fact that
    inode alloc/unlink are logged in buffers, but all other inode
    changes are logged in inode items. Hence there are ordering
    constraints that recovery must follow to ensure the correct result
    occurs.
    
    As it turns out, this ordering has been working mostly by chance
    than good management. The existing code moves all buffers except
    cancelled buffers to the head of the list, and everything else to
    the tail of the list. The problem with this is that is interleaves
    inode items with the buffer cancellation items, and hence whether
    the inode item in an cancelled buffer gets replayed is essentially
    left to chance.
    
    Further, this ordering causes problems for log recovery when inode
    CRCs are enabled. It typically replays the inode unlink buffer long before
    it replays the inode core changes, and so the CRC recorded in an
    unlink buffer is going to be invalid and hence any attempt to
    validate the inode in the buffer is going to fail. Hence we really
    need to enforce the ordering that the inode alloc/unlink code has
    expected log recovery to have since inode chunk de-allocation was
    introduced back in 2003...
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>
    
    (cherry picked from commit a775ad778073d55744ed6709ccede36310638911)

commit ea929536a43226a01d1a73ac8b14d52e81163bd4
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Jun 3 15:28:49 2013 +1000

    xfs: fix remote attribute invalidation for a leaf
    
    When invalidating an attribute leaf block block, there might be
    remote attributes that it points to. With the recent rework of the
    remote attribute format, we have to make sure we calculate the
    length of the attribute correctly. We aren't doing that in
    xfs_attr3_leaf_inactive(), so fix it.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Mark Tinguely <tinuguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>
    
    (cherry picked from commit 59913f14dfe8eb772ff93eb442947451b4416329)

commit bb9b8e86ad083ecb2567ae909c1d6cb0bbaa60fe
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Jun 3 15:28:46 2013 +1000

    xfs: rework dquot CRCs
    
    Calculating dquot CRCs when the backing buffer is written back just
    doesn't work reliably. There are several places which manipulate
    dquots directly in the buffers, and they don't calculate CRCs
    appropriately, nor do they always set the buffer up to calculate
    CRCs appropriately.
    
    Firstly, if we log a dquot buffer (e.g. during allocation) it gets
    logged without valid CRC, and so on recovery we end up with a dquot
    that is not valid.
    
    Secondly, if we recover/repair a dquot, we don't have a verifier
    attached to the buffer and hence CRCs are not calculated on the way
    down to disk.
    
    Thirdly, calculating the CRC after we've changed the contents means
    that if we re-read the dquot from the buffer, we cannot verify the
    contents of the dquot are valid, as the CRC is invalid.
    
    So, to avoid all the dquot CRC errors that are being detected by the
    read verifier, change to using the same model as for inodes. That
    is, dquot CRCs are calculated and written to the backing buffer at
    the time the dquot is flushed to the backing buffer. If we modify
    the dquot directly in the backing buffer, calculate the CRC
    immediately after the modification is complete. Hence the dquot in
    the on-disk buffer should always have a valid CRC.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>
    
    (cherry picked from commit 6fcdc59de28817d1fbf1bd58cc01f4f3fac858fb)

commit 7bc0dc271e494e12be3afd3c6431e5216347c624
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue May 21 18:02:08 2013 +1000

    xfs: rework remote attr CRCs
    
    Note: this changes the on-disk remote attribute format. I assert
    that this is OK to do as CRCs are marked experimental and the first
    kernel it is included in has not yet reached release yet. Further,
    the userspace utilities are still evolving and so anyone using this
    stuff right now is a developer or tester using volatile filesystems
    for testing this feature. Hence changing the format right now to
    save longer term pain is the right thing to do.
    
    The fundamental change is to move from a header per extent in the
    attribute to a header per filesytem block in the attribute. This
    means there are more header blocks and the parsing of the attribute
    data is slightly more complex, but it has the advantage that we
    always know the size of the attribute on disk based on the length of
    the data it contains.
    
    This is where the header-per-extent method has problems. We don't
    know the size of the attribute on disk without first knowing how
    many extents are used to hold it. And we can't tell from a
    mapping lookup, either, because remote attributes can be allocated
    contiguously with other attribute blocks and so there is no obvious
    way of determining the actual size of the atribute on disk short of
    walking and mapping buffers.
    
    The problem with this approach is that if we map a buffer
    incorrectly (e.g. we make the last buffer for the attribute data too
    long), we then get buffer cache lookup failure when we map it
    correctly. i.e. we get a size mismatch on lookup. This is not
    necessarily fatal, but it's a cache coherency problem that can lead
    to returning the wrong data to userspace or writing the wrong data
    to disk. And debug kernels will assert fail if this occurs.
    
    I found lots of niggly little problems trying to fix this issue on a
    4k block size filesystem, finally getting it to pass with lots of
    fixes. The thing is, 1024 byte filesystems still failed, and it was
    getting really complex handling all the corner cases that were
    showing up. And there were clearly more that I hadn't found yet.
    
    It is complex, fragile code, and if we don't fix it now, it will be
    complex, fragile code forever more.
    
    Hence the simple fix is to add a header to each filesystem block.
    This gives us the same relationship between the attribute data
    length and the number of blocks on disk as we have without CRCs -
    it's a linear mapping and doesn't require us to guess anything. It
    is simple to implement, too - the remote block count calculated at
    lookup time can be used by the remote attribute set/get/remove code
    without modification for both CRC and non-CRC filesystems. The world
    becomes sane again.
    
    Because the copy-in and copy-out now need to iterate over each
    filesystem block, I moved them into helper functions so we separate
    the block mapping and buffer manupulations from the attribute data
    and CRC header manipulations. The code becomes much clearer as a
    result, and it is a lot easier to understand and debug. It also
    appears to be much more robust - once it worked on 4k block size
    filesystems, it has worked without failure on 1k block size
    filesystems, too.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>
    
    (cherry picked from commit ad1858d77771172e08016890f0eb2faedec3ecee)

commit 634fd5322a3e6ae632dcf5f20eebc0583ba50838
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue May 21 18:02:06 2013 +1000

    xfs: fully initialise temp leaf in xfs_attr3_leaf_compact
    
    xfs_attr3_leaf_compact() uses a temporary buffer for compacting the
    the entries in a leaf. It copies the the original buffer into the
    temporary buffer, then zeros the original buffer completely. It then
    copies the entries back into the original buffer.  However, the
    original buffer has not been correctly initialised, and so the
    movement of the entries goes horribly wrong.
    
    Make sure the zeroed destination buffer is fully initialised, and
    once we've set up the destination incore header appropriately, write
    is back to the buffer before starting to move entries around.
    
    While debugging this, the _d/_s prefixes weren't sufficient to
    remind me what buffer was what, so rename then all _src/_dst.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>
    
    (cherry picked from commit d4c712bcf26a25c2b67c90e44e0b74c7993b5334)

commit 9e80c76205b46b338cb56c336148f54b2326342f
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue May 21 18:02:05 2013 +1000

    xfs: fully initialise temp leaf in xfs_attr3_leaf_unbalance
    
    xfs_attr3_leaf_unbalance() uses a temporary buffer for recombining
    the entries in two leaves when the destination leaf requires
    compaction. The temporary buffer ends up being copied back over the
    original destination buffer, so the header in the temporary buffer
    needs to contain all the information that is in the destination
    buffer.
    
    To make sure the temporary buffer is fully initialised, once we've
    set up the temporary incore header appropriately, write is back to
    the temporary buffer before starting to move entries around.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>
    
    (cherry picked from commit 8517de2a81da830f5d90da66b4799f4040c76dc9)

commit 58a72281555bf301f6dff24db2db205c87ef8db1
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue May 21 18:02:04 2013 +1000

    xfs: correctly map remote attr buffers during removal
    
    If we don't map the buffers correctly (same as for get/set
    operations) then the incore buffer lookup will fail. If a block
    number matches but a length is wrong, then debug kernels will ASSERT
    fail in _xfs_buf_find() due to the length mismatch. Ensure that we
    map the buffers correctly by basing the length of the buffer on the
    attribute data length rather than the remote block count.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>
    
    (cherry picked from commit 6863ef8449f1908c19f43db572e4474f24a1e9da)

commit 26f714450c3907ce07c41a0bd1bea40368e0b4da
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue May 21 18:02:03 2013 +1000

    xfs: remote attribute tail zeroing does too much
    
    When an attribute data does not fill then entire remote block, we
    zero the remaining part of the buffer. This, however, needs to take
    into account that the buffer has a header, and so the offset where
    zeroing starts and the length of zeroing need to take this into
    account. Otherwise we end up with zeros over the end of the
    attribute value when CRCs are enabled.
    
    While there, make sure we only ask to map an extent that covers the
    remaining range of the attribute, rather than asking every time for
    the full length of remote data. If the remote attribute blocks are
    contiguous with other parts of the attribute tree, it will map those
    blocks as well and we can potentially zero them incorrectly. We can
    also get buffer size mistmatches when trying to read or remove the
    remote attribute, and this can lead to not finding the correct
    buffer when looking it up in cache.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>
    
    (cherry picked from commit 4af3644c9a53eb2f1ecf69cc53576561b64be4c6)

commit 551b382f5368900d6d82983505cb52553c946a2b
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue May 21 18:02:02 2013 +1000

    xfs: remote attribute read too short
    
    Reading a maximally size remote attribute fails when CRCs are
    enabled with this verification error:
    
    XFS (vdb): remote attribute header does not match required off/len/owner)
    
    There are two reasons for this, the first being that the
    length of the buffer being read is determined from the
    args->rmtblkcnt which doesn't take into account CRC headers. Hence
    the mapped length ends up being too short and so we need to
    calculate it directly from the value length.
    
    The second is that the byte count of valid data within a buffer is
    capped by the length of the data and so doesn't take into account
    that the buffer might be longer due to headers. Hence we need to
    calculate the data space in the buffer first before calculating the
    actual byte count of data.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>
    
    (cherry picked from commit 913e96bc292e1bb248854686c79d6545ef3ee720)

commit 9531e2de6b7f04bd734b4bbc1e16a6955121615a
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue May 21 18:02:01 2013 +1000

    xfs: remote attribute allocation may be contiguous
    
    When CRCs are enabled, there may be multiple allocations made if the
    headers cause a length overflow. This, however, does not mean that
    the number of headers required increases, as the second and
    subsequent extents may be contiguous with the previous extent. Hence
    when we map the extents to write the attribute data, we may end up
    with less extents than allocations made. Hence the assertion that we
    consume the number of headers we calculated in the allocation loop
    is incorrect and needs to be removed.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>
    
    (cherry picked from commit 90253cf142469a40f89f989904abf0a1e500e1a6)

commit e400d27d1690d609f203f2d7d8efebc98cbc3089
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue May 28 18:37:17 2013 +1000

    xfs: fix dir3 freespace block corruption
    
    When the directory freespace index grows to a second block (2017
    4k data blocks in the directory), the initialisation of the second
    new block header goes wrong. The write verifier fires a corruption
    error indicating that the block number in the header is zero. This
    was being tripped by xfs/110.
    
    The problem is that the initialisation of the new block is done just
    fine in xfs_dir3_free_get_buf(), but the caller then users a dirv2
    structure to zero on-disk header fields that xfs_dir3_free_get_buf()
    has already zeroed. These lined up with the block number in the dir
    v3 header format.
    
    While looking at this, I noticed that the struct xfs_dir3_free_hdr()
    had 4 bytes of padding in it that wasn't defined as padding or being
    zeroed by the initialisation. Add a pad field declaration and fully
    zero the on disk and in-core headers in xfs_dir3_free_get_buf() so
    that this is never an issue in the future. Note that this doesn't
    change the on-disk layout, just makes the 32 bits of padding in the
    layout explicit.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>
    
    (cherry picked from commit 5ae6e6a401957698f2bd8c9f4a86d86d02199fea)

commit 7c9950fd2ac97431230544142d5e652e1b948372
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon May 27 16:38:24 2013 +1000

    xfs: disable swap extents ioctl on CRC enabled filesystems
    
    Currently, swapping extents from one inode to another is a simple
    act of switching data and attribute forks from one inode to another.
    This, unfortunately in no longer so simple with CRC enabled
    filesystems as there is owner information embedded into the BMBT
    blocks that are swapped between inodes. Hence swapping the forks
    between inodes results in the inodes having mapping blocks that
    point to the wrong owner and hence are considered corrupt.
    
    To fix this we need an extent tree block or record based swap
    algorithm so that the BMBT block owner information can be updated
    atomically in the swap transaction. This is a significant piece of
    new work, so for the moment simply don't allow swap extent
    operations to succeed on CRC enabled filesystems.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>
    
    (cherry picked from commit 02f75405a75eadfb072609f6bf839e027de6a29a)

commit e7927e879d12d27aa06b9bbed57cc32dcd7d17fd
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon May 27 16:38:26 2013 +1000

    xfs: add fsgeom flag for v5 superblock support.
    
    Currently userspace has no way of determining that a filesystem is
    CRC enabled. Add a flag to the XFS_IOC_FSGEOMETRY ioctl output to
    indicate that the filesystem has v5 superblock support enabled.
    This will allow xfs_info to correctly report the state of the
    filesystem.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Eric Sandeen <sandeen@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>
    
    (cherry picked from commit 74137fff067961c9aca1e14d073805c3de8549bd)

commit 1de09d1ae48152e56399aba0bfd984fb0ddae6b0
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon May 27 16:38:20 2013 +1000

    xfs: fix incorrect remote symlink block count
    
    When CRCs are enabled, the number of blocks needed to hold a remote
    symlink on a 1k block size filesystem may be 2 instead of 1. The
    transaction reservation for the allocated blocks was not taking this
    into account and only allocating one block. Hence when trying to
    read or invalidate such symlinks, we are mapping a hole where there
    should be a block and things go bad at that point.
    
    Fix the reservation to use the correct block count, clean up the
    block count calculation similar to the remote attribute calculation,
    and add a debug guard to detect when we don't write the entire
    symlink to disk.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>
    
    (cherry picked from commit 321a95839e65db3759a07a3655184b0283af90fe)

commit 7d2ffe80aa000a149246b3745968634192eb5358
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon May 27 16:38:23 2013 +1000

    xfs: fix split buffer vector log recovery support
    
    A long time ago in a galaxy far away....
    
    .. the was a commit made to fix some ilinux specific "fragmented
    buffer" log recovery problem:
    
    http://oss.sgi.com/cgi-bin/gitweb.cgi?p=archive/xfs-import.git;a=commitdiff;h=b29c0bece51da72fb3ff3b61391a391ea54e1603
    
    That problem occurred when a contiguous dirty region of a buffer was
    split across across two pages of an unmapped buffer. It's been a
    long time since that has been done in XFS, and the changes to log
    the entire inode buffers for CRC enabled filesystems has
    re-introduced that corner case.
    
    And, of course, it turns out that the above commit didn't actually
    fix anything - it just ensured that log recovery is guaranteed to
    fail when this situation occurs. And now for the gory details.
    
    xfstest xfs/085 is failing with this assert:
    
    XFS (vdb): bad number of regions (0) in inode log format
    XFS: Assertion failed: 0, file: fs/xfs/xfs_log_recover.c, line: 1583
    
    Largely undocumented factoid #1: Log recovery depends on all log
    buffer format items starting with this format:
    
    struct foo_log_format {
    	__uint16_t	type;
    	__uint16_t	size;
    	....
    
    As recoery uses the size field and assumptions about 32 bit
    alignment in decoding format items.  So don't pay much attention to
    the fact log recovery thinks that it decoding an inode log format
    item - it just uses them to determine what the size of the item is.
    
    But why would it see a log format item with a zero size? Well,
    luckily enough xfs_logprint uses the same code and gives the same
    error, so with a bit of gdb magic, it turns out that it isn't a log
    format that is being decoded. What logprint tells us is this:
    
    Oper (130): tid: a0375e1a  len: 28  clientid: TRANS  flags: none
    BUF:  #regs: 2   start blkno: 144 (0x90)  len: 16  bmap size: 2  flags: 0x4000
    Oper (131): tid: a0375e1a  len: 4096  clientid: TRANS  flags: none
    BUF DATA
    ----------------------------------------------------------------------------
    Oper (132): tid: a0375e1a  len: 4096  clientid: TRANS  flags: none
    xfs_logprint: unknown log operation type (4e49)
    **********************************************************************
    * ERROR: data block=2                                                 *
    **********************************************************************
    
    That we've got a buffer format item (oper 130) that has two regions;
    the format item itself and one dirty region. The subsequent region
    after the buffer format item and it's data is them what we are
    tripping over, and the first bytes of it at an inode magic number.
    Not a log opheader like there is supposed to be.
    
    That means there's a problem with the buffer format item. It's dirty
    data region is 4096 bytes, and it contains - you guessed it -
    initialised inodes. But inode buffers are 8k, not 4k, and we log
    them in their entirety. So something is wrong here. The buffer
    format item contains:
    
    (gdb) p /x *(struct xfs_buf_log_format *)in_f
    $22 = {blf_type = 0x123c, blf_size = 0x2, blf_flags = 0x4000,
           blf_len = 0x10, blf_blkno = 0x90, blf_map_size = 0x2,
           blf_data_map = {0xffffffff, 0xffffffff, .... }}
    
    Two regions, and a signle dirty contiguous region of 64 bits.  64 *
    128 = 8k, so this should be followed by a single 8k region of data.
    And the blf_flags tell us that the type of buffer is a
    XFS_BLFT_DINO_BUF. It contains inodes. And because it doesn't have
    the XFS_BLF_INODE_BUF flag set, that means it's an inode allocation
    buffer. So, it should be followed by 8k of inode data.
    
    But we know that the next region has a header of:
    
    (gdb) p /x *ohead
    $25 = {oh_tid = 0x1a5e37a0, oh_len = 0x100000, oh_clientid = 0x69,
           oh_flags = 0x0, oh_res2 = 0x0}
    
    and so be32_to_cpu(oh_len) = 0x1000 = 4096 bytes. It's simply not
    long enough to hold all the logged data. There must be another
    region. There is - there's a following opheader for another 4k of
    data that contains the other half of the inode cluster data - the
    one we assert fail on because it's not a log format header.
    
    So why is the second part of the data not being accounted to the
    correct buffer log format structure? It took a little more work with
    gdb to work out that the buffer log format structure was both
    expecting it to be there but hadn't accounted for it. It was at that
    point I went to the kernel code, as clearly this wasn't a bug in
    xfs_logprint and the kernel was writing bad stuff to the log.
    
    First port of call was the buffer item formatting code, and the
    discontiguous memory/contiguous dirty region handling code
    immediately stood out. I've wondered for a long time why the code
    had this comment in it:
    
                            vecp->i_addr = xfs_buf_offset(bp, buffer_offset);
                            vecp->i_len = nbits * XFS_BLF_CHUNK;
                            vecp->i_type = XLOG_REG_TYPE_BCHUNK;
    /*
     * You would think we need to bump the nvecs here too, but we do not
     * this number is used by recovery, and it gets confused by the boundary
     * split here
     *                      nvecs++;
     */
                            vecp++;
    
    And it didn't account for the extra vector pointer. The case being
    handled here is that a contiguous dirty region lies across a
    boundary that cannot be memcpy()d across, and so has to be split
    into two separate operations for xlog_write() to perform.
    
    What this code assumes is that what is written to the log is two
    consecutive blocks of data that are accounted in the buf log format
    item as the same contiguous dirty region and so will get decoded as
    such by the log recovery code.
    
    The thing is, xlog_write() knows nothing about this, and so just
    does it's normal thing of adding an opheader for each vector. That
    means the 8k region gets written to the log as two separate regions
    of 4k each, but because nvecs has not been incremented, the buf log
    format item accounts for only one of them.
    
    Hence when we come to log recovery, we process the first 4k region
    and then expect to come across a new item that starts with a log
    format structure of some kind that tells us whenteh next data is
    going to be. Instead, we hit raw buffer data and things go bad real
    quick.
    
    So, the commit from 2002 that commented out nvecs++ is just plain
    wrong. It breaks log recovery completely, and it would seem the only
    reason this hasn't been since then is that we don't log large
    contigous regions of multi-page unmapped buffers very often. Never
    would be a closer estimate, at least until the CRC code came along....
    
    So, lets fix that by restoring the nvecs accounting for the extra
    region when we hit this case.....
    
    .... and there's the problemin log recovery it is apparently working
    around:
    
    XFS: Assertion failed: i == item->ri_total, file: fs/xfs/xfs_log_recover.c, line: 2135
    
    Yup, xlog_recover_do_reg_buffer() doesn't handle contigous dirty
    regions being broken up into multiple regions by the log formatting
    code. That's an easy fix, though - if the number of contiguous dirty
    bits exceeds the length of the region being copied out of the log,
    only account for the number of dirty bits that region covers, and
    then loop again and copy more from the next region. It's a 2 line
    fix.
    
    Now xfstests xfs/085 passes, we have one less piece of mystery
    code, and one more important piece of knowledge about how to
    structure new log format items..
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>
    
    (cherry picked from commit 709da6a61aaf12181a8eea8443919ae5fc1b731d)

commit 2962f5a5dcc56f69cbf62121a7be67cc15d6940b
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon May 27 16:38:25 2013 +1000

    xfs: kill suid/sgid through the truncate path.
    
    XFS has failed to kill suid/sgid bits correctly when truncating
    files of non-zero size since commit c4ed4243 ("xfs: split
    xfs_setattr") introduced in the 3.1 kernel. Fix it.
    
    Fix it.
    
    cc: stable kernel <stable@vger.kernel.org>
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>
    
    (cherry picked from commit 56c19e89b38618390addfc743d822f99519055c6)

commit 08fb39051f5581df45ae2a20c6cf2d0c4cddf7c2
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue May 21 18:02:00 2013 +1000

    xfs: avoid nesting transactions in xfs_qm_scall_setqlim()
    
    Lockdep reports:
    
    =============================================
    [ INFO: possible recursive locking detected ]
    3.9.0+ #3 Not tainted
    ---------------------------------------------
    setquota/28368 is trying to acquire lock:
     (sb_internal){++++.?}, at: [<c11e8846>] xfs_trans_alloc+0x26/0x50
    
    but task is already holding lock:
     (sb_internal){++++.?}, at: [<c11e8846>] xfs_trans_alloc+0x26/0x50
    
    from xfs_qm_scall_setqlim()->xfs_dqread() when a dquot needs to be
    allocated.
    
    xfs_qm_scall_setqlim() is starting a transaction and then not
    passing it into xfs_qm_dqet() and so it starts it's own transaction
    when allocating the dquot.  Splat!
    
    Fix this by not allocating the dquot in xfs_qm_scall_setqlim()
    inside the setqlim transaction. This requires getting the dquot
    first (and allocating it if necessary) then dropping and relocking
    the dquot before joining it to the setqlim transaction.
    
    Reported-by: Michael L. Semon <mlsemon35@gmail.com>
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>
    (cherry picked from commit f648167f3ac79018c210112508c732ea9bf67c7b)

commit 7ae077802c9f12959a81fa1a16c1ec2842dbae05
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon May 20 09:51:16 2013 +1000

    xfs: remote attribute lookups require the value length
    
    When reading a remote attribute, to correctly calculate the length
    of the data buffer for CRC enable filesystems, we need to know the
    length of the attribute data. We get this information when we look
    up the attribute, but we don't store it in the args structure along
    with the other remote attr information we get from the lookup. Add
    this information to the args structure so we can use it
    appropriately.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>
    
    (cherry picked from commit e461fcb194172b3f709e0b478d2ac1bdac7ab9a3)

commit cf257abf02709dba3cc745d950f144ce49432b4f
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon May 20 09:51:14 2013 +1000

    xfs: xfs_attr_shortform_allfit() does not handle attr3 format.
    
    xfstests generic/117 fails with:
    
    XFS: Assertion failed: leaf->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC)
    
    indicating a function that does not handle the attr3 format
    correctly. Fix it.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>
    (cherry picked from commit b38958d715316031fe9ea0cc6c22043072a55f49)

commit 7ced60cae46cb37273a03c196e6f473b089bd8e1
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon May 20 09:51:13 2013 +1000

    xfs: xfs_da3_node_read_verify() doesn't handle XFS_ATTR3_LEAF_MAGIC
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>
    
    (cherry picked from commit 72916fb8cbcf0c2928f56cdc2fbe8c7bf5517758)

commit b17cb364dbbbf65add79f1610599d01bcb6851f9
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon May 20 09:51:12 2013 +1000

    xfs: fix missing KM_NOFS tags to keep lockdep happy
    
    There are several places where we use KM_SLEEP allocation contexts
    and use the fact that they are called from transaction context to
    add KM_NOFS where appropriate. Unfortunately, there are several
    places where the code makes this assumption but can be called from
    outside transaction context but with filesystem locks held. These
    places need explicit KM_NOFS annotations to avoid lockdep
    complaining about reclaim contexts.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>
    
    (cherry picked from commit ac14876cf9255175bf3bdad645bf8aa2b8fb2d7c)

commit 509e708a8929c5b75a16c985c03db5329e09cad4
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon May 20 09:51:10 2013 +1000

    xfs: Don't reference the EFI after it is freed
    
    Checking the EFI for whether it is being released from recovery
    after we've already released the known active reference is a mistake
    worthy of a brown paper bag. Fix the (now) obvious use after free
    that it can cause.
    
    Reported-by: Dave Jones <davej@redhat.com>
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>
    
    (cherry picked from commit 52c24ad39ff02d7bd73c92eb0c926fb44984a41d)

commit 7031d0e1c46e2b1c869458233dd216cb72af41b2
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon May 20 09:51:09 2013 +1000

    xfs: fix rounding in xfs_free_file_space
    
    The offset passed into xfs_free_file_space() needs to be rounded
    down to a certain size, but the rounding mask is built by a 32 bit
    variable. Hence the mask will always mask off the upper 32 bits of
    the offset and lead to incorrect writeback and invalidation ranges.
    
    This is not actually exposed as a bug because we writeback and
    invalidate from the rounded offset to the end of the file, and hence
    the offset we are actually punching a hole out of will always be
    covered by the code. This needs fixing, however, if we ever want to
    use exact ranges for writeback/invalidation here...
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>
    
    (cherry picked from commit 28ca489c63e9aceed8801d2f82d731b3c9aa50f5)

commit 480d7467e4aaa3dc38088baf56bc3eb3599f5d26
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon May 20 09:51:08 2013 +1000

    xfs: fix sub-page blocksize data integrity writes
    
    FSX on 512 byte block size filesystems has been failing for some
    time with corrupted data. The fault dates back to the change in
    the writeback data integrity algorithm that uses a mark-and-sweep
    approach to avoid data writeback livelocks.
    
    Unfortunately, a side effect of this mark-and-sweep approach is that
    each page will only be written once for a data integrity sync, and
    there is a condition in writeback in XFS where a page may require
    two writeback attempts to be fully written. As a result of the high
    level change, we now only get a partial page writeback during the
    integrity sync because the first pass through writeback clears the
    mark left on the page index to tell writeback that the page needs
    writeback....
    
    The cause is writing a partial page in the clustering code. This can
    happen when a mapping boundary falls in the middle of a page - we
    end up writing back the first part of the page that the mapping
    covers, but then never revisit the page to have the remainder mapped
    and written.
    
    The fix is simple - if the mapping boundary falls inside a page,
    then simple abort clustering without touching the page. This means
    that the next ->writepage entry that write_cache_pages() will make
    is the page we aborted on, and xfs_vm_writepage() will map all
    sections of the page correctly. This behaviour is also optimal for
    non-data integrity writes, as it results in contiguous sequential
    writeback of the file rather than missing small holes and having to
    write them a "random" writes in a future pass.
    
    With this fix, all the fsx tests in xfstests now pass on a 512 byte
    block size filesystem on a 4k page machine.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>
    
    (cherry picked from commit 49b137cbbcc836ef231866c137d24f42c42bb483)

commit 34097dfe88503ca2d0dbca3646c5afb331d1ac99
Author: Lukas Czerner <lczerner@redhat.com>
Date:   Tue May 21 23:58:01 2013 -0400

    xfs: use ->invalidatepage() length argument
    
    ->invalidatepage() aop now accepts range to invalidate so we can make
    use of it in xfs_vm_invalidatepage()
    
    Signed-off-by: Lukas Czerner <lczerner@redhat.com>
    Acked-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Cc: xfs@oss.sgi.com

commit d47992f86b307985b3215bcf141d56d1849d71df
Author: Lukas Czerner <lczerner@redhat.com>
Date:   Tue May 21 23:17:23 2013 -0400

    mm: change invalidatepage prototype to accept length
    
    Currently there is no way to truncate partial page where the end
    truncate point is not at the end of the page. This is because it was not
    needed and the functionality was enough for file system truncate
    operation to work properly. However more file systems now support punch
    hole feature and it can benefit from mm supporting truncating page just
    up to the certain point.
    
    Specifically, with this functionality truncate_inode_pages_range() can
    be changed so it supports truncating partial page at the end of the
    range (currently it will BUG_ON() if 'end' is not at the end of the
    page).
    
    This commit changes the invalidatepage() address space operation
    prototype to accept range to be invalidated and update all the instances
    for it.
    
    We also change the block_invalidatepage() in the same way and actually
    make a use of the new length argument implementing range invalidation.
    
    Actual file system implementations will follow except the file systems
    where the changes are really simple and should not change the behaviour
    in any way .Implementation for truncate_page_range() which will be able
    to accept page unaligned ranges will follow as well.
    
    Signed-off-by: Lukas Czerner <lczerner@redhat.com>
    Cc: Andrew Morton <akpm@linux-foundation.org>
    Cc: Hugh Dickins <hughd@google.com>

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/xfs_aops.c       | 14 ++++++++------
 fs/xfs/xfs_dir2.c       | 13 +++++--------
 fs/xfs/xfs_dir2_block.c | 17 +++++++----------
 fs/xfs/xfs_dir2_leaf.c  | 18 ++++++++----------
 fs/xfs/xfs_dir2_priv.h  | 11 +++++------
 fs/xfs/xfs_dir2_sf.c    | 31 +++++++++++++------------------
 fs/xfs/xfs_file.c       | 18 +++++++-----------
 fs/xfs/xfs_trace.h      | 15 ++++++++++-----
 fs/xfs/xfs_vnodeops.h   |  3 +--
 9 files changed, 64 insertions(+), 76 deletions(-)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
