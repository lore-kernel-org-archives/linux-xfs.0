Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A55B31BBBFE;
	Wed, 22 Jan 2025 21:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737582370; cv=none; b=exFyen7g1HjNSspMF+eolMhA2J2i5bvhBK9OKRHGywUmvWOUaUrt+6L6CgPIcfv+nnUdFR7TPddmy6vdHjlMa+wydnMF75Vrs8q1Vplgbz68F+9EK6GIiSrUhuZKnU/wqmryrJUEG83p5EPX6dxL9NecSnDnvR6C+OcRfObTEak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737582370; c=relaxed/simple;
	bh=ZELNs9k5syqH8wlnJ+5ZaWzBHBqqnApJ8kWTQMAJTgo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DaRJ6IM7tQ+Tu/fkZM8qx4DwxLXHzjmDgib/owBOuzOzx8UPTNb0Joz9jblQz6yF0olBUZcEcF01WFqrj4PBP/h1hZIZnf9DFEAG1cOIXaNMtg4Ckc05wps6KciUKDTtjQPiOtn30gsJcZJv8w5SOwNe8nYHsdLJbs6Bb/vHiUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hDHfbi8e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hDHfbi8e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 193EAC4CED2;
	Wed, 22 Jan 2025 21:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737582370;
	bh=ZELNs9k5syqH8wlnJ+5ZaWzBHBqqnApJ8kWTQMAJTgo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hDHfbi8ee2EPdPd3GiQwYahxvSLRe3A2yroMbdATLcLWQJmMF2a0C891CMeQLiFMo
	 gc4xlvoP9F3/ub1Aj+n1PdAWDDxLwSyxxUskDuAxkMD/vFc/d7wHEEUxmgCVpzYMZG
	 /yuAHIVkZEdESEXc6u43CcKIi+1687z3HSkUMf5pcsK6K5Ji7oCk9bJrPfw8FhakEu
	 Xk6GWtwqTk1B1sUKFpqfQLob0Cf/VqmENPM/lz9NFBehjzQVagbqE9NQBAYG5O9uEE
	 3/LLMjXxfNJbcwyKaM4xBJRSDFnHAHKJoT59eqL3enP/iDxDs6vu8MJw7lJWJj+1NH
	 x/5QNST8eYGpQ==
Date: Wed, 22 Jan 2025 13:46:09 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: zlang@redhat.com, hch@lst.de, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/23] common: fix pkill by running test program in a
 separate session
Message-ID: <20250122214609.GE1611770@frogsfrogsfrogs>
References: <173706974044.1927324.7824600141282028094.stgit@frogsfrogsfrogs>
 <173706974197.1927324.9208284704325894988.stgit@frogsfrogsfrogs>
 <Z48UWiVlRmaBe3cY@dread.disaster.area>
 <20250122042400.GX1611770@frogsfrogsfrogs>
 <Z5CLUbj4qbXCBGAD@dread.disaster.area>
 <20250122070520.GD1611770@frogsfrogsfrogs>
 <Z5C9mf2yCgmZhAXi@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z5C9mf2yCgmZhAXi@dread.disaster.area>

On Wed, Jan 22, 2025 at 08:42:49PM +1100, Dave Chinner wrote:
> On Tue, Jan 21, 2025 at 11:05:20PM -0800, Darrick J. Wong wrote:
> > On Wed, Jan 22, 2025 at 05:08:17PM +1100, Dave Chinner wrote:
> > > On Tue, Jan 21, 2025 at 08:24:00PM -0800, Darrick J. Wong wrote:
> > > > On Tue, Jan 21, 2025 at 02:28:26PM +1100, Dave Chinner wrote:
> > > > > On Thu, Jan 16, 2025 at 03:27:15PM -0800, Darrick J. Wong wrote:
> > > > > > c) Putting test subprocesses in a systemd sub-scope and telling systemd
> > > > > > to kill the sub-scope could work because ./check can already use it to
> > > > > > ensure that all child processes of a test are killed.  However, this is
> > > > > > an *optional* feature, which means that we'd have to require systemd.
> > > > > 
> > > > > ... requiring systemd was somewhat of a show-stopper for testing
> > > > > older distros.
> > > > 
> > > > Isn't RHEL7 the oldest one at this point?  And it does systemd.  At this
> > > > point the only reason I didn't go full systemd is out of consideration
> > > > for Devuan, since they probably need QA.
> > > 
> > > I have no idea what is out there in distro land vs what fstests
> > > "supports". All I know is that there are distros out there that
> > > don't use systemd.
> > > 
> > > It feels like poor form to prevent generic filesystem QA
> > > infrastructure from running on those distros by making an avoidable
> > > choice to tie the infrastructure exclusively to systemd-based
> > > functionality....
> > 
> > Agreed, though at some point after these bugfixes are merged I'll see if
> > I can build on the existing "if you have systemd then ___ else here's
> > your shabby opencoded version" logic in fstests to isolate the ./checks
> > from each other a little better.  It'd be kinda nice if we could
> > actually just put them in something resembling a modernish container,
> > albeit with the same underlying fs.
> 
> Agreed, but I don't think we need to depend on systemd for that,
> either.
> 
> > <shrug> Anyone else interested in that?
> 
> check-parallel has already started down that road with the
> mount namespace isolation it uses for the runner tasks via
> src/nsexec.c.
> 
> My plan has been to factor more of the check test running code
> (similar to what I did with the test list parsing) so that the
> check-parallel can iterate sections itself and runners can execute
> individual tests directly, rather than bouncing them through check
> to execute a set of tests serially. Then check-parallel could do
> whatever it needed to isolate individual tests from each other and
> nothing in check would need to change.
> 
> Now I'm wondering if I can just run each runner's check instance
> in it's own private PID namespace as easily as I'm running them in
> their own private mount namespace...
> 
> Hmmm - looks like src/nsexec.c can create new PID namespaces via
> the "-p" option. I haven't used that before - I wonder if that's a
> better solution that using per-test session IDs to solve the pkill
> --parent problem? Something to look into in the morning....

I tried that -- it appears to work, but then:

# ./src/nsexec -p bash
Current time: Wed Jan 22 13:43:33 PST 2025; Terminal: /dev/pts/0
# ps
fatal library error, lookup self
# 

Regular processes and pkill/pgrep seem to work, but that didn't seem
especially encouraging so I stopped. :/

--D

> -Dave.
> 
> -- 
> Dave Chinner
> david@fromorbit.com
> 
