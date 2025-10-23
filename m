Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A9D81D555;
	Thu, 23 Oct 2025 00:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761178654; cv=none; b=FADUqx8Az2e49pn64b4Qtgj7cGjj1SwCpKVlRrFm5Pq1UkzRMrXW2J32/6ygYU3TXC9AHJqr5+TsECuqLByTIVEOMc+MgedqZ8+opg7OpYPANhD5kg7AIFIn2Vio66kWv/CB/STKpZ4wK6yRXiI+fOvZDOsjHTjZHadgVg+rp8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761178654; c=relaxed/simple;
	bh=gf7j8DqwQ4j+yuRQPJln2C8hZMrop2pR5zmPLnlMy9Q=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Bxtf2OWLuRv2S256RC8vjHopvLaV8Eesc0MjrOBYAEVYKR7uW2e9a8zyrde/CRTNWvaXBbRdi8lc5d9dwajazElIVT6BJ4ShtGKNIoJzQ6ds8FGlqURxzOI+eAYv9PbrrgV2JOLsYfbBhdhveouvo/pDDBEb7/YNd4yktXzS1L4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lWiioAvN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lWiioAvN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0696C4CEE7;
	Thu, 23 Oct 2025 00:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761178653;
	bh=gf7j8DqwQ4j+yuRQPJln2C8hZMrop2pR5zmPLnlMy9Q=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lWiioAvNsEgL48U+/X/Rpmz+iZlR6VIEnuNH4/VeQd09s7WqpFvBHZ+Y+/cCsmAdJ
	 +/bIA4gc6N9tKhLOX2mWL3BnUz7bumVxhvHa2pxSPWC9H4kz4ddYxoBGVs3PiRv1PZ
	 jUZpO5QPwP0opQTgZxxdpKYgrzjHHwGKm5pyhkG012Lh6d1Gmy7v7/pzJcY+VA6QO7
	 MegGgy+P4OoePNFMtmyZod6JBiTbnr1JMkJTSYcSlAkzzy4iA705MFGMQssXmMSlG1
	 qyTZLcdKyJLaoNeSs9amEPj6jCF/0ad0V1HImTjb62tBLz61DfE5eaxF0COHZFobct
	 J96TwUzl/UEnA==
Date: Wed, 22 Oct 2025 17:17:33 -0700
Subject: [PATCH 1/4] xfs: test health monitoring code
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <176117749450.1030150.4760727036227745845.stgit@frogsfrogsfrogs>
In-Reply-To: <176117749414.1030150.3638956559465976455.stgit@frogsfrogsfrogs>
References: <176117749414.1030150.3638956559465976455.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Add some functionality tests for the new health monitoring code.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 doc/group-names.txt |    1 +
 tests/xfs/1885      |   53 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1885.out  |    5 +++++
 3 files changed, 59 insertions(+)
 create mode 100755 tests/xfs/1885
 create mode 100644 tests/xfs/1885.out


diff --git a/doc/group-names.txt b/doc/group-names.txt
index 10b49e50517797..158f84d36d3154 100644
--- a/doc/group-names.txt
+++ b/doc/group-names.txt
@@ -117,6 +117,7 @@ samefs			overlayfs when all layers are on the same fs
 scrub			filesystem metadata scrubbers
 seed			btrfs seeded filesystems
 seek			llseek functionality
+selfhealing		self healing filesystem code
 selftest		tests with fixed results, used to validate testing setup
 send			btrfs send/receive
 shrinkfs		decreasing the size of a filesystem
diff --git a/tests/xfs/1885 b/tests/xfs/1885
new file mode 100755
index 00000000000000..73fd1a5392056e
--- /dev/null
+++ b/tests/xfs/1885
@@ -0,0 +1,53 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2024-2025 Oracle.  All Rights Reserved.
+#
+# FS QA Test 1885
+#
+# Make sure that healthmon handles module refcount correctly.
+#
+. ./common/preamble
+_begin_fstest auto selfhealing
+
+. ./common/filter
+. ./common/module
+
+refcount_file="/sys/module/xfs/refcnt"
+test -e "$refcount_file" || _notrun "cannot find xfs module refcount"
+
+_require_test
+_require_xfs_io_command healthmon
+
+# Capture mod refcount without the test fs mounted
+_test_unmount
+init_refcount="$(cat "$refcount_file")"
+
+# Capture mod refcount with the test fs mounted
+_test_mount
+nomon_mount_refcount="$(cat "$refcount_file")"
+
+# Capture mod refcount with test fs mounted and the healthmon fd open.
+# Pause the xfs_io process so that it doesn't actually respond to events.
+$XFS_IO_PROG -c 'healthmon -c -v' $TEST_DIR >> $seqres.full &
+sleep 0.5
+kill -STOP %1
+mon_mount_refcount="$(cat "$refcount_file")"
+
+# Capture mod refcount with only the healthmon fd open.
+_test_unmount
+mon_nomount_refcount="$(cat "$refcount_file")"
+
+# Capture mod refcount after continuing healthmon (which should exit due to the
+# unmount) and killing it.
+kill -CONT %1
+kill %1
+wait
+nomon_nomount_refcount="$(cat "$refcount_file")"
+
+_within_tolerance "mount refcount" "$nomon_mount_refcount" "$((init_refcount + 1))" 0 -v
+_within_tolerance "mount + healthmon refcount" "$mon_mount_refcount" "$((init_refcount + 2))" 0 -v
+_within_tolerance "healthmon refcount" "$mon_nomount_refcount" "$((init_refcount + 1))" 0 -v
+_within_tolerance "end refcount" "$nomon_nomount_refcount" "$init_refcount" 0 -v
+
+status=0
+exit
diff --git a/tests/xfs/1885.out b/tests/xfs/1885.out
new file mode 100644
index 00000000000000..f152cef0525609
--- /dev/null
+++ b/tests/xfs/1885.out
@@ -0,0 +1,5 @@
+QA output created by 1885
+mount refcount is in range
+mount + healthmon refcount is in range
+healthmon refcount is in range
+end refcount is in range

