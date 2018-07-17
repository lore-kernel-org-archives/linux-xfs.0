Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:22935 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729759AbeGQXsf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Jul 2018 19:48:35 -0400
Date: Wed, 18 Jul 2018 09:13:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/6] xfs: avoid COW fork extent lookups in writeback if
 the fork didn't change
Message-ID: <20180717231338.GB19934@dastard>
References: <20180712134910.30298-1-hch@lst.de>
 <20180712134910.30298-7-hch@lst.de>
 <20180714000301.GY19934@dastard>
 <20180717133710.GA15892@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180717133710.GA15892@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Tue, Jul 17, 2018 at 03:37:10PM +0200, Christoph Hellwig wrote:
> On Sat, Jul 14, 2018 at 10:03:01AM +1000, Dave Chinner wrote:
> > >  	if (imap_valid &&
> > > -	    (!xfs_inode_has_cow_data(ip) || wpc->io_type == XFS_IO_COW))
> > > +	    (!xfs_inode_has_cow_data(ip) ||
> > > +	     wpc->io_type == XFS_IO_COW ||
> > > +	     wpc->cow_seq == ip->i_cowfp->if_seq))
> > >  		return 0;
> > 
> > Isn't this racy? It's not an atomic variable, we hold no locks,
> > there are no memory barriers, etc. Hence we can miss changes made by
> > concurrent mapping changes...
> > 
> > Which makes me ask - is the sequence number bumped before or after
> > we modify the extent map? It seems to me that it needs to be done
> > before we make a modification so that we invalidate the current map
> > before we change the extent map to avoid issuing IO to an extent map
> > we are know we changing, right?
> 
> Right now they are bumped later, but they really should be first.
> 
> I've got a series that bumps them first now.

Cool.

> That being said at least for the COW fork I don't think we care
> about the races too much.  All the actual updates to the COW fork
> are under the page lock, so for a given page we are synchronized
> already.  And for the bigger picture we either convert a COW
> fork to a real fork, in which case the change doesn't matter, or
> we drop it, in which case we already have higher level synchronization.

Ok.

> 
> For the data fork things might be more nasty, and that could explain
> why my trivial extension to that just didn't work at all..

Yeah, my patch was catching data fork modifications as well.
IIRC I ended up putting the seqno bump and checks under the
ip->i_flags_lock as a quick method of serialising updates, and that
made the update vs check races go away. It didn't make all the
problems go away - just the ones that were easy to reproduce - but
those remaining bugs may have been in other parts of the patchset
that I never got to the bottom of...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
