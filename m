Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 10 Feb 2007 01:01:39 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l1A91Sm7011517
	for <xfs@oss.sgi.com>; Sat, 10 Feb 2007 01:01:31 -0800
Date: Sat, 10 Feb 2007 19:38:19 +1100
From: Timothy Shimmin <tes@sgi.com>
Subject: XFS update for 2.6.21
Message-ID: <7AEB816692A232CFB60A832C@timothy-shimmins-power-mac-g5.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: torvalds@osdl.org
Cc: akpm@osdl.org, xfs@oss.sgi.com

Hi Linus,

Please pull from:
    git://oss.sgi.com:8090/xfs/xfs-2.6

This will update the following files:

 fs/xfs/linux-2.6/mrlock.h      |    6 -
 fs/xfs/linux-2.6/xfs_aops.c    |   15 +-
 fs/xfs/linux-2.6/xfs_buf.c     |  142 ++++++++++----------
 fs/xfs/linux-2.6/xfs_buf.h     |    4 -
 fs/xfs/linux-2.6/xfs_export.c  |    2
 fs/xfs/linux-2.6/xfs_file.c    |    4 -
 fs/xfs/linux-2.6/xfs_ioctl.c   |   51 +++----
 fs/xfs/linux-2.6/xfs_iops.c    |    6 -
 fs/xfs/linux-2.6/xfs_lrw.c     |   48 +++----
 fs/xfs/linux-2.6/xfs_lrw.h     |    2
 fs/xfs/linux-2.6/xfs_super.c   |   33 +++--
 fs/xfs/linux-2.6/xfs_sysctl.c  |  266 ++++++++++++++++++++++++++-----------
 fs/xfs/linux-2.6/xfs_vfs.h     |    2
 fs/xfs/linux-2.6/xfs_vnode.c   |    2
 fs/xfs/linux-2.6/xfs_vnode.h   |    4 -
 fs/xfs/quota/xfs_dquot.c       |    4 -
 fs/xfs/quota/xfs_dquot_item.c  |    8 -
 fs/xfs/quota/xfs_qm.c          |    8 -
 fs/xfs/quota/xfs_qm_bhv.c      |    4 -
 fs/xfs/quota/xfs_qm_stats.c    |    2
 fs/xfs/quota/xfs_qm_syscalls.c |    4 -
 fs/xfs/quota/xfs_trans_dquot.c |    2
 fs/xfs/support/debug.c         |   23 ++-
 fs/xfs/support/debug.h         |   30 ++++
 fs/xfs/support/move.h          |    4 -
 fs/xfs/xfs_acl.c               |    1
 fs/xfs/xfs_alloc_btree.h       |   10 -
 fs/xfs/xfs_attr.c              |   49 +++----
 fs/xfs/xfs_attr_leaf.c         |   54 +++++++-
 fs/xfs/xfs_bit.c               |    2
 fs/xfs/xfs_bmap.c              |  101 ++++----------
 fs/xfs/xfs_bmap.h              |    1
 fs/xfs/xfs_bmap_btree.c        |   86 +-----------
 fs/xfs/xfs_bmap_btree.h        |   59 ++------
 fs/xfs/xfs_btree.h             |    6 -
 fs/xfs/xfs_buf_item.c          |    2
 fs/xfs/xfs_buf_item.h          |   18 ---
 fs/xfs/xfs_cap.h               |   70 ----------
 fs/xfs/xfs_da_btree.c          |   18 ---
 fs/xfs/xfs_da_btree.h          |    1
 fs/xfs/xfs_dfrag.c             |    1
 fs/xfs/xfs_error.c             |   26 ----
 fs/xfs/xfs_error.h             |    3
 fs/xfs/xfs_extfree_item.c      |    4 -
 fs/xfs/xfs_fsops.c             |   60 +++++++-
 fs/xfs/xfs_ialloc.c            |    2
 fs/xfs/xfs_ialloc_btree.h      |   10 +
 fs/xfs/xfs_inode.c             |   30 +++-
 fs/xfs/xfs_inode_item.c        |    2
 fs/xfs/xfs_iomap.c             |   10 -
 fs/xfs/xfs_log_recover.c       |   61 +-------
 fs/xfs/xfs_mac.h               |  106 ---------------
 fs/xfs/xfs_mount.c             |  288 ++++++++++++++++++++++++----------------
 fs/xfs/xfs_mount.h             |   39 ++++-
 fs/xfs/xfs_rename.c            |    2
 fs/xfs/xfs_rtalloc.c           |  110 ---------------
 fs/xfs/xfs_rtalloc.h           |   18 ---
 fs/xfs/xfs_rw.c                |    1
 fs/xfs/xfs_trans.c             |   32 ++--
 fs/xfs/xfs_trans.h             |   46 +++---
 fs/xfs/xfs_trans_ail.c         |    2
 fs/xfs/xfs_vfsops.c            |   45 ++++--
 fs/xfs/xfs_vnodeops.c          |   22 +--
 63 files changed, 885 insertions(+), 1189 deletions(-)

through these commits:

commit e7ff6aed8761b2c86cd9ab7083e512de2b8cfa48
Author: David Chinner <dgc@sgi.com>
Date:   Sat Feb 10 18:37:46 2007 +1100

    [XFS] Don't use kmap in xfs_iozero.

    kmap() is inefficient and does not scale well. kmap_atomic() is a better
    choice. Use the generic wrapper function instead of open coding the
    kmap-memset-dcache flush-kunmap stuff.

    SGI-PV: 960904
    SGI-Modid: xfs-linux-melb:xfs-kern:28041a

    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 6be145bfb1ce93b2dbb854fee66fbb8d04916339
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Sat Feb 10 18:37:40 2007 +1100

    [XFS] Remove a bunch of unused functions from XFS.

    Patch provided by Eric Sandeen (sandeen@sandeen.net).

    SGI-PV: 960897
    SGI-Modid: xfs-linux-melb:xfs-kern:28038a

    Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 2c36ddeda7f04c085d9a612cf8dab5f0a1cd5224
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Sat Feb 10 18:37:33 2007 +1100

    [XFS] Remove unused arguments from the XFS_BTREE_*_ADDR macros.

    It makes it incrementally clearer to read the code when the top of a macro
    spaghetti-pile only receives the 3 arguments it uses, rather than 2 extra
    ones which are not used. Also when you start pulling this thread out of
    the sweater (i.e. remove unused args from XFS_BTREE_*_ADDR), a couple
    other third arms etc fall off too. If they're not used in the macro, then
    they sometimes don't need to be passed to the function calling the macro
    either, etc....

    Patch provided by Eric Sandeen (sandeen@sandeen.net).

    SGI-PV: 960197
    SGI-Modid: xfs-linux-melb:xfs-kern:28037a

    Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 7bc5306d74922d9b14f507e1164d8dd852a98ad3
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Sat Feb 10 18:37:28 2007 +1100

    [XFS] Remove unused header files for MAC and CAP checking functionality.

    xfs_mac.h and xfs_cap.h provide definitions and macros that aren't used
    anywhere in XFS at all. They are left-overs from "to be implement at some
    point in the future" functionality that Irix XFS has. If this
    functionality ever goes into Linux, it will be provided at a different
    layer, most likely through the security hooks in the kernel so we will
    never need this functionality in XFS.

    Patch provided by Eric Sandeen (sandeen@sandeen.net).

    SGI-PV: 960895
    SGI-Modid: xfs-linux-melb:xfs-kern:28036a

    Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 3c0dc77b42cee99c71e913765073888620d442fa
Author: David Chinner <dgc@sgi.com>
Date:   Sat Feb 10 18:37:22 2007 +1100

    [XFS] Make freeze code a little cleaner.

    Fixes a few small issues (mostly cosmetic) that were picked up during the
    review cycle for the last set of freeze path changes.

    SGI-PV: 959267
    SGI-Modid: xfs-linux-melb:xfs-kern:28035a

    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit f7c99b6fc7b3791cd24e0763cd4967d744c164a3
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Sat Feb 10 18:37:16 2007 +1100

    [XFS] Remove unused argument to xfs_bmap_finish

    The firstblock argument to xfs_bmap_finish is not used by that function.
    Remove it and cleanup the code a bit.

    Patch provided by Eric Sandeen.

    SGI-PV: 960196
    SGI-Modid: xfs-linux-melb:xfs-kern:28034a

    Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 39058a0e12a8b2dcb8f9345ecad52dbcfc120ef7
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Sat Feb 10 18:37:10 2007 +1100

    [XFS] Clean up use of VFS attr flags

    Use the the generic VFS attr flags where appropriate instead of open
    coding them to the same values.

    Patch provided by Eric Sandeen.

    SGI-PV: 960868
    SGI-Modid: xfs-linux-melb:xfs-kern:28033a

    Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 4cf3b52080b3d354b10b8b1c9147bf88118b8eef
Author: Ralf Baechle <ralf@linux-mips.org>
Date:   Sat Feb 10 18:37:04 2007 +1100

    [XFS] Remove useless memory barrier

    wake_up's implementation does an implicit memory barrier so the explicit
    memory barrier is not needed in vfs_sync_worker.

    Patch provided by Ralf Baechle.

    SGI-PV: 960867
    SGI-Modid: xfs-linux-melb:xfs-kern:28032a

    Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 3a68cbfe0277fb73d5f0c2a433884745fb500c38
Author: Eric W. Biederman <ebiederm@xmission.com>
Date:   Sat Feb 10 18:36:59 2007 +1100

    [XFS] XFS sysctl cleanups

    Removes unneeded sysctl insert at head behaviour. Cleans up sysctl
    definitions to use C99 initialisers. Patch provided by Eric W. Biederman.

    SGI-PV: 960192
    SGI-Modid: xfs-linux-melb:xfs-kern:28031a

    Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit c167b77d5e172a2deb058be442ca652ad3a417f9
Author: Lachlan McIlroy <lachlan@sgi.com>
Date:   Sat Feb 10 18:36:53 2007 +1100

    [XFS] Fix assertion in xfs_attr_shortform_remove().

    SGI-PV: 960791
    SGI-Modid: xfs-linux-melb:xfs-kern:28021a

    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
    Signed-off-by: Barry Naujok <bnaujok@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 681601613759accffd8e8ddbc6f942eba7ecbfe5
Author: Lachlan McIlroy <lachlan@sgi.com>
Date:   Sat Feb 10 18:36:47 2007 +1100

    [XFS] Fix callers of xfs_iozero() to zero the correct range.

    The problem is the two callers of xfs_iozero() are rounding out the range
    to be zeroed to the end of a fsb and in some cases this extends past the
    new eof. The call to commit_write() in xfs_iozero() will cause the Linux
    inode's file size to be set too high.

    SGI-PV: 960788
    SGI-Modid: xfs-linux-melb:xfs-kern:28013a

    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 2823945fda94e0636be573a037c45cb7b6495af2
Author: David Chinner <dgc@sgi.com>
Date:   Sat Feb 10 18:36:40 2007 +1100

    [XFS] Ensure a frozen filesystem has a clean log before writing the dummy
    record.

    The current Linux XFS freeze code is a mess. We flush the metadata buffers
    out while we are still allowing new transactions to start and then fail to
    flush the dirty buffers back out before writing the unmount and dummy
    records to the log.

    This leads to problems when the frozen filesystem is used for snapshots -
    we do log recovery on a readonly image and often it appears that the log
    image in the snapshot is not correct. Hence we end up with hangs, oops and
    mount failures when trying to mount a snapshot image that has been created
    when the filesystem has not been correctly frozen.

    To fix this, we need to move th metadata flush to after we wait for all
    current transactions to complete in teh second stage of the freeze. This
    means that when we write the final log records, the log should be clean
    and recovery should never occur on a snapshot image created from a frozen
    filesystem.

    SGI-PV: 959267
    SGI-Modid: xfs-linux-melb:xfs-kern:28010a

    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Donald Douwsma <donaldd@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 549054afadae44889c0b40d4c3bfb0207b98d5a0
Author: David Chinner <dgc@sgi.com>
Date:   Sat Feb 10 18:36:35 2007 +1100

    [XFS] Fix sub-block zeroing for buffered writes into unwritten extents.

    When writing less than a filesystem block of data into an unwritten extent
    via buffered I/O, __xfs_get_blocks fails to set the buffer new flag. As a
    result, the generic code will not zero either edge of the block resulting
    in garbage being written to disk either side of the real data. Set the
    buffer new state on bufferd writes to unwritten extents to ensure that
    zeroing occurs.

    SGI-PV: 960328
    SGI-Modid: xfs-linux-melb:xfs-kern:28000a

    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 5478eead8528f6cb5ebe3015fb88b68b175e1093
Author: Lachlan McIlroy <lachlan@sgi.com>
Date:   Sat Feb 10 18:36:29 2007 +1100

    [XFS] Re-initialize the per-cpu superblock counters after recovery.

    After filesystem recovery the superblock is re-read to bring in any
    changes. If the per-cpu superblock counters are not re-initialized from
    the superblock then the next time the per-cpu counters are disabled they
    might overwrite the global counter with a bogus value.

    SGI-PV: 957348
    SGI-Modid: xfs-linux-melb:xfs-kern:27999a

    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit c97be736051dacefb00643095d76fd5b70dfef7b
Author: Kevin Jamieson <kjamieson@bycast.com>
Date:   Sat Feb 10 18:36:23 2007 +1100

    [XFS] Fix block reservation changes for non-SMP systems.

    SGI-PV: 956323
    SGI-Modid: xfs-linux-melb:xfs-kern:27940a

    Signed-off-by: Kevin Jamieson <kjamieson@bycast.com>
    Signed-off-by: David Chatterton <chatz@sgi.com>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit dbcabad19aa91dc9bc7176fd2853fa74f724cd2f
Author: David Chinner <dgc@sgi.com>
Date:   Sat Feb 10 18:36:17 2007 +1100

    [XFS] Fix block reservation mechanism.

    The block reservation mechanism has been broken since the per-cpu
    superblock counters were introduced. Make the block reservation code work
    with the per-cpu counters by syncing the counters, snapshotting the amount
    of available space and then doing a modifcation of the counter state
    according to the result. Continue in a loop until we either have no space
    available or we reserve some space.

    SGI-PV: 956323
    SGI-Modid: xfs-linux-melb:xfs-kern:27895a

    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 20f4ebf2bf2f57c1a9abb3655391336cc90314b3
Author: David Chinner <dgc@sgi.com>
Date:   Sat Feb 10 18:36:10 2007 +1100

    [XFS] Make growfs work for amounts greater than 2TB

    The free block modification code has a 32bit interface, limiting the size
    the filesystem can be grown even on 64 bit machines. On 32 bit machines,
    there are other 32bit variables in transaction structures and interfaces
    that need to be expanded to allow this to work.

    SGI-PV: 959978
    SGI-Modid: xfs-linux-melb:xfs-kern:27894a

    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit f74eaf59b36c0ad01f416b567f89c737bbf82bae
Author: David Chinner <dgc@sgi.com>
Date:   Sat Feb 10 18:36:04 2007 +1100

    [XFS] Fix inode log item use-after-free on forced shutdown

    SGI-PV: 959388
    SGI-Modid: xfs-linux-melb:xfs-kern:27805a

    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit e5889e90dda328443161e9512f1123c9814d03de
Author: Barry Naujok <bnaujok@sgi.com>
Date:   Sat Feb 10 18:35:58 2007 +1100

    [XFS] Fix attr2 corruption with btree data extents

    SGI-PV: 958747
    SGI-Modid: xfs-linux-melb:xfs-kern:27792a

    Signed-off-by: Barry Naujok <bnaujok@sgi.com>
    Signed-off-by: Russell Cattelan <cattelan@thebarn.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 7666ab5fb378678a9d5eb3c0dc8d3170e274e7a4
Author: Vlad Apostolov <vapo@sgi.com>
Date:   Sat Feb 10 18:35:52 2007 +1100

    [XFS] Workaround log space issue by increasing XFS_TRANS_PUSH_AIL_RESTARTS

    SGI-PV: 959264
    SGI-Modid: xfs-linux-melb:xfs-kern:27750a

    Signed-off-by: Vlad Apostolov <vapo@sgi.com>
    Signed-off-by: David Chatterton <chatz@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 5180602e6fd6f7d221e51670567f3809ecfe968f
Author: Lachlan McIlroy <lachlan@sgi.com>
Date:   Sat Feb 10 18:35:46 2007 +1100

    [XFS] remove unused filp from ioctl functions

    SGI-PV: 959140
    SGI-Modid: xfs-linux-melb:xfs-kern:27712a

    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
    Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit a3227fb99675ebcdbe89e6954a85742c0dd11f0a
Author: Lachlan McIlroy <lachlan@sgi.com>
Date:   Sat Feb 10 18:35:40 2007 +1100

    [XFS] mraccessf & mrupdatef are supposed to be the "flags" versions of the
    functions, but they

    a) ignore the flags parameter completely, and b) are never called
    directly, only via the flag-less defines anyway

    So, drop the #define indirection, and rename mraccessf to mraccess, etc.

    SGI-PV: 959138
    SGI-Modid: xfs-linux-melb:xfs-kern:27711a

    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
    Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 1f9b3b64d417a714eb79d9a4cd4927ab304b0fc0
Author: Lachlan McIlroy <lachlan@sgi.com>
Date:   Sat Feb 10 18:35:33 2007 +1100

    [XFS] remove unused xflags parameter from sync routines

    SGI-PV: 959137
    SGI-Modid: xfs-linux-melb:xfs-kern:27710a

    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
    Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 1c91ad3aedba82a64ae06a5a0a5651105d378112
Author: Lachlan McIlroy <lachlan@sgi.com>
Date:   Sat Feb 10 18:35:27 2007 +1100

    [XFS] fix sparse warning in xfs_da_btree.c

    SGI-PV: 954580
    SGI-Modid: xfs-linux-melb:xfs-kern:27702a

    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit e5eb7f202b7a1a2d20a0b9866805314bf6464fd0
Author: Lachlan McIlroy <lachlan@sgi.com>
Date:   Sat Feb 10 18:35:21 2007 +1100

    [XFS] use struct kvec in struct uio

    SGI-PV: 954580
    SGI-Modid: xfs-linux-melb:xfs-kern:27701a

    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 03135cf72621fccab57728f0ba3ab5a551df1cc1
Author: David Chinner <dgc@sgi.com>
Date:   Sat Feb 10 18:35:15 2007 +1100

    [XFS] Fix UP build breakage due to undefined m_icsb_mutex.

    SGI-PV: 952227
    SGI-Modid: xfs-linux-melb:xfs-kern:27692a

    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 20b642858b6bb413976ff13ae6a35cc596967bab
Author: David Chinner <dgc@sgi.com>
Date:   Sat Feb 10 18:35:09 2007 +1100

    [XFS] Reduction global superblock lock contention near ENOSPC.

    The existing per-cpu superblock counter code uses the global superblock
    spin lock when we approach ENOSPC for global synchronisation. On larger
    machines than this code was originally tested on this can still get
    catastrophic spinlock contention due increasing rebalance frequency near
    ENOSPC.

    By introducing a sleeping lock that is used to serialise balances and
    modifications near ENOSPC we prevent contention from needlessly from
    wasting the CPU time of potentially hundreds of CPUs.

    To reduce the number of balances occuring, we separate the need rebalance
    case from the slow allocate case. Now, a counter running dry will trigger
    a rebalance during which counters are disabled. Any thread that sees a
    disabled counter enters a different path where it waits on the new mutex.
    When it gets the new mutex, it checks if the counter is disabled. If the
    counter is disabled, then we _know_ that we have to use the global counter
    and lock and it is safe to do so immediately. Otherwise, we drop the mutex
    and go back to trying the per-cpu counters which we know were re-enabled.

    SGI-PV: 952227
    SGI-Modid: xfs-linux-melb:xfs-kern:27612a

    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 804195b63a6dcb767f5fae43b435067079b52903
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Sat Feb 10 18:35:02 2007 +1100

    [XFS] Get rid of old 5.3/6.1 v1 log items. Cleanup patch sent in by Eric
    Sandeen.

    SGI-PV: 958736
    SGI-Modid: xfs-linux-melb:xfs-kern:27596a

    Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 7989cb8ef5dbc1411d3be48218c7b25ef6e71699
Author: David Chinner <dgc@sgi.com>
Date:   Sat Feb 10 18:34:56 2007 +1100

    [XFS] Keep stack usage down for 4k stacks by using noinline.

    gcc-4.1 and more recent aggressively inline static functions which
    increases XFS stack usage by ~15% in critical paths. Prevent this from
    occurring by adding noinline to the STATIC definition.

    Also uninline some functions that are too large to be inlined and were
    causing problems with CONFIG_FORCED_INLINING=y.

    Finally, clean up all the different users of inline, __inline and
    __inline__ and put them under one STATIC_INLINE macro. For debug kernels
    the STATIC_INLINE macro uninlines those functions.

    SGI-PV: 957159
    SGI-Modid: xfs-linux-melb:xfs-kern:27585a

    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: David Chatterton <chatz@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 5e6a07dfe404cd4d8494d842b54706cb007fa04b
Author: David Chinner <dgc@sgi.com>
Date:   Sat Feb 10 18:34:49 2007 +1100

    [XFS] Current usage of buftarg flags is incorrect.

    The {test,set,clear}_bit() operations take a bit index for the bit to
    operate on. The XBT_* flags are defined as bit fields which is incorrect,
    not to mention the way the bit fields are enumerated is broken too. This
    was only working by chance.

    Fix the definitions of the flags and make the code using them use the
    {test,set,clear}_bit() operations correctly.

    SGI-PV: 958639
    SGI-Modid: xfs-linux-melb:xfs-kern:27565a

    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit dc74eaad8cda9f12a885639b4f2513c99e9b483a
Author: Lachlan McIlroy <lachlan@sgi.com>
Date:   Sat Feb 10 18:34:38 2007 +1100

    [XFS] Prevent buffer overrun in cmn_err().

    The message buffer used by cmn_err() is only 256 bytes and some CXFS
    messages were exceeding this length. Since we were using vsprintf() and
    not checking for buffer overruns we were clobbering memory beyond the
    buffer. The size of the buffer has been increased to 1024 bytes so we can
    capture these larger messages and we are now using vsnprintf() to prevent
    overrunning the buffer size.

    SGI-PV: 958599
    SGI-Modid: xfs-linux-melb:xfs-kern:27561a

    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
    Signed-off-by: Geoffrey Wehrman <gwehrman@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 585e6d8856526a846b90b485abf37ec40e5da1cf
Author: David Chinner <dgc@sgi.com>
Date:   Sat Feb 10 18:32:29 2007 +1100

    [XFS] Fix a synchronous buftarg flush deadlock when freezing.

    At the last stage of a freeze, we flush the buftarg synchronously over and
    over again until it succeeds twice without skipping any buffers.

    The delwri list flush skips pinned buffers, but tries to flush all others.
    It removes the buffers from the delwri list, then tries to lock them one
    at a time as it traverses the list to issue the I/O. It holds them locked
    until we issue all of the I/O and then unlocks them once we've waited for
    it to complete.

    The problem is that during a freeze, the filesystem may still be doing
    stuff - like flushing delalloc data buffers - in the background and hence
    we can be trying to lock buffers that were on the delwri list at the same
    time. Hence we can get ABBA deadlocks between threads doing allocation and
    the buftarg flush (freeze) thread.

    Fix it by skipping locked (and pinned) buffers as we traverse the delwri
    buffer list.

    SGI-PV: 957195
    SGI-Modid: xfs-linux-melb:xfs-kern:27535a

    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit dac61f521b1e4d2c6c48023f2f2743c6096b48ca
Author: David Chinner <dgc@sgi.com>
Date:   Sat Feb 10 18:27:56 2007 +1100

    [XFS] Make quiet mounts quiet

    The XFS quiet mount logic was inverted making quiet mounts noisy and vice
    versa. Fix it.

    SGI-PV: 958469
    SGI-Modid: xfs-linux-melb:xfs-kern:27520a

    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
    Signed-off-by: Tim Shimmin <tes@sgi.com>
