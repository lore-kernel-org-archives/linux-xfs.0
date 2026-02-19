Received: from mail-oa1-f72.google.com (mail-oa1-f72.google.com [209.85.160.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8F7030DEB5
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 20:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771534289; cv=none; b=lAT1gfUEkLRjbZ/5216juKT5HrrrgPUTfZkqsdyT9Sqh0UFmb1OSnRVH0dKA7UugEDfSEUaCZjPVoXF/BOnRw/CR/PJjv2QrreZX3SgFeE86IKftibWNSmA+dsE7CCWz0w9kZDlclwRbIzAYaso+nOKoHRKm6DnsHYXnzamjPpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771534289; c=relaxed/simple;
	bh=bhTCVlVvMiw/CS5qSjmp96mJm0jg9pUbJJAGN51ggDU=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=Qcby13dDjqO6EUWFOe0WAoKE1RIyv+QNh1XqhzLBG/tgP/el74kXdZP46FGqJjLzjIXXBXR0RWublCS7XifmysLr5BVhYOa4d2O/hI1CiITw5lAsEQ3S3qnqKfJ1bpZJE26ldiwJyYs46dum29+VDsPC+pac6gMvRq8pU5N3wRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.160.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f72.google.com with SMTP id 586e51a60fabf-40450320b4fso6676364fac.0
        for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 12:51:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771534287; x=1772139087;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QJjfOm3xHv1STTMig9wkib+KS54oRvgqT9llxyCjsmo=;
        b=gfdC4WTdvMdUyMWoR8Xk056D1ryv9tLq6HD/KnYhpjjvxtCaTaIYvztkDpS9oj7gQ/
         CcUk/rK3qlzsZgtoFvLM4h0mcNv6JJ94lnmCTGV0cB1h1EZ/8vGo+egEte+dvHgqc/Zm
         anxHl+QkoYzvmNdrax6uIcXbA5MrZW2pI0h5zG3HA9g9D8SzH8bTWPwhD0SnLBCB0Yqi
         0kabDoYl3K1LBOmzRP9dNXQMDtCpqa0W86Acemc+ZuZ8sKwA6i0TjGq6nJySs9Mp2eIB
         ZjwPiOYsXCuFUllZiENNL5kW7JwGIRDFdgasDAjiVh7jPDeu+Ps8PpFAFTQw4HXBRhSi
         sJgw==
X-Forwarded-Encrypted: i=1; AJvYcCWPEjYj54faxKUAH5ueemTevVbkE1tdAeCeKMlJ2oDTuieDij6dWWVhAjEA8WCmc8/6Xwtc/BYOmjA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxPw3acqWR91CYppd+nfp3EcnItY2kNJ2hyNyS5ClSa6D0hy7O6
	YK3FpuSd5fg6axStlEpH924Zm1dqE+M4NJeH0gBL5hQjGGtEeqF42E7exi3WkwCuZiaZWGlpo9I
	8Kp1ZubUJuNigYBFc7T1JCNO16YAwYi6d2Atu9ne44KrscCBte8N1A0rmaZ8=
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1689:b0:662:f30e:d56d with SMTP id
 006d021491bc7-67766ad58d2mr10720204eaf.7.1771534286753; Thu, 19 Feb 2026
 12:51:26 -0800 (PST)
Date: Thu, 19 Feb 2026 12:51:26 -0800
In-Reply-To: <6968a164.050a0220.58bed.0011.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <699777ce.050a0220.b01bb.0031.GAE@google.com>
Subject: Re: [syzbot] [iomap?] WARNING in ifs_free
From: syzbot <syzbot+d3a62bea0e61f9d121da@syzkaller.appspotmail.com>
To: brauner@kernel.org, djwong@kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    2b7a25df823d Merge tag 'mm-nonmm-stable-2026-02-18-19-56' ..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10c21722580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=65722f41f7edc17e
dashboard link: https://syzkaller.appspot.com/bug?extid=d3a62bea0e61f9d121da
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1501dc02580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1357f652580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-2b7a25df.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/f3a54d09b17c/vmlinux-2b7a25df.xz
kernel image: https://storage.googleapis.com/syzbot-assets/fb704901bce5/bzImage-2b7a25df.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/b778b9903de5/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d3a62bea0e61f9d121da@syzkaller.appspotmail.com

------------[ cut here ]------------
ifs_is_fully_uptodate(folio, ifs) != folio_test_uptodate(folio)
WARNING: fs/iomap/buffered-io.c:256 at ifs_free+0x358/0x420 fs/iomap/buffered-io.c:255, CPU#0: syz-executor/5453
Modules linked in:
CPU: 0 UID: 0 PID: 5453 Comm: syz-executor Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:ifs_free+0x358/0x420 fs/iomap/buffered-io.c:255
Code: 41 5f 5d e9 7a fb bd ff e8 45 5a 5e ff 90 0f 0b 90 e9 d0 fe ff ff e8 37 5a 5e ff 90 0f 0b 90 e9 0a ff ff ff e8 29 5a 5e ff 90 <0f> 0b 90 eb c3 44 89 e1 80 e1 07 80 c1 03 38 c1 0f 8c 06 fe ff ff
RSP: 0018:ffffc9000dfcf688 EFLAGS: 00010293
RAX: ffffffff82674207 RBX: 0000000000000008 RCX: ffff88801f834900
RDX: 0000000000000000 RSI: 0000000000000008 RDI: 0000000000000000
RBP: 000000008267bc01 R08: ffffea00010fb747 R09: 1ffffd400021f6e8
R10: dffffc0000000000 R11: fffff9400021f6e9 R12: ffff888051c7da44
R13: ffff888051c7da00 R14: ffffea00010fb740 R15: 1ffffd400021f6e9
FS:  0000555586def500(0000) GS:ffff88808ca5b000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000555586e0aa28 CR3: 00000000591fe000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 folio_invalidate mm/truncate.c:140 [inline]
 truncate_cleanup_folio+0xcb/0x190 mm/truncate.c:160
 truncate_inode_pages_range+0x2ce/0xe30 mm/truncate.c:404
 ntfs_evict_inode+0x19/0x40 fs/ntfs3/inode.c:1861
 evict+0x61e/0xb10 fs/inode.c:846
 dispose_list fs/inode.c:888 [inline]
 evict_inodes+0x75a/0x7f0 fs/inode.c:942
 generic_shutdown_super+0xaa/0x2d0 fs/super.c:632
 kill_block_super+0x44/0x90 fs/super.c:1725
 ntfs3_kill_sb+0x44/0x1c0 fs/ntfs3/super.c:1889
 deactivate_locked_super+0xbc/0x130 fs/super.c:476
 cleanup_mnt+0x437/0x4d0 fs/namespace.c:1312
 task_work_run+0x1d9/0x270 kernel/task_work.c:233
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 __exit_to_user_mode_loop kernel/entry/common.c:67 [inline]
 exit_to_user_mode_loop+0xed/0x480 kernel/entry/common.c:98
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:226 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:256 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:325 [inline]
 do_syscall_64+0x32d/0xf80 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fb0f859d897
Code: a2 c7 05 5c ee 24 00 00 00 00 00 eb 96 e8 e1 12 00 00 90 31 f6 e9 09 00 00 00 66 0f 1f 84 00 00 00 00 00 b8 a6 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 01 c3 48 c7 c2 e8 ff ff ff f7 d8 64 89 02 b8
RSP: 002b:00007ffd23732b28 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
RAX: 0000000000000000 RBX: 00007fb0f8631ef0 RCX: 00007fb0f859d897
RDX: 0000000000000000 RSI: 0000000000000009 RDI: 00007ffd23732be0
RBP: 00007ffd23732be0 R08: 00007ffd23733be0 R09: 00000000ffffffff
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffd23733c70
R13: 00007fb0f8631ef0 R14: 000000000001b126 R15: 00007ffd23733cb0
 </TASK>


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
