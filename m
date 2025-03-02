Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36E9E1F03CD
	for <linux-xfs@vger.kernel.org>; Sun,  2 Mar 2025 16:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740933152; cv=none; b=XTKIkC24T6qZbsCwj74hGAO7XiSskAphjfu8WC5Gy/2tJO5jGydwji/9MV4nWp1S94zILjkcbU2CMNfPCj4I6Ean16pOhNDQFtoRrVugzrjtNuCLS8n/819BsA5FPPxb28FM3RbFhpA5srExErOvyGMva2jiUVOd6nsgNLY4l7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740933152; c=relaxed/simple;
	bh=57P+tNcbnfNXnT7hnuH21I1R3f0eQBHiddVU+5F7Ds0=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=G3qxmxAiG0fuPsQVIJZ3XCPZHjGLlE+V1wpama4TJX0N5eTWdSUksb+/X9y180aWqJlCFoxKGU5wSMxrpQ1RB1xG9eLxDVNJEwj0v7GnD91wOgMBg/WsYE74MSAxruLiOcfgLoEpY9MU1WxgxLF6Kk6W70uyxD/Lfyea8qsrXZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-3ce81a40f5cso88832585ab.1
        for <linux-xfs@vger.kernel.org>; Sun, 02 Mar 2025 08:32:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740933150; x=1741537950;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ujfoa9e7plnZ+Zb6IhbOn1wyIhQ3U/5af6ykQUmzi5g=;
        b=ZBwqwowuZgQo3jc3Y/tSSd1gngOT+d3C0qM/fbGIoexDs4DnR2m4fOQEiyL4gqI4T+
         FQ6iRuYbqHeK3WZwRhX/htLC5cnrsF7q3ZZDM40v05jVRoQIGiclBix7kds07I1DGevx
         P5Kc5yUuT2iYtsPeOrKydgZnJ5w9AXMFlbWHYEmLKg0YXRAhE6gWlvyelyqYOtFSP23m
         Z7XV8+HAU3lICZKHV/Zh90GVSesjs4n4Mos7yDpj+JcZONxatFw2t0QvINBoHXOf1Fw0
         iazzV+RBt4lTBPYX524jQyeZ99WyIAvHE/OtsVrH0evDtn0P1kzzdK4+cxiOKrwJiyeq
         f7XQ==
X-Forwarded-Encrypted: i=1; AJvYcCXeDF7F2b2BE9OyEsAgN3cnPKrLBGxGX5u0YVG7eSS2Y8ccT4M/Z7e+NF9UYesjkvpHJICmoMPQzrg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyRdBOE43bI8xo9C+UD4cVLbtTnypmiHfgBRe0dnFriTvQBUv2k
	oIdOtRSSEvi1G2TEmy4xn4gmNeOja0r1+nQUApYE2mzswD2HvzItnzrTz8lnK3Z4O6zcyx1R1vO
	1C40Xn8vQi5slSnNzZ0Txpjc/AXhUgsloaP/6b9Q1tb8ekebQQiOsQo8=
X-Google-Smtp-Source: AGHT+IGnsZcdzsCEkoV8H0T67CnG8PAHWQbjdFSkr/L2AIw2HlQEEmxCAdCaA/avNPrDqgQDo8zaUYK62e97nnU6FDpRWXYowuaY
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:138d:b0:3d3:dd60:bc37 with SMTP id
 e9e14a558f8ab-3d3e6fadcb1mr102772425ab.22.1740933150327; Sun, 02 Mar 2025
 08:32:30 -0800 (PST)
Date: Sun, 02 Mar 2025 08:32:30 -0800
In-Reply-To: <67a487f7.050a0220.19061f.05fc.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67c4881e.050a0220.1dee4d.0054.GAE@google.com>
Subject: Re: [syzbot] [xfs?] WARNING in fsnotify_file_area_perm
From: syzbot <syzbot+7229071b47908b19d5b7@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, amir73il@gmail.com, axboe@kernel.dk, 
	brauner@kernel.org, cem@kernel.org, chandan.babu@oracle.com, 
	djwong@kernel.org, jack@suse.cz, josef@toxicpanda.com, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    e056da87c780 Merge remote-tracking branch 'will/for-next/p..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=11f61864580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d6b7e15dc5b5e776
dashboard link: https://syzkaller.appspot.com/bug?extid=7229071b47908b19d5b7
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=162aba97980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15f61864580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/3d8b1b7cc4c0/disk-e056da87.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/b84c04cff235/vmlinux-e056da87.xz
kernel image: https://storage.googleapis.com/syzbot-assets/2ae4d0525881/Image-e056da87.gz.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/4ea12659f0c0/mount_0.gz
  fsck result: failed (log: https://syzkaller.appspot.com/x/fsck.log?x=1584cfb8580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7229071b47908b19d5b7@syzkaller.appspotmail.com

XFS (loop0): Mounting V5 Filesystem bfdc47fc-10d8-4eed-a562-11a831b3f791
XFS (loop0): Ending clean mount
XFS (loop0): Quotacheck needed: Please wait.
XFS (loop0): Quotacheck: Done.
------------[ cut here ]------------
WARNING: CPU: 1 PID: 6440 at ./include/linux/fsnotify.h:145 fsnotify_file_area_perm+0x20c/0x25c include/linux/fsnotify.h:145
Modules linked in:
CPU: 1 UID: 0 PID: 6440 Comm: syz-executor370 Not tainted 6.14.0-rc4-syzkaller-ge056da87c780 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 12/27/2024
pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : fsnotify_file_area_perm+0x20c/0x25c include/linux/fsnotify.h:145
lr : fsnotify_file_area_perm+0x20c/0x25c include/linux/fsnotify.h:145
sp : ffff8000a42569d0
x29: ffff8000a42569d0 x28: ffff0000dcec1b48 x27: ffff0000d68a1708
x26: ffff0000d68a16c0 x25: dfff800000000000 x24: 0000000000008000
x23: 0000000000000001 x22: ffff8000a4256b00 x21: 0000000000001000
x20: 0000000000000010 x19: ffff0000d68a16c0 x18: ffff8000a42566e0
x17: 000000000000e388 x16: ffff800080466c24 x15: 0000000000000001
x14: 1fffe0001b31513c x13: 0000000000000000 x12: 0000000000000000
x11: 0000000000000001 x10: 0000000000ff0100 x9 : 0000000000000000
x8 : ffff0000c6d98000 x7 : 0000000000000000 x6 : 0000000000000000
x5 : 0000000000000020 x4 : 0000000000000000 x3 : 0000000000001000
x2 : ffff8000a4256b00 x1 : 0000000000000001 x0 : 0000000000000000
Call trace:
 fsnotify_file_area_perm+0x20c/0x25c include/linux/fsnotify.h:145 (P)
 filemap_fault+0x12b0/0x1518 mm/filemap.c:3509
 xfs_filemap_fault+0xc4/0x194 fs/xfs/xfs_file.c:1543
 __do_fault+0xf8/0x498 mm/memory.c:4988
 do_read_fault mm/memory.c:5403 [inline]
 do_fault mm/memory.c:5537 [inline]
 do_pte_missing mm/memory.c:4058 [inline]
 handle_pte_fault+0x3504/0x57b0 mm/memory.c:5900
 __handle_mm_fault mm/memory.c:6043 [inline]
 handle_mm_fault+0xfa8/0x188c mm/memory.c:6212
 do_page_fault+0x570/0x10a8 arch/arm64/mm/fault.c:690
 do_translation_fault+0xc4/0x114 arch/arm64/mm/fault.c:783
 do_mem_abort+0x74/0x200 arch/arm64/mm/fault.c:919
 el1_abort+0x3c/0x5c arch/arm64/kernel/entry-common.c:432
 el1h_64_sync_handler+0x60/0xcc arch/arm64/kernel/entry-common.c:510
 el1h_64_sync+0x6c/0x70 arch/arm64/kernel/entry.S:595
 __uaccess_mask_ptr arch/arm64/include/asm/uaccess.h:169 [inline] (P)
 fault_in_readable+0x168/0x310 mm/gup.c:2234 (P)
 fault_in_iov_iter_readable+0x1dc/0x22c lib/iov_iter.c:94
 iomap_write_iter fs/iomap/buffered-io.c:950 [inline]
 iomap_file_buffered_write+0x490/0xd54 fs/iomap/buffered-io.c:1039
 xfs_file_buffered_write+0x2dc/0xac8 fs/xfs/xfs_file.c:792
 xfs_file_write_iter+0x2c4/0x6ac fs/xfs/xfs_file.c:881
 new_sync_write fs/read_write.c:586 [inline]
 vfs_write+0x704/0xa9c fs/read_write.c:679
 ksys_pwrite64 fs/read_write.c:786 [inline]
 __do_sys_pwrite64 fs/read_write.c:794 [inline]
 __se_sys_pwrite64 fs/read_write.c:791 [inline]
 __arm64_sys_pwrite64+0x188/0x220 fs/read_write.c:791
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:744
 el0t_64_sync_handler+0x84/0x108 arch/arm64/kernel/entry-common.c:762
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600
irq event stamp:


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
