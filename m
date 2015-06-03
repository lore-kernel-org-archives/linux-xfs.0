Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A2C817FE6
	for <xfs@oss.sgi.com>; Wed,  3 Jun 2015 18:18:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 30E96AC001
	for <xfs@oss.sgi.com>; Wed,  3 Jun 2015 16:18:08 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	pE8hBBgaDorEG3AT for <xfs@oss.sgi.com>;
	Wed, 03 Jun 2015 16:18:05 -0700 (PDT)
Date: Thu, 4 Jun 2015 09:11:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: "XFS: possible memory allocation deadlock in kmem_alloc" on high
	memory machine
Message-ID: <20150603231100.GR24666@dastard>
References: <20150601145741.GA16608@otto> <20150601210113.GL24666@dastard>
	<20150602120648.GA22111@otto> <20150603015245.GN24666@dastard>
	<20150603070725.GA20743@otto>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150603070725.GA20743@otto>
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

On Wed, Jun 03, 2015 at 09:07:25AM +0200, Anders Ossowicki wrote:
> On Wed, Jun 03, 2015 at 03:52:45AM +0200, Dave Chinner wrote:
> > On Tue, Jun 02, 2015 at 02:06:48PM +0200, Anders Ossowicki wrote:
> >
> > > Slab:           79729144 kB
> > > SReclaimable:   79040008 kB
> >
> > 80GB of slab caches as well - what is the output of /proc/slabinfo?
> 
> slabinfo - version: 2.1
> # name         <active_objs> <num_objs> <objsize> <objperslab> <pagesperslab> : tunables <limit> <batchcount> <sharedfactor> : slabdata <active_slabs> <num_slabs> <sharedavail>
...
> xfs_ili              1066228 1066625   152   53    2 : tunables    0    0    0 : slabdata  20125  20125      0
> xfs_inode            2522728 2523172  1024   32    8 : tunables    0    0    0 : slabdata  78857  78857      0
> dentry               3217866 3702384   192   42    2 : tunables    0    0    0 : slabdata  88152  88152      0
> buffer_head        370050715 400741536 104   39    1 : tunables    0    0    0 : slabdata 10275424 10275424  0
> radix_tree_node     64025078 64148728  584   56    8 : tunables    0    0    0 : slabdata 1145751 1145751    0
.....
> Slab:           82699516 kB
> SReclaimable:   81921588 kB
....

So 400 million bufferheads (consuming 40GB RAM) and 60 million radix
tree nodes (consuming 35GB RAM) is where all that memory is.  That's
being used to track the 2.8GB of page cache data (roughly 3% memory
overhead).

Ok, nothing unusual there, but it demonstrates why I want to get rid
of bufferheads.....

> > > We have three hardware raid'ed disks with XFS on them, one of which receives
> > > the bulk of the load. This is a raid 50 volume on SSDs with the raid controller
> > > running in writethrough mode.
> > 
> > It doesn't seem like writeback of dirty pages is the problem; more
> > the case that the page cache is rediculously huge and not being
> > reclaimed in a sane manner. Do you really need 2.8TB of cached file
> > data in memory for performance?
> 
> Yeah, disk cache is the primary reason for stuffing memory into that machine.

Hmmmm. I don't think anyone has considered the page cache to be used
at this scale for caching before. Normally this amount of memory is
needed by applications in their process space, not as a disk buffer
to avoid disk IO. You've only got a 12TB filesystem, so you're
keeping 25% of it in the page cache at any given time, so I'm not
surprised that the page cache reclaim algorithms are having trouble....

I don't think there's anything on the XFS side we can do here to
improve the situation you are in - it appears that it's memory
relcaim and compaction that aren't working well enough to sustain
your workload on that platform....

OTOH, have you considered using something like dm-cache with a huge
ramdisk as the cache device and running it in write-through mode so
that power failure doesn't result in data loss or filesystem
corruption?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
