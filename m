Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07BF97EF;
	Mon,  1 Jan 2024 01:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NHNru/oX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87030C433C8;
	Mon,  1 Jan 2024 01:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704070961;
	bh=zgzSX+sXh/oB3KgXb9RGzPP8BblpJQN7rbqn9NFxIrI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NHNru/oXxOnGvtU4PUS9sDufycyJfCVeJJ4Tl1Zac4WOB44FSX/ikOZafenHN9jUk
	 XLmNJon/iO6eibdkay4l2fbMcoxR2hDC6GAiWZrM1iJLSp22XR2z2RKmFdR1FPcpt8
	 iSzZSNrOftPKQjKgP2HhG/ihnPGkWCW9BsnUoG0luHyG0KCiioF7vDpUjnou4f9PCL
	 /s+P4SgxpGECP/eUfD2ru7CRjNyUdDdPgeRkGgcLI6OujtHS31WZMmUyjNZ+xEcrCe
	 SyP+PRDvtaTxFND9gpxPnuHZiH0SNPuA3BE40q2OS9YtzJO/s2pK5GpUHIxmff0tNP
	 o8+dEQQiz5b3w==
Date: Sun, 31 Dec 2023 17:02:41 +9900
Subject: [PATCH 5/9] xfs: race fsstress with realtime refcount btree scrub and
 repair
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170405032082.1827358.7127035550813883108.stgit@frogsfrogsfrogs>
In-Reply-To: <170405032011.1827358.11723561661069109569.stgit@frogsfrogsfrogs>
References: <170405032011.1827358.11723561661069109569.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
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

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/1818     |   43 +++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1818.out |    2 ++
 tests/xfs/1819     |   43 +++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1819.out |    2 ++
 4 files changed, 90 insertions(+)
 create mode 100755 tests/xfs/1818
 create mode 100644 tests/xfs/1818.out
 create mode 100755 tests/xfs/1819
 create mode 100644 tests/xfs/1819.out


diff --git a/tests/xfs/1818 b/tests/xfs/1818
new file mode 100755
index 0000000000..674fff25fa
--- /dev/null
+++ b/tests/xfs/1818
@@ -0,0 +1,43 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1818
+#
+# Race fsstress and rt refcount btree scrub for a while to see if we crash or
+# livelock.
+#
+. ./common/preamble
+_begin_fstest scrub dangerous_fsstress_scrub
+
+_cleanup() {
+	_scratch_xfs_stress_scrub_cleanup &> /dev/null
+	cd /
+	rm -r -f $tmp.*
+}
+_register_cleanup "_cleanup" BUS
+
+# Import common functions.
+. ./common/filter
+. ./common/fuzzy
+. ./common/inject
+. ./common/xfs
+
+# real QA test starts here
+_supported_fs xfs
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
index 0000000000..700d301da1
--- /dev/null
+++ b/tests/xfs/1818.out
@@ -0,0 +1,2 @@
+QA output created by 1818
+Silence is golden
diff --git a/tests/xfs/1819 b/tests/xfs/1819
new file mode 100755
index 0000000000..e27a29271f
--- /dev/null
+++ b/tests/xfs/1819
@@ -0,0 +1,43 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1819
+#
+# Race fsstress and rt refcount btree scrub for a while to see if we crash or
+# livelock.
+#
+. ./common/preamble
+_begin_fstest online_repair dangerous_fsstress_repair
+
+_cleanup() {
+	_scratch_xfs_stress_scrub_cleanup &> /dev/null
+	cd /
+	rm -r -f $tmp.*
+}
+_register_cleanup "_cleanup" BUS
+
+# Import common functions.
+. ./common/filter
+. ./common/fuzzy
+. ./common/inject
+. ./common/xfs
+
+# real QA test starts here
+_supported_fs xfs
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
index 0000000000..041e17ab61
--- /dev/null
+++ b/tests/xfs/1819.out
@@ -0,0 +1,2 @@
+QA output created by 1819
+Silence is golden

