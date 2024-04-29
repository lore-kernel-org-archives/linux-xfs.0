Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B4DF171C9
	for <linux-xfs@vger.kernel.org>; Mon, 29 Apr 2024 08:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714380293; cv=none; b=MahuwVYPko5cKGgxrisQXB7GGJjz/QNCbleMvmjx8oAf01sM6YuFEihBApj985y++FWWVV+MFGr1x7Cbe7/AINfOrM93n3qCBD2BkOVP+yCRYFOEJJlNdDNO4eAJc3gu2zhoIU2vpMcNPQB9EFtgsEEWdy9qDvyPZmosRYyuDXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714380293; c=relaxed/simple;
	bh=U1DZRgsH6AoXo2IUix4nOjmK5ezaWR00boEso86xnEk=;
	h=Date:Message-Id:From:To:Cc:Subject:In-Reply-To; b=WyssZTzROkUPSquMo/tQJAeChTrofrXI/sz80bBYelroS31qyLHRCMIHy1NcWdRCfrHm9QRoeEblML6TIyawaCHepQCQ+om2sx+pBUVKl/SDXzuR8g7kbYjPVWEFSnBYq7YA1Er8aM8CUXwe9b7aSH/OAg/iAorRNhnuscaN0DM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mVEhfdfn; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mVEhfdfn"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-6f3f6aa1437so975051b3a.3
        for <linux-xfs@vger.kernel.org>; Mon, 29 Apr 2024 01:44:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714380291; x=1714985091; darn=vger.kernel.org;
        h=in-reply-to:subject:cc:to:from:message-id:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=jyCBoafqyfaU5HLPGxaG12Gx7MUPv/VqvRO/Itc+wXI=;
        b=mVEhfdfnaB7Lg/JGqTzSAlNqr+uR6rvX2N4CX3sxG21IxL+qi6Fz7keRNO6SS77WWX
         cgtyagXcwMjbt4XjRQ27UZfSAU270Id7esMRPiWJHW7oTXWBYpz6EDtS5KMESi3Tb7cX
         WHN++XzK5lPbiX8qlfS7idGsHOVL26X6P2EC3jOXAv2wbW7PU4wxColf1RlorkYOlhx/
         dlF7+o8qh2lttbePiVPECtaGVv3mPbU5ZodSLsUhDniPB4D0g7jqIhuRtWZ9QRrfAbxF
         wbkqN/a59pdpF6qWGfLvXObpx4PWopbeBJ2eW1Z0WKBIuzFYKjsRWKkRgjmYpuyJ7ZGB
         JE4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714380291; x=1714985091;
        h=in-reply-to:subject:cc:to:from:message-id:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jyCBoafqyfaU5HLPGxaG12Gx7MUPv/VqvRO/Itc+wXI=;
        b=W+QJsqhquvPNlZZvvYZ6Gxd8w3riFba+q3MVBPDlF3A9UgEwGt0+M9hUgIu9yNyDML
         LmiHCnBJ2rzmXikaEVlOfnLpZDzkZEy4jq/Nub3iA98xm2wZZ6gCDAtd7yRMyAFKZDQ9
         ZZCUtcA0zazCWvHTMJXp8UyaJC85b9dfxyj14cTD81Dus4u4QjdMmuH+FzEAuUG3wGOJ
         3fpjqNULbnkPpHgIs/xdNBCzO/sqw0Exb2807hxO5PX/Tk1yzHwqAu+9TULA2AsflIxw
         bNzUtCnxUMMr/iZ6aK6rh6Y6B0OkeSYSMGTdwfsjWa84MT5m5buFC89gSjcD7GUOQvmP
         Syhg==
X-Gm-Message-State: AOJu0YykmabLqMqQwN2PfTGt96PbUSQmrSyCrLZHS5ToMHyuL8yrfIXW
	3n4r1X+Twt9Ii5xjmNmAfA9MgHMFDsxexAj/jVmbSxutctSwW69n
X-Google-Smtp-Source: AGHT+IFWiJNIKTIWc28djCvSTtS/HXpE+TTPZ73mOPFr1kU4AZbVCrDvtgwkpzBwNJiRXhe/jVkZyw==
X-Received: by 2002:a05:6a20:c896:b0:1af:5195:d035 with SMTP id hb22-20020a056a20c89600b001af5195d035mr717664pzb.45.1714380290658;
        Mon, 29 Apr 2024 01:44:50 -0700 (PDT)
Received: from dw-tp ([129.41.58.7])
        by smtp.gmail.com with ESMTPSA id f4-20020a056a0022c400b006ed066ebed4sm19308197pfj.93.2024.04.29.01.44.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Apr 2024 01:44:49 -0700 (PDT)
Date: Mon, 29 Apr 2024 14:14:46 +0530
Message-Id: <87sez4y2v5.fsf@gmail.com>
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>, Ojaswin Mujoo <ojaswin@linux.ibm.com>
Subject: Re: [PATCHv2 1/1] xfs: Add cond_resched in xfs_bunmapi_range loop
In-Reply-To: <f7d3db235a2c7e16681a323a99bb0ce50a92296a.1714033516.git.ritesh.list@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

"Ritesh Harjani (IBM)" <ritesh.list@gmail.com> writes:

> An async dio write to a sparse file can generate a lot of extents
> and when we unlink this file (using rm), the kernel can be busy in umapping
> and freeing those extents as part of transaction processing.
> Add cond_resched() in xfs_bunmapi_range() to avoid soft lockups
> messages like these. Here is a call trace of such a soft lockup.
>
> watchdog: BUG: soft lockup - CPU#1 stuck for 22s! [kworker/1:0:82435]
> CPU: 1 PID: 82435 Comm: kworker/1:0 Tainted: G S  L   6.9.0-rc5-0-default #1
> Workqueue: xfs-inodegc/sda2 xfs_inodegc_worker
> NIP [c000000000beea10] xfs_extent_busy_trim+0x100/0x290
> LR [c000000000bee958] xfs_extent_busy_trim+0x48/0x290
> Call Trace:
>   xfs_alloc_get_rec+0x54/0x1b0 (unreliable)
>   xfs_alloc_compute_aligned+0x5c/0x144
>   xfs_alloc_ag_vextent_size+0x238/0x8d4
>   xfs_alloc_fix_freelist+0x540/0x694
>   xfs_free_extent_fix_freelist+0x84/0xe0
>   __xfs_free_extent+0x74/0x1ec
>   xfs_extent_free_finish_item+0xcc/0x214
>   xfs_defer_finish_one+0x194/0x388
>   xfs_defer_finish_noroll+0x1b4/0x5c8
>   xfs_defer_finish+0x2c/0xc4
>   xfs_bunmapi_range+0xa4/0x100
>   xfs_itruncate_extents_flags+0x1b8/0x2f4
>   xfs_inactive_truncate+0xe0/0x124
>   xfs_inactive+0x30c/0x3e0
>   xfs_inodegc_worker+0x140/0x234
>   process_scheduled_works+0x240/0x57c
>   worker_thread+0x198/0x468
>   kthread+0x138/0x140
>   start_kernel_thread+0x14/0x18
>

My v1 patch had cond_resched() in xfs_defer_finish_noroll, since I was
suspecting that it's a common point where we loop for many other
operations. And initially Dave also suggested for the same [1].
But I was not totally convinced given the only problematic path I
had till now was in unmapping extents. So this patch keeps the
cond_resched() in xfs_bunmapi_range() loop.

[1]: https://lore.kernel.org/all/ZZ8OaNnp6b%2FPJzsb@dread.disaster.area/

However, I was able to reproduce a problem with reflink remapping path
both on Power (with 64k bs) and on x86 (with preempt=none and with KASAN
enabled). I actually noticed while I was doing regression testing of
some of the iomap changes with KASAN enabled. The issue was seen with
generic/175 for both on Power and x86.

Do you think we should keep the cond_resched() inside
xfs_defer_finish_noroll() loop like we had in v1 [2]. If yes, then I can rebase
v1 on the latest upstream tree and also update the commit msg with both
call stacks.

[2]: https://lore.kernel.org/all/0bfaf740a2d10cc846616ae05963491316850c52.1713674899.git.ritesh.list@gmail.com/


<call stack on Power>
======================
 run fstests generic/175 at 2024-02-02 04:40:21
 <...>
[   C17] watchdog: BUG: soft lockup - CPU#17 stuck for 23s! [xfs_io:7679]
 watchdog: BUG: soft lockup - CPU#17 stuck for 23s! [xfs_io:7679]
 CPU: 17 PID: 7679 Comm: xfs_io Kdump: loaded Tainted: G               X     6.4.0-150600.5-default #1
 NIP [c008000005e3ec94] xfs_rmapbt_diff_two_keys+0x54/0xe0 [xfs]
 LR [c008000005e08798] xfs_btree_get_leaf_keys+0x110/0x1e0 [xfs]
 Call Trace:
  0xc000000014107c00 (unreliable)
  __xfs_btree_updkeys+0x8c/0x2c0 [xfs]
  xfs_btree_update_keys+0x150/0x170 [xfs]
  xfs_btree_lshift+0x534/0x660 [xfs]
  xfs_btree_make_block_unfull+0x19c/0x240 [xfs]
  xfs_btree_insrec+0x4e4/0x630 [xfs]
  xfs_btree_insert+0x104/0x2d0 [xfs]
  xfs_rmap_insert+0xc4/0x260 [xfs]
  xfs_rmap_map_shared+0x228/0x630 [xfs]
  xfs_rmap_finish_one+0x2d4/0x350 [xfs]
  xfs_rmap_update_finish_item+0x44/0xc0 [xfs]
  xfs_defer_finish_noroll+0x2e4/0x740 [xfs]
  __xfs_trans_commit+0x1f4/0x400 [xfs]
  xfs_reflink_remap_extent+0x2d8/0x650 [xfs]
  xfs_reflink_remap_blocks+0x154/0x320 [xfs]
  xfs_file_remap_range+0x138/0x3a0 [xfs]
  do_clone_file_range+0x11c/0x2f0
  vfs_clone_file_range+0x60/0x1c0
  ioctl_file_clone+0x78/0x140
  sys_ioctl+0x934/0x1270
  system_call_exception+0x158/0x320
  system_call_vectored_common+0x15c/0x2ec


<call stack on x86 with KASAN>
===============================
 watchdog: BUG: soft lockup - CPU#6 stuck for 26s! [xfs_io:3438095]
 CPU: 6 PID: 3438095 Comm: xfs_io Not tainted 6.9.0-rc5-xfstests-perf-00008-g4e2752e99f55 #1
 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.16.2-0-gea1b7a073390-prebuilt.qemu.o4
 RIP: 0010:_raw_spin_unlock_irqrestore+0x3c/0x60
 Code: 10 48 89 fb 48 83 c7 18 e8 31 7c 10 fd 48 89 df e8 79 f5 10 fd f7 c5 00 02 00 00 74 06 e8 0c 6
 Call Trace:
  <IRQ>
  ? watchdog_timer_fn+0x2dc/0x3a0
  ? __pfx_watchdog_timer_fn+0x10/0x10
  ? __hrtimer_run_queues+0x4a1/0x870
  ? __pfx___hrtimer_run_queues+0x10/0x10
  ? kvm_clock_get_cycles+0x18/0x30
  ? ktime_get_update_offsets_now+0xc6/0x2f0
  ? hrtimer_interrupt+0x2b8/0x7a0
  ? __sysvec_apic_timer_interrupt+0xca/0x390
  ? sysvec_apic_timer_interrupt+0x65/0x80
  </IRQ>
  <TASK>
  ? asm_sysvec_apic_timer_interrupt+0x1a/0x20
  ? _raw_spin_unlock_irqrestore+0x34/0x60
  ? _raw_spin_unlock_irqrestore+0x3c/0x60
  ? _raw_spin_unlock_irqrestore+0x34/0x60
  get_partial_node.part.0+0x1af/0x340
  ___slab_alloc+0xc07/0x1250
  ? do_vfs_ioctl+0xe5c/0x1660
  ? __x64_sys_ioctl+0xd5/0x1b0
 ? __alloc_object+0x39/0x660
 ? __pfx___might_resched+0x10/0x10
 ? __alloc_object+0x39/0x660
 ? kmem_cache_alloc+0x3cd/0x410
 ? should_failslab+0xe/0x20
 kmem_cache_alloc+0x3cd/0x410
 __alloc_object+0x39/0x660
 __create_object+0x22/0x90
 kmem_cache_alloc+0x324/0x410
 xfs_bui_init+0x1b/0x150
 xfs_bmap_update_create_intent+0x48/0x110
 ? __pfx_xfs_bmap_update_create_intent+0x10/0x10
 xfs_defer_create_intent+0xcc/0x1b0
 xfs_defer_create_intents+0x8f/0x230
 xfs_defer_finish_noroll+0x1c0/0x1160
 ? xfs_inode_item_precommit+0x2c1/0x880
 ? __create_object+0x5e/0x90
 ? __pfx_xfs_defer_finish_noroll+0x10/0x10
 ? xfs_trans_run_precommits+0x126/0x200
 __xfs_trans_commit+0x767/0xbe0
 ? inode_maybe_inc_iversion+0xe2/0x150
 ? __pfx___xfs_trans_commit+0x10/0x10
 xfs_reflink_remap_extent+0x654/0xd40
 ? __pfx_xfs_reflink_remap_extent+0x10/0x10
 ? __pfx_down_read_nested+0x10/0x10
 xfs_reflink_remap_blocks+0x21a/0x850
 ? __pfx_xfs_reflink_remap_blocks+0x10/0x10
 ? _raw_spin_unlock+0x23/0x40
 ? xfs_reflink_remap_prep+0x47d/0x900
 xfs_file_remap_range+0x296/0xb40
 ? __pfx_xfs_file_remap_range+0x10/0x10
 ? __pfx_lock_acquire+0x10/0x10
 ? __pfx___might_resched+0x10/0x10
 vfs_clone_file_range+0x260/0xc20
 ioctl_file_clone+0x49/0xb0
 do_vfs_ioctl+0xe5c/0x1660
 ? __pfx_do_vfs_ioctl+0x10/0x10
 ? trace_irq_enable.constprop.0+0xd2/0x110
 ? kasan_quarantine_put+0x7e/0x1d0
 ? do_sys_openat2+0x120/0x170
 ? lock_acquire+0x43b/0x4f0
 ? __pfx_lock_release+0x10/0x10
 ? __pfx_do_sys_openat2+0x10/0x10
 ? __do_sys_newfstatat+0x94/0xe0
 ? __fget_files+0x1ce/0x330
 __x64_sys_ioctl+0xd5/0x1b0
 do_syscall_64+0x6a/0x140
 entry_SYSCALL_64_after_hwframe+0x76/0x7e
RIP: 0033:0x7ffff7d1a94f
 </TASK>


-ritesh



> Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> cc: Ojaswin Mujoo <ojaswin@linux.ibm.com>
> ---
>  fs/xfs/libxfs/xfs_bmap.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 656c95a22f2e..44d5381bc66f 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -6354,6 +6354,7 @@ xfs_bunmapi_range(
>  		error = xfs_defer_finish(tpp);
>  		if (error)
>  			goto out;
> +		cond_resched();
>  	}
>  out:
>  	return error;
> --
> 2.44.0
