Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F04FB136A;
	Wed, 22 Jan 2025 04:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737519842; cv=none; b=PqSZfxQKL371bphfsh/N2+UjJt7VsYwPn5fmyEBvnFEBT7qmupgKevRJaSxfEB3mDLpBbFDVvCtwGkdBqRT0pglEzcqGvIkOXpi8BoZ+OV9ahiqrvQk115T5KQT6q9ym/VLLHfmXMaNa15S+eLr2m7XXRD7xQeH5F2uSuH8CSKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737519842; c=relaxed/simple;
	bh=t5v6Z2qhCeDGMkeK3zrJ3NJZo+M1DbUXCv+dFyzVg4U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c9jpm0JVIZhbEL6pkEyvqPiC+B1NVJicnet0TwPFWZV0Q6BiYh1oRltOXQwJrW3lHySoNKrNLiZB8umySW+nzymGYzlUhE9Jjy74LmEVz97C6y6yI2IQJ83If1vuu0CXRNc0ypHsF6zZ7Y7GRgofDu5XIs3+kbHr/p1zxqmq5v0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SgX9F7F1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SgX9F7F1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BD14C4CED6;
	Wed, 22 Jan 2025 04:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737519841;
	bh=t5v6Z2qhCeDGMkeK3zrJ3NJZo+M1DbUXCv+dFyzVg4U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SgX9F7F1ACIWKIyJEkJqQJiTz46V6t1cZHGm4bY00LU3ks3hdd2XM/hhMzttQdtk0
	 mnAd4durWIAk0tPIu8WU3xn1YwF7tOWUwh1mFJehPqx44WnmoNwgNOAs0J+EYxP3a/
	 MWsN9YpbEs8NhytQewT4S0IjaflKz9HP43svgvv6k1Pfl65mLuBpegy2HaN8aMPx5s
	 7zZ06jPqXbwrcPapBm6aUMkskL+Nkochh8FgcPzasEJsilqp3vPTQtNqQjFyVYs44N
	 Y5NXGnb0tu2i2cR68oSckXev23KhxjwXCx0mD7MbL9zJtxWPd/sWTxJV/R+5X24TJs
	 ukSsbZiGu7u0A==
Date: Tue, 21 Jan 2025 20:24:00 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: zlang@redhat.com, hch@lst.de, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/23] common: fix pkill by running test program in a
 separate session
Message-ID: <20250122042400.GX1611770@frogsfrogsfrogs>
References: <173706974044.1927324.7824600141282028094.stgit@frogsfrogsfrogs>
 <173706974197.1927324.9208284704325894988.stgit@frogsfrogsfrogs>
 <Z48UWiVlRmaBe3cY@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z48UWiVlRmaBe3cY@dread.disaster.area>

On Tue, Jan 21, 2025 at 02:28:26PM +1100, Dave Chinner wrote:
> On Thu, Jan 16, 2025 at 03:27:15PM -0800, Darrick J. Wong wrote:
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
> 
> Yeah, 'pkill --parent' was the best I had managed to come up that
> mostly worked, not because it perfect. That was something I wanted
> feedback on before merge because it still had problems...
> 
> > This is necessary to fix SOAK_DURATION runtime constraints for all the
> > scrub stress tests.  However, there is a cost -- the test program no
> > longer runs with the same controlling tty as ./check, which means that
> > ^Z doesn't work and SIGINT/SIGQUIT are set to SIG_IGN.  IOWs, if a test
> > wants to kill its subprocesses, it must use another signal such as
> > SIGPIPE.  Fortunately, bash doesn't whine about children dying due to
> > fatal signals if the children run in a different session id.
> > 
> > I also explored alternate designs, and this was the least unsatisfying:
> > 
> > a) Setting the process group didn't work because background subshells
> > are assigned a new group id.
> 
> Yup, tried that.
> 
> > b) Constraining the pkill/pgrep search to a cgroup could work, but we'd
> > have to set up a cgroup in which to run the fstest.
> 
> thought about that, too, and considered if systemd scopes could do
> that, but ...
> 
> > 
> > c) Putting test subprocesses in a systemd sub-scope and telling systemd
> > to kill the sub-scope could work because ./check can already use it to
> > ensure that all child processes of a test are killed.  However, this is
> > an *optional* feature, which means that we'd have to require systemd.
> 
> ... requiring systemd was somewhat of a show-stopper for testing
> older distros.

Isn't RHEL7 the oldest one at this point?  And it does systemd.  At this
point the only reason I didn't go full systemd is out of consideration
for Devuan, since they probably need QA.

> > d) Constraining the pkill/pgrep search to a particular mount namespace
> > could work, but we already have tests that set up their own mount
> > namespaces, which means the constrained pgrep will not find all child
> > processes of a test.
> 
> *nod*.
> 
> > e) Constraining to any other type of namespace (uts, pid, etc) might not
> > work because those namespaces might not be enabled.
> 
> *nod*
> 
> I also tried modifying fsstress to catch and propagate signals and a
> couple of other ways of managing processes in the stress code, but
> all ended up having significantly worse downsides than using 'pkill
> --parent'.

Yeah, and then you'd still have to figure out fsx and any other random
little utility that a test might run in a background.

> I was aware of session IDs, but I've never used them before and
> hadn't gone down the rabbit hole of working out how to use them when
> I posted the initial RFC patchset.

<nod> Session IDs kinda suck, but they suck the least for nearly minimal
extra effort.

> > f) Revert check-parallel and go back to one fstests instance per system.
> > Zorro already chose not to revert.
> > 
> > So.  Change _run_seq to create a the ./$seq process with a new session
> > id, update _su calls to use the same session as the parent test, update
> > all the pkill sites to use a wrapper so that we only target processes
> > created by *this* instance of fstests, and update SIGINT to SIGPIPE.
> 
> Yeah, that's definitely cleaner.
> 
> .....
> 
> > @@ -1173,13 +1173,11 @@ _scratch_xfs_stress_scrub_cleanup() {
> >  	rm -f "$runningfile"
> >  	echo "Cleaning up scrub stress run at $(date)" >> $seqres.full
> >  
> > -	# Send SIGINT so that bash won't print a 'Terminated' message that
> > -	# distorts the golden output.
> >  	echo "Killing stressor processes at $(date)" >> $seqres.full
> > -	_kill_fsstress
> > -	pkill -INT --parent $$ xfs_io >> $seqres.full 2>&1
> > -	pkill -INT --parent $$ fsx >> $seqres.full 2>&1
> > -	pkill -INT --parent $$ xfs_scrub >> $seqres.full 2>&1
> > +	_pkill --echo -PIPE fsstress >> $seqres.full 2>&1
> > +	_pkill --echo -PIPE xfs_io >> $seqres.full 2>&1
> > +	_pkill --echo -PIPE fsx >> $seqres.full 2>&1
> > +	_pkill --echo -PIPE xfs_scrub >> $seqres.full 2>&1
> 
> Removing _kill_fsstress is wrong - the fsstress process has already
> been renamed, so open coding 'pkill fsstress' may not match. The
> _kill_fsstress() code gets changed to do the right thing here:
> 
> > @@ -69,7 +75,7 @@ _kill_fsstress()
> >  	if [ -n "$_FSSTRESS_PID" ]; then
> >  		# use SIGPIPE to avoid "Killed" messages from bash
> >  		echo "killing $_FSSTRESS_BIN" >> $seqres.full
> > -		pkill -PIPE $_FSSTRESS_BIN >> $seqres.full 2>&1
> > +		_pkill -PIPE $_FSSTRESS_BIN >> $seqres.full 2>&1
> >  		_wait_for_fsstress
> >  		return $?
> >  	fi
> 
> Then in the next patch when the _FSSTRESS_BIN workaround goes away,
> _kill_fsstress() is exactly what you open coded in
> _scratch_xfs_stress_scrub_cleanup()....
> 
> i.e. common/fuzzy really shouldn't open code the fsstress process
> management - it should use the wrapper like everything else does.

Ok will change.  I suppose I did go fix up the setting (or not) of
_FSSTRESS_PID.

> Everything else in the patch looks good.

Cool!

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
