Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 890A37F55
	for <xfs@oss.sgi.com>; Tue,  2 Sep 2014 17:20:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7660A304066
	for <xfs@oss.sgi.com>; Tue,  2 Sep 2014 15:19:57 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	igUdXgNIV7wivOyJ for <xfs@oss.sgi.com>;
	Tue, 02 Sep 2014 15:19:52 -0700 (PDT)
Date: Wed, 3 Sep 2014 08:19:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: storage, libaio, or XFS problem?  3.4.26
Message-ID: <20140902221915.GK20518@dastard>
References: <20140828003226.GO20518@dastard>
	<7f9e5aef187b44e899077467aeb0809d@localhost>
	<20140828230817.GU20518@dastard>
	<2d2ce7bb38c00a7d35f4a324f6a36cbb@localhost>
	<20140829235538.GF20518@dastard>
	<d20fe777ec1fd318ae5d4054dffda3f4@localhost>
	<20140831235749.GH20518@dastard>
	<5403E9B9.7040608@hardwarefreak.com>
	<20140901234529.GI20518@dastard>
	<5405FB19.2020208@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5405FB19.2020208@hardwarefreak.com>
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
To: stan hoeppner <stan@hardwarefreak.com>
Cc: xfs@oss.sgi.com

On Tue, Sep 02, 2014 at 12:15:05PM -0500, stan hoeppner wrote:
> On 09/01/2014 06:45 PM, Dave Chinner wrote:
> > On Sun, Aug 31, 2014 at 10:36:25PM -0500, stan hoeppner wrote:
> >> On 08/31/2014 06:57 PM, Dave Chinner wrote:
> >>> On Fri, Aug 29, 2014 at 09:55:53PM -0500, Stan Hoeppner wrote:
> >>>> Have you played with bcache yet?
> >>>
> >>> Enough to scare me. So many ways for things to go wrong, no easy way
> >>> to recover when things go wrong. And that's before I even get to
> >>> performance warts, like having systems stall completely because
> >>> there's tens or hundreds of GB of 4k random writes that have to be
> >>> flushed to slow SATA RAID6 in the cache....
> >>
> >> Yikes.  I hadn't yet heard such opinions expressed.  By go wrong I
> >> assume you mean the btrees or cached sector data getting broken, corrupted?
> > 
> > bcache is a complex filesystem hidden inside a block device. If
> > bcache goes AWOL, so does the all the data on your block device.
> > Need I say more?
> 
> So it's no different in that regard than the black box implementations
> such as LSI's CacheCade and various SAN vendor SSD caching
> implementations.  Or are you saying the bcache code complexity is so
> much greater that failure is more likely that the vendor implementations?

No, not the code complexity in particular. It's more that compared
to vendor SSD caching implementations there's an awful lot less
testing and validation, and people tend to use random, unreliable
hardware for cache devices. It's great when it works, but the
configuration and validation of correct behaviour in error
conditions falls to the user...

> > screen is your friend when it comes to keeping remote shells
> > active as the network comes and goes. VPN drops out, just bring it
> > back up when you need it and reconnect to the remote screen instance
> > and it's like you never left....
> 
> Thanks for this tip.  I'd heard of screen before but never used it.  I
> will say the man page is a bit intimidating for such an apparently
> simple tool...

Yeah, I use about 0.0001% of what screen can do. It could lose most
of it's functionality and I wouldn't notice or care. tmux is another
option for this functionality, but I've never used it because I
found out about screen first...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
