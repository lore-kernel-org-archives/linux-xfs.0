Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32438C48BDF
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Jun 2021 13:08:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E447F613D1
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Jun 2021 13:08:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbhFRNKa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Jun 2021 09:10:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53249 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229523AbhFRNK3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Jun 2021 09:10:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624021700;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9nElnUOijh695DG07lGYGc1seTtUzyfe2CdiBbDyuno=;
        b=gBY0Xs/k4+nQrvTTLMx3jlmYtqzFUXojZvpE3b2TJhuxP7+gtqKt9TPKj5tFRVLfYi4C2o
        9GyLg4AAc6MwOzIfA+GSCpr/g/2cTF43TF5F+bNU8Kuj9njSGcJG6rdKPv9LrDcU4zsZkC
        rfHKbaeCDDYvj2ADiOZFKwJLlAwAWaY=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-209-CRqHwO-yNz-9fFKfjrqlrQ-1; Fri, 18 Jun 2021 09:08:18 -0400
X-MC-Unique: CRqHwO-yNz-9fFKfjrqlrQ-1
Received: by mail-ot1-f70.google.com with SMTP id 108-20020a9d0bf50000b02903d55be6ada3so5849362oth.22
        for <linux-xfs@vger.kernel.org>; Fri, 18 Jun 2021 06:08:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9nElnUOijh695DG07lGYGc1seTtUzyfe2CdiBbDyuno=;
        b=d2jK2ja/FTUxyFpOCWMMXKypgZBcTvtfrySuYBotrUKEDIbddPW9SDtjkhqzOysVo3
         dMtiekbhAuQb3Hr7R+CQFvGFBZBW4YvXZ1Fz20rVGDe5ZEI/dxJNW8Zz4X2BlTvbidEB
         j79MkcRtjR+OtadnG8Dj4V7oCdXKiqOLAQzIOM0yliuC3K1UG+7IYH77b7rKxGoeKw6h
         OiY5W7DpWT1VGFJM7p0cBlxDE2MOV1g4BzvZ5pe6FoJNfpn04C/dhRpQV8O0TiTsHq1/
         /emffI/A0xYvjqFQn/I5tHZfj3kECoWR1mu+AK1W9Jm8N9seNlFg913gPLzjOO/gO5+Y
         fyOw==
X-Gm-Message-State: AOAM531SdqO0Ff945h1Ls/W4cbJOoUhvH9kpGEI/YMX57R23zpOmPwjd
        ugPnaGGtHSvHbDpvBKkmR9+hoRw8JlI2n10oo1FAzTYIPsTzDS/e0n3HTsPfuFci7W1/O5fZo4d
        WItgmGPiDurdIlwX7wB26
X-Received: by 2002:aca:b8c2:: with SMTP id i185mr14392195oif.172.1624021698082;
        Fri, 18 Jun 2021 06:08:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzH6OSLcm3A5nlBbPHFXzCAhUGuOjTbU7LA8BBtzQaeQRreYQdbVL9vx3M8tRhu8H6bkNAw2Q==
X-Received: by 2002:aca:b8c2:: with SMTP id i185mr14392174oif.172.1624021697784;
        Fri, 18 Jun 2021 06:08:17 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id w4sm1982776otm.31.2021.06.18.06.08.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 06:08:17 -0700 (PDT)
Date:   Fri, 18 Jun 2021 09:08:15 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/8 V2] xfs: log fixes for for-next
Message-ID: <YMyav1+JiSlQbDFH@bfoster>
References: <20210617082617.971602-1-david@fromorbit.com>
 <YMuVPgmEjwaGTaFA@bfoster>
 <20210617190519.GV158209@locust>
 <20210617234308.GH664593@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210617234308.GH664593@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 18, 2021 at 09:43:08AM +1000, Dave Chinner wrote:
> On Thu, Jun 17, 2021 at 12:05:19PM -0700, Darrick J. Wong wrote:
> > On Thu, Jun 17, 2021 at 02:32:30PM -0400, Brian Foster wrote:
> > > On Thu, Jun 17, 2021 at 06:26:09PM +1000, Dave Chinner wrote:
> > > > Hi folks,
> > > > 
> > > > This is followup from the first set of log fixes for for-next that
> > > > were posted here:
> > > > 
> > > > https://lore.kernel.org/linux-xfs/20210615175719.GD158209@locust/T/#mde2cf0bb7d2ac369815a7e9371f0303efc89f51b
> > > > 
> > > > The first two patches of this series are updates for those patches,
> > > > change log below. The rest is the fix for the bigger issue we
> > > > uncovered in investigating the generic/019 failures, being that
> > > > we're triggering a zero-day bug in the way log recovery assigns LSNs
> > > > to checkpoints.
> > > > 
> > > > The "simple" fix of using the same ordering code as the commit
> > > > record for the start records in the CIL push turned into a lot of
> > > > patches once I started cleaning it up, separating out all the
> > > > different bits and finally realising all the things I needed to
> > > > change to avoid unintentional logic/behavioural changes. Hence
> > > > there's some code movement, some factoring, API changes to
> > > > xlog_write(), changing where we attach callbacks to commit iclogs so
> > > > they remain correctly ordered if there are multiple commit records
> > > > in the one iclog and then, finally, strictly ordering the start
> > > > records....
> > > > 
> > > > The original "simple fix" I tested last night ran almost a thousand
> > > > cycles of generic/019 without a log hang or recovery failure of any
> > > > kind. The refactored patchset has run a couple hundred cycles of
> > > > g/019 and g/475 over the last few hours without a failure, so I'm
> > > > posting this so we can get a review iteration done while I sleep so
> > > > we can - hopefully - get this sorted out before the end of the week.
> > > > 
> > > 
> > > My first spin of this included generic/019 and generic/475, ran for 18
> > > or so iterations and 475 exploded with a stream of asserts followed by a
> > > NULL pointer crash:
> > > 
> > > # grep -e Assertion -e BUG dmesg.out
> > > ...
> > > [ 7951.878058] XFS: Assertion failed: atomic_read(&buip->bui_refcount) > 0, file: fs/xfs/xfs_bmap_item.c, line: 57
> > > [ 7952.261251] XFS: Assertion failed: atomic_read(&buip->bui_refcount) > 0, file: fs/xfs/xfs_bmap_item.c, line: 57
> > > [ 7952.644444] XFS: Assertion failed: atomic_read(&buip->bui_refcount) > 0, file: fs/xfs/xfs_bmap_item.c, line: 57
> > > [ 7953.027626] XFS: Assertion failed: atomic_read(&buip->bui_refcount) > 0, file: fs/xfs/xfs_bmap_item.c, line: 57
> > > [ 7953.410804] BUG: kernel NULL pointer dereference, address: 000000000000031f
> > > [ 7954.118973] BUG: unable to handle page fault for address: ffffa57ccf99fa98
> > > 
> > > I don't know if this is a regression, but I've not seen it before. I've
> > > attempted to spin generic/475 since then to see if it reproduces again,
> > > but so far I'm only running into some of the preexisting issues
> > > associated with that test.
> 
> I've not seen anything like that. I can't see how the changes in the
> patchset would affect BUI reference counting in any way. That seems
> more like an underlying intent item shutdown reference count issue
> to me (and we've had a *lot* of them in the past)....
> 

I've not made sense of it either, but at the same time, I've not seen it
in all my testing thus far up until targeting this series, and now I've
seen it twice in as many test runs as my overnight run fell into some
kind of similar haywire state. Unfortunately it seemed to be
spinning/streaming assert output so I lost any record of the initial
crash signature. It wouldn't surprise me if the fundamental problem is
some older bug in another area of code, but it's hard to believe it's
not at least related to this series somehow.

Also FYI, earlier iterations of generic/475 triggered a couple instances
of the following assert failure before things broke down more severely:

 XFS: Assertion failed: *log_offset + *len <= iclog->ic_size || iclog->ic_state == XLOG_STATE_WANT_SYNC, file: fs/xfs/xfs_log.c, line: 2115
 ...
 ------------[ cut here ]------------
 WARNING: CPU: 45 PID: 951355 at fs/xfs/xfs_message.c:112 assfail+0x25/0x28 [xfs]
 Modules linked in: rfkill dm_service_time dm_multipath scsi_dh_rdac scsi_dh_emc scsi_dh_alua rpcrdma sunrpc rdma_ucm ib_srpt ib_isert iscsi_target_mod target_core_mod ib_iser libiscsi scsi_transport_iscsi ib_umad ib_ipoib rdma_cm iw_cm ib_cm intel_rapl_msr mlx5_ib intel_rapl_common ib_uverbs isst_if_common ib_core skx_edac nfit libnvdimm x86_pkg_temp_thermal intel_powerclamp coretemp mlx5_core kvm_intel kvm ipmi_ssif irqbypass iTCO_wdt intel_pmc_bxt rapl psample intel_cstate iTCO_vendor_support acpi_ipmi mlxfw intel_uncore pci_hyperv_intf pcspkr wmi_bmof tg3 mei_me ipmi_si i2c_i801 mei ipmi_devintf i2c_smbus lpc_ich intel_pch_thermal ipmi_msghandler acpi_power_meter fuse zram ip_tables xfs lpfc mgag200 drm_kms_helper nvmet_fc nvmet cec crct10dif_pclmul nvme_fc crc32_pclmul drm nvme_fabrics crc32c_intel nvme_core ghash_clmulni_intel megaraid_sas scsi_transport_fc i2c_algo_bit wmi
 CPU: 45 PID: 951355 Comm: kworker/u162:5 Tainted: G          I       5.13.0-rc4+ #70
 Hardware name: Dell Inc. PowerEdge R740/01KPX8, BIOS 1.6.11 11/20/2018
 Workqueue: xfs-cil/dm-7 xlog_cil_push_work [xfs]
 RIP: 0010:assfail+0x25/0x28 [xfs]
 Code: ff ff 0f 0b c3 0f 1f 44 00 00 41 89 c8 48 89 d1 48 89 f2 48 c7 c6 d8 db 36 c0 e8 cf fa ff ff 80 3d f1 d4 0a 00 00 74 02 0f 0b <0f> 0b c3 48 8d 45 10 48 89 e2 4c 89 e6 48 89 1c 24 48 89 44 24 18
 RSP: 0018:ffffa59c80ce3bb0 EFLAGS: 00010246
 RAX: 00000000ffffffea RBX: ffff8b2671dddc00 RCX: 0000000000000000
 RDX: 00000000ffffffc0 RSI: 0000000000000000 RDI: ffffffffc035f0e2
 RBP: 0000000000015d60 R08: 0000000000000000 R09: 000000000000000a
 R10: 000000000000000a R11: f000000000000000 R12: ffff8b241716e6c0
 R13: 000000000000003c R14: ffff8b241716e6c0 R15: ffff8b24d9d17000
 FS:  0000000000000000(0000) GS:ffff8b52ff980000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00007f0d0e270910 CR3: 00000031a2826002 CR4: 00000000007706e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 PKRU: 55555554
 Call Trace:
  xlog_write+0x567/0x630 [xfs]
  xlog_cil_push_work+0x5bd/0x8d0 [xfs]
  ? load_balance+0x179/0xd60
  ? lock_acquire+0x15d/0x380
  ? lock_release+0x1cd/0x2a0
  ? lock_acquire+0x15d/0x380
  ? lock_release+0x1cd/0x2a0
  ? finish_task_switch.isra.0+0xa0/0x2c0
  process_one_work+0x26e/0x560
  worker_thread+0x52/0x3b0
  ? process_one_work+0x560/0x560
  kthread+0x12c/0x150
  ? __kthread_bind_mask+0x60/0x60
  ret_from_fork+0x22/0x30
 irq event stamp: 0
 hardirqs last  enabled at (0): [<0000000000000000>] 0x0
 hardirqs last disabled at (0): [<ffffffffa10da3f4>] copy_process+0x754/0x1d00
 softirqs last  enabled at (0): [<ffffffffa10da3f4>] copy_process+0x754/0x1d00
 softirqs last disabled at (0): [<0000000000000000>] 0x0
 ---[ end trace 275cd74c3f62be17 ]---

Brian

