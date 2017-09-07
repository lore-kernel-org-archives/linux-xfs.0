Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:58082 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752689AbdIGVIi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 Sep 2017 17:08:38 -0400
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 0/2] xfs: some DAX fixes
Date: Thu,  7 Sep 2017 15:08:30 -0600
Message-Id: <20170907210832.17969-1-ross.zwisler@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org

These two fixes are to the now-disabled per-inode DAX support in XFS.  I
started working on these in the v4.13 timeframe before the per-inode
DAX feature was turned off.

I realize that they may not be critical right now since the per-inode DAX
feature is turned off, but I think that if we ever do re-enable that
feature we will want these two issues to have been fixed.

I also do think that they are both vaulable for stable kernels.

These used to be part of my ext4 per-inode enabling:

https://lkml.org/lkml/2017/9/5/748

But I've since split that into a series of XFS bug fixes (these two) and a
series of ext4 bug fixes.

Ross Zwisler (2):
  xfs: always use DAX if mount option is used
  xfs: validate bdev support for DAX inode flag

 fs/xfs/xfs_ioctl.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

-- 
2.9.5

