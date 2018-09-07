Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:42758 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725921AbeIGEnA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Sep 2018 00:43:00 -0400
Date: Fri, 7 Sep 2018 10:04:32 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/4] mkfs: stop zeroing old superblocks excessively
Message-ID: <20180907000432.GH27618@dastard>
References: <20180905081932.27478-1-david@fromorbit.com>
 <20180905081932.27478-2-david@fromorbit.com>
 <20180906133108.GA3311@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180906133108.GA3311@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Sep 06, 2018 at 09:31:08AM -0400, Brian Foster wrote:
> On Wed, Sep 05, 2018 at 06:19:29PM +1000, Dave Chinner wrote:
....
> > @@ -1220,15 +1221,68 @@ zero_old_xfs_structures(
> >  
> >  	/*
> >  	 * block size and basic geometry seems alright, zero the secondaries.
> > +	 *
> > +	 * Don't be insane when it comes to overwriting really large filesystems
> > +	 * as it could take millions of IOs to zero every secondary
> > +	 * superblock. If we are remaking a huge filesystem, then do the
> > +	 * zeroing, but if we are replacing it with a small one (typically done
> > +	 * in test environments, limit the zeroing to:
> > +	 *
> > +	 *	- around the range of the new filesystem
> > +	 *	- the middle of the old filesystem
> > +	 *	- the end of the old filesystem
> > +	 *
> > +	 * Killing the middle and end of the old filesystem will prevent repair
> > +	 * from finding it with it's fast secondary sb scan algorithm. The slow
> > +	 * scan algorithm will then confirm the small filesystem geometry by
> > +	 * brute force scans.
> >  	 */
> >  	memset(buf, 0, new_sb->sb_sectsize);
> > +
> > +	/* this carefully avoids integer overflows */
> > +	end = sb.sb_dblocks;
> > +	if (sb.sb_agcount > 10000 &&
> > +	    new_sb->sb_dblocks < end / 10)
> > +		end = new_sb->sb_dblocks * 10;
> 
> ... but what's with the 10k agcount cutoff? Just a number out of a hat
> to demonstrate the improvement..?

yeah, I pulled it from a hat, but mainly so it only triggers the new
"partial zeroing" code on really large devices that had a large
filesystem and now we're making a much smaller filesystem on it.

There's no real reason for it except for the fact I haven't done the
verification needed to make this the default behaviour (hence the
RFCRAP status :).

> Given that you've done the work to rough in an AIO buffered write
> mechanism for mkfs, have you considered whether we can find a way to
> apply that mechanism here?

It would have be another AIO context because this loop doesn't
use xfs_bufs.

> I'm guessing that the result of using AIO
> wouldn't be quite as impressive of not doing I/O at all, but as you've
> already noted, this algorithmic optimization is more targeted at test
> environments than production ones. The AIO approach sounds like it could
> be more broadly beneficial, even if not quite as fast in those
> particular test cases.

I just don't think it's worth the hassle as, like you said, it's
easier just to avoid the IO altogether.

> 
> >  	off = 0;
> > -	for (i = 1; i < sb.sb_agcount; i++)  {
> > +	for (i = 1; i < sb.sb_agcount && off < end; i++)  {
> > +		off += sb.sb_agblocks;
> > +		if (pwrite(xi->dfd, buf, new_sb->sb_sectsize,
> > +					off << sb.sb_blocklog) == -1)
> > +			break;
> > +	}
> > +
> > +	if (end == sb.sb_dblocks)
> > +		return;
> > +
> > +	/*
> > +	 * Trash the middle 1000 AGs of the old fs, which we know has at least
> > +	 * 10000 AGs at this point. Cast to make sure we are doing 64bit
> > +	 * multiplies, otherwise off gets truncated to 32 bit. I hate C.
> > +	 */
> > +	i = (sb.sb_agcount / 2) - 500;
> > +	off = (xfs_off_t)sb.sb_agblocks * i;
> > +	off = (xfs_off_t)sb.sb_agblocks * ((sb.sb_agcount / 2) - 500);
> 
> Looks like a couple lines of dead code there.

Yup, didn't clean it up properly, did I?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
