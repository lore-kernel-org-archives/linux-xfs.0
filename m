Received: from mail-oo1-f77.google.com (mail-oo1-f77.google.com [209.85.161.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D752A1CF7D5
	for <linux-xfs@vger.kernel.org>; Mon, 26 Jan 2026 14:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769436454; cv=none; b=APbKf6P68pTxPB1GR2acmuGO1eDV4pZ6FzUIJeAYpz6Je08jajfT9F/B7u/pZK/9wDo6QVFU+NoxS7+7QxoSgw1+NIK5rbNwHIExTta3QKIeULXkmehTIv4Lze0woAnhE1mNJAvYGQ3dH/77Ne7j6s2bPF2jKn7cNOJp9K6XcqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769436454; c=relaxed/simple;
	bh=PUJPhOJ4AZ2lB4sT5ZrEb+XeEdqEQ9/Hnw47hjixBKQ=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=f4tBpDZqk8UlGNycQCR1LtGxtS5/EtrvlahaTiO6Ar5AM+A+gQs1h0njaorrR0RhKaFe0HUbflkXgoF8x+HHuycwwUVNH0LFvz3p100X7cCsEzd4IDJELh1ybr1XeVOB/T5KDE8VR1MNMYQNsi89AeKq+A5eMw+RHm8TadsLlQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f77.google.com with SMTP id 006d021491bc7-65f453d9603so7485813eaf.3
        for <linux-xfs@vger.kernel.org>; Mon, 26 Jan 2026 06:07:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769436452; x=1770041252;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6YOXJTvQa35EfB+oi4pMAGZpTsTQpaRB63oI/VpRPtY=;
        b=vcScXaYkswRmHdKhqE2B+Baw+TFKxNyfurgjOCtmEWuVQk6Rgq1Va6u54KIotpZnBR
         YsQ/8T9DKvjZJQKZGwi9yDPKa3uwCWpdfjAbcRvpdNpw3mfYQXurP7udpHzjOuW+Rc10
         acg/uR+yh8djR4vBD4cHnG6TzobXPDFt46hKu4gjq1LAAoOrcp6vOGEOcuGErgxvK6+Y
         FUYCi6vFlRePgV7Vwt61XRvh9DYErrqUB1XlnCxTK9xXTz+1uJel1m6BtjutsBtutiaL
         dBykjFFlf4oNoZXDAjvgE4VuZpwsCGkg2Nd+frevkoinhghK6SmgDH7oN3tWlEa3qg2B
         0hsw==
X-Forwarded-Encrypted: i=1; AJvYcCVpwgg0yPW5/S8ftfNCZdeb9teiEBBm6qskCnPycqOmoRJeVodMJGfhNKFB8J6wjPVH5SRH8NazVL4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yydz4Ga43tBV5rn2KnP3iyNI3kIC0dqjs5qlIikPIjUk280iQW+
	TTkYBOipMez5bx3wYtl/cNzT6c3GD/NPaOwyK1sWnxdhkx85T7qvpMM+F83RIcOo9ixlebgMZ2i
	16ZOrJp5G1MgNZpWLrJ9MYdA50V5J6Ri2iVVgXt5kq0MbvI7h8By06eKo6i8=
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1886:b0:65b:2a82:d700 with SMTP id
 006d021491bc7-662e044e138mr2042204eaf.44.1769436451887; Mon, 26 Jan 2026
 06:07:31 -0800 (PST)
Date: Mon, 26 Jan 2026 06:07:31 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69777523.050a0220.1d05e9.0018.GAE@google.com>
Subject: [syzbot] [iomap?] WARNING in iomap_iter (6)
From: syzbot <syzbot+bd5ca596a01d01bfa083@syzkaller.appspotmail.com>
To: brauner@kernel.org, djwong@kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    a66191c590b3 Merge tag 'hyperv-fixes-signed-20260121' of g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10db3e3a580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=312c0a6c03e6d7df
dashboard link: https://syzkaller.appspot.com/bug?extid=bd5ca596a01d01bfa083
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/f802af648f7a/disk-a66191c5.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/9f28f489fe55/vmlinux-a66191c5.xz
kernel image: https://storage.googleapis.com/syzbot-assets/8c44005e0c3c/bzImage-a66191c5.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+bd5ca596a01d01bfa083@syzkaller.appspotmail.com

------------[ cut here ]------------
iter->iomap.offset + iter->iomap.length <= iter->pos
WARNING: fs/iomap/iter.c:36 at iomap_iter_done fs/iomap/iter.c:36 [inline], CPU#0: kworker/u8:26/9724
WARNING: fs/iomap/iter.c:36 at iomap_iter+0x982/0xf30 fs/iomap/iter.c:114, CPU#0: kworker/u8:26/9724
Modules linked in:
CPU: 0 UID: 0 PID: 9724 Comm: kworker/u8:26 Tainted: G             L      syzkaller #0 PREEMPT(full) 
Tainted: [L]=SOFTLOCKUP
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/13/2026
Workqueue: loop6 loop_workfn
RIP: 0010:iomap_iter_done fs/iomap/iter.c:36 [inline]
RIP: 0010:iomap_iter+0x982/0xf30 fs/iomap/iter.c:114
Code: ff ff ff e9 86 fa ff ff e8 ab 6d 65 ff 90 0f 0b 90 e9 06 fd ff ff e8 9d 6d 65 ff 90 0f 0b 90 e9 3b fd ff ff e8 8f 6d 65 ff 90 <0f> 0b 90 e9 97 fd ff ff e8 81 6d 65 ff 90 0f 0b 90 e9 c4 fd ff ff
RSP: 0018:ffffc9000cdcf268 EFLAGS: 00010293
RAX: ffffffff825d2b81 RBX: ffffc9000cdcf3c0 RCX: ffff88806e5d1e80
RDX: 0000000000000000 RSI: 8000000000083fff RDI: 0000003e80000000
RBP: ffffc9000cdcf3f8 R08: ffffc9000cdcf3e8 R09: ffffc9000cdcf430
R10: dffffc0000000000 R11: ffffffff8473db20 R12: 8000000000083fff
R13: ffffc9000cdcf402 R14: 1ffff920019b9e79 R15: 0000003e80000000
FS:  0000000000000000(0000) GS:ffff888125928000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000031712ff8 CR3: 0000000043618000 CR4: 00000000003526f0
DR0: ffffffffffffffff DR1: 00000000000001f8 DR2: 0000000000000083
DR3: ffffffffefffff15 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 iomap_file_buffered_write+0x275/0xa30 fs/iomap/buffered-io.c:1187
 blkdev_buffered_write block/fops.c:736 [inline]
 blkdev_write_iter+0x524/0x710 block/fops.c:802
 lo_rw_aio+0xc7a/0xf00 include/linux/percpu-rwsem.h:-1
 do_req_filebacked drivers/block/loop.c:434 [inline]
 loop_handle_cmd drivers/block/loop.c:1947 [inline]
 loop_process_work+0x61d/0x11a0 drivers/block/loop.c:1982
 process_one_work kernel/workqueue.c:3257 [inline]
 process_scheduled_works+0xaec/0x17a0 kernel/workqueue.c:3340
 worker_thread+0x89f/0xd90 kernel/workqueue.c:3421
 kthread+0x726/0x8b0 kernel/kthread.c:463
 ret_from_fork+0x51b/0xa40 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
 </TASK>


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
