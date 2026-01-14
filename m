Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5F9D393DF0
	for <linux-xfs@vger.kernel.org>; Wed, 14 Jan 2026 12:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768392478; cv=none; b=sMJZN8ww8zwNDTpQH8s3KIR35Y7yUhNPhuxwjCeYMrGt91UaqcH+3Hv+veFaoTMpnLYSWWoxzwvPetDSbd5nsPwTbHN3vGoGmBIx7ZEdy26zp3quPDh1jytLjzsdgpFqAbwn1RncITKW/ntcBzlrVnEZE5Vv7W5sfy5kWhBaFyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768392478; c=relaxed/simple;
	bh=dk+MG0j/Q/ggsQkChPgCUEhcTK+ZpBuj8ngUiKB1Vsg=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=ZcmWGUpBsVHKSZX9WMrzcOdrZZeB8W/zBHOtaeA99oBGDZ+sHeocfqpbqGgVrvHmfrJDjO1Yy+4NgzJXLZ4HKDSrwYSvZizasu2v82rxcDhoNy/p94scc7obXI9s4ol9otxo+T+634Ln4G50f5BCg8i9J5J+uoyFZKsJWRv6jlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-450da1dcd2dso1697286b6e.1
        for <linux-xfs@vger.kernel.org>; Wed, 14 Jan 2026 04:07:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768392471; x=1768997271;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Af25JgVbYoOAoSQ+vle2hSLNYaFO30IFeCZiHf1EZB4=;
        b=Cx4rCeHQf8xywYW1T+DFH9k7fQ9uFBLenZkdyrTHbWRYXn7DdjUmXxrhwrN2XkfQLu
         SMW3wuv+C9Q7ljgW2GhFWnybEbLT2U8fovyz8DFJfepFFrLoQkDyKD50iqFjxi11AQK6
         i9fGV2KgY5sbnklGfx3MMDHFC4BxUnjxp1b3DnQ5PxIgla6YmnTDkT9h0IRDJqXGTyyr
         n2vQzJbSBp96rx80u+9oLF3urXEoqI8S4v0f1wZPO+FiOcgjF6sNTQPtQ1a/XkXXGzru
         +ZcYqCdXtQ7+6cZ4pfUz5b0bUpkI/m73T7X1bQYrUikX0yDKKCm0XN4wvJssYJKmL+oE
         kv0w==
X-Forwarded-Encrypted: i=1; AJvYcCX51pm36DOjNakMRTBkUqFg9EXqVKdwTguZU1wTlo+OAv+0LswAMiioFe+6oUQHbG+ngqRF1J1DSTU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyE7HYaKQSHyLjg+00JQjuoGfEUvxVx8f+Nd6xvQBito8MeOtEz
	J2S07NluoJStHcAqlG0IrmZLqLGeYAEuuM77294fwpv5lBHD8JPH0V/65jMcC1/w3OpPDe4xL8E
	sIANDyJgu2zSS13hbbYcKN/4xc8mpYpd0i/l/IKocZukek0BXAJ+wMp3Aca0=
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:11c4:b0:450:b249:71bb with SMTP id
 5614622812f47-45c621de113mr3245930b6e.19.1768392471315; Wed, 14 Jan 2026
 04:07:51 -0800 (PST)
Date: Wed, 14 Jan 2026 04:07:51 -0800
In-Reply-To: <20260114074113.151089-1-guzebing1612@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69678717.a70a0220.23fe94.0000.GAE@google.com>
Subject: [syzbot ci] Re: iomap: add allocation cache for iomap_dio
From: syzbot ci <syzbot+cibca756f676aaacf5@syzkaller.appspotmail.com>
To: brauner@kernel.org, changfengnan@bytedance.com, djwong@kernel.org, 
	guzebing1612@gmail.com, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v2] iomap: add allocation cache for iomap_dio
https://lore.kernel.org/all/20260114074113.151089-1-guzebing1612@gmail.com
* [PATCH v2] iomap: add allocation cache for iomap_dio

and found the following issue:
BUG: sleeping function called from invalid context in __iomap_dio_rw

Full report is available here:
https://ci.syzbot.org/series/2217a3d5-b2ea-47d6-9bca-2776e95fd748

***

BUG: sleeping function called from invalid context in __iomap_dio_rw

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      b2c43efc3c8d9cda34eb8421249d15e6fed4d650
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/1397dec0-a77b-450c-9c93-79aa717e1cff/config
C repro:   https://ci.syzbot.org/findings/b20bf03e-8485-4437-9a20-8d11cc0561d4/c_repro
syz repro: https://ci.syzbot.org/findings/b20bf03e-8485-4437-9a20-8d11cc0561d4/syz_repro

EXT4-fs (loop0): mounted filesystem 00000000-0000-0000-0000-000000000000 r/w without journal. Quota mode: none.
BUG: sleeping function called from invalid context at ./include/linux/sched/mm.h:321
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 5964, name: syz.0.17
preempt_count: 1, expected: 0
RCU nest depth: 0, expected: 0
1 lock held by syz.0.17/5964:
 #0: ffff88811839aa20 (&sb->s_type->i_mutex_key#9){++++}-{4:4}, at: inode_lock_shared include/linux/fs.h:995 [inline]
 #0: ffff88811839aa20 (&sb->s_type->i_mutex_key#9){++++}-{4:4}, at: ext4_dio_read_iter fs/ext4/file.c:78 [inline]
 #0: ffff88811839aa20 (&sb->s_type->i_mutex_key#9){++++}-{4:4}, at: ext4_file_read_iter+0x298/0x660 fs/ext4/file.c:145
Preemption disabled at:
[<ffffffff825b641d>] pcpu_cache_list_alloc fs/iomap/direct-io.c:129 [inline]
[<ffffffff825b641d>] __iomap_dio_rw+0x30d/0x2510 fs/iomap/direct-io.c:749
CPU: 0 UID: 0 PID: 5964 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x1a9/0x280 lib/dump_stack.c:120
 __might_resched+0x4b0/0x630 kernel/sched/core.c:8925
 might_alloc include/linux/sched/mm.h:321 [inline]
 slab_pre_alloc_hook mm/slub.c:4906 [inline]
 slab_alloc_node mm/slub.c:5241 [inline]
 __do_kmalloc_node mm/slub.c:5626 [inline]
 __kmalloc_noprof+0xbc/0x7d0 mm/slub.c:5639
 kmalloc_noprof include/linux/slab.h:961 [inline]
 pcpu_cache_list_alloc fs/iomap/direct-io.c:134 [inline]
 __iomap_dio_rw+0xbdd/0x2510 fs/iomap/direct-io.c:749
 iomap_dio_rw+0x45/0xb0 fs/iomap/direct-io.c:947
 ext4_dio_read_iter fs/ext4/file.c:94 [inline]
 ext4_file_read_iter+0x4f8/0x660 fs/ext4/file.c:145
 copy_splice_read+0x5ff/0xaa0 fs/splice.c:363
 do_splice_read fs/splice.c:981 [inline]
 splice_direct_to_actor+0x4a0/0xc70 fs/splice.c:1086
 do_splice_direct_actor fs/splice.c:1204 [inline]
 do_splice_direct+0x195/0x290 fs/splice.c:1230
 do_sendfile+0x535/0x7c0 fs/read_write.c:1370
 __do_sys_sendfile64 fs/read_write.c:1431 [inline]
 __se_sys_sendfile64+0x144/0x1a0 fs/read_write.c:1417
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xf0/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f8cd8b9acb9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffeab7c8828 EFLAGS: 00000246 ORIG_RAX: 0000000000000028
RAX: ffffffffffffffda RBX: 00007f8cd8e15fa0 RCX: 00007f8cd8b9acb9
RDX: 0000000000000000 RSI: 0000000000000004 RDI: 0000000000000004
RBP: 00007f8cd8c08bf7 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000fffe82 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f8cd8e15fac R14: 00007f8cd8e15fa0 R15: 00007f8cd8e15fa0
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.
