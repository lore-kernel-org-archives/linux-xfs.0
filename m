Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4214A1E498
	for <linux-xfs@vger.kernel.org>; Wed,  7 Feb 2024 17:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707327381; cv=none; b=cyGEaSaGobkvIObtoM2qkRbiOS5AH5FD2Eippk2sHjHlNLaZI5A00fl2ZtJdlWK+S/bEdamHB40PMdjRSOT0z+/4ZnqNjS3rsrP8D5GG3SlXLd4c8HNWO3COrp+otFG1WkGVlosCzFbELwljsA9uyFoPNDyoH0/O8IFej5JP2+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707327381; c=relaxed/simple;
	bh=AXr7uRL0ufZ01+wOgBuy6TL0EQljeCsABPhihotJFVo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ESvjoYu7dwNkQo6ql7fBPeqSAFPn/PsyYGO8cdL5bPg5agDROqln/pikAftNZrb6Z9y7KHF9JlVOlpMv4ylHOTdI9kJ+rBt3YXwG78Glb9JLLvOSc/YbT5Wr9Tj+v5YKUF2JR5t5v3ifparAllmMIzOf+/ZbMM1xMR8Kduc4Rfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jbmXn5PN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jbmXn5PN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B041FC433C7;
	Wed,  7 Feb 2024 17:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707327380;
	bh=AXr7uRL0ufZ01+wOgBuy6TL0EQljeCsABPhihotJFVo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jbmXn5PNAxrLPBr1osqYK9FGXNpRVJQ7MO6Acqhi7K5pakHtNnO2eFSsqY0CwD/mu
	 /Qa8Ud1vDjKexc+JzUsvR+oGAznXXBJxsEgpLgPEpM7sZZBhxBfzcqZ5gD0FJIZY9p
	 SzF5dZ6dWj4LluO4Ctnxu8/PbiHADd6dtwlcBU/LnleN+7DFk2tPqwzHZm0vxGtAIN
	 usLmB8YBjZ6lhiI0ULv83tFbtIcUtyTcziUbP8NfC4rU0EtoUsq9uD63XzTbxkMBGj
	 FR8LbndwMx7ZWqxqgSNAwV2oSACEjew/D6T+55B7uvHq51AGah7+tUeHAYbNDq87KF
	 X95I483j1pjKA==
Date: Wed, 7 Feb 2024 09:36:20 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Brian Foster <bfoster@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH v2] xfs: run blockgc on freeze to avoid iget stalls
 after reclaim
Message-ID: <20240207173620.GS616564@frogsfrogsfrogs>
References: <Za3fwLKtjC+B8aZa@dread.disaster.area>
 <ZbJYP63PgykS1CwU@bfoster>
 <ZbLyxHSkE5eCCRRZ@dread.disaster.area>
 <Zbe9+EY5bLjhPPJn@bfoster>
 <Zbrw07Co5vhrDUfd@dread.disaster.area>
 <Zb1FhDn09pwFvE7O@bfoster>
 <20240202233343.GM616564@frogsfrogsfrogs>
 <Zb+1O+MlTpzHZ595@bfoster>
 <20240205220727.GN616564@frogsfrogsfrogs>
 <ZcIz6V7EAYLW7cgO@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZcIz6V7EAYLW7cgO@bfoster>

On Tue, Feb 06, 2024 at 08:28:09AM -0500, Brian Foster wrote:
> On Mon, Feb 05, 2024 at 02:07:27PM -0800, Darrick J. Wong wrote:
> > On Sun, Feb 04, 2024 at 11:03:07AM -0500, Brian Foster wrote:
> > > On Fri, Feb 02, 2024 at 03:33:43PM -0800, Darrick J. Wong wrote:
> > > > On Fri, Feb 02, 2024 at 02:41:56PM -0500, Brian Foster wrote:
> > > > > On Thu, Feb 01, 2024 at 12:16:03PM +1100, Dave Chinner wrote:
> > > > > > On Mon, Jan 29, 2024 at 10:02:16AM -0500, Brian Foster wrote:
> > > > > > > On Fri, Jan 26, 2024 at 10:46:12AM +1100, Dave Chinner wrote:
> > > > > > > > On Thu, Jan 25, 2024 at 07:46:55AM -0500, Brian Foster wrote:
> > > > > > > > > On Mon, Jan 22, 2024 at 02:23:44PM +1100, Dave Chinner wrote:
> > > > > > > > > > On Fri, Jan 19, 2024 at 02:36:45PM -0500, Brian Foster wrote:
> > > > > ...
> > > > > > Here's the fixes for the iget vs inactive vs freeze problems in the
> > > > > > upstream kernel:
> > > > > > 
> > > > > > https://lore.kernel.org/linux-xfs/20240201005217.1011010-1-david@fromorbit.com/T/#t
> > > > > > 
> > > > > > With that sorted, are there any other issues we know about that
> > > > > > running a blockgc scan during freeze might work around?
> > > > > > 
> > > > > 
> > > > > The primary motivation for the scan patch was the downstream/stable
> > > > > deadlock issue. The reason I posted it upstream is because when I
> > > > > considered the overall behavior change, I thought it uniformly
> > > > > beneficial to both contexts based on the (minor) benefits of the side
> > > > > effects of the scan. You don't need me to enumerate them, and none of
> > > > > them are uniquely important or worth overanalyzing.
> > > > > 
> > > > > The only real question that matters here is do you agree with the
> > > > > general reasoning for a blockgc scan during freeze, or shall I drop the
> > > > > patch?
> > > > 
> > > 
> > > Hi Darrick,
> > > 
> > > > I don't see any particular downside to flushing {block,inode}gc work
> > > > during a freeze, other than the loss of speculative preallocations
> > > > sounds painful.
> > > > 
> > > 
> > > Yeah, that's definitely a tradeoff. The more I thought about that, the
> > > more ISTM that any workload that might be sensitive enough to the
> > > penalty of an extra blockgc scan, the less likely it's probably going to
> > > see freeze cycles all that often.
> > > 
> > > I suspect the same applies to the bit of extra work added to the freeze
> > > as well , but maybe there's some more painful scenario..?
> > 
> > <shrug> I suppose if you had a few gigabytes of speculative
> > preallocations across a bunch of log files (or log structured tree
> > files, or whatever) then you could lose those preallocations and make
> > fragmentation worse.  Since blockgc can run on open files, maybe we
> > should leave that out of the freeze preparation syncfs?
> > 
> 
> By "leave that out," do you mean leave out the blockgc scan on freeze,
> or use a special mode that explicitly skips over opened/writeable files?

I meant s/xfs_blockgc_free_space/xfs_inodegc_flush/ in the patch you sent.

But I'd wondered over the years if blockgc ought to ignore files that
are still opened for write unless we're scouring for free space due to
an ENOSPC.  Maybe the current heuristic of skipping files with dirty
pagecache or IOLOCK contention is good enough.

> FWIW, this sounds more like a generic improvement to the background scan
> to me. Background blockgc currently filters out on things like whether
> the file is dirty in pagecache. If you have a log file or something, I
> would think the regular background scan may end up processing such files
> more frequently than a freeze induced one will..? And for anything that
> isn't under active or continuous modification, freeze is already going
> to flush everything out for the first post-unfreeze background scan to
> take care of.

Mhm.

> So I dunno, I think I agree and disagree. :) I think it would be
> perfectly reasonable to add an open/writeable file filter check to the
> regular background scan to make it less aggressive. This patch does
> invoke the background scan, but only because of the wonky read into a
> mapped buffer use case.

Does this livelock happen on a non-frozen filesystem too?  I wasn't too
sure if you wrote about that in the commit message because there's a
real livelock bug w.r.t. that or if that sentence was simply explaining
the use of an async scan.

> I still think freeze should (eventually) rather
> invoke the more aggressive sync scan and process all pending work before
> quiesce and not alter behavior based on heuristics.

Admittedly, given how much recovery /can/ be required, I'm starting to
think that we could push more of that work to disk before the freeze.

> > OTOH most of the inodes on those lists are not open at all, so perhaps
> > we /should/ kick inodegc while preparing for freeze?  Such a patch could
> > reuse the justification below after s/blockgc/inodegc/.  Too bad we
> > didn't think far enough into the FIFREEZE design to allow userspace to
> > indicate if they want us to minimize freeze time or post-freeze
> > recovery time.
> > 
> 
> Yeah, I think this potentially ties in interestingly with the
> security/post freeze drop caches thing Christian brought up on fsdevel
> recently.

<nod> Back in the day Luis was trying to rearrange the suspend code so
that we'd freeze the filesystems in reverse mount order.  I guess the
trouble with that approach is that for suspend you'd also want to block
read requests.

> It would be more ideal if freeze actually had some controls
> that different use cases could use to suggest how aggressive (or not) to
> be with such things. Maybe that somewhat relates to the per-stage
> ->freeze_fs() prototype thing I posted earlier in the thread [1] to help
> support running a sync scan.

Agreed.  Frustratingly, I took a look at the FIFREEZE definition and
realized that it /does/ actually take a pointer to an int:

include/uapi/linux/fs.h:196:#define FIFREEZE _IOWR('X', 119, int)    /* Freeze */
include/uapi/linux/fs.h:197:#define FITHAW   _IOWR('X', 120, int)    /* Thaw */

But the current implementation ignores the parameter and Debian code
search shows that some people call ioctl(fd, FIFREEZE) which means that
we'd have to create a FIFREEZE2 just to add a parameter.

> Given the current implementation, I think ultimately it just depends on
> your perspective of what freeze is supposed to do. To me, it should
> reliably put the filesystem into a predictable state on-disk (based on
> the common snapshot use case).

I always thought freeze was only supposed to do the bare minimum needed
to quiesce the filesystem, assuming that the common case is that we
quickly thaw and resume runtime operations.  OTOH a dirty 1GB log will
take a while to recover, and if the point was to make a backup or
something, that just makes IT unhappy.

> It is a big hammer that should be
> scheduled with care wrt to any performance sensitive workloads, and
> should be minimally disruptive to the system when held for a
> non-deterministic/extended amount of time. Departures from that are
> either optimizations or extra feature/modifiers that we currently don't
> have a great way to control. Just my .02.

<nod> Is there anyone interested in working on adding a mode parameter
to FIFREEZE?  What happens if the freeze comes in via the block layer?

--D

> 
> Brian
> 
> [1] Appended to this reply:
>   https://lore.kernel.org/linux-xfs/ZbJYP63PgykS1CwU@bfoster/
> 
> > --D
> > 
> > > > Does Dave's patchset to recycle NEEDS_INACTIVE inodes eliminate the
> > > > stall problem?
> > > > 
> > > 
> > > I assume it does. I think some of the confusion here is that I probably
> > > would have gone in a slightly different direction on that issue, but
> > > that's a separate discussion.
> > > 
> > > As it relates to this patch, in hindsight I probably should have
> > > rewritten the commit log from the previous version. If I were to do that
> > > now, it might read more like this (factoring out sync vs. non-sync
> > > nuance and whatnot):
> > > 
> > > "
> > > xfs: run blockgc on freeze to keep inodes off the inactivation queues
> > > 
> > > blockgc processing is disabled when the filesystem is frozen. This means
> > > <words words words about blockgc> ...
> > > 
> > > Rather than hold pending blockgc inodes in inactivation queues when
> > > frozen, run a blockgc scan during the freeze sequence to process this
> > > subset of inodes up front. This allows reclaim to potentially free these
> > > inodes while frozen (by keeping them off inactive lists) and produces a
> > > more predictable/consistent on-disk freeze state. The latter is
> > > potentially beneficial for shapshots, as this means no dangling post-eof
> > > preallocs or cowblock recovery.
> > > 
> > > Potential tradeoffs for this are <yadda yadda, more words from above>
> > > ...
> > > "
> > > 
> > > ... but again, the primary motivation for this was still the whole
> > > deadlock thing. I think it's perfectly reasonable to look at this change
> > > and say it's not worth it. Thanks for the feedback.
> > > 
> > > Brian
> > > 
> > > > --D
> > > > 
> > > > > Brian
> > > > > 
> > > > > > -Dave.
> > > > > > -- 
> > > > > > Dave Chinner
> > > > > > david@fromorbit.com
> > > > > > 
> > > > > 
> > > > > 
> > > > 
> > > 
> > > 
> > 
> 
> 
