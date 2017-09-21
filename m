Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51235 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751593AbdIUNwE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 21 Sep 2017 09:52:04 -0400
Date: Thu, 21 Sep 2017 09:52:02 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 12/19] xfs: refactor xfs_bmap_add_extent_delay_real
Message-ID: <20170921135202.GB58956@bfoster.bfoster>
References: <20170918152422.24345-1-hch@lst.de>
 <20170918152422.24345-13-hch@lst.de>
 <20170919163525.GJ3487@bfoster.bfoster>
 <20170921132735.GA13541@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170921132735.GA13541@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Thu, Sep 21, 2017 at 03:27:35PM +0200, Christoph Hellwig wrote:
> On Tue, Sep 19, 2017 at 12:35:25PM -0400, Brian Foster wrote:
> > > @@ -2064,12 +2082,12 @@ xfs_bmap_add_extent_delay_real(
> > >  			if (error)
> > >  				goto done;
> > >  		}
> > > -		temp = xfs_bmap_worst_indlen(bma->ip, temp);
> > > -		temp2 = xfs_bmap_worst_indlen(bma->ip, temp2);
> > > -		diff = (int)(temp + temp2 -
> > > -			     (startblockval(PREV.br_startblock) -
> > > -			      (bma->cur ?
> > > -			       bma->cur->bc_private.b.allocated : 0)));
> > > +
> > > +		da_new = startblockval(PREV.br_blockcount) +
> > > +			 startblockval(RIGHT.br_blockcount);
> > 
> > s/br_blockcount/br_startblock/ :)
> 
> Yes.  And I've officially lost all faith in xfstests ever even testing
> this case in xfs_bmap_add_extent_delay_real at all.
> 
> I think it should be really easily testable by creating a large
> delalloc reservation and then fsyncing out the middle of it.
> Except of course we don't have a range fsync, and even then the
> writeback code might cluster it.  I might have to come up with
> a special kernel module to even reproduce this reliably..

What about creating a DEBUG mode option and/or an error injection tag
that allows for random partial extent allocation rather than the current
behavior of attempting to allocate the whole delalloc extent? E.g.,
could we "randomly" trim the ends of the delalloc extent looked up at
writeback time such that what we alloc it is smaller than the full
delalloc extent, but still large enough to satisfy the writeback? The
ideal result would be some combination of full allocs, some that trigger
either the left or right filling cases and some that trigger the
!LEFT_FILLING && !RIGHT_FILLING case. A bit hacky, but perhaps a test
could then use dio reads or something to induce ranged writebacks.

Brian
