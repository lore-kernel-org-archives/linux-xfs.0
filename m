Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:58390 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729212AbfC2OYh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 29 Mar 2019 10:24:37 -0400
From: Bob Liu <bob.liu@oracle.com>
Subject: [RFC PATCH v3 0/3] Block/XFS: Support alternative mirror device retry
Date: Fri, 29 Mar 2019 22:23:43 +0800
Message-Id: <20190329142346.1677-1-bob.liu@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-block@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, martin.petersen@oracle.com, shirley.ma@oracle.com, allison.henderson@oracle.com, david@fromorbit.com, darrick.wong@oracle.com, hch@infradead.org, adilger@dilger.ca, axboe@kernel.dk, tytso@mit.edu, Bob Liu <bob.liu@oracle.com>

Motivation:
When fs data/metadata checksum mismatch, lower block devices may have other
correct copies. e.g. If XFS successfully reads a metadata buffer off a raid1 but
decides that the metadata is garbage, today it will shut down the entire
filesystem without trying any of the other mirrors.  This is a severe
loss of service, and we propose these patches to have XFS try harder to
avoid failure.

This patch prototype this mirror retry idea by adding a function verifier
callback to submit_bio.  Filesystem can use submit_bio_verify() to pass a
callback to the block layer which can then be used to verify if the data read is
correct.

Reused some of bio-integrity code, can be separated if necessary.

Changes v3:
- Total new implementation, pass down verify function to block layer as
  suggested by Dave.

Bob Liu (3):
  block: introduce submit_bio_verify()
  block: verify data when endio
  fs: xfs: add read_verifier() function

 block/bio-integrity.c     | 45 +++++++++++++++++++++++++++++++++++++++
 block/bio.c               |  3 +++
 block/blk-core.c          | 17 ++++++++++++---
 block/blk.h               |  8 +++++++
 block/bounce.c            |  1 +
 drivers/md/raid1.c        |  1 +
 drivers/md/raid5-ppl.c    |  1 +
 fs/xfs/xfs_buf.c          | 23 ++++++++++++++++++--
 fs/xfs/xfs_buf.h          |  1 +
 include/linux/bio.h       |  2 ++
 include/linux/blk_types.h |  5 +++++
 11 files changed, 102 insertions(+), 5 deletions(-)

-- 
2.17.1
