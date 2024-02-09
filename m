Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40954EAC5
	for <linux-xfs@vger.kernel.org>; Fri,  9 Feb 2024 00:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707438235; cv=none; b=DtLvWgOMEn5akADRF2VGHWx2jBKi10+BUJxN4kDN7NC5xervQgfrGPg2wtfTnxI64yMJ4o65Ysh76gxpTPUwONOLzTm5fUczWOyCBtvebhWCbtQ7XAHPeEi+9jW1hXiIwtzctFK9F0sAJfXs1sbI998b19fAyIQD08AxLSBSdnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707438235; c=relaxed/simple;
	bh=eaWvt3jU5Mr5OivybhMzdb3GPiTOsJrbLnNJOAuE9lU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GCTV2A5OI/6oWWKkfeh7pItpsxAXbZJ1N7OoHDdcucNgKG8FSmqN4HJyNAeAWxy9vYaeQN4P7Iq2NnHDmDZn24ztMi+Bh4rIge7sXB1xvu+6vnzVmPElqLyvYcIC7AjtLdsjamXsNpIg9aiQ14pm7o1V7CdbDEOuD+Ntikmb6ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=CxqJPKvQ; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="CxqJPKvQ"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-6da4a923b1bso359247b3a.2
        for <linux-xfs@vger.kernel.org>; Thu, 08 Feb 2024 16:23:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1707438232; x=1708043032; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8BfsU6tA1JGScYnKMEeq7GmF2RuUvNF2hKCkweGfik0=;
        b=CxqJPKvQZ0a0t5Nc6dI8MtowlOqxR3rpf0PqbiMmdZYgBnQdK7Dw0VHyKF5+zHwgRL
         mXcxHpPtcUycittB9v+jI86NcYp+vLQnX4Hc/ISDVQdsYXtBqTTrj+2QWtTBk+iu+7j5
         zBnzxmyvsZ8A0/xLyTO7iYwZSy8DEwxnfvWFt0pO84qyZLRejCUZFp36c/N36+BvvEVG
         qZBPyu6U2mJVCs9BeYfGzdJEWzSP2ivz3hV0AsmyZZbo3dDDjmV3btHPChaHAuHcgC53
         4aeckU0quOROGYs1nxJsyC1ANkhUsAjQboXIygosySd984hGv7OH3OWsvGmZFbxl4vmR
         cWsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707438232; x=1708043032;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8BfsU6tA1JGScYnKMEeq7GmF2RuUvNF2hKCkweGfik0=;
        b=TGBJ/8dIir+RelgUKfAWJKpg72SA+jyzW9d4blinXgvv5n6q1Do/zMETbMLKKi3guN
         uGVM+3LxteDvWrTti1m1fBexXhQ7V4nVaBRrohvpWtM2WYiKwmCd2ccGxCtfP/ZKbL7E
         Ez7XhApnk8xgqfVnsdp2BFou5l4xVSs6fVQVsg4zOrT0sAk9vLKoI9H0x3e+9v1esrvc
         /6jke8F5ZoIi1sBtsaqDFxRC8WfLJaDZZpy04ZS66m7Zfw070sMr9RB9DnegxeEalNni
         8n8RenQp58ABeydvJfsPaMWS63bV3rDmAnileCq97hngNVOHXD4Ya00znT4khupAeM0s
         jXvQ==
X-Forwarded-Encrypted: i=1; AJvYcCXdNIxgN2qMX8Nb08xRtHYie8T7GdFBQVNX29cpFittyt2+vVD/7tNzgLr9TmalR4y9EiV6lQA9aCFE5kVFT7vmwQfvEXWPDCjD
X-Gm-Message-State: AOJu0YxUK7mBipCYluyjXfyc3c0TY2jZv8Vwvn8Km9ZbkYGK6qZijrps
	2O66fvSLL5RpDYViSVxrtLfOorG8eb8fC7GHKJinevdSKYAkla2F6cji0tDlnSw=
X-Google-Smtp-Source: AGHT+IFy5stMWntH8K5LsZy38mfKcIbxoiw7xG21DoxkrObYKP7BdfNJwAnl+439ywDEasid6OXpqg==
X-Received: by 2002:a62:d413:0:b0:6db:dc33:4e89 with SMTP id a19-20020a62d413000000b006dbdc334e89mr92072pfh.10.1707438232249;
        Thu, 08 Feb 2024 16:23:52 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWkna7wBdpOG0j4MGjuO1//7auGy+1s9qhYgwL9RPKyFwP7uNepgA7oRExr2jZAoqBCogfhc6GOrOsO4TbbhW8oafDIKvFmKiO0
Received: from dread.disaster.area (pa49-181-38-249.pa.nsw.optusnet.com.au. [49.181.38.249])
        by smtp.gmail.com with ESMTPSA id y10-20020a056a00190a00b006e085a96bd1sm104636pfi.117.2024.02.08.16.23.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Feb 2024 16:23:51 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rYEgG-003wL9-11;
	Fri, 09 Feb 2024 11:23:48 +1100
Date: Fri, 9 Feb 2024 11:23:48 +1100
From: Dave Chinner <david@fromorbit.com>
To: Brian Foster <bfoster@redhat.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH v2] xfs: run blockgc on freeze to avoid iget stalls
 after reclaim
Message-ID: <ZcVwlLTVL65KAmdB@dread.disaster.area>
References: <ZbLyxHSkE5eCCRRZ@dread.disaster.area>
 <Zbe9+EY5bLjhPPJn@bfoster>
 <Zbrw07Co5vhrDUfd@dread.disaster.area>
 <Zb1FhDn09pwFvE7O@bfoster>
 <20240202233343.GM616564@frogsfrogsfrogs>
 <Zb+1O+MlTpzHZ595@bfoster>
 <20240205220727.GN616564@frogsfrogsfrogs>
 <ZcIz6V7EAYLW7cgO@bfoster>
 <20240207173620.GS616564@frogsfrogsfrogs>
 <ZcTO6KyMyMYmeFr/@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZcTO6KyMyMYmeFr/@bfoster>

On Thu, Feb 08, 2024 at 07:54:00AM -0500, Brian Foster wrote:
> On Wed, Feb 07, 2024 at 09:36:20AM -0800, Darrick J. Wong wrote:
> > On Tue, Feb 06, 2024 at 08:28:09AM -0500, Brian Foster wrote:
> > > On Mon, Feb 05, 2024 at 02:07:27PM -0800, Darrick J. Wong wrote:
> > > > On Sun, Feb 04, 2024 at 11:03:07AM -0500, Brian Foster wrote:
> > But I'd wondered over the years if blockgc ought to ignore files that
> > are still opened for write unless we're scouring for free space due to
> > an ENOSPC.  Maybe the current heuristic of skipping files with dirty
> > pagecache or IOLOCK contention is good enough.
> > 
> 
> The existing heuristic may be fine for the current model of processing,
> but I think this is interesting in another context. I have a couple
> prototype variants around that work by keeping blockgc inodes out of
> eviction until blockgc work is actually processed. To do something like
> that probably warrants blockgc work to be more shrinker driven to
> accommodate memory pressure, so ISTM that having some opened/writeable
> logic to more intelligently select which blockgc inodes to process for
> the purpose of eviction/reclaim could be rather useful.
> 
> > > FWIW, this sounds more like a generic improvement to the background scan
> > > to me. Background blockgc currently filters out on things like whether
> > > the file is dirty in pagecache. If you have a log file or something, I
> > > would think the regular background scan may end up processing such files
> > > more frequently than a freeze induced one will..? And for anything that
> > > isn't under active or continuous modification, freeze is already going
> > > to flush everything out for the first post-unfreeze background scan to
> > > take care of.
> > 
> > Mhm.
> > 
> > > So I dunno, I think I agree and disagree. :) I think it would be
> > > perfectly reasonable to add an open/writeable file filter check to the
> > > regular background scan to make it less aggressive. This patch does
> > > invoke the background scan, but only because of the wonky read into a
> > > mapped buffer use case.
> > 
> > Does this livelock happen on a non-frozen filesystem too?  I wasn't too
> > sure if you wrote about that in the commit message because there's a
> > real livelock bug w.r.t. that or if that sentence was simply explaining
> > the use of an async scan.
> > 
> 
> The livelock was purely a SYNC blockgc scan vs. SB_FREEZE_PAGEFAULT
> thing. The original patch I sent way back when did the sync scan, but
> appeared to be susceptible to livelock if there was a blocked task
> reading (i.e. holding iolock) and causing a page fault by copying into a
> mapped buffer, because the scan will continuously try for the iolock
> that won't ever be released. So the non-sync variant was a followup
> suggestion as a best effort scan.
> 
> I think that if we could have a mode where the vfs called ->freeze_fs()
> once per freeze stage instead of only once at the end, then we could
> actually do a sync scan under SB_FREEZE_WRITE protection (possibly
> followed by another non-sync scan under PAGEFAULT to catch any races).

To what purpose, though? It's being talked about as a way to run a
blockgc pass during freeze on XFS, but we don't need a blockgc
passes in freeze for XFS for deadlock avoidance or correct freeze
behaviour.

Hence I just don't see what problems this complexity is going to
fix. What am I missing?

> > > I still think freeze should (eventually) rather
> > > invoke the more aggressive sync scan and process all pending work before
> > > quiesce and not alter behavior based on heuristics.
> > 
> > Admittedly, given how much recovery /can/ be required, I'm starting to
> > think that we could push more of that work to disk before the freeze.
> 
> I agree, but at least recovery is predictable. If you have a situation
> where you have a bunch of inodes with post-eof blocks and then take a
> snapshot, the fact that the snap might now have GBs of space off the end
> of random inodes somewhere in the fs is pretty wonky behavior to me. I

We've had that behaviour for 20+ years.  There's no evidence that it
is problematic and, realistically, it's not different to the
filesystem state after a system crash. i.e. crash your system, and
every inode in memory that has preallocated blocks beyond EOF now
has them persistently on disk, and they don't get cleaned up until
the next time they get cycled through the inode cache.

Further, we intentionally disable blockgc on any inode that has been
opend O_APPEND or had fallocate() called to preallocate blocks. So
regardless of anything else, blockgc scans are not a guarantee that
we clean up post-eof blocks during a freeze - they will exist on
disk after a freeze regardless of what we do during the freeze
process.

Also, we use the same quiesce code for remount,ro as we use for
freeze. Hence remount,ro leaves all the inodes in memory with
pending blockgc unchanged. The post-eof blocks are persisted on
disk, and they won't get removed until the filesystem is mounted rw
again and the inode is cycled through cache.

And then there's system crashes. They leave post-eof blocks
persistent on disk, too, and there is no possibility of blockgc
being done on them. Recovery does not run GC on these post-eof
blocks, nor should it.

So given that remount,ro and system crashes result in exactly the
same on-disk state as a freeze and we can't do anything about
crashes resulting in this state, why should we try to avoid
having post-eof blocks on disk during a freeze? They are going to be
on disk before a freeze, and then recreated immediately after a
freeze, so why does a freeze specifically need to remove them?

> suspect the only real way to reclaim that space is to cycle every inode
> in the snapshot fs through the cache such that the extent list is read
> and inode reclaim can identify whether there is post-eof space to trim,
> but I've not actually experimented to see how bad that really is.

We know how expensive that is: quotacheck has this exact same
requirement.  i.e. quotacheck has to cycle every inode in the
filesystem through the inode cache, and that will run post-eof block
removal as the inodes cycle out of cache.

And let's not forget that the reason we journal dquots is so that we
don't have to run a quotacheck on every mount because the overhead
is prohibitive on filesystems with millions of inodes.

If a full filesystem inode scan is necessary for blockgc, then do it
from userspace. A simple bulkstat pass will cycle every inode in the
filesystem through the cache, and so problem solved without having
to change a single line of XFS code anywhere.

> > > Given the current implementation, I think ultimately it just depends on
> > > your perspective of what freeze is supposed to do. To me, it should
> > > reliably put the filesystem into a predictable state on-disk (based on
> > > the common snapshot use case).
> > 
> > I always thought freeze was only supposed to do the bare minimum needed
> > to quiesce the filesystem, assuming that the common case is that we
> > quickly thaw and resume runtime operations.  OTOH a dirty 1GB log will
> > take a while to recover, and if the point was to make a backup or
> > something, that just makes IT unhappy.
> 
> It seems the reality is that it's neither of these things we think it
> should be, and rather just the result of a series of short term tweaks
> and mods over a long period of time. :)

IMO, freeze *requirements* are unchanged from what they were 25
years ago. Freeze is simply required to bring the filesystem down to
a consistent state on disk that is entirely readable without
requiring the filesytem to perform any more write operations to
perform those read and hold it unchanged in that state until the
filesystem is thawed.

A further desirable runtime characteristic is that it is
fast and has minimal runtime impact on application behaviour.

Yes, the implementaiton has changed over the years as we've found
bugs, changed the way other subsystems work, etc. But the actual
functional requirements of what freeze is supposed to provide have
not changed at all.

> I think at one point the entire
> inode working set was reclaimed on freeze, but that was removed due to
> being crazy.

Yes, up until 2020 it did do inode reclaim, but that was an
implementation detail. And it wasn't removed because it was "crazy",
it was removed because it was no longer necessary for correct
behaviour.

Back in 2005 we fixed some freeze issues by making it behave like
remount,ro. They both do largely the same thing in terms of bringing
the fs down to a consistent clean state on disk, so sharing the
implementaiton made a lot of sense. At the time, the only way to
prevent reclaimable inodes from running transactions after a
specific point in time was to process them all. i.e. inactivate all
the inodes, write them back and reclaim them. That was the problem
we needed to fix in freeze, and remount,ro already solved it. It was
the obvious, simple fix.

Did it cause problems? No, it didn't, because this "inode reclaim"
doesn't affect the working set of inodes in memory. i.e. the working
set is pinned in memory by cached dentries and so, by definition,
they are not on the inactive inode lists that can be purged by
reclaim during freeze/remount,ro.

To put this in modern context, the old code was essentially:

	xfs_inodegc_flush()
	xfs_ail_push_all_sync()
	xfs_reclaim_inodes()

Note that there is no xfs_blockgc_flush_all() call in there - it
didn't touch inodes in the working set, just processed inodes
already queued for inactivation work. And in kernels since about
3.10, the xfs_reclaim_inodes() call simply expedited the reclaim
that was going to happen in the background within 5 seconds, so it's
not like this actually changed anything material in terms of inode
cache behaviour.

Indeed, the commit that removed the inode reclaim in 2020 says this:

    For xfs_quiesce_attr() we can just remove the inode reclaim calls as
    they are a historic relic that was required to flush dirty inodes
    that contained unlogged changes. We now log all changes to the
    inodes, so the sync AIL push from xfs_log_quiesce() called by
    xfs_quiesce_attr() will do all the required inode writeback for
    freeze.

IOWs, it was removed because we realised it was redundant and no
longer necessary for correct behaviour of the freeze operation.
That's just normal development process, there was nothing "crazy"
about the old code, it just wasn't necessary anymore.

> But now we obviously leave around blockgc inodes as a side
> effect.

As per above: we have -always done that-. We have never run blockgc
on the current working set of inodes during a freeze. We don't want
to - that will perturb the runtime behaviour of the applications
beyond the freeze operation, and potentially not in a good way.

This is how we've implemented freeze for 20-odd years, and there's
no evidence that it is actually a behaviour that needs changing.
Having a bug in freeze realted to an inode that needs blockgc does
not mean "freeze should leave no inodes in memory that need
blockgc". All it means is that we need to handle inodes that need
blockgc during a freeze in a better way.....

> I think the log is intentionally left dirty (but forced and
> covered) to ensure the snapshot processes unlinked inodes as well (and I
> think there's been a lot of back and forth on that over the years), but
> could be misremembering...

That's a different problem altogether....

> > > It is a big hammer that should be
> > > scheduled with care wrt to any performance sensitive workloads, and
> > > should be minimally disruptive to the system when held for a
> > > non-deterministic/extended amount of time. Departures from that are
> > > either optimizations or extra feature/modifiers that we currently don't
> > > have a great way to control. Just my .02.
> > 
> > <nod> Is there anyone interested in working on adding a mode parameter
> > to FIFREEZE?  What happens if the freeze comes in via the block layer?
> > 
> 
> We'd probably want to audit and maybe try to understand the various use
> cases before getting too far with userspace API (at least defining flags
> anyways). At least I'm not sure I really have a clear view of anything
> outside of the simple snapshot case.

That's what I keep asking: what user problems are these proposed
changes actually trying to solve? Start with use cases, not grand
designs!

> IOW, suppose in theory freeze by default was the biggest hammer possible
> and made the filesystem generally flushed and clean on disk, but then
> grew a flag input for behavior modifiers. What behavior would we modify
> and why?

It was originally defined by the XFS_IOC_FREEZE API on Irix but we
never used it for anything on Linux. We didn't even validate it was
zero, so it really is just a result of a poor API implementation
done 25 years ago. I can see how this sort of little detail is
easily missed in the bigger "port an entire filesystem to a
different OS" picture....

> Would somebody want a NOFLUSH thing that is purely a runtime
> quiesce? Or something inbetween where data and log are flushed, but no
> blockgc scanning or log forcing and so forth? Something else?

No idea what the original intent was.  sync() is the filesystem
integrity flush, freeze is the "on-disk consistent" integrity flush,
and there's not much between those two things that is actually
useful to users, admins and/or applications.

The only thing I've seen proposed for the FIFREEZE argument is a
"timeout" variable to indicate the maximum time the filesystem
should stay frozen for before it automatically thaws itself (i.e. an
anti foot-gun mechanism). That went nowhere because it's just not
possible for admins and applications to use a timeout in a reliable
way...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
