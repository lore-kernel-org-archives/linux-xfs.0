Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752910AbdLMAp0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 12 Dec 2017 19:45:26 -0500
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH 1/9] generic/381: use username fsgqa-381
Date: Tue, 12 Dec 2017 16:45:11 -0800
Message-Id: <20171213004519.29340-2-mcgrof@kernel.org>
In-Reply-To: <20171213004519.29340-1-mcgrof@kernel.org>
References: <20171213004519.29340-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@kernel.org>

Some systems are not allowing usernames prefixed with a number now.
One can however use numbers as a postfix so use that.

Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 README                |  2 +-
 tests/generic/381     | 16 ++++++++--------
 tests/generic/381.out |  4 ++--
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/README b/README
index ed69332e774e..e05142be1a87 100644
--- a/README
+++ b/README
@@ -20,7 +20,7 @@ _______________________
 - run make
 - run make install
 - create fsgqa test user ("sudo useradd fsgqa")
-- create 123456-fsgqa test user ("sudo useradd 123456-fsgqa")
+- create fsgqa-381 test user ("sudo useradd fsgqa-381")
 	
 ______________________
 USING THE FSQA SUITE
diff --git a/tests/generic/381 b/tests/generic/381
index 006f0d879638..cdc29c2e029e 100755
--- a/tests/generic/381
+++ b/tests/generic/381
@@ -3,7 +3,7 @@
 #
 # Test xfs_quota when user or names beginning with digits.
 # For example, create a 'limit' for a user or group named
-# '12345678-abcd', then query this user and group.
+# 'fsgqa-381', then query this user and group.
 #
 #-----------------------------------------------------------------------
 # Copyright (c) 2015 Red Hat Inc. All Rights Reserved.
@@ -53,9 +53,9 @@ _require_scratch
 _require_quota
 _require_xfs_quota_foreign
 
-# need user and group named 123456-fsgqa
-_require_user 123456-fsgqa
-_require_group 123456-fsgqa
+# need user and group named fsgqa-381
+_require_user fsgqa-381
+_require_group fsgqa-381
 
 _scratch_mkfs >/dev/null 2>&1
 _qmount_option "usrquota,grpquota"
@@ -63,17 +63,17 @@ _qmount
 
 # user test
 echo "== user test =="
-$XFS_QUOTA_PROG -x -c "limit -u bsoft=100m bhard=200m 123456-fsgqa" $SCRATCH_MNT
+$XFS_QUOTA_PROG -x -c "limit -u bsoft=100m bhard=200m fsgqa-381" $SCRATCH_MNT
 echo "=== quota command output ==="
-$XFS_QUOTA_PROG -c "quota -u -b -N -v 123456-fsgqa" $SCRATCH_MNT | _filter_quota
+$XFS_QUOTA_PROG -c "quota -u -b -N -v fsgqa-381" $SCRATCH_MNT | _filter_quota
 echo "=== report command output ==="
 $XFS_QUOTA_PROG -x -c "report -u -b -N" $SCRATCH_MNT | grep -v "^root " | _filter_quota
 
 # group test
 echo "== group test =="
-$XFS_QUOTA_PROG -x -c "limit -g bsoft=100m bhard=200m 123456-fsgqa" $SCRATCH_MNT
+$XFS_QUOTA_PROG -x -c "limit -g bsoft=100m bhard=200m fsgqa-381" $SCRATCH_MNT
 echo "=== quota command output ==="
-$XFS_QUOTA_PROG -c "quota -g -b -N -v 123456-fsgqa" $SCRATCH_MNT | _filter_quota
+$XFS_QUOTA_PROG -c "quota -g -b -N -v fsgqa-381 " $SCRATCH_MNT | _filter_quota
 echo "=== report command output ==="
 $XFS_QUOTA_PROG -x -c "report -u -b -N" $SCRATCH_MNT | grep -v "^root " | _filter_quota
 
diff --git a/tests/generic/381.out b/tests/generic/381.out
index 50a1a27b0167..cc0ee4a1bb95 100644
--- a/tests/generic/381.out
+++ b/tests/generic/381.out
@@ -3,11 +3,11 @@ QA output created by 381
 === quota command output ===
 SCRATCH_DEV 0 102400 204800 00 [--------] SCRATCH_MNT
 === report command output ===
-123456-fsgqa 0 102400 204800 00 [--------]
+fsgqa-381 0 102400 204800 00 [--------]
 
 == group test ==
 === quota command output ===
 SCRATCH_DEV 0 102400 204800 00 [--------] SCRATCH_MNT
 === report command output ===
-123456-fsgqa 0 102400 204800 00 [--------]
+fsgqa-381 0 102400 204800 00 [--------]
 
-- 
2.15.0

