Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 006831D130E
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 23:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728688362; cv=none; b=PfJ2av/j+zU/FkY+jiYZZpfyHQ5bWkhZ3rKR0Aj6BD0+dbqyb3lKWh1J+if1dwLMcieY274pC4ZbvdHcniWf3v+WYs/9aTyuHtYaZjemay1unZEhaiS0jdy0yc7XoZo3WUQw36yYTTLxY3DEiIlGiQDG39KxRv3KhRGlitlh/u8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728688362; c=relaxed/simple;
	bh=gA/1+e1TxQk+qYg/rXHaZlHG1w+oD4wsFxPL+GoZq3o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sGoaoV39zDlt1eYR2gOW5014+RgVDUEmbG/Pyq3SjSzxxYNP0tmBJv30BkYdLKbqeFDNPDIdCPYwWHAFijzi7/Zg1mqSm55+b1Yr0VjrO1q1bZ8nTSAfnepW3QRltyr3uDM9L/+vROzL3ZyBB9iph2jSmDPJRfWxUX/7ZhCW8NI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ghNFuaUm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ghNFuaUm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EDDFC4CEC3;
	Fri, 11 Oct 2024 23:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728688361;
	bh=gA/1+e1TxQk+qYg/rXHaZlHG1w+oD4wsFxPL+GoZq3o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ghNFuaUmHcLAMVmLIUoZpoA57cLYW+oI0XsFSz9uSBe1uiYRSJbv9slcp632+Ewqe
	 zuSYpF1P8u2/abXxR0jQ3pR+NvzK8mUSJ+wrMXWA5UIhLcMhj/WrP1EGEl6B2sTH4U
	 y5kMzYQwNbDVP1XaOjoUGSysL6ZWQXbJb/3qa1N+sScU9mzWBgUPiX9npFVCVxyBF0
	 xrwhyDvv6KUmdgc6L/g+Ra2fdjg8a5xKKnZT2AgosAVrAF6CZBi0aWiS0atp05vWl2
	 f8Ts5khfwPRWbVC+aE6DFfSr4RKAI8VGKW9YfIm49XJSBJa/1ZW7u4cn5EbbQoZLJ8
	 wFVcFK6jeGKqA==
Date: Fri, 11 Oct 2024 16:12:41 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/7] xfs: don't update file system geometry through
 transaction deltas
Message-ID: <20241011231241.GD21853@frogsfrogsfrogs>
References: <20240930164211.2357358-1-hch@lst.de>
 <20240930164211.2357358-7-hch@lst.de>
 <ZwffQQuVx_CyVgLc@bfoster>
 <20241011075709.GC2749@lst.de>
 <Zwkv6G1ZMIdE5vs2@bfoster>
 <20241011171303.GB21853@frogsfrogsfrogs>
 <ZwlxTVpgeVGRfuUb@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZwlxTVpgeVGRfuUb@bfoster>

On Fri, Oct 11, 2024 at 02:41:17PM -0400, Brian Foster wrote:
> On Fri, Oct 11, 2024 at 10:13:03AM -0700, Darrick J. Wong wrote:
> > On Fri, Oct 11, 2024 at 10:02:16AM -0400, Brian Foster wrote:
> > > On Fri, Oct 11, 2024 at 09:57:09AM +0200, Christoph Hellwig wrote:
> > > > On Thu, Oct 10, 2024 at 10:05:53AM -0400, Brian Foster wrote:
> > > > > Ok, so we don't want geometry changes transactions in the same CIL
> > > > > checkpoint as alloc related transactions that might depend on the
> > > > > geometry changes. That seems reasonable and on a first pass I have an
> > > > > idea of what this is doing, but the description is kind of vague.
> > > > > Obviously this fixes an issue on the recovery side (since I've tested
> > > > > it), but it's not quite clear to me from the description and/or logic
> > > > > changes how that issue manifests.
> > > > > 
> > > > > Could you elaborate please? For example, is this some kind of race
> > > > > situation between an allocation request and a growfs transaction, where
> > > > > the former perhaps sees a newly added AG between the time the growfs
> > > > > transaction commits (applying the sb deltas) and it actually commits to
> > > > > the log due to being a sync transaction, thus allowing an alloc on a new
> > > > > AG into the same checkpoint that adds the AG?
> > > > 
> > > > This is based on the feedback by Dave on the previous version:
> > > > 
> > > > https://lore.kernel.org/linux-xfs/Zut51Ftv%2F46Oj386@dread.disaster.area/
> > > > 
> > > 
> > > Ah, Ok. That all seems reasonably sane to me on a first pass, but I'm
> > > not sure I'd go straight to this change given the situation...
> > > 
> > > > Just doing the perag/in-core sb updates earlier fixes all the issues
> > > > with my test case, so I'm not actually sure how to get more updates
> > > > into the check checkpoint.  I'll try your exercisers if it could hit
> > > > that.
> > > > 
> > > 
> > > Ok, that explains things a bit. My observation is that the first 5
> > > patches or so address the mount failure problem, but from there I'm not
> > > reproducing much difference with or without the final patch.
> > 
> > Does this change to flush the log after committing the new sb fix the
> > recovery problems on older kernels?  I /think/ that's the point of this
> > patch.
> > 
> 
> I don't follow.. growfs always forced the log via the sync transaction,
> right? Or do you mean something else by "change to flush the log?"

I guess I was typing a bit too fast this morning -- "change to flush the
log to disk before anyone else can get their hands on the superblock".
You're right that xfs_log_sb and data-device growfs already do that.

That said, growfsrt **doesn't** call xfs_trans_set_sync, so that's a bug
that this patch fixes, right?

> I thought the main functional change of this patch was to hold the
> superblock buffer locked across the force so nothing else can relog the
> new geometry superblock buffer in the same cil checkpoint. Presumably,
> the theory is that prevents recovery from seeing updates to different
> buffers that depend on the geometry update before the actual sb geometry
> update is recovered (because the latter might have been relogged).
> 
> Maybe we're saying the same thing..? Or maybe I just misunderstand.
> Either way I think patch could use a more detailed commit log...

<nod> The commit message should point out that we're fixing a real bug
here, which is that growfsrt doesn't force the log to disk when it
commits the new rt geometry.

> > >                                                              Either way,
> > > I see aborts and splats all over the place, which implies at minimum
> > > this isn't the only issue here.
> > 
> > Ugh.  I've recently noticed the long soak logrecovery test vm have seen
> > a slight tick up in failure rates -- random blocks that have clearly had
> > garbage written to them such that recovery tries to read the block to
> > recover a buffer log item and kaboom.  At this point it's unclear if
> > that's a problem with xfs or somewhere else. :(
> > 
> > > So given that 1. growfs recovery seems pretty much broken, 2. this
> > > particular patch has no straightforward way to test that it fixes
> > > something and at the same time doesn't break anything else, and 3. we do
> > 
> > I'm curious, what might break?  Was that merely a general comment, or do
> > you have something specific in mind?  (iows: do you see more string to
> > pull? :))
> > 
> 
> Just a general comment..
> 
> Something related that isn't totally clear to me is what about the
> inverse shrink situation where dblocks is reduced. I.e., is there some
> similar scenario where for example instead of the sb buffer being
> relogged past some other buffer update that depends on it, some other
> change is relogged past a sb update that invalidates/removes blocks
> referenced by the relogged buffer..? If so, does that imply a shrink
> should flush the log before the shrink transaction commits to ensure it
> lands in a new checkpoint (as opposed to ensuring followon updates land
> in a new checkpoint)..?

I think so.  Might we want to do that before and after to be careful?

> Anyways, my point is just that if it were me I wouldn't get too deep
> into this until some of the reproducible growfs recovery issues are at
> least characterized and testing is more sorted out.
> 
> The context for testing is here [1]. The TLDR is basically that
> Christoph has a targeted test that reproduces the initial mount failure
> and I hacked up a more general test that also reproduces it and
> additional growfs recovery problems. This test does seem to confirm that
> the previous patches address the mount failure issue, but this patch
> doesn't seem to prevent any of the other problems produced by the
> generic test. That might just mean the test doesn't reproduce what this
> fixes, but it's kind of hard to at least regression test something like
> this when basic growfs crash-recovery seems pretty much broken.

Hmm, if you make a variant of that test which formats with an rt device
and -d rtinherit=1 and then runs xfs_growfs -R instead of -D, do you see
similar blowups?  Let's see what happens if I do that...

--D

> Brian
> 
> [1] https://lore.kernel.org/fstests/ZwVdtXUSwEXRpcuQ@bfoster/
> 
> > > have at least one fairly straightforward growfs/recovery test in the
> > > works that reliably explodes, personally I'd suggest to split this work
> > > off into separate series.
> > > 
> > > It seems reasonable enough to me to get patches 1-5 in asap once they're
> > > fully cleaned up, and then leave the next two as part of a followon
> > > series pending further investigation into these other issues. As part of
> > > that I'd like to know whether the recovery test reproduces (or can be
> > > made to reproduce) the issue this patch presumably fixes, but I'd also
> > > settle for "the grow recovery test now passes reliably and this doesn't
> > > regress it." But once again, just my .02.
> > 
> > Yeah, it's too bad there's no good way to test recovery with older
> > kernels either. :(
> > 
> > --D
> > 
> > > Brian
> > > 
> > > 
> > 
> 
> 
