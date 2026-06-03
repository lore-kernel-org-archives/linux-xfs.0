Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com [209.85.160.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D23AD37FF40
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jun 2026 06:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780468989; cv=none; b=D04iGMZI8V9AjS6R7PhQFS9gzTu3BFZc9SFkWpCjFX6YLYSjVQ4cUDZmchbDDelKc9xHC0cqABD7bOcSYWIdhadhkDaxEzKi0EH98gMhQ2CI4tU34XtFdecXoLGQvmW09O1xw1E4Xv6a/G9v0BxuW3XFKTck1sfszjTEKVBavNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780468989; c=relaxed/simple;
	bh=CGT7gEJWsfdmL4PputUa7LMdCWKNz5EziUoO4YB1Cv0=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=N+JgO8MgOHTg1Lu3ulFZjP5JEFWQU9PDW4GINEl+/f43eY8HTaePOS8FdnT10jmaC9APhMdNzCsVAdvhGq/0cSSksFn6fhRVksz3tMttidRHwZI1FTwaMUqPZHMBOXM7gjhi2TBOyVyx3YVfQEBByjVmW0/D+87qchNSfxBPLmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.160.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-43d1e8bbb82so3785843fac.2
        for <linux-xfs@vger.kernel.org>; Tue, 02 Jun 2026 23:43:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780468987; x=1781073787;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BXLTeHlKrc/+j7C9QPbOJLUrs1rqjWUe2L1pYvC54MA=;
        b=PJ169M3HTomBhdCIIrcNwaa3ARIkooQCMIwfSvJN7WyqmEO3zczZcRhbr5y59ptnBO
         1++SPSGtA4TQefISA8+WvrE+LUBQitXa9aPxxjgDBITupQ0id+fWF2cHwzBegPbnIm9X
         mZUoxf4QPTH/YO/ifAMqZYdMmHPGDt5/q8d6J7PrHtu+6J9DlWdRsSddnaZJcEWwZKOT
         r6AYX6IN7PjtCxJm7+hJL879DSA6BZBiNV/1wrPzTpDw4hG0UorRG+OajmSJFZ2hrUD4
         TBr5v8T2tXIHLfXkrfluYAmERFrXOJarb6DLDVx5Fq7zmUVvjg3o05fc4BcJTYQWj8tw
         FkLQ==
X-Forwarded-Encrypted: i=1; AFNElJ+8bWyCoEFa/YHKYF4VBo9rjDO8E+fXrSdaRfJC2jQuPNDMn1k+zJqHJ/dhxEFjNtJS47sed6EBrbM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/NntNaaFGL1JSNh1nK/fO3FqkHMTQzkkVXdVW4xOEbPLrxULI
	fVOGeONkZqJ1i3vAT4VfIuShGuqnGzzJlruFHHhuLLaX3YU72igZTr9n/uzlpzD0lHqpSDjErnu
	BEnd3VWznbYTiEyRIc8wFhR2oW09/7yd/FWw/lpuWSlM9+kmjuZ5OM4PnmGM=
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:180c:b0:696:637e:4831 with SMTP id
 006d021491bc7-69e47f0669emr1446323eaf.25.1780468986990; Tue, 02 Jun 2026
 23:43:06 -0700 (PDT)
Date: Tue, 02 Jun 2026 23:43:06 -0700
In-Reply-To: <20260602-work-super-bdev_holder_global-v1-0-bb0fd82f3861@kernel.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a1fccfa.278b5b03.2bcf39.0048.GAE@google.com>
Subject: [syzbot ci] Re: fs: support freeze/thaw/mark_dead/sync with shared devices
From: syzbot ci <syzbot+ci2e0a11d6a5730bb0@syzkaller.appspotmail.com>
To: axboe@kernel.dk, brauner@kernel.org, cem@kernel.org, clm@fb.com, 
	dsterba@suse.com, hch@lst.de, jack@suse.cz, linux-block@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, tytso@mit.edu, 
	viro@zeniv.linux.org.uk, xiang@kernel.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] fs: support freeze/thaw/mark_dead/sync with shared devices
https://lore.kernel.org/all/20260602-work-super-bdev_holder_global-v1-0-bb0fd82f3861@kernel.org
* [PATCH RFC 1/8] fs, block: move blk_mode_t and fop_flags_t into <linux/types.h>
* [PATCH RFC 2/8] fs: add a global device to super block hash table
* [PATCH RFC 3/8] fs: refuse to claim any frozen block device
* [PATCH RFC 4/8] xfs: port to fs_bdev_file_open_by_path()
* [PATCH RFC 5/8] btrfs: open via dedicated fs bdev helpers
* [PATCH RFC 6/8] ext4: open via dedicated fs bdev helpers
* [PATCH RFC 7/8] erofs: open via dedicated fs bdev helpers
* [PATCH RFC 8/8] super: make fs_holder_ops private

and found the following issue:
general protection fault in close_fs_devices

Full report is available here:
https://ci.syzbot.org/series/9511f00a-a3c2-44ab-9a0b-2d65de5bbd49

***

general protection fault in close_fs_devices

tree:      bpf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf-next.git
base:      254f49634ee16a731174d2ae34bc50bd5f45e731
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/4af26755-5773-453e-807d-ee451d2fdec5/config
syz repro: https://ci.syzbot.org/findings/2d8d96f7-d133-47dc-b4ca-5c0c65e1b6c9/syz_repro

btrfs: Deprecated parameter 'usebackuproot'
BTRFS warning: 'usebackuproot' is deprecated, use 'rescue=usebackuproot' instead
BTRFS: device fsid ed167579-eb65-4e76-9a50-61ac97e9b59d devid 1281 transid 8 /dev/loop1 (7:1) scanned by syz.1.18 (5863)
Oops: general protection fault, probably for non-canonical address 0xdffffc00000000f8: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x00000000000007c0-0x00000000000007c7]
CPU: 1 UID: 0 PID: 5863 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:btrfs_close_bdev fs/btrfs/volumes.c:1140 [inline]
RIP: 0010:btrfs_close_one_device fs/btrfs/volumes.c:1161 [inline]
RIP: 0010:close_fs_devices+0x47c/0x860 fs/btrfs/volumes.c:1204
Code: 3c 08 00 74 08 48 89 ef e8 b1 95 38 fe 48 8b 6d 00 b8 c0 07 00 00 48 01 c5 48 89 e8 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <80> 3c 08 00 74 08 48 89 ef e8 86 95 38 fe 48 8b 75 00 4c 89 ff e8
RSP: 0018:ffffc90004007a48 EFLAGS: 00010202
RAX: 00000000000000f8 RBX: 1ffff110368c440b RCX: dffffc0000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 00000000000007c0 R08: ffff8881b462206f R09: 1ffff110368c440d
R10: dffffc0000000000 R11: ffffed10368c440e R12: ffff8881b4622000
R13: ffff8881b4622068 R14: ffff8881b4622058 R15: ffff8881707b7a00
FS:  00007f849d6ce6c0(0000) GS:ffff8882a9292000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f849c786a00 CR3: 00000001bbbcc000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 btrfs_close_devices+0xcd/0x570 fs/btrfs/volumes.c:1219
 btrfs_free_fs_info+0x4f/0x360 fs/btrfs/disk-io.c:1205
 deactivate_locked_super+0xbc/0x130 fs/super.c:477
 btrfs_get_tree_super fs/btrfs/super.c:-1 [inline]
 btrfs_get_tree_subvol fs/btrfs/super.c:2087 [inline]
 btrfs_get_tree+0xca6/0x1910 fs/btrfs/super.c:2121
 vfs_get_tree+0x92/0x2a0 fs/super.c:1928
 fc_mount fs/namespace.c:1193 [inline]
 do_new_mount_fc fs/namespace.c:3758 [inline]
 do_new_mount+0x341/0xd30 fs/namespace.c:3834
 do_mount fs/namespace.c:4167 [inline]
 __do_sys_mount fs/namespace.c:4383 [inline]
 __se_sys_mount+0x31d/0x420 fs/namespace.c:4360
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f849c79e0ca
Code: 48 c7 c2 e8 ff ff ff f7 d8 64 89 02 b8 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f849d6cde58 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007f849d6cdee0 RCX: 00007f849c79e0ca
RDX: 00002000000055c0 RSI: 0000200000000340 RDI: 00007f849d6cdea0
RBP: 00002000000055c0 R08: 00007f849d6cdee0 R09: 0000000000000408
R10: 0000000000000408 R11: 0000000000000246 R12: 0000200000000340
R13: 00007f849d6cdea0 R14: 00000000000055f5 R15: 0000200000000380
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:btrfs_close_bdev fs/btrfs/volumes.c:1140 [inline]
RIP: 0010:btrfs_close_one_device fs/btrfs/volumes.c:1161 [inline]
RIP: 0010:close_fs_devices+0x47c/0x860 fs/btrfs/volumes.c:1204
Code: 3c 08 00 74 08 48 89 ef e8 b1 95 38 fe 48 8b 6d 00 b8 c0 07 00 00 48 01 c5 48 89 e8 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <80> 3c 08 00 74 08 48 89 ef e8 86 95 38 fe 48 8b 75 00 4c 89 ff e8
RSP: 0018:ffffc90004007a48 EFLAGS: 00010202

RAX: 00000000000000f8 RBX: 1ffff110368c440b RCX: dffffc0000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 00000000000007c0 R08: ffff8881b462206f R09: 1ffff110368c440d
R10: dffffc0000000000 R11: ffffed10368c440e R12: ffff8881b4622000
R13: ffff8881b4622068 R14: ffff8881b4622058 R15: ffff8881707b7a00
FS:  00007f849d6ce6c0(0000) GS:ffff8882a9292000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000557941c2b058 CR3: 00000001bbbcc000 CR4: 00000000000006f0
----------------
Code disassembly (best guess):
   0:	3c 08                	cmp    $0x8,%al
   2:	00 74 08 48          	add    %dh,0x48(%rax,%rcx,1)
   6:	89 ef                	mov    %ebp,%edi
   8:	e8 b1 95 38 fe       	call   0xfe3895be
   d:	48 8b 6d 00          	mov    0x0(%rbp),%rbp
  11:	b8 c0 07 00 00       	mov    $0x7c0,%eax
  16:	48 01 c5             	add    %rax,%rbp
  19:	48 89 e8             	mov    %rbp,%rax
  1c:	48 c1 e8 03          	shr    $0x3,%rax
  20:	48 b9 00 00 00 00 00 	movabs $0xdffffc0000000000,%rcx
  27:	fc ff df
* 2a:	80 3c 08 00          	cmpb   $0x0,(%rax,%rcx,1) <-- trapping instruction
  2e:	74 08                	je     0x38
  30:	48 89 ef             	mov    %rbp,%rdi
  33:	e8 86 95 38 fe       	call   0xfe3895be
  38:	48 8b 75 00          	mov    0x0(%rbp),%rsi
  3c:	4c 89 ff             	mov    %r15,%rdi
  3f:	e8                   	.byte 0xe8


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a patch for this bug, please reply with `#syz test`
(should be on a separate line).

The patch should be attached to the email.
Note: arguments like custom git repos and branches are not supported.
