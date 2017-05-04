Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:33569 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751391AbdEDN0Q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 May 2017 09:26:16 -0400
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 0/8] hoist uuid helpers from xfs to linux/uuid.h
Date: Thu,  4 May 2017 16:26:15 +0300
Message-Id: <1493904383-2187-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J . Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Miklos Szeredi <miklos@szeredi.hu>, Theodore Tso <tytso@mit.edu>, Richard Weinberger <richard@nod.at>, Mark Fasheh <mfasheh@versity.com>, Dan Williams <dan.j.williams@intel.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, David Howells <dhowells@redhat.com>, Shaohua Li <shli@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, linux-xfs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Darick,

I moved some code around to be able to hoist all the generic
xfs uuid helpers to linux/uuid.h, so that other filesystems
and uuid related code in the kernel can use them.

Let me know what you think of the outcome.

I did not find any uuid related regressions with xfs.
Specifically, the following xfstests exercise these changes:
xfs/045 xfs/073 xfs/077 (multi uuid mount)
generic/079 xfs/238 xfs/269 xfs/062 (fshandle)

Some of these helpers are quite similar to thier uuid_{le|be}
variants in linux/uuid.h, but at the moment I don't see xfs
or any filesystem starting to use the uuid_{le|be} helpers,
so we probably have to live with this duplicity for a while
longer.

Amir.

Amir Goldstein (8):
  xfs: use uuid_copy() helper to abstract uuid_t
  xfs: re-define uuid_t as common struct uuid_v1
  xfs: dismiss xfs_uu_t
  xfs: namespace the helper uuid_getnodeuniq()
  md: namespace private helper names
  linux/uuid.h: hoist helpers uuid_equal() and uuid_copy() from xfs
  linux/uuid.h: hoist uuid_is_null() helper from libnvdimm
  xfs: use the common helper uuid_is_null()

 drivers/md/md.c           |  8 ++++----
 drivers/nvdimm/btt_devs.c | 10 ++--------
 fs/xfs/uuid.c             | 42 ++++++------------------------------------
 fs/xfs/uuid.h             | 14 ++------------
 fs/xfs/xfs_inode_item.c   |  8 ++------
 fs/xfs/xfs_log_recover.c  |  6 +++---
 fs/xfs/xfs_mount.c        | 10 +++++-----
 include/linux/uuid.h      | 21 +++++++++++++++++++--
 lib/uuid.c                |  3 +++
 9 files changed, 46 insertions(+), 76 deletions(-)

-- 
2.7.4

