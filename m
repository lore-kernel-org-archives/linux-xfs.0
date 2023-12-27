Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA83A7F9;
	Mon,  1 Jan 2024 00:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KDHPOdSc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 770BAC433C7;
	Mon,  1 Jan 2024 00:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704070335;
	bh=/aANm7nvLEKfpkuwErFAb72mKDf0v0lHcinO9RN7UVU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=KDHPOdScsmEjjHy/APAyFzKfK7fq7E0JLg4cjTth4OGjkC1ZWS5TLC7i35XBhoyRd
	 90voi+HLsnrXf5vtEdk18CcArr26mGh0xIk0T1N8RCcq2gE95SjrMoSMhp7ZJPWNts
	 ERIrPf5cP4v3lMp20j443MrMFo79D2nL+yzfZnWueMqwLC1xkOqV39Flba6s1JJ97S
	 MdiTdxqyIS7XLimh6rxlRMFRZyTcAMsDnV4737zAlqx880hwtYLWNWtBBAyAaWw9Zg
	 37+RVUGUYYrQcvz2Kpu097HjQgzHNVNwHfuOv6yK4mjEqvjTZLZjqRv+vWzNV25+Y4
	 FCMr4u+pozTsQ==
Date: Sun, 31 Dec 2023 16:52:15 +9900
Subject: [PATCH 09/11] xfs: create fuzz tests for metadata directories
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170405029968.1826032.6023234349919842647.stgit@frogsfrogsfrogs>
In-Reply-To: <170405029843.1826032.12205800164831698648.stgit@frogsfrogsfrogs>
References: <170405029843.1826032.12205800164831698648.stgit@frogsfrogsfrogs>
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

Create fuzz tests to make sure that all the validation works for
metadata directories and subdirectories.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/xfs         |   22 ++++++++++++++++++++++
 tests/xfs/1546     |   37 +++++++++++++++++++++++++++++++++++++
 tests/xfs/1546.out |    4 ++++
 tests/xfs/1547     |   37 +++++++++++++++++++++++++++++++++++++
 tests/xfs/1547.out |    4 ++++
 tests/xfs/1548     |   37 +++++++++++++++++++++++++++++++++++++
 tests/xfs/1548.out |    4 ++++
 tests/xfs/1549     |   38 ++++++++++++++++++++++++++++++++++++++
 tests/xfs/1549.out |    4 ++++
 tests/xfs/1550     |   37 +++++++++++++++++++++++++++++++++++++
 tests/xfs/1550.out |    4 ++++
 tests/xfs/1551     |   37 +++++++++++++++++++++++++++++++++++++
 tests/xfs/1551.out |    4 ++++
 tests/xfs/1552     |   37 +++++++++++++++++++++++++++++++++++++
 tests/xfs/1552.out |    4 ++++
 tests/xfs/1553     |   38 ++++++++++++++++++++++++++++++++++++++
 tests/xfs/1553.out |    4 ++++
 17 files changed, 352 insertions(+)
 create mode 100755 tests/xfs/1546
 create mode 100644 tests/xfs/1546.out
 create mode 100755 tests/xfs/1547
 create mode 100644 tests/xfs/1547.out
 create mode 100755 tests/xfs/1548
 create mode 100644 tests/xfs/1548.out
 create mode 100755 tests/xfs/1549
 create mode 100644 tests/xfs/1549.out
 create mode 100755 tests/xfs/1550
 create mode 100644 tests/xfs/1550.out
 create mode 100755 tests/xfs/1551
 create mode 100644 tests/xfs/1551.out
 create mode 100755 tests/xfs/1552
 create mode 100644 tests/xfs/1552.out
 create mode 100755 tests/xfs/1553
 create mode 100644 tests/xfs/1553.out


diff --git a/common/xfs b/common/xfs
index c6a60119f9..b88491666d 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1913,3 +1913,25 @@ _xfs_calc_hidden_quota_files() {
 		echo 0
 	fi
 }
+
+_require_xfs_mkfs_metadir()
+{
+	_scratch_mkfs_xfs_supported -m metadir=1 >/dev/null 2>&1 || \
+		_notrun "mkfs.xfs doesn't have metadir features"
+}
+
+_require_xfs_scratch_metadir()
+{
+	_require_xfs_mkfs_metadir
+	_require_scratch
+
+	_scratch_mkfs -m metadir=1 &> /dev/null
+	_require_scratch_xfs_features METADIR
+	_try_scratch_mount
+	res=$?
+	if [ $res -ne 0 ]; then
+		_notrun "mounting with metadir not supported by filesystem type: $FSTYP"
+	else
+		_scratch_unmount
+	fi
+}
diff --git a/tests/xfs/1546 b/tests/xfs/1546
new file mode 100755
index 0000000000..a370eb7abf
--- /dev/null
+++ b/tests/xfs/1546
@@ -0,0 +1,37 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1546
+#
+# Populate a XFS filesystem and fuzz every metadir root field.
+# Use xfs_scrub to fix the corruption.
+
+. ./common/preamble
+_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_online_repair
+
+_register_cleanup "_cleanup" BUS
+
+# Import common functions.
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_fs xfs
+_require_xfs_scratch_metadir
+_require_scratch_xfs_fuzz_fields
+_disable_dmesg_check
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+inode_ver=$(_scratch_xfs_get_metadata_field "core.version" 'path -m /')
+
+echo "Fuzz metadir root"
+_scratch_xfs_fuzz_metadata '' 'online' 'path -m /' >> $seqres.full
+echo "Done fuzzing metadir root"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1546.out b/tests/xfs/1546.out
new file mode 100644
index 0000000000..b72891a758
--- /dev/null
+++ b/tests/xfs/1546.out
@@ -0,0 +1,4 @@
+QA output created by 1546
+Format and populate
+Fuzz metadir root
+Done fuzzing metadir root
diff --git a/tests/xfs/1547 b/tests/xfs/1547
new file mode 100755
index 0000000000..0083924b7b
--- /dev/null
+++ b/tests/xfs/1547
@@ -0,0 +1,37 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1547
+#
+# Populate a XFS filesystem and fuzz every metadir root field.
+# Use xfs_repair to fix the corruption.
+
+. ./common/preamble
+_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_repair
+
+_register_cleanup "_cleanup" BUS
+
+# Import common functions.
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_fs xfs
+_require_xfs_scratch_metadir
+_require_scratch_xfs_fuzz_fields
+_disable_dmesg_check
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+inode_ver=$(_scratch_xfs_get_metadata_field "core.version" 'path -m /')
+
+echo "Fuzz metadir root"
+_scratch_xfs_fuzz_metadata '' 'offline' 'path -m /' >> $seqres.full
+echo "Done fuzzing metadir root"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1547.out b/tests/xfs/1547.out
new file mode 100644
index 0000000000..983cc01343
--- /dev/null
+++ b/tests/xfs/1547.out
@@ -0,0 +1,4 @@
+QA output created by 1547
+Format and populate
+Fuzz metadir root
+Done fuzzing metadir root
diff --git a/tests/xfs/1548 b/tests/xfs/1548
new file mode 100755
index 0000000000..d81c524b07
--- /dev/null
+++ b/tests/xfs/1548
@@ -0,0 +1,37 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1548
+#
+# Populate a XFS filesystem and fuzz every metadir root field.
+# Do not fix the filesystem, to test metadata verifiers.
+
+. ./common/preamble
+_begin_fstest dangerous_fuzzers dangerous_norepair
+
+_register_cleanup "_cleanup" BUS
+
+# Import common functions.
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_fs xfs
+_require_xfs_scratch_metadir
+_require_scratch_xfs_fuzz_fields
+_disable_dmesg_check
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+inode_ver=$(_scratch_xfs_get_metadata_field "core.version" 'path -m /')
+
+echo "Fuzz metadir root"
+_scratch_xfs_fuzz_metadata '' 'none' 'path -m /' >> $seqres.full
+echo "Done fuzzing metadir root"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1548.out b/tests/xfs/1548.out
new file mode 100644
index 0000000000..9e395bb059
--- /dev/null
+++ b/tests/xfs/1548.out
@@ -0,0 +1,4 @@
+QA output created by 1548
+Format and populate
+Fuzz metadir root
+Done fuzzing metadir root
diff --git a/tests/xfs/1549 b/tests/xfs/1549
new file mode 100755
index 0000000000..487c73e9e9
--- /dev/null
+++ b/tests/xfs/1549
@@ -0,0 +1,38 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1549
+#
+# Populate a XFS filesystem and fuzz every metadir root field.
+# Try online repair and, if necessary, offline repair,
+# to test the most likely usage pattern.
+
+. ./common/preamble
+_begin_fstest dangerous_fuzzers dangerous_bothrepair
+
+_register_cleanup "_cleanup" BUS
+
+# Import common functions.
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_fs xfs
+_require_xfs_scratch_metadir
+_require_scratch_xfs_fuzz_fields
+_disable_dmesg_check
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+inode_ver=$(_scratch_xfs_get_metadata_field "core.version" 'path -m /')
+
+echo "Fuzz metadir root"
+_scratch_xfs_fuzz_metadata '' 'both' 'path -m /' >> $seqres.full
+echo "Done fuzzing metadir root"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1549.out b/tests/xfs/1549.out
new file mode 100644
index 0000000000..22b3d215e3
--- /dev/null
+++ b/tests/xfs/1549.out
@@ -0,0 +1,4 @@
+QA output created by 1549
+Format and populate
+Fuzz metadir root
+Done fuzzing metadir root
diff --git a/tests/xfs/1550 b/tests/xfs/1550
new file mode 100755
index 0000000000..8b5b42710c
--- /dev/null
+++ b/tests/xfs/1550
@@ -0,0 +1,37 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1550
+#
+# Populate a XFS filesystem and fuzz every metadir subdir field.
+# Use xfs_scrub to fix the corruption.
+
+. ./common/preamble
+_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_online_repair
+
+_register_cleanup "_cleanup" BUS
+
+# Import common functions.
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_fs xfs
+_require_xfs_scratch_metadir
+_require_scratch_xfs_fuzz_fields
+_disable_dmesg_check
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+inode_ver=$(_scratch_xfs_get_metadata_field "core.version" 'path -m /realtime')
+
+echo "Fuzz metadir subdir"
+_scratch_xfs_fuzz_metadata '' 'online' 'path -m /realtime' >> $seqres.full
+echo "Done fuzzing metadir subdir"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1550.out b/tests/xfs/1550.out
new file mode 100644
index 0000000000..7694cd670b
--- /dev/null
+++ b/tests/xfs/1550.out
@@ -0,0 +1,4 @@
+QA output created by 1550
+Format and populate
+Fuzz metadir subdir
+Done fuzzing metadir subdir
diff --git a/tests/xfs/1551 b/tests/xfs/1551
new file mode 100755
index 0000000000..05b0328ef0
--- /dev/null
+++ b/tests/xfs/1551
@@ -0,0 +1,37 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1551
+#
+# Populate a XFS filesystem and fuzz every metadir subdir field.
+# Use xfs_repair to fix the corruption.
+
+. ./common/preamble
+_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_repair
+
+_register_cleanup "_cleanup" BUS
+
+# Import common functions.
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_fs xfs
+_require_xfs_scratch_metadir
+_require_scratch_xfs_fuzz_fields
+_disable_dmesg_check
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+inode_ver=$(_scratch_xfs_get_metadata_field "core.version" 'path -m /realtime')
+
+echo "Fuzz metadir subdir"
+_scratch_xfs_fuzz_metadata '' 'offline' 'path -m /realtime' >> $seqres.full
+echo "Done fuzzing metadir subdir"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1551.out b/tests/xfs/1551.out
new file mode 100644
index 0000000000..4c3360d08b
--- /dev/null
+++ b/tests/xfs/1551.out
@@ -0,0 +1,4 @@
+QA output created by 1551
+Format and populate
+Fuzz metadir subdir
+Done fuzzing metadir subdir
diff --git a/tests/xfs/1552 b/tests/xfs/1552
new file mode 100755
index 0000000000..0870837f9c
--- /dev/null
+++ b/tests/xfs/1552
@@ -0,0 +1,37 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1552
+#
+# Populate a XFS filesystem and fuzz every metadir subdir field.
+# Do not fix the filesystem, to test metadata verifiers.
+
+. ./common/preamble
+_begin_fstest dangerous_fuzzers dangerous_norepair
+
+_register_cleanup "_cleanup" BUS
+
+# Import common functions.
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_fs xfs
+_require_xfs_scratch_metadir
+_require_scratch_xfs_fuzz_fields
+_disable_dmesg_check
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+inode_ver=$(_scratch_xfs_get_metadata_field "core.version" 'path -m /realtime')
+
+echo "Fuzz metadir subdir"
+_scratch_xfs_fuzz_metadata '' 'none' 'path -m /realtime' >> $seqres.full
+echo "Done fuzzing metadir subdir"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1552.out b/tests/xfs/1552.out
new file mode 100644
index 0000000000..6636b1b656
--- /dev/null
+++ b/tests/xfs/1552.out
@@ -0,0 +1,4 @@
+QA output created by 1552
+Format and populate
+Fuzz metadir subdir
+Done fuzzing metadir subdir
diff --git a/tests/xfs/1553 b/tests/xfs/1553
new file mode 100755
index 0000000000..ab15e53e27
--- /dev/null
+++ b/tests/xfs/1553
@@ -0,0 +1,38 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1553
+#
+# Populate a XFS filesystem and fuzz every metadir subdir field.
+# Try online repair and, if necessary, offline repair,
+# to test the most likely usage pattern.
+
+. ./common/preamble
+_begin_fstest dangerous_fuzzers dangerous_bothrepair
+
+_register_cleanup "_cleanup" BUS
+
+# Import common functions.
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_fs xfs
+_require_xfs_scratch_metadir
+_require_scratch_xfs_fuzz_fields
+_disable_dmesg_check
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+inode_ver=$(_scratch_xfs_get_metadata_field "core.version" 'path -m /realtime')
+
+echo "Fuzz metadir subdir"
+_scratch_xfs_fuzz_metadata '' 'both' 'path -m /realtime' >> $seqres.full
+echo "Done fuzzing metadir subdir"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1553.out b/tests/xfs/1553.out
new file mode 100644
index 0000000000..0298fcfddb
--- /dev/null
+++ b/tests/xfs/1553.out
@@ -0,0 +1,4 @@
+QA output created by 1553
+Format and populate
+Fuzz metadir subdir
+Done fuzzing metadir subdir

