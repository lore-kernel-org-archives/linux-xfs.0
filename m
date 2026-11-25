Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795600351;
	b=w7K6OIGdqdCxwgwGc+IbOtQ4o/dXlNNMKkg2txLyEV+d/Iw+xv9eDkH00/qG9195tyD5
	 nJQmRccJ2FKS8ylDoTBFRqhCRz5UtzizWmzRj60yYotQDS+ssJborMt8f2vZ+rb05HrJ6
	 tQh1ZOKYOhkBfsO0NMYnquU1AjAFTM9ErpkJXDGydQ3DnabmKOEYYa+HY8UAo7jz/lcrH
	 oUY+f/Qf1bSA2Ano/d5u6G1M518zlbwgTTCAqkpPHhZodxTuUVnHe82wsHNqd1aCGBHk7
	 r0eE2mBiKdzETCQ4YhKuFFUocFe7syVmg+3FUp9rONTAiFPn/0irMSIFClLQAn3FXOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795600351;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:MIME-Version:X-Received:Date:In-Reply-To:
	 X-Google-Appengine-App-Id:X-Google-Appengine-App-Id-Alias:Message-ID:
	 Subject:From:To:Content-Type;
	bh=rDYrI57ud55NSWOFxTgViyOGUhOW41DRxkpMLR6U21w=;
	b=X1CqDj7njeTpxommGVApeB3zORbH1L6qOnPEfn+Fv+25+S/N2gmPow81qYDTqcI6hBu4
	 hpLZCyE5hP47+JhBg0QEy6NyfXWDmWpN9n6PCaT+RO3PYUcO/jC3OAzC1LojuWz2AK6ap
	 TjUOdv1JoD4b6m+KljKM8dVxEespAJ35BSAp3GrUHcM6YqbRvkbcDSFwmQJXSrgWyIt/H
	 oUYZZK3TBL8AYVZg4wH2ZXRYlX+/rGtdk/9RPBbnoP5ahWyXXdoNgHzzxTIs8DC2+FAFB
	 vJYALxe9wwA6bA60mKHmj/q3kKf0bt5wnu0BTo3bt0Q9a34zubCZW30mchhZ1m0w75g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.200
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 010A7606A31E
	for <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2026 09:52:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 010A7606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4c467e19391so8072437b6e.3
        for <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2026 01:52:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795600350; x=1796205150;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=rDYrI57ud55NSWOFxTgViyOGUhOW41DRxkpMLR6U21w=;
        b=JcQcwTe/l68gy4cSJvJdB7egGM/Aciru/MjcpyVCCup465VRDXnKTj1KipNn1nRrsR
         O0/t7UITRF7chM82GGng5RaLl+R+tNW6pc101C6sBpAiTTbIbKOpolgOKKC9ZYuU342n
         CdiCaLNOYzbph0a2NFEYsIY3SogX7NroUTYve4x0lULkCcGDyrjUK2CTq0LgOZSF6jMd
         1MLEMEuAmYtif9N6gTLowQcj7vnuPVXfrqOVZpEgDB9wamUb+1scTr9YezAnFjrXSYzP
         SCVdndEJYZXTekm4uSpyLPKNtN3OtAw1MXdkfWvwdlYGmajfkNo2ZxGFoedzuaceNfLM
         Bifw==
X-Forwarded-Encrypted: i=1; AL+hErEEUm4+wu+uf+2yOsU99gQOiqIBj+lq3EMfh1OTU6GFoMHmJqBzQTeqYo4YXWzC2H1aSgFMA/g+6oI=@vger.kernel.org
X-Gm-Message-State: APuU4Z8GmVdjNmCCiodQhOHW9uvCxpS0R74QrVgvuaj8q23kR4ZY8oLM
	kRVooSZDPUQHwLn7foehO2V7yHCc+po7HL4AcLUhc+qPJYBdeuItTIgnFNqk6WFaofVn1LcHfeW
	18YSYF1vB4c96ztpWehXz0xmSWrMaN3AvjaI0emawtd2VjWbGirWXmlKdjpQ=
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:16a1:b0:572:d0fb:ae64 with SMTP id
 5614622812f47-57a0bb6f16fmr17558738b6e.54.1795600349928; Wed, 25 Nov 2026
 01:52:29 -0800 (PST)
Date: Wed, 25 Nov 2026 01:52:29 -0800
In-Reply-To: <6b048c5c.a481e175.27cf24.0021.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6b06afdd.9416b02e.106116.000e.GAE@google.com>
Subject: Re: [syzbot] [iomap?] WARNING in iomap_release_folio
From: syzbot <syzbot+daa4cd155cd8696efe4f@syzkaller.appspotmail.com>
To: almaz.alexandrovich@paragon-software.com, brauner@kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    4dce97c6c265 Merge tag 'ext4_for_linus-7.4-rc5' of git://g..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
console output: https://syzkaller.appspot.com/x/log.txt?x=13bc88e9580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fbd0fc734eea62ed
dashboard link: https://syzkaller.appspot.com/bug?extid=daa4cd155cd8696efe4f
compiler:       Debian clang version 22.1.8 (1~deb13u5), Debian LLD 22.1.8
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=112662bd580000

The issue was bisected by AI to:

commit 099ef9ab9203dff327f2d61e44773f9acbc01f13
Author: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Date:   Fri Dec 26 13:45:19 2025 +0000

    fs/ntfs3: implement iomap-based file operations

AI reasoning:   https://syzkaller.appspot.com/ai_job?id=e3505470-e7cd-4afa-9bd4-3a5bf01c3027

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

The cause commit was identified by AI and may be wrong.
If you agree with it, please also add:
Fixes: 099ef9ab9203 ("fs/ntfs3: implement iomap-based file operations")

------------[ cut here ]------------
ifs_is_fully_uptodate(folio, ifs) != folio_test_uptodate(folio)
WARNING: fs/iomap/buffered-io.c:295 at ifs_free+0x22d/0x2c0 fs/iomap/buffered-io.c:294, CPU#0: syz-executor112/5663
Modules linked in:
CPU: 0 UID: 0 PID: 5663 Comm: syz-executor112 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:ifs_free+0x22d/0x2c0 fs/iomap/buffered-io.c:294
Code: 41 5f 5d e9 55 0a bb ff e8 30 8e 4d ff 90 0f 0b 90 e9 0a ff ff ff e8 22 8e 4d ff 90 0f 0b 90 e9 3a ff ff ff e8 14 8e 4d ff 90 <0f> 0b 90 eb c7 44 89 f9 80 e1 07 80 c1 03 38 c1 0f 8c 3d fe ff ff
RSP: 0018:ffffc90003b2f938 EFLAGS: 00010293
RAX: ffffffff827bc41c RBX: ffff8880147a7f80 RCX: ffff888036eea580
RDX: 0000000000000000 RSI: 0000000000000008 RDI: 0000000000000000
RBP: 00000000827c4201 R08: ffffea00013c5487 R09: 1ffffd4000278a90
R10: dffffc0000000000 R11: fffff94000278a91 R12: dffffc0000000000
R13: 1ffffd4000278a95 R14: 0000000000000008 R15: 0000000000000000
FS:  000055555a32a400(0000) GS:ffff88808a9e9000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f3c023b7000 CR3: 0000000013fb5000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 iomap_release_folio+0x254/0x450 fs/iomap/buffered-io.c:826
 mapping_evict_folio+0x348/0x470 mm/truncate.c:374
 mapping_try_invalidate+0x260/0x4b0 mm/truncate.c:605
 generic_fadvise+0x610/0x750 mm/fadvise.c:157
 vfs_fadvise mm/fadvise.c:184 [inline]
 ksys_fadvise64_64 mm/fadvise.c:197 [inline]
 __do_sys_fadvise64 mm/fadvise.c:209 [inline]
 __se_sys_fadvise64 mm/fadvise.c:207 [inline]
 __x64_sys_fadvise64+0x145/0x190 mm/fadvise.c:207
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x171/0x540 arch/x86/entry/syscall_64.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f3c023eea2a
Code: 10 00 00 00 48 63 4c 24 30 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 eb a2 e8 f1 18 00 00 90 41 89 ca b8 dd 00 00 00 0f 05 <89> c2 f7 da 3d 00 f0 ff ff b8 00 00 00 00 0f 47 c2 c3 0f 1f 40 00
RSP: 002b:00007ffd9854b3c8 EFLAGS: 00000246 ORIG_RAX: 00000000000000dd
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f3c023eea2a
RDX: 0000000000001000 RSI: 0000000000000000 RDI: 0000000000000003
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000004 R11: 0000000000000246 R12: 00007ffd9854c520
R13: 0000000000000000 R14: 0000000000000001 R15: 00007ffd9854b410
 </TASK>
