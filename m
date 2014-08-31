Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 114A97F5A
	for <xfs@oss.sgi.com>; Sun, 31 Aug 2014 18:57:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D7835304043
	for <xfs@oss.sgi.com>; Sun, 31 Aug 2014 16:57:54 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	itVnS03yFw7MJ93U for <xfs@oss.sgi.com>;
	Sun, 31 Aug 2014 16:57:52 -0700 (PDT)
Date: Mon, 1 Sep 2014 09:57:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: storage, libaio, or XFS problem?  3.4.26
Message-ID: <20140831235749.GH20518@dastard>
References: <3fe8c34c0ccbbd720015d273fa2b8b30@localhost>
	<20140826075345.GJ20518@dastard>
	<8c29baf987467a84f0b7c1d09c863662@localhost>
	<20140828003226.GO20518@dastard>
	<7f9e5aef187b44e899077467aeb0809d@localhost>
	<20140828230817.GU20518@dastard>
	<2d2ce7bb38c00a7d35f4a324f6a36cbb@localhost>
	<20140829235538.GF20518@dastard>
	<d20fe777ec1fd318ae5d4054dffda3f4@localhost>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <d20fe777ec1fd318ae5d4054dffda3f4@localhost>
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
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: xfs@oss.sgi.com

On Fri, Aug 29, 2014 at 09:55:53PM -0500, Stan Hoeppner wrote:
> On Sat, 30 Aug 2014 09:55:38 +1000, Dave Chinner <david@fromorbit.com> wrote:
> > On Fri, Aug 29, 2014 at 11:38:16AM -0500, Stan Hoeppner wrote:
> >> 
> >> Another storage crash yesterday.  xfs_repair output inline below for the 7
> >> filesystems.  I'm also pasting the dmesg output.  This time there is no
> >> oops, no call traces.  The filesystems mounted fine after mounting,
> >> replaying, and repairing. 
> > 
> > Ok, what version of xfs_repair did you use?
> 
> 3.1.4 which is a little long in the tooth.

And so not useful for th epurposes of finding free space tree
corruptions. Old xfs_repair versions only rebuild the freespace
trees - they don't check them first. IOWs, silence from an old
xfs_repair does not mean the filesystem was free of errors.

> >> This because some of our writes for a given low rate stream are as low as
> >> 32KB and may be 2-3 seconds apart.  With a 64-128KB chunk, 768 to 1536KB
> >> stripe width, we'd get massive RMW without this feature.  Testing thus
> >> far
> >> shows it is fairly effective, though we still get pretty serious RMW due
> >> to
> >> the fact we're writing 350 of these small streams per array at ~72 KB/s
> >> max, along with 2 streams at ~48 MB/s, and and 50 streams at ~1.2 MB/s.
> 
> >> Multiply this by 7 LUNs per controller and it becomes clear we're
> >> putting a
> >> pretty serious load on the firmware and cache.
> > 
> > Yup, so having the array cache do the equivalent of sequential
> > readahead multi-stream detection for writeback would make a big
> > difference. But not simple to do....
> 
> Not at all, especially with only 3 GB of RAM to work with, as I'm told. 
> Seems low for a high end controller with 4x 12G SAS ports.  We're only able
> to achieve ~250 MB/s per array at the application due to the access pattern
> being essentially random, and still with a serious quantity of RMWs.  Which
> is why we're going to test with an even smaller chunk of 32KB.  I believe
> that's the lower bound on these controllers.  For this workload 16KB or
> maybe even 8KB would likely be more optimal.  We're also going to test with
> bcache and a 400 GB Intel 3700 (datacenter grade) SSD backing two LUNs. 
> But with bcache chunk size should be far less relevant.  I'm anxious to
> kick those tires, but it'll be a couple of weeks.
> 
> Have you played with bcache yet?

Enough to scare me. So many ways for things to go wrong, no easy way
to recover when things go wrong. And that's before I even get to
performance warts, like having systems stall completely because
there's tens or hundreds of GB of 4k random writes that have to be
flushed to slow SATA RAID6 in the cache....

Cheers,

Dave.

PS: can you wrap your text at 68 or 72 columns so quoted text
doesn't overflow 80 columns and get randomly wrapped and messed up?

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
