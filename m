Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4UIj8Ls031133
	for <linux-xfs@oss.sgi.com>; Wed, 30 May 2012 13:45:08 -0500
Received: from mail-ee0-f53.google.com (mail-ee0-f53.google.com
	[74.125.83.53]) by cuda.sgi.com with ESMTP id 6FEnazMy4ECXplZn
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<linux-xfs@oss.sgi.com>; Wed, 30 May 2012 11:45:06 -0700 (PDT)
Received: by eekc41 with SMTP id c41so60808eek.26
	for <linux-xfs@oss.sgi.com>; Wed, 30 May 2012 11:45:05 -0700 (PDT)
MIME-Version: 1.0
From: Raz <raziebe@gmail.com>
Date: Wed, 30 May 2012 21:44:45 +0300
Message-ID: <CAPB=Z-rL2X3+2eNJwfN=ppk=6W8M08zEL8FR0w5Ew2pELpnFRg@mail.gmail.com>
Subject: task hung over xfs
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
To: linux-xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

Hello
We using 2.6.32 gentoo 64bit.=A0 and we're getting task_hung timeout stack.

Our server uses direct IO. =A0It reads files contents to buffers in
memory =A0and sends them by TCP. =A0In addition, data is received
by TCP and stored in files on disk.
Most of the IO is reading data and sending it by TCP sockets.

There are 4 threads reading data from disk into memory buffers. One
thread per partition.
There are about 20 threads reading data from the network and saving it
to disk.

In addition, there is an operation that is done on every file once it is
downloaded. =A0This operation maps data from file to memory. =A0It is done
in Java. I assume it is mmap. =A0The mapping is very short.

The bellow is the stack. Is this xfs bug=A0 ? root file system is xfs as
well the data partition.
Was a fix made in this area=A0 ? when was it ?
thank you
raz


Apr 20 04:11:50 hcs05 [499496.793804] INFO: task java:10439 blocked
for more than 120 seconds.
Apr 20 04:11:50 hcs05 [499496.793809] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Apr 20 04:11:50 hcs05 [499496.793814] java=A0=A0=A0=A0=A0=A0=A0=A0=A0 D 000=
0000000000001
=A0=A0=A0 0 10439=A0 10408 0x00000000
Apr 20 04:11:50 hcs05 [499496.793821]=A0 ffff88042acd5e78
0000000000000086 0000000000000000 0000000000000081
Apr 20 04:11:50 hcs05 [499496.793828]=A0 0000000000000001
0000000041365a28 ffff88042acd5ee8 ffffffff810a1b76
Apr 20 04:11:50 hcs05 [499496.793835]=A0 0000000000015840
000000000000f9c8 ffff88042c9596b0 ffff88042e4c2d60
Apr 20 04:11:50 hcs05 [499496.793841] Call Trace:
Apr 20 04:11:50 hcs05 [499496.793852]=A0 [<ffffffff810a1b76>] ?
do_futex+0x106/0xb90
Apr 20 04:11:50 hcs05 [499496.793861]=A0 [<ffffffff8101aee6>] ? read_tsc+0x=
16/0x40
Apr 20 04:11:50 hcs05 [499496.793866]=A0 [<ffffffff815f33f5>]
__down_write_nested+0xa5/0x100
Apr 20 04:11:50 hcs05 [499496.793869]=A0 [<ffffffff815f346e>]
__down_write+0x1e/0x40
Apr 20 04:11:50 hcs05 [499496.793872]=A0 [<ffffffff815f24ac>] down_write+0x=
1c/0x40
Apr 20 04:11:50 hcs05 [499496.793876]=A0 [<ffffffff81127e39>]
sys_mprotect+0x109/0x2c0
Apr 20 04:11:50 hcs05 [499496.793880]=A0 [<ffffffff81013302>]
system_call_fastpath+0x16/0x1b
Apr 20 04:11:50 hcs05 [499496.793883] INFO: task java:10449 blocked
for more than 120 seconds.
Apr 20 04:11:50 hcs05 [499496.793885] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Apr 20 04:11:50 hcs05 [499496.793886] java=A0=A0=A0=A0=A0=A0=A0=A0=A0 D 000=
7ffffffffe708
=A0=A0=A0 0 10449=A0 10408 0x00000000
Apr 20 04:11:50 hcs05 [499496.793890]=A0 ffff88042acd1c28
0000000000000086 0000000000cd1b88 0000000000000000
Apr 20 04:11:50 hcs05 [499496.793893]=A0 0000000000000000
ffff88042acd1d7c 000000002c95c410 0000000000000000
Apr 20 04:11:50 hcs05 [499496.793896]=A0 0000000000015840
000000000000f9c8 ffff88042c95c410 ffff88042e4d96b0
Apr 20 04:11:50 hcs05 [499496.793899] Call Trace:
Apr 20 04:11:50 hcs05 [499496.793922]=A0 [<ffffffffa060bd4a>] ?
kmem_zone_alloc+0xaa/0x110 [xfs]
Apr 20 04:11:50 hcs05 [499496.793926]=A0 [<ffffffff815f33f5>]
__down_write_nested+0xa5/0x100
Apr 20 04:11:50 hcs05 [499496.793928]=A0 [<ffffffff815f346e>]
__down_write+0x1e/0x40
Apr 20 04:11:50 hcs05 [499496.793931]=A0 [<ffffffff815f24ac>] down_write+0x=
1c/0x40
Apr 20 04:11:50 hcs05 [499496.793947]=A0 [<ffffffffa05e7e2c>]
xfs_ilock+0x9c/0xb0 [xfs]
Apr 20 04:11:50 hcs05 [499496.793962]=A0 [<ffffffffa06093d6>]
xfs_free_eofblocks+0x256/0x290 [xfs]
Apr 20 04:11:50 hcs05 [499496.793978]=A0 [<ffffffffa0609f1d>]
xfs_release+0x14d/0x210 [xfs]
Apr 20 04:11:50 hcs05 [499496.793993]=A0 [<ffffffffa0612303>]
xfs_file_release+0x23/0x40 [xfs]
Apr 20 04:11:50 hcs05 [499496.793996]=A0 [<ffffffff8114f1f9>] __fput+0xe9/0=
x210
Apr 20 04:11:50 hcs05 [499496.793999]=A0 [<ffffffff8114f34b>] fput+0x2b/0x50
Apr 20 04:11:50 hcs05 [499496.794002]=A0 [<ffffffff81124349>] remove_vma+0x=
49/0xb0
Apr 20 04:11:50 hcs05 [499496.794004]=A0 [<ffffffff81125a7a>]
do_munmap+0x36a/0x3d0
Apr 20 04:11:50 hcs05 [499496.794007]=A0 [<ffffffff815f346e>] ?
__down_write+0x1e/0x40
Apr 20 04:11:50 hcs05 [499496.794010]=A0 [<ffffffff81125b3c>] sys_munmap+0x=
5c/0xa0
Apr 20 04:11:50 hcs05 [499496.794013]=A0 [<ffffffff81013302>]
system_call_fastpath+0x16/0x1b
Apr 20 04:11:50 hcs05 [499496.794016] INFO: task java:10467 blocked
for more than 120 seconds.
Apr 20 04:11:50 hcs05 [499496.794017] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Apr 20 04:11:50 hcs05 [499496.794019] java=A0=A0=A0=A0=A0=A0=A0=A0=A0 D fff=
f88042cd5df58
=A0=A0=A0 0 10467=A0 10408 0x00000000
Apr 20 04:11:50 hcs05 [499496.794022]=A0 ffff88042cd5de68
0000000000000086 ffff8804249016e0 000000004139b728
Apr 20 04:11:50 hcs05 [499496.794026]=A0 0000000000000000
0000000000000081 0000000000000001 000000004139b728
Apr 20 04:11:50 hcs05 [499496.794029]=A0 0000000000015840
000000000000f9c8 ffff88042c9fdac0 ffff88042e4d96b0
Apr 20 04:11:50 hcs05 [499496.794032] Call Trace:
Apr 20 04:11:50 hcs05 [499496.794035]=A0 [<ffffffff815f353d>]
__down_read+0xad/0xfa
Apr 20 04:11:50 hcs05 [499496.794037]=A0 [<ffffffff815f24ec>] down_read+0x1=
c/0x40
Apr 20 04:11:50 hcs05 [499496.794040]=A0 [<ffffffff815f6e59>]
do_page_fault+0x379/0x3a0
Apr 20 04:11:50 hcs05 [499496.794043]=A0 [<ffffffff815f4145>] page_fault+0x=
25/0x30
Apr 20 04:11:50 hcs05 [499496.794054] INFO: task java:10949 blocked
for more than 120 seconds.
Apr 20 04:11:50 hcs05 [499496.794056] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Apr 20 04:11:50 hcs05 [499496.794058] java=A0=A0=A0=A0=A0=A0=A0=A0=A0 D fff=
f880429dd3f58
=A0=A0=A0 0 10949=A0 10408 0x00000000
Apr 20 04:11:50 hcs05 [499496.794061]=A0 ffff880429dd3e68
0000000000000086 0000000087237725 0000000000000000
Apr 20 04:11:50 hcs05 [499496.794064]=A0 ffff880429dd3df8
ffffffff811498ab 0000000100022000 0000000087237725
Apr 20 04:11:50 hcs05 [499496.794067]=A0 0000000000015840
000000000000f9c8 ffff880429dd8000 ffffffff81852600
Apr 20 04:11:50 hcs05 [499496.794070] Call Trace:
Apr 20 04:11:50 hcs05 [499496.794075]=A0 [<ffffffff811498ab>] ?
mem_cgroup_charge_common+0x7b/0xb0
Apr 20 04:11:50 hcs05 [499496.794078]=A0 [<ffffffff815f353d>]
__down_read+0xad/0xfa
Apr 20 04:11:50 hcs05 [499496.794081]=A0 [<ffffffff815f24ec>] down_read+0x1=
c/0x40
Apr 20 04:11:50 hcs05 [499496.794083]=A0 [<ffffffff815f6e59>]
do_page_fault+0x379/0x3a0
Apr 20 04:11:50 hcs05 [499496.794086]=A0 [<ffffffff815f4145>] page_fault+0x=
25/0x30
Apr 20 04:11:50 hcs05 [499496.794089] INFO: task java:10952 blocked
for more than 120 seconds.
Apr 20 04:11:50 hcs05 [499496.794090] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Apr 20 04:11:50 hcs05 [499496.794092] java=A0=A0=A0=A0=A0=A0=A0=A0=A0 D fff=
f880429de5f58
=A0=A0=A0 0 10952=A0 10408 0x00000000
Apr 20 04:11:50 hcs05 [499496.794095]=A0 ffff880429de5e68
0000000000000086 0000000000000000 00007fe2644c33f4
Apr 20 04:11:50 hcs05 [499496.794098]=A0 0000000000006f84
000000000000541b ffff880429de5df8 ffffffff8151e0d8
Apr 20 04:11:50 hcs05 [499496.794101]=A0 0000000000015840
000000000000f9c8 ffff880429ddc410 ffffffff81852600
Apr 20 04:11:50 hcs05 [499496.794104] Call Trace:
Apr 20 04:11:50 hcs05 [499496.794108]=A0 [<ffffffff8151e0d8>] ?
tcp_ioctl+0xb8/0x1d0
Apr 20 04:11:50 hcs05 [499496.794113]=A0 [<ffffffff8157120e>] ?
inet6_ioctl+0x3e/0x100
Apr 20 04:11:50 hcs05 [499496.794117]=A0 [<ffffffff814c7c66>] ?
sock_ioctl+0x86/0x2b0
Apr 20 04:11:50 hcs05 [499496.794120]=A0 [<ffffffff815f353d>]
__down_read+0xad/0xfa
Apr 20 04:11:50 hcs05 [499496.794123]=A0 [<ffffffff815f24ec>] down_read+0x1=
c/0x40
Apr 20 04:11:50 hcs05 [499496.794125]=A0 [<ffffffff815f6e59>]
do_page_fault+0x379/0x3a0
Apr 20 04:11:50 hcs05 [499496.794128]=A0 [<ffffffff815f4145>] page_fault+0x=
25/0x30
Apr 20 04:11:50 hcs05 [499496.794139] INFO: task java:11768 blocked
for more than 120 seconds.
Apr 20 04:11:50 hcs05 [499496.794141] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Apr 20 04:11:50 hcs05 [499496.794143] java=A0=A0=A0=A0=A0=A0=A0=A0=A0 D fff=
f8803bc495b48
=A0=A0=A0 0 11768=A0 10408 0x00000000
Apr 20 04:11:50 hcs05 [499496.794146]=A0 ffff8803bc495a58
0000000000000086 ffff8803bc4959a8 ffffffff815f38bc
Apr 20 04:11:50 hcs05 [499496.794149]=A0 ffff8803bc4959e8
000000005c14da46 ffff8803bc4959d8 ffffffff811300a2
Apr 20 04:11:50 hcs05 [499496.794152]=A0 0000000000015840
000000000000f9c8 ffff8803bc468000 ffff88042e4c2d60
Apr 20 04:11:50 hcs05 [499496.794155] Call Trace:
Apr 20 04:11:50 hcs05 [499496.794157]=A0 [<ffffffff815f38bc>] ?
_spin_lock+0x1c/0x40
Apr 20 04:11:50 hcs05 [499496.794161]=A0 [<ffffffff811300a2>] ?
swap_info_get+0x82/0x120
Apr 20 04:11:50 hcs05 [499496.794164]=A0 [<ffffffff811488c1>] ?
mem_cgroup_commit_charge_swapin+0x21/0x40
Apr 20 04:11:50 hcs05 [499496.794167]=A0 [<ffffffff815f353d>]
__down_read+0xad/0xfa
Apr 20 04:11:50 hcs05 [499496.794170]=A0 [<ffffffff815f24ec>] down_read+0x1=
c/0x40
Apr 20 04:11:50 hcs05 [499496.794172]=A0 [<ffffffff815f6e59>]
do_page_fault+0x379/0x3a0
Apr 20 04:11:50 hcs05 [499496.794175]=A0 [<ffffffff815f4145>] page_fault+0x=
25/0x30
Apr 20 04:11:50 hcs05 [499496.794180]=A0 [<ffffffff810fe39c>] ?
file_read_actor+0x6c/0x180
Apr 20 04:11:50 hcs05 [499496.794183]=A0 [<ffffffff810fe437>] ?
file_read_actor+0x107/0x180
Apr 20 04:11:50 hcs05 [499496.794187]=A0 [<ffffffff81100d02>]
generic_file_aio_read+0x492/0x6b0
Apr 20 04:11:50 hcs05 [499496.794202]=A0 [<ffffffffa06178f8>]
xfs_read+0x138/0x2c0 [xfs]
Apr 20 04:11:50 hcs05 [499496.794218]=A0 [<ffffffffa06124ce>]
xfs_file_aio_read+0x6e/0x90 [xfs]
Apr 20 04:11:50 hcs05 [499496.794221]=A0 [<ffffffff8114d341>]
do_sync_read+0x101/0x160
Apr 20 04:11:50 hcs05 [499496.794226]=A0 [<ffffffff8108c4a0>] ?
autoremove_wake_function+0x0/0x60
Apr 20 04:11:50 hcs05 [499496.794232]=A0 [<ffffffff81276b94>] ?
security_file_permission+0x24/0x40
Apr 20 04:11:50 hcs05 [499496.794234]=A0 [<ffffffff8114dc64>] vfs_read+0xe4=
/0x1c0
Apr 20 04:11:50 hcs05 [499496.794237]=A0 [<ffffffff8114de5f>] sys_read+0x5f=
/0xc0
Apr 20 04:11:50 hcs05 [499496.794240]=A0 [<ffffffff81013302>]
system_call_fastpath+0x16/0x1b
Apr 20 04:11:50 hcs05 [499496.794247] INFO: task ps:7313 blocked for
more than 120 seconds.
Apr 20 04:11:50 hcs05 [499496.794249] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Apr 20 04:11:50 hcs05 [499496.794251] ps=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 D=
 0000000000000000
=A0=A0=A0 0=A0 7313=A0=A0 7312 0x00000000
Apr 20 04:11:50 hcs05 [499496.794254]=A0 ffff88029df4fd18
0000000000000082 ffff88029df4fc78 0000003800000038
Apr 20 04:11:50 hcs05 [499496.794257]=A0 0000880200000001
0000000000000001 0000000000011b00 0000000000000001
Apr 20 04:11:50 hcs05 [499496.794260]=A0 0000000000015840
000000000000f9c8 ffff8801890d4410 ffff88042e4d96b0
Apr 20 04:11:50 hcs05 [499496.794264] Call Trace:
Apr 20 04:11:50 hcs05 [499496.794268]=A0 [<ffffffff8116c1de>] ?
mntput_no_expire+0x3e/0x140
Apr 20 04:11:50 hcs05 [499496.794271]=A0 [<ffffffff815f353d>]
__down_read+0xad/0xfa
Apr 20 04:11:50 hcs05 [499496.794274]=A0 [<ffffffff815f24ec>] down_read+0x1=
c/0x40
Apr 20 04:11:50 hcs05 [499496.794277]=A0 [<ffffffff8112219b>]
access_process_vm+0x5b/0x200
Apr 20 04:11:50 hcs05 [499496.794281]=A0 [<ffffffff81068cfd>] ?
get_task_mm+0x4d/0xb0
Apr 20 04:11:50 hcs05 [499496.794285]=A0 [<ffffffff811b07ba>]
proc_pid_cmdline+0xba/0x150
Apr 20 04:11:50 hcs05 [499496.794288]=A0 [<ffffffff811b12d2>]
proc_info_read+0xc2/0x110
Apr 20 04:11:50 hcs05 [499496.794291]=A0 [<ffffffff8114d407>] ?
rw_verify_area+0x67/0xf0
Apr 20 04:11:50 hcs05 [499496.794293]=A0 [<ffffffff8114dc64>] vfs_read+0xe4=
/0x1c0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
