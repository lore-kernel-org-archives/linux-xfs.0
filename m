Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 13 Jun 2007 15:31:17 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5DMVCWt019837
	for <xfs@oss.sgi.com>; Wed, 13 Jun 2007 15:31:13 -0700
Date: Thu, 14 Jun 2007 08:31:06 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: sunit not working
Message-ID: <20070613223105.GQ86004887@sgi.com>
References: <1181606134.7873.72.camel@holwrs01> <1181608444.3758.73.camel@edge.yarra.acx> <902286657-1181653953-cardhu_decombobulator_blackberry.rim.net-1527539029-@bxe120.bisx.prod.on.blackberry> <1181690478.3758.108.camel@edge.yarra.acx> <1181760380.8754.53.camel@holwrs01>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181760380.8754.53.camel@holwrs01>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Salmon, Rene" <Rene.Salmon@bp.com>
Cc: nscott@aconex.com, David Chinner <dgc@sgi.com>, salmr0@bp.com, xfs@oss.sgi.com

On Wed, Jun 13, 2007 at 01:46:20PM -0500, Salmon, Rene wrote:
> 
> Hi,
> 
> More details on this:
> 
> Using dd with various block sizes to measure write performance only for
> now.
> 
> This is using two options to dd. The direct I/O option for direct i/o
> and the fsync option for buffered i/o.
> 
> Using direct:
> /usr/bin/time -p dd of=/mnt/testfile if=/dev/zero oflag=direct 
> 
> Using fsync:
> /usr/bin/time -p dd of=/mnt/testfile if=/dev/zero conv=fsync
> 
> Using a 2Gbit/sec fiber channel card my theoretical max is 256
> MBytes/sec.  If we allow a bit of overhead for the card driver and
> things the manufacturer claims the card should be able to max out at
> around 200 MBytes/sec.

Right.

> The block sizes I used range from 128KBytes - 1024000Kbytes and all the
> writes generate a 1.0GB file.
> 
> Some of the results I got:
> 
> Buffered I/O(fsync):
> --------------------
> Linux seems to do a good job at buffering this. Regardless of the block
> size I choose I always get write speeds of around 150MBytes/sec

Because it does single threaded writeback via pdflush. It should always
get the same throughput.

If you wind /proc/sys/vm/dirty_ratio down to 5, it might go a bit
faster because writeback will start earlier in the write and so the
fsync will have less to do and overall speed will appear faster.

What you should be looking at it iostat throughput in the steady state,
not inferring the throughput from timing a write operation.....

> Direct I/O(direct):
> -------------------
> The speeds I get here of course are very dependent on the block size I
> choose and how well they align with the stripe size of the storage array
> underneath. For the appropriate block sizes I get really good
> performance about 200MBytes/sec.   

Also normal, because you're iop bound at small block sizes. At large
block sizes, you saturate the fibre. Sounds like nothing is wrong
here.

> >From your feedback is sounds like these are reasonable numbers.
> Most of our user apps do not use direct I/O but rather buffered I/O.  Is
> 150MBytes/sec as good as it gets for buffered I/O or is there something
> I can tune to get a bit more out of buffered I/O?

That's about it, I think. With tweaking any tuning of the vm parameters,
you might be able to get it higher, but it may be that writeback (when it
occurs) is actually higher than this....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
