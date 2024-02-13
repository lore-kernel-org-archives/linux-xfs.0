Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B4A60867
	for <linux-xfs@vger.kernel.org>; Tue, 13 Feb 2024 17:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707846919; cv=none; b=o29DOxMd+Dc5useXDC8a0nRwS4gKNOKV8qtnurCp56rcD1e3NeMQ3J7etuqIFzeXZpv+VOWwpzpUa8BMXTVn2QMPmL9lhy0iqm65UofvqwG8T023rSD1bYf+WhORgZ/X3/oa5NXuG8BQCpO0HQIpYr7ue2sWNqvZY9aBEobFaSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707846919; c=relaxed/simple;
	bh=BhsExO152oqPkNEBdZ59Sk+xvdq31Cm/OfMo8OrDsX4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YRfmwapQ1gnsIBIZvY8t+caogUPzpt+8QD5N66wVM0dLK4spqT4qUlgB6K/lotJTMUewe+fM4gyUqADMl44shvjhFgH8uR0JqSp/wll0GPLRKzPkGrXUh77rZP8Bt1i87QAamqjrfGtJ5olo3y2VGwaidAG1WR1WrRMUYJQliHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aQlmB/SO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aQlmB/SO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707846915;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hzwcMQt7X19WNhESN8UhDgiPJQHo47nzj2ti/T20QtA=;
	b=aQlmB/SOw70lOabiK13+SC2/q+fgj1t2pscMKuTm7Xh1grmAAmtr1wiYmaWPUb7W42Hrxr
	zJF7KTD6AR8cUQC/hQUugjcD8CXi6xy6rP+a47sxuP5fSSaG6vuYciw/cMVpb6D8ZFU0Ya
	hI6ez2pMApF1jHGaZ+YJLo31QZdDjgY=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-654-SKgkb7PfPiCkyQ4qgo5XDg-1; Tue,
 13 Feb 2024 12:55:11 -0500
X-MC-Unique: SKgkb7PfPiCkyQ4qgo5XDg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D36991C09822;
	Tue, 13 Feb 2024 17:54:55 +0000 (UTC)
Received: from bfoster (unknown [10.22.16.56])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8FE3A1BDB1;
	Tue, 13 Feb 2024 17:54:55 +0000 (UTC)
Date: Tue, 13 Feb 2024 12:56:32 -0500
From: Brian Foster <bfoster@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH v2] xfs: run blockgc on freeze to avoid iget stalls
 after reclaim
Message-ID: <ZcutUN5B2ZCuJfXr@bfoster>
References: <Zbrw07Co5vhrDUfd@dread.disaster.area>
 <Zb1FhDn09pwFvE7O@bfoster>
 <20240202233343.GM616564@frogsfrogsfrogs>
 <Zb+1O+MlTpzHZ595@bfoster>
 <20240205220727.GN616564@frogsfrogsfrogs>
 <ZcIz6V7EAYLW7cgO@bfoster>
 <20240207173620.GS616564@frogsfrogsfrogs>
 <ZcTO6KyMyMYmeFr/@bfoster>
 <ZcVwlLTVL65KAmdB@dread.disaster.area>
 <Zcp0zZ9h0OJ1a9x4@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zcp0zZ9h0OJ1a9x4@bfoster>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

On Mon, Feb 12, 2024 at 02:43:09PM -0500, Brian Foster wrote:
> On Fri, Feb 09, 2024 at 11:23:48AM +1100, Dave Chinner wrote:
> > On Thu, Feb 08, 2024 at 07:54:00AM -0500, Brian Foster wrote:
> > > On Wed, Feb 07, 2024 at 09:36:20AM -0800, Darrick J. Wong wrote:
> > > > On Tue, Feb 06, 2024 at 08:28:09AM -0500, Brian Foster wrote:
> > > > > On Mon, Feb 05, 2024 at 02:07:27PM -0800, Darrick J. Wong wrote:
> > > > > > On Sun, Feb 04, 2024 at 11:03:07AM -0500, Brian Foster wrote:
> > > > But I'd wondered over the years if blockgc ought to ignore files that
> > > > are still opened for write unless we're scouring for free space due to
> > > > an ENOSPC.  Maybe the current heuristic of skipping files with dirty
> > > > pagecache or IOLOCK contention is good enough.
> > > > 
> > > 
> > > The existing heuristic may be fine for the current model of processing,
> > > but I think this is interesting in another context. I have a couple
> > > prototype variants around that work by keeping blockgc inodes out of
> > > eviction until blockgc work is actually processed. To do something like
> > > that probably warrants blockgc work to be more shrinker driven to
> > > accommodate memory pressure, so ISTM that having some opened/writeable
> > > logic to more intelligently select which blockgc inodes to process for
> > > the purpose of eviction/reclaim could be rather useful.
> > > 
> > > > > FWIW, this sounds more like a generic improvement to the background scan
> > > > > to me. Background blockgc currently filters out on things like whether
> > > > > the file is dirty in pagecache. If you have a log file or something, I
> > > > > would think the regular background scan may end up processing such files
> > > > > more frequently than a freeze induced one will..? And for anything that
> > > > > isn't under active or continuous modification, freeze is already going
> > > > > to flush everything out for the first post-unfreeze background scan to
> > > > > take care of.
> > > > 
> > > > Mhm.
> > > > 
> > > > > So I dunno, I think I agree and disagree. :) I think it would be
> > > > > perfectly reasonable to add an open/writeable file filter check to the
> > > > > regular background scan to make it less aggressive. This patch does
> > > > > invoke the background scan, but only because of the wonky read into a
> > > > > mapped buffer use case.
> > > > 
> > > > Does this livelock happen on a non-frozen filesystem too?  I wasn't too
> > > > sure if you wrote about that in the commit message because there's a
> > > > real livelock bug w.r.t. that or if that sentence was simply explaining
> > > > the use of an async scan.
> > > > 
> > > 
> > > The livelock was purely a SYNC blockgc scan vs. SB_FREEZE_PAGEFAULT
> > > thing. The original patch I sent way back when did the sync scan, but
> > > appeared to be susceptible to livelock if there was a blocked task
> > > reading (i.e. holding iolock) and causing a page fault by copying into a
> > > mapped buffer, because the scan will continuously try for the iolock
> > > that won't ever be released. So the non-sync variant was a followup
> > > suggestion as a best effort scan.
> > > 
> > > I think that if we could have a mode where the vfs called ->freeze_fs()
> > > once per freeze stage instead of only once at the end, then we could
> > > actually do a sync scan under SB_FREEZE_WRITE protection (possibly
> > > followed by another non-sync scan under PAGEFAULT to catch any races).
> > 
> > To what purpose, though? It's being talked about as a way to run a
> > blockgc pass during freeze on XFS, but we don't need a blockgc
> > passes in freeze for XFS for deadlock avoidance or correct freeze
> > behaviour.
> > 
> > Hence I just don't see what problems this complexity is going to
> > fix. What am I missing?
> >
> 
> I mentioned in a reply or two back to Darrick that the deadlock/inode
> lookup behavior topic was a correlation I lazily/wrongly carried forward
> from the old discussion and caused unnecessary confusion.
> 
> > > > > I still think freeze should (eventually) rather
> > > > > invoke the more aggressive sync scan and process all pending work before
> > > > > quiesce and not alter behavior based on heuristics.
> > > > 
> > > > Admittedly, given how much recovery /can/ be required, I'm starting to
> > > > think that we could push more of that work to disk before the freeze.
> > > 
> > > I agree, but at least recovery is predictable. If you have a situation
> > > where you have a bunch of inodes with post-eof blocks and then take a
> > > snapshot, the fact that the snap might now have GBs of space off the end
> > > of random inodes somewhere in the fs is pretty wonky behavior to me. I
> > 
> > We've had that behaviour for 20+ years.  There's no evidence that it
> > is problematic and, realistically, it's not different to the
> > filesystem state after a system crash. i.e. crash your system, and
> > every inode in memory that has preallocated blocks beyond EOF now
> > has them persistently on disk, and they don't get cleaned up until
> > the next time they get cycled through the inode cache.
> > 
> > Further, we intentionally disable blockgc on any inode that has been
> > opend O_APPEND or had fallocate() called to preallocate blocks. So
> > regardless of anything else, blockgc scans are not a guarantee that
> > we clean up post-eof blocks during a freeze - they will exist on
> > disk after a freeze regardless of what we do during the freeze
> > process.
> > 
> > Also, we use the same quiesce code for remount,ro as we use for
> > freeze. Hence remount,ro leaves all the inodes in memory with
> > pending blockgc unchanged. The post-eof blocks are persisted on
> > disk, and they won't get removed until the filesystem is mounted rw
> > again and the inode is cycled through cache.
> > 
> > And then there's system crashes. They leave post-eof blocks
> > persistent on disk, too, and there is no possibility of blockgc
> > being done on them. Recovery does not run GC on these post-eof
> > blocks, nor should it.
> > 
> > So given that remount,ro and system crashes result in exactly the
> > same on-disk state as a freeze and we can't do anything about
> > crashes resulting in this state, why should we try to avoid
> > having post-eof blocks on disk during a freeze? They are going to be
> > on disk before a freeze, and then recreated immediately after a
> > freeze, so why does a freeze specifically need to remove them?
> > 
> 
> Because remount-ro isn't actually the same (xfs_remount_ro() runs a sync
> blockgc scan) and there is value in the state of a frozen fs on disk
> being more predictable than a system crash.
> 
> We don't (not necessarily can't) address the speculative prealloc
> problem on system crashes, but the COW blocks case actually does because
> it doesn't have much of a choice. We also can and do provide better than
> crash-like behavior for freeze by virtue of syncing the fs and forcing
> and covering the log.
> 
> > > suspect the only real way to reclaim that space is to cycle every inode
> > > in the snapshot fs through the cache such that the extent list is read
> > > and inode reclaim can identify whether there is post-eof space to trim,
> > > but I've not actually experimented to see how bad that really is.
> > 
> > We know how expensive that is: quotacheck has this exact same
> > requirement.  i.e. quotacheck has to cycle every inode in the
> > filesystem through the inode cache, and that will run post-eof block
> > removal as the inodes cycle out of cache.
> > 
> > And let's not forget that the reason we journal dquots is so that we
> > don't have to run a quotacheck on every mount because the overhead
> > is prohibitive on filesystems with millions of inodes.
> > 
> > If a full filesystem inode scan is necessary for blockgc, then do it
> > from userspace. A simple bulkstat pass will cycle every inode in the
> > filesystem through the cache, and so problem solved without having
> > to change a single line of XFS code anywhere.
> > 
> > > > > Given the current implementation, I think ultimately it just depends on
> > > > > your perspective of what freeze is supposed to do. To me, it should
> > > > > reliably put the filesystem into a predictable state on-disk (based on
> > > > > the common snapshot use case).
> > > > 
> > > > I always thought freeze was only supposed to do the bare minimum needed
> > > > to quiesce the filesystem, assuming that the common case is that we
> > > > quickly thaw and resume runtime operations.  OTOH a dirty 1GB log will
> > > > take a while to recover, and if the point was to make a backup or
> > > > something, that just makes IT unhappy.
> > > 
> > > It seems the reality is that it's neither of these things we think it
> > > should be, and rather just the result of a series of short term tweaks
> > > and mods over a long period of time. :)
> > 
> > IMO, freeze *requirements* are unchanged from what they were 25
> > years ago. Freeze is simply required to bring the filesystem down to
> > a consistent state on disk that is entirely readable without
> > requiring the filesytem to perform any more write operations to
> > perform those read and hold it unchanged in that state until the
> > filesystem is thawed.
> > 
> > A further desirable runtime characteristic is that it is
> > fast and has minimal runtime impact on application behaviour.
> > 
> > Yes, the implementaiton has changed over the years as we've found
> > bugs, changed the way other subsystems work, etc. But the actual
> > functional requirements of what freeze is supposed to provide have
> > not changed at all.
> > 
> > > I think at one point the entire
> > > inode working set was reclaimed on freeze, but that was removed due to
> > > being crazy.
> > 
> > Yes, up until 2020 it did do inode reclaim, but that was an
> > implementation detail. And it wasn't removed because it was "crazy",
> > it was removed because it was no longer necessary for correct
> > behaviour.
> > 
> > Back in 2005 we fixed some freeze issues by making it behave like
> > remount,ro. They both do largely the same thing in terms of bringing
> > the fs down to a consistent clean state on disk, so sharing the
> > implementaiton made a lot of sense. At the time, the only way to
> > prevent reclaimable inodes from running transactions after a
> > specific point in time was to process them all. i.e. inactivate all
> > the inodes, write them back and reclaim them. That was the problem
> > we needed to fix in freeze, and remount,ro already solved it. It was
> > the obvious, simple fix.
> > 
> > Did it cause problems? No, it didn't, because this "inode reclaim"
> > doesn't affect the working set of inodes in memory. i.e. the working
> > set is pinned in memory by cached dentries and so, by definition,
> > they are not on the inactive inode lists that can be purged by
> > reclaim during freeze/remount,ro.
> > 
> 
> Hmm.. yeah, I see what xfs_reclaim_inodes() does. I could have sworn we
> had a full invalidation in there somewhere at some point in the past. I
> don't see that on a quick look back, so I could either be misremembering
> or misinterpreting the reclaim call.
> 
> > To put this in modern context, the old code was essentially:
> > 
> > 	xfs_inodegc_flush()
> > 	xfs_ail_push_all_sync()
> > 	xfs_reclaim_inodes()
> > 
> > Note that there is no xfs_blockgc_flush_all() call in there - it
> > didn't touch inodes in the working set, just processed inodes
> > already queued for inactivation work. And in kernels since about
> > 3.10, the xfs_reclaim_inodes() call simply expedited the reclaim
> > that was going to happen in the background within 5 seconds, so it's
> > not like this actually changed anything material in terms of inode
> > cache behaviour.
> > 
> > Indeed, the commit that removed the inode reclaim in 2020 says this:
> > 
> >     For xfs_quiesce_attr() we can just remove the inode reclaim calls as
> >     they are a historic relic that was required to flush dirty inodes
> >     that contained unlogged changes. We now log all changes to the
> >     inodes, so the sync AIL push from xfs_log_quiesce() called by
> >     xfs_quiesce_attr() will do all the required inode writeback for
> >     freeze.
> > 
> > IOWs, it was removed because we realised it was redundant and no
> > longer necessary for correct behaviour of the freeze operation.
> > That's just normal development process, there was nothing "crazy"
> > about the old code, it just wasn't necessary anymore.
> > 
> > > But now we obviously leave around blockgc inodes as a side
> > > effect.
> > 
> > As per above: we have -always done that-. We have never run blockgc
> > on the current working set of inodes during a freeze. We don't want
> > to - that will perturb the runtime behaviour of the applications
> > beyond the freeze operation, and potentially not in a good way.
> > 
> 
> This is the primary tradeoff we've been discussing. How would this
> sufficiently peturb applications to the point of being problematic? ISTM
> that the only case where this is even observable are for files being
> actively extended across the freeze, and I'm not seeing how an added
> blockgc cycle per freeze operation would be beyond negligible from a
> performance or fragmentation perspective for common use cases.
> 
> What is less clear to me is whether the same applies to the COW/reflink
> use case. Darrick seemed to be on the fence. He would have to comment
> where he is on the runtime vs. snapshot -> recovery tradeoff. This is
> certainly not worth doing in current form if actively harmful in either
> situation.
> 

I ran a couple tests to try and substantiate this a bit more and measure
impact on both use cases vs. a pathological freeze workload...

Without going too deep into the details, a concurrent sequential
buffered write workload seemed less sensitive to pathological freezing
(i.e. a 1m freeze loop). It reduced a concurrent, sequential buffered
write workload that resulted ~5GB average sized extents in a baseline
test (no freezing) down to around ~3GB sized extents with a freeze cycle
every 60s. This workload involved a total of around 512GB written across
8 files (64GB per file).

A random write aio+dio workload to a prewritten and then reflinked file
was much more sensitive to blockgc scans. This wrote less data to keep
runtime down, but a 5m freeze loop (for a total of only two freeze
cycles) brought the extent count of an 8GB file from ~8191 1MB extents
(i.e. the cowextsize hint) on a baseline test up to 119488 when freezing
was introduced, for an average size of around ~70kb per extent.

Darrick,

I think this lends merit to your idea around having blockgc filter out
files currently open for write. Given the impact of only a couple scans
on the cowblocks test, it seems that even if a file seeing this sort of
workload (i.e. suppose a cloned VM image or something) idled for more
than a couple minutes or so, there's a decent chance a background scan
would come through and have the same kind of effect.

WRT freeze, this is enough for me to say we probably shouldn't be any
more aggressive with cowblocks files. I suppose a cowblocks only "open
for write" filter would still allow an eofblocks scan to trim preallocs
before a snapshot is taken. The same filter applied to eofblocks would
make that less effective, but then I suppose that would also remove most
of the risk associated with a freeze time blockgc scan. Not sure it's
really worth it at that point though.

Anyways, just something to think about. ISTM that's a potentially more
valuable improvement on its own than anything freeze related..

Brian

> Brian
> 
> > This is how we've implemented freeze for 20-odd years, and there's
> > no evidence that it is actually a behaviour that needs changing.
> > Having a bug in freeze realted to an inode that needs blockgc does
> > not mean "freeze should leave no inodes in memory that need
> > blockgc". All it means is that we need to handle inodes that need
> > blockgc during a freeze in a better way.....
> > 
> > > I think the log is intentionally left dirty (but forced and
> > > covered) to ensure the snapshot processes unlinked inodes as well (and I
> > > think there's been a lot of back and forth on that over the years), but
> > > could be misremembering...
> > 
> > That's a different problem altogether....
> > 
> > > > > It is a big hammer that should be
> > > > > scheduled with care wrt to any performance sensitive workloads, and
> > > > > should be minimally disruptive to the system when held for a
> > > > > non-deterministic/extended amount of time. Departures from that are
> > > > > either optimizations or extra feature/modifiers that we currently don't
> > > > > have a great way to control. Just my .02.
> > > > 
> > > > <nod> Is there anyone interested in working on adding a mode parameter
> > > > to FIFREEZE?  What happens if the freeze comes in via the block layer?
> > > > 
> > > 
> > > We'd probably want to audit and maybe try to understand the various use
> > > cases before getting too far with userspace API (at least defining flags
> > > anyways). At least I'm not sure I really have a clear view of anything
> > > outside of the simple snapshot case.
> > 
> > That's what I keep asking: what user problems are these proposed
> > changes actually trying to solve? Start with use cases, not grand
> > designs!
> > 
> > > IOW, suppose in theory freeze by default was the biggest hammer possible
> > > and made the filesystem generally flushed and clean on disk, but then
> > > grew a flag input for behavior modifiers. What behavior would we modify
> > > and why?
> > 
> > It was originally defined by the XFS_IOC_FREEZE API on Irix but we
> > never used it for anything on Linux. We didn't even validate it was
> > zero, so it really is just a result of a poor API implementation
> > done 25 years ago. I can see how this sort of little detail is
> > easily missed in the bigger "port an entire filesystem to a
> > different OS" picture....
> > 
> > > Would somebody want a NOFLUSH thing that is purely a runtime
> > > quiesce? Or something inbetween where data and log are flushed, but no
> > > blockgc scanning or log forcing and so forth? Something else?
> > 
> > No idea what the original intent was.  sync() is the filesystem
> > integrity flush, freeze is the "on-disk consistent" integrity flush,
> > and there's not much between those two things that is actually
> > useful to users, admins and/or applications.
> > 
> > The only thing I've seen proposed for the FIFREEZE argument is a
> > "timeout" variable to indicate the maximum time the filesystem
> > should stay frozen for before it automatically thaws itself (i.e. an
> > anti foot-gun mechanism). That went nowhere because it's just not
> > possible for admins and applications to use a timeout in a reliable
> > way...
> > 
> > -Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com
> > 
> 
> 

