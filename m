Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45E60C48BDF
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Jun 2021 15:14:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E0A261359
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Jun 2021 15:14:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231565AbhFJPQg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Jun 2021 11:16:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58222 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231553AbhFJPQf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Jun 2021 11:16:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623338079;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type;
        bh=8UMBAWlTJJcgxBCZQywODGtua/v0eVA9OtP0MSdnPRY=;
        b=WIexm/goZ8nI4u/ZKMMhKshth9Yl0Y+bj0tTyp5dIESaFOziDi30Aadz++UzBAMTmD73Gm
        OCkwZ6kISI8ZmaHx+F59tieL+AwXklbEJoWWNj4LXPuGujBP6PqgDKsTZJdTktw+fGQVZ6
        oqVxDomUga/fgwhP6gLX4sV01B90nos=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-149-ZcCeVhoTMQ-6Gfd41I6TBA-1; Thu, 10 Jun 2021 11:14:36 -0400
X-MC-Unique: ZcCeVhoTMQ-6Gfd41I6TBA-1
Received: by mail-oi1-f200.google.com with SMTP id b185-20020acab2c20000b02901f6dd5f89fbso1279367oif.10
        for <linux-xfs@vger.kernel.org>; Thu, 10 Jun 2021 08:14:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition;
        bh=8UMBAWlTJJcgxBCZQywODGtua/v0eVA9OtP0MSdnPRY=;
        b=WwkMvF1uAXfgMmzMLrMohubSYdGDUB8I8uJh2I289BfXKyfrqiyl9TnXBrLqfxyITO
         7id9np+DKYoj0EOoC6PCpErbIjPz6gLCRXjw4gSUxVxF1S8ImMMMsTKCk6P/Oae7VJs2
         qlvZRhUbtRjC6GDg/E5V/fpYw1twflWEuWOdOiIRJSQWboLiWS5ZinqbwfiZmce1YzyI
         TKiDaX0r9t7/QaMcNbuyKkrNzgi8WTX711ocjNFJrkkk/4DtZxJEawQbR9r3X+Ps1oQg
         31EEmFxGsn8+53ymkeUCd+u8nm3eu4Zlg5vw1efeRqBvqaTLxj4Hv7OE9ZVhTUPBpYqf
         ATzA==
X-Gm-Message-State: AOAM530WUZioNPkbQI1szrzmBet/AKRw7fnOZvM0WEUKe/W4eqbKA6zN
        cxl59X6QAe5Xxs+S+aRabca33thA5xB5nQnIq/wnaM4QPrUhyMhvNAyCd8s+0EHdtYhSSGsYNPn
        suGTbvdRff7dkw+9GRuyiytI63BUr1qRZ489ctgkPcRgJ8fOI5OJPnM9HFocPhLLJtN+uUNQ=
X-Received: by 2002:a05:6808:692:: with SMTP id k18mr10327722oig.148.1623338075699;
        Thu, 10 Jun 2021 08:14:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzYkapYiGEC4k7SioFrdW4i/uNuMDQYCHiwuSErYgaJa1vfhKSKyua+KknmYek9j99nkHrHhw==
X-Received: by 2002:a05:6808:692:: with SMTP id k18mr10327701oig.148.1623338075353;
        Thu, 10 Jun 2021 08:14:35 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id w4sm654770otm.31.2021.06.10.08.14.34
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 08:14:35 -0700 (PDT)
Date:   Thu, 10 Jun 2021 11:14:32 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [BUG] generic/475 recovery failure(s)
Message-ID: <YMIsWJ0Cb2ot/UjG@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

I'm seeing what looks like at least one new generic/475 failure on
current for-next. (I've seen one related to an attr buffer that seems to
be older and harder to reproduce.). The test devices are a couple ~15GB
lvm devices formatted with mkfs defaults. I'm still trying to establish
reproducibility, but so far a failure seems fairly reliable within ~30
iterations.

The first [1] looks like log recovery failure processing an EFI. The
second variant [2] looks like it passes log recovery, but then fails the
mount in the COW extent cleanup stage due to a refcountbt problem. I've
also seen one that looks like the same free space corruption error as
[1], but triggered via the COW recovery codepath in [2], so these could
very well be related. A snippet of the dmesg output for each failed
mount is appended below.

Brian

[1]

 ...
 XFS (dm-5): Mounting V5 Filesystem
 XFS (dm-5): Starting recovery (logdev: internal)
 XFS (dm-5): Internal error ltbno + ltlen > bno at line 1940 of file fs/xfs/libxfs/xfs_alloc.c.  Caller xfs_free_ag_extent+0x586/0xa00 [xfs]
 CPU: 75 PID: 207978 Comm: mount Tainted: G        W I       5.13.0-rc4 #64
 Hardware name: Dell Inc. PowerEdge R740/01KPX8, BIOS 1.6.11 11/20/2018
 Call Trace:
  dump_stack+0x7f/0xa1
  xfs_corruption_error+0x81/0x90 [xfs]
  ? xfs_free_ag_extent+0x586/0xa00 [xfs]
  xfs_free_ag_extent+0x5ba/0xa00 [xfs]
  ? xfs_free_ag_extent+0x586/0xa00 [xfs]
  __xfs_free_extent+0xed/0x210 [xfs]
  xfs_trans_free_extent+0x55/0x180 [xfs]
  xfs_efi_item_recover+0x11b/0x170 [xfs]
  xlog_recover_process_intents+0xc5/0x3c0 [xfs]
  ? xfs_iget+0x7c0/0x10b0 [xfs]
  xlog_recover_finish+0x19/0xb0 [xfs]
  xfs_log_mount_finish+0x55/0x150 [xfs]
  xfs_mountfs+0x552/0x960 [xfs]
  xfs_fs_fill_super+0x3af/0x7d0 [xfs]
  ? xfs_fs_put_super+0xa0/0xa0 [xfs]
  get_tree_bdev+0x17f/0x280
  vfs_get_tree+0x28/0xc0
  ? capable+0x3a/0x60
  path_mount+0x433/0xb60
  __x64_sys_mount+0xe3/0x120
  do_syscall_64+0x40/0x80
  entry_SYSCALL_64_after_hwframe+0x44/0xae
 RIP: 0033:0x7f457b46e19e
 Code: 48 8b 0d dd 1c 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d aa 1c 0c 00 f7 d8 64 89 01 48
 RSP: 002b:00007ffec1895aa8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
 RAX: ffffffffffffffda RBX: 00007ffec1895c20 RCX: 00007f457b46e19e
 RDX: 0000562eaa1bb8b0 RSI: 0000562eaa1bb610 RDI: 0000562eaa1ba4e0
 RBP: 0000562eaa1b95c0 R08: 0000000000000000 R09: 00007f457b530a60
 R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
 R13: 0000562eaa1ba4e0 R14: 0000562eaa1bb8b0 R15: 0000562eaa1b95c0
 XFS (dm-5): Corruption detected. Unmount and run xfs_repair
 XFS (dm-5): Internal error xfs_trans_cancel at line 955 of file fs/xfs/xfs_trans.c.  Caller xfs_efi_item_recover+0x12d/0x170 [xfs]
 CPU: 75 PID: 207978 Comm: mount Tainted: G        W I       5.13.0-rc4 #64
 Hardware name: Dell Inc. PowerEdge R740/01KPX8, BIOS 1.6.11 11/20/2018
 Call Trace:
  dump_stack+0x7f/0xa1
  xfs_trans_cancel+0x1a1/0x1f0 [xfs]
  xfs_efi_item_recover+0x12d/0x170 [xfs]
  xlog_recover_process_intents+0xc5/0x3c0 [xfs]
  ? xfs_iget+0x7c0/0x10b0 [xfs]
  xlog_recover_finish+0x19/0xb0 [xfs]
  xfs_log_mount_finish+0x55/0x150 [xfs]
  xfs_mountfs+0x552/0x960 [xfs]
  xfs_fs_fill_super+0x3af/0x7d0 [xfs]
  ? xfs_fs_put_super+0xa0/0xa0 [xfs]
  get_tree_bdev+0x17f/0x280
  vfs_get_tree+0x28/0xc0
  ? capable+0x3a/0x60
  path_mount+0x433/0xb60
  __x64_sys_mount+0xe3/0x120
  do_syscall_64+0x40/0x80
  entry_SYSCALL_64_after_hwframe+0x44/0xae
 RIP: 0033:0x7f457b46e19e
 Code: 48 8b 0d dd 1c 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d aa 1c 0c 00 f7 d8 64 89 01 48
 RSP: 002b:00007ffec1895aa8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
 RAX: ffffffffffffffda RBX: 00007ffec1895c20 RCX: 00007f457b46e19e
 RDX: 0000562eaa1bb8b0 RSI: 0000562eaa1bb610 RDI: 0000562eaa1ba4e0
 RBP: 0000562eaa1b95c0 R08: 0000000000000000 R09: 00007f457b530a60
 R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
 R13: 0000562eaa1ba4e0 R14: 0000562eaa1bb8b0 R15: 0000562eaa1b95c0
 XFS (dm-5): xfs_do_force_shutdown(0x8) called from line 956 of file fs/xfs/xfs_trans.c. Return address = ffffffffc0a9aa4a
 XFS (dm-5): Corruption of in-memory data detected.  Shutting down filesystem
 XFS (dm-5): Please unmount the filesystem and rectify the problem(s)
 XFS (dm-5): Failed to recover intents
 XFS (dm-5): log mount finish failed

[2]

 ...
 XFS (dm-5): Mounting V5 Filesystem
 XFS (dm-5): Starting recovery (logdev: internal)
 XFS (dm-5): Ending recovery (logdev: internal)
 XFS: Assertion failed: 0, file: fs/xfs/libxfs/xfs_btree.c, line: 1588
 ------------[ cut here ]------------
 WARNING: CPU: 73 PID: 189091 at fs/xfs/xfs_message.c:112 assfail+0x25/0x28 [xfs]
 Modules linked in: rfkill dm_service_time dm_multipath scsi_dh_rdac scsi_dh_emc scsi_dh_alua rpcrdma sunrpc rdma_ucm ib_srpt ib_isert iscsi_target_mod target_core_mod ib_iser libiscsi scsi_transport_iscsi rdma_cm ib_umad iw_cm ib_ipoib intel_rapl_msr ib_cm intel_rapl_common isst_if_common mlx5_ib ib_uverbs skx_edac nfit ib_core libnvdimm x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm mlx5_core ipmi_ssif iTCO_wdt irqbypass intel_pmc_bxt rapl iTCO_vendor_support intel_cstate intel_uncore psample mei_me tg3 acpi_ipmi mlxfw wmi_bmof i2c_i801 pcspkr pci_hyperv_intf mei lpc_ich intel_pch_thermal i2c_smbus ipmi_si ipmi_devintf ipmi_msghandler acpi_power_meter fuse zram ip_tables xfs lpfc mgag200 drm_kms_helper nvmet_fc nvmet cec nvme_fc crct10dif_pclmul drm nvme_fabrics crc32_pclmul crc32c_intel nvme_core ghash_clmulni_intel scsi_transport_fc megaraid_sas i2c_algo_bit wmi
 CPU: 73 PID: 189091 Comm: mount Tainted: G        W I       5.13.0-rc4 #64
 Hardware name: Dell Inc. PowerEdge R740/01KPX8, BIOS 1.6.11 11/20/2018
 RIP: 0010:assfail+0x25/0x28 [xfs]
 Code: ff ff 0f 0b c3 0f 1f 44 00 00 41 89 c8 48 89 d1 48 89 f2 48 c7 c6 18 c9 af c0 e8 cf fa ff ff 80 3d 01 cc 0a 00 00 74 02 0f 0b <0f> 0b c3 48 8d 45 10 48 89 e2 4c 89 e6 48 89 1c 24 48 89 44 24 18
 RSP: 0018:ffffb00069057b78 EFLAGS: 00010246
 RAX: 00000000ffffffea RBX: ffff9186c6b55880 RCX: 0000000000000000
 RDX: 00000000ffffffc0 RSI: 0000000000000000 RDI: ffffffffc0aedee4
 RBP: ffffb00069057c98 R08: 0000000000000000 R09: 000000000000000a
 R10: 000000000000000a R11: f000000000000000 R12: 0000000000000000
 R13: 00000000ffffff8b R14: ffffb00069057c70 R15: 0000000000000001
 FS:  00007ff3505eec40(0000) GS:ffff91b5bfd00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00007ff350254000 CR3: 00000030f045c001 CR4: 00000000007706e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 PKRU: 55555554
 Call Trace:
  xfs_btree_increment+0x27a/0x3d0 [xfs]
  ? xfs_refcount_still_have_space+0xb0/0xb0 [xfs]
  ? xfs_refcount_still_have_space+0xb0/0xb0 [xfs]
  xfs_btree_simple_query_range+0x133/0x1d0 [xfs]
  ? xfs_trans_read_buf_map+0x23f/0x5b0 [xfs]
  ? xfs_refcount_still_have_space+0xb0/0xb0 [xfs]
  xfs_btree_query_range+0xf6/0x110 [xfs]
  ? kmem_cache_alloc+0x247/0x2d0
  ? xfs_refcountbt_init_common+0x2b/0xa0 [xfs]
  xfs_refcount_recover_cow_leftovers+0x105/0x390 [xfs]
  ? trace_hardirqs_on+0x1b/0xd0
  ? lock_acquire+0x15d/0x380
  xfs_reflink_recover_cow+0x43/0xa0 [xfs]
  xfs_mountfs+0x5e5/0x960 [xfs]
  xfs_fs_fill_super+0x3af/0x7d0 [xfs]
  ? xfs_fs_put_super+0xa0/0xa0 [xfs]
  get_tree_bdev+0x17f/0x280
  vfs_get_tree+0x28/0xc0
  ? capable+0x3a/0x60
  path_mount+0x433/0xb60
  __x64_sys_mount+0xe3/0x120
  do_syscall_64+0x40/0x80
  entry_SYSCALL_64_after_hwframe+0x44/0xae
 RIP: 0033:0x7ff35082119e
 Code: 48 8b 0d dd 1c 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d aa 1c 0c 00 f7 d8 64 89 01 48
 RSP: 002b:00007ffebc43ea98 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
 RAX: ffffffffffffffda RBX: 00007ffebc43ec10 RCX: 00007ff35082119e
 RDX: 000055ba504c98b0 RSI: 000055ba504c9610 RDI: 000055ba504c84e0
 RBP: 000055ba504c75c0 R08: 0000000000000000 R09: 00007ff3508e3a60
 R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
 R13: 000055ba504c84e0 R14: 000055ba504c98b0 R15: 000055ba504c75c0
 irq event stamp: 0
 hardirqs last  enabled at (0): [<0000000000000000>] 0x0
 hardirqs last disabled at (0): [<ffffffff9e0da3f4>] copy_process+0x754/0x1d00
 softirqs last  enabled at (0): [<ffffffff9e0da3f4>] copy_process+0x754/0x1d00
 softirqs last disabled at (0): [<0000000000000000>] 0x0
 ---[ end trace 3975c06460f0a3d7 ]---
 XFS (dm-5): Error -117 recovering leftover CoW allocations.
 XFS (dm-5): xfs_do_force_shutdown(0x8) called from line 917 of file fs/xfs/xfs_mount.c. Return address = ffffffffc0a904e5
 XFS (dm-5): Corruption of in-memory data detected.  Shutting down filesystem
 XFS (dm-5): Please unmount the filesystem and rectify the problem(s)

