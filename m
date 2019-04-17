Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:39627 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728514AbfDQB13 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Apr 2019 21:27:29 -0400
From: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
Subject: [RFC PATCH 0/4] xfs: add handle for reflink in dax
Date: Wed, 17 Apr 2019 09:27:11 +0800
Message-ID: <20190417012715.8287-1-ruansy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, linux-nvdimm@lists.01.org

In XFS (under fsdax mode), reflink did not work correctly because xfs
iomap operators did not handle the inode with both reflink and dax flag.

This patchset aims to take care of this issue to make COW operation work
correctly in XFS.

XFS uses iomap to do read/write/mmap operations:
  vfs interface       xfs:
    iomap_bengin();     --> xfs_iomap_begin();
    actor();            --> dax_iomap_actor() / mmap actor function
    iomap_end();        --> xfs_iomap_end();

In xfs_iomap_begin(), COW operation is detected but not told to actor
function.  To resolve this, a new field 'src_addr' is added into
'struct iomap' to pass this COW info.  It means the start address of
source blocks in a COW operation, for actor functions to copy data
before writing.

In actor functions, the value of iomap->src_addr determines if it is a
COW operation.  If it is, copy data from source blocks to destination
blocks first, and then write user data.

After the COW operation, it is supposed to update the metadata of the
inode.  Added in xfs_iomap_end().


Shiyang Ruan (4):
  fs/iomap: Introduce src_addr for COW in fsdax mode.
  fs/xfs: iomap: add handle for reflink in fsdax mode
  fs/dax: copy source blocks before writing when COW
  fs/xfs: iomap: update the extent list after a COW

 fs/dax.c              | 70 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_iomap.c    | 23 +++++++++++---
 include/linux/iomap.h |  4 +++
 3 files changed, 93 insertions(+), 4 deletions(-)

-- 
2.17.0
