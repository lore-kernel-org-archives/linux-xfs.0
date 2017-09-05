Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:4505 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753955AbdIEWgO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 5 Sep 2017 18:36:14 -0400
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 0/9] add ext4 per-inode DAX flag
Date: Tue,  5 Sep 2017 16:35:32 -0600
Message-Id: <20170905223541.20594-1-ross.zwisler@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org

The original intent of this series was to add a per-inode DAX flag to ext4
so that it would be consistent with XFS.  In my travels I found and fixed
several related issues in both ext4 and XFS.

I'm not fully happy with the ways that ext4 DAX interacts with conflicting
features (journaling, inline data and encryption).  My goal with this
series was to make all these interactions as consistent as possilble, and
of course to make them safe.  If anyone has ideas for improvements, I'm
very open.

Ross Zwisler (9):
  ext4: remove duplicate extended attributes defs
  xfs: always use DAX if mount option is used
  xfs: validate bdev support for DAX inode flag
  ext4: add ext4_should_use_dax()
  ext4: ext4_change_inode_journal_flag error handling
  ext4: safely transition S_DAX on journaling changes
  ext4: prevent data corruption with inline data + DAX
  ext4: add sanity check for encryption + DAX
  ext4: add per-inode DAX flag

 fs/ext4/ext4.h      | 47 ++++++---------------------------------------
 fs/ext4/ext4_jbd2.h | 16 ++++++++++++++++
 fs/ext4/inline.c    | 10 ----------
 fs/ext4/inode.c     | 45 ++++++++++++++++++++++++-------------------
 fs/ext4/ioctl.c     | 55 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 fs/ext4/super.c     |  8 ++++++++
 fs/xfs/xfs_ioctl.c  | 14 +++++++++++---
 7 files changed, 119 insertions(+), 76 deletions(-)

-- 
2.9.5

