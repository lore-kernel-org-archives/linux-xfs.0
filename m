Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:51780 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754072AbeFTDXr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Jun 2018 23:23:47 -0400
Date: Wed, 20 Jun 2018 13:23:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [GIT PULL] xfsprogs: SPDX tag conversion
Message-ID: <20180620032343.GM19934@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: sandeen@sandeen.net, esandeen@redhat.com

Hi Eric,

Can you please pull the branch below with the xfsprogs repository
SPDX tag conversion in it? It is based on te libxfs-4.18-sync branch
of the upstream repo. The change is too big for the mailing list,
and is mostly scripted. The process and scripts are in the commit
message, and matches what I've done for the kernel code and
xfstests.

Cheers,

Dave.

The following changes since commit e05de95096511e8d63dd0648435d88265a2231c3:

  xfs: fix error handling in xfs_refcount_insert() (2018-06-07 14:54:17 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dgc/xfsprogs-dev spdx-tags

for you to fetch changes up to 2d86556ec32e49442557acf87d4beb11b603cb76:

  xfsprogs: convert to SPDX license tags (2018-06-20 13:17:45 +1000)

----------------------------------------------------------------
Dave Chinner (1):
      xfsprogs: convert to SPDX license tags

 LICENSES/GPL-2.0                    | 353 +++++++++++++++
 LICENSES/LGPL-2.1                   | 503 +++++++++++++++++++++
 Makefile                            |   1 +
 copy/Makefile                       |   2 +-
 copy/xfs_copy.c                     |  14 +-
 copy/xfs_copy.h                     |  14 +-
 db/Makefile                         |   2 +-
 db/addr.c                           |  14 +-
 db/addr.h                           |  14 +-
 db/agf.c                            |  14 +-
 db/agf.h                            |  14 +-
 db/agfl.c                           |  14 +-
 db/agfl.h                           |  14 +-
 db/agi.c                            |  14 +-
 db/agi.h                            |  14 +-
 db/attr.c                           |  14 +-
 db/attr.h                           |  14 +-
 db/attrset.c                        |  14 +-
 db/attrset.h                        |  14 +-
 db/attrshort.c                      |  14 +-
 db/attrshort.h                      |  14 +-
 db/bit.c                            |  14 +-
 db/bit.h                            |  14 +-
 db/block.c                          |  14 +-
 db/block.h                          |  14 +-
 db/bmap.c                           |  14 +-
 db/bmap.h                           |  14 +-
 db/bmroot.c                         |  14 +-
 db/bmroot.h                         |  14 +-
 db/btblock.c                        |  14 +-
 db/btblock.h                        |  14 +-
 db/btdump.c                         |  16 +-
 db/check.c                          |  14 +-
 db/check.h                          |  14 +-
 db/command.c                        |  14 +-
 db/command.h                        |  14 +-
 db/convert.c                        |  14 +-
 db/convert.h                        |  14 +-
 db/crc.c                            |  13 +-
 db/crc.h                            |  13 +-
 db/debug.c                          |  14 +-
 db/debug.h                          |  14 +-
 db/dir2.c                           |  14 +-
 db/dir2.h                           |  14 +-
 db/dir2sf.c                         |  14 +-
 db/dir2sf.h                         |  14 +-
 db/dquot.c                          |  14 +-
 db/dquot.h                          |  14 +-
 db/echo.c                           |  14 +-
 db/echo.h                           |  14 +-
 db/faddr.c                          |  14 +-
 db/faddr.h                          |  14 +-
 db/field.c                          |  14 +-
 db/field.h                          |  14 +-
 db/flist.c                          |  14 +-
 db/flist.h                          |   1 +
 db/fprint.c                         |  14 +-
 db/fprint.h                         |  14 +-
 db/frag.c                           |  14 +-
 db/frag.h                           |  14 +-
 db/freesp.c                         |  14 +-
 db/freesp.h                         |  14 +-
 db/fsmap.c                          |  16 +-
 db/fsmap.h                          |  16 +-
 db/fuzz.c                           |  14 +-
 db/fuzz.h                           |  16 +-
 db/hash.c                           |  14 +-
 db/hash.h                           |  14 +-
 db/help.c                           |  14 +-
 db/help.h                           |  14 +-
 db/info.c                           |  16 +-
 db/init.c                           |  14 +-
 db/init.h                           |  14 +-
 db/inode.c                          |  14 +-
 db/inode.h                          |  14 +-
 db/input.c                          |  14 +-
 db/input.h                          |  14 +-
 db/io.c                             |  14 +-
 db/io.h                             |  14 +-
 db/logformat.c                      |  14 +-
 db/logformat.h                      |  14 +-
 db/malloc.c                         |  14 +-
 db/malloc.h                         |  14 +-
 db/metadump.c                       |  14 +-
 db/metadump.h                       |  14 +-
 db/output.c                         |  14 +-
 db/output.h                         |  14 +-
 db/print.c                          |  14 +-
 db/print.h                          |  14 +-
 db/quit.c                           |  14 +-
 db/quit.h                           |  14 +-
 db/sb.c                             |  14 +-
 db/sb.h                             |  14 +-
 db/sig.c                            |  14 +-
 db/sig.h                            |  14 +-
 db/strvec.c                         |  14 +-
 db/strvec.h                         |  14 +-
 db/symlink.c                        |  14 +-
 db/symlink.h                        |  14 +-
 db/text.c                           |  14 +-
 db/text.h                           |  14 +-
 db/type.c                           |  14 +-
 db/type.h                           |  14 +-
 db/write.c                          |  14 +-
 db/write.h                          |  14 +-
 db/xfs_admin.sh                     |   1 +
 db/xfs_metadump.sh                  |   1 +
 db/xfs_ncheck.sh                    |   1 +
 debian/Makefile                     |   2 +-
 doc/COPYING                         | 854 ------------------------------------
 doc/Makefile                        |   2 +-
 estimate/Makefile                   |   2 +-
 estimate/xfs_estimate.c             |  14 +-
 fsck/Makefile                       |   2 +-
 fsr/Makefile                        |   2 +-
 fsr/xfs_fsr.c                       |  14 +-
 growfs/Makefile                     |   2 +-
 growfs/xfs_growfs.c                 |  14 +-
 include/Makefile                    |  14 +-
 include/atomic.h                    |  14 +-
 include/avl64.h                     |  14 +-
 include/bitops.h                    |   1 +
 include/builddefs.in                |  14 +-
 include/buildmacros                 |   2 +-
 include/buildrules                  |   2 +-
 include/cache.h                     |  14 +-
 include/command.h                   |  14 +-
 include/convert.h                   |  14 +-
 include/darwin.h                    |  14 +-
 include/freebsd.h                   |  14 +-
 include/fsgeom.h                    |  17 +-
 include/gnukfreebsd.h               |  14 +-
 include/handle.h                    |  14 +-
 include/hlist.h                     |  14 +-
 include/input.h                     |  14 +-
 include/install-sh                  |   2 +-
 include/jdm.h                       |  14 +-
 include/kmem.h                      |  14 +-
 include/libfrog.h                   |  14 +-
 include/libxcmd.h                   |  14 +-
 include/libxfs.h                    |  14 +-
 include/libxlog.h                   |  14 +-
 include/linux.h                     |  14 +-
 include/list.h                      |  14 +-
 include/parent.h                    |  14 +-
 include/path.h                      |  14 +-
 include/platform_defs.h.in          |  16 +-
 include/project.h                   |  14 +-
 include/ptvar.h                     |  16 +-
 include/radix-tree.h                |  15 +-
 include/workqueue.h                 |  18 +-
 include/xfs.h                       |  30 +-
 include/xfs_arch.h                  |  14 +-
 include/xfs_btree_trace.h           |  14 +-
 include/xfs_inode.h                 |  14 +-
 include/xfs_log_recover.h           |  14 +-
 include/xfs_metadump.h              |  14 +-
 include/xfs_mount.h                 |  14 +-
 include/xfs_multidisk.h             |  14 +-
 include/xfs_trace.h                 |  14 +-
 include/xfs_trans.h                 |  14 +-
 include/xqm.h                       |  14 +-
 io/Makefile                         |   2 +-
 io/attr.c                           |  14 +-
 io/bmap.c                           |  14 +-
 io/copy_file_range.c                |  15 +-
 io/cowextsize.c                     |  16 +-
 io/encrypt.c                        |  15 +-
 io/fadvise.c                        |  14 +-
 io/fiemap.c                         |  14 +-
 io/file.c                           |  14 +-
 io/freeze.c                         |  14 +-
 io/fsmap.c                          |  16 +-
 io/fsync.c                          |  14 +-
 io/getrusage.c                      |  14 +-
 io/imap.c                           |  14 +-
 io/init.c                           |  14 +-
 io/init.h                           |  14 +-
 io/inject.c                         |  14 +-
 io/io.h                             |  14 +-
 io/label.c                          |  17 +-
 io/link.c                           |  14 +-
 io/log_writes.c                     |  14 +-
 io/madvise.c                        |  14 +-
 io/mincore.c                        |  14 +-
 io/mmap.c                           |  14 +-
 io/open.c                           |  14 +-
 io/parent.c                         |  14 +-
 io/pread.c                          |  14 +-
 io/prealloc.c                       |  14 +-
 io/pwrite.c                         |  14 +-
 io/readdir.c                        |  14 +-
 io/reflink.c                        |  14 +-
 io/resblks.c                        |  14 +-
 io/scrub.c                          |  15 +-
 io/seek.c                           |  14 +-
 io/sendfile.c                       |  14 +-
 io/shutdown.c                       |  14 +-
 io/stat.c                           |  15 +-
 io/statx.h                          |   2 +
 io/swapext.c                        |  14 +-
 io/sync.c                           |  14 +-
 io/sync_file_range.c                |  14 +-
 io/truncate.c                       |  14 +-
 io/utimes.c                         |  14 +-
 io/xfs_bmap.sh                      |   2 +-
 io/xfs_freeze.sh                    |   2 +-
 io/xfs_mkfile.sh                    |   2 +-
 libfrog/Makefile                    |   2 +-
 libfrog/avl64.c                     |  14 +-
 libfrog/convert.c                   |  14 +-
 libfrog/darwin.c                    |  14 +-
 libfrog/freebsd.c                   |  14 +-
 libfrog/fsgeom.c                    |  17 +-
 libfrog/irix.c                      |  14 +-
 libfrog/linux.c                     |  14 +-
 libfrog/paths.c                     |  14 +-
 libfrog/projects.c                  |  14 +-
 libfrog/ptvar.c                     |  16 +-
 libfrog/radix-tree.c                |  15 +-
 libfrog/topology.c                  |  14 +-
 libfrog/util.c                      |  14 +-
 libfrog/workqueue.c                 |  19 +-
 libhandle/Makefile                  |   2 +-
 libhandle/handle.c                  |  14 +-
 libhandle/jdm.c                     |  14 +-
 libxcmd/Makefile                    |   2 +-
 libxcmd/command.c                   |  14 +-
 libxcmd/help.c                      |  14 +-
 libxcmd/input.c                     |  14 +-
 libxcmd/quit.c                      |  14 +-
 libxfs/Makefile                     |   2 +-
 libxfs/cache.c                      |  14 +-
 libxfs/crc32.c                      |   6 +-
 libxfs/crc32defs.h                  |   1 +
 libxfs/defer_item.c                 |  16 +-
 libxfs/gen_crc32table.c             |   1 +
 libxfs/init.c                       |  14 +-
 libxfs/init.h                       |  14 +-
 libxfs/kmem.c                       |   1 +
 libxfs/libxfs_api_defs.h            |  14 +-
 libxfs/libxfs_io.h                  |  14 +-
 libxfs/libxfs_priv.h                |  14 +-
 libxfs/logitem.c                    |  14 +-
 libxfs/rdwr.c                       |  14 +-
 libxfs/trans.c                      |  14 +-
 libxfs/util.c                       |  14 +-
 libxfs/xfs_ag_resv.c                |  16 +-
 libxfs/xfs_ag_resv.h                |  16 +-
 libxfs/xfs_alloc.c                  |  14 +-
 libxfs/xfs_alloc.h                  |  14 +-
 libxfs/xfs_alloc_btree.c            |  14 +-
 libxfs/xfs_alloc_btree.h            |  14 +-
 libxfs/xfs_attr.c                   |  14 +-
 libxfs/xfs_attr_leaf.c              |  14 +-
 libxfs/xfs_attr_leaf.h              |  14 +-
 libxfs/xfs_attr_remote.c            |  14 +-
 libxfs/xfs_attr_remote.h            |  14 +-
 libxfs/xfs_attr_sf.h                |  14 +-
 libxfs/xfs_bit.c                    |  14 +-
 libxfs/xfs_bit.h                    |  14 +-
 libxfs/xfs_bmap.c                   |  14 +-
 libxfs/xfs_bmap.h                   |  14 +-
 libxfs/xfs_bmap_btree.c             |  14 +-
 libxfs/xfs_bmap_btree.h             |  14 +-
 libxfs/xfs_btree.c                  |  14 +-
 libxfs/xfs_btree.h                  |  14 +-
 libxfs/xfs_cksum.h                  |   1 +
 libxfs/xfs_da_btree.c               |  14 +-
 libxfs/xfs_da_btree.h               |  14 +-
 libxfs/xfs_da_format.c              |  14 +-
 libxfs/xfs_da_format.h              |  14 +-
 libxfs/xfs_defer.c                  |  16 +-
 libxfs/xfs_defer.h                  |  16 +-
 libxfs/xfs_dir2.c                   |  14 +-
 libxfs/xfs_dir2.h                   |  14 +-
 libxfs/xfs_dir2_block.c             |  14 +-
 libxfs/xfs_dir2_data.c              |  14 +-
 libxfs/xfs_dir2_leaf.c              |  14 +-
 libxfs/xfs_dir2_node.c              |  14 +-
 libxfs/xfs_dir2_priv.h              |  14 +-
 libxfs/xfs_dir2_sf.c                |  14 +-
 libxfs/xfs_dquot_buf.c              |  14 +-
 libxfs/xfs_errortag.h               |  15 +-
 libxfs/xfs_format.h                 |  14 +-
 libxfs/xfs_fs.h                     |  14 +-
 libxfs/xfs_ialloc.c                 |  14 +-
 libxfs/xfs_ialloc.h                 |  14 +-
 libxfs/xfs_ialloc_btree.c           |  14 +-
 libxfs/xfs_ialloc_btree.h           |  14 +-
 libxfs/xfs_iext_tree.c              |  10 +-
 libxfs/xfs_inode_buf.c              |  14 +-
 libxfs/xfs_inode_buf.h              |  14 +-
 libxfs/xfs_inode_fork.c             |  14 +-
 libxfs/xfs_inode_fork.h             |  14 +-
 libxfs/xfs_log_format.h             |  14 +-
 libxfs/xfs_log_rlimit.c             |  14 +-
 libxfs/xfs_quota_defs.h             |  14 +-
 libxfs/xfs_refcount.c               |  16 +-
 libxfs/xfs_refcount.h               |  16 +-
 libxfs/xfs_refcount_btree.c         |  16 +-
 libxfs/xfs_refcount_btree.h         |  16 +-
 libxfs/xfs_rmap.c                   |  14 +-
 libxfs/xfs_rmap.h                   |  16 +-
 libxfs/xfs_rmap_btree.c             |  14 +-
 libxfs/xfs_rmap_btree.h             |  14 +-
 libxfs/xfs_rtbitmap.c               |  14 +-
 libxfs/xfs_sb.c                     |  14 +-
 libxfs/xfs_sb.h                     |  14 +-
 libxfs/xfs_shared.h                 |  14 +-
 libxfs/xfs_symlink_remote.c         |  14 +-
 libxfs/xfs_trans_resv.c             |  14 +-
 libxfs/xfs_trans_resv.h             |  14 +-
 libxfs/xfs_trans_space.h            |  14 +-
 libxfs/xfs_types.h                  |  14 +-
 libxlog/Makefile                    |   2 +-
 libxlog/util.c                      |  14 +-
 libxlog/xfs_log_recover.c           |  14 +-
 logprint/Makefile                   |   2 +-
 logprint/log_copy.c                 |  14 +-
 logprint/log_dump.c                 |  14 +-
 logprint/log_misc.c                 |  14 +-
 logprint/log_print_all.c            |  14 +-
 logprint/log_print_trans.c          |  14 +-
 logprint/log_redo.c                 |  14 +-
 logprint/logprint.c                 |  14 +-
 logprint/logprint.h                 |  14 +-
 m4/Makefile                         |   2 +-
 man/Makefile                        |   2 +-
 man/man2/ioctl_xfs_scrub_metadata.2 |  19 +-
 mdrestore/Makefile                  |   2 +-
 mdrestore/xfs_mdrestore.c           |  14 +-
 mkfs/Makefile                       |   2 +-
 mkfs/proto.c                        |  14 +-
 mkfs/xfs_mkfs.c                     |  14 +-
 po/Makefile                         |   2 +-
 quota/Makefile                      |   2 +-
 quota/darwin.c                      |  14 +-
 quota/edit.c                        |  14 +-
 quota/free.c                        |  14 +-
 quota/freebsd.c                     |  14 +-
 quota/init.c                        |  14 +-
 quota/init.h                        |  14 +-
 quota/irix.c                        |  14 +-
 quota/linux.c                       |  14 +-
 quota/path.c                        |  14 +-
 quota/project.c                     |  14 +-
 quota/quot.c                        |  14 +-
 quota/quota.c                       |  14 +-
 quota/quota.h                       |  14 +-
 quota/report.c                      |  14 +-
 quota/state.c                       |  14 +-
 quota/util.c                        |  14 +-
 repair/Makefile                     |   2 +-
 repair/README                       |   2 +
 repair/agheader.c                   |  14 +-
 repair/agheader.h                   |  14 +-
 repair/attr_repair.c                |  14 +-
 repair/attr_repair.h                |  14 +-
 repair/avl.c                        |  14 +-
 repair/avl.h                        |  14 +-
 repair/bmap.c                       |  14 +-
 repair/bmap.h                       |  14 +-
 repair/btree.c                      |  14 +-
 repair/btree.h                      |  14 +-
 repair/da_util.c                    |  13 +-
 repair/da_util.h                    |  14 +-
 repair/dino_chunks.c                |  14 +-
 repair/dinode.c                     |  14 +-
 repair/dinode.h                     |  14 +-
 repair/dir2.c                       |  14 +-
 repair/dir2.h                       |  14 +-
 repair/err_protos.h                 |  14 +-
 repair/globals.c                    |  14 +-
 repair/globals.h                    |  14 +-
 repair/incore.c                     |  14 +-
 repair/incore.h                     |  14 +-
 repair/incore_bmc.c                 |  14 +-
 repair/incore_ext.c                 |  14 +-
 repair/incore_ino.c                 |  14 +-
 repair/init.c                       |  14 +-
 repair/phase1.c                     |  14 +-
 repair/phase2.c                     |  14 +-
 repair/phase3.c                     |  14 +-
 repair/phase4.c                     |  14 +-
 repair/phase5.c                     |  14 +-
 repair/phase6.c                     |  14 +-
 repair/phase7.c                     |  14 +-
 repair/prefetch.c                   |   2 +
 repair/prefetch.h                   |   2 +
 repair/progress.c                   |   1 +
 repair/progress.h                   |   2 +
 repair/protos.h                     |  14 +-
 repair/rmap.c                       |  16 +-
 repair/rmap.h                       |  16 +-
 repair/rt.c                         |  14 +-
 repair/rt.h                         |  14 +-
 repair/sb.c                         |  14 +-
 repair/scan.c                       |  14 +-
 repair/scan.h                       |  14 +-
 repair/slab.c                       |  16 +-
 repair/slab.h                       |  16 +-
 repair/threads.c                    |   2 +
 repair/threads.h                    |   2 +
 repair/versions.c                   |  14 +-
 repair/versions.h                   |  14 +-
 repair/xfs_repair.c                 |  14 +-
 rtcp/Makefile                       |   2 +-
 rtcp/xfs_rtcp.c                     |  14 +-
 scrub/Makefile                      |   2 +-
 scrub/bitmap.c                      |  16 +-
 scrub/bitmap.h                      |  16 +-
 scrub/common.c                      |  16 +-
 scrub/common.h                      |  16 +-
 scrub/counter.c                     |  16 +-
 scrub/counter.h                     |  16 +-
 scrub/disk.c                        |  16 +-
 scrub/disk.h                        |  16 +-
 scrub/filemap.c                     |  16 +-
 scrub/filemap.h                     |  16 +-
 scrub/fscounters.c                  |  16 +-
 scrub/fscounters.h                  |  16 +-
 scrub/inodes.c                      |  16 +-
 scrub/inodes.h                      |  16 +-
 scrub/phase1.c                      |  16 +-
 scrub/phase2.c                      |  16 +-
 scrub/phase3.c                      |  16 +-
 scrub/phase4.c                      |  16 +-
 scrub/phase5.c                      |  16 +-
 scrub/phase6.c                      |  16 +-
 scrub/phase7.c                      |  16 +-
 scrub/progress.c                    |  16 +-
 scrub/progress.h                    |  16 +-
 scrub/read_verify.c                 |  16 +-
 scrub/read_verify.h                 |  16 +-
 scrub/scrub.c                       |  16 +-
 scrub/scrub.h                       |  16 +-
 scrub/spacemap.c                    |  16 +-
 scrub/spacemap.h                    |  16 +-
 scrub/unicrash.c                    |  16 +-
 scrub/unicrash.h                    |  16 +-
 scrub/vfs.c                         |  16 +-
 scrub/vfs.h                         |  16 +-
 scrub/xfs_scrub.c                   |  16 +-
 scrub/xfs_scrub.h                   |  16 +-
 scrub/xfs_scrub_all.in              |  19 +-
 spaceman/Makefile                   |   2 +-
 spaceman/file.c                     |  14 +-
 spaceman/freesp.c                   |  14 +-
 spaceman/info.c                     |  16 +-
 spaceman/init.c                     |  14 +-
 spaceman/init.h                     |  14 +-
 spaceman/prealloc.c                 |  14 +-
 spaceman/space.h                    |  14 +-
 spaceman/trim.c                     |  14 +-
 spaceman/xfs_info.sh                |   1 +
 tools/find-api-violations.sh        |   1 +
 tools/libxfs-apply                  |   1 +
 tools/libxfs-diff                   |   1 +
 tools/xfsbuflock.py                 |  19 +-
 460 files changed, 1327 insertions(+), 6291 deletions(-)
 create mode 100644 LICENSES/GPL-2.0
 create mode 100644 LICENSES/LGPL-2.1
 delete mode 100644 doc/COPYING
 mode change 100755 => 100644 io/utimes.c
-- 
Dave Chinner
david@fromorbit.com
