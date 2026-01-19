Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EE8926E71F;
	Mon, 19 Jan 2026 06:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768804617; cv=none; b=iPlUofWKmwVkoI67sLu5ObW+707Spzp61PKduqoymDRRmcm216EqvzHHdArYOKj76tMPHTycfGBF2UjGMzUR8XFE4B08m6/R0EBNU2JD/XQY7fYUiv4jZZYT7rtuOAn6W2VnRcG/ZTabXGDmbvXiY1yLt+XpL6V/ZoZEKr85cEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768804617; c=relaxed/simple;
	bh=r0Y7Jyr5JGyXXTDiyp/H8tlBTszB9xd77VfWFqsjq0g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Uc6ArIHyceriAXZ97wHbDy9HtqyVLWPu24K6qjHclFb1p/XIn35hu/LnmucxboAI6IU0lX944dWfvk0hZCLi/KqRh6AVaoRAyH35hcnyh2qBGYxGzqQ08cJaF4lY4pr+9FippBjkPLCpX/vtWBw7Jk+bjH45a4GHiwJZ9daY2xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=VgmbmRwy; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VgmbmRwy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ARhYh0qWKr7ukcVDai4Q/eUenpvB3MxH8FzufR+J1dU=; b=VgmbmRwyYaqg9E5PpLmHtW+VOZ
	NiSPFrKnpb/4eFjCBlcRcV3DkTWEFqPH7pjVEr5QPQ3QRRhfBnrXpNfx/awZHsOvy57USIPGp1T7W
	F5hKKk16pGaMQBoRX9KeWXlTFPO7Dn8KfecnNO58iypfz8819QY2iI4SvlvKw0SVVUeqSnk03YO5D
	UlhGw4eTTT/v/ZFqVlLxZbLQAZa9kPGRLz/rvNLGpRlS73S/L9ZYflrqSn5ZpkMG4Z4CvY62p6Jd1
	CBvu3HA/CkCSXrgq/GhpE7keuqfx/x4fqrTBHRHQmNibKuCr/TZnS8n1PDmacQXnqA3ns6nbWOUNH
	cEOCLdOA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vhisg-00000001POg-0AqA;
	Mon, 19 Jan 2026 06:36:54 +0000
Date: Sun, 18 Jan 2026 22:36:54 -0800
From: Christoph Hellwig <hch@infradead.org>
To: syzbot <syzbot+8debf4b3f7c7391cd8eb@syzkaller.appspotmail.com>
Cc: cem@kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	mikulas@artax.karlin.mff.cuni.cz, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [xfs?] KASAN: use-after-free Read in hpfs_bplus_lookup
Message-ID: <aW3RBuJJwRrwF76J@infradead.org>
References: <696aa7da.a70a0220.31956c.001a.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <696aa7da.a70a0220.31956c.001a.GAE@google.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Any idea why this Ccs the xfs list?

On Fri, Jan 16, 2026 at 01:04:26PM -0800, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    b71e635feefc Merge tag 'cgroup-for-6.19-rc5-fixes' of git:..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=10efa99a580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=7b058fb1d7dbe6b1
> dashboard link: https://syzkaller.appspot.com/bug?extid=8debf4b3f7c7391cd8eb
> compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10cd15fa580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=152a4052580000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/40abbbbc34a8/disk-b71e635f.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/74edfb8073f7/vmlinux-b71e635f.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/3b5198043bfa/bzImage-b71e635f.xz
> mounted in repro #1: https://storage.googleapis.com/syzbot-assets/7f1692afbc9c/mount_0.gz
>   fsck result: failed (log: https://syzkaller.appspot.com/x/fsck.log?x=1609599a580000)
> mounted in repro #2: https://storage.googleapis.com/syzbot-assets/d09b0f5dc58e/mount_2.gz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+8debf4b3f7c7391cd8eb@syzkaller.appspotmail.com
> 
> hpfs: filesystem error: invalid number of hotfixes: 2066844986, used: 2066844985; already mounted read-only
> hpfs: filesystem error: improperly stopped
> hpfs: filesystem error: warning: spare dnodes used, try chkdsk
> hpfs: You really don't want any checks? You are crazy...
> hpfs: hpfs_map_sector(): read error
> hpfs: code page support is disabled
> hpfs: filesystem error: map_dirent: not a directory
> hpfs: hpfs_map_4sectors(): unaligned read
> hpfs: filesystem error: unable to find root dir
> ==================================================================
> BUG: KASAN: use-after-free in hpfs_bplus_lookup+0x4dc/0x860 fs/hpfs/anode.c:38
> Read of size 4 at addr ffff888052abe004 by task syz.0.27/6198
> 
> CPU: 1 UID: 0 PID: 6198 Comm: syz.0.27 Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  print_address_description mm/kasan/report.c:378 [inline]
>  print_report+0xca/0x240 mm/kasan/report.c:482
>  kasan_report+0x118/0x150 mm/kasan/report.c:595
>  hpfs_bplus_lookup+0x4dc/0x860 fs/hpfs/anode.c:38
>  hpfs_bmap+0x22a/0x4d0 fs/hpfs/file.c:54
>  hpfs_get_block+0xa8/0x6e0 fs/hpfs/file.c:87
>  do_mpage_readpage+0x822/0x1990 fs/mpage.c:222
>  mpage_readahead+0x3b0/0x790 fs/mpage.c:371
>  read_pages+0x17a/0x580 mm/readahead.c:163
>  page_cache_ra_unbounded+0x68b/0x8c0 mm/readahead.c:302
>  filemap_get_pages+0x446/0x1ee0 mm/filemap.c:2690
>  filemap_read+0x3f9/0x11a0 mm/filemap.c:2800
>  __kernel_read+0x4d8/0x970 fs/read_write.c:530
>  integrity_kernel_read+0x89/0xd0 security/integrity/iint.c:28
>  ima_calc_file_hash_tfm security/integrity/ima/ima_crypto.c:480 [inline]
>  ima_calc_file_shash security/integrity/ima/ima_crypto.c:511 [inline]
>  ima_calc_file_hash+0x86a/0x1700 security/integrity/ima/ima_crypto.c:568
>  ima_collect_measurement+0x42e/0x900 security/integrity/ima/ima_api.c:293
>  process_measurement+0x112a/0x1a80 security/integrity/ima/ima_main.c:406
>  ima_file_check+0xd9/0x130 security/integrity/ima/ima_main.c:663
>  security_file_post_open+0xbb/0x290 security/security.c:2652
>  do_open fs/namei.c:4639 [inline]
>  path_openat+0x3472/0x3df0 fs/namei.c:4796
>  do_filp_open+0x1fa/0x410 fs/namei.c:4823
>  do_sys_openat2+0x121/0x200 fs/open.c:1430
>  do_sys_open fs/open.c:1436 [inline]
>  __do_sys_openat fs/open.c:1452 [inline]
>  __se_sys_openat fs/open.c:1447 [inline]
>  __x64_sys_openat+0x138/0x170 fs/open.c:1447
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xec/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fb59539f749
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fff3ac53cb8 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
> RAX: ffffffffffffffda RBX: 00007fb5955f5fa0 RCX: 00007fb59539f749
> RDX: 0000000000000000 RSI: 0000200000004280 RDI: ffffffffffffff9c
> RBP: 00007fb595423f91 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fb5955f5fa0 R14: 00007fb5955f5fa0 R15: 0000000000000004
>  </TASK>
> 
> The buggy address belongs to the physical page:
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x7fb58c615 pfn:0x52abe
> flags: 0x80000000000000(node=0|zone=1)
> raw: 0080000000000000 ffffea00014aafc8 ffff8880b8842d30 0000000000000000
> raw: 00000007fb58c615 0000000000000000 00000000ffffffff 0000000000000000
> page dumped because: kasan: bad access detected
> page_owner tracks the page as freed
> page last allocated via order 0, migratetype Movable, gfp_mask 0x140dca(GFP_HIGHUSER_MOVABLE|__GFP_ZERO|__GFP_COMP), pid 6198, tgid 6198 (syz.0.27), ts 130045840131, free_ts 130049000115
>  set_page_owner include/linux/page_owner.h:32 [inline]
>  post_alloc_hook+0x234/0x290 mm/page_alloc.c:1857
>  prep_new_page mm/page_alloc.c:1865 [inline]
>  get_page_from_freelist+0x28c0/0x2960 mm/page_alloc.c:3915
>  __alloc_frozen_pages_noprof+0x181/0x370 mm/page_alloc.c:5210
>  alloc_pages_mpol+0xd1/0x380 mm/mempolicy.c:2486
>  folio_alloc_mpol_noprof mm/mempolicy.c:2505 [inline]
>  vma_alloc_folio_noprof+0xe4/0x280 mm/mempolicy.c:2540
>  folio_prealloc+0x30/0x180 mm/memory.c:-1
>  alloc_anon_folio mm/memory.c:5165 [inline]
>  do_anonymous_page mm/memory.c:5222 [inline]
>  do_pte_missing+0x86a/0x27a0 mm/memory.c:4399
>  handle_pte_fault mm/memory.c:6273 [inline]
>  __handle_mm_fault mm/memory.c:6411 [inline]
>  handle_mm_fault+0xcc1/0x1330 mm/memory.c:6580
>  do_user_addr_fault+0xa7c/0x1380 arch/x86/mm/fault.c:1336
>  handle_page_fault arch/x86/mm/fault.c:1476 [inline]
>  exc_page_fault+0x71/0xd0 arch/x86/mm/fault.c:1532
>  asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
> page last free pid 6198 tgid 6198 stack trace:
>  reset_page_owner include/linux/page_owner.h:25 [inline]
>  free_pages_prepare mm/page_alloc.c:1406 [inline]
>  free_unref_folios+0xc28/0x1810 mm/page_alloc.c:3000
>  folios_put_refs+0x569/0x670 mm/swap.c:1002
>  free_pages_and_swap_cache+0x4be/0x520 mm/swap_state.c:358
>  __tlb_batch_free_encoded_pages mm/mmu_gather.c:136 [inline]
>  tlb_batch_pages_flush mm/mmu_gather.c:149 [inline]
>  tlb_flush_mmu_free mm/mmu_gather.c:397 [inline]
>  tlb_flush_mmu+0x3a0/0x680 mm/mmu_gather.c:404
>  tlb_finish_mmu+0xc3/0x1d0 mm/mmu_gather.c:497
>  vms_clear_ptes+0x42b/0x530 mm/vma.c:1238
>  vms_complete_munmap_vmas+0x206/0x8a0 mm/vma.c:1280
>  do_vmi_align_munmap+0x372/0x450 mm/vma.c:1539
>  do_vmi_munmap+0x253/0x2e0 mm/vma.c:1587
>  __vm_munmap+0x207/0x380 mm/vma.c:3203
>  __do_sys_munmap mm/mmap.c:1077 [inline]
>  __se_sys_munmap mm/mmap.c:1074 [inline]
>  __x64_sys_munmap+0x60/0x70 mm/mmap.c:1074
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xec/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> Memory state around the buggy address:
>  ffff888052abdf00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  ffff888052abdf80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> >ffff888052abe000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>                    ^
>  ffff888052abe080: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>  ffff888052abe100: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> ==================================================================
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> 
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
> 
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before testing.
> 
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
> 
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
> 
> If you want to undo deduplication, reply with:
> #syz undup
> 
---end quoted text---
