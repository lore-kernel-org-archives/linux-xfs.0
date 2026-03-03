Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C93219C546;
	Tue,  3 Mar 2026 00:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772498468; cv=none; b=NL54FYXqTzmNZ6CrTqb2YU4XnEomIVf6c2B7RZf/WS8bgUk/5sAe5sx13pA6F5UrxguI45NhH3Cj4+Krw0yUiKJ98z4AuY3z1yaa/gnv33nSoo0+FHIxQm4rogp6FbK/yHCnQpLsNUNFIc62GFAVP/gb/nVON1Oz4g5kS7Uz/q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772498468; c=relaxed/simple;
	bh=p1pYSqx0+XQQKTHczhAEnrV8MbMSxF3iKDe6Z8riQzI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UmYs5wT0RMOtHkH7C6S9S03FHmFWHhIGNu677CBnfvTY90ec29n6GUJw1TOk/EkWri02T3Q8nMuX7Y2Z2AtSuWBkD/rt0eGL6zX9AixXUx1WhCojvJVZsz0HdFqmRERJsEJ7XyfZbiy4ii782vlhV+PfN2GJeLaOdsYX6fcxHhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HIMKSizi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HIMKSizi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28828C2BC86;
	Tue,  3 Mar 2026 00:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772498468;
	bh=p1pYSqx0+XQQKTHczhAEnrV8MbMSxF3iKDe6Z8riQzI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HIMKSiziS3rQxQK65/z1DF3uT53YCwb+s7UBAyuOlCIAPRnBIpep1qgMNrBIKLh/1
	 w9Urw50H/1uZjFbM+X52N1ZryX+MZ1+ox5hoFssKr0FF/bDAcOElwO2Xnpqss/twIw
	 VuJFNaq2irEBpv5EB543KGhYFz3EkI/aW0fRYeqIqeA3pPcBuUXSVO8HA7JzOypzL3
	 rY/xflBfdkzuEPMJxdLrvgkef99WL2E7lsSc1LTA3DTHlwwtlqNslarvYEEGPz+OAh
	 ola5MNRBG1m5Jlz8bo7vc1JPBABCSywqR51mmwmxRkdC+eEvZmYZeuYFGK5Pmbm7Gf
	 OlykEqUcZK2Cg==
Date: Mon, 02 Mar 2026 16:41:07 -0800
Subject: [PATCH 01/13] xfs: test health monitoring code
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <177249785787.483507.3326797286262755687.stgit@frogsfrogsfrogs>
In-Reply-To: <177249785709.483507.8373602184765043420.stgit@frogsfrogsfrogs>
References: <177249785709.483507.8373602184765043420.stgit@frogsfrogsfrogs>
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
index 00000000000000..1d75ef19c7c9d9
--- /dev/null
+++ b/tests/xfs/1885
@@ -0,0 +1,53 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2024-2026 Oracle.  All Rights Reserved.
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

