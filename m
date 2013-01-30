Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A365B7F4E
	for <xfs@oss.sgi.com>; Wed, 30 Jan 2013 02:54:56 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 33D12AC001
	for <xfs@oss.sgi.com>; Wed, 30 Jan 2013 00:54:53 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id 2xJCNGVWPklJfa6Z
	for <xfs@oss.sgi.com>; Wed, 30 Jan 2013 00:54:52 -0800 (PST)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id C3CE86C0B9
	for <xfs@oss.sgi.com>; Wed, 30 Jan 2013 02:54:51 -0600 (CST)
Message-ID: <5108DFE0.2060908@hardwarefreak.com>
Date: Wed, 30 Jan 2013 02:54:56 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: XFS appears to cause strange hang with md raid1 on reboot
References: <32271.192.104.24.222.1359415698.squirrel@secure.skymagik.net>
	<5107124E.70607@sandeen.net>
	<20821.192.104.24.222.1359496079.squirrel@secure.skymagik.net>
	<51084544.6050907@sandeen.net>
	<22819.192.104.24.222.1359498326.squirrel@secure.skymagik.net>
In-Reply-To: <22819.192.104.24.222.1359498326.squirrel@secure.skymagik.net>
Reply-To: stan@hardwarefreak.com
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
To: xfs@oss.sgi.com

On 1/29/2013 4:25 PM, Tom wrote:

> For the SGI engineers on this list, I do miss IRIX though...  it will
> always have a special place in my heart -- if only that OS and its tools
> could have been open sourced...

Much of the differentiating/unique technology has been.  XFS and its
user space tools obviously.  Lesser known is that Paul Jackson and
others at SGI contributed the basic NUMA scalability code to Linux
during the Linux Scalability Effort in the early 2000s, based heavily on
IRIX concepts.  This included cpumemsets, directly taken from IRIX IIRC,
which evolved into Linux mainline cpusets.

This effort was necessary to get Linux to scale on Altix NUMALink
systems with up to 512 sockets, as well as IBM's Xeon based x440 NUMA
box with up to 16 sockets, HP's cell based Itanium systems w/32 sockets,
and clones of HP's cell design used by the likes of Bull, Unisys, NEC,
and others.  This work later turned out to be of great benefit to the
market at large, as the underpinnings were already in place when AMD
launched Opteron, whose 2/4/8 socket platforms use HT NUMA
interconnects.  Same for Intel when it finally went NUMA with QuickPath.
 This infrastructure also allowed for a relatively easy implementation
of multi-core support on single and multi-socket systems.

AIUI, from articles, not first hand experience,  is that what did not
make it into Linux was the tendency of some SGI engineers to write
bloated inefficient code with unnecessarily large data structures.  This
occurred because IRIX developers were working on 8-32 CPU systems (or
larger) with 8-32GB (or more) of RAM, and weren't concerned with single
processor performance or memory efficiency, as they had massive
resources available.  When the scalability concepts were brought over to
Linux, they were bolted onto the mantra of maximum single processor
performance and small memory footprint, and we got the best of both
worlds, without the previous IRIX overhead.

I recall reading an article from that period which described an early
Linux porting effort to Origin/MIPS.  This was a 16-way machine used as
a development mule to get Linux working on NUMALink, ready for
Altix/Itanium.  It was described that even before any NUMA scalability
work began, with a large number of operations the stock SMP Linux kernel
was much faster than IRIX on this 16 CPU origin box.  "Amazing" is a
description I recall.  It had been assumed Linux would be a dog since it
was optimized for small systems.  It turns out it worked just as well on
the big ones, due to said small system optimizations.

So in some respects it's probably better that IRIX simply was abandoned,
with some of the best parts making it into Linux.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
