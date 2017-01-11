Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36357 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965460AbdAKIYa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Jan 2017 03:24:30 -0500
Received: by mail-wm0-f65.google.com with SMTP id r126so14936888wmr.3
        for <linux-xfs@vger.kernel.org>; Wed, 11 Jan 2017 00:24:30 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v8 0/6] xfs: fixes for malformed on-disk i_mode
Date: Wed, 11 Jan 2017 10:24:04 +0200
Message-Id: <1484123050-11064-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J . Wong" <darrick.wong@oracle.com>
Cc: Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

Darrick,

This is 8th revision of the fixes for malformed on-disk i_mode.

Patches 1-2 are reviewed by Christoph and IMO, you should consider
patch 1 and perhaprs also patch 2 for 4.10 and stable 4.9.

Patches 4-6 replace xfs_mode_to_ftype table with switch statement
per Christoph's suggestion and add sanity checks.

Tested with generic/401 with -n ftype=0|1.
Tested with new xfs/348 test with -n ftype=0|1.

Amir.

v8:
- Address review comments by Darrick
- Added Reviewed-by Darrick to patches 4,6

v7:
- Replaced xfs_mode_to_ftype table with switch statement
- Reordered patches so reviewed trivial patches are first
- Added Reviewed-by Christoph to first 2 patches
- Added cleanup patch for xfs_dir2.h
- Added sanity checks for invalid mode in more places

v6:
- Added Reviewed-by Brian for patch 1
- Added patch to address new xfs/348 failures
- Added patch to fix ASSERT() likely

v5:
- remove wrong argument about on-disk malformed mode from commit message
- address Brian's review comments

v4:
- independent fix patch for xfs

*** BLURB HERE ***

Amir Goldstein (6):
  xfs: make the ASSERT() condition likely
  xfs: sanity check directory inode di_size
  xfs: add missing include dependencies to xfs_dir2.h
  xfs: replace xfs_mode_to_ftype table with switch statement
  xfs: sanity check inode mode when creating new dentry
  xfs: sanity check inode di_mode

 fs/xfs/libxfs/xfs_dir2.c      | 39 ++++++++++++++++++++-------------
 fs/xfs/libxfs/xfs_dir2.h      |  8 ++++---
 fs/xfs/libxfs/xfs_inode_buf.c | 10 +++++++--
 fs/xfs/xfs_iops.c             | 50 ++++++++++++++++++++++++++++++++++---------
 fs/xfs/xfs_linux.h            |  6 +++---
 5 files changed, 80 insertions(+), 33 deletions(-)

-- 
2.7.4

