Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 17 Oct 2007 04:03:56 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l9HB3k9r007872
	for <xfs@oss.sgi.com>; Wed, 17 Oct 2007 04:03:48 -0700
Date: Wed, 17 Oct 2007 21:03:39 +1000
Subject: [GIT PULL] XFS update for 2.6.24-rc1
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20071017110339.D4B3158C38F1@chook.melbourne.sgi.com>
From: tes@sgi.com (Tim Shimmin)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: torvalds@linux-foundation.org
Cc: tes@sgi.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org

Hi Linus,

Please pull from the for-linus branch:
    git pull git://oss.sgi.com:8090/xfs/xfs-2.6.git for-linus

These include changes we have had scheduled for 2.6.24.
In particular they include Christoph's (hch's) behavior removal patches.

--Tim

This will update the following files:

 fs/xfs/Makefile-linux-2.6      |    3 -
 fs/xfs/linux-2.6/xfs_aops.c    |   57 ++--
 fs/xfs/linux-2.6/xfs_aops.h    |    2 +-
 fs/xfs/linux-2.6/xfs_buf.c     |   26 ++-
 fs/xfs/linux-2.6/xfs_export.c  |   20 +-
 fs/xfs/linux-2.6/xfs_file.c    |  174 +++-------
 fs/xfs/linux-2.6/xfs_fs_subr.c |   54 ++--
 fs/xfs/linux-2.6/xfs_fs_subr.h |    4 -
 fs/xfs/linux-2.6/xfs_globals.c |    5 -
 fs/xfs/linux-2.6/xfs_globals.h |    1 -
 fs/xfs/linux-2.6/xfs_ioctl.c   |  242 +++++++------
 fs/xfs/linux-2.6/xfs_ioctl32.c |    8 +-
 fs/xfs/linux-2.6/xfs_iops.c    |  196 ++++-------
 fs/xfs/linux-2.6/xfs_iops.h    |    8 +-
 fs/xfs/linux-2.6/xfs_linux.h   |    3 +-
 fs/xfs/linux-2.6/xfs_lrw.c     |  104 +++----
 fs/xfs/linux-2.6/xfs_lrw.h     |   23 +--
 fs/xfs/linux-2.6/xfs_super.c   |  298 ++++++++--------
 fs/xfs/linux-2.6/xfs_super.h   |    5 +-
 fs/xfs/linux-2.6/xfs_vfs.c     |  327 ------------------
 fs/xfs/linux-2.6/xfs_vfs.h     |  168 +---------
 fs/xfs/linux-2.6/xfs_vnode.c   |  100 +++---
 fs/xfs/linux-2.6/xfs_vnode.h   |  345 ++-----------------
 fs/xfs/quota/xfs_qm.c          |   51 +---
 fs/xfs/quota/xfs_qm.h          |    6 +-
 fs/xfs/quota/xfs_qm_bhv.c      |  239 ++-----------
 fs/xfs/quota/xfs_qm_syscalls.c |   21 +-
 fs/xfs/support/move.c          |   51 ---
 fs/xfs/support/move.h          |   70 ----
 fs/xfs/xfs_acl.c               |   33 +-
 fs/xfs/xfs_acl.h               |   19 +-
 fs/xfs/xfs_ag.h                |    4 +
 fs/xfs/xfs_attr.c              |   50 ++-
 fs/xfs/xfs_attr.h              |   17 +-
 fs/xfs/xfs_behavior.c          |  183 ----------
 fs/xfs/xfs_behavior.h          |  185 ----------
 fs/xfs/xfs_bmap.c              |  150 +++++----
 fs/xfs/xfs_bmap.h              |    4 +-
 fs/xfs/xfs_bmap_btree.c        |  255 +++++---------
 fs/xfs/xfs_bmap_btree.h        |   68 +---
 fs/xfs/xfs_buf_item.c          |    1 +
 fs/xfs/xfs_clnt.h              |    1 -
 fs/xfs/xfs_dfrag.c             |    6 +-
 fs/xfs/xfs_dinode.h            |   65 ++--
 fs/xfs/xfs_dir2.c              |  117 +------
 fs/xfs/xfs_dir2.h              |   17 -
 fs/xfs/xfs_dir2_block.c        |   64 ++---
 fs/xfs/xfs_dir2_block.h        |    5 +-
 fs/xfs/xfs_dir2_data.c         |    1 +
 fs/xfs/xfs_dir2_leaf.c         |   76 ++---
 fs/xfs/xfs_dir2_leaf.h         |    6 +-
 fs/xfs/xfs_dir2_node.c         |    1 +
 fs/xfs/xfs_dir2_sf.c           |  122 +++----
 fs/xfs/xfs_dir2_sf.h           |    5 +-
 fs/xfs/xfs_dmapi.h             |   17 +-
 fs/xfs/xfs_dmops.c             |   43 ++-
 fs/xfs/xfs_error.c             |   21 +-
 fs/xfs/xfs_error.h             |    5 +-
 fs/xfs/xfs_extfree_item.c      |    1 +
 fs/xfs/xfs_fsops.c             |   17 +-
 fs/xfs/xfs_ialloc.c            |    6 +-
 fs/xfs/xfs_ialloc.h            |    7 +-
 fs/xfs/xfs_iget.c              |  605 +++++++++++---------------------
 fs/xfs/xfs_inode.c             |  383 +++++++++++----------
 fs/xfs/xfs_inode.h             |  158 +++++----
 fs/xfs/xfs_iocore.c            |    4 +-
 fs/xfs/xfs_iomap.c             |    8 -
 fs/xfs/xfs_iomap.h             |    1 -
 fs/xfs/xfs_itable.c            |   78 +++--
 fs/xfs/xfs_log.c               |  100 +++---
 fs/xfs/xfs_log_priv.h          |   21 +-
 fs/xfs/xfs_log_recover.c       |   32 +-
 fs/xfs/xfs_mount.c             |  242 +++++++-------
 fs/xfs/xfs_mount.h             |  176 +++++-----
 fs/xfs/xfs_qmops.c             |   40 ++-
 fs/xfs/xfs_quota.h             |   10 +-
 fs/xfs/xfs_rename.c            |   38 +--
 fs/xfs/xfs_rw.c                |    5 +-
 fs/xfs/xfs_rw.h                |   34 --
 fs/xfs/xfs_sb.h                |   68 ++++-
 fs/xfs/xfs_trans.c             |   76 ++---
 fs/xfs/xfs_trans_ail.c         |    1 +
 fs/xfs/xfs_trans_extfree.c     |    1 +
 fs/xfs/xfs_types.h             |   12 -
 fs/xfs/xfs_utils.c             |    9 +-
 fs/xfs/xfs_utils.h             |    6 +-
 fs/xfs/xfs_vfsops.c            |  351 ++++++++++++-------
 fs/xfs/xfs_vfsops.h            |   28 ++
 fs/xfs/xfs_vnodeops.c          |  745 +++++++++++++---------------------------
 fs/xfs/xfs_vnodeops.h          |   86 +++++
 90 files changed, 2762 insertions(+), 4739 deletions(-)
 delete mode 100644 fs/xfs/linux-2.6/xfs_vfs.c
 delete mode 100644 fs/xfs/support/move.c
 delete mode 100644 fs/xfs/support/move.h
 delete mode 100644 fs/xfs/xfs_behavior.c
 delete mode 100644 fs/xfs/xfs_behavior.h
 create mode 100644 fs/xfs/xfs_vfsops.h
 create mode 100644 fs/xfs/xfs_vnodeops.h

through these commits:

commit 7f015072348a14f16d548be557ee58c5c55df0aa
Author: Jeremy Fitzhardinge <jeremy@xensource.com>
Date:   Wed Oct 17 13:55:03 2007 +1000

    [XFS] eagerly remove vmap mappings to avoid upsetting Xen
    
    XFS leaves stray mappings around when it vmaps memory to make it virtually
    contigious. This upsets Xen if one of those pages is being recycled into a
    pagetable, since it finds an extra writable mapping of the page.
    
    This patch solves the problem in a brute force way, by making XFS always
    eagerly unmap its mappings.
    
    SGI-PV: 971902
    SGI-Modid: xfs-linux-melb:xfs-kern:29886a
    
    Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 6572bc28de150aaa6ca182eaf3e60c199ba48630
Author: Christoph Hellwig <hch@infradead.org>
Date:   Wed Sep 19 15:27:39 2007 +1000

    [XFS] simplify validata_fields
    
    Stop using xfs_getattr and a onstack bhv_vattr_t just to get three fields
    from the underlying inode and opencode copying from the inode fields
    instead.
    
    SGI-PV: 970662
    SGI-Modid: xfs-linux-melb:xfs-kern:29711a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 150f29ef2e96392c6ddf24d49289dd40df2783f0
Author: Tim Shimmin <tes@chook.melbourne.sgi.com>
Date:   Tue Oct 16 16:20:12 2007 +1000

    [XFS] no longer using io_vnode, as was remaining from 23 cherrypick
    
    Because we cherrypicked SGI-Modid xfs-linux-melb:xfs-kern:29675a
    and it depended on the sgi mod which removed io_vnode (which was
    not cherrypicked in 23) it was hand modified.
    This fixes things back up (to the originial mod) now we have moved
    on again.
    
    Reviewed-by: Lachlan McIlroy <lachlan@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 479ba36bbb322a21aa65cc89223c50adf78f4a56
Author: Tim Shimmin <tes@chook.melbourne.sgi.com>
Date:   Tue Oct 16 15:32:57 2007 +1000

    [XFS] Remove STATIC which was missing from prior manual merge
    
    Removes STATIC on xfs_freeze function which was not manually
    applied for SGI-Modid: xfs-linux-melb:xfs-kern:29504a.
    
    Reviewed-by: Lachlan McIlroy <lachlan@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit cd514bdaa87e48b52d4074390043f19ce43ea2c4
Author: Tim Shimmin <tes@sgi.com>
Date:   Mon Oct 15 13:18:59 2007 +1000

    [XFS] Put back the QUEUE_ORDERED_NONE test in the barrier check.
    
    Put back the QUEUE_ORDERED_NONE test which caused us grief in sles when it
    was taken out as, IIRC, it allowed md/lvm to be thought of as supporting
    barriers when they weren't in some configurations. This patch will be
    reverting what went in as part of a change for the SGI-pv 964544
    (SGI-Modid: xfs-linux-melb:xfs-kern:28568a).
    
    SGI-PV: 971783
    SGI-Modid: xfs-linux-melb:xfs-kern:29882a
    
    Signed-off-by: Tim Shimmin <tes@sgi.com>
    Signed-off-by: David Chinner <dgc@sgi.com>

commit bebf963fec2f319d162c18d06b6592f572c9c101
Author: Lachlan McIlroy <lachlan@sgi.com>
Date:   Mon Oct 15 13:18:02 2007 +1000

    [XFS] Turn off XBF_ASYNC flag before re-reading superblock.
    
    SGI-PV: 971603
    SGI-Modid: xfs-linux-melb:xfs-kern:29871a
    
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit e893bffd4cf2f000f3058319eea5abeeb1755969
Author: Lachlan McIlroy <lachlan@sgi.com>
Date:   Fri Oct 12 11:13:35 2007 +1000

    [XFS] avoid race in sync_inodes() that can fail to write out all dirty data
    
    In xfs_fs_sync_super() treat a sync the same as a filesystem freeze. This
    is needed to force the log to disk for inodes which are not marked dirty
    in the Linux inode (the inodes are marked dirty on completion of the log
    I/O) and so sync_inodes() will not flush them.
    
    In xfs_fs_write_inode() a synchronous flush will not get an EAGAIN from
    xfs_inode_flush() and if an asynchronous flush returns EAGAIN we should
    pass it on to the caller. If we get an error while flushing the inode then
    re-dirty it so we can try again later.
    
    SGI-PV: 971670
    SGI-Modid: xfs-linux-melb:xfs-kern:29860a
    
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit c2cba57e83dd7d2dda4ec425998b536669632c82
Author: Lachlan McIlroy <lachlan@sgi.com>
Date:   Fri Oct 12 11:12:20 2007 +1000

    [XFS] This fix prevents bulkstat from spinning in an infinite loop.
    
    Here 'agino' increments through the inodes in an allocation group. At the
    end of the innermost 'for' loop it will hold the value of the next inode
    to look at (ie the first inode in the next cluster/chunk). Assigning
    'lastino' to 'agino' resets it to the last inode in the last inode cluster
    we just looked at. This causes us to look up the very same cluster and
    examine all the inodes all over again, and again, and again...
    
    We also want to set 'lastino' for the cases when we're not interested in
    the inode so that the next call to bulkstat won't re-examine the same
    uninteresting inodes.
    
    SGI-PV: 971064
    SGI-Modid: xfs-linux-melb:xfs-kern:29840a
    
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 3e5daf05a0c7cce36dc2db41933b14b36d2048dc
Author: Christoph Hellwig <hch@infradead.org>
Date:   Thu Oct 11 18:09:12 2007 +1000

    [XFS] simplify xfs_create/mknod/symlink prototype
    
    Simplify the prototype for xfs_create/xfs_mkdir/xfs_symlink by not passing
    down a bhv_vattr_t that just hogs stack space. Instead pass down the mode
    in a mode_t and in case of xfs_create the rdev as a scalar type as well.
    
    SGI-PV: 968563
    SGI-Modid: xfs-linux-melb:xfs-kern:29794a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit c83bfab1faec9c32297d2079c06adaaaea2650d9
Author: Christoph Hellwig <hch@infradead.org>
Date:   Thu Oct 11 17:47:00 2007 +1000

    [XFS] avoid xfs_getattr in XFS_IOC_FSGETXATTR ioctl
    
    No need to call into xfs_getattr and put a big bhv_vattr_t on the stack
    just to get a little information from the XFS inode.
    
    Add a helper called xfs_ioc_fsgetxattr instead that deals with retrieving
    the information in a clean way.
    
    SGI-PV: 968563
    SGI-Modid: xfs-linux-melb:xfs-kern:29780a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 859d718279b6e1d6bc27a701db47c1be720b5907
Author: Vlad Apostolov <vapo@sgi.com>
Date:   Thu Oct 11 17:44:18 2007 +1000

    [XFS] get_bulkall() could return incorrect inode state
    
    In the following scenario xfs_bulkstat() returns incorrect stale inode
    state:
    
    1. File_A is created and its inode synced to disk. 2. File_A is unlinked
    and doesn't exist anymore. 3. Filesystem sync is invoked. 4. File_B is
    created. File_B happens to reclaim File_A's inode. 5. xfs_bulkstat() is
    called and detects File_B but reports the
    
    incorrect File_A inode state.
    
    Explanation for the incorrect inode state is that inodes are not
    immediately synced on file create for performance reasons. This leaves the
    on-disk inode buffer uninitialized (or with old state from a previous
    generation inode) and this is what xfs_bulkstat() would report.
    
    The patch marks the on-disk inode buffer "dirty" on unlink. When the inode
    is reclaimed (by a new file create), xfs_bulkstat() would filter this
    inode by the "dirty" mark. Once the inode is flushed to disk, the on-disk
    buffer "dirty" mark is automatically removed and a following
    xfs_bulkstat() would return the correct inode state.
    
    Marking the on-disk inode buffer "dirty" on unlink is achieved by setting
    the on-disk di_nlink field to 0. Note that the in-core di_nlink has
    already been set to 0 and a corresponding transaction logged by
    xfs_droplink(). This is an exception from the rule that any on-disk inode
    buffer changes has to be followed by a disk write (inode flush).
    Synchronizing the in-core to on-disk di_nlink values in advance (before
    the actual inode flush to disk) should be fine in this case because the
    inode is already unlinked and it would never change its di_nlink again for
    this inode generation.
    
    SGI-PV: 970842
    SGI-Modid: xfs-linux-melb:xfs-kern:29757a
    
    Signed-off-by: Vlad Apostolov <vapo@sgi.com>
    Signed-off-by: Alex Elder <aelder@sgi.com>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Mark Goodwin <markgw@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit ba532a980b7dcccf5eebd2cd409a9cb37faa2bb4
Author: Christoph Hellwig <hch@infradead.org>
Date:   Wed Sep 19 15:27:18 2007 +1000

    [XFS] Kill unused IOMAP_EOF flag
    
    SGI-PV: 968563
    SGI-Modid: xfs-linux-melb:xfs-kern:29705a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 574342f4ad450b33bc85ec53210b8aa8bfff2fcf
Author: Vlad Apostolov <vapo@sgi.com>
Date:   Fri Sep 14 15:23:44 2007 +1000

    [XFS] fix when DMAPI mount option processing happens
    Fix for a regression caused by a recent patch
    that moved the DMAPI mount option processing inside xfs_parseargs(). The
    DMAPI mount option used to be processed in the DMAPI module loaded before
    xfs_parseargs() was invoked.
    
    SGI-PV: 970451
    SGI-Modid: xfs-linux-melb:xfs-kern:29683a
    
    Signed-off-by: Vlad Apostolov <vapo@sgi.com>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 5903c4956f7b429f515ba107d9c04bbbe7ce8f9d
Author: Lachlan McIlroy <lachlan@sgi.com>
Date:   Fri Sep 14 15:22:08 2007 +1000

    [XFS] ensure file size is logged on synchronous writes
    
    Synchronous writes currently log inode changes before syncing pages to
    disk. Since the file size is updated on I/O completion we wont be writing
    out the updated file size and if we crash the file will have the wrong
    size. This change moves the logging after the syncing of the pages to
    ensure we log the correct file size.
    
    SGI-PV: 970334
    SGI-Modid: xfs-linux-melb:xfs-kern:29649a
    
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit cc92e7ac8d96418d99f0c31a9a132e9fccc54553
Author: Christoph Hellwig <hch@infradead.org>
Date:   Thu Aug 30 17:21:54 2007 +1000

    [XFS] growlock should be a mutex
    
    m_growlock only needs plain binary mutex semantics, so use a struct mutex
    instead of a semaphore for it.
    
    SGI-PV: 968563
    SGI-Modid: xfs-linux-melb:xfs-kern:29512a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 0adba5363ccbee073f127feb1d6942e64ee63ab3
Author: Christoph Hellwig <hch@infradead.org>
Date:   Thu Aug 30 17:21:46 2007 +1000

    [XFS] replace some large xfs_log_priv.h macros by proper functions
    
    ... or in the case of XLOG_TIC_ADD_OPHDR remove a useless macro entirely.
    
    SGI-PV: 968563
    SGI-Modid: xfs-linux-melb:xfs-kern:29511a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit b267ce9952374c51099f21d6c3a59c78fa0d7586
Author: Christoph Hellwig <hch@infradead.org>
Date:   Thu Aug 30 17:21:30 2007 +1000

    [XFS] kill struct bhv_vfs
    
    Now that struct bhv_vfs doesn't have any members left we can kill it and
    go directly from the super_block to the xfs_mount everywhere.
    
    SGI-PV: 969608
    SGI-Modid: xfs-linux-melb:xfs-kern:29509a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 743944967021f3759d3540b0dfbc7ee7215bc4b0
Author: Christoph Hellwig <hch@infradead.org>
Date:   Thu Aug 30 17:21:22 2007 +1000

    [XFS] move syncing related members from struct bhv_vfs to struct xfs_mount
    
    SGI-PV: 969608
    SGI-Modid: xfs-linux-melb:xfs-kern:29508a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit bd186aa901c183d6e25257711b6c64b42a90dde0
Author: Christoph Hellwig <hch@infradead.org>
Date:   Thu Aug 30 17:21:12 2007 +1000

    [XFS] kill the vfs_flags member in struct bhv_vfs
    
    All flags are added to xfs_mount's m_flag instead. Note that the 32bit
    inode flag was duplicated in both of them, but only cleared in the mount
    when it was not nessecary due to the filesystem beeing small enough. Two
    flags are still required here - one to indicate the mount option setting,
    and one to indicate if it applies or not.
    
    SGI-PV: 969608
    SGI-Modid: xfs-linux-melb:xfs-kern:29507a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 0ce4cfd4f7dde5891d5b3e3c1a28ff7a7b4d36b3
Author: Christoph Hellwig <hch@infradead.org>
Date:   Thu Aug 30 17:20:53 2007 +1000

    [XFS] kill the vfs_fsid and vfs_altfsid members in struct bhv_vfs
    
    vfs_altfsid was just a pointer to mp->m_fixedfsid so we can trivially
    replace it with the latter. vfs_fsid also was identical to m_fixedfsid
    through rather obfuscated ways so we can kill it as well and simply its
    only user.
    
    SGI-PV: 969608
    SGI-Modid: xfs-linux-melb:xfs-kern:29506a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 745f691912b700ac98607b525f3c892204c7f12f
Author: Christoph Hellwig <hch@infradead.org>
Date:   Thu Aug 30 17:20:39 2007 +1000

    [XFS] call common xfs vfs-level helpers directly and remove vfs operations
    
    Also remove the now dead behavior code.
    
    SGI-PV: 969608
    SGI-Modid: xfs-linux-melb:xfs-kern:29505a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 48c872a9f3ec4cdc37801aae9ef16c80026503ea
Author: Christoph Hellwig <hch@infradead.org>
Date:   Thu Aug 30 17:20:31 2007 +1000

    [XFS] decontaminate vfs operations from behavior details
    
    All vfs ops now take struct xfs_mount pointers and the behaviour related
    glue is split out into methods of its own.
    
    SGI-PV: 969608
    SGI-Modid: xfs-linux-melb:xfs-kern:29504a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit b09cc77109dbf33463480952de10511a2b67bba6
Author: Christoph Hellwig <hch@infradead.org>
Date:   Thu Aug 30 17:19:57 2007 +1000

    [XFS] remove dependency of the quota module on behaviors
    
    Mount options are now parsed by the main XFS module and rejected if quota
    support is not available, and there are some new quota operation for the
    quotactl syscall and calls to quote in the mount, unmount and sync
    callchains.
    
    SGI-PV: 969608
    SGI-Modid: xfs-linux-melb:xfs-kern:29503a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 293688ec420f1160ed93ea4c7948ed5baf8bafa7
Author: Christoph Hellwig <hch@infradead.org>
Date:   Wed Aug 29 11:59:36 2007 +1000

    [XFS] remove dependency of the dmapi module on behaviors
    
    Mount options are now parsed by the main XFS module and rejected if dmapi
    support is not available, and there is a new dm operation to send the
    mount event.
    
    SGI-PV: 969608
    SGI-Modid: xfs-linux-melb:xfs-kern:29502a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit f541d270dbce375b7bd8cef466bdaf0cff945b45
Author: Christoph Hellwig <hch@infradead.org>
Date:   Wed Aug 29 11:53:22 2007 +1000

    [XFS] move freeing the mount structure from xfs_mount_free into the callers
    
    In the next patch we need to look at the mount structure until just before
    it's freed, so we need to be able to free it as the very last thing in
    xfs_unmount.
    
    SGI-PV: 969608
    SGI-Modid: xfs-linux-melb:xfs-kern:29501a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 0a74cd1964501fdb577176f14ed3d02b8e148127
Author: Christoph Hellwig <hch@infradead.org>
Date:   Wed Aug 29 11:53:12 2007 +1000

    [XFS] kill struct bhv_vnode
    
    Now that struct bhv_vnode is empty we can just kill it. Retain bhv_vnode_t
    as a typedef for struct inode for the time being until all the fallout is
    cleaned up.
    
    SGI-PV: 969608
    SGI-Modid: xfs-linux-melb:xfs-kern:29500a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 2aeaa258c0527026228c43148ec6dffdc56bea1c
Author: Christoph Hellwig <hch@infradead.org>
Date:   Wed Aug 29 11:46:57 2007 +1000

    [XFS] kill the v_number member in struct bhv_vnode
    
    It's entirely unused except for ignored arguments in the mrlock
    initialization, so remove it.
    
    SGI-PV: 969608
    SGI-Modid: xfs-linux-melb:xfs-kern:29499a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 1543d79c45a374f934f95ca34d87e2eeeb2039b4
Author: Christoph Hellwig <hch@infradead.org>
Date:   Wed Aug 29 11:46:47 2007 +1000

    [XFS] move v_trace from bhv_vnode to xfs_inode
    
    struct bhv_vnode is on it's way out, so move the trace buffer to the XFS
    inode. Note that this makes the tracing macros rather misnamed, but this
    kind of fallout will be fixed up incrementally later on.
    
    SGI-PV: 969608
    SGI-Modid: xfs-linux-melb:xfs-kern:29498a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit b677c210cec0d6755335ffc01691982c417dd39e
Author: Christoph Hellwig <hch@infradead.org>
Date:   Wed Aug 29 11:46:28 2007 +1000

    [XFS] move v_iocount from bhv_vnode to xfs_inode
    
    struct bhv_vnode is on it's way out, so move the I/O count to the XFS
    inode.
    
    SGI-PV: 969608
    SGI-Modid: xfs-linux-melb:xfs-kern:29497a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 09262b4339de5417a10803fbfac277eebb38ca5a
Author: Christoph Hellwig <hch@infradead.org>
Date:   Wed Aug 29 11:44:50 2007 +1000

    [XFS] Create xfs_iflags_test_and_clear helper function
    
    SGI-PV: 969608
    SGI-Modid: xfs-linux-melb:xfs-kern:29496a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit b3aea4edc2903fdee34920630b8b2433f6452f02
Author: Christoph Hellwig <hch@infradead.org>
Date:   Wed Aug 29 11:44:37 2007 +1000

    [XFS] kill the v_flag member in struct bhv_vnode
    
    All flags previously handled at the vnode level are not in the xfs_inode
    where we already have a flags mechanisms and free bits for flags
    previously in the vnode.
    
    SGI-PV: 969608
    SGI-Modid: xfs-linux-melb:xfs-kern:29495a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 2f6f7b3d9b5600e1f6e7622c62ab30f36bd0f57f
Author: Christoph Hellwig <hch@infradead.org>
Date:   Wed Aug 29 11:44:18 2007 +1000

    [XFS] kill v_vfsp member from struct bhv_vnode
    
    We can easily get at the vfsp through the super_block but it will soon be
    gone anyway.
    
    SGI-PV: 969608
    SGI-Modid: xfs-linux-melb:xfs-kern:29494a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 739bfb2a7dfa369324f74aad1d020d6e0775e4f0
Author: Christoph Hellwig <hch@infradead.org>
Date:   Wed Aug 29 10:58:01 2007 +1000

    [XFS] call common xfs vnode-level helpers directly and remove vnode operations
    
    SGI-PV: 969608
    SGI-Modid: xfs-linux-melb:xfs-kern:29493a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 993386c19afa53fa54d00c7721e56ba820b3400d
Author: Christoph Hellwig <hch@infradead.org>
Date:   Tue Aug 28 16:12:30 2007 +1000

    [XFS] decontaminate vnode operations from behavior details
    
    All vnode ops now take struct xfs_inode pointers and the behaviour related
    glue is split out into methods of it's own. This required fixing
    xfs_create/mkdir/symlink to not mess with the inode pointer but rather use
    a separate boolean for error handling. Thanks to Dave Chinner for that
    fix.
    
    SGI-PV: 969608
    SGI-Modid: xfs-linux-melb:xfs-kern:29492a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit b93bd20cd59eb7ec172f95d08b100fea688d8bcf
Author: Vlad Apostolov <vapo@sgi.com>
Date:   Tue Aug 28 14:00:28 2007 +1000

    [XFS] do not have XFSMNT_IDELETE as default when mounted with XFSMNT_DMAPI
    
    XFS inodes are dynamically allocated on demand, rather than being
    allocated at mkfs time. Chunks of 64 inodes are allocated at once, but
    they are never freed. Over time, this can lead to filesystem
    fragmentation, clusters of inodes and the btrees which point at them can
    be scattered around the system.
    
    By freeing clusters as they are emptied, we will reduce fragmentation of
    the free space after removing files. This in turn will allow us to make
    better placement decisions when repopulating a filesystem. The
    XFSMNT_IDELETE mount option enables freeing clusters when they get empty.
    
    Unfortunately a side effect of freeing inode clusters is that the inode
    generation numbers of such inodes would be reset to zero when the cluster
    is reclaimed. This is a problem in particular for a DMAPI enabled
    filesystem as the the DMAPI handles need to be unique and persistent in
    time. An unique DMAPI handle is built with the help of the inode
    generation number. When the last one is prematurely reset by an inode
    cluster reclaim, there is a high probability of different generation
    inodes to end up having identical DMAPI handles.
    
    To avoid the problem with identical DMAPI handles, the XFSMNT_IDELETE
    mount option should be set as default, only if the filesystem is not
    mounted with XFSMNT_DMAPI.
    
    SGI-PV: 969192
    SGI-Modid: xfs-linux-melb:xfs-kern:29486a
    
    Signed-off-by: Vlad Apostolov <vapo@sgi.com>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Mark Goodwin <markgw@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit da353b0d64e070ae7c5342a0d56ec20ae9ef5cfb
Author: David Chinner <dgc@sgi.com>
Date:   Tue Aug 28 14:00:13 2007 +1000

    [XFS] Radix tree based inode caching
    
    One of the perpetual scaling problems XFS has is indexing it's incore
    inodes. We currently uses hashes and the default hash sizes chosen can
    only ever be a tradeoff between memory consumption and the maximum
    realistic size of the cache.
    
    As a result, anyone who has millions of inodes cached on a filesystem
    needs to tunes the size of the cache via the ihashsize mount option to
    allow decent scalability with inode cache operations.
    
    A further problem is the separate inode cluster hash, whose size is based
    on the ihashsize but is smaller, and so under certain conditions (sparse
    cluster cache population) this can become a limitation long before the
    inode hash is causing issues.
    
    The following patchset removes the inode hash and cluster hash and
    replaces them with radix trees to avoid the scalability limitations of the
    hashes. It also reduces the size of the inodes by 3 pointers....
    
    SGI-PV: 969561
    SGI-Modid: xfs-linux-melb:xfs-kern:29481a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 39cd9f877e63ce7e02cdc7f5dbf1b908451c9532
Author: Christoph Hellwig <hch@infradead.org>
Date:   Tue Aug 28 13:59:21 2007 +1000

    [XFS] kill move.[ch]
    
    Kill uio related functions and defines now that they're unused.
    
    SGI-PV: 968563
    SGI-Modid: xfs-linux-melb:xfs-kern:29480a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 804c83c37607efe415774c3a170ad72a789e5992
Author: Christoph Hellwig <hch@infradead.org>
Date:   Tue Aug 28 13:59:03 2007 +1000

    [XFS] stop using uio in the readlink code
    
    Simplify the readlink code to get rid of the last user of uio.
    
    SGI-PV: 968563
    SGI-Modid: xfs-linux-melb:xfs-kern:29479a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 051e7cd44ab8f0f7c2958371485b4a1ff64a8d1b
Author: Christoph Hellwig <hch@infradead.org>
Date:   Tue Aug 28 13:58:24 2007 +1000

    [XFS] use filldir internally
    
    Currently xfs has a rather complicated internal scheme to allow for
    different directory formats in IRIX. This patch rips all code related to
    this out and pushes useage of the Linux filldir callback into the lowlevel
    directory code. This does not make the code any less portable because
    filldir can be used to create dirents of all possible variations
    (including the IRIX ones as proved by the IRIX binary emulation code under
    arch/mips/).
    
    This patch get rid of an unessecary copy in the readdir path, about 400
    lines of code and one of the last two users of the uio structure.
    
    This version is updated to deal with dmapi aswell which greatly simplifies
    the get_dirattrs code. The dmapi part has been tested using the
    get_dirattrs tools from the xfstest dmapi suite1 with various small and
    large directories.
    
    SGI-PV: 968563
    SGI-Modid: xfs-linux-melb:xfs-kern:29478a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 2bdf7cd0baa67608ada1517a281af359faf4c58c
Author: Christoph Hellwig <hch@infradead.org>
Date:   Tue Aug 28 13:58:06 2007 +1000

    [XFS] superblock endianess annotations
    
    Creates a new xfs_dsb_t that is __be annotated and keeps xfs_sb_t for the
    incore one. xfs_xlatesb is renamed to xfs_sb_to_disk and only handles the
    incore -> disk conversion. A new helper xfs_sb_from_disk handles the other
    direction and doesn't need the slightly hacky table-driven approach
    because we only ever read the full sb from disk.
    
    The handling of shared r/o filesystems has been buggy on little endian
    system and fixing this required shuffling around of some code in that
    area.
    
    SGI-PV: 968563
    SGI-Modid: xfs-linux-melb:xfs-kern:29477a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 347d1c01956d567c18afef0cc253eb235cafacd8
Author: Christoph Hellwig <hch@infradead.org>
Date:   Tue Aug 28 13:57:51 2007 +1000

    [XFS] dinode endianess annotations
    
    Biggest bit is duplicating the dinode structure so we have one annotated for
    native endianess and one for disk endianess. The other significant change
    is that xfs_xlate_dinode_core is split into one helper per direction to
    allow for proper annotations, everything else is trivial.
    
    As a sidenode splitting out the incore dinode means we can move it into
    xfs_inode.h in a later patch and severely improving on the include hell in
    xfs.
    
    SGI-PV: 968563
    SGI-Modid: xfs-linux-melb:xfs-kern:29476a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit ddc6d3b32a8a732c343dc225048fae06c129e48a
Author: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Date:   Thu Aug 23 16:20:10 2007 +1000

    [XFS] Fix build regression from mod/commit which did cleanup of xfs_bmbt_*set_allf
    
    In sgi mod# xfs-linux-melb:xfs-kern:29319a, the variable renaming was not
    complete and variable 'b' was left unchanged for non-lbd 32 bit machines.
    
    SGI-PV: 968563
    SGI-Modid: xfs-linux-melb:xfs-kern:29469a
    
    Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 948c6d4fd894d9c7f9ad764cedbe443aa866def2
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Thu Aug 23 16:19:57 2007 +1000

    [XFS] optimize dmapi event tests w/o dmapi config
    
    SGI-PV: 969372
    SGI-Modid: xfs-linux-melb:xfs-kern:29444a
    
    Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
    Signed-off-by: Vlad Apostolov <vapo@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit eb9df39daf870d6f9e9528f092d506be04ebad2f
Author: Christoph Hellwig <hch@infradead.org>
Date:   Thu Aug 16 18:42:07 2007 +1000

    [XFS] remove unessecary vfs argument to DM_EVENT_ENABLED
    
    SGI-PV: 968690
    SGI-Modid: xfs-linux-melb:xfs-kern:29340a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Vlad Apostolov <vapo@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 49ee6c911f0ae5b3a9a04e0589e3265e52f94f53
Author: Jesper Juhl <jesper.juhl@gmail.com>
Date:   Thu Aug 16 16:25:42 2007 +1000

    [XFS] Fix a potential NULL pointer deref in XFS on failed mount.
    
    If we fail to open the the log device buftarg, we can fall through to
    error handling code that fails to check for a NULL log device buftarg
    before calling xfs_free_buftarg().
    
    This patch fixes the issue by checking mp->m_logdev_targp against NULL in
    xfs_unmountfs_close() and doing the proper xfs_blkdev_put(logdev); and
    xfs_blkdev_put(rtdev); on (!mp->m_rtdev_targp) in xfs_mount().
    
    Discovered by the Coverity checker.
    
    SGI-PV: 968563
    SGI-Modid: xfs-linux-melb:xfs-kern:29328a
    
    Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit dcb3b83febd1028afbc4a32cf7642a6580e349c6
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Thu Aug 16 16:25:33 2007 +1000

    [XFS] clean up xfs_start_flags
    
    xfs_start_flags can make use of is_power_of_2 to tidy up the test a little
    bit.
    
    SGI-PV: 968563
    SGI-Modid: xfs-linux-melb:xfs-kern:29327a
    
    Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit af3a2e8a3f3055ef269b09433bb28e33a0d1b8c0
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Thu Aug 16 16:25:23 2007 +1000

    [XFS] move linux/log2.h header to xfs_linux.h
    
    Generally we try not to directly include linux header files in core xfs
    code; xfs_linux.h is the spot for that.
    
    SGI-PV: 968563
    SGI-Modid: xfs-linux-melb:xfs-kern:29326a
    
    Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 6385f4d5579ccada7bd1d9fefbdea5515457b10d
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Thu Aug 16 16:25:10 2007 +1000

    [XFS] Remove xfs_physmem
    
    Now that nobody's using it, remove xfs_physmem & friends.
    
    SGI-PV: 968563
    SGI-Modid: xfs-linux-melb:xfs-kern:29325a
    
    Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 425f9ddd534573f58df8e7b633a534fcfc16d44d
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Thu Aug 16 16:24:55 2007 +1000

    [XFS] Pick a single default inode cluster size.
    
    Remove scaling of inode "clusters" based on machine memory; small cluster
    cut-point was an unrealistic 32MB and was probably never tested.
    
    Removes another user of xfs_physmem.
    
    SGI-PV: 968563
    SGI-Modid: xfs-linux-melb:xfs-kern:29324a
    
    Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 1cb51258758d725028e9ee9688d462de125a053d
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Thu Aug 16 16:24:43 2007 +1000

    [XFS] choose single default logbuf count & size
    
    Remove sizing of logbuf size & count based on physical memory; this was
    never a very good gauge as it's looking at global memory, but deciding on
    sizing per-filesystem; no account is made of the total number of
    filesystems, for example.
    
    For now just take the largest "default" case, as was set for machines with
    >400MB - 8 x 32k buffers. This can always be tuned higher or lower with
    mount options if necessary. Removes one more user of xfs_physmem.
    
    SGI-PV: 968563
    SGI-Modid: xfs-linux-melb:xfs-kern:29323a
    
    Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 40906630f18fdf5ac27f5928c20f76eeac8fb0f0
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Thu Aug 16 16:24:31 2007 +1000

    [XFS] Remove m_nreadaheads
    
    m_nreadaheads in the mount struct is never used; remove it and the various
    macros assigned to it. Also remove a couple other unused macros in the
    same areas.
    
    Removes one user of xfs_physmem.
    
    SGI-PV: 968563
    SGI-Modid: xfs-linux-melb:xfs-kern:29322a
    
    Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit cd8b0a97bd9216578a44a9bf82188cd901295964
Author: Christoph Hellwig <hch@infradead.org>
Date:   Thu Aug 16 16:24:15 2007 +1000

    [XFS] endianess annotations for xfs_bmbt_rec_t
    
    SGI-PV: 968563
    SGI-Modid: xfs-linux-melb:xfs-kern:29321a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit e05596643d4bb5ab7d813d1ac5724178ca4c7134
Author: Christoph Hellwig <hch@infradead.org>
Date:   Thu Aug 16 16:24:02 2007 +1000

    [XFS] cleanup defintions of BMBT_*BITLEN macros
    
    The BMBT_*BITLEN are currently defined in a complicated way depending on
    XFS_NATIVE_HOST. But if all the macros are expanded they (obviously)
    expand to the same value for both cases.
    
    This patch defines the macros in the most simple way and updates the
    comment describing them to remove outdated bits.
    
    SGI-PV: 968563
    SGI-Modid: xfs-linux-melb:xfs-kern:29320a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 8cba43447e7a843cd446a73baa91fe686f01e565
Author: Christoph Hellwig <hch@infradead.org>
Date:   Thu Aug 16 16:23:53 2007 +1000

    [XFS] clean up xfs_bmbt_set_all/xfs_bmbt_disk_set_all
    
    xfs_bmbt_set_all/xfs_bmbt_disk_set_all are identical to
    xfs_bmbt_set_allf/xfs_bmbt_disk_set_allf except that the former take a
    xfs_bmbt_irec_t and the latter take the individual extent fields as scalar
    values.
    
    This patch reimplements xfs_bmbt_set_all/xfs_bmbt_disk_set_all as trivial
    wrappers around xfs_bmbt_set_allf/xfs_bmbt_disk_set_allf and cleans up the
    variable naming in xfs_bmbt_set_allf/xfs_bmbt_disk_set_allf to have some
    meaning instead of one char variable names.
    
    SGI-PV: 968563
    SGI-Modid: xfs-linux-melb:xfs-kern:29319a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit a6f64d4aea0d0c8483e910c7dd2d1ee48e42245c
Author: Christoph Hellwig <hch@infradead.org>
Date:   Thu Aug 16 16:23:40 2007 +1000

    [XFS] split ondisk vs incore versions of xfs_bmbt_rec_t
    
    currently xfs_bmbt_rec_t is used both for ondisk extents as well as
    host-endian ones. This patch adds a new xfs_bmbt_rec_host_t for the native
    endian ones and cleans up the fallout. There have been various endianess
    issues in the tracing / debug printf code that are fixed by this patch.
    
    SGI-PV: 968563
    SGI-Modid: xfs-linux-melb:xfs-kern:29318a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit d580ef6eaae6eaaef1e06c7d689fc9949faee9da
Author: Christoph Hellwig <hch@infradead.org>
Date:   Thu Aug 16 16:23:11 2007 +1000

    [XFS] remove confusing INT_ comments in xfs_bmap_btree.c
    
    SGI-PV: 968563
    SGI-Modid: xfs-linux-melb:xfs-kern:29317a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 3bacbcd8830f89fc527f5c7dc13f24d0ce692980
Author: Vlad Apostolov <vapo@sgi.com>
Date:   Thu Aug 16 15:20:25 2007 +1000

    [XFS] hole not shown when file is created with resvsp
    
    SGI-PV: 967674
    SGI-Modid: xfs-linux-melb:xfs-kern:29211a
    
    Signed-off-by: Vlad Apostolov <vapo@sgi.com>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 0bfefc46dc028df60120acdb92062169c9328769
Author: David Chinner <dgc@sgi.com>
Date:   Mon May 14 18:24:23 2007 +1000

    [XFS] Barriers need to be dynamically checked and switched off
    
    If the underlying block device suddenly stops supporting barriers, we need
    to handle the -EOPNOTSUPP error in a sane manner rather than shutting
    down the filesystem. If we get this error, clear the barrier flag, reissue
    the I/O, and tell the world bad things are occurring.
    
    SGI-PV: 964544
    SGI-Modid: xfs-linux-melb:xfs-kern:28568a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Tim Shimmin <tes@sgi.com>
