Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 09 Jun 2008 16:14:43 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m59NEXIX014612
	for <xfs@oss.sgi.com>; Mon, 9 Jun 2008 16:14:34 -0700
Received: from rap.rap.dk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6B628209C79
	for <xfs@oss.sgi.com>; Mon,  9 Jun 2008 16:15:28 -0700 (PDT)
Received: from rap.rap.dk (213.237.47.228.adsl.vbr.worldonline.dk [213.237.47.228]) by cuda.sgi.com with ESMTP id G1yVpgj8JMWGBnAU for <xfs@oss.sgi.com>; Mon, 09 Jun 2008 16:15:28 -0700 (PDT)
Date: Tue, 10 Jun 2008 01:15:26 +0200
From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: Linux MD RAID 5 Benchmarks Across (3 to 10) 300 Gigabyte Veliciraptors
Message-ID: <20080609231526.GA6404@rap.rap.dk>
References: <alpine.DEB.1.10.0806071015110.23323@p34.internal.lan> <e9c3a7c20806071846w60b74aeegdf3e39afb36b5d9a@mail.gmail.com> <8CA981CB5C2B4D6-E68-18E2@MBLK-M14.sysops.aol.com> <A20315AE59B5C34585629E258D76A97CA535E9@34093-C3-EVS3.exchange.rackspace.com> <20080609142717.GB24950@rap.rap.dk> <A20315AE59B5C34585629E258D76A97CA536EF@34093-C3-EVS3.exchange.rackspace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <A20315AE59B5C34585629E258D76A97CA536EF@34093-C3-EVS3.exchange.rackspace.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Lethe <david@santools.com>
Cc: thomas62186218@aol.com, dan.j.williams@gmail.com, jpiszcz@lucidpixels.com, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com, ap@solarrain.com

On Mon, Jun 09, 2008 at 09:56:14AM -0500, David Lethe wrote:
> 
> 
> From: Keld Jørn Simonsen [mailto:keld@dkuug.dk] 
> Sent: Monday, June 09, 2008 9:27 AM
> To: David Lethe
> Cc: thomas62186218@aol.com; dan.j.williams@gmail.com; jpiszcz@lucidpixels.com; linux-kernel@vger.kernel.org; linux-raid@vger.kernel.org; xfs@oss.sgi.com; ap@solarrain.com
> Subject: Re: Linux MD RAID 5 Benchmarks Across (3 to 10) 300 Gigabyte Veliciraptors
> 
> For faster random IO I would suggest to use raid10,f2 for the random
> reading, it performs like raid0, something like more than double the
> speed of a normal single-drive file system. For random writes raid10,f2
> performs like most other mirrorred raids, given that data needs to be
> written twice.
> 
> Try and see if you can gat any HW raids to match that performance.
> 
> best regards
> keld
> 
> --------------------------------------------------------------------------------
> Keld:
> That is counter-intuitive. The issue is random IOPs, not throughput.

That probably depends on your use. I run Linux mirrors, and for that
purpose thruputi of random IO, especially reading, is key.

For data bases it is probably something else, probably IOP. here I also
think that Linux MD raid has good performance. Once again I think my pet
RAID type, raid10,f2 has something to offer, especially with lower
random seek rates, as the track span is shorter, and on the outer,
faster tracks.

And other uses may have other bottlenecks. In general I think that
thruput is an important figure, as it shows how fast a system can
process a given amount of data. Areas where this may count include web servers,
file servers, print servers, ordinary workstations.

I actually think those 2 measures for random IO: IO thruput, and IO transactions per
second, for read and write, are the two most important measures. 

For the IO transacions per second I agree that your suggestions are good
advice.

I would like to have good benchmarking tools for this, and also I would
like figures on how Linux MD compares to different HW RAID.

> I do not 
> understand how a RAID10 would provide more IOs per sec than RAID1. Or, since
> you are using RAID10, then how could RAID10 serve more random I/Os then a pair
> of RAID1 filesystems? 

In theory you are right. The MD implementation of RAID1 does not seem to
handle random seeks so well, AFAIK. Then the seeks are confined with
raid10,f2 to less than half of the disk arm movement, taht does speed
things up a little.

> RAID0 dictates that each disk will supply half 
> of the data you want per application I/O request. At least with RAID1, then each
> disk can get all the data you want with a single request, and dual-porting/load balancing 
> will allow both disks to work independently of each other on reads so the disk with
> the least amount of load at any time can work on the request. That is why RAID1 can be
> faster than JBOD.
> 
> Granted writes are handled differently, but with any RAID0 implementation you still have to write
> Half of the data to each disk requiring 2 I/Os + journaling & housekeeping.

yes, indeed.

best regards
keld
