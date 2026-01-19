Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12C6818DF80
	for <linux-xfs@vger.kernel.org>; Mon, 19 Jan 2026 08:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768811645; cv=none; b=UDFQogG8WLUpMS9X3tVdU/xkAFKdqSwjBUfxbbgSeKkvJCAini8CWbZ+/P0vNRCy6YiPdCYGPkki5MQXNJ57MFRR20OE2/brB2h1ePT3OJYNb7qMSeBD3cp6cBfSuyb84/aZf7Ke+rYzgBYhBQjbUwxWGK3coaWTQgChTx/lQlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768811645; c=relaxed/simple;
	bh=sgtOTAk7PkPytIC2g2EaJR2sjk2SAW+utZD3H1bHHhA=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=Pw/84YpPf7sv17GAZfqDQO0x4Xp9WB3uWbu0IkVUcuq5ZfJveskuOXNqwRCLx8BIkJEBhomRm49oZ/fmnn6zD1ZHPcBkGnAp+4wRdixsQVGJ3I3hGWmdoEpWWgECXXdYnhESAqjPzpzv2d07QZnx7vOW302jr2xbULvbDQp7HQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-45c8a31b1fcso4849429b6e.1
        for <linux-xfs@vger.kernel.org>; Mon, 19 Jan 2026 00:34:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768811643; x=1769416443;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yM8AzByrpc3MTbXANfa1KMyPEPLsdnfU2Z8kME41C18=;
        b=vGAgh7c9FTsa5NstdF0CuuuLep4vXlDYvHgwizUzAOcdNqtt5sEdXQVAWS+rzCfAGY
         bnnutJAWz1QcA9RXId7NaE3IGdptxvAFwNwxlpmhOauEun7lWOTzVw3dI2Fb5pHtsgYO
         NiyU7zlcSS5UIBiHtWJeCsgm73t/t9pb3u3sqqYJF8Aa/9kDJWU0cOBNgpa0yCACR84a
         UI478niqEFV8BO47hRVtaBKXw/zoAWeziOWhxdMJfpZStjyqACtuHz3nwTuJor6eTsAV
         UHGxY54FMO1O6W5Bwz7UXWO5uwHd8dGPbopGFLgpF+0fgnga3gHsLaCNfPCuHiVvoZvm
         q2XA==
X-Forwarded-Encrypted: i=1; AJvYcCXHphUgb8OXN/4HmgTRYtfaVEGr0hkOCswV2FK/Dv2r2VLctUM0F13wkrxNm/483E3Ppa4qi3Ce3Gw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwrhSoo7VsfUGWAgQeuBdKkauytdKCSPGkVCF9d3eMGQVqSDZqi
	sY0g0ISHdjycLSMvj8tk1RJMK2us0WRG9LOcUtGo19bK9Gx9RuA0VKOV4uRl6kCuOJx2sX1STrR
	i7RZjTxeR3I+BDzalR+d8AdRn0kUJsZBtrCF+522ICrJRgBr6+qqStUqDO6s=
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a4a:bb07:0:b0:661:1d0c:a5c1 with SMTP id
 006d021491bc7-6611d0caa6bmr2673131eaf.62.1768811643122; Mon, 19 Jan 2026
 00:34:03 -0800 (PST)
Date: Mon, 19 Jan 2026 00:34:03 -0800
In-Reply-To: <aW3g7G_dWk4cbx0_@infradead.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <696dec7b.a70a0220.34546f.043a.GAE@google.com>
Subject: Re: [syzbot] [xfs?] KASAN: slab-use-after-free Read in xfs_buf_rele (4)
From: syzbot <syzbot+0391d34e801643e2809b@syzkaller.appspotmail.com>
To: hch@infradead.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
BUG: MAX_LOCKDEP_KEYS too low!

BUG: MAX_LOCKDEP_KEYS too low!
turning off the locking correctness validator.
CPU: 1 UID: 0 PID: 7123 Comm: syz-executor Not tainted syzkaller #0 PREEMPT 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/03/2025
Call trace:
 show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:499 (C)
 __dump_stack+0x30/0x40 lib/dump_stack.c:94
 dump_stack_lvl+0xd8/0x12c lib/dump_stack.c:120
 dump_stack+0x1c/0x28 lib/dump_stack.c:129
 register_lock_class+0x310/0x348 kernel/locking/lockdep.c:1332
 __lock_acquire+0xbc/0x30a4 kernel/locking/lockdep.c:5112
 lock_acquire+0x140/0x2e0 kernel/locking/lockdep.c:5868
 touch_wq_lockdep_map+0xa8/0x164 kernel/workqueue.c:3940
 __flush_workqueue+0xfc/0x109c kernel/workqueue.c:3982
 drain_workqueue+0xa4/0x310 kernel/workqueue.c:4146
 destroy_workqueue+0xb4/0xd90 kernel/workqueue.c:5903
 xfs_destroy_mount_workqueues+0xac/0xdc fs/xfs/xfs_super.c:649
 xfs_fs_put_super+0x128/0x144 fs/xfs/xfs_super.c:1262
 generic_shutdown_super+0x12c/0x2b8 fs/super.c:643
 kill_block_super+0x44/0x90 fs/super.c:1722
 xfs_kill_sb+0x20/0x58 fs/xfs/xfs_super.c:2297
 deactivate_locked_super+0xc4/0x12c fs/super.c:474
 deactivate_super+0xe0/0x100 fs/super.c:507
 cleanup_mnt+0x31c/0x3ac fs/namespace.c:1318
 __cleanup_mnt+0x20/0x30 fs/namespace.c:1325
 task_work_run+0x1dc/0x260 kernel/task_work.c:233
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 __exit_to_user_mode_loop kernel/entry/common.c:44 [inline]
 exit_to_user_mode_loop+0x10c/0x18c kernel/entry/common.c:75
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:226 [inline]
 exit_to_user_mode_prepare_legacy include/linux/irq-entry-common.h:242 [inline]
 arm64_exit_to_user_mode arch/arm64/kernel/entry-common.c:81 [inline]
 el0_svc+0x17c/0x26c arch/arm64/kernel/entry-common.c:725
 el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:743
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596
XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb


Tested on:

commit:         3e548540 increase LOCKDEP_CHAINS_BITS
git tree:       git://git.infradead.org/users/hch/xfs.git xfs-buf-hash
console output: https://syzkaller.appspot.com/x/log.txt?x=101b0d22580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6c6138f827b10ea4
dashboard link: https://syzkaller.appspot.com/bug?extid=0391d34e801643e2809b
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
userspace arch: arm64

Note: no patches were applied.
