Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:51973 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727488AbfB0Vip (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Feb 2019 16:38:45 -0500
Date: Thu, 28 Feb 2019 08:38:39 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: allocate sector sized IO buffer via page_frag_alloc
Message-ID: <20190227213839.GG16436@dastard>
References: <20190226045826.GJ23020@dastard>
 <20190226093302.GA24879@ming.t460p>
 <a641feb8-ceb2-2dac-27aa-7b1df10f5ae5@suse.cz>
 <CACVXFVMX=WpTRBbDTSibfXkTZxckk3ootetbE+rkJtHhsZkRAw@mail.gmail.com>
 <20190226121209.GC11592@bombadil.infradead.org>
 <20190226123545.GA6163@ming.t460p>
 <20190226130230.GD11592@bombadil.infradead.org>
 <20190226134247.GA30942@ming.t460p>
 <20190226140440.GF11592@bombadil.infradead.org>
 <20190226161433.GH21626@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190226161433.GH21626@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>, Ming Lei <ming.lei@redhat.com>, Ming Lei <tom.leiming@gmail.com>, Vlastimil Babka <vbabka@suse.cz>, "open list:XFS FILESYSTEM" <linux-xfs@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Vitaly Kuznetsov <vkuznets@redhat.com>, Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>, Alexander Duyck <alexander.h.duyck@linux.intel.com>, Aaron Lu <aaron.lu@intel.com>, Christopher Lameter <cl@linux.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, linux-block <linux-block@vger.kernel.org>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>

On Tue, Feb 26, 2019 at 08:14:33AM -0800, Darrick J. Wong wrote:
> On Tue, Feb 26, 2019 at 06:04:40AM -0800, Matthew Wilcox wrote:
> > On Tue, Feb 26, 2019 at 09:42:48PM +0800, Ming Lei wrote:
> > > On Tue, Feb 26, 2019 at 05:02:30AM -0800, Matthew Wilcox wrote:
> > > > Wait, we're imposing a ridiculous amount of complexity on XFS for no
> > > > reason at all?  We should just change this to 512-byte alignment.  Tying
> > > > it to the blocksize of the device never made any sense.
> > > 
> > > OK, that is fine since we can fallback to buffered IO for loop in case of
> > > unaligned dio.
> > > 
> > > Then something like the following patch should work for all fs, could
> > > anyone comment on this approach?
> > 
> > That's not even close to what I meant.
> > 
> > diff --git a/fs/direct-io.c b/fs/direct-io.c
> > index ec2fb6fe6d37..dee1fc47a7fc 100644
> > --- a/fs/direct-io.c
> > +++ b/fs/direct-io.c
> > @@ -1185,18 +1185,20 @@ do_blockdev_direct_IO(struct kiocb *iocb, struct inode *inode,
> 
> Wait a minute, are you all saying that /directio/ is broken on XFS too??
> XFS doesn't use blockdev_direct_IO anymore.

No, loop devices w/ direct IO is a complete red herring. It's the
same issue - the upper filesystem is sending down unaligned bios
to the loop device, which is then just passing them on to the
underlying filesystem via DIO, and the DIO code in the lower
filesystem saying "that user memory buffer ain't aligned to my
logical sector size" and rejecting it.

Actually, in XFS's case, it doesn't care about memory buffer
alignment - it's the iomap code that is rejecting it when mapping
the memory buffer to a bio in iomap_dio_bio_actor():

	unsigned int blkbits = blksize_bits(bdev_logical_block_size(iomap->bdev));
.....
	unsigned int align = iov_iter_alignment(dio->submit.iter);
.....
	if ((pos | length | align) & ((1 << blkbits) - 1))
		return -EINVAL;

IOWs, if the memory buffer is not aligned to the logical block size
of the underlying device (which defaults to 512 bytes) then it will
be rejected by the lower filesystem...

> I thought we were talking about alignment of XFS metadata buffers
> (xfs_buf.c), which is a very different topic.

Yup, it's the same problem, just a different symptom. Fix the
unaligned buffer problem, we fix the loop dev w/ direct-io problem,
too.

FWIW, this "filesystem image sector size mismatch" problem has been
around for many, many years - the same issue that occurs with loop
devices when you try to mount a 512 byte sector image on a hard 4k
sector host filesystem/storage device using direct IO in the loop
device. This isn't a new thing at all - if you want to use direct IO
to manipulate filesystem images, you actually need to know what you
are doing....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
