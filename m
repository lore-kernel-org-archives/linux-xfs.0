Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AB6634D4D6;
	Tue, 28 Apr 2026 06:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777358599; cv=none; b=AwhCex4wqrB1oEddTRpasIzt1cZbQhPOYuWhV4xtYxvy01/QbxcfEtmMMuHPWOTJ845KKZdcZNOfemXwn8Vl9r/03hjFrsBZMEAw/zqBTsIheyPFLf7vGGe0w0xNEA52c+C02pR6dwvAjrk2z4wCoQpD/OVBVSGpMqtB4uJM5YQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777358599; c=relaxed/simple;
	bh=TRqMwolAX4yCDWXB0j0qpAqQz8UHvCOtRXRGaE/MMA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jdWGMwAwdXefLOah/8voH6Ii14y28PTlhPW+IwwAAVsFvuFrlADWNhlIV134yQvB+jm+QW+EHfOmhyT43eeT4C/whnm4QaBDyDRS/I/d6p13LbMLZGmyDA/tAXel8TwAvUWEt9CXySwE6It3QwCpzOme7lcIEx3cLi5GH0XJO6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XE2GMlNG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XE2GMlNG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99B8DC2BCAF;
	Tue, 28 Apr 2026 06:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777358599;
	bh=TRqMwolAX4yCDWXB0j0qpAqQz8UHvCOtRXRGaE/MMA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XE2GMlNG7gq2bTtYeHZAOAhjqnP6d27fF7kcuijBEVVdgCe5YxpaQFrBsTVZLsa/5
	 5/YsaM7+/oua6+DJLhuKL868G/k46EJ+5qOwAUbYeGtJded7y9nqI2WF5riPZnHrxr
	 ETv7NSobjASKRTPocxYtp0WDL9HlX9a7xsj3TsfO8RllS9usC0Xg4NrosmehDs2gnD
	 E/i8BpWBDqqOwGL8sNdAWWxqLAnBwp1WVjrfglsAYFgiSBYV7moruCN6gzvZRsI7ai
	 kO9XCyyAElQMeW1L7CsV9eMn2HmL328g7vbMo8h2osLoedcyNguv+zoopGyRnVvmzT
	 GtliUsutGUylw==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs@vger.kernel.org,
	amir73il@gmail.com,
	zlang@redhat.com,
	hch@infradead.org
Subject: [PATCH v4 3/9] fstests: add test for inotify isolation on cloned devices
Date: Tue, 28 Apr 2026 14:42:53 +0800
Message-ID: <01452c53ff400026796c4d43e2e23906ea9071ea.1777357321.git.asj@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1777357320.git.asj@kernel.org>
References: <cover.1777357320.git.asj@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a new test, to verify that the kernel correctly differentiates between
two block devices sharing the same FSID/UUID.

Signed-off-by: Anand Jain <asj@kernel.org>
---
 common/config         |  1 +
 tests/generic/800     | 89 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/800.out |  7 ++++
 3 files changed, 97 insertions(+)
 create mode 100644 tests/generic/800
 create mode 100644 tests/generic/800.out

diff --git a/common/config b/common/config
index 4fd4c2c8af11..605a57947a40 100644
--- a/common/config
+++ b/common/config
@@ -242,6 +242,7 @@ export BTRFS_MAP_LOGICAL_PROG=$(type -P btrfs-map-logical)
 export PARTED_PROG="$(type -P parted)"
 export XFS_PROPERTY_PROG="$(type -P xfs_property)"
 export FSCRYPTCTL_PROG="$(type -P fscryptctl)"
+export INOTIFYWAIT_PROG="$(type -P inotifywait)"
 
 # udev wait functions.
 #
diff --git a/tests/generic/800 b/tests/generic/800
new file mode 100644
index 000000000000..4b9bd3e4f487
--- /dev/null
+++ b/tests/generic/800
@@ -0,0 +1,89 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Anand Jain <asj@kernel.org>.  All Rights Reserved.
+#
+# FS QA Test 800
+#
+# Verify if the kernel or userspace becomes confused when two block devices
+# share the same fid/fsid/uuid. Create inotify on both original and cloned
+# filesystem. Monitor the notification in the respective logs.
+
+. ./common/preamble
+
+_begin_fstest auto quick mount clone
+
+_require_test
+_require_block_device $TEST_DEV
+_require_loop
+_require_command "$INOTIFYWAIT_PROG" inotifywait
+
+_cleanup()
+{
+	cd /
+	[[ -n $pid1 ]] && { kill -TERM "$pid1" 2> /dev/null; wait $pid1; }
+	[[ -n $pid2 ]] && { kill -TERM "$pid2" 2> /dev/null; wait $pid2; }
+	rm -r -f $tmp.*
+	_unmount $mnt1 2>/dev/null
+	_unmount $mnt2 2>/dev/null
+	_loop_image_destroy "${devs[@]}" 2> /dev/null
+}
+
+devs=()
+_loop_image_create_clone devs
+mkdir -p $TEST_DIR/$seq
+mnt1=$TEST_DIR/$seq/mnt1
+mnt2=$TEST_DIR/$seq/mnt2
+mkdir -p $mnt1
+mkdir -p $mnt2
+
+_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[0]} $mnt1 || \
+						_fail "Failed to mount dev1"
+_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[1]} $mnt2 || \
+						_fail "Failed to mount dev2"
+
+log1=$tmp.inotify1
+log2=$tmp.inotify2
+
+pid1=""
+pid2=""
+echo "Setup inotify watchers on both mnt1 and mnt2"
+$INOTIFYWAIT_PROG -m -e create --format '%f' $mnt1 > $log1 2>&1 &
+pid1=$!
+$INOTIFYWAIT_PROG -m -e create --format '%f' $mnt2 > $log2 2>&1 &
+pid2=$!
+sleep 2
+
+echo "Trigger file creation on mnt1"
+touch $mnt1/file_on_mnt1
+sync
+sleep 1
+
+echo "Trigger file creation on mnt2"
+touch $mnt2/file_on_mnt2
+sync
+sleep 1
+
+echo "Verify inotify isolation"
+kill $pid1 $pid2
+wait $pid1 $pid2 2>/dev/null
+pid1=""
+pid2=""
+
+if grep -q "file_on_mnt1" $log1 && ! grep -q "file_on_mnt2" $log1; then
+	echo "SUCCESS: mnt1 events isolated."
+else
+	echo "FAIL: mnt1 inotify confusion!"
+	[ ! -s $log1 ] && echo "  - mnt1 received no events."
+	grep -q "file_on_mnt2" $log1 && echo "  - mnt1 received event from mnt2."
+fi
+
+if grep -q "file_on_mnt2" $log2 && ! grep -q "file_on_mnt1" $log2; then
+	echo "SUCCESS: mnt2 events isolated."
+else
+	echo "FAIL: mnt2 inotify confusion!"
+	[ ! -s $log2 ] && echo "  - mnt2 received no events."
+	grep -q "file_on_mnt1" $log2 && echo "  - mnt2 received event from mnt1."
+fi
+
+status=0
+exit
diff --git a/tests/generic/800.out b/tests/generic/800.out
new file mode 100644
index 000000000000..b10842a31210
--- /dev/null
+++ b/tests/generic/800.out
@@ -0,0 +1,7 @@
+QA output created by 800
+Setup inotify watchers on both mnt1 and mnt2
+Trigger file creation on mnt1
+Trigger file creation on mnt2
+Verify inotify isolation
+SUCCESS: mnt1 events isolated.
+SUCCESS: mnt2 events isolated.
-- 
2.43.0

