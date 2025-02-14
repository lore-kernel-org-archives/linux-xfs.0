Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4819F267711;
	Fri, 14 Feb 2025 17:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739555806; cv=none; b=o6Rbo/4+FLYNqBgsPRq+vG7g8Hh+nAAEj4FhbMXBjYAnz1pTYSa8o1E/rVuqV93PYNdVXzVE3vGMIL56PSwVNctGYYejs+wa6eNA4/E+5FQm2GT6VzoiIfOnxtRK9ejUit0urs89I5BE+PcaftAJnZsBlDWEoZtmfn2yuZ8CRKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739555806; c=relaxed/simple;
	bh=mMuZiM+XRXw1PH8WLk3D6g2FtXvvGsN2XGHG+IQx9jM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MHFXsCkCuf876dMRkEdqLdAAJBXCgijSbZOeDiKyXnRdiUes/Nd6v2VIsh6VdDwqL5j2efvOUYeLVKw+A5x2oHZt5FZHzY1VcYV11vaHScf6+FuVdH29eq9R39IsogNZXOb2LQUK5qO6eUXmLJNLDmT8FhPRIwi/oM3jQohuMiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GNL4skNj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GNL4skNj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8D60C4CED1;
	Fri, 14 Feb 2025 17:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739555804;
	bh=mMuZiM+XRXw1PH8WLk3D6g2FtXvvGsN2XGHG+IQx9jM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GNL4skNjyEtyCAUPcXmE/uTXuKRyyDkH7WR7lwSW27WvgtAGPPwEA7tjavn2du/Fi
	 e9rRtCcYb3WTCBf0W6SdTZdL/0KkLGNjZUBAkP3DmJtIXrezq/I27/3OrKiIfqIzA9
	 XRXVeFQsNFbigprIgJZlJULTtEPSnr2O73ZOl/IM1hwdqTizXlK6UonQmj7LH2305V
	 zixG1K45epCYxzJDbqceBKMJhmxUOZ4dLHkOx9kwl1pTG3sh2coGW4xjq3pdn9B3HY
	 1jR29MeAD3gP2L6kzwc/rB4x7/FNsrBHoNLdvvuCbk3qrZsCrql49mrTnIgu+Of6SD
	 LqToA7LH0XIhA==
Date: Fri, 14 Feb 2025 09:56:44 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@redhat.com>
Cc: dchinner@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/34] common: fix pkill by running test program in a
 separate session
Message-ID: <20250214175644.GN3028674@frogsfrogsfrogs>
References: <173933094308.1758477.194807226568567866.stgit@frogsfrogsfrogs>
 <173933094569.1758477.13105816499921786298.stgit@frogsfrogsfrogs>
 <20250214173406.pf6j5pbb3ccoypui@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250214173406.pf6j5pbb3ccoypui@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>

On Sat, Feb 15, 2025 at 01:34:06AM +0800, Zorro Lang wrote:
> On Tue, Feb 11, 2025 at 07:34:20PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Run each test program with a separate session id so that we can tell
> > pkill to kill all processes of a given name, but only within our own
> > session id.  This /should/ suffice to run multiple fstests on the same
> > machine without one instance shooting down processes of another
> > instance.
> > 
> > This fixes a general problem with using "pkill --parent" -- if the
> > process being targeted is not a direct descendant of the bash script
> > calling pkill, then pkill will not do anything.  The scrub stress tests
> > make use of multiple background subshells, which is how a ^C in the
> > parent process fails to result in fsx/fsstress being killed.
> > 
> > This is necessary to fix SOAK_DURATION runtime constraints for all the
> > scrub stress tests.  However, there is a cost -- the test program no
> > longer runs with the same controlling tty as ./check, which means that
> > ^Z doesn't work and SIGINT/SIGQUIT are set to SIG_IGN.  IOWs, if a test
> > wants to kill its subprocesses, it must use another signal such as
> > SIGPIPE.  Fortunately, bash doesn't whine about children dying due to
> > fatal signals if the children run in a different session id.
> > Unfortunately we have to let it run the test as a background process for
> > bash to handle SIGINT, and SIGSTOP no longer works properly.
> > 
> > This solution is a bit crap, and I have a better solution for it in the
> > next patch that uses private pid and mount namespaces.  Unfortunately,
> > that solution adds new minimum requirements for running fstests and
> > removing previously supported configurations abruptly during a bug fix
> > is not appropriate behavior.
> > 
> > I also explored alternate designs, and this was the least unsatisfying:
> > 
> > a) Setting the process group didn't work because background subshells
> > are assigned a new group id.
> > 
> > b) Constraining the pkill/pgrep search to a cgroup could work, but it
> > seems that procps has only recently (~2023) gained the ability to filter
> > on a cgroup.  Furthermore, we'd have to set up a cgroup in which to run
> > the fstest.  The last decade has been rife with user bug reports
> > complaining about chaos resulting from multiple pieces of software (e.g.
> > Docker, systemd, etc.) deciding that they own the entire cgroup
> > structure without having any means to enforce that statement.  We should
> > not wade into that mess.
> > 
> > c) Putting test subprocesses in a systemd sub-scope and telling systemd
> > to kill the sub-scope could work because ./check can already use it to
> > ensure that all child processes of a test are killed.  However, this is
> > an *optional* feature, which means that we'd have to require systemd.
> > 
> > d) Constraining the pkill/pgrep search to a particular pid namespace
> > could work, but we already have tests that set up their own mount
> > namespaces, which means the constrained pgrep will not find all child
> > processes of a test.  Though this hasn't been born out through testing?
> > 
> > e) Constraining to any other type of namespace (uts, pid, etc) might not
> > work because those namespaces might not be enabled.  However, combining
> > a private pid and mount namespace to isolate tests from each other seems
> > to work better than session ids.  This is coming in a subsequent patch,
> > but to avoid breaking older systems, we will use this as an immediately
> > deprecated fallback.
> > 
> > f) Revert check-parallel and go back to one fstests instance per system.
> > Zorro already chose not to revert.
> > 
> > So.  Change _run_seq to create a the ./$seq process with a new session
> > id, update _su calls to use the same session as the parent test, update
> > all the pkill sites to use a wrapper so that we only target processes
> > created by *this* instance of fstests, and update SIGINT to SIGPIPE.
> > 
> > Cc: <fstests@vger.kernel.org> # v2024.12.08
> > Fixes: 8973af00ec212f ("fstests: cleanup fsstress process management")
> > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > Reviewed-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  check            |   40 ++++++++++++++++++++++++++++++++++------
> >  common/fuzzy     |    6 +++---
> >  common/rc        |    6 ++++--
> >  tools/run_setsid |   22 ++++++++++++++++++++++
> 
> The tools/ directory never be installed into /var/lib/xfstests. If someone runs
> xfstests after `make install`, all tests will be failed due to:
> 
>   Failed to find executable ./tools/run_setsid: No such file or directory

Urrrk, yeah, I didn't realize that tools/ doesn't have a Makefile,
therefore nothing from there get installed.  Three options:

1) Add a tools/Makefile and an install target
2) Update the top level Makefile's install target to install the two
   scripts
3) Move tools/run_* to the top level and (2)

Thoughts?

--D

> Thanks,
> Zorro
> 
> >  4 files changed, 63 insertions(+), 11 deletions(-)
> >  create mode 100755 tools/run_setsid
> > 
> > 
> > diff --git a/check b/check
> > index 5cb4e7eb71ce07..fb9b514e5cb1eb 100755
> > --- a/check
> > +++ b/check
> > @@ -698,18 +698,46 @@ _adjust_oom_score -500
> >  # systemd doesn't automatically remove transient scopes that fail to terminate
> >  # when systemd tells them to terminate (e.g. programs stuck in D state when
> >  # systemd sends SIGKILL), so we use reset-failed to tear down the scope.
> > +#
> > +# Use setsid to run the test program with a separate session id so that we
> > +# can pkill only the processes started by this test.
> >  _run_seq() {
> > -	local cmd=(bash -c "test -w ${OOM_SCORE_ADJ} && echo 250 > ${OOM_SCORE_ADJ}; exec ./$seq")
> > +	local res
> > +	unset CHILDPID
> > +	unset FSTESTS_ISOL	# set by tools/run_seq_*
> >  
> >  	if [ -n "${HAVE_SYSTEMD_SCOPES}" ]; then
> >  		local unit="$(systemd-escape "fs$seq").scope"
> >  		systemctl reset-failed "${unit}" &> /dev/null
> > -		systemd-run --quiet --unit "${unit}" --scope "${cmd[@]}"
> > +		systemd-run --quiet --unit "${unit}" --scope \
> > +			./tools/run_setsid "./$seq" &
> > +		CHILDPID=$!
> > +		wait
> >  		res=$?
> > +		unset CHILDPID
> >  		systemctl stop "${unit}" &> /dev/null
> > -		return "${res}"
> >  	else
> > -		"${cmd[@]}"
> > +		# bash won't run the SIGINT trap handler while there are
> > +		# foreground children in a separate session, so we must run
> > +		# the test in the background and wait for it.
> > +		./tools/run_setsid "./$seq" &
> > +		CHILDPID=$!
> > +		wait
> > +		res=$?
> > +		unset CHILDPID
> > +	fi
> > +
> > +	return $res
> > +}
> > +
> > +_kill_seq() {
> > +	if [ -n "$CHILDPID" ]; then
> > +		# SIGPIPE will kill all the children (including fsstress)
> > +		# without bash logging fatal signal termination messages to the
> > +		# console
> > +		pkill -PIPE --session "$CHILDPID"
> > +		wait
> > +		unset CHILDPID
> >  	fi
> >  }
> >  
> > @@ -718,9 +746,9 @@ _prepare_test_list
> >  fstests_start_time="$(date +"%F %T")"
> >  
> >  if $OPTIONS_HAVE_SECTIONS; then
> > -	trap "_summary; exit \$status" 0 1 2 3 15
> > +	trap "_kill_seq; _summary; exit \$status" 0 1 2 3 15
> >  else
> > -	trap "_wrapup; exit \$status" 0 1 2 3 15
> > +	trap "_kill_seq; _wrapup; exit \$status" 0 1 2 3 15
> >  fi
> >  
> >  function run_section()
> > diff --git a/common/fuzzy b/common/fuzzy
> > index 95b4344021a735..6d390d4efbd3da 100644
> > --- a/common/fuzzy
> > +++ b/common/fuzzy
> > @@ -1175,9 +1175,9 @@ _scratch_xfs_stress_scrub_cleanup() {
> >  
> >  	echo "Killing stressor processes at $(date)" >> $seqres.full
> >  	_kill_fsstress
> > -	_pkill -PIPE --parent $$ xfs_io >> $seqres.full 2>&1
> > -	_pkill -PIPE --parent $$ fsx >> $seqres.full 2>&1
> > -	_pkill -PIPE --parent $$ xfs_scrub >> $seqres.full 2>&1
> > +	_pkill --echo -PIPE xfs_io >> $seqres.full 2>&1
> > +	_pkill --echo -PIPE fsx >> $seqres.full 2>&1
> > +	_pkill --echo -PIPE xfs_scrub >> $seqres.full 2>&1
> >  
> >  	# Tests are not allowed to exit with the scratch fs frozen.  If we
> >  	# started a fs freeze/thaw background loop, wait for that loop to exit
> > diff --git a/common/rc b/common/rc
> > index 54e11dc0f843fd..3f981900e89081 100644
> > --- a/common/rc
> > +++ b/common/rc
> > @@ -33,7 +33,7 @@ _test_sync()
> >  # Kill only the processes started by this test.
> >  _pkill()
> >  {
> > -	pkill "$@"
> > +	pkill --session 0 "$@"
> >  }
> >  
> >  # Common execution handling for fsstress invocation.
> > @@ -2732,9 +2732,11 @@ _require_user_exists()
> >  	[ "$?" == "0" ] || _notrun "$user user not defined."
> >  }
> >  
> > +# Run all non-root processes in the same session as the root.  Believe it or
> > +# not, passing $SHELL in this manner works both for "su" and "su -c cmd".
> >  _su()
> >  {
> > -	su "$@"
> > +	su --session-command $SHELL "$@"
> >  }
> >  
> >  # check if a user exists and is able to execute commands.
> > diff --git a/tools/run_setsid b/tools/run_setsid
> > new file mode 100755
> > index 00000000000000..5938f80e689255
> > --- /dev/null
> > +++ b/tools/run_setsid
> > @@ -0,0 +1,22 @@
> > +#!/bin/bash
> > +
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2025 Oracle.  All Rights Reserved.
> > +#
> > +# Try starting things in a new process session so that test processes have
> > +# something with which to filter only their own subprocesses.
> > +
> > +if [ -n "${FSTESTS_ISOL}" ]; then
> > +	# Allow the test to become a target of the oom killer
> > +	oom_knob="/proc/self/oom_score_adj"
> > +	test -w "${oom_knob}" && echo 250 > "${oom_knob}"
> > +
> > +	exec "$@"
> > +fi
> > +
> > +if [ -z "$1" ] || [ "$1" = "--help" ]; then
> > +	echo "Usage: $0 command [args...]"
> > +	exit 1
> > +fi
> > +
> > +FSTESTS_ISOL=setsid exec setsid "$0" "$@"
> > 
> 
