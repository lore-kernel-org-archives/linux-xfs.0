Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795460189;
	b=YJ2pJy6BYtND2y/bvSebYEQZzcSQYdwMOEXGBRH+elefnYrjviKXroqEap7cWHhux7wW
	 TYW52rB8shZ96wL0w1FRrTw89hRAJU/NHSFIUd0Xvxs/ogHUsl6mA3ZgpyierrKh5kzPU
	 PVItBF2bbySziqzMlo9fcfdB9zNNfUyurqS5qfEfwJXZxJcKs5V7AncqRuouJeLDODnoT
	 tH+og35uj2gTPQ4GJY3x3paJVZxZFgQ52OEKWjwPeZg7s2VefhKwJ7p6Y/zrVT++TbJnB
	 hxnSd2mxMoG+/8XWgWZew2okWVbtc08myEd/CHF4lSEjzNGCQFmmlbgMgzM4/lo6pnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795460189;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:MIME-Version:X-Received:Date:
	 X-Google-Appengine-App-Id:X-Google-Appengine-App-Id-Alias:Message-ID:
	 Subject:From:To:Content-Type;
	bh=OnczQ3wxMDViQssbLqUHjFh88GfCTCb774Gt0G83kDQ=;
	b=Qzl/PhLPjoVPRXwBXUYNaAaesIqx93liXDmXY1eToWSKs5ASY7MNrvlZCF6edLrHafqL
	 K8rTuQteJXdKMOu0tBsiStAPAaABMZM6c9gm1ALgnWZhZlFn04EkDnjyElTgbbJ1A/kUU
	 fCdjMytDw/om8phPHQFXwxqdN+3jsXqzMGiwcQdh5c/Y6lyorOEGyPY/b4NKG6r5iPegF
	 pnHyMcuXSt+WXA26aR8gRyJEUzyW+XtO2Sl+08bc7wkOw1+5M9n+yNcByv7OJFJOA4I+5
	 5KCgS+5U3TkGYeAX9i4UVmA7RMFH9pwIHkIOCoYiZi5c5D8+2+3JSjzXGK/XeOqaFZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.210.70
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60151606A331
	for <linux-xfs@vger.kernel.org>; Mon, 23 Nov 2026 18:56:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 60151606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-83edc5c5ae9so3812160a34.1
        for <linux-xfs@vger.kernel.org>; Mon, 23 Nov 2026 10:56:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795460188; x=1796064988;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OnczQ3wxMDViQssbLqUHjFh88GfCTCb774Gt0G83kDQ=;
        b=vRzmsdo5Fm9ZjoEsTgWfkyrY++1+z5I6gFozxxC0aFTWl9gBRsuZP9giO6S7JPHJoI
         5PNOHkO918QL3JHIYwnYxPzwJL45FJGdxffQ8n3mjo4Tm+UrLUH/kLT4ZYA9WG07yDoL
         gYi58PHJngJ7zySUjwwlz/F0PWOSjMFUoWe+hTPhcz7IL3FiqJXfO/ISbGGNlMVmKfZU
         eybYa8NojPariRnRcmtZBb4+dYD5msxn41hUARWKcS0kxvfanulKfBQ7fmDPq6Rez828
         emUdKstLEC/TqSUcZFzD0Rkr4IhS4n9AiZ+ILd7W2uVyApjV0KULYUjOcA0CfVKhWhtZ
         nZtQ==
X-Forwarded-Encrypted: i=1; AL+hErGfru7LEk4uyU6atyDNfjvlYz83GpqcS8p12a+BcGEp74E19tQ8LDvb5mf9STy5By41IyMbOAMoWHY=@vger.kernel.org
X-Gm-Message-State: APuU4Z/2u4wDtPQkOAeM4QIU6EDDUEqdjxgAG4PPRUMjUE8h9+kcpP02
	xB9SZx9NfKU8EpEfxG/ZH1JFaM8tE5bbruC/wEX/oik71XegvJdpM6RII7/Y8TfDGQbJ0uO5khX
	Jb7cKHMFcx9dnCqn+tIAZDAhTDJTatd1m25BaU6dVh8pQxeocz3CruBifaos=
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:6f97:b0:573:30a5:f24d with SMTP id
 5614622812f47-57a0a10c7f6mr13468904b6e.17.1795460188434; Mon, 23 Nov 2026
 10:56:28 -0800 (PST)
Date: Mon, 23 Nov 2026 10:56:28 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6b048c5c.a481e175.27cf24.0021.GAE@google.com>
Subject: [syzbot] [iomap?] WARNING in iomap_release_folio
From: syzbot <syzbot+daa4cd155cd8696efe4f@syzkaller.appspotmail.com>
To: brauner@kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    4843f6873f7c Merge tag 'sysctl-7.04-fixes-rc4' of git://gi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=106a12b5580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3cc6a7ee2d24d208
dashboard link: https://syzkaller.appspot.com/bug?extid=daa4cd155cd8696efe4f
compiler:       Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/98fce4d0b21b/non_bootable_disk-4843f687.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/86db8b334894/vmlinux-4843f687.xz
kernel image: https://storage.googleapis.com/syzbot-assets/94ea4dad441a/bzImage-4843f687.xz

AI-generated root cause summary:
`ntfs3` registers iomap folio lifecycle callbacks (`iomap_dirty_folio` and
`iomap_release_folio`) on `ntfs_aops` and `ntfs_aops_cmpr`, which attach a
per-block `struct iomap_folio_state` (`ifs`) to folios whenever
`i_blocks_per_folio(inode, folio) > 1` (such as when NTFS cluster size is
smaller than `PAGE_SIZE`). However, `ntfs_read_folio()` in `fs/ntfs3/inode.c`
directly calls `folio_mark_uptodate(folio)` instead of
`iomap_folio_mark_uptodate(folio)` when `ni->i_valid <= vbo` (and the same
pattern appears in `ni_read_folio_cmpr`, `ntfs_compress_write`, and
`attr_make_nonresident`). If an earlier incomplete or aborted iomap
write/zero-range operation left `ifs` attached to an `!uptodate` folio,
`folio_mark_uptodate()` sets `PG_uptodate` without updating the `ifs->state`
uptodate bitmap. When kswapd later reclaims the clean folio via
`iomap_release_folio()` -> `ifs_free()`, `ifs_is_fully_uptodate(folio, ifs) !=
folio_test_uptodate(folio)` triggers the `WARN_ON_ONCE`.

full analysis:  https://syzkaller.appspot.com/x/ai_root_cause?x=daa4cd155cd8696efe4f

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+daa4cd155cd8696efe4f@syzkaller.appspotmail.com

------------[ cut here ]------------
ifs_is_fully_uptodate(folio, ifs) != folio_test_uptodate(folio)
WARNING: fs/iomap/buffered-io.c:295 at ifs_free+0x22d/0x2c0 fs/iomap/buffered-io.c:294, CPU#0: kswapd0/84
Modules linked in:
CPU: 0 UID: 0 PID: 84 Comm: kswapd0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:ifs_free+0x22d/0x2c0 fs/iomap/buffered-io.c:294
Code: 41 5f 5d e9 55 0a bb ff e8 30 8e 4d ff 90 0f 0b 90 e9 0a ff ff ff e8 22 8e 4d ff 90 0f 0b 90 e9 3a ff ff ff e8 14 8e 4d ff 90 <0f> 0b 90 eb c7 44 89 f9 80 e1 07 80 c1 03 38 c1 0f 8c 3d fe ff ff
RSP: 0018:ffffc90000ed67e0 EFLAGS: 00010293
RAX: ffffffff827bbe6c RBX: ffff88803922d400 RCX: ffff8880338a8000
RDX: 0000000000000000 RSI: 0000000000000008 RDI: 0000000000000000
RBP: 00000000827c3c01 R08: ffffea0000538607 R09: 1ffffd40000a70c0
R10: dffffc0000000000 R11: fffff940000a70c1 R12: dffffc0000000000
R13: 1ffffd40000a70c5 R14: 0000000000000008 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88808a9ea000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fb6145bafe8 CR3: 000000004527b000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 iomap_release_folio+0x254/0x450 fs/iomap/buffered-io.c:826
 shrink_folio_list+0x22e2/0x4d90 mm/vmscan.c:1569
 evict_folios+0x3326/0x4390 mm/vmscan.c:5097
 try_to_shrink_lruvec+0xf22/0x1630 mm/vmscan.c:5271
 shrink_one+0x312/0x10f0 mm/vmscan.c:5318
 shrink_many mm/vmscan.c:5381 [inline]
 lru_gen_shrink_node mm/vmscan.c:5459 [inline]
 shrink_node+0x631e/0x6c50 mm/vmscan.c:6465
 kswapd_shrink_node mm/vmscan.c:7258 [inline]
 balance_pgdat mm/vmscan.c:7429 [inline]
 kswapd+0x1ff4/0x3a20 mm/vmscan.c:7705
 kthread+0x38b/0x480 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
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
