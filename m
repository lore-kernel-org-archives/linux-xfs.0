Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2B8257CA0
	for <xfs@oss.sgi.com>; Wed, 13 Apr 2016 16:01:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 85F28AC003
	for <xfs@oss.sgi.com>; Wed, 13 Apr 2016 14:01:52 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id n3za7nCdZWOhM1Ba (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 13 Apr 2016 14:01:49 -0700 (PDT)
Date: Wed, 13 Apr 2016 14:01:43 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC v2 PATCH 05/10] dm thin: add methods to set and get
	reserved space
Message-ID: <20160413210143.GA17592@birch.djwong.org>
References: <1460479373-63317-1-git-send-email-bfoster@redhat.com>
	<1460479373-63317-6-git-send-email-bfoster@redhat.com>
	<20160413174442.GD18517@birch.djwong.org>
	<20160413183352.GB2775@bfoster.bfoster>
	<20160413204117.GA6870@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160413204117.GA6870@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: snitzer@redhat.com, Joe Thornber <ejt@redhat.com>, xfs@oss.sgi.com, linux-block@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org

On Wed, Apr 13, 2016 at 04:41:18PM -0400, Brian Foster wrote:
> On Wed, Apr 13, 2016 at 02:33:52PM -0400, Brian Foster wrote:
> > On Wed, Apr 13, 2016 at 10:44:42AM -0700, Darrick J. Wong wrote:
> > > On Tue, Apr 12, 2016 at 12:42:48PM -0400, Brian Foster wrote:
> > > > From: Joe Thornber <ejt@redhat.com>
> > > > 
> > > > Experimental reserve interface for XFS guys to play with.
> > > > 
> > > > I have big reservations (no pun intended) about this patch.
> > > > 
> > > > [BF:
> > > >  - Support for reservation reduction.
> > > >  - Support for space provisioning.
> > > >  - Condensed to a single function.]
> > > > 
> > > > Not-Signed-off-by: Joe Thornber <ejt@redhat.com>
> > > > Not-Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> > > > ---
> > > >  drivers/md/dm-thin.c | 181 ++++++++++++++++++++++++++++++++++++++++++++++++---
> > > >  1 file changed, 171 insertions(+), 10 deletions(-)
> > > > 
> > > > diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
> > > > index 92237b6..32bc5bd 100644
> > > > --- a/drivers/md/dm-thin.c
> > > > +++ b/drivers/md/dm-thin.c
> > ...
> > > > @@ -4271,6 +4343,94 @@ static void thin_io_hints(struct dm_target *ti, struct queue_limits *limits)
> > > >  	limits->max_discard_sectors = 2048 * 1024 * 16; /* 16G */
> > > >  }
> > > >  
> > > > +static int thin_provision_space(struct dm_target *ti, sector_t offset,
> > > > +				sector_t len, sector_t *res)
> > > > +{
> > > > +	struct thin_c *tc = ti->private;
> > > > +	struct pool *pool = tc->pool;
> > > > +	sector_t end;
> > > > +	dm_block_t pblock;
> > > > +	dm_block_t vblock;
> > > > +	int error;
> > > > +	struct dm_thin_lookup_result lookup;
> > > > +
> > > > +	if (!is_factor(offset, pool->sectors_per_block))
> > > > +		return -EINVAL;
> > > > +
> > > > +	if (!len || !is_factor(len, pool->sectors_per_block))
> > > > +		return -EINVAL;
> > > > +
> > > > +	if (res && !is_factor(*res, pool->sectors_per_block))
> > > > +		return -EINVAL;
> > > > +
> > > > +	end = offset + len;
> > > > +
> > > > +	while (offset < end) {
> > > > +		vblock = offset;
> > > > +		do_div(vblock, pool->sectors_per_block);
> > > > +
> > > > +		error = dm_thin_find_block(tc->td, vblock, true, &lookup);
> > > > +		if (error == 0)
> > > > +			goto next;
> > > > +		if (error != -ENODATA)
> > > > +			return error;
> > > > +
> > > > +		error = alloc_data_block(tc, &pblock);
> > > 
> > > So this means that if fallocate wants to BDEV_RES_PROVISION N blocks, it must
> > > first increase the reservation (BDEV_RES_MOD) by N blocks to avoid using up
> > > space that was previously reserved by some other caller.  I think?
> > > 
> > 
> > Yes, assuming this is being called from a filesystem using the
> > reservation mechanism.
> > 
> > > > +		if (error)
> > > > +			return error;
> > > > +
> > > > +		error = dm_thin_insert_block(tc->td, vblock, pblock);
> > > 
> > > Having reserved and mapped blocks, what happens when we try to read them?
> > > Do we actually get zeroes, or does the read go straight through to whatever
> > > happens to be in the disk blocks?  I don't think it's correct that we could
> > > BDEV_RES_PROVISION and end up with stale credit card numbers from some other
> > > thin device.
> > > 
> > 
> > Agree, but I'm not really sure how this works in thinp tbh. fallocate
> > wasn't really on my mind when doing this. I was simply trying to cobble
> > together what I could to facilitate making progress on the fs parts
> > (e.g., I just needed a call that allocated blocks and consumed
> > reservation in the process).
> > 
> > Skimming through the dm-thin code, it looks like a (configurable) block
> > zeroing mechanism can be triggered from somewhere around
> > provision_block()->schedule_zero(), depending on whether the incoming
> > write overwrites the newly allocated block. If that's the case, then I
> > suspect that means reads would just fall through to the block and return
> > whatever was on disk. This code would probably need to tie into that
> > zeroing mechanism one way or another to deal with that issue. (Though
> > somebody who actually knows something about dm-thin should verify that.
> > :)
> > 
> 
> BTW, if that mechanism is in fact doing I/O, that might not be the
> appropriate solution for fallocate. Perhaps we'd have to consider an
> unwritten flag or some such in dm-thin, if possible.

The hard part is that we don't know if the caller actually has a way to
prevent userspace from seeing the stale contents (filesystems) or if we'd
be leaking data straight to userspace (user program calling fallocate).

(And yeah, here we go with NO_HIDE_STALE again...)

--D

> 
> Brian
> 
> > Brian
> > 
> > > (PS: I don't know enough about thinp to know if this has already been taken
> > > care of.  I didn't see anything, but who knows what I missed. :))
> > > 
> > > --D
> > > 
> > > > +		if (error)
> > > > +			return error;
> > > > +
> > > > +		if (res && *res)
> > > > +			*res -= pool->sectors_per_block;
> > > > +next:
> > > > +		offset += pool->sectors_per_block;
> > > > +	}
> > > > +
> > > > +	return 0;
> > > > +}
> > > > +
> > > > +static int thin_reserve_space(struct dm_target *ti, int mode, sector_t offset,
> > > > +			      sector_t len, sector_t *res)
> > > > +{
> > > > +	struct thin_c *tc = ti->private;
> > > > +	struct pool *pool = tc->pool;
> > > > +	sector_t blocks;
> > > > +	unsigned long flags;
> > > > +	int error;
> > > > +
> > > > +	if (mode == BDEV_RES_PROVISION)
> > > > +		return thin_provision_space(ti, offset, len, res);
> > > > +
> > > > +	/* res required for get/set */
> > > > +	error = -EINVAL;
> > > > +	if (!res)
> > > > +		return error;
> > > > +
> > > > +	if (mode == BDEV_RES_GET) {
> > > > +		spin_lock_irqsave(&tc->pool->lock, flags);
> > > > +		*res = tc->reserve_count * pool->sectors_per_block;
> > > > +		spin_unlock_irqrestore(&tc->pool->lock, flags);
> > > > +		error = 0;
> > > > +	} else if (mode == BDEV_RES_MOD) {
> > > > +		/*
> > > > +		* @res must always be a factor of the pool's blocksize; upper
> > > > +		* layers can rely on the bdev's minimum_io_size for this.
> > > > +		*/
> > > > +		if (!is_factor(*res, pool->sectors_per_block))
> > > > +			return error;
> > > > +
> > > > +		blocks = *res;
> > > > +		(void) sector_div(blocks, pool->sectors_per_block);
> > > > +
> > > > +		error = set_reserve_count(tc, blocks);
> > > > +	}
> > > > +
> > > > +	return error;
> > > > +}
> > > > +
> > > >  static struct target_type thin_target = {
> > > >  	.name = "thin",
> > > >  	.version = {1, 18, 0},
> > > > @@ -4285,6 +4445,7 @@ static struct target_type thin_target = {
> > > >  	.status = thin_status,
> > > >  	.iterate_devices = thin_iterate_devices,
> > > >  	.io_hints = thin_io_hints,
> > > > +	.reserve_space = thin_reserve_space,
> > > >  };
> > > >  
> > > >  /*----------------------------------------------------------------*/
> > > > -- 
> > > > 2.4.11
> > > > 
> > > > _______________________________________________
> > > > xfs mailing list
> > > > xfs@oss.sgi.com
> > > > http://oss.sgi.com/mailman/listinfo/xfs
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-block" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-block" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
