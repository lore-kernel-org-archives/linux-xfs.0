Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1466D45953
	for <linux-xfs@vger.kernel.org>; Mon,  5 Feb 2024 22:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707170849; cv=none; b=XqIwxevMzX9FK1jT9U8o/305V6q+/RefiUjCih7Y3UXAuMs1he2UFIQPFVBfmCw6cd9twbbjRcBwgGYoh2m5PnnI8rDQekjhbFvoPLUJPuySkRmcR7hqJefbJkFAnJhCriCownvtET03xG+1+wgPI5INm8npJaWqtiXew7VwXQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707170849; c=relaxed/simple;
	bh=HbF1qcDk1hI/jeBLCQZQMHHo6bfFmwUMgfezXvvvhLU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BJ4V+Fm85PQHpJmDFIXS0irEo0gGu29adbAgXQCb2uGUuNfWmpeONqEr+ibm4CkCoXYxvHwbi6dJWsucGGO48JGQVT8mOpU+VDzb4I2RzB2LbMXbGALZ4go6TR08O9vq/Y0S0UGuVWnCxghm/xxwePY2UO0EPIDGUX8dze1UIsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y0uXbbaq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y0uXbbaq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90266C433C7;
	Mon,  5 Feb 2024 22:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707170848;
	bh=HbF1qcDk1hI/jeBLCQZQMHHo6bfFmwUMgfezXvvvhLU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Y0uXbbaqPcorqRSQ9xd+8bhsC2ZodsyoLZxXGVA5u7OUaQw5l8MIBWgmYF0LuPxhx
	 axrku9mIwbigF7jE4dRJErq7zu6YAN5Q8dw9uDyiphfbjecXCiVx2UhkHRvfxJKKuA
	 VJRdiq9PkGX2bga70o1tf9dKCerR7s3TNX2gJmD+B3DBxZgwrfi1VEzphLGwJ0vldZ
	 oYHXMhECy1Shr6Ss58WhDVIADURErEIb9njmpbPHKiLOJvoIUxkPJgMAWrk+NHNu8c
	 AylTJ6Rls7L7OEhcCLaH+ai32QFE0aE9h/77N71gr0aj6HQcs+WPYG6nh0y2h70qsD
	 jZrbcoWDX+EEw==
Date: Mon, 5 Feb 2024 14:07:27 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Brian Foster <bfoster@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH v2] xfs: run blockgc on freeze to avoid iget stalls
 after reclaim
Message-ID: <20240205220727.GN616564@frogsfrogsfrogs>
References: <20240119193645.354214-1-bfoster@redhat.com>
 <Za3fwLKtjC+B8aZa@dread.disaster.area>
 <ZbJYP63PgykS1CwU@bfoster>
 <ZbLyxHSkE5eCCRRZ@dread.disaster.area>
 <Zbe9+EY5bLjhPPJn@bfoster>
 <Zbrw07Co5vhrDUfd@dread.disaster.area>
 <Zb1FhDn09pwFvE7O@bfoster>
 <20240202233343.GM616564@frogsfrogsfrogs>
 <Zb+1O+MlTpzHZ595@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zb+1O+MlTpzHZ595@bfoster>

On Sun, Feb 04, 2024 at 11:03:07AM -0500, Brian Foster wrote:
> On Fri, Feb 02, 2024 at 03:33:43PM -0800, Darrick J. Wong wrote:
> > On Fri, Feb 02, 2024 at 02:41:56PM -0500, Brian Foster wrote:
> > > On Thu, Feb 01, 2024 at 12:16:03PM +1100, Dave Chinner wrote:
> > > > On Mon, Jan 29, 2024 at 10:02:16AM -0500, Brian Foster wrote:
> > > > > On Fri, Jan 26, 2024 at 10:46:12AM +1100, Dave Chinner wrote:
> > > > > > On Thu, Jan 25, 2024 at 07:46:55AM -0500, Brian Foster wrote:
> > > > > > > On Mon, Jan 22, 2024 at 02:23:44PM +1100, Dave Chinner wrote:
> > > > > > > > On Fri, Jan 19, 2024 at 02:36:45PM -0500, Brian Foster wrote:
> > > ...
> > > > Here's the fixes for the iget vs inactive vs freeze problems in the
> > > > upstream kernel:
> > > > 
> > > > https://lore.kernel.org/linux-xfs/20240201005217.1011010-1-david@fromorbit.com/T/#t
> > > > 
> > > > With that sorted, are there any other issues we know about that
> > > > running a blockgc scan during freeze might work around?
> > > > 
> > > 
> > > The primary motivation for the scan patch was the downstream/stable
> > > deadlock issue. The reason I posted it upstream is because when I
> > > considered the overall behavior change, I thought it uniformly
> > > beneficial to both contexts based on the (minor) benefits of the side
> > > effects of the scan. You don't need me to enumerate them, and none of
> > > them are uniquely important or worth overanalyzing.
> > > 
> > > The only real question that matters here is do you agree with the
> > > general reasoning for a blockgc scan during freeze, or shall I drop the
> > > patch?
> > 
> 
> Hi Darrick,
> 
> > I don't see any particular downside to flushing {block,inode}gc work
> > during a freeze, other than the loss of speculative preallocations
> > sounds painful.
> > 
> 
> Yeah, that's definitely a tradeoff. The more I thought about that, the
> more ISTM that any workload that might be sensitive enough to the
> penalty of an extra blockgc scan, the less likely it's probably going to
> see freeze cycles all that often.
> 
> I suspect the same applies to the bit of extra work added to the freeze
> as well , but maybe there's some more painful scenario..?

<shrug> I suppose if you had a few gigabytes of speculative
preallocations across a bunch of log files (or log structured tree
files, or whatever) then you could lose those preallocations and make
fragmentation worse.  Since blockgc can run on open files, maybe we
should leave that out of the freeze preparation syncfs?

OTOH most of the inodes on those lists are not open at all, so perhaps
we /should/ kick inodegc while preparing for freeze?  Such a patch could
reuse the justification below after s/blockgc/inodegc/.  Too bad we
didn't think far enough into the FIFREEZE design to allow userspace to
indicate if they want us to minimize freeze time or post-freeze
recovery time.

--D

> > Does Dave's patchset to recycle NEEDS_INACTIVE inodes eliminate the
> > stall problem?
> > 
> 
> I assume it does. I think some of the confusion here is that I probably
> would have gone in a slightly different direction on that issue, but
> that's a separate discussion.
> 
> As it relates to this patch, in hindsight I probably should have
> rewritten the commit log from the previous version. If I were to do that
> now, it might read more like this (factoring out sync vs. non-sync
> nuance and whatnot):
> 
> "
> xfs: run blockgc on freeze to keep inodes off the inactivation queues
> 
> blockgc processing is disabled when the filesystem is frozen. This means
> <words words words about blockgc> ...
> 
> Rather than hold pending blockgc inodes in inactivation queues when
> frozen, run a blockgc scan during the freeze sequence to process this
> subset of inodes up front. This allows reclaim to potentially free these
> inodes while frozen (by keeping them off inactive lists) and produces a
> more predictable/consistent on-disk freeze state. The latter is
> potentially beneficial for shapshots, as this means no dangling post-eof
> preallocs or cowblock recovery.
> 
> Potential tradeoffs for this are <yadda yadda, more words from above>
> ...
> "
> 
> ... but again, the primary motivation for this was still the whole
> deadlock thing. I think it's perfectly reasonable to look at this change
> and say it's not worth it. Thanks for the feedback.
> 
> Brian
> 
> > --D
> > 
> > > Brian
> > > 
> > > > -Dave.
> > > > -- 
> > > > Dave Chinner
> > > > david@fromorbit.com
> > > > 
> > > 
> > > 
> > 
> 
> 
