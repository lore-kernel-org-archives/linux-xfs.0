Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 29 Apr 2008 01:20:20 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3T8JtEc007175
	for <xfs@oss.sgi.com>; Tue, 29 Apr 2008 01:19:59 -0700
Date: Tue, 29 Apr 2008 18:20:31 +1000
Subject: [GIT PULL] XFS update for 2.6.26-rc1
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080429082031.A323B58C4C15@chook.melbourne.sgi.com>
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org

Please pull from the for-linus branch:
    git pull git://oss.sgi.com:8090/xfs/xfs-2.6.git for-linus

This will update the following files:

 fs/xfs/Kconfig                 |   13 ++
 fs/xfs/linux-2.6/mrlock.h      |   60 ++++------
 fs/xfs/linux-2.6/xfs_buf.c     |    2 +-
 fs/xfs/linux-2.6/xfs_export.c  |    2 +-
 fs/xfs/linux-2.6/xfs_file.c    |   75 -----------
 fs/xfs/linux-2.6/xfs_ioctl.c   |    8 +-
 fs/xfs/linux-2.6/xfs_iops.c    |    3 +-
 fs/xfs/linux-2.6/xfs_linux.h   |    1 -
 fs/xfs/linux-2.6/xfs_lrw.c     |   21 ++--
 fs/xfs/linux-2.6/xfs_lrw.h     |    1 -
 fs/xfs/linux-2.6/xfs_super.c   |    2 +-
 fs/xfs/linux-2.6/xfs_vnode.h   |   24 ----
 fs/xfs/quota/xfs_dquot.c       |    4 +-
 fs/xfs/quota/xfs_qm.c          |   27 ++---
 fs/xfs/quota/xfs_qm_syscalls.c |    6 -
 fs/xfs/quota/xfs_quota_priv.h  |    5 -
 fs/xfs/quota/xfs_trans_dquot.c |    2 +-
 fs/xfs/xfs.h                   |    2 +-
 fs/xfs/xfs_acl.c               |   53 ++------
 fs/xfs/xfs_attr.c              |   93 ++++++++------
 fs/xfs/xfs_attr.h              |    6 +-
 fs/xfs/xfs_bmap.c              |    1 -
 fs/xfs/xfs_dfrag.c             |    4 +-
 fs/xfs/xfs_fsops.c             |    8 +-
 fs/xfs/xfs_ialloc.c            |   10 ++
 fs/xfs/xfs_iget.c              |  140 +++++++++++----------
 fs/xfs/xfs_inode.c             |   25 ++--
 fs/xfs/xfs_inode.h             |   16 +--
 fs/xfs/xfs_inode_item.c        |   12 +-
 fs/xfs/xfs_iomap.c             |   19 ++--
 fs/xfs/xfs_itable.c            |    6 -
 fs/xfs/xfs_mount.c             |   83 ++++++-------
 fs/xfs/xfs_mount.h             |    7 +-
 fs/xfs/xfs_rename.c            |  252 ++++++++-----------------------------
 fs/xfs/xfs_trans_inode.c       |   12 +-
 fs/xfs/xfs_utils.c             |   45 +-------
 fs/xfs/xfs_utils.h             |    2 -
 fs/xfs/xfs_vfsops.c            |    1 +
 fs/xfs/xfs_vnodeops.c          |  274 +++++-----------------------------------
 fs/xfs/xfs_vnodeops.h          |    8 +-
 40 files changed, 396 insertions(+), 939 deletions(-)

through these commits:

commit adaa693b845373296631766176ebf0f73a342e10
Author: Stephen Rothwell <sfr@canb.auug.org.au>
Date:   Tue Apr 22 15:26:13 2008 +1000

    [XFS] Fix build failure after enabling CONFIG_XFS_DEBUG
    
    Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit c5acbaf43da139fe014d78d1f0ca7754fa856ddb
Author: Christoph Hellwig <hch@lst.de>
Date:   Mon Apr 21 18:11:13 2008 +1000

    [XFS] remove dmapi cruft in xfs_file.c
    
    The dmapi cruft in xfs_file.c is totally out of date in mainline vs
    CVS, and at this point just removing this code which can't be used on
    mainline at all seems to be the best option to keep it maintainable.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 3a738a5c73e0617d11b27ac46dd6a1a8f752017b
Author: Christoph Hellwig <hch@lst.de>
Date:   Mon Apr 21 17:25:35 2008 +1000

    [XFS] remove sendfile leftovers
    
    Remove the last sendfile leftovers in mainline.  This code is already
    gone in CVS.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 7788fae6cce616fe2c624273fcfe54cf50f5c38b
Author: Christoph Hellwig <hch@lst.de>
Date:   Mon Apr 21 17:22:27 2008 +1000

    [XFS] allow enabling CONFIG_XFS_DEBUG
    
    Back when I first submitted XFS for mainline inclusion we made the
    decision that the debug code is far to extensive to be accidentally
    enabled by users in mainline.  But then again it's often quite useful
    to track problems down and hacking the makefile all the time is rather
    annoying.  Given all the debug options with even more overhead like
    lockdep or DEBUG_PAGE_ALLOC users (or rather developers) should know
    by now what they're doing.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 359346a9655c8800408ed3ca44517ac7ea95c197
Author: David Chinner <dgc@sgi.com>
Date:   Tue Apr 29 12:53:32 2008 +1000

    [XFS] Don't initialise new inode generation numbers to zero
    
    When we allocation new inode chunks, we initialise the generation numbers
    to zero. This works fine until we delete a chunk and then reallocate it,
    resulting in the same inode numbers but with a reset generation count.
    This can result in inode/generation pairs of different inodes occurring
    relatively close together.
    
    Given that the inode/gen pair makes up the "unique" portion of an NFS
    filehandle on XFS, this can result in file handles cached on clients being
    seen on the wire from the server but refer to a different file. This
    causes .... issues for NFS clients.
    
    Hence we need a unique generation number initialisation for each inode to
    prevent reuse of a small portion of the generation number space. Use a
    random number to initialise the generation number so we don't need to keep
    any new state on disk whilst making the new number difficult to guess from
    previous allocations.
    
    SGI-PV: 979416
    SGI-Modid: xfs-linux-melb:xfs-kern:31001a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 86c4d62305649848164ae311a0959fc569b0d964
Author: David Chinner <dgc@sgi.com>
Date:   Tue Apr 29 12:53:21 2008 +1000

    [XFS] Fix check for block zero access in xfs_write_iomap_allocate()
    
    The check for block zero access should be done on non-realtime inodes. Fix
    the logic error in xfs_write_iomap_allocate(), and simplify the logic on
    all checks for block zero access in xfs_iomap.c
    
    SGI-PV: 980888
    SGI-Modid: xfs-linux-melb:xfs-kern:30998a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit d349404ff14758dc9a2d3df032073ed795085860
Author: David Chinner <dgc@sgi.com>
Date:   Tue Apr 29 12:53:15 2008 +1000

    [XFS] Don't double count reserved block changes on UP.
    
    On uniprocessor machines, the incore superblock is used for all in memory
    accounting of free blocks. in this situation, changes to the reserved
    block count are accounted twice; once directly and once via
    xfs_mod_incore_sb(). Seeing as the modification on SMP is done via
    xfs_mod_incore_sb(), make this the only update mechanism that UP uses as
    well.
    
    SGI-PV: 980654
    SGI-Modid: xfs-linux-melb:xfs-kern:30997a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit fe0754f0e5c0f070bf82b6e7e5e8fa5a188163fc
Author: Alexey Dobriyan <adobriyan@gmail.com>
Date:   Tue Apr 29 12:53:08 2008 +1000

    [XFS] remove xfs_log_ticket_zone on rmmod
    
    Fix bug introduced in commit eb01c9cd87c7a9998c2edf209721ea069e3e3652 aka
    "[XFS] Remove the xlog_ticket allocator"
    
    SGI-PV: 980887
    SGI-Modid: xfs-linux-melb:xfs-kern:30995a
    
    Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 7155054c9d8b5974f6e788b46939b419bd5fb020
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Tue Apr 29 12:53:00 2008 +1000

    [XFS] fix non-smp xfs build
    
    xfs_reserve_blocks() calls xfs_icsb_sync_counters_locked(), which is not
    defined if !CONFIG_SMP/!HAVE_PERCPU_SB
    
    SGI-PV: 976035
    SGI-Modid: xfs-linux-melb:xfs-kern:30991a
    
    Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 18d18208daced52123de9ba0808447058d3442d8
Author: Donald Douwsma <donaldd@sgi.com>
Date:   Tue Apr 22 17:34:56 2008 +1000

    [XFS] Fix broken HAVE_SPLICE removal commit.
    
    Commit e687330b5ed1ea899fdaf0dea50aba196b6e019a was meant to remove the
    unused HAVE_SPLICE macro, instead an unrelated change was checked enabling
    QUOTADEBUG when building DEBUG XFS. Restore the intended changes.
    
    SGI-PV: 971046
    SGI-Modid: xfs-linux-melb:xfs-kern:30924a
    
    Signed-off-by: Donald Douwsma <donaldd@sgi.com>
    Signed-off-by: Barry Naujok <bnaujok@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit ce46193bcaaf3c769718bcec6eae94719b8f53ed
Author: Christoph Hellwig <hch@infradead.org>
Date:   Tue Apr 22 17:34:50 2008 +1000

    [XFS] kill XFS_ICSB_SB_LOCKED
    
    With the last two patches XFS_ICSB_SB_LOCKED is never checked and only
    superflously passed to xfs_icsb_count, so kill it.
    
    SGI-PV: 976035
    SGI-Modid: xfs-linux-melb:xfs-kern:30920a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 45af6c6de6453b385c80555c0ee40ab5fc4a033b
Author: Christoph Hellwig <hch@infradead.org>
Date:   Tue Apr 22 17:34:44 2008 +1000

    [XFS] split xfs_icsb_balance_counter
    
    Add an xfs_icsb_balance_counter_locked for the case where mp->m_sb_lock is
    already locked.
    
    SGI-PV: 976035
    SGI-Modid: xfs-linux-melb:xfs-kern:30918a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit d4d90b577ee5af5c1b29bd693aca026a77a1a2f1
Author: Christoph Hellwig <hch@infradead.org>
Date:   Tue Apr 22 17:34:37 2008 +1000

    [XFS] Add xfs_icsb_sync_counters_locked for when m_sb_lock already held
    
    Add a new xfs_icsb_sync_counters_locked for the case where m_sb_lock
    is already taken and add a flags argument to xfs_icsb_sync_counters so
    that xfs_icsb_sync_counters_flags is not needed.
    
    SGI-PV: 976035
    SGI-Modid: xfs-linux-melb:xfs-kern:30917a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit e8b0ebaa115ac46b21622b103c29927f5805aeaa
Author: Barry Naujok <bnaujok@sgi.com>
Date:   Tue Apr 22 17:34:31 2008 +1000

    [XFS] Cleanup xfs_attr a bit with xfs_name and remove cred
    
    SGI-PV: 976035
    SGI-Modid: xfs-linux-melb:xfs-kern:30913a
    
    Signed-off-by: Barry Naujok <bnaujok@sgi.com>
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 5df78e73d328e870a1cd8a9e0f39bf094e42ce9d
Author: Christoph Hellwig <hch@infradead.org>
Date:   Tue Apr 22 17:34:24 2008 +1000

    [XFS] kill usesless IHOLD calls in xfs_remove and xfs_rmdir
    
    The VFS always has an inode reference when we call these functions. So we
    only need to grab a signle reference to each inode that's joined to a
    transaction - all the other bumping and dropping is as useless as the
    comments describing the IRIX semantics.
    
    SGI-PV: 976035
    SGI-Modid: xfs-linux-melb:xfs-kern:30912a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 82dab941a192d081dd0b7cde3ed32603372d5acc
Author: Christoph Hellwig <hch@infradead.org>
Date:   Tue Apr 22 17:34:18 2008 +1000

    [XFS] kill parent == child checks in xfs_remove and xfs_rmdir
    
    VFS guaranteed these can't happen.
    
    SGI-PV: 976035
    SGI-Modid: xfs-linux-melb:xfs-kern:30911a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 1ac74e01df959e3e91baded7c83399372af945a2
Author: Christoph Hellwig <hch@infradead.org>
Date:   Tue Apr 22 17:34:12 2008 +1000

    [XFS] kill usesless IHOLD calls in xfs_rename
    
    Similar to to the previous patch for remove and rmdir only grab a
    reference to inodes when we join them to transaction to balance the
    decrement on transaction completion. Everything else it taken care of by
    the VFS.
    
    Note that the old case had leaks of inode count when src == target or src
    or target == one of the parent inodes, but these cases are fortunately
    already rejected by the VFS.
    
    SGI-PV: 976035
    SGI-Modid: xfs-linux-melb:xfs-kern:30904a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit cfa853e47df4fbee441ac0ac3fb592f076233145
Author: Christoph Hellwig <hch@infradead.org>
Date:   Tue Apr 22 17:34:06 2008 +1000

    [XFS] remove manual lookup from xfs_rename and simplify locking
    
    ->rename already gets the target inode passed if it exits. Pass it down to
    xfs_rename so that we can avoid looking it up again. Also simplify locking
    as the first lock section in xfs_rename can go away now: the isdir is an
    invariant over the lifetime of the inode, and new_parent and the nlink
    check are namespace topology protected by i_mutex in the VFS. The projid
    check needs to move into the second lock section anyway to not be racy.
    
    Also kill the now unused xfs_dir_lookup_int and remove the now-unused
    first_locked argumet to xfs_lock_inodes.
    
    SGI-PV: 976035
    SGI-Modid: xfs-linux-melb:xfs-kern:30903a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 579aa9caf552c639fc78168db4cfe7ffcf00c3b3
Author: Christoph Hellwig <hch@infradead.org>
Date:   Tue Apr 22 17:34:00 2008 +1000

    [XFS] shrink mrlock_t
    
    The writer field is not needed for non_DEBU builds so remove it. While
    we're at i also clean up the interface for is locked asserts to go through
    and xfs_iget.c helper with an interface like the xfs_ilock routines to
    isolated the XFS codebase from mrlock internals. That way we can kill
    mrlock_t entirely once rw_semaphores grow an islocked facility. Also
    remove unused flags to the ilock family of functions.
    
    SGI-PV: 976035
    SGI-Modid: xfs-linux-melb:xfs-kern:30902a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit eca450b7c23f804597b87085b2a05bfc5b3ccb8b
Author: Christoph Hellwig <hch@infradead.org>
Date:   Tue Apr 22 17:33:52 2008 +1000

    [XFS] simplify xfs_lookup
    
    Opencode xfs-kill-xfs_dir_lookup_int here, which gets rid of a lock
    roundtrip, and lots of stack space. Also kill the di_mode == 0 check that
    has been done in xfs_iget for a few years now.
    
    SGI-PV: 976035
    SGI-Modid: xfs-linux-melb:xfs-kern:30901a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit d4377d84189349357e1812eaff6d0504766eea06
Author: Christoph Hellwig <hch@infradead.org>
Date:   Tue Apr 22 17:33:46 2008 +1000

    [XFS] xfs_rename: pass resblks to xfs_dir_removename
    
    Similar to rmdir and remove - avoids a potential transaction reservation
    overrun.
    
    SGI-PV: 976035
    SGI-Modid: xfs-linux-melb:xfs-kern:30900a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 6a7f422d47d4af461704ebb9d7a389d9e59766b2
Author: Christoph Hellwig <hch@infradead.org>
Date:   Tue Apr 22 17:33:40 2008 +1000

    [XFS] kill di_mode checks after xfs_iget
    
    Unless XFS_IGET_CREATE is passed xfs_iget will return ENOENT if it
    encounters an inode with di_mode == 0. Remove the duplicated checks in the
    callers.
    
    (the log recovery case is not touched for now)
    
    SGI-PV: 976035
    SGI-Modid: xfs-linux-melb:xfs-kern:30898a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 4e5dbb3498e74514b9936d691413afc55fb84ea9
Author: Christoph Hellwig <hch@infradead.org>
Date:   Tue Apr 22 17:33:33 2008 +1000

    [XFS] kill xfs_getattr
    
    It's currently used by the ACL code to read di_mode/di_uid, but these are
    simple 32bit scalar values we can just read directly without locking.
    
    SGI-PV: 976035
    SGI-Modid: xfs-linux-melb:xfs-kern:30897a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 42173f6860af7e016a950a9a19a66679cfc46d98
Author: Christoph Hellwig <hch@infradead.org>
Date:   Tue Apr 22 17:33:25 2008 +1000

    [XFS] Remove VN_IS* macros and related cruft.
    
    We can just check i_mode / di_mode directly.
    
    SGI-PV: 976035
    SGI-Modid: xfs-linux-melb:xfs-kern:30896a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
