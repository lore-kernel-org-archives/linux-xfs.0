Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 928B6399007;
	Tue, 10 Mar 2026 03:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773114624; cv=none; b=bALIYGpLHF/Aet474+q59fBtcGr1M5sXkVEWcx6+Vpc7v4xSd/KsbGMBsh853BVM4vpPXDH0P79ys2qjDaxjOVmDhWP9jfWGQ3iDI+FD3bgh1BENzMqnf/zSuN8iXMFyEikfo/WfF/tjQM8UUO5MwS3hJ4o59j7DkpEa/+JJ8cA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773114624; c=relaxed/simple;
	bh=N/tpqL5Pkp74PoYQ+id0CtOVrQ93noURyTfS6IfFbjM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CeKsp32hOF9xFTJ3yarAkqN0qljyF7C7ODmGd4795NDz3RdvDmTSPx2NJpI2Ch7NJ8cFBAwKT5fdnrCq008H/QI3RgDhqYoBTsqA3VJn1aJE1iA/PkJO6Hj/0dO7TL4FXhMP1BPzOr3GMJ7L9L+L+QmAP14JzQT5CvpIsGH4mGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HN4fxEJi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HN4fxEJi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C2E2C19423;
	Tue, 10 Mar 2026 03:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773114624;
	bh=N/tpqL5Pkp74PoYQ+id0CtOVrQ93noURyTfS6IfFbjM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HN4fxEJiZWjKjSxBFWyZHQZlyDnYsbq0lqgGPXuBSJ8ma3f5O2iEJ1sErICA+CI8I
	 VsyJ0NnWDBK28u6eaPu4Re/vIjruzB/lI1MHI8b6hzvffrsUIK5pZnG+y3biG+MUpI
	 /sj/H5jReZn7STtOCebNe0Sdj/7Z31jez2cXQp4Q+wGHlLbnEnjFJB8Wiu9RsDxWZx
	 MB1zZJYhdRo9ZlhS5uzE3UfKBTH5XVFl6mbC2E73Dq0mr4Gl7XZtMQAh/JYD4DhECs
	 ODaNJ7xGbHbtxw+smkUH5KkNsciVqy/Vh8XFWG8CkFwQYz6CZQh+unrQ38N4/9oHOn
	 HMKp0t4f7M3AA==
Date: Mon, 09 Mar 2026 20:50:23 -0700
Subject: [PATCH 01/14] xfs: test health monitoring code
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <177311403795.1186408.11292081408049550687.stgit@frogsfrogsfrogs>
In-Reply-To: <177311403712.1186408.7032564474004561606.stgit@frogsfrogsfrogs>
References: <177311403712.1186408.7032564474004561606.stgit@frogsfrogsfrogs>
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
 common/module      |   11 ++++++++++
 tests/xfs/1885     |   59 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1885.out |    5 ++++
 3 files changed, 75 insertions(+)
 create mode 100755 tests/xfs/1885
 create mode 100644 tests/xfs/1885.out


diff --git a/common/module b/common/module
index 697d76ba718bbc..c0529b65ad6e2b 100644
--- a/common/module
+++ b/common/module
@@ -225,3 +225,14 @@ _optional_reload_fs_module()
 		_test_loadable_fs_module "$@" 2>&1 | \
 		sed -e '/patient module removal/d'
 }
+
+_require_module_refcount()
+{
+	local refcount_file="/sys/module/$1/refcnt"
+	test -e "$refcount_file" || _notrun "cannot find $1 module refcount"
+}
+
+_module_refcount()
+{
+	cat "/sys/module/$1/refcnt"
+}
diff --git a/tests/xfs/1885 b/tests/xfs/1885
new file mode 100755
index 00000000000000..d44b29d1c57e06
--- /dev/null
+++ b/tests/xfs/1885
@@ -0,0 +1,59 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2024-2026 Oracle.  All Rights Reserved.
+#
+# FS QA Test 1885
+#
+# Make sure that healthmon handles module refcount correctly.
+#
+. ./common/preamble
+_begin_fstest auto selfhealing quick
+
+. ./common/filter
+. ./common/module
+
+_cleanup()
+{
+	test -n "$healer_pid" && kill $healer_pid &>/dev/null
+	cd /
+	rm -r -f $tmp.*
+}
+
+_require_test
+_require_xfs_io_command healthmon
+_require_module_refcount xfs
+
+# Capture mod refcount without the test fs mounted
+_test_unmount
+init_refcount="$(_module_refcount xfs)"
+
+# Capture mod refcount with the test fs mounted
+_test_mount
+nomon_mount_refcount="$(_module_refcount xfs)"
+
+# Capture mod refcount with test fs mounted and the healthmon fd open.
+# Pause the xfs_io process so that it doesn't actually respond to events.
+$XFS_IO_PROG -c 'healthmon -c -v' $TEST_DIR >> $seqres.full &
+healer_pid=$!
+sleep 0.5
+kill -STOP $healer_pid
+mon_mount_refcount="$(_module_refcount xfs)"
+
+# Capture mod refcount with only the healthmon fd open.
+_test_unmount
+mon_nomount_refcount="$(_module_refcount xfs)"
+
+# Capture mod refcount after continuing healthmon (which should exit due to the
+# unmount) and killing it.
+kill -CONT $healer_pid
+kill $healer_pid
+wait
+nomon_nomount_refcount="$(_module_refcount xfs)"
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

