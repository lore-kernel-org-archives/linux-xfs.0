Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 313027CA1
	for <xfs@oss.sgi.com>; Fri,  4 Mar 2016 07:39:03 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8E50EAC004
	for <xfs@oss.sgi.com>; Fri,  4 Mar 2016 05:39:02 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Oq0U4teTHCn4NmLi (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 04 Mar 2016 05:38:58 -0800 (PST)
Date: Fri, 4 Mar 2016 08:38:55 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/3] xfs: optimize bio handling in the buffer writeback
	path
Message-ID: <20160304133854.GB3758@bfoster.bfoster>
References: <1456302011-18915-1-git-send-email-hch@lst.de>
	<1456302011-18915-4-git-send-email-hch@lst.de>
	<20160303151730.GC57990@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160303151730.GC57990@bfoster.bfoster>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Thu, Mar 03, 2016 at 10:17:30AM -0500, Brian Foster wrote:
> On Wed, Feb 24, 2016 at 09:20:11AM +0100, Christoph Hellwig wrote:
> > This patch implements two closely related changes:  First it embedds a
> > bio the ioend structure so that we don't have to allocate one separately.
> > Second it uses the block layer bio chaining mechanism to chain additional
> > bios off this first one if needed instead of manually accouting for
> > multiple bio completions in the ioend structure.  Together this removes a
> > memory allocation per ioend and greatly simplifies the ioend setup and
> > I/O completion path.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/xfs/xfs_aops.c  | 217 ++++++++++++++++++++---------------------------------
> >  fs/xfs/xfs_aops.h  |  15 ++--
> >  fs/xfs/xfs_super.c |  26 ++-----
> >  3 files changed, 93 insertions(+), 165 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> > index fc4fed6..1ea4167 100644
> > --- a/fs/xfs/xfs_aops.c
> > +++ b/fs/xfs/xfs_aops.c
...
> >  	if (xfs_bio_add_buffer(ioend->io_bio, bh) != bh->b_size) {
> > -		xfs_submit_ioend_bio(wbc, ioend, ioend->io_bio);
> > -		ioend->io_bio = NULL;
> > +		/*
> > +		 * No space left in the bio.
> > +		 *
> > +		 * Allocate a new one, and chain the old bio to the new one.
> > +		 * Note that we have to do perform the chaining in this
> > +		 * unintuitive order so that the bi_private linkage is set up
> > +		 * in the right direction for the traversal in
> > +		 * xfs_destroy_ioend().
> > +		 */
> > +		new = bio_alloc(GFP_NOFS, BIO_MAX_PAGES);
> > +		new->bi_iter.bi_sector = bh->b_blocknr * (bh->b_size >> 9);
> > +		new->bi_bdev = bh->b_bdev;
> > +
> > +		bio_chain(ioend->io_bio, new);
> > +		bio_get(ioend->io_bio);	/* for xfs_destroy_ioend */
> > +		submit_bio(wbc->sync_mode == WB_SYNC_ALL ? WRITE_SYNC : WRITE,
> > +				ioend->io_bio);
> > +		ioend->io_bio = new;
> 
> I'm trying to make sure I grok how this works without knowing much about
> the block layer. So we chain the current bio to the new one, the latter
> becoming the parent, and submit the old one. It looks to me that this
> could result in bio_endio() on the parent, which seems fishy... what am
> I missing? IOW, is it safe to submit bios like this before the entire
> chain is created?
> 

Responding to my own question...

Dave pointed out on irc yesterday that the bio chaining does some
reference counting similar to the xfs_ioend to ensure that bi_end_io()
of the parent is never called until the chain is complete. I took a
closer look at the code and managed to convince myself that this should
work fine. When the old bio is chained to the new, the new becomes the
parent and the remaining I/O count is elevated. If the child bio
happens to complete while the parent is still being built, bio_endio()
on the child propagates an error to the parent and calls
bio_remaining_done() on the parent, which drops the extra reference it
held. The parent can still subsequently be chained itself to another bio
or have the XFS bi_end_io() cb set.

One thing I'm a bit suspicious about still is whether the error
propagation is racy. For example, consider we've created two chained
bios A and B, such that A is the parent and thus bio(io_remaining) for
each is A(2) and B(1). Suppose bio A happens to complete first with an
error. A->bi_error is set and bio_endio(A) is called, which IIUC
basically just does A(2)->A(1). If bio B completes successfully,
B->bi_error presumably remains set to 0 and bio_endio(B) is called. The
latter checks that B->bi_end_io == bio_chain_endio, propagates
B->bi_error to A->bi_error unconditionally and then walks up to the
parent bio to drop its reference and finally call A->bi_end_io().

Doesn't this mean that we can potentially lose errors in the chain? I
could easily still be missing something here...

Brian

> >  		goto retry;
> >  	}
> >  
> ...
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index 59c9b7b..33aa638 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> ...
> > @@ -1755,10 +1749,8 @@ xfs_init_zones(void)
> >  	kmem_zone_destroy(xfs_bmap_free_item_zone);
> >   out_destroy_log_ticket_zone:
> >  	kmem_zone_destroy(xfs_log_ticket_zone);
> > - out_destroy_ioend_pool:
> > -	mempool_destroy(xfs_ioend_pool);
> > - out_destroy_ioend_zone:
> > -	kmem_zone_destroy(xfs_ioend_zone);
> > + out_free_ioend_bioset:
> > + 	bioset_free(xfs_ioend_bioset);
> 
> Space before tab ^.
> 
> >   out:
> >  	return -ENOMEM;
> >  }
> > @@ -1784,9 +1776,7 @@ xfs_destroy_zones(void)
> >  	kmem_zone_destroy(xfs_btree_cur_zone);
> >  	kmem_zone_destroy(xfs_bmap_free_item_zone);
> >  	kmem_zone_destroy(xfs_log_ticket_zone);
> > -	mempool_destroy(xfs_ioend_pool);
> > -	kmem_zone_destroy(xfs_ioend_zone);
> > -
> > + 	bioset_free(xfs_ioend_bioset);
> 
> Space before tab ^.
> 
> Brian
> 
> >  }
> >  
> >  STATIC int __init
> > -- 
> > 2.1.4
> > 
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
