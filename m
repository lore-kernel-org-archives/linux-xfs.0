Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B84C429415;
	Tue, 31 Dec 2024 23:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735689457; cv=none; b=UTKqHAXYAFIV8B3uB1SnzbJGOU99HlGJTNcFBGWYFMYvYaf/jjoeCMDoP3j6IB3Mr2rnn2qWvO8QQSe5to5PZoznDb2ayGfFfQ0jLqoMLEeE+iASwDViZKG6rIrM5SuQVKEWaIS/MZ0UDsSRA+bvTd0Yg6tbHRxQXkg/33sBaGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735689457; c=relaxed/simple;
	bh=Le/zm7U7Svhw4MXdFYfy+X3/5IbdhEI3vE+bSjIxFf8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C6m7+To0RWRiYOHDRNHA9wpO1/G/BmhQownPv2xO1+jSs4S05qM52BB9SpEw5JrHThF/lJbwh1hgTyyZUS/5rAnElcM+ll0dqSFjJ2eHCNr5RRst84fZkosu9s5A4SwE/EGDYBN47yDdYJHsp2zUHAOPD9osq97HemNEKadhqJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gtXjk3Oh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gtXjk3Oh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B97EC4CED2;
	Tue, 31 Dec 2024 23:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735689457;
	bh=Le/zm7U7Svhw4MXdFYfy+X3/5IbdhEI3vE+bSjIxFf8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=gtXjk3Oh11/lPOZTnTkFwm+Se53/u+TutukuDEzxMThMw/fYlieq9YyvJO33oGdw2
	 M0Ul5EZy4zZVC6dBsxMLYl9vrMwZqLIrAiSi/pxpPrviAgXYhMg7PHg+VVA5tBYMac
	 mt/TcRjO74QAv/DFmFbyct1VbkP8o3NRCLPcP0aH6VTyU+CuOVXNKqv6GlroJ+u3O6
	 2fIiq3PIbpboQ9Vf4JJdjVBz8kTaaPW4kRGYnp+czRCZ+2q5xLtMOIcmGhF5WCVo6g
	 ZA6AOLI9MSth75IXXjF29qo6yICkkizO9HV9bH7v0X+zAAa5WEgdw1Qx/YQeyaI+yl
	 GdH0a0cPNst2g==
Date: Tue, 31 Dec 2024 15:57:37 -0800
Subject: [PATCH 3/6] xfs: test health monitoring code
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173568783179.2712254.8093422109753152079.stgit@frogsfrogsfrogs>
In-Reply-To: <173568783121.2712254.10238353363026075180.stgit@frogsfrogsfrogs>
References: <173568783121.2712254.10238353363026075180.stgit@frogsfrogsfrogs>
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
index b04d0180e8ec02..8fbb260d8c7bb5 100644
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
index 00000000000000..1b87af3a9178fc
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
+$XFS_IO_PROG -c 'healthmon -c -v' $TEST_DIR &
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

