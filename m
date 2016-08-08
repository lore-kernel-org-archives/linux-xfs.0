Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C51837CA0
	for <xfs@oss.sgi.com>; Mon,  8 Aug 2016 18:12:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7B67F8F8039
	for <xfs@oss.sgi.com>; Mon,  8 Aug 2016 16:12:33 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	Nl1mPxFnNIScZLx1 for <xfs@oss.sgi.com>;
	Mon, 08 Aug 2016 16:12:27 -0700 (PDT)
Date: Tue, 9 Aug 2016 09:12:25 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Subtle races between DAX mmap fault and write path
Message-ID: <20160808231225.GD19025@dastard>
References: <20160727221949.GU16044@dastard>
	<20160728081033.GC4094@quack2.suse.cz>
	<20160729022152.GZ16044@dastard>
	<CAPcyv4gOcDGzikJHYGxNXtYqQKkPUgkG+z4ASxogQUnp1zmD2g@mail.gmail.com>
	<20160730001249.GE16044@dastard> <579F20D9.80107@plexistor.com>
	<20160802002144.GL16044@dastard>
	<1470335997.8908.128.camel@hpe.com>
	<20160805112739.GG16044@dastard>
	<CS1PR84MB0119314ACA9B4823C0FE33318E180@CS1PR84MB0119.NAMPRD84.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CS1PR84MB0119314ACA9B4823C0FE33318E180@CS1PR84MB0119.NAMPRD84.PROD.OUTLOOK.COM>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "Boylston, Brian" <brian.boylston@hpe.com>
Cc: "jack@suse.cz" <jack@suse.cz>, "Kani, Toshimitsu" <toshi.kani@hpe.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>

On Fri, Aug 05, 2016 at 07:58:33PM +0000, Boylston, Brian wrote:
> Dave Chinner wrote on 2016-08-05:
> > [ cut to just the important points ]
> > On Thu, Aug 04, 2016 at 06:40:42PM +0000, Kani, Toshimitsu wrote:
> >> On Tue, 2016-08-02 at 10:21 +1000, Dave Chinner wrote:
> >>> If I drop the fsync from the
> >>> buffered IO path, bandwidth remains the same but runtime drops to
> >>> 0.55-0.57s, so again the buffered IO write path is faster than DAX
> >>> while doing more work.
> >> =

> >> I do not think the test results are relevant on this point because both
> >> buffered and dax write() paths use uncached copy to avoid clflush. =A0=
The
> >> buffered path uses cached copy to the page cache and then use uncached=
 copy to
> >> PMEM via writeback. =A0Therefore, the buffered IO path also benefits f=
rom using
> >> uncached copy to avoid clflush.
> > =

> > Except that I tested without the writeback path for buffered IO, so
> > there was a direct comparison for single cached copy vs single
> > uncached copy.
> > =

> > The undenial fact is that a write() with a single cached copy with
> > all the overhead of dirty page tracking is /faster/ than a much
> > shorter, simpler IO path that uses an uncached copy. That's what the
> > numbers say....
> > =

> >> Cached copy (req movq) is slightly faster than uncached copy,
> > =

> > Not according to Boaz - he claims that uncached is 20% faster than
> > cached. How about you two get together, do some benchmarking and get
> > your story straight, eh?
> > =

> >> and should be
> >> used for writing to the page cache. =A0For writing to PMEM, however, a=
dditional
> >> clflush can be expensive, and allocating cachelines for PMEM leads to =
evict
> >> application's cachelines.
> > =

> > I keep hearing people tell me why cached copies are slower, but
> > no-one is providing numbers to back up their statements. The only
> > numbers we have are the ones I've published showing cached copies w/
> > full dirty tracking is faster than uncached copy w/o dirty tracking.
> > =

> > Show me the numbers that back up your statements, then I'll listen
> > to you.
> =

> Here are some numbers for a particular scenario, and the code is below.
> =

> Time (in seconds) to copy a 16KiB buffer 1M times to a 4MiB NVDIMM buffer
> (1M total memcpy()s).  For the cached+clflush case, the flushes are done
> every 4MiB (which seems slightly faster than flushing every 16KiB):
> =

>                   NUMA local    NUMA remote
> Cached+clflush      13.5           37.1
> movnt                1.0            1.3 =


So let's put that in memory bandwidth terms. You wrote 16GB to the
NVDIMM.  That means:

                  NUMA local    NUMA remote
Cached+clflush      1.2GB/s         0.43GB/s
movnt              16.0GB/s         12.3GB/s

That smells wrong.  The DAX code (using movnt) is not 1-2 orders of
magnitude faster than a page cache copy, so I don't believe your
benchmark reflects what I'm proposing.

What I think you're getting wrong is that we are not doing a clflush
after every 16k write when we use the page cache, nor will we do
that if we use cached copies, dirty tracking and clflush on fsync().
IOWs, the correct equivalent "cached + clflush" loop to a volatile
copy with dirty tracking + fsync would be:

	dstp =3D dst;
	while (--nloops) {
		memcpy(dstp, src, src_sz);	// pwrite();
		dstp +=3D src_sz;
	}
        pmem_persist(dst, dstsz);	// fsync();

i.e. The cache flushes occur only at the user defined
synchronisation point not on every syscall.

Yes, if you want to make your copy slow and safe, use O_SYNC to
trigger clflush on every write() call - that's what we do for
existing storage and the mechanisms are already there; we just need
the dirty tracking to optimise it.

Put simple: we should only care about cache flush synchronisation at
user defined data integrity synchronisation points. That's the IO
model the kernel has always exposed to users, and pmem storage is no
different.

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
