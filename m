Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D17D3ED5D6;
	Tue,  6 Oct 2026 08:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791277006; cv=none; b=bCZWeTI/fH/e06kKrFLZqlK7ZSUy4XBKdKpW0QHmxGOVvqJcx++aXCIfpxHpGv0yQrJP3jN3EHAcfbSG6jzGGDpjRrpvzzFhEUFw2Ph3Qa0lgfdVXTVq6aigrxDNk+G/abx1NV+lu+qV1gcpvEeZnbWUzTQwFOEoVbA71yyf0yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791277006; c=relaxed/simple;
	bh=2HjebHF7T6YxAHOqYeygmHwq1CqIld73cVUBZNx144U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kZ1Hm5R0YlMVt5J0+PNL8iYG9IXCOrap+44bJi0VzyV6+rNTkAQvV6U++DeMu+aZiPJ2UI/mZOJ7kdRt9+PagbfD8hMyBmcIpJ9rykU8TZkrCwoaPvbwTwH4mGhWG7Om8OGsIES2/4dX9qHihKe/F1p6dwIwVO44t1i1Rfc0HkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kFwbTMmc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kFwbTMmc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E46111F00893;
	Tue,  6 Oct 2026 08:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791277004;
	bh=sIQ1rBSTohGKXCssWuhmCPutMCMuff7MWW945lTxsCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kFwbTMmccrcK+qbRkaf3Cm2yz7SPrmNjIBrSlbQu7E+WDg01E+mwChy7YsjJJokV8
	 AiSFhi2Yl53Tf7RfmLQ4+v5bhs8r9EcWZqyryBcQggBs/KZGJSY9jfsnOBUg7mrTmf
	 0g5NXKwSA+eL64uxzxwo/S0C07qt5E6/gGNGC/khsAbQKz2dCxUoCxj8lnSaICMNHI
	 2fch3B1H6QOiyQ9Oet+2XtbodvuasAIZ3TjDH9qwLi4MWQPMdfbJdpvnZbBtsDHzTT
	 01KcZIpChC+DWAqo46rDzsoeokeBGxW9XVYznrNS6goHj19VoAnF/rlFSi1BwI5IbV
	 qVIPU0JqYEgyQ==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: zlang@kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 15/21] fstests: verify exportfs file handles on cloned filesystems
Date: Tue,  6 Oct 2026 16:55:41 +0800
Message-ID: <40f9fa47341946da9edbe10498c3d8d789ce202f.1791272793.git.asj@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1791272793.git.asj@kernel.org>
References: <cover.1791272793.git.asj@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Ensure that exportfs can correctly decode file handles on a cloned
filesystem across a mount cycle, by file handles generated on a
cloned device remain valid after mount cycle.

Signed-off-by: Anand Jain <asj@kernel.org>
---
 tests/generic/905     | 79 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/905.out |  2 ++
 2 files changed, 81 insertions(+)
 create mode 100644 tests/generic/905
 create mode 100644 tests/generic/905.out

diff --git a/tests/generic/905 b/tests/generic/905
new file mode 100644
index 000000000000..d69c613110db
--- /dev/null
+++ b/tests/generic/905
@@ -0,0 +1,79 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Anand Jain <asj@kernel.org>.  All Rights Reserved.
+#
+# FS QA Test No. 905
+# Verify that file handles encoded on a cloned filesystem remain valid and
+# resolvable via open_by_handle across a mount cycle and mount order swap.
+
+. ./common/preamble
+
+_begin_fstest auto quick exportfs tempfsid
+
+_require_test
+_require_exportfs
+_require_loop
+_require_test_program "open_by_handle"
+
+_cleanup()
+{
+	cd /
+	rm -r -f $tmp.*
+	_unmount $mnt1 2>/dev/null
+	_unmount $mnt2 2>/dev/null
+	_destroy_cloned_loop_devs "${devs[@]}" 2> /dev/null
+}
+
+# Create test dir and test files, encode file handles and store to tmp file
+create_test_files()
+{
+	rm -rf $testdir
+	mkdir -p $testdir
+	$here/src/open_by_handle -cwp -o $tmp.handles_file $testdir $NUMFILES
+}
+
+# Attempt to read and decode the saved file handles on the targeted mount point.
+test_file_handles()
+{
+	local opt=$1
+	local when=$2
+
+	echo test_file_handles after $when
+	$here/src/open_by_handle $opt -i $tmp.handles_file $mnt2 $NUMFILES
+}
+
+rm -rf $TEST_DIR/$seq 2>/dev/null
+mkdir -p $TEST_DIR/$seq
+# Setup base loop device and its clone
+devs=()
+_create_cloned_loop_devs devs
+mnt1=$TEST_DIR/$seq/mnt1
+mnt2=$TEST_DIR/$seq/mnt2
+mkdir -p $mnt1
+mkdir -p $mnt2
+
+# Mount both identical UUID filesystems simultaneously
+_mount $(_common_dev_mount_options) $(_clone_mount_options) ${devs[0]} $mnt1 || \
+						_fail "Failed to mount dev1"
+_mount $(_common_dev_mount_options) $(_clone_mount_options) ${devs[1]} $mnt2 || \
+						_fail "Failed to mount dev2"
+
+NUMFILES=1
+testdir=$mnt2/testdir
+
+# Decode file handles of files/dir after cycle mount
+create_test_files
+
+# Cycle mounts and reverse initialization sequence to check if
+# file handle lookups are okay
+_unmount $mnt1
+_unmount $mnt2
+_mount $(_common_dev_mount_options) $(_clone_mount_options) ${devs[1]} $mnt2 || \
+						_fail "Failed to mount dev2"
+_mount $(_common_dev_mount_options) $(_clone_mount_options) ${devs[0]} $mnt1 || \
+						_fail "Failed to mount dev1"
+
+# Verify file handles can still be resolved post-mount-cycle
+test_file_handles -rp "cycle mount"
+
+_exit 0
diff --git a/tests/generic/905.out b/tests/generic/905.out
new file mode 100644
index 000000000000..234f5ec35863
--- /dev/null
+++ b/tests/generic/905.out
@@ -0,0 +1,2 @@
+QA output created by 905
+test_file_handles after cycle mount
-- 
2.43.0

