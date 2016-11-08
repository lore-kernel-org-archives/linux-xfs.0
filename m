Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:18099 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752225AbcKHBkF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Nov 2016 20:40:05 -0500
Date: Tue, 8 Nov 2016 12:38:05 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/5] iomap: implement direct I/O
Message-ID: <20161108013805.GA28922@dastard>
References: <1478276479-10749-1-git-send-email-hch@lst.de>
 <1478276479-10749-5-git-send-email-hch@lst.de>
 <20161106224049.GP14023@dastard>
 <20161107150807.GA10865@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161107150807.GA10865@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, axboe@fb.com, kent.overstreet@gmail.com, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org

On Mon, Nov 07, 2016 at 04:08:07PM +0100, Christoph Hellwig wrote:
> On Mon, Nov 07, 2016 at 09:40:49AM +1100, Dave Chinner wrote:
> > > +	case IOMAP_HOLE:
> > > +		/*
> > > +		 * We return -ENOTBLK to fall back to buffered I/O for file
> > > +		 * systems that can't fill holes from direct writes.
> > > +		 */
> > > +		if (dio->flags & IOMAP_DIO_WRITE)
> > > +			return -ENOTBLK;
> > > +		/*FALLTHRU*/
> > 
> > This is preventing direct IO writes from being done into holes for
> > all filesystems.
> 
> It's not.  Hint:  the whole iomap code very much assumes a file system
> fills holes before applying the actor on writes.
> 
> That being said I should remove this check - as-is it's dead, untested
> code that I only used for my aborted ext2 conversion, so we're better
> off not having it.

Yup, agreed.

> > > +	iov_iter_truncate(&iter, length);
> > 
> > Won't this truncate the entire DIO down to the length of the first
> > extent that is mapped? 
> 
> It truncates a copy of the main iter down to the length of the extent
> we're working on.  That allows us to limit all the iov_iter based helper
> (most importantly get_user_pages) to only operate on a given extent.
> Later in the function we then advance the primary iter when moving to
> the next extent.

Hmmm, I must be missing something here. iomap_dio_rw() stores a
pointer to the primary iter in the dio structure, and that gets
passed to the actor function, and then it....

Oh, bloody hell, Christoph! :/ You hid a structure copy in the
variable initialisations and used the same variable name for the
copy as the primary pointer:

	struct iov_iter iter = *dio->submit.iter;

That's really subtle and easy for idiots like me to miss when
reading the code. Please make it clear that we're working on
a copy of the primary iter here, not the primary iter itself.

> > > +		if (ret <= 0) {
> > > +			/* magic error code to fall back to buffered I/O */
> > > +			if (ret == -ENOTBLK)
> > > +				ret = 0;
> > > +			break;
> > > +		}
> > > +		pos += ret;
> > > +	} while ((count = iov_iter_count(iter)) > 0);
> > > +	blk_finish_plug(&plug);
> > > +
> > > +	if (ret < 0)
> > > +		cmpxchg(&dio->error, 0, ret);
> > 
> > Why cmpxchg? What are we racing with here? Helper (e.g.
> > dio_set_error())?
> 
> The submission thread against I/O completions (which in the worst
> case could come from multiple threads as well).  Same reason as
> the one in xfs_buf_bio_end_io added in commit 9bdd9bd69b
> ("xfs: buffer ->bi_end_io function requires irq-safe lock")

Yup, that's what I suspected - a comment is needed at least, though,
IMO, a helper w/ comment is the most maintainable approach here.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
