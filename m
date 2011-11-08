Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA8IAD3N140214
	for <linux-xfs@oss.sgi.com>; Tue, 8 Nov 2011 12:10:15 -0600
Received: from lo.gmane.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1E9ED1CF55E8
	for <linux-xfs@oss.sgi.com>; Tue,  8 Nov 2011 10:10:10 -0800 (PST)
Received: from lo.gmane.org (lo.gmane.org [80.91.229.12]) by cuda.sgi.com with
	ESMTP id 5AayVdwxqN4w5Vhm for <linux-xfs@oss.sgi.com>;
	Tue, 08 Nov 2011 10:10:10 -0800 (PST)
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1RNq7d-0000h8-Fz
	for linux-xfs@oss.sgi.com; Tue, 08 Nov 2011 19:10:10 +0100
Received: from office1.visionpointsystems.com ([216.252.206.159])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Tue, 08 Nov 2011 19:10:09 +0100
Received: from acook by office1.visionpointsystems.com with local (Gmexim 0.1
	(Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Tue, 08 Nov 2011 19:10:09 +0100
From: Alan Cook <acook@visionpointsystems.com>
Subject: XFS realtime =?utf-8?b?T19ESVJFQ1Q=?= failures
Date: Tue, 8 Nov 2011 17:37:55 +0000 (UTC)
Message-ID: <loom.20111108T180925-222@post.gmane.org>
Mime-Version: 1.0
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
To: linux-xfs@oss.sgi.com

I am having issues using the O_DIRECT flags for writing to files that reside on
the realtime subvolume of an XFS file system.  I have found a failure case for
xfstests test 090 as well as another case that I will describe below.

For test 090, I have the following setup:

mkfs.xfs -f -llogdev=/dev/ram1 -rrtdev=/dev/ram2 -bsize=4096 /dev/ram0
mount -t xfs -o attr2,rtdev=/dev/ram2,logdev=/dev/ram1 /dev/ram0 /mnt/test

mkfs.xfs -f -llogdev=/dev/ram4 -rrtdev=/dev/ram5 -bsize=4096 /dev/ram3
mount -t xfs -o attr2,rtdev=/dev/ram5,logdev=/dev/ram4 /dev/ram3 \
    /mnt/test-scratch

I have the following local.config in xfstests:
#!/bin/bash
export TEST_DEV="/dev/ram0"
export TEST_MNT="/mnt/test"
export TEST_DIR="/mnt/test"
export TEST_LOGDEV="/dev/ram1"
export TEST_RTDEV="/dev/ram2"
export SCRATCH_DEV="/dev/ram3"
export SCRATCH_MNT="/mnt/test-scratch"
export SCRATCH_LOGDEV="/dev/ram4"
export SCRATCH_RTDEV="/dev/ram5"
export USE_EXTERNAL="yes"

All devices are ramdisks.

I find with the above setup, when I run 'xfstests/check 090', the test will
block indefinitely on I/O for the first iteration of the test.  This test was
run using the latest code from the xfstests git repo and xfs git repo (kernel
3.1.0-rc9).

For the other failure scenario, I have the following setup:

mkfs.xfs -f -llogdev=/dev/ram1 -rrtdev=/dev/ram2 -bsize=4096 /dev/ram0
mount -t xfs -o attr2,rtdev=/dev/ram2,logdev=/dev/ram1 /dev/ram0 /mnt/test
xfs_io -c 'chattr +t' /mnt/test

I have setup all files under /mnt/test to be placed in the realtime portion
using the realtime inherit flag set through xfs_io.  If I do not use the flag
and instead create the file using xfs_io and 'pwrite', I still encounter the
same issue O_DIRECT hang issue.

Using a fairly simple C application (below), the call to write() will hang the
system indefinitely on kernel 2.6.32, or cause the kernel to kill the process on
kernel 3.1.0-rc9 reporting a NULL pointer dereference (message below).  I have
traced the issue back to the use of the O_DIRECT and O_TRUNC flags.  If the file
to write to has been preallocated using xfs_io's 'pwrite' and 'truncate',
omitting the O_TRUNC flag will allow the test application to complete without
issue.  As I understand it, the realtime subvolume has no requirements that all
files be preallocated.  Omitting the O_DIRECT flag will also allow the test to
complete without issue, but with absolutely terrible I/O performance.

Have I uncovered a legitimate or known bug or is there something wrong with my
XFS setup?

I can supply more information if needed.  Thanks for any help.

----

Kernel 3.1.0-rc9 reports a NULL pointer dereference:

[  657.406892] BUG: unable to handle kernel NULL pointer dereference at
0000000000000090
[  657.406905] IP: [<ffffffff813bae29>] _raw_spin_lock+0x9/0x20
[  657.406918] PGD 113f2e067 PUD 1144b3067 PMD 0
[  657.406926] Oops: 0002 [#1] SMP
[  657.406932] CPU 0
[  657.406935] Modules linked in: xfs exportfs brd binfmt_misc snd_pcm_oss ...
[  657.407008]
[  657.407012] Pid: 4573, comm: write-bench Not tainted 3.1.0-rc9-0.5-acook-xfs
#1 Gigabyte Technology Co., Ltd. X58A-UD3R/X58A-UD3R
[  657.407020] RIP: 0010:[<ffffffff813bae29>]  [<ffffffff813bae29>]
_raw_spin_lock+0x9/0x20
[  657.407027] RSP: 0018:ffff880115d83478  EFLAGS: 00010246
[  657.407031] RAX: 0000000000010000 RBX: 0000000000000000 RCX: 0000000000000003
[  657.407036] RDX: 0000000000000001 RSI: 000000004008aec1 RDI: 0000000000000090
[  657.407040] RBP: ffff880115d83478 R08: ffff880037407280 R09: 0000000000000000
[  657.407044] R10: 0000000000000001 R11: 0000000000000000 R12: 0080115d82000000
[  657.407048] R13: 0000000000001000 R14: 0000000000000000 R15: 0000000000000000
[  657.407053] FS:  00007f0a00ec3700(0000) GS:ffff88011fc00000(0000)
knlGS:0000000000000000
[  657.407058] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  657.407062] CR2: 0000000000000090 CR3: 000000010df5d000 CR4: 00000000000006f0
[  657.407066] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  657.407071] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  657.407076] Process write-bench (pid: 4573, threadinfo ffff880115d82000, task
ffff880119720240)
[  657.407080] Stack:
[  657.407082]  ffff880115d834d8 ffffffffa03b9954 0000000000000001 0000000000000
090
[  657.407088]  0002800900000000 ffff88003741a400 000000004008aec1 0000000000000
000
[  657.407094]  0000000000000008 00004008aec10000 0000000000028009 ffff8801161d4
c80
[  657.407101] Call Trace:
[  657.407117]  [<ffffffffa03b9954>] _xfs_buf_find+0x64/0x1e0 [xfs]
[  657.407129]  [<ffffffffa03b9dd0>] xfs_buf_get+0x30/0x160 [xfs]
[  657.407140]  [<ffffffffa03b9f16>] xfs_buf_read+0x16/0xa0 [xfs]
[  657.407158]  [<ffffffffa040cf20>] xfs_trans_read_buf+0x1a0/0x2a0 [xfs]
[  657.407174]  [<ffffffffa0414e1f>] xfs_rtbuf_get+0xcf/0xf0 [xfs]
[  657.407180]  [<ffffffffa00c3664>] ? brd_make_request+0x54/0x4ac [brd]
[  657.407196]  [<ffffffffa0415b6a>] xfs_rtget_summary+0x7a/0x110 [xfs]
[  657.407203]  [<ffffffff811c82f0>] ? generic_make_request+0x2f0/0x3b0
[  657.407220]  [<ffffffffa04162f2>] xfs_rtallocate_extent_size+0x82/0x2b0 [xfs]
[  657.407235]  [<ffffffffa03cda17>] ? kmem_zone_alloc+0x77/0xe0 [xfs]
[  657.407252]  [<ffffffffa0416aa0>] xfs_rtallocate_extent+0x140/0x1a0 [xfs]
[  657.407269]  [<ffffffffa0403fe8>] ? xfs_trans_add_item+0x28/0x70 [xfs]
[  657.407286]  [<ffffffffa03e106d>] xfs_bmap_rtalloc+0x18d/0x300 [xfs]
[  657.407303]  [<ffffffffa03d923d>] ? xfs_bmap_search_multi_extents+0x6d/0x100
[xfs]
[  657.407320]  [<ffffffffa03e1215>] xfs_bmap_alloc+0x35/0x40 [xfs]
[  657.407337]  [<ffffffffa03e12e9>] xfs_bmapi_allocate+0xc9/0x2c0 [xfs]
[  657.407354]  [<ffffffffa03e18ec>] xfs_bmapi_write+0x40c/0x6f0 [xfs]
[  657.407368]  [<ffffffffa03c276b>] xfs_iomap_write_direct+0x20b/0x3a0 [xfs]
[  657.407379]  [<ffffffffa03b69e5>] __xfs_get_blocks+0x2b5/0x370 [xfs]
[  657.407389]  [<ffffffffa03b6aaf>] xfs_get_blocks_direct+0xf/0x20 [xfs]
[  657.407396]  [<ffffffff81142e4a>] __blockdev_direct_IO+0x5ba/0xb90
[  657.407407]  [<ffffffffa03b651f>] xfs_vm_direct_IO+0x9f/0x120 [xfs]
[  657.407418]  [<ffffffffa03b6aa0>] ? __xfs_get_blocks+0x370/0x370 [xfs]
[  657.407428]  [<ffffffffa03b66d0>] ? xfs_finish_ioend_sync+0x30/0x30 [xfs]
[  657.407439]  [<ffffffff810c17b8>] generic_file_direct_write+0xb8/0x190
[  657.407453]  [<ffffffffa03bc8d0>] xfs_file_dio_aio_write+0x190/0x270 [xfs]
[  657.407469]  [<ffffffffa03bcec2>] xfs_file_aio_write+0x252/0x260 [xfs]
[  657.407478]  [<ffffffff812644ba>] ? tty_wakeup+0x3a/0x80
[  657.407486]  [<ffffffff8110f6c1>] do_sync_write+0xd1/0x120
[  657.407495]  [<ffffffff8119736d>] ? security_file_permission+0x1d/0xa0
[  657.407502]  [<ffffffff8110fcfb>] vfs_write+0xcb/0x180
[  657.407509]  [<ffffffff8110fea0>] sys_write+0x50/0x90
[  657.407517]  [<ffffffff813c1492>] system_call_fastpath+0x16/0x1b
[  657.407522] Code: 90 00 00 01 00 75 04 f0 0f b1 17 0f 94 c2 0f b6 c2 85 c0 c9
0f 95 c0 0f b6 c0 c3 0f 1f 80 00 00 00 00 55 b8 00 00 01 00 48 89 e5 <f0> 0f
[  657.407566] RIP  [<ffffffff813bae29>] _raw_spin_lock+0x9/0x20
[  657.407574]  RSP <ffff880115d83478>
[  657.407578] CR2: 0000000000000090
[  657.407590] ---[ end trace e406d45b83e0d669 ]---

Simple C application for testing:

#include <stdio.h>
#include <stdlib.h>
#define __USE_GNU
#include <fcntl.h>

int
main(int argc, char **argv)
{
    int fd = -1;
    unsigned char *buffer, *buffer_orig;
    unsigned long size = 32 * 1024 * 1024; /* 32 MiB */
        unsigned long i = 0;

    if(argc < 2) {
        printf("%s <destfile>\n", argv[0]);
        return 1;
    }

    buffer_orig = buffer = malloc(size + 4096);
    if(!buffer) {
        perror("malloc");
        return 2;
    }

    /* open file for direct write on realtime partition */
    fd = open(argv[1], O_TRUNC | O_CREAT | O_DIRECT | O_WRONLY, 0666);
    if(fd >= 0) {

        /* write hangs machine, or kill process depending on kernel version */
        if(0 > write(fd, buffer, size)) {
            perror("write");
        }

        close(fd);
    }

    free(buffer_orig);

    return 0;
}



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
