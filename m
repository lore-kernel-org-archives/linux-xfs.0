Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 40E487CA1
	for <xfs@oss.sgi.com>; Thu, 14 Apr 2016 10:18:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A88428F8049
	for <xfs@oss.sgi.com>; Thu, 14 Apr 2016 08:18:31 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id fSnBzYlIyjktRFWj (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 14 Apr 2016 08:18:30 -0700 (PDT)
Date: Thu, 14 Apr 2016 11:18:28 -0400
From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [RFC PATCH] block: wire blkdev_fallocate() to
	block_device_operations' reserve_space
Message-ID: <20160414151828.GB13074@redhat.com>
References: <1460479373-63317-1-git-send-email-bfoster@redhat.com>
	<20160412200459.GA10730@redhat.com>
	<20160412203904.GD5812@birch.djwong.org>
	<20160412210426.GA1845@redhat.com>
	<20160413001243.GA25280@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160413001243.GA25280@birch.djwong.org>
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

On Tue, Apr 12 2016 at  8:12pm -0400,
Darrick J. Wong <darrick.wong@oracle.com> wrote:

> On Tue, Apr 12, 2016 at 05:04:27PM -0400, Mike Snitzer wrote:
> > On Tue, Apr 12 2016 at  4:39pm -0400,
> > Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > 
> > > On Tue, Apr 12, 2016 at 04:04:59PM -0400, Mike Snitzer wrote:
> > > > diff --git a/fs/block_dev.c b/fs/block_dev.c
> > > > index 5a2c3ab..b34c07b 100644
> > > > --- a/fs/block_dev.c
> > > > +++ b/fs/block_dev.c
> > > > @@ -1801,17 +1801,13 @@ long blkdev_fallocate(struct file *file, int mode, loff_t start, loff_t len)
> > > >  	struct request_queue *q = bdev_get_queue(bdev);
> > > >  	struct address_space *mapping;
> > > >  	loff_t end = start + len - 1;
> > > > -	loff_t bs_mask, isize;
> > > > +	loff_t isize;
> > > >  	int error;
> > > >  
> > > >  	/* We only support zero range and punch hole. */
> > > >  	if (mode & ~BLKDEV_FALLOC_FL_SUPPORTED)
> > > >  		return -EOPNOTSUPP;
> > > >  
> > > > -	/* We haven't a primitive for "ensure space exists" right now. */
> > > > -	if (!(mode & ~FALLOC_FL_KEEP_SIZE))
> > > > -		return -EOPNOTSUPP;
> > > > -
> > > >  	/* Only punch if the device can do zeroing discard. */
> > > >  	if ((mode & FALLOC_FL_PUNCH_HOLE) &&
> > > >  	    (!blk_queue_discard(q) || !q->limits.discard_zeroes_data))
> > > > @@ -1829,9 +1825,12 @@ long blkdev_fallocate(struct file *file, int mode, loff_t start, loff_t len)
> > > >  			return -EINVAL;
> > > >  	}
> > > >  
> > > > -	/* Don't allow IO that isn't aligned to logical block size */
> > > > -	bs_mask = bdev_logical_block_size(bdev) - 1;
> > > > -	if ((start | len) & bs_mask)
> > > > +	/*
> > > > +	 * Don't allow IO that isn't aligned to minimum IO size (io_min)
> > > > +	 * - for normal device's io_min is usually logical block size
> > > > +	 * - but for more exotic devices (e.g. DM thinp) it may be larger
> > > > +	 */
> > > > +	if ((start | len) % bdev_io_min(bdev))
> 
> I started by noticing the 64-bit division.

Oops, yeah good point.  I did said my patch was untested (didn't mention
that it wasn't even compile tested.. RFC and all) ;)

> However, in researching alignment
> requirements for fallocate, I noticed that nothing says that we can return
> -EINVAL for unaligned offset/len for allocate or punch.  For file allocations
> ext4 and xfs simply enlarge the range so that the ends are aligned to the
> logical block size; for punch they both shrink the range to deallocate until
> the ends are aligned, and write zeroes to the partial blocks.
> 
> At least for user-visible fallocate we should do likewise, but for the internal
> blkdev_ helpers I think it makes more sense to check lbs alignment and let the
> lower level driver reject the IO if min_io alignment is a hard requirement.
> Documentation/block/queue-sysfs.txt says that the min_io is the smallest
> /preferred/ size.

Thinking about this all further.  Alignment on allocation isn't a big
deal for thinp.  If the extent requested isn't properly aligned we'll
still do the right thing (which is to round-up and allocate a block at
the beginning and/or end to fulfill the request).

As for discard, DM-thinp silently drops the discard of the beginning
and/or end that isn't aligned on a thinp blocksize boundary -- that is
DM thinp doesn't unmap the corresponding thinp block because the partial
block is still considered used.  But thinp still passes down the
appropriate discard for that subset of the still-mapped thinp block to
the underlying storage (if discard passdown in enabled on the DM
thin-pool).
 
> But, before that, I'll push out some new fallocate patches for -rc3.
> 
> > > >  		return -EINVAL;
> > > 
> > > Noted.  Will update the original patch.
> > 
> > BTW, I just noticed your "block: require write_same and discard requests
> > align to logical block size" -- doesn't look right.
> 
> What happens if we pass a request to thinp that isn't aligned to
> minimum_io_size?  Does it reject the command?

I hope I answered that above just now.

SO.. it seems we can avoid the mess of worrying about minimum_io_size
alignment (both for this fallocate interface and discard).

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
