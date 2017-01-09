Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34483 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934994AbdAINax (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Jan 2017 08:30:53 -0500
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3 0/3] xfs: test malformed inode mode
Date: Mon,  9 Jan 2017 15:30:22 +0200
Message-Id: <1483968625-29160-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: Brian Foster <bfoster@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

Eryu,

This is the 3rd revision of the malformed inode mode test.

Like with v2, patch 1 is safe and it passes on kernel 4.9.

Like with v2, patch 2 is safe, but unlike v2, it fails on
kernel 4.9, because I added a stronger expectation for the
test to fails on stat of directory with inode size 0.

Like with v2, patch 3 triggers an XFS assert and I removed
the "safety pin" that was there in v2.

I already sent the fix patch to Darick, which addresses the
failures in both patch 2 and 3.

You could merge patch 1 now and defer merging patches 2-3
or you could wait with merging the entire test. up to you.

Amir.

v3:
- added empty and non empty regular file cases (patch 1)
- expect to detect directory with size 0 as an error (patch 2)
- removed the "safety pin" from patch 3

v2:
- test fstat with malformed inode mode
- test readlink/readdir with malformed inode mode

v1:
- test xfs_repair with malformed inode mode


Amir Goldstein (3):
  xfs: test handling of invalid inode modes
  xfs: test fstat with malformed inode mode
  xfs: test readlink/readdir with malformed inode mode

 tests/xfs/348     | 154 +++++++++++++++++++++++
 tests/xfs/348.out | 360 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/group   |   1 +
 3 files changed, 515 insertions(+)
 create mode 100755 tests/xfs/348
 create mode 100644 tests/xfs/348.out

-- 
2.7.4

