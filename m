Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:58824 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727378AbeIGPp6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 7 Sep 2018 11:45:58 -0400
Date: Fri, 7 Sep 2018 07:05:29 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/4] mkfs: stop zeroing old superblocks excessively
Message-ID: <20180907110529.GA33388@bfoster>
References: <20180905081932.27478-1-david@fromorbit.com>
 <20180905081932.27478-2-david@fromorbit.com>
 <20180906133108.GA3311@bfoster>
 <20180907000432.GH27618@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180907000432.GH27618@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Sep 07, 2018 at 10:04:32AM +1000, Dave Chinner wrote:
> On Thu, Sep 06, 2018 at 09:31:08AM -0400, Brian Foster wrote:
> > On Wed, Sep 05, 2018 at 06:19:29PM +1000, Dave Chinner wrote:
> ....
> > > @@ -1220,15 +1221,68 @@ zero_old_xfs_structures(
> > >  
> > >  	/*
> > >  	 * block size and basic geometry seems alright, zero the secondaries.
> > > +	 *
> > > +	 * Don't be insane when it comes to overwriting really large filesystems
> > > +	 * as it could take millions of IOs to zero every secondary
> > > +	 * superblock. If we are remaking a huge filesystem, then do the
> > > +	 * zeroing, but if we are replacing it with a small one (typically done
> > > +	 * in test environments, limit the zeroing to:
> > > +	 *
> > > +	 *	- around the range of the new filesystem
> > > +	 *	- the middle of the old filesystem
> > > +	 *	- the end of the old filesystem
> > > +	 *
> > > +	 * Killing the middle and end of the old filesystem will prevent repair
> > > +	 * from finding it with it's fast secondary sb scan algorithm. The slow
> > > +	 * scan algorithm will then confirm the small filesystem geometry by
> > > +	 * brute force scans.
> > >  	 */
> > >  	memset(buf, 0, new_sb->sb_sectsize);
> > > +
> > > +	/* this carefully avoids integer overflows */
> > > +	end = sb.sb_dblocks;
> > > +	if (sb.sb_agcount > 10000 &&
> > > +	    new_sb->sb_dblocks < end / 10)
> > > +		end = new_sb->sb_dblocks * 10;
> > 
> > ... but what's with the 10k agcount cutoff? Just a number out of a hat
> > to demonstrate the improvement..?
> 
> yeah, I pulled it from a hat, but mainly so it only triggers the new
> "partial zeroing" code on really large devices that had a large
> filesystem and now we're making a much smaller filesystem on it.
> 
> There's no real reason for it except for the fact I haven't done the
> verification needed to make this the default behaviour (hence the
> RFCRAP status :).
> 

Ok...

> > Given that you've done the work to rough in an AIO buffered write
> > mechanism for mkfs, have you considered whether we can find a way to
> > apply that mechanism here?
> 
> It would have be another AIO context because this loop doesn't
> use xfs_bufs.
> 

Yup. I wasn't suggesting to necessarily use xfs_bufs, but I suppose that
could be an option if we could find a clever way to do so. It's probably
not worth getting into the weeds of an implementation until the core
I/O infrastructure is more fleshed out.

> > I'm guessing that the result of using AIO
> > wouldn't be quite as impressive of not doing I/O at all, but as you've
> > already noted, this algorithmic optimization is more targeted at test
> > environments than production ones. The AIO approach sounds like it could
> > be more broadly beneficial, even if not quite as fast in those
> > particular test cases.
> 
> I just don't think it's worth the hassle as, like you said, it's
> easier just to avoid the IO altogether.
> 

Well, I said it probably wouldn't be as fast as not doing the I/O at
all. I'm not necessarily convinced it's easier (or better). ;P This
patch is kind of a case in point. It's more code than the current
dead-simple pwrite() loop, it picks an arbitrary cutoff which suggests
it needs more work (and/or complexity) to be more generically
acceptable, and it ultimately requires some kind of evaluation against
(or cooperation with) the repair secondary scan to ensure it's done
properly. If this function could do exactly what it does now, but much
faster (based on the mkfs results you've achieved), then that could be a
more simple approach.

All I'm really saying is that if we're going through the work to create
a fast/efficient I/O mechanism for mkfs, it's worth looking into
applying that mechanism here because it's the same fundamental problem
(applied to the more narrow case of zeroing out that old, huge fs rather
than creating it in the first place). If the code complexity is
comparable (an open/valid question), then at least we stand to benefit
regardless of whether the old -> new fs is an 8x delta rather than 10x
for example, without having to come up with (and maintain) new/rigid
heuristics.

If the benefits aren't as great or there's just too much of an impedence
mismatch between this algorithm and the underlying I/O mechanism to
justify the complexity, then we can always fall back to doing something
like this. I'd just prefer to see some of that analysis before comitting
to this approach.

Brian

> > 
> > >  	off = 0;
> > > -	for (i = 1; i < sb.sb_agcount; i++)  {
> > > +	for (i = 1; i < sb.sb_agcount && off < end; i++)  {
> > > +		off += sb.sb_agblocks;
> > > +		if (pwrite(xi->dfd, buf, new_sb->sb_sectsize,
> > > +					off << sb.sb_blocklog) == -1)
> > > +			break;
> > > +	}
> > > +
> > > +	if (end == sb.sb_dblocks)
> > > +		return;
> > > +
> > > +	/*
> > > +	 * Trash the middle 1000 AGs of the old fs, which we know has at least
> > > +	 * 10000 AGs at this point. Cast to make sure we are doing 64bit
> > > +	 * multiplies, otherwise off gets truncated to 32 bit. I hate C.
> > > +	 */
> > > +	i = (sb.sb_agcount / 2) - 500;
> > > +	off = (xfs_off_t)sb.sb_agblocks * i;
> > > +	off = (xfs_off_t)sb.sb_agblocks * ((sb.sb_agcount / 2) - 500);
> > 
> > Looks like a couple lines of dead code there.
> 
> Yup, didn't clean it up properly, did I?
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
