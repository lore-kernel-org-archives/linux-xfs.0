Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 070857F50
	for <xfs@oss.sgi.com>; Wed, 12 Feb 2014 01:18:42 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 97AF1AC00D
	for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 23:18:38 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	bDERnUrjuEEq23Q7 for <xfs@oss.sgi.com>;
	Tue, 11 Feb 2014 23:18:33 -0800 (PST)
Date: Wed, 12 Feb 2014 18:18:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 3.14-rc2 XFS backtrace because irqs_disabled.
Message-ID: <20140212071829.GE13997@dastard>
References: <20140211172707.GA1749@redhat.com> <20140211210841.GM13647@dastard>
	<52FA9ADA.9040803@sandeen.net> <20140212004403.GA17129@redhat.com>
	<20140212010941.GM18016@ZenIV.linux.org.uk>
	<CA+55aFwoWT-0A_KTkXMkNqOy8hc=YmouTMBgWUD_z+8qYPphjA@mail.gmail.com>
	<20140212040358.GA25327@redhat.com>
	<20140212042215.GN18016@ZenIV.linux.org.uk>
	<20140212054043.GB13997@dastard>
	<CA+55aFxy2t7bnCUc-DhhxYxsZ0+GwL9GuQXRYtE_VzqZusmB9A@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+55aFxy2t7bnCUc-DhhxYxsZ0+GwL9GuQXRYtE_VzqZusmB9A@mail.gmail.com>
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, xfs@oss.sgi.com, Eric Sandeen <sandeen@sandeen.net>, Al Viro <viro@zeniv.linux.org.uk>, Linux Kernel <linux-kernel@vger.kernel.org>

On Tue, Feb 11, 2014 at 10:28:12PM -0800, Linus Torvalds wrote:
> On Tue, Feb 11, 2014 at 9:40 PM, Dave Chinner <david@fromorbit.com> wrote:
> >
> > None of the XFS code disables interrupts in that path, not does is
> > call outside XFS except to dispatch IO. The stack is pretty deep at
> > this point and I know that the standard (non stacked) IO stack can
> > consume >3kb of stack space when it gets down to having to do memory
> > reclaim during GFP_NOIO allocation at the lowest level of SCSI
> > drivers. Stack overruns typically show up with symptoms like we are
> > seeing.
> 
> That would also explain why it shows up for do_coredump(), even though
> clearly interrupts are not disabled at that point. It's just because
> do_coredump() opens a filename at a deeper point in the stack than the
> more normal system call paths do.

Right, it's exactly the same problem we have when knfsd is making
the VFS calls.

> It looks like just "do_signal()" has a stack frame that is about 230
> bytes even under normal circumstancs (largely due to "struct ksignal"
> - which in turn is largely due to the insane 128-byte padding in
> siginfo_t). Add a few other frames in there, and I guess that if it
> was close before, the coredump path just makes it go off.

Yup. But it's when you see this sort of thing you realise that
almost no GFP_KERNEL memory allocation is really safe from stack
overruns, though:

  0)     6064      64   update_group_power+0x2c/0x270
  1)     6000     384   find_busiest_group+0x10a/0x8b0
  2)     5616     288   load_balance+0x165/0x870
  3)     5328      96   idle_balance+0x106/0x1b0
  4)     5232     112   __schedule+0x7b6/0x7e0
  5)     5120      16   schedule+0x29/0x70
  6)     5104     176   percpu_ida_alloc+0x1b3/0x3d0
  7)     4928      32   blk_mq_wait_for_tags+0x1f/0x40
  8)     4896      80   blk_mq_alloc_request_pinned+0x4e/0x110
  9)     4816     128   blk_mq_make_request+0x42b/0x510
 10)     4688      48   generic_make_request+0xc0/0x110
 11)     4640      96   submit_bio+0x71/0x120
 12)     4544     192   _xfs_buf_ioapply+0x2cc/0x3b0
 13)     4352      48   xfs_buf_iorequest+0x6f/0xc0
 14)     4304      32   xlog_bdstrat+0x23/0x60
 15)     4272      96   xlog_sync+0x3a4/0x5c0
 16)     4176      48   xlog_state_release_iclog+0x121/0x130
 17)     4128     192   xlog_write+0x700/0x7c0
 18)     3936     192   xlog_cil_push+0x2ae/0x3d0
 19)     3744     128   xlog_cil_force_lsn+0x1b8/0x1e0
 20)     3616     144   _xfs_log_force_lsn+0x7c/0x300
 21)     3472      48   xfs_log_force_lsn+0x3b/0xa0
 22)     3424     112   xfs_iunpin_wait+0xd7/0x160
 23)     3312      80   xfs_reclaim_inode+0xd0/0x350
 24)     3232     432   xfs_reclaim_inodes_ag+0x277/0x3d0
 25)     2800      48   xfs_reclaim_inodes_nr+0x33/0x40
 26)     2752      16   xfs_fs_free_cached_objects+0x15/0x20
 27)     2736      80   super_cache_scan+0x169/0x170
 28)     2656     160   shrink_slab_node+0x133/0x290
 29)     2496      80   shrink_slab+0x122/0x160
 30)     2416     112   do_try_to_free_pages+0x1de/0x360
 31)     2304     192   try_to_free_pages+0x110/0x190
 32)     2112     256   __alloc_pages_nodemask+0x5a2/0x8e0
 33)     1856      80   alloc_pages_current+0xb2/0x170
 34)     1776      64   new_slab+0x265/0x2e0
 35)     1712     240   __slab_alloc+0x2fb/0x4c4
 36)     1472      80   kmem_cache_alloc+0x10b/0x140

That's almost 4700 bytes of stack usage from the
kmem_cache_alloc(GFP_KERNEL) call because it entered the IO path.
Yes, it's an extreme case, but if you're looking for a smoking
gun.... :/

I can fix this one easily - we already have a workqueue for doing
async log pushes (will split the stack between xlog_cil_force_lsn
and xlog_cil_push), but the reason we haven't used it for synchronous
log forces is that screws up fsync performance on CFQ. We don't
recommend CFQ with XFS anyway, so I think I'll make this change
anyway.

> And some of the debug options that I'm sure DaveJ has enabled tend to
> make the stack usage worse (simply because they make a lot of data
> structures bigger).

True - CONFIG_XFS_DEBUG tends to add about 5% to the stack usage of
XFS, but realistically 5% is not significant especially as we've
been hitting stack overflows with XFS on production systems
regularly enough on x86-64 over the past 2-3 years that we know what
"typical symptoms" of such overflows are...

The problem we have now is that everything outside XFS continues to
grow in stack usage, so the only choice that remains for us to avoid
overruns is to add performance impacting stack switches into the
middle of common XFS paths. We also have to do it unconditionally
because we don't know ahead of time if any specific operation is
going to require all the stack we can give it because - for example
- we can't predict when the IO path is going to require memory
allocation...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
