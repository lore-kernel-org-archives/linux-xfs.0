Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35465 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936994AbdAJPjb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Jan 2017 10:39:31 -0500
Received: by mail-wm0-f66.google.com with SMTP id l2so30686200wml.2
        for <linux-xfs@vger.kernel.org>; Tue, 10 Jan 2017 07:39:30 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v7 0/6] xfs: fixes for malformed on-disk i_mode
Date: Tue, 10 Jan 2017 17:39:11 +0200
Message-Id: <1484062757-12433-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J . Wong" <darrick.wong@oracle.com>
Cc: Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

Darrick,

This is 7th revision of the fixes for malformed on-disk i_mode.

Patches 1-3 are simple cleanups, some already reviewed and
one (patch 2) was suggested by you.

Patch 4 replaces xfs_mode_to_ftype table with switch statement
per Christoph's suggestion.

Patches 5-6 use the new conversion helper to sanity test mode
loaded from disk and export the error to the user.

Tested with generic/401 with -n ftype=0|1.
Tested with new xfs/348 test with -n ftype=0|1.

Amir.

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


Amir Goldstein (6):
  xfs: make the ASSERT() condition likely
  xfs: sanity check directory inode di_size
  xfs: add missing include dependencies to xfs_dir2.h
  xfs: replace xfs_mode_to_ftype table with switch statement
  xfs: sanity check inode mode when creating new dentry
  xfs: sanity check inode di_mode

 fs/xfs/libxfs/xfs_dir2.c      | 40 ++++++++++++++++++++++-------------
 fs/xfs/libxfs/xfs_dir2.h      |  8 ++++---
 fs/xfs/libxfs/xfs_inode_buf.c | 10 +++++++--
 fs/xfs/xfs_iops.c             | 49 ++++++++++++++++++++++++++++++++++---------
 fs/xfs/xfs_linux.h            |  6 +++---
 5 files changed, 80 insertions(+), 33 deletions(-)

-- 
2.7.4

