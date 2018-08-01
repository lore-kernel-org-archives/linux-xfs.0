Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:59314 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726105AbeHBAJq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 1 Aug 2018 20:09:46 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 7BA8F4A2
        for <linux-xfs@vger.kernel.org>; Wed,  1 Aug 2018 17:21:44 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs v4.18.0-rc1 released
Message-ID: <d8798aa6-5ba4-00cf-4ecf-c125352f541d@sandeen.net>
Date: Wed, 1 Aug 2018 17:21:47 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

Hi folks,

The for-next and master branches of the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

This time I mean the next part! ;)

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

If you have patches outstanding that you hoped to see in 4.18 please
let me know soon!

The new head of the both branches is commit:

1b816f3 xfsprogs: Release v4.18.0-rc1

xfsprogs-4.18.0-rc1 (01 Aug 2018)
        - xfs_repair: notify user if free inodes are corrupt (Eric Sandeen)
        - xfs_repair: use extent size validation helpers (Darrick Wong)
        - xfs_quota: don't stop the directory tree walk at DEPTH (Kazuya Mio)
        - xfs_scrub: ongoing updates (Darrick Wong)
        - xfs_io: document shutdown -f (Carlos Maiolino)
        - xfs_io: wire up online repair ioctls (Darrick Wong)
        - misc: adddebian initramfs hook to package (Darrick Wong)
        - misc: remove unused macros (Eric Sandeen)
        - misc: remove many XFS_BUF macros (Carlos Maiolino)
        - misc: convert to SPDX license tags (Dave Chinner)

New Commits since v4.17.0:

Brian Foster (6):
      [30c8be8] xfs: create agfl block free helper function
      [d5c1b46] xfs: defer agfl block frees when dfops is available
      [eb94763] xfs: defer agfl block frees from deferred ops processing context
      [3a13f95] xfs: add bmapi nodiscard flag
      [bd04ae3] xfs: don't discard on free of unwritten extents
      [cc5af22] xfs: factor out nodiscard helpers

Carlos Maiolino (6):
      [0433861] Get rid of XFS_BUF_PTR() macro
      [69ac495] Get rid of XFS_BUF_TARGET() macro
      [135e4bf] Get rid of XFS_BUF_COUNT() macro
      [d73a5b9] Get rid of XFS_BUF_SET_COUNT() macro
      [c25e430] xfs: Initialize variables in xfs_alloc_get_rec before using them
      [0d88afd] xfs_io: Document shutdown -f

Darrick J. Wong (50):
      [a65177d] xfs_repair: clear extent size hints when clearing inode core
      [4d5e288] xfs: bmap debugging should never panic the system
      [cfa7d89] xfs: add missing rmap error return
      [9e99501] xfs: refactor XFS_QMOPT_DQNEXT out of existence
      [43cf369] xfs: remove unnecessary xfs_qm_dqattach parameter
      [cd1a0fd] xfs: replace XFS_QMOPT_DQALLOC with a simple boolean
      [5f72838] xfs: add helpers to calculate btree size
      [aa46519] xfs: expose various functions to repair code
      [d264e39] xfs: add repair helpers for the reverse mapping btree
      [43e73fb] xfs: add repair helpers for the reference count btree
      [5f847f1] xfs: add BMAPI_NORMAP flag to perform block remapping without up
      [17d741a] xfs: superblock scrub should use short-lived buffers
      [71a98c6] xfs: hoist xfs_scrub_agfl_walk to libxfs as xfs_agfl_walk
      [26d6a48] xfs: make xfs_bmapi_remapi work with attribute forks
      [36cfb33] xfs: teach xfs_bmapi_remap to accept some bmapi flags
      [5281884] xfs: implement the metadata repair ioctl flag
      [3464dff] xfs: fix inobt magic number check
      [b153fb4] xfs: repair superblocks
      [a531149] xfs: xfs_rtword_t should be unsigned, not signed
      [5e28c9c] xfs: xfs_rtbuf_get should check the bmapi_read results
      [dc1e090] xfs: strengthen rtalloc query range checks
      [858ae33] xfs: fix xfs_rtalloc_rec units
      [1b49337] xfs: don't assert when reporting on-disk corruption while loadin
      [b831204] xfs: remove redundant ASSERT on insufficient bestfree length in 
      [3741f97] xfs: xfs_alloc_get_rec should return EFSCORRUPTED for obvious bn
      [0e64ec0] xfs: btree lookup shouldn't ASSERT on empty btree nodes
      [55fdeb2] xfs: don't ASSERT on short form btree root pointer of zero
      [52581d3] xfs: don't return garbage buffers in xfs_da3_node_read
      [280f5ad] xfs: check directory bestfree information in the verifier
      [efa7ddd] xfs: introduce xfs_btree_debug_check_ptr
      [7ab54cd] xfs: strengthen btree pointer checks before use
      [7cf9f81] xfs: don't assert when on-disk btree pointers are garbage
      [3177b91] xfs: explicitly pass buffer size to xfs_corruption_error
      [a3204ee] xfs: update incore per-AG inode count
      [5b50159] xfs: don't allow insert-range to shift extents past the maximum 
      [a4b61d9] xfs: fix off-by-one error in xfs_rtalloc_query_range
      [2d49506] xfs: fix fdblocks accounting w/ RMAPBT per-AG reservation
      [b123033] libxfs: remove crc32 functions
      [973de64] libfrog: move crc32c code out of libxfs
      [224df90] xfs_scrub: destroy workqueues when erroring out
      [ee310b0] xfs_scrub: schedule and manage optimizations/repairs to the file
      [7a9d1ac] xfs_scrub: allow developers to force repairs
      [b07c2ba] xfs_scrub: don't error out if an optimize-only repair isn't supp
      [06e49f3] xfs_scrub: rename NOFIX_COMPLAIN to be less confusing
      [c3a140f] xfs_scrub: only retry non-permanent repair failures
      [bec810e] xfs_io: wire up repair ioctl stuff
      [db3d080] xfs_repair: use libxfs extsize/cowextsize validation helpers
      [581c24a] misc: use xfs_agfl_walk where appropriate
      [68d1690] misc: clean up MIN/MAX in the utilities
      [900bd62] xfs: add debian initramfs hook to package

Dave Chinner (18):
      [ce50fc0] xfs: make xfs_buf_incore out of line
      [f11d5ed] xfs: adder caller IP to xfs_defer* tracepoints
      [2fdd378] xfs: get rid of the log item descriptor
      [971ce25] xfs: move growfs core to libxfs
      [8a89542] xfs: factor the ag length extension code into libxfs
      [02afaae] xfs: fix error handling in xfs_refcount_insert()
      [2d65306] xfs: verify AGI unlinked list contains valid blocks
      [595add5] xfs: catch bad stripe alignment configurations
      [316d5a9] xfs: verify extent size hint is valid in inode verifier
      [77e17d5] xfs: verify COW extent size hint is valid in inode verifier
      [32b30f1] xfs: push corruption -> ESTALE conversion to xfs_nfs_get_inode()
      [ec29198] xfs: validate btree records on retrieval
      [37b3b4d] xfs: convert to SPDX license tags
      [1727fd1] xfs: move various type verifiers to common file
      [d7ff12b] xfs: clean up MIN/MAX
      [5a59509] xfs: replace do_mod with native operations
      [8ac50ba] xfs: More robust inode extent count validation
      [959ef98] xfsprogs: convert to SPDX license tags

Eric Sandeen (15):
      [160942b] xfs: remove unused flags arg from xfs_dquot_verify
      [c87d912] xfs: check type in quota verifier during quotacheck
      [e1d3178] xfs: pass full xfs_dqblk to repair during quotacheck
      [887223d] xfs: add full xfs_dqblk verifier
      [bf762eb] xfs: print specific dqblk that failed verifiers
      [691fdd7] xfs: implement online get/set fs label
      [b4b56fc] xfs: don't call xfs_da_shrink_inode with NULL bp
      [bf297b1] xfsprogs: Release v4.18.0-rc0
      [206bef9] xfs: properly handle free inodes in extent hint validators
      [30d6292] Merge branch 'libxfs-4.18-sync' into for-next
      [a0d4565] xfsprogs: remove unused macros
      [2e1bf6c] xfs_repair: notify user if free inodes contain errors
      [0724d0f] xfs_repair: clear_dinode should simply clear, not check contents
      [b25c875] misc: remove COPYING from doc/ Makefile
      [1b816f3] xfsprogs: Release v4.18.0-rc1

Jeff Mahoney (1):
      [99a3f52] mkfs: avoid divide-by-zero when hardware reports optimal i/o siz

Kazuya Mio (1):
      [1472d00] xfs_quota: don't stop the directory tree walk when DEPTH is hit


Code Diffstat:

 .gitignore                           |   6 +-
 LICENSES/GPL-2.0                     | 353 +++++++++++++++
 LICENSES/LGPL-2.1                    | 503 +++++++++++++++++++++
 Makefile                             |   1 +
 VERSION                              |   4 +-
 configure.ac                         |   2 +-
 copy/Makefile                        |   2 +-
 copy/xfs_copy.c                      |  24 +-
 copy/xfs_copy.h                      |  14 +-
 db/Makefile                          |   2 +-
 db/addr.c                            |  14 +-
 db/addr.h                            |  14 +-
 db/agf.c                             |  14 +-
 db/agf.h                             |  14 +-
 db/agfl.c                            |  14 +-
 db/agfl.h                            |  14 +-
 db/agi.c                             |  14 +-
 db/agi.h                             |  14 +-
 db/attr.c                            |  14 +-
 db/attr.h                            |  14 +-
 db/attrset.c                         |  14 +-
 db/attrset.h                         |  14 +-
 db/attrshort.c                       |  14 +-
 db/attrshort.h                       |  14 +-
 db/bit.c                             |  14 +-
 db/bit.h                             |  14 +-
 db/block.c                           |  14 +-
 db/block.h                           |  14 +-
 db/bmap.c                            |  14 +-
 db/bmap.h                            |  14 +-
 db/bmroot.c                          |  14 +-
 db/bmroot.h                          |  14 +-
 db/btblock.c                         |  19 +-
 db/btblock.h                         |  14 +-
 db/btdump.c                          |  16 +-
 db/check.c                           |  78 ++--
 db/check.h                           |  14 +-
 db/command.c                         |  14 +-
 db/command.h                         |  14 +-
 db/convert.c                         |  14 +-
 db/convert.h                         |  14 +-
 db/crc.c                             |  13 +-
 db/crc.h                             |  13 +-
 db/debug.c                           |  14 +-
 db/debug.h                           |  14 +-
 db/dir2.c                            |  14 +-
 db/dir2.h                            |  14 +-
 db/dir2sf.c                          |  14 +-
 db/dir2sf.h                          |  14 +-
 db/dquot.c                           |  14 +-
 db/dquot.h                           |  14 +-
 db/echo.c                            |  14 +-
 db/echo.h                            |  14 +-
 db/faddr.c                           |  14 +-
 db/faddr.h                           |  14 +-
 db/field.c                           |  14 +-
 db/field.h                           |  14 +-
 db/flist.c                           |  14 +-
 db/flist.h                           |   1 +
 db/fprint.c                          |  14 +-
 db/fprint.h                          |  14 +-
 db/frag.c                            |  14 +-
 db/frag.h                            |  14 +-
 db/freesp.c                          |  45 +-
 db/freesp.h                          |  14 +-
 db/fsmap.c                           |  16 +-
 db/fsmap.h                           |  16 +-
 db/fuzz.c                            |  14 +-
 db/fuzz.h                            |  16 +-
 db/hash.c                            |  14 +-
 db/hash.h                            |  14 +-
 db/help.c                            |  14 +-
 db/help.h                            |  14 +-
 db/info.c                            |  16 +-
 db/init.c                            |  14 +-
 db/init.h                            |  14 +-
 db/inode.c                           |  14 +-
 db/inode.h                           |  14 +-
 db/input.c                           |  14 +-
 db/input.h                           |  14 +-
 db/io.c                              |  14 +-
 db/io.h                              |  14 +-
 db/logformat.c                       |  14 +-
 db/logformat.h                       |  14 +-
 db/malloc.c                          |  14 +-
 db/malloc.h                          |  14 +-
 db/metadump.c                        |  22 +-
 db/metadump.h                        |  14 +-
 db/output.c                          |  14 +-
 db/output.h                          |  14 +-
 db/print.c                           |  14 +-
 db/print.h                           |  14 +-
 db/quit.c                            |  14 +-
 db/quit.h                            |  14 +-
 db/sb.c                              |  14 +-
 db/sb.h                              |  14 +-
 db/sig.c                             |  14 +-
 db/sig.h                             |  14 +-
 db/strvec.c                          |  14 +-
 db/strvec.h                          |  14 +-
 db/symlink.c                         |  15 +-
 db/symlink.h                         |  14 +-
 db/text.c                            |  14 +-
 db/text.h                            |  14 +-
 db/type.c                            |  14 +-
 db/type.h                            |  14 +-
 db/write.c                           |  14 +-
 db/write.h                           |  14 +-
 db/xfs_admin.sh                      |   1 +
 db/xfs_metadump.sh                   |   1 +
 db/xfs_ncheck.sh                     |   1 +
 debian/Makefile                      |   2 +-
 debian/changelog                     |  13 +
 debian/local/initramfs.hook          |  52 +++
 debian/rules                         |   1 +
 doc/CHANGES                          |  15 +
 doc/COPYING                          | 854 -----------------------------------
 doc/Makefile                         |   6 +-
 estimate/Makefile                    |   2 +-
 estimate/xfs_estimate.c              |  15 +-
 fsck/Makefile                        |   2 +-
 fsr/Makefile                         |   2 +-
 fsr/xfs_fsr.c                        |  18 +-
 growfs/Makefile                      |   2 +-
 growfs/xfs_growfs.c                  |  14 +-
 include/Makefile                     |  14 +-
 include/atomic.h                     |  14 +-
 include/avl64.h                      |  14 +-
 include/bitops.h                     |   1 +
 include/builddefs.in                 |  14 +-
 include/buildmacros                  |   2 +-
 include/buildrules                   |   2 +-
 include/cache.h                      |  14 +-
 include/command.h                    |  14 +-
 include/convert.h                    |  14 +-
 include/crc32c.h                     |  11 +
 include/darwin.h                     |  14 +-
 include/freebsd.h                    |  14 +-
 include/fsgeom.h                     |  17 +-
 include/gnukfreebsd.h                |  14 +-
 include/handle.h                     |  14 +-
 include/hlist.h                      |  14 +-
 include/input.h                      |  14 +-
 include/install-sh                   |   2 +-
 include/jdm.h                        |  14 +-
 include/kmem.h                       |  14 +-
 include/libfrog.h                    |  14 +-
 include/libxcmd.h                    |  14 +-
 include/libxfs.h                     |  17 +-
 include/libxlog.h                    |  14 +-
 include/linux.h                      |  14 +-
 include/list.h                       |  14 +-
 include/parent.h                     |  14 +-
 include/path.h                       |  14 +-
 include/platform_defs.h.in           |  16 +-
 include/project.h                    |  14 +-
 include/ptvar.h                      |  16 +-
 include/radix-tree.h                 |  15 +-
 include/workqueue.h                  |  18 +-
 include/xfs.h                        |  30 +-
 include/xfs_arch.h                   |  14 +-
 include/xfs_btree_trace.h            |  14 +-
 include/xfs_inode.h                  |  14 +-
 include/xfs_log_recover.h            |  14 +-
 include/xfs_metadump.h               |  14 +-
 include/xfs_mount.h                  |  14 +-
 include/xfs_multidisk.h              |  14 +-
 include/xfs_trace.h                  |  32 +-
 include/xfs_trans.h                  |  23 +-
 include/xqm.h                        |  14 +-
 io/Makefile                          |   2 +-
 io/attr.c                            |  14 +-
 io/bmap.c                            |  14 +-
 io/copy_file_range.c                 |  15 +-
 io/cowextsize.c                      |  16 +-
 io/encrypt.c                         |  15 +-
 io/fadvise.c                         |  14 +-
 io/fiemap.c                          |  14 +-
 io/file.c                            |  14 +-
 io/freeze.c                          |  14 +-
 io/fsmap.c                           |  16 +-
 io/fsync.c                           |  14 +-
 io/getrusage.c                       |  14 +-
 io/imap.c                            |  14 +-
 io/init.c                            |  15 +-
 io/init.h                            |  14 +-
 io/inject.c                          |  15 +-
 io/io.h                              |  15 +-
 io/label.c                           |  17 +-
 io/link.c                            |  14 +-
 io/log_writes.c                      |  14 +-
 io/madvise.c                         |  14 +-
 io/mincore.c                         |  14 +-
 io/mmap.c                            |  14 +-
 io/open.c                            |  14 +-
 io/parent.c                          |  14 +-
 io/pread.c                           |  14 +-
 io/prealloc.c                        |  14 +-
 io/pwrite.c                          |  14 +-
 io/readdir.c                         |  14 +-
 io/reflink.c                         |  14 +-
 io/resblks.c                         |  14 +-
 io/scrub.c                           | 112 ++++-
 io/seek.c                            |  14 +-
 io/sendfile.c                        |  14 +-
 io/shutdown.c                        |  31 +-
 io/stat.c                            |  15 +-
 io/statx.h                           |   2 +
 io/swapext.c                         |  14 +-
 io/sync.c                            |  14 +-
 io/sync_file_range.c                 |  14 +-
 io/truncate.c                        |  14 +-
 io/utimes.c                          |  14 +-
 io/xfs_bmap.sh                       |   2 +-
 io/xfs_freeze.sh                     |   2 +-
 io/xfs_mkfile.sh                     |   2 +-
 libfrog/Makefile                     |  29 +-
 libfrog/avl64.c                      |  14 +-
 libfrog/convert.c                    |  14 +-
 {libxfs => libfrog}/crc32.c          | 379 +++++-----------
 {libxfs => libfrog}/crc32defs.h      |  58 +--
 libfrog/darwin.c                     |  14 +-
 libfrog/freebsd.c                    |  14 +-
 libfrog/fsgeom.c                     |  17 +-
 {libxfs => libfrog}/gen_crc32table.c |  65 +--
 libfrog/irix.c                       |  14 +-
 libfrog/linux.c                      |  14 +-
 libfrog/paths.c                      |  14 +-
 libfrog/projects.c                   |  14 +-
 libfrog/ptvar.c                      |  16 +-
 libfrog/radix-tree.c                 |  15 +-
 libfrog/topology.c                   |  14 +-
 libfrog/util.c                       |  14 +-
 libfrog/workqueue.c                  |  19 +-
 libhandle/Makefile                   |   2 +-
 libhandle/handle.c                   |  14 +-
 libhandle/jdm.c                      |  14 +-
 libxcmd/Makefile                     |   2 +-
 libxcmd/command.c                    |  14 +-
 libxcmd/help.c                       |  14 +-
 libxcmd/input.c                      |  14 +-
 libxcmd/quit.c                       |  14 +-
 libxfs/Makefile                      |  31 +-
 libxfs/cache.c                       |  14 +-
 libxfs/defer_item.c                  |  16 +-
 libxfs/init.c                        |  18 +-
 libxfs/init.h                        |  14 +-
 libxfs/kmem.c                        |   1 +
 libxfs/libxfs_api_defs.h             |  22 +-
 libxfs/libxfs_io.h                   |  18 +-
 libxfs/libxfs_priv.h                 |  76 ++--
 libxfs/logitem.c                     |  34 +-
 libxfs/rdwr.c                        |  32 +-
 libxfs/trans.c                       |  74 +--
 libxfs/util.c                        |  32 +-
 libxfs/xfs_ag.c                      | 465 +++++++++++++++++++
 libxfs/xfs_ag.h                      |  30 ++
 libxfs/xfs_ag_resv.c                 |  47 +-
 libxfs/xfs_ag_resv.h                 |  16 +-
 libxfs/xfs_alloc.c                   | 225 +++++----
 libxfs/xfs_alloc.h                   |  41 +-
 libxfs/xfs_alloc_btree.c             |  24 +-
 libxfs/xfs_alloc_btree.h             |  16 +-
 libxfs/xfs_attr.c                    |  18 +-
 libxfs/xfs_attr_leaf.c               |  21 +-
 libxfs/xfs_attr_leaf.h               |  14 +-
 libxfs/xfs_attr_remote.c             |  16 +-
 libxfs/xfs_attr_remote.h             |  14 +-
 libxfs/xfs_attr_sf.h                 |  14 +-
 libxfs/xfs_bit.c                     |  14 +-
 libxfs/xfs_bit.h                     |  14 +-
 libxfs/xfs_bmap.c                    | 172 ++++---
 libxfs/xfs_bmap.h                    |  46 +-
 libxfs/xfs_bmap_btree.c              |  23 +-
 libxfs/xfs_bmap_btree.h              |  17 +-
 libxfs/xfs_btree.c                   | 196 ++++----
 libxfs/xfs_btree.h                   |  17 +-
 libxfs/xfs_cksum.h                   |   1 +
 libxfs/xfs_da_btree.c                |  24 +-
 libxfs/xfs_da_btree.h                |  14 +-
 libxfs/xfs_da_format.c               |  14 +-
 libxfs/xfs_da_format.h               |  14 +-
 libxfs/xfs_defer.c                   |  40 +-
 libxfs/xfs_defer.h                   |  17 +-
 libxfs/xfs_dir2.c                    |  14 +-
 libxfs/xfs_dir2.h                    |  14 +-
 libxfs/xfs_dir2_block.c              |  22 +-
 libxfs/xfs_dir2_data.c               | 122 +++--
 libxfs/xfs_dir2_leaf.c               |  26 +-
 libxfs/xfs_dir2_node.c               |  17 +-
 libxfs/xfs_dir2_priv.h               |  14 +-
 libxfs/xfs_dir2_sf.c                 |  14 +-
 libxfs/xfs_dquot_buf.c               | 108 ++---
 libxfs/xfs_errortag.h                |  19 +-
 libxfs/xfs_format.h                  |  26 +-
 libxfs/xfs_fs.h                      |  23 +-
 libxfs/xfs_ialloc.c                  | 162 ++-----
 libxfs/xfs_ialloc.h                  |  24 +-
 libxfs/xfs_ialloc_btree.c            |  25 +-
 libxfs/xfs_ialloc_btree.h            |  16 +-
 libxfs/xfs_iext_tree.c               |  10 +-
 libxfs/xfs_inode_buf.c               | 116 +++--
 libxfs/xfs_inode_buf.h               |  14 +-
 libxfs/xfs_inode_fork.c              |  14 +-
 libxfs/xfs_inode_fork.h              |  14 +-
 libxfs/xfs_log_format.h              |  14 +-
 libxfs/xfs_log_rlimit.c              |  14 +-
 libxfs/xfs_quota_defs.h              |  23 +-
 libxfs/xfs_refcount.c                |  87 +++-
 libxfs/xfs_refcount.h                |  23 +-
 libxfs/xfs_refcount_btree.c          |  17 +-
 libxfs/xfs_refcount_btree.h          |  16 +-
 libxfs/xfs_rmap.c                    | 138 +++++-
 libxfs/xfs_rmap.h                    |  20 +-
 libxfs/xfs_rmap_btree.c              |  15 +-
 libxfs/xfs_rmap_btree.h              |  14 +-
 libxfs/xfs_rtbitmap.c                |  52 +--
 libxfs/xfs_sb.c                      | 181 +++++++-
 libxfs/xfs_sb.h                      |  30 +-
 libxfs/xfs_shared.h                  |  30 +-
 libxfs/xfs_symlink_remote.c          |  14 +-
 libxfs/xfs_trans_resv.c              |  30 +-
 libxfs/xfs_trans_resv.h              |  14 +-
 libxfs/xfs_trans_space.h             |  14 +-
 libxfs/xfs_types.c                   | 173 +++++++
 libxfs/xfs_types.h                   |  35 +-
 libxlog/Makefile                     |   2 +-
 libxlog/util.c                       |  14 +-
 libxlog/xfs_log_recover.c            |  18 +-
 logprint/Makefile                    |   2 +-
 logprint/log_copy.c                  |  14 +-
 logprint/log_dump.c                  |  14 +-
 logprint/log_misc.c                  |  26 +-
 logprint/log_print_all.c             |  18 +-
 logprint/log_print_trans.c           |  14 +-
 logprint/log_redo.c                  |  22 +-
 logprint/logprint.c                  |  14 +-
 logprint/logprint.h                  |  14 +-
 m4/Makefile                          |   2 +-
 man/Makefile                         |   2 +-
 man/man2/ioctl_xfs_scrub_metadata.2  |  19 +-
 man/man5/xfs.5                       |   2 +-
 man/man8/xfs_io.8                    |  26 +-
 man/man8/xfs_scrub.8                 |  38 +-
 mdrestore/Makefile                   |   2 +-
 mdrestore/xfs_mdrestore.c            |  14 +-
 mkfs/Makefile                        |   2 +-
 mkfs/proto.c                         |  22 +-
 mkfs/xfs_mkfs.c                      |  63 ++-
 po/Makefile                          |   2 +-
 quota/Makefile                       |   2 +-
 quota/darwin.c                       |  14 +-
 quota/edit.c                         |  14 +-
 quota/free.c                         |  14 +-
 quota/freebsd.c                      |  14 +-
 quota/init.c                         |  14 +-
 quota/init.h                         |  14 +-
 quota/irix.c                         |  14 +-
 quota/linux.c                        |  14 +-
 quota/path.c                         |  14 +-
 quota/project.c                      |  20 +-
 quota/quot.c                         |  14 +-
 quota/quota.c                        |  14 +-
 quota/quota.h                        |  14 +-
 quota/report.c                       |  14 +-
 quota/state.c                        |  14 +-
 quota/util.c                         |  16 +-
 repair/Makefile                      |   2 +-
 repair/README                        |   2 +
 repair/agheader.c                    |  20 +-
 repair/agheader.h                    |  14 +-
 repair/attr_repair.c                 |  19 +-
 repair/attr_repair.h                 |  14 +-
 repair/avl.c                         |  14 +-
 repair/avl.h                         |  14 +-
 repair/bmap.c                        |  16 +-
 repair/bmap.h                        |  14 +-
 repair/btree.c                       |  18 +-
 repair/btree.h                       |  14 +-
 repair/da_util.c                     |  13 +-
 repair/da_util.h                     |  14 +-
 repair/dino_chunks.c                 |  16 +-
 repair/dinode.c                      | 280 +++---------
 repair/dinode.h                      |  14 +-
 repair/dir2.c                        |  14 +-
 repair/dir2.h                        |  14 +-
 repair/err_protos.h                  |  14 +-
 repair/globals.c                     |  14 +-
 repair/globals.h                     |  14 +-
 repair/incore.c                      |  18 +-
 repair/incore.h                      |  16 +-
 repair/incore_bmc.c                  |  14 +-
 repair/incore_ext.c                  |  22 +-
 repair/incore_ino.c                  |  16 +-
 repair/init.c                        |  14 +-
 repair/phase1.c                      |  14 +-
 repair/phase2.c                      |  14 +-
 repair/phase3.c                      |  14 +-
 repair/phase4.c                      |  14 +-
 repair/phase5.c                      |  14 +-
 repair/phase6.c                      |  18 +-
 repair/phase7.c                      |  14 +-
 repair/prefetch.c                    |   8 +-
 repair/prefetch.h                    |   2 +
 repair/progress.c                    |   1 +
 repair/progress.h                    |   2 +
 repair/protos.h                      |  14 +-
 repair/rmap.c                        |  16 +-
 repair/rmap.h                        |  16 +-
 repair/rt.c                          |  14 +-
 repair/rt.h                          |  14 +-
 repair/sb.c                          |  14 +-
 repair/scan.c                        |  82 ++--
 repair/scan.h                        |  14 +-
 repair/slab.c                        |  17 +-
 repair/slab.h                        |  16 +-
 repair/threads.c                     |   2 +
 repair/threads.h                     |   2 +
 repair/versions.c                    |  14 +-
 repair/versions.h                    |  14 +-
 repair/xfs_repair.c                  |  24 +-
 rtcp/Makefile                        |   2 +-
 rtcp/xfs_rtcp.c                      |  14 +-
 scrub/Makefile                       |   4 +-
 scrub/bitmap.c                       |  16 +-
 scrub/bitmap.h                       |  16 +-
 scrub/common.c                       |  16 +-
 scrub/common.h                       |  16 +-
 scrub/counter.c                      |  16 +-
 scrub/counter.h                      |  16 +-
 scrub/disk.c                         |  16 +-
 scrub/disk.h                         |  16 +-
 scrub/filemap.c                      |  16 +-
 scrub/filemap.h                      |  16 +-
 scrub/fscounters.c                   |  16 +-
 scrub/fscounters.h                   |  16 +-
 scrub/inodes.c                       |  16 +-
 scrub/inodes.h                       |  16 +-
 scrub/phase1.c                       |  23 +-
 scrub/phase2.c                       |  77 +++-
 scrub/phase3.c                       |  58 +--
 scrub/phase4.c                       |  92 +++-
 scrub/phase5.c                       |  16 +-
 scrub/phase6.c                       |  16 +-
 scrub/phase7.c                       |  16 +-
 scrub/progress.c                     |  16 +-
 scrub/progress.h                     |  16 +-
 scrub/read_verify.c                  |  16 +-
 scrub/read_verify.h                  |  16 +-
 scrub/repair.c                       | 286 ++++++++++++
 scrub/repair.h                       |  42 ++
 scrub/scrub.c                        | 198 +++++---
 scrub/scrub.h                        |  60 ++-
 scrub/spacemap.c                     |  16 +-
 scrub/spacemap.h                     |  16 +-
 scrub/unicrash.c                     |  16 +-
 scrub/unicrash.h                     |  16 +-
 scrub/vfs.c                          |  20 +-
 scrub/vfs.h                          |  16 +-
 scrub/xfs_scrub.c                    |  60 ++-
 scrub/xfs_scrub.h                    |  17 +-
 scrub/xfs_scrub_all.in               |  19 +-
 spaceman/Makefile                    |   2 +-
 spaceman/file.c                      |  14 +-
 spaceman/freesp.c                    |  14 +-
 spaceman/info.c                      |  16 +-
 spaceman/init.c                      |  14 +-
 spaceman/init.h                      |  14 +-
 spaceman/prealloc.c                  |  14 +-
 spaceman/space.h                     |  14 +-
 spaceman/trim.c                      |  14 +-
 spaceman/xfs_info.sh                 |   1 +
 tools/find-api-violations.sh         |   1 +
 tools/libxfs-apply                   |   1 +
 tools/libxfs-diff                    |   1 +
 tools/xfsbuflock.py                  |  19 +-
 476 files changed, 4657 insertions(+), 7822 deletions(-)
 create mode 100644 LICENSES/GPL-2.0
 create mode 100644 LICENSES/LGPL-2.1
 create mode 100644 debian/local/initramfs.hook
 delete mode 100644 doc/COPYING
 create mode 100644 include/crc32c.h
 mode change 100755 => 100644 io/utimes.c
 rename {libxfs => libfrog}/crc32.c (76%)
 rename {libxfs => libfrog}/crc32defs.h (57%)
 rename {libxfs => libfrog}/gen_crc32table.c (54%)
 create mode 100644 libxfs/xfs_ag.c
 create mode 100644 libxfs/xfs_ag.h
 create mode 100644 libxfs/xfs_types.c
 create mode 100644 scrub/repair.c
 create mode 100644 scrub/repair.h
