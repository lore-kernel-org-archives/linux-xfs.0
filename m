Received: from mail-oa1-f79.google.com (mail-oa1-f79.google.com [209.85.160.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 645CF3C5DB8
	for <linux-xfs@vger.kernel.org>; Wed, 15 Jul 2026 08:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784102616; cv=none; b=XcsSBqhsVLS9rjJ2n0U98wzdbe6mwraLBpYyVVAHJ6eMmw9PkJXGtOplAYU9imG5MFdV1YQ5QvWJAmQpV3TtV/RmB6ztSjaSLMMD56wppTDK0U228bsne5RrmkaW9inpsUxD9XJDkfxKqU8AofLYqAQCUAKmYkVfO2MgpzUp2pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784102616; c=relaxed/simple;
	bh=QnJ3npLe3Jq929+Dm8Rf71hPPa0sAuF+dxoDh604zJs=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=FAt6bG6tMkaee/iNpaz/0ZK6SPcvfbw2O/kocOWTOLRoPhd79k5j5j9IGag59rIxGiqWUxiCyEW5eA/4D3fqyCRm7RqpxaQ7CuzUly2tnzmlPyeUi0KkiScYf4k9bmHtR/uC5qu0JoiZ9yhWe17plAj2zoPV1Cypu1ITFe74kyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.160.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f79.google.com with SMTP id 586e51a60fabf-448bb8bcf38so5638072fac.1
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jul 2026 01:03:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784102612; x=1784707412;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8huaG1l+TqnhMbAmozHvzlPUkkyNYeXkjkEe0bSzewc=;
        b=LgglnyFw5vXYAR0m7aOQEa4139Af/g7S8Gv/nbLBV8bEjKESFyDiMCOORINNTz/SSC
         GsgRjWBC34P8lpU7YdK+JAC3p82eTz6WgiM88SWTxWTmNfzxLsLiHdZAmLqDR3Zbid/I
         1/2SM/42RdnnUiG1smrWEKgQKw+DOD5BkA/pIG0451Gb0C9IXwpZLCqmZlpAr6bgO/4k
         RZIqwn+wPVRwp06J5M1UoTZ/MOKecg7Hh6SKWEuR3KdmDpx7cb6nV+qFvVa/6fiFup8K
         QbyZOLRJHj7D6tnBI7CzR9uM1emt3v/m9ntKQ1CrioBtEKgEHJt5B+wjpyQbtWtXHXQn
         J8yg==
X-Forwarded-Encrypted: i=1; AHgh+RqUcANlNyWJrzemLNC0EOqJhqDwwV56Oc0TAM9KfNlRFb7kxcunUMl6jZ5QuQkRfGBURFZ8Nu0kA3M=@vger.kernel.org
X-Gm-Message-State: AOJu0YyJyIXNxK4ezF/uy5lvd7uVt/iSGIb7Mv+q6xCWvjubgShzVpWb
	s4ggBpvslrwryJ7oin4sa/bJilCy90uHRHxrKIG9aD355cx1VffLrgvfZfvL+uvwRT0EApiwjd/
	UtGoCnXaGTo9dkJGroMKqQbFTipySTHw+f7BHRSkvI7rUKz878YWeFXXq7bc=
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:13c5:b0:495:c597:aa59 with SMTP id
 5614622812f47-4a47a6c443bmr3917992b6e.28.1784102611986; Wed, 15 Jul 2026
 01:03:31 -0700 (PDT)
Date: Wed, 15 Jul 2026 01:03:31 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a573ed3.c90005c7.37d349.0044.GAE@google.com>
Subject: [syzbot] [xfs?] kernel BUG in xfs_buf_free
From: syzbot <syzbot+94c22d92f72f5a235b7d@syzkaller.appspotmail.com>
To: cem@kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    0f26556c5eee Merge tag 'nfsd-7.2-1' of git://git.kernel.or..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12497432580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=20c9876b0f77b546
dashboard link: https://syzkaller.appspot.com/bug?extid=94c22d92f72f5a235b7d
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-0f26556c.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/b2cc0fb490f4/vmlinux-0f26556c.xz
kernel image: https://storage.googleapis.com/syzbot-assets/89e3ca00a62a/bzImage-0f26556c.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+94c22d92f72f5a235b7d@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 32768
=======================================================
WARNING: The mand mount option has been deprecated and
         and is ignored by this kernel. Remove the mand
         option from the mount to silence this warning.
=======================================================
XFS (loop0): Mounting V5 Filesystem bfdc47fc-10d8-4eed-a562-11a831b3f791
XFS (loop0): Ending clean mount
XFS (loop0): Quotacheck needed: Please wait.
XFS (loop0): Quotacheck: Done.
FAULT_INJECTION: forcing a failure.
name fail_page_alloc, interval 1, probability 0, space 0, times 1
CPU: 0 UID: 0 PID: 5326 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 fail_dump lib/fault-inject.c:73 [inline]
 should_fail_ex+0x40c/0x560 lib/fault-inject.c:174
 prepare_alloc_pages+0x230/0x650 mm/page_alloc.c:5055
 __alloc_frozen_pages_noprof+0x12f/0x380 mm/page_alloc.c:5293
 alloc_pages_mpol+0x212/0x380 mm/mempolicy.c:2490
 folio_alloc_mpol_noprof+0x39/0x160 mm/mempolicy.c:2509
 shmem_alloc_folio mm/shmem.c:1907 [inline]
 shmem_alloc_and_add_folio+0x43e/0xf60 mm/shmem.c:1949
 shmem_get_folio_gfp+0x5da/0x16d0 mm/shmem.c:2502
 shmem_get_folio+0x86/0xb0 mm/shmem.c:2608
 xmbuf_map_backing_mem+0x1c4/0x590 fs/xfs/xfs_buf_mem.c:144
 xfs_buf_alloc_backing_mem fs/xfs/xfs_buf.c:216 [inline]
 xfs_buf_alloc+0xafe/0x19b0 fs/xfs/xfs_buf.c:322
 xfs_buf_find_insert+0x50/0x14e0 fs/xfs/xfs_buf.c:483
 xfs_buf_get_map+0x120f/0x17a0 fs/xfs/xfs_buf.c:584
 xfs_buf_get fs/xfs/xfs_buf.h:233 [inline]
 xfbtree_init_leaf_block+0x117/0x4a0 fs/xfs/libxfs/xfs_btree_mem.c:94
 xfbtree_init+0x1b6/0x450 fs/xfs/libxfs/xfs_btree_mem.c:147
 xrep_rmap_setup_scan+0xfb/0x1f0 fs/xfs/scrub/rmap_repair.c:1658
 xrep_rmapbt+0x3c/0xb0 fs/xfs/scrub/rmap_repair.c:1709
 xrep_attempt+0x184/0x7c0 fs/xfs/scrub/repair.c:78
 xfs_scrub_metadata+0xce4/0x1910 fs/xfs/scrub/scrub.c:747
 xfs_ioc_scrubv_metadata+0x7ac/0xb70 fs/xfs/scrub/scrub.c:981
 xfs_file_ioctl+0x916/0x1590 fs/xfs/xfs_ioctl.c:1308
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f3b9ef9de59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f3b9fdf9fe8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f3b9f225fa0 RCX: 00007f3b9ef9de59
RDX: 0000200000000000 RSI: 00000000c0285840 RDI: 0000000000000008
RBP: 00007f3b9fdfa050 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000002
R13: 00007f3b9f226038 R14: 00007f3b9f225fa0 R15: 00007ffedc4d4158
 </TASK>
------------[ cut here ]------------
kernel BUG at arch/x86/mm/physaddr.c:28!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5326 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:__phys_addr+0xf7/0x100 arch/x86/mm/physaddr.c:28
Code: c7 c9 8e 57 90 e8 29 e1 bc 00 eb 8b 48 c7 c7 f0 0f 9c 8e 48 89 de 48 89 ca 49 89 ce e8 92 d9 98 03 4c 89 f1 e9 7b ff ff ff 90 <0f> 0b 90 0f 0b 0f 1f 40 00 90 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 0018:ffffc9000f2ff150 EFLAGS: 00010206
RAX: 1ffffffff1c9e7e0 RBX: 0000778000000000 RCX: 0000000000000000
RDX: ffff888038c28000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffffff9057a4f7 R09: 1ffffffff20af49e
R10: dffffc0000000000 R11: fffffbfff20af49f R12: ffffea0000000000
R13: dffffc0000000000 R14: 0000000080000000 R15: dffffc0000000000
FS:  00007f3b9fdfa6c0(0000) GS:ffff88808c54a000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f3b9fd5d9d0 CR3: 000000003f04d000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 virt_to_folio include/linux/mm.h:1944 [inline]
 xfs_buf_free+0x25a/0x510 fs/xfs/xfs_buf.c:118
 xfs_buf_alloc+0xc93/0x19b0 fs/xfs/xfs_buf.c:324
 xfs_buf_find_insert+0x50/0x14e0 fs/xfs/xfs_buf.c:483
 xfs_buf_get_map+0x120f/0x17a0 fs/xfs/xfs_buf.c:584
 xfs_buf_get fs/xfs/xfs_buf.h:233 [inline]
 xfbtree_init_leaf_block+0x117/0x4a0 fs/xfs/libxfs/xfs_btree_mem.c:94
 xfbtree_init+0x1b6/0x450 fs/xfs/libxfs/xfs_btree_mem.c:147
 xrep_rmap_setup_scan+0xfb/0x1f0 fs/xfs/scrub/rmap_repair.c:1658
 xrep_rmapbt+0x3c/0xb0 fs/xfs/scrub/rmap_repair.c:1709
 xrep_attempt+0x184/0x7c0 fs/xfs/scrub/repair.c:78
 xfs_scrub_metadata+0xce4/0x1910 fs/xfs/scrub/scrub.c:747
 xfs_ioc_scrubv_metadata+0x7ac/0xb70 fs/xfs/scrub/scrub.c:981
 xfs_file_ioctl+0x916/0x1590 fs/xfs/xfs_ioctl.c:1308
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f3b9ef9de59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f3b9fdf9fe8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f3b9f225fa0 RCX: 00007f3b9ef9de59
RDX: 0000200000000000 RSI: 00000000c0285840 RDI: 0000000000000008
RBP: 00007f3b9fdfa050 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000002
R13: 00007f3b9f226038 R14: 00007f3b9f225fa0 R15: 00007ffedc4d4158
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__phys_addr+0xf7/0x100 arch/x86/mm/physaddr.c:28
Code: c7 c9 8e 57 90 e8 29 e1 bc 00 eb 8b 48 c7 c7 f0 0f 9c 8e 48 89 de 48 89 ca 49 89 ce e8 92 d9 98 03 4c 89 f1 e9 7b ff ff ff 90 <0f> 0b 90 0f 0b 0f 1f 40 00 90 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 0018:ffffc9000f2ff150 EFLAGS: 00010206
RAX: 1ffffffff1c9e7e0 RBX: 0000778000000000 RCX: 0000000000000000
RDX: ffff888038c28000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffffff9057a4f7 R09: 1ffffffff20af49e
R10: dffffc0000000000 R11: fffffbfff20af49f R12: ffffea0000000000
R13: dffffc0000000000 R14: 0000000080000000 R15: dffffc0000000000
FS:  00007f3b9fdfa6c0(0000) GS:ffff88808c54a000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f3b9f1ea0b0 CR3: 000000003f04d000 CR4: 0000000000352ef0


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
