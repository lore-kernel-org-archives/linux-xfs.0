Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 372EEC433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Mar 2022 13:47:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233619AbiCRNsS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Mar 2022 09:48:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236805AbiCRNsS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Mar 2022 09:48:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8DB22170DAF
        for <linux-xfs@vger.kernel.org>; Fri, 18 Mar 2022 06:46:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647611217;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type;
        bh=zk6SiYHFBx+Dh7tkZ/9iTCm0qDbhPY8kGy4Blu2IcTg=;
        b=HQTWC9cRkjva5KxDv454k+wzfE/lPxetbz0sm8uaGXc0BTqS3KF/3Jf3lDt2FwyiUsREIu
        LMcU+ZO6A7clNLh37g/A06+rRIhD01TJvdqFkJV6mqoPTxJhhSIKRQYWKVJ2zsuylkufWf
        0gfXXYLUwwPEOFhed4mjFyZIWVTXJT8=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-391-ir3GatVYO92QhjWXRaGxsg-1; Fri, 18 Mar 2022 09:46:56 -0400
X-MC-Unique: ir3GatVYO92QhjWXRaGxsg-1
Received: by mail-qk1-f197.google.com with SMTP id 12-20020a37090c000000b0067b32f93b90so5360874qkj.16
        for <linux-xfs@vger.kernel.org>; Fri, 18 Mar 2022 06:46:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition;
        bh=zk6SiYHFBx+Dh7tkZ/9iTCm0qDbhPY8kGy4Blu2IcTg=;
        b=0gtKeOcc6xdSEGuS+kKmmt5oWEviEnGsPvj/du9dcnQbgHtxICGEKL52HMVayg8pJT
         jCa9th8dIkWL6irS499xs9d0mHWm0KzvjrL8k2OwGQESYmq/BVn8GePOk7TuC8jNa8bD
         KhBeKgVRWz8btUBFlN78f+d8A3np7PzEuvl7PtqHrylcZzeCTvb+5Pd/F1kbgH8WtD6K
         nRxUJvZ3PmV9F3njhwyQoy0L4dzdZhISRoFgDV8w3SMEkE9bqF9syPROM5yZzDUl0Y+Y
         3pMcqOQ98htmbyGlH40PAtMvtsIYPb4nZ+y35Pgb4l2TWfAOibqBTnNfJNnp0Ui5S5H7
         HI/Q==
X-Gm-Message-State: AOAM531jZ9TXFEPuthm5t7p/paf1oJXvqeYKrFI6KUbXn4rLbnQejBHE
        CvTK254nXAgHr55hm7mgQIyB3SrLZIElUHtDqDKhonvTMcHtHOuqVUjZXeYkc8vAbaVXwP/7klR
        2rjYkNdx4FvrtrzwpHXnk8qJ87HEAETjX0jc7F0khnY8+GO8X86i/DDigcYzmYjg3iWh7Pnw=
X-Received: by 2002:ac8:5e46:0:b0:2e1:e77b:804c with SMTP id i6-20020ac85e46000000b002e1e77b804cmr7433553qtx.671.1647611215546;
        Fri, 18 Mar 2022 06:46:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzGkz/+r3g0T97y8AcRE3ElW7nCiWscpbnF0X8VFhhoFRHhVJRgLvdbtvKTv5geRWIJWrYq+Q==
X-Received: by 2002:ac8:5e46:0:b0:2e1:e77b:804c with SMTP id i6-20020ac85e46000000b002e1e77b804cmr7433529qtx.671.1647611215105;
        Fri, 18 Mar 2022 06:46:55 -0700 (PDT)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id i17-20020ac85e51000000b002e1cf062ef4sm5825816qtx.45.2022.03.18.06.46.54
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 06:46:54 -0700 (PDT)
Date:   Fri, 18 Mar 2022 09:46:53 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [BUG] log I/O completion GPF via xfs/006 and xfs/264 on 5.17.0-rc8
Message-ID: <YjSNTd+U3HBq/Gsv@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

I'm not sure if this is known and/or fixed already, but it didn't look
familiar so here is a report. I hit a splat when testing Willy's
prospective folio bookmark change and it turns out it replicates on
Linus' current master (551acdc3c3d2). This initially reproduced on
xfs/264 (mkfs defaults) and I saw a soft lockup warning variant via
xfs/006, but when I attempted to reproduce the latter a second time I
hit what looks like the same problem as xfs/264. Both tests seem to
involve some form of error injection, so possibly the same underlying
problem. The GPF splat from xfs/264 is below.

Brian

--- 8< ---

general protection fault, probably for non-canonical address 0x102e31d0105f07d: 0000 [#1] PREEMPT SMP NOPTI
CPU: 24 PID: 1647 Comm: kworker/24:1H Tainted: G S                5.17.0-rc8+ #14
Hardware name: Dell Inc. PowerEdge R750/06V45N, BIOS 1.2.4 05/28/2021
Workqueue: xfs-log/dm-5 xlog_ioend_work [xfs]
RIP: 0010:native_queued_spin_lock_slowpath+0x1a4/0x1e0
Code: f3 90 48 8b 0a 48 85 c9 74 f6 eb c5 c1 e9 12 83 e0 03 83 e9 01 48 c1 e0 05 48 63 c9 48 05 40 0d 03 00 48 03 04 cd e0 ba 60 b9 <48> 89 10 8b 42 08 85 c0 75 09 f3 90 8b 42 08 85 c0 74 f7 48 8b 0a
RSP: 0018:ff407350cf917b48 EFLAGS: 00010206
RAX: 0102e31d0105f07d RBX: ff1a52eeb16dd1c0 RCX: 0000000000002c5a
RDX: ff1a53123fb30d40 RSI: ffffffffb95826f6 RDI: ffffffffb9554147
RBP: ff1a53123fb30d40 R08: ff1a52d3c8684028 R09: 0000000000000121
R10: 00000000000000bf R11: 0000000000000b65 R12: 0000000000640000
R13: 0000000000000008 R14: ff1a52d3d0899000 R15: ff1a52d5bdf07800
FS:  0000000000000000(0000) GS:ff1a53123fb00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000556b2ed15f44 CR3: 000000019a4c0005 CR4: 0000000000771ee0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554
Call Trace:
 <TASK>
 _raw_spin_lock+0x2c/0x30
 xfs_trans_ail_delete+0x27/0xd0 [xfs]
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
Modules linked in: rpcrdma sunrpc rdma_ucm ib_srpt ib_isert iscsi_target_mod target_core_mod ib_iser libiscsi intel_rapl_msr scsi_transport_iscsi intel_rapl_common ib_umad i10nm_edac x86_pkg_temp_thermal intel_powerclamp ch
 dm_log dm_mod
---[ end trace 0000000000000000 ]---
RIP: 0010:native_queued_spin_lock_slowpath+0x1a4/0x1e0
Code: f3 90 48 8b 0a 48 85 c9 74 f6 eb c5 c1 e9 12 83 e0 03 83 e9 01 48 c1 e0 05 48 63 c9 48 05 40 0d 03 00 48 03 04 cd e0 ba 60 b9 <48> 89 10 8b 42 08 85 c0 75 09 f3 90 8b 42 08 85 c0 74 f7 48 8b 0a
RSP: 0018:ff407350cf917b48 EFLAGS: 00010206
RAX: 0102e31d0105f07d RBX: ff1a52eeb16dd1c0 RCX: 0000000000002c5a
RDX: ff1a53123fb30d40 RSI: ffffffffb95826f6 RDI: ffffffffb9554147
RBP: ff1a53123fb30d40 R08: ff1a52d3c8684028 R09: 0000000000000121
R10: 00000000000000bf R11: 0000000000000b65 R12: 0000000000640000
R13: 0000000000000008 R14: ff1a52d3d0899000 R15: ff1a52d5bdf07800
FS:  0000000000000000(0000) GS:ff1a53123fb00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000556b2ed15f44 CR3: 000000019a4c0005 CR4: 0000000000771ee0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554
Kernel panic - not syncing: Fatal exception
Kernel Offset: 0x37200000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
---[ end Kernel panic - not syncing: Fatal exception ]---

