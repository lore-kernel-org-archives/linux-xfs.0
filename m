Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 22 Dec 2006 01:51:58 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kBM9pkqw005696
	for <linux-xfs@oss.sgi.com>; Fri, 22 Dec 2006 01:51:49 -0800
Date: Mon, 18 Dec 2006 09:44:57 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: xfslogd-spinlock bug?
Message-ID: <20061217224457.GN33919298@melbourne.sgi.com>
References: <003701c71d78$33ed28d0$0400a8c0@dcccs> <Pine.LNX.4.64.0612120932220.19050@p34.internal.lan> <00ab01c71e53$942af2f0$0400a8c0@dcccs> <000d01c72127$3d7509b0$0400a8c0@dcccs>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <000d01c72127$3d7509b0$0400a8c0@dcccs>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Haar =?iso-8859-1?B?SsOhbm9z?= <djani22@netcenter.hu>
Cc: linux-xfs@oss.sgi.com, linux-kernel@vger.kernel.org

On Sat, Dec 16, 2006 at 12:19:45PM +0100, Haar János wrote:
> Hi
> 
> I have some news.
> 
> I dont know there is a context between 2 messages, but i can see, the
> spinlock bug comes always on cpu #3.
> 
> Somebody have any idea?

Your disk interrupts are directed to CPU 3, and so log I/O completion
occurs on that CPU.

> Dec 16 12:08:36 dy-base BUG: spinlock bad magic on CPU#3, xfslogd/3/317
> Dec 16 12:08:36 dy-base general protection fault: 0000 [1]
> Dec 16 12:08:36 dy-base SMP
> Dec 16 12:08:36 dy-base
> Dec 16 12:08:36 dy-base CPU 3
> Dec 16 12:08:36 dy-base
> Dec 16 12:08:36 dy-base Modules linked in:
> Dec 16 12:08:36 dy-base  nbd

Are you using XFS on a NBD?

> Dec 16 12:08:36 dy-base  rd
> Dec 16 12:08:36 dy-base  netconsole
> Dec 16 12:08:36 dy-base  e1000
> Dec 16 12:08:36 dy-base  video
> Dec 16 12:08:36 dy-base
> Dec 16 12:08:36 dy-base Pid: 317, comm: xfslogd/3 Not tainted 2.6.19 #1
> Dec 16 12:08:36 dy-base RIP: 0010:[<ffffffff803f3aba>]
> Dec 16 12:08:36 dy-base  [<ffffffff803f3aba>] spin_bug+0x69/0xdf
> Dec 16 12:08:36 dy-base RSP: 0018:ffff81011fdedbc0  EFLAGS: 00010002
> Dec 16 12:08:36 dy-base RAX: 0000000000000033 RBX: 6b6b6b6b6b6b6b6b RCX:
                                                     ^^^^^^^^^^^^^^^^
Anyone recognise that pattern?

> Dec 16 12:08:36 dy-base Call Trace:
> Dec 16 12:08:36 dy-base  [<ffffffff803f3bdc>] _raw_spin_lock+0x23/0xf1
> Dec 16 12:08:36 dy-base  [<ffffffff805e7f2b>] _spin_lock_irqsave+0x11/0x18
> Dec 16 12:08:36 dy-base  [<ffffffff80222aab>] __wake_up+0x22/0x50
> Dec 16 12:08:36 dy-base  [<ffffffff803c97f9>] xfs_buf_unpin+0x21/0x23
> Dec 16 12:08:36 dy-base  [<ffffffff803970a4>] xfs_buf_item_unpin+0x2e/0xa6

This implies a spinlock inside a wait_queue_head_t is corrupt.

What are you type of system do you have, and what sort of
workload are you running?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
