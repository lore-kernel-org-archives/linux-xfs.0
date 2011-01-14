Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0ENrdQI114875 for <xfs@oss.sgi.com>; Fri, 14 Jan 2011 17:53:39 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 411E4154159D
	for <xfs@oss.sgi.com>; Fri, 14 Jan 2011 15:55:53 -0800 (PST)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	DMMcYUMEnopHlezJ for <xfs@oss.sgi.com>;
	Fri, 14 Jan 2011 15:55:53 -0800 (PST)
Date: Sat, 15 Jan 2011 10:55:49 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Issues with delalloc->real extent allocation
Message-ID: <20110114235549.GI16267@dastard>
References: <20110114002900.GF16267@dastard> <20110114214334.GN28274@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110114214334.GN28274@sgi.com>
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
To: bpm@sgi.com
Cc: xfs@oss.sgi.com

On Fri, Jan 14, 2011 at 03:43:34PM -0600, bpm@sgi.com wrote:
> Hi Dave,
> 
> On Fri, Jan 14, 2011 at 11:29:00AM +1100, Dave Chinner wrote:
> > I've noticed a few suspicious things trying to reproduce the
> > allocate-in-the-middle-of-a-delalloc-extent,
> ...
> > Secondly, I think we have the same expose-the-entire-delalloc-extent
> > -to-stale-data-exposure problem in ->writepage. This onnne, however,
> > is due to using BMAPI_ENTIRE to allocate the entire delalloc extent
> > the first time any part of it is written to. Even if we are only
> > writing a single page (i.e. wbc->nr_to_write = 1) and the delalloc
> > extent covers gigabytes. So, same problem when we crash.
> >
> > Finally, I think the extsize based problem exposed by test 229 is a
> > also a result of allocating space we have no pages covering in the
> > page cache (triggered by BMAPI_ENTIRE allocation) so the allocated
> > space is never zeroed and hence exposes stale data.
> 
> This is precisely the bug I was going after when I hit the
> allocate-in-the-middle-of-a-delalloc-extent bug.  This is a race between
> block_prepare_write/__xfs_get_blocks and writepage/xfs_page_state
> convert.  When xfs_page_state_convert allocates a real extent for a page
> toward the beginning of a delalloc extent, XFS_BMAPI converts the entire
> delalloc extent.  Any subsequent writes into the page cache toward the
> end of this freshly allocated extent will see a written extent instead
> of delalloc and read the block from disk into the page before writing
> over it.  If the write does not cover the entire page garbage from disk
> will be exposed into the page cache.

I see from later on you are getting this state fom using a large
extsize. Perhaps this comes back to my comment about extsize
alignment might be better handled at the .aio_write level rather
than hiding inside the get_block() callback and attempting to handle
the mismatch at the .writepage level.

Worth noting, though, is that DIO handles extsize unaligned writes
by allocating unwritten extsize sized/aligned extents an then doing
conversion at IO completion time. So perhaps we should be following
this example for delalloc conversion....

I think, however, if we use delalloc->unwritten allocation, we will
need to stop trusting the state of buffer heads in .writepage.  That
is because we'd then have blocks marked as buffer_delay() that
really cover unwritten extents and would need remapping. We're
already moving in the direction of not using the state in buffer
heads in ->writepage, so perhaps we need to speed up that
conversion as the first. Christoph, what are you plans here?

> <snip>
> 
> > I'm sure there are other ways to solve these problems, but these two
> > are the ones that come to mind for me.  I'm open to other solutions
> > or ways to improve on these ones, especially if they are simpler. ;)
> > Anyone got any ideas or improvements?
> 
> The direction I've been taking is to use XFS_BMAPI_EXACT in
> *xfs_iomap_write_allocate to ensure that an extent covering exactly the
> pages we're prepared to write out immediately is allocated and the rest
> of the delalloc extent is left as is.  This exercises some of the btree
> code more heavily and led to the discovery of the
> allocate-in-the-middle-of-a-delalloc-extent bug.

Yup, that explains it ;)

> It also presents a
> performance issue which I've tried to resolve by extending
> xfs_probe_cluster to probe delalloc extents-- lock up all of the pages
> to be converted before performing the allocation and hold those locks
> until they are submitted for writeback.  It's not very pretty but it
> resolves the corruption.

If we zero the relevant range in the page cache at .aio_write level
like we do with xfs_zero_eof or allocate unwritten extents instead,
then I don't think that you need to make changes like this. 

> There is still the issue of crashes...  This could be solved by
> converting from delalloc to unwritten in xfs_page_state_convert in this
> very exact way and then to written in the io completion handler.  Never
> go delalloc->written directly.
> 
> I have not had luck reproducing this on TOT xfs and have come to realize
> that this is because it doesn't do speculative preallocation of larger
> delalloc extents unless you are using extsize... which I haven't tried.

Have a look at the dynamic speculative allocation patches that just
went into 2.6.38 - I'm very interested to know whether your tests
expose stale data now that it can do up to an entire extent (8GB on
4k block size) of speculative delalloc for writes that are extending
the file.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
