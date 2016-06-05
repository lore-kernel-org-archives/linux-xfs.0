Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6ADF17CA0
	for <xfs@oss.sgi.com>; Sun,  5 Jun 2016 14:32:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A6EE9AC007
	for <xfs@oss.sgi.com>; Sun,  5 Jun 2016 12:32:39 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id bwPNfDpVbQ2OSPYq (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 05 Jun 2016 12:32:34 -0700 (PDT)
From: mchristi@redhat.com
Subject: [PATCH 00/45] v8: separate operations from flags in the bio/request
	structs
Date: Sun,  5 Jun 2016 14:31:40 -0500
Message-Id: <1465155145-10812-1-git-send-email-mchristi@redhat.com>
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
To: linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org, konrad.wilk@oracle.com, drbd-dev@lists.linbit.com, philipp.reisner@linbit.com, lars.ellenberg@linbit.com, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-mtd@lists.infradead.org, target-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, osd-dev@open-osd.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com

The following patches begin to cleanup the request->cmd_flags and
bio->bi_rw mess. We currently use cmd_flags to specify the operation,
attributes and state of the request. For bi_rw we use it for similar
info and also the priority but then also have another bi_flags field
for state. At some point, we abused them so much we just made cmd_flags
64 bits, so we could add more.

The following patches seperate the operation (read, write discard,
flush, etc) from cmd_flags/bi_rw. They were made against Linus's
tree.

I put a git tree here:

https://github.com/mikechristie/linux-kernel/tree/op

The patches are in the op branch.

Note that I made it against linus's tree, but right now the only
major conflicts with -next are in the dm tree from the dm-rq related
changes. I have patches for that and can submit them. I was just not
sure how to coordinate everything.

v8:
1. Handle Jens's review comments from LSF.  Instead of adding a op
field, store the value in bi_rw/cmd_flags and access via accessors.

v7:
1. Fix broken feature_flush/fua use.

v6 and maybe hopfully the last version:
1. Adapt patch 41 to Jens's QUEUE_FLAG_WC/FUA patchset.

v5:
1. Missed crypto fs submit_bio_wait call.
2. Change nfs bi_rw check to bi_op.
3. btrfs. Convert finish_parity_scrub.
4. Reworked against Jens's QUEUE_FLAG patches so I could drop my similar
code.
5. Separated the core block layer change into multiple patches for
merging, elevator, stats, mq and non mq request allocation to try
and make it easier to read.

v4:
1. Rebased to current linux-next tree.

v3:

1. Used "=" instead of "|="  to setup bio bi_rw.
2. Removed __get_request cmd_flags compat code.
3. Merged initial dm related changes requested by Mike Snitzer.
4. Fixed ubd kbuild errors in flush related patches.
5. Fix 80 char col issues in several patches.
6. Fix issue with one of the btrfs patches where it looks like I reverted
a patch when trying to fix a merge error.

v2

1. Dropped arguments from submit_bio, and had callers setup
bio.
2. Add REQ_OP_FLUSH for request_fn users and renamed REQ_FLUSH
to REQ_PREFLUSH for make_request_fn users.
3. Dropped bio/rq_data_dir functions, and added a op_is_write
function instead.



Diffstat for the set:

Documentation/block/writeback_cache_control.txt |   28 +++---
 Documentation/device-mapper/log-writes.txt      |   10 +-
 arch/um/drivers/ubd_kern.c                      |    2
 block/bio.c                                     |   20 ++--
 block/blk-core.c                                |  105 +++++++++++------------
 block/blk-flush.c                               |   25 ++---
 block/blk-lib.c                                 |   37 ++++----
 block/blk-map.c                                 |    2
 block/blk-merge.c                               |   24 ++---
 block/blk-mq.c                                  |   42 ++++-----
 block/cfq-iosched.c                             |   55 +++++++-----
 block/elevator.c                                |    7 -
 drivers/ata/libata-scsi.c                       |    2
 drivers/block/brd.c                             |    2
 drivers/block/drbd/drbd_actlog.c                |   34 ++++---
 drivers/block/drbd/drbd_bitmap.c                |   10 +-
 drivers/block/drbd/drbd_int.h                   |    4
 drivers/block/drbd/drbd_main.c                  |   22 ++--
 drivers/block/drbd/drbd_protocol.h              |    2
 drivers/block/drbd/drbd_receiver.c              |   38 +++++---
 drivers/block/drbd/drbd_req.c                   |    2
 drivers/block/drbd/drbd_worker.c                |    7 -
 drivers/block/floppy.c                          |    5 -
 drivers/block/loop.c                            |   16 +--
 drivers/block/mtip32xx/mtip32xx.c               |    2
 drivers/block/nbd.c                             |    4
 drivers/block/osdblk.c                          |    2
 drivers/block/pktcdvd.c                         |    4
 drivers/block/ps3disk.c                         |    4
 drivers/block/rbd.c                             |    4
 drivers/block/rsxx/dma.c                        |    2
 drivers/block/skd_main.c                        |    2
 drivers/block/umem.c                            |    2
 drivers/block/virtio_blk.c                      |    2
 drivers/block/xen-blkback/blkback.c             |   31 ++++--
 drivers/block/xen-blkfront.c                    |   67 +++++++--------
 drivers/block/zram/zram_drv.c                   |    2
 drivers/ide/ide-cd_ioctl.c                      |    3
 drivers/ide/ide-disk.c                          |    2
 drivers/ide/ide-floppy.c                        |    2
 drivers/lightnvm/rrpc.c                         |    6 -
 drivers/md/bcache/btree.c                       |    4
 drivers/md/bcache/debug.c                       |   10 +-
 drivers/md/bcache/io.c                          |    2
 drivers/md/bcache/journal.c                     |   11 +-
 drivers/md/bcache/movinggc.c                    |    2
 drivers/md/bcache/request.c                     |   28 +++---
 drivers/md/bcache/super.c                       |   28 +++---
 drivers/md/bcache/writeback.c                   |    4
 drivers/md/bitmap.c                             |    6 -
 drivers/md/dm-bufio.c                           |   11 +-
 drivers/md/dm-cache-target.c                    |   22 ++--
 drivers/md/dm-crypt.c                           |   15 +--
 drivers/md/dm-era-target.c                      |    4
 drivers/md/dm-flakey.c                          |    2
 drivers/md/dm-io.c                              |   65 +++++++-------
 drivers/md/dm-kcopyd.c                          |   11 +-
 drivers/md/dm-log-writes.c                      |   19 ++--
 drivers/md/dm-log.c                             |    5 -
 drivers/md/dm-raid.c                            |    5 -
 drivers/md/dm-raid1.c                           |   24 +++--
 drivers/md/dm-region-hash.c                     |    8 -
 drivers/md/dm-snap-persistent.c                 |   24 ++---
 drivers/md/dm-snap.c                            |    6 -
 drivers/md/dm-stats.c                           |    9 --
 drivers/md/dm-stripe.c                          |    6 -
 drivers/md/dm-thin.c                            |   30 +++---
 drivers/md/dm.c                                 |   45 +++++-----
 drivers/md/linear.c                             |    4
 drivers/md/md.c                                 |   24 +++--
 drivers/md/md.h                                 |    5 -
 drivers/md/multipath.c                          |    2
 drivers/md/raid0.c                              |    4
 drivers/md/raid1.c                              |   38 ++++----
 drivers/md/raid10.c                             |   54 ++++++------
 drivers/md/raid5-cache.c                        |   35 ++++---
 drivers/md/raid5.c                              |   48 +++++-----
 drivers/mmc/card/block.c                        |   13 +-
 drivers/mmc/card/queue.c                        |    6 -
 drivers/mmc/card/queue.h                        |    8 +
 drivers/mtd/mtd_blkdevs.c                       |    4
 drivers/nvme/host/core.c                        |    4
 drivers/nvme/host/nvme.h                        |    4
 drivers/scsi/osd/osd_initiator.c                |   12 +-
 drivers/scsi/sd.c                               |   34 ++++---
 drivers/staging/lustre/lustre/llite/lloop.c     |    6 -
 drivers/target/target_core_iblock.c             |   53 ++++++-----
 drivers/target/target_core_pscsi.c              |    2
 fs/btrfs/check-integrity.c                      |   73 ++++++++--------
 fs/btrfs/check-integrity.h                      |    6 -
 fs/btrfs/compression.c                          |   17 ++-
 fs/btrfs/ctree.h                                |    2
 fs/btrfs/disk-io.c                              |   45 ++++------
 fs/btrfs/disk-io.h                              |    2
 fs/btrfs/extent-tree.c                          |    2
 fs/btrfs/extent_io.c                            |  107 +++++++++++-------------
 fs/btrfs/extent_io.h                            |    8 -
 fs/btrfs/inode.c                                |   74 ++++++++--------
 fs/btrfs/raid56.c                               |   27 +++---
 fs/btrfs/scrub.c                                |   25 +++--
 fs/btrfs/volumes.c                              |   95 +++++++++++----------
 fs/btrfs/volumes.h                              |    6 -
 fs/buffer.c                                     |   75 ++++++++--------
 fs/crypto/crypto.c                              |    5 -
 fs/direct-io.c                                  |   37 ++++----
 fs/exofs/ore.c                                  |    2
 fs/ext4/balloc.c                                |    2
 fs/ext4/ialloc.c                                |    2
 fs/ext4/inode.c                                 |    8 -
 fs/ext4/mmp.c                                   |    4
 fs/ext4/namei.c                                 |    3
 fs/ext4/page-io.c                               |    9 +-
 fs/ext4/readpage.c                              |   11 +-
 fs/ext4/super.c                                 |    2
 fs/f2fs/checkpoint.c                            |   10 +-
 fs/f2fs/data.c                                  |   51 ++++++-----
 fs/f2fs/f2fs.h                                  |    5 -
 fs/f2fs/gc.c                                    |    9 +-
 fs/f2fs/inline.c                                |    3
 fs/f2fs/node.c                                  |    8 +
 fs/f2fs/segment.c                               |   18 ++--
 fs/f2fs/trace.c                                 |    7 -
 fs/fat/misc.c                                   |    2
 fs/gfs2/bmap.c                                  |    4
 fs/gfs2/dir.c                                   |    2
 fs/gfs2/log.c                                   |    8 -
 fs/gfs2/lops.c                                  |   14 +--
 fs/gfs2/lops.h                                  |    2
 fs/gfs2/meta_io.c                               |   20 ++--
 fs/gfs2/ops_fstype.c                            |    5 -
 fs/gfs2/quota.c                                 |    2
 fs/hfsplus/hfsplus_fs.h                         |    2
 fs/hfsplus/part_tbl.c                           |    5 -
 fs/hfsplus/super.c                              |    6 -
 fs/hfsplus/wrapper.c                            |   17 ++-
 fs/isofs/compress.c                             |    2
 fs/jbd2/commit.c                                |    6 -
 fs/jbd2/journal.c                               |   12 +-
 fs/jbd2/recovery.c                              |    4
 fs/jfs/jfs_logmgr.c                             |   10 +-
 fs/jfs/jfs_metapage.c                           |   14 +--
 fs/logfs/dev_bdev.c                             |   27 +++---
 fs/mpage.c                                      |   43 ++++-----
 fs/nfs/blocklayout/blocklayout.c                |   26 +++--
 fs/nilfs2/btnode.c                              |    6 -
 fs/nilfs2/btnode.h                              |    2
 fs/nilfs2/btree.c                               |    6 -
 fs/nilfs2/gcinode.c                             |    5 -
 fs/nilfs2/mdt.c                                 |   11 +-
 fs/nilfs2/segbuf.c                              |   20 ++--
 fs/ntfs/aops.c                                  |    6 -
 fs/ntfs/compress.c                              |    2
 fs/ntfs/file.c                                  |    2
 fs/ntfs/logfile.c                               |    2
 fs/ntfs/mft.c                                   |    4
 fs/ocfs2/aops.c                                 |    2
 fs/ocfs2/buffer_head_io.c                       |    8 -
 fs/ocfs2/cluster/heartbeat.c                    |   22 ++--
 fs/ocfs2/super.c                                |    2
 fs/reiserfs/inode.c                             |    4
 fs/reiserfs/journal.c                           |   14 +--
 fs/reiserfs/stree.c                             |    4
 fs/reiserfs/super.c                             |    2
 fs/squashfs/block.c                             |    4
 fs/udf/dir.c                                    |    2
 fs/udf/directory.c                              |    2
 fs/udf/inode.c                                  |    2
 fs/ufs/balloc.c                                 |    2
 fs/ufs/util.c                                   |    2
 fs/xfs/xfs_aops.c                               |   27 +++---
 fs/xfs/xfs_buf.c                                |   32 +++----
 include/linux/bio.h                             |   37 +++-----
 include/linux/blk-cgroup.h                      |   15 +--
 include/linux/blk_types.h                       |   94 +++++++++++----------
 include/linux/blkdev.h                          |   56 ++++++++----
 include/linux/blktrace_api.h                    |    2
 include/linux/buffer_head.h                     |   11 +-
 include/linux/dm-io.h                           |    3
 include/linux/elevator.h                        |    4
 include/linux/fs.h                              |   71 +++++++++------
 include/trace/events/bcache.h                   |   12 +-
 include/trace/events/block.h                    |   31 ++++--
 include/trace/events/f2fs.h                     |   37 ++++----
 kernel/power/swap.c                             |   35 ++++---
 kernel/trace/blktrace.c                         |   72 +++++++++-------
 mm/page_io.c                                    |   14 +--
 186 files changed, 1679 insertions(+), 1413 deletions(-)



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
