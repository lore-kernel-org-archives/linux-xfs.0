Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5D81F7F56
	for <xfs@oss.sgi.com>; Tue,  1 Apr 2014 15:42:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C1C1EAC005
	for <xfs@oss.sgi.com>; Tue,  1 Apr 2014 13:42:34 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	9BPGOszaejF3VDwK for <xfs@oss.sgi.com>;
	Tue, 01 Apr 2014 13:42:31 -0700 (PDT)
Date: Wed, 2 Apr 2014 07:42:15 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs: invalid requests to request_fn from xfs_repair
Message-ID: <20140401204215.GG17603@dastard>
References: <CABHf-sxmxmM0+WVzvGGJqKrrGngm0qrGTsYDnEmUEf+GJ_pK8A@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CABHf-sxmxmM0+WVzvGGJqKrrGngm0qrGTsYDnEmUEf+GJ_pK8A@mail.gmail.com>
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
To: Jamie Pocas <pocas.jamie@gmail.com>
Cc: xfs@oss.sgi.com

On Tue, Apr 01, 2014 at 04:16:39PM -0400, Jamie Pocas wrote:
> Hi folks,
> 
> I have a very simple block device driver that uses the request_fn style of
> processing instead of the older bio handling or newer multiqueue approach.
> I have been using this with ext3 and ext4 for years with no issues, but
> scalability requirements have dictated that I move to xfs to better support
> larger devices.
> 
> I'm observing something weird in my request_fn. It seems like the block
> layer is issuing invalid requests to my request function, and it really
> manifests when I use xfs_repair. Here's some info:
> 
> blk_queue_physical_block_size(q, 512) // should be no surprise
> blk_queue_logical_block_size(q, 512) // should be no surprise

512 byte sectors.

> blk_queue_max_segments(q, 128); /* 128 memory segments (page +
> offset/length pairs) per request! */
> blk_queue_max_hw_sectors(q, CA_MAX_REQUEST_SECTORS); /* Up to 1024 sectors
> (512k) per request hard limit in the kernel */
> blk_queue_max_segment_size(q, CA_MAX_REQUEST_BYTES); /* 512k (1024 sectors)
> is the hard limit in the kernel */

And up to 512KB per IO.

> While iterating through segments in rq_for_each_segment(), for some
> requests I am seeing some odd behavior.
> 
> segment 0: iter.bio->bi_sector = 0, blk_rq_cur_sectors(rq) = 903   // Ok,
> this looks normal
> segment 1: iter.bio->bi_sector = 1023, blk_rq_cur_sectors(rq) = 7 //
> Whoah... this doesn't look right to me

Seems fine to me. There's absolutely no reason two separate IOs
can't be sub-page sector aligned or discontiguous given the above
configuration. If that's what the getblocks callback returned to the
DIO layer, then that's what you're going to see in the bios...

> You can see with segment 1, that the start sector is *NOT*
> adjacent to the the previous segment's sectors (there's a gap from
> sector 903 through 1022) and that the "sparse" request, for lack
> of a better term, extends beyond the max I/O boundary of 512k.
> Furthermore, this doesn't seem to jibe with what userspace is
> doing, which is a simple 512k read all in one chunk with a single
> userspace address.

The read syscall is for a byte offset (from the fd, set by lseek)
and a length, not a range of contiguous sectors on the device. That
off/len tuple gets mapped by the underlying filesystem or device
into an sector/len via a getblocks callback in the dio code and the
bios are then built according to the mappings that are returned. So
in many cases the IO that hits the block device looks nothing at all
like the IO that came from userspace.


> But when you look at the strace of what xfs_repair is doing, it's just an
> innocuous read of 512k from sector 0.
> 
> write(2, "Phase 1 - find and verify superb"..., 40Phase 1 - find and verify
> superblock...
> ) = 40
> mmap(NULL, 528384, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0)
> = 0x7f00e2f42000
> mmap(NULL, 528384, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0)
> = 0x7f00e2ec1000
> lseek(4, 0, SEEK_SET)                   = 0
> read(4, 0x7f00e2ec1200, 524288)         = -1 EIO (Input/output error)
> write(2, "superblock read failed, offset 0"..., 61superblock read failed,
> offset 0, size 524288, ag 0, rval -1
> ) = 61

This is mostly meaningless without the command line you used for
xfs_repair and the trace from the open() syscall parameters that
returned fd 4 because we have no idea what the IO context actually
is.

> The reason you see the EIO is because I am failing a request in the driver
> since it violates the restrictions I set earlier, is non-adjacent, and so I
> am unable to satisfy it.
> 
> *Point 1:* Shouldn't requests contain all segments that are adjacent on
> disk

Not necessarily, see above.

> *Point 2:* If I ignore the incorrect iter.bio->bi_sector, and just
> read/write the request out as if it were adjacent, I xfs_repair reports
> corruption,

Of course, because you read data from different sectors than was
asked for by the higher layers.

> and sure enough there are inodes which are zeroed out instead
> of having the inode magic 0x494e ( "IN") as expected. So mkfs.xfs, while
> not sending what appear to be illegal requests, is still resulting in
> corruption.
> 
> *Point 3:* Interestingly this goes away when I set
> blk_queue_max_segments(q, 1), but this obviously cuts down on clustering,
> and this of course kills performance. Is this indicative of anything in
> particular that I could be doing wrong?

Probably does, but I can't tell you what it may be...

> Please cut me some slack when I say something like xfs_repair is "sending"
> invalid requests. I know that there is the C library, system call
> interface, block layer, etc.. in between, but I just mean to say simply
> that using this tool results in this unexpected behavior. I don't mean to
> point blame at xfs or xfsprogs. If this turns out to be a block layer
> issue, and this posting needs to be sent elsewhere, I apologize and would
> appreciate being pointed in the right direction.
> 
> It almost feels like the block layer is splitting the bios up wrongly, is
> corrupting the bvecs, or is introducing a race. What's strange again, is
> that I have only seen this behavior with xfs tools, but not ext3, or ext4
> and e2fsprogs which has been working for years. It really shouldn't matter

Because the XFS tools use direct IO, and the ext tools don't.
Therefore the IO that the different tools pass through are completely
different code paths in the kernel that have different constraints.
e.g. buffered IO will always be page aligned, direct IO can be
sector aligned....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
