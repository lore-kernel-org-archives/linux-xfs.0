Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:29665 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1161176AbcKAFrb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Nov 2016 01:47:31 -0400
Date: Tue, 1 Nov 2016 16:47:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [rfc] larger batches for crc32c
Message-ID: <20161101054725.GZ14023@dastard>
References: <20161028031747.68472ac7@roar.ozlabs.ibm.com>
 <20161027214244.GO14023@dastard>
 <20161028131234.24a5cb6f@roar.ozlabs.ibm.com>
 <20161028160218.1af40906@roar.ozlabs.ibm.com>
 <20161031030853.GK22126@dastard>
 <20161101143918.4f154154@roar.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161101143918.4f154154@roar.ozlabs.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nicholas Piggin <npiggin@gmail.com>
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>

On Tue, Nov 01, 2016 at 02:39:18PM +1100, Nicholas Piggin wrote:
> On Mon, 31 Oct 2016 14:08:53 +1100
> Dave Chinner <david@fromorbit.com> wrote:
> 
> > On Fri, Oct 28, 2016 at 04:02:18PM +1100, Nicholas Piggin wrote:
> > > Okay, the XFS crc sizes indeed don't look too so bad, so it's more the
> > > crc implementation I suppose. I was seeing a lot of small calls to crc,
> > > but as a fraction of the total number of bytes, it's not as significant
> > > as I thought. That said, there is some improvement you may be able to
> > > get even from x86 implementation.
> > > 
> > > I took an ilog2 histogram of frequency and total bytes going to XFS  
> > 
> > Which means ilog2 = 3 is 8-15 bytes and 9 is 512-1023 bytes? 
> 
> Yes.
> 
> > > checksum, with total, head, and tail lengths. I'll give as percentages
> > > of total for easier comparison (total calls were around 1 million and
> > > 500MB of data):  
> > 
> > Does this table match the profile you showed with all the overhead
> > being through the fsync->log write path?
> 
> Yes.
> 
> [snip interesting summary]
> 
> > Full sector, no head, no tail (i.e. external crc store)? I think
> > only log buffers (the extended header sector CRCs) can do that.
> > That implies a large log buffer (e.g. 256k) is configured and
> > (possibly) log stripe unit padding is being done. What is the
> > xfs_info and mount options from the test filesystem?
> 
> See the end of the mail.
> 
> [snip]
> 
> > > Keep in mind you have to sum the number of bytes for head and tail to
> > > get ~100%.
> > > 
> > > Now for x86-64, you need to be at 9-10 (depending on configuration) or
> > > greater to exceed the breakeven point for their fastest implementation.
> > > Split crc implementation will use the fast algorithm for about 85% of
> > > bytes in the best case, 12% at worst. Combined gets there for 85% at
> > > worst, and 100% at best. The slower x86 implementation still uses a
> > > hardware instruction, so it doesn't do too badly.
> > > 
> > > For powerpc, the breakeven is at 512 + 16 bytes (9ish), but it falls
> > > back to generic implementation for bytes below that.  
> > 
> > Which means for the most common objects we won't be able to reach
> > breakeven easily simply because of the size of the objects we are
> > running CRCs on. e.g. sectors and inodes/dquots by default are all
> > 512 bytes or smaller. THere's only so much that can be optimised
> > here...
> 
> Well for this workload at least, the full checksum size seems always
> >= 512. The small heads cut it down and drag a lot of crc32c calls
> from 1024-2047 range (optimal for Intel) to 512-1023. I don't *think*
> I've done the wrong thing here, but if it looks odd to you, I'll go
> back and double check.

That doesn't make immediate sense to me. Objects being CRC'd in XFS
are either:

	- sector size or smaller (so head/tail < 512)
	- block sized (4k) with a very small head (< 64 bytes)
	  and a ~4k tail.
	- sector padded log writes of up to iclogbuf size (default
	  32k) with a short head/tail for the first sector, then
	  a direct crc32c() call for the rest.

The only thing that can fall into the 1024-2047 range are /very
small/ log writes. i.e. fsync()ing an inode change, but nothing
else.

FWIW, from the stats below, there are lots more transactions than log
forces and we know that the log forces driven by fsync are the
majority of the CRC traffic. The stats show about 1.4GB of data got
written to the log, so all that would have been CRCed. with ~140k
log forces, that's an average of 10kb per log write that was CRC'd.
Some are going to be much larger, some are going to be small. You'll
see the very small log writes be affected by head/tail size, but
otherwise the difference will be minimal because there are still
multiple crc32c calls for a log buffer...

So I think what you are seeing is simply the effect of variable log
write size due to frequent fsyncs preventing the log from fully
utilising it's in-memory log write reduction optimisations to reduce
log traffic and fully utilise the log buffer space to minimise CRC
overhead....

I've left the decoding of the stats below if you want to read it,
otherwise there's nothing else of note here...

> > > I think we can
> > > reduce the break even point on powerpc slightly and capture most of
> > > the rest, so it's not so bad.
> > > 
> > > Anyway at least that's a data point to consider. Small improvement is
> > > possible.  
> > 
> > Yup, but there's no huge gain to be made here - these numbers say to
> > me that the problem may not be the CRC overhead, but instead is the
> > amount of CRC work being done. Hence my request for mount options
> > + xfs_info to determine if what you are seeing is simply a bad fs
> > configuration for optimal small log write performance. CRC overhead
> > may just be a symptom of a filesystem config issue...
> 
> Yes sorry, I forgot to send an xfs_info sample. mkfs.xfs is 4.3.0 from
> Ubuntu 16.04.
> 
> npiggin@fstn3:/etc$ sudo mkfs.xfs -f /dev/ram0
> specified blocksize 4096 is less than device physical sector size 65536
> switching to logical sector size 512
> meta-data=/dev/ram0              isize=512    agcount=4, agsize=4194304 blks
>          =                       sectsz=512   attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=0
> data     =                       bsize=4096   blocks=16777216, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
> log      =internal log           bsize=4096   blocks=8192, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> Mount options are standard:
> /dev/ram0 on /mnt type xfs (rw,relatime,attr2,inode64,noquota)

OK, nothing unusual here at all. Nothing to make me suspect a config
issue.

> xfs_info sample:
....
> dir 79418 460612 460544 5685160

directory operations:
	lookups = 79418
	creates = 460612
	removes = 460544
	getdents = 5685160

SO, we have 80k directory lookups to instantiate an inode, but 460k
creates and removes, and 5.6M readdir calls. That's a lot of readdir
calls - this doesn't look like any part of a MySQL workload I'm
familiar with....

> trans 0 3491960 0

3.5 million asynchronous transaction commits. That's a lot, so far I
can account for about 1.5M of them (creates, removes and a handful
of data extents). Oh, a couple of million data writes - I bet the
rest are timestamp/i_version updates.

> log 89045 2859542 62 132145 143932

journal stats:
	log write IOs = 89045
	log write blocks = 2859542 = 1.4GB
	log stalls waitingfor iclogbuf = 62	(can ignore)
	log forces = 132145			(fsync load!)
	log force sleeps = 143932		(fsync waits!)

> push_ail 3491960 24 619 53860 0 6433 13135 284324 0 445

log space reservations = 3491960
  ... that blocked = 24
AIL pushes = 619
objects cleaned = 53860
buffers pushed = 0
objects skipped because pinned = 6433
objects skipped because locked = 13135
objects skipped because already pushed = 284324		(inodes!)
Push restarts = 0
log forces to unpin objects = 445

So, in terms of metadata writeback, there's inodes being flushed
here, and not much else. The directory blocks are probably being freed before
they get flushed (0 buffers pushed), which indicates that the inode
create/remove is temporary files.

> xstrat 64342 0

64342 data extent allocations during writeback. 

> rw 951375 2937203

->read_iter and ->write_iter calls.

> attr 0 0 0 0
> icluster 47412 38985 221903
> vnodes 5294 0 0 0 381123 381123 381123 0

only 5294 active inodes in cache at sample time, 380k inodes have
been fully reclaimed.

> buf 4497307 6910 4497106 1054073 13012 201 0 0 0

~4.5M metadata buffer lookups, 7,000 lookup misses.

> abtb2 139597 675266 27639 27517 0 0 0 0 0 0 0 0 0 0 1411718
> abtc2 240942 1207277 120532 120410 0 0 0 0 0 0 0 0 0 0 4618844
> bmbt2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
> ibt2 762383 3048311 69 67 0 0 0 0 0 0 0 0 0 0 263
> fibt2 1114420 2571311 143583 143582 0 0 0 0 0 0 0 0 0 0 1232534

The btree stats indication lookup, compare, insert, delete and move
on the free space btrees and the inode btrees. This means all the
data being written is in just 1-few extents per inode, and there
were about 143583 inodes created and removed in this period.

Let's tie that number back into the number of log forces from above:

log force sleeps = 143932               (fsync waits!)

It's almost identical. Whatever is creating/removing these files is
probably also causing all the fsync load and the log CRC overhead
you are measuring. Identifying what that is will give you some idea
of how to reduce the fsync load and hence potentially decrease the
log and CRC overhead that it is causing....

> rmapbt 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
> refcntbt 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
> qm 0 0 0 0 0 0 0 0
> xpc 3366711296 24870568605 34799779740

so in 64342 data extent allocations during writeback, we allocated
3366711296 bytes = 3.3GB. We wrote 24GB of data through ->write_iter
and read 34GB of data through ->read_iter.  That means average
read/write sizes are about 24k/12k. Pretty typical for a database, I
think.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
