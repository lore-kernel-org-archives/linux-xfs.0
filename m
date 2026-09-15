Received: from mail-oo2-f7.google.com (mail-oo2-f7.google.com [74.125.231.135])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BB803DBD53
	for <linux-xfs@vger.kernel.org>; Tue, 15 Sep 2026 03:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.135
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789443625; cv=none; b=O8bZkrbKyVz7Epxu8nyWiTTtwx6OtNn/jUuOCm4sVynilB43ljm9FqiKWBVWqbB+2oNWzE993tU0djRIALQ8JKD70ZRDXFP5sg/Nlbrvl6DKz/XRdWWgIczHMRQwht4AxIYvYndkn4YDq6ryIXTCFRj1TwQGQ+dy3d90OmGHRIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789443625; c=relaxed/simple;
	bh=ZcY6JPh1zNj4rkC+lrc3gFdD95dTdXZZkhUPw7qCTRw=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=GLX3RAe4K/wcpeD/UavgYr0h5tua4uRs6c2kIBKpoegUzV5Z1k8BJ85xrpx4uaGAbN05Ky1DMYTWkWDTRmtZY990RiLP21JsD+V9/96OoFQ8hAcK9UUaU2c+x2/wjyJr8nZ1Dxm0F4tewrPJdkdJrwpSHc9liiH6A2H7yj1IdAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=74.125.231.135
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo2-f7.google.com with SMTP id 006d021491bc7-6b1bebb3ae8so1581218eaf.1
        for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 20:40:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789443622; x=1790048422;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ATIiePy97NGhXTC8rWXIR2/eUm2iTgVkiucL0AeqS2c=;
        b=BLD83jhcCpPrREulMC+ScBSv3FDMjyOGor73qCYNSeJuO5NKVzKmh3kYof6eJHW1Nm
         ppzEaicmheopwKSLXVsjlwcy86/7Wc+EP7d/anKDnTKTTMHTfpIgTB84/fDHtfy8bV99
         TxLh1ZQCktOyZFV0k2MBjIJn8Nzafook1TcVMiHcIHhatOwURTS/+PtgD/5VtDNdLxu9
         3Nc7bdOUGbPGjhfj060wmIWVF5bIJ15WLznDoRfR6trMqfoNZYX4plutH5LCLzAAmwwl
         dR1WFa5UpZaxNFl8JBSmyrtOgr9hVCrSKXHu3+v/sHAd9zyh++ha2PPoYMhF1gcd4xcF
         jb9w==
X-Forwarded-Encrypted: i=1; AKwUvBzDzJ5lJ9P9auOI1KgG0E9Cw3VePSQkCmpPZl3YSygoJVtniBHacvK9AYfpp1OE0x7FyqvdoMy6fIM=@vger.kernel.org
X-Gm-Message-State: AFuF++mWFrqmUpd4mrmXvsAE/9smxCiye3B0lQXdRNEAUoIyHyCiVrOh
	zT18TzP/en8/EbsY5YKwUZKwkk7OqCnR17iHLMMkEmUUR89dK6KMVCh3ZqG0HJ9X1X6ZqZYU5kP
	7SHlY5KU3K95UzwAp0RJ9lQVrLLJVR62OYAylRuWht102kyOX5u3kYlGwhdw=
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1988:b0:6c1:fd93:5292 with SMTP id
 006d021491bc7-6c541d3ff08mr6133761eaf.17.1789443622633; Mon, 14 Sep 2026
 20:40:22 -0700 (PDT)
Date: Mon, 14 Sep 2026 20:40:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6aa8be26.a211d2ce.1a5198.02a4.GAE@google.com>
Subject: [syzbot] [iomap?] WARNING in iomap_read_inline_data (2)
From: syzbot <syzbot+079e16bc964fb91acb4a@syzkaller.appspotmail.com>
To: brauner@kernel.org, djwong@kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    50d05c7c76c9 Merge tag 'landlock-7.3-rc3' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15f67749580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e909ffe6b35dddb7
dashboard link: https://syzkaller.appspot.com/bug?extid=079e16bc964fb91acb4a
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-50d05c7c.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/f17e999d8f8c/vmlinux-50d05c7c.xz
kernel image: https://storage.googleapis.com/syzbot-assets/c22ded366230/bzImage-50d05c7c.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+079e16bc964fb91acb4a@syzkaller.appspotmail.com

------------[ cut here ]------------
size > iomap->length
WARNING: fs/iomap/buffered-io.c:431 at iomap_read_inline_data+0xa7b/0xc40 fs/iomap/buffered-io.c:431, CPU#0: syz.0.0/5317
Modules linked in:
CPU: 0 UID: 0 PID: 5317 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:iomap_read_inline_data+0xa7b/0xc40 fs/iomap/buffered-io.c:431
Code: 48 83 c4 58 5b 41 5c 41 5d 41 5e 41 5f 5d e9 0c 45 78 09 cc e8 46 17 56 ff 90 0f 0b 90 bd fb ff ff ff eb da e8 36 17 56 ff 90 <0f> 0b 90 48 bb 00 00 00 00 00 fc ff df 48 8b 44 24 10 80 3c 18 00
RSP: 0018:ffffc9000e5172d8 EFLAGS: 00010293
RAX: ffffffff8271c46a RBX: ffffc9000e517538 RCX: ffff88803ecccb00
RDX: 0000000000000000 RSI: 0000000000000015 RDI: 0000000000000200
RBP: 0000000000001000 R08: ffffea00004e0fc7 R09: 1ffffd400009c1f8
R10: dffffc0000000000 R11: fffff9400009c1f9 R12: ffffc9000e5174e0
R13: ffffea00004e0fc0 R14: 0000000000000015 R15: 1ffff92001ca2ea7
FS:  00007fe7bb50d6c0(0000) GS:ffff88808c2c7000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f481c6085a1 CR3: 000000001201b000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 iomap_read_folio_iter+0x30d/0xe80 fs/iomap/buffered-io.c:571
 iomap_read_folio+0x58b/0x970 fs/iomap/buffered-io.c:676
 ntfs_read_folio+0x3f1/0x4b0 fs/ntfs3/inode.c:856
 filemap_read_folio+0x12c/0x3a0 mm/filemap.c:2520
 filemap_fault+0xd06/0x13b0 mm/filemap.c:3689
 __do_fault+0x138/0x2a0 mm/memory.c:5565
 do_shared_fault mm/memory.c:6064 [inline]
 do_fault mm/memory.c:6138 [inline]
 do_pte_missing+0x684/0x34b0 mm/memory.c:4700
 handle_pte_fault mm/memory.c:6558 [inline]
 __handle_mm_fault mm/memory.c:6707 [inline]
 handle_mm_fault+0x1a53/0x3750 mm/memory.c:6876
 do_user_addr_fault+0x746/0x1340 arch/x86/mm/fault.c:1394
 handle_page_fault arch/x86/mm/fault.c:1483 [inline]
 exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1536
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:595
RIP: 0010:__put_user_4+0xd/0x30 arch/x86/lib/putuser.S:94
Code: 66 89 01 31 c9 0f 01 ca c3 cc cc cc cc 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 48 89 cb 48 c1 fb 3f 48 09 d9 0f 01 cb <89> 01 31 c9 0f 01 ca e9 c7 95 03 00 90 90 90 90 90 90 90 90 90 90
RSP: 0018:ffffc9000e517e50 EFLAGS: 00050246
RAX: 000000000000002a RBX: 0000000000000000 RCX: 0000000000000000
RDX: 00000000085a7cfd RSI: ffffffff8e702abd RDI: ffffffff8c6dba80
RBP: 000000000000002a R08: ffffffff82205d8f R09: 0000000000000000
R10: dffffc0000000000 R11: ffffed1003a3b181 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000001 R15: 0000000000000005
 __sys_socketpair+0xb7/0x560 net/socket.c:1868
 __do_sys_socketpair net/socket.c:1934 [inline]
 __se_sys_socketpair net/socket.c:1931 [inline]
 __x64_sys_socketpair+0x9b/0xb0 net/socket.c:1931
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fe7ba59e159
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fe7bb50cfe8 EFLAGS: 00000246 ORIG_RAX: 0000000000000035
RAX: ffffffffffffffda RBX: 00007fe7ba826180 RCX: 00007fe7ba59e159
RDX: 0000000000000000 RSI: 0000000000000005 RDI: 0000000000000001
RBP: 00007fe7ba63503b R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fe7ba826218 R14: 00007fe7ba826180 R15: 00007ffc20525218
 </TASK>
----------------
Code disassembly (best guess):
   0:	66 89 01             	mov    %ax,(%rcx)
   3:	31 c9                	xor    %ecx,%ecx
   5:	0f 01 ca             	clac
   8:	c3                   	ret
   9:	cc                   	int3
   a:	cc                   	int3
   b:	cc                   	int3
   c:	cc                   	int3
   d:	90                   	nop
   e:	90                   	nop
   f:	90                   	nop
  10:	90                   	nop
  11:	90                   	nop
  12:	90                   	nop
  13:	90                   	nop
  14:	90                   	nop
  15:	90                   	nop
  16:	90                   	nop
  17:	90                   	nop
  18:	90                   	nop
  19:	90                   	nop
  1a:	90                   	nop
  1b:	90                   	nop
  1c:	90                   	nop
  1d:	48 89 cb             	mov    %rcx,%rbx
  20:	48 c1 fb 3f          	sar    $0x3f,%rbx
  24:	48 09 d9             	or     %rbx,%rcx
  27:	0f 01 cb             	stac
* 2a:	89 01                	mov    %eax,(%rcx) <-- trapping instruction
  2c:	31 c9                	xor    %ecx,%ecx
  2e:	0f 01 ca             	clac
  31:	e9 c7 95 03 00       	jmp    0x395fd
  36:	90                   	nop
  37:	90                   	nop
  38:	90                   	nop
  39:	90                   	nop
  3a:	90                   	nop
  3b:	90                   	nop
  3c:	90                   	nop
  3d:	90                   	nop
  3e:	90                   	nop
  3f:	90                   	nop


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
