Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E58F858200
	for <linux-xfs@vger.kernel.org>; Tue, 20 Feb 2024 05:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708408197; cv=none; b=pdw1Q4y1sIVqqxSxHTEEvDP1x+G4CV5MwkJmqf2TaPnoEC2gnPjGBVry+Ct3fdtgdSnxua8JBOs0ICEynjWqDolBeeVRzn2dqc5yZ2GTvqBwXJHjef45Qy0OYQkccdXD1M3T9S13Ks5oyvmSbQRxKSDFsEkeCZj00uEeMHdHv9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708408197; c=relaxed/simple;
	bh=e8UT6dSwV60osv3sSVae4f/eZL915TOpLjG31ZT9KVk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aC9MfRFI33IZDJBFS8QkYepGl8MvGflTH3Y1LxyBqFDFdyfLxIDP/WOEOI69kE0HDb7JkPKSnq6UnUHx2UUS93wNa+EeHBsaWHWxySl5WpQfbw/4j/PhUXWy2VCjE6YT+Nj/l5iTRY2Z6P5HXzdz9rQOf0YNnD3NWKGKlRehJT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fxv474vJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fxv474vJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708408191;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qH2tn9TvD8uv882iC4uAPHCnspainQDc9KShlX/5Xqo=;
	b=fxv474vJNE8GWE+kjWasg03bvzIugtFTTgZMF1ztSfDNtJ6enh617tKblaFoQl8qZqzpyc
	+LGdNuFk9zhtNaCMB2mKmdgV1ixmibN4DsRe7QnShMbZ/vGAgzG76FWezZdvmZpHwts56N
	xV/Twy6TWovOu37p4fXZfuJsNBI3NuA=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-307-FWwD5yM_MGCcZfvuV2md-w-1; Tue, 20 Feb 2024 00:49:48 -0500
X-MC-Unique: FWwD5yM_MGCcZfvuV2md-w-1
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-5d8bdadc79cso4014031a12.2
        for <linux-xfs@vger.kernel.org>; Mon, 19 Feb 2024 21:49:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708408188; x=1709012988;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qH2tn9TvD8uv882iC4uAPHCnspainQDc9KShlX/5Xqo=;
        b=wodLHOeU7FAXX5dVM0Vi8i0BjbWH4gXaMbrZLo9TEPWGCfPds5KJNl2pzCfIVBug0a
         RQ4+fpCR+Duk0xsAy3V6MpU76SdQPTQbcv+WBKHQuDZLb3y+j8EPnD8zldG1Pz8op+aJ
         0YkCp8dtc8lHnhUNrqWCfnjtv+ev1fF1WvahY3PWUq85yTdDtJku90l6Jle3VkuZ4RFx
         rY7VP5wZwdvACv/p7IL634jkpbqeJxmEpxwbxhNGdzyTtFObKC2kgbp7mFoNARtDOKMC
         buFuKEKY8ynN6kYd0vTCZV9yiesxAcX9hK9+RSLv9wPhHiJQeW3V6PGveKYpcZN8wBBH
         /H6w==
X-Gm-Message-State: AOJu0Yw4tPkAHQ2ZfCNYCqUiLTBM/fLpY8AUbcnj4KqsM5O0WEBRIxxO
	G4rG/qzUVpKolxLfQ0ikcfR6vJ2fRBvz1/XjBrDnH0/sIrnINFrj5HBo5kxgpvDAG+noGe1Tsal
	Iu+AD6VE3zFte86ucdFNTXpYMggjzJTnO1jMv6hkJKVxuqF1JOCUTc60/Vg==
X-Received: by 2002:a05:6a21:2d8f:b0:19e:b198:8241 with SMTP id ty15-20020a056a212d8f00b0019eb1988241mr13415965pzb.41.1708408187030;
        Mon, 19 Feb 2024 21:49:47 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHIvKTdiKqwun1R57W3R5Xe8vQ9XCMnjxoQtvdn3zOHLGw1Al53JVOmGY7aF5AZFdSrc1A0GQ==
X-Received: by 2002:a05:6a21:2d8f:b0:19e:b198:8241 with SMTP id ty15-20020a056a212d8f00b0019eb1988241mr13415946pzb.41.1708408185970;
        Mon, 19 Feb 2024 21:49:45 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id w6-20020a17090a1b8600b002966a13f2e9sm6141471pjc.37.2024.02.19.21.49.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Feb 2024 21:49:45 -0800 (PST)
Date: Tue, 20 Feb 2024 13:49:41 +0800
From: Zorro Lang <zlang@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
	linux-mm@kvack.org
Subject: Re: [BUG][xfstests generic/133] deadlock and crach on xfs, BUG:
 KASAN: slab-out-of-bounds in xfs_read_iomap_begin+0x5f2/0x750 [xfs]
Message-ID: <20240220054941.qqezfubpr5dcfcrw@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20240208084616.6l3cfdelev7trv3w@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <ZcVH+FzS3NaCrsqe@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZcVH+FzS3NaCrsqe@dread.disaster.area>

On Fri, Feb 09, 2024 at 08:30:32AM +1100, Dave Chinner wrote:
> cc Willy.
> 
> This looks like a page cache index issue - lookups as spinning
> probably because of a stale entry that isn't clearing up, and I
> think the KASAN report on XFS accessing an object owned byt he
> shmem_inode_cache is a bad folio returned by a lookup that is now
> (was?) owned by a shmem file and so mapping->host points at a shmem
> inode, not an XFS inode.

Just an update: It's still reproducible [1] on latest linux v6.8-rc5
(HEAD=b401b621758e), g/133 is still stuck, by loop running it 10~100
times on XFS with below multi-stripes: (just this time doesn't have
KASAN warnning output).

meta-data=/dev/sda2              isize=512    agcount=16, agsize=245744 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=1    bigtime=1 inobtcount=1 nrext64=1
data     =                       bsize=4096   blocks=3931904, imaxpct=25
         =                       sunit=16     swidth=32 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=16384, version=2
         =                       sectsz=512   sunit=16 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

Thanks,
Zorro

[1]
[ 3007.006905] run fstests generic/133 at 2024-02-19 01:36:16 
[ 3019.016044] restraintd[2635]: *** Current Time: Mon Feb 19 01:36:30 2024  Localwatchdog at: Wed Feb 21 00:52:30 2024 
[ 3048.526415] XFS (sda3): EXPERIMENTAL online scrub feature in use. Use at your own risk! 
[ 3049.098621] XFS (sda3): Unmounting Filesystem 3dc15a78-b428-41c8-aad4-a2aef1ea0ca0 
[ 3049.705927] XFS (sda3): Mounting V5 Filesystem 3dc15a78-b428-41c8-aad4-a2aef1ea0ca0 
[ 3049.755518] XFS (sda3): Ending clean mount 
[ 3049.993134] XFS (sda3): Unmounting Filesystem 3dc15a78-b428-41c8-aad4-a2aef1ea0ca0 
[ 3050.115860] XFS (sda3): Mounting V5 Filesystem 3dc15a78-b428-41c8-aad4-a2aef1ea0ca0 
[ 3050.167303] XFS (sda3): Ending clean mount 
[ 3058.370393] XFS (sda2): Mounting V5 Filesystem 59669b4a-5d3f-4f08-8ae8-f7e8c9638ef8 
[ 3058.413304] XFS (sda2): Ending clean mount 
[ 3058.439878] XFS (sda2): Unmounting Filesystem 59669b4a-5d3f-4f08-8ae8-f7e8c9638ef8 
[ 3058.558366] XFS (sda3): EXPERIMENTAL online scrub feature in use. Use at your own risk! 
[ 3059.176278] XFS (sda3): Unmounting Filesystem 3dc15a78-b428-41c8-aad4-a2aef1ea0ca0 
[ 3059.792248] XFS (sda3): Mounting V5 Filesystem 3dc15a78-b428-41c8-aad4-a2aef1ea0ca0 
[ 3059.843412] XFS (sda3): Ending clean mount 
[ 3059.958996] run fstests generic/133 at 2024-02-19 01:37:09 
[ 3079.012848] restraintd[2635]: *** Current Time: Mon Feb 19 01:37:30 2024  Localwatchdog at: Wed Feb 21 00:52:30 2024 
[ 3098.710289] watchdog: BUG: soft lockup - CPU#38 stuck for 26s! [xfs_io:258927] 
[ 3098.717520] Modules linked in: rfkill intel_rapl_msr intel_rapl_common ipmi_ssif intel_uncore_frequency intel_uncore_frequency_common i10nm_edac nfit x86_pkg_temp_thermal intel_powerclamp coretemp mlx5_ib mgag200 acpi_ipmi kvm_intel ib_uverbs i2c_algo_bit iTCO_wdt dax_hmem ipmi_si drm_shmem_helper iTCO_vendor_support cxl_acpi dell_smbios sunrpc dcdbas kvm irqbypass rapl intel_cstate ib_core cxl_core intel_uncore wmi_bmof dell_wmi_descriptor pcspkr mei_me ipmi_devintf i2c_i801 isst_if_mbox_pci isst_if_mmio drm_kms_helper mei ipmi_msghandler intel_pch_thermal isst_if_common i2c_smbus intel_vsec acpi_power_meter drm fuse xfs libcrc32c sd_mod t10_pi sg mlx5_core crct10dif_pclmul crc32_pclmul crc32c_intel ahci mlxfw libahci tls ghash_clmulni_intel libata megaraid_sas psample tg3 pci_hyperv_intf wmi 
[ 3098.787849] irq event stamp: 787114 
[ 3098.791340] hardirqs last  enabled at (787113): [<ffffffff89200dc6>] asm_sysvec_apic_timer_interrupt+0x16/0x20 
[ 3098.801342] hardirqs last disabled at (787114): [<ffffffff88ff6acb>] sysvec_apic_timer_interrupt+0xb/0xc0 
[ 3098.810909] softirqs last  enabled at (787038): [<ffffffff89033b57>] __do_softirq+0x5d7/0x8f4 
[ 3098.819431] softirqs last disabled at (787033): [<ffffffff86a5384c>] __irq_exit_rcu+0xbc/0x210 
[ 3098.828046] CPU: 38 PID: 258927 Comm: xfs_io Kdump: loaded Not tainted 6.8.0-rc5 #1 
[ 3098.835705] Hardware name: Dell Inc. PowerEdge R750/0PJ80M, BIOS 1.5.4 12/17/2021 
[ 3098.843185] RIP: 0010:lock_is_held_type+0x105/0x140 
[ 3098.848073] Code: 00 00 b8 ff ff ff ff 65 0f c1 05 a6 8f 1f 77 83 f8 01 75 2d 9c 58 f6 c4 02 75 41 48 f7 04 24 00 02 00 00 74 01 fb 48 83 c4 08 <44> 89 e0 5b 5d 41 5c 41 5d 41 5e 41 5f c3 cc cc cc cc 45 31 e4 eb 
[ 3098.866819] RSP: 0018:ffa00000257a77d0 EFLAGS: 00000292 
[ 3098.872052] RAX: 0000000000000046 RBX: ff110002b4a06c68 RCX: 0000000000000001 
[ 3098.879185] RDX: 0000000000000001 RSI: ffffffff894e63c0 RDI: ffffffff897a0240 
[ 3098.886320] RBP: ff110001d43a8000 R08: 0000000000000001 R09: fffa7c0001529806 
[ 3098.893452] R10: ffd400000a94c037 R11: 0000000000000000 R12: 0000000000000000 
[ 3098.900585] R13: 00000000ffffffff R14: ff110001d43a8f28 R15: 0000000000000002 
[ 3098.907718] FS:  00007f03b3275cc0(0000) GS:ff11000c36c00000(0000) knlGS:0000000000000000 
[ 3098.915813] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 
[ 3098.921566] CR2: 00007fa11cb64584 CR3: 00000001320b4005 CR4: 0000000000771ef0 
[ 3098.928700] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000 
[ 3098.935831] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400 
[ 3098.942963] PKRU: 55555554 
[ 3098.945676] Call Trace: 
[ 3098.948130]  <IRQ> 
[ 3098.950150]  ? watchdog_timer_fn+0x40e/0x560 
[ 3098.954430]  ? do_raw_spin_unlock+0x55/0x1f0 
[ 3098.958714]  ? __pfx_watchdog_timer_fn+0x10/0x10 
[ 3098.963343]  ? __hrtimer_run_queues+0x16a/0xad0 
[ 3098.967893]  ? __pfx___hrtimer_run_queues+0x10/0x10 
[ 3098.972779]  ? ktime_get_update_offsets_now+0x95/0x2c0 
[ 3098.977924]  ? ktime_get_update_offsets_now+0xdd/0x2c0 
[ 3098.983073]  ? hrtimer_interrupt+0x2e9/0x7a0 
[ 3098.987361]  ? __sysvec_apic_timer_interrupt+0x139/0x4f0 
[ 3098.992680]  ? sysvec_apic_timer_interrupt+0x8e/0xc0 
[ 3098.997652]  </IRQ> 
[ 3098.999756]  <TASK> 
[ 3099.001863]  ? asm_sysvec_apic_timer_interrupt+0x16/0x20 
[ 3099.007190]  ? lock_is_held_type+0x105/0x140 
[ 3099.011473]  xas_start+0x19d/0x510 
[ 3099.014886]  xas_load+0x2e/0xf0 
[ 3099.018040]  filemap_get_read_batch+0x413/0x6b0 
[ 3099.022580]  ? __pfx_filemap_get_read_batch+0x10/0x10 
[ 3099.027646]  ? __lock_release+0x487/0x960 
[ 3099.031663]  ? __pfx___lock_release+0x10/0x10 
[ 3099.036033]  filemap_get_pages+0x19e/0x960 
[ 3099.040149]  ? __pfx_filemap_get_pages+0x10/0x10 
[ 3099.044790]  filemap_read+0x2f9/0x9d0 
[ 3099.048484]  ? __pfx_filemap_read+0x10/0x10 
[ 3099.052678]  ? down_read_nested+0xc2/0x4d0 
[ 3099.056788]  ? __pfx_down_read_nested+0x10/0x10 
[ 3099.061336]  ? xfs_file_buffered_read+0x170/0x320 [xfs] 
[ 3099.066863]  xfs_file_buffered_read+0x17b/0x320 [xfs] 
[ 3099.072183]  xfs_file_read_iter+0x27a/0x570 [xfs] 
[ 3099.077151]  vfs_read+0x5be/0xbe0 
[ 3099.080488]  ? __pfx_vfs_read+0x10/0x10 
[ 3099.084325]  ? local_clock_noinstr+0x9/0xc0 
[ 3099.088518]  ? __fget_files+0x1b8/0x3f0 
[ 3099.092379]  __x64_sys_pread64+0x193/0x1e0 
[ 3099.096487]  ? __pfx___x64_sys_pread64+0x10/0x10 
[ 3099.101115]  ? ktime_get_coarse_real_ts64+0x130/0x170 
[ 3099.106187]  do_syscall_64+0x94/0x190 
[ 3099.109859]  ? lockdep_hardirqs_on_prepare.part.0+0x18c/0x370 
[ 3099.115614]  ? do_syscall_64+0xa3/0x190 
[ 3099.119454]  ? lockdep_hardirqs_on+0x79/0x100 
[ 3099.123823]  ? do_syscall_64+0xa3/0x190 
[ 3099.127668]  ? do_syscall_64+0xa3/0x190 
[ 3099.131507]  ? do_syscall_64+0xa3/0x190 
[ 3099.135353]  entry_SYSCALL_64_after_hwframe+0x6e/0x76 
[ 3099.140417] RIP: 0033:0x7f03b30fba9f 
[ 3099.144004] Code: 08 89 3c 24 48 89 4c 24 18 e8 bd a5 f8 ff 4c 8b 54 24 18 48 8b 54 24 10 41 89 c0 48 8b 74 24 08 8b 3c 24 b8 11 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 31 44 89 c7 48 89 04 24 e8 0d a6 f8 ff 48 8b 
[ 3099.162752] RSP: 002b:00007fff1e20ff10 EFLAGS: 00000293 ORIG_RAX: 0000000000000011 
[ 3099.170325] RAX: ffffffffffffffda RBX: 00007fff1e20ffc0 RCX: 00007f03b30fba9f 
[ 3099.177459] RDX: 0000000000010000 RSI: 0000000000862000 RDI: 0000000000000003 
[ 3099.184590] RBP: 0000000000000003 R08: 0000000000000000 R09: 0000000000000003 
[ 3099.191725] R10: 000000000d750000 R11: 0000000000000293 R12: 0000000000000d75 
[ 3099.198857] R13: 00000000128b0000 R14: 0000000000000000 R15: 000000000d750000 
[ 3099.206007]  </TASK> 
[ 3099.208198] watchdog: BUG: soft lockup - CPU#42 stuck for 26s! [xfs_io:258926] 
[ 3099.215428] Modules linked in: rfkill intel_rapl_msr intel_rapl_common ipmi_ssif intel_uncore_frequency intel_uncore_frequency_common i10nm_edac nfit x86_pkg_temp_thermal intel_powerclamp coretemp mlx5_ib mgag200 acpi_ipmi kvm_intel ib_uverbs i2c_algo_bit iTCO_wdt dax_hmem ipmi_si drm_shmem_helper iTCO_vendor_support cxl_acpi dell_smbios sunrpc dcdbas kvm irqbypass rapl intel_cstate ib_core cxl_core intel_uncore wmi_bmof dell_wmi_descriptor pcspkr mei_me ipmi_devintf i2c_i801 isst_if_mbox_pci isst_if_mmio drm_kms_helper mei ipmi_msghandler intel_pch_thermal isst_if_common i2c_smbus intel_vsec acpi_power_meter drm fuse xfs libcrc32c sd_mod t10_pi sg mlx5_core crct10dif_pclmul crc32_pclmul crc32c_intel ahci mlxfw libahci tls ghash_clmulni_intel libata megaraid_sas psample tg3 pci_hyperv_intf wmi 
[ 3099.285747] irq event stamp: 603296 
[ 3099.289241] hardirqs last  enabled at (603295): [<ffffffff89200dc6>] asm_sysvec_apic_timer_interrupt+0x16/0x20 
[ 3099.299243] hardirqs last disabled at (603296): [<ffffffff88ff6acb>] sysvec_apic_timer_interrupt+0xb/0xc0 
[ 3099.308808] softirqs last  enabled at (603252): [<ffffffff89033b57>] __do_softirq+0x5d7/0x8f4 
[ 3099.317329] softirqs last disabled at (603247): [<ffffffff86a5384c>] __irq_exit_rcu+0xbc/0x210 
[ 3099.325943] CPU: 42 PID: 258926 Comm: xfs_io Kdump: loaded Tainted: G             L     6.8.0-rc5 #1 
[ 3099.335068] Hardware name: Dell Inc. PowerEdge R750/0PJ80M, BIOS 1.5.4 12/17/2021 
[ 3099.342549] RIP: 0010:lock_is_held_type+0x105/0x140 
[ 3099.347430] Code: 00 00 b8 ff ff ff ff 65 0f c1 05 a6 8f 1f 77 83 f8 01 75 2d 9c 58 f6 c4 02 75 41 48 f7 04 24 00 02 00 00 74 01 fb 48 83 c4 08 <44> 89 e0 5b 5d 41 5c 41 5d 41 5e 41 5f c3 cc cc cc cc 45 31 e4 eb 
[ 3099.366182] RSP: 0018:ffa00000257974f8 EFLAGS: 00000282 
[ 3099.371408] RAX: 0000000000000046 RBX: ff110002b4a06c68 RCX: 0000000000000001 
[ 3099.378543] RDX: 0000000000000002 RSI: ffffffff894e63c0 RDI: ffffffff897a0240 
[ 3099.385675] RBP: ff11000331e08000 R08: 0000000000000001 R09: fffa7c0001529806 
[ 3099.392806] R10: ffd400000a94c037 R11: 0000000000000000 R12: 0000000000000000 
[ 3099.399938] R13: 00000000ffffffff R14: ff11000331e08f60 R15: 0000000000000003 
[ 3099.407073] FS:  00007f52bca1ccc0(0000) GS:ff11000c37400000(0000) knlGS:0000000000000000 
[ 3099.415158] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 
[ 3099.420905] CR2: 00007f437c400920 CR3: 0000000124d4a003 CR4: 0000000000771ef0 
[ 3099.428036] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000 
[ 3099.435171] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400 
[ 3099.442301] PKRU: 55555554 
[ 3099.445015] Call Trace: 
[ 3099.447467]  <IRQ> 
[ 3099.449490]  ? watchdog_timer_fn+0x40e/0x560 
[ 3099.453768]  ? do_raw_spin_unlock+0x55/0x1f0 
[ 3099.458050]  ? __pfx_watchdog_timer_fn+0x10/0x10 
[ 3099.462673]  ? __hrtimer_run_queues+0x16a/0xad0 
[ 3099.467224]  ? __pfx___hrtimer_run_queues+0x10/0x10 
[ 3099.472109]  ? ktime_get_update_offsets_now+0x95/0x2c0 
[ 3099.477256]  ? ktime_get_update_offsets_now+0xdd/0x2c0 
[ 3099.482405]  ? hrtimer_interrupt+0x2e9/0x7a0 
[ 3099.486700]  ? __sysvec_apic_timer_interrupt+0x139/0x4f0 
[ 3099.492017]  ? sysvec_apic_timer_interrupt+0x8e/0xc0 
[ 3099.496991]  </IRQ> 
[ 3099.499095]  <TASK> 
[ 3099.501204]  ? asm_sysvec_apic_timer_interrupt+0x16/0x20 
[ 3099.506535]  ? lock_is_held_type+0x105/0x140 
[ 3099.510821]  xas_descend+0x247/0x310 
[ 3099.514407]  xas_load+0x8b/0xf0 
[ 3099.517561]  xas_find+0x4b2/0x6c0 
[ 3099.520893]  find_get_entries+0x13d/0x870 
[ 3099.524921]  ? __pfx_find_get_entries+0x10/0x10 
[ 3099.529461]  ? filemap_get_folios_tag+0x603/0x830 
[ 3099.534182]  invalidate_inode_pages2_range+0x134/0xbf0 
[ 3099.539336]  ? __pfx_invalidate_inode_pages2_range+0x10/0x10 
[ 3099.545007]  ? __filemap_fdatawait_range+0xb0/0x190 
[ 3099.549893]  ? __pfx___filemap_fdatawait_range+0x10/0x10 
[ 3099.555211]  ? filemap_fdatawrite_wbc+0x38/0x180 
[ 3099.559835]  ? filemap_map_pages+0x7d0/0x1050 
[ 3099.564202]  ? __pfx___filemap_fdatawrite_range+0x10/0x10 
[ 3099.569619]  ? rcu_is_watching+0x11/0xb0 
[ 3099.573554]  ? filemap_check_errors+0x56/0xf0 
[ 3099.577922]  ? filemap_write_and_wait_range.part.0+0x94/0xc0 
[ 3099.583596]  __iomap_dio_rw+0x95a/0x1740 
[ 3099.587546]  ? __pfx___xfs_trans_commit+0x10/0x10 [xfs] 
[ 3099.593052]  ? __pfx___iomap_dio_rw+0x10/0x10 
[ 3099.597456]  ? xfs_file_write_checks+0x4bc/0x8d0 [xfs] 
[ 3099.602862]  iomap_dio_rw+0xe/0x40 
[ 3099.606277]  xfs_file_dio_write_aligned+0xff/0x140 [xfs] 
[ 3099.611853]  ? __pfx_xfs_file_dio_write_aligned+0x10/0x10 [xfs] 
[ 3099.618039]  xfs_file_write_iter+0x463/0x680 [xfs] 
[ 3099.623096]  vfs_write+0x9ad/0xff0 
[ 3099.626510]  ? __pfx_vfs_write+0x10/0x10 
[ 3099.630439]  ? local_clock_noinstr+0x9/0xc0 
[ 3099.634631]  ? __fget_files+0x1b8/0x3f0 
[ 3099.638491]  __x64_sys_pwrite64+0x193/0x1e0 
[ 3099.642686]  ? __pfx___x64_sys_pwrite64+0x10/0x10 
[ 3099.647397]  ? ktime_get_coarse_real_ts64+0x130/0x170 
[ 3099.652453]  ? lockdep_hardirqs_on_prepare.part.0+0x18c/0x370 
[ 3099.658217]  do_syscall_64+0x94/0x190 
[ 3099.661892]  ? lockdep_hardirqs_on_prepare.part.0+0x18c/0x370 
[ 3099.667644]  ? do_syscall_64+0xa3/0x190 
[ 3099.671485]  ? lockdep_hardirqs_on+0x79/0x100 
[ 3099.675854]  ? do_syscall_64+0xa3/0x190 
[ 3099.679701]  ? do_syscall_64+0xa3/0x190 
[ 3099.683539]  ? do_syscall_64+0xa3/0x190 
[ 3099.687377]  ? lockdep_hardirqs_on_prepare.part.0+0x18c/0x370 
[ 3099.693128]  entry_SYSCALL_64_after_hwframe+0x6e/0x76 
[ 3099.698185] RIP: 0033:0x7f52bc8fbb4f 
[ 3099.701766] Code: 08 89 3c 24 48 89 4c 24 18 e8 0d a5 f8 ff 4c 8b 54 24 18 48 8b 54 24 10 41 89 c0 48 8b 74 24 08 8b 3c 24 b8 12 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 31 44 89 c7 48 89 04 24 e8 5d a5 f8 ff 48 8b 
[ 3099.720511] RSP: 002b:00007fffbfee2430 EFLAGS: 00000293 ORIG_RAX: 0000000000000012 
[ 3099.728086] RAX: ffffffffffffffda RBX: 000000000d750000 RCX: 00007f52bc8fbb4f 
[ 3099.735219] RDX: 0000000000010000 RSI: 0000000001b74000 RDI: 0000000000000003 
[ 3099.742351] RBP: 00000000ffffffff R08: 0000000000000000 R09: 0000000000000079 
[ 3099.749483] R10: 000000000d750000 R11: 0000000000000293 R12: 000000000d750000 
[ 3099.756615] R13: 0000000000000000 R14: 0000000000000d75 R15: 00000000128b0000 
[ 3099.763766]  </TASK> 
[ 3126.710029] watchdog: BUG: soft lockup - CPU#38 stuck for 52s! [xfs_io:258927]
...
...
[   35.270303] swapper/0 invoked oom-killer: gfp_mask=0xcc0(GFP_KERNEL), order=0, oom_score_adj=0 
[   35.278943] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 6.8.0-rc5 #1 
[   35.279922] Hardware name: Dell Inc. PowerEdge R750/0PJ80M, BIOS 1.5.4 12/17/2021 
[   35.279922] Call Trace: 
[   35.279922]  <TASK> 
[   35.279922]  dump_stack_lvl+0x8e/0xb0 
[   35.279922]  dump_header+0x109/0x7e0 
[   35.279922]  out_of_memory+0x5e0/0x970 
[   35.279922]  ? __pfx_out_of_memory+0x10/0x10 
[   35.279922]  __alloc_pages_slowpath.constprop.0+0x13a1/0x1c10 
[   35.279922]  ? __pfx___alloc_pages_slowpath.constprop.0+0x10/0x10 
[   35.279922]  ? get_page_from_freelist+0x35c/0x10f0 
[   35.279922]  __alloc_pages+0x47b/0x550 
[   35.279922]  ? __pfx_lock_acquire+0x10/0x10 
[   35.279922]  ? __pfx___alloc_pages+0x10/0x10 
[   35.279922]  ? __lock_release+0x487/0x960 
[   35.279922]  ? finish_task_switch.isra.0+0x2c2/0xb40 
[   35.279922]  ? lockdep_hardirqs_on+0x79/0x100 
[   35.279922]  allocate_slab+0x342/0x3a0 
[   35.279922]  ___slab_alloc+0x7bc/0x1470 
[   35.279922]  ? key_alloc+0xa39/0x1100 
[   35.279922]  ? __lock_release+0x487/0x960 
[   35.279922]  ? ___slab_alloc+0x30/0x1470 
[   35.279922]  ? __pfx___lock_release+0x10/0x10 
[   35.279922]  ? key_alloc+0xa39/0x1100 
[   35.279922]  ? __slab_alloc.constprop.0+0x52/0xa0 
[   35.279922]  __slab_alloc.constprop.0+0x52/0xa0 
[   35.279922]  ? key_alloc+0xa39/0x1100 
[   35.279922]  kmem_cache_alloc+0x3d8/0x420 
[   35.279922]  ? console_trylock_spinning+0x10/0x230 
[   35.279922]  key_alloc+0xa39/0x1100 
[   35.279922]  ? __pfx_system_trusted_keyring_init+0x10/0x10 
[   35.279922]  ? __pfx_key_alloc+0x10/0x10 
[   35.279922]  ? __pfx__printk+0x10/0x10 
[   35.279922]  ? _raw_spin_unlock_irqrestore+0x42/0x70 
[   35.279922]  ? __pfx_system_trusted_keyring_init+0x10/0x10 
[   35.279922]  keyring_alloc+0x27/0x70 
[   35.279922]  ? __pfx_system_trusted_keyring_init+0x10/0x10 
[   35.279922]  system_trusted_keyring_init+0x6a/0x1e0 
[   35.279922]  do_one_initcall+0xfb/0x540 
[   35.279922]  ? __pfx_do_one_initcall+0x10/0x10 
[   35.279922]  ? parse_one+0x2a0/0x370 
[   35.279922]  ? __kmalloc+0x3d1/0x540 
[   35.279922]  ? do_initcalls+0x2a/0x1d0 
[   35.279922]  do_initcalls+0x138/0x1d0 
[   35.279922]  kernel_init_freeable+0x8bd/0xbe0 
[   35.279922]  ? __pfx_kernel_init+0x10/0x10 
[   35.279922]  kernel_init+0x1b/0x1e0 
[   35.279922]  ? _raw_spin_unlock_irq+0x2f/0x50 
[   35.279922]  ret_from_fork+0x2d/0x70 
[   35.279922]  ? __pfx_kernel_init+0x10/0x10 
[   35.279922]  ret_from_fork_asm+0x1b/0x30 
[   35.279922]  </TASK> 
[   35.497570] Mem-Info: 
[   35.499857] active_anon:1905 inactive_anon:0 isolated_anon:0 
[   35.499857]  active_file:0 inactive_file:0 isolated_file:0 
[   35.499857]  unevictable:0 dirty:0 writeback:0 
[   35.499857]  slab_reclaimable:294 slab_unreclaimable:25805 
[   35.499857]  mapped:0 shmem:1905 pagetables:9 
[   35.499857]  sec_pagetables:0 bounce:0 
[   35.499857]  kernel_misc_reclaimable:0 
[   35.499857]  free:222 free_pcp:527 free_cma:0 
[   35.536903] Node 0 active_anon:7620kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:0kB dirty:0kB writeback:0kB shmem:7620kB shmem_thp:0kB shmem_pmdmapped:0kB anon_thp:0kB writeback_tmp:0kB kernel_stack:1280kB pagetables:36kB sec_pagetables:0kB all_unreclaimable? no 
[   35.566171] Node 0 DMA free:0kB boost:0kB min:0kB low:0kB high:0kB reserved_highatomic:0KB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:620kB managed:0kB mlocked:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB 
[   35.590867] lowmem_reserve[]: 0 0 0 0 0 
[   35.594722] Node 0 DMA32 free:888kB boost:2048kB min:3780kB low:4212kB high:4644kB reserved_highatomic:0KB active_anon:7620kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:523388kB managed:188064kB mlocked:0kB bounce:0kB free_pcp:2108kB local_pcp:2108kB free_cma:0kB 
[   35.622266] lowmem_reserve[]: 0 0 0 0 0 
[   35.626124] Node 0 DMA: 0*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 0kB 
[   35.636405] Node 0 DMA32: 20*4kB (UM) 7*8kB (UM) 3*16kB (UM) 2*32kB (U) 2*64kB (U) 0*128kB 0*256kB 1*512kB (U) 0*1024kB 0*2048kB 0*4096kB = 888kB 
[   35.649464] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB 
[   35.658142] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB 
[   35.666564] 1905 total pagecache pages 
[   35.670316] 0 pages in swap cache 
[   35.673636] Free swap  = 0kB 
[   35.676524] Total swap = 0kB 
[   35.679414] 131002 pages RAM 
[   35.682302] 0 pages HighMem/MovableOnly 
[   35.686140] 83986 pages reserved 
[   35.689374] 0 pages cma reserved 
[   35.692606] 0 pages hwpoisoned 
[   35.695667] Unreclaimable slab info: 
[   35.699266] Name                      Used          Total 
[   35.704679] RAW                       15KB         15KB 
[   35.709902] UDP                       15KB         15KB 
[   35.715123] hugetlbfs_inode_cache         30KB         30KB 
[   35.720692] bio-248                   15KB         15KB 
[   35.725924] sgpool-128                29KB         29KB 
[   35.731144] sgpool-64                 31KB         31KB 
[   35.736368] sgpool-32                 15KB         15KB 
[   35.741589] sgpool-16                  7KB          7KB 
[   35.746813] sgpool-8                   3KB          3KB 
[   35.752037] bio-184                    3KB          3KB 
[   35.757265] biovec-max               178KB        178KB 
[   35.762491] bio_integrity_payload          3KB          3KB 
[   35.768072] dmaengine-unmap-256         30KB         30KB 
[   35.773470] dmaengine-unmap-128         15KB         15KB 
[   35.778863] dmaengine-unmap-16          4KB          4KB 
[   35.784172] dmaengine-unmap-2          3KB          3KB 
[   35.789395] audit_buffer               3KB          3KB 
[   35.794617] skbuff_small_head         15KB         15KB 
[   35.799840] skbuff_head_cache          7KB          7KB 
[   35.805069] proc_dir_entry           108KB        108KB 
[   35.810294] shmem_inode_cache        184KB        184KB 
[   35.815517] kernfs_node_cache      10004KB      10004KB 
[   35.820737] mnt_cache                 11KB         11KB 
[   35.825960] filp                       7KB          7KB 
[   35.831188] names_cache              624KB        624KB 
[   35.836420] avc_node                   3KB          3KB 
[   35.841646] lsm_inode_cache           86KB         86KB 
[   35.846866] lsm_file_cache             3KB          3KB 
[   35.852093] nsproxy                    3KB          3KB 
[   35.857321] fs_cache                   3KB          3KB 
[   35.862544] files_cache                7KB          7KB 
[   35.867765] signal_cache              78KB         78KB 
[   35.872987] sighand_cache            120KB        120KB 
[   35.878210] task_struct              622KB        622KB 
[   35.883434] cred_jar                  15KB         15KB 
[   35.888656] pid                       15KB         15KB 
[   35.893890] Acpi-Operand           38940KB      39359KB 
[   35.899117] Acpi-ParseExt             39KB         55KB 
[   35.904342] Acpi-Parse               483KB        622KB 
[   35.909572] Acpi-State               638KB        763KB 
[   35.914792] Acpi-Namespace          4005KB       4016KB 
[   35.920017] numa_policy                3KB          3KB 
[   35.925238] perf_event                15KB         15KB 
[   35.930462] trace_event_file         268KB        268KB 
[   35.935683] ftrace_event_field        500KB        500KB 
[   35.940995] pool_workqueue            48KB         48KB 
[   35.946221] maple_node                16KB         16KB 
[   35.951447] mm_struct                 30KB         30KB 
[   35.956677] vmap_area                 40KB         66KB 
[   35.961897] debug_objects_cache        504KB        504KB 
[   35.967293] page->ptl                  3KB          3KB 
[   35.972516] kmalloc-cg-4k             32KB         32KB 
[   35.977738] kmalloc-cg-2k             32KB         32KB 
[   35.982962] kmalloc-cg-1k             16KB         16KB 
[   35.988183] kmalloc-cg-512            24KB         24KB 
[   35.993405] kmalloc-cg-256             8KB          8KB 
[   35.998628] kmalloc-cg-192             7KB          7KB 
[   36.003850] kmalloc-cg-128             4KB          4KB 
[   36.009073] kmalloc-cg-96              3KB          3KB 
[   36.014295] kmalloc-cg-32              8KB          8KB 
[   36.019518] kmalloc-cg-16              3KB          3KB 
[   36.024740] kmalloc-cg-8               3KB          3KB 
[   36.029970] kmalloc-8k               256KB        256KB 
[   36.035195] kmalloc-4k              3864KB       4128KB 
[   36.040415] kmalloc-2k              5916KB       5952KB 
[   36.045643] kmalloc-1k               640KB        640KB 
[   36.050870] kmalloc-512             1936KB       1936KB 
[   36.056092] kmalloc-256               92KB         92KB 
[   36.061315] kmalloc-192               99KB         99KB 
[   36.066538] kmalloc-128               92KB         92KB 
[   36.071758] kmalloc-96               521KB        521KB 
[   36.076984] kmalloc-64             11023KB      11091KB 
[   36.082211] kmalloc-32              5831KB       5848KB 
[   36.087434] kmalloc-16               763KB        763KB 
[   36.092658] kmalloc-8                306KB        582KB 
[   36.097879] kmem_cache_node           48KB         48KB 
[   36.103102] kmem_cache                60KB         60KB 
[   36.108325] Tasks state (memory values in pages): 
[   36.113028] [  pid  ]   uid  tgid total_vm      rss rss_anon rss_file rss_shmem pgtables_bytes swapents oom_score_adj name 
[   36.124046] Out of memory and no killable processes... 
[   36.129189] Kernel panic - not syncing: System is deadlocked on memory 
[   36.130184] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 6.8.0-rc5 #1 
[   36.130184] Hardware name: Dell Inc. PowerEdge R750/0PJ80M, BIOS 1.5.4 12/17/2021 
[   36.130184] Call Trace: 
[   36.130184]  <TASK> 
[   36.130184]  dump_stack_lvl+0x60/0xb0 
[   36.130184]  panic+0x4e6/0x560 
[   36.130184]  ? __pfx_panic+0x10/0x10 
[   36.130184]  out_of_memory+0x902/0x970 
[   36.130184]  ? __pfx_out_of_memory+0x10/0x10 
[   36.130184]  __alloc_pages_slowpath.constprop.0+0x13a1/0x1c10 
[   36.130184]  ? __pfx___alloc_pages_slowpath.constprop.0+0x10/0x10 
[   36.130184]  ? get_page_from_freelist+0x35c/0x10f0 
[   36.130184]  __alloc_pages+0x47b/0x550 
[   36.130184]  ? __pfx_lock_acquire+0x10/0x10 
[   36.130184]  ? __pfx___alloc_pages+0x10/0x10 
[   36.130184]  ? __lock_release+0x487/0x960 
[   36.130184]  ? finish_task_switch.isra.0+0x2c2/0xb40 
[   36.130184]  ? lockdep_hardirqs_on+0x79/0x100 
[   36.130184]  allocate_slab+0x342/0x3a0 
[   36.130184]  ___slab_alloc+0x7bc/0x1470 
[   36.130184]  ? key_alloc+0xa39/0x1100 
[   36.130184]  ? __lock_release+0x487/0x960 
[   36.130184]  ? ___slab_alloc+0x30/0x1470 
[   36.130184]  ? __pfx___lock_release+0x10/0x10 
[   36.130184]  ? key_alloc+0xa39/0x1100 
[   36.130184]  ? __slab_alloc.constprop.0+0x52/0xa0 
[   36.130184]  __slab_alloc.constprop.0+0x52/0xa0 
[   36.130184]  ? key_alloc+0xa39/0x1100 
[   36.130184]  kmem_cache_alloc+0x3d8/0x420 
[   36.130184]  ? console_trylock_spinning+0x10/0x230 
[   36.130184]  key_alloc+0xa39/0x1100 
[   36.130184]  ? __pfx_system_trusted_keyring_init+0x10/0x10 
[   36.130184]  ? __pfx_key_alloc+0x10/0x10 
[   36.130184]  ? __pfx__printk+0x10/0x10 
[   36.130184]  ? _raw_spin_unlock_irqrestore+0x42/0x70 
[   36.130184]  ? __pfx_system_trusted_keyring_init+0x10/0x10 
[   36.130184]  keyring_alloc+0x27/0x70 
[   36.130184]  ? __pfx_system_trusted_keyring_init+0x10/0x10 
[   36.130184]  system_trusted_keyring_init+0x6a/0x1e0 
[   36.130184]  do_one_initcall+0xfb/0x540 
[   36.130184]  ? __pfx_do_one_initcall+0x10/0x10 
[   36.130184]  ? parse_one+0x2a0/0x370 
[   36.130184]  ? __kmalloc+0x3d1/0x540 
[   36.130184]  ? do_initcalls+0x2a/0x1d0 
[   36.130184]  do_initcalls+0x138/0x1d0 
[   36.130184]  kernel_init_freeable+0x8bd/0xbe0 
[   36.130184]  ? __pfx_kernel_init+0x10/0x10 
[   36.130184]  kernel_init+0x1b/0x1e0 
[   36.130184]  ? _raw_spin_unlock_irq+0x2f/0x50 
[   36.130184]  ret_from_fork+0x2d/0x70 
[   36.130184]  ? __pfx_kernel_init+0x10/0x10 
[   36.130184]  ret_from_fork_asm+0x1b/0x30 
[   36.130184]  </TASK> 
[   36.130184] Kernel Offset: disabled 
[   36.130184] Rebooting in 10 seconds.. 
[-- MARK -- Mon Feb 19 12:30:00 2024] 
   
       
 [=3h   
       
Error: No response to keepalive - Terminating session 
Error: No response de-activating SOL payload 
[-- Console down -- Mon Feb 19 12:32:01 2024] 
[-- Console up -- Mon Feb 19 12:32:01 2024] 

> 
> -Dave.
> 
> On Thu, Feb 08, 2024 at 04:46:16PM +0800, Zorro Lang wrote:
> > Hi,
> > 
> > Recently I hit a deadlock then panic at the end [1] by running
> > xfstests generic/133 on x86_64 xfs with linux v6.8-rc3+. And
> > it's reproducible by loop running g/133 many times.
> > 
> > But I found that each time I hit this deadlock, the testing
> > machine uses a *multi-stripes* disk/fs, likes:
> > 
> > TEST_DEV:
> > meta-data=/dev/sda2              isize=512    agcount=16, agsize=245744 blks
> >          =                       sectsz=512   attr=2, projid32bit=1
> >          =                       crc=1        finobt=1, sparse=1, rmapbt=0
> >          =                       reflink=1    bigtime=1 inobtcount=1 nrext64=1
> > data     =                       bsize=4096   blocks=3931904, imaxpct=25
> >          =                       sunit=16     swidth=32 blks
> > naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> > log      =internal log           bsize=4096   blocks=16384, version=2
> >          =                       sectsz=512   sunit=16 blks, lazy-count=1
> > realtime =none                   extsz=4096   blocks=0, rtextents=0
> > 
> > SCRATCH_DEV:
> > meta-data=/dev/sda3              isize=512    agcount=16, agsize=245744 blks
> >          =                       sectsz=512   attr=2, projid32bit=1
> >          =                       crc=1        finobt=1, sparse=1, rmapbt=0
> >          =                       reflink=1    bigtime=1 inobtcount=1 nrext64=1
> > data     =                       bsize=4096   blocks=3931904, imaxpct=25
> >          =                       sunit=16     swidth=32 blks
> > naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> > log      =internal log           bsize=4096   blocks=16384, version=2
> >          =                       sectsz=512   sunit=16 blks, lazy-count=1
> > realtime =none                   extsz=4096   blocks=0, rtextents=0
> > 
> > I haven't reproduced this issue on a xfs with sunit=0 and swidth=0.
> > 
> > The newest linux commit id (HEAD) which I used to hit this issue is
> > (mainline linux):
> > 
> > commit 547ab8fc4cb04a1a6b34377dd8fad34cd2c8a8e3
> > Author: Linus Torvalds <torvalds@linux-foundation.org>
> > Date:   Wed Feb 7 18:06:16 2024 +0000
> > 
> >     Merge tag 'loongarch-fixes-6.8-2' of git://git.kernel.org/pub/scm/linux/kernel/git/chenhuacai/linux-loongson
> > 
> > Thanks,
> > Zorro
> > 
> > [1]
> > [ 4566.643284] run fstests generic/133 at 2024-02-07 05:44:09 
> > [ 4606.053701] watchdog: BUG: soft lockup - CPU#23 stuck for 26s! [xfs_io:1139165] 
> > [ 4606.061022] Modules linked in: dm_snapshot dm_bufio ext4 mbcache jbd2 loop dm_flakey dm_mod rfkill intel_rapl_msr intel_rapl_common ipmi_ssif intel_uncore_frequency intel_uncore_frequency_common i10nm_edac nfit x86_pkg_temp_thermal intel_powerclamp mlx5_ib coretemp acpi_ipmi ib_uverbs kvm_intel mgag200 iTCO_wdt ipmi_si dax_hmem i2c_algo_bit mei_me iTCO_vendor_support cxl_acpi drm_shmem_helper dell_smbios sunrpc dcdbas kvm irqbypass rapl intel_cstate ib_core cxl_core intel_uncore dell_wmi_descriptor wmi_bmof pcspkr ipmi_devintf i2c_i801 isst_if_mmio isst_if_mbox_pci drm_kms_helper mei isst_if_common ipmi_msghandler intel_pch_thermal intel_vsec i2c_smbus acpi_power_meter drm fuse xfs libcrc32c sd_mod t10_pi sg mlx5_core crct10dif_pclmul crc32_pclmul crc32c_intel ahci libahci mlxfw tls ghash_clmulni_intel megaraid_sas tg3 libata psample pci_hyperv_intf wmi [last unloaded: scsi_debug] 
> > [ 4606.139091] irq event stamp: 606146 
> > [ 4606.142590] hardirqs last  enabled at (606145): [<ffffffff84800dc6>] asm_sysvec_apic_timer_interrupt+0x16/0x20 
> > [ 4606.152591] hardirqs last disabled at (606146): [<ffffffff845f5acb>] sysvec_apic_timer_interrupt+0xb/0xc0 
> > [ 4606.162161] softirqs last  enabled at (606050): [<ffffffff84632b47>] __do_softirq+0x5d7/0x8f4 
> > [ 4606.170689] softirqs last disabled at (606045): [<ffffffff8205392c>] __irq_exit_rcu+0xbc/0x210 
> > [ 4606.179305] CPU: 23 PID: 1139165 Comm: xfs_io Kdump: loaded Not tainted 6.8.0-rc3+ #1 
> > [ 4606.187137] Hardware name: Dell Inc. PowerEdge R750/0PJ80M, BIOS 1.5.4 12/17/2021 
> > [ 4606.194617] RIP: 0010:lock_is_held_type+0x105/0x140 
> > [ 4606.199507] Code: 00 00 b8 ff ff ff ff 65 0f c1 05 a6 9f bf 7b 83 f8 01 75 2d 9c 58 f6 c4 02 75 41 48 f7 04 24 00 02 00 00 74 01 fb 48 83 c4 08 <44> 89 e0 5b 5d 41 5c 41 5d 41 5e 41 5f c3 cc cc cc cc 45 31 e4 eb 
> > [ 4606.218259] RSP: 0018:ffa000002332f710 EFLAGS: 00000292 
> > [ 4606.223496] RAX: 0000000000000046 RBX: ffffffff85d31460 RCX: 0000000000000001 
> > [ 4606.230636] RDX: 0000000000000001 RSI: ffffffff84ae63c0 RDI: ffffffff84da0200 
> > [ 4606.237768] RBP: ff1100154932be40 R08: 0000000000000001 R09: fffa7c0008ec7a06 
> > [ 4606.244900] R10: ffd400004763d037 R11: 0000000000000000 R12: 0000000000000001 
> > [ 4606.252034] R13: 00000000ffffffff R14: ff1100154932cd68 R15: 0000000000000001 
> > [ 4606.259167] FS:  00007f45ed47ccc0(0000) GS:ff11002033c00000(0000) knlGS:0000000000000000 
> > [ 4606.267262] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 
> > [ 4606.273006] CR2: 00007fdc20089000 CR3: 00000011446ea004 CR4: 0000000000771ef0 
> > [ 4606.280140] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000 
> > [ 4606.287274] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400 
> > [ 4606.294413] PKRU: 55555554 
> > [ 4606.297126] Call Trace: 
> > [ 4606.299582]  <IRQ> 
> > [ 4606.301608]  ? watchdog_timer_fn+0x40e/0x560 
> > [ 4606.305890]  ? do_raw_spin_unlock+0x55/0x1f0 
> > [ 4606.310172]  ? __pfx_watchdog_timer_fn+0x10/0x10 
> > [ 4606.314799]  ? __hrtimer_run_queues+0x16a/0xad0 
> > [ 4606.319351]  ? __pfx___hrtimer_run_queues+0x10/0x10 
> > [ 4606.324240]  ? ktime_get_update_offsets_now+0x95/0x2c0 
> > [ 4606.329385]  ? ktime_get_update_offsets_now+0xdd/0x2c0 
> > [ 4606.334542]  ? hrtimer_interrupt+0x2e9/0x7a0 
> > [ 4606.338839]  ? __sysvec_apic_timer_interrupt+0x139/0x4f0 
> > [ 4606.344165]  ? sysvec_apic_timer_interrupt+0x8e/0xc0 
> > [ 4606.349135]  </IRQ> 
> > [ 4606.351240]  <TASK> 
> > [ 4606.353351]  ? asm_sysvec_apic_timer_interrupt+0x16/0x20 
> > [ 4606.358684]  ? lock_is_held_type+0x105/0x140 
> > [ 4606.362966]  xas_descend+0x254/0x310 
> > [ 4606.366563]  xas_load+0x8b/0xf0 
> > [ 4606.369718]  filemap_get_read_batch+0x413/0x6b0 
> > [ 4606.374267]  ? __pfx_filemap_get_read_batch+0x10/0x10 
> > [ 4606.379330]  ? __might_fault+0x11b/0x170 
> > [ 4606.383267]  ? __might_fault+0x11b/0x170 
> > [ 4606.387210]  filemap_get_pages+0x19e/0x960 
> > [ 4606.391322]  ? __pfx__copy_to_iter+0x10/0x10 
> > [ 4606.395612]  ? __pfx_filemap_get_pages+0x10/0x10 
> > [ 4606.400238]  ? folio_mark_accessed+0x2fd/0x7c0 
> > [ 4606.404706]  filemap_read+0x2f9/0x9d0 
> > [ 4606.408391]  ? __pfx_filemap_read+0x10/0x10 
> > [ 4606.412588]  ? down_read_nested+0xc2/0x4d0 
> > [ 4606.416695]  ? __pfx_down_read_nested+0x10/0x10 
> > [ 4606.421247]  ? xfs_file_buffered_read+0x170/0x320 [xfs] 
> > [ 4606.426772]  xfs_file_buffered_read+0x17b/0x320 [xfs] 
> > [ 4606.432082]  xfs_file_read_iter+0x27a/0x570 [xfs] 
> > [ 4606.437050]  vfs_read+0x5be/0xbe0 
> > [ 4606.440386]  ? __pfx_vfs_read+0x10/0x10 
> > [ 4606.444228]  ? local_clock_noinstr+0x9/0xc0 
> > [ 4606.448428]  ? __fget_files+0x1b8/0x3f0 
> > [ 4606.452296]  __x64_sys_pread64+0x193/0x1e0 
> > [ 4606.456407]  ? __pfx___x64_sys_pread64+0x10/0x10 
> > [ 4606.461032]  ? ktime_get_coarse_real_ts64+0x130/0x170 
> > [ 4606.466104]  do_syscall_64+0x94/0x190 
> > [ 4606.469780]  ? rcu_is_watching+0x11/0xb0 
> > [ 4606.473718]  ? lockdep_hardirqs_on_prepare.part.0+0x18c/0x370 
> > [ 4606.479477]  ? do_syscall_64+0xa3/0x190 
> > [ 4606.483324]  ? lockdep_hardirqs_on+0x79/0x100 
> > [ 4606.487693]  ? do_syscall_64+0xa3/0x190 
> > [ 4606.491543]  ? do_syscall_64+0xa3/0x190 
> > [ 4606.495385]  ? do_syscall_64+0xa3/0x190 
> > [ 4606.499229]  ? do_syscall_64+0xa3/0x190 
> > [ 4606.503073]  ? do_syscall_64+0xa3/0x190 
> > [ 4606.506912]  ? lockdep_hardirqs_on_prepare.part.0+0x18c/0x370 
> > [ 4606.512665]  entry_SYSCALL_64_after_hwframe+0x6e/0x76 
> > [ 4606.517728] RIP: 0033:0x7f45ed33d02f 
> > [ 4606.521309] Code: 08 89 3c 24 48 89 4c 24 18 e8 3d 0d f6 ff 4c 8b 54 24 18 48 8b 54 24 10 41 89 c0 48 8b 74 24 08 8b 3c 24 b8 11 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 31 44 89 c7 48 89 04 24 e8 8d 0d f6 ff 48 8b 
> > [ 4606.540062] RSP: 002b:00007ffd64ed92f0 EFLAGS: 00000293 ORIG_RAX: 0000000000000011 
> > [ 4606.547639] RAX: ffffffffffffffda RBX: 00007ffd64ed93a0 RCX: 00007f45ed33d02f 
> > [ 4606.554772] RDX: 0000000000010000 RSI: 0000000001d45000 RDI: 0000000000000003 
> > [ 4606.561913] RBP: 0000000000000003 R08: 0000000000000000 R09: 0000000000000003 
> > [ 4606.569053] R10: 000000000d280000 R11: 0000000000000293 R12: 0000000000000d28 
> > [ 4606.576185] R13: 0000000012d80000 R14: 0000000000000000 R15: 000000000d280000 
> > [ 4606.583337]  </TASK> 
> > [ 4606.585531] watchdog: BUG: soft lockup - CPU#61 stuck for 26s! [xfs_io:1139164] 
> > [ 4606.592844] Modules linked in: dm_snapshot dm_bufio ext4 mbcache jbd2 loop dm_flakey dm_mod rfkill intel_rapl_msr intel_rapl_common ipmi_ssif intel_uncore_frequency intel_uncore_frequency_common i10nm_edac nfit x86_pkg_temp_thermal intel_powerclamp mlx5_ib coretemp acpi_ipmi ib_uverbs kvm_intel mgag200 iTCO_wdt ipmi_si dax_hmem i2c_algo_bit mei_me iTCO_vendor_support cxl_acpi drm_shmem_helper dell_smbios sunrpc dcdbas kvm irqbypass rapl intel_cstate ib_core cxl_core intel_uncore dell_wmi_descriptor wmi_bmof pcspkr ipmi_devintf i2c_i801 isst_if_mmio isst_if_mbox_pci drm_kms_helper mei isst_if_common ipmi_msghandler intel_pch_thermal intel_vsec i2c_smbus acpi_power_meter drm fuse xfs libcrc32c sd_mod t10_pi sg mlx5_core crct10dif_pclmul crc32_pclmul crc32c_intel ahci libahci mlxfw tls ghash_clmulni_intel megaraid_sas tg3 libata psample pci_hyperv_intf wmi [last unloaded: scsi_debug] 
> > [ 4606.670896] irq event stamp: 514288 
> > [ 4606.674389] hardirqs last  enabled at (514287): [<ffffffff84800dc6>] asm_sysvec_apic_timer_interrupt+0x16/0x20 
> > [ 4606.684391] hardirqs last disabled at (514288): [<ffffffff845f5acb>] sysvec_apic_timer_interrupt+0xb/0xc0 
> > [ 4606.693959] softirqs last  enabled at (514178): [<ffffffff84632b47>] __do_softirq+0x5d7/0x8f4 
> > [ 4606.702484] softirqs last disabled at (514173): [<ffffffff8205392c>] __irq_exit_rcu+0xbc/0x210 
> > [ 4606.711100] CPU: 61 PID: 1139164 Comm: xfs_io Kdump: loaded Tainted: G             L     6.8.0-rc3+ #1 
> > [ 4606.720408] Hardware name: Dell Inc. PowerEdge R750/0PJ80M, BIOS 1.5.4 12/17/2021 
> > [ 4606.727889] RIP: 0010:lock_is_held_type+0x105/0x140 
> > [ 4606.732775] Code: 00 00 b8 ff ff ff ff 65 0f c1 05 a6 9f bf 7b 83 f8 01 75 2d 9c 58 f6 c4 02 75 41 48 f7 04 24 00 02 00 00 74 01 fb 48 83 c4 08 <44> 89 e0 5b 5d 41 5c 41 5d 41 5e 41 5f c3 cc cc cc cc 45 31 e4 eb 
> > [ 4606.751524] RSP: 0018:ffa000002331f720 EFLAGS: 00000292 
> > [ 4606.756755] RAX: 0000000000000046 RBX: ff110010bb7ed468 RCX: 0000000000000001 
> > [ 4606.763890] RDX: 0000000000000002 RSI: ffffffff84ae63c0 RDI: ffffffff84da0200 
> > [ 4606.771022] RBP: ff110010a6f88000 R08: 0000000000000001 R09: fffa7c0008ec7a06 
> > [ 4606.778156] R10: ffd400004763d037 R11: 0000000000000000 R12: 0000000000000000 
> > [ 4606.785286] R13: 00000000ffffffff R14: ff110010a6f88f60 R15: 0000000000000003 
> > [ 4606.792420] FS:  00007fa2bb23ecc0(0000) GS:ff11002038800000(0000) knlGS:0000000000000000 
> > [ 4606.800506] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 
> > [ 4606.806251] CR2: 000000000042e2a8 CR3: 00000010cb1fc005 CR4: 0000000000771ef0 
> > [ 4606.813386] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000 
> > [ 4606.820519] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400 
> > [ 4606.827652] PKRU: 55555554 
> > [ 4606.830363] Call Trace: 
> > [ 4606.832815]  <IRQ> 
> > [ 4606.834836]  ? watchdog_timer_fn+0x40e/0x560 
> > [ 4606.839117]  ? do_raw_spin_unlock+0x55/0x1f0 
> > [ 4606.843401]  ? __pfx_watchdog_timer_fn+0x10/0x10 
> > [ 4606.848028]  ? __hrtimer_run_queues+0x16a/0xad0 
> > [ 4606.852580]  ? __pfx___hrtimer_run_queues+0x10/0x10 
> > [ 4606.857466]  ? ktime_get_update_offsets_now+0x95/0x2c0 
> > [ 4606.862613]  ? ktime_get_update_offsets_now+0xdd/0x2c0 
> > [ 4606.867760]  ? hrtimer_interrupt+0x2e9/0x7a0 
> > [ 4606.872050]  ? __sysvec_apic_timer_interrupt+0x139/0x4f0 
> > [ 4606.877373]  ? sysvec_apic_timer_interrupt+0x8e/0xc0 
> > [ 4606.882348]  </IRQ> 
> > [ 4606.884452]  <TASK> 
> > [ 4606.886561]  ? asm_sysvec_apic_timer_interrupt+0x16/0x20 
> > [ 4606.891893]  ? lock_is_held_type+0x105/0x140 
> > [ 4606.896179]  xas_start+0x19d/0x510 
> > [ 4606.899596]  xas_load+0x2e/0xf0 
> > [ 4606.902755]  xas_find+0x4b2/0x6c0 
> > [ 4606.906085]  find_get_entries+0x13d/0x870 
> > [ 4606.910114]  ? __pfx_find_get_entries+0x10/0x10 
> > [ 4606.914656]  ? __pfx___blk_flush_plug+0x10/0x10 
> > [ 4606.919209]  invalidate_inode_pages2_range+0x134/0xbf0 
> > [ 4606.924366]  ? __pfx_invalidate_inode_pages2_range+0x10/0x10 
> > [ 4606.930037]  ? __pfx___xfs_trans_commit+0x10/0x10 [xfs] 
> > [ 4606.935528]  ? __pfx___iomap_dio_rw+0x10/0x10 
> > [ 4606.939928]  kiocb_invalidate_post_direct_write+0xc3/0x140 
> > [ 4606.945424]  iomap_dio_complete+0x59a/0x900 
> > [ 4606.949627]  xfs_file_dio_write_aligned+0xff/0x140 [xfs] 
> > [ 4606.955201]  ? __pfx_xfs_file_dio_write_aligned+0x10/0x10 [xfs] 
> > [ 4606.961382]  xfs_file_write_iter+0x463/0x680 [xfs] 
> > [ 4606.966430]  vfs_write+0x9ad/0xff0 
> > [ 4606.969844]  ? __pfx_vfs_write+0x10/0x10 
> > [ 4606.973772]  ? local_clock_noinstr+0x9/0xc0 
> > [ 4606.977962]  ? __fget_files+0x1b8/0x3f0 
> > [ 4606.981823]  __x64_sys_pwrite64+0x193/0x1e0 
> > [ 4606.986012]  ? __pfx___x64_sys_pwrite64+0x10/0x10 
> > [ 4606.990723]  ? ktime_get_coarse_real_ts64+0x130/0x170 
> > [ 4606.995796]  do_syscall_64+0x94/0x190 
> > [ 4606.999473]  ? lockdep_hardirqs_on_prepare.part.0+0x18c/0x370 
> > [ 4607.005224]  ? do_syscall_64+0xa3/0x190 
> > [ 4607.009062]  ? lockdep_hardirqs_on+0x79/0x100 
> > [ 4607.013422]  ? do_syscall_64+0xa3/0x190 
> > [ 4607.017259]  ? do_syscall_64+0xa3/0x190 
> > [ 4607.021100]  ? do_syscall_64+0xa3/0x190 
> > [ 4607.024946]  entry_SYSCALL_64_after_hwframe+0x6e/0x76 
> > [ 4607.030001] RIP: 0033:0x7fa2bb13d0df 
> > [ 4607.033590] Code: 08 89 3c 24 48 89 4c 24 18 e8 8d 0c f6 ff 4c 8b 54 24 18 48 8b 54 24 10 41 89 c0 48 8b 74 24 08 8b 3c 24 b8 12 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 31 44 89 c7 48 89 04 24 e8 dd 0c f6 ff 48 8b 
> > [ 4607.052343] RSP: 002b:00007ffcd49aaec0 EFLAGS: 00000293 ORIG_RAX: 0000000000000012 
> > [ 4607.059917] RAX: ffffffffffffffda RBX: 000000000d280000 RCX: 00007fa2bb13d0df 
> > [ 4607.067050] RDX: 0000000000010000 RSI: 0000000001226000 RDI: 0000000000000003 
> > [ 4607.074182] RBP: 00000000ffffffff R08: 0000000000000000 R09: 0000000000000079 
> > [ 4607.081316] R10: 000000000d280000 R11: 0000000000000293 R12: 000000000d280000 
> > [ 4607.088449] R13: 0000000000000000 R14: 0000000000000d28 R15: 0000000012d80000 
> > [ 4607.095600]  </TASK> 
> > [ 4615.015456] restraintd[2712]: *** Current Time: Wed Feb 07 05:44:59 2024  Localwatchdog at: Fri Feb 09 04:33:58 2024 
> > [-- MARK -- Wed Feb  7 10:45:00 2024] 
> > [ 4634.053531] watchdog: BUG: soft lockup - CPU#23 stuck for 52s! [xfs_io:1139165]
> > ...
> > ...
> > [31678.432905] watchdog: BUG: soft lockup - CPU#61 stuck for 25239s! [xfs_io:1139164] 
> > [31678.440472] Modules linked in: dm_snapshot dm_bufio ext4 mbcache jbd2 loop dm_flakey dm_mod rfkill intel_rapl_msr intel_rapl_common ipmi_ssif intel_uncore_frequency intel_uncore_frequency_common i10nm_edac nfit x86_pkg_temp_thermal intel_powerclamp mlx5_ib coretemp acpi_ipmi ib_uverbs kvm_intel mgag200 iTCO_wdt ipmi_si dax_hmem i2c_algo_bit mei_me iTCO_vendor_support cxl_acpi drm_shmem_helper dell_smbios sunrpc dcdbas kvm irqbypass rapl intel_cstate ib_core cxl_core intel_uncore dell_wmi_descriptor wmi_bmof pcspkr ipmi_devintf i2c_i801 isst_if_mmio isst_if_mbox_pci drm_kms_helper mei isst_if_common ipmi_msghandler intel_pch_thermal intel_vsec i2c_smbus acpi_power_meter drm fuse xfs libcrc32c sd_mod t10_pi sg mlx5_core crct10dif_pclmul crc32_pclmul crc32c_intel ahci libahci mlxfw tls ghash_clmulni_intel megaraid_sas tg3 libata psample pci_hyperv_intf wmi [last unloaded: scsi_debug] 
> > [31678.518516] irq event stamp: 55287820 
> > [31678.522180] hardirqs last  enabled at (55287819): [<ffffffff84800dc6>] asm_sysvec_apic_timer_interrupt+0x16/0x20 
> > [31678.532348] hardirqs last disabled at (55287820): [<ffffffff845f5acb>] sysvec_apic_timer_interrupt+0xb/0xc0 
> > [31678.542089] softirqs last  enabled at (55287812): [<ffffffff84632b47>] __do_softirq+0x5d7/0x8f4 
> > [31678.550790] softirqs last disabled at (55287807): [<ffffffff8205392c>] __irq_exit_rcu+0xbc/0x210 
> > [31678.559580] CPU: 61 PID: 1139164 Comm: xfs_io Kdump: loaded Tainted: G             L     6.8.0-rc3+ #1 
> > [31678.568886] Hardware name: Dell Inc. PowerEdge R750/0PJ80M, BIOS 1.5.4 12/17/2021 
> > [31678.576366] RIP: 0010:rcu_read_lock_held+0x21/0x50 
> > [31678.581167] Code: 90 90 90 90 90 90 90 90 90 0f 1f 44 00 00 e8 56 bd 39 02 41 b8 01 00 00 00 85 c0 75 08 44 89 c0 c3 cc cc cc cc e8 0f e0 00 00 <84> c0 74 1a e8 26 f8 00 00 84 c0 74 11 be ff ff ff ff 48 c7 c7 60 
> > [31678.599914] RSP: 0018:ffa000002331f750 EFLAGS: 00000292 
> > [31678.605147] RAX: 0000000000000001 RBX: ffa000002331f880 RCX: 1ffffffff0ac4ba9 
> > [31678.612280] RDX: 0000000000000000 RSI: ffffffff84da0180 RDI: ffffffff85625d48 
> > [31678.619413] RBP: ff110010bb7ed450 R08: 0000000000000001 R09: fffa7c0008ec7a06 
> > [31678.626547] R10: ffd400004763d037 R11: 0000000000000000 R12: ff1100108f07b702 
> > [31678.633679] R13: ffa000002331f898 R14: dffffc0000000000 R15: ffa000002331f880 
> > [31678.640812] FS:  00007fa2bb23ecc0(0000) GS:ff11002038800000(0000) knlGS:0000000000000000 
> > [31678.648904] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 
> > [31678.654653] CR2: 000000000042e2a8 CR3: 00000010cb1fc005 CR4: 0000000000771ef0 
> > [31678.661786] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000 
> > [31678.668917] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400 
> > [31678.676050] PKRU: 55555554 
> > [31678.678763] Call Trace: 
> > [31678.681214]  <IRQ> 
> > [31678.683237]  ? watchdog_timer_fn+0x40e/0x560 
> > [31678.687517]  ? do_raw_spin_unlock+0x55/0x1f0 
> > [31678.691800]  ? __pfx_watchdog_timer_fn+0x10/0x10 
> > [31678.696427]  ? __hrtimer_run_queues+0x16a/0xad0 
> > [31678.700980]  ? __pfx___hrtimer_run_queues+0x10/0x10 
> > [31678.705865]  ? ktime_get_update_offsets_now+0x95/0x2c0 
> > [31678.711011]  ? ktime_get_update_offsets_now+0xdd/0x2c0 
> > [31678.716161]  ? hrtimer_interrupt+0x2e9/0x7a0 
> > [31678.720457]  ? __sysvec_apic_timer_interrupt+0x139/0x4f0 
> > [31678.725773]  ? sysvec_apic_timer_interrupt+0x8e/0xc0 
> > [31678.730746]  </IRQ> 
> > [31678.732850]  <TASK> 
> > [31678.734959]  ? asm_sysvec_apic_timer_interrupt+0x16/0x20 
> > [31678.740292]  ? rcu_read_lock_held+0x21/0x50 
> > [31678.744486]  xas_start+0x1aa/0x510 
> > [31678.747902]  xas_load+0x2e/0xf0 
> > [31678.751058]  xas_find+0x4b2/0x6c0 
> > [31678.754388]  find_get_entries+0x13d/0x870 
> > [31678.758416]  ? __pfx_find_get_entries+0x10/0x10 
> > [31678.762958]  ? __pfx___blk_flush_plug+0x10/0x10 
> > [31678.767502]  invalidate_inode_pages2_range+0x134/0xbf0 
> > [31678.772660]  ? __pfx_invalidate_inode_pages2_range+0x10/0x10 
> > [31678.778332]  ? __pfx___xfs_trans_commit+0x10/0x10 [xfs] 
> > [31678.783806]  ? __pfx___iomap_dio_rw+0x10/0x10 
> > [31678.788207]  kiocb_invalidate_post_direct_write+0xc3/0x140 
> > [31678.793705]  iomap_dio_complete+0x59a/0x900 
> > [31678.797903]  xfs_file_dio_write_aligned+0xff/0x140 [xfs] 
> > [31678.803463]  ? __pfx_xfs_file_dio_write_aligned+0x10/0x10 [xfs] 
> > [31678.809631]  xfs_file_write_iter+0x463/0x680 [xfs] 
> > [31678.814662]  vfs_write+0x9ad/0xff0 
> > [31678.818079]  ? __pfx_vfs_write+0x10/0x10 
> > [31678.822006]  ? local_clock_noinstr+0x9/0xc0 
> > [31678.826199]  ? __fget_files+0x1b8/0x3f0 
> > [31678.827396] rcu: INFO: rcu_preempt self-detected stall on CPU 
> > [31678.830058]  __x64_sys_pwrite64+0x193/0x1e0 
> > [31678.835787] rcu: 	23-....: (26465147 ticks this GP) idle=72a4/1/0x4000000000000000 softirq=105080/105093 fqs=12773358 
> > [31678.839974]  ? __pfx___x64_sys_pwrite64+0x10/0x10 
> > [31678.850583] rcu: 	(t=27100074 jiffies g=2428137 q=527160 ncpus=112) 
> > [31678.855275]  ? ktime_get_coarse_real_ts64+0x130/0x170 
> > [31678.861545] CPU: 23 PID: 1139165 Comm: xfs_io Kdump: loaded Tainted: G             L     6.8.0-rc3+ #1 
> > [31678.866606]  do_syscall_64+0x94/0x190 
> > [31678.875894] Hardware name: Dell Inc. PowerEdge R750/0PJ80M, BIOS 1.5.4 12/17/2021 
> > [31678.879566]  ? lockdep_hardirqs_on_prepare.part.0+0x18c/0x370 
> > [31678.887040] RIP: 0010:lock_is_held_type+0x105/0x140 
> > [31678.892786]  ? do_syscall_64+0xa3/0x190 
> > [31678.897666] Code: 00 00 b8 ff ff ff ff 65 0f c1 05 a6 9f bf 7b 83 f8 01 75 2d 9c 58 f6 c4 02 75 41 48 f7 04 24 00 02 00 00 74 01 fb 48 83 c4 08 <44> 89 e0 5b 5d 41 5c 41 5d 41 5e 41 5f c3 cc cc cc cc 45 31 e4 eb 
> > [31678.901507]  ? lockdep_hardirqs_on+0x79/0x100 
> > [31678.920252] RSP: 0018:ffa000002332f710 EFLAGS: 00000292 
> > [31678.924613]  ? do_syscall_64+0xa3/0x190 
> > [31678.924617]  ? do_syscall_64+0xa3/0x190 
> > [31678.929846] RAX: 0000000000000046 RBX: ff110010bb7ed468 RCX: 0000000000000001 
> > [31678.933683]  ? do_syscall_64+0xa3/0x190 
> > [31678.937523] RDX: 0000000000000001 RSI: ffffffff84ae63c0 RDI: ffffffff84da0200 
> > [31678.944662]  entry_SYSCALL_64_after_hwframe+0x6e/0x76 
> > [31678.948495] RBP: ff1100154932be40 R08: 0000000000000001 R09: fffa7c0008ec7a06 
> > [31678.955627] RIP: 0033:0x7fa2bb13d0df 
> > [31678.960680] R10: ffd400004763d037 R11: 0000000000000000 R12: 0000000000000000 
> > [31678.967813] Code: 08 89 3c 24 48 89 4c 24 18 e8 8d 0c f6 ff 4c 8b 54 24 18 48 8b 54 24 10 41 89 c0 48 8b 74 24 08 8b 3c 24 b8 12 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 31 44 89 c7 48 89 04 24 e8 dd 0c f6 ff 48 8b 
> > [31678.971392] R13: 00000000ffffffff R14: ff1100154932cd68 R15: 0000000000000002 
> > [31678.978526] RSP: 002b:00007ffcd49aaec0 EFLAGS: 00000293 
> > [31678.997272] FS:  00007f45ed47ccc0(0000) GS:ff11002033c00000(0000) knlGS:0000000000000000 
> > [31679.004404]  ORIG_RAX: 0000000000000012 
> > [31679.004407] RAX: ffffffffffffffda RBX: 000000000d280000 RCX: 00007fa2bb13d0df 
> > [31679.009631] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 
> > [31679.017717] RDX: 0000000000010000 RSI: 0000000001226000 RDI: 0000000000000003 
> > [31679.021558] CR2: 00007fdc20089000 CR3: 00000011446ea004 CR4: 0000000000771ef0 
> > [31679.028690] RBP: 00000000ffffffff R08: 0000000000000000 R09: 0000000000000079 
> > [31679.034435] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000 
> > [31679.041569] R10: 000000000d280000 R11: 0000000000000293 R12: 000000000d280000 
> > [31679.048700] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400 
> > [31679.055834] R13: 0000000000000000 R14: 0000000000000d28 R15: 0000000012d80000 
> > [31679.062966] PKRU: 55555554 
> > [31679.070118]  </TASK> 
> > [31679.077230] Call Trace: 
> > [31679.084364] watchdog: BUG: soft lockup - CPU#92 stuck for 23175s! [migration/92:569] 
> > [31679.087079]  <IRQ> 
> > [31679.089270] Modules linked in: 
> > [31679.091726]  ? rcu_dump_cpu_stacks+0x278/0x420 
> > [31679.099461]  dm_snapshot 
> > [31679.101496]  ? print_cpu_stall+0x378/0x6d0 
> > [31679.104541]  dm_bufio 
> > [31679.109000]  ? check_cpu_stall+0x260/0x500 
> > [31679.111524]  ext4 
> > [31679.115636]  ? rcu_pending+0xbc/0x530 
> > [31679.117904]  mbcache 
> > [31679.122010]  ? rcu_sched_clock_irq+0x2de/0x800 
> > [31679.123935]  jbd2 
> > [31679.127610]  ? update_process_times+0xe3/0x140 
> > [31679.129794]  loop 
> > [31679.134246]  ? tick_sched_handle+0x67/0x130 
> > [31679.136174]  dm_flakey 
> > [31679.140623]  ? tick_nohz_highres_handler+0xaf/0xd0 
> > [31679.142552]  dm_mod 
> > [31679.146740]  ? __pfx_tick_nohz_highres_handler+0x10/0x10 
> > [31679.149105]  rfkill 
> > [31679.153900]  ? __hrtimer_run_queues+0x16a/0xad0 
> > [31679.156003]  intel_rapl_msr 
> > [31679.161335]  ? __pfx___hrtimer_run_queues+0x10/0x10 
> > [31679.163422]  intel_rapl_common 
> > [31679.167958]  ? ktime_get_update_offsets_now+0x95/0x2c0 
> > [31679.170753]  ipmi_ssif 
> > [31679.175635]  ? ktime_get_update_offsets_now+0xdd/0x2c0 
> > [31679.178691]  intel_uncore_frequency 
> > [31679.183846]  ? hrtimer_interrupt+0x2e9/0x7a0 
> > [31679.186197]  intel_uncore_frequency_common 
> > [31679.191363]  ? __sysvec_apic_timer_interrupt+0x139/0x4f0 
> > [31679.194831]  i10nm_edac 
> > [31679.199108]  ? sysvec_apic_timer_interrupt+0x8e/0xc0 
> > [31679.203202]  nfit x86_pkg_temp_thermal 
> > [31679.208516]  </IRQ> 
> > [31679.210967]  intel_powerclamp 
> > [31679.215933]  <TASK> 
> > [31679.219687]  mlx5_ib 
> > [31679.221797]  ? asm_sysvec_apic_timer_interrupt+0x16/0x20 
> > [31679.224766]  coretemp 
> > [31679.226893]  ? lock_is_held_type+0x105/0x140 
> > [31679.229063]  acpi_ipmi 
> > [31679.234389]  xas_descend+0x247/0x310 
> > [31679.236654]  ib_uverbs kvm_intel 
> > [31679.240941]  xas_load+0x8b/0xf0 
> > [31679.243295]  mgag200 iTCO_wdt 
> > [31679.246876]  ? kasan_check_range+0xe/0x1b0 
> > [31679.250106]  ipmi_si 
> > [31679.253261]  filemap_get_read_batch+0x413/0x6b0 
> > [31679.256226]  dax_hmem 
> > [31679.260332]  ? __pfx_filemap_get_read_batch+0x10/0x10 
> > [31679.262517]  i2c_algo_bit 
> > [31679.267060]  ? __might_fault+0x11b/0x170 
> > [31679.269330]  mei_me 
> > [31679.274384]  ? __might_fault+0x11b/0x170 
> > [31679.277009]  iTCO_vendor_support 
> > [31679.280949]  filemap_get_pages+0x19e/0x960 
> > [31679.283040]  cxl_acpi 
> > [31679.286975]  ? __pfx__copy_to_iter+0x10/0x10 
> > [31679.290199]  drm_shmem_helper 
> > [31679.294310]  ? __pfx_filemap_get_pages+0x10/0x10 
> > [31679.296576]  dell_smbios 
> > [31679.300854]  ? folio_mark_accessed+0x2fd/0x7c0 
> > [31679.303821]  sunrpc dcdbas 
> > [31679.308468]  filemap_read+0x2f9/0x9d0 
> > [31679.310981]  kvm 
> > [31679.315459]  ? __pfx_filemap_read+0x10/0x10 
> > [31679.318140]  irqbypass 
> > [31679.321811]  ? down_read_nested+0xc2/0x4d0 
> > [31679.323651]  rapl 
> > [31679.327844]  ? __pfx_down_read_nested+0x10/0x10 
> > [31679.330203]  intel_cstate 
> > [31679.334322]  ? xfs_file_buffered_read+0x170/0x320 [xfs] 
> > [31679.336236]  ib_core 
> > [31679.340780]  xfs_file_buffered_read+0x17b/0x320 [xfs] 
> > [31679.343397]  cxl_core 
> > [31679.348631]  xfs_file_read_iter+0x27a/0x570 [xfs] 
> > [31679.350815]  intel_uncore dell_wmi_descriptor 
> > [31679.355887]  vfs_read+0x5be/0xbe0 
> > [31679.358154]  wmi_bmof 
> > [31679.362872]  ? __pfx_vfs_read+0x10/0x10 
> > [31679.367219]  pcspkr 
> > [31679.370540]  ? local_clock_noinstr+0x9/0xc0 
> > [31679.372818]  ipmi_devintf i2c_i801 
> > [31679.376669]  ? __fget_files+0x1b8/0x3f0 
> > [31679.378763]  isst_if_mmio 
> > [31679.382980]  __x64_sys_pread64+0x193/0x1e0 
> > [31679.386355]  isst_if_mbox_pci 
> > [31679.390199]  ? __pfx___x64_sys_pread64+0x10/0x10 
> > [31679.392821]  drm_kms_helper 
> > [31679.396920]  ? ktime_get_coarse_real_ts64+0x130/0x170 
> > [31679.399894]  mei isst_if_common 
> > [31679.404540]  do_syscall_64+0x94/0x190 
> > [31679.407319]  ipmi_msghandler 
> > [31679.412377]  ? rcu_is_watching+0x11/0xb0 
> > [31679.415520]  intel_pch_thermal 
> > [31679.419197]  ? lockdep_hardirqs_on_prepare.part.0+0x18c/0x370 
> > [31679.422071]  intel_vsec 
> > [31679.425999]  ? do_syscall_64+0xa3/0x190 
> > [31679.429056]  i2c_smbus acpi_power_meter 
> > [31679.434804]  ? lockdep_hardirqs_on+0x79/0x100 
> > [31679.437254]  drm 
> > [31679.441097]  ? do_syscall_64+0xa3/0x190 
> > [31679.444934]  fuse xfs 
> > [31679.449298]  ? do_syscall_64+0xa3/0x190 
> > [31679.451139]  libcrc32c sd_mod 
> > [31679.454978]  ? do_syscall_64+0xa3/0x190 
> > [31679.457259]  t10_pi 
> > [31679.461102]  ? do_syscall_64+0xa3/0x190 
> > [31679.464071]  sg 
> > [31679.467911]  ? do_syscall_64+0xa3/0x190 
> > [31679.470014]  mlx5_core 
> > [31679.473855]  ? lockdep_hardirqs_on_prepare.part.0+0x18c/0x370 
> > [31679.475614]  crct10dif_pclmul 
> > [31679.479461]  entry_SYSCALL_64_after_hwframe+0x6e/0x76 
> > [31679.481819]  crc32_pclmul crc32c_intel 
> > [31679.487565] RIP: 0033:0x7f45ed33d02f 
> > [31679.490540]  ahci 
> > [31679.495591] Code: 08 89 3c 24 48 89 4c 24 18 e8 3d 0d f6 ff 4c 8b 54 24 18 48 8b 54 24 10 41 89 c0 48 8b 74 24 08 8b 3c 24 b8 11 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 31 44 89 c7 48 89 04 24 e8 8d 0d f6 ff 48 8b 
> > [31679.499342]  libahci 
> > [31679.502923] RSP: 002b:00007ffd64ed92f0 EFLAGS: 00000293 
> > [31679.504856]  mlxfw 
> > [31679.523602]  ORIG_RAX: 0000000000000011 
> > [31679.525793]  tls ghash_clmulni_intel 
> > [31679.531022] RAX: ffffffffffffffda RBX: 00007ffd64ed93a0 RCX: 00007f45ed33d02f 
> > [31679.533039]  megaraid_sas 
> > [31679.536880] RDX: 0000000000010000 RSI: 0000000001d45000 RDI: 0000000000000003 
> > [31679.540459]  tg3 
> > [31679.547590] RBP: 0000000000000003 R08: 0000000000000000 R09: 0000000000000003 
> > [31679.550217]  libata 
> > [31679.557351] R10: 000000000d280000 R11: 0000000000000293 R12: 0000000000000d28 
> > [31679.559197]  psample 
> > [31679.566328] R13: 0000000012d80000 R14: 0000000000000000 R15: 000000000d280000 
> > [31679.568435]  pci_hyperv_intf 
> > [31679.575596]  </TASK> 
> > [31679.577759]  wmi 
> > [31679.584895] Sending NMI from CPU 23 to CPUs 61: 
> > [31679.587779]  [last unloaded: scsi_debug] 
> > [31679.600278] irq event stamp: 50377244 
> > [31679.603942] hardirqs last  enabled at (50377243): [<ffffffff84800dc6>] asm_sysvec_apic_timer_interrupt+0x16/0x20 
> > [31679.614110] hardirqs last disabled at (50377244): [<ffffffff845f5acb>] sysvec_apic_timer_interrupt+0xb/0xc0 
> > [31679.623851] softirqs last  enabled at (50377120): [<ffffffff84632b47>] __do_softirq+0x5d7/0x8f4 
> > [31679.632551] softirqs last disabled at (50377115): [<ffffffff8205392c>] __irq_exit_rcu+0xbc/0x210 
> > [31679.641340] CPU: 92 PID: 569 Comm: migration/92 Kdump: loaded Tainted: G             L     6.8.0-rc3+ #1 
> > [31679.650812] Hardware name: Dell Inc. PowerEdge R750/0PJ80M, BIOS 1.5.4 12/17/2021 
> > [31679.658293] Stopper: multi_cpu_stop+0x0/0x370 <- migrate_swap+0x2e5/0x4f0 
> > [31679.665087] RIP: 0010:rcu_momentary_dyntick_idle+0x38/0x80 
> > [31679.670574] Code: 05 70 7d f7 7d 00 e8 27 8a 36 02 48 ba 00 00 00 00 00 fc ff df 89 c0 48 8d 3c c5 60 5b 62 85 48 89 f9 48 c1 e9 03 80 3c 11 00 <75> 2c 48 03 1c c5 60 5b 62 85 b8 08 00 00 00 f0 0f c1 03 a8 04 74 
> > [31679.689317] RSP: 0000:ffa0000009287dc8 EFLAGS: 00000246 
> > [31679.694544] RAX: 000000000000005c RBX: 0000000000200628 RCX: 1ffffffff0ac4bc8 
> > [31679.701678] RDX: dffffc0000000000 RSI: ffffffff84da0180 RDI: ffffffff85625e40 
> > [31679.708809] RBP: ffa000000f71f720 R08: 0000000000000001 R09: fff3fc0001ee3ee8 
> > [31679.715941] R10: ffa000000f71f747 R11: 0000000000000000 R12: fff3fc0001ee3ee8 
> > [31679.723075] R13: ffffffff84aad940 R14: 0000000000000001 R15: 0000000000000001 
> > [31679.730207] FS:  0000000000000000(0000) GS:ff11000c3d800000(0000) knlGS:0000000000000000 
> > [31679.738294] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 
> > [31679.744040] CR2: 000055cc71e048a8 CR3: 000000011113a001 CR4: 0000000000771ef0 
> > [31679.751172] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000 
> > [31679.758304] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400 
> > [31679.765437] PKRU: 55555554 
> > [31679.768152] Call Trace: 
> > [31679.770602]  <IRQ> 
> > [31679.772625]  ? watchdog_timer_fn+0x40e/0x560 
> > [31679.776903]  ? do_raw_spin_unlock+0x55/0x1f0 
> > [31679.781178]  ? __pfx_watchdog_timer_fn+0x10/0x10 
> > [31679.785799]  ? __hrtimer_run_queues+0x16a/0xad0 
> > [31679.790350]  ? __pfx___hrtimer_run_queues+0x10/0x10 
> > [31679.795237]  ? ktime_get_update_offsets_now+0x95/0x2c0 
> > [31679.800382]  ? ktime_get_update_offsets_now+0xdd/0x2c0 
> > [31679.805540]  ? hrtimer_interrupt+0x2e9/0x7a0 
> > [31679.809834]  ? __sysvec_apic_timer_interrupt+0x139/0x4f0 
> > [31679.815155]  ? sysvec_apic_timer_interrupt+0x8e/0xc0 
> > [31679.820126]  </IRQ> 
> > [31679.822230]  <TASK> 
> > [31679.824339]  ? asm_sysvec_apic_timer_interrupt+0x16/0x20 
> > [31679.829673]  ? rcu_momentary_dyntick_idle+0x38/0x80 
> > [31679.834559]  ? rcu_momentary_dyntick_idle+0x19/0x80 
> > [31679.839446]  multi_cpu_stop+0x1b0/0x370 
> > [31679.843300]  cpu_stopper_thread+0x1e9/0x400 
> > [31679.847486]  ? __pfx_multi_cpu_stop+0x10/0x10 
> > [31679.851851]  ? __pfx_cpu_stopper_thread+0x10/0x10 
> > [31679.856566]  smpboot_thread_fn+0x543/0x920 
> > [31679.860670]  ? __pfx_smpboot_thread_fn+0x10/0x10 
> > [31679.865299]  kthread+0x2f8/0x3e0 
> > [31679.868538]  ? _raw_spin_unlock_irq+0x24/0x50 
> > [31679.872897]  ? __pfx_kthread+0x10/0x10 
> > [31679.876652]  ret_from_fork+0x2d/0x70 
> > [31679.880239]  ? __pfx_kthread+0x10/0x10 
> > [31679.883991]  ret_from_fork_asm+0x1b/0x30 
> > [31679.887932]  </TASK> 
> > [31679.890126] NMI backtrace for cpu 61 
> > [31679.890129] CPU: 61 PID: 1139164 Comm: xfs_io Kdump: loaded Tainted: G             L     6.8.0-rc3+ #1 
> > [31679.890132] Hardware name: Dell Inc. PowerEdge R750/0PJ80M, BIOS 1.5.4 12/17/2021 
> > [31679.890133] RIP: 0010:check_preemption_disabled+0x30/0xf0 
> > [31679.890137] Code: ec 08 65 44 8b 25 fc d8 c0 7b 65 8b 05 f1 d8 c0 7b a9 ff ff ff 7f 74 10 48 83 c4 08 44 89 e0 5b 5d 41 5c c3 cc cc cc cc 9c 58 <f6> c4 02 74 e9 48 89 fd 65 48 8b 04 25 c0 58 20 00 f6 40 2f 04 0f 
> > [31679.890140] RSP: 0018:ffa000002331f6f0 EFLAGS: 00000046 
> > [31679.890142] RAX: 0000000000000046 RBX: ff110010bb7ed468 RCX: 0000000000000001 
> > [31679.890144] RDX: 0000000000000002 RSI: ffffffff84ae63c0 RDI: ffffffff84da0200 
> > [31679.890146] RBP: ff110010a6f88000 R08: 0000000000000001 R09: fffa7c0008ec7a06 
> > [31679.890148] R10: ffd400004763d037 R11: 0000000000000000 R12: 000000000000003d 
> > [31679.890149] R13: 00000000ffffffff R14: ff110010a6f88f60 R15: 0000000000000003 
> > [31679.890151] FS:  00007fa2bb23ecc0(0000) GS:ff11002038800000(0000) knlGS:0000000000000000 
> > [31679.890153] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 
> > [31679.890155] CR2: 000000000042e2a8 CR3: 00000010cb1fc005 CR4: 0000000000771ef0 
> > [31679.890156] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000 
> > [31679.890157] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400 
> > [31679.890159] PKRU: 55555554 
> > [31679.890160] Call Trace: 
> > [31679.890161]  <NMI> 
> > [31679.890162]  ? nmi_cpu_backtrace+0x144/0x290 
> > [31679.890168]  ? nmi_cpu_backtrace_handler+0xd/0x20 
> > [31679.890173]  ? nmi_handle+0x15c/0x470 
> > [31679.890178]  ? check_preemption_disabled+0x30/0xf0 
> > [31679.890182]  ? default_do_nmi+0x6b/0x180 
> > [31679.890186]  ? exc_nmi+0x121/0x1a0 
> > [31679.890190]  ? end_repeat_nmi+0xf/0x60 
> > [31679.890196]  ? check_preemption_disabled+0x30/0xf0 
> > [31679.890199]  ? check_preemption_disabled+0x30/0xf0 
> > [31679.890203]  ? check_preemption_disabled+0x30/0xf0 
> > [31679.890207]  </NMI> 
> > [31679.890208]  <TASK> 
> > [31679.890210]  lock_is_held_type+0xdd/0x140 
> > [31679.890214]  xas_start+0x19d/0x510 
> > [31679.890217]  xas_load+0x2e/0xf0 
> > [31679.890221]  xas_find+0x4b2/0x6c0 
> > [31679.890226]  find_get_entries+0x13d/0x870 
> > [31679.890232]  ? __pfx_find_get_entries+0x10/0x10 
> > [31679.890237]  ? __pfx___blk_flush_plug+0x10/0x10 
> > [31679.890243]  invalidate_inode_pages2_range+0x134/0xbf0 
> > [31679.890248]  ? __pfx_invalidate_inode_pages2_range+0x10/0x10 
> > [31679.890253]  ? __pfx___xfs_trans_commit+0x10/0x10 [xfs] 
> > [31679.890511]  ? __pfx___iomap_dio_rw+0x10/0x10 
> > [31679.890523]  kiocb_invalidate_post_direct_write+0xc3/0x140 
> > [31679.890528]  iomap_dio_complete+0x59a/0x900 
> > [31679.890532]  xfs_file_dio_write_aligned+0xff/0x140 [xfs] 
> > [31679.890792]  ? __pfx_xfs_file_dio_write_aligned+0x10/0x10 [xfs] 
> > [31679.891047]  xfs_file_write_iter+0x463/0x680 [xfs] 
> > [31679.891301]  vfs_write+0x9ad/0xff0 
> > [31679.891305]  ? __pfx_vfs_write+0x10/0x10 
> > [31679.891307]  ? local_clock_noinstr+0x9/0xc0 
> > [31679.891311]  ? __fget_files+0x1b8/0x3f0 
> > [31679.891319]  __x64_sys_pwrite64+0x193/0x1e0 
> > [31679.891322]  ? __pfx___x64_sys_pwrite64+0x10/0x10 
> > [31679.891325]  ? ktime_get_coarse_real_ts64+0x130/0x170 
> > [31679.891332]  do_syscall_64+0x94/0x190 
> > [31679.891335]  ? lockdep_hardirqs_on_prepare.part.0+0x18c/0x370 
> > [31679.891338]  ? do_syscall_64+0xa3/0x190 
> > [31679.891341]  ? lockdep_hardirqs_on+0x79/0x100 
> > [31679.891343]  ? do_syscall_64+0xa3/0x190 
> > [31679.891346]  ? do_syscall_64+0xa3/0x190 
> > [31679.891348]  ? do_syscall_64+0xa3/0x190 
> > [31679.891351]  entry_SYSCALL_64_after_hwframe+0x6e/0x76 
> > [31679.891355] RIP: 0033:0x7fa2bb13d0df 
> > [31679.891357] Code: 08 89 3c 24 48 89 4c 24 18 e8 8d 0c f6 ff 4c 8b 54 24 18 48 8b 54 24 10 41 89 c0 48 8b 74 24 08 8b 3c 24 b8 12 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 31 44 89 c7 48 89 04 24 e8 dd 0c f6 ff 48 8b 
> > [31679.891360] RSP: 002b:00007ffcd49aaec0 EFLAGS: 00000293 ORIG_RAX: 0000000000000012 
> > [31679.891362] RAX: ffffffffffffffda RBX: 000000000d280000 RCX: 00007fa2bb13d0df 
> > [31679.891363] RDX: 0000000000010000 RSI: 0000000001226000 RDI: 0000000000000003 
> > [31679.891365] RBP: 00000000ffffffff R08: 0000000000000000 R09: 0000000000000079 
> > [31679.891366] R10: 000000000d280000 R11: 0000000000000293 R12: 000000000d280000 
> > [31679.891367] R13: 0000000000000000 R14: 0000000000000d28 R15: 0000000012d80000 
> > [31679.891373]  </TASK> 
> > [31679.908469] ================================================================== 
> > [31680.277796] BUG: KASAN: slab-out-of-bounds in xfs_read_iomap_begin+0x5f2/0x750 [xfs] 
> > [31680.285803] Read of size 8 at addr ff11001261ad43f0 by task xfs_io/1139165 
> > [31680.292675]  
> > [31680.294175] CPU: 3 PID: 1139165 Comm: xfs_io Kdump: loaded Tainted: G             L     6.8.0-rc3+ #1 
> > [31680.303390] Hardware name: Dell Inc. PowerEdge R750/0PJ80M, BIOS 1.5.4 12/17/2021 
> > [31680.310868] Call Trace: 
> > [31680.313321]  <TASK> 
> > [31680.315427]  dump_stack_lvl+0x60/0xb0 
> > [31680.319101]  print_address_description.constprop.0+0x2c/0x3e0 
> > [31680.324857]  ? xfs_read_iomap_begin+0x5f2/0x750 [xfs] 
> > [31680.330171]  print_report+0xb5/0x270 
> > [31680.333751]  ? xfs_read_iomap_begin+0x5f2/0x750 [xfs] 
> > [31680.339053]  ? kasan_addr_to_slab+0x9/0xa0 
> > [31680.343152]  kasan_report+0x8a/0xc0 
> > [31680.346644]  ? xfs_read_iomap_begin+0x5f2/0x750 [xfs] 
> > [31680.351951]  xfs_read_iomap_begin+0x5f2/0x750 [xfs] 
> > [31680.357079]  ? __debug_check_no_obj_freed+0x253/0x520 
> > [31680.362133]  ? __pfx_xfs_read_iomap_begin+0x10/0x10 [xfs] 
> > [31680.367783]  ? validate_chain+0x148/0xe00 
> > [31680.371797]  ? kasan_quarantine_put+0x109/0x220 
> > [31680.376335]  ? lockdep_hardirqs_on+0x79/0x100 
> > [31680.380698]  ? finish_task_switch.isra.0+0x69f/0xb40 
> > [31680.385669]  ? __pfx_xfs_read_iomap_begin+0x10/0x10 [xfs] 
> > [31680.391322]  ? iomap_read_folio+0x230/0x490 
> > [31680.395506]  iomap_iter+0x332/0x760 
> > [31680.399001]  iomap_read_folio+0x230/0x490 
> > [31680.403015]  ? __pfx_iomap_read_folio+0x10/0x10 
> > [31680.407547]  ? __schedule+0x7f9/0x1df0 
> > [31680.411306]  ? filemap_update_page+0x31a/0xba0 
> > [31680.415753]  ? filemap_update_page+0x31a/0xba0 
> > [31680.420200]  ? __pfx_xfs_vm_read_folio+0x10/0x10 [xfs] 
> > [31680.425600]  filemap_read_folio+0xb1/0x220 
> > [31680.429696]  ? __pfx_filemap_read_folio+0x10/0x10 
> > [31680.434404]  ? __pfx_filemap_get_read_batch+0x10/0x10 
> > [31680.439458]  filemap_update_page+0x447/0xba0 
> > [31680.443732]  filemap_get_pages+0x5de/0x960 
> > [31680.447838]  ? __pfx__copy_to_iter+0x10/0x10 
> > [31680.452111]  ? __pfx_filemap_get_pages+0x10/0x10 
> > [31680.456730]  ? folio_mark_accessed+0x2fd/0x7c0 
> > [31680.461178]  filemap_read+0x2f9/0x9d0 
> > [31680.464855]  ? __pfx_filemap_read+0x10/0x10 
> > [31680.469045]  ? down_read_nested+0xc2/0x4d0 
> > [31680.473144]  ? __pfx_down_read_nested+0x10/0x10 
> > [31680.477681]  ? xfs_file_buffered_read+0x170/0x320 [xfs] 
> > [31680.483166]  xfs_file_buffered_read+0x17b/0x320 [xfs] 
> > [31680.488468]  xfs_file_read_iter+0x27a/0x570 [xfs] 
> > [31680.493424]  vfs_read+0x5be/0xbe0 
> > [31680.496747]  ? __pfx_vfs_read+0x10/0x10 
> > [31680.500591]  ? local_clock_noinstr+0x9/0xc0 
> > [31680.504777]  ? __fget_files+0x1b8/0x3f0 
> > [31680.508621]  __x64_sys_pread64+0x193/0x1e0 
> > [31680.512725]  ? __pfx___x64_sys_pread64+0x10/0x10 
> > [31680.517343]  ? ktime_get_coarse_real_ts64+0x130/0x170 
> > [31680.522399]  do_syscall_64+0x94/0x190 
> > [31680.526062]  ? rcu_is_watching+0x11/0xb0 
> > [31680.529990]  ? lockdep_hardirqs_on_prepare.part.0+0x18c/0x370 
> > [31680.535735]  ? do_syscall_64+0xa3/0x190 
> > [31680.539574]  ? lockdep_hardirqs_on+0x79/0x100 
> > [31680.543933]  ? do_syscall_64+0xa3/0x190 
> > [31680.547773]  ? do_syscall_64+0xa3/0x190 
> > [31680.551613]  ? do_syscall_64+0xa3/0x190 
> > [31680.555452]  ? do_syscall_64+0xa3/0x190 
> > [31680.559289]  ? do_syscall_64+0xa3/0x190 
> > [31680.563131]  ? lockdep_hardirqs_on_prepare.part.0+0x18c/0x370 
> > [31680.568877]  entry_SYSCALL_64_after_hwframe+0x6e/0x76 
> > [31680.573930] RIP: 0033:0x7f45ed33d02f 
> > [31680.577508] Code: 08 89 3c 24 48 89 4c 24 18 e8 3d 0d f6 ff 4c 8b 54 24 18 48 8b 54 24 10 41 89 c0 48 8b 74 24 08 8b 3c 24 b8 11 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 31 44 89 c7 48 89 04 24 e8 8d 0d f6 ff 48 8b 
> > [31680.596253] RSP: 002b:00007ffd64ed92f0 EFLAGS: 00000293 ORIG_RAX: 0000000000000011 
> > [31680.603820] RAX: ffffffffffffffda RBX: 00007ffd64ed93a0 RCX: 00007f45ed33d02f 
> > [31680.610953] RDX: 0000000000010000 RSI: 0000000001d45000 RDI: 0000000000000003 
> > [31680.618085] RBP: 0000000000000003 R08: 0000000000000000 R09: 0000000000000003 
> > [31680.625217] R10: 000000000d280000 R11: 0000000000000293 R12: 0000000000000d28 
> > [31680.632352] R13: 0000000012d80000 R14: 0000000000000000 R15: 000000000d280000 
> > [31680.639488]  </TASK> 
> > [31680.641685]  
> > [31680.643184] The buggy address belongs to the object at ff11001261ad3d98 
> > [31680.643184]  which belongs to the cache shmem_inode_cache of size 1624 
> > [31680.656298] The buggy address is located 0 bytes to the right of 
> > [31680.656298]  allocated 1624-byte region [ff11001261ad3d98, ff11001261ad43f0) 
> > [31680.669322]  
> > [31680.670821] The buggy address belongs to the physical page: 
> > [31680.676396] page:00000000a0d62698 refcount:1 mapcount:0 mapping:0000000000000000 index:0xff11001261ad3d98 pfn:0x1261ad0 
> > [31680.687168] head:00000000a0d62698 order:3 entire_mapcount:0 nr_pages_mapped:0 pincount:0 
> > [31680.695255] memcg:ff110010ceb7ebc1 
> > [31680.698659] ksm flags: 0x57ffffc0000840(slab|head|node=1|zone=2|lastcpupid=0x1fffff) 
> > [31680.706398] page_type: 0xffffffff() 
> > [31680.709895] raw: 0057ffffc0000840 ff110001008de880 ffd4000007ea8800 dead000000000003 
> > [31680.717632] raw: ff11001261ad3d98 0000000080120008 00000001ffffffff ff110010ceb7ebc1 
> > [31680.725371] page dumped because: kasan: bad access detected 
> > [31680.730943]  
> > [31680.732441] Memory state around the buggy address: 
> > [31680.737237]  ff11001261ad4280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb 
> > [31680.744456]  ff11001261ad4300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb 
> > [31680.751674] >ff11001261ad4380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fc fc 
> > [31680.758892]                                                              ^ 
> > [31680.765768]  ff11001261ad4400: fc fc fc fc fc fc fc fc fc fc fc fc fc fc 00 00 
> > [31680.772986]  ff11001261ad4480: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
> > [31680.780204] ================================================================== 
> > [31680.787456] Disabling lock debugging due to kernel taint 
> > [31680.792793] general protection fault, probably for non-canonical address 0xe993e8b0631e699f: 0000 [#1] PREEMPT SMP KASAN NOPTI 
> > [31680.804176] KASAN: maybe wild-memory-access in range [0x4c9f658318f34cf8-0x4c9f658318f34cff] 
> > [31680.812611] CPU: 3 PID: 1139165 Comm: xfs_io Kdump: loaded Tainted: G    B        L     6.8.0-rc3+ #1 
> > [31680.821822] Hardware name: Dell Inc. PowerEdge R750/0PJ80M, BIOS 1.5.4 12/17/2021 
> > [31680.829301] RIP: 0010:xfs_read_iomap_begin+0xbc/0x750 [xfs] 
> > [31680.835134] Code: 48 c1 e8 03 80 3c 10 00 0f 85 4a 05 00 00 4c 8b 85 f8 fd ff ff 48 b8 00 00 00 00 00 fc ff df 4d 8d 50 78 4c 89 d2 48 c1 ea 03 <0f> b6 04 02 84 c0 74 06 0f 8e de 04 00 00 4d 8d 88 08 01 00 00 45 
> > [31680.853881] RSP: 0018:ffa000002332f460 EFLAGS: 00010206 
> > [31680.859105] RAX: dffffc0000000000 RBX: 1ff4000004665e93 RCX: ffffffff82039806 
> > [31680.866240] RDX: 0993ecb0631e699f RSI: 0000000000000008 RDI: ffffffff87760e20 
> > [31680.873371] RBP: ff11001261ad45f8 R08: 4c9f658318f34c82 R09: fffffbfff0eec1c4 
> > [31680.880505] R10: 4c9f658318f34cfa R11: 6e696c6261736944 R12: 0000000000000000 
> > [31680.887637] R13: 0000000002427000 R14: ff11001261ad43f0 R15: 0000000000000003 
> > [31680.894772] FS:  00007f45ed47ccc0(0000) GS:ff11002031400000(0000) knlGS:0000000000000000 
> > [31680.902856] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 
> > [31680.908603] CR2: 00007fa6aa91acb0 CR3: 00000011446ea005 CR4: 0000000000771ef0 
> > [31680.915735] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000 
> > [31680.922868] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400 
> > [31680.930000] PKRU: 55555554 
> > [31680.932712] Call Trace: 
> > [31680.935165]  <TASK> 
> > [31680.937271]  ? die_addr+0x3d/0xa0 
> > [31680.940593]  ? exc_general_protection+0x150/0x230 
> > [31680.945302]  ? asm_exc_general_protection+0x22/0x30 
> > [31680.950188]  ? add_taint+0x26/0x90 
> > [31680.953601]  ? xfs_read_iomap_begin+0xbc/0x750 [xfs] 
> > [31680.958808]  ? __debug_check_no_obj_freed+0x253/0x520 
> > [31680.963862]  ? __pfx_xfs_read_iomap_begin+0x10/0x10 [xfs] 
> > [31680.969513]  ? validate_chain+0x148/0xe00 
> > [31680.973525]  ? kasan_quarantine_put+0x109/0x220 
> > [31680.978058]  ? lockdep_hardirqs_on+0x79/0x100 
> > [31680.982418]  ? finish_task_switch.isra.0+0x69f/0xb40 
> > [31680.987382]  ? __pfx_xfs_read_iomap_begin+0x10/0x10 [xfs] 
> > [31680.993025]  ? iomap_read_folio+0x230/0x490 
> > [31680.997211]  iomap_iter+0x332/0x760 
> > [31681.000706]  iomap_read_folio+0x230/0x490 
> > [31681.004717]  ? __pfx_iomap_read_folio+0x10/0x10 
> > [31681.009250]  ? __schedule+0x7f9/0x1df0 
> > [31681.013009]  ? filemap_update_page+0x31a/0xba0 
> > [31681.017456]  ? filemap_update_page+0x31a/0xba0 
> > [31681.021904]  ? __pfx_xfs_vm_read_folio+0x10/0x10 [xfs] 
> > [31681.027294]  filemap_read_folio+0xb1/0x220 
> > [31681.031393]  ? __pfx_filemap_read_folio+0x10/0x10 
> > [31681.036100]  ? __pfx_filemap_get_read_batch+0x10/0x10 
> > [31681.041154]  filemap_update_page+0x447/0xba0 
> > [31681.045436]  filemap_get_pages+0x5de/0x960 
> > [31681.049540]  ? __pfx__copy_to_iter+0x10/0x10 
> > [31681.053815]  ? __pfx_filemap_get_pages+0x10/0x10 
> > [31681.058433]  ? folio_mark_accessed+0x2fd/0x7c0 
> > [31681.062882]  filemap_read+0x2f9/0x9d0 
> > [31681.066557]  ? __pfx_filemap_read+0x10/0x10 
> > [31681.070748]  ? down_read_nested+0xc2/0x4d0 
> > [31681.074847]  ? __pfx_down_read_nested+0x10/0x10 
> > [31681.079382]  ? xfs_file_buffered_read+0x170/0x320 [xfs] 
> > [31681.084859]  xfs_file_buffered_read+0x17b/0x320 [xfs] 
> > [31681.090155]  xfs_file_read_iter+0x27a/0x570 [xfs] 
> > [31681.095103]  vfs_read+0x5be/0xbe0 
> > [31681.098424]  ? __pfx_vfs_read+0x10/0x10 
> > [31681.102261]  ? local_clock_noinstr+0x9/0xc0 
> > [31681.106446]  ? __fget_files+0x1b8/0x3f0 
> > [31681.110291]  __x64_sys_pread64+0x193/0x1e0 
> > [31681.114395]  ? __pfx___x64_sys_pread64+0x10/0x10 
> > [31681.119014]  ? ktime_get_coarse_real_ts64+0x130/0x170 
> > [31681.124069]  do_syscall_64+0x94/0x190 
> > [31681.127739]  ? rcu_is_watching+0x11/0xb0 
> > [31681.131669]  ? lockdep_hardirqs_on_prepare.part.0+0x18c/0x370 
> > [31681.137414]  ? do_syscall_64+0xa3/0x190 
> > [31681.141252]  ? lockdep_hardirqs_on+0x79/0x100 
> > [31681.145613]  ? do_syscall_64+0xa3/0x190 
> > [31681.149451]  ? do_syscall_64+0xa3/0x190 
> > [31681.153289]  ? do_syscall_64+0xa3/0x190 
> > [31681.157128]  ? do_syscall_64+0xa3/0x190 
> > [31681.160967]  ? do_syscall_64+0xa3/0x190 
> > [31681.164808]  ? lockdep_hardirqs_on_prepare.part.0+0x18c/0x370 
> > [31681.170556]  entry_SYSCALL_64_after_hwframe+0x6e/0x76 
> > [31681.175615] RIP: 0033:0x7f45ed33d02f 
> > [31681.179194] Code: 08 89 3c 24 48 89 4c 24 18 e8 3d 0d f6 ff 4c 8b 54 24 18 48 8b 54 24 10 41 89 c0 48 8b 74 24 08 8b 3c 24 b8 11 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 31 44 89 c7 48 89 04 24 e8 8d 0d f6 ff 48 8b 
> > [31681.197939] RSP: 002b:00007ffd64ed92f0 EFLAGS: 00000293 ORIG_RAX: 0000000000000011 
> > [31681.205508] RAX: ffffffffffffffda RBX: 00007ffd64ed93a0 RCX: 00007f45ed33d02f 
> > [31681.212639] RDX: 0000000000010000 RSI: 0000000001d45000 RDI: 0000000000000003 
> > [31681.219773] RBP: 0000000000000003 R08: 0000000000000000 R09: 0000000000000003 
> > [31681.226904] R10: 000000000d280000 R11: 0000000000000293 R12: 0000000000000d28 
> > [31681.234038] R13: 0000000012d80000 R14: 0000000000000000 R15: 000000000d280000 
> > [31681.241174]  </TASK> 
> > [31681.243363] Modules linked in: dm_snapshot dm_bufio ext4 mbcache jbd2 loop dm_flakey dm_mod rfkill intel_rapl_msr intel_rapl_common ipmi_ssif intel_uncore_frequency intel_uncore_frequency_common i10nm_edac nfit x86_pkg_temp_thermal intel_powerclamp mlx5_ib coretemp acpi_ipmi ib_uverbs kvm_intel mgag200 iTCO_wdt ipmi_si dax_hmem i2c_algo_bit mei_me iTCO_vendor_support cxl_acpi drm_shmem_helper dell_smbios sunrpc dcdbas kvm irqbypass rapl intel_cstate ib_core cxl_core intel_uncore dell_wmi_descriptor wmi_bmof pcspkr ipmi_devintf i2c_i801 isst_if_mmio isst_if_mbox_pci drm_kms_helper mei isst_if_common ipmi_msghandler intel_pch_thermal intel_vsec i2c_smbus acpi_power_meter drm fuse xfs libcrc32c sd_mod t10_pi sg mlx5_core crct10dif_pclmul crc32_pclmul crc32c_intel ahci libahci mlxfw tls ghash_clmulni_intel megaraid_sas tg3 libata psample pci_hyperv_intf wmi [last unloaded: scsi_debug] 
> > [31681.321349] ---[ end trace 0000000000000000 ]--- 
> > [31681.523907] RIP: 0010:xfs_read_iomap_begin+0xbc/0x750 [xfs] 
> > [31681.529745] Code: 48 c1 e8 03 80 3c 10 00 0f 85 4a 05 00 00 4c 8b 85 f8 fd ff ff 48 b8 00 00 00 00 00 fc ff df 4d 8d 50 78 4c 89 d2 48 c1 ea 03 <0f> b6 04 02 84 c0 74 06 0f 8e de 04 00 00 4d 8d 88 08 01 00 00 45 
> > [31681.548497] RSP: 0018:ffa000002332f460 EFLAGS: 00010206 
> > [31681.553733] RAX: dffffc0000000000 RBX: 1ff4000004665e93 RCX: ffffffff82039806 
> > [31681.560874] RDX: 0993ecb0631e699f RSI: 0000000000000008 RDI: ffffffff87760e20 
> > [31681.568016] RBP: ff11001261ad45f8 R08: 4c9f658318f34c82 R09: fffffbfff0eec1c4 
> > [31681.575156] R10: 4c9f658318f34cfa R11: 6e696c6261736944 R12: 0000000000000000 
> > [31681.582296] R13: 0000000002427000 R14: ff11001261ad43f0 R15: 0000000000000003 
> > [31681.589442] FS:  00007f45ed47ccc0(0000) GS:ff11002031400000(0000) knlGS:0000000000000000 
> > [31681.597533] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 
> > [31681.603289] CR2: 00007fa6aa91acb0 CR3: 00000011446ea005 CR4: 0000000000771ef0 
> > [31681.610431] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000 
> > [31681.617570] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400 
> > [31681.624713] PKRU: 55555554 
> > [31735.015066] restraintd[2712]: *** Current Time: Wed Feb 07 13:16:59 2024  Localwatchdog at: Fri Feb 09 04:33:58 2024 
> > [31795.013965] restraintd[2712]: *** Current Time: Wed Feb 07 13:17:59 2024  Localwatchdog at: Fri Feb 09 04:33:58 2024
> > 
> > 
> > 
> 
> -- 
> Dave Chinner
> david@fromorbit.com
> 

