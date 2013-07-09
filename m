Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D912E7F75
	for <xfs@oss.sgi.com>; Mon,  8 Jul 2013 19:15:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C8F6C30405F
	for <xfs@oss.sgi.com>; Mon,  8 Jul 2013 17:15:20 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	IGWEeDGgyWu1VtDI for <xfs@oss.sgi.com>;
	Mon, 08 Jul 2013 17:15:19 -0700 (PDT)
Date: Tue, 9 Jul 2013 10:15:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Some baseline tests on new hardware (was Re: [PATCH] xfs:
	optimise CIL insertion during transaction commit [RFC])
Message-ID: <20130709001516.GE3438@dastard>
References: <1372657476-9241-1-git-send-email-david@fromorbit.com>
	<20130708124453.GC3438@dastard>
	<20130708135953.GF5988@quack.suse.cz> <51DAD943.6050703@gmail.com>
	<20130708153807.GC12743@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130708153807.GC12743@quack.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: Marco Stornelli <marco.stornelli@gmail.com>, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Mon, Jul 08, 2013 at 05:38:07PM +0200, Jan Kara wrote:
> On Mon 08-07-13 17:22:43, Marco Stornelli wrote:
> > Il 08/07/2013 15:59, Jan Kara ha scritto:
> > >On Mon 08-07-13 22:44:53, Dave Chinner wrote:
> > ><snipped some nice XFS results ;)>
> > >>So, lets look at ext4 vs btrfs vs XFS at 16-way (this is on the
> > >>3.10-cil kernel I've been testing XFS on):
> > >>
> > >>	    create		 walk		unlink
> > >>	 time(s)   rate		time(s)		time(s)
> > >>xfs	  222	266k+-32k	  170		  295
> > >>ext4	  978	 54k+- 2k	  325		 2053
> > >>btrfs	 1223	 47k+- 8k	  366		12000(*)
> > >>
> > >>(*) Estimate based on a removal rate of 18.5 minutes for the first
> > >>4.8 million inodes.
> > >>
> > >>Basically, neither btrfs or ext4 have any concurrency scaling to
> > >>demonstrate, and unlinks on btrfs a just plain woeful.
> > >   Thanks for posting the numbers. There isn't anyone seriously testing ext4
> > >SMP scalability AFAIK so it's not surprising it sucks.

It's worse than that - nobody picked up on review that taking a
global lock on every extent lookup might be a scalability issue?
Scalability is not an afterthought anymore - new filesystem and
kernel features need to be designed from the ground up with this in
mind. We're living in a world where even phones have 4 CPU cores....

> > Funny, if I well remember Google guys switched android from yaffs2
> > to ext4 due to its superiority on SMP :)
>   Well, there's SMP and SMP. Ext4 is perfectly OK for desktop kind of SMP -

Barely. It tops out in parallelism at between 2-4 threads depending
on the metadata operations being done.

> that's what lots of people use. When we speak of heavy IO load with 16 CPUs
> on enterprise grade storage so that CPU (and not IO) bottlenecks are actually
> visible, that's not so easily available and so we don't have serious
> performance work in that direction...

I'm not testing with "enterprise grade" storage. The filesystem I'm
testing on is hosted on less than $300 of SSDs.  The "enterprise"
RAID controller they sit behind is actually an IOPS bottleneck, not
an improvement.

My 2.5 year old desktop has a pair of cheap, no name sandforce SSDs
in RAID0 and they can do at least 2x the read and write IOPS of the
new hardware I just tested. And yes, I run XFS on my desktop.

And then there's my 3 month old laptop, which has a recent SATA SSD
in it. It also has 8 threads, but twice the memory and about 1.5x
the IOPS and bandwidth of my desktop machine.

The bottlenecks showing up in ext4 and btrfs don't magically show up
at 16 threads - they are present and reproducable at 2-4 threads.
Indeed, I didn't bother testing at 32 threads - even though my new
server can do that - because that will just hammer the same
bottlenecks even harder.  Fundamentally, I'm not testing anything
you can't test on a $2000 desktop PC....

FWIW, the SSDs are making ext4 and btrfs look good in these
workloads. XFS is creating >250k files/s doing about 1500 IOPS. ext4
is making 50k files/s at 23,000 IOPS. btrfs has peaks every 30s of
over 30,000 IOPS. Which filesystem is going to scale better on
desktops with spinning rust?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
