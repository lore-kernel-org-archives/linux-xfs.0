Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q556T6To050402
	for <linux-xfs@oss.sgi.com>; Tue, 5 Jun 2012 01:29:06 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	C1r7Jr7UccZHa6Fi for <linux-xfs@oss.sgi.com>;
	Mon, 04 Jun 2012 23:29:01 -0700 (PDT)
Date: Tue, 5 Jun 2012 16:28:58 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: task hung over xfs
Message-ID: <20120605062858.GH4347@dastard>
References: <CAPB=Z-rL2X3+2eNJwfN=ppk=6W8M08zEL8FR0w5Ew2pELpnFRg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPB=Z-rL2X3+2eNJwfN=ppk=6W8M08zEL8FR0w5Ew2pELpnFRg@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Raz <raziebe@gmail.com>
Cc: linux-xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

On Wed, May 30, 2012 at 09:44:45PM +0300, Raz wrote:
> Hello
> We using 2.6.32 gentoo 64bit.=A0 and we're getting task_hung timeout stac=
k.
> =

> Our server uses direct IO. =A0It reads files contents to buffers in
> memory =A0and sends them by TCP. =A0In addition, data is received
> by TCP and stored in files on disk.
> Most of the IO is reading data and sending it by TCP sockets.
> =

> There are 4 threads reading data from disk into memory buffers. One
> thread per partition.
> There are about 20 threads reading data from the network and saving it
> to disk.
> =

> In addition, there is an operation that is done on every file once it is
> downloaded. =A0This operation maps data from file to memory. =A0It is done
> in Java. I assume it is mmap. =A0The mapping is very short.
> =

> The bellow is the stack. Is this xfs bug=A0 ? root file system is xfs as
> well the data partition.
> Was a fix made in this area=A0 ? when was it ?
> thank you
> raz
> =

> =


 INFO: task java:10449 blocked for more than 120 seconds.
 "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
 java=A0=A0=A0=A0=A0=A0=A0=A0=A0 D 0007ffffffffe708 =A0=A0=A0 0 10449=A0 10=
408 0x00000000
=A0 ffff88042acd1c28 0000000000000086 0000000000cd1b88 0000000000000000
=A0 0000000000000000 ffff88042acd1d7c 000000002c95c410 0000000000000000
=A0 0000000000015840 000000000000f9c8 ffff88042c95c410 ffff88042e4d96b0
 Call Trace:
=A0 [<ffffffffa060bd4a>] ?  kmem_zone_alloc+0xaa/0x110 [xfs]
=A0 [<ffffffff815f33f5>] __down_write_nested+0xa5/0x100
=A0 [<ffffffff815f346e>] __down_write+0x1e/0x40
=A0 [<ffffffff815f24ac>] down_write+0x1c/0x40
=A0 [<ffffffffa05e7e2c>] xfs_ilock+0x9c/0xb0 [xfs]
=A0 [<ffffffffa06093d6>] xfs_free_eofblocks+0x256/0x290 [xfs]
=A0 [<ffffffffa0609f1d>] xfs_release+0x14d/0x210 [xfs]
=A0 [<ffffffffa0612303>] xfs_file_release+0x23/0x40 [xfs]
=A0 [<ffffffff8114f1f9>] __fput+0xe9/0x210
=A0 [<ffffffff8114f34b>] fput+0x2b/0x50
=A0 [<ffffffff81124349>] remove_vma+0x49/0xb0
=A0 [<ffffffff81125a7a>] do_munmap+0x36a/0x3d0
=A0 [<ffffffff815f346e>] ?  __down_write+0x1e/0x40
=A0 [<ffffffff81125b3c>] sys_munmap+0x5c/0xa0
=A0 [<ffffffff81013302>] system_call_fastpath+0x16/0x1b

Holding the mmap_sem, blocked on the iolock in exclusive mode waiting for I=
O to complete.

 java=A0=A0=A0=A0=A0=A0=A0=A0=A0 D ffff8803bc495b48 =A0=A0=A0 0 11768=A0 10=
408 0x00000000
=A0 ffff8803bc495a58 0000000000000086 ffff8803bc4959a8 ffffffff815f38bc
=A0 ffff8803bc4959e8 000000005c14da46 ffff8803bc4959d8 ffffffff811300a2
=A0 0000000000015840 000000000000f9c8 ffff8803bc468000 ffff88042e4c2d60
 Call Trace:
=A0 [<ffffffff815f38bc>] ?  _spin_lock+0x1c/0x40
=A0 [<ffffffff811300a2>] ?  swap_info_get+0x82/0x120
=A0 [<ffffffff811488c1>] ?  mem_cgroup_commit_charge_swapin+0x21/0x40
=A0 [<ffffffff815f353d>] __down_read+0xad/0xfa
=A0 [<ffffffff815f24ec>] down_read+0x1c/0x40
=A0 [<ffffffff815f6e59>] do_page_fault+0x379/0x3a0
=A0 [<ffffffff815f4145>] page_fault+0x25/0x30
=A0 [<ffffffff810fe39c>] ?  file_read_actor+0x6c/0x180
=A0 [<ffffffff810fe437>] ?  file_read_actor+0x107/0x180
=A0 [<ffffffff81100d02>] generic_file_aio_read+0x492/0x6b0
=A0 [<ffffffffa06178f8>] xfs_read+0x138/0x2c0 [xfs]
=A0 [<ffffffffa06124ce>] xfs_file_aio_read+0x6e/0x90 [xfs]
=A0 [<ffffffff8114d341>] do_sync_read+0x101/0x160
=A0 [<ffffffff8108c4a0>] ?  autoremove_wake_function+0x0/0x60
=A0 [<ffffffff81276b94>] ?  security_file_permission+0x24/0x40
=A0 [<ffffffff8114dc64>] vfs_read+0xe4/0x1c0
=A0 [<ffffffff8114de5f>] sys_read+0x5f/0xc0
=A0 [<ffffffff81013302>] system_call_fastpath+0x16/0x1b

Holding the iolock in shared mode, taken a page fault during the
read() call and blocked on the mmap_sem.

IOWs, you're doing read() IO into a mmap()d buffer, and there's a
concurrent munmap() of another region of the same file that is open
under a different file descriptor. ABBA deadlock, and it's been
there for about 10 years. The problem is the munmap() call calling
fput() with the mmap_sem() held.

Here's the latest discussion thread about solving it:

https://lkml.org/lkml/2012/4/19/635

Right now your only option for avoiding the deadlock is "don't do
that". Soon it might be "upgrade to 3.x", but don't hold your
breath...

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
