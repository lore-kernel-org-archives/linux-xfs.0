Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2996B7F58
	for <xfs@oss.sgi.com>; Fri, 15 Mar 2013 21:00:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A547BAC003
	for <xfs@oss.sgi.com>; Fri, 15 Mar 2013 19:00:40 -0700 (PDT)
Received: from mail-la0-f52.google.com (mail-la0-f52.google.com
	[209.85.215.52]) by cuda.sgi.com with ESMTP id czFYtj95ArKTKivr
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 15 Mar 2013 19:00:39 -0700 (PDT)
Received: by mail-la0-f52.google.com with SMTP id fs12so4413660lab.11
	for <xfs@oss.sgi.com>; Fri, 15 Mar 2013 19:00:37 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 15 Mar 2013 22:00:37 -0400
Message-ID: <CAJzLF9mvztWUQq7X2o0BcYLvUDH2bjAjpZosgzVUERgPTNYLVg@mail.gmail.com>
Subject: xfstests #078: Mild oops/kernel issue for small partitions
From: "Michael L. Semon" <mlsemon35@gmail.com>
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
To: xfs@oss.sgi.com

Hi!  I was making another run with xfstests, using smaller partitions
so I could use the larger ones for other tests, and I got a mild
oops/crash of some sort.  This applies only to small partitions, first
hit using 480MB partitions.  Also, CONFIG_XFS_DEBUG is set here, but I
haven't tested the non-debug case lately.  This has been repeatable
across various 3.8/3.9 kernels used recently.

PC in this test is my Pentium III boat anchor, 512 MB RAM, 768 MB
swap, no VGA/console, using serial and ssh to communicate.  Output was
taken from the remote syslog facility and trimmed down.

This is a crash report.  No fix is requested.  Let me know if this
needs to go somewhere else in the Linux development world as well.

Though labelled as _RTDEV partitions, /dev/sdb2 was my $TEST_DEV, and
/test/sdb5 was my $SCRATCH_DEV, and none of the external options were
in play:

[From `gdisk -l /dev/sdb`]
Number  Start (sector)    End (sector)  Size       Code  Name
   2        17639424        18687999   512.0 MiB   8300  gSTestRTDev
   5        18950144        19999694   512.5 MiB   8300  gSScrRTDev

Below is my oops, which was soft in nature, and my accidental typing
of `telinit 0` instead of `telinit 1` stopped things gently.  All is
well.  Don't try too hard...no bisecting unless you really want to do
so...this has never happened in my production environment...and thanks
again!

MIchael

root: run xfstest 078
XFS (loop0): Mounting Filesystem
XFS (loop0): Mounting Filesystem
XFS (loop0): Mounting Filesystem
XFS (loop0): Mounting Filesystem
XFS: Assertion failed: block_offset + from == pos, file:
fs/xfs/xfs_aops.c, line: 1504
------------[ cut here ]------------
kernel BUG at fs/xfs/xfs_message.c:100!
invalid opcode: 0000 [#1]
Pid: 1203, comm: mkfs.xfs Not tainted 3.9.0-rc1+ #1
EIP: 0060:[<c10fa4f7>] EFLAGS: 00010286 CPU: 0
EIP is at assfail+0x27/0x30
EAX: 00000056 EBX: dfd7bd60 ECX: c141db1c EDX: 00000000
ESI: 1bb72000 EDI: 00000000 EBP: dd037d70 ESP: dd037d5c
 DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
CR0: 8005003b CR2: b757d000 CR3: 1286c000 CR4: 000007d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
Process mkfs.xfs (pid: 1203, ti=dd036000 task=d620b320 task.ti=dd036000)
Stack:
 00000000 c13d0274 c13c970c c13c9607 000005e0 dd037db8 c10e9af4 c7f5a398
 00000000 cf0a5888 00001000 dfd7bd60 c7f5a398 00001000 00000000 00000000
 00000000 cf0a5888 0801bb72 0102005a dfd7bd60 ffffffe4 c7f5a398 dd037de0
Call Trace:
 [<c10e9af4>] xfs_vm_write_failed+0x64/0x150
 [<c10e9c8e>] xfs_vm_write_begin+0xae/0x100
 [<c1063a29>] ? iov_iter_copy_from_user_atomic+0x59/0x90
 [<c106421a>] generic_file_buffered_write+0xca/0x210
 [<c10ef3b1>] xfs_file_buffered_aio_write+0xc1/0x110
 [<c10ef4db>] xfs_file_aio_write+0xdb/0x140
 [<c108f447>] do_sync_write+0xb7/0xf0
 [<c108f390>] ? vfs_read+0x150/0x150
 [<c108f509>] vfs_write+0x89/0x150
 [<c108f390>] ? vfs_read+0x150/0x150
 [<c108f692>] sys_write+0x42/0x80
 [<c1331964>] syscall_call+0x7/0xb
Code: 00 00 00 00 55 89 e5 83 ec 14 89 54 24 0c ba 74 02 3d c1 89 4c
24 10 89 44 24 08 89 54 24 04 c7 04 24 00 00 00 00 e8 d9 fd ff ff <0f>
0b 8d b4 26 00 00 00 00 55 b9 01 00 00 00 89 e5 83 ec 14 89
EIP: [<c10fa4f7>] assfail+0x27/0x30 SS:ESP 0068:dd037d5c
---[ end trace a734100af2d0a0d7 ]---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
