Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7116E139D0A;
	Thu, 13 Mar 2025 04:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741839176; cv=none; b=D00CZzmpodOmDwvNJRvWZgWOQ70NYDgYGue4UHFvv/4kWIIfTLqAo41drZLotJNYsINIa3MN+wSL0qmPf9alxrANh2xJXkYSOKhhnKHFwNEuk/W/A6UY6Z/cCz3fC2LY/2hteZjE3XIeqiiJu6D4hawA7PGjloyU+ErkEKCz/0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741839176; c=relaxed/simple;
	bh=oT3pYRi54sAqI7gSafboTrU1A+0+3Fg+E1p2ca4BU6s=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=c+rpBkeI6EicImlzn8jCfNkfTYJtZ4bBKxuODYEafWIezgH4t+rtUhRrR9lyGMiKLdZrWaOw1reKgji0Fdnon1KmEPuFRa9sIUNCz9D3tg4HyGgz3Z0j2nI511RpuEV+boT/JlLCs1tY4bCcKtiGES03Cx7oFWTza/b01JqapO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l3TPjWp+; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l3TPjWp+"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-223a7065ff8so14202725ad.0;
        Wed, 12 Mar 2025 21:12:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741839174; x=1742443974; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dv1Rhs4NBiLhIvTsPWGPDSbczJ4kop60MgIVQjZJy60=;
        b=l3TPjWp+SjhgBeIt5zBgqH1D3vNOBIyFKN1lW6myvZhp75HGB0DoTAWvycV1FJfaww
         FfWlLOS4Vpr8y/jlgf2QhRGmVEAOveTWvCWpeHS39qNh51jyjhwFKAhul4UpB19+L8lb
         fwezB1z/iu/7n1BytGPWza/p56KntuBzvmbmhpK2HLbjmBLTL1PAGzIGKL/N9DfB9viY
         eQZu4pT7JvyL/3RfVMZfpyMTyBYoj9JbQyzaaokwjCMTY5s4X3eHvRRwBQpyZfW5fR2S
         9rMtdZ0ke+hleDl0RjDdScCVs0PKpC0lrFo81J4MIDBBfqOnl8jSgRd9F+H1xJiefL2g
         VS/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741839174; x=1742443974;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dv1Rhs4NBiLhIvTsPWGPDSbczJ4kop60MgIVQjZJy60=;
        b=IRBmHhMXRnWajziupJRd6VfTB5ivJuJxIGbDIC3O8bZXyS87o4VFhAErQVrsv+pnoA
         sxth7CntdtzcPn2kla24QgidnCjAFeiHasxRWfLSoXAQ+j1nVCpdSlRKkrLRls+bEq3l
         +q52xBy/1Un3cx9aRIXUtFseaA/60NUSTPmXklyWqMgRY/o62M5N3FvcOazj/zKSeSpR
         Y359ZqzKmzMGGJDBlkmas9er/JHQ/36+r/QWbIfqGSXE64V7jfHnqVtzVB0pTZco4oHU
         p8PPkinZLZUVf+QcWRlEl8be4kR/7y8gVeojqmJbxGNKxYF984Qq6nSLzJojWL7XOwlq
         LKOQ==
X-Forwarded-Encrypted: i=1; AJvYcCUNLdllTGPT/EuPUqGqdLkJVk41NFkrZEq+0IeYqbFdvDnYTTGYPj1qnab7MKuTVtiuYbd+ctP7xYoPtzk=@vger.kernel.org, AJvYcCVnmd8i0/Hy0gLx9BLuLzj5xr/IkmgarISNe+WbsZtweWn0jg7xMSw03A/Iq9odtXUNqcghnftvIDSW@vger.kernel.org, AJvYcCXEmrYDvhiL78LJ3FctPRvFi+LLPe9Eq0cxHd9fczHRBoPwdUbiDYNq5qhepQPQK/dpNrD6EbtIuESnm9Ae@vger.kernel.org
X-Gm-Message-State: AOJu0Yyo5gNZSUG/B7pEOzV17Slw16sUqSUFa3vs/dTYHGUYhZxTsmpw
	C9a01CyLLoREfnpG+1JlVFbqJUsnO7K8P3rSEJfUgkGvGKktImeP
X-Gm-Gg: ASbGncv4glEcfzMG/kySEd7wJOTErvP4utnvUEC2Uiqz3n/9kkEZmr2O/Vo8KbCUngX
	NQ3IaNFHUucG4HQQ5iadL03tk5slMBis4M1KsSsCZoAYZm7RqillHa7BPZpKYYhwKGHH0G+ur6l
	B55vju1auYtxVdT4VksAh/BqtKx42gSWDQjKCJvWE/tQO1T72haGSwOFKpxio+J0zFjejVAop9E
	Pgs5u8N2lf0yPbiypTOoEFGlx4M53WHo2wYs1IRAWlM1YL7odGSELJaOlAyC0oobiTf48QK2jjC
	Vh3HvbmiUpvG4Zhdz5rrrGFvRFmhFN7tPz0N2QF/zDXsxCX9TU2dfBQ=
X-Google-Smtp-Source: AGHT+IHjm10d87SlKuLM121V9MpKQ/Afi7b+Ga9A48Vz2S5NykhF3wyHw2P60uwXL8uFmc7PWwAffw==
X-Received: by 2002:a05:6a21:6009:b0:1f5:9098:e446 with SMTP id adf61e73a8af0-1f59098e71bmr13088918637.2.1741839173543;
        Wed, 12 Mar 2025 21:12:53 -0700 (PDT)
Received: from [10.172.23.16] ([114.242.33.243])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7371167e07fsm338205b3a.119.2025.03.12.21.12.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Mar 2025 21:12:53 -0700 (PDT)
Message-ID: <1f4c7fbe-f666-45d2-911e-59fffdca905d@gmail.com>
Date: Thu, 13 Mar 2025 12:12:48 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [xfs?] KASAN: slab-out-of-bounds Read in xlog_cksum
To: syzbot <syzbot+9f6d080dece587cfdd4c@syzkaller.appspotmail.com>,
 ardb@kernel.org, bp@alien8.de, chandan.babu@oracle.com,
 dave.hansen@linux.intel.com, ebiggers@kernel.org, hpa@zytor.com,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-xfs@vger.kernel.org, mingo@redhat.com,
 syzkaller-bugs@googlegroups.com, tglx@linutronix.de, x86@kernel.org
References: <67c72724.050a0220.38b91b.0244.GAE@google.com>
Content-Language: en-US
From: Julian Sun <sunjunchao2870@gmail.com>
In-Reply-To: <67c72724.050a0220.38b91b.0244.GAE@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

#syz test

On 3/5/25 00:15, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    99fa936e8e4f Merge tag 'affs-6.14-rc5-tag' of git://git.ke..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=111c9464580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=2040405600e83619
> dashboard link: https://syzkaller.appspot.com/bug?extid=9f6d080dece587cfdd4c
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=132f0078580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1483fc54580000
> 
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-99fa936e.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/ef04f83d96f6/vmlinux-99fa936e.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/583a7eea5c8e/bzImage-99fa936e.xz
> mounted in repro: https://storage.googleapis.com/syzbot-assets/6232fcdbddfb/mount_1.gz
>    fsck result: failed (log: https://syzkaller.appspot.com/x/fsck.log?x=11d457a0580000)
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+9f6d080dece587cfdd4c@syzkaller.appspotmail.com
> 
> =======================================================
> XFS (loop0): Mounting V5 Filesystem bfdc47fc-10d8-4eed-a562-11a831b3f791
> ==================================================================
> BUG: KASAN: slab-out-of-bounds in crc32c_le_arch+0xc7/0x1b0 arch/x86/lib/crc32-glue.c:81
> Read of size 8 at addr ffff888040dfea00 by task syz-executor260/5304
> 
> CPU: 0 UID: 0 PID: 5304 Comm: syz-executor260 Not tainted 6.14.0-rc5-syzkaller-00013-g99fa936e8e4f #0
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
> Call Trace:
>   <TASK>
>   __dump_stack lib/dump_stack.c:94 [inline]
>   dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
>   print_address_description mm/kasan/report.c:408 [inline]
>   print_report+0x16e/0x5b0 mm/kasan/report.c:521
>   kasan_report+0x143/0x180 mm/kasan/report.c:634
>   crc32c_le_arch+0xc7/0x1b0 arch/x86/lib/crc32-glue.c:81
>   __crc32c_le include/linux/crc32.h:36 [inline]
>   crc32c include/linux/crc32c.h:9 [inline]
>   xlog_cksum+0x91/0xf0 fs/xfs/xfs_log.c:1588
>   xlog_recover_process+0x78/0x1e0 fs/xfs/xfs_log_recover.c:2900
>   xlog_do_recovery_pass+0xa01/0xdc0 fs/xfs/xfs_log_recover.c:3235
>   xlog_verify_head+0x21f/0x5a0 fs/xfs/xfs_log_recover.c:1058
>   xlog_find_tail+0xa04/0xdf0 fs/xfs/xfs_log_recover.c:1315
>   xlog_recover+0xe1/0x540 fs/xfs/xfs_log_recover.c:3419
>   xfs_log_mount+0x252/0x3e0 fs/xfs/xfs_log.c:666
>   xfs_mountfs+0xfbb/0x2500 fs/xfs/xfs_mount.c:878
>   xfs_fs_fill_super+0x1223/0x1550 fs/xfs/xfs_super.c:1817
>   get_tree_bdev_flags+0x48c/0x5c0 fs/super.c:1636
>   vfs_get_tree+0x90/0x2b0 fs/super.c:1814
>   do_new_mount+0x2be/0xb40 fs/namespace.c:3560
>   do_mount fs/namespace.c:3900 [inline]
>   __do_sys_mount fs/namespace.c:4111 [inline]
>   __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4088
>   do_syscall_x64 arch/x86/entry/common.c:52 [inline]
>   do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
>   entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7ff347850dfa
> Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffcece53ae8 EFLAGS: 00000202 ORIG_RAX: 00000000000000a5
> RAX: ffffffffffffffda RBX: 00007ffcece53b00 RCX: 00007ff347850dfa
> RDX: 0000400000000500 RSI: 0000400000000200 RDI: 00007ffcece53b00
> RBP: 0000400000000500 R08: 00007ffcece53b40 R09: 002c6563726f666e
> R10: 0000000002218a5d R11: 0000000000000202 R12: 0000400000000200
> R13: 0000000000000005 R14: 0000000000000004 R15: 00007ffcece53b40
>   </TASK>
> 
> Allocated by task 5304:
>   kasan_save_stack mm/kasan/common.c:47 [inline]
>   kasan_save_track+0x3f/0x80 mm/kasan/common.c:68
>   poison_kmalloc_redzone mm/kasan/common.c:377 [inline]
>   __kasan_kmalloc+0x98/0xb0 mm/kasan/common.c:394
>   kasan_kmalloc include/linux/kasan.h:260 [inline]
>   __do_kmalloc_node mm/slub.c:4294 [inline]
>   __kmalloc_node_noprof+0x290/0x4d0 mm/slub.c:4300
>   __kvmalloc_node_noprof+0x72/0x190 mm/util.c:662
>   xlog_do_recovery_pass+0x143/0xdc0 fs/xfs/xfs_log_recover.c:3016
>   xlog_verify_head+0x21f/0x5a0 fs/xfs/xfs_log_recover.c:1058
>   xlog_find_tail+0xa04/0xdf0 fs/xfs/xfs_log_recover.c:1315
>   xlog_recover+0xe1/0x540 fs/xfs/xfs_log_recover.c:3419
>   xfs_log_mount+0x252/0x3e0 fs/xfs/xfs_log.c:666
>   xfs_mountfs+0xfbb/0x2500 fs/xfs/xfs_mount.c:878
>   xfs_fs_fill_super+0x1223/0x1550 fs/xfs/xfs_super.c:1817
>   get_tree_bdev_flags+0x48c/0x5c0 fs/super.c:1636
>   vfs_get_tree+0x90/0x2b0 fs/super.c:1814
>   do_new_mount+0x2be/0xb40 fs/namespace.c:3560
>   do_mount fs/namespace.c:3900 [inline]
>   __do_sys_mount fs/namespace.c:4111 [inline]
>   __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4088
>   do_syscall_x64 arch/x86/entry/common.c:52 [inline]
>   do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
>   entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> The buggy address belongs to the object at ffff888040dfe800
>   which belongs to the cache kmalloc-512 of size 512
> The buggy address is located 0 bytes to the right of
>   allocated 512-byte region [ffff888040dfe800, ffff888040dfea00)
> 
> The buggy address belongs to the physical page:
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x40dfe
> head: order:1 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
> flags: 0x4fff00000000040(head|node=1|zone=1|lastcpupid=0x7ff)
> page_type: f5(slab)
> raw: 04fff00000000040 ffff88801b041c80 ffffea0000d6ab00 dead000000000004
> raw: 0000000000000000 0000000080080008 00000000f5000000 0000000000000000
> head: 04fff00000000040 ffff88801b041c80 ffffea0000d6ab00 dead000000000004
> head: 0000000000000000 0000000080080008 00000000f5000000 0000000000000000
> head: 04fff00000000001 ffffea0001037f81 ffffffffffffffff 0000000000000000
> head: 0000000000000002 0000000000000000 00000000ffffffff 0000000000000000
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 1, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 2, tgid 2 (kthreadd), ts 25533552797, free_ts 0
>   set_page_owner include/linux/page_owner.h:32 [inline]
>   post_alloc_hook+0x1f4/0x240 mm/page_alloc.c:1551
>   prep_new_page mm/page_alloc.c:1559 [inline]
>   get_page_from_freelist+0x365c/0x37a0 mm/page_alloc.c:3477
>   __alloc_frozen_pages_noprof+0x292/0x710 mm/page_alloc.c:4739
>   alloc_pages_mpol+0x311/0x660 mm/mempolicy.c:2270
>   alloc_slab_page mm/slub.c:2423 [inline]
>   allocate_slab+0x8f/0x3a0 mm/slub.c:2587
>   new_slab mm/slub.c:2640 [inline]
>   ___slab_alloc+0xc27/0x14a0 mm/slub.c:3826
>   __slab_alloc+0x58/0xa0 mm/slub.c:3916
>   __slab_alloc_node mm/slub.c:3991 [inline]
>   slab_alloc_node mm/slub.c:4152 [inline]
>   __kmalloc_cache_noprof+0x27b/0x390 mm/slub.c:4320
>   kmalloc_noprof include/linux/slab.h:901 [inline]
>   kzalloc_noprof include/linux/slab.h:1037 [inline]
>   set_kthread_struct+0xc2/0x330 kernel/kthread.c:126
>   copy_process+0x1179/0x3cf0 kernel/fork.c:2331
>   kernel_clone+0x226/0x8e0 kernel/fork.c:2815
>   kernel_thread+0x1c0/0x250 kernel/fork.c:2877
>   create_kthread kernel/kthread.c:487 [inline]
>   kthreadd+0x60d/0x810 kernel/kthread.c:847
>   ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:148
>   ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
> page_owner free stack trace missing
> 
> Memory state around the buggy address:
>   ffff888040dfe900: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>   ffff888040dfe980: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> ffff888040dfea00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>                     ^
>   ffff888040dfea80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>   ffff888040dfeb00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
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

