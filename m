Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CD5AC433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Mar 2022 12:47:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231493AbiCWMsq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Mar 2022 08:48:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243298AbiCWMsp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Mar 2022 08:48:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 33A127C169
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 05:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648039635;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=rd3YqlwNesKWb1OlMj9wjgJF/QLwzeCtaFx8+vLE4NY=;
        b=SOAC5rDWuZGZgh43KLVCnXswZuK+t45QwFfpQtLvaFEIW/855QyMwp0QS4of/IFz7Ac2kt
        SyI4Ss4kEnmW1usPAG1RyEB4uVUOqgvtfV5f+qwHwmQRBu+pgqZ+p5/zeQvtxS8oWF+B4X
        byv/46pewD29sfpMqVhxFOjmqGrwGX0=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-633-_eQi6KPKOwuAE5T3euaBUA-1; Wed, 23 Mar 2022 08:47:14 -0400
X-MC-Unique: _eQi6KPKOwuAE5T3euaBUA-1
Received: by mail-qt1-f197.google.com with SMTP id o15-20020ac8698f000000b002e1db0c88d0so1034883qtq.17
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 05:47:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=rd3YqlwNesKWb1OlMj9wjgJF/QLwzeCtaFx8+vLE4NY=;
        b=VjNrHg/2yYSAchm4GJ9fQl3qshNrRuYXfR41z1072HSWV18cVhbv7dlGwA1Air8ZS8
         bZrvBqO4NUEGLHhiXa5MjSzcl15HzK/CJ2oYEWxvqGLTcQ2t1+nSS0oBw9JQc0oMJcES
         kelumBnSm/ziHBftyBQqaz3HYri8yETHro+vxVGMkxVtIWRYyYWzkhpcmxO3kAjNKWtQ
         ma5Pz732oFs08Dtt5sN2UarPROYbMSdVddIA1OvVPk8uXVz62D1BCoq9sKnm8pUrWoYg
         VYg4Wad/AxpaJfjMWkcRDEGKW63ITtkfUJchkRpDEQk560LGh7TxXH2AfwDMqHp9j3b/
         2KGA==
X-Gm-Message-State: AOAM531xtO20R2AgiP6hbesQqZ2/13luIId+YEPzhe2W60sTGUQQBu/y
        +mD5sKHk7aIlGJu/zXbOAs2PVouXn0tgLxLH2K/AYLs0RpVxS/8o8ATcTSvRaV6tSmrN10ICTMb
        L3hVj3FrMpfRm7sI/Qpbh
X-Received: by 2002:a0c:c784:0:b0:440:c2fe:33a3 with SMTP id k4-20020a0cc784000000b00440c2fe33a3mr23534567qvj.38.1648039633069;
        Wed, 23 Mar 2022 05:47:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxfnRPd4fvZapPSceaPFfmi75/bbzUsXpN25NgEjgWY5LOGC+SWCLwNnYQnIYq8mWncP7R13w==
X-Received: by 2002:a0c:c784:0:b0:440:c2fe:33a3 with SMTP id k4-20020a0cc784000000b00440c2fe33a3mr23534551qvj.38.1648039632796;
        Wed, 23 Mar 2022 05:47:12 -0700 (PDT)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id h2-20020ac85842000000b002e1ec550506sm15104391qth.87.2022.03.23.05.47.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 05:47:12 -0700 (PDT)
Date:   Wed, 23 Mar 2022 08:47:10 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-xfs@vger.kernel.org
Subject: XFS tracepoint warning due to NULL string
Message-ID: <YjsWzuw5FbWPrdqq@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Steven,

I'm seeing the warning below [1] on recent kernels via the
xfs_dir2_sf_create tracepoint. This appears to be associated with commit
9a6944fee68e ("tracing: Add a verifier to check string pointers for
trace events") checking for valid string usage in the tracepoint hooks.
It looks to me that the memory usage is correct, we've just open coded
it via __dynamic_array and memcpy() as opposed to using the various more
friendly __string() variants (perhaps due to the format width
specifier).

In any event, playing around with this suggests that the cause is
passing the NULL pointer when no name string is available. The resulting
trace output associated with the warning is here [2]. This particular
tracepoint logic looks to have been in place for some time. The
historical output prior to the above commit is here [3].

What's the best way to address this going forward with the memory usage
verification in place? ISTM we could perhaps consider dropping the
custom %.*s thing in favor of using %s with __string_len() and friends,
or perhaps just replace the open-coded NULL parameter with the "(null)"
string that the trace subsystem code seems to use on NULL pointer
checks. The latter seems pretty simple and straightforward of a change
to me, but I want to make sure I'm not missing something more obvious.
Thoughts?

Brian

[1]

------------[ cut here ]------------
fmt: 'dev %d:%d ino 0x%llx name %.*s namelen %d hashval 0x%x inumber 0x%llx op_flags %s
' current_buffer: '           mkdir-3922    [060] .....  2591.032755: xfs_dir2_sf_create: dev 253:3 ino 0x985 name '
WARNING: CPU: 6 PID: 2683 at kernel/trace/trace.c:3859 trace_check_vprintf+0x4ac/0x4d0
Modules linked in: rpcrdma sunrpc rdma_ucm ib_srpt ib_isert iscsi_target_mod target_core_mod ib_iser libiscsi scsi_transport_iscsi ib_umad rdma_cm ib_ipoib iw_cm ib_cm intel_rapl_msr iTCO_wdt iTCO_vendor_support intel_rapl_common ipmi_ssif i10nm_edac x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel rfkill kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel rapl intel_cstate intel_uncore acpi_ipmi bnxt_re mlx5_ib ipmi_si mei_me ib_uverbs isst_if_mmio isst_if_mbox_pci ipmi_devintf i2c_i801 nd_pmem pcspkr wmi_bmof ib_core mei intel_pch_thermal isst_if_common i2c_smbus ipmi_msghandler nd_btt dax_pmem acpi_power_meter xfs libcrc32c sd_mod sg lpfc nvmet_fc mgag200 nvmet i2c_algo_bit mlx5_core drm_shmem_helper nvme_fc mlxfw drm_kms_helper syscopyarea pci_hyperv_intf nvme_fabrics sysfillrect nvme_core sysimgblt fb_sys_fops t10_pi ahci tls crc32c_intel libahci psample scsi_transport_fc megaraid_sas bnxt_en drm tg3 libata wmi nfit libnvdimm dm_mirror dm_region_hash
 dm_log dm_mod
CPU: 6 PID: 2683 Comm: cat Tainted: G S                5.17.0-rc6+ #29
Hardware name: Dell Inc. PowerEdge R750/06V45N, BIOS 1.2.4 05/28/2021
RIP: 0010:trace_check_vprintf+0x4ac/0x4d0
Code: 3a 39 f0 74 36 c6 04 32 00 49 8b 95 b0 20 00 00 48 8b 74 24 08 48 c7 c7 60 5a e0 87 44 89 44 24 28 88 4c 24 20 e8 46 ea 80 00 <0f> 0b 0f b6 4c 24 20 44 8b 44 24 28 e9 4e fe ff ff c6 44 02 ff 00
RSP: 0018:ff5f059ca0f23d20 EFLAGS: 00010282
RAX: 0000000000000000 RBX: 000000000000001b RCX: 0000000000000027
RDX: 0000000000000027 RSI: ff173cacffcdf8c0 RDI: ff173cacffcdf8c8
RBP: 0000000000000000 R08: 0000000000000000 R09: c0000000ffff7fff
R10: 0000000000000001 R11: ff5f059ca0f23b48 R12: ffffffffc0b04ffa
R13: ff173c6ed005c000 R14: 0000000000000000 R15: ffffffffc0b04fe0
FS:  00007ff5d157d680(0000) GS:ff173cacffcc0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fd6c036a0c0 CR3: 000000010fcfc001 CR4: 0000000000771ee0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554
Call Trace:
 <TASK>
 trace_event_printf+0x5d/0x80
 trace_raw_output_xfs_da_class+0x78/0x90 [xfs]
 print_trace_line+0x1da/0x4d0
 tracing_read_pipe+0x1cd/0x350
 vfs_read+0x95/0x190
 ksys_read+0x59/0xd0
 do_syscall_64+0x37/0x80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7ff5d107a5a5
Code: fe ff ff 50 48 8d 3d 92 f7 09 00 e8 85 fe 01 00 0f 1f 44 00 00 f3 0f 1e fa 48 8d 05 f5 6f 2d 00 8b 00 85 c0 75 0f 31 c0 0f 05 <48> 3d 00 f0 ff ff 77 53 c3 66 90 41 54 49 89 d4 55 48 89 f5 53 89
RSP: 002b:00007ffd47158d88 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
RAX: ffffffffffffffda RBX: 0000000000020000 RCX: 00007ff5d107a5a5
RDX: 0000000000020000 RSI: 00007ff5d14f5000 RDI: 0000000000000003
RBP: 00007ff5d14f5000 R08: 00000000ffffffff R09: 0000000000000000
R10: 0000000000000022 R11: 0000000000000246 R12: 00007ff5d14f5000
R13: 0000000000000003 R14: 00000000000000ab R15: 0000000000020000
 </TASK>
---[ end trace 0000000000000000 ]---

[2] 

mkdir-3922    [060] .....  2591.032755: xfs_dir2_sf_create: dev 253:3 ino 0x985 name (0x0000000000000000)[UNSAFE-MEMORY] namelen 0 hashval 0x0 inumber 0x0 op_flags

[3]

mkdir-3783    [006] ....   406.453838: xfs_dir2_sf_create: dev 253:3 ino 0x985 name  namelen 0 hashval 0x0 inumber 0x0 op_flags

