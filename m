Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D27E17EE;
	Mon,  1 Jan 2024 00:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D2lhwLSx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 538B5C433C8;
	Mon,  1 Jan 2024 00:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704070163;
	bh=im8zc6XeXwkN1EF4G/Qjmvbip51EkovsRT71tZmHj+A=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=D2lhwLSxbk3cNv07tq2xO9afMGu59QpdWkeFpu4YzZzW3dO6qoWKec6dBT/c1azSt
	 wDZaYWtyh5nSdJRmCIoP7f7oBTQJcIjm3hyrA8jkBTdMAB7ix64haZIIhC3DGFGVvI
	 t80JpvQmMhmcRR/UewynJsQ9gdJ7Jiu3OuRKQVUAEJPbN4RiJUxw/f8TED02Hh4Rep
	 Gk0Xr6NKswT+G7oUEmQ6mzFAUprjh3T5F+BhvOH6ISneS0CvMIzsOzZ+FtKY1u1bOF
	 DqHXCaZvOtSgjVCs76VETCO/lu6YZQ93vCsm9ZOtWYjMLJ0yvovAtvFCEyLYmXC1gR
	 twwk/i6miFf4Q==
Date: Sun, 31 Dec 2023 16:49:22 +9900
Subject: [PATCH 1/2] common/fuzzy: stress directory tree modifications with
 the dirtree tester
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, guan@eryu.me, fstests@vger.kernel.org
Message-ID: <170405028907.1825187.18368003139938154708.stgit@frogsfrogsfrogs>
In-Reply-To: <170405028893.1825187.7753896310306155652.stgit@frogsfrogsfrogs>
References: <170405028893.1825187.7753896310306155652.stgit@frogsfrogsfrogs>
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

Stress test the directory tree corruption detector by racing it with
fsstress.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/1864     |   38 ++++++++++++++++++++++++++++++++++++++
 tests/xfs/1864.out |    2 ++
 tests/xfs/1865     |   38 ++++++++++++++++++++++++++++++++++++++
 tests/xfs/1865.out |    2 ++
 4 files changed, 80 insertions(+)
 create mode 100755 tests/xfs/1864
 create mode 100644 tests/xfs/1864.out
 create mode 100755 tests/xfs/1865
 create mode 100644 tests/xfs/1865.out


diff --git a/tests/xfs/1864 b/tests/xfs/1864
new file mode 100755
index 0000000000..d00bcb28b4
--- /dev/null
+++ b/tests/xfs/1864
@@ -0,0 +1,38 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2023-2024 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1864
+#
+# Race fsstress and directory tree structure corruption detector for a while to
+# see if we crash or livelock.
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
+_require_scratch
+_require_xfs_stress_scrub
+
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+_scratch_xfs_stress_scrub -x 'dir' -s "scrub dirtree" -t "%dir%"
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/1864.out b/tests/xfs/1864.out
new file mode 100644
index 0000000000..472f56323a
--- /dev/null
+++ b/tests/xfs/1864.out
@@ -0,0 +1,2 @@
+QA output created by 1864
+Silence is golden
diff --git a/tests/xfs/1865 b/tests/xfs/1865
new file mode 100755
index 0000000000..098891536c
--- /dev/null
+++ b/tests/xfs/1865
@@ -0,0 +1,38 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2023-2024 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1865
+#
+# Race fsstress and directory tree structure repair for a while to see if we
+# crash or livelock.
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
+_require_scratch
+_require_xfs_stress_online_repair
+
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+_scratch_xfs_stress_online_repair -x 'dir' -s "repair dirtree" -t "%dir%"
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/1865.out b/tests/xfs/1865.out
new file mode 100644
index 0000000000..9f2fecad3f
--- /dev/null
+++ b/tests/xfs/1865.out
@@ -0,0 +1,2 @@
+QA output created by 1865
+Silence is golden

