Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A58177F37
	for <xfs@oss.sgi.com>; Fri, 14 Jun 2013 22:09:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 615D98F8033
	for <xfs@oss.sgi.com>; Fri, 14 Jun 2013 20:09:33 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	xczjphD453L4dWZ6 for <xfs@oss.sgi.com>;
	Fri, 14 Jun 2013 20:09:31 -0700 (PDT)
Date: Sat, 15 Jun 2013 13:09:28 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS (vdb): Corruption detected. Unmount and run xfs_repair
Message-ID: <20130615030928.GC29338@dastard>
References: <20130615023620.GA23586@localhost>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130615023620.GA23586@localhost>
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
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: linux-fsdevel@vger.kernel.org, Ben Myers <bpm@sgi.com>, Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

[cc xfs@oss.sgi.com, where XFS bug reports should go]

On Sat, Jun 15, 2013 at 10:36:20AM +0800, Fengguang Wu wrote:
> Greetings,
> 
> I got the below dmesg in both upstream and linux-next, and the first
> bad commit *might be* commit 211d022c43ca ("xfs: Avoid pathological
> backwards allocation").
>     
> [   74.595386] 
> [   74.603826] CPU: 0 PID: 2137 Comm: kworker/0:1H Not tainted 3.10.0-rc1-00031-gade1335 #1508
> [   74.609255] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
> [   74.612498] Workqueue: xfslogd xfs_buf_iodone_work
> [   74.615690]  0000000000000001 ffff880016815c68 ffffffff81aa456f ffff880016815c88
> [   74.621548]  ffffffff8130b179 ffffffff81309514 0000000000000001 ffff880016815cc8
> [   74.627417]  ffffffff8130b1d0 0000000000000000 00000000000002da 0000000000000016
> [   74.633321] Call Trace:
> [   74.635427]  [<ffffffff81aa456f>] dump_stack+0x19/0x1b
> [   74.638412]  [<ffffffff8130b179>] xfs_error_report+0x3d/0x3f
> [   74.641627]  [<ffffffff81309514>] ? xfs_buf_iodone_work+0x4a/0x83
> [   74.644970]  [<ffffffff8130b1d0>] xfs_corruption_error+0x55/0x71
> [   74.648217]  [<ffffffff81352ce1>] xfs_sb_read_verify+0xee/0x105
> [   74.651478]  [<ffffffff81309514>] ? xfs_buf_iodone_work+0x4a/0x83
> [   74.654820]  [<ffffffff8108045d>] ? ftrace_raw_event_workqueue_execute_start+0x92/0xa1
> [   74.659821]  [<ffffffff81309514>] xfs_buf_iodone_work+0x4a/0x83
> [   74.663042]  [<ffffffff81082561>] process_one_work+0x26c/0x470
> [   74.666296]  [<ffffffff810824bf>] ? process_one_work+0x1ca/0x470
> [   74.669647]  [<ffffffff81082ee6>] worker_thread+0x1d0/0x2cb
> [   74.672770]  [<ffffffff81082d16>] ? manage_workers.isra.19+0x1c3/0x1c3
> [   74.676201]  [<ffffffff8108a590>] kthread+0xd5/0xdd
> [   74.679151]  [<ffffffff810bd47c>] ? trace_hardirqs_on+0xd/0xf
> [   74.682411]  [<ffffffff8108a4bb>] ? __init_kthread_worker+0x5a/0x5a
> [   74.685776]  [<ffffffff81ab74dc>] ret_from_fork+0x7c/0xb0
> [   74.688798]  [<ffffffff8108a4bb>] ? __init_kthread_worker+0x5a/0x5a
> [   74.692206] XFS (vdb): Corruption detected. Unmount and run xfs_repair
> [   74.696000] XFS (vdb): SB validate failed with error 22.

EINVAL, which means there should have been some kind of output in
the log before the -corruption report- that explains why EINVAL was
returned.

> I'm not sure whether it's the first bad commit because

It's not, because it isn't in the upstream kernel and so if you are
seeing it in the upstream kernel, it can't be the cause. And,
besides:

> [   74.570969] XFS (vdb): bad magic number
> [   74.573837] ffff8800170ed000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [   74.579266] ffff8800170ed010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [   74.584581] ffff8800170ed020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [   74.590036] ffff8800170ed030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [   74.595386] XFS (vdb): Internal error xfs_sb_read_verify at line 730 of file /c/kernel-tests/src/stable/fs/xfs/xfs_mount.c.  Caller 0xffffffff81309514
.....
> [   74.692206] XFS (vdb): Corruption detected. Unmount and run xfs_repair
> [   74.696000] XFS (vdb): SB validate failed with error 22.

It's obviously not an XFS filesystem you are asking the kernel to
mount, so it's perfectly valid to throw a corruption error at you.
What it has actually thrown is EWRONGFS, but because you've asked
the kernel specifically to mount the device as an XFS filesystem,
the kernel is explicitly telling you that it's a corrupt
filesystem... :)

> common.rc: retrying test device mount with external set
> [   74.782247] XFS (vdb): bad magic number
> [   74.784895] ffff8800170e7000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [   74.790201] ffff8800170e7010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [   74.795466] ffff8800170e7020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [   74.800759] ffff8800170e7030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [   74.806031] XFS (vdb): Internal error xfs_sb_read_verify at line 730 of file /c/kernel-tests/src/stable/fs/xfs/xfs_mount.c.  Caller 0xffffffff81309514

It still isn't an XFS filesystem.... :/

This looks like user error, not a bug.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
