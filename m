Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3FD615E90
	for <linux-xfs@vger.kernel.org>; Sun, 26 May 2024 14:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716732587; cv=none; b=TiOWpL19enBNIdUrEv5uss5qUUTrCJ9lZ+Lv2AaUxqWg7lRy0+KEhd8yqAtVfcPnhmBsS2bWS0ubUqOLos8gnzKcxwrmxXApbn7tY17AmvMbtcYH4tmBZr5c00gSR4XcXmj5NxV/5BO24yMj4AZR9fWZzZnn3NdXQyghaRXtfv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716732587; c=relaxed/simple;
	bh=APdTwxB72P4Lp3vs37nDf3J5HkStnTGyNXm3wVknAtU=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=utywZ0+7CAggTzu4YhoNFx4a0r89tIHfW60++kSsow9cLwx6lHIx8N7OAThJ9JC/QZ6SsNNI60Th5U+rH6o+y6WySC2d5tRHQjMamRo9P78qxtGqG3JzHgOe7SQ6RxpT+Uqsz8kKnDqZkzCtgoL+FwfCwVym9clXhm2lM7zpdoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IMifrJ55; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IMifrJ55"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716732583;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type;
	bh=VDY10QwWeqE43FqnrNRzYH2v07TVlzQoGqvLbyLN8Kk=;
	b=IMifrJ55l4CGtpvv8oNGzV67Tv61sIB2rilnSfTujQxe92LBtORxD6PXwBvkdnxg+jn9Za
	+t4JITYEZ/0zBazQvDuLOk7ZH3GGPJLlvvvkyoQpJZYYgClNdkkHLAq3yY8UuQB2Abdiks
	z9UxpsiYtOGKtmjN3E17K+WTL4/seJg=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-439-DOfaoYSeOE-ejfDgna5TUw-1; Sun, 26 May 2024 10:09:41 -0400
X-MC-Unique: DOfaoYSeOE-ejfDgna5TUw-1
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-1ecb7e1e3fdso19213605ad.0
        for <linux-xfs@vger.kernel.org>; Sun, 26 May 2024 07:09:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716732580; x=1717337380;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VDY10QwWeqE43FqnrNRzYH2v07TVlzQoGqvLbyLN8Kk=;
        b=uuzVrP+AYh1mEKp7rpN573p5HzWOhzlWkKAvaNmPqjzOAO9q4zmZYI8Gr8UX3kIm1N
         fCcpxjYNlXQtdv4fLTmg2/jAFoIbUCsCKvbYPfIENh/gCwHE2JyXIR7cV+JgEXkO2lJf
         zkN3MU7G9v4t7DPP7YsMyOW25vVpLtciaen+L6H+TRm2Qoj7Ijb7BG854hDzSYq0hrd8
         H+gkbkbX3wAeIw0yiRDqMBnDgEEqF6XFCZDYehtR3Y9wGLGjHb7hiXwiRSo0ZPp5OlP6
         7SG9374KsHFgSLWFRlsjl2J2BCdYalAxL4lKJS6XIaA92Hz7hLJS0hJ1U66Ff0brfZGy
         fxAg==
X-Gm-Message-State: AOJu0Yyy6WyHkkUu69GVdcYdNJdWLjz7h3KeP+wstwhT5NWkfNUlIUf5
	UYiPSck7Q+ljUyFJLR7tnlsnpPo1Q3AFhHnQejT9FQgReHvBagErFZ5Z9DMSnCXHcvWMtREnCvw
	GEKcDxwXOMF2/vJmr491ket4PDwwAY49t6CL+yU5wZhRFE5d414jlmNbtLkYZmfHBU+UGFCf9Z3
	A0WoA6Xi3bmO/bhMYJeI6iF2ZxKLvTKUEsBvTBYVQy
X-Received: by 2002:a17:902:ef47:b0:1f3:830:783e with SMTP id d9443c01a7336-1f44817cf74mr102039315ad.20.1716732579284;
        Sun, 26 May 2024 07:09:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHCJ90avzY51Ey3gepuyp7z+9UOIhrpMswmhLUdnYG7MklkdqTj5qlI7KYBQdAek4npiNOE1w==
X-Received: by 2002:a17:902:ef47:b0:1f3:830:783e with SMTP id d9443c01a7336-1f44817cf74mr102038215ad.20.1716732577489;
        Sun, 26 May 2024 07:09:37 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f44c9a683asm43967815ad.225.2024.05.26.07.09.36
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 May 2024 07:09:37 -0700 (PDT)
Date: Sun, 26 May 2024 22:09:34 +0800
From: Zorro Lang <zlang@redhat.com>
To: linux-xfs@vger.kernel.org
Subject: [BUG report] Oops: general protection fault, probably for
 non-canonical address, RIP: 0010:lockdep_unregister_key+0x92/0x240
Message-ID: <20240526140934.hegcme2cps3sjpiw@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

When I tested linux v6.10-rc0 (HEAD is [0]), I hit a kernel crash several
times [1][2] by running fstests on xfs. Besides that, I also found there
was a KASAN warning [3][4] before this kernel crash happened each time.
So the thing is the [3]/[4] happens at first, then fstests keep running,
then kernel crash [1]/[2] after a while.

The KASAN warning call trace shows "xfs". So I report this bug to xfs list
at first, please feel free to send to other list if it's not related with
xfs.

Thanks,
Zorro

[0]
commit 56fb6f92854f29dcb6c3dc3ba92eeda1b615e88c
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri May 24 17:28:02 2024 -0700

    Merge tag 'drm-next-2024-05-25' of https://gitlab.freedesktop.org/drm/kernel


[1]
[ 1536.887265] run fstests generic/058 at 2024-05-25 04:00:09 
[ 1538.419955] XFS (pmem0): EXPERIMENTAL online scrub feature in use. Use at your own risk! 
[ 1538.717051] XFS (pmem0): Unmounting Filesystem dd16c11a-078c-4740-ad8c-c87d48258622 
[ 1538.897398] XFS (pmem0): Mounting V5 Filesystem dd16c11a-078c-4740-ad8c-c87d48258622 
[ 1538.912263] XFS (pmem0): Ending clean mount 
[ 1538.951253] XFS (pmem0): Unmounting Filesystem dd16c11a-078c-4740-ad8c-c87d48258622 
[ 1539.129894] XFS (pmem0): Mounting V5 Filesystem dd16c11a-078c-4740-ad8c-c87d48258622 
[ 1539.146138] XFS (pmem0): Ending clean mount 
[ 1539.886454] XFS (pmem1): Mounting V5 Filesystem 85dac31d-0118-479a-bc73-632eef90644a 
[ 1539.899395] XFS (pmem1): Ending clean mount 
[ 1539.912986] XFS (pmem1): Unmounting Filesystem 85dac31d-0118-479a-bc73-632eef90644a 
[ 1539.922472] Oops: general protection fault, probably for non-canonical address 0xe0a6bc240000ad1e: 0000 [#1] PREEMPT SMP KASAN NOPTI 
[ 1539.934378] KASAN: maybe wild-memory-access in range [0x05360120000568f0-0x05360120000568f7] 
[ 1539.942811] CPU: 18 PID: 3 Comm: pool_workqueue_ Kdump: loaded Tainted: G    B              6.9.0+ #1 
[ 1539.952023] Hardware name: Dell Inc. PowerEdge R750/0PJ80M, BIOS 1.5.4 12/17/2021 
[ 1539.959502] RIP: 0010:lockdep_unregister_key+0x92/0x240 
[ 1539.964737] Code: 00 0f 85 88 01 00 00 48 8b 1c dd a0 25 7d b3 49 bc 00 00 00 00 00 fc ff df 48 85 db 75 23 e9 11 01 00 00 48 89 d8 48 c1 e8 03 <42> 80 3c 20 00 0f 85 4d 01 00 00 48 8b 1b 48 85 db 0f 84 f3 00 00 
[ 1539.972794] XFS (pmem0): EXPERIMENTAL online scrub feature in use. Use at your own risk! 
[ 1539.983482] RSP: 0018:ffa000000013fe00 EFLAGS: 00010007 
[ 1539.983486] RAX: 00a6c0240000ad1e RBX: 05360120000568f6 RCX: ffffffffacff4872 
[ 1539.983489] RDX: 0000000000000000 RSI: 0000000000000008 RDI: ff1100061df2aa08 
[ 1539.983491] RBP: ff110006b903a148 R08: 0000000000000001 R09: fff3fc0000027fb6 
[ 1540.018201] R10: 0000000000000003 R11: ffa000000013ff50 R12: dffffc0000000000 
[ 1540.025334] R13: 0000000000000246 R14: ff11001189954008 R15: ff110006b903a001 
[ 1540.032467] FS:  0000000000000000(0000) GS:ff11000cecc00000(0000) knlGS:0000000000000000 
[ 1540.040555] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 
[ 1540.046300] CR2: 00007fb8375fda40 CR3: 000000091506e006 CR4: 0000000000771ef0 
[ 1540.053433] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000 
[ 1540.060564] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400 
[ 1540.067698] PKRU: 55555554 
[ 1540.070410] Call Trace: 
[ 1540.072864]  <TASK> 
[ 1540.074971]  ? die_addr+0x3d/0xa0 
[ 1540.078297]  ? exc_general_protection+0x150/0x230 
[ 1540.083008]  ? asm_exc_general_protection+0x22/0x30 
[ 1540.087895]  ? lockdep_unregister_key+0x1f2/0x240 
[ 1540.092609]  ? lockdep_unregister_key+0x92/0x240 
[ 1540.097235]  pwq_release_workfn+0x464/0x930 
[ 1540.101420]  ? trace_irq_enable.constprop.0+0x151/0x1c0 
[ 1540.106648]  kthread_worker_fn+0x2bb/0x990 
[ 1540.110757]  ? __pfx_pwq_release_workfn+0x10/0x10 
[ 1540.115471]  ? __pfx_kthread_worker_fn+0x10/0x10 
[ 1540.120092]  kthread+0x2f3/0x3e0 
[ 1540.123330]  ? _raw_spin_unlock_irq+0x24/0x50 
[ 1540.127698]  ? __pfx_kthread+0x10/0x10 
[ 1540.131450]  ret_from_fork+0x2d/0x70 
[ 1540.135030]  ? __pfx_kthread+0x10/0x10 
[ 1540.138783]  ret_from_fork_asm+0x1a/0x30 
[ 1540.142715]  </TASK> 
[ 1540.144911] Modules linked in: loop rfkill intel_rapl_msr intel_rapl_common intel_uncore_frequency intel_uncore_frequency_common i10nm_edac nfit x86_pkg_temp_thermal intel_powerclamp mlx5_ib coretemp dax_hmem cxl_acpi mgag200 ib_uverbs kvm_intel cxl_core i2c_algo_bit iTCO_wdt acpi_power_meter mei_me ipmi_ssif iTCO_vendor_support drm_shmem_helper dell_smbios sunrpc dcdbas kvm rapl intel_cstate intel_uncore dax_pmem nd_pmem ib_core dell_wmi_descriptor einj wmi_bmof pcspkr isst_if_mbox_pci drm_kms_helper intel_th_gth isst_if_mmio i2c_i801 mei ipmi_si intel_th_pci isst_if_common acpi_ipmi i2c_smbus intel_th intel_pch_thermal intel_vsec ipmi_devintf ipmi_msghandler drm fuse xfs libcrc32c sd_mod t10_pi sg mlx5_core crct10dif_pclmul crc32_pclmul crc32c_intel ahci libahci mlxfw tls ghash_clmulni_intel libata tg3 psample megaraid_sas dimlib pci_hyperv_intf wmi dm_mirror dm_region_hash dm_log dm_mod 
[ 1540.223677] ---[ end trace 0000000000000000 ]--- 
[ 1540.419540] RIP: 0010:lockdep_unregister_key+0x92/0x240 
[ 1540.424804] Code: 00 0f 85 88 01 00 00 48 8b 1c dd a0 25 7d b3 49 bc 00 00 00 00 00 fc ff df 48 85 db 75 23 e9 11 01 00 00 48 89 d8 48 c1 e8 03 <42> 80 3c 20 00 0f 85 4d 01 00 00 48 8b 1b 48 85 db 0f 84 f3 00 00 
[ 1540.443555] RSP: 0018:ffa000000013fe00 EFLAGS: 00010007 
[ 1540.448781] RAX: 00a6c0240000ad1e RBX: 05360120000568f6 RCX: ffffffffacff4872 
[ 1540.455916] RDX: 0000000000000000 RSI: 0000000000000008 RDI: ff1100061df2aa08 
[ 1540.463048] RBP: ff110006b903a148 R08: 0000000000000001 R09: fff3fc0000027fb6 
[ 1540.470180] R10: 0000000000000003 R11: ffa000000013ff50 R12: dffffc0000000000 
[ 1540.477314] R13: 0000000000000246 R14: ff11001189954008 R15: ff110006b903a001 
[ 1540.484445] FS:  0000000000000000(0000) GS:ff11000cecc00000(0000) knlGS:0000000000000000 
[ 1540.492531] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 
[ 1540.498277] CR2: 00007fb8375fda40 CR3: 000000091506e006 CR4: 0000000000771ef0 
[ 1540.505411] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000 
[ 1540.512542] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400 
[ 1540.519674] PKRU: 55555554 
[ 1540.522389] note: pool_workqueue_[3] exited with irqs disabled 
[ 1540.528552] XFS (pmem0): Unmounting Filesystem dd16c11a-078c-4740-ad8c-c87d48258622

[2]
[ 8142.904861] run fstests generic/653 at 2024-05-25 05:49:51 
[ 8144.543052] XFS (pmem1): Mounting V5 Filesystem 25321d99-fb0c-43da-9e96-340d13797ffd 
[ 8144.559228] XFS (pmem1): Ending clean mount 
[ 8144.594106] XFS (pmem1): Unmounting Filesystem 25321d99-fb0c-43da-9e96-340d13797ffd 
[ 8144.724615] XFS (pmem0): Unmounting Filesystem d31f1d21-8356-4bfc-8208-34f838e50811 
[ 8144.792613] Oops: general protection fault, probably for non-canonical address 0xdffffc000000000f: 0000 [#1] PREEMPT SMP KASAN NOPTI 
[ 8144.804525] KASAN: null-ptr-deref in range [0x0000000000000078-0x000000000000007f] 
[ 8144.812100] CPU: 35 PID: 3 Comm: pool_workqueue_ Kdump: loaded Tainted: G    B              6.9.0+ #1 
[ 8144.821320] Hardware name: Dell Inc. PowerEdge R750/0PJ80M, BIOS 1.5.4 12/17/2021 
[ 8144.828798] RIP: 0010:lockdep_unregister_key+0x92/0x240 
[ 8144.834033] Code: 00 0f 85 88 01 00 00 48 8b 1c dd a0 25 dd 8f 49 bc 00 00 00 00 00 fc ff df 48 85 db 75 23 e9 11 01 00 00 48 89 d8 48 c1 e8 03 <42> 80 3c 20 00 0f 85 4d 01 00 00 48 8b 1b 48 85 db 0f 84 f3 00 00 
[ 8144.852780] RSP: 0018:ffa000000013fe00 EFLAGS: 00010006 
[ 8144.858015] RAX: 000000000000000f RBX: 000000000000007b RCX: ffffffff895f4872 
[ 8144.865148] RDX: 0000000000000000 RSI: 0000000000000008 RDI: ff1100062ad8ea08 
[ 8144.872281] RBP: ff11000779a2b948 R08: 0000000000000001 R09: fff3fc0000027fb6 
[ 8144.879412] R10: 0000000000000003 R11: ffa000000013ff50 R12: dffffc0000000000 
[ 8144.886545] R13: 0000000000000246 R14: ff11000672ba8808 R15: ff11000779a2b801 
[ 8144.893678] FS:  0000000000000000(0000) GS:ff11002035400000(0000) knlGS:0000000000000000 
[ 8144.901765] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 
[ 8144.907509] CR2: 0000560a902eddd8 CR3: 00000015afc6e001 CR4: 0000000000771ef0 
[ 8144.914642] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000 
[ 8144.921775] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400 
[ 8144.928908] PKRU: 55555554 
[ 8144.931620] Call Trace: 
[ 8144.934074]  <TASK> 
[ 8144.936180]  ? die_addr+0x3d/0xa0 
[ 8144.939500]  ? exc_general_protection+0x150/0x230 
[ 8144.944208]  ? asm_exc_general_protection+0x22/0x30 
[ 8144.949095]  ? lockdep_unregister_key+0x1f2/0x240 
[ 8144.953801]  ? lockdep_unregister_key+0x92/0x240 
[ 8144.958420]  pwq_release_workfn+0x464/0x930 
[ 8144.962612]  ? trace_irq_enable.constprop.0+0x151/0x1c0 
[ 8144.967840]  kthread_worker_fn+0x2bb/0x990 
[ 8144.971949]  ? __pfx_pwq_release_workfn+0x10/0x10 
[ 8144.976655]  ? __pfx_kthread_worker_fn+0x10/0x10 
[ 8144.981273]  kthread+0x2f3/0x3e0 
[ 8144.984506]  ? _raw_spin_unlock_irq+0x24/0x50 
[ 8144.988873]  ? __pfx_kthread+0x10/0x10 
[ 8144.992626]  ret_from_fork+0x2d/0x70 
[ 8144.996207]  ? __pfx_kthread+0x10/0x10 
[ 8144.999959]  ret_from_fork_asm+0x1a/0x30 
[ 8145.003888]  </TASK> 
[ 8145.006078] Modules linked in: overlay dm_log_writes ext4 mbcache jbd2 loop rfkill intel_rapl_msr intel_rapl_common intel_uncore_frequency intel_uncore_frequency_common i10nm_edac nfit x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm mlx5_ib dax_hmem mgag200 cxl_acpi ib_uverbs cxl_core i2c_algo_bit rapl iTCO_wdt mei_me iTCO_vendor_support drm_shmem_helper dell_smbios ipmi_ssif acpi_power_meter intel_cstate sunrpc dcdbas ib_core intel_uncore dax_pmem drm_kms_helper nd_pmem dell_wmi_descriptor wmi_bmof einj intel_th_gth pcspkr ipmi_si isst_if_mbox_pci mei i2c_i801 acpi_ipmi isst_if_mmio intel_th_pci isst_if_common i2c_smbus intel_pch_thermal ipmi_devintf intel_vsec intel_th ipmi_msghandler drm fuse xfs libcrc32c sd_mod t10_pi sg mlx5_core mlxfw tls ahci libahci crct10dif_pclmul crc32_pclmul crc32c_intel psample ghash_clmulni_intel dimlib libata megaraid_sas tg3 pci_hyperv_intf wmi dm_mirror dm_region_hash dm_log dm_mod [last unloaded: scsi_debug] 
[ 8145.090735] ---[ end trace 0000000000000000 ]--- 
[ 8145.307827] RIP: 0010:lockdep_unregister_key+0x92/0x240 
[ 8145.313062] Code: 00 0f 85 88 01 00 00 48 8b 1c dd a0 25 dd 8f 49 bc 00 00 00 00 00 fc ff df 48 85 db 75 23 e9 11 01 00 00 48 89 d8 48 c1 e8 03 <42> 80 3c 20 00 0f 85 4d 01 00 00 48 8b 1b 48 85 db 0f 84 f3 00 00 
[ 8145.331809] RSP: 0018:ffa000000013fe00 EFLAGS: 00010006 
[ 8145.337043] RAX: 000000000000000f RBX: 000000000000007b RCX: ffffffff895f4872 
[ 8145.344175] RDX: 0000000000000000 RSI: 0000000000000008 RDI: ff1100062ad8ea08 
[ 8145.351307] RBP: ff11000779a2b948 R08: 0000000000000001 R09: fff3fc0000027fb6 
[ 8145.358440] R10: 0000000000000003 R11: ffa000000013ff50 R12: dffffc0000000000 
[ 8145.365573] R13: 0000000000000246 R14: ff11000672ba8808 R15: ff11000779a2b801 
[ 8145.372705] FS:  0000000000000000(0000) GS:ff11002035400000(0000) knlGS:0000000000000000 
[ 8145.380793] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 
[ 8145.386537] CR2: 0000560a902eddd8 CR3: 00000015afc6e001 CR4: 0000000000771ef0 
[ 8145.393670] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000 
[ 8145.400805] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400 
[ 8145.407937] PKRU: 55555554 
[ 8145.410649] note: pool_workqueue_[3] exited with irqs disabled 
[-- MARK -- Sat May 25 09:50:00 2024]

[3]
[  347.732117] XFS (pmem0): Mounting V5 Filesystem dd16c11a-078c-4740-ad8c-c87d48258622 
[  347.748296] XFS (pmem0): Ending clean mount 
[  347.775892] XFS (pmem1): Mounting V5 Filesystem bcf841af-51bd-4837-b846-06928f4ebcbf 
[  347.786106] ================================================================== 
[  347.793325] BUG: KASAN: slab-use-after-free in lockdep_register_key+0x1c1/0x200 
[  347.800641] Read of size 8 at addr ff1100061df2aa08 by task mount/46820 
[  347.807251]  
[  347.808754] CPU: 37 PID: 46820 Comm: mount Kdump: loaded Not tainted 6.9.0+ #1 
[  347.815978] Hardware name: Dell Inc. PowerEdge R750/0PJ80M, BIOS 1.5.4 12/17/2021 
[  347.823460] Call Trace: 
[  347.825913]  <TASK> 
[  347.828019]  dump_stack_lvl+0x7e/0xc0 
[  347.831694]  print_address_description.constprop.0+0x2c/0x3d0 
[  347.837449]  ? lockdep_register_key+0x1c1/0x200 
[  347.841981]  print_report+0xb4/0x270 
[  347.845559]  ? lockdep_register_key+0x1c1/0x200 
[  347.850093]  ? kasan_addr_to_slab+0x9/0xa0 
[  347.854191]  kasan_report+0x89/0xc0 
[  347.857685]  ? lockdep_register_key+0x1c1/0x200 
[  347.862220]  lockdep_register_key+0x1c1/0x200 
[  347.866586]  alloc_workqueue+0x455/0xed0 
[  347.870520]  ? __pfx___lock_release+0x10/0x10 
[  347.874880]  ? wq_adjust_max_active+0x318/0x3e0 
[  347.879414]  ? __pfx_alloc_workqueue+0x10/0x10 
[  347.883858]  ? rcu_is_watching+0x11/0xb0 
[  347.887785]  ? trace_kmalloc+0x30/0xd0 
[  347.891546]  ? kmalloc_trace_noprof+0x1a9/0x360 
[  347.896080]  xlog_cil_init+0xc5/0x5a0 [xfs] 
[  347.900656]  xlog_alloc_log+0xfd8/0x1330 [xfs] 
[  347.905424]  xfs_log_mount+0xbb/0x490 [xfs] 
[  347.909921]  xfs_mountfs+0xe33/0x1ba0 [xfs] 
[  347.914430]  ? __pfx_xfs_mountfs+0x10/0x10 [xfs] 
[  347.919365]  ? init_timer_key+0x145/0x300 
[  347.923379]  ? rcu_is_watching+0x11/0xb0 
[  347.927307]  xfs_fs_fill_super+0xdff/0x17e0 [xfs] 
[  347.932332]  get_tree_bdev+0x304/0x560 
[  347.936093]  ? __pfx_xfs_fs_fill_super+0x10/0x10 [xfs] 
[  347.941552]  ? __pfx_get_tree_bdev+0x10/0x10 
[  347.945826]  ? security_sb_eat_lsm_opts+0x44/0x80 
[  347.950543]  vfs_get_tree+0x87/0x350 
[  347.954128]  do_new_mount+0x2a0/0x5f0 
[  347.957804]  ? __pfx_do_new_mount+0x10/0x10 
[  347.961997]  ? security_capable+0x53/0xa0 
[  347.966010]  path_mount+0x2d5/0x1520 
[  347.969592]  ? __pfx_path_mount+0x10/0x10 
[  347.973604]  __x64_sys_mount+0x1fe/0x270 
[  347.977528]  ? __pfx___x64_sys_mount+0x10/0x10 
[  347.981977]  do_syscall_64+0x8c/0x180 
[  347.985648]  ? do_faccessat+0x21e/0x850 
[  347.989495]  ? ktime_get_coarse_real_ts64+0x130/0x170 
[  347.994551]  ? rcu_is_watching+0x11/0xb0 
[  347.998476]  ? lockdep_hardirqs_on_prepare+0x179/0x400 
[  348.003615]  ? do_syscall_64+0x98/0x180 
[  348.007453]  ? lockdep_hardirqs_on+0x78/0x100 
[  348.011812]  ? do_syscall_64+0x98/0x180 
[  348.015652]  ? from_kgid_munged+0x84/0x110 
[  348.019752]  ? rcu_is_watching+0x11/0xb0 
[  348.023679]  ? lockdep_hardirqs_on_prepare+0x179/0x400 
[  348.028816]  ? do_syscall_64+0x98/0x180 
[  348.032656]  ? lockdep_hardirqs_on+0x78/0x100 
[  348.037015]  ? do_syscall_64+0x98/0x180 
[  348.040856]  ? lockdep_hardirqs_on+0x78/0x100 
[  348.045216]  ? from_kuid_munged+0x82/0x100 
[  348.049314]  ? rcu_is_watching+0x11/0xb0 
[  348.053240]  ? lockdep_hardirqs_on_prepare+0x179/0x400 
[  348.058380]  ? do_syscall_64+0x98/0x180 
[  348.062217]  ? lockdep_hardirqs_on+0x78/0x100 
[  348.066579]  ? do_syscall_64+0x98/0x180 
[  348.070419]  ? do_user_addr_fault+0x4a2/0xb60 
[  348.074786]  ? rcu_is_watching+0x11/0xb0 
[  348.078711]  ? clear_bhb_loop+0x45/0xa0 
[  348.082550]  ? clear_bhb_loop+0x45/0xa0 
[  348.086392]  entry_SYSCALL_64_after_hwframe+0x76/0x7e 
[  348.091444] RIP: 0033:0x7fd0f570f03e 
[  348.095022] Code: 48 8b 0d e5 ad 0e 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d b2 ad 0e 00 f7 d8 64 89 01 48 
[  348.113768] RSP: 002b:00007ffd7abe69d8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5 
[  348.121335] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fd0f570f03e 
[  348.128468] RDX: 000055a647556630 RSI: 000055a6475566b0 RDI: 000055a647556690 
[  348.135598] RBP: 000055a647556400 R08: 000055a647556650 R09: 00007ffd7abe5700 
[  348.142731] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000 
[  348.149865] R13: 000055a647556630 R14: 000055a647556690 R15: 000055a647556400 
[  348.157001]  </TASK> 
[  348.159192]  
[  348.160690] Allocated by task 46035: 
[  348.164270]  kasan_save_stack+0x20/0x40 
[  348.168108]  kasan_save_track+0x10/0x30 
[  348.171947]  __kasan_slab_alloc+0x55/0x70 
[  348.175959]  kmem_cache_alloc_noprof+0x131/0x330 
[  348.180581]  getname_flags.part.0+0x4f/0x450 
[  348.184853]  do_sys_openat2+0xdb/0x160 
[  348.188606]  __x64_sys_openat+0x11f/0x1e0 
[  348.192618]  do_syscall_64+0x8c/0x180 
[  348.196283]  entry_SYSCALL_64_after_hwframe+0x76/0x7e 
[  348.201338]  
[  348.202836] Freed by task 46035: 
[  348.206070]  kasan_save_stack+0x20/0x40 
[  348.209909]  kasan_save_track+0x10/0x30 
[  348.213746]  kasan_save_free_info+0x37/0x60 
[  348.217932]  __kasan_slab_free+0x109/0x190 
[  348.222032]  kmem_cache_free+0x1a6/0x4c0 
[  348.225959]  do_sys_openat2+0x10a/0x160 
[  348.229798]  __x64_sys_openat+0x11f/0x1e0 
[  348.233809]  do_syscall_64+0x8c/0x180 
[  348.237477]  entry_SYSCALL_64_after_hwframe+0x76/0x7e 
[  348.242530]  
[  348.244029] The buggy address belongs to the object at ff1100061df2a200 
[  348.244029]  which belongs to the cache names_cache of size 4096 
[  348.256622] The buggy address is located 2056 bytes inside of 
[  348.256622]  freed 4096-byte region [ff1100061df2a200, ff1100061df2b200) 
[  348.269041]  
[  348.270542] The buggy address belongs to the physical page: 
[  348.276114] page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x61df28 
[  348.284114] head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0 
[  348.291764] flags: 0x17ffffc0000040(head|node=0|zone=2|lastcpupid=0x1fffff) 
[  348.298726] page_type: 0xffffefff(slab) 
[  348.302567] raw: 0017ffffc0000040 ff11000600047ac0 dead000000000100 dead000000000122 
[  348.310305] raw: 0000000000000000 0000000000070007 00000001ffffefff 0000000000000000 
[  348.318043] head: 0017ffffc0000040 ff11000600047ac0 dead000000000100 dead000000000122 
[  348.325869] head: 0000000000000000 0000000000070007 00000001ffffefff 0000000000000000 
[  348.333694] head: 0017ffffc0000003 ffd400001877ca01 ffffffffffffffff 0000000000000000 
[  348.341522] head: 0000000000000008 0000000000000000 00000000ffffffff 0000000000000000 
[  348.349347] page dumped because: kasan: bad access detected 
[  348.354918]  
[  348.356420] Memory state around the buggy address: 
[  348.361212]  ff1100061df2a900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb 
[  348.368433]  ff1100061df2a980: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb 
[  348.375650] >ff1100061df2aa00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb 
[  348.382868]                       ^ 
[  348.386363]  ff1100061df2aa80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb 
[  348.393582]  ff1100061df2ab00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb 
[  348.400799] ================================================================== 
[  348.408022] Disabling lock debugging due to kernel taint 
[  348.416787] XFS (pmem1): Ending clean mount

[4]
[   50.746014] ================================================================== 
[   50.753237] BUG: KASAN: slab-use-after-free in lockdep_register_key+0x1c1/0x200 
[   50.760551] Read of size 8 at addr ff1100062ad8ea08 by task modprobe/1286 
[   50.767338]  
[   50.768836] CPU: 66 PID: 1286 Comm: modprobe Not tainted 6.9.0+ #1 
[   50.775014] Hardware name: Dell Inc. PowerEdge R750/0PJ80M, BIOS 1.5.4 12/17/2021 
[   50.782494] Call Trace: 
[   50.784946]  <TASK> 
[   50.787054]  dump_stack_lvl+0x7e/0xc0 
[   50.790728]  print_address_description.constprop.0+0x2c/0x3d0 
[   50.796484]  ? lockdep_register_key+0x1c1/0x200 
[   50.801015]  print_report+0xb4/0x270 
[   50.804595]  ? lockdep_register_key+0x1c1/0x200 
[   50.809126]  ? kasan_addr_to_slab+0x9/0xa0 
[   50.813226]  kasan_report+0x89/0xc0 
[   50.816720]  ? lockdep_register_key+0x1c1/0x200 
[   50.821254]  lockdep_register_key+0x1c1/0x200 
[   50.825615]  alloc_workqueue+0x455/0xed0 
[   50.829546]  ? do_init_module+0x4b/0x740 
[   50.833472]  ? init_module_from_file+0xd2/0x130 
[   50.838004]  ? idempotent_init_module+0x33a/0x610 
[   50.842712]  ? __pfx_alloc_workqueue+0x10/0x10 
[   50.847159]  ? find_held_lock+0x33/0x120 
[   50.851085]  ? local_clock_noinstr+0x9/0xc0 
[   50.855279]  ? __lock_release+0x486/0x960 
[   50.859293]  ? __pfx_dm_mirror_init+0x10/0x10 [dm_mirror] 
[   50.864698]  dm_mirror_init+0x19/0xff0 [dm_mirror] 
[   50.869492]  do_one_initcall+0x101/0x5b0 
[   50.873428]  ? __pfx_do_one_initcall+0x10/0x10 
[   50.877873]  ? rcu_is_watching+0x11/0xb0 
[   50.881800]  ? trace_kmalloc+0x30/0xd0 
[   50.885561]  ? kmalloc_trace_noprof+0x1a9/0x360 
[   50.890091]  ? trace_module_load+0x14f/0x1c0 
[   50.894366]  ? kasan_unpoison+0x23/0x50 
[   50.898206]  do_init_module+0x233/0x740 
[   50.902047]  init_module_from_file+0xd2/0x130 
[   50.906412]  ? __pfx_init_module_from_file+0x10/0x10 
[   50.911382]  ? idempotent_init_module+0x322/0x610 
[   50.916094]  ? do_raw_spin_unlock+0x55/0x1f0 
[   50.920367]  idempotent_init_module+0x33a/0x610 
[   50.924898]  ? __pfx_idempotent_init_module+0x10/0x10 
[   50.929953]  ? do_syscall_64+0x98/0x180 
[   50.933800]  ? security_capable+0x53/0xa0 
[   50.937821]  __x64_sys_finit_module+0xba/0x130 
[   50.942268]  do_syscall_64+0x8c/0x180 
[   50.945936]  ? vfs_read+0x399/0xc20 
[   50.949434]  ? vfs_read+0x399/0xc20 
[   50.952929]  ? __pfx___x64_sys_openat+0x10/0x10 
[   50.957468]  ? __pfx_vfs_read+0x10/0x10 
[   50.961308]  ? do_syscall_64+0x98/0x180 
[   50.965148]  ? lockdep_hardirqs_on+0x78/0x100 
[   50.969510]  ? __fget_light+0x53/0x1e0 
[   50.973266]  ? lockdep_hardirqs_on_prepare+0x179/0x400 
[   50.978407]  ? ksys_read+0xf1/0x1d0 
[   50.981900]  ? rcu_is_watching+0x11/0xb0 
[   50.985827]  ? lockdep_hardirqs_on_prepare+0x179/0x400 
[   50.990964]  ? do_syscall_64+0x98/0x180 
[   50.994803]  ? lockdep_hardirqs_on+0x78/0x100 
[   50.999163]  ? do_syscall_64+0x98/0x180 
[   51.003002]  ? lockdep_hardirqs_on+0x78/0x100 
[   51.007362]  ? do_syscall_64+0x98/0x180 
[   51.011201]  ? do_syscall_64+0x98/0x180 
[   51.015041]  ? lockdep_hardirqs_on+0x78/0x100 
[   51.019402]  ? do_syscall_64+0x98/0x180 
[   51.023240]  ? do_syscall_64+0x98/0x180 
[   51.027080]  ? clear_bhb_loop+0x45/0xa0 
[   51.030919]  ? clear_bhb_loop+0x45/0xa0 
[   51.034759]  entry_SYSCALL_64_after_hwframe+0x76/0x7e 
[   51.039811] RIP: 0033:0x7fe63f21613d 
[   51.043391] Code: 5b 41 5c c3 66 0f 1f 84 00 00 00 00 00 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d b3 2c 0f 00 f7 d8 64 89 01 48 
[   51.062137] RSP: 002b:00007fffee7816f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000139 
[   51.069702] RAX: ffffffffffffffda RBX: 000055b226781aa0 RCX: 00007fe63f21613d 
[   51.076836] RDX: 0000000000000000 RSI: 000055b2198d5962 RDI: 0000000000000005 
[   51.083968] RBP: 0000000000040000 R08: 0000000000000000 R09: 000055b226782140 
[   51.091101] R10: 0000000000000005 R11: 0000000000000246 R12: 000055b2198d5962 
[   51.098233] R13: 000055b226781b70 R14: 000055b226781aa0 R15: 000055b226782300 
[   51.105371]  </TASK> 
[   51.107560]  
[   51.109058] Allocated by task 1: 
[   51.112291]  kasan_save_stack+0x20/0x40 
[   51.116131]  kasan_save_track+0x10/0x30 
[   51.119969]  __kasan_kmalloc+0x7b/0x90 
[   51.123721]  pci_alloc_dev+0x44/0x270 
[   51.127388]  pci_scan_single_device+0x132/0x280 
[   51.131920]  p2sb_scan_and_cache_devfn+0x15/0x290 
[   51.136627]  p2sb_fs_init+0x10d/0x240 
[   51.140292]  do_one_initcall+0x101/0x5b0 
[   51.144219]  do_initcalls+0x138/0x1d0 
[   51.147884]  kernel_init_freeable+0x8bc/0xbe0 
[   51.152244]  kernel_init+0x1b/0x1f0 
[   51.155736]  ret_from_fork+0x2d/0x70 
[   51.159317]  ret_from_fork_asm+0x1a/0x30 
[   51.163243]  
[   51.164741] Freed by task 1: 
[   51.167629]  kasan_save_stack+0x20/0x40 
[   51.171466]  kasan_save_track+0x10/0x30 
[   51.175307]  kasan_save_free_info+0x37/0x60 
[   51.179491]  __kasan_slab_free+0x109/0x190 
[   51.183593]  kfree+0x126/0x3d0 
[   51.186650]  device_release+0x98/0x210 
[   51.190405]  kobject_cleanup+0x101/0x360 
[   51.194329]  p2sb_fs_init+0x10d/0x240 
[   51.197995]  do_one_initcall+0x101/0x5b0 
[   51.201923]  do_initcalls+0x138/0x1d0 
[   51.205587]  kernel_init_freeable+0x8bc/0xbe0 
[   51.209949]  kernel_init+0x1b/0x1f0 
[   51.213441]  ret_from_fork+0x2d/0x70 
[   51.217018]  ret_from_fork_asm+0x1a/0x30 
[   51.220944]  
[   51.222444] The buggy address belongs to the object at ff1100062ad8e000 
[   51.222444]  which belongs to the cache kmalloc-4k of size 4096 
[   51.234950] The buggy address is located 2568 bytes inside of 
[   51.234950]  freed 4096-byte region [ff1100062ad8e000, ff1100062ad8f000) 
[   51.247372]  
[   51.248868] The buggy address belongs to the physical page: 
[   51.254441] page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x62ad88 
[   51.262443] head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0 
[   51.270094] flags: 0x17ffffc0000040(head|node=0|zone=2|lastcpupid=0x1fffff) 
[   51.277054] page_type: 0xffffefff(slab) 
[   51.280896] raw: 0017ffffc0000040 ff1100060003d040 dead000000000122 0000000000000000 
[   51.288634] raw: 0000000000000000 0000000000040004 00000001ffffefff 0000000000000000 
[   51.296374] head: 0017ffffc0000040 ff1100060003d040 dead000000000122 0000000000000000 
[   51.304199] head: 0000000000000000 0000000000040004 00000001ffffefff 0000000000000000 
[   51.312026] head: 0017ffffc0000003 ffd4000018ab6201 ffffffffffffffff 0000000000000000 
[   51.319852] head: 0000000000000008 0000000000000000 00000000ffffffff 0000000000000000 
[   51.327675] page dumped because: kasan: bad access detected 
[   51.333250]  
[   51.334749] Memory state around the buggy address: 
[   51.339543]  ff1100062ad8e900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb 
[   51.346763]  ff1100062ad8e980: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb 
[   51.353981] >ff1100062ad8ea00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb 
[   51.361200]                       ^ 
[   51.364693]  ff1100062ad8ea80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb 
[   51.371913]  ff1100062ad8eb00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb 
[   51.379130] ================================================================== 
[   51.386351] Disabling lock debugging due to kernel taint 
[      
  OK     
] Finished         
dracut pre-udev hook   

