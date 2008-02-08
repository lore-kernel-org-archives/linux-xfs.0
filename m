Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 07 Feb 2008 18:27:06 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m182Qox8022396
	for <xfs@oss.sgi.com>; Thu, 7 Feb 2008 18:26:54 -0800
Date: Fri, 08 Feb 2008 13:27:04 +1100
Subject: [GIT PULL] XFS update for 2.6.25
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080208022705.0DB1058C4C11@chook.melbourne.sgi.com>
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org

Please pull from the for-linus branch:
    git pull git://oss.sgi.com:8090/xfs/xfs-2.6.git for-linus

This will update the following files:

 fs/xfs/Makefile-linux-2.6      |    1 -
 fs/xfs/linux-2.6/spin.h        |   45 ---
 fs/xfs/linux-2.6/xfs_aops.c    |   43 ++-
 fs/xfs/linux-2.6/xfs_buf.c     |   57 +---
 fs/xfs/linux-2.6/xfs_buf.h     |    1 -
 fs/xfs/linux-2.6/xfs_export.c  |   25 +-
 fs/xfs/linux-2.6/xfs_file.c    |    3 +-
 fs/xfs/linux-2.6/xfs_globals.c |    3 +-
 fs/xfs/linux-2.6/xfs_ioctl.c   |   86 ++---
 fs/xfs/linux-2.6/xfs_ioctl32.c |    9 +-
 fs/xfs/linux-2.6/xfs_iops.c    |  170 +++++++--
 fs/xfs/linux-2.6/xfs_linux.h   |   34 +--
 fs/xfs/linux-2.6/xfs_lrw.c     |  122 +++----
 fs/xfs/linux-2.6/xfs_lrw.h     |   16 +-
 fs/xfs/linux-2.6/xfs_super.c   |  572 +++++++++++++++++++++++++++--
 fs/xfs/linux-2.6/xfs_vnode.c   |  117 +++----
 fs/xfs/linux-2.6/xfs_vnode.h   |   62 ++--
 fs/xfs/quota/xfs_dquot.c       |   12 +-
 fs/xfs/quota/xfs_dquot.h       |    5 -
 fs/xfs/quota/xfs_dquot_item.c  |   27 +-
 fs/xfs/quota/xfs_qm.c          |   14 +-
 fs/xfs/quota/xfs_qm.h          |    6 +-
 fs/xfs/quota/xfs_qm_syscalls.c |   19 +-
 fs/xfs/support/debug.c         |    7 +-
 fs/xfs/support/ktrace.c        |    8 +-
 fs/xfs/support/ktrace.h        |    3 -
 fs/xfs/support/uuid.c          |    2 +-
 fs/xfs/xfs.h                   |    2 +-
 fs/xfs/xfs_acl.c               |   30 +--
 fs/xfs/xfs_acl.h               |    2 -
 fs/xfs/xfs_ag.h                |    2 +-
 fs/xfs/xfs_alloc.c             |   19 +-
 fs/xfs/xfs_attr.c              |    2 +-
 fs/xfs/xfs_attr_leaf.c         |    8 +-
 fs/xfs/xfs_bit.c               |  103 ------
 fs/xfs/xfs_bit.h               |   27 ++-
 fs/xfs/xfs_bmap.c              |   22 +-
 fs/xfs/xfs_bmap.h              |    2 +
 fs/xfs/xfs_bmap_btree.c        |    3 +-
 fs/xfs/xfs_btree.h             |    2 +
 fs/xfs/xfs_buf_item.c          |   10 +-
 fs/xfs/xfs_buf_item.h          |    2 +
 fs/xfs/xfs_da_btree.c          |   13 +-
 fs/xfs/xfs_da_btree.h          |    1 +
 fs/xfs/xfs_dfrag.c             |   84 ++---
 fs/xfs/xfs_dinode.h            |   82 ++---
 fs/xfs/xfs_dir2.c              |    3 +-
 fs/xfs/xfs_error.c             |   31 --
 fs/xfs/xfs_error.h             |    2 +
 fs/xfs/xfs_extfree_item.c      |   21 +-
 fs/xfs/xfs_filestream.c        |    2 +-
 fs/xfs/xfs_fs.h                |   10 +-
 fs/xfs/xfs_fsops.c             |   13 +-
 fs/xfs/xfs_ialloc_btree.h      |    2 -
 fs/xfs/xfs_iget.c              |  185 ++++------
 fs/xfs/xfs_inode.c             |  225 +++---------
 fs/xfs/xfs_inode.h             |   98 ++---
 fs/xfs/xfs_inode_item.c        |   26 +-
 fs/xfs/xfs_iocore.c            |  119 ------
 fs/xfs/xfs_iomap.c             |  212 ++++++------
 fs/xfs/xfs_iomap.h             |    5 +-
 fs/xfs/xfs_itable.c            |   12 +-
 fs/xfs/xfs_log.c               |  416 ++++++++++-----------
 fs/xfs/xfs_log.h               |    3 +-
 fs/xfs/xfs_log_priv.h          |   96 ++---
 fs/xfs/xfs_log_recover.c       |  197 +++++------
 fs/xfs/xfs_mount.c             |  344 ++++++++++--------
 fs/xfs/xfs_mount.h             |  127 +------
 fs/xfs/xfs_mru_cache.c         |   54 ++--
 fs/xfs/xfs_qmops.c             |    7 +-
 fs/xfs/xfs_rename.c            |    9 +-
 fs/xfs/xfs_rtalloc.c           |   19 +-
 fs/xfs/xfs_rtalloc.h           |    2 -
 fs/xfs/xfs_rw.h                |   12 +-
 fs/xfs/xfs_trans.c             |    7 +-
 fs/xfs/xfs_trans.h             |    7 +-
 fs/xfs/xfs_trans_ail.c         |  340 +++++++++++------
 fs/xfs/xfs_trans_item.c        |    1 +
 fs/xfs/xfs_trans_priv.h        |   13 +-
 fs/xfs/xfs_utils.c             |   11 +-
 fs/xfs/xfs_utils.h             |    2 -
 fs/xfs/xfs_vfsops.c            |  793 ++--------------------------------------
 fs/xfs/xfs_vfsops.h            |    9 +-
 fs/xfs/xfs_vnodeops.c          |  165 +++------
 fs/xfs/xfs_vnodeops.h          |    2 -
 85 files changed, 2303 insertions(+), 3184 deletions(-)
 delete mode 100644 fs/xfs/linux-2.6/spin.h
 delete mode 100644 fs/xfs/xfs_iocore.c

through these commits:

commit de2eeea609b55e8c3994133a565b39edeaaaaf69
Author: Lachlan McIlroy <lachlan@sgi.com>
Date:   Wed Feb 6 13:37:56 2008 +1100

    [XFS] add __init/__exit mark to specific init/cleanup functions
    
    SGI-PV: 971186
    SGI-Modid: xfs-linux-melb:xfs-kern:30459a
    
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
    Signed-off-by: Denis Cheng <crquan@gmail.com>

commit 450790a2c51e6d9d47ed30dbdcf486656b8e186f
Author: David Chinner <dgc@sgi.com>
Date:   Wed Feb 6 13:37:40 2008 +1100

    [XFS] Fix oops in xfs_file_readdir()
    
    When xfs_file_readdir() exactly fills a buffer, it can move it's index
    past the end of the buffer and dereference it even though the result of
    the dereference is never used. On some platforms this causes an oops.
    
    SGI-PV: 976923
    SGI-Modid: xfs-linux-melb:xfs-kern:30458a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit cbc89dcfd24fd161f7a8e262266177db160a58fb
Author: Christoph Hellwig <hch@infradead.org>
Date:   Tue Feb 5 12:14:01 2008 +1100

    [XFS] kill xfs_root
    
    The only caller (xfs_fs_fill_super) can simplify call igrab on the root
    inode.
    
    SGI-PV: 971186
    SGI-Modid: xfs-linux-melb:xfs-kern:30393a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 4188c78d951d8a44630f4c33bc0f5b63374572a4
Author: Christoph Hellwig <hch@infradead.org>
Date:   Tue Feb 5 12:13:53 2008 +1100

    [XFS] keep i_nlink updated and use proper accessors
    
    To get the read-only bind mounts in -mm to work correctly with XFS we need
    to call the drop_nlink and inc_nlink helpers to monitor the link count.
    Add calls to these to xfs_bumplink and xfs_droplink and stop copying over
    di_nlink to i_nlink in xfs_validate_fields and vn_revalidate.
    
    SGI-PV: 971186
    SGI-Modid: xfs-linux-melb:xfs-kern:30392a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 222096ae7f7616caa9e4150948096160cc8a8141
Author: Christoph Hellwig <hch@infradead.org>
Date:   Tue Feb 5 12:13:46 2008 +1100

    [XFS] stop updating inode->i_blocks
    
    The VFS doesn't use i_blocks, it's only used by generic_fillattr and the
    generic quota code which XFS doesn't use. In XFS there is one use to check
    whether we have an inline or out of line sumlink, but we can replace that
    with a check of the XFS_IFINLINE inode flag.
    
    SGI-PV: 971186
    SGI-Modid: xfs-linux-melb:xfs-kern:30391a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit de08dbc1977419efa47eb71f10d96a98eb5bb111
Author: David Chinner <dgc@sgi.com>
Date:   Tue Feb 5 12:13:38 2008 +1100

    [XFS] Make xfs_ail_check check less by default
    
    Checking the entire AIL on every insert and remove is prohibitively
    expensive - the sustained sequntial create rate on a single disk drops
    from about 1800/s to 60/s because of this checking resulting in the
    xfslogd becoming cpu bound.
    
    By default on debug builds, only check the next and previous entries in
    the list to ensure they are ordered correctly. If you really want, define
    XFS_TRANS_DEBUG to use the old behaviour.
    
    SGI-PV: 972759
    SGI-Modid: xfs-linux-melb:xfs-kern:30372a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 249a8c1124653fa90f3a3afff869095a31bc229f
Author: David Chinner <dgc@sgi.com>
Date:   Tue Feb 5 12:13:32 2008 +1100

    [XFS] Move AIL pushing into it's own thread
    
    When many hundreds to thousands of threads all try to do simultaneous
    transactions and the log is in a tail-pushing situation (i.e. full), we
    can get multiple threads walking the AIL list and contending on the AIL
    lock.
    
    The AIL push is, in effect, a simple I/O dispatch algorithm complicated by
    the ordering constraints placed on it by the transaction subsystem. It
    really does not need multiple threads to push on it - even when only a
    single CPU is pushing the AIL, it can push the I/O out far faster that
    pretty much any disk subsystem can handle.
    
    So, to avoid contention problems stemming from multiple list walkers, move
    the list walk off into another thread and simply provide a "target" to
    push to. When a thread requires a push, it sets the target and wakes the
    push thread, then goes to sleep waiting for the required amount of space
    to become available in the log.
    
    This mechanism should also be a lot fairer under heavy load as the waiters
    will queue in arrival order, rather than queuing in "who completed a push
    first" order.
    
    Also, by moving the pushing to a separate thread we can do more
    effectively overload detection and prevention as we can keep context from
    loop iteration to loop iteration. That is, we can push only part of the
    list each loop and not have to loop back to the start of the list every
    time we run. This should also help by reducing the number of items we try
    to lock and/or push items that we cannot move.
    
    Note that this patch is not intended to solve the inefficiencies in the
    AIL structure and the associated issues with extremely large list
    contents. That needs to be addresses separately; parallel access would
    cause problems to any new structure as well, so I'm only aiming to isolate
    the structure from unbounded parallelism here.
    
    SGI-PV: 972759
    SGI-Modid: xfs-linux-melb:xfs-kern:30371a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 4576758db5817a91b8974c696247d459dc653db2
Author: Christoph Hellwig <hch@infradead.org>
Date:   Tue Feb 5 12:13:24 2008 +1100

    [XFS] use generic_permission
    
    Now that all direct caller of xfs_iaccess are gone we can kill xfs_iaccess
    and xfs_access and just use generic_permission with a check_acl callback.
    This is required for the per-mount read-only patchset in -mm to work
    properly with XFS.
    
    SGI-PV: 971186
    SGI-Modid: xfs-linux-melb:xfs-kern:30370a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit f6aa7f2184330262e1cb5f7802536e5346bd46a3
Author: Christoph Hellwig <hch@infradead.org>
Date:   Tue Feb 5 12:13:15 2008 +1100

    [XFS] stop re-checking permissions in xfs_swapext
    
    xfs_swapext should simplify check if we have a writeable file descriptor
    instead of re-checking the permissions using xfs_iaccess. Add an
    additional check to refuse O_APPEND file descriptors because swapext is
    not an append-only write operation.
    
    SGI-PV: 971186
    SGI-Modid: xfs-linux-melb:xfs-kern:30369a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 35fec8df65217546f6d9d508b203c1d135a67fbc
Author: Christoph Hellwig <hch@infradead.org>
Date:   Tue Feb 5 12:13:07 2008 +1100

    [XFS] clean up xfs_swapext
    
    - stop using vnodes
    - use proper multiple label goto unwinding
    - give the struct file * variables saner names
    
    SGI-PV: 971186
    SGI-Modid: xfs-linux-melb:xfs-kern:30366a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 199037c598daf5f3602dace68c331665a4f4f0c1
Author: Christoph Hellwig <hch@infradead.org>
Date:   Tue Feb 5 12:12:58 2008 +1100

    [XFS] remove permission check from xfs_change_file_space
    
    Both callers of xfs_change_file_space alreaedy do the file->f_mode &
    FMODE_WRITE check to ensure we have a file descriptor that has been opened
    for write mode, so there is no need to re-check that with xfs_iaccess.
    Especially as the later might wrongly deny it for corner cases like file
    descriptor passing through unix domain sockets.
    
    SGI-PV: 971186
    SGI-Modid: xfs-linux-melb:xfs-kern:30365a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 9742bb93da27737fe490eab2af9fba1efa243dcb
Author: Lachlan McIlroy <lachlan@sgi.com>
Date:   Thu Jan 10 16:43:36 2008 +1100

    [XFS] prevent panic during log recovery due to bogus op_hdr length
    
    A problem was reported where a system panicked in log recovery due to a
    corrupt log record. The cause of the corruption is not known but this
    change will at least prevent a crash for this specific scenario. Log
    recovery definitely needs some more work in this area.
    
    SGI-PV: 974151
    SGI-Modid: xfs-linux-melb:xfs-kern:30318a
    
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Christoph Hellwig <hch@infradead.org>

commit f71354bc3a96c657a70e36dcf980cbad6c9fc63f
Author: Christoph Hellwig <hch@infradead.org>
Date:   Tue Dec 18 16:26:55 2007 +1100

    [XFS] Cleanup various fid related bits:
    
    - merge xfs_fid2 into it's only caller xfs_dm_inode_to_fh.
    - remove xfs_vget and opencode it in the two callers, simplifying
      both of them by avoiding the awkward calling convetion.
    - assign directly to the dm_fid_t members in various places in the
      dmapi code instead of casting them to xfs_fid_t first (which
      is identical to dm_fid_t)
    
    SGI-PV: 974747
    SGI-Modid: xfs-linux-melb:xfs-kern:30258a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Vlad Apostolov <vapo@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit edd319dc527733e61eec5bdc9ce20c94634b6482
Author: David Chinner <dgc@sgi.com>
Date:   Fri Dec 7 14:08:48 2007 +1100

    [XFS] Fix xfs_lowbit64
    
    xfs_lowbit64 was broken on 32 bit platforms in a recent cleanup of the xfs
    bitops. Fix it back up again.
    
    SGI-PV: 974005
    SGI-Modid: xfs-linux-melb:xfs-kern:30202a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 45ba598e56fa9f77801e06432b50580d97994fa4
Author: Christoph Hellwig <hch@infradead.org>
Date:   Fri Dec 7 14:07:20 2007 +1100

    [XFS] Remove CFORK macros and use code directly in IFORK and DFORK macros.
    
    Currently XFS_IFORK_* and XFS_DFORK* are implemented by means of
    XFS_CFORK* macros. But given that XFS_IFORK_* operates on an xfs_inode
    that embedds and xfs_icdinode_core and XFS_DFORK_* operates on an
    xfs_dinode that embedds a xfs_dinode_core one will have to do endian
    swapping while the other doesn't. Instead of having the current mess with
    the CFORK macros that have byteswapping and non-byteswapping version
    (which are inconsistantly named while we're at it) just define each family
    of the macros to stand by itself and simplify the whole matter.
    
    A few direct references to the CFORK variants were cleaned up to use IFORK
    or DFORK to make this possible.
    
    SGI-PV: 971186
    SGI-Modid: xfs-linux-melb:xfs-kern:30163a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Tim Shimmin <tes@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit a9759f2de38a3443d5107bddde03b4f3f550060e
Author: Christoph Hellwig <hch@infradead.org>
Date:   Fri Dec 7 14:07:08 2007 +1100

    [XFS] kill superflous buffer locking (2nd attempt)
    
    There is no need to lock any page in xfs_buf.c because we operate on our
    own address_space and all locking is covered by the buffer semaphore. If
    we ever switch back to main blockdeive address_space as suggested e.g. for
    fsblock with a similar scheme the locking will have to be totally revised
    anyway because the current scheme is neither correct nor coherent with
    itself.
    
    SGI-PV: 971186
    SGI-Modid: xfs-linux-melb:xfs-kern:30156a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 40ebd81d1a7635cf92a59c387a599fce4863206b
Author: Robert P. J. Day <rpjday@crashcourse.ca>
Date:   Fri Nov 23 16:30:51 2007 +1100

    [XFS] Use kernel-supplied "roundup_pow_of_two" for simplicity
    
    SGI-PV: 971186
    SGI-Modid: xfs-linux-melb:xfs-kern:30098a
    
    Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit e6a4b37f38dca6e86b2648d172946700ee921e12
Author: Tim Shimmin <tes@sgi.com>
Date:   Fri Nov 23 16:30:42 2007 +1100

    [XFS] Remove the BPCSHIFT and NB* based macros from XFS.
    
    The BPCSHIFT based macros, btoc*, ctob*, offtoc* and ctooff are either not
    used or don't need to be used. The NDPP, NDPP, NBBY macros don't need to
    be used but instead are replaced directly by PAGE_SIZE and PAGE_CACHE_SIZE
    where appropriate. Initial patch and motivation from Nicolas Kaiser.
    
    SGI-PV: 971186
    SGI-Modid: xfs-linux-melb:xfs-kern:30096a
    
    Signed-off-by: Tim Shimmin <tes@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit f7b7c3673e6e225de337abe00e14dc048e44782b
Author: Niv Sardi <xaiki@sgi.com>
Date:   Tue Nov 27 17:01:13 2007 +1100

    [XFS] Remove bogus assert
    
    This assert is bogus. We can have a forced shutdown occur
    between the check for the XLOG_FORCED_SHUTDOWN and the ASSERT. Also, the
    logging system shouldn't care about the state of XFS_FORCED_SHUTDOWN, it
    should only check XLOG_FORCED_SHUTDOWN. The logging system has it's own
    forced shutdown flag so, for the case of a forced shutdown that's not due
    to a logging error, we can flush the log.
    
    SGI-PV: 972985
    SGI-Modid: xfs-linux-melb:xfs-kern:30029a
    
    Signed-off-by: Niv Sardi <xaiki@sgi.com>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 71ddabb94a623d1e16e7e66898bf439ff78ecc41
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Fri Nov 23 16:29:42 2007 +1100

    [XFS] optimize XFS_IS_REALTIME_INODE w/o realtime config
    
    Use XFS_IS_REALTIME_INODE in more places, and #define it to 0 if
    CONFIG_XFS_RT is off. This should be safe because mount checks in
    xfs_rtmount_init:
    
    so if we get mounted w/o CONFIG_XFS_RT, no realtime inodes should be
    encountered after that.
    
    Defining XFS_IS_REALTIME_INODE to 0 saves a bit of stack space,
    presumeably gcc can optimize around the various "if (0)" type checks:
    
    xfs_alloc_file_space -8 xfs_bmap_adjacent -16 xfs_bmapi -8
    xfs_bmap_rtalloc -16 xfs_bunmapi -28 xfs_free_file_space -64 xfs_imap +8
    <-- ? hmm. xfs_iomap_write_direct -12 xfs_qm_dqusage_adjust -4
    xfs_qm_vop_chown_reserve -4
    
    SGI-PV: 971186
    SGI-Modid: xfs-linux-melb:xfs-kern:30014a
    
    Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit a67d7c5f5d25d0b13a4dfb182697135b014fa478
Author: David Chinner <dgc@sgi.com>
Date:   Fri Nov 23 16:29:32 2007 +1100

    [XFS] Move platform specific mount option parse out of core XFS code
    
    Mount option parsing is platform specific. Move it out of core code into
    the platform specific superblock operation file.
    
    SGI-PV: 971186
    SGI-Modid: xfs-linux-melb:xfs-kern:30012a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 3ed6526441053d79b85d206b14d75125e6f51cc2
Author: David Chinner <dgc@sgi.com>
Date:   Fri Nov 23 16:29:25 2007 +1100

    [XFS] Implement fallocate.
    
    Implement the new generic callout for file preallocation. Atomically
    change the file size if requested.
    
    SGI-PV: 972756
    SGI-Modid: xfs-linux-melb:xfs-kern:30009a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 5d51eff4538bdfeb9b7a2ec030ee3b0980b067d2
Author: David Chinner <dgc@sgi.com>
Date:   Fri Nov 23 16:29:18 2007 +1100

    [XFS] Fix inode allocation latency
    
    The log force added in xfs_iget_core() has been a performance issue since
    it was introduced for tight loops that allocate then unlink a single file.
    under heavy writeback, this can introduce unnecessary latency due tothe
    log I/o getting stuck behind bulk data writes.
    
    Fix this latency problem by avoinding the need for the log force by moving
    the place we mark linux inode dirty to the transaction commit rather than
    on transaction completion.
    
    This also closes a potential hole in the sync code where a linux inode is
    not dirty between the time it is modified and the time the log buffer has
    been written to disk.
    
    SGI-PV: 972753
    SGI-Modid: xfs-linux-melb:xfs-kern:30007a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit e4143a1cf5973e3443c0650fc4c35292d3b7baa8
Author: David Chinner <dgc@sgi.com>
Date:   Fri Nov 23 16:29:11 2007 +1100

    [XFS] Fix transaction overrun during writeback.
    
    Prevent transaction overrun in xfs_iomap_write_allocate() if we race with
    a truncate that overlaps the delalloc range we were planning to allocate.
    
    If we race, we may allocate into a hole and that requires block
    allocation. At this point in time we don't have a reservation for block
    allocation (apart from metadata blocks) and so allocating into a hole
    rather than a delalloc region results in overflowing the transaction block
    reservation.
    
    Fix it by only allowing a single extent to be allocated at a time.
    
    SGI-PV: 972757
    SGI-Modid: xfs-linux-melb:xfs-kern:30005a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 786f486f8154b94b36182d2b53df3bf2b40d85e7
Author: David Chinner <dgc@sgi.com>
Date:   Fri Nov 23 16:28:24 2007 +1100

    [XFS] Show all mount args in /proc/mounts
    
    There are several mount options that don't show up in /proc/mounts. Add
    them in and clean up the showargs code at the same time.
    
    SGI-PV: 971186
    SGI-Modid: xfs-linux-melb:xfs-kern:30004a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 8ae2c0f64a81a93d2c394eacee29d6ced53b54f9
Author: David Chinner <dgc@sgi.com>
Date:   Fri Nov 23 16:28:17 2007 +1100

    [XFS] Fix sparse warning in xlog_recover_do_efd_trans.
    
    Sparse trips over the locking order in xlog_recover_do_efd_trans() when
    xfs_trans_delete_ail() drops the ail lock. Because the unlock is
    conditional, we need to either annotate with a "fake unlock" or change the
    structure of the code so sparse thinks the function always unlocks.
    
    Reordering the code makes it simpler, so do that.
    
    SGI-PV: 972755
    SGI-Modid: xfs-linux-melb:xfs-kern:30003a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit a8272ce0c1d49aa3bec57682678f0bdfe28ed4ca
Author: David Chinner <dgc@sgi.com>
Date:   Fri Nov 23 16:28:09 2007 +1100

    [XFS] Fix up sparse warnings.
    
    These are mostly locking annotations, marking things static, casts where
    needed and declaring stuff in header files.
    
    SGI-PV: 971186
    SGI-Modid: xfs-linux-melb:xfs-kern:30002a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit a69b176df246d59626e6a9c640b44c0921fa4566
Author: David Chinner <dgc@sgi.com>
Date:   Fri Nov 23 16:27:59 2007 +1100

    [XFS] Use the generic bitops rather than implementing them ourselves.
    Patch inspired by Andi Kleen.
    
    SGI-PV: 971186
    SGI-Modid: xfs-linux-melb:xfs-kern:30000a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit c319b58b13bb22f9a2478825b06c641c825f51ec
Author: Vlad Apostolov <vapo@sgi.com>
Date:   Fri Nov 23 16:27:51 2007 +1100

    [XFS] Make xfs_bulkstat() to report unlinked but referenced inodes
    
    We need xfs_bulkstat() to report inode stat for inodes with link count
    zero but reference count non zero.
    
    The fix here:
    
    http://oss.sgi.com/archives/xfs/2007-09/msg00266.html
    
    changed this behavior and made xfs_bulkstat() to filter all unlinked
    inodes including those that are not destroyed yet but held by reference.
    
    The attached patch returns back to the original behavior by marking the
    on-disk inode buffer "dirty" when di_mode is cleared (at that time both
    inode link and reference counter are zero).
    
    SGI-PV: 972004
    SGI-Modid: xfs-linux-melb:xfs-kern:29914a
    
    Signed-off-by: Vlad Apostolov <vapo@sgi.com>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 98ce2b5b1bd6db9f8d510b4333757fa6b1efe131
Author: Lachlan McIlroy <lachlan@sgi.com>
Date:   Fri Nov 23 16:27:32 2007 +1100

    [XFS] 971186 Undo mod xfs-linux-melb:xfs-kern:29845a due to a regression
    
    SGI-PV: 971596
    SGI-Modid: xfs-linux-melb:xfs-kern:29902a
    
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit bc58f9bb6be02a80b5f1f757b656c9affc07154f
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Fri Oct 12 11:13:22 2007 +1000

    [XFS] fix 32-bit compat ioctls for GETXFLAGS, SETXFLAGS, GETVERSION
    
    XFS_IOC_GETVERSION, XFS_IOC_GETXFLAGS and XFS_IOC_SETXFLAGS all take a
    "long" which changes size between 32 and 64 bit platforms.
    
    So, the ioctl cmds that come in from a 32-bit app aren't as expected, for
    example on GETXFLAGS,
    
    unknown cmd fd(3) cmd(80046601){t:'f';sz:4}
    
    due to the size mismatch.
    
    So, use instead the 32-bit version of the commands for compat ioctls, and
    other than that it doesn't take any more manipulation.
    
    Also, for both native and compat versions, just define them to the values
    as defined in fs.h
    
    SGI-PV: 971186
    SGI-Modid: xfs-linux-melb:xfs-kern:29849a
    
    Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit d4f3cc016fd6b392d483adc586b6dfaabad081af
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Fri Oct 12 11:13:08 2007 +1000

    [XFS] lose xfs_hex_dump in favor of print_hex_dump
    
    No need for xfs to have its own hex dumping routine now that the kernel
    has one.
    
    SGI-PV: 971186
    SGI-Modid: xfs-linux-melb:xfs-kern:29847a
    
    Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 91906a882a4c9541317bc4f4c7fa5d8b784ba198
Author: Christoph Hellwig <hch@infradead.org>
Date:   Fri Oct 12 11:12:54 2007 +1000

    [XFS] kill XFS_INOBT_IS_FREE_DISK
    
    This macro is unused an all other acros in this family operate on native
    types, so we most likely won't grow a user either.
    
    SGI-PV: 971186
    SGI-Modid: xfs-linux-melb:xfs-kern:29846a
    
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit c40ea74101ab75a8f320d057e7cf4b772b090110
Author: Christoph Hellwig <hch@infradead.org>
Date:   Fri Oct 12 11:12:39 2007 +1000

    [XFS] kill superflous buffer locking
    
    There is no need to lock any page in xfs_buf.c because we operate on our
    own address_space and all locking is covered by the buffer semaphore. If
    we ever switch back to main blockdeive address_space as suggested e.g. for
    fsblock with a similar scheme the locking will have to be totally revised
    anyway because the current scheme is neither correct nor coherent with
    itself.
    
    SGI-PV: 971186
    SGI-Modid: xfs-linux-melb:xfs-kern:29845a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 0771fb4515229821b7d74865b87a430de9fc1113
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Fri Oct 12 11:03:40 2007 +1000

    [XFS] Refactor xfs_mountfs
    
    Refactoring xfs_mountfs() to call sub-functions for logical chunks can
    help save a bit of stack, and can make it easier to read this long
    function.
    
    The mount path is one of the longest common callchains, easily getting to
    within a few bytes of the end of a 4k stack when over lvm, quotas are
    enabled, and quotacheck must be done.
    
    With this change on top of the other stack-related changes I've sent, I
    can get xfs to survive a normal xfsqa run on 4k stacks over lvm.
    
    SGI-PV: 971186
    SGI-Modid: xfs-linux-melb:xfs-kern:29834a
    
    Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
    Signed-off-by: Donald Douwsma <donaldd@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit b53e675dc868c4844ecbcce9149cf68e4299231d
Author: Christoph Hellwig <hch@infradead.org>
Date:   Fri Oct 12 10:59:34 2007 +1000

    [XFS] xlog_rec_header/xlog_rec_ext_header endianess annotations
    
    Mostly trivial conversion with one exceptions: h_num_logops was kept in
    native endian previously and only converted to big endian in xlog_sync,
    but we always keep it big endian now. With todays cpus fast byteswap
    instructions that's not an issue but the new variant keeps the code clean
    and maintainable.
    
    SGI-PV: 971186
    SGI-Modid: xfs-linux-melb:xfs-kern:29821a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 67fcb7bfb69eb1072c7e2dd6b46fa34db11dd587
Author: Christoph Hellwig <hch@infradead.org>
Date:   Fri Oct 12 10:58:59 2007 +1000

    [XFS] clean up some xfs_log_priv.h macros
    
    - the various assign lsn macros are replaced by a single inline,
    xlog_assign_lsn, which is equivalent to ASSIGN_ANY_LSN_HOST except
    for a more sane calling convention. ASSIGN_LSN_DISK is replaced
    by xlog_assign_lsn and a manual bytespap, and ASSIGN_LSN by the same,
    except we pass the cycle and block arguments explicitly instead of a
    log paramter. The latter two variants only had 2, respectively one
    user anyway.
    - the GET_CYCLE is replaced by a xlog_get_cycle inline with exactly the
    same calling conventions.
    - GET_CLIENT_ID is replaced by xlog_get_client_id which leaves away
    the unused arch argument. Instead of conditional defintions
    depending on host endianess we now do an unconditional swap and shift
    then, which generates equal code.
    - the unused XLOG_SET macro is removed.
    
    SGI-PV: 971186
    SGI-Modid: xfs-linux-melb:xfs-kern:29820a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 03bea6fe6c38c502c815432999eacfa2eccb0a12
Author: Christoph Hellwig <hch@infradead.org>
Date:   Fri Oct 12 10:58:05 2007 +1000

    [XFS] clean up some xfs_log_priv.h macros
    
    - the various assign lsn macros are replaced by a single inline,
    xlog_assign_lsn, which is equivalent to ASSIGN_ANY_LSN_HOST except
    for a more sane calling convention. ASSIGN_LSN_DISK is replaced
    by xlog_assign_lsn and a manual bytespap, and ASSIGN_LSN by the same,
    except we pass the cycle and block arguments explicitly instead of a
    log paramter. The latter two variants only had 2, respectively one
    user anyway.
    - the GET_CYCLE is replaced by a xlog_get_cycle inline with exactly the
    same calling conventions.
    - GET_CLIENT_ID is replaced by xlog_get_client_id which leaves away
    the unused arch argument. Instead of conditional defintions
    depending on host endianess we now do an unconditional swap and shift
    then, which generates equal code.
    - the unused XLOG_SET macro is removed.
    
    SGI-PV: 971186
    SGI-Modid: xfs-linux-melb:xfs-kern:29819a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 9909c4aa1a3e5b1f23cbc1bc2f0db025a7f75f85
Author: Christoph Hellwig <hch@infradead.org>
Date:   Thu Oct 11 18:11:14 2007 +1000

    [XFS] kill xfs_freeze.
    
    No need to have a wrapper just two call two more functions.
    
    SGI-PV: 971186
    SGI-Modid: xfs-linux-melb:xfs-kern:29816a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Donald Douwsma <donaldd@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 10090be25c159c02208b7abf89ae90f8105a2423
Author: Christoph Hellwig <hch@infradead.org>
Date:   Thu Oct 11 18:11:03 2007 +1000

    [XFS] cleanup vnode useage in xfs_iget.c
    
    Get rid of vnode useage in xfs_iget.c and pass Linux inode / xfs_inode
    where apropinquate. And kill some useless helpers while we're at it.
    
    SGI-PV: 971186
    SGI-Modid: xfs-linux-melb:xfs-kern:29808a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 6e7f75eafbc9b0eb575097f52ba6ed27154cea1b
Author: Christoph Hellwig <hch@infradead.org>
Date:   Thu Oct 11 18:09:50 2007 +1000

    [XFS] cleanup vnode useage in xfs_ioctl.c
    
    xfs_ioctl.c passes around vnode pointers quite a lot, but all places
    already have the Linux inode which is identical to the vnode these days.
    Clean the code up to always use the Linux inode.
    
    SGI-PV: 971186
    SGI-Modid: xfs-linux-melb:xfs-kern:29807a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 4ca488eb45692520f745f96abc00ea4e268a87d4
Author: Christoph Hellwig <hch@infradead.org>
Date:   Thu Oct 11 18:09:40 2007 +1000

    [XFS] Kill off xfs_statvfs.
    
    We were already filling the Linux struct statfs anyway, and doing this
    trivial task directly in xfs_fs_statfs makes the code quite a bit cleaner.
    While I was at it I also moved copying attributes that don't change over
    the lifetime of the filesystem outside the superblock lock.
    
    xfs_fs_fill_super used to get the magic number and blocksize through
    xfs_statvfs, but assigning them directly is a lot cleaner and will save
    some stack space during mount.
    
    SGI-PV: 971186
    SGI-Modid: xfs-linux-melb:xfs-kern:29802a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit c43f408795c3210c9f5c925e4a49dbb93d41bb57
Author: Christoph Hellwig <hch@infradead.org>
Date:   Thu Oct 11 17:46:39 2007 +1000

    [XFS] simplify xfs_vn_getattr
    
    Just fill in struct kstat directly from the xfs_inode instead of doing a
    detour through a bhv_vattr_t and xfs_getattr.
    
    SGI-PV: 970980
    SGI-Modid: xfs-linux-melb:xfs-kern:29770a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 613d70436c1aeda6843ca8b70c7fab6d0484a591
Author: Christoph Hellwig <hch@infradead.org>
Date:   Thu Oct 11 17:44:08 2007 +1000

    [XFS] kill xfs_iocore_t
    
    xfs_iocore_t is a structure embedded in xfs_inode. Except for one field it
    just duplicates fields already in xfs_inode, and there is nothing this
    abstraction buys us on XFS/Linux. This patch removes it and shrinks source
    and binary size of xfs aswell as shrinking the size of xfs_inode by 60/44
    bytes in debug/non-debug builds.
    
    SGI-PV: 970852
    SGI-Modid: xfs-linux-melb:xfs-kern:29754a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 007c61c68640ea17c036785b698d05da67b4365e
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Thu Oct 11 17:43:56 2007 +1000

    [XFS] Remove spin.h
    
    remove spinlock init abstraction macro in spin.h, remove the callers, and
    remove the file. Move no-op spinlock_destroy to xfs_linux.h Cleanup
    spinlock locals in xfs_mount.c
    
    SGI-PV: 970382
    SGI-Modid: xfs-linux-melb:xfs-kern:29751a
    
    Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
    Signed-off-by: Donald Douwsma <donaldd@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 36e41eebdafc8b5fabdf66f59d0d43b0b60f0fdb
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Thu Oct 11 17:43:43 2007 +1000

    [XFS] Cleanup lock goop.
    
    Switch last couple lock_t's to spinlock_t's. Remove now-unused
    spinlock-related macros & types.
    
    SGI-PV: 970382
    SGI-Modid: xfs-linux-melb:xfs-kern:29748a
    
    Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
    Signed-off-by: Donald Douwsma <donaldd@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 3a0e487034107c0859b8a0d71d14b5c8988d356b
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Thu Oct 11 17:43:32 2007 +1000

    [XFS] ktrace kt_lock is unused, remove it.
    
    SGI-PV: 970382
    SGI-Modid: xfs-linux-melb:xfs-kern:29747a
    
    Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
    Signed-off-by: Donald Douwsma <donaldd@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 3685c2a1d773781608c9e281a6ff6b4c8ea8f6f9
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Thu Oct 11 17:42:32 2007 +1000

    [XFS] Unwrap XFS_SB_LOCK.
    
    Un-obfuscate XFS_SB_LOCK, remove XFS_SB_LOCK->mutex_lock->spin_lock
    macros, call spin_lock directly, remove extraneous cookie holdover from
    old xfs code, and change lock type to spinlock_t.
    
    SGI-PV: 970382
    SGI-Modid: xfs-linux-melb:xfs-kern:29746a
    
    Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
    Signed-off-by: Donald Douwsma <donaldd@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit ba74d0cba51dcaa99e4dc2e4fb62e6e13abbf703
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Thu Oct 11 17:42:10 2007 +1000

    [XFS] Unwrap mru_lock.
    
    Un-obfuscate mru_lock, remove mutex_lock->spin_lock macros, call spin_lock
    directly, remove extraneous cookie holdover from old xfs code.
    
    SGI-PV: 970382
    SGI-Modid: xfs-linux-melb:xfs-kern:29745a
    
    Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
    Signed-off-by: Donald Douwsma <donaldd@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 703e1f0fd2edc2978bde3b4536e78b577318c090
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Thu Oct 11 17:41:21 2007 +1000

    [XFS] Unwrap xfs_dabuf_global_lock
    
    Un-obfuscate dabuf_global_lock, remove mutex_lock->spin_lock macros, call
    spin_lock directly, remove extraneous cookie holdover from old xfs code,
    and change lock type to spinlock_t.
    
    SGI-PV: 970382
    SGI-Modid: xfs-linux-melb:xfs-kern:29744a
    
    Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
    Signed-off-by: Donald Douwsma <donaldd@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 64137e56d76a5c05aa4411e2f5d7121593dd9478
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Thu Oct 11 17:38:28 2007 +1000

    [XFS] Unwrap pagb_lock.
    
    Un-obfuscate pagb_lock, remove mutex_lock->spin_lock macros, call
    spin_lock directly, remove extraneous cookie holdover from old xfs code,
    and change lock type to spinlock_t.
    
    SGI-PV: 970382
    SGI-Modid: xfs-linux-melb:xfs-kern:29743a
    
    Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
    Signed-off-by: Donald Douwsma <donaldd@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 869b906078720b68711569b68de0acca6b73b675
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Thu Oct 11 17:38:18 2007 +1000

    [XFS] Unwrap XFS_DQ_PINUNLOCK.
    
    Un-obfuscate DQ_PINLOCK, remove DQ_PINLOCK->mutex_lock->spin_lock macros,
    call spin_lock directly, remove extraneous cookie holdover from old xfs
    code, and change lock type to spinlock_t.
    
    SGI-PV: 970382
    SGI-Modid: xfs-linux-melb:xfs-kern:29742a
    
    Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
    Signed-off-by: Donald Douwsma <donaldd@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit c8b5ea289fed15a7d7a4d6e911987ff16499aed7
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Thu Oct 11 17:37:31 2007 +1000

    [XFS] Unwrap GRANT_LOCK.
    
    Un-obfuscate GRANT_LOCK, remove GRANT_LOCK->mutex_lock->spin_lock macros,
    call spin_lock directly, remove extraneous cookie holdover from old xfs
    code, and change lock type to spinlock_t.
    
    SGI-PV: 970382
    SGI-Modid: xfs-linux-melb:xfs-kern:29741a
    
    Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
    Signed-off-by: Donald Douwsma <donaldd@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit b22cd72c95df0414e0502a0999624d460ba66126
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Thu Oct 11 17:37:10 2007 +1000

    [XFS] Unwrap LOG_LOCK.
    
    Un-obfuscate LOG_LOCK, remove LOG_LOCK->mutex_lock->spin_lock macros, call
    spin_lock directly, remove extraneous cookie holdover from old xfs code,
    and change lock type to spinlock_t.
    
    SGI-PV: 970382
    SGI-Modid: xfs-linux-melb:xfs-kern:29740a
    
    Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
    Signed-off-by: Donald Douwsma <donaldd@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 287f3dad14828275d2517c8696ad118c82b9243f
Author: Donald Douwsma <donaldd@sgi.com>
Date:   Thu Oct 11 17:36:05 2007 +1000

    [XFS] Unwrap AIL_LOCK
    
    SGI-PV: 970382
    SGI-Modid: xfs-linux-melb:xfs-kern:29739a
    
    Signed-off-by: Donald Douwsma <donaldd@sgi.com>
    Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 541d7d3c4b31e2b0ac846fe6d2eb5cdbe1353095
Author: Lachlan McIlroy <lachlan@sgi.com>
Date:   Thu Oct 11 17:34:33 2007 +1000

    [XFS] kill unnessecary ioops indirection
    
    Currently there is an indirection called ioops in the XFS data I/O path.
    Various functions are called by functions pointers, but there is no
    coherence in what this is for, and of course for XFS itself it's entirely
    unused. This patch removes it instead and significantly reduces source and
    binary size of XFS while making maintaince easier.
    
    SGI-PV: 970841
    SGI-Modid: xfs-linux-melb:xfs-kern:29737a
    
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 21a62542b6d7f726d6c1d2cfbfa084f721ba4a26
Author: Christoph Hellwig <hch@infradead.org>
Date:   Wed Sep 19 15:27:49 2007 +1000

    [XFS] simplify vn_revalidate
    
    No need to allocate a bhv_vattr_t on stack and call xfs_getattr to update
    a few fields in the Linux inode from the XFS inode, just do it directly.
    
    And yes, this function is in dire need of a better name and prototype,
    I'll do in a separate patch, though.
    
    SGI-PV: 970705
    SGI-Modid: xfs-linux-melb:xfs-kern:29713a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 15947f2d4f747897f31cfaa36e98a93f80ca3d3f
Author: Lachlan McIlroy <lachlan@sgi.com>
Date:   Mon Sep 17 13:11:58 2007 +1000

    [XFS] more vnode/inode tracing fixes
    
    SGI-PV: 970335
    SGI-Modid: xfs-linux-melb:xfs-kern:29697a
    
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
    Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 7642861b7eeaddfc82d762b3342044c809c3f77e
Author: Christoph Hellwig <hch@infradead.org>
Date:   Fri Sep 14 15:23:31 2007 +1000

    [XFS] kill BMAPI_UNWRITTEN
    
    There is no reason to go through xfs_iomap for the BMAPI_UNWRITTEN because
    it has nothing in common with the other cases. Instead check for the
    shutdown filesystem in xfs_end_bio_unwritten and perform a direct call to
    xfs_iomap_write_unwritten (which should be renamed to something more
    sensible one day)
    
    SGI-PV: 970241
    SGI-Modid: xfs-linux-melb:xfs-kern:29681a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Donald Douwsma <donaldd@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 6214ed4461f1ad8aeec41857c73d58afb31be335
Author: Christoph Hellwig <hch@infradead.org>
Date:   Fri Sep 14 15:23:17 2007 +1000

    [XFS] kill BMAPI_DEVICE
    
    There is no reason to go into the iomap machinery just to get the right
    block device for an inode. Instead look at the realtime flag in the inode
    and grab the right device from the mount structure.
    
    I created a new helper, xfs_find_bdev_for_inode instead of opencoding it
    because I plan to use it in other places in the future.
    
    SGI-PV: 970240
    SGI-Modid: xfs-linux-melb:xfs-kern:29680a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Donald Douwsma <donaldd@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit cf441eeb79c32471379f0a4d97feaef691432a03
Author: Lachlan McIlroy <lachlan@redback.melbourne.sgi.com>
Date:   Thu Feb 7 16:42:19 2008 +1100

    [XFS] clean up vnode/inode tracing
    
    Simplify vnode tracing calls by embedding function name & return addr in
    the calling macro.
    
    Also do a lot of vnode->inode renaming for consistency, while we're at it.
    
    SGI-PV: 970335
    SGI-Modid: xfs-linux-melb:xfs-kern:29650a
    
    Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 44866d39282d0782b15fa4cb62aad937bf0a0897
Author: Lachlan McIlroy <lachlan@sgi.com>
Date:   Fri Sep 14 15:21:08 2007 +1000

    [XFS] remove dead SYNC_BDFLUSH case in xfs_sync_inodes
    
    A large part of xfs_sync_inodes is conditional on the SYNC_BDFLUSH which
    is never passed to it. This patch removes it and adds an assert that
    triggers in case some new code tries to pass SYNC_BDFLUSH to it.
    
    SGI-PV: 970242
    SGI-Modid: xfs-linux-melb:xfs-kern:29630a
    
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Tim Shimmin <tes@sgi.com>
