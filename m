Received: from mail-oo1-f79.google.com (mail-oo1-f79.google.com [209.85.161.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A455735F8DA
	for <linux-xfs@vger.kernel.org>; Wed, 17 Dec 2025 15:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765983993; cv=none; b=Nxod5w0cJC/vI+TdKMEwWV4o9+9uNKy0UHBCJ0YWBqht8YHLLzrD5iIh3V/szbBXkGqFUTnHfop/MuR9B/jKzLgcPlQvdF9J5EPof1JGfsweDY+FpW4FhorltRL0WqyGuteU0WxS3U9cfDRUpJad9rwF7P+7SgcaVOoifDgg2sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765983993; c=relaxed/simple;
	bh=guTVx0EHN1D1Uhou4Rx7F0yW/ZXIS6CzojBXCRNbR1g=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=NQSBysv9swUxJ++ko0Jf5Brnw9tJ20cFCtUFYTM4ghJTnUoJ30BhKvokMbeEEJS9uTu0y/uxMzFkox1r/u97kL+CUeqPVTsCw49qrMsQbsB4PUxjOMbbaZAXWZi5o2aAqhVgWJV/Lx3+fhlAAOrlC3yaWMgx45gKlDkiiQ3SBZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f79.google.com with SMTP id 006d021491bc7-656b2edce07so9199985eaf.0
        for <linux-xfs@vger.kernel.org>; Wed, 17 Dec 2025 07:06:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765983989; x=1766588789;
        h=content-transfer-encoding:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+LXp+/OiwgJFK4+HBN1KxSKPTjJfUuQ79kirzdSqjQA=;
        b=ME5rmq+9jcI8R7P3IzrVUB4xZsO37WeQLwHq5Ra10hbzsO18DrbFULtZfTYoFMUF9n
         aoNK12l4MO+5enolZql5DJKyls/BawGa9B2WwPS6E7UkOKrjTnofm2xV7jKP7jdag8rJ
         ouND22VrumN+6lXgttduSlAJ7PXdH1KlZxTzaddVIiGWFL8sKnCDw/si3hPYYiMe8vqb
         Dtsas9jrVow8jFNgM1ksdR2V2aGtoHuJ64Lzl1AQO9+N2lFL3XoSXsb3qd6IXBDbDq8/
         UFvFX1yp90Z/39no8kfzvV5JQqwXwJ+RGLaHduzElO0AvfCskboQKcvSb6sgRBL6yHF3
         gsgw==
X-Forwarded-Encrypted: i=1; AJvYcCXefqFLSNIb46wFkHeg12Nwve8VZMJIidVsVK7kK3RT44arkc0q2e1e9NvSwsY8uL5AJjhcsCuJPx0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxjrpW4acMfK69SqwyJZpZ1MVj2chbFaBcdLvMNXW4k/QnO1R2e
	zwi9Lx9F7/uxRb21RXk/Hauz5/9HOmZULayvQRS9iIR+3jBvCAOslFTEYbP7iNU/DtvktbuSrtx
	CU/gH0WibUQMJ/HXLKxi+T9S90JylHPNPUmecmWNQ6KJQ8SljUlQ2BIyz0p8=
X-Google-Smtp-Source: AGHT+IEepE1vOkZRfZw65Yq1mLKX8fjSXWFd+RCC7vexsDa9QIOBmOOjGkoOx7rg/oWkXOnGdoUhwKHlpGYWuc7/8UmLqU7NJZSW
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4df7:b0:659:9a49:8f11 with SMTP id
 006d021491bc7-65b45151581mr7967725eaf.34.1765983989465; Wed, 17 Dec 2025
 07:06:29 -0800 (PST)
Date: Wed, 17 Dec 2025 07:06:29 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6942c6f5.a70a0220.207337.0063.GAE@google.com>
Subject: [syzbot] [xfs] general protection fault in workingset_refault (3)
From: syzbot <syzbot+ccf9f05f06b4b951f3cd@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, axelrasmussen@google.com, cem@kernel.org, 
	david@kernel.org, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-xfs@vger.kernel.org, lorenzo.stoakes@oracle.com, 
	mhocko@kernel.org, shakeel.butt@linux.dev, syzkaller-bugs@googlegroups.com, 
	weixugc@google.com, yuanchu@google.com, zhengqi.arch@bytedance.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

syzbot found the following issue on:

HEAD commit:    ea1013c15392 Merge tag 'bpf-fixes' of git://git.kernel.org.=
.
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=3D16a839b4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3D513255d80ab78f2=
b
dashboard link: https://syzkaller.appspot.com/bug?extid=3Dccf9f05f06b4b951f=
3cd
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-=
1~exp1~20250708183702.136), Debian LLD 20.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d90=
0f083ada3/non_bootable_disk-ea1013c1.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/ea4d0b50128d/vmlinux-=
ea1013c1.xz
kernel image: https://storage.googleapis.com/syzbot-assets/f2e7f1524121/bzI=
mage-ea1013c1.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit=
:
Reported-by: syzbot+ccf9f05f06b4b951f3cd@syzkaller.appspotmail.com

Zero length message leads to an empty skb
loop0: detected capacity change from 0 to 32768
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
WARNING: The mand mount option has been deprecated and
         and is ignored by this kernel. Remove the mand
         option from the mount to silence this warning.
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
xfs: Unknown parameter '=EF=BF=BD=04'
Oops: general protection fault, probably for non-canonical address 0xdffffc=
00000009c0: 0000 [#1] SMP KASAN NOPTI
KASAN: probably user-memory-access in range [0x0000000000004e00-0x000000000=
0004e07]
CPU: 0 UID: 0 PID: 5343 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full=
)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16=
.3-2~bpo12+1 04/01/2014
RIP: 0010:mem_cgroup_lruvec include/linux/memcontrol.h:720 [inline]
RIP: 0010:lru_gen_test_recent mm/workingset.c:275 [inline]
RIP: 0010:lru_gen_refault mm/workingset.c:296 [inline]
RIP: 0010:workingset_refault+0x3f8/0x1170 mm/workingset.c:546
Code: 74 0c 48 c7 c7 e0 6a a2 8f e8 04 05 1d 00 4c 8b 35 3d c7 95 0d 49 81 =
c6 78 0c 00 00 4d 8d bd 00 4e 00 00 4c 89 f8 48 c1 e8 03 <42> 0f b6 04 20 8=
4 c0 0f 85 ce 05 00 00 49 63 07 4d 8d 34 c6 4c 89
RSP: 0018:ffffc9000a7b7880 EFLAGS: 00010206
RAX: 00000000000009c0 RBX: 0000000000000383 RCX: 0000000000100000
RDX: ffffc900208d2000 RSI: 0000000000000472 RDI: 0000000000000473
RBP: ffffc9000a7b7998 R08: ffff88801f7524c0 R09: 0000000000000002
R10: 0000000000000406 R11: 0000000000000002 R12: dffffc0000000000
R13: 0000000000000000 R14: ffff88801baf8c78 R15: 0000000000004e00
FS:  00007fbc75e8f6c0(0000) GS:ffff88808d22a000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000000040 CR3: 000000001234e000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 filemap_add_folio+0x33f/0x540 mm/filemap.c:981
 do_read_cache_folio+0x32e/0x590 mm/filemap.c:4063
 freader_get_folio+0x3c7/0x830 lib/buildid.c:58
 freader_fetch+0xa3/0x750 lib/buildid.c:101
 __build_id_parse+0x133/0x7d0 lib/buildid.c:289
 do_procmap_query fs/proc/task_mmu.c:733 [inline]
 procfs_procmap_ioctl+0x76f/0xce0 fs/proc/task_mmu.c:813
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fbc74f8f7c9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fbc75e8f038 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007fbc751e5fa0 RCX: 00007fbc74f8f7c9
RDX: 0000200000000180 RSI: 00000000c0686611 RDI: 000000000000000d
RBP: 00007fbc75013f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fbc751e6038 R14: 00007fbc751e5fa0 R15: 00007fff29f355e8
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:mem_cgroup_lruvec include/linux/memcontrol.h:720 [inline]
RIP: 0010:lru_gen_test_recent mm/workingset.c:275 [inline]
RIP: 0010:lru_gen_refault mm/workingset.c:296 [inline]
RIP: 0010:workingset_refault+0x3f8/0x1170 mm/workingset.c:546
Code: 74 0c 48 c7 c7 e0 6a a2 8f e8 04 05 1d 00 4c 8b 35 3d c7 95 0d 49 81 =
c6 78 0c 00 00 4d 8d bd 00 4e 00 00 4c 89 f8 48 c1 e8 03 <42> 0f b6 04 20 8=
4 c0 0f 85 ce 05 00 00 49 63 07 4d 8d 34 c6 4c 89
RSP: 0018:ffffc9000a7b7880 EFLAGS: 00010206
RAX: 00000000000009c0 RBX: 0000000000000383 RCX: 0000000000100000
RDX: ffffc900208d2000 RSI: 0000000000000472 RDI: 0000000000000473
RBP: ffffc9000a7b7998 R08: ffff88801f7524c0 R09: 0000000000000002
R10: 0000000000000406 R11: 0000000000000002 R12: dffffc0000000000
R13: 0000000000000000 R14: ffff88801baf8c78 R15: 0000000000004e00
FS:  00007fbc75e8f6c0(0000) GS:ffff88808d22a000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f9f4cc08120 CR3: 000000001234e000 CR4: 0000000000352ef0
----------------
Code disassembly (best guess):
   0:	74 0c                	je     0xe
   2:	48 c7 c7 e0 6a a2 8f 	mov    $0xffffffff8fa26ae0,%rdi
   9:	e8 04 05 1d 00       	call   0x1d0512
   e:	4c 8b 35 3d c7 95 0d 	mov    0xd95c73d(%rip),%r14        # 0xd95c752
  15:	49 81 c6 78 0c 00 00 	add    $0xc78,%r14
  1c:	4d 8d bd 00 4e 00 00 	lea    0x4e00(%r13),%r15
  23:	4c 89 f8             	mov    %r15,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	42 0f b6 04 20       	movzbl (%rax,%r12,1),%eax <-- trapping instruct=
ion
  2f:	84 c0                	test   %al,%al
  31:	0f 85 ce 05 00 00    	jne    0x605
  37:	49 63 07             	movslq (%r15),%rax
  3a:	4d 8d 34 c6          	lea    (%r14,%rax,8),%r14
  3e:	4c                   	rex.WR
  3f:	89                   	.byte 0x89


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
