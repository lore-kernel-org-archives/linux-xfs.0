Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB72D337B9C
	for <linux-xfs@vger.kernel.org>; Thu, 30 Oct 2025 08:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761814026; cv=none; b=TNNiZQWKrTyfqbwSazuU+au8m0O3e7wBV3welFGFcEV7wvEqgpHX1BeQRNDMBSfx25DrKZQ+Rr/OxIx5pzJDJQHOgNNQha/NmxHdGc3ckTPMKXDNOHJg3gZArAROov5CPvnJU5Uyc36g/YJ48ZbLYCMoflJgAudzoCl5FbWSgmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761814026; c=relaxed/simple;
	bh=IarTxW89Ra6vUVZHMkY0Iycnhbs0P0WXiLbcgA+I4lk=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=mjwogUHdSMTfOC4VUa2fY10BD+rhkj4j9uoSS+0r3l+UmA13ioE2xTkXXafObgpVGoGsWBPoRvUMiwGXEOHiChd2XD0YO3CACUB1oRH1+4EDxBw850D9pm6NKydpizTKtvB5Hs8NplxDRZzWjubrcZgoEkeKW/y2dnmDOVEZ9Uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-430d003e87eso23096185ab.3
        for <linux-xfs@vger.kernel.org>; Thu, 30 Oct 2025 01:47:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761814024; x=1762418824;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mmOik3UrVW25KeFjmXxwLV1xvwqUDEy5baTvfzfN5Wg=;
        b=ONPGwO2Ja7EFnACZBAR7D65TvPGb6RKIXVXNySCjWAvkRHLnwaCZcUwPN2HzVw2sCJ
         RMyLoGLIlKCdKCiN9YHFGjuh6N9GqrN+47+QxzEfckwGtWmuWS+n7OoeeGGVV1/67dVo
         bssHEQtTmKCvQ8Th/QEYxwKgy6f6eW/3fZiUjj27tAZStFos5pa/G+7/UgefjqFvI3F9
         LieN4tqr/WE1u1X4v26SHN9Lm+aIaBUcRo5svumpOMCO4k9dSAzORH0PsndekCBHQCx6
         fWoWGxZjqXy5Znas0Kti5TKB5yC2aGtplF+ucN2lKPMw1NNhSZUj89TLyDgdAVVclMoB
         qjqg==
X-Forwarded-Encrypted: i=1; AJvYcCXbdk8M9VXz576x74pGR0PWRpNZUlmyhqqsCGWM4YBqxrUD1lRbsnx9BljnhhmJj/tnLKmtXtoERew=@vger.kernel.org
X-Gm-Message-State: AOJu0Yynd346Rd7YrNDKS+fDrjbdYrDfLJXSC1+jKbY0Ssx59G/Aj5U5
	vNdIE5pPm0yYagGbLa3mJDWocaTaG7kPhTkscZ+ercN0GeN24cnjMEITfLU1s1COQLiRDOrVioV
	a7an7o55CxrKORiJ5t7yYghyMS6z+bf2CMnGjz16Y7MyWu1c5kEpXzJiXYfw=
X-Google-Smtp-Source: AGHT+IGF6AY05UN9vxQmE2c9VdB1OEbLSUASEGjNx91JHdvc4rL9APPvQ+++EFWjhnDPC+YgNoSqEIlwqdmfedXsEqUx+Rvomnm6
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3089:b0:42f:9dd5:3ebb with SMTP id
 e9e14a558f8ab-43301550345mr30446515ab.24.1761814023995; Thu, 30 Oct 2025
 01:47:03 -0700 (PDT)
Date: Thu, 30 Oct 2025 01:47:03 -0700
In-Reply-To: <aQMbZoAAVWxxx6wc@infradead.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69032607.050a0220.3344a1.043e.GAE@google.com>
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
CPU: 1 UID: 0 PID: 2577 Comm: kworker/u8:7 Not tainted syzkaller #0 PREEMPT 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/30/2025
Workqueue: xfs-cil/loop0 xlog_cil_push_work
Call trace:
 show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:499 (C)
 __dump_stack+0x30/0x40 lib/dump_stack.c:94
 dump_stack_lvl+0xd8/0x12c lib/dump_stack.c:120
 dump_stack+0x1c/0x28 lib/dump_stack.c:129
 add_chain_cache kernel/locking/lockdep.c:-1 [inline]
 lookup_chain_cache_add kernel/locking/lockdep.c:3855 [inline]
 validate_chain kernel/locking/lockdep.c:3876 [inline]
 __lock_acquire+0xf9c/0x30a4 kernel/locking/lockdep.c:5237
 lock_acquire+0x14c/0x2e0 kernel/locking/lockdep.c:5868
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
 _raw_spin_lock_irqsave+0x5c/0x7c kernel/locking/spinlock.c:162
 __wake_up_common_lock kernel/sched/wait.c:124 [inline]
 __wake_up+0x40/0x1a8 kernel/sched/wait.c:146
 xlog_cil_set_ctx_write_state+0x2a8/0x310 fs/xfs/xfs_log_cil.c:997
 xlog_write+0x1fc/0xe94 fs/xfs/xfs_log.c:2252
 xlog_cil_write_commit_record fs/xfs/xfs_log_cil.c:1118 [inline]
 xlog_cil_push_work+0x19ec/0x1f74 fs/xfs/xfs_log_cil.c:1434
 process_one_work+0x7e8/0x155c kernel/workqueue.c:3236
 process_scheduled_works kernel/workqueue.c:3319 [inline]
 worker_thread+0x958/0xed8 kernel/workqueue.c:3400
 kthread+0x5fc/0x75c kernel/kthread.c:463
 ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:844


Tested on:

commit:         af1722bb xfs: switch (back) to a per-buftarg buffer hash
git tree:       git://git.infradead.org/users/hch/misc.git xfs-buf-hash
console output: https://syzkaller.appspot.com/x/log.txt?x=1110bfe2580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=39f8a155475bc42d
dashboard link: https://syzkaller.appspot.com/bug?extid=0391d34e801643e2809b
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
userspace arch: arm64

Note: no patches were applied.
