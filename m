Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:51342 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751148AbeEVANE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 May 2018 20:13:04 -0400
Date: Tue, 22 May 2018 10:07:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 16/34] iomap: add initial support for writes without
 buffer heads
Message-ID: <20180522000745.GU23861@dastard>
References: <20180518164830.1552-1-hch@lst.de>
 <20180518164830.1552-17-hch@lst.de>
 <20180521232700.GB14384@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180521232700.GB14384@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org

On Mon, May 21, 2018 at 04:27:00PM -0700, Darrick J. Wong wrote:
> On Fri, May 18, 2018 at 06:48:12PM +0200, Christoph Hellwig wrote:
> > For now just limited to blocksize == PAGE_SIZE, where we can simply read
> > in the full page in write begin, and just set the whole page dirty after
> > copying data into it.  This code is enabled by default and XFS will now
> > be feed pages without buffer heads in ->writepage and ->writepages.
> > 
> > If a file system sets the IOMAP_F_BUFFER_HEAD flag on the iomap the old
> > path will still be used, this both helps the transition in XFS and
> > prepares for the gfs2 migration to the iomap infrastructure.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/iomap.c            | 132 ++++++++++++++++++++++++++++++++++++++----
> >  fs/xfs/xfs_iomap.c    |   6 +-
> >  include/linux/iomap.h |   2 +
> >  3 files changed, 127 insertions(+), 13 deletions(-)
> > 
> > diff --git a/fs/iomap.c b/fs/iomap.c
> > index 821671af2618..cd4c563db80a 100644
> > --- a/fs/iomap.c
> > +++ b/fs/iomap.c
> > @@ -314,6 +314,58 @@ iomap_write_failed(struct inode *inode, loff_t pos, unsigned len)
> >  		truncate_pagecache_range(inode, max(pos, i_size), pos + len);
> >  }
> >  
> > +static int
> > +iomap_read_page_sync(struct inode *inode, loff_t block_start, struct page *page,
> > +		unsigned poff, unsigned plen, struct iomap *iomap)
> > +{
> > +	struct bio_vec bvec;
> > +	struct bio bio;
> > +	int ret;
> > +
> > +	bio_init(&bio, &bvec, 1);
> > +	bio.bi_opf = REQ_OP_READ;
> > +	bio.bi_iter.bi_sector = iomap_sector(iomap, block_start);
> > +	bio_set_dev(&bio, iomap->bdev);
> > +	__bio_add_page(&bio, page, plen, poff);
> > +	ret = submit_bio_wait(&bio);
> > +	if (ret < 0 && iomap_block_needs_zeroing(inode, block_start, iomap))
> > +		zero_user(page, poff, plen);
> > +	return ret;
> > +}
> > +
> > +static int
> > +__iomap_write_begin(struct inode *inode, loff_t pos, unsigned len,
> > +		struct page *page, struct iomap *iomap)
> > +{
> > +	loff_t block_size = i_blocksize(inode);
> > +	loff_t block_start = pos & ~(block_size - 1);
> > +	loff_t block_end = (pos + len + block_size - 1) & ~(block_size - 1);
> > +	unsigned poff = block_start & (PAGE_SIZE - 1);
> > +	unsigned plen = min_t(loff_t, PAGE_SIZE - poff, block_end - block_start);
> > +	int status;
> > +
> > +	WARN_ON_ONCE(i_blocksize(inode) < PAGE_SIZE);
> > +
> > +	if (PageUptodate(page))
> > +		return 0;
> > +
> > +	if (iomap_block_needs_zeroing(inode, block_start, iomap)) {
> > +		unsigned from = pos & (PAGE_SIZE - 1), to = from + len;
> > +		unsigned pend = poff + plen;
> > +
> > +		if (poff < from || pend > to)
> > +			zero_user_segments(page, poff, from, to, pend);
> > +	} else {
> > +		status = iomap_read_page_sync(inode, block_start, page,
> > +				poff, plen, iomap);
> 
> Something doesn't smell right here.  The only pages we need to read in
> are the first and last pages in the write_begin range, and only if they
> aren't page aligned and the underlying extent is IOMAP_MAPPED, right?

And not beyond EOF, too.

The bufferhead code handles this via the buffer_new() flag - it
triggers the skipping of read IO and the states in which it is
set are clearly indicated in iomap_to_bh(). That same logic needs to
apply here.

> I also noticed that speculative preallocation kicks in by the second 80M
> write() call and writeback for the second call can successfully allocate
> the entire preallocation, which means that the third (or nth) write call
> can have a real extent already mapped in, and then we end up reading it.

Yeah, that's because there's no check against EOF here. These writes
are all beyond EOF, so there shouldn't be any read at all...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
