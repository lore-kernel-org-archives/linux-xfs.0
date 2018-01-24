Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:37012 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932251AbeAXXxq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Jan 2018 18:53:46 -0500
Subject: [PATCH 4/5] xfs/24[356]: checking cow fork bmap requires
 CONFIG_XFS_DEBUG=y
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 24 Jan 2018 15:53:41 -0800
Message-ID: <151683802170.17051.13989603221322920472.stgit@magnolia>
In-Reply-To: <151683799705.17051.9987269343206294671.stgit@magnolia>
References: <151683799705.17051.9987269343206294671.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

These tests requires XFS debugging functionality, so test for that.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/243 |    2 ++
 tests/xfs/245 |    2 ++
 tests/xfs/246 |    2 ++
 3 files changed, 6 insertions(+)


diff --git a/tests/xfs/243 b/tests/xfs/243
index 0bb69c4..1e6ab5a 100755
--- a/tests/xfs/243
+++ b/tests/xfs/243
@@ -49,10 +49,12 @@ _cleanup()
 . ./common/rc
 . ./common/filter
 . ./common/reflink
+. ./common/xfs
 
 # real QA test starts here
 _supported_os Linux
 _supported_fs xfs
+_require_xfs_debug
 _require_scratch_reflink
 _require_xfs_io_command "falloc"
 _require_xfs_io_command "cowextsize"
diff --git a/tests/xfs/245 b/tests/xfs/245
index c668eeb..d54f347 100755
--- a/tests/xfs/245
+++ b/tests/xfs/245
@@ -43,10 +43,12 @@ _cleanup()
 . ./common/rc
 . ./common/filter
 . ./common/reflink
+. ./common/xfs
 
 # real QA test starts here
 _supported_os Linux
 _supported_fs xfs
+_require_xfs_debug
 _require_scratch_reflink
 _require_xfs_io_command "falloc"
 _require_xfs_io_command "bmap" "-c"
diff --git a/tests/xfs/246 b/tests/xfs/246
index 61d2545..c6ab603 100755
--- a/tests/xfs/246
+++ b/tests/xfs/246
@@ -38,10 +38,12 @@ _cleanup()
 # get standard environment, filters and checks
 . ./common/rc
 . ./common/filter
+. ./common/xfs
 
 # real QA test starts here
 _supported_os Linux
 _supported_fs xfs
+_require_xfs_debug
 _require_xfs_io_command "bmap" "-c"
 _require_scratch
 

