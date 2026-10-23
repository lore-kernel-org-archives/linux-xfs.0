Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792787495;
	b=YvczqVQwMEc9qL1QmvCGhTs9Tc0vEDKLSk/0mOjxHbq5/cvv3mzpoVMgKZKxbFUYIP5L
	 9VOYrOJ+1y+Rz2x3aTpm0lUFfVjoO7m3SK7RqDZiD0hBRx86YjHS2njsN2Ltt1qj4zIfc
	 VNEdb9lrLt/HW8/UBd0fkk+NSyt7FHom1xunJ+aJH49eIKqRx+ZJT9QPkQWy7VZG2ylUV
	 7ptj0zHSyU5iT/Z+sVYey7aUOvLdUxdonbYqm5vFWorFMe8LuIJ+B+Efn1DkleMeIMK8t
	 JCpt6Gi6kzw9pn4vSjU5kDogljX1hhnfuWbqFnNienqjoXWEsaZ3TXb9k/k0+1rBwQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792787495;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=0Sod5hk90djXR1PXQs5IJGrO5nDk8350GEU0ykLBVDo=;
	b=l68wbdoe1ANkGRTRB5kXC4KLMWcOQIUpn9a5IMmsrQZ1VBjzLYwSH1Wl47g7+EQtIE8F
	 JxX31cIcjL0Qtml1wg/Sa6KGuWF5aSBRIv4EXNFoNSOgxJYD5YTm9S3O/RF0qRV59Jwdi
	 iu3FUCI3B/hjo97+5pPHrzsQzt0ulx9Y41PgllpcfSnpRY6orrsSUNEF8hxVlqVrH5OGV
	 SywP8rSyyIorv4HUPnSFZAnVLFrWsuCAv9cdgXHvweqMtoNhKY3/d2WoHzyRQlHwixKh6
	 VnCocd2kfR15ZBXzVDU9fS4ks2POldfdra0vRMqZm94izivsTXFeZKmyqlq9XVxhOVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Kgie+n8k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0F64606A31A;
	Fri, 23 Oct 2026 20:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Kgie+n8k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A05A71F01829;
	Fri, 23 Oct 2026 20:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792787494;
	bh=0Sod5hk90djXR1PXQs5IJGrO5nDk8350GEU0ykLBVDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kgie+n8kXwJkQXR4abSt3VnU0GV5/J/eO8vQGGqbRL8Bzt9hlYdWtwB9DSJtgWuxX
	 ug2428QMKrbpNnN+SriFAkY8cR8fta4J6uJxSF+sb174h/eSIFAavd+DnsWN4SZ3Qx
	 yMp3Tke6SEijfU/6NzTR8SDkn99BppRPU2gmo1LjbfdCegTsOxar9+WkAhMXeyNRKm
	 u70DXse+0bM6gqFoWILMf65FQvLJIeGJL7jPmrvzF40ecJP1NxblgmKy+7vrotXZnU
	 kDMO3bt4+KF3oxKPB0lxTX9PKxv8Bh/OuU7YbRftk6OtfR85lQUh/KjV0pP1kT3E1s
	 Cnd6etfjy+upQ==
From: Zorro Lang <zlang@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	Anand Suveer Jain <asj@kernel.org>,
	Chao Yu <chao@kernel.org>,
	Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v2 3/6] common: move btrfs-only sysfs policy helpers out of common/sysfs
Date: Sat, 24 Oct 2026 04:31:11 +0800
Message-ID: <20261023203114.1655019-4-zlang@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261023203114.1655019-1-zlang@kernel.org>
References: <20261023203114.1655019-1-zlang@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The sysfs policy helpers in common/sysfs are only usable for btrfs.
The only filesystem supported by them is btrfs and the only callers
are btrfs tests. So rename them with a _btrfs_ infix and move them to
common/btrfs, then remove empty common/sysfs and its references.

Signed-off-by: Zorro Lang <zlang@kernel.org>
---
 common/btrfs    | 135 ++++++++++++++++++++++++++++++++++++++++++++
 common/sysfs    | 145 ------------------------------------------------
 tests/btrfs/253 |   3 +-
 tests/btrfs/329 |   5 +-
 tests/btrfs/334 |   3 +-
 5 files changed, 139 insertions(+), 152 deletions(-)
 delete mode 100644 common/sysfs

diff --git a/common/btrfs b/common/btrfs
index b52b4b11..38658a11 100644
--- a/common/btrfs
+++ b/common/btrfs
@@ -1084,3 +1084,138 @@ _require_btrfs_iouring_encoded_read()
 		_notrun "btrfs io_uring encoded read failed with -EOPNOTSUPP"
 	fi
 }
+
+# Btrfs-only sysfs policy helpers.  They operate on per-device sysfs
+# attributes that accept a "policy" value, e.g. read_policy.
+
+# Test for the existence of a policy at /sys/fs/$FSTYP/$DEV/$ATTR
+#
+# All arguments are necessary, and in this order:
+#  - dev: device name, e.g. $SCRATCH_DEV
+#  - attr: path name under /sys/fs/$FSTYP/$dev
+#  - policy: policy within /sys/fs/$FSTYP/$dev
+#
+# Usage example:
+#   _has_btrfs_sysfs_dev_policy /dev/mapper/scratch-dev read_policy round-robin
+_has_btrfs_sysfs_dev_policy()
+{
+	local dev=$1
+	local attr=$2
+	local policy=$3
+
+	if [ ! -b "$dev" -o -z "$attr" -o -z "$policy" ]; then
+		_fail \
+	     "Usage: _has_btrfs_sysfs_dev_policy <mounted_device> <attr> <policy>"
+	fi
+
+	local dname=$(_fs_sysfs_dname $dev)
+	if ! test -e /sys/fs/${FSTYP}/${dname}/${attr}; then
+		return 1
+	fi
+
+	cat /sys/fs/${FSTYP}/${dname}/${attr} | grep -q ${policy}
+}
+
+# Require the existence of a sysfs entry at /sys/fs/$FSTYP/$DEV/$ATTR
+# and value in it contains $policy
+# All arguments are necessary, and in this order:
+#  - dev: device name, e.g. $SCRATCH_DEV
+#  - attr: path name under /sys/fs/$FSTYP/$dev
+#  - policy: mentioned in /sys/fs/$FSTYP/$dev/$attr
+#
+# Usage example:
+#   _require_btrfs_sysfs_dev_policy /dev/mapper/scratch-dev read_policy round-robin
+_require_btrfs_sysfs_dev_policy()
+{
+	_has_btrfs_sysfs_dev_policy "$@" && return
+
+	local dev=$1
+	local attr=$2
+	local policy=$3
+	local dname=$(_fs_sysfs_dname $dev)
+
+	_notrun "This test requires /sys/fs/${FSTYP}/${dname}/${attr} ${policy}"
+}
+
+_set_btrfs_sysfs_dev_policy()
+{
+	local dev=$1
+	local attr=$2
+	shift
+	shift
+	local policy=$@
+
+	_set_fs_sysfs_dev_attr $dev $attr ${policy}
+
+	_get_fs_sysfs_dev_attr $dev $attr | grep -q "[${policy}]"
+	if [[ $? != 0 ]]; then
+		echo "Setting sysfs $attr $policy failed"
+	fi
+}
+
+_set_btrfs_sysfs_dev_policy_must_fail()
+{
+	local dev=$1
+	local attr=$2
+	shift
+	shift
+	local policy=$@
+
+	_set_fs_sysfs_dev_attr $dev $attr ${policy} | _filter_sysfs_error \
+							   | tee -a $seqres.full
+}
+
+# Verify sysfs attribute rejects invalid input.
+# Usage syntax:
+#   _verify_btrfs_sysfs_dev_syntax <$dev> <$attr> <$policy> [$value]
+# Examples:
+#   _verify_btrfs_sysfs_dev_syntax $TEST_DEV read_policy pid
+#   _verify_btrfs_sysfs_dev_syntax $TEST_DEV read_policy round-robin 4k
+# Note:
+#  Testcase must include
+#      . ./common/filter
+# Prerequisite checks are kept outside this function
+# to make them clear to the test case, rather than hiding
+# them deep inside another function.
+#      _require_btrfs_sysfs_dev_policy $TEST_DEV $attr $policy
+_verify_btrfs_sysfs_dev_syntax()
+{
+	local dev=$1
+	local attr=$2
+	local policy=$3
+	local value=$4
+
+	# Test policy specified wrongly. Must fail.
+	_set_btrfs_sysfs_dev_policy_must_fail $dev $attr "'$policy $policy'"
+	_set_btrfs_sysfs_dev_policy_must_fail $dev $attr "'$policy t'"
+	_set_btrfs_sysfs_dev_policy_must_fail $dev $attr "' '"
+	_set_btrfs_sysfs_dev_policy_must_fail $dev $attr "'${policy} n'"
+	_set_btrfs_sysfs_dev_policy_must_fail $dev $attr "'n ${policy}'"
+	_set_btrfs_sysfs_dev_policy_must_fail $dev $attr "' ${policy}'"
+	_set_btrfs_sysfs_dev_policy_must_fail $dev $attr "' ${policy} '"
+	_set_btrfs_sysfs_dev_policy_must_fail $dev $attr "'${policy} '"
+	_set_btrfs_sysfs_dev_policy_must_fail $dev $attr _${policy}
+	_set_btrfs_sysfs_dev_policy_must_fail $dev $attr ${policy}_
+	_set_btrfs_sysfs_dev_policy_must_fail $dev $attr _${policy}_
+	_set_btrfs_sysfs_dev_policy_must_fail $dev $attr ${policy}:
+	# Test policy longer than 32 chars fails stable.
+	_set_btrfs_sysfs_dev_policy_must_fail $dev $attr 'jfdkkkkjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjffjfjfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff'
+
+	# Test policy specified correctly. Must pass.
+	_set_btrfs_sysfs_dev_policy $dev $attr $policy
+
+	# If the policy has no value return
+	if [[ -z $value ]]; then
+		return
+	fi
+
+	# Test value specified wrongly. Must fail.
+	_set_btrfs_sysfs_dev_policy_must_fail $dev $attr "'$policy: $value'"
+	_set_btrfs_sysfs_dev_policy_must_fail $dev $attr "'$policy:$value '"
+	_set_btrfs_sysfs_dev_policy_must_fail $dev $attr "'$policy:$value typo'"
+	_set_btrfs_sysfs_dev_policy_must_fail $dev $attr "'$policy:${value}typo'"
+	_set_btrfs_sysfs_dev_policy_must_fail $dev $attr "'$policy :$value'"
+
+	# Test policy and value all specified correctly. Must pass.
+	_set_btrfs_sysfs_dev_policy $dev $attr $policy:$value
+}
diff --git a/common/sysfs b/common/sysfs
deleted file mode 100644
index c36ab426..00000000
--- a/common/sysfs
+++ /dev/null
@@ -1,145 +0,0 @@
-##/bin/bash
-# SPDX-License-Identifier: GPL-2.0+
-# Copyright (c) 2025 Oracle.  All Rights Reserved.
-#
-# Common/sysfs file for the sysfs related helper functions.
-
-# Test for the existence of a policy at /sys/fs/$FSTYP/$DEV/$ATTR
-#
-# All arguments are necessary, and in this order:
-#  - dev: device name, e.g. $SCRATCH_DEV
-#  - attr: path name under /sys/fs/$FSTYP/$dev
-#  - policy: policy within /sys/fs/$FSTYP/$dev
-#
-# Usage example:
-#   _has_fs_sysfs_attr_policy /dev/mapper/scratch-dev read_policy round-robin
-_has_fs_sysfs_attr_policy()
-{
-	local dev=$1
-	local attr=$2
-	local policy=$3
-
-	if [ ! -b "$dev" -o -z "$attr" -o -z "$policy" ]; then
-		_fail \
-	     "Usage: _has_fs_sysfs_attr_policy <mounted_device> <attr> <policy>"
-	fi
-
-	local dname=$(_fs_sysfs_dname $dev)
-	if ! test -e /sys/fs/${FSTYP}/${dname}/${attr}; then
-		return 1
-	fi
-
-	cat /sys/fs/${FSTYP}/${dname}/${attr} | grep -q ${policy}
-}
-
-# Require the existence of a sysfs entry at /sys/fs/$FSTYP/$DEV/$ATTR
-# and value in it contains $policy
-# All arguments are necessary, and in this order:
-#  - dev: device name, e.g. $SCRATCH_DEV
-#  - attr: path name under /sys/fs/$FSTYP/$dev
-#  - policy: mentioned in /sys/fs/$FSTYP/$dev/$attr
-#
-# Usage example:
-#   _require_fs_sysfs_attr_policy /dev/mapper/scratch-dev read_policy round-robin
-_require_fs_sysfs_attr_policy()
-{
-	_has_fs_sysfs_attr_policy "$@" && return
-
-	local dev=$1
-	local attr=$2
-	local policy=$3
-	local dname=$(_fs_sysfs_dname $dev)
-
-	_notrun "This test requires /sys/fs/${FSTYP}/${dname}/${attr} ${policy}"
-}
-
-_set_sysfs_policy()
-{
-	local dev=$1
-	local attr=$2
-	shift
-	shift
-	local policy=$@
-
-	_set_fs_sysfs_dev_attr $dev $attr ${policy}
-
-	case "$FSTYP" in
-	btrfs)
-		_get_fs_sysfs_dev_attr $dev $attr | grep -q "[${policy}]"
-		if [[ $? != 0 ]]; then
-			echo "Setting sysfs $attr $policy failed"
-		fi
-		;;
-	*)
-		_fail \
-"sysfs syntax verification for '${attr}' '${policy}' for '${FSTYP}' is not implemented"
-		;;
-	esac
-}
-
-_set_sysfs_policy_must_fail()
-{
-	local dev=$1
-	local attr=$2
-	shift
-	shift
-	local policy=$@
-
-	_set_fs_sysfs_dev_attr $dev $attr ${policy} | _filter_sysfs_error \
-							   | tee -a $seqres.full
-}
-
-# Verify sysfs attribute rejects invalid input.
-# Usage syntax:
-#   _verify_sysfs_syntax <$dev> <$attr> <$policy> [$value]
-# Examples:
-#   _verify_sysfs_syntax $TEST_DEV read_policy pid
-#   _verify_sysfs_syntax $TEST_DEV read_policy round-robin 4k
-# Note:
-#  Testcase must include
-#      . ./common/filter
-# Prerequisite checks are kept outside this function
-# to make them clear to the test case, rather than hiding
-# them deep inside another function.
-#      _require_fs_sysfs_attr_policy $TEST_DEV $attr $policy
-_verify_sysfs_syntax()
-{
-	local dev=$1
-	local attr=$2
-	local policy=$3
-	local value=$4
-
-	# Test policy specified wrongly. Must fail.
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
-	# Test policy longer than 32 chars fails stable.
-	_set_sysfs_policy_must_fail $dev $attr 'jfdkkkkjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjffjfjfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff'
-
-	# Test policy specified correctly. Must pass.
-	_set_sysfs_policy $dev $attr $policy
-
-	# If the policy has no value return
-	if [[ -z $value ]]; then
-		return
-	fi
-
-	# Test value specified wrongly. Must fail.
-	_set_sysfs_policy_must_fail $dev $attr "'$policy: $value'"
-	_set_sysfs_policy_must_fail $dev $attr "'$policy:$value '"
-	_set_sysfs_policy_must_fail $dev $attr "'$policy:$value typo'"
-	_set_sysfs_policy_must_fail $dev $attr "'$policy:${value}typo'"
-	_set_sysfs_policy_must_fail $dev $attr "'$policy :$value'"
-
-	# Test policy and value all specified correctly. Must pass.
-	_set_sysfs_policy $dev $attr $policy:$value
-}
diff --git a/tests/btrfs/253 b/tests/btrfs/253
index 5843643d..27c35dc9 100755
--- a/tests/btrfs/253
+++ b/tests/btrfs/253
@@ -25,7 +25,6 @@
 #       value is in megabytes.
 #
 . ./common/preamble
-. ./common/sysfs
 _begin_fstest auto
 
 # Parse a size string which is in the format "XX.XXMib".
@@ -226,7 +225,7 @@ alloc_size "Data" FOURTH_DATA_SIZE_MB
 # Force chunk allocation of system block type must fail.
 #
 echo "Force allocation of system block type must fail."
-_set_sysfs_policy_must_fail ${SCRATCH_BDEV} allocation/system/force_chunk_alloc 1
+_set_btrfs_sysfs_dev_policy_must_fail ${SCRATCH_BDEV} allocation/system/force_chunk_alloc 1
 
 #
 # Verification of initial allocation.
diff --git a/tests/btrfs/329 b/tests/btrfs/329
index f4fadded..9d6ccce9 100755
--- a/tests/btrfs/329
+++ b/tests/btrfs/329
@@ -9,13 +9,12 @@
 . ./common/preamble
 _begin_fstest auto quick
 
-. ./common/sysfs
 . ./common/filter
 
 _require_test
-_require_fs_sysfs_attr_policy $TEST_DEV read_policy round-robin
+_require_btrfs_sysfs_dev_policy $TEST_DEV read_policy round-robin
 
-_verify_sysfs_syntax $TEST_DEV read_policy round-robin 4096
+_verify_btrfs_sysfs_dev_syntax $TEST_DEV read_policy round-robin 4096
 
 status=0
 exit
diff --git a/tests/btrfs/334 b/tests/btrfs/334
index 08b66dc7..8c0f226e 100755
--- a/tests/btrfs/334
+++ b/tests/btrfs/334
@@ -9,13 +9,12 @@
 . ./common/preamble
 _begin_fstest auto quick
 
-. ./common/sysfs
 . ./common/filter
 
 _require_test
 _require_fs_sysfs_dev_attr $TEST_DEV allocation/data/chunk_size
 
-_verify_sysfs_syntax $TEST_DEV allocation/data/chunk_size 256m
+_verify_btrfs_sysfs_dev_syntax $TEST_DEV allocation/data/chunk_size 256m
 
 status=0
 exit
-- 
2.55.0

