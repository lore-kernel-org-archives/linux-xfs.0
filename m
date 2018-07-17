Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:51443 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731324AbeGQOHT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 17 Jul 2018 10:07:19 -0400
Date: Tue, 17 Jul 2018 15:37:10 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 6/6] xfs: avoid COW fork extent lookups in writeback if
        the fork didn't change
Message-ID: <20180717133710.GA15892@lst.de>
References: <20180712134910.30298-1-hch@lst.de> <20180712134910.30298-7-hch@lst.de> <20180714000301.GY19934@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180714000301.GY19934@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Sat, Jul 14, 2018 at 10:03:01AM +1000, Dave Chinner wrote:
> >  	if (imap_valid &&
> > -	    (!xfs_inode_has_cow_data(ip) || wpc->io_type == XFS_IO_COW))
> > +	    (!xfs_inode_has_cow_data(ip) ||
> > +	     wpc->io_type == XFS_IO_COW ||
> > +	     wpc->cow_seq == ip->i_cowfp->if_seq))
> >  		return 0;
> 
> Isn't this racy? It's not an atomic variable, we hold no locks,
> there are no memory barriers, etc. Hence we can miss changes made by
> concurrent mapping changes...
> 
> Which makes me ask - is the sequence number bumped before or after
> we modify the extent map? It seems to me that it needs to be done
> before we make a modification so that we invalidate the current map
> before we change the extent map to avoid issuing IO to an extent map
> we are know we changing, right?

Right now they are bumped later, but they really should be first.

I've got a series that bumps them first now.

That being said at least for the COW fork I don't think we care
about the races too much.  All the actual updates to the COW fork
are under the page lock, so for a given page we are synchronized
already.  And for the bigger picture we either convert a COW
fork to a real fork, in which case the change doesn't matter, or
we drop it, in which case we already have higher level synchronization.

For the data fork things might be more nasty, and that could explain
why my trivial extension to that just didn't work at all..
