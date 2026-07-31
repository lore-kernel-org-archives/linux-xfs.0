Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADAF83F822F
	for <linux-xfs@vger.kernel.org>; Fri, 31 Jul 2026 11:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785498076; cv=none; b=gvUnZL2+ctABvbsrUMN2mmmhhJ6MRyLwVcVPhhZtLKEtw3NSm48h5aPVONJGLy0ynmeGkWVzkPFg/txlVjYh6if76vl9wtZshQhtv/Z3Zt1QnpXfNASJMv+WoMjYjNtnUqh0cZABPrztWCKDaPoWNBIzy+kI+bHRJTwCtsMuqsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785498076; c=relaxed/simple;
	bh=e2vjSttxcoNtyW6JrbhYTnqq7Pxo0YsnVImfEbqlRQk=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=cGMTzpiml007vcfXLKRB42SVJIxSdAJAK3NiKWVzf4z7tnusnA4f1LbgRxK0HzFlhpVga1FLG+rb+zSZEgC2zVE0cbHqBF7e4vHb7Mwdj37HWnboBVdwbcdB25ZOdDBJDmG+3zIsZqpSWiRdrhQIvQUmqewiXTqLTGN1mEqoj3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4ab4f652f9bso617514b6e.0
        for <linux-xfs@vger.kernel.org>; Fri, 31 Jul 2026 04:41:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785498073; x=1786102873;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=m8VUZ3s3LYwXHsVpWfjVPQGrgQzqZfc/ZafskNEpMqk=;
        b=bzMZi6A6MwSW3ZWL/dbGGmM4sezD/xNo8b6wVl6UcWjnHKMpkqZO5hKvtawfVoi09e
         N7BUbln4/Kpe406y2t9OAr8CToJNkb6npOS+vGTzeZTzdCANI4cR1Kc+/K6IToeylPr1
         FECyjqVtSCJ5C+19HHEJE6KTgZo0/ZLrBG/ZEi4KZrpSQ/fCkMOV8xu6jUjtSUr4Nxr1
         FpyOmPj7TF6TyIvKDexKhDkJRUp0i2AN7nFlQHz5sRCSrRVNwvq3IO2NhyxVtNjumNsM
         CyZ06CDg/f+69uAbQHuSRh3YWlB4kq30M0phIkKbMkhMmhF2ql59Frhjc1UgyI0C0CGH
         aejg==
X-Forwarded-Encrypted: i=1; AHgh+RpdL3eZLxZ8LNfmbKlVmwb+sp18O6gSWjai3q30DC63Mw9SmNtq721U2mjnpu63J4mAArj/CbPke3s=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzj/NYWzvsyOtNjrgdV+rEGHpUHxP2psFNzxsBEtMsKQKrA9PVb
	4uINi+65YOMkz15Bl//WwSH7SX+WHkh4rRzHngTAfoaE3qXiyJB517lDzCoWthEt7quS+bSD+jl
	9Ky9kR0FAZY0IzcVaqlV2RJra6GFxIDxuW6DbfI+7tvaMPgPdY7LgA5TtVgU=
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:10cc:b0:4a4:c12:49d9 with SMTP id
 5614622812f47-4ae4c4de8a7mr1992011b6e.3.1785498073711; Fri, 31 Jul 2026
 04:41:13 -0700 (PDT)
Date: Fri, 31 Jul 2026 04:41:13 -0700
In-Reply-To: <e69cc8a4a9c3f641b97872b50f04c397880077cd.1785374485.git.wqu@suse.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a6c89d9.77639fcc.3d4fd0.0026.GAE@google.com>
Subject: [syzbot ci] Re: iomap: follow the alignment requirement for iomap_dio_hole_iter()
From: syzbot ci <syzbot+ci731b4119b755b229@syzkaller.appspotmail.com>
To: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, wqu@suse.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] iomap: follow the alignment requirement for iomap_dio_hole_iter()
https://lore.kernel.org/all/e69cc8a4a9c3f641b97872b50f04c397880077cd.1785374485.git.wqu@suse.com
* [PATCH] iomap: follow the alignment requirement for iomap_dio_hole_iter()

and found the following issue:
general protection fault in __iomap_dio_rw

Full report is available here:
https://ci.syzbot.org/series/81e0fbae-4715-4d62-8e9e-bcd19e46b164

***

general protection fault in __iomap_dio_rw

tree:      vfs
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/vfs/vfs.git
base:      70c2cbf8600c7d3a622b77e31136b83d6ac7d86c
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/8d5fee65-291c-46a2-9f9a-d512f8fad82b/config
syz repro: https://ci.syzbot.org/findings/c9f79a18-3316-44ec-b805-b805b1c49325/syz_repro

loop0: rw=2049, sector=53248, nr_sectors = 976 limit=40427
Oops: general protection fault, probably for non-canonical address 0xdffffc0000000003: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000018-0x000000000000001f]
CPU: 0 UID: 0 PID: 5842 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:bdev_get_queue include/linux/blkdev.h:1058 [inline]
RIP: 0010:bdev_logical_block_size include/linux/blkdev.h:1403 [inline]
RIP: 0010:iomap_dio_alignment fs/iomap/direct-io.c:415 [inline]
RIP: 0010:iomap_dio_hole_iter fs/iomap/direct-io.c:595 [inline]
RIP: 0010:iomap_dio_iter fs/iomap/direct-io.c:643 [inline]
RIP: 0010:__iomap_dio_rw+0x1142/0x2130 fs/iomap/direct-io.c:815
Code: e2 5a ff 83 e3 08 75 5c e8 ab de 5a ff 48 8b 9c 24 68 01 00 00 48 83 c3 18 48 89 d8 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <80> 3c 08 00 74 08 48 89 df e8 d0 75 c8 ff 48 8b 1b b8 58 01 00 00
RSP: 0018:ffffc90003fef560 EFLAGS: 00010206
RAX: 0000000000000003 RBX: 0000000000000018 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc90003fef860 R08: ffff8881148d8fff R09: 0000000000000000
R10: ffff8881148d8000 R11: ffffed102291b200 R12: 1ffff920007fdecc
R13: 0000000000000000 R14: ffff888166b45340 R15: 0000000000001000
FS:  00007fd77743d6c0(0000) GS:ffff88818d951000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000078000 CR3: 000000011606a000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 f2fs_dio_read_iter fs/f2fs/file.c:4887 [inline]
 f2fs_file_read_iter+0x60b/0x940 fs/f2fs/file.c:4950
 copy_splice_read+0x5ff/0xaa0 fs/splice.c:362
 do_splice_read fs/splice.c:979 [inline]
 splice_direct_to_actor+0x4b6/0xcb0 fs/splice.c:1084
 do_splice_direct_actor fs/splice.c:1202 [inline]
 do_splice_direct+0x195/0x290 fs/splice.c:1228
 do_sendfile+0x52e/0x7c0 fs/read_write.c:1371
 __do_sys_sendfile64 fs/read_write.c:1432 [inline]
 __se_sys_sendfile64+0x144/0x1a0 fs/read_write.c:1418
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fd77659df99
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fd77743d028 EFLAGS: 00000246 ORIG_RAX: 0000000000000028
RAX: ffffffffffffffda RBX: 00007fd776825fa0 RCX: 00007fd77659df99
RDX: 0000000000000000 RSI: 0000000000000004 RDI: 0000000000000004
RBP: 00007fd776634ec4 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000800000009 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fd776826038 R14: 00007fd776825fa0 R15: 00007fff168f4a18
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:bdev_get_queue include/linux/blkdev.h:1058 [inline]
RIP: 0010:bdev_logical_block_size include/linux/blkdev.h:1403 [inline]
RIP: 0010:iomap_dio_alignment fs/iomap/direct-io.c:415 [inline]
RIP: 0010:iomap_dio_hole_iter fs/iomap/direct-io.c:595 [inline]
RIP: 0010:iomap_dio_iter fs/iomap/direct-io.c:643 [inline]
RIP: 0010:__iomap_dio_rw+0x1142/0x2130 fs/iomap/direct-io.c:815
Code: e2 5a ff 83 e3 08 75 5c e8 ab de 5a ff 48 8b 9c 24 68 01 00 00 48 83 c3 18 48 89 d8 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <80> 3c 08 00 74 08 48 89 df e8 d0 75 c8 ff 48 8b 1b b8 58 01 00 00
RSP: 0018:ffffc90003fef560 EFLAGS: 00010206
RAX: 0000000000000003 RBX: 0000000000000018 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc90003fef860 R08: ffff8881148d8fff R09: 0000000000000000
R10: ffff8881148d8000 R11: ffffed102291b200 R12: 1ffff920007fdecc
R13: 0000000000000000 R14: ffff888166b45340 R15: 0000000000001000
FS:  00007fd77743d6c0(0000) GS:ffff8882a8f51000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007faa8f64dc80 CR3: 000000011606a000 CR4: 00000000000006f0
----------------
Code disassembly (best guess):
   0:	e2 5a                	loop   0x5c
   2:	ff 83 e3 08 75 5c    	incl   0x5c7508e3(%rbx)
   8:	e8 ab de 5a ff       	call   0xff5adeb8
   d:	48 8b 9c 24 68 01 00 	mov    0x168(%rsp),%rbx
  14:	00
  15:	48 83 c3 18          	add    $0x18,%rbx
  19:	48 89 d8             	mov    %rbx,%rax
  1c:	48 c1 e8 03          	shr    $0x3,%rax
  20:	48 b9 00 00 00 00 00 	movabs $0xdffffc0000000000,%rcx
  27:	fc ff df
* 2a:	80 3c 08 00          	cmpb   $0x0,(%rax,%rcx,1) <-- trapping instruction
  2e:	74 08                	je     0x38
  30:	48 89 df             	mov    %rbx,%rdi
  33:	e8 d0 75 c8 ff       	call   0xffc87608
  38:	48 8b 1b             	mov    (%rbx),%rbx
  3b:	b8 58 01 00 00       	mov    $0x158,%eax


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a patch for this bug, please reply with `#syz test`
(should be on a separate line).

The patch should be attached to the email.
Note: arguments like custom git repos and branches are not supported.
