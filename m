Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CAA157CB4
	for <xfs@oss.sgi.com>; Wed, 10 Feb 2016 15:10:03 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 93D38304059
	for <xfs@oss.sgi.com>; Wed, 10 Feb 2016 13:10:00 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	sInXNLB9xOcyH2Lh for <xfs@oss.sgi.com>;
	Wed, 10 Feb 2016 13:09:57 -0800 (PST)
Date: Thu, 11 Feb 2016 08:09:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/5] xfs: don't chain ioends during writepage submission
Message-ID: <20160210210926.GL14668@dastard>
References: <1454910258-7578-1-git-send-email-david@fromorbit.com>
	<1454910258-7578-6-git-send-email-david@fromorbit.com>
	<20160209142355.GB25829@bfoster.bfoster>
	<20160209215900.GH14668@dastard>
	<20160210131816.GB48974@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160210131816.GB48974@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Wed, Feb 10, 2016 at 08:18:17AM -0500, Brian Foster wrote:
> On Wed, Feb 10, 2016 at 08:59:00AM +1100, Dave Chinner wrote:
> > On Tue, Feb 09, 2016 at 09:23:55AM -0500, Brian Foster wrote:
> > > On Mon, Feb 08, 2016 at 04:44:18PM +1100, Dave Chinner wrote:
> > > > @@ -738,29 +726,22 @@ xfs_writepage_submit(
> > > >  	struct writeback_control *wbc,
> > > >  	int			status)
> > > >  {
> > > > -	struct blk_plug		plug;
> > > > -
> > > > -	/* Reserve log space if we might write beyond the on-disk inode size. */
> > > > -	if (!status && wpc->ioend && wpc->ioend->io_type != XFS_IO_UNWRITTEN &&
> > > > -	    xfs_ioend_is_append(wpc->ioend))
> > > > -		status = xfs_setfilesize_trans_alloc(wpc->ioend);
> > > > -
> > > > -	if (wpc->iohead) {
> > > > -		blk_start_plug(&plug);
> > > > -		xfs_submit_ioend(wbc, wpc->iohead, status);
> > > > -		blk_finish_plug(&plug);
> > > > -	}
> > > 
> > > We've dropped our plug here but I don't see anything added in
> > > xfs_vm_writepages(). Shouldn't we have one there now that ioends are
> > > submitted as we go? generic_writepages() uses one around its
> > > write_cache_pages() call..
> > 
> > It's not really necessary, as we now have higher level plugging in
> > the writeback go will get flushed on context switch, and if we don't
> > have a high level plug (e.g. fsync triggered writeback), then we
> > submit the IO immediately, just like flushing the plug here would do
> > anyway....
> > 
> 
> Ok, I'm digging around the wb code a bit and I see plugs in/around
> wb_writeback(), so I assume that's what you're referring to in the first
> case. I'm not quite following the fsync case though...
> 
> In the current upstream code, fsync() leads to the following call chain:
> 
>   filemap_write_and_wait_range()
>     __filemap_fdatawrite_range()
>       do_writepages()
>         xfs_vm_writepages()
>           generic_writepages()
>             blk_start_plug()
>             write_cache_pages()
>             blk_finish_plug()
> 
> After this series, we have the following:
> 
>   filemap_write_and_wait_range()
>     __filemap_fdatawrite_range()
>       do_writepages()
>         xfs_vm_writepages() 
>           write_cache_pages()
> 
> ... with no plug that I can see. What am I missing?

fsync tends to be a latency sensitive operation, not a bandwidth
maximising operation. Plugging trades off IO submission latency for
maximising IO bandwidth. For fsync and other single inode operations
that block waiting for the IO to complete, maximising bandwidth is
not necessarily the right thing to do.

For single inode IO commands (such as through
__filemap_fdatawrite_range), block plugging will only improve
performance if the filesystem does not form large bios to begin
with. XFS always builds maximally sized bios if it can, so plugging
cannot improve the IO throughput from such writeback behaviour
because the bios it builds cannot be further merged.  Such bios are
better served being pushed straight in the the IO scheduler queues.

IOWs, plugging only makes a difference when the IO being formed is
small but is mergable in the IO scheduler. This what happens with
small file delayed allocation in writeback in XFS, and nowdays we
have a high level plug for this (i.e. in writeback_inodes_wb() and
wb_writeback()). Hence those one-bio-per-inode-but-all-sequential IO
will be merged in the plug before dispatch, thereby improving write
bandwidth under such small file writeback workloads. (See the
numbers in commmit d353d75 writeback: plug writeback at a high
level").)

IOWs, block plugging is not a magical "make everything go faster"
knob. Different filesystems have different IO dispatch methods, and
so require different plugging strategies to optimise their IO
patterns.  It may be that plugging in xfs_vm_writepages is
advantageous in some workloads for fsync, but I haven't been able to
measure them.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
