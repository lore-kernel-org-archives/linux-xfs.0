Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:55517 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726232AbfGaLtt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Jul 2019 07:49:49 -0400
From: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
Subject: [RFC PATCH 0/7] xfs: add reflink & dedupe support for fsdax.
Date: Wed, 31 Jul 2019 19:49:28 +0800
Message-ID: <20190731114935.11030-1-ruansy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, linux-nvdimm@lists.01.org, darrick.wong@oracle.com
Cc: linux-kernel@vger.kernel.org, rgoldwyn@suse.de, gujx@cn.fujitsu.com, david@fromorbit.com, qi.fuli@fujitsu.com, caoj.fnst@cn.fujitsu.com, ruansy.fnst@cn.fujitsu.com

This patchset aims to take care of this issue to make reflink and dedupe
work correctly in XFS.

It is based on Goldwyn's patchsets: "v4 Btrfs dax support" and "Btrfs
iomap".  I picked up some patches related and made a few fix to make it
basically works fine.

For dax framework: 
  1. adapt to the latest change in iomap.

For XFS:
  1. report the source address and set IOMAP_COW type for those write
     operations that need COW.
  2. update extent list at the end.
  3. add file contents comparison function based on dax framework.
  4. use xfs_break_layouts() to support dax.


Goldwyn Rodrigues (3):
  dax: replace mmap entry in case of CoW
  fs: dedup file range to use a compare function
  dax: memcpy before zeroing range

Shiyang Ruan (4):
  dax: Introduce dax_copy_edges() for COW.
  dax: copy data before write.
  xfs: Add COW handle for fsdax.
  xfs: Add dedupe support for fsdax.

 fs/btrfs/ioctl.c      |  11 ++-
 fs/dax.c              | 203 ++++++++++++++++++++++++++++++++++++++----
 fs/iomap.c            |   9 +-
 fs/ocfs2/file.c       |   2 +-
 fs/read_write.c       |  11 +--
 fs/xfs/xfs_iomap.c    |  42 +++++----
 fs/xfs/xfs_reflink.c  |  84 +++++++++--------
 include/linux/dax.h   |  15 ++--
 include/linux/fs.h    |   8 +-
 include/linux/iomap.h |   6 ++
 10 files changed, 294 insertions(+), 97 deletions(-)

-- 
2.17.0
