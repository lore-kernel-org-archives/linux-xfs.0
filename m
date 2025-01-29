Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B24F166F1A;
	Wed, 29 Jan 2025 03:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738120394; cv=none; b=jzbdgi9bUM1fbxciuezqIjlMiLbMBoYfiCSxZjUPDOa7o2jTra31UQFmtamVDCTiCSex1la2iFEninn16R8iniADkAsaxcxBHUiXWE7b9nA6PibaZb9FhFe3UeZ0mYsWgwfuVrP+0sFWzhi4JKEIpqGyoJlrQWcKykFHI7xbvR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738120394; c=relaxed/simple;
	bh=VeAp8D2m+K0i0k6MO1B6Cg6rfije6AkiU0ELUEtgy0E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CyabtH3w8k03Pj+CQLIFI5oZq6uCWPg35beoGHM0uFUemmB51NmA1fyeGGdTz7CYGP4l/mSXVy/g05RAkwQbPsiw+FwdWI78IXIsL0oeBPEAC1QlLd+r/JCAMllThLbmNcxP1nK31RzpiZbLdSkmy1SUG27UmQoOr94P2A7wQH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jIVsiiWq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jIVsiiWq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06336C4CED3;
	Wed, 29 Jan 2025 03:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738120394;
	bh=VeAp8D2m+K0i0k6MO1B6Cg6rfije6AkiU0ELUEtgy0E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jIVsiiWqNURD/Vba6icorsP9gDRrECfAYZs9IVpqST2OOrL2D9utKdYPMtO8e+300
	 pclQ+cFFAJnakL4RgOzP6ckTzldTFDm5EqXEyCbcvd1l0FnAWn3FxTTZjvYLcA8PW6
	 7//A9i/+nYfEBJxgTh3LmXdoCsdHEyrkj+iWZj4FD7Aodg6zTCmWI924UpBNkRsdG7
	 8MmFM7Ih/QrTOpKX69e8tAcQdj/6CJe1U/aML5OsvL0M/NLQtQagslJrknCJstuShj
	 fJmc/+yT95gqY49W5QhkHegHQJRPWieehkSLC4+7QDd8/iqhtD+nCd8/TEYRpzvKmj
	 ltRjvmr3LQ4yA==
Date: Tue, 28 Jan 2025 19:13:13 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: zlang@redhat.com, hch@lst.de, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/23] common: fix pkill by running test program in a
 separate session
Message-ID: <20250129031313.GV3557695@frogsfrogsfrogs>
References: <Z48UWiVlRmaBe3cY@dread.disaster.area>
 <20250122042400.GX1611770@frogsfrogsfrogs>
 <Z5CLUbj4qbXCBGAD@dread.disaster.area>
 <20250122070520.GD1611770@frogsfrogsfrogs>
 <Z5C9mf2yCgmZhAXi@dread.disaster.area>
 <20250122214609.GE1611770@frogsfrogsfrogs>
 <Z5GYgjYL_9LecSb9@dread.disaster.area>
 <Z5heaj-ZsL_rBF--@dread.disaster.area>
 <20250128072352.GP3557553@frogsfrogsfrogs>
 <Z5lAek54UK8mdFs-@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z5lAek54UK8mdFs-@dread.disaster.area>

On Wed, Jan 29, 2025 at 07:39:22AM +1100, Dave Chinner wrote:
> On Mon, Jan 27, 2025 at 11:23:52PM -0800, Darrick J. Wong wrote:
> > On Tue, Jan 28, 2025 at 03:34:50PM +1100, Dave Chinner wrote:
> > > On Thu, Jan 23, 2025 at 12:16:50PM +1100, Dave Chinner wrote:
> > > 4. /tmp is still shared across all runner instances so all the
> > > 
> > >    concurrent runners dump all their tmp files in /tmp. However, the
> > >    runners no longer have unique PIDs (i.e. check runs as PID 3 in
> > >    all runner instaces). This means using /tmp/tmp.$$ as the
> > >    check/test temp file definition results is instant tmp file name
> > >    collisions and random things in check and tests fail.  check and
> > >    common/preamble have to be converted to use `mktemp` to provide
> > >    unique tempfile name prefixes again.
> > > 
> > > 5. Don't forget to revert the parent /proc mount back to shared
> > >    after check has finished running (or was aborted).
> > > 
> > > I think with this (current prototype patch below), we can use PID
> > > namespaces rather than process session IDs for check-parallel safe
> > > process management.
> > > 
> > > Thoughts?
> > 
> > Was about to go to bed, but can we also start a new mount namespace,
> > create a private (or at least non-global) /tmp to put files into, and
> > then each test instance is isolated from clobbering the /tmpfiles of
> > other ./check instances *and* the rest of the system?
> 
> We probably can. I didn't want to go down that rat hole straight
> away, because then I'd have to make a decision about what to mount
> there. One thing at a time....
> 
> I suspect that I can just use a tmpfs filesystem for it - there's
> heaps of memory available on my test machines and we don't use /tmp
> to hold large files, so that should work fine for me.  However, I'm
> a little concerned about what will happen when testing under memory
> pressure situations if /tmp needs memory to operate correctly.
> 
> I'll have a look at what is needed for private tmpfs /tmp instances
> to work - it should work just fine.
> 
> However, if check-parallel has taught me anything, it is that trying
> to use "should work" features on a modern system tends to mean "this
> is a poorly documented rat-hole that with many dead-ends that will
> be explored before a working solution is found"...

<nod> I'm running an experiment overnight with the following patch to
get rid of the session id grossness.  AFAICT it can also be used by
check-parallel to start its subprocesses in separate pid namespaces,
though I didn't investigate thoroughly.

I'm also not sure it's required for check-helper to unmount the /proc
that it creates; merely exiting seems to clean everything up? <shrug>

I also tried using systemd-nspawn to run fstests inside a "container"
but very quickly discovered that you can't pass block devices to the
container which makes fstests pretty useless for testing real scsi
devices. :/

--D

check: run tests in a private pid/mount namespace

Experiment with running tests in a private pid/mount namespace for
better isolation of the scheduler (check) vs the test (./$seq).  This
also makes it cleaner to adjust the oom score and is a convenient place
to set up the environment before invoking the test.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 check        |   30 +++++-------------------------
 check-helper |   31 +++++++++++++++++++++++++++++++
 common/rc    |    8 +++-----
 3 files changed, 39 insertions(+), 30 deletions(-)
 create mode 100755 check-helper

diff --git a/check b/check
index 00ee5af2a31e34..9c70f6f1e10110 100755
--- a/check
+++ b/check
@@ -698,41 +698,21 @@ _adjust_oom_score -500
 # systemd doesn't automatically remove transient scopes that fail to terminate
 # when systemd tells them to terminate (e.g. programs stuck in D state when
 # systemd sends SIGKILL), so we use reset-failed to tear down the scope.
-#
-# Use setsid to run the test program with a separate session id so that we
-# can pkill only the processes started by this test.
 _run_seq() {
-	local cmd=(bash -c "test -w ${OOM_SCORE_ADJ} && echo 250 > ${OOM_SCORE_ADJ}; exec setsid bash ./$seq")
+	local cmd=("./check-helper" "./$seq")
 
 	if [ -n "${HAVE_SYSTEMD_SCOPES}" ]; then
 		local unit="$(systemd-escape "fs$seq").scope"
 		systemctl reset-failed "${unit}" &> /dev/null
-		systemd-run --quiet --unit "${unit}" --scope "${cmd[@]}" &
-		CHILDPID=$!
-		wait
+		systemd-run --quiet --unit "${unit}" --scope "${cmd[@]}"
 		res=$?
-		unset CHILDPID
 		systemctl stop "${unit}" &> /dev/null
 		return "${res}"
 	else
 		# bash won't run the SIGINT trap handler while there are
 		# foreground children in a separate session, so we must run
 		# the test in the background and wait for it.
-		"${cmd[@]}" &
-		CHILDPID=$!
-		wait
-		unset CHILDPID
-	fi
-}
-
-_kill_seq() {
-	if [ -n "$CHILDPID" ]; then
-		# SIGPIPE will kill all the children (including fsstress)
-		# without bash logging fatal signal termination messages to the
-		# console
-		pkill -PIPE --session "$CHILDPID"
-		wait
-		unset CHILDPID
+		"${cmd[@]}"
 	fi
 }
 
@@ -741,9 +721,9 @@ _prepare_test_list
 fstests_start_time="$(date +"%F %T")"
 
 if $OPTIONS_HAVE_SECTIONS; then
-	trap "_kill_seq; _summary; exit \$status" 0 1 2 3 15
+	trap "_summary; exit \$status" 0 1 2 3 15
 else
-	trap "_kill_seq; _wrapup; exit \$status" 0 1 2 3 15
+	trap "_wrapup; exit \$status" 0 1 2 3 15
 fi
 
 function run_section()
diff --git a/check-helper b/check-helper
new file mode 100755
index 00000000000000..2cc8dbe5cfc791
--- /dev/null
+++ b/check-helper
@@ -0,0 +1,31 @@
+#!/bin/bash
+
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2025 Oracle.  All Rights Reserved.
+#
+# Try starting things in a private pid/mount namespace with a private /tmp
+# and /proc so that child process trees cannot interfere with each other.
+
+if [ -n "${IN_NSEXEC}" ]; then
+	for path in /proc /tmp; do
+		mount --make-private "$path"
+	done
+	unset IN_NSEXEC
+	mount -t proc proc /proc
+	mount -t tmpfs tmpfs /tmp
+
+	oom_knob="/proc/self/oom_score_adj"
+	test -w "${oom_knob}" && echo 250 > "${oom_knob}"
+
+	# Run the test, but don't let it be pid 1 because that will confuse
+	# the filter functions in common/dump.
+	"$@"
+	exit
+fi
+
+if [ -z "$1" ] || [ "$1" = "--help" ]; then
+	echo "Usage: $0 command [args...]"
+	exit 1
+fi
+
+IN_NSEXEC=1 exec "$(dirname "$0")/src/nsexec" -m -p $0 "$@"
diff --git a/common/rc b/common/rc
index 1c28a2d190f5a0..cc080ecaa9f801 100644
--- a/common/rc
+++ b/common/rc
@@ -33,13 +33,13 @@ _test_sync()
 # Kill only the test processes started by this test
 _pkill()
 {
-	pkill --session 0 "$@"
+	pkill "$@"
 }
 
 # Find only the test processes started by this test
 _pgrep()
 {
-	pgrep --session 0 "$@"
+	pgrep "$@"
 }
 
 # Common execution handling for fsstress invocation.
@@ -2817,11 +2817,9 @@ _require_user_exists()
 	[ "$?" == "0" ] || _notrun "$user user not defined."
 }
 
-# Run all non-root processes in the same session as the root.  Believe it or
-# not, passing $SHELL in this manner works both for "su" and "su -c cmd".
 _su()
 {
-	su --session-command $SHELL "$@"
+	su "$@"
 }
 
 # check if a user exists and is able to execute commands.
