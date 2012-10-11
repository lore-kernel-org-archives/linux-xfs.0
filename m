Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9BM514d246699 for <xfs@oss.sgi.com>; Thu, 11 Oct 2012 17:05:01 -0500
Received: from trent.utfs.org (trent.utfs.org [94.185.90.103]) by cuda.sgi.com
	with ESMTP id r6GRlhXwAV3dvts1 for <xfs@oss.sgi.com>;
	Thu, 11 Oct 2012 15:06:32 -0700 (PDT)
Date: Thu, 11 Oct 2012 15:06:29 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: possible memory allocation deadlock in xfs_buf_allocate_memory
In-Reply-To: <20121011213323.GD2739@dastard>
Message-ID: <alpine.DEB.2.01.1210111456090.10880@trent.utfs.org>
References: <alpine.DEB.2.01.1210111048170.10880@trent.utfs.org>
	<20121011213323.GD2739@dastard>
MIME-Version: 1.0
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
Cc: LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

[Cc'ed lkml, hence the full-quote]

On Fri, 12 Oct 2012 at 08:33, Dave Chinner wrote:
> On Thu, Oct 11, 2012 at 11:13:14AM -0700, Christian Kujau wrote:
> > Hi,
> > 
> > since Linux 3.5 I'm seeing these "inconsistent lock state" lockdep 
> > warnings [0]. They show up in 3.6 as well [1]. I was being told[2] that I 
> > may have run out of inode attributes. This may well be the case, but I 
> > cannot reformat the disk right now and will have to live with that warning 
> > a while longer.
> > 
> > I got the warning again today, but 8h later the system hung and eventually 
> > shutdown. The last message from the box was received via netconsole:
> > 
> >  XFS: possible memory allocation deadlock in xfs_buf_allocate_memory (mode:0x250)
> > 
> > This has been reported[3] for 3.2.1, but when the message was printed I 
> > was not around and could not watch /proc/slabinfo.
> > 
> > The last -MARK- message (some kind of heartbeat message from syslog, 
> > printing "MARK" every 5min) has been received 07:55 local time, the
> > netconsole message above was received 08:09, so two -MARK- messages were 
> > lost. sar(1) stopped recording at 08:05.
> > 
> > These two incidents (the lockdep warning and the final lockup) may be 
> > unrelated (and timestamp-wise, they seem to be), but I thought I'd 
> > better report it.
> > 
> > Full dmesg and .config: http://nerdbynature.de/bits/3.6.0/xfs/o
> 
> The inconsistent lock state is this path:
> 
> Oct 11 00:18:27 alice kernel: [261506.767190] [e5e2fc70] [c00b5d44] vm_map_ram+0x228/0x5a0
> Oct 11 00:18:27 alice kernel: [261506.768354] [e5e2fcf0] [c01a6f9c] _xfs_buf_map_pages+0x44/0x104
> Oct 11 00:18:27 alice kernel: [261506.769522] [e5e2fd10] [c01a8090] xfs_buf_get_map+0x74/0x11c
> Oct 11 00:18:27 alice kernel: [261506.770698] [e5e2fd30] [c01ffad8] xfs_trans_get_buf_map+0xc0/0xdc
> Oct 11 00:18:27 alice kernel: [261506.772106] [e5e2fd50] [c01e9504] xfs_ifree_cluster+0x3f4/0x5b0
> Oct 11 00:18:27 alice kernel: [261506.773309] [e5e2fde0] [c01eabc0] xfs_ifree+0xec/0xf0
> Oct 11 00:18:27 alice kernel: [261506.774493] [e5e2fe20] [c01bd5c0] xfs_inactive+0x274/0x448
> Oct 11 00:18:27 alice kernel: [261506.775672] [e5e2fe60] [c01b8450] xfs_fs_evict_inode+0x60/0x74
> Oct 11 00:18:27 alice kernel: [261506.776863] [e5e2fe70] [c00dfa88] evict+0xc0/0x1b4
> Oct 11 00:18:27 alice kernel: [261506.778046] [e5e2fe90] [c00db968] d_delete+0x1b0/0x1ec
> Oct 11 00:18:27 alice kernel: [261506.779235] [e5e2feb0] [c00d2e24] vfs_rmdir+0x124/0x128
> Oct 11 00:18:27 alice kernel: [261506.780425] [e5e2fed0] [c00d2f10] do_rmdir+0xe8/0x110
> Oct 11 00:18:27 alice kernel: [261506.781619] [e5e2ff40] [c0010aac] ret_from_syscall+0x0/0x38
> 
> 
> Which indicates that it is this:
> 
> > [1] http://oss.sgi.com/archives/xfs/2012-09/msg00305.html
> 
> which is a real bug in the VM code that the VM developers refuse to
> fix even though it is simple to do and patches have been posted
> several times to fix it.
> 
> /me points to his recent rant rather than repeating it:
> 
> https://lkml.org/lkml/2012/6/13/628

Read through it, only understood the half of it. But interesting to see 
that there seems to be a real issue.

> However, that is unrelated to this message:
> 
> XFS: possible memory allocation deadlock in xfs_buf_allocate_memory (mode:0x250)
> 
> which triggers when memory cannot be allocated. mode 0x250 is
> 
> 	___GFP_NOWARN | ___GFP_IO | ___GFP_WAIT
> 
> or more commonly known as:
> 
> 	GFP_NOFS
> 
> with warnings turned off. Basically the warning is saying "we're
> trying really hard to allocate memory, but we're not making
> progress". If it was only emitted once, however, it means that
> progress was made, as the message is emitted every 100 times through
> the loop and so only one message means it looped less than 200
> times...

Memory usage at that time was not different than on other days, so I don't 
know why it had a hard time allocating memory. But I don't have any 
numbers.
 
> What it does imply, however, is that vm_map_ram() is being called
> from GFP_NOFS context quite regularly and might be blocking there,
> and so the lockdep warning is more than just a nuisance - your
> system may indeed have hung there, but I don't have enough
> information to say for sure.
> 
> When it hangs next time, can you get a blocked task dump from sysrq
> (i.e. sysrq-w, or "echo w > /proc/sysrq-trigger")? That's the only

OK, will try to get this information the next time this happens.

> way we're going to know where the system hung. You might also want
> to ensure the hung task functionality is built into you kernel, so
> it automatically dumps stack traces for tasks hung longer than
> 120s...

Yes, the option was already set:

CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0

Thanks for digging through this and for the explanation!

Christian.
-- 
BOFH excuse #398:

Data for intranet got routed through the extranet and landed on the internet.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
