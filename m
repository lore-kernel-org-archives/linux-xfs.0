Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BA4487F3F
	for <xfs@oss.sgi.com>; Tue,  4 Jun 2013 05:20:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 42367AC007
	for <xfs@oss.sgi.com>; Tue,  4 Jun 2013 03:20:02 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	qZCvG6hVYByoRUD6 for <xfs@oss.sgi.com>;
	Tue, 04 Jun 2013 03:20:00 -0700 (PDT)
Date: Tue, 4 Jun 2013 20:19:37 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Debunking myths about metadata CRC overhead
Message-ID: <20130604101937.GI29466@dastard>
References: <20130603074452.GZ29466@dastard> <20130603200052.GB863@sgi.com>
	<20130604024329.GA29466@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130604024329.GA29466@dastard>
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
To: Geoffrey Wehrman <gwehrman@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, Jun 04, 2013 at 12:43:29PM +1000, Dave Chinner wrote:
> On Mon, Jun 03, 2013 at 03:00:53PM -0500, Geoffrey Wehrman wrote:
> > On Mon, Jun 03, 2013 at 05:44:52PM +1000, Dave Chinner wrote:
> > This will have significant impact
> > on SGI's DMF managed filesystems.
> 
> You're concerned about bulkstat performance, then? Bulkstat will CRC
> every inode it reads, so the increase in inode size is the least of
> your worries....
> 
> But bulkstat scalability is an unrelated issue to the CRC work,
> especially as bulkstat already needs application provided
> parallelism to scale effectively.

So, I just added a single threaded bulkstat pass to the fsmark
workload by passing xfs_fsr across the filesystem to test out what
impact it has. So, 50 million inodes in the directory structure:

		256 byte inodes,	512 byte inodes
		CRCs disabled		CRCs enabled
		---------------------------------------
wall time	13m34.203s		14m15.266s
sys CPU		7m7.930s		8m52.050s
rate		61,425 inodes/s		58,479 inode/s
efficency	116,800 inodes/CPU/s	93,984 inodes/CPU/s

So, really it's not particularly significant in terms of performance
differential. Certainly there isn't anything signficant problem that
larger inodes cause.  For comparison, the 8-way find workloads:

		256 byte inodes,	512 byte inodes
		CRCs disabled		CRCs enabled
		---------------------------------------
wall time	5m33.165s		8m18.256s
sys CPU		18m36.731s		22m2.277s
rate		150,055 inodes/s	100,400 inodes/s
efficiency	44,800 inodes/CPU/s	37,800 inodes/CPU/s

Which makes me think omething is not right with this bulkstat pass
I've just done. It's way too slow if a find+stat is 2-2.5x faster.

Ah, xfs_fsr only bulkstats 64 inodes at a time. That's right,
last time I did this I used bstat out of xfstests. On a CRC enabled
fs:

ninodes		runtime		sys time	read bw(IOPS)
64		14m01s		8m37s
128		11m20s		7m58s		35MB/s(5000)
256		 8m53s		7m24s		45MB/s(6000)
512		 7m24s		6m28s		55MB/s(7000)
1024		 6m37s		5m40s		65MB/s(8000)
2048		10m50s		6m51s		35MB/s(5000)
4096(default)	26m23s		8m38s

Ask bulkstat for too few or too much, and it all goes to hell.  So
if we get the bulkstat config right, a single threaded bulkstat is
faster than the 8-way find, and a whole lot more efficient at it.
But, still there is effectively no performance differential between
256 byte and 512 byte inodes worth talking about.

And, FWIW, I just hacked threading into bstat to run a thread per AG
and just scan a single AG per thread. It's not perfect - it counts
some inodes twice (threads*ninodes at most) before it detects it's
run into the next AG. This is on a 100TB filesystem, so it runs 100
threads. CRC enabled fs:

ninodes		runtime		sys time	read bw(IOPS)
64		 1m53s		10m25s		220MB/s (27000)
256		 1m52s		10m03s		220MB/s (27000)
1024		 1m55s		10m08s		210MB/s (26000)

So when it's threaded, the small request size just doesn't matter -
there's enough IO to drive the system to being IOPS bound and that
limits performance.

Just to go full circle, the differences between 256 byte inodes, no
CRCs and the crc enabled filesystem for a single threaded bulkstat:

		256 byte inodes,	512 byte inodes
		CRCs disabled		CRCs enabled
		---------------------------------------
ninodes		   1024			     1024
wall time	   5m22s		     6m37s
sys CPU		   4m46s		     5m40s
bw(IOPS)	     40MB/s(5000)	     65MB/s(8000)
rate		155,300 inodes/s	126,000 inode/s
efficency	174,800 inodes/CPU/s	147,000 inodes/CPU/s

Both follow the same ninode profile, but there is less IO done for
the 256 byte inode filesystem and throughput is higher. There's no
big surprise there, what does surprise me is that the difference
isn't larger. Let's drive it to being I/O bound with threading:

		256 byte inodes,	512 byte inodes
		CRCs disabled		CRCs enabled
		---------------------------------------
ninodes		    256			    256
wall time	   1m02s		   1m52s
sys CPU		   7m04s		  10m03s
bw/IOPS		    210MB/s (27000)	    220MB/s (27000)
rate		806,500 inodes/s	446,500 inode/s
efficency	117,900 inodes/CPU/s	 82,900 inodes/CPU/s

The 256 byte inode test is completely CPU bound - it can't go any
faster than that, and it just so happens to be pretty close to IO
bound as well. So, while there's double the throughput for 256 byte
inodes, it raises an interesting question: why are all the IOs only
8k in size?

That means the inode readahead that bulkstat is doing is not being
combined down in the elevator - it is either being cancelled because
there is too much, or it is being dispatched immediately and so we
are being IOPS limited long before we should be. i.e. there's still
500MB of bandwidth available on this filesystem and we're issuing
sequential adjacent 8k IO.  Either way, it's not functioning as it
should.

<blktrace>

Yup, immediate, explicit unplug and dispatch. No readahead batching
and the unplug is coming from _xfs_buf_ioapply().  Well, that is
easy to fix.

		256 byte inodes,	512 byte inodes
		CRCs disabled		CRCs enabled
		---------------------------------------
ninodes		    256			    256
wall time	   1m02s		   1m08s
sys CPU		   7m07s		   8m09s
bw/IOPS		    210MB/s (13500)	    360MB/s (14000)
rate		806,500 inodes/s	735,300 inode/s
efficency	117,100 inodes/CPU/s	102,200 inodes/CPU/s

So, the difference in performance pretty much goes away. We burn
more bandwidth, but now the multithreaded bulkstat is CPU limited
for both non-crc, 256 byte inodes and CRC enabled 512 byte inodes.

What this says to me is that there isn't a bulkstat performance
problem that we need to fix apart from the 3 lines of code for the
readahead IO plugging that I just added.  It's only limited by
storage IOPS and available CPU power, yet the bandwidth is
sufficiently low that any storage system that SGI installs for DMF
is not going to be stressed by it. IOPS, yes. Bandwidth, no.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
