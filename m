Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2548642;
	Mon,  1 Jan 2024 00:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NFcUkiEo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5810DC433C7;
	Mon,  1 Jan 2024 00:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704070711;
	bh=e8C2AtCF/7Yhu7cMKseIcORmI1rqaz/31kg8V+bwEwo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NFcUkiEoptzZc3gyX/wD9+qmfXhVrBMcvZCqmbzayRxZ3z2XPxE8Ux6Y7KWqCoz84
	 VGGLXBPjfhe4D0HLechaYaoThEyjuXy4wIgFrgtnAMBHP2/Y3NeV4OtQxDsZJAkUqV
	 9gClmO6VDr7ti6DEuxGtaELaxRX75mPTMH1azDX+UieAH1fnKU+7WmQDxvd+jNg+jv
	 zuTGtV7bTguyWlIMW+sbXg5azCQTTbJE0umrumK0CWXxBAANooY9NQTXvwu8n1+JH6
	 X4vg7cbYHzLvcJLJ8ztMbT/HA1a0hFWRUkVQj4HSPUxCzH0VSCc2kEAbS/wqgu+kKw
	 71elvAjtoc0UA==
Date: Sun, 31 Dec 2023 16:58:30 +9900
Subject: [PATCH 03/13] xfs: race fsstress with realtime rmap btree scrub and
 repair
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170405031273.1826914.10723169821572634090.stgit@frogsfrogsfrogs>
In-Reply-To: <170405031226.1826914.14340556896857027512.stgit@frogsfrogsfrogs>
References: <170405031226.1826914.14340556896857027512.stgit@frogsfrogsfrogs>
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

Race checking and rebuilding realtime rmap btrees with fsstress.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/1817     |   42 ++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1817.out |    2 ++
 tests/xfs/1821     |   42 ++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1821.out |    2 ++
 tests/xfs/1857     |   42 ++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1857.out |    2 ++
 6 files changed, 132 insertions(+)
 create mode 100755 tests/xfs/1817
 create mode 100644 tests/xfs/1817.out
 create mode 100755 tests/xfs/1821
 create mode 100644 tests/xfs/1821.out
 create mode 100755 tests/xfs/1857
 create mode 100644 tests/xfs/1857.out


diff --git a/tests/xfs/1817 b/tests/xfs/1817
new file mode 100755
index 0000000000..56ce63e005
--- /dev/null
+++ b/tests/xfs/1817
@@ -0,0 +1,42 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1817
+#
+# Race fsstress and rtrmapbt scrub for a while to see if we crash or livelock.
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
+_require_xfs_has_feature "$SCRATCH_MNT" rmapbt
+_xfs_force_bdev realtime $SCRATCH_MNT
+
+_scratch_xfs_stress_scrub -s "scrub rtrmapbt %rgno%"
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/1817.out b/tests/xfs/1817.out
new file mode 100644
index 0000000000..525ec14ed0
--- /dev/null
+++ b/tests/xfs/1817.out
@@ -0,0 +1,2 @@
+QA output created by 1817
+Silence is golden
diff --git a/tests/xfs/1821 b/tests/xfs/1821
new file mode 100755
index 0000000000..7dbac04f52
--- /dev/null
+++ b/tests/xfs/1821
@@ -0,0 +1,42 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1821
+#
+# Race fsstress and realtime bitmap repair for a while to see if we crash or
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
+_xfs_force_bdev realtime $SCRATCH_MNT
+
+_scratch_xfs_stress_online_repair -s "repair rtbitmap" -s "repair rgbitmap %rgno%"
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/1821.out b/tests/xfs/1821.out
new file mode 100644
index 0000000000..0f18ad5d88
--- /dev/null
+++ b/tests/xfs/1821.out
@@ -0,0 +1,2 @@
+QA output created by 1821
+Silence is golden
diff --git a/tests/xfs/1857 b/tests/xfs/1857
new file mode 100755
index 0000000000..de10bbb5c4
--- /dev/null
+++ b/tests/xfs/1857
@@ -0,0 +1,42 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1857
+#
+# Race fsstress and rtrmapbt repair for a while to see if we crash or livelock.
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
+_require_xfs_has_feature "$SCRATCH_MNT" rmapbt
+_xfs_force_bdev realtime $SCRATCH_MNT
+
+_scratch_xfs_stress_online_repair -s "repair rtrmapbt %rgno%"
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/1857.out b/tests/xfs/1857.out
new file mode 100644
index 0000000000..b51ffd3f6c
--- /dev/null
+++ b/tests/xfs/1857.out
@@ -0,0 +1,2 @@
+QA output created by 1857
+Silence is golden

