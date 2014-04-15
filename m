Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DD55B7F3F
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 16:34:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DFDD98F8052
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 14:34:25 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	C9gu8598nDnHNDRB for <xfs@oss.sgi.com>;
	Tue, 15 Apr 2014 14:34:23 -0700 (PDT)
Date: Wed, 16 Apr 2014 07:34:08 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Seeking XFS tuning advice for PostgreSQL on SATA SSDs/Linux-md
Message-ID: <20140415213408.GL15995@dastard>
References: <534D24AB.1050605@geizhals.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <534D24AB.1050605@geizhals.at>
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

On Tue, Apr 15, 2014 at 02:23:07PM +0200, Johannes Truschnigg wrote:
> Hi list,
> 
> we're building a postgres streaming replication slave that's
> supposed to pick up work if our primary pg cluster (with an
> all-flash FC SAN appliance as its backend store) goes down. We'll be
> using consumer-grade hardware for this setup, which I detail below:
> 
> o 2x Intel Xeon E5-2630L (24 threads total)
> o 512GB DDR3 ECC RDIMM
> o Intel C606-based Dual 4-Port SATA/SAS HBA (PCIID 8086:1d68)

How much write cache does this have?

> o 6x Samsung 830 SSD with 512GB each, 25% reserved for HPA

830? That's the previous generation of drives - do you mean 840?

> o Debian GNU/Linux 7.x "Wheezy" + backports kernel (3.13+)
> o PostgreSQL 9.0
> 
> If there's anything else that is of critical interest that I forgot
> to mention, hardware- or software-wise, please let me know.
> 
> When benchmarking the individual SSDs with fio (using the libaio
> backend), the IOPS we've seen were in the 30k-35k range overall for
> 4K block sizes.

They don't sustain that performance over 20+ minutes of constant IO,
though. Even if you have 840s (I have 840 EVOs in my test rig), the
sustained performance of 4k random write IOPS is somewhere around
4-6k each. See, for example, the performance consistency graphs here:

http://www.anandtech.com/show/7173/samsung-ssd-840-evo-review-120gb-250gb-500gb-750gb-1tb-models-tested/6

Especially the last one that shows a zoomed view of the steady state
behaviour between 1400s and 2000s of constant load.

The 830 series are old enough that they were reviewed before this
was considered an important metric for SSD comparison, and so there
is no equivalent information available for them. However, they are
likely to be significantly slower and less deterministic in their
behaviour than the 840s under the same load...

> The host will be on the receiving end of a pg9.0
> streaming replication cluster setup where the master handles ~50k
> IOPS peak, and I'm thinking what'd be a good approach to design the
> local storage stack (with availability in mind) in a way that has a
> chance to keep up with our flash-based FC SAN.

I'd be surprised if it can keep up after a couple of months of
production level IO going to the SSDs...

> After digging through linux-raid archives, I think the most sensible
> approach are two-disk pairs in RAID1 that are concatenated via
> either LVM2 or md (leaning towards the latter, since I'd expect that
> to have a tad less overhead),

I'd stripe them (i.e. RAID10), not concantenate them so as to load
both RAID1 legs evenly.

> and xfs on top of that resulting block
> device. That should yield roughly 1.2TB of usable space (we need a
> minimum of 900GB for the DB). With this setup, it should be possible
> to have up to 3 CPUs busy with handling I/O on the block side of
> things, which raises the question what'd be a sensible value to
> choose for xfs' Allocation Group Count/agcount.
> 
> I've been trying to find information on that myself, but what I
> managed to dig up is, at times, so old that it seems rather
> outlandish today - some sources on the web (from 2003), for example,
> say that one AG per 4GB of underlying diskspace makes sense, which
> seems excessive for a 1200GB volume.
> 
> I've experimented with mkfs.xfs (on top of LVM only; I don't know if
> it takes into account lower block layers and seen that it supposedly
> chooses to default to an agcount of 4, which seems insufficient
> given the max. bandwidth our setup should be able to provide.

The number of AGs has no bearing on acheivable bandwidth. The number
of AGs affects allocation concurrency. Hence if you have 24 CPU
cores, I'd expect that you want 32 AGs. Normally with a RAID array
this will be the default, but it seems that RAID1 is not triggering
the "optimise for allocation concurrency" heuristics in mkfs....

> Apart from that, is there any kind of advice you can share for
> tuning xfs to run postgres (9.0 initially, but we're planning to
> upgrade to 9.3 or later eventually) on in 2014, especially
> performance-wise?

Apart from the AG count and perhaps tuning the sunit/swidth to match
the RAID0 part of the equation, I wouldn't touch a thing unless you
know that there's a problem that needs fixing and you know exactly
what knob will fix the problem you have...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
