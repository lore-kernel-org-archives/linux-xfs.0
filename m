Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DEBB87FDB
	for <xfs@oss.sgi.com>; Wed, 21 Aug 2013 21:25:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C1CBF3040A4
	for <xfs@oss.sgi.com>; Wed, 21 Aug 2013 19:25:47 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	ASzEUNcQdvaCnYl7 for <xfs@oss.sgi.com>;
	Wed, 21 Aug 2013 19:25:46 -0700 (PDT)
Date: Thu, 22 Aug 2013 12:25:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS: possible memory allocation deadlock in kmem_alloc
	(mode:0x250)
Message-ID: <20130822022544.GS6023@dastard>
References: <20130821152458.GD986@poseidon.cudanet.local>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130821152458.GD986@poseidon.cudanet.local>
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
To: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
Cc: xfs@oss.sgi.com

On Wed, Aug 21, 2013 at 11:24:58AM -0400, Josef 'Jeff' Sipek wrote:
> We've started experimenting with larger directory block sizes to avoid
> directory fragmentation.  Everything seems to work fine, except that the log
> is spammed with these lovely debug messages:
> 
> 	XFS: possible memory allocation deadlock in kmem_alloc (mode:0x250)
> 
> From looking at the code, it looks like that each of those messages (there
> are thousands) equates to 100 trips through the loop.  My guess is that the
> larger blocks require multi-page allocations which are harder to satisfy.
> This is with 3.10 kernel.

No, larger blocks simply require more single pages. The buffer cache
does not require multi-page allocation at all. So, mode = 0x250,
which means ___GFP_NOWARN | ___GFP_IO | ___GFP_WAIT which is also
known as a GFP_NOFS allocation context.

So, it's entirely possible that your memory is full of cached
filesystem data and metadata, and the allocation that needs more
can't reclaim them.

> The hardware is something like (I can find out the exact config is you want):
> 
> 	32 cores
> 	128 GB RAM
> 	LSI 9271-8i RAID (one big RAID-60 with 36 disks, partitioned)
> 
> As I hinted at earlier, we end up with pretty big directories.  We can
> semi-reliably trigger this when we run rsync on the data between two
> (identical) hosts over 10GbitE.
> 
> # xfs_info /dev/sda9 
> meta-data=/dev/sda9              isize=256    agcount=6, agsize=268435455 blks 
>          =                       sectsz=512   attr=2 
> data     =                       bsize=4096   blocks=1454213211, imaxpct=5 
>          =                       sunit=0      swidth=0 blks 
> naming   =version 2              bsize=65536  ascii-ci=0 
> log      =internal               bsize=4096   blocks=521728, version=2 
>          =                       sectsz=512   sunit=0 blks, lazy-count=1 
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> /proc/slabinfo: https://www.copy.com/s/1x1yZFjYO2EI/slab.txt

Hmmm. You're using filestreams. That's unusual.

Only major slab cache is the buffer_head slab, with ~12 million
active bufferheads. So, that means you've got at least 47-48GB of
data in the page cache.....

And there's only ~35000 xfs_buf items in the slab, so the metadata
cache isn't very big, and reclaim from that isn't a problem, nor the
inode caches as there's only 130,000 cached inodes.

> sysrq m output: https://www.copy.com/s/mYfMYfJJl2EB/sysrq-m.txt

27764401 total pagecache pages

which indicates that you've got close to 110GB of pages in the page
cache. Hmmm, and 24-25GB of dirty pages in memory.

You know, I'd be suspecting a memory reclaim problem here to do with
having large amounts of dirty memory in the page cache. I don't
think the underlying cause is going to be the filesystem code, as
the warning should never be emitted if memory reclaim is making
progress. Perhaps you could try lowering all the dirty memory
thresholds to see if that allows memory reclaim to make more
progress because there are fewer dirty pages in memory...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
