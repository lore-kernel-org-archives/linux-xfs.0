Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0H0QIZt205336 for <xfs@oss.sgi.com>; Sun, 16 Jan 2011 18:26:18 -0600
Date: Sun, 16 Jan 2011 19:28:27 -0500 (EST)
From: Lachlan McIlroy <lmcilroy@redhat.com>
Message-ID: <1414867864.5452.1295224107104.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
In-Reply-To: <20110114214334.GN28274@sgi.com>
Subject: Re: Issues with delalloc->real extent allocation
MIME-Version: 1.0
Reply-To: Lachlan McIlroy <lmcilroy@redhat.com>
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

----- Original Message -----
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
> allocate-in-the-middle-of-a-delalloc-extent bug. This is a race
> between
> block_prepare_write/__xfs_get_blocks and writepage/xfs_page_state
> convert. When xfs_page_state_convert allocates a real extent for a
> page
> toward the beginning of a delalloc extent, XFS_BMAPI converts the
> entire
> delalloc extent. Any subsequent writes into the page cache toward the
> end of this freshly allocated extent will see a written extent instead
> of delalloc and read the block from disk into the page before writing
> over it. If the write does not cover the entire page garbage from disk
> will be exposed into the page cache.

Ben, take a look at the XFS gap list code in IRIX - this code was
designed specifically to handle this problem.  It's also implemented in
several of the cxfs clients too.  On entry to a write() it will create a
list of all the holes that exist in the write range before any delayed
allocations are created.  The first call to xfs_bmapi() sets up the delayed
allocation for the entire write (even if the bmaps returned don't cover the
full write range).  If the write results in a fault from disk then it checks
the gap list to see if any sections of the buffer used to cover a hole and
if so it ignores the state of the extent and zeroes those region(s) in the
buffer that match the pre-existing holes.  If the buffer has multiple
non-hole sections that need to be read from disk the whole buffer will be
read from disk and the zeroing of the holes is done post I/O - this reduces
the number of I/Os to be done.  The whole delayed allocation can be safely
converted at any time without risk of reading exposed data (assuming no
crash that is).  As the write progresses through the range it removes
sections from the front of the gap list so by the time the write is complete
the gap list is empty.  The gap list does not have a dedicated lock to
protect it but instead relies on the iolock to ensure that only one write
operation occurs at once (so it's not appropriate for direct I/O).

> 
> <snip>
> 
> > I'm sure there are other ways to solve these problems, but these two
> > are the ones that come to mind for me. I'm open to other solutions
> > or ways to improve on these ones, especially if they are simpler. ;)
> > Anyone got any ideas or improvements?
> 
> The direction I've been taking is to use XFS_BMAPI_EXACT in
> *xfs_iomap_write_allocate to ensure that an extent covering exactly
> the
> pages we're prepared to write out immediately is allocated and the
> rest
> of the delalloc extent is left as is. This exercises some of the btree
> code more heavily and led to the discovery of the
> allocate-in-the-middle-of-a-delalloc-extent bug. It also presents a
> performance issue which I've tried to resolve by extending
> xfs_probe_cluster to probe delalloc extents-- lock up all of the pages
> to be converted before performing the allocation and hold those locks
> until they are submitted for writeback. It's not very pretty but it
> resolves the corruption.
> 
> There is still the issue of crashes... This could be solved by
> converting from delalloc to unwritten in xfs_page_state_convert in
> this
> very exact way and then to written in the io completion handler. Never
> go delalloc->written directly.

That solution would probably make the gap list redundant too.

> 
> I have not had luck reproducing this on TOT xfs and have come to
> realize
> that this is because it doesn't do speculative preallocation of larger
> delalloc extents unless you are using extsize... which I haven't
> tried.
> 
> Regards,
> Ben
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
