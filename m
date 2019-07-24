Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:50860 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbfGXPzr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Jul 2019 11:55:47 -0400
Date: Wed, 24 Jul 2019 08:55:43 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 4/3] generic/506: mount scratch fs before testing for
 prjquota presence
Message-ID: <20190724155543.GE7084@magnolia>
References: <156394156831.1850719.2997473679130010771.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156394156831.1850719.2997473679130010771.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

On XFS, the _require_prjquota helper takes a path to a block device,
but (unintuitively) requires the block device to be mounted for the
detection to work properly.  Fix the detection code in generic/506.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/quota      |    3 ++-
 tests/generic/506 |    2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/common/quota b/common/quota
index f19f81a1..8a22f815 100644
--- a/common/quota
+++ b/common/quota
@@ -68,7 +68,8 @@ _require_xfs_quota_foreign()
 }
 
 #
-# checks that the project quota support in the kernel is enabled.
+# Checks that the project quota support in the kernel is enabled.
+# The device must be mounted for detection to work properly.
 #
 _require_prjquota()
 {
diff --git a/tests/generic/506 b/tests/generic/506
index 7002c00c..e8d0ca24 100755
--- a/tests/generic/506
+++ b/tests/generic/506
@@ -51,7 +51,9 @@ _require_scratch_shutdown
 
 _scratch_mkfs >/dev/null 2>&1
 _require_metadata_journaling $SCRATCH_DEV
+_scratch_mount
 _require_prjquota $SCRATCH_DEV
+_scratch_unmount
 
 testfile=$SCRATCH_MNT/testfile
 
