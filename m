Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23143 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754342AbcI2C2s (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Sep 2016 22:28:48 -0400
Subject: [PATCH 3/3] xfs/{207,327}: fsxattr no longer has the reflink flag
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 28 Sep 2016 19:28:40 -0700
Message-ID: <147511612047.12284.3645173774395982911.stgit@birch.djwong.org>
In-Reply-To: <147511610789.12284.10323409415801065382.stgit@birch.djwong.org>
References: <147511610789.12284.10323409415801065382.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

The FS_XFLAG_REFLINK flag was removed from struct fsxattr prior to
the inclusion of reflink in XFS, so remove it from the test outputs.
Note that the inode flag still exists; it's simply not presented
to userspace any more.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/207.out |    4 ++--
 tests/xfs/327.out |    6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)


diff --git a/tests/xfs/207.out b/tests/xfs/207.out
index 434b8d9..f6dc17d 100644
--- a/tests/xfs/207.out
+++ b/tests/xfs/207.out
@@ -11,8 +11,8 @@ Check extsz and cowextsz settings on 1Mbyte file
 [0] SCRATCH_MNT/test-207/file2
 [1048576] SCRATCH_MNT/test-207/file2
 Set cowextsize and check flag
-fsxattr.xflags = 0x20000 [----------------C]
+fsxattr.xflags = 0x10000 [---------------C]
 [1048576] SCRATCH_MNT/test-207/file3
 Unset cowextsize and check flag
-fsxattr.xflags = 0x0 [-----------------]
+fsxattr.xflags = 0x0 [----------------]
 [0] SCRATCH_MNT/test-207/file3
diff --git a/tests/xfs/327.out b/tests/xfs/327.out
index c88d623..5b3cba2 100644
--- a/tests/xfs/327.out
+++ b/tests/xfs/327.out
@@ -3,11 +3,11 @@ Format filesystem
 Create files
 Check files
 8fa14cdd754f91cc6554c9e71929cce7  SCRATCH_MNT/file.0
-[reflink] SCRATCH_MNT/file.0 
+[] SCRATCH_MNT/file.0 
 8fa14cdd754f91cc6554c9e71929cce7  SCRATCH_MNT/file.64
-[reflink] SCRATCH_MNT/file.64 
+[] SCRATCH_MNT/file.64 
 8fa14cdd754f91cc6554c9e71929cce7  SCRATCH_MNT/file.128
-[reflink] SCRATCH_MNT/file.128 
+[] SCRATCH_MNT/file.128 
 CoW all files
 Repair filesystem
 Check files again

