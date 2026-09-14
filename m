Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B6447D47A;
	Mon, 14 Sep 2026 17:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789406735; cv=none; b=KwiFqHh5hyT5seH4gTVxJhUSEcMeeFiaVw2CY/57An+cpUN7ieBbGffboNAUg5173cMhYzwx4g01pkF40eS8TjWI99SN/opDwevmPZNwneTmr1EqlbBKjI7MUwoA2w2SVQJCSCFm5ceFFUe4puM6MoMkSytDc97lBwOJv5oIeeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789406735; c=relaxed/simple;
	bh=BWzIH1HS25pAySlEFY2FgcNNjMPUOLvzgTAMNvDlY68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VyzeFi8tNB1LpZap0ob6DOr6vggtJZbMAPzrwnUANgSCDD/y1zD1B7zFwo826VtWRMbPKejfk4Wz9LT9mc5Jszii15TqAn6/n04Sm0hAx/yIq9DS2P75Wss+CEfC546Ps8emQXzHbmVRDcQkk2TXSpKS8cfMxr/09XoQZkbFnmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M7mFtDfH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M7mFtDfH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28FFE1F00898;
	Mon, 14 Sep 2026 17:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789406733;
	bh=O8CUL9XoxzoyqRBXtPiMVPZC2E3Yjab2yfiEuXaL0co=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M7mFtDfH6z7oX32B1Dr8/6XiqPHbnG/yTtjfQu46PXLsvSao1FIMwZJnkxM6NSxeE
	 EyQcd2/rZR9GPRWnNF3BBo0/XVbXiXUeFcG9ksyNKNz4V52+KoUu5Y5gWYLOs38JBW
	 bAxUapBkhJvDwLDuWeHuy+lqTthOr1pAPP3m5u+w+ey4WFdqqkJROEe26op3jxPk6u
	 JjbAiVDaMHWJhSP++Q+SuStC78BK40dSWz8z8nIBG872EZWDbEjlK9mMgp+POpFLBJ
	 P5Ekgf0uSojzzzf4KrdqPzuMVlPlXJDohe9gN3oZyzF8igP+Gu1Esj/Pe11m2FODwN
	 6c2RDeFecGIcQ==
From: Zorro Lang <zlang@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	Anand Suveer Jain <asj@kernel.org>,
	Chao Yu <chao@kernel.org>
Subject: [PATCH 2/5] common/sysfs: adjust function naming
Date: Tue, 15 Sep 2026 01:25:06 +0800
Message-ID: <20260914172509.3799016-3-zlang@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260914172509.3799016-1-zlang@kernel.org>
References: <20260914172509.3799016-1-zlang@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the _dev_ infix to helper functions associated with
/sys/fs/$FSTYP/<devices> to distinguish them from upcoming
/sys/fs/$FSTYP/features/ related helpers.

Signed-off-by: Zorro Lang <zlang@kernel.org>
---
 common/sysfs    | 66 ++++++++++++++++++++++++-------------------------
 tests/btrfs/253 |  2 +-
 tests/btrfs/329 |  4 +--
 tests/btrfs/334 |  2 +-
 4 files changed, 37 insertions(+), 37 deletions(-)

diff --git a/common/sysfs b/common/sysfs
index c36ab426..ede5bcb6 100644
--- a/common/sysfs
+++ b/common/sysfs
@@ -12,8 +12,8 @@
 #  - policy: policy within /sys/fs/$FSTYP/$dev
 #
 # Usage example:
-#   _has_fs_sysfs_attr_policy /dev/mapper/scratch-dev read_policy round-robin
-_has_fs_sysfs_attr_policy()
+#   _has_fs_sysfs_dev_policy /dev/mapper/scratch-dev read_policy round-robin
+_has_fs_sysfs_dev_policy()
 {
 	local dev=$1
 	local attr=$2
@@ -21,7 +21,7 @@ _has_fs_sysfs_attr_policy()
 
 	if [ ! -b "$dev" -o -z "$attr" -o -z "$policy" ]; then
 		_fail \
-	     "Usage: _has_fs_sysfs_attr_policy <mounted_device> <attr> <policy>"
+	     "Usage: _has_fs_sysfs_dev_policy <mounted_device> <attr> <policy>"
 	fi
 
 	local dname=$(_fs_sysfs_dname $dev)
@@ -40,10 +40,10 @@ _has_fs_sysfs_attr_policy()
 #  - policy: mentioned in /sys/fs/$FSTYP/$dev/$attr
 #
 # Usage example:
-#   _require_fs_sysfs_attr_policy /dev/mapper/scratch-dev read_policy round-robin
-_require_fs_sysfs_attr_policy()
+#   _require_fs_sysfs_dev_policy /dev/mapper/scratch-dev read_policy round-robin
+_require_fs_sysfs_dev_policy()
 {
-	_has_fs_sysfs_attr_policy "$@" && return
+	_has_fs_sysfs_dev_policy "$@" && return
 
 	local dev=$1
 	local attr=$2
@@ -53,7 +53,7 @@ _require_fs_sysfs_attr_policy()
 	_notrun "This test requires /sys/fs/${FSTYP}/${dname}/${attr} ${policy}"
 }
 
-_set_sysfs_policy()
+_set_sysfs_dev_policy()
 {
 	local dev=$1
 	local attr=$2
@@ -77,7 +77,7 @@ _set_sysfs_policy()
 	esac
 }
 
-_set_sysfs_policy_must_fail()
+_set_sysfs_dev_policy_must_fail()
 {
 	local dev=$1
 	local attr=$2
@@ -91,18 +91,18 @@ _set_sysfs_policy_must_fail()
 
 # Verify sysfs attribute rejects invalid input.
 # Usage syntax:
-#   _verify_sysfs_syntax <$dev> <$attr> <$policy> [$value]
+#   _verify_sysfs_dev_syntax <$dev> <$attr> <$policy> [$value]
 # Examples:
-#   _verify_sysfs_syntax $TEST_DEV read_policy pid
-#   _verify_sysfs_syntax $TEST_DEV read_policy round-robin 4k
+#   _verify_sysfs_dev_syntax $TEST_DEV read_policy pid
+#   _verify_sysfs_dev_syntax $TEST_DEV read_policy round-robin 4k
 # Note:
 #  Testcase must include
 #      . ./common/filter
 # Prerequisite checks are kept outside this function
 # to make them clear to the test case, rather than hiding
 # them deep inside another function.
-#      _require_fs_sysfs_attr_policy $TEST_DEV $attr $policy
-_verify_sysfs_syntax()
+#      _require_fs_sysfs_dev_policy $TEST_DEV $attr $policy
+_verify_sysfs_dev_syntax()
 {
 	local dev=$1
 	local attr=$2
@@ -110,23 +110,23 @@ _verify_sysfs_syntax()
 	local value=$4
 
 	# Test policy specified wrongly. Must fail.
-	_set_sysfs_policy_must_fail $dev $attr "'$policy $policy'"
-	_set_sysfs_policy_must_fail $dev $attr "'$policy t'"
-	_set_sysfs_policy_must_fail $dev $attr "' '"
-	_set_sysfs_policy_must_fail $dev $attr "'${policy} n'"
-	_set_sysfs_policy_must_fail $dev $attr "'n ${policy}'"
-	_set_sysfs_policy_must_fail $dev $attr "' ${policy}'"
-	_set_sysfs_policy_must_fail $dev $attr "' ${policy} '"
-	_set_sysfs_policy_must_fail $dev $attr "'${policy} '"
-	_set_sysfs_policy_must_fail $dev $attr _${policy}
-	_set_sysfs_policy_must_fail $dev $attr ${policy}_
-	_set_sysfs_policy_must_fail $dev $attr _${policy}_
-	_set_sysfs_policy_must_fail $dev $attr ${policy}:
+	_set_sysfs_dev_policy_must_fail $dev $attr "'$policy $policy'"
+	_set_sysfs_dev_policy_must_fail $dev $attr "'$policy t'"
+	_set_sysfs_dev_policy_must_fail $dev $attr "' '"
+	_set_sysfs_dev_policy_must_fail $dev $attr "'${policy} n'"
+	_set_sysfs_dev_policy_must_fail $dev $attr "'n ${policy}'"
+	_set_sysfs_dev_policy_must_fail $dev $attr "' ${policy}'"
+	_set_sysfs_dev_policy_must_fail $dev $attr "' ${policy} '"
+	_set_sysfs_dev_policy_must_fail $dev $attr "'${policy} '"
+	_set_sysfs_dev_policy_must_fail $dev $attr _${policy}
+	_set_sysfs_dev_policy_must_fail $dev $attr ${policy}_
+	_set_sysfs_dev_policy_must_fail $dev $attr _${policy}_
+	_set_sysfs_dev_policy_must_fail $dev $attr ${policy}:
 	# Test policy longer than 32 chars fails stable.
-	_set_sysfs_policy_must_fail $dev $attr 'jfdkkkkjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjffjfjfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff'
+	_set_sysfs_dev_policy_must_fail $dev $attr 'jfdkkkkjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjffjfjfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff'
 
 	# Test policy specified correctly. Must pass.
-	_set_sysfs_policy $dev $attr $policy
+	_set_sysfs_dev_policy $dev $attr $policy
 
 	# If the policy has no value return
 	if [[ -z $value ]]; then
@@ -134,12 +134,12 @@ _verify_sysfs_syntax()
 	fi
 
 	# Test value specified wrongly. Must fail.
-	_set_sysfs_policy_must_fail $dev $attr "'$policy: $value'"
-	_set_sysfs_policy_must_fail $dev $attr "'$policy:$value '"
-	_set_sysfs_policy_must_fail $dev $attr "'$policy:$value typo'"
-	_set_sysfs_policy_must_fail $dev $attr "'$policy:${value}typo'"
-	_set_sysfs_policy_must_fail $dev $attr "'$policy :$value'"
+	_set_sysfs_dev_policy_must_fail $dev $attr "'$policy: $value'"
+	_set_sysfs_dev_policy_must_fail $dev $attr "'$policy:$value '"
+	_set_sysfs_dev_policy_must_fail $dev $attr "'$policy:$value typo'"
+	_set_sysfs_dev_policy_must_fail $dev $attr "'$policy:${value}typo'"
+	_set_sysfs_dev_policy_must_fail $dev $attr "'$policy :$value'"
 
 	# Test policy and value all specified correctly. Must pass.
-	_set_sysfs_policy $dev $attr $policy:$value
+	_set_sysfs_dev_policy $dev $attr $policy:$value
 }
diff --git a/tests/btrfs/253 b/tests/btrfs/253
index 5843643d..b1443328 100755
--- a/tests/btrfs/253
+++ b/tests/btrfs/253
@@ -226,7 +226,7 @@ alloc_size "Data" FOURTH_DATA_SIZE_MB
 # Force chunk allocation of system block type must fail.
 #
 echo "Force allocation of system block type must fail."
-_set_sysfs_policy_must_fail ${SCRATCH_BDEV} allocation/system/force_chunk_alloc 1
+_set_sysfs_dev_policy_must_fail ${SCRATCH_BDEV} allocation/system/force_chunk_alloc 1
 
 #
 # Verification of initial allocation.
diff --git a/tests/btrfs/329 b/tests/btrfs/329
index f4fadded..86e9a380 100755
--- a/tests/btrfs/329
+++ b/tests/btrfs/329
@@ -13,9 +13,9 @@ _begin_fstest auto quick
 . ./common/filter
 
 _require_test
-_require_fs_sysfs_attr_policy $TEST_DEV read_policy round-robin
+_require_fs_sysfs_dev_policy $TEST_DEV read_policy round-robin
 
-_verify_sysfs_syntax $TEST_DEV read_policy round-robin 4096
+_verify_sysfs_dev_syntax $TEST_DEV read_policy round-robin 4096
 
 status=0
 exit
diff --git a/tests/btrfs/334 b/tests/btrfs/334
index 08b66dc7..ae9b72b7 100755
--- a/tests/btrfs/334
+++ b/tests/btrfs/334
@@ -15,7 +15,7 @@ _begin_fstest auto quick
 _require_test
 _require_fs_sysfs_dev_attr $TEST_DEV allocation/data/chunk_size
 
-_verify_sysfs_syntax $TEST_DEV allocation/data/chunk_size 256m
+_verify_sysfs_dev_syntax $TEST_DEV allocation/data/chunk_size 256m
 
 status=0
 exit
-- 
2.55.0

