Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAMNRuRF125628 for <xfs@oss.sgi.com>; Mon, 22 Nov 2010 17:27:57 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DA45F13E1BB5
	for <xfs@oss.sgi.com>; Mon, 22 Nov 2010 15:29:32 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	55M34ZU3dFMwGsbZ for <xfs@oss.sgi.com>;
	Mon, 22 Nov 2010 15:29:32 -0800 (PST)
Date: Tue, 23 Nov 2010 10:29:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Xfs delaylog hanged up
Message-ID: <20101122232929.GJ13830@dastard>
References: <4CEAC412.9000406@shiftmail.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4CEAC412.9000406@shiftmail.org>
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
To: Spelic <spelic@shiftmail.org>
Cc: xfs@oss.sgi.com

On Mon, Nov 22, 2010 at 08:27:14PM +0100, Spelic wrote:
> Hi there
> EXCELLENT speed improvement with delaylog! My congratulations.
> Now there's a problem: it hanged on me (not sure it was because of
> delaylog, but anyway...)
> I am on 2.6.37rc2
> 
> 16 disk MD raid-5

What is the storage hardware and the MD raid5 configuration?

> mkfs line
>        mkfs.xfs -l size=128m -d agcount=16 <device>
> (then lvm2, all aligned to stripes)
> mount line:
>        /dev/mapper/perftestvg-xfslv /perftest/xfs xfs rw,relatime,attr2,delaylog,nobarrier,inode64,logbufs=8,logbsize=256k,noquota
> 0 0

FYI, relatime, attr2, logbufs=8 and noquota are default values that
you don't need to specify.

> deadline scheduler, nr_requests 1024
> 
> I was doing a parallel-kernel-unpack benchmark:
> 
>     /perftest/xfs# mkdir dir{1,2,3,4,5,6,7,8,9,10}
>     /perftest/xfs# for i in {1..10} ; do time tar -jxf
> linux-2.6.37-rc2.tar.bz2 -C dir$i & done ; echo waiting now ; time
> wait; echo syncing now ; time sync

Thanks for the test case - I'll try to reproduce this. One more key
piece of information I need: the output of mkfs.xfs so I can see your
filesystem geometry. if you have the filesystem mounted, then the
output of 'xfs_info <mntpt>' will give the same information.

>     Iostat showed everything totally still.
>     Computer was responsive for the rest (OS is on other filesystems)
>     Look at the stack traces in the 5 minutes they were hanged:
....
> # cat /proc/3403/stack
>     [<ffffffffa02c607b>] xlog_grant_log_space+0x19b/0x5e0 [xfs]
>     [<ffffffffa02c65be>] xfs_log_reserve+0xfe/0x160 [xfs]
>     [<ffffffffa02d25cb>] xfs_trans_reserve+0x9b/0x210 [xfs]
>     [<ffffffffa02d80fa>] xfs_setattr+0x81a/0xa10 [xfs]
>     [<ffffffffa02e3df6>] xfs_vn_setattr+0x16/0x20 [xfs]
>     [<ffffffff8114de68>] notify_change+0x168/0x2d0
>     [<ffffffff811346e7>] sys_fchmodat+0xd7/0x110
>     [<ffffffff81134733>] sys_chmod+0x13/0x20
>     [<ffffffff8100af42>] system_call_fastpath+0x16/0x1b
>     [<ffffffffffffffff>] 0xffffffffffffffff

Ok, so it is stuck with a full log....

> dmesg:
> [ 8042.770130] xfsaild/dm-6  D 00000001000b92b8     0  2979      2
> 0x00000000
> [ 8042.770135]  ffff88082c11ba90 0000000000000046 ffff88083140de08
> 0000000000000000
> [ 8042.770140]  00000000000138c0 ffff88083dfa5a80 ffff88083dfa5e18
> ffff88082c11bfd8
> [ 8042.770144]  ffff88083dfa5e20 00000000000138c0 ffff88082c11a010
> 00000000000138c0
> [ 8042.770148] Call Trace:
> [ 8042.770187]  [<ffffffffa02c4a8f>]
> xlog_state_get_iclog_space+0xdf/0x2c0 [xfs]
> [ 8042.770205]  [<ffffffffa02c422a>] ? xlog_sync+0x1fa/0x3d0 [xfs]
> [ 8042.770213]  [<ffffffff810538d0>] ? default_wake_function+0x0/0x10
> [ 8042.770231]  [<ffffffffa02c5708>] xlog_write+0x198/0x6c0 [xfs]
> [ 8042.770249]  [<ffffffffa02c6fd2>] xlog_cil_push+0x252/0x3b0 [xfs]
> [ 8042.770267]  [<ffffffffa02c7636>] xlog_cil_force_lsn+0x116/0x120 [xfs]
> [ 8042.770286]  [<ffffffffa02dd3dc>] ? xfs_buf_delwri_queue+0xcc/0x150 [xfs]
> [ 8042.770291]  [<ffffffff81033209>] ? default_spin_lock_flags+0x9/0x10
> [ 8042.770296]  [<ffffffff810808d2>] ? down_trylock+0x32/0x50
> [ 8042.770314]  [<ffffffffa02c4543>] _xfs_log_force+0x63/0x230 [xfs]
> [ 8042.770332]  [<ffffffffa02c4933>] xfs_log_force+0x13/0x40 [xfs]
> [ 8042.770351]  [<ffffffffa02d38e4>] xfsaild_push+0x3b4/0x400 [xfs]
> [ 8042.770357]  [<ffffffff81571c26>] ? schedule_timeout+0x196/0x2f0
> [ 8042.770377]  [<ffffffffa02e67a4>] xfsaild+0x74/0xb0 [xfs]
> [ 8042.770395]  [<ffffffffa02e6730>] ? xfsaild+0x0/0xb0 [xfs]
> [ 8042.770400]  [<ffffffff8107b076>] kthread+0x96/0xa0
> [ 8042.770404]  [<ffffffff8100bd64>] kernel_thread_helper+0x4/0x10
> [ 8042.770408]  [<ffffffff8107afe0>] ? kthread+0x0/0xa0
> [ 8042.770411]  [<ffffffff8100bd60>] ? kernel_thread_helper+0x0/0x10

That's the key thread that frees up space in the log by writing out
metadata buffers. But it itself looks to be stuck trying to force
the log out. It's waiting for IO completion on a log buffer to
complete.

> What do you think?

I'll need to reproduce this to determine the cause.

> Is it the delaylog?

No idea yet.

> is it not stable?

It is stable enough that all my local machines are running with
delaylog. And as a dev team, we have enough confidence in it to
remove the EXPERIMENTAL status for the 2.6.37 release. That doesn't
mean it is perfectly bug free - it just means more people will start
to use it.  And as this happens, we will find new problems in
different environments (just like you have), but this is a pretty
normal occurrence for new code.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
