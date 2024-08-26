Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C18E194A6B
	for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2024 16:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724689255; cv=none; b=bDoGoATGJFGwgRbY+O3V55yUqrNPL0+d/JBainvUw80GfqE7+s/LESWfsYSv2aLdN4z8SNPFzmzB7T/w9YF34+BqXWVV6EUKdUpVMMzGKO5V6V/N4FFogUqwtL4+TW9JICZu6RNxQDf3QezJV2rCuErAo8FMQ7kn0FM+LKO4nWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724689255; c=relaxed/simple;
	bh=ch2Etf6YmHaS9y3FPYswQhO9MKhYMLm0Mp/4LpQnah0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aEtHQSZmCrqQir8Uhw5zpge/8IaAYlkNAclOdkKZyXna2redU9dSyKaCntderhgMg+nnty02BlI3FUgC3FQ4kQxNhWdAJhEiEdz8NpSLJ3DspAtA0EG+sb+u8eKaVpz26+vP2qMpsl/DaW1IGO4EcrNWM7hFk7lXnDZ/+NyLDOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Evvw1Mjd; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Evvw1Mjd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724689252;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=p1LjrpKcP7UYBoQzong09jX9UWGXwu2iSaP3XjmBMtY=;
	b=Evvw1MjdLuqcKJXbwNw0YrNueutNtTCBp4MSyFz+1czhpF5zPSPdgqV5YZg6VwcpmcmXam
	H58GdXW0qAm6X4f3hXRkggT2p/kYO+mQIUxn/KJjkKrPy0gnNAhJE55MNdOiDzWpo+/O5K
	+FeiZQ0/ayI4GGJ2yVCQV+TpB/j3BWs=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-76-0aVmVSrPMS6fz83M7u40TA-1; Mon,
 26 Aug 2024 12:20:50 -0400
X-MC-Unique: 0aVmVSrPMS6fz83M7u40TA-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2E7061955BEF;
	Mon, 26 Aug 2024 16:20:49 +0000 (UTC)
Received: from bfoster (unknown [10.22.32.22])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4F7E9300019C;
	Mon, 26 Aug 2024 16:20:48 +0000 (UTC)
Date: Mon, 26 Aug 2024 12:21:44 -0400
From: Brian Foster <bfoster@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: skip background cowblock trims on inodes open for
 write
Message-ID: <ZsyrmMqEgmgauZcW@bfoster>
References: <20240214165231.84925-1-bfoster@redhat.com>
 <20240224020554.GP6226@frogsfrogsfrogs>
 <Zdyw8i6/DTEgojqm@bfoster>
 <20240226193921.GM616564@frogsfrogsfrogs>
 <ZdzxBr3daNUHwlxg@bfoster>
 <20240823012447.GX6082@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240823012447.GX6082@frogsfrogsfrogs>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Thu, Aug 22, 2024 at 06:24:47PM -0700, Darrick J. Wong wrote:
> On Mon, Feb 26, 2024 at 03:13:58PM -0500, Brian Foster wrote:
> > On Mon, Feb 26, 2024 at 11:39:21AM -0800, Darrick J. Wong wrote:
> > > On Mon, Feb 26, 2024 at 10:40:34AM -0500, Brian Foster wrote:
> > > > On Fri, Feb 23, 2024 at 06:05:54PM -0800, Darrick J. Wong wrote:
> > > > > On Wed, Feb 14, 2024 at 11:52:31AM -0500, Brian Foster wrote:
> > > > > > The background blockgc scanner runs on a 5m interval by default and
> > > > > > trims preallocation (post-eof and cow fork) from inodes that are
> > > > > > otherwise idle. Idle effectively means that iolock can be acquired
> > > > > > without blocking and that the inode has no dirty pagecache or I/O in
> > > > > > flight.
> > > > > > 
> > > > > > This simple mechanism and heuristic has worked fairly well for
> > > > > > post-eof speculative preallocations. Support for reflink and COW
> > > > > > fork preallocations came sometime later and plugged into the same
> > > > > > mechanism, with similar heuristics. Some recent testing has shown
> > > > > > that COW fork preallocation may be notably more sensitive to blockgc
> > > > > > processing than post-eof preallocation, however.
> > > > > > 
> > > > > > For example, consider an 8GB reflinked file with a COW extent size
> > > > > > hint of 1MB. A worst case fully randomized overwrite of this file
> > > > > > results in ~8k extents of an average size of ~1MB. If the same
> > > > > > workload is interrupted a couple times for blockgc processing
> > > > > > (assuming the file goes idle), the resulting extent count explodes
> > > > > > to over 100k extents with an average size <100kB. This is
> > > > > > significantly worse than ideal and essentially defeats the COW
> > > > > > extent size hint mechanism.
> > > > > > 
> > > > > > While this particular test is instrumented, it reflects a fairly
> > > > > > reasonable pattern in practice where random I/Os might spread out
> > > > > > over a large period of time with varying periods of (in)activity.
> > > > > > For example, consider a cloned disk image file for a VM or container
> > > > > > with long uptime and variable and bursty usage. A background blockgc
> > > > > > scan that races and processes the image file when it happens to be
> > > > > > clean and idle can have a significant effect on the future
> > > > > > fragmentation level of the file, even when still in use.
> > > > > > 
> > > > > > To help combat this, update the heuristic to skip cowblocks inodes
> > > > > > that are currently opened for write access during non-sync blockgc
> > > > > > scans. This allows COW fork preallocations to persist for as long as
> > > > > > possible unless otherwise needed for functional purposes (i.e. a
> > > > > > sync scan), the file is idle and closed, or the inode is being
> > > > > > evicted from cache.
> > > > > 
> > > > > Hmmm.  Thinking this over a bit more, I wonder if we really want this
> > > > > heuristic?
> > > > > 
> > > > > If we're doing our periodic background scan then sure, I think it's ok
> > > > > to ignore files that are open for write but aren't actively being
> > > > > written to.
> > > > > 
> > > > > This might introduce nastier side effects if OTOH we're doing blockgc
> > > > > because we've hit ENOSPC and we're trying to free up any blocks that we
> > > > > can.  I /think/ the way you've written the inode_is_open_for_write check
> > > > > means that we scan maximally for ENOSPC.
> > > > > 
> > > > 
> > > > The intent of the patch was to limit the scope of the heuristic to
> > > > the background (non-sync) scan where there are no real guarantees or
> > > > predictability. Otherwise I would expect a sync scan to bypass the
> > > > heuristic and prioritize the need to free space.
> > > > 
> > > > This is similar to the existing dirty pagecache check for eofblocks
> > > > inodes, but I notice that the same check for cowblocks inodes doesn't
> > > > seem to care about the type of scan. I suppose one thing to consider for
> > > > why that might not matter that much is that IIRC usually this sort of
> > > > -ENOSPC handling is preceded by a full fs flush, which probably reduces
> > > > the significance of a sync check filter (or lack thereof).
> > > > 
> > > > > However, xfs_blockgc_free_dquots doesn't seem to do synchronous scans
> > > > > for EDQUOT.  So if we hit quota limits, we won't free maximally, right?
> > > > > OTOH I guess we don't really do that now either, so maybe it doesn't
> > > > > matter?
> > > > > 
> > > > > <shrug> Thoughts?
> > > > > 
> > > > 
> > > > Yeah, it seems like it depends on the calling context. I.e.,
> > > > xfs_file_buffered_write() -> xfs_blockgc_free_quota() passes the sync
> > > > flag for the -EDQUOT case. That case doesn't invoke a flush for -EDQUOT
> > > > since it's a a specific quota failure, so ISTM this isn't that much of a
> > > > departure from the existing heuristic (which skips cowblocks inodes that
> > > > are dirty). Is there a case I'm missing?
> > > 
> > > Not that I can think of.  The SYNC/!SYNC decision is entirely based on
> > > the caller's state, which (ime) makes me think harder any time I have to
> > > reason about the {block,inode}gc function calls.
> > > 
> > 
> > Not sure what you mean by caller state, but I kind of just view it as a
> > poorly named force scan (not that that's a better name). All that really
> > matters in this context is the non-force/sync/wait mode that is run by
> > the background scanner. Nothing prevents userspace from running a sync
> > scan via ioctl() whenever, so it's hard to assume behavior.
> > 
> > Also just a random thought.. you could consider something like a FLUSH
> > flag (and/or scan) if you wanted to be more selectively aggressive for
> > any of the -EDQUOT handling cases.
> > 
> > > > The question that comes to mind to me is whether those dirty checks in
> > > > xfs_prep_free_cowblocks() are more of a correctness thing than a
> > > > heuristic..? For example, is that to prevent races between things like
> > > > writes allocating some cowblocks and blockgc coming along and removing
> > > > them before I/O completes, which actually expects them to exist for
> > > > remapping? If so, I suppose that would make me want to tweak the change
> > > > a bit to perhaps make the open check first and combine the comments to
> > > > better explain what is heuristic and what is rule, but that's only if we
> > > > want to keep the patch..
> > > 
> > > The dirty/writeback flag testing in xfs_prep_free_cowblocks exists for
> > > correctness -- any time there's live cow staging blocks (as opposed to
> > > speculative preallocations) it skips that inode.
> > > 
> > 
> > Thanks, makes sense. With that, I'd make _prep_free_cowblocks() look
> > more something like:
> 
> I think we were talking about xfs_prep_free_cowblocks, right?
> 

Yeah, IIRC.

> >         /*
> >          * A cowblocks trim of an inode can have a significant effect on
> >          * fragmentation even when a reasonable COW extent size hint is set.
> >          * Therefore, we prefer to not process cowblocks unless they are clean
> >          * and idle. We can never process a cowblocks inode that is dirty or has
> >          * in-flight I/O under any circumstances, because outstanding writeback
> >          * or dio expects targeted COW fork blocks exist through write
> >          * completion where they can be remapped into the data fork.
> >          *
> >          * Therefore, the heuristic used here is to never process inodes
> >          * currently opened for write from background (i.e. non-sync) scans. For
> >          * sync scans, use the pagecache/dio state of the inode to ensure we
> >          * never free COW fork blocks out from under pending I/O.
> >          */
> >         if (!sync && inode_is_open_for_write(VFS_I(ip)))
> >                 return false;
> >         if ((VFS_I(ip)->i_state & I_DIRTY_PAGES) ||
> >             mapping_tagged(VFS_I(ip)->i_mapping, PAGECACHE_TAG_DIRTY) ||
> >             mapping_tagged(VFS_I(ip)->i_mapping, PAGECACHE_TAG_WRITEBACK) ||
> >             atomic_read(&VFS_I(ip)->i_dio_count))
> >                 return false;
> > 
> > ... but again, not clear to me if upstream wants the patch or not. v2 or
> > shall I drop it?
> 
> I think it's a useful heuristic for background blockgc not to clear
> speculative cow preallocations on files that are open for write, even if
> there's no contention on the IOLOCK for that file.  Maybe it's time to
> get that moving again, along with the post-eof block handling revamp?
> 
> (Sorry it took me 6 months to reply to this...)
> 

No problem. I'll follow up with a v2 once I get a chance to page back in
where I was at with this and review any pending tweaks we were
discussing...

Brian

> --D
> 
> > Brian
> > 
> > > --D
> > > 
> > > > Brian
> > > > 
> > > > > --D
> > > > > 
> > > > > > Suggested-by: Darrick Wong <djwong@kernel.org>
> > > > > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > > > > ---
> > > > > > 
> > > > > > This fell out of some of the discussion on a prospective freeze time
> > > > > > blockgc scan. I ran this through the same random write test described in
> > > > > > that thread and it prevented all cowblocks trimming until the file is
> > > > > > released.
> > > > > > 
> > > > > > Brian
> > > > > > 
> > > > > > [1] https://lore.kernel.org/linux-xfs/ZcutUN5B2ZCuJfXr@bfoster/
> > > > > > 
> > > > > >  fs/xfs/xfs_icache.c | 20 +++++++++++++++++---
> > > > > >  1 file changed, 17 insertions(+), 3 deletions(-)
> > > > > > 
> > > > > > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > > > > > index dba514a2c84d..d7c54e45043a 100644
> > > > > > --- a/fs/xfs/xfs_icache.c
> > > > > > +++ b/fs/xfs/xfs_icache.c
> > > > > > @@ -1240,8 +1240,13 @@ xfs_inode_clear_eofblocks_tag(
> > > > > >   */
> > > > > >  static bool
> > > > > >  xfs_prep_free_cowblocks(
> > > > > > -	struct xfs_inode	*ip)
> > > > > > +	struct xfs_inode	*ip,
> > > > > > +	struct xfs_icwalk	*icw)
> > > > > >  {
> > > > > > +	bool			sync;
> > > > > > +
> > > > > > +	sync = icw && (icw->icw_flags & XFS_ICWALK_FLAG_SYNC);
> > > > > > +
> > > > > >  	/*
> > > > > >  	 * Just clear the tag if we have an empty cow fork or none at all. It's
> > > > > >  	 * possible the inode was fully unshared since it was originally tagged.
> > > > > > @@ -1262,6 +1267,15 @@ xfs_prep_free_cowblocks(
> > > > > >  	    atomic_read(&VFS_I(ip)->i_dio_count))
> > > > > >  		return false;
> > > > > >  
> > > > > > +	/*
> > > > > > +	 * A full cowblocks trim of an inode can have a significant effect on
> > > > > > +	 * fragmentation even when a reasonable COW extent size hint is set.
> > > > > > +	 * Skip cowblocks inodes currently open for write on opportunistic
> > > > > > +	 * blockgc scans.
> > > > > > +	 */
> > > > > > +	if (!sync && inode_is_open_for_write(VFS_I(ip)))
> > > > > > +		return false;
> > > > > > +
> > > > > >  	return true;
> > > > > >  }
> > > > > >  
> > > > > > @@ -1291,7 +1305,7 @@ xfs_inode_free_cowblocks(
> > > > > >  	if (!xfs_iflags_test(ip, XFS_ICOWBLOCKS))
> > > > > >  		return 0;
> > > > > >  
> > > > > > -	if (!xfs_prep_free_cowblocks(ip))
> > > > > > +	if (!xfs_prep_free_cowblocks(ip, icw))
> > > > > >  		return 0;
> > > > > >  
> > > > > >  	if (!xfs_icwalk_match(ip, icw))
> > > > > > @@ -1320,7 +1334,7 @@ xfs_inode_free_cowblocks(
> > > > > >  	 * Check again, nobody else should be able to dirty blocks or change
> > > > > >  	 * the reflink iflag now that we have the first two locks held.
> > > > > >  	 */
> > > > > > -	if (xfs_prep_free_cowblocks(ip))
> > > > > > +	if (xfs_prep_free_cowblocks(ip, icw))
> > > > > >  		ret = xfs_reflink_cancel_cow_range(ip, 0, NULLFILEOFF, false);
> > > > > >  	return ret;
> > > > > >  }
> > > > > > -- 
> > > > > > 2.42.0
> > > > > > 
> > > > > 
> > > > 
> > > > 
> > > 
> > 
> 

