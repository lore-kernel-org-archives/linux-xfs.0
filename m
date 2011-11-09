Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA95ScuF193512
	for <linux-xfs@oss.sgi.com>; Tue, 8 Nov 2011 23:28:38 -0600
Received: from mail-fx0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5CE851CF75EE
	for <linux-xfs@oss.sgi.com>; Tue,  8 Nov 2011 21:28:36 -0800 (PST)
Received: from mail-fx0-f53.google.com (mail-fx0-f53.google.com
	[209.85.161.53]) by cuda.sgi.com with ESMTP id esxvAYC5quj1XWZz
	for <linux-xfs@oss.sgi.com>; Tue, 08 Nov 2011 21:28:36 -0800 (PST)
Received: by faan15 with SMTP id n15so1483157faa.26
	for <linux-xfs@oss.sgi.com>; Tue, 08 Nov 2011 21:28:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <loom.20111108T180925-222@post.gmane.org>
References: <loom.20111108T180925-222@post.gmane.org>
Date: Wed, 9 Nov 2011 10:50:43 +0530
Message-ID: <CADDb1s20M0w+yFGa8G=KbAZ6wL4Hj7WUxR0w+hzRH9BCgFWpLQ@mail.gmail.com>
Subject: Re: XFS realtime O_DIRECT failures
From: Amit Sahrawat <amit.sahrawat83@gmail.com>
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
To: Alan Cook <acook@visionpointsystems.com>
Cc: linux-xfs@oss.sgi.com

Hi Alan,

On Tue, Nov 8, 2011 at 11:07 PM, Alan Cook <acook@visionpointsystems.com> w=
rote:
> I am having issues using the O_DIRECT flags for writing to files that res=
ide on
> the realtime subvolume of an XFS file system. =A0I have found a failure c=
ase for
> xfstests test 090 as well as another case that I will describe below.
>
> For test 090, I have the following setup:
>
> mkfs.xfs -f -llogdev=3D/dev/ram1 -rrtdev=3D/dev/ram2 -bsize=3D4096 /dev/r=
am0
> mount -t xfs -o attr2,rtdev=3D/dev/ram2,logdev=3D/dev/ram1 /dev/ram0 /mnt=
/test
>
> mkfs.xfs -f -llogdev=3D/dev/ram4 -rrtdev=3D/dev/ram5 -bsize=3D4096 /dev/r=
am3
> mount -t xfs -o attr2,rtdev=3D/dev/ram5,logdev=3D/dev/ram4 /dev/ram3 \
> =A0 =A0/mnt/test-scratch
>
> I have the following local.config in xfstests:
> #!/bin/bash
> export TEST_DEV=3D"/dev/ram0"
> export TEST_MNT=3D"/mnt/test"
> export TEST_DIR=3D"/mnt/test"
> export TEST_LOGDEV=3D"/dev/ram1"
> export TEST_RTDEV=3D"/dev/ram2"
> export SCRATCH_DEV=3D"/dev/ram3"
> export SCRATCH_MNT=3D"/mnt/test-scratch"
> export SCRATCH_LOGDEV=3D"/dev/ram4"
> export SCRATCH_RTDEV=3D"/dev/ram5"
> export USE_EXTERNAL=3D"yes"
>
> All devices are ramdisks.
>
> I find with the above setup, when I run 'xfstests/check 090', the test wi=
ll
> block indefinitely on I/O for the first iteration of the test. =A0This te=
st was
> run using the latest code from the xfstests git repo and xfs git repo (ke=
rnel
> 3.1.0-rc9).
>
> For the other failure scenario, I have the following setup:
>
> mkfs.xfs -f -llogdev=3D/dev/ram1 -rrtdev=3D/dev/ram2 -bsize=3D4096 /dev/r=
am0
> mount -t xfs -o attr2,rtdev=3D/dev/ram2,logdev=3D/dev/ram1 /dev/ram0 /mnt=
/test
> xfs_io -c 'chattr +t' /mnt/test
>
> I have setup all files under /mnt/test to be placed in the realtime porti=
on
> using the realtime inherit flag set through xfs_io. =A0If I do not use th=
e flag
> and instead create the file using xfs_io and 'pwrite', I still encounter =
the
> same issue O_DIRECT hang issue.
>
> Using a fairly simple C application (below), the call to write() will han=
g the
> system indefinitely on kernel 2.6.32, or cause the kernel to kill the pro=
cess on
> kernel 3.1.0-rc9 reporting a NULL pointer dereference (message below). =
=A0I have
> traced the issue back to the use of the O_DIRECT and O_TRUNC flags. =A0If=
 the file
> to write to has been preallocated using xfs_io's 'pwrite' and 'truncate',
> omitting the O_TRUNC flag will allow the test application to complete wit=
hout
> issue. =A0As I understand it, the realtime subvolume has no requirements =
that all
> files be preallocated. =A0Omitting the O_DIRECT flag will also allow the =
test to
> complete without issue, but with absolutely terrible I/O performance.
>
> Have I uncovered a legitimate or known bug or is there something wrong wi=
th my
> XFS setup?
>
> I can supply more information if needed. =A0Thanks for any help.
>
> ----
>
> Kernel 3.1.0-rc9 reports a NULL pointer dereference:
>
> [ =A0657.406892] BUG: unable to handle kernel NULL pointer dereference at
> 0000000000000090
> [ =A0657.406905] IP: [<ffffffff813bae29>] _raw_spin_lock+0x9/0x20
> [ =A0657.406918] PGD 113f2e067 PUD 1144b3067 PMD 0
> [ =A0657.406926] Oops: 0002 [#1] SMP
> [ =A0657.406932] CPU 0
> [ =A0657.406935] Modules linked in: xfs exportfs brd binfmt_misc snd_pcm_=
oss ...
> [ =A0657.407008]
> [ =A0657.407012] Pid: 4573, comm: write-bench Not tainted 3.1.0-rc9-0.5-a=
cook-xfs
> #1 Gigabyte Technology Co., Ltd. X58A-UD3R/X58A-UD3R
> [ =A0657.407020] RIP: 0010:[<ffffffff813bae29>] =A0[<ffffffff813bae29>]
> _raw_spin_lock+0x9/0x20
> [ =A0657.407027] RSP: 0018:ffff880115d83478 =A0EFLAGS: 00010246
> [ =A0657.407031] RAX: 0000000000010000 RBX: 0000000000000000 RCX: 0000000=
000000003
> [ =A0657.407036] RDX: 0000000000000001 RSI: 000000004008aec1 RDI: 0000000=
000000090
> [ =A0657.407040] RBP: ffff880115d83478 R08: ffff880037407280 R09: 0000000=
000000000
> [ =A0657.407044] R10: 0000000000000001 R11: 0000000000000000 R12: 0080115=
d82000000
> [ =A0657.407048] R13: 0000000000001000 R14: 0000000000000000 R15: 0000000=
000000000
> [ =A0657.407053] FS: =A000007f0a00ec3700(0000) GS:ffff88011fc00000(0000)
> knlGS:0000000000000000
> [ =A0657.407058] CS: =A00010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ =A0657.407062] CR2: 0000000000000090 CR3: 000000010df5d000 CR4: 0000000=
0000006f0
> [ =A0657.407066] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000=
000000000
> [ =A0657.407071] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000=
000000400
> [ =A0657.407076] Process write-bench (pid: 4573, threadinfo ffff880115d82=
000, task
> ffff880119720240)
> [ =A0657.407080] Stack:
> [ =A0657.407082] =A0ffff880115d834d8 ffffffffa03b9954 0000000000000001 00=
00000000000
> 090
> [ =A0657.407088] =A00002800900000000 ffff88003741a400 000000004008aec1 00=
00000000000
> 000
> [ =A0657.407094] =A00000000000000008 00004008aec10000 0000000000028009 ff=
ff8801161d4
> c80
> [ =A0657.407101] Call Trace:
> [ =A0657.407117] =A0[<ffffffffa03b9954>] _xfs_buf_find+0x64/0x1e0 [xfs]
> [ =A0657.407129] =A0[<ffffffffa03b9dd0>] xfs_buf_get+0x30/0x160 [xfs]
> [ =A0657.407140] =A0[<ffffffffa03b9f16>] xfs_buf_read+0x16/0xa0 [xfs]
> [ =A0657.407158] =A0[<ffffffffa040cf20>] xfs_trans_read_buf+0x1a0/0x2a0 [=
xfs]
> [ =A0657.407174] =A0[<ffffffffa0414e1f>] xfs_rtbuf_get+0xcf/0xf0 [xfs]
> [ =A0657.407180] =A0[<ffffffffa00c3664>] ? brd_make_request+0x54/0x4ac [b=
rd]
> [ =A0657.407196] =A0[<ffffffffa0415b6a>] xfs_rtget_summary+0x7a/0x110 [xf=
s]
> [ =A0657.407203] =A0[<ffffffff811c82f0>] ? generic_make_request+0x2f0/0x3=
b0
> [ =A0657.407220] =A0[<ffffffffa04162f2>] xfs_rtallocate_extent_size+0x82/=
0x2b0 [xfs]
> [ =A0657.407235] =A0[<ffffffffa03cda17>] ? kmem_zone_alloc+0x77/0xe0 [xfs]
> [ =A0657.407252] =A0[<ffffffffa0416aa0>] xfs_rtallocate_extent+0x140/0x1a=
0 [xfs]
> [ =A0657.407269] =A0[<ffffffffa0403fe8>] ? xfs_trans_add_item+0x28/0x70 [=
xfs]
> [ =A0657.407286] =A0[<ffffffffa03e106d>] xfs_bmap_rtalloc+0x18d/0x300 [xf=
s]
> [ =A0657.407303] =A0[<ffffffffa03d923d>] ? xfs_bmap_search_multi_extents+=
0x6d/0x100
> [xfs]
> [ =A0657.407320] =A0[<ffffffffa03e1215>] xfs_bmap_alloc+0x35/0x40 [xfs]
> [ =A0657.407337] =A0[<ffffffffa03e12e9>] xfs_bmapi_allocate+0xc9/0x2c0 [x=
fs]
> [ =A0657.407354] =A0[<ffffffffa03e18ec>] xfs_bmapi_write+0x40c/0x6f0 [xfs]
> [ =A0657.407368] =A0[<ffffffffa03c276b>] xfs_iomap_write_direct+0x20b/0x3=
a0 [xfs]
> [ =A0657.407379] =A0[<ffffffffa03b69e5>] __xfs_get_blocks+0x2b5/0x370 [xf=
s]
> [ =A0657.407389] =A0[<ffffffffa03b6aaf>] xfs_get_blocks_direct+0xf/0x20 [=
xfs]
> [ =A0657.407396] =A0[<ffffffff81142e4a>] __blockdev_direct_IO+0x5ba/0xb90
> [ =A0657.407407] =A0[<ffffffffa03b651f>] xfs_vm_direct_IO+0x9f/0x120 [xfs]
> [ =A0657.407418] =A0[<ffffffffa03b6aa0>] ? __xfs_get_blocks+0x370/0x370 [=
xfs]
> [ =A0657.407428] =A0[<ffffffffa03b66d0>] ? xfs_finish_ioend_sync+0x30/0x3=
0 [xfs]
> [ =A0657.407439] =A0[<ffffffff810c17b8>] generic_file_direct_write+0xb8/0=
x190
> [ =A0657.407453] =A0[<ffffffffa03bc8d0>] xfs_file_dio_aio_write+0x190/0x2=
70 [xfs]
> [ =A0657.407469] =A0[<ffffffffa03bcec2>] xfs_file_aio_write+0x252/0x260 [=
xfs]
> [ =A0657.407478] =A0[<ffffffff812644ba>] ? tty_wakeup+0x3a/0x80
> [ =A0657.407486] =A0[<ffffffff8110f6c1>] do_sync_write+0xd1/0x120
> [ =A0657.407495] =A0[<ffffffff8119736d>] ? security_file_permission+0x1d/=
0xa0
> [ =A0657.407502] =A0[<ffffffff8110fcfb>] vfs_write+0xcb/0x180
> [ =A0657.407509] =A0[<ffffffff8110fea0>] sys_write+0x50/0x90
> [ =A0657.407517] =A0[<ffffffff813c1492>] system_call_fastpath+0x16/0x1b
> [ =A0657.407522] Code: 90 00 00 01 00 75 04 f0 0f b1 17 0f 94 c2 0f b6 c2=
 85 c0 c9
> 0f 95 c0 0f b6 c0 c3 0f 1f 80 00 00 00 00 55 b8 00 00 01 00 48 89 e5 <f0>=
 0f
> [ =A0657.407566] RIP =A0[<ffffffff813bae29>] _raw_spin_lock+0x9/0x20
> [ =A0657.407574] =A0RSP <ffff880115d83478>
> [ =A0657.407578] CR2: 0000000000000090
> [ =A0657.407590] ---[ end trace e406d45b83e0d669 ]---
>
> Simple C application for testing:
>
> #include <stdio.h>
> #include <stdlib.h>
> #define __USE_GNU
> #include <fcntl.h>
>
> int
> main(int argc, char **argv)
> {
> =A0 =A0int fd =3D -1;
> =A0 =A0unsigned char *buffer, *buffer_orig;
> =A0 =A0unsigned long size =3D 32 * 1024 * 1024; /* 32 MiB */
> =A0 =A0 =A0 =A0unsigned long i =3D 0;
>
> =A0 =A0if(argc < 2) {
> =A0 =A0 =A0 =A0printf("%s <destfile>\n", argv[0]);
> =A0 =A0 =A0 =A0return 1;
> =A0 =A0}
>
> =A0 =A0buffer_orig =3D buffer =3D malloc(size + 4096);
In my opinion, this is not the way to allocate memory and use for
O_DIRECT approach. Instead you can make use of valloc() or
posix_memalign()/memalign
Or if you are still using malloc() - then you probably did the right
thing by allocating for alignment like malloc(size + 4096);
but, store this is permanent pointer and make use of aligned pointer :
perm_pointer =3D malloc(size +4096);
For aligning you need an expression like this:
align_pointer =3D (perm_pointer + 4096) & ~(4095);// If you wish to
align for 512, do it like (p+512) & ~(511);
> =A0 =A0if(!buffer) {
> =A0 =A0 =A0 =A0perror("malloc");
> =A0 =A0 =A0 =A0return 2;
> =A0 =A0}
>
> =A0 =A0/* open file for direct write on realtime partition */
> =A0 =A0fd =3D open(argv[1], O_TRUNC | O_CREAT | O_DIRECT | O_WRONLY, 0666=
);
> =A0 =A0if(fd >=3D 0) {
>
> =A0 =A0 =A0 =A0/* write hangs machine, or kill process depending on kerne=
l version */
> =A0 =A0 =A0 =A0if(0 > write(fd, buffer, size)) {
> =A0 =A0 =A0 =A0 =A0 =A0perror("write");
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0close(fd);
> =A0 =A0}
>
> =A0 =A0free(buffer_orig);
free(perm_pointer); // freeing the original pointer which has the size
history for malloc.
>
> =A0 =A0return 0;
> }
>
>
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>

Thanks & Regards,
Amit Sahrawat

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
