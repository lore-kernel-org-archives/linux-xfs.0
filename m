Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 281F829415;
	Tue, 31 Dec 2024 23:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735689536; cv=none; b=PxlS76XPM4/5pfK0bI00N2WXY1rVFYHVjXhRYFuvyIIfLZDWJp4z/1vDtuKD4VtG1nqMU5S06/QY/aEOyLQQ/iZW6SlVCNZY9c04YqUG2PgkRe5DayDuvFhwYYEz2P+4pEeebMvDbOr0djseEoPd3nWINyPcnS4p31XZfQE7Zbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735689536; c=relaxed/simple;
	bh=R+ivmdjCUxyhelGvRuRBBSEwkXfVdKX3S9qBtHKRzFQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VSK56zwjVHCmU4OW8J2woYcPeHAQKL0Zdp5tH+ABywOQuCU3soqUr0XK/CeN7Ycc+Xz8zB4CKFTaN80mSvUpQW3kUJk8DSnDJmQnc6kz+oo6sFiUArfsu9GcRN0YM8YEAss6RRasRnmIOuwMBl1/5TZ0thtMH6QdXmhfeg3gny0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ifKuuboZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ifKuuboZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2EEFC4CED2;
	Tue, 31 Dec 2024 23:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735689535;
	bh=R+ivmdjCUxyhelGvRuRBBSEwkXfVdKX3S9qBtHKRzFQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ifKuuboZ+XaoSEuzvPXJ9h1rPpAdHauknzUU+ujTG60dnP2fHI9qROWxrL+KlbJH7
	 hZLLtErhISc8CQEGAWOqwiFRHm24SmBU/LDgJLM68QF9IgZmXHl7/g+dPeV1tfj9IE
	 rkKa+u+tAoYSfw7jJfMwJqc8fuqIimCB1d/x18b2Gr7rVs0+Q5USdP35DsSgV/iGdr
	 sWes/HqskpMPjjD9VkY5s3SWeLAISbfAH3pDZynfmroSjL20ikp2BSQ1N4gnvFuVlV
	 C+FMO8t88V3jbKenI5UVlfDcJZjplWBv6XWjTeRSSwQC4+tySweXIdxvIyDXxVB74K
	 bGuHIFHDVYN+w==
Date: Tue, 31 Dec 2024 15:58:55 -0800
Subject: [PATCH 2/3] xfs/1856: add rtrmapbt upgrade to test matrix
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173568783579.2712510.14941057760653386301.stgit@frogsfrogsfrogs>
In-Reply-To: <173568783548.2712510.6440569474290843546.stgit@frogsfrogsfrogs>
References: <173568783548.2712510.6440569474290843546.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Add realtime reverse mapping btrees to the features that this test will
try to upgrade.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/1856 |   40 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 39 insertions(+), 1 deletion(-)


diff --git a/tests/xfs/1856 b/tests/xfs/1856
index fedeb157dbd9bb..8e3213da752348 100755
--- a/tests/xfs/1856
+++ b/tests/xfs/1856
@@ -30,11 +30,47 @@ rt_configured()
 	test "$USE_EXTERNAL" = "yes" && test -n "$SCRATCH_RTDEV"
 }
 
+# Does mkfs support metadir?
+supports_metadir()
+{
+	$MKFS_XFS_PROG 2>&1 | grep -q 'metadir='
+}
+
+# Do we need to enable metadir at mkfs time to support a feature upgrade test?
+need_metadir()
+{
+	local feat="$1"
+
+	# if realtime isn't configured, we don't need metadir
+	rt_configured || return 1
+
+	# If we don't even know what realtime rmap is, we don't need rt groups
+	# and hence don't need metadir.
+	test -z "${FEATURE_STATE["rmapbt"]}" && return 1
+
+	# rt rmap btrees require metadir, but metadir cannot be added to an
+	# existing rt filesystem.  Force it on at mkfs time.
+	test "${FEATURE_STATE["rmapbt"]}" -eq 1 && return 0
+	test "$feat" = "rmapbt" && return 0
+
+	return 1
+}
+
 # Compute the MKFS_OPTIONS string for a particular feature upgrade test
 compute_mkfs_options()
 {
+	local feat="$1"
 	local m_opts=""
 	local caller_options="$MKFS_OPTIONS"
+	local metadir
+
+	need_metadir "$feat" && metadir=1
+	if echo "$caller_options" | grep -q 'metadir='; then
+		test -z "$metadir" && metadir=0
+		caller_options="$(echo "$caller_options" | sed -e 's/metadir=*[0-9]*/metadir='$metadir'/g')"
+	elif [ -n "$metadir" ]; then
+		caller_options="$caller_options -m metadir=$metadir"
+	fi
 
 	for feat in "${FEATURES[@]}"; do
 		local feat_state="${FEATURE_STATE["${feat}"]}"
@@ -179,9 +215,11 @@ MKFS_OPTIONS="$(qerase_mkfs_options)"
 # upgrade don't spread failure to the rest of the tests.
 FEATURES=()
 if rt_configured; then
+	# rmap wasn't added to rt devices until after metadir
 	check_repair_upgrade finobt && FEATURES+=("finobt")
 	check_repair_upgrade inobtcount && FEATURES+=("inobtcount")
 	check_repair_upgrade bigtime && FEATURES+=("bigtime")
+	supports_metadir && check_repair_upgrade rmapbt && FEATURES+=("rmapbt")
 else
 	check_repair_upgrade finobt && FEATURES+=("finobt")
 	check_repair_upgrade rmapbt && FEATURES+=("rmapbt")
@@ -204,7 +242,7 @@ for feat in "${FEATURES[@]}"; do
 
 	upgrade_start_message "$feat" | _tee_kernlog $seqres.full > /dev/null
 
-	opts="$(compute_mkfs_options)"
+	opts="$(compute_mkfs_options "$feat")"
 	echo "mkfs.xfs $opts" >> $seqres.full
 
 	# Format filesystem

