Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2A5297CA2
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 19:12:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 938D7AC005
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 17:12:49 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id fRmOn0yYAYqx4Ltf (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 12 Apr 2016 17:12:47 -0700 (PDT)
Date: Tue, 12 Apr 2016 17:12:43 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC PATCH] block: wire blkdev_fallocate() to
	block_device_operations' reserve_space
Message-ID: <20160413001243.GA25280@birch.djwong.org>
References: <1460479373-63317-1-git-send-email-bfoster@redhat.com>
	<20160412200459.GA10730@redhat.com>
	<20160412203904.GD5812@birch.djwong.org>
	<20160412210426.GA1845@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160412210426.GA1845@redhat.com>
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
To: Mike Snitzer <snitzer@redhat.com>
Cc: linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, Brian Foster <bfoster@redhat.com>, dm-devel@redhat.com, xfs@oss.sgi.com

On Tue, Apr 12, 2016 at 05:04:27PM -0400, Mike Snitzer wrote:
> On Tue, Apr 12 2016 at  4:39pm -0400,
> Darrick J. Wong <darrick.wong@oracle.com> wrote:
> 
> > On Tue, Apr 12, 2016 at 04:04:59PM -0400, Mike Snitzer wrote:
> > > diff --git a/fs/block_dev.c b/fs/block_dev.c
> > > index 5a2c3ab..b34c07b 100644
> > > --- a/fs/block_dev.c
> > > +++ b/fs/block_dev.c
> > > @@ -1801,17 +1801,13 @@ long blkdev_fallocate(struct file *file, int mode, loff_t start, loff_t len)
> > >  	struct request_queue *q = bdev_get_queue(bdev);
> > >  	struct address_space *mapping;
> > >  	loff_t end = start + len - 1;
> > > -	loff_t bs_mask, isize;
> > > +	loff_t isize;
> > >  	int error;
> > >  
> > >  	/* We only support zero range and punch hole. */
> > >  	if (mode & ~BLKDEV_FALLOC_FL_SUPPORTED)
> > >  		return -EOPNOTSUPP;
> > >  
> > > -	/* We haven't a primitive for "ensure space exists" right now. */
> > > -	if (!(mode & ~FALLOC_FL_KEEP_SIZE))
> > > -		return -EOPNOTSUPP;
> > > -
> > >  	/* Only punch if the device can do zeroing discard. */
> > >  	if ((mode & FALLOC_FL_PUNCH_HOLE) &&
> > >  	    (!blk_queue_discard(q) || !q->limits.discard_zeroes_data))
> > > @@ -1829,9 +1825,12 @@ long blkdev_fallocate(struct file *file, int mode, loff_t start, loff_t len)
> > >  			return -EINVAL;
> > >  	}
> > >  
> > > -	/* Don't allow IO that isn't aligned to logical block size */
> > > -	bs_mask = bdev_logical_block_size(bdev) - 1;
> > > -	if ((start | len) & bs_mask)
> > > +	/*
> > > +	 * Don't allow IO that isn't aligned to minimum IO size (io_min)
> > > +	 * - for normal device's io_min is usually logical block size
> > > +	 * - but for more exotic devices (e.g. DM thinp) it may be larger
> > > +	 */
> > > +	if ((start | len) % bdev_io_min(bdev))

I started by noticing the 64-bit division.  However, in researching alignment
requirements for fallocate, I noticed that nothing says that we can return
-EINVAL for unaligned offset/len for allocate or punch.  For file allocations
ext4 and xfs simply enlarge the range so that the ends are aligned to the
logical block size; for punch they both shrink the range to deallocate until
the ends are aligned, and write zeroes to the partial blocks.

At least for user-visible fallocate we should do likewise, but for the internal
blkdev_ helpers I think it makes more sense to check lbs alignment and let the
lower level driver reject the IO if min_io alignment is a hard requirement.
Documentation/block/queue-sysfs.txt says that the min_io is the smallest
/preferred/ size.

But, before that, I'll push out some new fallocate patches for -rc3.

> > >  		return -EINVAL;
> > 
> > Noted.  Will update the original patch.
> 
> BTW, I just noticed your "block: require write_same and discard requests
> align to logical block size" -- doesn't look right.

What happens if we pass a request to thinp that isn't aligned to
minimum_io_size?  Does it reject the command?

> But maybe I'm just too hyper-focused on DM thinp's needs (which would
> much prefer these checks be done in terms of minimum_io_size, rather
> than logical_block_size, and _not_ assuming power-of-2 math will work).
> 
> But at least for discard: your lbs-based check is fine; since we have
> discard_granularity to cover thinp's more specific requirements.

--D

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
