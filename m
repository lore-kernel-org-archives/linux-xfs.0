Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF79E2DBF49;
	Tue, 21 Oct 2025 18:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761072156; cv=none; b=dvCWibOyFsneQuvUTvEIhDUnaZKsWpAxVpRqiwtwQVc5ZGKb0QUnPq4bBH4Pa9PC7poF2qnrLERnyE8CN+dyhUXrcNO+TE0fZIJfrK/GhcHRjPjNY85MknwXb3ZklXrMANCT1Z35US+8TPHj5f/DP/EYN5L17jEqZhvADUyvhRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761072156; c=relaxed/simple;
	bh=TKkZt+mToepei0NZ1Loo93ZA9B4L2D2n3aGD+LG1r5Q=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AWUoD9V5kVVF0gspJY0Yf60kRbL4/T/jP7PMqfET8sZ4vx6FXzM0pM+o46A0+5OrAyhEUuM0v1MJsKHH2ZlCIg7ZaAm5Z8t9h22B/6qVFKigZNxZBGzIGVUjNRxAv7XiRREtlRGSxVVXzSSzdLzmwHLg/nexo7Rpo9iFYiigGjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VmPu1JGd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VmPu1JGd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C391C4CEF1;
	Tue, 21 Oct 2025 18:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761072156;
	bh=TKkZt+mToepei0NZ1Loo93ZA9B4L2D2n3aGD+LG1r5Q=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=VmPu1JGdM9iqr8cyj+nr+Q0M3GZIriYpI2+0D70VyrSFsj1nwZ+crsHUfcXzNi2ZM
	 xEZUZmGTCvHt6iSKQ6NhhxEQCwpF7qNbgDS1eq1rv3IV/lUDnq5gjFI8+InzzL5K14
	 qKnfPe2CCvuOW2z0gkhLgfRpHQIjFajYRYzXKOMbuSjm3QhXdowOLBE/CeC4tGLhj5
	 qzjOnDBCeJJ2sS9VGV0EH0y+2Yqp380hWnEEGE0VIoeJG5OJ9WAyYT4dlqJQfkZblR
	 a0dntOyhWZWcjSiM04C8zm3A9fdeaE2VappPRyHAgI2lyhCac9CA1mIG/kiVxHL3xc
	 H6Ee9uAthmyBg==
Date: Tue, 21 Oct 2025 11:42:35 -0700
Subject: [PATCH 2/2] check: collect core dumps from systemd-coredump
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <176107189073.4164152.3187672168604514761.stgit@frogsfrogsfrogs>
In-Reply-To: <176107189031.4164152.8523735303635067534.stgit@frogsfrogsfrogs>
References: <176107189031.4164152.8523735303635067534.stgit@frogsfrogsfrogs>
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
 README    |   20 ++++++++++++++++++++
 check     |    2 ++
 common/rc |   44 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 66 insertions(+)


diff --git a/README b/README
index 9e9afe3cbb7ad4..196c79a21bdc0c 100644
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
index 2d089d351380d2..c897afbb419612 100755
--- a/check
+++ b/check
@@ -930,6 +930,7 @@ function run_section()
 		     $1 == "'$seqnum'" {lasttime=" " $2 "s ... "; exit} \
 		     END {printf "%s", lasttime}' "$check.time"
 		rm -f core $seqres.notrun
+		_start_coredumpctl_collection
 
 		start=`_wallclock`
 		$timestamp && _timestamp
@@ -963,6 +964,7 @@ function run_section()
 		# just "core".  Use globbing to find the most common patterns,
 		# assuming there are no other coredump capture packages set up.
 		local cores=0
+		_finish_coredumpctl_collection
 		for i in core core.*; do
 			test -f "$i" || continue
 			if ((cores++ == 0)); then
diff --git a/common/rc b/common/rc
index 462f433197a3c2..3e7d7646cd6868 100644
--- a/common/rc
+++ b/common/rc
@@ -5001,6 +5001,50 @@ _check_kmemleak()
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

