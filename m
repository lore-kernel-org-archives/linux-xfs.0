Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E0C947F54
	for <xfs@oss.sgi.com>; Tue,  1 Apr 2014 23:47:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CA1DE304053
	for <xfs@oss.sgi.com>; Tue,  1 Apr 2014 21:47:55 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	yDHoowRxwBcDz03l for <xfs@oss.sgi.com>;
	Tue, 01 Apr 2014 21:47:52 -0700 (PDT)
Date: Wed, 2 Apr 2014 15:47:49 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs: invalid requests to request_fn from xfs_repair
Message-ID: <20140402044749.GK17603@dastard>
References: <CABHf-sxmxmM0+WVzvGGJqKrrGngm0qrGTsYDnEmUEf+GJ_pK8A@mail.gmail.com>
	<20140401204215.GG17603@dastard>
	<CABHf-sxeACnsSoJszM8Xan-VcXLkLdrY7cBM9=FCAxdMBaQohA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CABHf-sxeACnsSoJszM8Xan-VcXLkLdrY7cBM9=FCAxdMBaQohA@mail.gmail.com>
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

On Tue, Apr 01, 2014 at 06:28:19PM -0400, Jamie Pocas wrote:
> I have to say, thanks very much for the lightning fast response. Comments
> are inline. I think the punchline is going to end up being that I probably
> need to learn some more about the effects of O_DIRECT on the I/O path and
> how it ends up in the request_queue. It's tempting now to regress back to a
> bio-handling function, do my own merging, and see if I can avoid the
> problem, but I am stubborn so I will probably stick it out for as long as I
> can.
> 
> On Tue, Apr 1, 2014 at 4:42 PM, Dave Chinner <david@fromorbit.com> wrote:
> 
> > On Tue, Apr 01, 2014 at 04:16:39PM -0400, Jamie Pocas wrote:
> > > blk_queue_physical_block_size(q, 512) // should be no surprise
> > > blk_queue_logical_block_size(q, 512) // should be no surprise
> >
> > 512 byte sectors.
> >
> > > blk_queue_max_segments(q, 128); /* 128 memory segments (page +
> > > offset/length pairs) per request! */
> > > blk_queue_max_hw_sectors(q, CA_MAX_REQUEST_SECTORS); /* Up to 1024
> > sectors
> > > (512k) per request hard limit in the kernel */
> > > blk_queue_max_segment_size(q, CA_MAX_REQUEST_BYTES); /* 512k (1024
> > sectors)
> > > is the hard limit in the kernel */
> >
> > And up to 512KB per IO.
> >
> > > While iterating through segments in rq_for_each_segment(), for some
> > > requests I am seeing some odd behavior.
> > >
> > > segment 0: iter.bio->bi_sector = 0, blk_rq_cur_sectors(rq) = 903   // Ok,
> > > this looks normal
> > > segment 1: iter.bio->bi_sector = 1023, blk_rq_cur_sectors(rq) = 7 //
> > > Whoah... this doesn't look right to me
> >
> > Seems fine to me. There's absolutely no reason two separate IOs
> > can't be sub-page sector aligned or discontiguous given the above
> > configuration. If that's what the getblocks callback returned to the
> > DIO layer, then that's what you're going to see in the bios...
> >
> >
> I guess my assumption that sectors would be adjacent was invalid, but this
> is what I have read in ldd3 and other books and seen in some driver
> examples. So I apologize for my folly and it's another lesson in not
> believing everything you see on the net. The back half of my driver is
> really optimized for transferring a single contiguous lba & transfer length
> pair (ala SCSI WRITE 16 for example). However in desperation, I had changed
> the driver to support requests like this (with disjoint sector ranges) but
> it still seemed odd to me that occasionally some requests would even have
> multiple segments that would *write* the same sectors/lengths. For example
> I also see requests like the following.
> 
> Given: rq_data_dir(rq) == 1 (i.e. a write)
> segment   0: iter.bio->bi_sector = 0, blk_rq_cur_sectors(rq) = 7    // Ok
> segment   1: iter.bio->bi_sector = 0, blk_rq_cur_sectors(rq) = 7    //
> Again?
> segment   2: iter.bio->bi_sector = 0, blk_rq_cur_sectors(rq) = 7    // Yet
> again?
> segment   3: iter.bio->bi_sector = 0, blk_rq_cur_sectors(rq) = 7    //
> Really?
> ...
> segment 126: iter.bio->bi_sector = 0, blk_rq_cur_sectors(rq) = 7    //
> What's going on?
> // Reminder: segment limit is 128
> segment 127: iter.bio->bi_sector = 1023, blk_rq_cur_sectors(rq) = 1 //
> Haha, bet you though I was going to say sector = 0!

That really looks to me like a bug in whatever is building that iter
structure. It looks like there's an off-by-one on each page (should
be 8 sectors not 7) and the bi_sector is not being set correctly to
the sector offset of the bio within the IO. i.e. for a contiguous
IO it should look something like:

segment   0: iter.bio->bi_sector = 0, blk_rq_cur_sectors(rq) = 8
segment   1: iter.bio->bi_sector = 8, blk_rq_cur_sectors(rq) = 8
segment   2: iter.bio->bi_sector = 16, blk_rq_cur_sectors(rq) = 8
....
segment 127: iter.bio->bi_sector = 1016, blk_rq_cur_sectors(rq) = 8

I highly doubt the direct IO code is doing something wrong, because
a mapping bug like that would show up everywhere and not just in your
special driver....

> > The read syscall is for a byte offset (from the fd, set by lseek)
> > and a length, not a range of contiguous sectors on the device. That
> > off/len tuple gets mapped by the underlying filesystem or device
> > into an sector/len via a getblocks callback in the dio code and the
> > bios are then built according to the mappings that are returned. So
> > in many cases the IO that hits the block device looks nothing at all
> > like the IO that came from userspace.
> >
> >
> In general if I were reading a file I agree 100%, but this was the read
> call issued by xfs_repair to read the superblock directly from a block
> device. So I, perhaps wrongly, anticipated straightforward requests or
> maybe even a single 512k request coming down to the request_fn. I should
> have mentioned that this was observed while using xfs_repair earlier in the
> email though, so no offense intended. There's more of the xfs_repair strace
> in my response to your next comment below. It fails very early as you can
> imagine when xfs_repair can't read the superblock.

I figured that this is what you were talking about, but remember
that the block device also does it's own offset->sector mapping in
the direct IO layer. So it's entirely possible that the mapping
function (i.e the getblocks callback) is broken and that is why you
are seeing weird mappings in the bios being built by the direct Io
code.

> and post more of the strace below. I *do* see the O_DIRECT flag as
> expected. Here's the block device being opened. All I did was "xfs_repair
> -n /dev/tsca0", hence the O_RDONLY flag.

That all seems ok from what I'd expect from xfsrepair....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
