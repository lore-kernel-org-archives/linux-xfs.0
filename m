Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60314 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750926AbdBAOd5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 1 Feb 2017 09:33:57 -0500
Date: Wed, 1 Feb 2017 09:33:51 -0500
From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: error propagation problem on xfs over dm stripe
Message-ID: <20170201143351.GA18848@redhat.com>
References: <b44b5dc2-eac0-cd40-6de8-b615cb4dece8@sandeen.net>
 <20170201074249.GA22669@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170201074249.GA22669@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs <linux-xfs@vger.kernel.org>, dm-devel@redhat.com

On Wed, Feb 01 2017 at  2:42am -0500,
Christoph Hellwig <hch@infradead.org> wrote:

> On Tue, Jan 31, 2017 at 09:12:07PM -0600, Eric Sandeen wrote:
> > diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> > index 3086da5..3555ba8 100644
> > --- a/drivers/md/dm.c
> > +++ b/drivers/md/dm.c
> > @@ -808,7 +808,9 @@ static void dec_pending(struct dm_io *io, int error)
> >  		} else {
> >  			/* done with normal IO or empty flush */
> >  			trace_block_bio_complete(md->queue, bio, io_error);
> > -			bio->bi_error = io_error;
> > +			/* don't overwrite or clear existing errors */
> > +			if (!bio->bi_error)
> > +				bio->bi_error = io_error;
> >  			bio_endio(bio);
> >  		}
> >  	}
> > 
> > but Mike was a little uneasy, not knowing for sure how we got here to
> > overwrite this bio's error (hopefully I'm representing his concerns
> > fairly and correctly).

Well that is just it, I'm not seeing how io_error (io->error) can ever
transition from non-zero to zero.  And bio->bi_error shouldn't be set
without having first set io->error.  But just cause I cannot see it
doesn't change the fact that it is clearly happening to you.

It does concern me that this kind of fundamental error propagation
change is needed.  Speaks to a regression.  Would be nice to bisect
this.. Eric? ;)
 
> FYI, what we do both in the XFS buffer cache and the new direct I/O
> code is to use a
> 
> 	        cmpxchg(&dio->error, 0, ret);
> 
> in a similar situation, which should work here, too.

What is the benefit?  Faster than the conditional?
