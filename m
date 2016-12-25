Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:36361 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750967AbcLYSJ6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 25 Dec 2016 13:09:58 -0500
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 0/3] xfs/348: test handling of malformed inode mode
Date: Sun, 25 Dec 2016 20:09:33 +0200
Message-Id: <1482689376-23553-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@infradead.org>
Cc: Brian Foster <bfoster@redhat.com>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

Eryu,

I beefed up the initial test sent earlier today with more checks
on mounted fs.

The original patch testing only xfs_repair remains patch 1 in this series.

Patch 2 adds fstat tests on mounted fs, which are safe on my test system.

Patch 3 is explosive. It exposes an XFS assert, but I left a "safety pin"
that needs to be commented out to reproduce the assert.

I will soon post my kernel configs and dmesg logs.

Amir.

v2:
- test fstat with malformed inode mode
- test readlink/readdir with malformed inode mode

v1:
- test xfs_repair with malformed inode mode

Amir Goldstein (3):
  xfs/348: test handling of invalid inode modes
  xfs/348: test fstat with malformed inode mode
  xfs/348: test readlink/readdir with malformed inode mode

 tests/xfs/348     | 154 +++++++++++++++++++++++++++
 tests/xfs/348.out | 312 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/group   |   1 +
 3 files changed, 467 insertions(+)
 create mode 100755 tests/xfs/348
 create mode 100644 tests/xfs/348.out

-- 
2.7.4

