Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B0427144B
	for <linux-xfs@vger.kernel.org>; Mon, 19 Jan 2026 08:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768811729; cv=none; b=r5qb+MFa0YJ79eC4pPTtuuFrP1K9sZISN0iDEYikWEKbyG8pRGtxyeNgCocbVQWgmr9DYNztutBmIt7ZvgIE/wSrJXiMFA94t8C4IquqFgoMoBBoAyZv+sSgkBbR7t1yc4SbSjXHQk4dGjE9JoYXcbg9KOAsd8KxU6TWEti/sOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768811729; c=relaxed/simple;
	bh=gWBk0gqYc4nobpF5iIQB6kDckyNxgvkp2w1ihLHfcqM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QQUyTbHG8aR3lRR1VDzHKzapqsHZ5Jwsw8zT2GZhu5akai2vytZv4HXjk6oVJUTCuf7q1jBhiFRxFDfKMQdGAVx/jOTRJvl0IIMzsnEhTLS79CA4VUAKat5tAeiMPy/oF0HaJyEWtDsH/f+LvgSiQf/JH7mGQ58XREqcBK6btSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zRM5pQnz; arc=none smtp.client-ip=209.85.160.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zRM5pQnz"
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-4042f55de3aso3143029fac.1
        for <linux-xfs@vger.kernel.org>; Mon, 19 Jan 2026 00:35:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768811726; x=1769416526; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3WyNyQZRxDe8Jf9BT6NUtHQcdNjWnTF1PsvEzFWmQCk=;
        b=zRM5pQnzRsIsFjaRPjDVyJS7OCoNl7CsSXX3fKlY1Nk1pQISLUOSauwfPgmMq3vcew
         Ko8HytPLpV/tDt8rstjJls2fzUs9KD1g+6VxfuSiEr0eWaFGRQhB7WuqL57Xbxjew+eS
         vNP+5eIQAl6fqeH8KPTz3fCX2tdCtlbxmpJTTJ0231gxBMB8l7c1eyOfdoRchDcpE7fb
         5/IMncubedBL4utYPSPnquCKdJ2ykyN+iD3WBGnckrgPEp9B1IvB0vEL6n4S1B9FnH0l
         5cFjAvTNhBMaKejteJfzazHxkLdobGzQ2ejYOmGF/5prmCHNcD+xZQb7acUVabn6XOtd
         VghQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768811726; x=1769416526;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3WyNyQZRxDe8Jf9BT6NUtHQcdNjWnTF1PsvEzFWmQCk=;
        b=ePnafZyaPf4XEuPpzuZjX3DS8H+LA7rpCwjng9LgKjyPz3OR72HMq3LMPWRBsBON4Y
         NBC0+uX4d4dxyoJvyVjXtTbEucScm1dKAzSJDsB8jkCvIY/kkfqMIvZ2Y7EbMHt2t5ZM
         8zaz/i/onLe4MEZnuphdAJC7lYa8hcjftwnlhh8buJjk48TJJWD+z71L+6o/UnJUo0jb
         GE8mLR2bCeQozjlW+kwEA1fUxoPvg69wQejCi7tYU0UeHXC0P3SS//53r+84pAsNmIQX
         kkwULWyzqQiuxOBmQiWPHn/NcI2dD8dk/zh0MCAbW4OmdHC3iwd7ioO5WoNyOBndLOLb
         c+sg==
X-Forwarded-Encrypted: i=1; AJvYcCUbq60YEVELAzOZ7v83JpmEcxlN1jEB9GUsq6tcU2SZzvdChDFw1RrCyXVne5BMQ3qKYyR2KkriZ4E=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2fURpwruLywtxNuZgI4KnvLVXN2LyZNIoqpV4onHeU2MRn7u0
	DR19Ea0uyq0p38tT+d+EWBtnidSrElresm5dxCD2AOapnzmHtwJuVXi3sOmAwVuo05O5O1yDoY9
	F6JcdGsJJDo1jpupFFciR67ee0V0hUgZG+F0gcw9U
X-Gm-Gg: AY/fxX54NEMxGt+Wypgqalug72wHamk+NwP0h8USG4gEaIxiyRMgO1ngGU+xE9xM/OZ
	E+AM4m+dZXPbQBiXz74RpoR6EyRywhi1THTgnYaH4mDrwKRJqdPAZBeU5RdtpskkxVhlvS5lwwJ
	3N4B5ZFg7B+Gs/85KLOdVk3Y4HhpUI+Gjx5pHxUQa//JX4tc8gNunQtZNMWTXlPSPoP6sn8C0UW
	6hvss1Ms3gcsMRHS7JJ7CqGrwGC47Cs87VNSZpkv4peQJQpUD87rU4wXMSZQmeUaLHA57IWmkFr
	IhngGPINY5fomtUH5YXtQ16gTJs4Gv4EVHtk3lMOUTTe0Vbqcozvi4PL6A==
X-Received: by 2002:a05:6820:1c89:b0:660:fffb:15d6 with SMTP id
 006d021491bc7-66118126603mr4872320eaf.32.1768811726197; Mon, 19 Jan 2026
 00:35:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <696aa7da.a70a0220.31956c.001a.GAE@google.com> <aW3RBuJJwRrwF76J@infradead.org>
In-Reply-To: <aW3RBuJJwRrwF76J@infradead.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Mon, 19 Jan 2026 09:35:14 +0100
X-Gm-Features: AZwV_QgVXZVjmjEU6RxzpyTF_3z8DOol1Rq8vZvQLMZnIoudOQubn9e_MB2nbTw
Message-ID: <CANp29Y4Y8hn0riev+SPM_3wnpLeP+eBpkBwD-7fgRjbHck6dSA@mail.gmail.com>
Subject: Re: [syzbot] [xfs?] KASAN: use-after-free Read in hpfs_bplus_lookup
To: Christoph Hellwig <hch@infradead.org>
Cc: syzbot <syzbot+8debf4b3f7c7391cd8eb@syzkaller.appspotmail.com>, cem@kernel.org, 
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	mikulas@artax.karlin.mff.cuni.cz, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 19, 2026 at 7:36=E2=80=AFAM Christoph Hellwig <hch@infradead.or=
g> wrote:
>
> Any idea why this Ccs the xfs list?

Somehow, the reproducers first mount xfs and only then hpfs, so syzbot
also tagged the xfs list.

>
> On Fri, Jan 16, 2026 at 01:04:26PM -0800, syzbot wrote:
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    b71e635feefc Merge tag 'cgroup-for-6.19-rc5-fixes' of g=
it:..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=3D10efa99a580=
000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=3D7b058fb1d7d=
be6b1
> > dashboard link: https://syzkaller.appspot.com/bug?extid=3D8debf4b3f7c73=
91cd8eb
> > compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7=
976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D10cd15fa5=
80000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D152a4052580=
000
> >
> > Downloadable assets:
> > disk image: https://storage.googleapis.com/syzbot-assets/40abbbbc34a8/d=
isk-b71e635f.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/74edfb8073f7/vmli=
nux-b71e635f.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/3b5198043bfa=
/bzImage-b71e635f.xz
> > mounted in repro #1: https://storage.googleapis.com/syzbot-assets/7f169=
2afbc9c/mount_0.gz
> >   fsck result: failed (log: https://syzkaller.appspot.com/x/fsck.log?x=
=3D1609599a580000)
> > mounted in repro #2: https://storage.googleapis.com/syzbot-assets/d09b0=
f5dc58e/mount_2.gz
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the co=
mmit:
> > Reported-by: syzbot+8debf4b3f7c7391cd8eb@syzkaller.appspotmail.com
> >
> > hpfs: filesystem error: invalid number of hotfixes: 2066844986, used: 2=
066844985; already mounted read-only
> > hpfs: filesystem error: improperly stopped
> > hpfs: filesystem error: warning: spare dnodes used, try chkdsk
> > hpfs: You really don't want any checks? You are crazy...
> > hpfs: hpfs_map_sector(): read error
> > hpfs: code page support is disabled
> > hpfs: filesystem error: map_dirent: not a directory
> > hpfs: hpfs_map_4sectors(): unaligned read
> > hpfs: filesystem error: unable to find root dir
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > BUG: KASAN: use-after-free in hpfs_bplus_lookup+0x4dc/0x860 fs/hpfs/ano=
de.c:38
> > Read of size 4 at addr ffff888052abe004 by task syz.0.27/6198
> >
> > CPU: 1 UID: 0 PID: 6198 Comm: syz.0.27 Not tainted syzkaller #0 PREEMPT=
_{RT,(full)}
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS=
 Google 10/25/2025
> > Call Trace:
> >  <TASK>
> >  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
> >  print_address_description mm/kasan/report.c:378 [inline]
> >  print_report+0xca/0x240 mm/kasan/report.c:482
> >  kasan_report+0x118/0x150 mm/kasan/report.c:595
> >  hpfs_bplus_lookup+0x4dc/0x860 fs/hpfs/anode.c:38
> >  hpfs_bmap+0x22a/0x4d0 fs/hpfs/file.c:54
> >  hpfs_get_block+0xa8/0x6e0 fs/hpfs/file.c:87
> >  do_mpage_readpage+0x822/0x1990 fs/mpage.c:222
> >  mpage_readahead+0x3b0/0x790 fs/mpage.c:371
> >  read_pages+0x17a/0x580 mm/readahead.c:163
> >  page_cache_ra_unbounded+0x68b/0x8c0 mm/readahead.c:302
> >  filemap_get_pages+0x446/0x1ee0 mm/filemap.c:2690
> >  filemap_read+0x3f9/0x11a0 mm/filemap.c:2800
> >  __kernel_read+0x4d8/0x970 fs/read_write.c:530
> >  integrity_kernel_read+0x89/0xd0 security/integrity/iint.c:28
> >  ima_calc_file_hash_tfm security/integrity/ima/ima_crypto.c:480 [inline=
]
> >  ima_calc_file_shash security/integrity/ima/ima_crypto.c:511 [inline]
> >  ima_calc_file_hash+0x86a/0x1700 security/integrity/ima/ima_crypto.c:56=
8
> >  ima_collect_measurement+0x42e/0x900 security/integrity/ima/ima_api.c:2=
93
> >  process_measurement+0x112a/0x1a80 security/integrity/ima/ima_main.c:40=
6
> >  ima_file_check+0xd9/0x130 security/integrity/ima/ima_main.c:663
> >  security_file_post_open+0xbb/0x290 security/security.c:2652
> >  do_open fs/namei.c:4639 [inline]
> >  path_openat+0x3472/0x3df0 fs/namei.c:4796
> >  do_filp_open+0x1fa/0x410 fs/namei.c:4823
> >  do_sys_openat2+0x121/0x200 fs/open.c:1430
> >  do_sys_open fs/open.c:1436 [inline]
> >  __do_sys_openat fs/open.c:1452 [inline]
> >  __se_sys_openat fs/open.c:1447 [inline]
> >  __x64_sys_openat+0x138/0x170 fs/open.c:1447
> >  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> >  do_syscall_64+0xec/0xf80 arch/x86/entry/syscall_64.c:94
> >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > RIP: 0033:0x7fb59539f749
> > Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89=
 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 =
ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> > RSP: 002b:00007fff3ac53cb8 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
> > RAX: ffffffffffffffda RBX: 00007fb5955f5fa0 RCX: 00007fb59539f749
> > RDX: 0000000000000000 RSI: 0000200000004280 RDI: ffffffffffffff9c
> > RBP: 00007fb595423f91 R08: 0000000000000000 R09: 0000000000000000
> > R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> > R13: 00007fb5955f5fa0 R14: 00007fb5955f5fa0 R15: 0000000000000004
> >  </TASK>
> >
> > The buggy address belongs to the physical page:
> > page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x7fb58c615 =
pfn:0x52abe
> > flags: 0x80000000000000(node=3D0|zone=3D1)
> > raw: 0080000000000000 ffffea00014aafc8 ffff8880b8842d30 000000000000000=
0
> > raw: 00000007fb58c615 0000000000000000 00000000ffffffff 000000000000000=
0
> > page dumped because: kasan: bad access detected
> > page_owner tracks the page as freed
> > page last allocated via order 0, migratetype Movable, gfp_mask 0x140dca=
(GFP_HIGHUSER_MOVABLE|__GFP_ZERO|__GFP_COMP), pid 6198, tgid 6198 (syz.0.27=
), ts 130045840131, free_ts 130049000115
> >  set_page_owner include/linux/page_owner.h:32 [inline]
> >  post_alloc_hook+0x234/0x290 mm/page_alloc.c:1857
> >  prep_new_page mm/page_alloc.c:1865 [inline]
> >  get_page_from_freelist+0x28c0/0x2960 mm/page_alloc.c:3915
> >  __alloc_frozen_pages_noprof+0x181/0x370 mm/page_alloc.c:5210
> >  alloc_pages_mpol+0xd1/0x380 mm/mempolicy.c:2486
> >  folio_alloc_mpol_noprof mm/mempolicy.c:2505 [inline]
> >  vma_alloc_folio_noprof+0xe4/0x280 mm/mempolicy.c:2540
> >  folio_prealloc+0x30/0x180 mm/memory.c:-1
> >  alloc_anon_folio mm/memory.c:5165 [inline]
> >  do_anonymous_page mm/memory.c:5222 [inline]
> >  do_pte_missing+0x86a/0x27a0 mm/memory.c:4399
> >  handle_pte_fault mm/memory.c:6273 [inline]
> >  __handle_mm_fault mm/memory.c:6411 [inline]
> >  handle_mm_fault+0xcc1/0x1330 mm/memory.c:6580
> >  do_user_addr_fault+0xa7c/0x1380 arch/x86/mm/fault.c:1336
> >  handle_page_fault arch/x86/mm/fault.c:1476 [inline]
> >  exc_page_fault+0x71/0xd0 arch/x86/mm/fault.c:1532
> >  asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
> > page last free pid 6198 tgid 6198 stack trace:
> >  reset_page_owner include/linux/page_owner.h:25 [inline]
> >  free_pages_prepare mm/page_alloc.c:1406 [inline]
> >  free_unref_folios+0xc28/0x1810 mm/page_alloc.c:3000
> >  folios_put_refs+0x569/0x670 mm/swap.c:1002
> >  free_pages_and_swap_cache+0x4be/0x520 mm/swap_state.c:358
> >  __tlb_batch_free_encoded_pages mm/mmu_gather.c:136 [inline]
> >  tlb_batch_pages_flush mm/mmu_gather.c:149 [inline]
> >  tlb_flush_mmu_free mm/mmu_gather.c:397 [inline]
> >  tlb_flush_mmu+0x3a0/0x680 mm/mmu_gather.c:404
> >  tlb_finish_mmu+0xc3/0x1d0 mm/mmu_gather.c:497
> >  vms_clear_ptes+0x42b/0x530 mm/vma.c:1238
> >  vms_complete_munmap_vmas+0x206/0x8a0 mm/vma.c:1280
> >  do_vmi_align_munmap+0x372/0x450 mm/vma.c:1539
> >  do_vmi_munmap+0x253/0x2e0 mm/vma.c:1587
> >  __vm_munmap+0x207/0x380 mm/vma.c:3203
> >  __do_sys_munmap mm/mmap.c:1077 [inline]
> >  __se_sys_munmap mm/mmap.c:1074 [inline]
> >  __x64_sys_munmap+0x60/0x70 mm/mmap.c:1074
> >  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> >  do_syscall_64+0xec/0xf80 arch/x86/entry/syscall_64.c:94
> >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> >
> > Memory state around the buggy address:
> >  ffff888052abdf00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> >  ffff888052abdf80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > >ffff888052abe000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> >                    ^
> >  ffff888052abe080: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> >  ffff888052abe100: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> >
> > ---
> > This report is generated by a bot. It may contain errors.
> > See https://goo.gl/tpsmEJ for more information about syzbot.
> > syzbot engineers can be reached at syzkaller@googlegroups.com.
> >
> > syzbot will keep track of this issue. See:
> > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> >
> > If the report is already addressed, let syzbot know by replying with:
> > #syz fix: exact-commit-title
> >
> > If you want syzbot to run the reproducer, reply with:
> > #syz test: git://repo/address.git branch-or-commit-hash
> > If you attach or paste a git patch, syzbot will apply it before testing=
.
> >
> > If you want to overwrite report's subsystems, reply with:
> > #syz set subsystems: new-subsystem
> > (See the list of subsystem names on the web dashboard)
> >
> > If the report is a duplicate of another one, reply with:
> > #syz dup: exact-subject-of-another-report
> >
> > If you want to undo deduplication, reply with:
> > #syz undup
> >
> ---end quoted text---
>
