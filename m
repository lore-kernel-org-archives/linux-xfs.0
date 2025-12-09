Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0BCB217723;
	Tue,  9 Dec 2025 11:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765281025; cv=none; b=DllFZfjOp9l6gcx6BNR0h9x0+pKiKCb4rSmHIY6gVfge84j/hMg6Mud/tZH8FMkKkBmPNOE6b5NCHSjdsQ+7ZQFux7u1HIVKxuzECBkAEizrmM0cOEaAmzYI763AszGe+lynKbubV5NG0/BcHHuYCdPqWz9LA8h3ia3QggrQA/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765281025; c=relaxed/simple;
	bh=DXUYsWklURS/vuNGYZr7s7CxaCbzGUpMsUzgQDx/1UM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dTKePB6lHC8BEyVDhZTPevU4VfyGf+zR0l9s2FZlNIVV/NaZ0fm2k/MEU8XElLBBx/dZ3k70L4KbfF0Z1hXPd0cGEj2jL704qDSRP7DYssap+8L2OfnUDKeWglelyjqXfoT7SNhyj9lx3jlWzW8hIhAeBLMPcuuy3C7mM3JJw6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2FA6A1691;
	Tue,  9 Dec 2025 03:50:16 -0800 (PST)
Received: from [10.57.46.210] (unknown [10.57.46.210])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B89CA3F762;
	Tue,  9 Dec 2025 03:50:21 -0800 (PST)
Message-ID: <4386e0f7-9e45-41d2-8236-7133d6d00610@arm.com>
Date: Tue, 9 Dec 2025 11:50:18 +0000
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: WARNING: drivers/iommu/io-pgtable-arm.c:639
To: Sebastian Ott <sebott@redhat.com>, linux-nvme@lists.infradead.org,
 iommu@lists.linux.dev, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org
Cc: Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>,
 Will Deacon <will@kernel.org>, Carlos Maiolino <cem@kernel.org>
References: <170120f7-dd2c-4d2a-d6fc-ac4c82afefd7@redhat.com>
From: Robin Murphy <robin.murphy@arm.com>
Content-Language: en-GB
In-Reply-To: <170120f7-dd2c-4d2a-d6fc-ac4c82afefd7@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2025-12-09 11:43 am, Sebastian Ott wrote:
> Hi,
> 
> got the following warning after a kernel update on Thurstday, leading to a
> panic and fs corruption. I didn't capture the first warning but I'm pretty
> sure it was the same. It's reproducible but I didn't bisect since it
> borked my fs. The only hint I can give is that v6.18 worked. Is this a
> known issue? Anything I should try?

nvme_unmap_data() is attempting to unmap an IOVA that was never mapped, 
or has already been unmapped by someone else. That's a usage bug.

Thanks,
Robin.

> [64906.234244] WARNING: drivers/iommu/io-pgtable-arm.c:639 at 
> __arm_lpae_unmap+0x358/0x3d0, CPU#94: kworker/94:0/494
> [64906.234247] Modules linked in: mlx5_ib ib_uverbs ib_core qrtr rfkill 
> sunrpc mlx5_core cdc_eem usbnet mii acpi_ipmi ipmi_ssif ipmi_devintf 
> ipmi_msghandler mlxfw arm_cmn psample arm_spe_pmu arm_dmc620_pmu vfat 
> fat arm_dsu_pmu cppc_cpufreq fuse loop dm_multipath nfnetlink zram xfs 
> nvme mgag200 ghash_ce sbsa_gwdt nvme_core i2c_algo_bit xgene_hwmon 
> scsi_dh_rdac scsi_dh_emc scsi_dh_alua i2c_dev
> [64906.234269] CPU: 94 UID: 0 PID: 494 Comm: kworker/94:0 Tainted: 
> G        W           6.18.0+ #1 PREEMPT(voluntary) [64906.234271] 
> Tainted: [W]=WARN
> [64906.234271] Hardware name: HPE ProLiant RL300 Gen11/ProLiant RL300 
> Gen11, BIOS 1.50 12/18/2023
> [64906.234272] Workqueue: xfs-buf/nvme1n1p1 xfs_buf_ioend_work [xfs]
> [64906.234383] pstate: 804000c9 (Nzcv daIF +PAN -UAO -TCO -DIT -SSBS 
> BTYPE=--)
> [64906.234385] pc : __arm_lpae_unmap+0x358/0x3d0
> [64906.234386] lr : __arm_lpae_unmap+0x100/0x3d0
> [64906.234387] sp : ffff800083d4bad0
> [64906.234388] x29: ffff800083d4bad0 x28: 00000000f3460000 x27: 
> ffff800081bb28e8
> [64906.234391] x26: 0000000000001000 x25: ffff800083d4be00 x24: 
> 00000000f3460000
> [64906.234393] x23: 0000000000001000 x22: ffff07ff85de9c20 x21: 
> 0000000000000001
> [64906.234395] x20: 0000000000000000 x19: ffff07ff9d540300 x18: 
> 0000000000000300
> [64906.234398] x17: ffff887cbd289000 x16: ffff800083d48000 x15: 
> 0000000000001000
> [64906.234400] x14: 0000000000000fc4 x13: 0000000000000820 x12: 
> 0000000000001000
> [64906.234402] x11: 0000000000000006 x10: ffff07ffa1b9c300 x9 : 
> 0000000000000009
> [64906.234405] x8 : 0000000000000060 x7 : 000000000000000c x6 : 
> ffff07ffa1b9c000
> [64906.234407] x5 : 0000000000000003 x4 : 0000000000000001 x3 : 
> 0000000000001000
> [64906.234409] x2 : 0000000000000000 x1 : ffff800083d4be00 x0 : 
> 0000000000000000
> [64906.234411] Call trace:
> [64906.234412]  __arm_lpae_unmap+0x358/0x3d0 (P)
> [64906.234414]  __arm_lpae_unmap+0x100/0x3d0
> [64906.234415]  __arm_lpae_unmap+0x100/0x3d0
> [64906.234417]  __arm_lpae_unmap+0x100/0x3d0
> [64906.234418]  arm_lpae_unmap_pages+0x74/0x90
> [64906.234420]  arm_smmu_unmap_pages+0x24/0x40
> [64906.234422]  __iommu_unmap+0xe8/0x2a0
> [64906.234424]  iommu_unmap_fast+0x18/0x30
> [64906.234426]  __iommu_dma_iova_unlink+0xe4/0x280
> [64906.234428]  dma_iova_destroy+0x30/0x58
> [64906.234431]  nvme_unmap_data+0x88/0x248 [nvme]
> [64906.234434]  nvme_poll_cq+0x1d4/0x3e0 [nvme]
> [64906.234438]  nvme_irq+0x28/0x70 [nvme]
> [64906.234441]  __handle_irq_event_percpu+0x84/0x370
> [64906.234444]  handle_irq_event+0x4c/0xb0
> [64906.234447]  handle_fasteoi_irq+0x110/0x1a8
> [64906.234449]  handle_irq_desc+0x3c/0x68
> [64906.234451]  generic_handle_domain_irq+0x24/0x40
> [64906.234454]  gic_handle_irq+0x5c/0xe0
> [64906.234455]  call_on_irq_stack+0x30/0x48
> [64906.234457]  do_interrupt_handler+0xdc/0xe0
> [64906.234459]  el1_interrupt+0x38/0x60
> [64906.234462]  el1h_64_irq_handler+0x18/0x30
> [64906.234464]  el1h_64_irq+0x70/0x78
> [64906.234466]  arm_lpae_init_pte+0x228/0x238 (P)
> [64906.234467]  __arm_lpae_map+0x2f8/0x378
> [64906.234469]  __arm_lpae_map+0x114/0x378
> [64906.234470]  __arm_lpae_map+0x114/0x378
> [64906.234472]  __arm_lpae_map+0x114/0x378
> [64906.234473]  arm_lpae_map_pages+0x108/0x240
> [64906.234475]  arm_smmu_map_pages+0x24/0x40
> [64906.234477]  iommu_map_nosync+0x124/0x310
> [64906.234479]  iommu_map+0x2c/0xb0
> [64906.234481]  __iommu_dma_map+0xbc/0x1b0
> [64906.234484]  iommu_dma_map_phys+0xf0/0x1c0
> [64906.234486]  dma_map_phys+0x190/0x1b0
> [64906.234488]  dma_map_page_attrs+0x50/0x70
> [64906.234490]  nvme_map_data+0x21c/0x318 [nvme]
> [64906.234493]  nvme_prep_rq+0x60/0x200 [nvme]
> [64906.234496]  nvme_queue_rq+0x48/0x180 [nvme]
> [64906.234499]  blk_mq_dispatch_rq_list+0xfc/0x4d0
> [64906.234502]  __blk_mq_sched_dispatch_requests+0xa4/0x1b0
> [64906.234504]  blk_mq_sched_dispatch_requests+0x38/0xa0
> [64906.234506]  blk_mq_run_hw_queue+0x2f0/0x3d0
> [64906.234509]  blk_mq_issue_direct+0x12c/0x280
> [64906.234511]  blk_mq_dispatch_queue_requests+0x258/0x318
> [64906.234514]  blk_mq_flush_plug_list+0x68/0x170
> [64906.234515]  __blk_flush_plug+0xf0/0x140
> [64906.234518]  blk_finish_plug+0x34/0x50
> [64906.234520]  xfs_buf_submit_bio+0x158/0x1a8 [xfs]
> [64906.234630]  xfs_buf_submit+0x80/0x268 [xfs]
> [64906.234739]  xfs_buf_ioend_handle_error+0x254/0x480 [xfs]
> [64906.234848]  __xfs_buf_ioend+0x18c/0x218 [xfs]
> [64906.234957]  xfs_buf_ioend_work+0x24/0x60 [xfs]
> [64906.235066]  process_one_work+0x22c/0x658
> [64906.235069]  worker_thread+0x1ac/0x360
> [64906.235072]  kthread+0x110/0x138
> [64906.235074]  ret_from_fork+0x10/0x20
> [64906.235075] ---[ end trace 0000000000000000 ]---
> 
> Thanks,
> Sebastian
> 

