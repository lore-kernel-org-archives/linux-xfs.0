Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:48686 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbfBMJx2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Feb 2019 04:53:28 -0500
From: Bob Liu <bob.liu@oracle.com>
Subject: [RFC PATCH v2 0/9] Block/XFS: Support alternative mirror device retry
Date: Wed, 13 Feb 2019 17:50:35 +0800
Message-Id: <20190213095044.29628-1-bob.liu@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-block@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, martin.petersen@oracle.com, shirley.ma@oracle.com, allison.henderson@oracle.com, david@fromorbit.com, darrick.wong@oracle.com, hch@infradead.org, adilger@dilger.ca, Bob Liu <bob.liu@oracle.com>

Motivation:
When fs data/metadata checksum mismatch, lower block devices may have other
correct copies. e.g. If XFS successfully reads a metadata buffer off a raid1 but
decides that the metadata is garbage, today it will shut down the entire
filesystem without trying any of the other mirrors.  This is a severe
loss of service, and we propose these patches to have XFS try harder to
avoid failure.

This patch prototype this mirror retry idea by:
* Adding @nr_mirrors to struct request_queue which is similar as
  blk_queue_nonrot(), filesystem can grab device request queue and check max
  mirrors this block device has.
  Helper functions were also added to get/set the nr_mirrors.

* Introducing bi_rd_hint just like bi_write_hint, but bi_rd_hint is a long bitmap
in order to support stacked layer case.

* Modify md/raid1 to support this retry feature.

* Adapter xfs to use this feature.
  If the read verify fails, we loop over the available mirrors and retry the read.

* Rewrite retried read
  When the read verification fails, but the retry succeedes
  write the buffer back to correct the bad mirror

* Add tracepoints and logging to alternate device retry.
  This patch adds new log entries and trace points to the alternate device retry
  error path.

Changes v2:
- No more reuse bi_write_hint
- Stacked layer support(see patch 4/9)
- Other feedback fix

Allison Henderson (5):
  Add b_alt_retry to xfs_buf
  xfs: Add b_rd_hint to xfs_buf
  xfs: Add device retry
  xfs: Rewrite retried read
  xfs: Add tracepoints and logging to alternate device retry

Bob Liu (4):
  block: add nr_mirrors to request_queue
  block: add rd_hint to bio and request
  md:raid1: set mirrors correctly
  md:raid1: rd_hint support and consider stacked layer case

 Documentation/block/biodoc.txt |   3 +
 block/bio.c                    |   1 +
 block/blk-core.c               |   4 ++
 block/blk-merge.c              |   6 ++
 block/blk-settings.c           |  24 +++++++
 block/bounce.c                 |   1 +
 drivers/md/raid1.c             | 123 ++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_buf.c               |  58 +++++++++++++++-
 fs/xfs/xfs_buf.h               |  14 ++++
 fs/xfs/xfs_trace.h             |   6 +-
 include/linux/blk_types.h      |   1 +
 include/linux/blkdev.h         |   4 ++
 include/linux/types.h          |   3 +
 13 files changed, 244 insertions(+), 4 deletions(-)

-- 
2.17.1
