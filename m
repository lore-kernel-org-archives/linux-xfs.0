Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71F007EF;
	Mon,  1 Jan 2024 00:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="POcvr6Pt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA44BC433C8;
	Mon,  1 Jan 2024 00:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704070727;
	bh=XXlbWvWkUPc6diQ1nc573PK6tgbd2IypPrgPrqS6584=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=POcvr6PtplJt4YwUw+Tf3FXS2VJWSY97tNmrlUbi6KyeKTCuBhyBOk0sk/3h10Cxt
	 ri8xbaDE5HIyqzMhWAY0NeYR+CyR7PSdFDx0bJtaLkXA8h+QlaKNywgm2FTR0g//ry
	 eVDkpvFPqTEq6abNxJPczcOUkeRYS3tsT98ZgGsTHSfwzUQk6VuzjKkiQyi3YsO+TC
	 MPbmuk5dWGc6a/nlvX1QKv49joKLcwVU9+ZOuId4jkE8T7U2OnNNiJa1yWgXiZICgI
	 KeBJtRzIGaNbXka9XN0cVangmty9ksayIMut9+/mts5NyhnuuPEqtDnw6xwpo/i36b
	 u9FBqyKmI6vyw==
Date: Sun, 31 Dec 2023 16:58:46 +9900
Subject: [PATCH 04/13] xfs/856: add rtrmapbt upgrade to test matrix
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170405031286.1826914.4787726527598409685.stgit@frogsfrogsfrogs>
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

Add realtime reverse mapping btrees to the features that this test will
try to upgrade.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/1856 |   39 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)


diff --git a/tests/xfs/1856 b/tests/xfs/1856
index 93bdbaa531..8453d9bff2 100755
--- a/tests/xfs/1856
+++ b/tests/xfs/1856
@@ -34,11 +34,46 @@ rt_configured()
 	test "$USE_EXTERNAL" = "yes" && test -n "$SCRATCH_RTDEV"
 }
 
+# Does mkfs support rtgroups?
+supports_rtgroups()
+{
+	$MKFS_XFS_PROG 2>&1 | grep -q 'rtgroups='
+}
+
+# Do we need to enable rtgroups at mkfs time to support a feature upgrade test?
+need_rtgroups()
+{
+	local feat="$1"
+
+	# if realtime isn't configured, we don't need rt groups
+	rt_configured || return 1
+
+	# If we don't even know what realtime rmap is, we don't need rt groups
+	test -z "${FEATURE_STATE["rmapbt"]}" && return 1
+
+	# rt rmap btrees require rt groups but rt groups cannot be added to
+	# an existing filesystem, so we must force it on at mkfs time
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
+	local rtgroups
+
+	need_rtgroups "$feat" && rtgroups=1
+	if echo "$caller_options" | grep -q 'rtgroups='; then
+		test -z "$rtgroups" && rtgroups=0
+		caller_options="$(echo "$caller_options" | sed -e 's/rtgroups=*[0-9]*/rtgroups='$rtgroups'/g')"
+	elif [ -n "$rtgroups" ]; then
+		caller_options="$caller_options -r rtgroups=$rtgroups"
+	fi
 
 	for feat in "${FEATURES[@]}"; do
 		local feat_state="${FEATURE_STATE["${feat}"]}"
@@ -170,10 +205,12 @@ post_exercise()
 # upgrade don't spread failure to the rest of the tests.
 FEATURES=()
 if rt_configured; then
+	# rmap wasn't added to rt devices until after metadir and rtgroups
 	check_repair_upgrade finobt && FEATURES+=("finobt")
 	check_repair_upgrade inobtcount && FEATURES+=("inobtcount")
 	check_repair_upgrade bigtime && FEATURES+=("bigtime")
 	check_repair_upgrade metadir && FEATURES+=("metadir")
+	supports_rtgroups && check_repair_upgrade rmapbt && FEATURES+=("rmapbt")
 else
 	check_repair_upgrade finobt && FEATURES+=("finobt")
 	check_repair_upgrade rmapbt && FEATURES+=("rmapbt")
@@ -196,7 +233,7 @@ for feat in "${FEATURES[@]}"; do
 
 	upgrade_start_message "$feat" | _tee_kernlog $seqres.full > /dev/null
 
-	opts="$(compute_mkfs_options)"
+	opts="$(compute_mkfs_options "$feat")"
 	echo "mkfs.xfs $opts" >> $seqres.full
 
 	# Format filesystem

