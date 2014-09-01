Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9236C7F66
	for <xfs@oss.sgi.com>; Mon,  1 Sep 2014 18:45:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 12E52AC001
	for <xfs@oss.sgi.com>; Mon,  1 Sep 2014 16:45:36 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	Cx1sDyWPS7jgwOvG for <xfs@oss.sgi.com>;
	Mon, 01 Sep 2014 16:45:34 -0700 (PDT)
Date: Tue, 2 Sep 2014 09:45:29 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: storage, libaio, or XFS problem?  3.4.26
Message-ID: <20140901234529.GI20518@dastard>
References: <20140826075345.GJ20518@dastard>
	<8c29baf987467a84f0b7c1d09c863662@localhost>
	<20140828003226.GO20518@dastard>
	<7f9e5aef187b44e899077467aeb0809d@localhost>
	<20140828230817.GU20518@dastard>
	<2d2ce7bb38c00a7d35f4a324f6a36cbb@localhost>
	<20140829235538.GF20518@dastard>
	<d20fe777ec1fd318ae5d4054dffda3f4@localhost>
	<20140831235749.GH20518@dastard>
	<5403E9B9.7040608@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5403E9B9.7040608@hardwarefreak.com>
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

On Sun, Aug 31, 2014 at 10:36:25PM -0500, stan hoeppner wrote:
> On 08/31/2014 06:57 PM, Dave Chinner wrote:
> > On Fri, Aug 29, 2014 at 09:55:53PM -0500, Stan Hoeppner wrote:
> >> Have you played with bcache yet?
> > 
> > Enough to scare me. So many ways for things to go wrong, no easy way
> > to recover when things go wrong. And that's before I even get to
> > performance warts, like having systems stall completely because
> > there's tens or hundreds of GB of 4k random writes that have to be
> > flushed to slow SATA RAID6 in the cache....
> 
> Yikes.  I hadn't yet heard such opinions expressed.  By go wrong I
> assume you mean the btrees or cached sector data getting broken, corrupted?

bcache is a complex filesystem hidden inside a block device. If
bcache goes AWOL, so does the all the data on your block device.
Need I say more?

> > PS: can you wrap your text at 68 or 72 columns so quoted text
> > doesn't overflow 80 columns and get randomly wrapped and messed up?
> 
> This email should be.  Lemme see what I can do with the others.  The
> lovely Cisco VPN client I must use kills routing to my local subnet, so
> Icedovce can't connect to my IMAP server when the VPN is active.  The
> test hardness app requires a shell unfortunately so I have to keep the
> tunnel open all the time, as the test runs are 40+ hours each.  My last
> test just crashed a bit ago so I can use Icedove for this reply.

screen is your friend when it comes to keeping remote shells
active as the network comes and goes. VPN drops out, just bring it
back up when you need it and reconnect to the remote screen instance
and it's like you never left....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
