Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEABD188A0C;
	Wed, 13 Aug 2025 15:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755098317; cv=none; b=jKvD8detPTexsOfL3YvWSRNVSPS8J9AfRpDlmoXGz/xMMy4BpaAmiOCUlBlLkeLQaMBm1ITFXzsDCii+MV8u1AMrOaVqDmQZA83UDQqTn0ccvDBWZsufLAFWD5f5Js4QM66yxdEYXHkBAzYYx4hdMGcy9rTI/e/f5SDwwLuAZKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755098317; c=relaxed/simple;
	bh=/cCZ0J8HYbHeehuodruuC87QWAo2CjRdwJQIXFDC+34=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GyqnKA5LlZ8hzj0S1N8YQB8dDbfU0Kwyteu6m+7HbpeK8rwUNZypWAFCamfCFh4q8jrKSPoB0OoVEGznvq1bSRSm2IXIdPYVoxSTMikcwzwJOSw8P1Ce1Vg8k2R84KImq6q3FziwgxAS2+5nuVRN8CsPdn/n2N4QL4QCNYZjsvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AOcc7Ecg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AOcc7Ecg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34542C4CEEB;
	Wed, 13 Aug 2025 15:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755098317;
	bh=/cCZ0J8HYbHeehuodruuC87QWAo2CjRdwJQIXFDC+34=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AOcc7Ecgbne1cdoxE1zT7t6BEDTWgQXabokOMk4CXfoHBCEb8uYgr4QmES0nxT1BI
	 PR5qqxO08phuw15RIVDhJ1NTmSXmxwirxpyv+EKnVo8YMTv20YLvrD+4b06WD2Z04Z
	 YuAGMjGJpterFYY8ertD0A2VX68k6I9qEX/BrbaDHO3Cbo2CYWWa1YabdmtIuacaxl
	 9nW0LjhgH9UH712tFOzoFj5q+zU3wReZG/EpJvZMuTgURFlNs3YW1NxU13gPYbvW5r
	 y8RsqlcimVzzbVkq5FMG7IDoOhwdk/SU4rPWCT3AO2h5olpUWiNBTCq99z7q9fG4UO
	 siNOo3ZSh2+RQ==
Date: Wed, 13 Aug 2025 08:18:36 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: [PATCH v2 2/2] check: collect core dumps from systemd-coredump
Message-ID: <20250813151836.GC7952@frogsfrogsfrogs>
References: <175381958396.3021194.15630936445319512317.stgit@frogsfrogsfrogs>
 <175381958439.3021194.17530499480231032752.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <175381958439.3021194.17530499480231032752.stgit@frogsfrogsfrogs>

From: Darrick J. Wong <djwong@kernel.org>

On modern RHEL (>=8) and Debian KDE systems, systemd-coredump can be
installed to capture core dumps from crashed programs.  If this is the
case, we would like to capture core dumps from programs that crash
during the test.  Set up an (admittedly overwrought) pipeline to extract
dumps created during the test and then capture them the same way that we
pick up "core" and "core.$pid" files.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
v2: update reamde
---
 README    |   20 ++++++++++++++++++++
 check     |    2 ++
 common/rc |   44 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 66 insertions(+)

diff --git a/README b/README
index de452485af87a3..14e54a00c9e1a2 100644
--- a/README
+++ b/README
@@ -109,6 +109,11 @@ Ubuntu or Debian
    $ sudo apt-get install exfatprogs f2fs-tools ocfs2-tools udftools xfsdump \
         xfslibs-dev
 
+3. Install packages for optional features:
+
+    systemd coredump capture:
+    $ sudo apt install systemd-coredump systemd jq
+
 Fedora
 ------
 
@@ -124,6 +129,11 @@ Fedora
     $ sudo yum install btrfs-progs exfatprogs f2fs-tools ocfs2-tools xfsdump \
         xfsprogs-devel
 
+3. Install packages for optional features:
+
+    systemd coredump capture:
+    $ sudo yum install systemd systemd-udev jq
+
 RHEL or CentOS
 --------------
 
@@ -159,6 +169,11 @@ RHEL or CentOS
     For ocfs2 build and install:
      - see https://github.com/markfasheh/ocfs2-tools
 
+5. Install packages for optional features:
+
+    systemd coredump capture:
+    $ sudo yum install systemd systemd-udev jq
+
 SUSE Linux Enterprise or openSUSE
 ---------------------------------
 
@@ -176,6 +191,11 @@ SUSE Linux Enterprise or openSUSE
     For XFS install:
      $ sudo zypper install xfsdump xfsprogs-devel
 
+3. Install packages for optional features:
+
+    systemd coredump capture:
+    $ sudo yum install systemd systemd-coredump jq
+
 Build and install test, libs and utils
 --------------------------------------
 
diff --git a/check b/check
index 7ef6c9b3d69df5..37f733d0f2afb2 100755
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
index 3b853a913bee44..335d995909f74c 100644
--- a/common/rc
+++ b/common/rc
@@ -5053,6 +5053,50 @@ _check_kmemleak()
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
