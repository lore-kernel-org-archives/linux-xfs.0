Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 97A787F9D
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 20:52:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0B865AC002
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 18:52:54 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	y87ZTqE3cWeErktd for <xfs@oss.sgi.com>;
	Tue, 02 Jun 2015 18:52:52 -0700 (PDT)
Date: Wed, 3 Jun 2015 11:52:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: "XFS: possible memory allocation deadlock in kmem_alloc" on high
	memory machine
Message-ID: <20150603015245.GN24666@dastard>
References: <20150601145741.GA16608@otto> <20150601210113.GL24666@dastard>
	<20150602120648.GA22111@otto>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150602120648.GA22111@otto>
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
To: Anders Ossowicki <aowi@novozymes.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Tue, Jun 02, 2015 at 02:06:48PM +0200, Anders Ossowicki wrote:
> On Mon, Jun 01, 2015 at 11:01:13PM +0200, Dave Chinner wrote:
> > Nothing should go wrong - XFS will essentially block until it gets
> > the memory it requires.
> 
> Good to know, thanks!
> 
> > > We're running on 3.18.13, built from kernel.org git.
> > 
> > Right around the time that I was seeing all sorts of regressions
> > relating to low memory behaviour and the OOM killer....
> 
> We fought with some high cpu load issues back in march, related to
> memory management, and we ended up on a recent longterm kernel.
> http://thread.gmane.org/gmane.linux.kernel.mm/129858
> 
> > Ouch. 3TB of memory, and no higher order pages left? Do you have
> > memory compaction turned on? That should be reforming large pages in
> > this situation. What type of machine is it?
> 
> Memory compaction is turned on. It's an off-the-shelf dell server with 4
> 12c Xeon processors.
> 
> > Yes, memory fragmentation tends to be a MM problem; nothing XFS can
> > do about it.
> 
> Ya, knowing we're not in immediate danger of a filesystem meltdown, I
> think we'll tackle the fragmentation issue next.
> 
> > Especially as it appears that 2.8TB of your memory is in the page
> > cache and should be reclaimable.
> 
> Indeed. I haven't been able to catch the issue while it was ongoing,
> since upgrading to 3.13.18, but my guess is that we're not reclaiming
> the cache fast enough for some reason, possibly because it takes too
> long to find the best reclaimable regions with so many fragment to sift
> through.

You can always try to drop the page cache to see if that solves the
problem...

> As for the pertinent system info:
> 
> Linux 3.18.13 (we also saw the issue with 3.18.9)
> xfs_repair version 3.1.7
> 
> 4x Intel Xeon E7-8857 v2
> 
> $ cat /proc/meminfo
> MemTotal:       3170749444 kB
> MemFree:        18947564 kB
> MemAvailable:   2968870324 kB
> Buffers:          270704 kB
> Cached:         3008702200 kB
> SwapCached:            0 kB
> Active:         1617534420 kB
> Inactive:       1415684856 kB
> Active(anon):   156973416 kB
> Inactive(anon):  4856264 kB
> Active(file):   1460561004 kB
> Inactive(file): 1410828592 kB

This. You've got 2.8GB of reclaimable page cache there.

> Unevictable:           0 kB
> Mlocked:               0 kB
> SwapTotal:      25353212 kB
> SwapFree:       25353212 kB
> Dirty:           1228056 kB
> Writeback:        348024 kB

And very little of it is dirty, so it should all be immediately
reclaimable or compactable.

> Slab:           79729144 kB
> SReclaimable:   79040008 kB

80GB of slab caches as well - what is the output of /proc/slabinfo?

> We have three hardware raid'ed disks with XFS on them, one of which receives
> the bulk of the load. This is a raid 50 volume on SSDs with the raid controller
> running in writethrough mode.

It doesn't seem like writeback of dirty pages is the problem; more
the case that the page cache is rediculously huge and not being
reclaimed in a sane manner. Do you really need 2.8TB of cached file
data in memory for performance?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
