Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:52712 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753811AbdBDJyf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 4 Feb 2017 04:54:35 -0500
Date: Sat, 4 Feb 2017 10:54:34 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/4] xfs: improve handling of busy extents in the
        low-level allocator
Message-ID: <20170204095434.GB18472@lst.de>
References: <1485715421-17182-1-git-send-email-hch@lst.de> <1485715421-17182-3-git-send-email-hch@lst.de> <20170203152233.GC45388@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170203152233.GC45388@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Fri, Feb 03, 2017 at 10:22:33AM -0500, Brian Foster wrote:
> Not a big deal, but perhaps in the above two cases where we're
> traversing the bnobt, just track the max busy gen and use that being set
> non-zero to trigger (hopefully) fewer flushes rather than being subject
> to whatever the last value was? Then we don't have to do the 'busy |=
> ..' thing either. That doesn't cover the overflow case, but that should
> be rare and we still have the retry.

It would hang for the overflow case, been there done that.  Note that
we only rety if we failed the allocation anyway, so it won't actually
trigger any less flushes either.

> > +out:
> >  	spin_unlock(&args->pag->pagb_lock);
> >  
> > -	if (fbno != bno || flen != len) {
> > -		trace_xfs_extent_busy_trim(args->mp, args->agno, bno, len,
> > +	if (fbno != *bno || flen != *len) {
> > +		trace_xfs_extent_busy_trim(args->mp, args->agno, *bno, *len,
> >  					  fbno, flen);
> > +		*bno = fbno;
> > +		*len = flen;
> > +		*busy_gen = args->pag->pagb_gen;
> > +		return true;
> 
> We've already dropped pagb_lock by the time we grab pagb_gen. What
> prevents this from racing with a flush and pagb_gen bump and returning a
> gen value that might not have any associated busy extents?

Good point.  I though I had moved the lock around but obviously
didn't.  I'll fix it up for the next version.

> > +	while (busy_gen == READ_ONCE(pag->pagb_gen)) {
> > +		prepare_to_wait(&pag->pagb_wait, &wait, TASK_KILLABLE);
> > +		schedule();
> >  	}
> > +	finish_wait(&pag->pagb_wait, &wait);
> 
> This seems racy. Shouldn't this do something like:
> 
> 	do {
> 		prepare_to_wait();
> 		if (busy_gen != pagb_gen)
> 			break;
> 		schedule();
> 		finish_wait();
> 	} while (1);
> 	finish_wait();
> 
> ... to make sure we don't lose a wakeup between setting the task state
> and actually scheduling out?

Yes, will fix.

> > +++ b/fs/xfs/xfs_mount.h
> > @@ -384,6 +384,8 @@ typedef struct xfs_perag {
> >  	xfs_agino_t	pagl_rightrec;
> >  	spinlock_t	pagb_lock;	/* lock for pagb_tree */
> >  	struct rb_root	pagb_tree;	/* ordered tree of busy extents */
> > +	unsigned int	pagb_gen;
> > +	wait_queue_head_t pagb_wait;
> 
> Can we add some comments here similar to the other fields?

Sure.

> Also, how
> about slightly more informative names... pagb_discard_[gen|wait], or
> pagb_busy_*?

That's what I had first - but:

 - pagb is the short name for the pag busy tree and I wanted to
   follow that convention.  And with the current series we also
   use the wakeup code for normal busy extents, even without discards.
