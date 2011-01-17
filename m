Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0HKBApa056236 for <xfs@oss.sgi.com>; Mon, 17 Jan 2011 14:11:10 -0600
Date: Mon, 17 Jan 2011 14:12:40 -0600
From: bpm@sgi.com
Subject: Re: Issues with delalloc->real extent allocation
Message-ID: <20110117201240.GW28274@sgi.com>
References: <20110114002900.GF16267@dastard> <20110114214334.GN28274@sgi.com>
	<20110114235549.GI16267@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110114235549.GI16267@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Hey Dave,

On Sat, Jan 15, 2011 at 10:55:49AM +1100, Dave Chinner wrote:
> On Fri, Jan 14, 2011 at 03:43:34PM -0600, bpm@sgi.com wrote:
> > It also presents a
> > performance issue which I've tried to resolve by extending
> > xfs_probe_cluster to probe delalloc extents-- lock up all of the pages
> > to be converted before performing the allocation and hold those locks
> > until they are submitted for writeback.  It's not very pretty but it
> > resolves the corruption.
> 
> If we zero the relevant range in the page cache at .aio_write level
> like we do with xfs_zero_eof or allocate unwritten extents instead,
> then I don't think that you need to make changes like this. 

Ganging up pages under lock in xfs_page_state_convert (along with
exactness in xfs_iomap_write_allocate) was needed to provide exclusion
with block_prepare_write because zeroing isn't done in the case of
written extents.

Converting from delalloc->unwritten has the advantage of
__xfs_get_blocks setting each buffer 'new' when you write into the page,
so the zeroing is done properly even if you convert the entire extent to
unwritten in xfs_vm_writepage instead of just the part you're going to
write out.  However, when converting from unwritten->written in the
completion handler you still need to convert only the part of the extent
that was actually written.  That might be a lot of transactions in
xfs_end_io.

> > There is still the issue of crashes...  This could be solved by
> > converting from delalloc to unwritten in xfs_page_state_convert in this
> > very exact way and then to written in the io completion handler.  Never
> > go delalloc->written directly.
> > 
> > I have not had luck reproducing this on TOT xfs and have come to realize
> > that this is because it doesn't do speculative preallocation of larger
> > delalloc extents unless you are using extsize... which I haven't tried.
> 
> Have a look at the dynamic speculative allocation patches that just
> went into 2.6.38 - I'm very interested to know whether your tests
> expose stale data now that it can do up to an entire extent (8GB on
> 4k block size) of speculative delalloc for writes that are extending
> the file.

8GB, Eek!

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
