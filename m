Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8A8DC29DF7
	for <xfs@oss.sgi.com>; Thu, 27 Mar 2014 08:14:08 -0500 (CDT)
Message-ID: <5334241E.9060708@sgi.com>
Date: Thu, 27 Mar 2014 08:14:06 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: xfs errors while unlinking filenames with hash collisions
References: <20140327074156.GJ29498@order.stressinduktion.org>
In-Reply-To: <20140327074156.GJ29498@order.stressinduktion.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Hannes Frederic Sowa <hannes@stressinduktion.org>
Cc: xfs@oss.sgi.com

On 03/27/14 02:41, Hannes Frederic Sowa wrote:
> Hello!
>
> I wanted to break some network stack hashing, but while running the test
> against my local xfs filesystem I got corruptions in rmdir:
>
> [ 3856.245843] XFS (vda1): Internal error xfs_trans_cancel at line 966 of file fs/xfs/xfs_trans.c.  Caller 0xffffffffa01186bc
> [ 3856.249049] CPU: 1 PID: 866 Comm: rm Not tainted 3.13.6-200.fc20.x86_64 #1
> [ 3856.250966] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [ 3856.252615]  000000000000000c ffff8800d23a7d68 ffffffff8168730c ffff8800cf5462b8
> [ 3856.254823]  ffff8800d23a7d80 ffffffffa00d00cb ffffffffa01186bc ffff8800d23a7da8
> [ 3856.257241]  ffffffffa00e5459 ffff8800d9ac3400 ffff8800d23a7e30 ffff8800371b6800
> [ 3856.259420] Call Trace:
> [ 3856.260172]  [<ffffffff8168730c>] dump_stack+0x45/0x56
> [ 3856.261717]  [<ffffffffa00d00cb>] xfs_error_report+0x3b/0x40 [xfs]
> [ 3856.263472]  [<ffffffffa01186bc>] ? xfs_remove+0x1ac/0x370 [xfs]
> [ 3856.270838]  [<ffffffffa00e5459>] xfs_trans_cancel+0xd9/0x100 [xfs]
> [ 3856.272783]  [<ffffffffa01186bc>] xfs_remove+0x1ac/0x370 [xfs]
> [ 3856.274531]  [<ffffffffa00db40b>] xfs_vn_unlink+0x4b/0x90 [xfs]
> [ 3856.276286]  [<ffffffff811c61b8>] vfs_rmdir+0xa8/0x100
> [ 3856.277821]  [<ffffffff811c638d>] do_rmdir+0x17d/0x1d0
> [ 3856.281021]  [<ffffffff811ba7fe>] ? ____fput+0xe/0x10
> [ 3856.285261]  [<ffffffff8108c11c>] ? task_work_run+0xac/0xe0
> [ 3856.286952]  [<ffffffff81013a31>] ? do_notify_resume+0x61/0xa0
> [ 3856.288693]  [<ffffffff811c9a65>] SyS_unlinkat+0x25/0x40
> [ 3856.290407]  [<ffffffff816962e9>] system_call_fastpath+0x16/0x1b
> [ 3856.292685] XFS (vda1): xfs_do_force_shutdown(0x8) called from line 967 of file fs/xfs/xfs_trans.c.  Return address = 0xffffffffa00e5472
> [ 3856.627330] XFS (vda1): Corruption of in-memory data detected.  Shutting down filesystem
> [ 3856.627332] XFS (vda1): Please umount the filesystem and rectify the problem(s)
>
> I also tested this on a current linux net-next kernel, which is 3.14.0-rc6.
>
> If I run the test code below in an directory for a while and after that
> try to unlink the files in it (rm -rf testdir), I get above splat. Even
> after running xfs_repair I cannot remove the directory. The system is
> pretty unusable after that if this is done on a root filesystem.
>
> I quickly extracted this simple test case below. It does not generate
> perfect collisions, but they are enough to trigger the above described
> problem.
>
> Thanks,
>
>    Hannes
>

Have you tried to run a xfs_repair on the filesystem after the reboot?

Do you fill the filesystem with the test or just part way?

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
