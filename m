Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3R3SS30125304 for <xfs@oss.sgi.com>; Mon, 26 Apr 2010 22:28:28 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3FF0D2F3A3D
	for <xfs@oss.sgi.com>; Mon, 26 Apr 2010 20:30:29 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	DG5D8FFCw3aYBjww for <xfs@oss.sgi.com>;
	Mon, 26 Apr 2010 20:30:29 -0700 (PDT)
Date: Tue, 27 Apr 2010 13:30:25 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/4] writeback: pay attention to wbc->nr_to_write in
	write_cache_pages
Message-ID: <20100427033025.GB9783@dastard>
References: <1271731314-5893-1-git-send-email-david@fromorbit.com>
	<1271731314-5893-4-git-send-email-david@fromorbit.com>
	<20100425033315.GC667@thunk.org> <20100426014908.GD11437@dastard>
	<20100426024302.GC13043@thunk.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100426024302.GC13043@thunk.org>
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
To: tytso@mit.edu, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Sun, Apr 25, 2010 at 10:43:02PM -0400, tytso@mit.edu wrote:
> On Mon, Apr 26, 2010 at 11:49:08AM +1000, Dave Chinner wrote:
> > 
> > Yes, but that does not require a negative value to get right.  None
> > of the code relies on negative nr_to_write values to do anything
> > correctly, and all the termination checks are for wbc->nr_to-write
> > <= 0. And the tracing shows it behaves correctly when
> > wbc->nr_to_write = 0 on return. Requiring a negative number is not
> > documented in any of the comments, write_cache_pages() does not
> > return a negative number, etc, so I can't see why you think this is
> > necessary....
> 
> In fs/fs-writeback.c, wb_writeback(), around line 774:
> 
>    		      wrote += MAX_WRITEBACK_PAGES - wbc.nr_to_write;
> 
> If we want "wrote" to be reflect accurately the number of pages that
> the filesystem actually wrote, then if you write more pages than what
> was requested by wbc.nr_to_write, then it needs to be negative.

Yes, but the change I made:

	a) prevented it from writing more than requested in the
	   async writeback case, and
	b) prevented it from going massively negative so that the
	   higher levels wouldn't have over-accounted for pages
	   written.

And if we consider that for the sync case we actaully return the
number of pages written - it's gets capped at zero even when we
write a lot more than that.

Hence exactly accounting for pages written is really not important.
Indeed, exact number of written pages is not actually used for
anything specific - only to determine if there was activity or not:

 919                 pages_written = wb_do_writeback(wb, 0);
 920
 921                 if (pages_written)
 922                         last_active = jiffies;

> > XFS put a workaround in for a different reason to ext4. ext4 put it
> > in to improve delayed allocation by working with larger chunks of
> > pages. XFS put it in to get large IOs to be issued through
> > submit_bio(), not to help the allocator...
> 
> That's why I put in ext4 at least initially, yes.  I'm working on
> rewriting the ext4_writepages() code to make this unnecessary....
> 
> However...
> 
> > And to be the nasty person to shoot down your modern hardware
> > theory: nr_to_write = 1024 pages works just fine on my laptop (XFS
> > on indilix SSD) as well as my big test server (XFS on 12 disk RAID0)
> > The server gets 1.5GB/s with pretty much perfect IO patterns with
> > the fixes I posted, unlike the mess of single page IOs that occurs
> > without them....
> 
> Have you tested with multiple files that are subject to writeout at
> the same time?

Of course.

> After all, if your I/O allocator does a great job of
> keeping the files contiguous in chunks larger tham 4MB, then if you
> have two or more files that need to be written out, the page allocator
> will round robin between the two files in 4MB chunks, and that might
> not be considered an ideal I/O pattern.

4MB chunks translate into 4-8 IOs at the block layer with typical
setups that set the maximum IO size to 512k or 1MB. So that is
_plenty_ to keep a single disk or several disks in a RAID stripe
busy before seeking to another location to do the next set of 4-8
writes. And if the drive has any amount of cache (we're seeing
64-128MB in SATA drives now), then it will be aggregating these writes in
the cache into even larger sequential chunks. Hence seeks in _modern
hardware_ are going to be almost entirely mitigated for most large
sequential write workloads as long as the contiguous chunks are more
than a few MB in size.

Some numbers for you:

One 4GB file (baseline):

$ dd if=/dev/zero of=/mnt/scratch/$i/test bs=1024k count=4000
.....
$ sudo xfs_bmap -vp /mnt/scratch/*/test
/mnt/scratch/0/test:
 EXT: FILE-OFFSET         BLOCK-RANGE      AG AG-OFFSET     TOTAL FLAGS
   0: [0..4710271]:       96..4710367       0 (96..4710367) 4710272 00000
   1: [4710272..8191999]: 5242976..8724703  1 (96..3481823) 3481728 00000

Ideal layout - the AG size is about 2.4GB, so it'll be two extents
as we see (average gives 2GB per extent). This completed at about 440MB/s.

Two 4GB files in parallel into the same directory:

$ for i in `seq 0 1 1`; do dd if=/dev/zero of=/mnt/scratch/test$i bs=1024k count=4000 & done
$ sudo xfs_bmap -vp /mnt/scratch/test* | awk '/ [0-9]*:/ { tot += $6; cnt++ } END { print tot / cnt }'
712348
$

So the average extent size is ~355MB, and throughput was roughly
520MB/s.

Two 4GB files in parallel into different directories (to trigger a
different allocator placement heuristic):

$ for i in `seq 0 1 1`; do dd if=/dev/zero of=/mnt/scratch/$i/test bs=1024k count=4000 & done
$ sudo xfs_bmap -vp /mnt/scratch/*/test | awk '/ [0-9]*:/ { tot += $6; cnt++ } END { printf "%d\n", tot / cnt }'
1170285
$

~600MB average extent size and throughput was roughly 530MB/s.

Let's make it harder - eight 1GB files in parallel into the same directory:

$ for i in `seq 0 1 7`; do dd if=/dev/zero of=/mnt/scratch/test$i bs=1024k count=1000 & done
...
$ sudo xfs_bmap -vp /mnt/scratch/test* | awk '/[0-9]:/ { tot += $6; cnt++ } END { print tot / cnt }'
157538
$

An average of 78MB per extent with throughput at roughly 520MB/s.
IOWs, the extent size is still large enough to provide full
bandwidth to pretty much any application that does sequential IO.
i.e. it is not ideal, but it's not badly fragmented enough to be a
problem for most people.

FWIW, with the current code I am seeing average extent sizes of
roughly 55MB for this same test, so there is significant _reduction_
in fragmentation by making sure we interleave chunks of pages
_consistently_ in writeback. Mind you, throughput didn't change
because extents of 55MB are still large enough to maintain full disk
throughput for this workload....

FYI, if this level of fragmentation were a problem for this
workload (e.g. a mythTV box) I could use something like the
allocsize mount option to specify the EOF preallocation size:

$ sudo umount /mnt/scratch
$ sudo mount -o logbsize=262144,nobarrier,allocsize=512m /dev/vdb /mnt/scratch
$ for i in `seq 0 1 7`; do dd if=/dev/zero of=/mnt/scratch/test$i bs=1024k count=1000 & done
....
$ sudo xfs_bmap -vp /mnt/scratch/test* | awk '/ [0-9]*:/ { tot += $6; cnt++ } END { print tot / cnt }'
1024000
$

512MB extent size average, exactly, with throughput at 510MB/s (so
not real reduction in throughput). IOWs, fragmentation for this
workload can be directly controlled without any performance penalty
if necessary.

I hope this answers your question, Ted. ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
