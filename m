Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CD801CD25
	for <linux-xfs@vger.kernel.org>; Thu,  8 Feb 2024 12:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707396768; cv=none; b=Tpd4LG9DpqxY9m3/XIU3S6g3vf0yLS10Recu+gEBQVSo9RRQiy89sJy+1pxSqNMBoIsu/YQnFBRZDAIiQrvNQmvjr7OZy31n9cwMa2AznRiDl8BWB+Bf9rpeFWzc5A1W3GBmzFPHD0j+W9eXlen3jqskcej9zHrfkCl3SW71B2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707396768; c=relaxed/simple;
	bh=Xfi5ss/i9GYmtbkdQa6Tz1orjA3TUWakJXIoPvr9Ar8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YfDQQ5ceq17W9g1dy7xtEd6gFQNyUTW5yj5mssELwD8z8uzeM4zrX8vYShqK9BaH8fwLrhfrRouU6Olx8NtDDZ2zz3bZMuinuFSlSuAmT/djOAnZ8DQNSCYO31BlmdSA770mbNlpcbbVE2d6fRydMBpmQ84ix3ucb2WkVVbgSHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dG+KbjzE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dG+KbjzE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707396764;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QqC0TNgkRfVMp0YXUoD695qoiamSQItS7j60sIqpn7M=;
	b=dG+KbjzEW1kerZJcXnmBn0NWwXdEP7gTt+mZm8Qys4btrAc7L8dAZVX9onCeYWL6SQe6VT
	asJEv+htyu7y8Wuh8zr8303sMOo31+3e0BZ9PXdQ205MYx5NzMooyiBobJX7IoJKKf+urk
	zE9uZa0hvYf0K4W5P5L1b2s4MdMoTv0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-131-2p4v1rNXMZW6Kr1fTy1Phw-1; Thu, 08 Feb 2024 07:52:42 -0500
X-MC-Unique: 2p4v1rNXMZW6Kr1fTy1Phw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0361D185A782;
	Thu,  8 Feb 2024 12:52:42 +0000 (UTC)
Received: from bfoster (unknown [10.22.32.186])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B932F40C9444;
	Thu,  8 Feb 2024 12:52:41 +0000 (UTC)
Date: Thu, 8 Feb 2024 07:54:00 -0500
From: Brian Foster <bfoster@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH v2] xfs: run blockgc on freeze to avoid iget stalls
 after reclaim
Message-ID: <ZcTO6KyMyMYmeFr/@bfoster>
References: <ZbJYP63PgykS1CwU@bfoster>
 <ZbLyxHSkE5eCCRRZ@dread.disaster.area>
 <Zbe9+EY5bLjhPPJn@bfoster>
 <Zbrw07Co5vhrDUfd@dread.disaster.area>
 <Zb1FhDn09pwFvE7O@bfoster>
 <20240202233343.GM616564@frogsfrogsfrogs>
 <Zb+1O+MlTpzHZ595@bfoster>
 <20240205220727.GN616564@frogsfrogsfrogs>
 <ZcIz6V7EAYLW7cgO@bfoster>
 <20240207173620.GS616564@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240207173620.GS616564@frogsfrogsfrogs>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

On Wed, Feb 07, 2024 at 09:36:20AM -0800, Darrick J. Wong wrote:
> On Tue, Feb 06, 2024 at 08:28:09AM -0500, Brian Foster wrote:
> > On Mon, Feb 05, 2024 at 02:07:27PM -0800, Darrick J. Wong wrote:
> > > On Sun, Feb 04, 2024 at 11:03:07AM -0500, Brian Foster wrote:
> > > > On Fri, Feb 02, 2024 at 03:33:43PM -0800, Darrick J. Wong wrote:
> > > > > On Fri, Feb 02, 2024 at 02:41:56PM -0500, Brian Foster wrote:
> > > > > > On Thu, Feb 01, 2024 at 12:16:03PM +1100, Dave Chinner wrote:
> > > > > > > On Mon, Jan 29, 2024 at 10:02:16AM -0500, Brian Foster wrote:
> > > > > > > > On Fri, Jan 26, 2024 at 10:46:12AM +1100, Dave Chinner wrote:
> > > > > > > > > On Thu, Jan 25, 2024 at 07:46:55AM -0500, Brian Foster wrote:
> > > > > > > > > > On Mon, Jan 22, 2024 at 02:23:44PM +1100, Dave Chinner wrote:
> > > > > > > > > > > On Fri, Jan 19, 2024 at 02:36:45PM -0500, Brian Foster wrote:
> > > > > > ...
> > > > > > > Here's the fixes for the iget vs inactive vs freeze problems in the
> > > > > > > upstream kernel:
> > > > > > > 
> > > > > > > https://lore.kernel.org/linux-xfs/20240201005217.1011010-1-david@fromorbit.com/T/#t
> > > > > > > 
> > > > > > > With that sorted, are there any other issues we know about that
> > > > > > > running a blockgc scan during freeze might work around?
> > > > > > > 
> > > > > > 
> > > > > > The primary motivation for the scan patch was the downstream/stable
> > > > > > deadlock issue. The reason I posted it upstream is because when I
> > > > > > considered the overall behavior change, I thought it uniformly
> > > > > > beneficial to both contexts based on the (minor) benefits of the side
> > > > > > effects of the scan. You don't need me to enumerate them, and none of
> > > > > > them are uniquely important or worth overanalyzing.
> > > > > > 
> > > > > > The only real question that matters here is do you agree with the
> > > > > > general reasoning for a blockgc scan during freeze, or shall I drop the
> > > > > > patch?
> > > > > 
> > > > 
> > > > Hi Darrick,
> > > > 
> > > > > I don't see any particular downside to flushing {block,inode}gc work
> > > > > during a freeze, other than the loss of speculative preallocations
> > > > > sounds painful.
> > > > > 
> > > > 
> > > > Yeah, that's definitely a tradeoff. The more I thought about that, the
> > > > more ISTM that any workload that might be sensitive enough to the
> > > > penalty of an extra blockgc scan, the less likely it's probably going to
> > > > see freeze cycles all that often.
> > > > 
> > > > I suspect the same applies to the bit of extra work added to the freeze
> > > > as well , but maybe there's some more painful scenario..?
> > > 
> > > <shrug> I suppose if you had a few gigabytes of speculative
> > > preallocations across a bunch of log files (or log structured tree
> > > files, or whatever) then you could lose those preallocations and make
> > > fragmentation worse.  Since blockgc can run on open files, maybe we
> > > should leave that out of the freeze preparation syncfs?
> > > 
> > 
> > By "leave that out," do you mean leave out the blockgc scan on freeze,
> > or use a special mode that explicitly skips over opened/writeable files?
> 
> I meant s/xfs_blockgc_free_space/xfs_inodegc_flush/ in the patch you sent.
> 

Ah, but isn't that already part of the xfs_inodegc_stop() path?

> But I'd wondered over the years if blockgc ought to ignore files that
> are still opened for write unless we're scouring for free space due to
> an ENOSPC.  Maybe the current heuristic of skipping files with dirty
> pagecache or IOLOCK contention is good enough.
> 

The existing heuristic may be fine for the current model of processing,
but I think this is interesting in another context. I have a couple
prototype variants around that work by keeping blockgc inodes out of
eviction until blockgc work is actually processed. To do something like
that probably warrants blockgc work to be more shrinker driven to
accommodate memory pressure, so ISTM that having some opened/writeable
logic to more intelligently select which blockgc inodes to process for
the purpose of eviction/reclaim could be rather useful.

> > FWIW, this sounds more like a generic improvement to the background scan
> > to me. Background blockgc currently filters out on things like whether
> > the file is dirty in pagecache. If you have a log file or something, I
> > would think the regular background scan may end up processing such files
> > more frequently than a freeze induced one will..? And for anything that
> > isn't under active or continuous modification, freeze is already going
> > to flush everything out for the first post-unfreeze background scan to
> > take care of.
> 
> Mhm.
> 
> > So I dunno, I think I agree and disagree. :) I think it would be
> > perfectly reasonable to add an open/writeable file filter check to the
> > regular background scan to make it less aggressive. This patch does
> > invoke the background scan, but only because of the wonky read into a
> > mapped buffer use case.
> 
> Does this livelock happen on a non-frozen filesystem too?  I wasn't too
> sure if you wrote about that in the commit message because there's a
> real livelock bug w.r.t. that or if that sentence was simply explaining
> the use of an async scan.
> 

The livelock was purely a SYNC blockgc scan vs. SB_FREEZE_PAGEFAULT
thing. The original patch I sent way back when did the sync scan, but
appeared to be susceptible to livelock if there was a blocked task
reading (i.e. holding iolock) and causing a page fault by copying into a
mapped buffer, because the scan will continuously try for the iolock
that won't ever be released. So the non-sync variant was a followup
suggestion as a best effort scan.

I think that if we could have a mode where the vfs called ->freeze_fs()
once per freeze stage instead of only once at the end, then we could
actually do a sync scan under SB_FREEZE_WRITE protection (possibly
followed by another non-sync scan under PAGEFAULT to catch any races).

> > I still think freeze should (eventually) rather
> > invoke the more aggressive sync scan and process all pending work before
> > quiesce and not alter behavior based on heuristics.
> 
> Admittedly, given how much recovery /can/ be required, I'm starting to
> think that we could push more of that work to disk before the freeze.
> 

I agree, but at least recovery is predictable. If you have a situation
where you have a bunch of inodes with post-eof blocks and then take a
snapshot, the fact that the snap might now have GBs of space off the end
of random inodes somewhere in the fs is pretty wonky behavior to me. I
suspect the only real way to reclaim that space is to cycle every inode
in the snapshot fs through the cache such that the extent list is read
and inode reclaim can identify whether there is post-eof space to trim,
but I've not actually experimented to see how bad that really is.

> > > OTOH most of the inodes on those lists are not open at all, so perhaps
> > > we /should/ kick inodegc while preparing for freeze?  Such a patch could
> > > reuse the justification below after s/blockgc/inodegc/.  Too bad we
> > > didn't think far enough into the FIFREEZE design to allow userspace to
> > > indicate if they want us to minimize freeze time or post-freeze
> > > recovery time.
> > > 
> > 
> > Yeah, I think this potentially ties in interestingly with the
> > security/post freeze drop caches thing Christian brought up on fsdevel
> > recently.
> 
> <nod> Back in the day Luis was trying to rearrange the suspend code so
> that we'd freeze the filesystems in reverse mount order.  I guess the
> trouble with that approach is that for suspend you'd also want to block
> read requests.
> 

Yeah, I vaguely recall some discussion on that and kind of got the sense
that suspend was... more involved of a problem. :P

> > It would be more ideal if freeze actually had some controls
> > that different use cases could use to suggest how aggressive (or not) to
> > be with such things. Maybe that somewhat relates to the per-stage
> > ->freeze_fs() prototype thing I posted earlier in the thread [1] to help
> > support running a sync scan.
> 
> Agreed.  Frustratingly, I took a look at the FIFREEZE definition and
> realized that it /does/ actually take a pointer to an int:
> 
> include/uapi/linux/fs.h:196:#define FIFREEZE _IOWR('X', 119, int)    /* Freeze */
> include/uapi/linux/fs.h:197:#define FITHAW   _IOWR('X', 120, int)    /* Thaw */
> 
> But the current implementation ignores the parameter and Debian code
> search shows that some people call ioctl(fd, FIFREEZE) which means that
> we'd have to create a FIFREEZE2 just to add a parameter.
> 
> > Given the current implementation, I think ultimately it just depends on
> > your perspective of what freeze is supposed to do. To me, it should
> > reliably put the filesystem into a predictable state on-disk (based on
> > the common snapshot use case).
> 
> I always thought freeze was only supposed to do the bare minimum needed
> to quiesce the filesystem, assuming that the common case is that we
> quickly thaw and resume runtime operations.  OTOH a dirty 1GB log will
> take a while to recover, and if the point was to make a backup or
> something, that just makes IT unhappy.
> 

It seems the reality is that it's neither of these things we think it
should be, and rather just the result of a series of short term tweaks
and mods over a long period of time. :) I think at one point the entire
inode working set was reclaimed on freeze, but that was removed due to
being crazy. But now we obviously leave around blockgc inodes as a side
effect. I think the log is intentionally left dirty (but forced and
covered) to ensure the snapshot processes unlinked inodes as well (and I
think there's been a lot of back and forth on that over the years), but
could be misremembering...

> > It is a big hammer that should be
> > scheduled with care wrt to any performance sensitive workloads, and
> > should be minimally disruptive to the system when held for a
> > non-deterministic/extended amount of time. Departures from that are
> > either optimizations or extra feature/modifiers that we currently don't
> > have a great way to control. Just my .02.
> 
> <nod> Is there anyone interested in working on adding a mode parameter
> to FIFREEZE?  What happens if the freeze comes in via the block layer?
> 

We'd probably want to audit and maybe try to understand the various use
cases before getting too far with userspace API (at least defining flags
anyways). At least I'm not sure I really have a clear view of anything
outside of the simple snapshot case.

IOW, suppose in theory freeze by default was the biggest hammer possible
and made the filesystem generally flushed and clean on disk, but then
grew a flag input for behavior modifiers. What behavior would we modify
and why? Would somebody want a NOFLUSH thing that is purely a runtime
quiesce? Or something inbetween where data and log are flushed, but no
blockgc scanning or log forcing and so forth? Something else?

Brian

> --D
> 
> > 
> > Brian
> > 
> > [1] Appended to this reply:
> >   https://lore.kernel.org/linux-xfs/ZbJYP63PgykS1CwU@bfoster/
> > 
> > > --D
> > > 
> > > > > Does Dave's patchset to recycle NEEDS_INACTIVE inodes eliminate the
> > > > > stall problem?
> > > > > 
> > > > 
> > > > I assume it does. I think some of the confusion here is that I probably
> > > > would have gone in a slightly different direction on that issue, but
> > > > that's a separate discussion.
> > > > 
> > > > As it relates to this patch, in hindsight I probably should have
> > > > rewritten the commit log from the previous version. If I were to do that
> > > > now, it might read more like this (factoring out sync vs. non-sync
> > > > nuance and whatnot):
> > > > 
> > > > "
> > > > xfs: run blockgc on freeze to keep inodes off the inactivation queues
> > > > 
> > > > blockgc processing is disabled when the filesystem is frozen. This means
> > > > <words words words about blockgc> ...
> > > > 
> > > > Rather than hold pending blockgc inodes in inactivation queues when
> > > > frozen, run a blockgc scan during the freeze sequence to process this
> > > > subset of inodes up front. This allows reclaim to potentially free these
> > > > inodes while frozen (by keeping them off inactive lists) and produces a
> > > > more predictable/consistent on-disk freeze state. The latter is
> > > > potentially beneficial for shapshots, as this means no dangling post-eof
> > > > preallocs or cowblock recovery.
> > > > 
> > > > Potential tradeoffs for this are <yadda yadda, more words from above>
> > > > ...
> > > > "
> > > > 
> > > > ... but again, the primary motivation for this was still the whole
> > > > deadlock thing. I think it's perfectly reasonable to look at this change
> > > > and say it's not worth it. Thanks for the feedback.
> > > > 
> > > > Brian
> > > > 
> > > > > --D
> > > > > 
> > > > > > Brian
> > > > > > 
> > > > > > > -Dave.
> > > > > > > -- 
> > > > > > > Dave Chinner
> > > > > > > david@fromorbit.com
> > > > > > > 
> > > > > > 
> > > > > > 
> > > > > 
> > > > 
> > > > 
> > > 
> > 
> > 
> 

