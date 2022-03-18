Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8022C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Mar 2022 16:11:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234956AbiCRQMd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Mar 2022 12:12:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234745AbiCRQMc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Mar 2022 12:12:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6C7B41AECA0
        for <linux-xfs@vger.kernel.org>; Fri, 18 Mar 2022 09:11:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647619872;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=W7xITz/5ElJGJFyeGuq895Jef1O/vQALLGAOy/yRoTU=;
        b=MvVGIPgjo/1HSa71RCzgg6HhRceDOvJ+zeOFwKfSAddPvHq6bg91oP3bVzGHynQUrLC3L3
        GPAHWMeHrFpZSkF+rHGl4NqRavy/3yAXxMUc9r9gpvXELeYTteOn9nlyZpzePI8aqsflIu
        kfbFtZOmFbHuGIvMkBAg04BOHYbzopo=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-375-bwXFFNAaNyC7UAA2UmcLLA-1; Fri, 18 Mar 2022 12:11:10 -0400
X-MC-Unique: bwXFFNAaNyC7UAA2UmcLLA-1
Received: by mail-qt1-f198.google.com with SMTP id bq21-20020a05622a1c1500b002e06d6279d5so5930159qtb.7
        for <linux-xfs@vger.kernel.org>; Fri, 18 Mar 2022 09:11:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=W7xITz/5ElJGJFyeGuq895Jef1O/vQALLGAOy/yRoTU=;
        b=BfVT2L/qgNlD1s1tMFEk3qKXmFx5N6zgN49BNYyUmgcEbAQCdl26VFCbhcy/pae+iX
         ihyqkL4nH97FYFlDTrQ5CLBe0ySy3xlpTaCADzpKUfVdXvHwUBb6ubqfS98mnb7MrVKR
         EXFb50z+VezbNnV5JYAo5MAu8TRHraKP91s5Gi+CqqsZ/Vxay0YQa5f0Uv/TZ7ctzTdw
         8DHOfk9sOXsXMsCI6+2pX2aDK6/ZmpPT1zSrzli/es6lecCHILNEm8isrlezQLu+h047
         /Aa40m5wtJpiHM4rh6iv/4rVO4v8LVD3SHFvHrH1YJRn6Lcogrp/tZqKhTHhd7O0ZP/c
         dN6Q==
X-Gm-Message-State: AOAM531j4uSexOSd3lHuEKas/yqbjDC7aWlAkfGnxVwc9Q6IsWuNhGLB
        QYQF6+m4ujymYCOXnbR1ScZ10zuIf6jHusZf1L3R97sHKD/8Fw1WGwaG3yJBjIDaVJ+KBkIqPG1
        yhH+OS2sGQhJgdQPM3cZt3F42dPByH7jxMe+wZd6MxRlur1+byKyFTpq8sojZ0X+VyU7OT8k=
X-Received: by 2002:ac8:5cc1:0:b0:2e1:bd05:1371 with SMTP id s1-20020ac85cc1000000b002e1bd051371mr7871013qta.573.1647619869906;
        Fri, 18 Mar 2022 09:11:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxxBZ3zoEWYEf+X+sQIkCzS/FpYh4SQtDrS5VoBzXusu3TEWy1H5h9zcxCa+PdtVw4feWoKSw==
X-Received: by 2002:ac8:5cc1:0:b0:2e1:bd05:1371 with SMTP id s1-20020ac85cc1000000b002e1bd051371mr7870974qta.573.1647619869408;
        Fri, 18 Mar 2022 09:11:09 -0700 (PDT)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id q8-20020a05622a030800b002e1c9304db8sm5873617qtw.38.2022.03.18.09.11.09
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 09:11:09 -0700 (PDT)
Date:   Fri, 18 Mar 2022 12:11:07 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: Re: [BUG] log I/O completion GPF via xfs/006 and xfs/264 on
 5.17.0-rc8
Message-ID: <YjSvG0wgm6epCa8X@bfoster>
References: <YjSNTd+U3HBq/Gsv@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YjSNTd+U3HBq/Gsv@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 18, 2022 at 09:46:53AM -0400, Brian Foster wrote:
> Hi,
> 
> I'm not sure if this is known and/or fixed already, but it didn't look
> familiar so here is a report. I hit a splat when testing Willy's
> prospective folio bookmark change and it turns out it replicates on
> Linus' current master (551acdc3c3d2). This initially reproduced on
> xfs/264 (mkfs defaults) and I saw a soft lockup warning variant via
> xfs/006, but when I attempted to reproduce the latter a second time I
> hit what looks like the same problem as xfs/264. Both tests seem to
> involve some form of error injection, so possibly the same underlying
> problem. The GPF splat from xfs/264 is below.
> 

Darrick pointed out this [1] series on IRC (particularly the final
patch) so I gave that a try. I _think_ that addresses the GPF issue
given it was nearly 100% reproducible before and I didn't see it in a
few iterations, but once I started a test loop for a longer test I ran
into the aforementioned soft lockup again. A snippet of that one is
below [2]. When this occurs, the task appears to be stuck (i.e. the
warning repeats) indefinitely.

Brian

[1] https://lore.kernel.org/linux-xfs/20220317053907.164160-1-david@fromorbit.com/
[2] Soft lockup warning from xfs/264 with patches from [1] applied:

watchdog: BUG: soft lockup - CPU#52 stuck for 134s! [kworker/52:1H:1881]
Modules linked in: rfkill rpcrdma sunrpc intel_rapl_msr intel_rapl_common rdma_ucm ib_srpt ib_isert iscsi_target_mod i10nm_edac target_core_mod x86_pkg_temp_thermal intel_powerclamp ib_iser coretemp libiscsi scsi_transport_iscsi kvm_intel rdma_cm ib_umad ipmi_ssif ib_ipoib iw_cm ib_cm kvm iTCO_wdt iTCO_vendor_support irqbypass crct10dif_pclmul crc32_pclmul acpi_ipmi mlx5_ib ghash_clmulni_intel bnxt_re ipmi_si rapl intel_cstate ib_uverbs ipmi_devintf mei_me isst_if_mmio isst_if_mbox_pci i2c_i801 nd_pmem ib_core intel_uncore wmi_bmof pcspkr isst_if_common mei i2c_smbus intel_pch_thermal ipmi_msghandler nd_btt dax_pmem acpi_power_meter xfs libcrc32c sd_mod sg mlx5_core lpfc mgag200 i2c_algo_bit drm_shmem_helper nvmet_fc drm_kms_helper nvmet nvme_fc mlxfw nvme_fabrics syscopyarea sysfillrect pci_hyperv_intf sysimgblt fb_sys_fops nvme_core ahci tls t10_pi libahci crc32c_intel psample scsi_transport_fc bnxt_en drm megaraid_sas tg3 libata wmi nfit libnvdimm dm_mirror dm_region_hash
 dm_log dm_mod
CPU: 52 PID: 1881 Comm: kworker/52:1H Tainted: G S           L    5.17.0-rc8+ #17
Hardware name: Dell Inc. PowerEdge R750/06V45N, BIOS 1.2.4 05/28/2021
Workqueue: xfs-log/dm-5 xlog_ioend_work [xfs]
RIP: 0010:native_queued_spin_lock_slowpath+0x1b0/0x1e0
Code: c1 e9 12 83 e0 03 83 e9 01 48 c1 e0 05 48 63 c9 48 05 40 0d 03 00 48 03 04 cd e0 ba 00 8c 48 89 10 8b 42 08 85 c0 75 09 f3 90 <8b> 42 08 85 c0 74 f7 48 8b 0a 48 85 c9 0f 84 6b ff ff ff 0f 0d 09
RSP: 0018:ff4ed0b360e4bb48 EFLAGS: 00000246
RAX: 0000000000000000 RBX: ff3413f05c684540 RCX: 0000000000001719
RDX: ff34142ebfeb0d40 RSI: ffffffff8bf826f6 RDI: ffffffff8bf54147
RBP: ff34142ebfeb0d40 R08: ff34142ebfeb0a68 R09: 00000000000001bc
R10: 00000000000001d1 R11: 0000000000000abd R12: 0000000000d40000
R13: 0000000000000008 R14: ff3413f04cd84000 R15: ff3413f059404400
FS:  0000000000000000(0000) GS:ff34142ebfe80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f9200514f70 CR3: 0000000216c16005 CR4: 0000000000771ee0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554
Call Trace:
 <TASK>
 _raw_spin_lock+0x2c/0x30
 xfs_trans_ail_delete+0x2a/0xd0 [xfs]
 xfs_buf_item_done+0x22/0x30 [xfs]
 xfs_buf_ioend+0x71/0x5e0 [xfs]
 xfs_trans_committed_bulk+0x167/0x2c0 [xfs]
 ? enqueue_entity+0x121/0x4d0
 ? enqueue_task_fair+0x417/0x530
 ? resched_curr+0x23/0xc0
 ? check_preempt_curr+0x3f/0x70
 ? _raw_spin_unlock_irqrestore+0x1f/0x31
 ? __wake_up_common_lock+0x87/0xc0
 xlog_cil_committed+0x29c/0x2d0 [xfs]
 ? _raw_spin_unlock_irqrestore+0x1f/0x31
 ? __wake_up_common_lock+0x87/0xc0
 xlog_cil_process_committed+0x69/0x80 [xfs]
 xlog_state_shutdown_callbacks+0xce/0xf0 [xfs]
 xlog_force_shutdown+0xd0/0x110 [xfs]
 xfs_do_force_shutdown+0x5f/0x150 [xfs]
 xlog_ioend_work+0x71/0x80 [xfs]
 process_one_work+0x1c5/0x390
 ? process_one_work+0x390/0x390
 worker_thread+0x30/0x350
 ? process_one_work+0x390/0x390
 kthread+0xe6/0x110
 ? kthread_complete_and_exit+0x20/0x20
 ret_from_fork+0x1f/0x30
 </TASK>

