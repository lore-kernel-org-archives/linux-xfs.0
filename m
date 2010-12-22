Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBM61Kh3183606 for <xfs@oss.sgi.com>; Wed, 22 Dec 2010 00:01:21 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8610F147382D
	for <xfs@oss.sgi.com>; Tue, 21 Dec 2010 22:03:16 -0800 (PST)
Received: from mail.internode.on.net (bld-mail20.adl6.internode.on.net
	[150.101.137.105]) by cuda.sgi.com with ESMTP id
	QJGv7ZGrSUyUUaSL for <xfs@oss.sgi.com>;
	Tue, 21 Dec 2010 22:03:16 -0800 (PST)
Date: Wed, 22 Dec 2010 17:02:54 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS hangs
Message-ID: <20101222060254.GH4907@dastard>
References: <AANLkTikOcJA5a6u2YDXVGAEY0CqKiATTF02VeBsSKtU0@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AANLkTikOcJA5a6u2YDXVGAEY0CqKiATTF02VeBsSKtU0@mail.gmail.com>
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
To: Amit Sahrawat <amit.sahrawat83@gmail.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Wed, Dec 22, 2010 at 11:05:26AM +0530, Amit Sahrawat wrote:
> Hi,
> I am encountering hang of XFS filesystem, please find the logs as given
> below:
> INFO: task usb_mount:1858 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> usb_mount        D [84a42440] 8032d62c     0  1858
> 1816                             (user thread)
> Stack : 00000107 00000000 85e7be80 00030002 84a425c8 8032d62c 7fffffff
> 84a42440
>         00000002 8496e200 00000001 00000000 85e7bf00 85e7bef8 7fa2f2e0
> 8032d62c
>         00000001 801d69a8 85e7bd40 801d6b34 85e7bd4c 8032dc6c 00000000
> 801dbc80
>         85e7be80 864315a8 8662c980 00000001 00000742 00000000 00000000
> 84b85800
>         85e7bd90 801d6cc0 7fffffff 84a42440 00000002 8032ee74 00000081
> 804158a0
>         ...
> Call Trace:
> [<8032d574>] __schedule+0x618/0x6b8 from[<8032d62c>] schedule+0x18/0x3c
> [<8032d62c>] schedule+0x18/0x3c from[<8032dc6c>] schedule_timeout+0x2c/0x1c0
> [<8032dc6c>] schedule_timeout+0x2c/0x1c0 from[<8032ee74>] __down+0x8c/0xdc
> [<8032ee74>] __down+0x8c/0xdc from[<8004500c>] down+0x40/0x88
> [<8004500c>] down+0x40/0x88 from[<801ca838>] xfs_buf_lock+0xcc/0x15c
> [<801ca838>] xfs_buf_lock+0xcc/0x15c from[<801b71a0>] xfs_getsb+0x38/0x54
> [<801b71a0>] xfs_getsb+0x38/0x54 from[<801d64a8>] xfs_sync_fsdata+0x7c/0x154
> [<801d64a8>] xfs_sync_fsdata+0x7c/0x154 from[<801d7284>]
> xfs_quiesce_data+0x34/0x60
> [<801d7284>] xfs_quiesce_data+0x34/0x60 from[<801d3514>]
> xfs_fs_sync_fs+0x30/0xec
> [<801d3514>] xfs_fs_sync_fs+0x30/0xec from[<800ba09c>]
> __fsync_super+0xa4/0xc8
> [<800ba09c>] __fsync_super+0xa4/0xc8 from[<800ba0d4>] fsync_super+0x14/0x28
> [<800ba0d4>] fsync_super+0x14/0x28 from[<800ba4a0>]
> generic_shutdown_super+0x34/0x190
> [<800ba4a0>] generic_shutdown_super+0x34/0x190 from[<800ba654>]
> kill_block_super+0x58/0x80
> [<800ba654>] kill_block_super+0x58/0x80 from[<800bac6c>]
> deactivate_super+0x7c/0x110
> [<800bac6c>] deactivate_super+0x7c/0x110 from[<800d2bbc>]
> sys_umount+0x310/0x358
> [<800d2bbc>] sys_umount+0x310/0x358 from[<8000ff44>] stack_done+0x20/0x3c

Please make sure you paste stack traces cleanly in your emails so we
can read them easily.

> After reboot it works fine, but during this state XFS does not works no
> operation.

What kernel? What did you do to produce the error? What is the output
of "echo w > /proc/sysrq-trigger"? Do you have a repeatable test
case? What sort of storage are you using? Were there any IO errors
before the hang? etc, etc, etc....

--

For future reference, when you are reporting a problem you need to
be specific about what you were doing to cause the problem you are
reporting.  Describe your kernel, your storage, your test case, any
errors that occurred before the problem you are reporting, etc.

We need this information to make any sense of your bug report, but
I'm getting tired of having to ask for it every time you report a
problem. The more information you put in your bug report, the more
likely we are to be able to help you. We don't have unlimited
amounts of time (or patience) to drag all the basic details of your
problem out of you over 3 or 4 emails, so including it up front will
help a lot....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
