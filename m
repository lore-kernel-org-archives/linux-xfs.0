Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga18.intel.com ([134.134.136.126]:31098 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752308AbeBIAiJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 8 Feb 2018 19:38:09 -0500
Subject: [PATCH v3 0/3] minimal DAX support for XFS realtime device
From: Dave Jiang <dave.jiang@intel.com>
Date: Thu, 08 Feb 2018 17:38:08 -0700
Message-ID: <151813659955.15926.8922476613392258086.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-nvdimm@lists.01.org, david@fromorbit.com, linux-xfs@vger.kernel.org, ross.zwisler@linux.intel.com, linux-ext4@vger.kernel.org, dan.j.williams@intel.com

Darrick,
After reading the comments from you, Dave Chinner, and Dan, it looks like
the dyanmic S_DAX flag support won't be coming or not any time soon at the
least. Here are the the collection of patches so far to address yours and
Dave C's comments for minimal support. Please let me know what else I am
missing. Thanks!

---

Darrick J. Wong (1):
      fs: allow per-device dax status checking for filesystems

Dave Jiang (2):
      dax: change bdev_dax_supported() to support boolean returns
      xfs: reject removal of realtime flag when datadev doesn't support DAX


 drivers/dax/super.c |   25 +++++++++++++------------
 fs/ext2/super.c     |    5 +++--
 fs/ext4/super.c     |    5 +++--
 fs/xfs/xfs_ioctl.c  |   18 +++++++++++++++++-
 fs/xfs/xfs_iops.c   |   30 +++++++++++++++++++++++++-----
 fs/xfs/xfs_super.c  |   11 +++++++++--
 include/linux/dax.h |   18 +++++++++++++-----
 7 files changed, 83 insertions(+), 29 deletions(-)

--
