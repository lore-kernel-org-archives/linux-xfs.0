Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD07B2E8E08;
	Thu, 25 Sep 2025 09:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758792634; cv=none; b=U/d+GcolUXqTVv72ekbcCUfCTK96yBzmLfPFJAN+A0w7F/QBoyy/BLcSTJBojhR2OGZSbzmThsW/ME+Hpn/05GymmMUn8fp7N5p48Ohb4Pe59GX2Uwum5nEVDgGq49AHIpacZoqUIPEgH0Vi57COeuu4aUQLfotF8qDvZpSRM5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758792634; c=relaxed/simple;
	bh=8EdRATLQJC+x0x6sRG682jNp1lICRAVFLuBuRe4iR50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qq+KIEGZo2bjYexPo03eq6ZFm42pdo+dNAJtEH5k9/A4Xv/IcJu3MAflgb3tPTwV5/T936fiK8zLA63IW7tFoipsvkQetScz0MVO/lGbvdIiyafnQFXHXhzQyrQSUqS0KkrvMywthL+otaaBBA7QtuByAcKUd0gXnXwDEJ5tySE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WT5Uy8ee; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WT5Uy8ee"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67843C4CEF7;
	Thu, 25 Sep 2025 09:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758792634;
	bh=8EdRATLQJC+x0x6sRG682jNp1lICRAVFLuBuRe4iR50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WT5Uy8eeAePazQXKu67wHqdQ/WdiAiNMc7+B+kvMkzQjKFzcOXIYJSU6nPxzT/zMx
	 FxC2qeKa4cwAP9sSUIh1eRZedsmDtHJM5zF4VxUuJ7PPoUY7Vg7V09L0dVlhgQsSYf
	 hle5GS5IvTf3yo/tX1vZG3s5y5ZMnCq50bdDK+OZUmJrG0EAAlGgjvRNhb9JmYyv/U
	 RaxMvst519VETElcfB45a+ipMghloUrQcAW/yc7rglCiCMGj3iAvY0fEkaxoy2rKOK
	 CaTfVYAPH+xgu/2xQ0DJdmHqM93swbsrZQh4c+YY46RwZj7SHp20RU4Xpa8Ry0RRBN
	 E9QIraur+3lyw==
From: cem@kernel.org
To: zlang@redhat.com
Cc: djwong@kernel.org,
	linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: [PATCH 3/3] xfs/539: Remove test for good
Date: Thu, 25 Sep 2025 11:29:26 +0200
Message-ID: <20250925093005.198090-4-cem@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250925093005.198090-1-cem@kernel.org>
References: <20250925093005.198090-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

This check deprecation warnings are not being printed during remount for
both attr2 and ikeep mount options.

Both options are now gone in 6.17, so this test not only is pointless
from 6.17 and above, but will always fail due the lack of these options.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 tests/xfs/539     | 72 -----------------------------------------------
 tests/xfs/539.out |  2 --
 2 files changed, 74 deletions(-)
 delete mode 100755 tests/xfs/539
 delete mode 100644 tests/xfs/539.out

diff --git a/tests/xfs/539 b/tests/xfs/539
deleted file mode 100755
index 5098be4a9351..000000000000
--- a/tests/xfs/539
+++ /dev/null
@@ -1,72 +0,0 @@
-#! /bin/bash
-# SPDX-License-Identifier: GPL-2.0
-# Copyright (c) 2020 Red Hat, Inc.. All Rights Reserved.
-#
-# FS QA Test 539
-#
-# https://bugzilla.kernel.org/show_bug.cgi?id=211605
-# Verify that the warnings are not printed on remount if the mount option has
-# the same value as during the mount
-#
-# Regression test for commit:
-# 92cf7d36384b xfs: Skip repetitive warnings about mount options
-
-. ./common/preamble
-_begin_fstest auto quick mount
-
-# Import common functions.
-
-_fixed_by_kernel_commit 92cf7d36384b \
-	"xfs: Skip repetitive warnings about mount options"
-
-_require_check_dmesg
-_require_scratch
-
-log_tag()
-{
-	echo "fstests $seqnum [tag]" > /dev/kmsg
-}
-
-dmesg_since_test_tag()
-{
-	dmesg | tac | sed -ne "0,\#fstests $seqnum \[tag\]#p" | \
-		tac
-}
-
-check_dmesg_for_since_tag()
-{
-	dmesg_since_test_tag | grep -E -q "$1"
-}
-
-echo "Silence is golden."
-
-# Skip old kernels that did not print the warning yet
-log_tag
-_scratch_mkfs > $seqres.full 2>&1
-_scratch_mount -o attr2
-_scratch_unmount
-check_dmesg_for_since_tag "XFS: attr2 mount option is deprecated" || \
-	_notrun "Deprecation warning are not printed at all."
-
-# Test mount with default options (attr2 and noikeep) and remount with
-# 2 groups of options
-# 1) the defaults (attr2, noikeep)
-# 2) non defaults (noattr2, ikeep)
-_scratch_mount
-for VAR in {attr2,noikeep}; do
-	log_tag
-	_scratch_remount $VAR
-	check_dmesg_for_since_tag "XFS: $VAR mount option is deprecated." && \
-		echo "Should not be able to find deprecation warning for $VAR"
-done
-for VAR in {noattr2,ikeep}; do
-	log_tag
-	_scratch_remount $VAR >> $seqres.full 2>&1
-	check_dmesg_for_since_tag "XFS: $VAR mount option is deprecated" || \
-		echo "Could not find deprecation warning for $VAR"
-done
-_scratch_unmount
-
-# success, all done
-status=0
-exit
diff --git a/tests/xfs/539.out b/tests/xfs/539.out
deleted file mode 100644
index 038993426333..000000000000
--- a/tests/xfs/539.out
+++ /dev/null
@@ -1,2 +0,0 @@
-QA output created by 539
-Silence is golden.
-- 
2.51.0

