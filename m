Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9706gD7208552 for <xfs@oss.sgi.com>; Thu, 6 Oct 2011 19:06:42 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D7CCE1C6FAB7
	for <xfs@oss.sgi.com>; Thu,  6 Oct 2011 17:06:40 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	brQfrD6hHopXnoBv for <xfs@oss.sgi.com>;
	Thu, 06 Oct 2011 17:06:40 -0700 (PDT)
Date: Fri, 7 Oct 2011 11:06:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] repair: fix some valgrind reported errors on i686
Message-ID: <20111007000627.GV3159@dastard>
References: <1317862891-3033-1-git-send-email-david@fromorbit.com>
	<1317862891-3033-3-git-send-email-david@fromorbit.com>
	<1317903472.3139.30.camel@doink> <20111006221542.GU3159@dastard>
	<1317941658.2870.50.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1317941658.2870.50.camel@doink>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Oct 06, 2011 at 05:54:18PM -0500, Alex Elder wrote:
> On Fri, 2011-10-07 at 09:15 +1100, Dave Chinner wrote:
> > On Thu, Oct 06, 2011 at 07:17:52AM -0500, Alex Elder wrote:
> > > On Thu, 2011-10-06 at 12:01 +1100, Dave Chinner wrote:
> > > > @@ -218,6 +244,15 @@ blkmap_grow(
> > > >  	}
> > > >  
> > > >  	blkmap->naexts += 4;
> > > 
> > > The check needs to go *before* you update naexts.
> > 
> > It's in the right place - adding 4 to the unchecked extent count can
> > push it over the limit, so we have to check it after adding 4 to it.
> 
> My point was that I'd rather see the check be whether it *will*
> overflow, rather than allowing it to overflow.
> 
> The other reason though, even if you do the calculation
> at that spot, is that you shouldn't update what blkmap
> records as the number of allocated extents unless you
> have actually updated it the amount of allocated memory.
> As it stands, you will have updated blkmap->naexts, then
> if it overflows you return before actually attempting
> to reallocate.
> 
> In other words, blkmap->naexts should reflect the actual
> amount of memory allotted in the blkmap->exts array, which
> is not going to be the case if it returns early (and this
> can be avoided).

Fair point.

And just checking the single caller of blkmap_grow indicates that it
doesn't handle allocation failure *at all*, so I need to fix that as
well.

> > IOWs, we can't use BLKMAP_SIZE to detect an overflow, because it
> > is the code that overflows...
> 
> I understand that argument.  I'm in a hurry at the moment so
> I haven't thought through this very well right now.
> 
> But if you do have BLKMAP_NENTS_MAX, you could check nex
> against that before attempting to use BLKMAP_SIZE to
> compute how many bytes need to be allocated.

Yup, that's what the patch does, just without the BLKMAP_NENTS_MAX
macro. Which I've already added. ;)

FWIW, because the extent count fields are all signed ints,
overflow checks also need to check for values <= 0. So I've added
that too.

And I think now I need to split this into separate patches for each
issue, as there are now about 5 different problems this one patch
fixes.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
