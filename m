Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5AEC17F5E
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 04:31:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0CCF9AC002
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 02:31:23 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	JkkuFaAnxtjLQFLO for <xfs@oss.sgi.com>;
	Wed, 16 Apr 2014 02:31:21 -0700 (PDT)
Date: Wed, 16 Apr 2014 19:31:06 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Seeking XFS tuning advice for PostgreSQL on SATA SSDs/Linux-md
Message-ID: <20140416093106.GL15995@dastard>
References: <534D24AB.1050605@geizhals.at> <20140415213408.GL15995@dastard>
	<534E3D98.3000600@geizhals.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <534E3D98.3000600@geizhals.at>
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
To: Johannes Truschnigg <johannes.truschnigg@geizhals.at>
Cc: xfs@oss.sgi.com

On Wed, Apr 16, 2014 at 10:21:44AM +0200, Johannes Truschnigg wrote:
> Hi Dave,
> 
> On 04/15/2014 11:34 PM, Dave Chinner wrote:
> >On Tue, Apr 15, 2014 at 02:23:07PM +0200, Johannes Truschnigg wrote:
> >>Hi list,
> >>[...]
> >>o Intel C606-based Dual 4-Port SATA/SAS HBA (PCIID 8086:1d68)
> >
> >How much write cache does this have?
> 
> It's a plain HBA; it doesn't have write cache (or a BBU) of its own.

Ok, so nothing to isolate nasty bad IO patterns from the drives,
or to soak up write peaks. IOWs, what the drives give you is all
you're going to get. You might want to think about dropping $1000 on
a good quality LSI SAS RAID HBA and putting the disks behind that...

> >>o 6x Samsung 830 SSD with 512GB each, 25% reserved for HPA
> >
> >830? That's the previous generation of drives - do you mean 840?
> 
> No, I really mean 830 - we've tested 840 EVO as well, and they
> performed quite well, too, however from what I've seen on the web
> the longevity of Samsung's TLC flash choice in 840 disks isn't as
> promising as those of the 830s MLC variant. We might be switching
> over to 840 EVO or one of their successors once the 830s wear out,
> or we need to expand capacity, but we do have a number of 830s in
> stock that we'll use first.

What I've read is "there's really no difference". Yes, there are
less write/erase cycles for the 21nm TLC compared to the 27nm MLC in
the 830s, but the controller in the 840 is far better at handling
wear levelling.

> >>When benchmarking the individual SSDs with fio (using the libaio
> >>backend), the IOPS we've seen were in the 30k-35k range overall for
> >>4K block sizes.
> >
> >They don't sustain that performance over 20+ minutes of constant IO,
> >though. Even if you have 840s (I have 840 EVOs in my test rig), the
> >sustained performance of 4k random write IOPS is somewhere around
> >4-6k each. See, for example, the performance consistency graphs here:
> >
> >http://www.anandtech.com/show/7173/samsung-ssd-840-evo-review-120gb-250gb-500gb-750gb-1tb-models-tested/6
> >
> >Especially the last one that shows a zoomed view of the steady state
> >behaviour between 1400s and 2000s of constant load.
> 
> I used tkperf[0] to benchmark the devices, both on Intel's SAS HBA
> and on a LSI 2108 SAS RAID-Controller. I did runs for the 512GB 830
> with 25% over-provisioning, and runs for 1TB 840 EVO with 0% op and
> 25% op (two different disks with the same firmware). tkperf tries
> hard to achieve steady state by torturing the devices for a few
> hours before the actual benchmarking takes place, and will only do
> so after that steady state has been reached.
> 
> From what I've seen, the over-provisioning is absolutely crucial to
> get anywhere near acceptable performance; since Anandtech doesn't
> seem to use it, I'll trust my tests more.

Oh, they do, just not in every SSD review they do:

http://anandtech.com/show/7864/crucial-m550-review-128gb-256gb-512gb-and-1tb-models-tested/3

Unfortunately, there aren't 25% spare area numbers for the 840EVO...

> For reference: the 750GB usable-space EVO clocked in at ~35k 4k IOPS
> on the LSI 2108, whilst the 1000GB usable-space sister disk still
> hasn't finished the benchmark run, because it's _so much slower_.

Yes, apart from validation effort, that's the main difference
between consumer and enterprise SSDs; enterprise SSDs usually run
20-25% over provisioned space but are otherwise mostly identical
hardware and firmware to the consumer drives.  That's why you get
200, 400 and 800GB enterprise drives rather than 250, 500, and 1TB
capacities...

> >>After digging through linux-raid archives, I think the most sensible
> >>approach are two-disk pairs in RAID1 that are concatenated via
> >>either LVM2 or md (leaning towards the latter, since I'd expect that
> >>to have a tad less overhead),
> >
> >I'd stripe them (i.e. RAID10), not concantenate them so as to load
> >both RAID1 legs evenly.
> 
> Afaik, the problem with md is that each array (I'm pretty convinced
> that also holds true for RAID10, but I'm not 100% sure) only has one
> associated kernel thread for writes,

I think it used to have a single thread for parity calculations,
which is not used for raid 0/1/10, so I don't think that's true
anymore. There were patches to multithread the parity calculations,
no idea what the status of that work ended being...

> which should make that kind of
> setup worse, at least in theory and in terms of achiveable
> parallelism, than the setup I described. I'd be very happy to see a
> comparison between the two setups for high-IOPS devices, but I
> haven't yet found one anywhere.

I don't think it makes any difference at all. I have both LVM and MD
RAID 0 SSD stripes, and neither MD nor DM are the performance
limiting factor, nor do they show up anywhere in profiles.

> > [...]
> >>I've experimented with mkfs.xfs (on top of LVM only; I don't know if
> >>it takes into account lower block layers and seen that it supposedly
> >>chooses to default to an agcount of 4, which seems insufficient
> >>given the max. bandwidth our setup should be able to provide.
> >
> >The number of AGs has no bearing on acheivable bandwidth. The number
> >of AGs affects allocation concurrency. Hence if you have 24 CPU
> >cores, I'd expect that you want 32 AGs. Normally with a RAID array
> >this will be the default, but it seems that RAID1 is not triggering
> >the "optimise for allocation concurrency" heuristics in mkfs....
> 
> Thanks, that is a very useful heads-up! What's the formula used to
> get to 32 AGs for 24 CPUs - just (num_cpus * 4/3), and is there a
> simple explanation for why this is an ideal starting point? And is
> that an advisable rule of thumb for xfs in general?

Simple explanation: 32 is the default for RAID5/6 based devices
between 1-32TB in size.

General rule of thumb:

http://xfs.org/index.php/XFS_FAQ#Q:_I_want_to_tune_my_XFS_filesystems_for_.3Csomething.3E

> >>Apart from that, is there any kind of advice you can share for
> >>tuning xfs to run postgres (9.0 initially, but we're planning to
> >>upgrade to 9.3 or later eventually) on in 2014, especially
> >>performance-wise?
> >
> >Apart from the AG count and perhaps tuning the sunit/swidth to match
> >the RAID0 part of the equation, I wouldn't touch a thing unless you
> >know that there's a problem that needs fixing and you know exactly
> >what knob will fix the problem you have...
> 
> OK, I'll read up on stripe width impact and will (hopefully) have
> enough time to test a number of configs that should make sense.

http://xfs.org/index.php/XFS_FAQ#Q:_How_to_calculate_the_correct_sunit.2Cswidth_values_for_optimal_performance

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
