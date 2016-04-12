Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 03BB97CA1
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 16:04:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BD157304067
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 14:04:30 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 0uBtp10odEM2SUVh (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 12 Apr 2016 14:04:29 -0700 (PDT)
Date: Tue, 12 Apr 2016 17:04:27 -0400
From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [RFC PATCH] block: wire blkdev_fallocate() to
	block_device_operations' reserve_space
Message-ID: <20160412210426.GA1845@redhat.com>
References: <1460479373-63317-1-git-send-email-bfoster@redhat.com>
	<20160412200459.GA10730@redhat.com>
	<20160412203904.GD5812@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160412203904.GD5812@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, Brian Foster <bfoster@redhat.com>, dm-devel@redhat.com, xfs@oss.sgi.com

On Tue, Apr 12 2016 at  4:39pm -0400,
Darrick J. Wong <darrick.wong@oracle.com> wrote:

> On Tue, Apr 12, 2016 at 04:04:59PM -0400, Mike Snitzer wrote:
> > diff --git a/fs/block_dev.c b/fs/block_dev.c
> > index 5a2c3ab..b34c07b 100644
> > --- a/fs/block_dev.c
> > +++ b/fs/block_dev.c
> > @@ -1801,17 +1801,13 @@ long blkdev_fallocate(struct file *file, int mode, loff_t start, loff_t len)
> >  	struct request_queue *q = bdev_get_queue(bdev);
> >  	struct address_space *mapping;
> >  	loff_t end = start + len - 1;
> > -	loff_t bs_mask, isize;
> > +	loff_t isize;
> >  	int error;
> >  
> >  	/* We only support zero range and punch hole. */
> >  	if (mode & ~BLKDEV_FALLOC_FL_SUPPORTED)
> >  		return -EOPNOTSUPP;
> >  
> > -	/* We haven't a primitive for "ensure space exists" right now. */
> > -	if (!(mode & ~FALLOC_FL_KEEP_SIZE))
> > -		return -EOPNOTSUPP;
> > -
> >  	/* Only punch if the device can do zeroing discard. */
> >  	if ((mode & FALLOC_FL_PUNCH_HOLE) &&
> >  	    (!blk_queue_discard(q) || !q->limits.discard_zeroes_data))
> > @@ -1829,9 +1825,12 @@ long blkdev_fallocate(struct file *file, int mode, loff_t start, loff_t len)
> >  			return -EINVAL;
> >  	}
> >  
> > -	/* Don't allow IO that isn't aligned to logical block size */
> > -	bs_mask = bdev_logical_block_size(bdev) - 1;
> > -	if ((start | len) & bs_mask)
> > +	/*
> > +	 * Don't allow IO that isn't aligned to minimum IO size (io_min)
> > +	 * - for normal device's io_min is usually logical block size
> > +	 * - but for more exotic devices (e.g. DM thinp) it may be larger
> > +	 */
> > +	if ((start | len) % bdev_io_min(bdev))
> >  		return -EINVAL;
> 
> Noted.  Will update the original patch.

BTW, I just noticed your "block: require write_same and discard requests
align to logical block size" -- doesn't look right.

But maybe I'm just too hyper-focused on DM thinp's needs (which would
much prefer these checks be done in terms of minimum_io_size, rather
than logical_block_size, and _not_ assuming power-of-2 math will work).

But at least for discard: your lbs-based check is fine; since we have
discard_granularity to cover thinp's more specific requirements.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
