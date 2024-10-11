Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A3F2D53F;
	Fri, 11 Oct 2024 01:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728610828; cv=none; b=XtxFrPkZdYQhOtStMZ560kg8w9okP2EhCL8tBKOy+pZMPIET8CNFc7/52v5rCRL5g/M43UVtcAI2/LZzu3yxzkETiSVLsvS3JU79Cd7DWis+38EzuJMqT9I550TmwpmhK8CG+T/D0AbISBtP9gyiVE3a0kulFzF3pDVPbp5RhSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728610828; c=relaxed/simple;
	bh=zy33KlbzmQb7hfMYC0dLuL9G6+YnLR5OzByHpbkFP9g=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EgmDtKdHWlVvAG3R6EeqUrnGCv3Andicb96dDWVKDij1GA/wC9QJLAlMoH8DR+ksX1G9nwhJa4GmLR7FTVAco/uqyvH3K51cqGkAQmg+swwjXDvcaiDxltwbDu4dlf1d45rgq8R9g1Yn5vNgy1qI6msC/IIreVxINTDv7PoV9YI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ozySzmf8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ozySzmf8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 238A6C4CEC5;
	Fri, 11 Oct 2024 01:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728610828;
	bh=zy33KlbzmQb7hfMYC0dLuL9G6+YnLR5OzByHpbkFP9g=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ozySzmf8WFQWwRft1h2KugvLbsz6kcsR6fON/ygFdVapVuNjCip4ASpRY2MXRRkI/
	 gtNWZcHF5BFXe1h8jY3ZfHephWM+f4BZE3jKdhN+jHV2WGJ66+sosKn8Sk8ky20xoi
	 001g3YgechcKjBifL5DHMLnjLTCpOTJv3ucYz7p0cZakgUiUWTpLFbRjaOnSozWFxo
	 T73IimRgPsP5hUlOTVRUbIXS0SsU9BfnD1nWwjziuyvuGSAtzcx2RIXI9Peqc813vF
	 vbd69KHcoDZRMT1xYNZyojv03lbGi5gUIQ15GOqPwnry8E/+oCa59n2SxyK5hnWfhi
	 2m++BJy3Fiypw==
Date: Thu, 10 Oct 2024 18:40:27 -0700
Subject: [PATCH 09/11] xfs: create fuzz tests for metadata directories
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, fstests@vger.kernel.org
Message-ID: <172860658134.4187056.2066555135807219372.stgit@frogsfrogsfrogs>
In-Reply-To: <172860657983.4187056.5472629319415849070.stgit@frogsfrogsfrogs>
References: <172860657983.4187056.5472629319415849070.stgit@frogsfrogsfrogs>
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
 tests/xfs/1546     |   34 ++++++++++++++++++++++++++++++++++
 tests/xfs/1546.out |    4 ++++
 tests/xfs/1547     |   34 ++++++++++++++++++++++++++++++++++
 tests/xfs/1547.out |    4 ++++
 tests/xfs/1548     |   34 ++++++++++++++++++++++++++++++++++
 tests/xfs/1548.out |    4 ++++
 tests/xfs/1549     |   35 +++++++++++++++++++++++++++++++++++
 tests/xfs/1549.out |    4 ++++
 tests/xfs/1550     |   34 ++++++++++++++++++++++++++++++++++
 tests/xfs/1550.out |    4 ++++
 tests/xfs/1551     |   34 ++++++++++++++++++++++++++++++++++
 tests/xfs/1551.out |    4 ++++
 tests/xfs/1552     |   34 ++++++++++++++++++++++++++++++++++
 tests/xfs/1552.out |    4 ++++
 tests/xfs/1553     |   35 +++++++++++++++++++++++++++++++++++
 tests/xfs/1553.out |    4 ++++
 17 files changed, 328 insertions(+)
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
index f95a5a6d1d970e..39cb04ff2cddcd 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1929,3 +1929,25 @@ _xfs_calc_hidden_quota_files() {
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
index 00000000000000..e41ee0d4a6c759
--- /dev/null
+++ b/tests/xfs/1546
@@ -0,0 +1,34 @@
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
+_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_online_repair realtime
+
+_register_cleanup "_cleanup" BUS
+
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
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
index 00000000000000..b72891a7583c04
--- /dev/null
+++ b/tests/xfs/1546.out
@@ -0,0 +1,4 @@
+QA output created by 1546
+Format and populate
+Fuzz metadir root
+Done fuzzing metadir root
diff --git a/tests/xfs/1547 b/tests/xfs/1547
new file mode 100755
index 00000000000000..b82c2ef6a87aed
--- /dev/null
+++ b/tests/xfs/1547
@@ -0,0 +1,34 @@
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
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
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
index 00000000000000..983cc01343e5f4
--- /dev/null
+++ b/tests/xfs/1547.out
@@ -0,0 +1,4 @@
+QA output created by 1547
+Format and populate
+Fuzz metadir root
+Done fuzzing metadir root
diff --git a/tests/xfs/1548 b/tests/xfs/1548
new file mode 100755
index 00000000000000..b2ca3016842e3a
--- /dev/null
+++ b/tests/xfs/1548
@@ -0,0 +1,34 @@
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
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
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
index 00000000000000..9e395bb059436d
--- /dev/null
+++ b/tests/xfs/1548.out
@@ -0,0 +1,4 @@
+QA output created by 1548
+Format and populate
+Fuzz metadir root
+Done fuzzing metadir root
diff --git a/tests/xfs/1549 b/tests/xfs/1549
new file mode 100755
index 00000000000000..f0b01c9ce1e177
--- /dev/null
+++ b/tests/xfs/1549
@@ -0,0 +1,35 @@
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
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
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
index 00000000000000..22b3d215e32e7b
--- /dev/null
+++ b/tests/xfs/1549.out
@@ -0,0 +1,4 @@
+QA output created by 1549
+Format and populate
+Fuzz metadir root
+Done fuzzing metadir root
diff --git a/tests/xfs/1550 b/tests/xfs/1550
new file mode 100755
index 00000000000000..b8da04676cd6b3
--- /dev/null
+++ b/tests/xfs/1550
@@ -0,0 +1,34 @@
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
+_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_online_repair realtime
+
+_register_cleanup "_cleanup" BUS
+
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+_require_xfs_scratch_metadir
+_require_scratch_xfs_fuzz_fields
+_disable_dmesg_check
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+inode_ver=$(_scratch_xfs_get_metadata_field "core.version" 'path -m /rtgroups')
+
+echo "Fuzz metadir subdir"
+_scratch_xfs_fuzz_metadata '' 'online' 'path -m /rtgroups' >> $seqres.full
+echo "Done fuzzing metadir subdir"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1550.out b/tests/xfs/1550.out
new file mode 100644
index 00000000000000..7694cd670bd25b
--- /dev/null
+++ b/tests/xfs/1550.out
@@ -0,0 +1,4 @@
+QA output created by 1550
+Format and populate
+Fuzz metadir subdir
+Done fuzzing metadir subdir
diff --git a/tests/xfs/1551 b/tests/xfs/1551
new file mode 100755
index 00000000000000..df721d9b34dae2
--- /dev/null
+++ b/tests/xfs/1551
@@ -0,0 +1,34 @@
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
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+_require_xfs_scratch_metadir
+_require_scratch_xfs_fuzz_fields
+_disable_dmesg_check
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+inode_ver=$(_scratch_xfs_get_metadata_field "core.version" 'path -m /rtgroups')
+
+echo "Fuzz metadir subdir"
+_scratch_xfs_fuzz_metadata '' 'offline' 'path -m /rtgroups' >> $seqres.full
+echo "Done fuzzing metadir subdir"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1551.out b/tests/xfs/1551.out
new file mode 100644
index 00000000000000..4c3360d08b34f8
--- /dev/null
+++ b/tests/xfs/1551.out
@@ -0,0 +1,4 @@
+QA output created by 1551
+Format and populate
+Fuzz metadir subdir
+Done fuzzing metadir subdir
diff --git a/tests/xfs/1552 b/tests/xfs/1552
new file mode 100755
index 00000000000000..8672cb3c08bedf
--- /dev/null
+++ b/tests/xfs/1552
@@ -0,0 +1,34 @@
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
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+_require_xfs_scratch_metadir
+_require_scratch_xfs_fuzz_fields
+_disable_dmesg_check
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+inode_ver=$(_scratch_xfs_get_metadata_field "core.version" 'path -m /rtgroups')
+
+echo "Fuzz metadir subdir"
+_scratch_xfs_fuzz_metadata '' 'none' 'path -m /rtgroups' >> $seqres.full
+echo "Done fuzzing metadir subdir"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1552.out b/tests/xfs/1552.out
new file mode 100644
index 00000000000000..6636b1b656c926
--- /dev/null
+++ b/tests/xfs/1552.out
@@ -0,0 +1,4 @@
+QA output created by 1552
+Format and populate
+Fuzz metadir subdir
+Done fuzzing metadir subdir
diff --git a/tests/xfs/1553 b/tests/xfs/1553
new file mode 100755
index 00000000000000..b98ad67904c31f
--- /dev/null
+++ b/tests/xfs/1553
@@ -0,0 +1,35 @@
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
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+_require_xfs_scratch_metadir
+_require_scratch_xfs_fuzz_fields
+_disable_dmesg_check
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+inode_ver=$(_scratch_xfs_get_metadata_field "core.version" 'path -m /rtgroups')
+
+echo "Fuzz metadir subdir"
+_scratch_xfs_fuzz_metadata '' 'both' 'path -m /rtgroups' >> $seqres.full
+echo "Done fuzzing metadir subdir"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1553.out b/tests/xfs/1553.out
new file mode 100644
index 00000000000000..0298fcfddbf15a
--- /dev/null
+++ b/tests/xfs/1553.out
@@ -0,0 +1,4 @@
+QA output created by 1553
+Format and populate
+Fuzz metadir subdir
+Done fuzzing metadir subdir

