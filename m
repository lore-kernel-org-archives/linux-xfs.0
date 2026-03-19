Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD80840DFDD
	for <linux-xfs@vger.kernel.org>; Thu, 19 Mar 2026 19:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773949396; cv=none; b=aahP0sGn7iVECX3fQDzzcOvv/3aW6kvYCJKuGsQz3alH+6L/jr8vdhmNw+asGjbg9pCnQkLx07HC94/rRBiSe6XZaxljr2GwKridLP7qw+Yg3vo8pxrWe7Pi1dnph6pjaaFOQJqqKcUQoDmNmYbH4SnDfPIGmabNnhvSjnEHwgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773949396; c=relaxed/simple;
	bh=nqP6OqXqPAL5xs4lImG23ostT8Rq5oXNL/9/gwAGhhc=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=nTvaZnzAD529aw1LuNnRUXeHc7k1CTNASctsxFRIKgICadHGov3SADVoboa3liTscHBhhWQOSnNIAO8s0z4xNoPubTxCjj6zz1MN40bh9AuXOQ3sKe4wfAWr2TO8rXVv1pKe1/5z9nDHbmNTo43He2YaN91r8cGDA9Rh/f6Tn40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FVCOjnud; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ko8S9OcF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FVCOjnud";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ko8S9OcF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773949393;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type;
	bh=WzBwTzreRD72oHPW1PJ7lfFf4Wuc92pgPx7wFiIMpb0=;
	b=FVCOjnudOZ+ub9tN/xvCNxjRXfSAaKZqL108rtMZkJ+YMGtjcXRxEJdBaaO/6SckYw+5oH
	1BSDqX9wInlZYLak5USCItXdZJVTcF7HNgj0lIoZfHEFkUsljMJ6oXyfIuK4vFd4KVXROL
	CQcVlTy3Kd+0jzyz4zMfd4O38+YQTD8=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-578-hx1EQFERO7aBHLcVOyCQYg-1; Thu, 19 Mar 2026 15:43:10 -0400
X-MC-Unique: hx1EQFERO7aBHLcVOyCQYg-1
X-Mimecast-MFC-AGG-ID: hx1EQFERO7aBHLcVOyCQYg_1773949389
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-35b96fbfc64so6430097a91.2
        for <linux-xfs@vger.kernel.org>; Thu, 19 Mar 2026 12:43:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1773949389; x=1774554189; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WzBwTzreRD72oHPW1PJ7lfFf4Wuc92pgPx7wFiIMpb0=;
        b=ko8S9OcFqrgOLOLtGKf2VfPJPQTH5TOkVhr0la0kyzEcdZqdpjshQ809t/SbkWNnNG
         HYCOY/llvfmd7SWnQuRCR+jyf/Tuq3Ob7M5Jt3wPqgad2B1ts5kH2N38tqmuBBr5NDF+
         lQl1wT3fRMnBnJRx/BlsIZwgnhBpc6fbD8oWAwYluCMWoKsjeeXJ7Cn6IySd5vzIc0WO
         /16EuDQCHjrKs0AuWSLVMSnWCyyca2MvaeJTqu2DlJXKktvvWQEGRLXiRPa5NyEB7vz+
         hkuO1w8sUmYw157YIOr0nPjnrpvK4ucKw++zqnoIgl3HLSusiFULteT0INdbSypKpmho
         tNAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773949389; x=1774554189;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WzBwTzreRD72oHPW1PJ7lfFf4Wuc92pgPx7wFiIMpb0=;
        b=Gu99o+bIo4GBD4aZK0uuHFypjFQGAECfJIxI8HTsmXqhDd7BWuHlC0G02AH/2CZChA
         gMU9mKdfyI4ke5a5KLDCDWsTd9yAlA1/Etqr4BGyfSXpPQAbLWqkh1bXRbSjscXn2KLK
         Cyozv4VtjX2ZlT9fkCOEKhQPPIo/on9xaWeFX592sJnPKuGgBWIVBBK0M7mBOJsKBLkg
         IFrAGU4vbjkS5/kfYFyY2z75lTeevMssGKpoJfH8qu6eMKFAMYQGAYiWUpNgL/5ibyUg
         TFPIuQBqydylvhWSnFVudYcFV4kokU/6wDnE+FXyW8/kPBfpdu4U5nVN7wdj+gV08EiK
         g2bQ==
X-Gm-Message-State: AOJu0YyfvsMjgOfwqKVsYcc4M5p7L4Fugx60jEBQ4BmbDjOU9NXIC3Hn
	AgeQ83wCIelAGp9ZjK2k2aZ+NJnBqhhzONRLfPwvVWK0L3/25A6YZWs78/HxLwjt173iJyy2hvD
	EFDkYa4zfLcvehZfZ3m8i1TcOfbbjf1oZj+t9dsHhlTaaxGlN/o1Fe1yqipMU4Z42BAs1TXFYXP
	IVQSKH9xeYCvVj5eP52ANq0Xh36xiou9LrKu7oBNgpfXtj
X-Gm-Gg: ATEYQzw1LhPNwF2CGO6tG26Ybo58re/F/6SinUUlkM1aouCG/iwihwQG2zmgPVQZ9sH
	l0AU38dGHbQeOcE7m6Np3thNmO58wPhptysknWJp57YYkJNE2D1/M3WyQWHov7f7lSNBGVw6Ou9
	uzSQVFlhHMwwadapwQNVZra7DRn+diOFxGhV9AiskfM5F2smlRbctFRVYDyVpLSCmZXf+vI1D4q
	INaoBWo27ciF2sC0472H2LbgDrCz3eHz+BgYsRu39YOmWzwhXlx4X5N47MV5g31W4JnJpG5Hwxf
	wsOGY0LX4RdKyDjORYUjckURU27e4Q9diWzXVtMFBSEiI9uWXXT73GZGq8DvwsrpyXFNmja7IyV
	W6cmQEZPkoutoEoNG4g==
X-Received: by 2002:a17:90b:554e:b0:35b:9ab6:1d65 with SMTP id 98e67ed59e1d1-35bd2d52dc5mr251012a91.25.1773949388861;
        Thu, 19 Mar 2026 12:43:08 -0700 (PDT)
X-Received: by 2002:a17:90b:554e:b0:35b:9ab6:1d65 with SMTP id 98e67ed59e1d1-35bd2d52dc5mr250989a91.25.1773949387961;
        Thu, 19 Mar 2026 12:43:07 -0700 (PDT)
Received: from doltdoltdolt ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35bd355e630sm31247a91.4.2026.03.19.12.43.06
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2026 12:43:07 -0700 (PDT)
Date: Fri, 20 Mar 2026 03:43:03 +0800
From: Zorro Lang <zlang@redhat.com>
To: linux-xfs@vger.kernel.org
Subject: [Bug][xfstests xfs/556] inconsistent {HARDIRQ-ON-W} ->
 {IN-HARDIRQ-W} usage
Message-ID: <20260319194303.efw4wcu7c4idhthz@doltdoltdolt>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

While running fstests xfs/556 on kernel 7.0.0-rc4+ (HEAD=04a9f1766954), a
lockdep warning was triggered indicating an inconsistent lock state for
sb->s_type->i_lock_key.

The deadlock might occur because iomap_read_end_io (called from a hardware
interrupt completion path) invokes fserror_report, which then calls igrab.
igrab attempts to acquire the i_lock spinlock. However, the i_lock is frequently
acquired in process context with interrupts enabled. If an interrupt occurs while
a process holds the i_lock, and that interrupt handler calls fserror_report, the
system deadlocks.

I hit this warning several times by running xfs/556 (mostly) or generic/648
on xfs. More details refer to below console log.

Thanks,
Zorro

[15105.802705] run fstests xfs/556 at 2026-03-18 20:05:30
[15108.147391] XFS (sda3): Mounting V5 Filesystem 396e9164-c45a-4e05-be9d-b38c2c5c6477
[15108.171762] XFS (sda3): Ending clean mount
[15108.354287] XFS (sda3): Unmounting Filesystem 396e9164-c45a-4e05-be9d-b38c2c5c6477
[15109.690032] XFS (sda3): Mounting V5 Filesystem bf3f89c3-3c45-4650-a9c7-744f39c0191e
[15109.714629] XFS (sda3): Ending clean mount
[15109.877339] XFS (sda3): Unmounting Filesystem bf3f89c3-3c45-4650-a9c7-744f39c0191e
[15110.083161] XFS (dm-0): Mounting V5 Filesystem bf3f89c3-3c45-4650-a9c7-744f39c0191e
[15110.110860] XFS (dm-0): Ending clean mount
[15110.583809] device-mapper: table: 253:0: adding target device (start sect 209 len 1) caused an alignment inconsistency
[15110.594796] device-mapper: table: 253:0: adding target device (start sect 210 len 62914350) caused an alignment inconsistency
[15110.639670] buffer_io_error: 6 callbacks suppressed
[15110.639674] Buffer I/O error on dev dm-0, logical block 209, async page read
[15110.653608] Buffer I/O error on dev dm-0, logical block 209, async page read
[15111.885152] XFS (dm-0): Unmounting Filesystem bf3f89c3-3c45-4650-a9c7-744f39c0191e
[15111.944096] XFS (dm-0): Mounting V5 Filesystem bf3f89c3-3c45-4650-a9c7-744f39c0191e
[15111.970163] XFS (dm-0): Ending clean mount

[15111.986335] ================================
[15111.990607] WARNING: inconsistent lock state
[15111.994880] 7.0.0-rc4+ #1 Tainted: G S      W          
[15112.000124] --------------------------------
[15112.004397] inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
[15112.010403] od/2368602 [HC1[1]:SC0[0]:HE0:SE1] takes:
[15112.015455] ff1100069f2b4a98 (&sb->s_type->i_lock_key#31){?.+.}-{3:3}, at: igrab+0x28/0x1a0
[15112.023827] {HARDIRQ-ON-W} state was registered at:
[15112.028705]   __lock_acquire+0x40d/0xbd0
[15112.032651]   lock_acquire.part.0+0xbd/0x260
[15112.036922]   _raw_spin_lock+0x37/0x80
[15112.040692]   unlock_new_inode+0x66/0x2a0
[15112.044706]   xfs_iget+0x67b/0x7b0 [xfs]
[15112.048967]   xfs_mountfs+0xde4/0x1c80 [xfs]
[15112.053485]   xfs_fs_fill_super+0xe86/0x17a0 [xfs]
[15112.058518]   get_tree_bdev_flags+0x312/0x590
[15112.062879]   vfs_get_tree+0x8d/0x2f0
[15112.066544]   vfs_cmd_create+0xb2/0x240
[15112.070386]   __do_sys_fsconfig+0x3d8/0x9a0
[15112.074569]   do_syscall_64+0x13a/0x1520
[15112.078497]   entry_SYSCALL_64_after_hwframe+0x76/0x7e
[15112.083637] irq event stamp: 3118
[15112.086955] hardirqs last  enabled at (3117): [<ffffffffb54e4ad8>] _raw_spin_unlock_irq+0x28/0x50
[15112.095838] hardirqs last disabled at (3118): [<ffffffffb54b84c9>] common_interrupt+0x19/0xe0
[15112.104375] softirqs last  enabled at (3040): [<ffffffffb290ca28>] handle_softirqs+0x6b8/0x950
[15112.112998] softirqs last disabled at (3023): [<ffffffffb290ce4d>] __irq_exit_rcu+0xfd/0x250
[15112.121430] 
               other info that might help us debug this:
[15112.127956]  Possible unsafe locking scenario:

[15112.133877]        CPU0
[15112.136329]        ----
[15112.138781]   lock(&sb->s_type->i_lock_key#31);
[15112.143334]   <Interrupt>
[15112.145958]     lock(&sb->s_type->i_lock_key#31);
[15112.150680] 
                *** DEADLOCK ***

[15112.156601] 1 lock held by od/2368602:
[15112.160352]  #0: ff1100069f2b4b58 (&sb->s_type->i_mutex_key#19){++++}-{4:4}, at: xfs_ilock+0x324/0x4b0 [xfs]
[15112.170415] 
               stack backtrace:
[15112.174778] CPU: 15 UID: 0 PID: 2368602 Comm: od Kdump: loaded Tainted: G S      W           7.0.0-rc4+ #1 PREEMPT(full) 
[15112.174783] Tainted: [S]=CPU_OUT_OF_SPEC, [W]=WARN
[15112.174784] Hardware name: Dell Inc. PowerEdge R660/0R5JJC, BIOS 2.1.5 03/14/2024
[15112.174786] Call Trace:
[15112.174788]  <IRQ>
[15112.174790]  dump_stack_lvl+0x6f/0xb0
[15112.174794]  print_usage_bug.part.0+0x230/0x2c0
[15112.174797]  mark_lock_irq+0x3ce/0x5b0
[15112.174800]  ? save_trace+0x64/0x1e0
[15112.174806]  mark_lock+0x1cb/0x3d0
[15112.174809]  mark_usage+0x109/0x120
[15112.174811]  __lock_acquire+0x40d/0xbd0
[15112.174814]  lock_acquire.part.0+0xbd/0x260
[15112.174817]  ? igrab+0x28/0x1a0
[15112.174821]  ? rcu_is_watching+0x15/0xb0
[15112.174824]  ? fserror_alloc_event+0x1c8/0x330
[15112.174826]  ? igrab+0x28/0x1a0
[15112.174828]  ? lock_acquire+0x159/0x180
[15112.174831]  _raw_spin_lock+0x37/0x80
[15112.174833]  ? igrab+0x28/0x1a0
[15112.174836]  igrab+0x28/0x1a0
[15112.174839]  fserror_report+0x127/0x2d0
[15112.174842]  iomap_finish_folio_read+0x13c/0x280
[15112.174846]  ? bio_first_folio+0x2b9/0x550
[15112.174850]  iomap_read_end_io+0x10e/0x2c0
[15112.174855]  ? __pfx_iomap_read_end_io+0x10/0x10
[15112.174858]  ? percpu_ref_put_many.constprop.0+0x7a/0x1b0
[15112.174864]  ? percpu_ref_put_many.constprop.0+0x7f/0x1b0
[15112.174867]  ? bio_endio+0x5a3/0x790
[15112.174871]  clone_endio+0x37e/0x780 [dm_mod]
[15112.174895]  ? __pfx_clone_endio+0x10/0x10 [dm_mod]
[15112.174907]  ? percpu_ref_put_many.constprop.0+0x7f/0x1b0
[15112.174910]  ? bio_endio+0x5a3/0x790
[15112.174913]  blk_update_request+0x448/0xf00
[15112.174918]  ? find_held_lock+0x32/0x90
[15112.174922]  scsi_end_request+0x74/0x750
[15112.174924]  ? scsi_dec_host_busy+0x1b5/0x2b0
[15112.174927]  scsi_io_completion+0xe9/0x7c0
[15112.174929]  ? __pfx_scsi_io_completion+0x10/0x10
[15112.174933]  _scsih_io_done+0x6ba/0x1ca0 [mpt3sas]
[15112.174976]  ? mpt3sas_scsih_scsi_lookup_get+0xd4/0x3e0 [mpt3sas]
[15112.175004]  _base_process_reply_queue+0x249/0x15b0 [mpt3sas]
[15112.175032]  ? __pfx_sched_clock_cpu+0x10/0x10
[15112.175034]  ? find_held_lock+0x32/0x90
[15112.175037]  ? __pfx__base_interrupt+0x10/0x10 [mpt3sas]
[15112.175064]  _base_interrupt+0x95/0xe0 [mpt3sas]
[15112.175090]  __handle_irq_event_percpu+0x1f0/0x780
[15112.175094]  handle_irq_event+0xa9/0x1c0
[15112.175098]  handle_edge_irq+0x2ef/0x8a0
[15112.175102]  __common_interrupt+0xa0/0x170
[15112.175105]  common_interrupt+0xb7/0xe0
[15112.175108]  </IRQ>
[15112.175109]  <TASK>
[15112.175110]  asm_common_interrupt+0x26/0x40
[15112.175113] RIP: 0010:_raw_spin_unlock_irq+0x2e/0x50
[15112.175116] Code: 0f 1f 44 00 00 53 48 8b 74 24 08 48 89 fb 48 83 c7 18 e8 b5 73 5e fd 48 89 df e8 ed e2 5e fd e8 08 78 8f fd fb bf 01 00 00 00 <e8> 8d 56 4d fd 65 8b 05 46 d5 1d 03 85 c0 74 06 5b c3 cc cc cc cc
[15112.175119] RSP: 0018:ffa0000027d07538 EFLAGS: 00000206
[15112.175121] RAX: 0000000000000c2d RBX: ffffffffb6614bc8 RCX: 0000000000000080
[15112.175123] RDX: 0000000000000000 RSI: ffffffffb6306a01 RDI: 0000000000000001
[15112.175125] RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000000
[15112.175126] R10: ffffffffb75efc67 R11: 0000000000000001 R12: ff1100015ada0000
[15112.175128] R13: 0000000000000083 R14: 0000000000000002 R15: ffffffffb6614c10
[15112.175132]  ? _raw_spin_unlock_irq+0x28/0x50
[15112.175134]  folio_wait_bit_common+0x407/0x780
[15112.175138]  ? find_held_lock+0x32/0x90
[15112.175141]  ? filemap_update_page+0x377/0xbd0
[15112.175143]  ? __lock_acquired+0xe0/0x270
[15112.175145]  ? __pfx_folio_wait_bit_common+0x10/0x10
[15112.175148]  ? filemap_update_page+0x377/0xbd0
[15112.175150]  ? __pfx_wake_page_function+0x10/0x10
[15112.175155]  ? __lock_release.isra.0+0x1a2/0x2c0
[15112.175158]  ? filemap_update_page+0x8d3/0xbd0
[15112.175160]  filemap_update_page+0x8e7/0xbd0
[15112.175164]  filemap_get_pages+0x904/0xc50
[15112.175168]  ? find_held_lock+0x32/0x90
[15112.175170]  ? __pfx_filemap_get_pages+0x10/0x10
[15112.175173]  ? __pfx___might_resched+0x10/0x10
[15112.175178]  ? __page_table_check_zero+0x1c0/0x2d0
[15112.175181]  filemap_read+0x320/0xc20
[15112.175186]  ? __pfx_filemap_read+0x10/0x10
[15112.175192]  ? xfs_file_buffered_read+0x29f/0x380 [xfs]
[15112.175453]  ? xfs_ilock+0x324/0x4b0 [xfs]
[15112.175678]  xfs_file_buffered_read+0x2aa/0x380 [xfs]
[15112.175899]  xfs_file_read_iter+0x263/0x4a0 [xfs]
[15112.176119]  vfs_read+0x6cb/0xb70
[15112.176121]  ? __lock_release.isra.0+0x1a2/0x2c0
[15112.176124]  ? __pfx_vfs_read+0x10/0x10
[15112.176127]  ? __lock_acquire+0x58c/0xbd0
[15112.176130]  ? find_held_lock+0x32/0x90
[15112.176134]  ksys_read+0xf9/0x1d0
[15112.176135]  ? __pfx_ksys_read+0x10/0x10
[15112.176138]  ? lockdep_hardirqs_on+0x78/0x100
[15112.176140]  ? do_syscall_64+0xde/0x1520
[15112.176143]  do_syscall_64+0x13a/0x1520
[15112.176146]  ? __pfx_css_rstat_updated+0x10/0x10
[15112.176148]  ? __lock_acquire+0x58c/0xbd0
[15112.176151]  ? __pfx___handle_mm_fault+0x10/0x10
[15112.176154]  ? rcu_is_watching+0x15/0xb0
[15112.176156]  ? find_held_lock+0x32/0x90
[15112.176159]  ? local_clock_noinstr+0xd/0xe0
[15112.176161]  ? __lock_release.isra.0+0x1a2/0x2c0
[15112.176164]  ? count_memcg_events_mm.constprop.0+0xa7/0x1a0
[15112.176167]  ? find_held_lock+0x32/0x90
[15112.176169]  ? local_clock_noinstr+0xd/0xe0
[15112.176172]  ? __lock_release.isra.0+0x1a2/0x2c0

