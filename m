Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 537091799F;
	Wed, 29 Jan 2025 07:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738135988; cv=none; b=pdW1hLBwEc6PEkEiagymugKv66SITmhZsLnvag0VXMzvEO3J7tsYodRdFRlp+23zzO5DuChMycFfWRf0AUMtt+NUFjAYQ8JmvYVwH+gpAHpHLhrodUhr/zAckFFo0nOsjKEYSneedmc/M2/uqJ09bceDtITu168Zk7kVvT601tE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738135988; c=relaxed/simple;
	bh=gHpsI1HgM0Vo7QX7HXT3s6pfG5nGsssvXys/v1vTSXY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tHqLbYlTPfuxH3sEzDigjPU+zdWzBIV70d+JeKvHCaue+mKMt+dSLhsRM7Vmeqq3JK9908l0svgTx36htSTT/zNYPPvYxJoNRyfHl/hfQ8ZccUOuNEZG64DuHTHMrU5ud+vX9oHvruGjzpXhZHO19fIXVfHMO3+lg8BepEI7gwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dcrpng5r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dcrpng5r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD60AC4CEE6;
	Wed, 29 Jan 2025 07:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738135987;
	bh=gHpsI1HgM0Vo7QX7HXT3s6pfG5nGsssvXys/v1vTSXY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dcrpng5rdb4++90u4NEfdg0eLVbkHXfRcGBmL1LHeVxH3g4gQ6G5yur/WdgdY4qkM
	 sMvHcwOrKhImlx0oDYBBxVP7z10CtLHxqwFhOwsh5BNAaK/YtOcQEtRYUC4bMDo2Kr
	 cFXOnXpAP1r776ez/YqDqZG9VbxPvbh6N9H0RRYS7G1+l7ErGUza1XPiuzyBcGxsri
	 Q4931B8WGfzfS+C0c/Qk97JX1z8YbiiUZx546qSo61yJkgfthp6zN3wO2zU0CluXB7
	 vypDWuzIISeh/+4/KD7WleYYPhOOB4yHy5UFJ1xT1ro8RZia/ycn7Ng8FQrn+KA8QS
	 QGp7AvYvQ3DNw==
Date: Tue, 28 Jan 2025 23:33:07 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: zlang@redhat.com, hch@lst.de, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/23] common: fix pkill by running test program in a
 separate session
Message-ID: <20250129073307.GS3557553@frogsfrogsfrogs>
References: <Z5CLUbj4qbXCBGAD@dread.disaster.area>
 <20250122070520.GD1611770@frogsfrogsfrogs>
 <Z5C9mf2yCgmZhAXi@dread.disaster.area>
 <20250122214609.GE1611770@frogsfrogsfrogs>
 <Z5GYgjYL_9LecSb9@dread.disaster.area>
 <Z5heaj-ZsL_rBF--@dread.disaster.area>
 <20250128072352.GP3557553@frogsfrogsfrogs>
 <Z5lAek54UK8mdFs-@dread.disaster.area>
 <20250129031313.GV3557695@frogsfrogsfrogs>
 <Z5nFfCD8Km_A3AnA@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z5nFfCD8Km_A3AnA@dread.disaster.area>

On Wed, Jan 29, 2025 at 05:06:52PM +1100, Dave Chinner wrote:
> On Tue, Jan 28, 2025 at 07:13:13PM -0800, Darrick J. Wong wrote:
> > On Wed, Jan 29, 2025 at 07:39:22AM +1100, Dave Chinner wrote:
> > > On Mon, Jan 27, 2025 at 11:23:52PM -0800, Darrick J. Wong wrote:
> > > > On Tue, Jan 28, 2025 at 03:34:50PM +1100, Dave Chinner wrote:
> > > > > On Thu, Jan 23, 2025 at 12:16:50PM +1100, Dave Chinner wrote:
> > > > > 4. /tmp is still shared across all runner instances so all the
> > > > > 
> > > > >    concurrent runners dump all their tmp files in /tmp. However, the
> > > > >    runners no longer have unique PIDs (i.e. check runs as PID 3 in
> > > > >    all runner instaces). This means using /tmp/tmp.$$ as the
> > > > >    check/test temp file definition results is instant tmp file name
> > > > >    collisions and random things in check and tests fail.  check and
> > > > >    common/preamble have to be converted to use `mktemp` to provide
> > > > >    unique tempfile name prefixes again.
> > > > > 
> > > > > 5. Don't forget to revert the parent /proc mount back to shared
> > > > >    after check has finished running (or was aborted).
> > > > > 
> > > > > I think with this (current prototype patch below), we can use PID
> > > > > namespaces rather than process session IDs for check-parallel safe
> > > > > process management.
> > > > > 
> > > > > Thoughts?
> > > > 
> > > > Was about to go to bed, but can we also start a new mount namespace,
> > > > create a private (or at least non-global) /tmp to put files into, and
> > > > then each test instance is isolated from clobbering the /tmpfiles of
> > > > other ./check instances *and* the rest of the system?
> > > 
> > > We probably can. I didn't want to go down that rat hole straight
> > > away, because then I'd have to make a decision about what to mount
> > > there. One thing at a time....
> > > 
> > > I suspect that I can just use a tmpfs filesystem for it - there's
> > > heaps of memory available on my test machines and we don't use /tmp
> > > to hold large files, so that should work fine for me.  However, I'm
> > > a little concerned about what will happen when testing under memory
> > > pressure situations if /tmp needs memory to operate correctly.
> > > 
> > > I'll have a look at what is needed for private tmpfs /tmp instances
> > > to work - it should work just fine.
> > > 
> > > However, if check-parallel has taught me anything, it is that trying
> > > to use "should work" features on a modern system tends to mean "this
> > > is a poorly documented rat-hole that with many dead-ends that will
> > > be explored before a working solution is found"...
> > 
> > <nod> I'm running an experiment overnight with the following patch to
> > get rid of the session id grossness.  AFAICT it can also be used by
> > check-parallel to start its subprocesses in separate pid namespaces,
> > though I didn't investigate thoroughly.
> 
> I don't think check-parallel needs to start each check instance in
> it's own PID namespace - it's the tests themselves that need the
> isolation from each other.
> 
> However, the check instances require a private mount namespace, as
> they mount and unmount test/scratch devices themselves and we do not
> want other check instances seeing those mounts.
> 
> Hence I think the current check-parallel code doing mount namespace
> isolation as it already does should work with this patch enabling
> per-test process isolation inside check itself.
> 
> > I'm also not sure it's required for check-helper to unmount the /proc
> > that it creates; merely exiting seems to clean everything up? <shrug>
> 
> Yeah, I think tearing down the mount namespace (i.e. exiting the
> process that nsexec created) drops the last active reference to the
> mounts inside the private namespace and so it gets torn down that
> way.
> 
> So from my perspective, I think your check-helper namespace patch is
> a good improvement and I'll build/fix anything I come across on top
> of it. Once your series of fixes goes in, I'll rebase all the stuff
> I've got on top it and go from there...

<nod> I might reformulate the pkill code to use nsexec (and not systemd)
if it's available; systemd scopes if those are available (I figured out
how to get systemd to tell me the cgroup name); or worst case fall back
to process sessions if neither are available.

I don't know how ancient of a userspace we realistically have to support
since (afaict) namespaces and systemd both showed up around the 2.6.24
era?  But I also don't know if Devuan at least does pid/mount
namespaces.

--D

> > I also tried using systemd-nspawn to run fstests inside a "container"
> > but very quickly discovered that you can't pass block devices to the
> > container which makes fstests pretty useless for testing real scsi
> > devices. :/
> 
> Yet another dead-end in the poorly sign-posted rat-hole, eh?

Yup.

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
