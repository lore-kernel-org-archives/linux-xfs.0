Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 42D327F37
	for <xfs@oss.sgi.com>; Mon,  4 Jan 2016 13:40:48 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DEC44AC004
	for <xfs@oss.sgi.com>; Mon,  4 Jan 2016 11:40:47 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	QAvbNy9BbmyDhxrE for <xfs@oss.sgi.com>;
	Mon, 04 Jan 2016 11:40:45 -0800 (PST)
Date: Tue, 5 Jan 2016 06:40:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Suspend does not work with v4.4-rc8
Message-ID: <20160104194014.GD19802@dastard>
References: <20160104202611.5b100540@saldaea>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160104202611.5b100540@saldaea>
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
To: Julian Wollrath <jwollrath@web.de>
Cc: Jiri Kosina <jkosina@suse.cz>, xfs@oss.sgi.com

On Mon, Jan 04, 2016 at 08:26:11PM +0100, Julian Wollrath wrote:
> Hi,
> 
> suspending (either to RAM or disk) fails with 4.4-rc8 with the
> following message while v4.3.3 worked fine:
> 
> kernel: Freezing of tasks failed after 20.006 seconds (2 tasks refusing to freeze, wq_bu_busy=0):
> kernel: xfsaild/dm-1    S 0000000000014100     0   283      2 0x00000000
> kernel:  ffff880213f53e10 ffffffff8180e4c0 ffff880213f05040 0000000000000000
> kernel:  0000000000000000 ffff880213f54000 0000000000000000 0000000000000000
> kernel:  ffff8800ca389e40 ffff8800ca392000 ffff880213f53ed0 ffffffff814cd8ac
> kernel: Call Trace:
> kernel:  [<ffffffff814cd8ac>] ? schedule+0x2c/0x70
> kernel:  [<ffffffff8125e37d>] ? xfsaild+0x4fd/0x5b0
> kernel:  [<ffffffff8125de80>] ? xfs_trans_ail_cursor_first+0x80/0x80
> kernel:  [<ffffffff8125de80>] ? xfs_trans_ail_cursor_first+0x80/0x80
> kernel:  [<ffffffff8108bd18>] ? kthread+0xb8/0xd0
> kernel:  [<ffffffff8108bc60>] ? kthread_worker_fn+0x150/0x150
> kernel:  [<ffffffff814d115f>] ? ret_from_fork+0x3f/0x70 
> kernel:  [<ffffffff8108bc60>] ? kthread_worker_fn+0x150/0x150
> kernel: xfsaild/sda1    S 0000000000014100     0   591      2 0x00000000
> kernel:  ffff88021193be10 ffff8802159c4dc0 ffff880213ab9340 0000000000000000
> kernel:  0000000000000000 ffff88021193c000 0000000000000000 0000000000000000
> kernel:  ffff8800ca2a4240 ffff880214eea000 ffff88021193bed0 ffffffff814cd8ac
> kernel: Call Trace:
> kernel:  [<ffffffff814cd8ac>] ? schedule+0x2c/0x70
> kernel:  [<ffffffff8125e37d>] ? xfsaild+0x4fd/0x5b0
> kernel:  [<ffffffff8125de80>] ? xfs_trans_ail_cursor_first+0x80/0x80
> kernel:  [<ffffffff8125de80>] ? xfs_trans_ail_cursor_first+0x80/0x80
> kernel:  [<ffffffff8108bd18>] ? kthread+0xb8/0xd0
> kernel:  [<ffffffff8108bc60>] ? kthread_worker_fn+0x150/0x150
> kernel:  [<ffffffff814d115f>] ? ret_from_fork+0x3f/0x70 
> kernel:  [<ffffffff8108bc60>] ? kthread_worker_fn+0x150/0x150
> 
> Please tell me what more information you need to be able to fix this
> issue.

The freezer detection is broken. The thread is sleeping in schedule
until a wakeup occurs some time in the future, which means it cannot
"enter then freezer" because it's not a running thread. This is a
problem introduced by commit 24ba16b ("xfs: clear PF_NOFREEZE for
xfsaild kthread").

Jiri, I'm tempted just to revert this change - if the freezer
doesn't detect processes that are not in TASK_RUNNABLE state as
frozeni or can't mark them as frozen, then this change will never
work reliably for XFS....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
