Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0I1gdag089152 for <xfs@oss.sgi.com>; Mon, 17 Jan 2011 19:42:39 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DE728101A4B5
	for <xfs@oss.sgi.com>; Mon, 17 Jan 2011 17:44:54 -0800 (PST)
Received: from mail.internode.on.net (bld-mail20.adl6.internode.on.net
	[150.101.137.105]) by cuda.sgi.com with ESMTP id
	8OMHXKMPNi3FPYXM for <xfs@oss.sgi.com>;
	Mon, 17 Jan 2011 17:44:54 -0800 (PST)
Date: Tue, 18 Jan 2011 12:44:51 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Issues with delalloc->real extent allocation
Message-ID: <20110118014451.GT28803@dastard>
References: <20110114002900.GF16267@dastard> <20110114214334.GN28274@sgi.com>
	<20110114235549.GI16267@dastard> <20110117201240.GW28274@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110117201240.GW28274@sgi.com>
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

On Mon, Jan 17, 2011 at 02:12:40PM -0600, bpm@sgi.com wrote:
> Hey Dave,
> 
> On Sat, Jan 15, 2011 at 10:55:49AM +1100, Dave Chinner wrote:
> > On Fri, Jan 14, 2011 at 03:43:34PM -0600, bpm@sgi.com wrote:
> > > It also presents a
> > > performance issue which I've tried to resolve by extending
> > > xfs_probe_cluster to probe delalloc extents-- lock up all of the pages
> > > to be converted before performing the allocation and hold those locks
> > > until they are submitted for writeback.  It's not very pretty but it
> > > resolves the corruption.
> > 
> > If we zero the relevant range in the page cache at .aio_write level
> > like we do with xfs_zero_eof or allocate unwritten extents instead,
> > then I don't think that you need to make changes like this. 
> 
> Ganging up pages under lock in xfs_page_state_convert (along with
> exactness in xfs_iomap_write_allocate) was needed to provide exclusion
> with block_prepare_write because zeroing isn't done in the case of
> written extents.
> 
> Converting from delalloc->unwritten has the advantage of
> __xfs_get_blocks setting each buffer 'new' when you write into the page,
> so the zeroing is done properly even if you convert the entire extent to
> unwritten in xfs_vm_writepage instead of just the part you're going to
> write out. 

That's definitely the advantage to using unwritten extents in this
case. However, it also means that all the buffers that were
already set up at the time of delalloc->unwritten as buffer_delay()
are now incorrect - the underlying extent is now unwritten, no
delayed allocation. Hence when it comes to writing buffer_delay()
buffers, we would also have to handle the case that they are really
buffer_unwritten(). That could be very nasty....

> However, when converting from unwritten->written in the
> completion handler you still need to convert only the part of the extent
> that was actually written.  That might be a lot of transactions in
> xfs_end_io.

Yes, that was my original concern fo the general case and
why I was looking at an intent/done transaction arrangement rather
than unwritten/conversion arrangement. The "done" part of the
transaction is much less overhead, and we can safely do the
transaction reservation (i.e. the blocking bits) before the IO is
issued so that we keep the loverhead on the completion side down to
an absolute minimum....

However, when tracking down an assert failure reported by Christoph
with the new speculative delalloc code this morning, I've realised
that extent alignment for delayed allocation in xfs_bmapi() is badly
broken. It can result in attempting to set up a delalloc extent
larger than the maximum extent size because it aligns extents by
extending them.  Hence if the extent being allocated is MAXEXTLEN in
length, the extent size alignment will extend it and we'll do nasty
stuff to the extent record we insert into the incore extent tree.

To make matters worse, extent size is not limited to the maximum
supported extent size in the filesystem. The extent size can be
set to (2^32 bytes - 1 fsblock), but for 512 byte block size
filesystems the maximum extent size is 2^21 * 2^9 = 2^30. You can't
align extents to a size larger than that maximum extent size, and if
you try:

# sudo mkfs.xfs -b size=512 -f /dev/vda
...
# xfs_io -f -c "extsize 2g" \
> -c "ftruncate 4g" \
> -c "pwrite 64k 512" \
> -c "bmap -vp" /mnt/test/foo
XFS: Assertion failed: k < (1 << STARTBLOCKVALBITS), file: fs/xfs/xfs_bmap_btree.h, line: 83
....
Call Trace:
  [<ffffffff8145998c>] xfs_bmapi+0x167c/0x1a20
  [<ffffffff81488be2>] xfs_iomap_write_delay+0x1c2/0x340
  [<ffffffff814a7b62>] __xfs_get_blocks+0x402/0x4d0
  [<ffffffff814a7c61>] xfs_get_blocks+0x11/0x20
  [<ffffffff8118f1fb>] __block_write_begin+0x20b/0x5a0
  [<ffffffff8118f6f6>] block_write_begin+0x56/0x90
  [<ffffffff814a7541>] xfs_vm_write_begin+0x41/0x70
  [<ffffffff81118c06>] generic_file_buffered_write+0x106/0x270
  [<ffffffff814ae7a2>] xfs_file_buffered_aio_write+0xd2/0x190
  [<ffffffff814aece2>] xfs_file_aio_write+0x1c2/0x310
  [<ffffffff8116052a>] do_sync_write+0xda/0x120
  [<ffffffff81160850>] vfs_write+0xd0/0x190
  [<ffffffff81161262>] sys_pwrite64+0x82/0xa0
  [<ffffffff8103a002>] system_call_fastpath+0x16/0x1b

Which failed this check:

81      static inline xfs_fsblock_t nullstartblock(int k)
82      {
83  >>>>>>      ASSERT(k < (1 << STARTBLOCKVALBITS));
84              return STARTBLOCKMASK | (k);
85      }

You end up with a corrupt extent record in the inncore extent list.

Along the same lines, extsize > ag size for non-rt inode is also
invalid. It won't be handled correctly by the delalloc->unwritten
method because delalloc conversion is currently limited to a single
allocation per .writepage call to avoid races with truncate. Hence
when extsize is larger than an AG, we'll only allocate the part
within an a single AG and hence leave part of the delalloc range in
the delalloc state. With no pages covering this range, it'll never
get written or allocated. Not to mention that it'll  trip assert
failures in xfs_getbmap:

# sudo mkfs.xfs -b size=4k -f-dagsize=1g /dev/vda
...
# xfs_io -f -c "extsize 2g" \
> -c "ftruncate 4g" \
> -c "pwrite 64k 512" \
> -c "bmap -vp" /mnt/test/foo
XFS: Assertion failed: ((iflags & BMV_IF_DELALLOC) != 0) || (map[i].br_startblock != DELAYSTARTBLOCK) file: fs/xfs/xfs_bmap.c, line: 5558
.....

These problems indicate to me that doing extent size alignment for
delayed allocation inside xfs_bmapi() is wrong on many levels.
Moving the "alignment" to zeroing at the .aio_write level solves
these issues except for one detail - ensuring that speculative
delalloc beyond EOF is correctly aligned - this can be handled easily
by the prealloc code.

Hence I'm thinking that the solution we should be implementing is:

	1. Limit extsize values to sane alignment boundaries.

	2. Do extsize alignment for delalloc by zeroing the page
	   cache at the .aio_write level for regions not covered by
	   the write.

	3. Ensure that speculative delalloc is extsize aligned

	4. Rip the delalloc extent alignment code from xfs_bmapi()

	5. Implement alloc intent/done transactions to protect
	   against stale data exposure caused by crashing between
	   allocation and data write completion (*).

I think that covers all the issues we've discussed - have I missed
anything?

Cheers,

Dave.

(*) FWIW, since I proposed the intent/done method, I've realised it
also solves the main difficulty in implementing data-in-inode
safely: how to sycnhronise the unlogged data write when we move the
data out of the inode with the allocation transaction so we know
when we can allow the tail of the log to move past the allocation
transaction or whether we can replay the format change transaction
in log recovery.....

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
