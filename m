Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3NNS598253692 for <xfs@oss.sgi.com>; Mon, 23 Apr 2012 18:28:05 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	V5WHmzlsMKQnEu6A for <xfs@oss.sgi.com>;
	Mon, 23 Apr 2012 16:28:03 -0700 (PDT)
Date: Tue, 24 Apr 2012 09:27:59 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: task blocked for more than 120 seconds
Message-ID: <20120423232759.GO9541@dastard>
References: <20120418151139.GC4652@poseidon.cudanet.local>
	<20120418234821.GR6734@dastard>
	<20120419154601.GB8230@poseidon.cudanet.local>
	<20120419225603.GA9541@dastard>
	<20120420135820.GB9189@poseidon.cudanet.local>
	<20120421002932.GG9541@dastard>
	<20120423202441.GD21260@poseidon.cudanet.local>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120423202441.GD21260@poseidon.cudanet.local>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
Cc: xfs@oss.sgi.com

On Mon, Apr 23, 2012 at 04:24:41PM -0400, Josef 'Jeff' Sipek wrote:
> On Sat, Apr 21, 2012 at 10:29:32AM +1000, Dave Chinner wrote:
> ...
> > but also given the length of the incident, some other data is definitely
> > needed:
> > 	- a 30s event trace - it'll compress pretty well
> > 	  (trace-cmd record -e xfs* sleep 30; trace-cmd report > output.txt)
> 
> http://31bits.net/download/output-1335211829.txt.bz2

Ok, that's instructive. Inode RMW cycles in the xfsaild:

xfsaild/sda4  968486.257027: xfs_buf_read:         dev 8:4 bno 0xe000d4e10 len 0x2000
xfsaild/sda4  968486.338194: xfs_buf_delwri_queue: dev 8:4 bno 0xe000d4e10 len 0x2000
xfsaild/sda4  968486.338203: xfs_buf_read:         dev 8:4 bno 0xb00ff7c00 len 0x2000
xfsaild/sda4  968486.351177: xfs_buf_delwri_queue: dev 8:4 bno 0xb00ff7c00 len 0x2000
xfsaild/sda4  968486.351183: xfs_buf_read:         dev 8:4 bno 0x280054e38 len 0x2000
xfsaild/sda4  968486.351194: xfs_buf_delwri_queue: dev 8:4 bno 0x280054e38 len 0x2000
xfsaild/sda4  968486.351200: xfs_buf_read:         dev 8:4 bno 0x580057ee8 len 0x2000
xfsaild/sda4  968486.363347: xfs_buf_delwri_queue: dev 8:4 bno 0x580057ee8 len 0x2000
xfsaild/sda4  968486.363355: xfs_buf_read:         dev 8:4 bno 0x500522980 len 0x2000
xfsaild/sda4  968486.373812: xfs_buf_delwri_queue: dev 8:4 bno 0x500522980 len 0x2000
xfsaild/sda4  968486.373817: xfs_buf_read:         dev 8:4 bno 0x800412390 len 0x2000
xfsaild/sda4  968486.373829: xfs_buf_delwri_queue: dev 8:4 bno 0x800412390 len 0x2000
xfsaild/sda4  968486.373835: xfs_buf_read:         dev 8:4 bno 0xe005a07c0 len 0x2000
xfsaild/sda4  968486.386211: xfs_buf_delwri_queue: dev 8:4 bno 0xe005a07c0 len 0x2000
xfsaild/sda4  968486.386220: xfs_buf_read:         dev 8:4 bno 0x5801af5f8 len 0x2000
xfsaild/sda4  968486.400109: xfs_buf_delwri_queue: dev 8:4 bno 0x5801af5f8 len 0x2000
xfsaild/sda4  968486.400116: xfs_buf_read:         dev 8:4 bno 0xf01026940 len 0x2000
xfsaild/sda4  968486.400128: xfs_buf_delwri_queue: dev 8:4 bno 0xf01026940 len 0x2000
xfsaild/sda4  968486.400135: xfs_buf_read:         dev 8:4 bno 0xe00fccac0 len 0x2000
xfsaild/sda4  968486.517162: xfs_buf_delwri_queue: dev 8:4 bno 0xe00fccac0 len 0x2000
xfsaild/sda4  968486.517169: xfs_buf_read:         dev 8:4 bno 0x4007ba2d0 len 0x2000
xfsaild/sda4  968486.517179: xfs_buf_delwri_queue: dev 8:4 bno 0x4007ba2d0 len 0x2000
xfsaild/sda4  968486.517187: xfs_buf_read:         dev 8:4 bno 0x8800652c8 len 0x2000
xfsaild/sda4  968486.524118: xfs_buf_delwri_queue: dev 8:4 bno 0x8800652c8 len 0x2000
xfsaild/sda4  968486.524126: xfs_buf_read:         dev 8:4 bno 0x2811e0dc8 len 0x2000
xfsaild/sda4  968486.536576: xfs_buf_delwri_queue: dev 8:4 bno 0x2811e0dc8 len 0x2000
.....
xfsaild/sda4  968516.199683: xfs_buf_read:         dev 8:4 bno 0x7008ebfb0 len 0x2000
xfsaild/sda4  968516.212424: xfs_buf_delwri_queue: dev 8:4 bno 0x7008ebfb0 len 0x2000


Every buffer read is followed by a queuing for write.  It is also
showing that it is typically taking 10-25ms per inode read IO, which
is exactly what I'd expect for your given storage. There are 2500 of
these over the 30s period, which translates to about one every 12ms
across the 30s sample.

So, yes, your hangs are definitely due to inode buffer RMW cycles
when trying to flush dirty inodes from the cache. I have a few
ideas on how to fix this - but I'm not sure whether a current TOT
solution will be easily back-portable. The simplest solution is a
readahead based solution - AIL pushing is async, and will cycle back
to inodes that it failed to flush the first time past, so triggering
readahead on the first pass might work just fine.

Right now we do:

	read inode buffer (trylock)
	no buffer:
		read from disk
		wait
	flush inode to buffer
	queue buffer for write

So the aild is essentially blocking on inode buffer read IO. What
would be better is:


	read inode buffer (trylock)
	no buffer:
		issue readahead to disk
		fail read
	xfsaild skips inode
	.....
	read inode buffer (trylock)
	buffer found
	flush inode to buffer
	queue buffer for write

That way the xfsaild will make a pass across the AIL doing
readahead and doesn't block on RMW cycles. Effectively we get async
RMW cycles occurring, and the latency of a single cycle will no
longer be the performance limiting factor. I'll start to prototype
something to address this - it isn't a new idea, and I've seen it
done before, so i should be able to get something working.

> Anything else?

No, I know what the problem is now.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
