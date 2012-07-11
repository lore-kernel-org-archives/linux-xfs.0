Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6BNr0Ul250324 for <xfs@oss.sgi.com>; Wed, 11 Jul 2012 18:53:01 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	V5Rq0pMGwAAMTzjH for <xfs@oss.sgi.com>;
	Wed, 11 Jul 2012 16:52:58 -0700 (PDT)
Date: Thu, 12 Jul 2012 09:52:27 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/2] xfs: regression fixes for 3.5-rc7
Message-ID: <20120711235227.GA19223@dastard>
References: <1342042843-1773-1-git-send-email-david@fromorbit.com>
	<20120711224822.GQ10196@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120711224822.GQ10196@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, Jul 11, 2012 at 05:48:22PM -0500, Ben Myers wrote:
> Hey Dave,
> 
> On Thu, Jul 12, 2012 at 07:40:41AM +1000, Dave Chinner wrote:
> > These two patches need to go to Linus before 3.5 is released. The
> > first fixes the btree cursor leak properly, and the second fixes a
> > significant performance regression reported by Mel Gorman. Can you
> > review them and send them onwards to Linus?
> 
> I have some test exposure on the first one, but not on the second.  I'd rather
> have a known performance regression in 3.5 than start popping stacks again this
> late toward the end of the rc cycle.  I suggest that #2 go in for the 3.6 merge
> window and back to 3.5 via -stable.  Any other opinions?

I'd prefer not to have to go via a -stable kernel. It's a pain to
have to keep track and maintain multiple -stable kernels...

As it is, I've never once seen a popped stack through a metadata
allocation triggered path.  The worst I've seen in the past few days
is this: a bmbt block allocation in the sync write path:

       Depth    Size   Location    (45 entries)
        -----    ----   --------
  0)     5880      40   zone_statistics+0xbd/0xc0
  1)     5840     272   get_page_from_freelist+0x3db/0x870
  2)     5568     304   __alloc_pages_nodemask+0x192/0x840
  3)     5264      80   alloc_pages_current+0xb0/0x120
  4)     5184      96   xfs_buf_allocate_memory+0xfc/0x270
  5)     5088      80   xfs_buf_get_map+0x15d/0x1b0
  6)     5008      64   xfs_buf_read_map+0x33/0x130
  7)     4944      48   xfs_buf_readahead_map+0x51/0x70
  8)     4896      64   xfs_btree_reada_bufs+0xa3/0xc0
  9)     4832      48   xfs_btree_readahead_sblock+0x7e/0xa0
 10)     4784      16   xfs_btree_readahead+0x5f/0x80
 11)     4768      96   xfs_btree_increment+0x52/0x360
 12)     4672     208   xfs_btree_rshift+0x6bf/0x730
 13)     4464     288   xfs_btree_delrec+0x1308/0x14d0
 14)     4176      64   xfs_btree_delete+0x41/0xe0
 15)     4112     112   xfs_alloc_fixup_trees+0x21b/0x580
 16)     4000     192   xfs_alloc_ag_vextent_near+0xb05/0xcd0
 17)     3808      32   xfs_alloc_ag_vextent+0x228/0x2a0
 18)     3776     112   __xfs_alloc_vextent+0x4b7/0x910
 19)     3664      80   xfs_alloc_vextent+0xa5/0xb0
 20)     3584     224   xfs_bmbt_alloc_block+0xd1/0x240
 21)     3360     240   xfs_btree_split+0xe2/0x7e0
 22)     3120      96   xfs_btree_make_block_unfull+0xde/0x1d0
 23)     3024     240   xfs_btree_insrec+0x587/0x8e0
 24)     2784     112   xfs_btree_insert+0x6b/0x1d0
 25)     2672     256   xfs_bmap_add_extent_delay_real+0x1fd4/0x2210
 26)     2416      80   xfs_bmapi_allocate+0x290/0x350
 27)     2336     368   xfs_bmapi_write+0x66e/0xa60
 28)     1968     176   xfs_iomap_write_allocate+0x131/0x350
 29)     1792     112   xfs_map_blocks+0x302/0x390
 30)     1680     192   xfs_vm_writepage+0x19b/0x5a0
 31)     1488      32   __writepage+0x1a/0x50
 32)     1456     304   write_cache_pages+0x258/0x4d0
 33)     1152      96   generic_writepages+0x4d/0x70
 34)     1056      48   xfs_vm_writepages+0x4d/0x60
 35)     1008      16   do_writepages+0x21/0x50
 36)      992      64   __filemap_fdatawrite_range+0x59/0x60
 37)      928      16   filemap_fdatawrite_range+0x13/0x20
 38)      912      80   xfs_flush_pages+0x75/0xb0
 39)      832     176   xfs_file_buffered_aio_write+0xdf/0x1e0
 40)      656     128   xfs_file_aio_write+0x157/0x1d0
 41)      528     272   do_sync_write+0xde/0x120
 42)      256      48   vfs_write+0xa8/0x160
 43)      208      80   sys_write+0x4a/0x90
 44)      128     128   system_call_fastpath+0x16/0x1b

This is not quite the insanely complex, worst case double tree split
path (i.e. bmbt split, followed by a allocbt split), but it's still
very close to the worst case stack usage I've seen in above
xfs_bmapi_write() (i.e. >3.5k of stack from xfs_vm_writepage() to
the last XFS function in the stack).

In theory, the directory code could trigger such a stack, and it
calls xfs_bmapi_write() from roughly the same stack depth. It woul
dtake quite a large directory to be causing splits in the bmbt tree,
so it's a relatively rare occurance....

Also, while this is arguably a metadata allocation here, this is in
the data writeback path so perhaps the xfs_bmbt_alloc_block() call
needs to trigger allocation via a workqueue here. That would make
the worst case bmbt split usage (even for directory allocation)
switch stacks.  It's rare enough that it shouldn't introduce
performance issues....

What is notable here, however, is that none of the directory or
inode allocation paths consumed more stack than this sync write
case. That indicates that my statement assumption about inode and
directory allocation does hold some water....

> I'll feel better about if after some testing, so I'll get tests running asap.
> What testing have you and Mel done?

Mel reran his performance tests that were showing regressions, and
those regressions went away, and I've rerun all my perf tests and
xfstests for the past couple of days and not seen any changes in
performance or stack usage.

> IMO we should also consider "xfs: prevent recursion in xfs_buf_iorequest", from
> Christoph.

Yes, I think so. You don't have to wait for me to propose fixes to
suggest other patches that could be considered for Linus updates... ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
