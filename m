Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9E1425487C
	for <linux-xfs@vger.kernel.org>; Sat, 30 Aug 2025 18:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756577015; cv=none; b=iteUlQux/2sWPRkZjdCa83Non/MZiaGQePOA3v7E32CZFWRW3OcKLOsQIoXQgzQ2hmoOCrjTflIDsooUEbk8wHijYLx47kLAhC8vGQTSszgI7ucjPh9iA0Tp/V7j76RBMJqU/pclx2o6iFAW61Hlsr22jq+ubXscKJOKdy3aX64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756577015; c=relaxed/simple;
	bh=hdj9CuNvUL2qLsfWQqzcQGBGGcXsEsqeJOYPfSil7BQ=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=TzC/5cpB6rM1qM9CbylS38HkcIl0B22BTS3OpqKT4hCfbLmxQ3tiP7hCdmiX2T8N8bfLDCQZotC2HapeAJzZpV6LAf+xYVY0Jq+xDiKtLMRerTCCMKfWNYoMseRPsfhyIjw+G/bGonHZs2s+jiER9HtLDnEqzXvFWM0BVzeDRrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-3e6649d783bso68833575ab.3
        for <linux-xfs@vger.kernel.org>; Sat, 30 Aug 2025 11:03:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756577013; x=1757181813;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y0EmFDrtnTB27c9P1CgT1xWyHibY7Jm3IDK1ySTEc4U=;
        b=qxhXW5njFXU7Rr8IvUw91yy9VoKl5H2Y6hiDYf3h8fX4nmt6DIlgZMyXTYKQDetOe6
         eW+3ccroTcaVyBfMXbIRIfK7MNGAYqQeOZtADC11JRthhy0ydct6UCVByIBMUy9+QTLA
         uXJwRv7gkra6kBodmlZOstHC02scM1tOotLrYuSdsQDmPm+wMemQeLuW/W7N3rCKAOob
         dnQYHnba+ff4Cb3d/iBnciDVzNGvfw0JhgC2JHbwNY15Qp6Y7QQA6Hb0V/9fiwTBEi50
         2vwPDtZTiBQMhDf4dtDb7RQ4Toet5uAHnfbWBluchWWa9VCvy4EKYN6FpRp6VtJwEJUt
         i3zg==
X-Forwarded-Encrypted: i=1; AJvYcCUKpj/H2I3KjRdnW8pTMk47d7RRmX5yIdVyyYlSjlnf4EcDCnBq/+diQ0wPjRh35+r9uPf1L9vrnoM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw33eLakwGEg0dB+Uy2vyh3UUxmUlaBtCbjUeaQfAUy8SRVTWem
	jEXZsaaA7oj1JZ055eWOgdoOQgozrAAZYqIWTfaA6nx/5PqyOoupNfHWArv7Y3Y5MC1MmGihmM3
	5Z2s6R02MHaSjeyL7dU8k0ZO2sAFNiZdLupGEcOsnvyWzhNUZ29CaCAafCbI=
X-Google-Smtp-Source: AGHT+IG32OKZdP/wR5LsTpXnN7zPnfxInIheNy/NLRAyHRxnx4lf1Ppw0rVZprhjee1dorUQDzs2sKZopzbmRoTgayJB7NX6CAfu
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2189:b0:3f3:42ba:5a9 with SMTP id
 e9e14a558f8ab-3f4027b88cemr54329045ab.31.1756577012922; Sat, 30 Aug 2025
 11:03:32 -0700 (PDT)
Date: Sat, 30 Aug 2025 11:03:32 -0700
In-Reply-To: <68a28720.050a0220.e29e5.0080.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68b33cf4.a00a0220.1337b0.0025.GAE@google.com>
Subject: Re: [syzbot] [xfs?] WARNING in xfs_trans_alloc
From: syzbot <syzbot+ab02e4744b96de7d3499@syzkaller.appspotmail.com>
To: cem@kernel.org, hch@infradead.org, linux-kernel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    8f5ae30d69d7 Linux 6.17-rc1
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=15474242580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8c5ac3d8b8abfcb
dashboard link: https://syzkaller.appspot.com/bug?extid=ab02e4744b96de7d3499
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10891a62580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14a32a62580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/18a2e4bd0c4a/disk-8f5ae30d.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/3b5395881b25/vmlinux-8f5ae30d.xz
kernel image: https://storage.googleapis.com/syzbot-assets/e875f4e3b7ff/Image-8f5ae30d.gz.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/f4f2ae1e66f9/mount_3.gz
  fsck result: failed (log: https://syzkaller.appspot.com/x/fsck.log?x=12458e34580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ab02e4744b96de7d3499@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 24 at fs/xfs/xfs_trans.c:256 xfs_trans_alloc+0x3e4/0x898 fs/xfs/xfs_trans.c:256
Modules linked in:
CPU: 1 UID: 0 PID: 24 Comm: kworker/1:0 Not tainted 6.17.0-rc1-syzkaller-g8f5ae30d69d7 #0 PREEMPT 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/30/2025
Workqueue: xfs-inodegc/loop0 xfs_inodegc_worker
pstate: 83400005 (Nzcv daif +PAN -UAO +TCO +DIT -SSBS BTYPE=--)
pc : xfs_trans_alloc+0x3e4/0x898 fs/xfs/xfs_trans.c:256
lr : xfs_trans_alloc+0x3e4/0x898 fs/xfs/xfs_trans.c:256
sp : ffff800097ce77e0
x29: ffff800097ce7860 x28: ffff0000c2490130 x27: 0000000000000000
x26: ffff0000c2490000 x25: dfff800000000000 x24: 1ffff00012f9cf18
x23: dfff800000000000 x22: ffff0000c249043c x21: ffff0000c2490440
x20: ffff0000c2490438 x19: 0000000000000004 x18: 1fffe000337a0688
x17: ffff800093507000 x16: ffff80008b007230 x15: 0000000000000001
x14: 1fffe0001e61bbb5 x13: 0000000000000000 x12: 0000000000000000
x11: ffff60001e61bbb6 x10: 0000000000ff0100 x9 : 0000000000000000
x8 : ffff0000c1ae8000 x7 : ffff800081e80e40 x6 : 0000000000000000
x5 : ffff800097ce78e0 x4 : 0000000000000000 x3 : 0000000000000000
x2 : 0000000000000000 x1 : 0000000000000004 x0 : 0000000000000004
Call trace:
 xfs_trans_alloc+0x3e4/0x898 fs/xfs/xfs_trans.c:256 (P)
 xfs_attr_inactive+0xec/0x2b0 fs/xfs/xfs_attr_inactive.c:343
 xfs_inactive+0x7ac/0xb74 fs/xfs/xfs_inode.c:1464
 xfs_inodegc_inactivate fs/xfs/xfs_icache.c:1944 [inline]
 xfs_inodegc_worker+0x320/0x83c fs/xfs/xfs_icache.c:1990
 process_one_work+0x7e8/0x155c kernel/workqueue.c:3236
 process_scheduled_works kernel/workqueue.c:3319 [inline]
 worker_thread+0x958/0xed8 kernel/workqueue.c:3400
 kthread+0x5fc/0x75c kernel/kthread.c:463
 ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:844
irq event stamp: 1049032
hardirqs last  enabled at (1049031): [<ffff80008b028e88>] __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:159 [inline]
hardirqs last  enabled at (1049031): [<ffff80008b028e88>] _raw_spin_unlock_irq+0x30/0x80 kernel/locking/spinlock.c:202
hardirqs last disabled at (1049032): [<ffff80008b001bfc>] el1_brk64+0x1c/0x48 arch/arm64/kernel/entry-common.c:574
softirqs last  enabled at (1048974): [<ffff8000803d88a0>] softirq_handle_end kernel/softirq.c:425 [inline]
softirqs last  enabled at (1048974): [<ffff8000803d88a0>] handle_softirqs+0xaf8/0xc88 kernel/softirq.c:607
softirqs last disabled at (1048959): [<ffff800080022028>] __do_softirq+0x14/0x20 kernel/softirq.c:613
---[ end trace 0000000000000000 ]---


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
