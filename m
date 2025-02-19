Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACBA946447;
	Wed, 19 Feb 2025 01:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739927285; cv=none; b=lmDCPWlmA6hR07E54GF9F0EMxF4lp56K3G8JvZztVp0ct6Y21ZRotzlPqP/UK+rXvjS5AwdiW+6mmZj4D0sxwW1/FtZSZP9CESwoWCrOOYOeJksmvInP24KC+Dxmeb1+thKSXuMGPYnmlOiTrModEi6DqzrpF8VSgbeJx0pj8BI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739927285; c=relaxed/simple;
	bh=njMWAfLRtww//2/3OVcXVe6jG2m8raReSR1qyGBMq3c=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aO3O6lbMlEYDfHlaoapii1K9vh+VT3Wng9jIdIaGQYWjwYPBZbJAozoMkCzkr9tApi4oAZ1DQfmY+rastrtp+n8035xaV/lQkyPBLayFtqxSXGfUsJXUF8BdOvfDn/uhCZIViaKTB7gS49tzq6dJ/YKV6rjjnjEZcui+5vnFIPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q5+yPT+i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q5+yPT+i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26FECC4CEE2;
	Wed, 19 Feb 2025 01:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739927285;
	bh=njMWAfLRtww//2/3OVcXVe6jG2m8raReSR1qyGBMq3c=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=q5+yPT+iCJSqS+6dgJby0/CkQSU9NhNkXEgC/acX66tI0ss0eDoRLXuo9WiIeXR8e
	 2nTkvmCloUJsWxWXRjvkbFCne96Luv1AMu5c+8Z/7cdxRaqUMxEOyO0158Jb3lH5vc
	 5aCORZGoxSZHZIIvn1G8yxoSkg48ToucsImqYMoLFVlHqgf7hLJT8UYw2ozAAM/cMe
	 CEYMdGziahKOHOS86rcO5QehlsMk4941tLIU9uiiowkqJHJp07486v2lTQ6nuA+UNh
	 suUAzhkDLYb8UJJYiHK+mIflp1gTbxOpxfSlunwX9tTzUaIm7KNzKibYLQicYQqy+S
	 5IPafLHKyMMVQ==
Date: Tue, 18 Feb 2025 17:08:04 -0800
Subject: [PATCH 4/7] xfs: race fsstress with realtime refcount btree scrub and
 repair
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992591827.4081089.9026111603191501024.stgit@frogsfrogsfrogs>
In-Reply-To: <173992591722.4081089.9486182038960980513.stgit@frogsfrogsfrogs>
References: <173992591722.4081089.9486182038960980513.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Race checking and rebuilding realtime refcount btrees with fsstress.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/1818     |   40 ++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1818.out |    2 ++
 tests/xfs/1819     |   40 ++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1819.out |    2 ++
 tests/xfs/1893     |    2 +-
 5 files changed, 85 insertions(+), 1 deletion(-)
 create mode 100755 tests/xfs/1818
 create mode 100644 tests/xfs/1818.out
 create mode 100755 tests/xfs/1819
 create mode 100644 tests/xfs/1819.out


diff --git a/tests/xfs/1818 b/tests/xfs/1818
new file mode 100755
index 00000000000000..eb0b4a61722d81
--- /dev/null
+++ b/tests/xfs/1818
@@ -0,0 +1,40 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022-2025 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1818
+#
+# Race fsstress and rt refcount btree scrub for a while to see if we crash or
+# livelock.
+#
+. ./common/preamble
+_begin_fstest scrub fsstress_scrub
+
+_cleanup() {
+	_scratch_xfs_stress_scrub_cleanup &> /dev/null
+	cd /
+	rm -r -f $tmp.*
+}
+_register_cleanup "_cleanup" BUS
+
+. ./common/filter
+. ./common/fuzzy
+. ./common/inject
+. ./common/xfs
+
+_require_realtime
+_require_scratch
+_require_xfs_stress_scrub
+
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+_require_xfs_has_feature "$SCRATCH_MNT" realtime
+_require_xfs_has_feature "$SCRATCH_MNT" reflink
+_xfs_force_bdev realtime $SCRATCH_MNT
+
+_scratch_xfs_stress_scrub -s "scrub rtrefcountbt %rgno%"
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/1818.out b/tests/xfs/1818.out
new file mode 100644
index 00000000000000..700d301da1450c
--- /dev/null
+++ b/tests/xfs/1818.out
@@ -0,0 +1,2 @@
+QA output created by 1818
+Silence is golden
diff --git a/tests/xfs/1819 b/tests/xfs/1819
new file mode 100755
index 00000000000000..53cf18d5549ce9
--- /dev/null
+++ b/tests/xfs/1819
@@ -0,0 +1,40 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022-2025 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1819
+#
+# Race fsstress and rt refcount btree scrub for a while to see if we crash or
+# livelock.
+#
+. ./common/preamble
+_begin_fstest online_repair fsstress_online_repair
+
+_cleanup() {
+	_scratch_xfs_stress_scrub_cleanup &> /dev/null
+	cd /
+	rm -r -f $tmp.*
+}
+_register_cleanup "_cleanup" BUS
+
+. ./common/filter
+. ./common/fuzzy
+. ./common/inject
+. ./common/xfs
+
+_require_realtime
+_require_scratch
+_require_xfs_stress_online_repair
+
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+_require_xfs_has_feature "$SCRATCH_MNT" realtime
+_require_xfs_has_feature "$SCRATCH_MNT" reflink
+_xfs_force_bdev realtime $SCRATCH_MNT
+
+_scratch_xfs_stress_online_repair -s "repair rtrefcountbt %rgno%"
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/1819.out b/tests/xfs/1819.out
new file mode 100644
index 00000000000000..041e17ab61eaef
--- /dev/null
+++ b/tests/xfs/1819.out
@@ -0,0 +1,2 @@
+QA output created by 1819
+Silence is golden
diff --git a/tests/xfs/1893 b/tests/xfs/1893
index 1f04da0028a12a..b0066b7e15e605 100755
--- a/tests/xfs/1893
+++ b/tests/xfs/1893
@@ -46,7 +46,7 @@ done
 
 # Metapath verbs that take a rt group number
 for ((rgno = 0; rgno < rgcount; rgno++)); do
-	for v in rtbitmap rtsummary rtrmapbt; do
+	for v in rtbitmap rtsummary rtrmapbt rtrefcbt; do
 		testio=$(try_verb "$v" "$rgno")
 		test -z "$testio" && verbs+=("$v $rgno")
 	done

