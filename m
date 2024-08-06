Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D7E1175D23;
	Tue,  6 Aug 2024 22:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722984925; cv=none; b=hIH+VbXIxVowh4eyACxd5TUbxlMAi8bHIC6ccqtOFIzH1DkVBnwo08HW11s9NyIKi8McSJJdY7r/Wlc7L7mQjidmdIxHFjV1Je5ufLv2uxlOgbWJmXtFbHCJpk+hFwJhAeFjigHzSJfgoHM3YP59RlyFWeHJcPOZ8oG2jnmZCU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722984925; c=relaxed/simple;
	bh=ZTSy6LyRNewtX5JomdsEjt28F7ruK0Gse9LoVahKVpc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=tl1F/xeOVBqRGYsWG1usBd2cWR64AVba1RXT3RGG57D7OsgT18fV+tz5jD+vZVE2/46QFvOPvPQFY7ExB4BhO5cQJd5uXBoCyeEPT/l4RqHpgBBtX5sHBDgw0inu1vADhrXM29VHEvvYnfUykUtvG9j114KR4XrcpkfaSDeEyeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AQg6U0za; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AQg6U0za"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88A87C32786;
	Tue,  6 Aug 2024 22:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722984924;
	bh=ZTSy6LyRNewtX5JomdsEjt28F7ruK0Gse9LoVahKVpc=;
	h=Date:From:To:Cc:Subject:From;
	b=AQg6U0zavDNAimryqBV+cbHPnaNC6uBt24Mgn2VUwwE0rWRkpOoIEwQ2YZpXr3Lx5
	 INSomStOhPpTRXASkMWWHkRZ6gRc7gZ5UMw3SWbIg/+PsLQRZPXAXpPlilAbqeHILj
	 l7JQ/im5tEqJdQKjPgWJlhpF3jy52akkdIqOfDEmu1u/K5hSsczyrq8wM3e+nYgzH/
	 Yd/IILKkFG5fBcrME4o2YsubtsVnTF5e/Tv5/u6Eo0H4a7qST99fAqc0KzAxM39ndw
	 M+y9gfqCmgre+da2+coEbP9B/s9smJKIOBPLnNx/QEufn5o0p1ah2Ozxy204VUlE2v
	 NCo9/gAFyFq4w==
Date: Tue, 6 Aug 2024 15:55:23 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@redhat.com>
Cc: fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: test online repair when xfiles consists of THPs
Message-ID: <20240806225523.GB623922@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

Fork xfs/286 so that we can ensure that the xfile and xmbuf code in
fsck can handle THPs and large folios.  This actually caused a
regression in the mm code during 6.10.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/1877     |   76 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1877.out |    2 +
 2 files changed, 78 insertions(+)
 create mode 100755 tests/xfs/1877
 create mode 100644 tests/xfs/1877.out

diff --git a/tests/xfs/1877 b/tests/xfs/1877
new file mode 100755
index 0000000000..e546ad854f
--- /dev/null
+++ b/tests/xfs/1877
@@ -0,0 +1,76 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2017 Oracle, Inc.  All Rights Reserved.
+#
+# FS QA Test No. 1877
+#
+# Force-enable THPs/large folios in tmpfs, then race fsstress and xfs_scrub in
+# force-repair mode for a while to see if we crash, livelock, or corrupt data
+# because the xfile code wasn't folioized.
+#
+. ./common/preamble
+_begin_fstest online_repair dangerous_fsstress_repair
+
+declare -A oldvalues
+
+_cleanup() {
+	cd /
+	for knob in "${!oldvalues[@]}"; do
+		echo "${oldvalues["$knob"]}" > "$knob"
+	done
+
+	_scratch_xfs_stress_scrub_cleanup &> /dev/null
+	rm -r -f $tmp.*
+}
+_register_cleanup "_cleanup" BUS
+
+. ./common/filter
+. ./common/fuzzy
+. ./common/inject
+. ./common/xfs
+
+_require_scratch
+_require_xfs_stress_online_repair
+
+_fixed_by_git_commit kernel 099d90642a711 \
+	"mm/filemap: make MAX_PAGECACHE_ORDER acceptable to xarray"
+
+# Make sure that the xfile code can handle large folios
+knob="/sys/kernel/mm/transparent_hugepage/shmem_enabled"
+test -w "$knob" || _notrun "tmpfs transparent hugepages disabled"
+
+pagesize=`getconf PAGE_SIZE`
+pagesize_kb=$((pagesize / 1024))
+
+echo "settings now: pagesize=${pagesize_kb}KB" >> $seqres.full
+sysfs-dump /sys/kernel/mm/transparent_hugepage/* >> $seqres.full
+
+# Enable large folios for each of the relevant page sizes.
+for ((i = 0; i <= 31; i++)); do
+	hugepagesize_kb=$(( pagesize_kb * (2**i) ))
+	knob="/sys/kernel/mm/transparent_hugepage/hugepages-${hugepagesize_kb}kB/enabled"
+	test -e "$knob" || continue
+
+	echo "setting $knob to inherit" >> $seqres.full
+	oldvalue="$(sed -e 's/^.*\[//g' -e 's/\].*$//g' < "$knob")"
+	oldvalues["$knob"]="$oldvalue"
+	echo inherit > "$knob"
+done
+
+# Turn on large folios
+knob="/sys/kernel/mm/transparent_hugepage/shmem_enabled"
+echo "setting $knob to force" >> $seqres.full
+oldvalues["$knob"]="$(sed -e 's/^.*\[//g' -e 's/\].*$//g' < "$knob")"
+echo force > "$knob" || _fail "could not force tmpfs transparent hugepages"
+
+echo "settings now" >> $seqres.full
+sysfs-dump /sys/kernel/mm/transparent_hugepage/* >> $seqres.full
+
+_scratch_mkfs >> "$seqres.full" 2>&1
+_scratch_mount
+_scratch_xfs_stress_online_repair -S '-k'
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/1877.out b/tests/xfs/1877.out
new file mode 100644
index 0000000000..88d845a112
--- /dev/null
+++ b/tests/xfs/1877.out
@@ -0,0 +1,2 @@
+QA output created by 1877
+Silence is golden
