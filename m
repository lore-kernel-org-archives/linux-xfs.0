Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:55764 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726507AbfBZQRb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Feb 2019 11:17:31 -0500
Date: Tue, 26 Feb 2019 08:14:33 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: allocate sector sized IO buffer via page_frag_alloc
Message-ID: <20190226161433.GH21626@magnolia>
References: <20190226032737.GA11592@bombadil.infradead.org>
 <20190226045826.GJ23020@dastard>
 <20190226093302.GA24879@ming.t460p>
 <a641feb8-ceb2-2dac-27aa-7b1df10f5ae5@suse.cz>
 <CACVXFVMX=WpTRBbDTSibfXkTZxckk3ootetbE+rkJtHhsZkRAw@mail.gmail.com>
 <20190226121209.GC11592@bombadil.infradead.org>
 <20190226123545.GA6163@ming.t460p>
 <20190226130230.GD11592@bombadil.infradead.org>
 <20190226134247.GA30942@ming.t460p>
 <20190226140440.GF11592@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190226140440.GF11592@bombadil.infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Matthew Wilcox <willy@infradead.org>
Cc: Ming Lei <ming.lei@redhat.com>, Ming Lei <tom.leiming@gmail.com>, Vlastimil Babka <vbabka@suse.cz>, Dave Chinner <david@fromorbit.com>, "open list:XFS FILESYSTEM" <linux-xfs@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Vitaly Kuznetsov <vkuznets@redhat.com>, Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>, Alexander Duyck <alexander.h.duyck@linux.intel.com>, Aaron Lu <aaron.lu@intel.com>, Christopher Lameter <cl@linux.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, linux-block <linux-block@vger.kernel.org>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>

On Tue, Feb 26, 2019 at 06:04:40AM -0800, Matthew Wilcox wrote:
> On Tue, Feb 26, 2019 at 09:42:48PM +0800, Ming Lei wrote:
> > On Tue, Feb 26, 2019 at 05:02:30AM -0800, Matthew Wilcox wrote:
> > > Wait, we're imposing a ridiculous amount of complexity on XFS for no
> > > reason at all?  We should just change this to 512-byte alignment.  Tying
> > > it to the blocksize of the device never made any sense.
> > 
> > OK, that is fine since we can fallback to buffered IO for loop in case of
> > unaligned dio.
> > 
> > Then something like the following patch should work for all fs, could
> > anyone comment on this approach?
> 
> That's not even close to what I meant.
> 
> diff --git a/fs/direct-io.c b/fs/direct-io.c
> index ec2fb6fe6d37..dee1fc47a7fc 100644
> --- a/fs/direct-io.c
> +++ b/fs/direct-io.c
> @@ -1185,18 +1185,20 @@ do_blockdev_direct_IO(struct kiocb *iocb, struct inode *inode,

Wait a minute, are you all saying that /directio/ is broken on XFS too??
XFS doesn't use blockdev_direct_IO anymore.

I thought we were talking about alignment of XFS metadata buffers
(xfs_buf.c), which is a very different topic.

As I understand the problem, in non-debug mode the slab caches give
xfs_buf chunks of memory that are aligned well enough to work, but in
debug mode the slabs allocate slightly more bytes to carry debug
information which pushes the returned address up slightly, thus breaking
the alignment requirements.

So why can't we just move the debug info to the end of the object?  If
our 512 byte allocation turns into a (512 + a few more) bytes we'll end
up using 1024 bytes on the allocation regardless, so it shouldn't matter
to put the debug info at offset 512.  If the reason is fear that kernel
code will scribble off the end of the object, then return (*obj + 512).
Maybe you all have already covered this, though?

--D

>  	struct dio_submit sdio = { 0, };
>  	struct buffer_head map_bh = { 0, };
>  	struct blk_plug plug;
> -	unsigned long align = offset | iov_iter_alignment(iter);
>  
>  	/*
>  	 * Avoid references to bdev if not absolutely needed to give
>  	 * the early prefetch in the caller enough time.
>  	 */
>  
> -	if (align & blocksize_mask) {
> +	if (iov_iter_alignment(iter) & 511)
> +		goto out;
> +
> +	if (offset & blocksize_mask) {
>  		if (bdev)
>  			blkbits = blksize_bits(bdev_logical_block_size(bdev));
>  		blocksize_mask = (1 << blkbits) - 1;
> -		if (align & blocksize_mask)
> +		if (offset & blocksize_mask)
>  			goto out;
>  	}
>  
