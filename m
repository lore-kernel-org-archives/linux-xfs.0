Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33102 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759342AbdAINGn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Jan 2017 08:06:43 -0500
Received: by mail-wm0-f66.google.com with SMTP id r144so13204315wme.0
        for <linux-xfs@vger.kernel.org>; Mon, 09 Jan 2017 05:06:43 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v6 0/3] xfs: fixes for malformed on-disk i_mode
Date: Mon,  9 Jan 2017 15:06:26 +0200
Message-Id: <1483967189-27313-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J . Wong" <darrick.wong@oracle.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

Darrick,

This is 6th revision of the fixes for malformed on-disk i_mode.

I implemented the xfs specific test case (xfs/348) to test all
possible malformed file type values as you suggested.

Tested with generic/401 with -n ftype=0|1.
Tested with new xfs/348 test with -n ftype=0|1.

Test xfs/348 exposed an ASSERT on attempt to readdir of regular
file that is posing as a directory.

Patch 2 implements your suggestion to address this case.

Patch 3 fixes a very strage upsidedown unlikely() in the
xfs ASSERT macros. I hope I am not tripping...

Amir.

v6:
- Added Reviewed-by Brian for patch 1
- Added patch 2 to address new xfs/348 failures
- Added patch 3 to fix ASSERT() likely

v5:
- remove wrong argument about on-disk malformed mode from commit message
- address Brian's review comments

v4:
- independent fix patch for xfs

Amir Goldstein (3):
  xfs: fix the size of xfs_mode_to_ftype table
  xfs: sanity check directory inode di_size
  xfs: make the ASSERT() condition likely

 fs/xfs/libxfs/xfs_dir2.c      | 21 +++++++++++----------
 fs/xfs/libxfs/xfs_dir2.h      |  4 +++-
 fs/xfs/libxfs/xfs_inode_buf.c |  7 +++++--
 fs/xfs/xfs_iops.c             |  2 +-
 fs/xfs/xfs_linux.h            |  6 +++---
 5 files changed, 23 insertions(+), 17 deletions(-)

-- 
2.7.4

