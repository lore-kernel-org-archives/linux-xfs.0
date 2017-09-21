Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:50137 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751387AbdIUN1g (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 21 Sep 2017 09:27:36 -0400
Date: Thu, 21 Sep 2017 15:27:35 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 12/19] xfs: refactor xfs_bmap_add_extent_delay_real
Message-ID: <20170921132735.GA13541@lst.de>
References: <20170918152422.24345-1-hch@lst.de> <20170918152422.24345-13-hch@lst.de> <20170919163525.GJ3487@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170919163525.GJ3487@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Tue, Sep 19, 2017 at 12:35:25PM -0400, Brian Foster wrote:
> > @@ -2064,12 +2082,12 @@ xfs_bmap_add_extent_delay_real(
> >  			if (error)
> >  				goto done;
> >  		}
> > -		temp = xfs_bmap_worst_indlen(bma->ip, temp);
> > -		temp2 = xfs_bmap_worst_indlen(bma->ip, temp2);
> > -		diff = (int)(temp + temp2 -
> > -			     (startblockval(PREV.br_startblock) -
> > -			      (bma->cur ?
> > -			       bma->cur->bc_private.b.allocated : 0)));
> > +
> > +		da_new = startblockval(PREV.br_blockcount) +
> > +			 startblockval(RIGHT.br_blockcount);
> 
> s/br_blockcount/br_startblock/ :)

Yes.  And I've officially lost all faith in xfstests ever even testing
this case in xfs_bmap_add_extent_delay_real at all.

I think it should be really easily testable by creating a large
delalloc reservation and then fsyncing out the middle of it.
Except of course we don't have a range fsync, and even then the
writeback code might cluster it.  I might have to come up with
a special kernel module to even reproduce this reliably..
