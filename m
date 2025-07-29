Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC8F1F956;
	Tue, 29 Jul 2025 20:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753819867; cv=none; b=PYkoYDhcL/wnw9lgYerU0puy+RbJuTkWXoTY+VXlILFP/veiycdufJhckgv7b00Cki6PwIgegeMtM16CB/yaWsxA97xK0FW1+39iJscYSEoCNiKybDgKviAN3g3cFKvoQGPw+iHSJIh16tzB3qH3Ia87gYkbKbPXv6XMJVFzwhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753819867; c=relaxed/simple;
	bh=kc5U0hLoGfGaJ0/Z2qdqDZxObo5maAIOUTFfNx5+bbs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N9nqi+VREOQwrKFmmfBq6Uia/2BjUsq5FYLpfHnWwCTxFqEp9y7kSmHZZgU3odeb/fxAP+U1SGOJnyxdCXlgMoZpT/iH4GmlAvfCjXbryyhekCr7AenxVzuooAfgY6VqvHR6+ytL0bRDBVCqKEQTqoOSCNYgf/PE1w6cxiWuwdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l5iGb8MH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l5iGb8MH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15FC6C4CEEF;
	Tue, 29 Jul 2025 20:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753819867;
	bh=kc5U0hLoGfGaJ0/Z2qdqDZxObo5maAIOUTFfNx5+bbs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=l5iGb8MHM302BmnTNo3XtAxQ3dwAyc0tzBOSgUrclRxV0N5TB0cDdwVXTsI+tYors
	 sn7BwUs40kWhuw5irAqTexQifgLTnyYOgS/ETfqLFUk2nObbQRHJT0MKfHgx+agg1+
	 gpWAJujfq6hUnQ1JMvih1suDEpOZCfGwp3KHszaGZSCpBHUQbFMewblimz1D6QpKrU
	 zFaTcHAbntpEMjT1z8jFoEomS6uFqGWYiizMTJMCIm/ZrF78I5Bn5nCh/xD2mDywDU
	 Rz6ziz56IKoalqBCZB24drC9HoVejv4bR5nrpsaqBy9+i4sHDVhCzFRsccXRvLJDIC
	 waPZN7Cjj4vvw==
Date: Tue, 29 Jul 2025 13:11:06 -0700
Subject: [PATCH 2/2] check: collect core dumps from systemd-coredump
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <175381958439.3021194.17530499480231032752.stgit@frogsfrogsfrogs>
In-Reply-To: <175381958396.3021194.15630936445319512317.stgit@frogsfrogsfrogs>
References: <175381958396.3021194.15630936445319512317.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

On modern RHEL (>=8) and Debian KDE systems, systemd-coredump can be
installed to capture core dumps from crashed programs.  If this is the
case, we would like to capture core dumps from programs that crash
during the test.  Set up an (admittedly overwrought) pipeline to extract
dumps created during the test and then capture them the same way that we
pick up "core" and "core.$pid" files.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 check     |    2 ++
 common/rc |   44 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+)


diff --git a/check b/check
index ce7eacb7c45d9e..77581e438c46b9 100755
--- a/check
+++ b/check
@@ -924,6 +924,7 @@ function run_section()
 		     $1 == "'$seqnum'" {lasttime=" " $2 "s ... "; exit} \
 		     END {printf "%s", lasttime}' "$check.time"
 		rm -f core $seqres.notrun
+		_start_coredumpctl_collection
 
 		start=`_wallclock`
 		$timestamp && _timestamp
@@ -957,6 +958,7 @@ function run_section()
 		# just "core".  Use globbing to find the most common patterns,
 		# assuming there are no other coredump capture packages set up.
 		local cores=0
+		_finish_coredumpctl_collection
 		for i in core core.*; do
 			test -f "$i" || continue
 			if ((cores++ == 0)); then
diff --git a/common/rc b/common/rc
index 04b721b7318a7e..e4c4d05387f44e 100644
--- a/common/rc
+++ b/common/rc
@@ -5034,6 +5034,50 @@ _check_kmemleak()
 	fi
 }
 
+# Current timestamp, in a format that systemd likes
+_systemd_now() {
+	timedatectl show --property=TimeUSec --value
+}
+
+# Do what we need to do to capture core dumps from coredumpctl
+_start_coredumpctl_collection() {
+	command -v coredumpctl &>/dev/null || return
+	command -v timedatectl &>/dev/null || return
+	command -v jq &>/dev/null || return
+
+	sysctl kernel.core_pattern | grep -q systemd-coredump || return
+	COREDUMPCTL_START_TIMESTAMP="$(_systemd_now)"
+}
+
+# Capture core dumps from coredumpctl.
+#
+# coredumpctl list only supports json output as a machine-readable format.  The
+# human-readable format intermingles spaces from the timestamp with actual
+# column separators, so we cannot parse that sanely.  The json output is an
+# array of:
+#        {
+#                "time" : 1749744847150926,
+#                "pid" : 2297,
+#                "uid" : 0,
+#                "gid" : 0,
+#                "sig" : 6,
+#                "corefile" : "present",
+#                "exe" : "/run/fstests/e2fsprogs/fuse2fs",
+#                "size" : 47245
+#        },
+# So we use jq to filter out lost corefiles, then print the pid and exe
+# separated by a pipe and hope that nobody ever puts a pipe in an executable
+# name.
+_finish_coredumpctl_collection() {
+	test -n "$COREDUMPCTL_START_TIMESTAMP" || return
+
+	coredumpctl list --since="$COREDUMPCTL_START_TIMESTAMP" --json=short 2>/dev/null | \
+	jq --raw-output 'map(select(.corefile == "present")) | map("\(.pid)|\(.exe)") | .[]' | while IFS='|' read pid exe; do
+		test -e "core.$pid" || coredumpctl dump --output="core.$pid" "$pid" "$exe" &>> $seqres.full
+	done
+	unset COREDUMPCTL_START_TIMESTAMP
+}
+
 # don't check dmesg log after test
 _disable_dmesg_check()
 {

