Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D0AC158520;
	Thu, 16 Jan 2025 23:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737070474; cv=none; b=lt8SPmMBUGy5P0B6B0giBwSJwtNSU3GMGqY1EP2Pze8P8kzeQaV2MuwDI2hOMRo1JAkFSIrHrapKqxpChqaWEdkcvaMFObNf0Mjgv23KybtWjh4rOcn13M8UqOP9RmwsceFSrC8EKWSsq9P+xpwB1IQreM8EUye04a27wgVFsGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737070474; c=relaxed/simple;
	bh=cTN8QDFyMHsSG76d6Uok+F1oLjzK7k8DgxwBZ+h+YXA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NkDcvM4iSETdQ90QgQ1+bPhm0ml95kei/qC/of+QUsefc1GQL7DDLDyGmTrXbCkTA2c3asoK4Z7nrk8Gbjm6ddlkieyHj1V3rz4AQ6mtkfIRMq7p35km/DfCfmEK5P986krECn+CbIDv0d/hPv4NBWS5kj+5Fvo6kYlE262mDss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DqGqZyUX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DqGqZyUX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14A81C4CED6;
	Thu, 16 Jan 2025 23:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737070474;
	bh=cTN8QDFyMHsSG76d6Uok+F1oLjzK7k8DgxwBZ+h+YXA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=DqGqZyUXLFdRw7yMxLig0OVdZRCGP1tPr8ugWozQ41aFsZ+YxW8/POD+g80yevdes
	 46rV98UgykmKNsB2YnQcr8l939E+yE8H/LMPWCDx6Wli40B1f6/KER9B5KOO5PrKhT
	 FuDzUJeeAT8tvgdu+9ITCMiKHAcpLhK+O/HUFscYCWgDDA1dib09wU0p3VpdGxd8Zl
	 3NFMe7KK9IkhfWaiTn/bpus2cx8sk/2Igm4tU51LCJmAli8VtFeycpuHyMuVDeTZ4J
	 9LgnKZU68UZ+MltbIOPdSgnWSZawVMxmqlC5Fs2QsKHEmIf2Bv2QVBslWTkQvSuDFJ
	 pg9vIRlTQjXog==
Date: Thu, 16 Jan 2025 15:34:33 -0800
Subject: [PATCH 10/11] scrub: race metapath online fsck with fsstress
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173706975320.1928284.12262575850185873579.stgit@frogsfrogsfrogs>
In-Reply-To: <173706975151.1928284.10657631623674241763.stgit@frogsfrogsfrogs>
References: <173706975151.1928284.10657631623674241763.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Add a pair of new tests to exercise fsstress vs. metapath repairs.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/xfs         |    3 ++
 tests/xfs/1892     |   66 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1892.out |    2 ++
 tests/xfs/1893     |   67 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1893.out |    2 ++
 5 files changed, 140 insertions(+)
 create mode 100755 tests/xfs/1892
 create mode 100644 tests/xfs/1892.out
 create mode 100755 tests/xfs/1893
 create mode 100644 tests/xfs/1893.out


diff --git a/common/xfs b/common/xfs
index 1c5daaa977aef1..b8e24c2e0ce8fe 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1664,6 +1664,9 @@ _xfs_filter_mkfs()
 	if (/^realtime\s+=([\w|\/.-]+)\s+extsz=(\d+)\s+blocks=(\d+), rtextents=(\d+)/) {
 		print STDERR "rtdev=$1\nrtextsz=$2\nrtblocks=$3\nrtextents=$4\n";
 		print STDOUT "realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX\n";
+	}
+	if (/^\s+=\s+rgcount=(\d+)\s+rgsize=(\d+) extents/) {
+		print STDERR "rgcount=$1\nrgextents=$2\n";
 	}'
 }
 
diff --git a/tests/xfs/1892 b/tests/xfs/1892
new file mode 100755
index 00000000000000..13310353564554
--- /dev/null
+++ b/tests/xfs/1892
@@ -0,0 +1,66 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2024-2025 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1892
+#
+# Race fsstress and metadata directory tree path corruption detector for a
+# while to see if we crash or livelock.
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
+# Import common functions.
+. ./common/filter
+. ./common/fuzzy
+. ./common/inject
+. ./common/xfs
+
+_require_scratch
+_require_xfs_stress_scrub
+
+_scratch_mkfs | _filter_mkfs 2>$tmp.mkfs >/dev/null
+. $tmp.mkfs
+_scratch_mount
+
+verbs=()
+
+try_verb()
+{
+	$XFS_IO_PROG -x -c "scrub metapath $*" "$SCRATCH_MNT" 2>&1
+}
+
+# Metapath verbs that don't require arguments
+for v in quotadir usrquota grpquota prjquota rtdir; do
+	testio=$(try_verb "$v")
+	test -z "$testio" && verbs+=("$v")
+done
+
+# Metapath verbs that take a rt group number
+for ((rgno = 0; rgno < rgcount; rgno++)); do
+	for v in rtbitmap rtsummary rtrmapbt rtrefcbt; do
+		testio=$(try_verb "$v" "$rgno")
+		test -z "$testio" && verbs+=("$v $rgno")
+	done
+done
+test "${#verbs[@]}" -gt 0 || _notrun "no metapath verbs detected"
+
+args=()
+for v in "${verbs[@]}"; do
+	args+=("scrub metapath $v")
+done
+
+echo "${verbs[@]}" >> $seqres.full
+_scratch_xfs_stress_scrub "${args[@]}"
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/1892.out b/tests/xfs/1892.out
new file mode 100644
index 00000000000000..afc84c43ed2dcc
--- /dev/null
+++ b/tests/xfs/1892.out
@@ -0,0 +1,2 @@
+QA output created by 1892
+Silence is golden
diff --git a/tests/xfs/1893 b/tests/xfs/1893
new file mode 100755
index 00000000000000..d06687fa2a1087
--- /dev/null
+++ b/tests/xfs/1893
@@ -0,0 +1,67 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2024-2025 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1893
+#
+# Race fsstress and metadata directory tree path repair for a while to see if
+# we crash or livelock.
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
+# Import common functions.
+. ./common/filter
+. ./common/fuzzy
+. ./common/inject
+. ./common/xfs
+
+_require_scratch
+_require_xfs_stress_online_repair
+
+_scratch_mkfs | _filter_mkfs 2>$tmp.mkfs >/dev/null
+. $tmp.mkfs
+_scratch_mount
+
+verbs=()
+
+try_verb()
+{
+	$XFS_IO_PROG -x -c "repair metapath $*" "$SCRATCH_MNT" 2>&1 | \
+		sed -e '/did not need repair/d'
+}
+
+# Metapath verbs that don't require arguments
+for v in quotadir usrquota grpquota prjquota rtdir; do
+	testio=$(try_verb "$v")
+	test -z "$testio" && verbs+=("$v")
+done
+
+# Metapath verbs that take a rt group number
+for ((rgno = 0; rgno < rgcount; rgno++)); do
+	for v in rtbitmap rtsummary; do
+		testio=$(try_verb "$v" "$rgno")
+		test -z "$testio" && verbs+=("$v $rgno")
+	done
+done
+test "${#verbs[@]}" -gt 0 || _notrun "no metapath verbs detected"
+
+args=()
+for v in "${verbs[@]}"; do
+	args+=("repair metapath $v")
+done
+
+echo "${verbs[@]}" >> $seqres.full
+_scratch_xfs_stress_online_repair "${args[@]}"
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/1893.out b/tests/xfs/1893.out
new file mode 100644
index 00000000000000..64d6b1b2bcd09e
--- /dev/null
+++ b/tests/xfs/1893.out
@@ -0,0 +1,2 @@
+QA output created by 1893
+Silence is golden

