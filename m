Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 17 Apr 2008 22:06:42 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3I55Jbm027848
	for <xfs@oss.sgi.com>; Thu, 17 Apr 2008 22:05:21 -0700
Date: Fri, 18 Apr 2008 15:05:46 +1000
Subject: [GIT PULL] XFS update for 2.6.26-rc1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <20080418050547.0E70F58C4C15@chook.melbourne.sgi.com>
From: lachlan@sgi.com (Lachlan McIlroy)
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org

Please pull from the for-linus branch:
    git pull git://oss.sgi.com:8090/xfs/xfs-2.6.git for-linus

This will update the following files:

 Documentation/filesystems/xfs.txt |   15 +-
 fs/xfs/Kconfig                    |   12 -
 fs/xfs/linux-2.6/kmem.c           |    6 +-
 fs/xfs/linux-2.6/xfs_aops.c       |   12 +-
 fs/xfs/linux-2.6/xfs_buf.c        |    8 +-
 fs/xfs/linux-2.6/xfs_buf.h        |    8 +-
 fs/xfs/linux-2.6/xfs_cred.h       |    2 +-
 fs/xfs/linux-2.6/xfs_export.c     |   14 +-
 fs/xfs/linux-2.6/xfs_file.c       |   13 +-
 fs/xfs/linux-2.6/xfs_fs_subr.c    |   36 +--
 fs/xfs/linux-2.6/xfs_ioctl.c      |  676 ++++++++++++++----------------
 fs/xfs/linux-2.6/xfs_iops.c       |  223 ++++++-----
 fs/xfs/linux-2.6/xfs_linux.h      |    1 -
 fs/xfs/linux-2.6/xfs_lrw.c        |   70 ++--
 fs/xfs/linux-2.6/xfs_lrw.h        |    3 +-
 fs/xfs/linux-2.6/xfs_stats.h      |    4 +-
 fs/xfs/linux-2.6/xfs_super.c      |   27 +-
 fs/xfs/linux-2.6/xfs_super.h      |    8 +-
 fs/xfs/linux-2.6/xfs_vfs.h        |    1 -
 fs/xfs/linux-2.6/xfs_vnode.h      |   30 +--
 fs/xfs/quota/xfs_dquot.c          |   20 +-
 fs/xfs/quota/xfs_dquot_item.c     |   14 +-
 fs/xfs/quota/xfs_qm.c             |   76 ++--
 fs/xfs/quota/xfs_qm.h             |    2 +-
 fs/xfs/quota/xfs_qm_stats.h       |    4 +-
 fs/xfs/quota/xfs_qm_syscalls.c    |   44 ++-
 fs/xfs/support/ktrace.c           |   37 +-
 fs/xfs/support/ktrace.h           |    3 +-
 fs/xfs/xfs.h                      |    2 +-
 fs/xfs/xfs_acl.c                  |   16 +-
 fs/xfs/xfs_alloc.c                |   65 ++--
 fs/xfs/xfs_attr.c                 |   10 +-
 fs/xfs/xfs_attr_leaf.c            |    2 +-
 fs/xfs/xfs_bmap.c                 |   59 ++--
 fs/xfs/xfs_bmap.h                 |    2 +-
 fs/xfs/xfs_bmap_btree.c           |   54 ++-
 fs/xfs/xfs_buf_item.c             |    7 +-
 fs/xfs/xfs_dir2.c                 |   62 ++--
 fs/xfs/xfs_dir2.h                 |   12 +-
 fs/xfs/xfs_filestream.c           |    2 +-
 fs/xfs/xfs_ialloc.c               |   44 ++-
 fs/xfs/xfs_iget.c                 |   49 +--
 fs/xfs/xfs_inode.c                |  823 ++++++++++++++++++-------------------
 fs/xfs/xfs_inode.h                |   23 +-
 fs/xfs/xfs_inode_item.c           |    8 +-
 fs/xfs/xfs_inode_item.h           |    8 +
 fs/xfs/xfs_iomap.c                |    7 +-
 fs/xfs/xfs_itable.c               |    7 +-
 fs/xfs/xfs_log.c                  |  259 ++++--------
 fs/xfs/xfs_log.h                  |    5 +-
 fs/xfs/xfs_log_priv.h             |   93 +++--
 fs/xfs/xfs_log_recover.c          |  123 ++++--
 fs/xfs/xfs_mount.c                |   66 ++--
 fs/xfs/xfs_mount.h                |   30 +-
 fs/xfs/xfs_rename.c               |  121 ++----
 fs/xfs/xfs_rtalloc.c              |   41 ++-
 fs/xfs/xfs_rw.c                   |    8 +-
 fs/xfs/xfs_trans.h                |    8 +-
 fs/xfs/xfs_trans_ail.c            |  151 +++----
 fs/xfs/xfs_trans_buf.c            |   15 +-
 fs/xfs/xfs_types.h                |    5 +
 fs/xfs/xfs_utils.c                |   26 +--
 fs/xfs/xfs_utils.h                |   15 +-
 fs/xfs/xfs_vfsops.c               |   76 ++---
 fs/xfs/xfs_vnodeops.c             |  505 +++++++----------------
 fs/xfs/xfs_vnodeops.h             |   33 +-
 66 files changed, 1907 insertions(+), 2304 deletions(-)

through these commits:

commit 65e67f5165c8a156b34ee7adf65d5ed3b16a910d
Author: Lachlan McIlroy <lachlan@redback.melbourne.sgi.com>
Date:   Fri Apr 18 12:59:45 2008 +1000

    [XFS] Fix merge failure

commit 3b2816be271b8b364294a5b48721a3e68af46cfa
Author: Lachlan McIlroy <lachlan@redback.melbourne.sgi.com>
Date:   Fri Apr 18 12:43:35 2008 +1000

    [XFS] The forward declarations for the xfs_ioctl() helpers and the
    associated comment about gcc behavior really aren't needed; all of these
    functions are marked STATIC which includes noinline, and the stack usage
    won't be a problem.
    
    This effectively just removes the forward declarations and moves
    xfs_ioctl() back to the end of the file.
    
    SGI-PV: 971186
    SGI-Modid: xfs-linux-melb:xfs-kern:30534a
    
    Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
    Signed-off-by: Niv Sardi <xaiki@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit f6e9f28865552bd9d79a9df93cf120436b073223
Author: Josef Sipek <jeffpc@josefsipek.net>
Date:   Fri Apr 11 17:11:02 2008 +1000

    [XFS] Update XFS documentation for noikeep/ikeep.
    
    Mention how DMAPI affects default for noikeep.
    Slightly modified since Josef's patch was based on
    an old xfs.txt prior to Dave's (dgc) checkin which
    missed going to oss.
    
    Signed-off-by: Josef Sipek <jeffpc@josefsipek.net>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 033bfb1a65242e0d60e6fc991cd9b3553053d334
Author: David Chinner <dgc@sgi.com>
Date:   Fri Apr 11 17:05:49 2008 +1000

    [XFS] Update XFS Documentation for ikeep and ihashsize
    
    Update xfs docs for:
    * In memory inode hashes has been removed.
    * noikeep is now the default.
    
    SGI-PV: 969561
    SGI-Modid: 2.6.x-xfs-melb:linux:29481b
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit e687330b5ed1ea899fdaf0dea50aba196b6e019a
Author: Donald Douwsma <donaldd@sgi.com>
Date:   Thu Apr 17 16:50:28 2008 +1000

    [XFS] Remove unused HAVE_SPLICE macro.
    
    HAVE_SPLICE was part of the infrastructure for building 2.4 and 2.6
    kernels out of the same tree. Now we don't build 2.4 kernels this
    
    SGI-PV: 971046
    SGI-Modid: xfs-linux-melb:xfs-kern:30878a
    
    Signed-off-by: Donald Douwsma <donaldd@sgi.com>
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit f7d3c34788696f5ba9ac9fa414ad80e2a91d4b2e
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Thu Apr 17 16:50:22 2008 +1000

    [XFS] Remove CONFIG_XFS_SECURITY.
    
    There is no point to the CONFIG_XFS_SECURITY option; it disables the
    ability to set security attributes at runtime, but it does not actually
    slim down or remove any code for runtime. Just remove it and always allow
    security attributes to be set.
    
    SGI-PV: 980310
    SGI-Modid: xfs-linux-melb:xfs-kern:30877a
    
    Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
    Signed-off-by: Tim Shimmin <tes@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 6d1337b29bf09a97682d39db36ac2d0dfc6659c0
Author: Tim Shimmin <tes@sgi.com>
Date:   Thu Apr 17 16:50:16 2008 +1000

    [XFS] xfs_bmap_compute_maxlevels should be based on di_forkoff
    
    Fix up xfs_bmap_compute_maxlevels() to account for the case when we go
    from using attr2 to using attr1. In that case attr1 will no longer
    necessarily be at m_attr_offset>>3, but could be at a different value for
    di_forkoff. Therefore, we return the worst case scenario using MINDBTPTRS
    and MINABTPTRS, as this function is used for determining the maximum log
    space.
    
    SGI-PV: 979606
    SGI-Modid: xfs-linux-melb:xfs-kern:30862a
    
    Signed-off-by: Tim Shimmin <tes@sgi.com>
    Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit cb49dbb130e17a6f9af4cb4714cf6976cf09afdf
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Thu Apr 17 16:50:09 2008 +1000

    [XFS] Always use di_forkoff when checking for attr space.
    
    In the case where we mount a filesystem which was previously using the
    attr2 format as attr1, returning the default mp->m_attroffset instead of
    the per-inode di_forkoff for inline attribute fit calculations, may result
    in corruption, if for example, the data fork is already taking more space
    than the default fork offset and we try to add an extended attribute. Fix
    tested by xfstests/186.
    
    SGI-PV: 979606
    SGI-Modid: xfs-linux-melb:xfs-kern:30861a
    
    Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
    Signed-off-by: Tim Shimmin <tes@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit f6485057c5cfbc84e5eff639ddea1ce0d668607b
Author: David Chinner <dgc@sgi.com>
Date:   Thu Apr 17 16:50:04 2008 +1000

    [XFS] Ensure the inode is joined in xfs_itruncate_finish
    
    On success, we still need to join the inode to the current transaction in
    xfs_itruncate_finish(). Fixes regression from error handling changes.
    
    SGI-PV: 980084
    SGI-Modid: xfs-linux-melb:xfs-kern:30845a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 7e20694d91f817f8e9f62404aca793ae0df4d98a
Author: David Chinner <dgc@sgi.com>
Date:   Thu Apr 17 16:49:55 2008 +1000

    [XFS] Remove periodic logging of in-core superblock counters.
    
    xfssyncd triggers the logging of superblock counters every 30s if the
    filesystem is made with lazy-count=1. This will prevent disks from idling
    and spinning down as there will be a log write every 30s. With the way
    counter recovery works for lazy-count=1, this code is unnecessary and
    provides no real benefit, so just remove it.
    
    SGI-PV: 980145
    SGI-Modid: xfs-linux-melb:xfs-kern:30840a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Barry Naujok <bnaujok@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit e6430037e9fd0b3d02ceaf5ab99bfe3ccb763be7
Author: David Chinner <dgc@sgi.com>
Date:   Thu Apr 17 16:49:49 2008 +1000

    [XFS] fix logic error in xfs_alloc_ag_vextent_near()
    
    Fix a logic error in xfs_alloc_ag_vextent_near(). This is a regression
    introduced by the error handling changes.
    
    SGI-PV: 890084
    SGI-Modid: xfs-linux-melb:xfs-kern:30838a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Barry Naujok <bnaujok@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit d4055947bd0913864f4d8ac96bf1197338071622
Author: David Chinner <dgc@sgi.com>
Date:   Thu Apr 17 16:49:35 2008 +1000

    [XFS] Don't error out on good I/Os.
    
    xfsbdstrat() made all I/Os error out, good or bad. Fix it.
    
    SGI-PV: 980084
    SGI-Modid: xfs-linux-melb:xfs-kern:30836a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Donald Douwsma <donaldd@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 1bb7d6b5a82f1d9487fd44415484a368f7c87bed
Author: David Chinner <dgc@sgi.com>
Date:   Thu Apr 10 12:24:38 2008 +1000

    [XFS] Catch log unmount failures.
    
    Unmounting the log can fail. unlikely, but it can. Catch all the error
    conditions an make sure it's propagated upwards.
    
    SGI-PV: 980084
    SGI-Modid: xfs-linux-melb:xfs-kern:30833a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Niv Sardi <xaiki@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit b911ca0472c3762d2bafc4d21e432a9056844064
Author: David Chinner <dgc@sgi.com>
Date:   Thu Apr 10 12:24:30 2008 +1000

    [XFS] Sanitise xfs_log_force error checking.
    
    xfs_log_force() is declared to return an error, but we almost never check
    it. We don't need to check it in most cases; if there's a log I/O error
    then we'll be shutting down the filesystem anyway and that means we'll
    catch the error somewhere else.
    
    However, on certain calls we should be returning an error - sync
    transactions, fsync, sync writes, etc. so this isn't a pure black and
    white distinction. Hence make xfs_log_force() a void function that issues
    a warning to the syslog on error, and call _xfs_log_force() in all the
    places where we actually care about the error status returned.
    
    SGI-PV: 980084
    SGI-Modid: xfs-linux-melb:xfs-kern:30832a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Niv Sardi <xaiki@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 234f56aca20a4f66b6ba3d3bf2787634dd9e0999
Author: David Chinner <dgc@sgi.com>
Date:   Thu Apr 10 12:24:24 2008 +1000

    [XFS] Check for errors when changing buffer pointers.
    
    xfs_buf_associate_memory() can fail, but the return is never checked.
    Propagate the error through XFS_BUF_SET_PTR() so that failures are
    detected.
    
    SGI-PV: 980084
    SGI-Modid: xfs-linux-melb:xfs-kern:30831a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Niv Sardi <xaiki@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 78e9da77f1bf265fe750b9223ec15707473fb6e8
Author: David Chinner <dgc@sgi.com>
Date:   Thu Apr 10 12:24:17 2008 +1000

    [XFS] Don't allow silent errors in xfs_inactive().
    
    xfs_inactive() fails to report errors when committing the inactive
    transaction. Hence we can get silent failures either finishing off the
    truncation or committing the transaction. Even if we get errors, we need
    to continue, so simply warn loudly to the system if we get errors here.
    
    SGI-PV: 980084
    SGI-Modid: xfs-linux-melb:xfs-kern:30830a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Niv Sardi <xaiki@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 64bfe1bfae833e89ed77f72c61ded19f4b1976f8
Author: David Chinner <dgc@sgi.com>
Date:   Thu Apr 10 12:24:10 2008 +1000

    [XFS] Catch errors from xfs_imap().
    
    Catch errors from xfs_imap() in log recovery when we might be trying to
    map an invalid inode number due to a corrupted log.
    
    SGI-PV: 980084
    SGI-Modid: xfs-linux-melb:xfs-kern:30829a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Niv Sardi <xaiki@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 7b07339048f7b020575706b492c004b5664b67ab
Author: David Chinner <dgc@sgi.com>
Date:   Thu Apr 10 12:24:04 2008 +1000

    [XFS] xfs_bulkstat_one_dinode() never returns an error.
    
    Mark it void.
    
    SGI-PV: 980084
    SGI-Modid: xfs-linux-melb:xfs-kern:30828a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Niv Sardi <xaiki@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit e4ac967b117c5780760abbd9ae996210c31cb398
Author: David Chinner <dgc@sgi.com>
Date:   Thu Apr 10 12:23:58 2008 +1000

    [XFS] xfs_iflush_fork() never returns an error.
    
    xfs_iflush_fork() never returns an error. Mark it void and clean up the
    code calling it that checks for errors.
    
    SGI-PV: 980084
    SGI-Modid: xfs-linux-melb:xfs-kern:30827a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Niv Sardi <xaiki@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit cc88466f3f67bb16fc91b0b974e51c2a43a9e597
Author: David Chinner <dgc@sgi.com>
Date:   Thu Apr 10 12:23:52 2008 +1000

    [XFS] Catch unwritten extent conversion errors.
    
    On unwritten I/O completion, we fail to propagate an error when converting
    the extent to a written extent. This means that the I/O silently fails.
    propagate the error onto the ioend so that the inode is marked with an
    error appropriately.
    
    SGI-PV: 980084
    SGI-Modid: xfs-linux-melb:xfs-kern:30826a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Niv Sardi <xaiki@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 958d4ec606d4af590f86a601a238613f21e878ee
Author: David Chinner <dgc@sgi.com>
Date:   Thu Apr 10 12:23:46 2008 +1000

    [XFS] xfs_bdwrite() does not return errors.
    
    xfs_bdwrite() cannot return an error; it only queues buffers to the
    delayed write list and as such never encounters anything that can fail.
    Mark it void.
    
    SGI-PV: 980084
    SGI-Modid: xfs-linux-melb:xfs-kern:30825a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Niv Sardi <xaiki@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit db7a19f2c89d99b66874a7e0c0dc681ff1f37b4e
Author: David Chinner <dgc@sgi.com>
Date:   Thu Apr 10 12:22:24 2008 +1000

    [XFS] Ensure xfs_bawrite() errors are checked.
    
    xfs_bawrite() can return immediate error status on async writes. Unlike
    xfsbdstrat() we don't ever check the error on the buffer after the call,
    so we currently do not catch errors at all here. Ensure we catch and
    propagate or warn to the syslog about up-front async write errors.
    
    SGI-PV: 980084
    SGI-Modid: xfs-linux-melb:xfs-kern:30824a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Niv Sardi <xaiki@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit d64e31a2f53cdcb2f95b782196faacb0995ca0c0
Author: David Chinner <dgc@sgi.com>
Date:   Thu Apr 10 12:22:17 2008 +1000

    [XFS] Ensure errors from xfs_bdstrat() are correctly checked.
    
    xfsbdstrat() is declared to return an error. That is never checked because
    the error is propagated by the xfs_buf_t that is passed through the
    function.
    
    Mark xfsbdstrat() as returning void and comment the prototype on the
    methods needed for error checking.
    
    SGI-PV: 980084
    SGI-Modid: xfs-linux-melb:xfs-kern:30823a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Niv Sardi <xaiki@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 556b8b166c9514b5f940047a41dad8fe8cd9a778
Author: Barry Naujok <bnaujok@sgi.com>
Date:   Thu Apr 10 12:22:07 2008 +1000

    [XFS] remove bhv_vname_t and xfs_rename code
    
    SGI-PV: 976035
    SGI-Modid: xfs-linux-melb:xfs-kern:30804a
    
    Signed-off-by: Barry Naujok <bnaujok@sgi.com>
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 7c9ef85c5672ae316aafd7bbe0bbadebe90301e6
Author: David Chinner <dgc@sgi.com>
Date:   Thu Apr 10 12:21:59 2008 +1000

    [XFS] Catch errors returned from xfs_bmap_last_offset().
    
    xfs_bmap_last_offset() can fail and return an error.
    xfs_iomap_write_allocate() fails to detect and propagate the error.
    
    SGI-PV: 980084
    SGI-Modid: xfs-linux-melb:xfs-kern:30802a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Niv Sardi <xaiki@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit fc6149d8d9634814cdcd9283b8f2efd3359181df
Author: David Chinner <dgc@sgi.com>
Date:   Thu Apr 10 12:21:53 2008 +1000

    [XFS] Check for xfs_free_extent() failing.
    
    xfs_free_extent() can fail, but log recovery never bothers to check if it
    successfully free the extent it was supposed to. This could lead to silent
    corruption during log recovery. Abort log recovery if we fail to free an
    extent.
    
    SGI-PV: 980084
    SGI-Modid: xfs-linux-melb:xfs-kern:30801a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Niv Sardi <xaiki@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit d87dd6360dce86cad9099aed74f14b4dd0143301
Author: David Chinner <dgc@sgi.com>
Date:   Thu Apr 10 12:21:46 2008 +1000

    [XFS] Warn if errors come from block_truncate_page().
    
    block_truncate_page() can return errors that we currently ignore and
    silently discard. We should not ever get errors reported here - an error
    indicates a bug somewhere else. Hence catch the error and issue a stack
    dump to the syslog because we cannot propagate the error any further up
    the call chain.
    
    SGI-PV: 980084
    SGI-Modid: xfs-linux-melb:xfs-kern:30800a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Niv Sardi <xaiki@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit c2b1cba6833da77b1b478ac144f9cf5144d276ec
Author: David Chinner <dgc@sgi.com>
Date:   Thu Apr 10 12:21:40 2008 +1000

    [XFS] xfs_bmap_adjacent() never returns an error.
    
    Mark it void.
    
    SGI-PV: 980084
    SGI-Modid: xfs-linux-melb:xfs-kern:30798a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Niv Sardi <xaiki@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 12375c82375ec39ec948a3ad62e5e77533515e83
Author: David Chinner <dgc@sgi.com>
Date:   Thu Apr 10 12:21:32 2008 +1000

    [XFS] Make xfs_alloc_compute_aligned() void.
    
    xfs_alloc_compute_aligned() returns a value based on a comparison of the
    computed extent length and the minimum length allowed. This is only used
    by some callers - the other four return parameters are used more often.
    Hence move the comparison to the code that actually needs to do it and
    make xfs_alloc_compute_aligned() a void function.
    
    SGI-PV: 980084
    SGI-Modid: xfs-linux-melb:xfs-kern:30797a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Niv Sardi <xaiki@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit f4586e40613a9f8bb9f7f9c8a796062a9ab1614c
Author: David Chinner <dgc@sgi.com>
Date:   Thu Apr 10 12:21:25 2008 +1000

    [XFS] Clean up xfs_alloc_search_busy() return values.
    
    xfs_alloc_search_busy() returns an index into the busy array if the extent
    was found in the array. This is never checked, and the
    xfs_alloc_search_busy() does a log force to prevent reuse of the extent
    before the free transaction hits the disk. Hence the return value is
    useless. Declare the function void and remove the slot number from the
    tracing as well.
    
    SGI-PV: 980084
    SGI-Modid: xfs-linux-melb:xfs-kern:30796a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Niv Sardi <xaiki@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit e5720eec0548c08943d759e39db0388d8fe59287
Author: David Chinner <dgc@sgi.com>
Date:   Thu Apr 10 12:21:18 2008 +1000

    [XFS] Propagate errors from xfs_trans_commit().
    
    xfs_trans_commit() can return errors when there are problems in the
    transaction subsystem. They are indicative that the entire transaction may
    be incomplete, and hence the error should be propagated as there is a good
    possibility that there is something fatally wrong in the filesystem. Catch
    and propagate or warn about commit errors in the places where they are
    currently ignored.
    
    SGI-PV: 980084
    SGI-Modid: xfs-linux-melb:xfs-kern:30795a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Niv Sardi <xaiki@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 3c1e2bbe5bcdcd435510a05eb121fa74b848e24f
Author: David Chinner <dgc@sgi.com>
Date:   Thu Apr 10 12:21:11 2008 +1000

    [XFS] Propagate xfs_trans_reserve() errors.
    
    xfs_trans_reserve() reports errors that should not be ignored. For
    example, a shutdown filesystem will report errors through
    xfs_trans_reserve() to prevent further changes from being attempted on a
    damaged filesystem. Catch and propagate all error conditions from
    xfs_trans_reserve().
    
    SGI-PV: 980084
    SGI-Modid: xfs-linux-melb:xfs-kern:30794a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Niv Sardi <xaiki@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 5ca1f261a08d5cff5f29eaa0887b59baae2ae7f7
Author: David Chinner <dgc@sgi.com>
Date:   Thu Apr 10 12:21:04 2008 +1000

    [XFS] Catch errors from xfs_acl_vremove().
    
    Removing an ACL can return an error. Propagate it.
    
    SGI-PV: 980084
    SGI-Modid: xfs-linux-melb:xfs-kern:30793a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Niv Sardi <xaiki@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 0c928299676c8df2b00e75d5691cd4846e6c0868
Author: David Chinner <dgc@sgi.com>
Date:   Thu Apr 10 12:20:58 2008 +1000

    [XFS] Catch errors from xfs_acl_setmode().
    
    Propagate the error status from xfs_acl_setmode() so that callers know if
    the ACl was set correctly or not.
    
    SGI-PV: 980084
    SGI-Modid: xfs-linux-melb:xfs-kern:30792a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Niv Sardi <xaiki@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 88ab02085363b7c45935d66ab3e969b4fec9a20c
Author: David Chinner <dgc@sgi.com>
Date:   Thu Apr 10 12:20:51 2008 +1000

    [XFS] Propagate quota file truncation errors.
    
    Truncating the quota files can silently fail. Ensure that truncation
    errors are propagated to the callers.
    
    SGI-PV: 980084
    SGI-Modid: xfs-linux-melb:xfs-kern:30791a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Niv Sardi <xaiki@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit cb6edc26c386d2268dcf61bcdec02b6fb50b6ba2
Author: David Chinner <dgc@sgi.com>
Date:   Thu Apr 10 12:20:45 2008 +1000

    [XFS] Catch errors when turning off quotas.
    
    When turning off quota, we need to write various transactions to the log
    to ensure that they are cleanly removed in the case of a crash. We need to
    check that the transactions hit the disk correctly. If we fail to write
    the final quota off transaction, we are corrupt in memory and so the only
    option is to shut the filesystem down at this point.
    
    SGI-PV: 980084
    SGI-Modid: xfs-linux-melb:xfs-kern:30790a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Niv Sardi <xaiki@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 31d5577b35d8397dea19f2ba7550e9225605a785
Author: David Chinner <dgc@sgi.com>
Date:   Thu Apr 10 12:20:38 2008 +1000

    [XFS] Catch errors resetting quota flags.
    
    Warn to the syslog if we fail to reset the quota flags in the superblock
    when a quota check fails.
    
    SGI-PV: 980084
    SGI-Modid: xfs-linux-melb:xfs-kern:30789a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Niv Sardi <xaiki@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 53aa7915d67b9d0f5986c9f08e76846fedc520d4
Author: David Chinner <dgc@sgi.com>
Date:   Thu Apr 10 12:20:31 2008 +1000

    [XFS] Clean up quotamount error handling.
    
    xfs_qm_mount_quotas() returns an error status that is ignored. If we fail
    to mount quotas, we continue with quota's turned off, which is all handled
    inside xfs_qm_mount_quotas(). Mark it as void to indicate that errors need
    not be returned to the callers.
    
    SGI-PV: 980084
    SGI-Modid: xfs-linux-melb:xfs-kern:30788a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Niv Sardi <xaiki@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 3c56836f92683cb871ebbf44c512069b0d48a08f
Author: David Chinner <dgc@sgi.com>
Date:   Thu Apr 10 12:20:24 2008 +1000

    [XFS] Check for dquot flush errors
    
    xfs_qm_dqflush() can fail, but the return is not checked anywhere. Hence
    we never know if we've failed to flush a dquot to disk. Propagate the
    error and warn to the syslog if a flush ever fails.
    
    SGI-PV: 980084
    SGI-Modid: xfs-linux-melb:xfs-kern:30787a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Niv Sardi <xaiki@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 4b8879df8c21bed3efd1eb2da5d72501199aba29
Author: David Chinner <dgc@sgi.com>
Date:   Thu Apr 10 12:20:17 2008 +1000

    [XFS] Propagate xfs_qm_dqflush_all() errors.
    
    xfs_qm_dqflush_all() can return flush errors. Ensure they are propagated
    into the quotacheck code to determine if the quotacheck succeeded or not.
    
    SGI-PV: 980084
    SGI-Modid: xfs-linux-melb:xfs-kern:30786a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Niv Sardi <xaiki@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 5b1397385bf536cbdb60f3362f44079d15d5f5ee
Author: David Chinner <dgc@sgi.com>
Date:   Thu Apr 10 12:20:10 2008 +1000

    [XFS] xfs_qm_reset_dqcounts() does not return errors.
    
    Declare it void.
    
    SGI-PV: 980084
    SGI-Modid: xfs-linux-melb:xfs-kern:30785a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Niv Sardi <xaiki@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 714082bc12b6c305f825411df02177efcb0085f1
Author: David Chinner <dgc@sgi.com>
Date:   Thu Apr 10 12:20:03 2008 +1000

    [XFS] Report errors from xfs_reserve_blocks().
    
    xfs_reserve_blocks() can fail in interesting ways. In neither case is it a
    fatal error, but the result can lead to sub-optimal behaviour. Warn to the
    syslog if the call fails but otherwise continue.
    
    SGI-PV: 980084
    SGI-Modid: xfs-linux-melb:xfs-kern:30784a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Niv Sardi <xaiki@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 36fbe6e6bd5408b09341043dfece978b4a7a0f34
Author: David Chinner <dgc@sgi.com>
Date:   Thu Apr 10 12:19:56 2008 +1000

    [XFS] xfs_icsb_counter_disabled() never returns an error.
    
    Mark it void.
    
    SGI-PV: 980084
    SGI-Modid: xfs-linux-melb:xfs-kern:30782a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Niv Sardi <xaiki@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit a414047fc97aea7db6237176ce00013117839cd5
Author: David Chinner <dgc@sgi.com>
Date:   Thu Apr 10 12:19:47 2008 +1000

    [XFS] Remove useless whitespace in function prototypes
    
    Makes it simpler to annotate function prototypes with __must_check via sed
    scripts.
    
    SGI-PV: 980084
    SGI-Modid: xfs-linux-melb:xfs-kern:30781a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Niv Sardi <xaiki@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 3c85c36cc2e87018d38fcd033f41bbdf1360c07a
Author: David Chinner <dgc@sgi.com>
Date:   Thu Apr 10 12:19:40 2008 +1000

    [XFS] xfs_quiesce_fs() never returns an error. Mark it void.
    
    SGI-PV: 980084
    SGI-Modid: xfs-linux-melb:xfs-kern:30780a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Niv Sardi <xaiki@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit b6ddc4e6fed9c6f4adb273c8b36e1731f90ec17e
Author: Christoph Hellwig <hch@infradead.org>
Date:   Thu Apr 10 12:19:27 2008 +1000

    [XFS] Don't validate symlink target component length
    
    This target component validation is not POSIX conformant and it is not
    done by any other Linux filesystem so remove it from XFS.
    
    SGI-PV: 980080
    SGI-Modid: xfs-linux-melb:xfs-kern:30776a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 34a622b2e1c8e11c8990184634f101c1aad42fec
Author: Harvey Harrison <harvey.harrison@gmail.com>
Date:   Thu Apr 10 12:19:21 2008 +1000

    [XFS] replace remaining __FUNCTION__ occurrences
    
    __FUNCTION__ is gcc-specific, use __func__
    
    SGI-PV: 976035
    SGI-Modid: xfs-linux-melb:xfs-kern:30775a
    
    Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 0225da1f35df46c67785eb08526995d7cdb4e3b0
Author: Harvey Harrison <harvey.harrison@gmail.com>
Date:   Thu Apr 10 12:19:10 2008 +1000

    [XFS] Replace __inline with inline
    
    Remove the remaining uses of __inline in the XFS code base.
    
    SGI-PV: 976035
    SGI-Modid: xfs-linux-melb:xfs-kern:30774a
    
    Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 6b1d1a732f886936fe515d911b1a01d9cc50e179
Author: David Chinner <dgc@sgi.com>
Date:   Thu Apr 10 12:19:02 2008 +1000

    [XFS] Fix lock inversion in forced shutdown.
    
    Recent changes to xlog_state_release_iclog() placed the grant_lock inside
    the icloglock. forced unmount of the log does this the opposite way
    around, but does not depend on the order for correct working. Fix the
    inversion by changing the order locks are gained in
    xfs_log_force_umount().
    
    SGI-PV: 979661
    SGI-Modid: xfs-linux-melb:xfs-kern:30773a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 4679b2d36d53ed508c956337972fbbea8db99a77
Author: David Chinner <dgc@sgi.com>
Date:   Thu Apr 10 12:18:54 2008 +1000

    [XFS] Reorganise xlog_t for better cacheline isolation of contention
    
    To reduce contention on the log in large CPU count, separate out different
    parts of the xlog_t structure onto different cachelines. Move each lock
    onto a different cacheline along with all the members that are
    accessed/modified while that lock is held.
    
    Also, move the debugging code into debug code.
    
    SGI-PV: 978729
    SGI-Modid: xfs-linux-melb:xfs-kern:30772a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit eb01c9cd87c7a9998c2edf209721ea069e3e3652
Author: David Chinner <dgc@sgi.com>
Date:   Thu Apr 10 12:18:46 2008 +1000

    [XFS] Remove the xlog_ticket allocator
    
    The ticket allocator is just a simple slab implementation internal to the
    log. It requires the icloglock to be held when manipulating it and this
    contributes to contention on that lock.
    
    Just kill the entire allocator and use a memory zone instead. While there,
    allow us to gracefully fail allocation with ENOMEM.
    
    SGI-PV: 978729
    SGI-Modid: xfs-linux-melb:xfs-kern:30771a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 114d23aae51233b2bc62d8e2a632bcb55de1953d
Author: David Chinner <dgc@sgi.com>
Date:   Thu Apr 10 12:18:39 2008 +1000

    [XFS] Per iclog callback chain lock
    
    Rather than use the icloglock for protecting the iclog completion callback
    chain, use a new per-iclog lock so that walking the callback chain doesn't
    require holding a global lock.
    
    This reduces contention on the icloglock during transaction commit and log
    I/O completion by reducing the number of times we need to hold the global
    icloglock during these operations.
    
    SGI-PV: 978729
    SGI-Modid: xfs-linux-melb:xfs-kern:30770a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 2abdb8c88110bab78bfe17e51346e735560daa02
Author: Lachlan McIlroy <lachlan@sgi.com>
Date:   Thu Mar 27 18:01:14 2008 +1100

    [XFS] Prevent xfs_bmap_check_leaf_extents() referencing unmapped memory.
    
    While investigating the extent corruption bug I ran into this bug in debug
    only code. xfs_bmap_check_leaf_extents() loops through the leaf blocks of
    the extent btree checking that every extent is entirely before the next
    extent. It also compares the last extent in the previous block to the
    first extent in the current block when the previous block has been
    released and potentially unmapped. So take a copy of the last extent
    instead of a pointer. Also move the last extent check out of the loop
    because we only need to do it once.
    
    SGI-PV: 976035
    SGI-Modid: xfs-linux-melb:xfs-kern:30718a
    
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
    Signed-off-by: Christoph Hellwig <hch@infradead.org>

commit 433550990e6c2e94995239bac6a52b4df454cae0
Author: Christoph Hellwig <hch@infradead.org>
Date:   Thu Mar 27 18:01:08 2008 +1100

    [XFS] remove most calls to VN_RELE
    
    Most VN_RELE calls either directly contain a XFS_ITOV or have the
    corresponding xfs_inode already in scope. Use the IRELE helper instead of
    VN_RELE to clarify the code. With a little more work we can kill VN_RELE
    altogether and define IRELE in terms of iput directly.
    
    SGI-PV: 976035
    SGI-Modid: xfs-linux-melb:xfs-kern:30710a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit df26cfe849d8fd767b26fcd4bfebfff67bda9f3a
Author: Lachlan McIlroy <lachlan@redback.melbourne.sgi.com>
Date:   Fri Apr 18 11:44:03 2008 +1000

    [XFS] split xfs_ioc_xattr
    
    The three subcases of xfs_ioc_xattr don't share any semantics and almost
    no code, so split it into three separate helpers.
    
    SGI-PV: 976035
    SGI-Modid: xfs-linux-melb:xfs-kern:30709a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit f3dcc13f6fa20af1171eac7a537a4b89b1a84849
Author: Christoph Hellwig <hch@infradead.org>
Date:   Thu Mar 27 18:00:54 2008 +1100

    [XFS] cleanup root inode handling in xfs_fs_fill_super
    
    - rename rootvp to root for clarify
    - remove useless vn_to_inode call
    - check is_bad_inode before calling d_alloc_root
    - use iput instead of VN_RELE in the error case
    
    SGI-PV: 976035
    SGI-Modid: xfs-linux-melb:xfs-kern:30708a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 59a33f9f776b051018ec98af95bd9fe8ba9d0f3e
Author: David Chinner <dgc@sgi.com>
Date:   Thu Mar 27 18:00:45 2008 +1100

    [XFS] Ensure a btree insert returns a valid cursor.
    
    When writing into preallocated regions there is a case where XFS can oops
    or hang doing the unwritten extent conversion on I/O completion. It turns
    out that the problem is related to the btree cursor being invalid.
    
    When we do an insert into the tree, we may need to split blocks in the
    tree. When we only split at the leaf level (i.e. level 0), everything
    works just fine. However, if we have a multi-level split in the btreee,
    the cursor passed to the insert function is no longer valid once the
    insert is complete.
    
    The leaf level split is handled correctly because all the operations at
    level 0 are done using the original cursor, hence it is updated correctly.
    However, when we need to update the next level up the tree, we don't use
    that cursor - we use a cloned cursor that points to the index in the next
    level up where we need to do the insert.
    
    Hence if we need to split a second level, the changes to the tree are
    reflected in the cloned cursor and not the original cursor. This
    clone-and-move-up-a-level-on-split behaviour recurses all the way to the
    top of the tree.
    
    The complexity here is that these cloned cursors do not point to the
    original index that was inserted - they point to the newly allocated block
    (the right block) and the original cursor pointer to that level may still
    point to the left block. Hence, without deep examination of the cloned
    cursor and buffers, we cannot update the original cursor with the new path
    from the cloned cursor.
    
    In these cases the original cursor could be pointing to the wrong block(s)
    and hence a subsequent modification to the tree using that cursor will
    lead to corruption of the tree.
    
    The crash case occurs when the tree changes height - we insert a new level
    in the tree, and the cursor does not have a buffer in it's path for that
    level. Hence any attempt to walk back up the cursor to the root block will
    result in a null pointer dereference.
    
    To make matters even more complex, the BMAP BT is rooted in an inode, so
    we can have a change of height in the btree *without a root split*. That
    is, if the root block in the inode is full when we split a leaf node, we
    cannot fit the pointer to the new block in the root, so we allocate a new
    block, migrate all the ptrs out of the inode into the new block and point
    the inode root block at the newly allocated block. This changes the height
    of the tree without a root split having occurred and hence invalidates the
    path in the original cursor.
    
    The patch below prevents xfs_bmbt_insert() from returning with an invalid
    cursor by detecting the cases that invalidate the original cursor and
    refresh it by do a lookup into the btree for the original index we were
    inserting at.
    
    Note that the INOBT, AGFBNO and AGFCNT btree implementations also have
    this bug, but the cursor is currently always destroyed or revalidated
    after an insert for those trees. Hence this patch only address the problem
    in the BMBT code.
    
    SGI-PV: 979339
    SGI-Modid: xfs-linux-melb:xfs-kern:30701a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 75de2a91c98a6f486f261c1367fe59f5583e15a3
Author: David Chinner <dgc@sgi.com>
Date:   Thu Mar 27 18:00:38 2008 +1100

    [XFS] Account for inode cluster alignment in all allocations
    
    At ENOSPC, we can get a filesystem shutdown due to a cancelling a dirty
    transaction in xfs_mkdir or xfs_create. This is due to the initial
    allocation attempt not taking into account inode alignment and hence we
    can prepare the AGF freelist for allocation when it's not actually
    possible to do an allocation. This results in inode allocation returning
    ENOSPC with a dirty transaction, and hence we shut down the filesystem.
    
    Because the first allocation is an exact allocation attempt, we must tell
    the allocator that the alignment does not affect the allocation attempt.
    i.e. we will accept any extent alignment as long as the extent starts at
    the block we want. Unfortunately, this means that if the longest free
    extent is less than the length + alignment necessary for fallback
    allocation attempts but is long enough to attempt a non-aligned
    allocation, we will modify the free list.
    
    If we then have the exact allocation fail, all other allocation attempts
    will also fail due to the alignment constraint being taken into account.
    Hence the initial attempt needs to set the "alignment slop" field so that
    alignment, while not required, must be taken into account when determining
    if there is enough space left in the AG to do the allocation.
    
    That means if the exact allocation fails, we will not dirty the freelist
    if there is not enough space available fo a subsequent allocation to
    succeed. Hence we get an ENOSPC error back to userspace without shutting
    down the filesystem.
    
    SGI-PV: 978886
    SGI-Modid: xfs-linux-melb:xfs-kern:30699a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 535f6b3735db6ef6026537bfe55ae00c3d9cc1ee
Author: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
Date:   Thu Mar 27 17:58:27 2008 +1100

    [XFS] Replace custom AIL linked-list code with struct list_head
    
    Replace the xfs_ail_entry_t with a struct list_head and clean the
    surrounding code up. Also fixes a livelock in xfs_trans_first_push_ail()
    by terminating the loop at the head of the list correctly.
    
    SGI-PV: 978682
    SGI-Modid: xfs-linux-melb:xfs-kern:30636a
    
    Signed-off-by: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit a45c796867df8dabc8eed6e72898d7ba1609bd7e
Author: Christoph Hellwig <hch@infradead.org>
Date:   Thu Mar 6 13:49:36 2008 +1100

    [XFS] Remove superflous xfs_readsb call in xfs_mountfs.
    
    When xfs_mountfs is called by xfs_mount xfs_readsb was called 35 lines
    above unconditionally, so there is no need to try to read the superblock
    if it's not present. If any other port doesn't have the superblock read at
    this point it should just call it directly from it's xfs_mount equivalent.
    
    SGI-PV: 976035
    SGI-Modid: xfs-linux-melb:xfs-kern:30603a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Donald Douwsma <donaldd@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit dfa18b117974d7667a2d5b941853fac3f2e256db
Author: Niv Sardi <xaiki@sgi.com>
Date:   Thu Mar 6 13:49:26 2008 +1100

    [XFS] kill t_sema member of struct xfs_trans
    
    It's completely unused so we might aswell kill it. Note that there is
    another t_sema in struct xlog_ticket, which is used and actually an sv_t
    despite the name. That one is left untouched by this patch.
    
    SGI-PV: 971186
    SGI-Modid: xfs-linux-melb:xfs-kern:30591a
    
    Signed-off-by: Niv Sardi <xaiki@sgi.com>
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 5f90150abad61b49dbb4a6ca1087fe0a75001ef9
Author: Christoph Hellwig <hch@infradead.org>
Date:   Thu Mar 6 13:46:49 2008 +1100

    [XFS] cleanup vnode use in xfs_bmap.c
    
    SGI-PV: 976035
    SGI-Modid: xfs-linux-melb:xfs-kern:30553a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit af048193fcfe2650e7ed3b1ab3d48b1ed0efb467
Author: Christoph Hellwig <hch@infradead.org>
Date:   Thu Mar 6 13:46:43 2008 +1100

    [XFS] cleanup vnode use in xfs_iops.c
    
    SGI-PV: 976035
    SGI-Modid: xfs-linux-melb:xfs-kern:30552a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit dcf49cc5cfbbc0070ad4307428f8282dc7e04e58
Author: Christoph Hellwig <hch@infradead.org>
Date:   Thu Mar 6 13:46:37 2008 +1100

    [XFS] cleanup vnode use in xfs_lrw.c
    
    SGI-PV: 976035
    SGI-Modid: xfs-linux-melb:xfs-kern:30551a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit ef1f5e7ad38e5414d016983a8cc5a8db7654a61d
Author: Christoph Hellwig <hch@infradead.org>
Date:   Thu Mar 6 13:46:25 2008 +1100

    [XFS] cleanup vnode use in xfs_lookup
    
    SGI-PV: 976035
    SGI-Modid: xfs-linux-melb:xfs-kern:30550a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 3937be5ba836a204d3d1df96b518eecd6cdacbb9
Author: Christoph Hellwig <hch@infradead.org>
Date:   Thu Mar 6 13:46:19 2008 +1100

    [XFS] cleanup vnode use in xfs_symlink and xfs_rename
    
    SGI-PV: 976035
    SGI-Modid: xfs-linux-melb:xfs-kern:30548a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit a3da789640871c897901c5f766e33be78d56f35a
Author: Christoph Hellwig <hch@infradead.org>
Date:   Thu Mar 6 13:46:12 2008 +1100

    [XFS] cleanup vnode use in xfs_link
    
    SGI-PV: 976035
    SGI-Modid: xfs-linux-melb:xfs-kern:30547a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 979ebab11623894528d4d37b947533ea4e8649d1
Author: Christoph Hellwig <hch@infradead.org>
Date:   Thu Mar 6 13:46:05 2008 +1100

    [XFS] cleanup vnode use in xfs_create/mknod/mkdir
    
    SGI-PV: 976035
    SGI-Modid: xfs-linux-melb:xfs-kern:30546a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit bc4ac74a4e5bd7db02976eb1b681e1d11f81c9ce
Author: Christoph Hellwig <hch@infradead.org>
Date:   Thu Mar 6 13:45:58 2008 +1100

    [XFS] cleanup vnode use in dmapi calls
    
    SGI-PV: 976035
    SGI-Modid: xfs-linux-melb:xfs-kern:30545a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit d234154125197053d5215711b5df867979e55ebd
Author: David Chinner <dgc@sgi.com>
Date:   Thu Mar 6 13:45:43 2008 +1100

    [XFS] Use power-of-2 sized buffers to reduce overhead
    
    Now that the ktrace_enter() code is using atomics, the non-power-of-2
    buffer sizes - which require modulus operations to get the index - are
    showing up as using substantial CPU in the profiles.
    
    Force the buffer sizes to be rounded up to the nearest power of two and
    use masking rather than modulus operations to convert the index counter to
    the buffer index. This reduces ktrace_enter overhead to 8% of a CPU time,
    and again almost halves the trace intensive test runtime.
    
    SGI-PV: 977546
    SGI-Modid: xfs-linux-melb:xfs-kern:30538a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 6ee4752ffe782be6e86bea1403a2fe0f682aa71a
Author: David Chinner <dgc@sgi.com>
Date:   Thu Mar 6 13:45:35 2008 +1100

    [XFS] Use atomic counters for ktrace buffer indexes
    
    ktrace_enter() is consuming vast amounts of CPU time due to the use of a
    single global lock for protecting buffer index increments. Change it to
    use per-buffer atomic counters - this reduces ktrace_enter() overhead
    during a trace intensive test on a 4p machine from 58% of all CPU time to
    12% and halves test runtime.
    
    SGI-PV: 977546
    SGI-Modid: xfs-linux-melb:xfs-kern:30537a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 44d814ced4cffbfe6a775c5bb8b941a6e734e7d9
Author: David Chinner <dgc@sgi.com>
Date:   Thu Mar 6 13:45:29 2008 +1100

    [XFS] Update c/mtime correctly on truncates
    
    XFS changes the c/mtime of an inode when truncating it to the same size.
    The c/mtime is only supposed to change if the size is changed. Not to be
    confused with ftruncate, where the c/mtime is supposed to be changed even
    if the size is not changed.
    
    The Linux VFS encodes this semantic difference in the flags it sends down
    to ->setattr, which XFS currently ignores. We need to make XFS pay
    attention to the VFS flags and hence Do The Right Thing.
    
    SGI-PV: 977547
    SGI-Modid: xfs-linux-melb:xfs-kern:30536a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 24bd861d1c3fff5248de7ba3bdddb3369087ad46
Author: Christoph Hellwig <hch@infradead.org>
Date:   Thu Mar 6 13:45:16 2008 +1100

    [XFS] don't encode parent in nfs filehandles unless nessecary
    
    As Dave pointed out after the export ops changes we now always encode the
    parent into the filehandle for regular files, but it's not actually needed
    when the filesystem is export with no_subtree_check. This one-liner fixes
    xfs_fs_encode_fh to skip encoding the parent unless nessecary.
    
    SGI-PV: 976035
    SGI-Modid: xfs-linux-melb:xfs-kern:30535a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 126468b1156211e26d97f74b2f1767acd141005a
Author: Christoph Hellwig <hch@infradead.org>
Date:   Thu Mar 6 13:44:57 2008 +1100

    [XFS] kill xfs_rwlock/xfs_rwunlock
    
    We can just use xfs_ilock/xfs_iunlock instead and get rid of the ugly
    bhv_vrwlock_t.
    
    SGI-PV: 976035
    SGI-Modid: xfs-linux-melb:xfs-kern:30533a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 43973964a386348af0a392266f008ba24170aa30
Author: Christoph Hellwig <hch@infradead.org>
Date:   Thu Mar 6 13:44:50 2008 +1100

    [XFS] kill xfs_get_dir_entry
    
    Instead of of xfs_get_dir_entry use a macro to get the xfs_inode from the
    dentry in the callers and grab the reference manually.
    
    Only grab the reference once as it's fine to keep it over the dmapi calls.
    (And even that reference is actually superflous in Linux but I'll leave
    that for another patch)
    
    SGI-PV: 976035
    SGI-Modid: xfs-linux-melb:xfs-kern:30531a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit a8b3acd57e3aaaf73a863a28e0e9f6cca37cd8e3
Author: Christoph Hellwig <hch@infradead.org>
Date:   Thu Mar 6 13:44:41 2008 +1100

    [XFS] vnode cleanup in xfs_fs_subr.c
    
    Cleanup the unneeded intermediate vnode step in the flushing helpers and
    go directly from the xfs_inode to the struct address_space.
    
    SGI-PV: 976035
    SGI-Modid: xfs-linux-melb:xfs-kern:30530a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit db0bb7baa1533db156d8af3ebeda1f0473a0197a
Author: Christoph Hellwig <hch@infradead.org>
Date:   Thu Mar 6 13:44:35 2008 +1100

    [XFS] cleanup xfs_vn_mknod
    
    - use proper goto based unwinding instead of the current mess of
      multiple conditionals
    - rename ip to inode because that's the normal convention for Linux
      inodes while ip is the convention for xfs_inodes
    - remove unlikely checks for the default_acl - branches marked unlikely
      might lead to extreme branch bredictor slowdons if taken and for some
      workloads a default acl is quite common
    - properly indent the switch statements
    - remove xfs_has_fs_struct as nfsd has a fs_struct in any semi-recent
      kernel
    
    SGI-PV: 976035
    SGI-Modid: xfs-linux-melb:xfs-kern:30529a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 155cc6b784a959ed456fe46dca522e1d28b3b718
Author: David Chinner <dgc@sgi.com>
Date:   Thu Mar 6 13:44:14 2008 +1100

    [XFS] Use atomics for iclog reference counting
    
    Now that we update the log tail LSN less frequently on transaction
    completion, we pass the contention straight to the global log state lock
    (l_iclog_lock) during transaction completion.
    
    We currently have to take this lock to decrement the iclog reference
    count. there is a reference count on each iclog, so we need to take þhe
    global lock for all refcount changes.
    
    When large numbers of processes are all doing small trnasctions, the iclog
    reference counts will be quite high, and the state change that absolutely
    requires the l_iclog_lock is the except rather than the norm.
    
    Change the reference counting on the iclogs to use atomic_inc/dec so that
    we can use atomic_dec_and_lock during transaction completion and avoid the
    need for grabbing the l_iclog_lock for every reference count decrement
    except the one that matters - the last.
    
    SGI-PV: 975671
    SGI-Modid: xfs-linux-melb:xfs-kern:30505a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit b589334c7a1fff85d2f009d5db4c34fad48925e9
Author: David Chinner <dgc@sgi.com>
Date:   Thu Mar 6 13:44:06 2008 +1100

    [XFS] Prevent AIL lock contention during transaction completion
    
    When hundreds of processors attempt to commit transactions at the same
    time, they can contend on the AIL lock when updating the tail LSN held in
    the in-core log structure.
    
    At the moment, the tail LSN is only needed when actually writing out an
    iclog, so it really does not need to be updated on every single
    transaction completion - only those that result in switching iclogs and
    flushing them to disk.
    
    The result is that we reduce the number of times we need to grab the AIL
    lock and the log grant lock by up to two orders of magnitude on large
    processor count machines. The problem has previously been hidden by AIL
    lock contention walking the AIL list which was recently solved and
    uncovered this issue.
    
    SGI-PV: 975671
    SGI-Modid: xfs-linux-melb:xfs-kern:30504a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 3354040897f828644be6ca5783588e9f64a53b8e
Author: David Chinner <dgc@sgi.com>
Date:   Thu Mar 6 13:43:59 2008 +1100

    [XFS] Use xfs_inode_clean() in more places
    
    Remove open coded checks for the whether the inode is clean and replace
    them with an inlined function.
    
    SGI-PV: 977461
    SGI-Modid: xfs-linux-melb:xfs-kern:30503a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit bad5584332e888ac40ca13584e8c114149ddb01e
Author: David Chinner <dgc@sgi.com>
Date:   Thu Mar 6 13:43:49 2008 +1100

    [XFS] Remove the xfs_icluster structure
    
    Remove the xfs_icluster structure and replace with a radix tree lookup.
    
    We don't need to keep a list of inodes in each cluster around anymore as
    we can look them up quickly when we need to. The only time we need to do
    this now is during inode writeback.
    
    Factor the inode cluster writeback code out of xfs_iflush and convert it
    to use radix_tree_gang_lookup() instead of walking a list of inodes built
    when we first read in the inodes.
    
    This remove 3 pointers from each xfs_inode structure and the xfs_icluster
    structure per inode cluster. Hence we reduce the cache footprint of the
    xfs_inodes by between 5-10% depending on cluster sparseness.
    
    To be truly efficient we need a radix_tree_gang_lookup_range() call to
    stop searching once we are past the end of the cluster instead of trying
    to find a full cluster's worth of inodes.
    
    Before (ia64):
    
    $ cat /sys/slab/xfs_inode/object_size 536
    
    After:
    
    $ cat /sys/slab/xfs_inode/object_size 512
    
    SGI-PV: 977460
    SGI-Modid: xfs-linux-melb:xfs-kern:30502a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit a3f74ffb6d1448d9a8f482e593b80ec15f1695d4
Author: David Chinner <dgc@sgi.com>
Date:   Thu Mar 6 13:43:42 2008 +1100

    [XFS] Don't block pdflush when writing back inodes
    
    When pdflush is writing back inodes, it can get stuck on inode cluster
    buffers that are currently under I/O. This occurs when we write data to
    multiple inodes in the same inode cluster at the same time.
    
    Effectively, delayed allocation marks the inode dirty during the data
    writeback. Hence if the inode cluster was flushed during the writeback of
    the first inode, the writeback of the second inode will block waiting for
    the inode cluster write to complete before writing it again for the newly
    dirtied inode.
    
    Basically, we want to avoid this from happening so we don't block pdflush
    and slow down all of writeback. Hence we introduce a non-blocking async
    inode flush flag that pdflush uses. If this flag is set, we use
    non-blocking operations (e.g. try locks) whereever we can to avoid
    blocking or extra I/O being issued.
    
    SGI-PV: 970925
    SGI-Modid: xfs-linux-melb:xfs-kern:30501a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 4ae29b4321b99b711bcfde5527c4fbf249eac60f
Author: David Chinner <dgc@sgi.com>
Date:   Thu Mar 6 13:43:34 2008 +1100

    [XFS] Factor xfs_itobp() and xfs_inotobp().
    
    The only difference between the functions is one passes an inode for the
    lookup, the other passes an inode number. However, they don't do the same
    validity checking or set all the same state on the buffer that is returned
    yet they should.
    
    Factor the functions into a common implementation.
    
    SGI-PV: 970925
    SGI-Modid: xfs-linux-melb:xfs-kern:30500a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit e9a56b7cdaf6129892fd7c8d950b71a1a4304bb0
Author: Lachlan McIlroy <lachlan@sgi.com>
Date:   Thu Mar 6 13:43:27 2008 +1100

    [XFS] Fix regression due to refcache removal
    
    SGI-PV: 971186
    SGI-Modid: xfs-linux-melb:xfs-kern:30490a
    
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
    Signed-off-by: Donald Douwsma <donaldd@sgi.com>

commit 163d3686bb09d88e2120bffe780a3f2d7cc4c948
Author: Donald Douwsma <donaldd@sgi.com>
Date:   Thu Mar 6 13:43:20 2008 +1100

    [XFS] Remove the xfs_refcache
    
    Remove the xfs_refcache, it was only needed while we were still
    building for 2.4 kernels.
    
    SGI-PV: 971186
    SGI-Modid: xfs-linux-melb:xfs-kern:30472a
    
    Signed-off-by: Donald Douwsma <donaldd@sgi.com>
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 461aa8a22595e3bd3e6f4dc2894d7c4315ea2bb9
Author: Lachlan McIlroy <lachlan@sgi.com>
Date:   Thu Mar 6 13:43:11 2008 +1100

    [XFS] make inode reclaim synchronise with xfs_iflush_done()
    
    On a forced shutdown, xfs_finish_reclaim() will skip flushing the inode.
    If the inode flush lock is not already held and there is an outstanding
    xfs_iflush_done() then we might free the inode prematurely. By acquiring
    and releasing the flush lock we will synchronise with xfs_iflush_done().
    
    SGI-PV: 909874
    SGI-Modid: xfs-linux-melb:xfs-kern:30468a
    
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
    Signed-off-by: David Chinner <dgc@sgi.com>

commit e12070a5dca8bfeee352e9655ae79772a96b32f8
Author: Niv Sardi <xaiki@sgi.com>
Date:   Thu Mar 6 13:43:03 2008 +1100

    [XFS] actually check error returned by xfs_flush_pages, clean up and
    bailout if fails.
    
    SGI-PV: 973041
    SGI-Modid: xfs-linux-melb:xfs-kern:30462a
    
    Signed-off-by: Niv Sardi <xaiki@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
