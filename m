Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB2728DA4
	for <linux-xfs@vger.kernel.org>; Thu, 28 Mar 2024 05:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711604898; cv=none; b=jrcLmEvqzKDh+1M507Uz5KVqut0GaD2GL+QomFml0XYzyHXP5S2EgIl6W7iP09SMXywPKmmTlrhGa8vUEYwdF5OCbaUiDntjPhqV+niLNR0eINdaOQBGXddab76GNQbSg95XnDd0gZCBCtapTmYxFs2OhisEM1ass8rTPtVefzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711604898; c=relaxed/simple;
	bh=qKzbioJcQxk58EFZG1By9qByXS7nGV3/3djdeQxcY0U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=tI+GMYofMqL5RPoc1mYCgaVtzfsJNEJpumGrWW5m7BNLO49Pmp+sW2nwWVLGc4pLDKpMj8uTeizUtNHQdpcZpLVJ6PiXWYI4qozLVNJfAyhaRktzdf+XuaQEXcjipycwHX/GbpkoomILr5B/ANPxRByuxQrzIDJ2pdER5ybBalc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XXAd+8Rt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XXAd+8Rt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE04FC433C7;
	Thu, 28 Mar 2024 05:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711604898;
	bh=qKzbioJcQxk58EFZG1By9qByXS7nGV3/3djdeQxcY0U=;
	h=From:To:Cc:Subject:Date:From;
	b=XXAd+8RtSYyAelINtYxd+EAv++T5edxWY6mKiA19qx5Sx86ko0gzupZeykCgglg11
	 vhvuIat9QsrrQUKlfG6uco/wk2QnSUQEdhDs6M0XqrTr0tsOJi8vnmMYiljSEg2zKd
	 aU5b5HtEsjaaTNsSdcnMkJQdTsCWy+KfgdqqRNFv+WJd4MTx94zSG1Ln3cd4TfMnNW
	 60kTXu52MUGsHC826oEfddsUEexEr0BtBtRBLOPk0b/v9+WngXcqu6zAtu/pUhtjhL
	 S99D0i7MqLjIDA5nYTeOACjqO/I0hcnrtOqH4KWt2G0tyglCrpCRyJ9wrxp2wSkE1g
	 fQb80uE4mMbPw==
User-agent: mu4e 1.10.8; emacs 27.1
From: Chandan Babu R <chandanbabu@kernel.org>
To: linux-mm@kvack.org
Cc: linux-xfs@vger.kernel.org
Subject: [BUG REPORT] writeback: soft lockup encountered on a next-20240327
 kernel
Date: Thu, 28 Mar 2024 11:11:05 +0530
Message-ID: <8734sa3o0x.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

Executing fstest on XFS on a next-20240327 kernel resulted in two of my test
VMs getting into soft lockup state.

watchdog: BUG: soft lockup - CPU#0 stuck for 64383s! [kworker/u16:8:1648676]
Modules linked in: overlay dm_zero dm_thin_pool dm_persistent_data dm_bio_p=
rison dm_snapshot dm_bufio dm_flakey loop nft_redir ipt_REJECT xt_comment x=
t_owner nft_compat nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_rejec=
t_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct nft_chain_nat nf_nat=
 nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 rfkill ip_set cuse vfat fat ext=
4 mbcache jbd2 intel_rapl_msr intel_rapl_common kvm_amd ccp bochs drm_vram_=
helper drm_kms_helper kvm drm_ttm_helper pcspkr pvpanic_mmio ttm pvpanic i2=
c_piix4 joydev sch_fq_codel drm fuse xfs nvme_tcp nvme_fabrics nvme_core sd=
_mod t10_pi crc64_rocksoft_generic crc64_rocksoft sg virtio_net net_failove=
r failover virtio_scsi crct10dif_pclmul crc32_pclmul ata_generic pata_acpi =
ata_piix ghash_clmulni_intel sha512_ssse3 sha256_ssse3 sha1_ssse3 libata vi=
rtio_pci virtio_pci_legacy_dev virtio_pci_modern_dev serio_raw dm_multipath=
 btrfs blake2b_generic xor zstd_compress raid6_pq sunrpc dm_mirror dm_regio=
n_hash dm_log dm_mod be2iscsi bnx2i cnic uio
 cxgb4i cxgb4 tls cxgb3i cxgb3 mdio libcxgbi libcxgb qla4xxx iscsi_boot_sys=
fs iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi qemu_fw_cfg aesni_i=
ntel crypto_simd cryptd [last unloaded: scsi_debug]
CPU: 0 PID: 1648676 Comm: kworker/u16:8 Kdump: loaded Tainted: G           =
  L     6.9.0-rc1-next-20240327+ #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.6.6 08/22/2023
Workqueue: writeback wb_update_bandwidth_workfn
RIP: 0010:__pv_queued_spin_lock_slowpath+0x4d5/0xc30
Code: eb c6 45 01 01 41 bc 00 80 00 00 48 c1 e9 03 83 e3 07 41 be 01 00 00 =
00 48 b8 00 00 00 00 00 fc ff df 4c 8d 2c 01 eb 0c f3 90 <41> 83 ec 01 0f 8=
4 82 04 00 00 41 0f b6 45 00 38 d8 7f 08 84 c0 0f
RSP: 0018:ffffc90007167b18 EFLAGS: 00000206
RAX: 0000000000000003 RBX: 0000000000000000 RCX: 1ffff110211bda18
RDX: 0000000000000001 RSI: 0000000000000003 RDI: ffff888108ded0c0
RBP: ffff888108ded0c0 R08: 0000000000000001 R09: ffffed10211bda18
R10: ffff888108ded0c0 R11: 000000000000000a R12: 0000000000005218
R13: ffffed10211bda18 R14: 0000000000000001 R15: ffff8883ef246bc0
FS:  0000000000000000(0000) GS:ffff8883ef200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f9fa7534500 CR3: 0000000146556000 CR4: 0000000000350ef0
Call Trace:
 <IRQ>
 ? watchdog_timer_fn+0x2e2/0x3b0
 ? __pfx_watchdog_timer_fn+0x10/0x10
 ? __hrtimer_run_queues+0x300/0x6d0
 ? __pfx___hrtimer_run_queues+0x10/0x10
 ? __pfx___raw_spin_lock_irqsave+0x10/0x10
 ? srso_return_thunk+0x5/0x5f
 ? srso_return_thunk+0x5/0x5f
 ? ktime_get_update_offsets_now+0x73/0x280
 ? hrtimer_interrupt+0x2ce/0x770
 ? __sysvec_apic_timer_interrupt+0x90/0x2c0
 ? sysvec_apic_timer_interrupt+0x69/0x90
 </IRQ>
 <TASK>
 _raw_spin_lock+0xd0/0xe0
 __wb_update_bandwidth+0x72/0x600
 wb_update_bandwidth+0x97/0xd0
 process_one_work+0x60d/0x1020
 worker_thread+0x795/0x1290
 kthread+0x2a9/0x380
 ret_from_fork+0x34/0x70
 ret_from_fork_asm+0x1a/0x30
 </TASK>

I am unable to retrieve any other debug information since the machines are =
not
accessible. Hence, I am not sure about the exact test which caused the above
issue.

--=20
Chandan
