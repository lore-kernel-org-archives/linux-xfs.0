Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:54182 "EHLO
        ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753944AbcLTVpf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Dec 2016 16:45:35 -0500
Date: Wed, 21 Dec 2016 08:45:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/4] xfs: fix bogus minleft manipulations
Message-ID: <20161220214532.GR4326@dastard>
References: <1481644767-9098-1-git-send-email-hch@lst.de>
 <1481644767-9098-2-git-send-email-hch@lst.de>
 <20161214173507.GA24645@bfoster.bfoster>
 <20161214193626.GA12106@lst.de>
 <20161214215133.GA26688@bfoster.bfoster>
 <20161215143430.GB29477@bfoster.bfoster>
 <20161219113826.GA26535@lst.de>
 <20161220141747.GA25290@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161220141747.GA25290@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, eguan@redhat.com, darrick.wong@oracle.com

On Tue, Dec 20, 2016 at 09:17:47AM -0500, Brian Foster wrote:
> On Mon, Dec 19, 2016 at 12:38:26PM +0100, Christoph Hellwig wrote:
> > On Thu, Dec 15, 2016 at 09:34:33AM -0500, Brian Foster wrote:
> > > FWIW, I was playing with this a bit more and managed to manufacture a
> > > filesystem layout that this series doesn't handle too well. Emphasis on
> > > "manufactured" because this might not be a likely real world scenario,
> > > but either way the current code handles it fine.
> > 
> > It does, although mostly by accident.  I suspect with an even better
> > manufcatured image you could also drive the current code to it's knees,
> > e.g. only have one single block free in the first few AGs, and then
> > a small number just higher than that in a higher AG.
> > 
> 
> Perhaps, I certainly wouldn't expect the code in current form to be
> perfect. It's hard enough to understand as it is. Just trying to avoid
> regressions and properly scope the required fix...
> 
> > > I've attached a metadump of the offending image. mdestore it, mount and
> > > attempt something like 'dd if=/dev/zero of=/mnt/file' on the root. The
> > > buffered write looks like it's in a livelock, waiting indefinitely for a
> > > writeback cycle that will never complete...
> > 
> > Yeah, that's the loop that keeps going even if it can't allocate any
> > blocks, which seems generally bogus.  But even without that we'd get
> > ENOSPC despite not having a reservations. Which is a little easier to
> > debug, but just as wrong.
> > 
> 
> Indeed.
> 
> > The only good way out I can see is to not hand out any more reservations
> > after we only nave nr_ags * xfs_bmap_worst_indlen(1) available.  I'll
> > see if I can come up with a patch for that.
> 
> Hmm, so the idea is to basically find a way we can infer accurate
> information about the per-AG state at the time blocks are reserved from
> the global pool (i.e., buffered write time) and cut off writes at the
> point we can no longer guarantee at least one AG can satisfy the
> smallest write..?

We already do this for per-AG freelist minimum space requirements.
See XFS_ALLOC_AGFL_RESERVE and the big comment above
xfs_alloc_set_aside().

What's worth noting is that xfs_alloc_set_aside() has a magic number
of "4" added to it, which is supposedly for the bmbt split that
might be needed. This is applied at delalloc space reservation time,
so this would seem to me to be the place to hook into here.

I do see a problem here, though - it's only reserving space for a
single BMBT split from the global free space pool. This is fine for
the AGFL reservations (as they are static and fixed in size), but
maybe this is where we are over-committing the freespace pool...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
