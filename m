Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED03B4E06C6
	for <linux-xfs@vger.kernel.org>; Wed, 16 Sep 2026 22:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789598798; cv=none; b=tVmr2dJERya5tDgbyqj1GSvbwwRhnNzScCClgPTFrIuVX3CZgyg9YCvFoCMY0fz7dUiYhka5jOms16xCQDGRlKPAH3ia+pqCG6m69VLhstc00ym1zBD1lTV0Vdl0cmZmChNrvQm+RC8Jclcuw9vvniWxVqfwvu8TI9d2hUCx9xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789598798; c=relaxed/simple;
	bh=LCKg0MXz47Q9n7t/K46oO0BkUTa0dHYB5QwrbZcHbVE=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=gOtEZueJaN3Ti69SBZ3LBlawYN6UJZUaL21nhpGy9282rIXmhRCWHTCi8bpVtymxUPB714VRDdgUI6q8x5Qj/P87yJTNp6iB2zsgaEreLMJMSIOlLwetiG9tRH+oj8fCcYNEMniJr28W5hHsJojarLSy2H3oeDs59JIXtAf2cYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-7f4e9fe8b17so289234a34.1
        for <linux-xfs@vger.kernel.org>; Wed, 16 Sep 2026 15:46:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789598787; x=1790203587;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=LcizwlFxn2dDfjlSrFy6ssnr9nUP1n7/qJEJqqsStLE=;
        b=hhVt5SmHEBE3/TRFdWDPx8G/6okttTDQn8ozQm9DY8ryLZRFBZxMiNUagBG0BWt1Xn
         CNUPa+zaWtgQwsm+8RBCTkIUGfQzNQdVVrRNKc2whOtXDgWU+MjK2PaEE6q1SfkygS9B
         //Dn3FCjhaDKedxRVi9FyOc459VzrD2laUTqxDcy9MrBR9UsUWN88w9av4aW5MlHjhg4
         S8KAEcfOeSlZGC8Ms3d9XmGLIAi4FCo1eSBFPe5v1HGouYXMfzHT+qsui8bFrk1SVT8i
         j+UAJESccQGAAeEIyLrUmVTtv2pEK1CAI2Qj4KnZ03bw1Sglr9u634Qa+qSmBScAF9NW
         nXJw==
X-Forwarded-Encrypted: i=1; AKwUvBw/CBiUVkIwqQRFgL2MsUavjzYOAih56AGtHyRlTJ9cs5n+ah+os+xuf24vPWeUlJ+S99SOGyrh3Do=@vger.kernel.org
X-Gm-Message-State: AFuF++n5L2RN3oyETENcckeLtLmAahDx904rFxxrJ87QyeBVOFpqC7YL
	6jQiAF+KQW3Ix2M1BrJUMzuR+D7KEhSZJHcc3fCkAmZZDtB4W6dCVjBqd9njoqLov1TyqQmPHaZ
	p4wNGrMWetOw+oRq8zXgJ5CklDyxoj9BgRkoFrbpTbACOkNEe/1MpWDz0V8g=
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1897:b0:6b7:46fc:1d7 with SMTP id
 006d021491bc7-6c7d41de430mr4519967eaf.54.1789598787523; Wed, 16 Sep 2026
 15:46:27 -0700 (PDT)
Date: Wed, 16 Sep 2026 15:46:27 -0700
In-Reply-To: <6aa8be26.a211d2ce.1a5198.02a4.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6aab1c43.71f81b7d.278072.0001.GAE@google.com>
Subject: Re: [syzbot] [iomap?] WARNING in iomap_read_inline_data (2)
From: syzbot <syzbot+079e16bc964fb91acb4a@syzkaller.appspotmail.com>
To: brauner@kernel.org, djwong@kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    9b87fdc9af2f Merge tag 'sched_ext-for-7.3-rc3-fixes' of gi..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
console output: https://syzkaller.appspot.com/x/log.txt?x=110993f9580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8c5c3949d762a91f
dashboard link: https://syzkaller.appspot.com/bug?extid=079e16bc964fb91acb4a
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=150993f9580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+079e16bc964fb91acb4a@syzkaller.appspotmail.com

------------[ cut here ]------------
size > iomap->length
WARNING: fs/iomap/buffered-io.c:431 at iomap_read_inline_data+0x901/0xc10 fs/iomap/buffered-io.c:431, CPU#1: syz-executor183/6038
Modules linked in:
CPU: 1 UID: 0 PID: 6038 Comm: syz-executor183 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:iomap_read_inline_data+0x901/0xc10 fs/iomap/buffered-io.c:431
Code: ff ff ff e8 31 37 51 ff 48 c7 c6 20 6b 0a 8c 48 89 ef e8 52 d9 a4 ff 90 0f 0b e8 4a 7a c4 ff e9 46 f7 ff ff e8 10 37 51 ff 90 <0f> 0b 90 48 b8 00 00 00 00 00 fc ff df 4c 89 fa 48 c1 ea 03 80 3c
RSP: 0000:ffffc90003357538 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffffc90003357790 RCX: 0000000000000000
RDX: ffff888029fa4b00 RSI: ffffffff82bae840 RDI: ffff888029fa4b00
RBP: ffffea0001030f80 R08: 0000000000000006 R09: 0000000000000005
R10: 0000000000000014 R11: 0000000000000000 R12: 0000000000000014
R13: ffffc900033577b8 R14: ffffc900033577e8 R15: ffffc900033577c0
FS:  00007f4d0baf66c0(0000) GS:ffff8880d5c59000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f4d0a2f1000 CR3: 0000000059e5c000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 iomap_read_folio_iter+0xc35/0xfd0 fs/iomap/buffered-io.c:571
 iomap_read_folio+0x392/0x980 fs/iomap/buffered-io.c:676
 ntfs_read_folio+0x298/0x4b0 fs/ntfs3/inode.c:856
 filemap_read_folio+0xfc/0x3b0 mm/filemap.c:2520
 filemap_fault+0x24b8/0x3130 mm/filemap.c:3689
 __do_fault+0x10b/0x440 mm/memory.c:5565
 do_read_fault mm/memory.c:6000 [inline]
 do_fault+0xb3f/0x1830 mm/memory.c:6134
 do_pte_missing mm/memory.c:4700 [inline]
 handle_pte_fault mm/memory.c:6558 [inline]
 __handle_mm_fault+0x150b/0x2f60 mm/memory.c:6707
 handle_mm_fault+0x363/0xa20 mm/memory.c:6876
 do_user_addr_fault+0x59c/0x12f0 arch/x86/mm/fault.c:1343
 handle_page_fault arch/x86/mm/fault.c:1483 [inline]
 exc_page_fault+0x6f/0xd0 arch/x86/mm/fault.c:1536
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:595
RIP: 0033:0x7f4d0cb0af39
Code: 00 ba 04 00 00 00 be 00 10 00 00 48 89 df e8 7e 3e 02 00 8b 3d e0 4b 0c 00 b9 04 00 00 00 31 f6 ba 00 10 00 00 e8 87 34 02 00 <0f> b6 03 88 44 24 0f 8b 05 be 4b 0c 00 85 c0 74 c6 be 00 10 00 00
RSP: 002b:00007f4d0baf6200 EFLAGS: 00010207
RAX: 0000000000000000 RBX: 00007f4d0a2f1000 RCX: 00007f4d0cb2e3ca
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000003
RBP: 0000000000000021 R08: 0000000000000003 R09: 0000000000000000
R10: 0000000000000004 R11: 0000000000000246 R12: ffffffffffffffd0
R13: 0000000000000002 R14: 00007ffe1da2f580 R15: 00007ffe1da2f668
 </TASK>


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
