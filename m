Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 17 Jul 2008 12:17:56 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6HJHrBV013946
	for <xfs@oss.sgi.com>; Thu, 17 Jul 2008 12:17:53 -0700
Received: from el-out-1112.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C8B0BE527CA
	for <xfs@oss.sgi.com>; Thu, 17 Jul 2008 12:19:00 -0700 (PDT)
Received: from el-out-1112.google.com (el-out-1112.google.com [209.85.162.183]) by cuda.sgi.com with ESMTP id oouXlBravPODVDSN for <xfs@oss.sgi.com>; Thu, 17 Jul 2008 12:19:00 -0700 (PDT)
Received: by el-out-1112.google.com with SMTP id v27so28843ele.23
        for <xfs@oss.sgi.com>; Thu, 17 Jul 2008 12:18:59 -0700 (PDT)
Message-ID: <19f34abd0807171218u3de86ddbt506b0b4fa0548406@mail.gmail.com>
Date: Thu, 17 Jul 2008 21:18:59 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: latest -git: kernel BUG at fs/xfs/support/debug.c:54!
In-Reply-To: <487F980F.7070708@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0807171046j425bebc6m8d8eb80a641e0e5b@mail.gmail.com>
	 <487F980F.7070708@redhat.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: Tim Shimmin <xfs-masters@oss.sgi.com>, xfs@oss.sgi.com, linux-kernel@vger.kernel.org, Johannes Weiner <hannes@saeurebad.de>

On Thu, Jul 17, 2008 at 9:05 PM, Eric Sandeen <sandeen@redhat.com> wrote:
>> Hi,
>>
>> I got this with an intentionally corrupted filesystem:
>>
>> Filesystem "loop1": Disabling barriers, not supported by the underlying device
>> XFS mounting filesystem loop1
>> Ending clean XFS mount for filesystem: loop1
>> Device loop1 - bad inode magic/vsn daddr 9680 #30 (magic=4946)
>> ------------[ cut here ]------------
>> kernel BUG at fs/xfs/support/debug.c:54!
>
> running a debug XFS will turn all sorts of tests into panics that would
> not otherwise crash and burn that way.
>
> I think normally when testing intentionally corrupted filesystems, you
> expect corruptions to be handled gracefully.  But in xfs's flavor of
> debug, I'm not sure it's quite as true.
>
> Perhaps the debug variant should not BUG() on disk corruption either,
> but it'd probably be more relevent to test this on a non-debug build.
>
> Does this corrupted fs survive better on non-debug xfs?

Thanks, you are right. I have adjusted my configuration, but I am
still able to produce this:

BUG: unable to handle kernel paging request at b62a66e0
IP: [<c030ef88>] xfs_alloc_fix_freelist+0x28/0x490
*pde = 00000000
Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
Pid: 4174, comm: rm Not tainted (2.6.26-03414-g33af79d #44)
EIP: 0060:[<c030ef88>] EFLAGS: 00210296 CPU: 0
EIP is at xfs_alloc_fix_freelist+0x28/0x490
EAX: f63e8830 EBX: f490a000 ECX: f48e8000 EDX: b62a66e0
ESI: 00000000 EDI: f48e9d8c EBP: f48e9d6c ESP: f48e9ccc
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process rm (pid: 4174, ti=f48e8000 task=f63d5fa0 task.ti=f48e8000)
Stack: 00000000 f63e8ac0 f63d5fa0 f63d64cc 00000002 00000000 f63d5fa0 f63e8830
       b62a66e0 f490a000 f73a3e10 c0b57c78 f49f2be0 c0ce8048 f49f24c0 00200046
       00000002 f48e9d20 c015908e f48e9d20 c01590cd f48e9d50 00200246 f63d6010
Call Trace:
 [<c015908e>] ? get_lock_stats+0x1e/0x50
 [<c01590cd>] ? put_lock_stats+0xd/0x30
 [<c030f453>] ? xfs_free_extent+0x63/0xd0
 [<c074955b>] ? down_read+0x5b/0x80
 [<c030f470>] ? xfs_free_extent+0x80/0xd0
 [<c0361f1a>] ? kmem_zone_alloc+0x7a/0xc0
 [<c0361f1a>] ? kmem_zone_alloc+0x7a/0xc0
 [<c03201ca>] ? xfs_bmap_finish+0x13a/0x180
 [<c03428d8>] ? xfs_itruncate_finish+0x1b8/0x400
 [<c035fa2b>] ? xfs_inactive+0x3bb/0x4e0
 [<c036b87a>] ? xfs_fs_clear_inode+0x8a/0xe0
 [<c01b962c>] ? clear_inode+0x7c/0x160
 [<c01b9c2e>] ? generic_delete_inode+0x10e/0x120
 [<c01b9d67>] ? generic_drop_inode+0x127/0x180
 [<c01b8be7>] ? iput+0x47/0x50
 [<c01af1bc>] ? do_unlinkat+0xec/0x170
 [<c0430938>] ? trace_hardirqs_on_thunk+0xc/0x10
 [<c0104174>] ? restore_nocheck_notrace+0x0/0xe
 [<c0430938>] ? trace_hardirqs_on_thunk+0xc/0x10
 [<c015ad76>] ? trace_hardirqs_on_caller+0x116/0x170
 [<c01af383>] ? sys_unlinkat+0x23/0x50
 [<c010407f>] ? sysenter_past_esp+0x78/0xc5
 =======================
Code: 8d 76 00 55 89 e5 57 89 c7 56 53 81 ec 94 00 00 00 8b 1f 89 95
70 ff ff ff 8b 57 0c 8b 40 04 89 5d 84 89 55 80 89 85 7c ff ff ff <80>
3a 00 0f 84 e7 02 00 00 c7 45 f0 00 00 00 00 8b 55 80 80 7a
EIP: [<c030ef88>] xfs_alloc_fix_freelist+0x28/0x490 SS:ESP 0068:f48e9ccc
Kernel panic - not syncing: Fatal exception

(Full log at http://folk.uio.no/vegardno/linux/log-1216322418.txt has
some more details.)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
