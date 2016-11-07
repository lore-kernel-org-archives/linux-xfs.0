Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:57034 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932119AbcKGPIJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 7 Nov 2016 10:08:09 -0500
Date: Mon, 7 Nov 2016 16:08:07 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 4/5] iomap: implement direct I/O
Message-ID: <20161107150807.GA10865@lst.de>
References: <1478276479-10749-1-git-send-email-hch@lst.de> <1478276479-10749-5-git-send-email-hch@lst.de> <20161106224049.GP14023@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161106224049.GP14023@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, axboe@fb.com, kent.overstreet@gmail.com, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org

On Mon, Nov 07, 2016 at 09:40:49AM +1100, Dave Chinner wrote:
> > +	case IOMAP_HOLE:
> > +		/*
> > +		 * We return -ENOTBLK to fall back to buffered I/O for file
> > +		 * systems that can't fill holes from direct writes.
> > +		 */
> > +		if (dio->flags & IOMAP_DIO_WRITE)
> > +			return -ENOTBLK;
> > +		/*FALLTHRU*/
> 
> This is preventing direct IO writes from being done into holes for
> all filesystems.

It's not.  Hint:  the whole iomap code very much assumes a file system
fills holes before applying the actor on writes.

That being said I should remove this check - as-is it's dead, untested
code that I only used for my aborted ext2 conversion, so we're better
off not having it.

> > +	iov_iter_truncate(&iter, length);
> 
> Won't this truncate the entire DIO down to the length of the first
> extent that is mapped? 

It truncates a copy of the main iter down to the length of the extent
we're working on.  That allows us to limit all the iov_iter based helper
(most importantly get_user_pages) to only operate on a given extent.
Later in the function we then advance the primary iter when moving to
the next extent.

> 
> > +	if (may_zero) {
> > +		pad = pos & (fs_block_size - 1);
> > +		if (pad)
> > +			iomap_dio_zero(dio, iomap, pos, fs_block_size - pad);
> > +	}
> 
> Repeated zeroing code. helper function?

The actual repeated code is in iomap_dio_zero.  Because we once zero
the beginning of a block and once the end the arithmetics looks somewhat
similar but actually are different. We could do a trick like the end
parameter to dio_zero_block in the old dio code to save a line of code
or two, but I think it's highly confusing to the reader.

> > +	do {
> > +		ret = iomap_apply(inode, pos, count, flags, ops, dio,
> > +				iomap_dio_actor);
> > +		if (ret <= 0) {
> > +			/* magic error code to fall back to buffered I/O */
> > +			if (ret == -ENOTBLK)
> > +				ret = 0;
> > +			break;
> > +		}
> > +		pos += ret;
> > +	} while ((count = iov_iter_count(iter)) > 0);
> > +	blk_finish_plug(&plug);
> > +
> > +	if (ret < 0)
> > +		cmpxchg(&dio->error, 0, ret);
> 
> Why cmpxchg? What are we racing with here? Helper (e.g.
> dio_set_error())?

The submission thread against I/O completions (which in the worst
case could come from multiple threads as well).  Same reason as
the one in xfs_buf_bio_end_io added in commit 9bdd9bd69b
("xfs: buffer ->bi_end_io function requires irq-safe lock")

> Comment decribing use?

Sure.

> Comment on the context the new flags are used under and what they
> mean?

Ok.
