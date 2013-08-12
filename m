Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, for-next,
	updated. for-linus-v3.11-rc1-2-12161-g3e7b91c
Message-Id: <20130812225539.BA9047F5A@oss.sgi.com>
Date: Mon, 12 Aug 2013 17:55:38 -0500 (CDT)
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
  3e7b91c xfs: Validate log space at mount time
  5a96a94 xfs: Add xfs_log_rlimit.c
  e773fc9 xfs: Refactor xfs_ticket_alloc() to extract a new helper
  f749278 xfs: Get rid of all XFS_XXX_LOG_RES() macro
  3d3c8b5 xfs: refactor xfs_trans_reserve() interface
  783cb6d xfs: Make writeid transaction use tr_writeid
  20996c9 xfs: Introduce tr_fsyncts to m_reservation
  0eadd10 xfs: Introduce a new structure to hold transaction reservation items
  9356fe2 xfs: make struct xfs_perag kernel only
  4f3d71f xfs: move kernel specific type definitions to xfs.h
  9b90b0d xfs: xfs_filestreams.h doesn't need __KERNEL__
  cb9eabf xfs: remove __KERNEL__ check from xfs_dir2_leaf.c
  b49a0c1 xfs: remove __KERNEL__ from debug code
  63d20d6 xfs: kill __KERNEL__ check for debug code in allocation code
  94b4060 xfs: don't special case shared superblock mounts
  a133d95 xfs: consolidate extent swap code
  e546cb7 xfs: consolidate xfs_utils.c
  f6bba20 xfs: consolidate xfs_rename.c
  c24b5df xfs: kill xfs_vnodeops.[ch]
  836a94a xfs: fix issues that cause userspace warnings
  c5c249b xfs: minor cleanups
  6898811 xfs: create xfs_bmap_util.[ch]
  ff55068 xfs: introduce xfs_sb.c for sharing with libxfs
  1fb7e48d xfs: split out the remote symlink handling
  fde2227 xfs: split out attribute fork truncation code into separate file
  abec5f2 xfs: split out attribute listing code into separate file
  2b9ab5a xfs: reshuffle dir2 definitions around for userspace
  4a8af27 xfs: move getdents code into it's own file
  1fd7115 xfs: introduce xfs_inode_buf.c for inode buffer operations
  7bb85ef xfs: move unrelated definitions out of xfs_inode.h
  5c4d97d xfs: move inode fork definitions to a new header file
  7fd36c4 xfs: split out transaction reservation code
  d386b32 xfs: sync minor header differences needed by userspace.
  76456fc xfs: introduce xfs_quota_defs.h
  c729820 xfs: introduce xfs_rtalloc_defs.h
  2a3c0ac xfs: split out on-disk transaction definitions
  9cd047f xfs: separate icreate log format definitions from xfs_icreate_item.h
  6ca1c90 xfs: separate dquot on disk format definitions out of xfs_quota.h
  9fbe24d xfs: split out EFI/EFD log item format definition
  a8da0da xfs: split out buf log item format definitions
  6943283 xfs: split out inode log item format definition
  fc06c6d xfs: separate out log format definitions
      from  7a378c9aeab3782a5f998c17313bc7027cee3454 (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit 3e7b91cf8c19d89e55df5f05e3010446dbdaba77
Author: Jie Liu <jeff.liu@oracle.com>
Date:   Mon Aug 12 20:50:03 2013 +1000

    xfs: Validate log space at mount time
    
    Validate log space during log mount stage, the underlying function
    will drop a warning message via syslog in critical level if the log
    space is too small or too large.
    
    [ dchinner: For CRC enable filesystems, abort the mounting of the
    filesystem as mkfs should never make a log too small for the given
    filesystem configuration. ]
    
    [ dchinner: make a note of the fact that the log size limits in
    block counts are in units of filesystem blocks, not basic blocks. ]
    
    Signed-off-by: Jie Liu <jeff.liu@oracle.com>
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 5a96a94547fe345467c2ab2ec51cb3fade355bd9
Author: Jie Liu <jeff.liu@oracle.com>
Date:   Mon Aug 12 20:50:02 2013 +1000

    xfs: Add xfs_log_rlimit.c
    
    Add source files for xfs_log_rlimit.c The new file is used for log
    size calculations and validation shared with userspace.
    
    [dchinner: xfs_log_calc_max_attrsetm_res() does not modify the
    tr_attrsetm reservation, just calculates the maximum. ]
    
    [dchinner: rework loop in xfs_log_get_max_trans_res() ]
    
    Signed-off-by: Jie Liu <jeff.liu@oracle.com>
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit e773fc934fcbe2536dc625c2bd76234b9b9a60b6
Author: Jie Liu <jeff.liu@oracle.com>
Date:   Mon Aug 12 20:50:01 2013 +1000

    xfs: Refactor xfs_ticket_alloc() to extract a new helper
    
    Refactor xlog_ticket_alloc() to extract a new helper, i.e.
    xfs_log_calc_unit_res().
    
    This helper would be used to calculate the total log reservation
    size by adding extra log operation/transation headers for a new
    log ticket.
    
    Signed-off-by: Jie Liu <jeff.liu@oracle.com>
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit f749278c5a45e8a80f3e3ca41d4634b84948b9d9
Author: Jie Liu <jeff.liu@oracle.com>
Date:   Mon Aug 12 20:50:00 2013 +1000

    xfs: Get rid of all XFS_XXX_LOG_RES() macro
    
    Get rid of all XFS_XXX_LOG_RES() macros since they are obsoleted now.
    
    Signed-off-by: Jie Liu <jeff.liu@oracle.com>
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 3d3c8b5222b92447bffaa4127ee18c757f32a460
Author: Jie Liu <jeff.liu@oracle.com>
Date:   Mon Aug 12 20:49:59 2013 +1000

    xfs: refactor xfs_trans_reserve() interface
    
    With the new xfs_trans_res structure has been introduced, the log
    reservation size, log count as well as log flags are pre-initialized
    at mount time.  So it's time to refine xfs_trans_reserve() interface
    to be more neat.
    
    Also, introduce a new helper M_RES() to return a pointer to the
    mp->m_resv structure to simplify the input.
    
    Signed-off-by: Jie Liu <jeff.liu@oracle.com>
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 783cb6d172358892d6af394ebe2876bcbfcc6499
Author: Jie Liu <jeff.liu@oracle.com>
Date:   Mon Aug 12 20:49:58 2013 +1000

    xfs: Make writeid transaction use tr_writeid
    
    tr_writeid is defined at mp->m_resv structure, however, it does not
    really being used when it should be..
    
    This patch changes it to tr_writeid to fetch the correct log
    reservation size.
    
    Signed-off-by: Jie Liu <jeff.liu@oracle.com>
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 20996c932603b34fc82b8c8cd00f3ded83982f7b
Author: Jie Liu <jeff.liu@oracle.com>
Date:   Mon Aug 12 20:49:57 2013 +1000

    xfs: Introduce tr_fsyncts to m_reservation
    
    A preparation step.
    
    For now fsync_ts transaction use the pre-calculated log reservation
    size of tr_swrite.  This patch introduce a new item tr_fsyncts to
    mp->m_reservations structure so that we can fetch the log
    reservation value for it in a same manner to others.
    
    Signed-off-by: Jie Liu <jeff.liu@oracle.com>
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 0eadd1028858b193ce8cdc36bf443d39b42141ca
Author: Jie Liu <jeff.liu@oracle.com>
Date:   Mon Aug 12 20:49:56 2013 +1000

    xfs: Introduce a new structure to hold transaction reservation items
    
    Introduce a new structure xfs_trans_res to hold transaction
    reservation item info per log ticket.
    
    We also need to improve xfs_trans_resv_calc() by initializing the
    log count as well as log flags for permanent log reservation.
    
    Signed-off-by: Jie Liu <jeff.liu@oracle.com>
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 9356fe22af084e7b9c1f3c8633a1cbe9b36de405
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Aug 12 20:49:55 2013 +1000

    xfs: make struct xfs_perag kernel only
    
    The struct xfs_perag has many kernel-only definitions in it,
    requiring a __KERNEL__ guard so userspace can use it to. Move it to
    xfs_mount.h so that it it kernel-only, and let userspace redefine
    it's own version of the structure containing only what it needs.
    This gets rid of another __KERNEL__ check in the XFS header files.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 4f3d71f68bc976321b19efe2624cd91619af601f
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Aug 12 20:49:54 2013 +1000

    xfs: move kernel specific type definitions to xfs.h
    
    xfs_types.h is shared with userspace, so having kernel specific
    types defined in it is problematic. Move all the kernel specific
    defines to xfs_linux.h so we can remove the __KERNEL__ guards from
    xfs_types.h.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 9b90b0d9da907a1810e7b7764befaf084e4cd45b
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Aug 12 20:49:53 2013 +1000

    xfs: xfs_filestreams.h doesn't need __KERNEL__
    
    Because it is only used within the kernel.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit cb9eabff58390a22ba8e4b0c838cbf2efb192225
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Aug 12 20:49:52 2013 +1000

    xfs: remove __KERNEL__ check from xfs_dir2_leaf.c
    
    It's actually an ifndef section, which means it is only included in
    userspace. however, it's deep within the libxfs code, so it's
    unlikely that the condition checked in userspace can actually occur
    (search an empty leaf) through the libxfs interfaces. i.e. if it can
    happen in usrspace, it can happen in the kernel, so remove it from
    userspace too....
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit b49a0c1883899bf9bc6cc5b9c4e6ee5d0f552530
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Aug 12 20:49:51 2013 +1000

    xfs: remove __KERNEL__ from debug code
    
    There is no reason the remaining kernel-only debug code needs to
    remain kernel-only. Kill the __KERNEL__ part of the defines, and let
    userspace handle the debug code appropriately.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 63d20d6e3620898e67f80c813ec199b19b1674a9
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Aug 12 20:49:50 2013 +1000

    xfs: kill __KERNEL__ check for debug code in allocation code
    
    Userspace running debug builds is relatively rare, so there's need
    to special case the allocation algorithm code coverage debug switch.
    As it is, userspace defines random numbers to 0, so  invert the
    logic of the switch so it is effectively a no-op in userspace.
    This kills another couple of __KERNEL__ users.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 94b406091bb3fcbab3d846d7d273e30e5fc8ceb5
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Aug 12 20:49:49 2013 +1000

    xfs: don't special case shared superblock mounts
    
    Neither kernel or userspace support shared read-only mounts, so
    don't bother special casing the support check to be different
    between kernel and userspace. The same check can be used as neither
    like it...
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit a133d952b44cef278d2da664d742d51ef95f4dd3
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Aug 12 20:49:48 2013 +1000

    xfs: consolidate extent swap code
    
    So we don't need xfs_dfrag.h in userspace anymore, move the extent
    swap ioctl structure definition to xfs_fs.h where most of the other
    ioctl structure definitions are.
    
    Now that we don't need separate files for extent swapping, separate
    the basic file descriptor checking code to xfs_ioctl.c, and the code
    that does the extent swap operation to xfs_bmap_util.c.  This
    cleanly separates the user interface code from the physical
    mechanism used to do the extent swap.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit e546cb79ef7ebe53060369dae665fa449a544353
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Aug 12 20:49:47 2013 +1000

    xfs: consolidate xfs_utils.c
    
    There are a few small helper functions in xfs_util, all related to
    xfs_inode modifications. Move them all to xfs_inode.c so all
    xfs_inode operations are consiolidated in the one place.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit f6bba2017afb3bda8f2a27d6ba9d7023e8ff7f37
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Aug 12 20:49:46 2013 +1000

    xfs: consolidate xfs_rename.c
    
    Move the rename code to xfs_inode.c to continue consolidating
    all the kernel xfs_inode operations in the one place.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit c24b5dfadc4a4f7a13af373067871479c74455e6
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Aug 12 20:49:45 2013 +1000

    xfs: kill xfs_vnodeops.[ch]
    
    Now we have xfs_inode.c for holding kernel-only XFS inode
    operations, move all the inode operations from xfs_vnodeops.c to
    this new file as it holds another set of kernel-only inode
    operations. The name of this file traces back to the days of Irix
    and it's vnodes which we don't have anymore.
    
    Essentially this move consolidates the inode locking functions
    and a bunch of XFS inode operations into the one file. Eventually
    the high level functions will be merged into the VFS interface
    functions in xfs_iops.c.
    
    This leaves only internal preallocation, EOF block manipulation and
    hole punching functions in vnodeops.c. Move these to xfs_bmap_util.c
    where we are already consolidating various in-kernel physical extent
    manipulation and querying functions.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 836a94ad59bf6c1bcea0fdbe945540926fa3ca8b
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Aug 12 20:49:44 2013 +1000

    xfs: fix issues that cause userspace warnings
    
    Some of the code shared with userspace causes compilation warnings
    from things turned off in the kernel code, such as differences in
    variable signedness. Fix those issues.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit c5c249b42464cbcda3ac5cbdc114f6a6d5b0b7ac
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Aug 12 20:49:43 2013 +1000

    xfs: minor cleanups
    
    These come from syncing the shared userspace and kernel code. Small
    whitespace and trivial cleanups.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 6898811459ff523ed256c07d1d5c54ba915d51ac
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Aug 12 20:49:42 2013 +1000

    xfs: create xfs_bmap_util.[ch]
    
    There is a bunch of code in xfs_bmap.c that is kernel specific and
    not shared with userspace. To minimise the difference between the
    kernel and userspace code, shift this unshared code to
    xfs_bmap_util.c, and the declarations to xfs_bmap_util.h.
    
    The biggest issue here is xfs_bmap_finish() - userspace has it's own
    definition of this function, and so we need to move it out of
    xfs_bmap.[ch]. This means several other files need to include
    xfs_bmap_util.h as well.
    
    It also introduces and interesting dance for the stack switching
    code in xfs_bmapi_allocate(). The stack switching/workqueue code is
    actually moved to xfs_bmap_util.c, so that userspace can simply use
    a #define in a header file to connect the dots without needing to
    know about the stack switch code at all.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit ff55068c2010f39bcd899ca14b0a3d401d14da54
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Aug 12 20:49:41 2013 +1000

    xfs: introduce xfs_sb.c for sharing with libxfs
    
    xfs_mount.c is shared with userspace, but the only functions that
    are shared are to do with physical superblock manipulations. This
    means that less than 25% of the xfs_mount.c code is actually shared
    with userspace. Move all the superblock functions to xfs_sb.c and
    share that instead with libxfs.
    
    Note that this will leave all the in-core transaction related
    superblock counter modifications in xfs_mount.c as none of that is
    shared with userspace. With a few more small changes, xfs_mount.h
    won't need to be shared with userspace anymore, either.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 1fb7e48db6810093012873a652062648ace6b5bb
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Aug 12 20:49:40 2013 +1000

    xfs: split out the remote symlink handling
    
    The remote symlink format definition and manipulation needs to be
    shared with userspace, but the in-kernel interfaces do not. Split
    the remote symlink format handling out into xfs_symlink_remote.[ch]
    fo it can easily be shared with userspace.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit fde2227ce12b6d3e1945bd512da2a4a333331a2c
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Aug 12 20:49:39 2013 +1000

    xfs: split out attribute fork truncation code into separate file
    
    The attribute inactivation code is not used by userspace, so like
    the attribute listing, split it out into a separate file to minimise
    the differences between the filesystem shared with libxfs in
    userspace.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit abec5f2bf991a03b055be36d918cd6f8f58cc83e
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Aug 12 20:49:38 2013 +1000

    xfs: split out attribute listing code into separate file
    
    The attribute listing code is not used by userspace, so like the
    directory readdir code, split it out into a separate file to
    minimise the differences between the filesystem shared with libxfs
    in userspace.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 2b9ab5ab9c4a1f16f11ad883bfd21d5eb55e5bcc
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Aug 12 20:49:37 2013 +1000

    xfs: reshuffle dir2 definitions around for userspace
    
    Many of the definitions within xfs_dir2_priv.h are needed in
    userspace outside libxfs. Definitions within xfs_dir2_priv.h are
    wholly contained within libxfs, so we need to shuffle some of the
    definitions around to keep consistency across files shared between
    user and kernel space.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 4a8af273de63d9656559ba5289e91f40aae0441f
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Aug 12 20:49:36 2013 +1000

    xfs: move getdents code into it's own file
    
    The directory readdir code is not used by userspace, but it is
    intermingled with files that are shared with userspace. This makes
    it difficult to compare the differences between the userspac eand
    kernel files are the userspace files don't have the getdents code in
    them. Move all the kernel getdents code to a separate file to bring
    the shared content between userspace and kernel files closer
    together.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 1fd7115eda5661e872463694fc4a12821c4f914a
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Aug 12 20:49:35 2013 +1000

    xfs: introduce xfs_inode_buf.c for inode buffer operations
    
    The only thing remaining in xfs_inode.[ch] are the operations that
    read, write or verify physical inodes in their underlying buffers.
    Move all this code to xfs_inode_buf.[ch] and so we can stop sharing
    xfs_inode.[ch] with userspace.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 7bb85ef3608bf740e285b4436776526b7afd4903
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Aug 12 20:49:34 2013 +1000

    xfs: move unrelated definitions out of xfs_inode.h
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 5c4d97d01a3a7a4a84fb05bfc439145ea25ba989
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Aug 12 20:49:33 2013 +1000

    xfs: move inode fork definitions to a new header file
    
    The inode fork definitions are a combination of on-disk format
    definition and in-memory tracking and manipulation. They are both
    shared with userspace, so move them all into their own file so
    sharing is easy to do and track.  This removes all inode fork
    related information from xfs_inode.h.
    
    Do the same for the all the C code that currently resides in
    xfs_inode.c for the same reason.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 7fd36c4418ee86712db6871ac95ab23743224bff
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Aug 12 20:49:32 2013 +1000

    xfs: split out transaction reservation code
    
    The transaction reservation size calculations is used by both kernel
    and userspace, but most of the transaction code in xfs_trans.c is
    kernel specific. Split all the transaction reservation code out into
    it's own files to make sharing with userspace simpler. This just
    leaves kernel-only definitions in xfs_trans.h, so it doesn't need to
    be shared with userspace anymore, either.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit d386b32b553ce145fb40f0d9360b6e5a79b5a80c
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Aug 12 20:49:31 2013 +1000

    xfs: sync minor header differences needed by userspace.
    
    Little things like exported functions, __KERNEL__ protections, and
    so on that ensure user and kernel shared headers are identical.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 76456fc2a6fe3a31c492a072413925eebc68cc98
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Aug 12 20:49:30 2013 +1000

    xfs: introduce xfs_quota_defs.h
    
    There are a lot of quota flag definitions that are shared by user
    and kernel space. Move them all to xfs_quota_defs.h so we can
    unshare xfs_quota.h and remove the __KERNEL__ regions from it.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit c7298202e5df6fad66c7c8146bf2ed55ba07aff0
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Aug 12 20:49:29 2013 +1000

    xfs: introduce xfs_rtalloc_defs.h
    
    There are quite a few realtime device definitions shared with
    userspace. Move them from xfs_rtalloc.h to xfs_rt_alloc_defs.h
    so we don't need to share xfs_rtalloc.h with userspace anymore.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 2a3c0acc351baf1e5e584d8d0692f41d5067582c
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Aug 12 20:49:28 2013 +1000

    xfs: split out on-disk transaction definitions
    
    There's a bunch of definitions in xfs_trans.h that define on-disk
    formats - transaction headers that get written into the log, log
    item type definitions, etc. Split out everything into a separate
    file so that all which remains in xfs_trans.h are kernel only
    definitions.
    
    Also, remove the duplicate magic number definitions for
    XFS_TRANS_MAGIC...
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 9cd047f3a3c38f5abf998b781296ff0c834e509f
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Aug 12 20:49:27 2013 +1000

    xfs: separate icreate log format definitions from xfs_icreate_item.h
    
    The on disk log format definitions for the icreate log item are
    intertwined with the kernel-only in-memory log item definitions.
    Separate the log format definitions out into their own header file
    so they can easily be shared with userspace.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 6ca1c9063d1952b20c61136e01e6a8987371616b
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Aug 12 20:49:26 2013 +1000

    xfs: separate dquot on disk format definitions out of xfs_quota.h
    
    The on disk format definitions of the on-disk dquot, log formats and
    quota off log formats are all intertwined with other definitions for
    quotas. Separate them out into their own header file so they can
    easily be shared with userspace.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 9fbe24d95ea36205a71195b378a163aa829dfe40
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Aug 12 20:49:25 2013 +1000

    xfs: split out EFI/EFD log item format definition
    
    The EFI/EFD item format definitions are shared with userspace. Split
    the out of header files that contain kernel only defintions to make
    it simple to shared them.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit a8da0da25c9fda7cbfd824979e824ac54d8eef07
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Aug 12 20:49:24 2013 +1000

    xfs: split out buf log item format definitions
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 69432832fd7466c20c7c92cbd92c561ac78988c2
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Aug 12 20:49:23 2013 +1000

    xfs: split out inode log item format definition
    
    The log item format definitions are shared with userspace. Split
    them out of header files that contain kernel only defintions to make
    it simple to shared them.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit fc06c6d064dd50f7aa157065ef79216190d75c91
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Aug 12 20:49:22 2013 +1000

    xfs: separate out log format definitions
    
    The on-disk format definitions for the log are spread randoms
    through a couple of header files. Consolidate it all in a single
    file that can be shared easily with userspace. This means that
    xfs_log.h and xfs_log_priv.h no longer need to be shared with
    userspace.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/Makefile             |   20 +-
 fs/xfs/xfs_acl.c            |    4 +-
 fs/xfs/xfs_ag.h             |   53 -
 fs/xfs/xfs_alloc.c          |    6 +-
 fs/xfs/xfs_aops.c           |    4 +-
 fs/xfs/xfs_attr.c           |  426 +----
 fs/xfs/xfs_attr.h           |    9 +
 fs/xfs/xfs_attr_inactive.c  |  453 +++++
 fs/xfs/xfs_attr_leaf.c      |  655 +-------
 fs/xfs/xfs_attr_leaf.h      |    2 +
 fs/xfs/xfs_attr_list.c      |  655 ++++++++
 fs/xfs/xfs_attr_remote.c    |   18 +-
 fs/xfs/xfs_bmap.c           |  817 +--------
 fs/xfs/xfs_bmap.h           |   56 +-
 fs/xfs/xfs_bmap_btree.c     |    6 +-
 fs/xfs/xfs_bmap_util.c      | 2026 +++++++++++++++++++++++
 fs/xfs/xfs_bmap_util.h      |  110 ++
 fs/xfs/xfs_btree.h          |    2 -
 fs/xfs/xfs_buf.c            |    1 +
 fs/xfs/xfs_buf_item.h       |  100 +-
 fs/xfs/xfs_da_btree.c       |    8 +-
 fs/xfs/xfs_dfrag.c          |  459 ------
 fs/xfs/xfs_dfrag.h          |   53 -
 fs/xfs/xfs_dir2.c           |   34 +-
 fs/xfs/xfs_dir2.h           |   45 +
 fs/xfs/xfs_dir2_block.c     |   99 +-
 fs/xfs/xfs_dir2_data.c      |   10 +-
 fs/xfs/xfs_dir2_format.h    |    3 +
 fs/xfs/xfs_dir2_leaf.c      |  395 +----
 fs/xfs/xfs_dir2_node.c      |    3 +
 fs/xfs/xfs_dir2_priv.h      |   40 +-
 fs/xfs/xfs_dir2_readdir.c   |  646 ++++++++
 fs/xfs/xfs_dir2_sf.c        |  100 +-
 fs/xfs/xfs_discard.c        |    5 +-
 fs/xfs/xfs_dquot.c          |    8 +-
 fs/xfs/xfs_dquot_item.c     |    1 +
 fs/xfs/xfs_error.c          |    1 -
 fs/xfs/xfs_export.c         |    5 +-
 fs/xfs/xfs_extfree_item.h   |   88 +-
 fs/xfs/xfs_file.c           |    3 +-
 fs/xfs/xfs_filestream.c     |    8 +-
 fs/xfs/xfs_filestream.h     |    4 -
 fs/xfs/xfs_format.h         |  169 ++
 fs/xfs/xfs_fs.h             |   36 +-
 fs/xfs/xfs_fsops.c          |    8 +-
 fs/xfs/xfs_ialloc.c         |    3 +-
 fs/xfs/xfs_icache.c         |    3 +-
 fs/xfs/xfs_icache.h         |    7 +
 fs/xfs/xfs_icreate_item.c   |   12 -
 fs/xfs/xfs_icreate_item.h   |   18 -
 fs/xfs/xfs_inode.c          | 3824 +++++++++++++++++--------------------------
 fs/xfs/xfs_inode.h          |  312 +---
 fs/xfs/xfs_inode_buf.c      |  453 +++++
 fs/xfs/xfs_inode_buf.h      |   52 +
 fs/xfs/xfs_inode_fork.c     | 1919 ++++++++++++++++++++++
 fs/xfs/xfs_inode_fork.h     |  171 ++
 fs/xfs/xfs_inode_item.h     |  115 +-
 fs/xfs/xfs_ioctl.c          |  113 +-
 fs/xfs/xfs_ioctl.h          |   10 +
 fs/xfs/xfs_ioctl32.c        |    4 +-
 fs/xfs/xfs_iomap.c          |   21 +-
 fs/xfs/xfs_iops.c           |   13 +-
 fs/xfs/xfs_iops.h           |   13 +
 fs/xfs/xfs_linux.h          |   32 +
 fs/xfs/xfs_log.c            |  107 +-
 fs/xfs/xfs_log.h            |   89 +-
 fs/xfs/xfs_log_format.h     |  846 ++++++++++
 fs/xfs/xfs_log_priv.h       |  146 +-
 fs/xfs/xfs_log_recover.c    |   12 +-
 fs/xfs/xfs_log_rlimit.c     |  145 ++
 fs/xfs/xfs_mount.c          |  800 +--------
 fs/xfs/xfs_mount.h          |  113 +-
 fs/xfs/xfs_qm.c             |   13 +-
 fs/xfs/xfs_qm_bhv.c         |    1 +
 fs/xfs/xfs_qm_syscalls.c    |   15 +-
 fs/xfs/xfs_quota.h          |  260 +--
 fs/xfs/xfs_quota_defs.h     |  157 ++
 fs/xfs/xfs_quotaops.c       |    4 +-
 fs/xfs/xfs_rename.c         |  346 ----
 fs/xfs/xfs_rtalloc.c        |   28 +-
 fs/xfs/xfs_rtalloc.h        |   53 +-
 fs/xfs/xfs_sb.c             |  834 ++++++++++
 fs/xfs/xfs_sb.h             |   34 +-
 fs/xfs/xfs_super.c          |    6 +-
 fs/xfs/xfs_symlink.c        |  189 +--
 fs/xfs/xfs_symlink.h        |   41 +-
 fs/xfs/xfs_symlink_remote.c |  200 +++
 fs/xfs/xfs_trace.c          |    1 +
 fs/xfs/xfs_trans.c          |  709 +-------
 fs/xfs/xfs_trans.h          |  288 +---
 fs/xfs/xfs_trans_dquot.c    |    1 +
 fs/xfs/xfs_trans_priv.h     |    3 +
 fs/xfs/xfs_trans_resv.c     |  769 +++++++++
 fs/xfs/xfs_trans_resv.h     |  116 ++
 fs/xfs/xfs_types.h          |   59 +-
 fs/xfs/xfs_utils.c          |  314 ----
 fs/xfs/xfs_utils.h          |   27 -
 fs/xfs/xfs_vnodeops.c       | 1870 ---------------------
 fs/xfs/xfs_vnodeops.h       |   55 -
 fs/xfs/xfs_xattr.c          |    2 +-
 100 files changed, 11992 insertions(+), 11410 deletions(-)
 create mode 100644 fs/xfs/xfs_attr_inactive.c
 create mode 100644 fs/xfs/xfs_attr_list.c
 create mode 100644 fs/xfs/xfs_bmap_util.c
 create mode 100644 fs/xfs/xfs_bmap_util.h
 delete mode 100644 fs/xfs/xfs_dfrag.c
 delete mode 100644 fs/xfs/xfs_dfrag.h
 create mode 100644 fs/xfs/xfs_dir2_readdir.c
 create mode 100644 fs/xfs/xfs_format.h
 create mode 100644 fs/xfs/xfs_inode_buf.c
 create mode 100644 fs/xfs/xfs_inode_buf.h
 create mode 100644 fs/xfs/xfs_inode_fork.c
 create mode 100644 fs/xfs/xfs_inode_fork.h
 create mode 100644 fs/xfs/xfs_log_format.h
 create mode 100644 fs/xfs/xfs_log_rlimit.c
 create mode 100644 fs/xfs/xfs_quota_defs.h
 delete mode 100644 fs/xfs/xfs_rename.c
 create mode 100644 fs/xfs/xfs_sb.c
 create mode 100644 fs/xfs/xfs_symlink_remote.c
 create mode 100644 fs/xfs/xfs_trans_resv.c
 create mode 100644 fs/xfs/xfs_trans_resv.h
 delete mode 100644 fs/xfs/xfs_utils.c
 delete mode 100644 fs/xfs/xfs_utils.h
 delete mode 100644 fs/xfs/xfs_vnodeops.c
 delete mode 100644 fs/xfs/xfs_vnodeops.h


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
