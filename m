Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32B9B7083A;
	Wed,  5 Feb 2025 18:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738778449; cv=none; b=spOncYI9k7/+OARxcKly8JmYCLUXYUSr4wOjToJ6KC6+FddolPD2wAjsVVpPWE8tWuhKR0s4evzd4SFUsbOWDVXvRX3H/RxSotBNKgd5BrFyG7ix1LXfmKstwppS5Qke8PkD4e3NfHTHfSaWRb+Y7j78sQiNtQHfz2vQoLTqnRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738778449; c=relaxed/simple;
	bh=V/oniRhm2p2wfxSYl3mIZQdp/ONJqeRlDPXoG9rvOR4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rybuXM0M0xKrfyRNcYE2+PJys6+n4QuTjoC5rkytnObofg1M4yApGF1FrS4orVJ5PyHW09+9HAcelJSJWAglpFG81aWNZFi/N5R8GfqOE56yPxrjhQPegnNy/ddd2s4FVjsO4aQxccd5W8zmlNFzyYJdB7OG08daYMJecY3tVIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r+RLq/ps; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r+RLq/ps"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93147C4CED1;
	Wed,  5 Feb 2025 18:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738778448;
	bh=V/oniRhm2p2wfxSYl3mIZQdp/ONJqeRlDPXoG9rvOR4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=r+RLq/psZJYFFCRHReSK0T8gkXPcQhhhxcKOycYsJ3bBKuRCesxugTH+R8PV7c9TC
	 wj97gcF+aQqFw4LZI4hQ5/5b2wKDUaYdE900Nu4hEUh1Gufb+beAZ7Lk3nDaRor1TO
	 llXWz80L4mNL+o0X8jq/z8hSlCV6vFCDXsihlf3p+fhEZm3SfKw7T3tjuXFflCwgP7
	 dAKwgImJNB0HeZ/jbmC8SYAyMDbIbnwmSHwDbQ1Hv7R0xuMXUniOOb299hRbGFJEar
	 NaqELmnk7cUwGKZzXYy6FBek183VjtJStH7migcy1kencyg6by3wov3cYei4mS9ath
	 0njuGnJl6KR5w==
Date: Wed, 5 Feb 2025 10:00:48 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/34] check: run tests in a private pid/mount namespace
Message-ID: <20250205180048.GH21799@frogsfrogsfrogs>
References: <173870406063.546134.14070590745847431026.stgit@frogsfrogsfrogs>
 <173870406337.546134.5825194290554919668.stgit@frogsfrogsfrogs>
 <Z6KyrG6jatCgmUiD@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z6KyrG6jatCgmUiD@dread.disaster.area>

On Wed, Feb 05, 2025 at 11:37:00AM +1100, Dave Chinner wrote:
> On Tue, Feb 04, 2025 at 01:26:13PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > As mentioned in the previous patch, trying to isolate processes from
> > separate test instances through the use of distinct Unix process
> > sessions is annoying due to the many complications with signal handling.
> > 
> > Instead, we could just use nsexec to run the test program with a private
> > pid namespace so that each test instance can only see its own processes;
> > and private mount namespace so that tests writing to /tmp cannot clobber
> > other tests or the stuff running on the main system.
> > 
> > However, it's not guaranteed that a particular kernel has pid and mount
> > namespaces enabled.  Mount (2.4.19) and pid (2.6.24) namespaces have
> > been around for a long time, but there's no hard requirement for the
> > latter to be enabled in the kernel.  Therefore, this bugfix slips
> > namespace support in alongside the session id thing.
> > 
> > Declaring CONFIG_PID_NS=n a deprecated configuration and removing
> > support should be a separate conversation, not something that I have to
> > do in a bug fix to get mainline QA back up.
> > 
> > Cc: <fstests@vger.kernel.org> # v2024.12.08
> > Fixes: 8973af00ec212f ("fstests: cleanup fsstress process management")
> > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > ---
> >  check               |   34 +++++++++++++++++++++++-----------
> >  common/rc           |   12 ++++++++++--
> >  src/nsexec.c        |   18 +++++++++++++++---
> >  tests/generic/504   |   15 +++++++++++++--
> >  tools/run_seq_pidns |   28 ++++++++++++++++++++++++++++
> >  5 files changed, 89 insertions(+), 18 deletions(-)
> >  create mode 100755 tools/run_seq_pidns
> 
> Same question as for session ids - is this all really necessary (or
> desired) if check-parallel executes check in it's own private PID
> namespace?
> 
> If so, then the code is fine apart from the same nit about
> tools/run_seq_pidns - call it run_pidns because this helper will
> also be used by check-parallel to run check in it's own private
> mount and PID namespaces...

I prefer to name it tools/run_privatens since it creates more than just
a pid namespace.  At some point we might even decide to privatize more
namespaces (e.g. do we want a private network namespace for nfs?) and I
don't want this to become lsfmmbpfbbq'd, as it were.

> > diff --git a/tests/generic/504 b/tests/generic/504
> > index 271c040e7b842a..96f18a0bbc7ba2 100755
> > --- a/tests/generic/504
> > +++ b/tests/generic/504
> > @@ -18,7 +18,7 @@ _cleanup()
> >  {
> >  	exec {test_fd}<&-
> >  	cd /
> > -	rm -f $tmp.*
> > +	rm -r -f $tmp.*
> >  }
> >  
> >  # Import common functions.
> > @@ -35,13 +35,24 @@ echo inode $tf_inode >> $seqres.full
> >  
> >  # Create new fd by exec
> >  exec {test_fd}> $testfile
> > -# flock locks the fd then exits, we should see the lock info even the owner is dead
> > +# flock locks the fd then exits, we should see the lock info even the owner is
> > +# dead.  If we're using pid namespace isolation we have to move /proc so that
> > +# we can access the /proc/locks from the init_pid_ns.
> > +if [ "$FSTESTS_ISOL" = "privatens" ]; then
> > +	move_proc="$tmp.procdir"
> > +	mkdir -p "$move_proc"
> > +	mount --move /proc "$move_proc"
> > +fi
> >  flock -x $test_fd
> >  cat /proc/locks >> $seqres.full
> >  
> >  # Checking
> >  grep -q ":$tf_inode " /proc/locks || echo "lock info not found"
> >  
> > +if [ -n "$move_proc" ]; then
> > +	mount --move "$move_proc" /proc
> > +fi
> > +
> >  # success, all done
> >  status=0
> >  echo "Silence is golden"
> 
> Urk. That explains the failure I've noticed but not had time to
> debug from check-parallel when using a private pidns. Do you know
> why /proc/locks in the overlaid mount does not show the locks taken
> from within that namespace? Is that a bug in the namespace/lock
> code?

I /think/ this happens because the code in fs/locks.c records the pid of
"flock -x $test_fd" as the owner of the lock.  But then flock exits, so
that pid is no longer recorded in the pid_namespace and this code in
locks_translate_pid:

	pid = find_pid_ns(fl->flc_pid, &init_pid_ns);
	vnr = pid_nr_ns(pid, ns);

returns with vnr == 0, which causes locks_show to skip the lock.
However, the underlying /proc is associated with init_pid_ns, so
locks_translate_pid always returns a nonzero pid.  Unfortunately, that
means we can't have tools/run_privatens unmount the /proc it inherits
before mounting the pidns-specific /proc.

I'll note this in the commit message.

> Regardless, the code looks ok so with the helper renamed:
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Thanks!

--D

> -- 
> Dave Chinner
> david@fromorbit.com
> 
