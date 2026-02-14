Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com [209.85.161.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5097730C60E
	for <linux-xfs@vger.kernel.org>; Sat, 14 Feb 2026 08:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771057118; cv=none; b=DvBnooM7vOBeQQqVROzdSS7BzmE7Z5Lc0X4T0RR9ZlhNSxcYmluxjnuxR0qT2yT14NJ2TAQqmcwQDGiqDSWzY+/xxBdGDOCdfKxDWmcm/wlxCFdflj++IjwZZ4xF5MS3cgC27+gstJeKhlv3ChJoVCgCG3q6GllCjQZwMBbmnPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771057118; c=relaxed/simple;
	bh=KIg4TvcyQPX9WGJulFvD/Ghp1QaI79uuZ1vpZJTW7aI=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=Y3zCIAGBQ3ufjveLleLJuN/7PkRRAnbyH+eb5qct9PDg6ctTF9IAS0zYh9ZcS4kY35/FMX7KiYsqj3oovws9VbeqzotrOH/iCXAEbKZBKVL0mTErK+v4gOKzSnCoMCN8dA17PUeIPJpGad7EUI8HSvebUI2MshYT+VdcOcmh6fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-6640dc1ca05so15564027eaf.1
        for <linux-xfs@vger.kernel.org>; Sat, 14 Feb 2026 00:18:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771057116; x=1771661916;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9uvPHovtibdDNjaJrM1iOU+1emVWnTutPtyQrHhWRPo=;
        b=Ev+aIK8kUHwoTEMe2H0x8m1O5nFwJTAwz1bROVR+30HJOo5zTpIbbG4lPSF7cI482f
         +85sm2WtDW78N5fMafLVpf7AJ7zevBXfU8hz6cICF3tG82qVtRt3jOgDgjAarhFq6gLj
         vU8a7ppayM3nEg904qPD/xj6S+cyD8BCCmr64zbTHARnHCrCeVi0ISGPjFRFUZ2wdA1x
         7WQ4WoSUS43EM8w076HkwtxoxDP/JPTzLebHf/DDYNFzoeOgglux04iWEejzMhLJMQIN
         jrBKbxXVTrKwgUmjy7+ok1FJ33n+8x67UptveeB6WZM+3EQLpFoS+Stnt07MgCLyzkRy
         PLdA==
X-Forwarded-Encrypted: i=1; AJvYcCWrlfJDsGRUFRI27E6ucsY7a3q6qRbwivCrmjjl+j59jeoCWwFzb95HG/QPBy9ZP/Tq3hTwnFSNiT0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxF8ZB/jRqUwpXB5U7WsroQf3bTV556YLfv0ZIU6KLKvsKOFeDH
	ZYFB5sFePTxWhRmAMl4XXM2qiZmwn4F4cDhRrGR/lUXo15tDe0zN1MOi8O1bOyjZ0/KQ+eSnRjR
	K6xz0UrxKfiq11dakerumMP3Rd+WUPJ+p6VF9V8bALaavifshozEP9WovpQE=
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:16a0:b0:66f:2d14:32b7 with SMTP id
 006d021491bc7-6771ff7c17fmr2225067eaf.9.1771057116236; Sat, 14 Feb 2026
 00:18:36 -0800 (PST)
Date: Sat, 14 Feb 2026 00:18:36 -0800
In-Reply-To: <699000b2.050a0220.3a4a67.00a6.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69902fdc.a70a0220.3c8f9c.0088.GAE@google.com>
Subject: Re: [syzbot] [xfs?] inconsistent lock state in igrab
From: syzbot <syzbot+5eb0d61dfb76ca12670c@syzkaller.appspotmail.com>
To: cem@kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    cd7a5651db26 alpha: add missing address argument in call t..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13b47e5a580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e600149b13c010eb
dashboard link: https://syzkaller.appspot.com/bug?extid=5eb0d61dfb76ca12670c
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15df8722580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17f362aa580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/ea46ed04f19d/disk-cd7a5651.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/ee7aa4ba7700/vmlinux-cd7a5651.xz
kernel image: https://storage.googleapis.com/syzbot-assets/70280d10edbe/bzImage-cd7a5651.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/41cb64e4f612/mount_0.gz
  fsck result: failed (log: https://syzkaller.appspot.com/x/fsck.log?x=1105a6e6580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5eb0d61dfb76ca12670c@syzkaller.appspotmail.com

I/O error, dev loop0, sector 512 op 0x0:(READ) flags 0x880700 phys_seg 1 prio class 2
I/O error, dev loop0, sector 18692 op 0x0:(READ) flags 0x880700 phys_seg 1 prio class 2
================================
WARNING: inconsistent lock state
syzkaller #0 Not tainted
--------------------------------
inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
ksoftirqd/0/15 [HC0[0]:SC1[1]:HE1:SE0] takes:
ffff888059619180 (&sb->s_type->i_lock_key#36){+.?.}-{3:3}, at: spin_lock include/linux/spinlock.h:341 [inline]
ffff888059619180 (&sb->s_type->i_lock_key#36){+.?.}-{3:3}, at: igrab+0x2a/0x230 fs/inode.c:1583
{SOFTIRQ-ON-W} state was registered at:
  lock_acquire kernel/locking/lockdep.c:5868 [inline]
  lock_acquire+0x17c/0x330 kernel/locking/lockdep.c:5825
  __raw_spin_lock include/linux/spinlock_api_smp.h:158 [inline]
  _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:154
  spin_lock include/linux/spinlock.h:341 [inline]
  unlock_new_inode+0x7a/0x330 fs/inode.c:1222
  xfs_finish_inode_setup fs/xfs/xfs_inode.h:630 [inline]
  xfs_setup_existing_inode fs/xfs/xfs_inode.h:637 [inline]
  xfs_iget+0x1196/0x30f0 fs/xfs/xfs_icache.c:814
  xfs_mountfs+0x108c/0x20b0 fs/xfs/xfs_mount.c:1072
  xfs_fs_fill_super+0x153f/0x1f20 fs/xfs/xfs_super.c:1938
  get_tree_bdev_flags+0x38c/0x620 fs/super.c:1694
  vfs_get_tree+0x92/0x320 fs/super.c:1754
  fc_mount fs/namespace.c:1193 [inline]
  do_new_mount_fc fs/namespace.c:3760 [inline]
  do_new_mount fs/namespace.c:3836 [inline]
  path_mount+0x7d0/0x23d0 fs/namespace.c:4146
  do_mount fs/namespace.c:4159 [inline]
  __do_sys_mount fs/namespace.c:4348 [inline]
  __se_sys_mount fs/namespace.c:4325 [inline]
  __x64_sys_mount+0x293/0x310 fs/namespace.c:4325
  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
  do_syscall_64+0x106/0xf80 arch/x86/entry/syscall_64.c:94
  entry_SYSCALL_64_after_hwframe+0x77/0x7f
irq event stamp: 972992
hardirqs last  enabled at (972992): [<ffffffff8b820072>] __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:178 [inline]
hardirqs last  enabled at (972992): [<ffffffff8b820072>] _raw_spin_unlock_irqrestore+0x52/0x80 kernel/locking/spinlock.c:194
hardirqs last disabled at (972991): [<ffffffff8b81fd82>] __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:130 [inline]
hardirqs last disabled at (972991): [<ffffffff8b81fd82>] _raw_spin_lock_irqsave+0x52/0x60 kernel/locking/spinlock.c:162
softirqs last  enabled at (972968): [<ffffffff81c7bb68>] run_ksoftirqd kernel/softirq.c:1063 [inline]
softirqs last  enabled at (972968): [<ffffffff81c7bb68>] run_ksoftirqd+0x38/0x60 kernel/softirq.c:1055
softirqs last disabled at (972973): [<ffffffff81c7bb68>] run_ksoftirqd kernel/softirq.c:1063 [inline]
softirqs last disabled at (972973): [<ffffffff81c7bb68>] run_ksoftirqd+0x38/0x60 kernel/softirq.c:1055

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&sb->s_type->i_lock_key#36);
  <Interrupt>
    lock(&sb->s_type->i_lock_key#36);

 *** DEADLOCK ***

no locks held by ksoftirqd/0/15.

stack backtrace:
CPU: 0 UID: 0 PID: 15 Comm: ksoftirqd/0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2026
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
 print_usage_bug.part.0+0x257/0x340 kernel/locking/lockdep.c:4042
 print_usage_bug kernel/locking/lockdep.c:4010 [inline]
 valid_state kernel/locking/lockdep.c:4056 [inline]
 mark_lock_irq kernel/locking/lockdep.c:4267 [inline]
 mark_lock+0x74a/0xa20 kernel/locking/lockdep.c:4753
 mark_usage kernel/locking/lockdep.c:4642 [inline]
 __lock_acquire+0x103a/0x2630 kernel/locking/lockdep.c:5191
 lock_acquire kernel/locking/lockdep.c:5868 [inline]
 lock_acquire+0x17c/0x330 kernel/locking/lockdep.c:5825
 __raw_spin_lock include/linux/spinlock_api_smp.h:158 [inline]
 _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:154
 spin_lock include/linux/spinlock.h:341 [inline]
 igrab+0x2a/0x230 fs/inode.c:1583
 fserror_report+0x3fd/0x750 fs/fserror.c:159
 fserror_report_io include/linux/fserror.h:48 [inline]
 iomap_finish_folio_read+0x168/0x2c0 fs/iomap/buffered-io.c:407
 iomap_read_end_io+0x11a/0x430 fs/iomap/bio.c:17
 bio_endio+0x755/0x8b0 block/bio.c:1790
 blk_update_request+0x741/0x1330 block/blk-mq.c:1016
 blk_mq_end_request+0x5b/0x420 block/blk-mq.c:1178
 lo_complete_rq+0x1d4/0x2a0 drivers/block/loop.c:314
 blk_complete_reqs+0xb1/0xf0 block/blk-mq.c:1253
 handle_softirqs+0x1ea/0x910 kernel/softirq.c:622
 run_ksoftirqd kernel/softirq.c:1063 [inline]
 run_ksoftirqd+0x38/0x60 kernel/softirq.c:1055
 smpboot_thread_fn+0x3d3/0xaa0 kernel/smpboot.c:160
 kthread+0x370/0x450 kernel/kthread.c:467
 ret_from_fork+0x754/0xd80 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
