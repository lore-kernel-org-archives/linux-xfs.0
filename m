Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A884214A73;
	Wed,  5 Feb 2025 21:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738790726; cv=none; b=Ko1BWMQPy02S1bMBbnpTNqNjn1wBfjMibq9LsiVSirqpdr6+9gxo9xl0qtQo/KrYM0+omeUUa7hiqKD76Pxr3yVrVDTI6AGMTZ9mkAs/hwe1+eq/xwWcHEiBCAnKY/38bPewofp+mCdQ8ALIcD4Gyj5vw8SjGQ/z7sjNiJru4hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738790726; c=relaxed/simple;
	bh=qOciB2zAmW+iGaWGu4e8oadw0Z9OC7vLuQRbgu6E/r8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=twTLoE/8MSBsOSxBJiMkxdYOrli8AwVoWICqjunXfRxddIrfoksyP5YGun87YYKWcn47qDlrj39as35j2IlgqpAVMQPw5CiRsDY4Rgfh1kfyOadYGrU2aP16UEwfmKgcRUINb4v7JX6QADpDUFlZMyoR5pyazumfoRIwHCxncg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vQ7v3wyG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vQ7v3wyG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAEC8C4CED1;
	Wed,  5 Feb 2025 21:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738790725;
	bh=qOciB2zAmW+iGaWGu4e8oadw0Z9OC7vLuQRbgu6E/r8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vQ7v3wyGcx/Rqv+Z2YEC16jTz+zW+rdbCCU5k6vju8cTGdap6ImY/On//jQGqg3n+
	 tpOVgkRneAyCT+OUerruzsPv6yj/J1VQJ63VEDATRHaMuJKv9ZeGtflRNJx01UX8+L
	 tjQctOHCYOZvUefvPWQ5X2Kk2VMfoSZomgERROmvXYiYCCkyS/XXy3zmkveIDNvBWe
	 oNK9ts6wp/7TqkTXdLgI+AeP6ThMnfra3UMpgHRkBFrehVv2tH/wd9wIl5zjztvJzY
	 cGej21R5Eir7TFMM8wkZ1aP+c8SY4bLGpNFoLaTEFZkwp3pcW8A3zi+5MDW4aSCekR
	 M98qLU1lo6qIg==
Date: Wed, 5 Feb 2025 13:25:25 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/34] check: run tests in a private pid/mount namespace
Message-ID: <20250205212525.GD21808@frogsfrogsfrogs>
References: <173870406063.546134.14070590745847431026.stgit@frogsfrogsfrogs>
 <173870406337.546134.5825194290554919668.stgit@frogsfrogsfrogs>
 <Z6KyrG6jatCgmUiD@dread.disaster.area>
 <20250205180048.GH21799@frogsfrogsfrogs>
 <20250205181959.GL21799@frogsfrogsfrogs>
 <Z6PU11K25tADRy4i@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z6PU11K25tADRy4i@dread.disaster.area>

On Thu, Feb 06, 2025 at 08:15:03AM +1100, Dave Chinner wrote:
> On Wed, Feb 05, 2025 at 10:19:59AM -0800, Darrick J. Wong wrote:
> > On Wed, Feb 05, 2025 at 10:00:48AM -0800, Darrick J. Wong wrote:
> > > On Wed, Feb 05, 2025 at 11:37:00AM +1100, Dave Chinner wrote:
> > > > On Tue, Feb 04, 2025 at 01:26:13PM -0800, Darrick J. Wong wrote:
> > > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > > 
> > > > > As mentioned in the previous patch, trying to isolate processes from
> > > > > separate test instances through the use of distinct Unix process
> > > > > sessions is annoying due to the many complications with signal handling.
> > > > > 
> > > > > Instead, we could just use nsexec to run the test program with a private
> > > > > pid namespace so that each test instance can only see its own processes;
> > > > > and private mount namespace so that tests writing to /tmp cannot clobber
> > > > > other tests or the stuff running on the main system.
> > > > > 
> > > > > However, it's not guaranteed that a particular kernel has pid and mount
> > > > > namespaces enabled.  Mount (2.4.19) and pid (2.6.24) namespaces have
> > > > > been around for a long time, but there's no hard requirement for the
> > > > > latter to be enabled in the kernel.  Therefore, this bugfix slips
> > > > > namespace support in alongside the session id thing.
> > > > > 
> > > > > Declaring CONFIG_PID_NS=n a deprecated configuration and removing
> > > > > support should be a separate conversation, not something that I have to
> > > > > do in a bug fix to get mainline QA back up.
> > > > > 
> > > > > Cc: <fstests@vger.kernel.org> # v2024.12.08
> > > > > Fixes: 8973af00ec212f ("fstests: cleanup fsstress process management")
> > > > > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > > > > ---
> > > > >  check               |   34 +++++++++++++++++++++++-----------
> > > > >  common/rc           |   12 ++++++++++--
> > > > >  src/nsexec.c        |   18 +++++++++++++++---
> > > > >  tests/generic/504   |   15 +++++++++++++--
> > > > >  tools/run_seq_pidns |   28 ++++++++++++++++++++++++++++
> > > > >  5 files changed, 89 insertions(+), 18 deletions(-)
> > > > >  create mode 100755 tools/run_seq_pidns
> > > > 
> > > > Same question as for session ids - is this all really necessary (or
> > > > desired) if check-parallel executes check in it's own private PID
> > > > namespace?
> > 
> > Forgot to respond to this question --
> > 
> > Because check-parallel runs (will run?) each child ./check instance in a
> > private namepsace, each of those instances will be isolated from the
> > others.  So no, it's probably not absolutely necessary.
> > 
> > However, there are a couple of reasons to let it happen: (a) the private
> > ns that ./check creates in _run_seq() isolates the actual test code from
> > its parent ./check process; and (b) the process started by nsexec is
> > considered to be the "init" process for that namespace, so when it dies,
> > the kernel will kill -9 all other processes in that namespace, so we
> > won't have any stray fsstress processes that bleed into the next test.
> 
> Ok - that might be worth adding to the commit message so that anyone
> looking at it in a few months time doesn't need to remember this
> detail.

It /does/ say that in _run_seq() but yeah I'll add it to the commit
message too:

"Instead, we could just use nsexec to run the test program with a
private pid namespace so that each test instance can only see its own
processes; and private mount namespace so that tests writing to /tmp
cannot clobber other tests or the stuff running on the main system.
Further, the process created by the clone(CLONE_NEWPID) call is
considered the init process of that pid namespace, so all processes will
be SIGKILL'd when the init process terminates, so we no longer need
systemd scopes for externally enforced cleanup."

--D

> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
