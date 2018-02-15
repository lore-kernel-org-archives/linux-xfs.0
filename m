Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:58007 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751145AbeBOVki (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 15 Feb 2018 16:40:38 -0500
Subject: [PATCH v5 0/3] minimal DAX support for XFS realtime device
From: Dave Jiang <dave.jiang@intel.com>
Date: Thu, 15 Feb 2018 14:40:37 -0700
Message-ID: <151873070632.53899.3320294279108510082.stgit@djiang5-desk3.ch.intel.com>
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

v5:
- Removed sb parameter for bdev_dax_supported() since we only use it for
  debug output per Christoph comment.

v4:
- Removed setting of error return in ext2 and ext4 per Ross's comments
- Rebased against 4.16-rc1 with updates

---

Darrick J. Wong (1):
      fs: allow per-device dax status checking for filesystems

Dave Jiang (2):
      dax: change bdev_dax_supported() to support boolean returns
      xfs: reject removal of realtime flag when datadev doesn't support DAX


 drivers/dax/super.c |   44 ++++++++++++++++++++++----------------------
 fs/ext2/super.c     |    3 +--
 fs/ext4/super.c     |    3 +--
 fs/xfs/xfs_ioctl.c  |   17 ++++++++++++++++-
 fs/xfs/xfs_iops.c   |   30 +++++++++++++++++++++++++-----
 fs/xfs/xfs_super.c  |   10 ++++++++--
 include/linux/dax.h |   12 ++++--------
 7 files changed, 77 insertions(+), 42 deletions(-)

--
