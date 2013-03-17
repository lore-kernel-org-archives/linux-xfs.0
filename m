Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 991887F91
	for <xfs@oss.sgi.com>; Sat, 16 Mar 2013 22:30:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6C18D304059
	for <xfs@oss.sgi.com>; Sat, 16 Mar 2013 20:30:22 -0700 (PDT)
Received: from mail-lb0-f177.google.com (mail-lb0-f177.google.com
	[209.85.217.177]) by cuda.sgi.com with ESMTP id
	2DAiAcfYXPuXzLof (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 16 Mar 2013 20:30:20 -0700 (PDT)
Received: by mail-lb0-f177.google.com with SMTP id go11so3794101lbb.36
	for <xfs@oss.sgi.com>; Sat, 16 Mar 2013 20:30:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <514432D8.1090702@oracle.com>
References: <CAJzLF9mvztWUQq7X2o0BcYLvUDH2bjAjpZosgzVUERgPTNYLVg@mail.gmail.com>
	<5143EA55.9040209@oracle.com> <20130316072550.GH6369@dastard>
	<514432D8.1090702@oracle.com>
Date: Sat, 16 Mar 2013 23:30:18 -0400
Message-ID: <CAJzLF9k-oXk+4rksi0O8+YywP1FHZE-3KTpVW=p7thYsP7TAiQ@mail.gmail.com>
Subject: Re: xfstests #078: Mild oops/kernel issue for small partitions
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

On Sat, Mar 16, 2013 at 4:52 AM, Jeff Liu <jeff.liu@oracle.com> wrote:
> On 03/16/2013 03:25 PM, Dave Chinner wrote:
>> On Sat, Mar 16, 2013 at 11:43:17AM +0800, Jeff Liu wrote:
>>> Hi Michael,
>>>
>>> Thanks for the report.
>>> On 03/16/2013 10:00 AM, Michael L. Semon wrote:
>>>> Hi!  I was making another run with xfstests, using smaller partitions
>>>> so I could use the larger ones for other tests, and I got a mild
>>>> oops/crash of some sort.  This applies only to small partitions, first
>>>> hit using 480MB partitions.  Also, CONFIG_XFS_DEBUG is set here, but I
>>>> haven't tested the non-debug case lately.  This has been repeatable
>>>> across various 3.8/3.9 kernels used recently.
>>>>
>>>> PC in this test is my Pentium III boat anchor, 512 MB RAM, 768 MB
>>>> swap, no VGA/console, using serial and ssh to communicate.  Output was
>>>> taken from the remote syslog facility and trimmed down.
>>> So I just tried it against both 480MB and 512MB partitions, but I can not
>>> reproduce it on 3.8/3.9-rc1 with xfsprogs 3.1.8.
>>>
>>> # gdisk -l /dev/sda
>>> Number  Start (sector)    End (sector)  Size       Code  Name
>>>    7       405682176       406730751   512.0 MiB   8300  Linux filesystem
>>>    8       406732800       407781375   512.0 MiB   8300  Linux filesystem
>>>    9       407783424       408766463   480.0 MiB   8300  Linux filesystem
>>>   10       408768512       409751551   480.0 MiB   8300  Linux filesystem
>>>
>>> # ./check 078
>>> FSTYP         -- xfs (debug)
>>> PLATFORM      -- Linux/x86_64 koala 3.9.0-rc1
>>
>> 64 bit system
>>
>>> MKFS_OPTIONS  -- -f -bsize=4096 /dev/sda10
>>> MOUNT_OPTIONS -- /dev/sda10 /xfstest4
>>>
>>> 078 46s ... - output mismatch (see 078.out.bad)
>>>     --- 078.out      2012-10-16 11:59:14.757395850 +0800
>>>     +++ 078.out.bad  2013-03-16 11:39:10.945051414 +0800
>>>     @@ -76,6 +76,7 @@
>>>      === GROWFS (from 1t to 2500g, 4096 blocksize)
>>>
>>>      *** mkfs loop file (size=1t)
>>>     +mkfs.xfs: libxfs_device_zero write failed: No space left on device
>>
>> it ran out of space creating the log device. That write error is
>> likely what triggered the reported oops , which occurred in the
>> buffered write error handling routine....
> Yes.
>>
>>>> This is a crash report.  No fix is requested.  Let me know if this
>>>> needs to go somewhere else in the Linux development world as well.
>> ....
>>>> XFS (loop0): Mounting Filesystem
>>>> XFS: Assertion failed: block_offset + from == pos, file:
>>>> fs/xfs/xfs_aops.c, line: 1504
>>>> ------------[ cut here ]------------
>>>> kernel BUG at fs/xfs/xfs_message.c:100!
>>>> invalid opcode: 0000 [#1]
>>>> Pid: 1203, comm: mkfs.xfs Not tainted 3.9.0-rc1+ #1
>>>> EIP: 0060:[<c10fa4f7>] EFLAGS: 00010286 CPU: 0
>>>> EIP is at assfail+0x27/0x30
>>>> EAX: 00000056 EBX: dfd7bd60 ECX: c141db1c EDX: 00000000
>>>> ESI: 1bb72000 EDI: 00000000 EBP: dd037d70 ESP: dd037d5c
>>
>> Oops occurred on a 32 bit system. That might be relevant...
> Ah, I missed this difference, will build a 32bits VM to verify it again.
>
> Thanks,
> -Jeff

Just an update:  Things like gcc and glibc are slow to compile, so I
played with the kernel setting CONFIG_LBDAF, which is listed as
something like "support for files greater than 1TB" in the block layer
section.  It makes a difference in whether the xfstests 078 passes or
fails for larger partitions, so there is enough emulated 64-bitness in
32-bit Linux for that, at least.  However, the resulting oops on
smaller partitions is almost exactly the same.  My report is posted
below, and it's probably noise, but it is information and proof that
the test can pass under some conditions.

I like Dave's idea of the log filling up, and it's food for thought.
But the questions remain:  Why only on 32-bit Linux does it become an
oops?  And in a passing test, in terms of calculations, how large is
the log/journal supposed to become?  Later, I'll make partitions
smaller than the 4.9GiB that I used below, interpolating until I get
an educated guess.

Thanks yet again!

Michael

NOISE REPORT FOLLOWS...

In these tests, I used slightly larger partitions:

[taken from `gdisk -l /dev/sda]
Number  Start (sector)    End (sector)  Size       Code  Name
  11        96468992       106828227   4.9 GiB     8300  gTestDev
  12       106828228       117187466   4.9 GiB     8300  gScratchDev

##### Result when CONFIG_LBDAF=n (setting for original post):

root:/var/lib/xfstests# ./check 078
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/i686 oldsvrhw 3.9.0-rc1+
MKFS_OPTIONS  -- -f -bsize=4096 /dev/sda12
MOUNT_OPTIONS -- /dev/sda12 /mnt/xfstests-scratch

078	 - output mismatch (see 078.out.bad)
    --- 078.out	2013-03-15 17:38:42.339750761 -0400
    +++ 078.out.bad	2013-03-16 15:43:58.946699766 -0400
    @@ -85,9 +85,9 @@
     *** extend loop file
     wrote 4096/4096 bytes at offset 2684354560000
     *** mount loop filesystem
    +mount: /mnt/xfstests-test/078.fs: failed setting up loop device:
No such device or address
     *** grow loop filesystem
    -xfs_growfs --BlockSize=4096 --Blocks=268435456
    -data blocks changed from 268435456 to 655360001
     ...
     (Run 'diff -u 078.out 078.out.bad' to see the entire diff)
Ran: 078
Failures: 078
Failed 1 of 1 tests

##### Result when CONFIG_LBDAF=y:

root:/var/lib/xfstests# ./check 078
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/i686 oldsvrhw 3.9.0-rc1+
MKFS_OPTIONS  -- -f -bsize=4096 /dev/sda12
MOUNT_OPTIONS -- /dev/sda12 /mnt/xfstests-scratch

078 155s ... 164s
Ran: 078
Passed all 1 tests

However, bringing this kernel back to the smaller partitions, I get a
very slightly different trace (below).  In particular, the code is the
same, except the sequence "74 02 3d" is replaced by "d8 20 3c" at
around the 16th pair of hex digits...if that makes any difference at
all.

Mar 16 16:20:22 oldsvrhw logger: run xfstest 078
XFS (loop0): Mounting Filesystem
XFS (loop0): Mounting Filesystem
XFS (loop0): Mounting Filesystem
XFS (loop0): Mounting Filesystem
XFS: Assertion failed: block_offset + from == pos, file:
fs/xfs/xfs_aops.c, line: 1504
------------[ cut here ]------------
kernel BUG at fs/xfs/xfs_message.c:100!
invalid opcode: 0000 [#1]
Pid: 4547, comm: mkfs.xfs Not tainted 3.9.0-rc1+ #5
EIP: 0060:[<c10fbc57>] EFLAGS: 00010286 CPU: 0
EIP is at assfail+0x27/0x30
EAX: 00000056 EBX: dfc98a80 ECX: c140db1c EDX: 00000000
ESI: 0e78a000 EDI: 00000000 EBP: da5b5d70 ESP: da5b5d5c
 DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
CR0: 8005003b CR2: 093f6000 CR3: 1a584000 CR4: 000007d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
Process mkfs.xfs (pid: 4547, ti=da5b4000 task=de9a0ff0 task.ti=da5b4000)
Stack:
 00000000 c13c20d8 c13bb4e8 c13bb3e3 000005e0 da5b5db8 c10eaeb4 00000000
 df3b10e0 00001000 dfc98a80 00001000 df183038 00001000 00000000 00000000
 00000000 df3b10e0 0800e78a 0102005a dfc98a80 ffffffe4 df183038 da5b5de0
Call Trace:
 [<c10eaeb4>] xfs_vm_write_failed+0x64/0x150
 [<c10eb04e>] xfs_vm_write_begin+0xae/0x100
 [<c1063a29>] ? iov_iter_copy_from_user_atomic+0x59/0x90
 [<c106421a>] generic_file_buffered_write+0xca/0x210
 [<c10f0801>] xfs_file_buffered_aio_write+0xc1/0x110
 [<c10f092b>] xfs_file_aio_write+0xdb/0x140
 [<c108f677>] do_sync_write+0xb7/0xf0
 [<c108f5c0>] ? vfs_read+0x150/0x150
 [<c108f739>] vfs_write+0x89/0x150
 [<c108f5c0>] ? vfs_read+0x150/0x150
 [<c108f8c2>] sys_write+0x42/0x80
 [<c13255d4>] syscall_call+0x7/0xb
Code: 00 00 00 00 55 89 e5 83 ec 14 89 54 24 0c ba d8 20 3c c1 89 4c
24 10 89 44 24 08 89 54 24 04 c7 04 24 00 00 00 00 e8 d9 fd ff ff <0f>
0b 8d b4 26 00 00 00 00 55 b9 01 00 00 00 89 e5 83 ec 14 89
EIP: [<c10fbc57>] assfail+0x27/0x30 SS:ESP 0068:da5b5d5c
---[ end trace 0ea88b7b501c5efc ]---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
