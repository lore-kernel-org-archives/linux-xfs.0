Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:49882 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727303AbeK1Own (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Nov 2018 09:52:43 -0500
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [RFC PATCH v1 0/7] Block/XFS: Support alternative mirror device retry
Date: Tue, 27 Nov 2018 20:49:44 -0700
Message-Id: <1543376991-5764-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: martin.petersen@oracle.com, shirley.ma@oracle.com, bob.liu@oracle.com, allison.henderson@oracle.com

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

* Expanding bi_write_hint to bi_rw_hint, now @bi_rw_hint has three meanings.
 1.Original write_hint.
 2.end_io() will update @bi_rw_hint to reflect which mirror this i/o really happened.
 3.Fs set @bi_rw_hint to force driver e.g raid1 read from a specific mirror.

* Modify md/raid1 to support this retry feature.

* Add b_rw_hint to xfs_buf
  This patch adds a new field b_rw_hint to xfs_buf.  We will use this to set the
  new bio->bi_rw_hint when submitting the read request, and also to store the
  returned mirror when the read compleates

* Add device retry
  This patch add some logic to xfs_buf_read_map.  If the read verify
  fails, we loop over the available mirrors and retry the read

* Rewrite retried read
  When the read verification fails, but the retry succeedes
  write the buffer back to correct the bad mirror

* Add tracepoints and logging to alternate device retry.
  This patch adds new log entries and trace points to the alternate device retry
  error path.

We're not planning to take over all 16 bits of the read hint field; just looking for
feedback about the sanity of the overall approach.

Allison Henderson (4):
  xfs: Add b_rw_hint to xfs_buf
  xfs: Add device retry
  xfs: Rewrite retried read
  xfs: Add tracepoints and logging to alternate device retry

Bob Liu (3):
  block: add nr_mirrors to request_queue
  block: expand write_hint of bio/request to rw_hint
  md: raid1: handle bi_rw_hint accordingly

 Documentation/block/biodoc.txt |  7 ++++++
 block/bio.c                    |  2 +-
 block/blk-core.c               | 13 ++++++++++-
 block/blk-merge.c              |  8 +++----
 block/blk-settings.c           | 18 ++++++++++++++
 block/bounce.c                 |  2 +-
 drivers/md/raid1.c             | 33 ++++++++++++++++++++++----
 drivers/md/raid5.c             | 10 ++++----
 drivers/md/raid5.h             |  2 +-
 drivers/nvme/host/core.c       |  2 +-
 fs/block_dev.c                 |  6 +++--
 fs/btrfs/extent_io.c           |  3 ++-
 fs/buffer.c                    |  3 ++-
 fs/direct-io.c                 |  3 ++-
 fs/ext4/page-io.c              |  7 ++++--
 fs/f2fs/data.c                 |  2 +-
 fs/iomap.c                     |  3 ++-
 fs/mpage.c                     |  2 +-
 fs/xfs/xfs_aops.c              |  4 ++--
 fs/xfs/xfs_buf.c               | 53 ++++++++++++++++++++++++++++++++++++++++--
 fs/xfs/xfs_buf.h               |  8 +++++++
 fs/xfs/xfs_trace.h             |  6 ++++-
 include/linux/blk_types.h      |  2 +-
 include/linux/blkdev.h         |  5 +++-
 24 files changed, 169 insertions(+), 35 deletions(-)

-- 
2.7.4
