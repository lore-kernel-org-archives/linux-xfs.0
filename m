Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 951A17F53
	for <xfs@oss.sgi.com>; Tue,  2 Sep 2014 12:15:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 32B14AC003
	for <xfs@oss.sgi.com>; Tue,  2 Sep 2014 10:15:07 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id fV9YsJOgMCmCGKtG
	for <xfs@oss.sgi.com>; Tue, 02 Sep 2014 10:15:06 -0700 (PDT)
Message-ID: <5405FB19.2020208@hardwarefreak.com>
Date: Tue, 02 Sep 2014 12:15:05 -0500
From: stan hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: storage, libaio, or XFS problem?  3.4.26
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
	<20140901234529.GI20518@dastard>
In-Reply-To: <20140901234529.GI20518@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 09/01/2014 06:45 PM, Dave Chinner wrote:
> On Sun, Aug 31, 2014 at 10:36:25PM -0500, stan hoeppner wrote:
>> On 08/31/2014 06:57 PM, Dave Chinner wrote:
>>> On Fri, Aug 29, 2014 at 09:55:53PM -0500, Stan Hoeppner wrote:
>>>> Have you played with bcache yet?
>>>
>>> Enough to scare me. So many ways for things to go wrong, no easy way
>>> to recover when things go wrong. And that's before I even get to
>>> performance warts, like having systems stall completely because
>>> there's tens or hundreds of GB of 4k random writes that have to be
>>> flushed to slow SATA RAID6 in the cache....
>>
>> Yikes.  I hadn't yet heard such opinions expressed.  By go wrong I
>> assume you mean the btrees or cached sector data getting broken, corrupted?
> 
> bcache is a complex filesystem hidden inside a block device. If
> bcache goes AWOL, so does the all the data on your block device.
> Need I say more?

So it's no different in that regard than the black box implementations
such as LSI's CacheCade and various SAN vendor SSD caching
implementations.  Or are you saying the bcache code complexity is so
much greater that failure is more likely that the vendor implementations?

>>> PS: can you wrap your text at 68 or 72 columns so quoted text
>>> doesn't overflow 80 columns and get randomly wrapped and messed up?
>>
>> This email should be.  Lemme see what I can do with the others.  The
>> lovely Cisco VPN client I must use kills routing to my local subnet, so
>> Icedovce can't connect to my IMAP server when the VPN is active.  The
>> test hardness app requires a shell unfortunately so I have to keep the
>> tunnel open all the time, as the test runs are 40+ hours each.  My last
>> test just crashed a bit ago so I can use Icedove for this reply.
> 
> screen is your friend when it comes to keeping remote shells
> active as the network comes and goes. VPN drops out, just bring it
> back up when you need it and reconnect to the remote screen instance
> and it's like you never left....

Thanks for this tip.  I'd heard of screen before but never used it.  I
will say the man page is a bit intimidating for such an apparently
simple tool...

Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
