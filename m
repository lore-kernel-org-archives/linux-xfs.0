Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5U2moQV166420 for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 21:48:51 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E21114C28F9
	for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 19:48:48 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	R32sbtFhFuXYjctG for <xfs@oss.sgi.com>;
	Wed, 29 Jun 2011 19:48:48 -0700 (PDT)
Date: Thu, 30 Jun 2011 12:48:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 03/27] xfs: use write_cache_pages for writeback clustering
Message-ID: <20110630024845.GC561@dastard>
References: <20110629140109.003209430@bombadil.infradead.org>
	<20110629140336.950805096@bombadil.infradead.org>
	<20110630020013.GX561@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110630020013.GX561@dastard>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Thu, Jun 30, 2011 at 12:00:13PM +1000, Dave Chinner wrote:
> On Wed, Jun 29, 2011 at 10:01:12AM -0400, Christoph Hellwig wrote:
> > Instead of implementing our own writeback clustering use write_cache_pages
> > to do it for us.  This means the guts of the current writepage implementation
> > become a new helper used both for implementing ->writepage and as a callback
> > to write_cache_pages for ->writepages.  A new struct xfs_writeback_ctx
> > is used to track block mapping state and the ioend chain over multiple
> > invocation of it.
> > 
> > The advantage over the old code is that we avoid a double pagevec lookup,
> > and a more efficient handling of extent boundaries inside a page for
> > small blocksize filesystems, as well as having less XFS specific code.
> 
> Yes, it should be, but I can't actually measure any noticable CPU
> usage difference @800MB/s writeback. The profiles change shape
> around the changed code, but overall cpu usage does not change. I
> think this is because the second pagevec lookup is pretty much free
> because the radix tree is already hot in cache when we do the second
> lookup...
> 
> > The downside is that we don't do writeback clustering when called from
> > kswapd anyore, but that is a case that should be avoided anyway.  Note
> > that we still convert the whole delalloc range from ->writepage, so
> > the on-disk allocation pattern is not affected.
> 
> All the more reason to ensure the mm subsystem doesn't do this....
> 
> .....
> >  error:
> > -	if (iohead)
> > -		xfs_cancel_ioend(iohead);
> > -
> > -	if (err == -EAGAIN)
> > -		goto redirty;
> > -
> 
> Should this EAGAIN handling be dealt with in the removing-the-non-
> blocking-mode patch?
> 
> > +STATIC int
> >  xfs_vm_writepages(
> >  	struct address_space	*mapping,
> >  	struct writeback_control *wbc)
> >  {
> > +	struct xfs_writeback_ctx ctx = { };
> > +	int ret;
> > +
> >  	xfs_iflags_clear(XFS_I(mapping->host), XFS_ITRUNCATED);
> > -	return generic_writepages(mapping, wbc);
> > +
> > +	ret = write_cache_pages(mapping, wbc, __xfs_vm_writepage, &ctx);
> > +
> > +	if (ctx.iohead) {
> > +		if (ret)
> > +			xfs_cancel_ioend(ctx.iohead);
> > +		else
> > +			xfs_submit_ioend(wbc, ctx.iohead);
> > +	}
> 
> I think this error handling does not work. If we have put pages into
> the ioend (i.e. successful ->writepage calls) and then have a
> ->writepage call fail, we'll get all the pages under writeback (i.e.
> those on the ioend) remain in that state, and not ever get written
> back (so move into the clean state) or redirtied (so written again
> later)
> 
> xfs_cancel_ioend() was only ever called for the first page sent down
> to ->writepage, and on error that page was redirtied separately.
> Hence it doesn't handle this case at all as it never occurs in the
> existing code.
> 
> I'd suggest that regardless of whether an error is returned here,
> the existence of ctx.iohead indicates a valid ioend that needs to be
> submitted....

I think i just tripped this. I'm running a 1k block size filesystem,
and test 224 has hung with waiting on IO completion after .writepage
errors:

[ 2850.300979] XFS (vdb): Mounting Filesystem
[ 2850.310069] XFS (vdb): Ending clean mount
[ 2867.246341] Filesystem "vdb": reserve blocks depleted! Consider increasing reserve pool size.
[ 2867.247652] XFS (vdb): page discard on page ffffea0000257b40, inode 0x1c6, offset 1187840.
[ 2867.254135] XFS (vdb): page discard on page ffffea0000025f40, inode 0x423, offset 1839104.
[ 2867.256289] XFS (vdb): page discard on page ffffea0000a21aa0, inode 0x34e, offset 28672.
[ 2867.258845] XFS (vdb): page discard on page ffffea00001830d0, inode 0xe5, offset 3637248.
[ 2867.260637] XFS (vdb): page discard on page ffffea0000776af8, inode 0x132, offset 6283264.
[ 2867.269380] XFS (vdb): page discard on page ffffea00009d5d38, inode 0xf1, offset 5632000.
[ 2867.277851] XFS (vdb): page discard on page ffffea0000017e60, inode 0x27a, offset 32768.
[ 2867.281165] XFS (vdb): page discard on page ffffea0000258278, inode 0x274, offset 32768.
[ 2867.282802] XFS (vdb): page discard on page ffffea00009a3c60, inode 0x48a, offset 32768.
[ 2867.284166] XFS (vdb): page discard on page ffffea0000cc7808, inode 0x42e, offset 32768.
[ 2867.287138] XFS (vdb): page discard on page ffffea00004d4440, inode 0x4e0, offset 32768.
[ 2867.288500] XFS (vdb): page discard on page ffffea0000b34978, inode 0x4cd, offset 32768.
[ 2867.289381] XFS (vdb): page discard on page ffffea00003f40f8, inode 0x4c4, offset 155648.
[ 2867.291536] XFS (vdb): page discard on page ffffea0000023578, inode 0x4c7, offset 32768.
[ 2867.300880] XFS (vdb): page discard on page ffffea00005276e8, inode 0x4cc, offset 32768.
[ 2867.318819] XFS (vdb): page discard on page ffffea0000777230, inode 0x449, offset 8581120.
[ 4701.141666] SysRq : Show Blocked State
[ 4701.142093]   task                        PC stack   pid father
[ 4701.142707] dd              D ffff8800076edbe8     0 14211   8946 0x00000000
[ 4701.143509]  ffff88002b03fa58 0000000000000086 ffffea00002db598 ffffea0000000000
[ 4701.144009]  ffff88002b03f9d8 ffffffff81113a35 ffff8800076ed860 0000000000010f80
[ 4701.144009]  ffff88002b03ffd8 ffff88002b03e010 ffff88002b03ffd8 0000000000010f80
[ 4701.144009] Call Trace:
[ 4701.144009]  [<ffffffff81113a35>] ? __free_pages+0x35/0x40
[ 4701.144009]  [<ffffffff81062f69>] ? default_spin_lock_flags+0x9/0x10
[ 4701.144009]  [<ffffffff8110b520>] ? __lock_page+0x70/0x70
[ 4701.144009]  [<ffffffff81afe2d0>] io_schedule+0x60/0x80
[ 4701.144009]  [<ffffffff8110b52e>] sleep_on_page+0xe/0x20
[ 4701.144009]  [<ffffffff81afec2f>] __wait_on_bit+0x5f/0x90
[ 4701.144009]  [<ffffffff8110b773>] wait_on_page_bit+0x73/0x80
[ 4701.144009]  [<ffffffff810a4110>] ? autoremove_wake_function+0x40/0x40
[ 4701.144009]  [<ffffffff81116365>] ? pagevec_lookup_tag+0x25/0x40
[ 4701.144009]  [<ffffffff8110bbc2>] filemap_fdatawait_range+0x112/0x1a0
[ 4701.144009]  [<ffffffff8145f469>] xfs_wait_on_pages+0x59/0x80
[ 4701.144009]  [<ffffffff8145f51d>] xfs_flush_pages+0x8d/0xb0
[ 4701.144009]  [<ffffffff8145f084>] xfs_file_buffered_aio_write+0x104/0x190
[ 4701.144009]  [<ffffffff81b03a98>] ? do_page_fault+0x1e8/0x450
[ 4701.144009]  [<ffffffff8145f2cf>] xfs_file_aio_write+0x1bf/0x300
[ 4701.144009]  [<ffffffff81160844>] ? path_openat+0x104/0x3f0
[ 4701.144009]  [<ffffffff8115251a>] do_sync_write+0xda/0x120
[ 4701.144009]  [<ffffffff816488b3>] ? security_file_permission+0x23/0x90
[ 4701.144009]  [<ffffffff81152a88>] vfs_write+0xc8/0x180
[ 4701.144009]  [<ffffffff81152c31>] sys_write+0x51/0x90
[ 4701.144009]  [<ffffffff81b07ec2>] system_call_fastpath+0x16/0x1b

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
