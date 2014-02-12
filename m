Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 33BA47F50
	for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 23:40:53 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 28457304059
	for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 21:40:49 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	2xpNN8Q9f7OUexGC for <xfs@oss.sgi.com>;
	Tue, 11 Feb 2014 21:40:47 -0800 (PST)
Date: Wed, 12 Feb 2014 16:40:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 3.14-rc2 XFS backtrace because irqs_disabled.
Message-ID: <20140212054043.GB13997@dastard>
References: <20140211172707.GA1749@redhat.com> <20140211210841.GM13647@dastard>
	<52FA9ADA.9040803@sandeen.net> <20140212004403.GA17129@redhat.com>
	<20140212010941.GM18016@ZenIV.linux.org.uk>
	<CA+55aFwoWT-0A_KTkXMkNqOy8hc=YmouTMBgWUD_z+8qYPphjA@mail.gmail.com>
	<20140212040358.GA25327@redhat.com>
	<20140212042215.GN18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140212042215.GN18016@ZenIV.linux.org.uk>
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
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Dave Jones <davej@redhat.com>, Eric Sandeen <sandeen@sandeen.net>, Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Wed, Feb 12, 2014 at 04:22:15AM +0000, Al Viro wrote:
> On Tue, Feb 11, 2014 at 11:03:58PM -0500, Dave Jones wrote:
> > [ 3111.414202]  [<ffffffff8d1f9036>] bio_alloc_bioset+0x156/0x210
> > [ 3111.414855]  [<ffffffffc0314231>] _xfs_buf_ioapply+0x1c1/0x3c0 [xfs]
> > [ 3111.415517]  [<ffffffffc03858f2>] ? xlog_bdstrat+0x22/0x60 [xfs]
> > [ 3111.416175]  [<ffffffffc031449b>] xfs_buf_iorequest+0x6b/0xf0 [xfs]
> > [ 3111.416843]  [<ffffffffc03858f2>] xlog_bdstrat+0x22/0x60 [xfs]
> > [ 3111.417509]  [<ffffffffc0387a87>] xlog_sync+0x3a7/0x5b0 [xfs]
> > [ 3111.418175]  [<ffffffffc0387d9f>] xlog_state_release_iclog+0x10f/0x120 [xfs]
> > [ 3111.418846]  [<ffffffffc0388840>] xlog_write+0x6f0/0x800 [xfs]
> > [ 3111.419518]  [<ffffffffc038a061>] xlog_cil_push+0x2f1/0x410 [xfs]
> 
> Very interesting.  The first thing xlog_cil_push() is doing is blocking
> kmalloc().  So at that point it still hadn't been atomic.  I'd probably
> slap may_sleep() in the beginning of xlog_sync() and see if that triggers...

None of the XFS code disables interrupts in that path, not does is
call outside XFS except to dispatch IO. The stack is pretty deep at
this point and I know that the standard (non stacked) IO stack can
consume >3kb of stack space when it gets down to having to do memory
reclaim during GFP_NOIO allocation at the lowest level of SCSI
drivers. Stack overruns typically show up with symptoms like we are
seeing.

Simple example with memory allocation follows. keep in mind that
memory reclaim uses a whole lot more stack if it is needed, and that
scheduling at this point requires about 1k of stack to be free for
the scheduler footprint, too.

FWIW, the blk-mq stuff seems to hae added 200-300 bytes of new stack
usage to the IO path....

$ sudo cat /sys/kernel/debug/tracing/stack_trace
        Depth    Size   Location    (45 entries)
        -----    ----   --------
  0)     5944      40   zone_statistics+0xbd/0xc0
  1)     5904     256   get_page_from_freelist+0x3a8/0x8a0
  2)     5648     256   __alloc_pages_nodemask+0x143/0x8e0
  3)     5392      80   alloc_pages_current+0xb2/0x170
  4)     5312      64   new_slab+0x265/0x2e0
  5)     5248     240   __slab_alloc+0x2fb/0x4c4
  6)     5008      80   __kmalloc+0x133/0x180
  7)     4928     112   virtqueue_add_sgs+0x2fe/0x520
  8)     4816     288   __virtblk_add_req+0xd5/0x180
  9)     4528      96   virtio_queue_rq+0xdd/0x1d0
 10)     4432     112   __blk_mq_run_hw_queue+0x1c3/0x3c0
 11)     4320      16   blk_mq_run_hw_queue+0x35/0x40
 12)     4304      80   blk_mq_insert_requests+0xc5/0x120
 13)     4224      96   blk_mq_flush_plug_list+0x129/0x140
 14)     4128     112   blk_flush_plug_list+0xe7/0x240
 15)     4016      32   blk_finish_plug+0x18/0x50
 16)     3984     192   _xfs_buf_ioapply+0x30f/0x3b0
 17)     3792      48   xfs_buf_iorequest+0x6f/0xc0
....
 37)      928      16   xfs_vn_create+0x13/0x20
 38)      912      64   vfs_create+0xb5/0xf0
 39)      848     208   do_last.isra.53+0x6e0/0xd00
 40)      640     176   path_openat+0xbe/0x620
 41)      464     208   do_filp_open+0x43/0xa0
 42)      256     112   do_sys_open+0x13c/0x230
 43)      144      16   SyS_open+0x22/0x30
 44)      128     128   system_call_fastpath+0x16/0x1b


Dave, before chasing ghosts, can you (like Eric originally asked)
turn on stack overrun detection?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
