Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793818078;
	b=tJRJRrwfoKHb3JHYzY6w7V4ltMLFi4Y3oTrj0njFlk5GyMeM8VSTZL5KFqqUI6GVJNLT
	 Gp2NL6SYDwucrojGc9wp2uJIEeLpktcz0RFVq/NcxnoXeXY6Dp4EKZwSpHIBUQ1O6A4Hq
	 Ex30TH6BIsC353WB8cxnIGz77ukrXrtTDKOnfYw3CsA4onri859y7xtW71Y90ah8yPUjD
	 Rpa5urLItyBCj3V/eDBGMjjMFg/Sxt1qzDlN0HCGWUUXOoIyu/9TXPZLSO7QuMGkMdQkq
	 lJhmey5rko7RJttqVoYS9WsjorDwRIhLumyHRCmqF8rTjZa7ejHBmVxyPV4AseQwpRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793818078;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=kAWfIkz2OnVli6BBpBv4zQKVqOk9m5WzaEmNb/yXk6Y=;
	b=anBo1RtXLWCld4VJIa7YeS+PNsHjRyiQwxNX/tvaHd8XiiDbrdr/Oe08cHnZbpwo5nHv
	 FzTICPCrcqO+oIsb3M9tcrrg0Er2duRm4YqmVU/102ZBQxM5+kovrvW+ROAGMKhXxUECN
	 w1cqoC7IzByb9nBClRYLFUHdCa9Ir6zgxxv8dNqCscW5XjjWfFEA67WhZS0U59ubtWfmr
	 1qIE0pp2ozS8OPhKBN77jYMFY7QM0NcKP5oxGvF9ewg2yVdXzg7IH8B4HwhuphJqHo6Fa
	 rmd36dXZU5aYKh6GnXDBdOrihiX/F3aJOv1UdvajXPNmv9bdxFYQgf5o8GkeXZqng1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DYEzEbiS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0280606A328;
	Wed,  4 Nov 2026 18:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DYEzEbiS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66E381F000C1;
	Wed,  4 Nov 2026 18:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793818077;
	bh=kAWfIkz2OnVli6BBpBv4zQKVqOk9m5WzaEmNb/yXk6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DYEzEbiSEOQNaf6miKO5LJsWT2A3yiVPyv2GWd3HFjJ74iVBlncH1ZnhHepsv+4FA
	 PNIypiIy1sZ11TrVe8TTeYHR0rY5431CHYM9XMMTs9C6bHG5E/4T/8H5orj4o3i3Ta
	 EFlxuMNdXnA6n9u6CRNvkp/vOvb+nOXuV1OD4HRl2tNLDaVu32ChqgQ7MdCZXPZ7T9
	 gFgfk9TSk69Zmbr2NLC0UX8yxOhmjimS3L/uFypaYlFh0jqyUvqn9aPaF+6Qaj02Ko
	 5ECtHc+m3coZT46HvoYqLyYgX1umqbp8Mx8q2+rabNGnGtSzZfrLDNDjvWjZ2wlyj3
	 GqrOlIoJNLgAQ==
From: Zorro Lang <zlang@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	Anand Suveer Jain <asj@kernel.org>,
	Chao Yu <chao@kernel.org>,
	Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v3 3/6] common: move btrfs-only sysfs policy helpers out of common/sysfs
Date: Thu,  5 Nov 2026 02:47:33 +0800
Message-ID: <20261104184736.1564283-4-zlang@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104184736.1564283-1-zlang@kernel.org>
References: <20261104184736.1564283-1-zlang@kernel.org>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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
index 88ac0b4d..a8d30419 100755
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
index 5f97ec20..1d32d06e 100755
--- a/tests/btrfs/334
+++ b/tests/btrfs/334
@@ -9,13 +9,12 @@
 . ./common/preamble
 _begin_fstest auto quick
 
-. ./common/sysfs
 . ./common/filter
 
 _require_test
 _require_test_sysfs_dev_attr allocation/data/chunk_size
 
-_verify_sysfs_syntax $TEST_DEV allocation/data/chunk_size 256m
+_verify_btrfs_sysfs_dev_syntax $TEST_DEV allocation/data/chunk_size 256m
 
 status=0
 exit
-- 
2.56.0

