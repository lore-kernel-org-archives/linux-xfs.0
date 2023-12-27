Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 718C9BA35;
	Mon,  1 Jan 2024 00:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O7j/8nac"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40E3DC433C7;
	Mon,  1 Jan 2024 00:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704069944;
	bh=f8ynwtIRFwXaM6SCG29/GknoBXX9+TC34h3xNfgOfAA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=O7j/8nacmdsK/4kyeKQHt7HOA7EnFjO20Un16dCirp8ACMM4UDHVgz280zQcjwkms
	 9LXl4zdd/YBatwjPW1a4VO+VZ8HVRVjaM6yyekDPiYKx1qlw6JRe2V3QBtvUFjAhg1
	 sIj9fzlRU3yYiiXEBNpHUoGk9v+Mbcz/dPwUU6cnk/yGh0deV4HcJxcAHJ6s4AOHDD
	 Zg23dtPZgszhW0+6nLAVSRaZCutWyzyX3OTwI0MQXPHJ1Xd0kpEmwcJaZ4XeG6ah5F
	 0eWzbXieE+clNjLHbWEM9dlnrYffION/wNhNRCBlMzqn7X11vDs+JUpbRdfXq7LTlI
	 yBDUjtXupy9ww==
Date: Sun, 31 Dec 2023 16:45:43 +9900
Subject: [PATCH 1/1] xfs: test xfs_scrub services
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, guan@eryu.me
Message-ID: <170405027224.1823970.12236527305568587932.stgit@frogsfrogsfrogs>
In-Reply-To: <170405027211.1823970.7781854324106857081.stgit@frogsfrogsfrogs>
References: <170405027211.1823970.7781854324106857081.stgit@frogsfrogsfrogs>
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

Create a pair of new tests that check that xfs_scrub and xfs_scrub_all
will find and test mounted filesystems.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/rc          |   22 ++++++++
 tests/xfs/1863     |  136 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1863.out |    6 ++
 3 files changed, 164 insertions(+)
 create mode 100755 tests/xfs/1863
 create mode 100644 tests/xfs/1863.out


diff --git a/common/rc b/common/rc
index a9e0ba7e22..969ff93de7 100644
--- a/common/rc
+++ b/common/rc
@@ -5333,6 +5333,7 @@ _soak_loop_running() {
 	return 0
 }
 
+
 _require_unshare() {
 	unshare -f -r -m -p -U $@ true &>/dev/null || \
 		_notrun "unshare $*: command not found, should be in util-linux"
@@ -5345,6 +5346,27 @@ _random_file() {
 	echo "$basedir/$(ls -U $basedir | shuf -n 1)"
 }
 
+_require_program() {
+	local cmd="$1"
+	local tag="$2"
+
+	test -z "$tag" && tag="$(basename "$cmd")"
+	command -v "$1" &>/dev/null || _notrun "$tag required"
+}
+
+_require_systemd_service() {
+	_require_program systemctl systemd
+
+	systemctl cat "$1" >/dev/null || \
+		_notrun "systemd service \"$1\" not found"
+}
+
+_require_systemd_running() {
+	_require_systemd_service "$1"
+	test "$(systemctl is-active "$1")" = "active" || \
+		_notrun "systemd service \"$1\" not running"
+}
+
 init_rc
 
 ################################################################################
diff --git a/tests/xfs/1863 b/tests/xfs/1863
new file mode 100755
index 0000000000..36f10a0826
--- /dev/null
+++ b/tests/xfs/1863
@@ -0,0 +1,136 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2023-2024 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1863
+#
+# Check that the online fsck systemd services find and check the test and
+# scratch filesystems, and that we can read the health reports after the fact.
+# IOWs, basic testing for the systemd background services.
+#
+. ./common/preamble
+_begin_fstest auto scrub
+
+_cleanup()
+{
+	cd /
+	if [ -n "$new_svcfile" ]; then
+		rm -f "$new_svcfile"
+		systemctl daemon-reload
+	fi
+	rm -r -f $tmp.*
+}
+
+# Import common functions.
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+
+_supported_fs xfs
+_require_systemd_service xfs_scrub@.service
+_require_systemd_service xfs_scrub_all.service
+_require_scratch
+_require_scrub
+_require_xfs_io_command "scrub"
+_require_xfs_spaceman_command "health"
+_require_populate_commands
+
+_xfs_skip_online_rebuild
+_xfs_skip_offline_rebuild
+
+# Back when xfs_scrub was really experimental, the systemd service definitions
+# contained various bugs that resulted in weird problems such as logging
+# messages sometimes dropping slashes from paths, and the xfs_scrub@ service
+# being logged as completing long after the process actually stopped.  These
+# problems were all fixed by the time the --auto-media-scan-stamp option was
+# added to xfs_scrub_all, so turn off this test for such old codebases.
+scruball_exe="$(systemctl cat xfs_scrub_all | grep '^ExecStart=' | sed -e 's/ExecStart=//g' -e 's/ .*$//g')"
+grep -q -- '--auto-media-scan-stamp' "$scruball_exe" || \
+	_notrun "xfs_scrub service too old, skipping test"
+
+orig_svcfile="/lib/systemd/system/xfs_scrub_all.service"
+test -f "$orig_svcfile" || \
+	_notrun "cannot find xfs_scrub_all service file"
+
+new_svcdir="/run/systemd/system/"
+test -d "$new_svcdir" || \
+	_notrun "cannot find runtime systemd service dir"
+
+# We need to make some local mods to the xfs_scrub_all service definition
+# so we fork it and create a new service just for this test.
+new_scruball_svc="xfs_scrub_all_fstest.service"
+systemctl status "$new_scruball_svc" 2>&1 | grep -E -q '(could not be found|Loaded: not-found)' || \
+	_notrun "systemd service \"$new_scruball_svc\" found, will not mess with this"
+
+find_scrub_trace() {
+	local path="$1"
+
+	$XFS_SPACEMAN_PROG -c "health" "$path" | grep -q ": ok$" || \
+		echo "cannot find evidence that $path was scrubbed"
+}
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+_scratch_mount
+
+run_service() {
+	systemctl start --wait "$1"
+
+	# Sometimes systemctl start --wait returns early due to some external
+	# event, such as somebody else reloading the daemon, which closes the
+	# socket.  The CLI has no way to resume waiting for the service once
+	# the connection breaks, so we'll pgrep for up to 30 seconds until
+	# there are no xfs_scrub processes running on the system.
+	for ((i = 0; i < 30; i++)); do
+		pgrep -f 'xfs_scrub*' > /dev/null 2>&1 || break
+		sleep 1
+	done
+}
+
+echo "Scrub Test FS"
+test_path=$(systemd-escape --path "$TEST_DIR")
+run_service xfs_scrub@$test_path
+find_scrub_trace "$TEST_DIR"
+
+echo "Scrub Scratch FS"
+scratch_path=$(systemd-escape --path "$SCRATCH_MNT")
+run_service xfs_scrub@$scratch_path
+find_scrub_trace "$SCRATCH_MNT"
+
+# Remove the xfs_scrub_all media scan stamp directory (if specified) because we
+# want to leave the regular system's stamp file alone.
+mkdir -p $tmp/stamp
+
+new_svcfile="$new_svcdir/$new_scruball_svc"
+cp "$orig_svcfile" "$new_svcfile"
+
+execstart="$(grep '^ExecStart=' $new_svcfile | sed -e 's/--auto-media-scan-interval[[:space:]]*[0-9]*[a-z]*//g')"
+sed -e '/ExecStart=/d' -e '/BindPaths=/d' -i $new_svcfile
+cat >> "$new_svcfile" << ENDL
+[Service]
+$execstart
+ENDL
+systemctl daemon-reload
+
+# Emit the results of our editing to the full log.
+systemctl cat "$new_scruball_svc" >> $seqres.full
+
+# Cycle both mounts to clear all the incore CHECKED bits.
+_test_cycle_mount
+_scratch_cycle_mount
+
+echo "Scrub Everything"
+run_service "$new_scruball_svc"
+
+sleep 2 # give systemd a chance to tear down the service container mount tree
+
+find_scrub_trace "$TEST_DIR"
+find_scrub_trace "$SCRATCH_MNT"
+
+echo "Scrub Done" | tee -a $seqres.full
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1863.out b/tests/xfs/1863.out
new file mode 100644
index 0000000000..a1dd7d4bf4
--- /dev/null
+++ b/tests/xfs/1863.out
@@ -0,0 +1,6 @@
+QA output created by 1863
+Format and populate
+Scrub Test FS
+Scrub Scratch FS
+Scrub Everything
+Scrub Done

