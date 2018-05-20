Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qt0-f178.google.com ([209.85.216.178]:41911 "EHLO
        mail-qt0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751451AbeETW0S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 20 May 2018 18:26:18 -0400
From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: [PATCH 00/13] convert block layer to bioset_init()/mempool_init()
Date: Sun, 20 May 2018 18:25:46 -0400
Message-Id: <20180520222558.7053-1-kent.overstreet@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, axboe@kernel.dk, hch@infradead.org, colyli@suse.de, snitzer@redhat.com, darrick.wong@oracle.com, clm@fb.com, bacik@fb.com, linux-xfs@vger.kernel.org, drbd-dev@lists.linbit.com, linux-btrfs@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.com
Cc: Kent Overstreet <kent.overstreet@gmail.com>

Jens - this series does the rest of the conversions that Christoph wanted, and
drops bioset_create().

Only lightly tested, but the changes are pretty mechanical. Based on your
for-next tree.

It's also in the for-jens branch at https://evilpiepirate.org/git/bcachefs.git

Kent Overstreet (12):
  block: convert bounce, q->bio_split to bioset_init()/mempool_init()
  drbd: convert to bioset_init()/mempool_init()
  pktcdvd: convert to bioset_init()/mempool_init()
  lightnvm: convert to bioset_init()/mempool_init()
  bcache: convert to bioset_init()/mempool_init()
  md: convert to bioset_init()/mempool_init()
  dm: convert to bioset_init()/mempool_init()
  target: convert to bioset_init()/mempool_init()
  fs: convert block_dev.c to bioset_init()
  btrfs: convert to bioset_init()/mempool_init()
  xfs: convert to bioset_init()/mempool_init()
  block: Drop bioset_create()

 block/bio.c                         | 61 +++++------------------
 block/blk-core.c                    |  7 +--
 block/blk-merge.c                   |  8 +--
 block/blk-sysfs.c                   |  3 +-
 block/bounce.c                      | 47 +++++++++---------
 drivers/block/drbd/drbd_bitmap.c    |  4 +-
 drivers/block/drbd/drbd_int.h       | 10 ++--
 drivers/block/drbd/drbd_main.c      | 71 ++++++++++-----------------
 drivers/block/drbd/drbd_receiver.c  |  6 +--
 drivers/block/drbd/drbd_req.c       |  4 +-
 drivers/block/drbd/drbd_req.h       |  2 +-
 drivers/block/pktcdvd.c             | 50 +++++++++----------
 drivers/lightnvm/pblk-core.c        | 30 ++++++------
 drivers/lightnvm/pblk-init.c        | 72 +++++++++++++--------------
 drivers/lightnvm/pblk-read.c        |  4 +-
 drivers/lightnvm/pblk-recovery.c    |  2 +-
 drivers/lightnvm/pblk-write.c       |  8 +--
 drivers/lightnvm/pblk.h             | 14 +++---
 drivers/md/bcache/bcache.h          | 10 ++--
 drivers/md/bcache/bset.c            | 13 ++---
 drivers/md/bcache/bset.h            |  2 +-
 drivers/md/bcache/btree.c           |  4 +-
 drivers/md/bcache/io.c              |  4 +-
 drivers/md/bcache/request.c         | 18 +++----
 drivers/md/bcache/super.c           | 38 ++++++---------
 drivers/md/dm-bio-prison-v1.c       | 13 ++---
 drivers/md/dm-bio-prison-v2.c       | 13 ++---
 drivers/md/dm-cache-target.c        | 25 +++++-----
 drivers/md/dm-core.h                |  4 +-
 drivers/md/dm-crypt.c               | 60 +++++++++++------------
 drivers/md/dm-integrity.c           | 15 +++---
 drivers/md/dm-io.c                  | 29 +++++------
 drivers/md/dm-kcopyd.c              | 22 +++++----
 drivers/md/dm-log-userspace-base.c  | 19 ++++----
 drivers/md/dm-region-hash.c         | 23 ++++-----
 drivers/md/dm-rq.c                  |  2 +-
 drivers/md/dm-snap.c                | 17 +++----
 drivers/md/dm-thin.c                | 32 ++++++------
 drivers/md/dm-verity-fec.c          | 55 +++++++++++----------
 drivers/md/dm-verity-fec.h          |  8 +--
 drivers/md/dm-zoned-target.c        | 13 +++--
 drivers/md/dm.c                     | 55 +++++++++------------
 drivers/md/md-faulty.c              |  2 +-
 drivers/md/md-linear.c              |  2 +-
 drivers/md/md-multipath.c           | 17 ++++---
 drivers/md/md-multipath.h           |  2 +-
 drivers/md/md.c                     | 61 +++++++++--------------
 drivers/md/md.h                     |  4 +-
 drivers/md/raid0.c                  |  5 +-
 drivers/md/raid1.c                  | 76 ++++++++++++++---------------
 drivers/md/raid1.h                  |  6 +--
 drivers/md/raid10.c                 | 60 +++++++++++------------
 drivers/md/raid10.h                 |  6 +--
 drivers/md/raid5-cache.c            | 43 ++++++++--------
 drivers/md/raid5-ppl.c              | 42 +++++++---------
 drivers/md/raid5.c                  | 12 ++---
 drivers/md/raid5.h                  |  2 +-
 drivers/target/target_core_iblock.c | 14 +++---
 drivers/target/target_core_iblock.h |  2 +-
 fs/block_dev.c                      |  9 ++--
 fs/btrfs/extent_io.c                | 25 +++++-----
 fs/xfs/xfs_aops.c                   |  2 +-
 fs/xfs/xfs_aops.h                   |  2 +-
 fs/xfs/xfs_super.c                  | 11 ++---
 include/linux/bio.h                 | 11 +++--
 include/linux/blkdev.h              |  2 +-
 include/linux/pktcdvd.h             |  2 +-
 67 files changed, 606 insertions(+), 711 deletions(-)

-- 
2.17.0

