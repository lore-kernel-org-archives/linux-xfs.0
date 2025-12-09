Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F4A62E888C
	for <linux-xfs@vger.kernel.org>; Tue,  9 Dec 2025 11:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765280619; cv=none; b=njyOLfbYhyxkWeCnfaW4v4eoVRufP0YRtqx7uSce5CR+aKQce4gLRUoAi+XPmjkjI6+Ds8RuBFaGfh7iXE/zkWZYqCqEIml/9blBKrqqAj8W0xH6wguIVSsawlSOMykQsKkagIzozd3eFKgEFKT5D0hmujCu9opkPrXV732eS/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765280619; c=relaxed/simple;
	bh=te0KfRJU+K0wvyrgTPgIAU6zci8ra0yRIY9sGbu+0Eo=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=bH3LhzO27EURmU01md3GyQx2iAnVTk3MSWwphpzpf+5dkzmeFUEmQBtWdrtbr50dCu0CLGz8fg9gXyFkptUcWqluHuHAxHOIntlFy2niddWAiNvpt3MCtgRvrirXDnHR6f3QqAt9LWFywCD+05a5W8n7vhm7NHyNYf6r3mOfAu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TzneeByN; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=PTVAPUPm; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TzneeByN";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="PTVAPUPm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765280617;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=NikMOxT90crM9oNPXJGa+RbIKPBjXLpDJi4mnNew1j4=;
	b=TzneeByNaZBXNqRYTvpMx1zUr8M/POEjV5nspkp/GlfoGbI5o/lQi++Z5d9Ai/6dXLS/WK
	WmocuDnOU/r39hCPKSfCWIwrB7FnJ+mtLHalCIuS1lw/IL9QZO2jw5tkDaT32m3gcEFH1J
	I/r9tkSwkf8uyv9xB3eNQ0wgER8f4UU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-21-H1TOKzoSNN6VK9BNd9JqFQ-1; Tue, 09 Dec 2025 06:43:35 -0500
X-MC-Unique: H1TOKzoSNN6VK9BNd9JqFQ-1
X-Mimecast-MFC-AGG-ID: H1TOKzoSNN6VK9BNd9JqFQ_1765280615
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-477771366cbso40135835e9.0
        for <linux-xfs@vger.kernel.org>; Tue, 09 Dec 2025 03:43:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765280614; x=1765885414; darn=vger.kernel.org;
        h=mime-version:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=NikMOxT90crM9oNPXJGa+RbIKPBjXLpDJi4mnNew1j4=;
        b=PTVAPUPmwpW1nh2AtaX9dKK00ZBCZtVrRC6hZyuXgQbVoU09LWMKMYoddg4KbIS/yH
         fFaUEjA1MoAfZQBdB0n1ZElwhPu+Uay06PmbQl2PvbHyADpoeVrbG7vSWZx8QZ7f0ElH
         4TwAD7X96t1QBZfJAWku5KQ5dviBx8p20LBnoD5PZT5g6KOZ85zBAI0JvvOg8KGv/elc
         lS2WzqKqRqSVQ3Q5fNY+U9olkXj1XIl+XyIkC7OBc3yoKXZaAQV6AIIf72OEJPrCVpkT
         mdyq/4SXoqtFNJ0ldT7hzeG61cU78+zoMV7Q9I/clt+gQwk1Edt5/VWR8+/faYQDid8V
         O5TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765280614; x=1765885414;
        h=mime-version:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NikMOxT90crM9oNPXJGa+RbIKPBjXLpDJi4mnNew1j4=;
        b=FZNaPkwBf5XtZETJ7Gv0DrRvYDPLB6MQshcQfpCfWwFxDWI4Bg+o/ZDqhdfW+idXpt
         azSYb+QwuYUPuFEHb3QI8Wr/nDH2uhyRtRHqQbizsPIyNw8vr+cu0/6frFxXQikVULAm
         JLS4cTjB65W7uBpaFhgMz/m5Iz6dKdGJZVj5VVAPMAyEMV8KAd4wBWfGaMzStie4FGk0
         1mPJu9k1dzGSjkGTxOOR49G4zRhS6DgcieId/DX82LXIO4WIa7GxRi0bfpVgGrmfxbDF
         ou9ja1lF7r8LefUtsBcT7OnIYlFuDxG9+ihGUNqdUrr62homyF/p755WmXurXAZHd4vw
         1oFg==
X-Forwarded-Encrypted: i=1; AJvYcCXHtspuSx5KJlGvHlm+/UU3gq7/iG8R2LE4+HRMufq/+WivAIxCWfA8uEIi0fqj14XkAWQUeD+xr6Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YxcpgPyFVcXXk5gOWDC4aCMM2zbEoq8NtCo94CguNqERRVU5xfD
	56NVnWLk95mceto0KLMef00rNycQDRz9e6gz21t3+Zmitj3/t+ZkHD7Rd0lPpc285Ulj9Hgine8
	JQwckbOiXIT+5vY0jVfCyX1kf8O8txHy/wbaPAT+ulk4CZejpznyPgIwc6S+28Q==
X-Gm-Gg: ASbGncunIn1hXhKljCsiQEljEoI7/C5Sjix3k6PsIrH30rV/8xcl/zWdhimpe7erH3t
	UrkXxAf8uxlbAk2yUPSXlJQRsvsZtUuWXteEDhguHxcymPoJw5KtPGbHkTDD+JJqcvEzhoaz3Tq
	55zWsdM6bBDovPWsv1EwacLmc3XroHBXurf7K8pkJeCW4l66jOC2er/66lJE8tEQpFnZla24nbu
	gUQKeodExF8/PvqtcYvKc9p31JUGA+zgTDeDF+nnr3G0c/lEix40eMcSOtNSjoP6//ICeqp587N
	3dbjn3r6hm6IyH9f52hIN+CfxW+rl+F6a7UncAXDnFjfVRnOJYvN7eaw9c1Oszd4aD46VeKjXkl
	O1x9JThZEk3OvRFSv5PgL/ebrNpLNNBceyfZeULYbunl0sBS7r50pPU2ComU=
X-Received: by 2002:a05:600c:34d4:b0:477:333a:f71f with SMTP id 5b1f17b1804b1-47939e2484cmr122030455e9.17.1765280614444;
        Tue, 09 Dec 2025 03:43:34 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHTCZyGzi4xmxR7nPR/Yx8w8X5OBttsHOapMgqtOJbDHqtR8ByTJr1zXCWk2ywc3r/CT1Ivxg==
X-Received: by 2002:a05:600c:34d4:b0:477:333a:f71f with SMTP id 5b1f17b1804b1-47939e2484cmr122030155e9.17.1765280614025;
        Tue, 09 Dec 2025 03:43:34 -0800 (PST)
Received: from rh (p200300f6af498100e5be2e2bdb5254b6.dip0.t-ipconnect.de. [2003:f6:af49:8100:e5be:2e2b:db52:54b6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42f7d222506sm33280363f8f.28.2025.12.09.03.43.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Dec 2025 03:43:33 -0800 (PST)
Date: Tue, 9 Dec 2025 12:43:31 +0100 (CET)
From: Sebastian Ott <sebott@redhat.com>
To: linux-nvme@lists.infradead.org, iommu@lists.linux.dev, 
    linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
    linux-xfs@vger.kernel.org
cc: Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, 
    Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
    Carlos Maiolino <cem@kernel.org>
Subject: WARNING: drivers/iommu/io-pgtable-arm.c:639
Message-ID: <170120f7-dd2c-4d2a-d6fc-ac4c82afefd7@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII

Hi,

got the following warning after a kernel update on Thurstday, leading to a
panic and fs corruption. I didn't capture the first warning but I'm pretty
sure it was the same. It's reproducible but I didn't bisect since it
borked my fs. The only hint I can give is that v6.18 worked. Is this a
known issue? Anything I should try?

[64906.234244] WARNING: drivers/iommu/io-pgtable-arm.c:639 at __arm_lpae_unmap+0x358/0x3d0, CPU#94: kworker/94:0/494
[64906.234247] Modules linked in: mlx5_ib ib_uverbs ib_core qrtr rfkill sunrpc mlx5_core cdc_eem usbnet mii acpi_ipmi ipmi_ssif ipmi_devintf ipmi_msghandler mlxfw arm_cmn psample arm_spe_pmu arm_dmc620_pmu vfat fat arm_dsu_pmu cppc_cpufreq fuse loop dm_multipath nfnetlink zram xfs nvme mgag200 ghash_ce sbsa_gwdt nvme_core i2c_algo_bit xgene_hwmon scsi_dh_rdac scsi_dh_emc scsi_dh_alua i2c_dev
[64906.234269] CPU: 94 UID: 0 PID: 494 Comm: kworker/94:0 Tainted: G        W           6.18.0+ #1 PREEMPT(voluntary) 
[64906.234271] Tainted: [W]=WARN
[64906.234271] Hardware name: HPE ProLiant RL300 Gen11/ProLiant RL300 Gen11, BIOS 1.50 12/18/2023
[64906.234272] Workqueue: xfs-buf/nvme1n1p1 xfs_buf_ioend_work [xfs]
[64906.234383] pstate: 804000c9 (Nzcv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[64906.234385] pc : __arm_lpae_unmap+0x358/0x3d0
[64906.234386] lr : __arm_lpae_unmap+0x100/0x3d0
[64906.234387] sp : ffff800083d4bad0
[64906.234388] x29: ffff800083d4bad0 x28: 00000000f3460000 x27: ffff800081bb28e8
[64906.234391] x26: 0000000000001000 x25: ffff800083d4be00 x24: 00000000f3460000
[64906.234393] x23: 0000000000001000 x22: ffff07ff85de9c20 x21: 0000000000000001
[64906.234395] x20: 0000000000000000 x19: ffff07ff9d540300 x18: 0000000000000300
[64906.234398] x17: ffff887cbd289000 x16: ffff800083d48000 x15: 0000000000001000
[64906.234400] x14: 0000000000000fc4 x13: 0000000000000820 x12: 0000000000001000
[64906.234402] x11: 0000000000000006 x10: ffff07ffa1b9c300 x9 : 0000000000000009
[64906.234405] x8 : 0000000000000060 x7 : 000000000000000c x6 : ffff07ffa1b9c000
[64906.234407] x5 : 0000000000000003 x4 : 0000000000000001 x3 : 0000000000001000
[64906.234409] x2 : 0000000000000000 x1 : ffff800083d4be00 x0 : 0000000000000000
[64906.234411] Call trace:
[64906.234412]  __arm_lpae_unmap+0x358/0x3d0 (P)
[64906.234414]  __arm_lpae_unmap+0x100/0x3d0
[64906.234415]  __arm_lpae_unmap+0x100/0x3d0
[64906.234417]  __arm_lpae_unmap+0x100/0x3d0
[64906.234418]  arm_lpae_unmap_pages+0x74/0x90
[64906.234420]  arm_smmu_unmap_pages+0x24/0x40
[64906.234422]  __iommu_unmap+0xe8/0x2a0
[64906.234424]  iommu_unmap_fast+0x18/0x30
[64906.234426]  __iommu_dma_iova_unlink+0xe4/0x280
[64906.234428]  dma_iova_destroy+0x30/0x58
[64906.234431]  nvme_unmap_data+0x88/0x248 [nvme]
[64906.234434]  nvme_poll_cq+0x1d4/0x3e0 [nvme]
[64906.234438]  nvme_irq+0x28/0x70 [nvme]
[64906.234441]  __handle_irq_event_percpu+0x84/0x370
[64906.234444]  handle_irq_event+0x4c/0xb0
[64906.234447]  handle_fasteoi_irq+0x110/0x1a8
[64906.234449]  handle_irq_desc+0x3c/0x68
[64906.234451]  generic_handle_domain_irq+0x24/0x40
[64906.234454]  gic_handle_irq+0x5c/0xe0
[64906.234455]  call_on_irq_stack+0x30/0x48
[64906.234457]  do_interrupt_handler+0xdc/0xe0
[64906.234459]  el1_interrupt+0x38/0x60
[64906.234462]  el1h_64_irq_handler+0x18/0x30
[64906.234464]  el1h_64_irq+0x70/0x78
[64906.234466]  arm_lpae_init_pte+0x228/0x238 (P)
[64906.234467]  __arm_lpae_map+0x2f8/0x378
[64906.234469]  __arm_lpae_map+0x114/0x378
[64906.234470]  __arm_lpae_map+0x114/0x378
[64906.234472]  __arm_lpae_map+0x114/0x378
[64906.234473]  arm_lpae_map_pages+0x108/0x240
[64906.234475]  arm_smmu_map_pages+0x24/0x40
[64906.234477]  iommu_map_nosync+0x124/0x310
[64906.234479]  iommu_map+0x2c/0xb0
[64906.234481]  __iommu_dma_map+0xbc/0x1b0
[64906.234484]  iommu_dma_map_phys+0xf0/0x1c0
[64906.234486]  dma_map_phys+0x190/0x1b0
[64906.234488]  dma_map_page_attrs+0x50/0x70
[64906.234490]  nvme_map_data+0x21c/0x318 [nvme]
[64906.234493]  nvme_prep_rq+0x60/0x200 [nvme]
[64906.234496]  nvme_queue_rq+0x48/0x180 [nvme]
[64906.234499]  blk_mq_dispatch_rq_list+0xfc/0x4d0
[64906.234502]  __blk_mq_sched_dispatch_requests+0xa4/0x1b0
[64906.234504]  blk_mq_sched_dispatch_requests+0x38/0xa0
[64906.234506]  blk_mq_run_hw_queue+0x2f0/0x3d0
[64906.234509]  blk_mq_issue_direct+0x12c/0x280
[64906.234511]  blk_mq_dispatch_queue_requests+0x258/0x318
[64906.234514]  blk_mq_flush_plug_list+0x68/0x170
[64906.234515]  __blk_flush_plug+0xf0/0x140
[64906.234518]  blk_finish_plug+0x34/0x50
[64906.234520]  xfs_buf_submit_bio+0x158/0x1a8 [xfs]
[64906.234630]  xfs_buf_submit+0x80/0x268 [xfs]
[64906.234739]  xfs_buf_ioend_handle_error+0x254/0x480 [xfs]
[64906.234848]  __xfs_buf_ioend+0x18c/0x218 [xfs]
[64906.234957]  xfs_buf_ioend_work+0x24/0x60 [xfs]
[64906.235066]  process_one_work+0x22c/0x658
[64906.235069]  worker_thread+0x1ac/0x360
[64906.235072]  kthread+0x110/0x138
[64906.235074]  ret_from_fork+0x10/0x20
[64906.235075] ---[ end trace 0000000000000000 ]---

Thanks,
Sebastian

