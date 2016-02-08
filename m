Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B808F29DF5
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 08:35:35 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 980AF8F804C
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 06:35:35 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 242H7aEssxaOGcPR (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 08 Feb 2016 06:35:34 -0800 (PST)
Date: Mon, 8 Feb 2016 09:35:32 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Question about continous blocks for inode due to 'no space left
	on device' problem
Message-ID: <20160208143531.GA19597@bfoster.bfoster>
References: <CAAgKQi+AOZO_K9Garmz3G6C1X8TuTRxrfF1MP2HPEZ3JkdE41w@mail.gmail.com>
	<20160205223023.GL459@dastard>
	<CAAgKQiJ17XKu-k-Gufk0O_EgXcZvebzCEO4STGdAkszoZxAqfw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAAgKQiJ17XKu-k-Gufk0O_EgXcZvebzCEO4STGdAkszoZxAqfw@mail.gmail.com>
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
To: Michel Verbraak <info1stsetup@gmail.com>
Cc: xfs@oss.sgi.com

On Mon, Feb 08, 2016 at 02:09:15PM +0100, Michel Verbraak wrote:
> 2016-02-05 23:30 GMT+01:00 Dave Chinner <david@fromorbit.com>:
> 
> > On Fri, Feb 05, 2016 at 02:13:00PM +0100, Michel Verbraak wrote:
> > > All,
> > >
> > > Recently we ran into a problem where our filesystem (300GB in size)
> > > reported 'no space left on device' (ENOSPC) but when we looked at disk
> > > space usage and inode usage it was around 52% for disk space and 11% for
> > .......
> 
> 
> >
> > > Store 03 (root@server):~# xfs_db -c freesp /dev/sdb
> > >    from      to extents  blocks    pct
> > >       1       1 3282633 3282633   9.03
> > >       2       3 3416223 8372325  23.03
> > >       4       7 6175009 24700036  67.94
> >
> > Yup, no more aligned 4 block extents in the filesystem.
> >
> > Dave Thank you for your answer but are you able to explain a bit more on
> how you determine there are no aligned 4 block extends available?
> It apparently is not the 'from 4 to 7' line telling there are at least
> continuous extents of 4 blocks big. Or is it because 24700036 divided
> by 6175009
> is exactly 4 and not a bit more?
> When I calculate the ratio between the individual AG freesp they were all
> four exactly 4.
> 

I'm not sure there is a way to determine whether these extents are
aligned or not short of walking the free space btree structures with
xfs_db checking directly.

IIRC from doing some of the sparse inode work, the slight caveat to this
whole thing is that it's technically not enough to have an aligned
extent available to satisfy an inode chunk allocation. The allocation
group has to have an extent large enough for the inode chunk plus some
set of blocks to _guarantee_ the allocation can be aligned for the
caller.

If you look at the code in xfs_alloc_space_available(), you can see that
in practice the allocator will start to fail when the longest free
extent in the AG is less than something along the lines of <extsize> +
<alignment>. For a 4k fsb fs w/ 256b inodes (and thus 16k inode chunks),
a quick test shows that the alignment is 8k (for a 24k total required
extent length).

I do wonder if we could do something basic here like search the AG for
an actual aligned extent, but I expect performance would be terrible so
this would be a last resort (and may or may not be useful). Another
option might be to scan or somehow or another track the number of inode
chunk aligned extents in each AG based on the inode alignment of the fs,
but I'd have to investigate how easy that is to see whether it's worth
it.

BTW, a metadump of your fs while it's in this ENOSPC state would be
useful towards testing something like that, if you'd be willing to
provide one. Note that xfs_metadump has obfuscation that hides filenames
and whatnot for privacy purposes. 

Brian

> As said we would like to detect this problem from happening again. And we
> would like this detection to be done by our monitoring service.
> One of my colleagues mentions the following calculation to find out if
> there are enough aligned 4 block extents:
> 
> Starting from line "from 4 to 7" calculate: <blocks-column> - (4 *
> <extents-column>) > 0. When not there is not enough free space for new
> inodes.
> 
> On another system we have which does not see these problems yet we have:
> 
>    from      to extents  blocks    pct
>       1       1 3483987 3483987   7.83
>       2       3 3560607 8709838  19.58
>       4       7 6402893 26486634  59.55
>       8      15  418450 5799206  13.04
> 
> 26486634 / 6402893 = 4.136666 and
> 26486634 - (4 * 6402893) = 875062 > 0 and
> 5799205 - (4 * 418450) = 4125405 > 0
> 
> 
> > into this condition.
> >
> > Cheers,
> >
> > Dave.
> > --
> > Dave Chinner
> > david@fromorbit.com
> >
> 
> Michel.

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
