Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A654D7CA0
	for <xfs@oss.sgi.com>; Thu, 14 Apr 2016 11:23:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 760BD304032
	for <xfs@oss.sgi.com>; Thu, 14 Apr 2016 09:23:48 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 1lFEN0Ja46si9fSZ (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 14 Apr 2016 09:23:47 -0700 (PDT)
Date: Thu, 14 Apr 2016 12:23:44 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [RFC v2 PATCH 05/10] dm thin: add methods to set and get
	reserved space
Message-ID: <20160414162344.GG20696@bfoster.bfoster>
References: <1460479373-63317-1-git-send-email-bfoster@redhat.com>
	<1460479373-63317-6-git-send-email-bfoster@redhat.com>
	<20160413174442.GD18517@birch.djwong.org>
	<20160413183352.GB2775@bfoster.bfoster>
	<20160413204117.GA6870@bfoster.bfoster>
	<20160414151014.GA13074@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160414151014.GA13074@redhat.com>
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
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Joe Thornber <ejt@redhat.com>, xfs@oss.sgi.com, linux-block@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org

On Thu, Apr 14, 2016 at 11:10:14AM -0400, Mike Snitzer wrote:
> On Wed, Apr 13 2016 at  4:41pm -0400,
> Brian Foster <bfoster@redhat.com> wrote:
> 
> > On Wed, Apr 13, 2016 at 02:33:52PM -0400, Brian Foster wrote:
> > > On Wed, Apr 13, 2016 at 10:44:42AM -0700, Darrick J. Wong wrote:
> > > > On Tue, Apr 12, 2016 at 12:42:48PM -0400, Brian Foster wrote:
> > > > > From: Joe Thornber <ejt@redhat.com>
> > > > > 
> > > > > Experimental reserve interface for XFS guys to play with.
> > > > > 
> > > > > I have big reservations (no pun intended) about this patch.
> > > > > 
> > > > > [BF:
> > > > >  - Support for reservation reduction.
> > > > >  - Support for space provisioning.
> > > > >  - Condensed to a single function.]
> > > > > 
> > > > > Not-Signed-off-by: Joe Thornber <ejt@redhat.com>
> > > > > Not-Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> > > > > ---
> > > > >  drivers/md/dm-thin.c | 181 ++++++++++++++++++++++++++++++++++++++++++++++++---
> > > > >  1 file changed, 171 insertions(+), 10 deletions(-)
> > > > > 
> > > > > diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
> > > > > index 92237b6..32bc5bd 100644
> > > > > --- a/drivers/md/dm-thin.c
> > > > > +++ b/drivers/md/dm-thin.c
> > > ...
> > > > > @@ -4271,6 +4343,94 @@ static void thin_io_hints(struct dm_target *ti, struct queue_limits *limits)
> > > > >  	limits->max_discard_sectors = 2048 * 1024 * 16; /* 16G */
> > > > >  }
> > > > >  
> > > > > +static int thin_provision_space(struct dm_target *ti, sector_t offset,
> > > > > +				sector_t len, sector_t *res)
> > > > > +{
> > > > > +	struct thin_c *tc = ti->private;
> > > > > +	struct pool *pool = tc->pool;
> > > > > +	sector_t end;
> > > > > +	dm_block_t pblock;
> > > > > +	dm_block_t vblock;
> > > > > +	int error;
> > > > > +	struct dm_thin_lookup_result lookup;
> > > > > +
> > > > > +	if (!is_factor(offset, pool->sectors_per_block))
> > > > > +		return -EINVAL;
> > > > > +
> > > > > +	if (!len || !is_factor(len, pool->sectors_per_block))
> > > > > +		return -EINVAL;
> > > > > +
> > > > > +	if (res && !is_factor(*res, pool->sectors_per_block))
> > > > > +		return -EINVAL;
> > > > > +
> > > > > +	end = offset + len;
> > > > > +
> > > > > +	while (offset < end) {
> > > > > +		vblock = offset;
> > > > > +		do_div(vblock, pool->sectors_per_block);
> > > > > +
> > > > > +		error = dm_thin_find_block(tc->td, vblock, true, &lookup);
> > > > > +		if (error == 0)
> > > > > +			goto next;
> > > > > +		if (error != -ENODATA)
> > > > > +			return error;
> > > > > +
> > > > > +		error = alloc_data_block(tc, &pblock);
> > > > 
> > > > So this means that if fallocate wants to BDEV_RES_PROVISION N blocks, it must
> > > > first increase the reservation (BDEV_RES_MOD) by N blocks to avoid using up
> > > > space that was previously reserved by some other caller.  I think?
> > > > 
> > > 
> > > Yes, assuming this is being called from a filesystem using the
> > > reservation mechanism.
> 
> Brian, I need to circle back with you to understand why XFS even needs
> reservation as opposed to just using something like fallocate (which
> would provision the space before you actually initiate the IO that would
> use it).  But we can discuss that in person and then report back to the
> list if it makes it easier...
>  

The primary reason is delayed allocation. Buffered writes to the fs copy
data into the pagecache before the physical space has been allocated.
E.g., we only modify the free blocks counters at write() time in order
to guarantee that we have space somewhere in the fs. The physical
extents aren't allocated until later at writeback time.

So reservation from dm-thin basically extends the mechanism to also
guarantee that the underlying thin volume has space for writes that
we've received but haven't written back yet.

> > > > > +		if (error)
> > > > > +			return error;
> > > > > +
> > > > > +		error = dm_thin_insert_block(tc->td, vblock, pblock);
> > > > 
> > > > Having reserved and mapped blocks, what happens when we try to read them?
> > > > Do we actually get zeroes, or does the read go straight through to whatever
> > > > happens to be in the disk blocks?  I don't think it's correct that we could
> > > > BDEV_RES_PROVISION and end up with stale credit card numbers from some other
> > > > thin device.
> > > > 
> > > 
> > > Agree, but I'm not really sure how this works in thinp tbh. fallocate
> > > wasn't really on my mind when doing this. I was simply trying to cobble
> > > together what I could to facilitate making progress on the fs parts
> > > (e.g., I just needed a call that allocated blocks and consumed
> > > reservation in the process).
> > > 
> > > Skimming through the dm-thin code, it looks like a (configurable) block
> > > zeroing mechanism can be triggered from somewhere around
> > > provision_block()->schedule_zero(), depending on whether the incoming
> > > write overwrites the newly allocated block. If that's the case, then I
> > > suspect that means reads would just fall through to the block and return
> > > whatever was on disk. This code would probably need to tie into that
> > > zeroing mechanism one way or another to deal with that issue. (Though
> > > somebody who actually knows something about dm-thin should verify that.
> > > :)
> > > 
> > 
> > BTW, if that mechanism is in fact doing I/O, that might not be the
> > appropriate solution for fallocate. Perhaps we'd have to consider an
> > unwritten flag or some such in dm-thin, if possible.
> 
> DM thinp defaults to enabling 'zero_new_blocks' (can be disabled using
> the 'skip_block_zeroing' feature when loading the DM table for the
> thin-pool).  With block-zeroing any blocks that are provisioned _will_
> be overwritten with zeroes (using dm-kcopyd which is trained to use
> WRITE_SAME if supported).
> 

Ok, thanks.

> But yeah, for fallocate.. certainly not something we want as it defeats
> the point of fallocate being cheap.
> 

Indeed.

> So we probably would need a flag comparable to the
> ext4-stale-flag-that-shall-not-be-named ;)
> 

Any chance to support an unwritten flag for all blocks that are
allocated via fallocate? E.g., subsequent reads detect the flag and
return zeroes as if the block wasn't there and a subsequent write clears
the flag (doing any partial block zeroing that might be necessary as
well).

Brian

> Mike
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
