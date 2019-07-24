Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:53140 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725823AbfGXENG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Jul 2019 00:13:06 -0400
Subject: [PATCH 2/3] xfs/504: fix bogus test description
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 23 Jul 2019 21:13:00 -0700
Message-ID: <156394158077.1850719.2222567081675874481.stgit@magnolia>
In-Reply-To: <156394156831.1850719.2997473679130010771.stgit@magnolia>
References: <156394156831.1850719.2997473679130010771.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Fix the description of this test to reflect what it actually checks.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/504 |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)


diff --git a/tests/xfs/504 b/tests/xfs/504
index cc6088d1..c6435117 100755
--- a/tests/xfs/504
+++ b/tests/xfs/504
@@ -4,10 +4,10 @@
 #
 # FS QA Test No. 504
 #
-# Create a directory with multiple filenames that all appear the same
-# (in unicode, anyway) but point to different inodes.  In theory all
-# Linux filesystems should allow this (filenames are a sequence of
-# arbitrary bytes) even if the user implications are horrifying.
+# Create a filesystem label with emoji and confusing unicode characters
+# to make sure that these special things actually work on xfs.  In
+# theory it should allow this (labels are a sequence of arbitrary bytes)
+# even if the user implications are horrifying.
 #
 seq=`basename "$0"`
 seqres="$RESULT_DIR/$seq"
