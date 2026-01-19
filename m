Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 360AF2FB0B4
	for <linux-xfs@vger.kernel.org>; Mon, 19 Jan 2026 07:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768808284; cv=none; b=DK+VHyPDTORYcs1Z8E6j6V0z2ja8OnHFDJ06WK0Qp2xtFRfwbX/46ZOzR2zAlaqen8NxB/yvS261LkrhRnIvJQD60hZRhIjd4Risf6fbevAjWCfFHn6QW+oDd/pckEdYQl4v/TOUvi0QV8UZH75IBlkEfYwkz1jYOCkF9XioXXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768808284; c=relaxed/simple;
	bh=nXdpN0aAj2BV8Yiw0h/jk0Xc/rGaB4TF1HUcSKFeCvs=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=FCenLVW+Ljz1VL6O2BZYlSxc154w6VOzod1K8+trMH070PUOx20QZLwdBqdhXVs8Lq5ZZC4zFqa25kC66cLtAfDQyJXnHHNxxUr18jdmAmUqFPj+erujeRQ8W+SmRKMyFVLrrLTxj6Li3Sse+ONET/LMU+yJoslOrwo51PGNeVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-7cfd12d8245so7904974a34.1
        for <linux-xfs@vger.kernel.org>; Sun, 18 Jan 2026 23:38:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768808282; x=1769413082;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u17TDd0O2aRjgPGpyf9+kN3LRuqgAITfQio0IcMT/ZE=;
        b=O1IHXO/djXQ6LHao/qJN4fbg6qTNwD/PdWPozwCidYc2X1R/wLWa6bilUOX4x4BWDG
         VpdW4RBnDjPiJ9gJV/qW0FI36p7r/EaBj/mUbpPBibH4VcM6waNtHsgdMeA40kWK5Lh/
         wCVH5zmuO/KHuYLa4fHmskyS6jDqbMro5y0Ko2GTM/2AItJbgQNCldp2/ar0sT+QbbC+
         89gZLUhEaWWq0D4qL/vTZafU7iLgwqIwSCnqYKVn5/8kcEffYfzxeGHNXzwAi7Dp4XUp
         ZoIT6jQ77YpTt9BUiFurZ4IV6KZypsjZlpTaEoSQv+tNdbb3X7vjCsfZGZVlwjzVt0m1
         JuJg==
X-Forwarded-Encrypted: i=1; AJvYcCVQ+n5lBYmgK1ZVB3WyxggCj0SfzgBUv6f+FKto5ciunTlpweT9PxaEBHxNw7p42sXBjbwRAYkzDn8=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywqm/jDfxJQZcUF09aNc5yjW940or0ytySHyzVBxPUKBj7OF8B6
	ZzE7fBsWhNiMEzjRwkeBDQWaTi8F51EvTVXOzbhoto0rLJzsluKLgzneLGiW0HNbJQ5GYvwOl6F
	3juBfzjOvw7GAdhxmdLt7yocvzuictn64Aw/vKfxi1+maaazQcaJfc/A5Ldw=
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:229c:b0:65c:fa23:2d04 with SMTP id
 006d021491bc7-661188d5c3amr3980306eaf.13.1768808282190; Sun, 18 Jan 2026
 23:38:02 -0800 (PST)
Date: Sun, 18 Jan 2026 23:38:02 -0800
In-Reply-To: <aW3J5Cc3ezll_601@infradead.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <696ddf5a.050a0220.3390f1.003b.GAE@google.com>
Subject: Re: [syzbot] [xfs?] KASAN: slab-use-after-free Read in xfs_buf_rele (4)
From: syzbot <syzbot+0391d34e801643e2809b@syzkaller.appspotmail.com>
To: hch@infradead.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
BUG: MAX_LOCKDEP_CHAINS too low!

BUG: MAX_LOCKDEP_CHAINS too low!
turning off the locking correctness validator.
CPU: 0 UID: 0 PID: 1610 Comm: kworker/u8:6 Not tainted syzkaller #0 PREEMPT 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/03/2025
Workqueue: xfs_iwalk-13497 xfs_pwork_work
Call trace:
 show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:499 (C)
 __dump_stack+0x30/0x40 lib/dump_stack.c:94
 dump_stack_lvl+0xd8/0x12c lib/dump_stack.c:120
 dump_stack+0x1c/0x28 lib/dump_stack.c:129
 add_chain_cache kernel/locking/lockdep.c:-1 [inline]
 lookup_chain_cache_add kernel/locking/lockdep.c:3855 [inline]
 validate_chain kernel/locking/lockdep.c:3876 [inline]
 __lock_acquire+0xf9c/0x30a4 kernel/locking/lockdep.c:5237
 lock_acquire+0x140/0x2e0 kernel/locking/lockdep.c:5868
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
 _raw_spin_lock_irqsave+0x5c/0x7c kernel/locking/spinlock.c:162
 debug_object_activate+0x7c/0x460 lib/debugobjects.c:818
 debug_timer_activate kernel/time/timer.c:793 [inline]
 __mod_timer+0x8c4/0xd00 kernel/time/timer.c:1124
 add_timer_global+0x88/0xc0 kernel/time/timer.c:1283
 __queue_delayed_work+0x218/0x2c8 kernel/workqueue.c:2520
 queue_delayed_work_on+0xe4/0x194 kernel/workqueue.c:2555
 queue_delayed_work include/linux/workqueue.h:684 [inline]
 xfs_reclaim_work_queue+0x154/0x244 fs/xfs/xfs_icache.c:211
 xfs_perag_set_inode_tag+0x19c/0x4bc fs/xfs/xfs_icache.c:263
 xfs_inodegc_set_reclaimable+0x1e0/0x444 fs/xfs/xfs_icache.c:1917
 xfs_inode_mark_reclaimable+0x2c8/0x10f8 fs/xfs/xfs_icache.c:2252
 xfs_fs_destroy_inode+0x2fc/0x618 fs/xfs/xfs_super.c:712
 destroy_inode fs/inode.c:396 [inline]
 evict+0x7cc/0xa74 fs/inode.c:861
 iput_final fs/inode.c:1954 [inline]
 iput+0xc54/0xfdc fs/inode.c:2006
 xfs_irele+0xd0/0x2ac fs/xfs/xfs_inode.c:2662
 xfs_qm_dqusage_adjust+0x4f4/0x5b0 fs/xfs/xfs_qm.c:1411
 xfs_iwalk_ag_recs+0x404/0x7c8 fs/xfs/xfs_iwalk.c:209
 xfs_iwalk_run_callbacks+0x1c0/0x3e8 fs/xfs/xfs_iwalk.c:370
 xfs_iwalk_ag+0x6ac/0x82c fs/xfs/xfs_iwalk.c:473
 xfs_iwalk_ag_work+0xf8/0x1a0 fs/xfs/xfs_iwalk.c:620
 xfs_pwork_work+0x80/0x1a4 fs/xfs/xfs_pwork.c:47
 process_one_work+0x7c0/0x1558 kernel/workqueue.c:3257
 process_scheduled_works kernel/workqueue.c:3340 [inline]
 worker_thread+0x958/0xed8 kernel/workqueue.c:3421
 kthread+0x5fc/0x75c kernel/kthread.c:463
 ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:844


Tested on:

commit:         855e81db xfs: switch (back) to a per-buftarg buffer hash
git tree:       git://git.infradead.org/users/hch/xfs.git xfs-buf-hash
console output: https://syzkaller.appspot.com/x/log.txt?x=162bb63a580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1707867b02964a26
dashboard link: https://syzkaller.appspot.com/bug?extid=0391d34e801643e2809b
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
userspace arch: arm64

Note: no patches were applied.
