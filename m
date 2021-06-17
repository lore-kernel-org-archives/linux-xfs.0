Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30D4BC2B9F4
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 23:31:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1466E61164
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 23:31:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231858AbhFQXd7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Jun 2021 19:33:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27663 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231809AbhFQXd7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Jun 2021 19:33:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623972710;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DPlOPTJCxd/E68MoSHZx+gFqTwGDEistqluKNyYcTas=;
        b=NlpBWdcmeEHS3nxn4Lmdv7ySD/DARDom8fRSoqPKR4wcAIJ9xLS9S9WjWUF+hLycXJtGgL
        BCFY1eOF2wA/g99OoyUeJaZSAWK5iaED/ZBZS09D9w1Lv/F2Neu8EivMpPfuAIlwbgUp5A
        a+aYv5ag42UD9KuOrLEVe5kGI9HNIvs=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-143-hWk6UIcFMzes58gaN9avOw-1; Thu, 17 Jun 2021 19:31:48 -0400
X-MC-Unique: hWk6UIcFMzes58gaN9avOw-1
Received: by mail-oi1-f198.google.com with SMTP id j20-20020aca17140000b02901f3ef48ce7dso3808349oii.12
        for <linux-xfs@vger.kernel.org>; Thu, 17 Jun 2021 16:31:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DPlOPTJCxd/E68MoSHZx+gFqTwGDEistqluKNyYcTas=;
        b=HJtuYjLHWqJCPgEtcYCMjDxQ+IkHrrXwBCU/1Usn6F74eJbkaf21bw0Z+T6r+enUKW
         uLZhdCY2dHNKXKizrD1XPnK1Ve47DjiP0eM9uro5yYu1EPjXz3kZTj9FZtHcH4aWbkt/
         JHHEfCuGkWBB82REE+3/v+/q5KyxveKNFkDHR45qNq5IVitfRaqPbkzGthuq1UdfK7IW
         883k3z5rQvnxm6Tn4atNSInfUWMtK6HQN9yDJUWjCRmLaCluSM/v7ldLv4SWHF/jwdLp
         HP6jge3zcwzJwg8n7jCnDgEtMEGY2wyiEPrdE21tzC8dHsyv0gDKO7vgwek8fk8tEdCI
         GiHw==
X-Gm-Message-State: AOAM533L86qpeXMGEBn74xU+ZDMR6UcBeEN8Ppl4QlWccdsJpbdKUyTG
        akH3L0mcc6pFOCO5ad+xHUDWnRrWAw7sMxkK3oFCD9gyFO1v7Gz6ueS+RHl3X89jbywOGdlc472
        +q6w6Q3h48w4ZrXqBK77Q
X-Received: by 2002:aca:dfc2:: with SMTP id w185mr5129881oig.91.1623972708102;
        Thu, 17 Jun 2021 16:31:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxlNQwD0oSwCR10Rz6kwmjAS99EX463l/FB7uMacdtGeKm0TMxQb0Q0qX7rWgRiTrwUsdJskg==
X-Received: by 2002:aca:dfc2:: with SMTP id w185mr5129871oig.91.1623972707902;
        Thu, 17 Jun 2021 16:31:47 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id h17sm1096625oop.21.2021.06.17.16.31.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jun 2021 16:31:47 -0700 (PDT)
Date:   Thu, 17 Jun 2021 19:31:45 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/8 V2] xfs: log fixes for for-next
Message-ID: <YMvbYbz/qO1qWJ1Z@bfoster>
References: <20210617082617.971602-1-david@fromorbit.com>
 <YMuVPgmEjwaGTaFA@bfoster>
 <20210617190519.GV158209@locust>
 <YMurQCySJ/AlVlVM@bfoster>
 <20210617202642.GY158209@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210617202642.GY158209@locust>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 17, 2021 at 01:26:42PM -0700, Darrick J. Wong wrote:
> On Thu, Jun 17, 2021 at 04:06:24PM -0400, Brian Foster wrote:
> > On Thu, Jun 17, 2021 at 12:05:19PM -0700, Darrick J. Wong wrote:
> > > On Thu, Jun 17, 2021 at 02:32:30PM -0400, Brian Foster wrote:
> > > > On Thu, Jun 17, 2021 at 06:26:09PM +1000, Dave Chinner wrote:
> > > > > Hi folks,
> > > > > 
> > > > > This is followup from the first set of log fixes for for-next that
> > > > > were posted here:
> > > > > 
> > > > > https://lore.kernel.org/linux-xfs/20210615175719.GD158209@locust/T/#mde2cf0bb7d2ac369815a7e9371f0303efc89f51b
> > > > > 
> > > > > The first two patches of this series are updates for those patches,
> > > > > change log below. The rest is the fix for the bigger issue we
> > > > > uncovered in investigating the generic/019 failures, being that
> > > > > we're triggering a zero-day bug in the way log recovery assigns LSNs
> > > > > to checkpoints.
> > > > > 
> > > > > The "simple" fix of using the same ordering code as the commit
> > > > > record for the start records in the CIL push turned into a lot of
> > > > > patches once I started cleaning it up, separating out all the
> > > > > different bits and finally realising all the things I needed to
> > > > > change to avoid unintentional logic/behavioural changes. Hence
> > > > > there's some code movement, some factoring, API changes to
> > > > > xlog_write(), changing where we attach callbacks to commit iclogs so
> > > > > they remain correctly ordered if there are multiple commit records
> > > > > in the one iclog and then, finally, strictly ordering the start
> > > > > records....
> > > > > 
> > > > > The original "simple fix" I tested last night ran almost a thousand
> > > > > cycles of generic/019 without a log hang or recovery failure of any
> > > > > kind. The refactored patchset has run a couple hundred cycles of
> > > > > g/019 and g/475 over the last few hours without a failure, so I'm
> > > > > posting this so we can get a review iteration done while I sleep so
> > > > > we can - hopefully - get this sorted out before the end of the week.
> > > > > 
> > > > 
> > > > My first spin of this included generic/019 and generic/475, ran for 18
> > > > or so iterations and 475 exploded with a stream of asserts followed by a
> > > > NULL pointer crash:
> > > > 
> > > > # grep -e Assertion -e BUG dmesg.out
> > > > ...
> > > > [ 7951.878058] XFS: Assertion failed: atomic_read(&buip->bui_refcount) > 0, file: fs/xfs/xfs_bmap_item.c, line: 57
> > > > [ 7952.261251] XFS: Assertion failed: atomic_read(&buip->bui_refcount) > 0, file: fs/xfs/xfs_bmap_item.c, line: 57
> > > > [ 7952.644444] XFS: Assertion failed: atomic_read(&buip->bui_refcount) > 0, file: fs/xfs/xfs_bmap_item.c, line: 57
> > > > [ 7953.027626] XFS: Assertion failed: atomic_read(&buip->bui_refcount) > 0, file: fs/xfs/xfs_bmap_item.c, line: 57
> > > > [ 7953.410804] BUG: kernel NULL pointer dereference, address: 000000000000031f
> > > > [ 7954.118973] BUG: unable to handle page fault for address: ffffa57ccf99fa98
> > > > 
> > > > I don't know if this is a regression, but I've not seen it before. I've
> > > > attempted to spin generic/475 since then to see if it reproduces again,
> > > > but so far I'm only running into some of the preexisting issues
> > > > associated with that test.
> > > 
> > > By any chance, do the two log recovery fixes I sent yesterday make those
> > > problems go away?
> > > 
> > 
> > Hadn't got to those ones yet...
> 
> <nod>
> 
> > > > I'll let it go a while more and probably
> > > > switch it back to running both sometime before the end of the day for an
> > > > overnight test.
> > > 
> > > Also, do the CIL livelocks go away if you apply only patches 1-2?
> > > 
> > 
> > It's kind of hard to discern the effect of individual fixes when
> > multiple corruptions are at play. :/ I suppose I could switch up my
> > planned overnight test to include the aforementioned 2 recovery fixes
> > and 1-2 from this series, if that is preferable..?
> 
> I dunno about overnight, but at least ~20 or so iterations?
> 
> > I suspect that would
> > leave around the originally reported generic/019 corruption presumably
> > caused by the start LSN ordering issue, but we could see if the deadlock
> > is addressed and whether 475 survives any longer.
> 
> Might be a useful data point to figure out if these pieces are separate
> or if they really do belong in an 8 patch series, since I think ~20 or
> so iterations shouldn't take too long (though I guess it is nearly 16:30
> your time, isn't it...)  Well, do whatever you think is best use of
> machine time.
> 

With the above combination of the first two patches in this series and
your two separate patches, I see no occurrence of a hang in ~50 iters of
generic/019 and do hit the preexisting generic/475 corruption in ~20
iters.

Brian

> --D
> 
> > 
> > Brian
> > 
> > > > A full copy of the assert and NULL pointer BUG splat is included below
> > > > for reference. It looks like the fault BUG splat ended up interspersed
> > > > or otherwise mangled, but I suspect that one is just fallout from the
> > > > immediately previous crash.
> > > 
> > > I have a question about the composition of this 8-patch series --
> > > which patches fix the new cil code, and which ones fix the out of order
> > > recovery problems?  I suspect that patches 1-2 are for the new CIL code,
> > > and 3-8 are to fix the recovery problems.
> > > 
> > > Thinking with my distro kernel not-maintainer hat on, I'm considering
> > > how to backport whatever fixes emerge for the recovery ordering issue
> > > into existing kernels.  The way I see things right now, the CIL changes
> > > (+ fixes) and the ordering bug fixes are separate issues.  The log
> > > ordering problems should get fixed as soon as we have a practical
> > > solution; the CIL changes could get deferred if need be since it's a
> > > medium-high risk; and the real question is how to sequence all this?
> > > 
> > > (Or to put it another way: I'm still stuck going "oh wowwww this is a
> > > lot more change" while trying to understand patch 4)
> > > 
> > > --D
> > > 
> > > > 
> > > > Brian
> > > > 
> > > > --- 8< ---
> > > > 
> > > > [ 7953.027626] XFS: Assertion failed: atomic_read(&buip->bui_refcount) > 0, file: fs/xfs/xfs_bmap_item.c, line: 57
> > > > [ 7953.037737] ------------[ cut here ]------------
> > > > [ 7953.042358] WARNING: CPU: 0 PID: 131627 at fs/xfs/xfs_message.c:112 assfail+0x25/0x28 [xfs]
> > > > [ 7953.050782] Modules linked in: rfkill dm_service_time dm_multipath scsi_dh_rdac scsi_dh_emc scsi_dh_alua rpcrdma sunrpc rdma_ucm ib_srpt ib_isert iscsi_target_mod target_core_mod ib_iser libiscsi scsi_transport_iscsi rdma_cm ib_umad ib_ipoib iw_cm ib_cm mlx5_ib intel_rapl_msr intel_rapl_common isst_if_common ib_uverbs ib_core skx_edac nfit libnvdimm x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel mlx5_core kvm ipmi_ssif iTCO_wdt intel_pmc_bxt irqbypass iTCO_vendor_support rapl acpi_ipmi intel_cstate psample intel_uncore mei_me wmi_bmof ipmi_si pcspkr mlxfw i2c_i801 tg3 pci_hyperv_intf mei lpc_ich intel_pch_thermal ipmi_devintf i2c_smbus ipmi_msghandler acpi_power_meter fuse zram ip_tables xfs lpfc mgag200 drm_kms_helper nvmet_fc nvmet cec nvme_fc crct10dif_pclmul crc32_pclmul nvme_fabrics drm crc32c_intel nvme_core ghash_clmulni_intel scsi_transport_fc megaraid_sas i2c_algo_bit wmi
> > > > [ 7953.129548] CPU: 0 PID: 131627 Comm: kworker/u161:5 Tainted: G        W I       5.13.0-rc4+ #70
> > > > [ 7953.138243] Hardware name: Dell Inc. PowerEdge R740/01KPX8, BIOS 1.6.11 11/20/2018
> > > > [ 7953.145818] Workqueue: xfs-cil/dm-7 xlog_cil_push_work [xfs]
> > > > [ 7953.151554] RIP: 0010:assfail+0x25/0x28 [xfs]
> > > > [ 7953.155991] Code: ff ff 0f 0b c3 0f 1f 44 00 00 41 89 c8 48 89 d1 48 89 f2 48 c7 c6 d8 eb c3 c0 e8 cf fa ff ff 80 3d f1 d4 0a 00 00 74 02 0f 0b <0f> 0b c3 48 8d 45 10 48 89 e2 4c 89 e6 48 89 1c 24 48 89 44 24 18
> > > > [ 7953.174745] RSP: 0018:ffffa57ccf99fa50 EFLAGS: 00010246
> > > > [ 7953.179982] RAX: 00000000ffffffea RBX: 0000000500003977 RCX: 0000000000000000
> > > > [ 7953.187121] RDX: 00000000ffffffc0 RSI: 0000000000000000 RDI: ffffffffc0c300e2
> > > > [ 7953.194264] RBP: ffff91f685725040 R08: 0000000000000000 R09: 000000000000000a
> > > > [ 7953.201405] R10: 000000000000000a R11: f000000000000000 R12: ffff91f685725040
> > > > [ 7953.208546] R13: 0000000000000000 R14: ffff91f66abed140 R15: ffff91c76dfccb40
> > > > [ 7953.215686] FS:  0000000000000000(0000) GS:ffff91f580800000(0000) knlGS:0000000000000000
> > > > [ 7953.223781] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > > [ 7953.229533] CR2: 00000000020e2108 CR3: 0000003d02826003 CR4: 00000000007706f0
> > > > [ 7953.236667] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > > > [ 7953.243809] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > > > [ 7953.250949] PKRU: 55555554
> > > > [ 7953.253669] Call Trace:
> > > > [ 7953.256123]  xfs_bui_release+0x4b/0x50 [xfs]
> > > > [ 7953.260466]  xfs_trans_committed_bulk+0x158/0x2c0 [xfs]
> > > > [ 7953.265762]  ? lock_release+0x1cd/0x2a0
> > > > [ 7953.269610]  ? _raw_spin_unlock+0x1f/0x30
> > > > [ 7953.273630]  ? xlog_write+0x1e2/0x630 [xfs]
> > > > [ 7953.277886]  ? lock_acquire+0x15d/0x380
> > > > [ 7953.281732]  ? lock_acquire+0x15d/0x380
> > > > [ 7953.285582]  ? lock_release+0x1cd/0x2a0
> > > > [ 7953.289428]  ? trace_hardirqs_on+0x1b/0xd0
> > > > [ 7953.293536]  ? _raw_spin_unlock_irqrestore+0x37/0x40
> > > > [ 7953.298511]  ? __wake_up_common_lock+0x7a/0x90
> > > > [ 7953.302966]  ? lock_release+0x1cd/0x2a0
> > > > [ 7953.306813]  xlog_cil_committed+0x34f/0x390 [xfs]
> > > > [ 7953.311593]  ? xlog_cil_push_work+0x715/0x8d0 [xfs]
> > > > [ 7953.316547]  xlog_cil_push_work+0x740/0x8d0 [xfs]
> > > > [ 7953.321321]  ? _raw_spin_unlock_irq+0x24/0x40
> > > > [ 7953.325689]  ? finish_task_switch.isra.0+0xa0/0x2c0
> > > > [ 7953.330580]  ? kmem_cache_free+0x247/0x5c0
> > > > [ 7953.334685]  ? fsnotify_final_mark_destroy+0x1c/0x30
> > > > [ 7953.339658]  ? lock_acquire+0x15d/0x380
> > > > [ 7953.343505]  ? lock_acquire+0x15d/0x380
> > > > [ 7953.347353]  ? lock_release+0x1cd/0x2a0
> > > > [ 7953.351203]  process_one_work+0x26e/0x560
> > > > [ 7953.355225]  worker_thread+0x52/0x3b0
> > > > [ 7953.358898]  ? process_one_work+0x560/0x560
> > > > [ 7953.363094]  kthread+0x12c/0x150
> > > > [ 7953.366335]  ? __kthread_bind_mask+0x60/0x60
> > > > [ 7953.370617]  ret_from_fork+0x22/0x30
> > > > [ 7953.374206] irq event stamp: 0
> > > > [ 7953.377268] hardirqs last  enabled at (0): [<0000000000000000>] 0x0
> > > > [ 7953.383544] hardirqs last disabled at (0): [<ffffffffb50da3f4>] copy_process+0x754/0x1d00
> > > > [ 7953.391724] softirqs last  enabled at (0): [<ffffffffb50da3f4>] copy_process+0x754/0x1d00
> > > > [ 7953.399907] softirqs last disabled at (0): [<0000000000000000>] 0x0
> > > > [ 7953.406179] ---[ end trace f04c960f66265f3a ]---
> > > > [ 7953.410804] BUG: kernel NULL pointer dereference, address: 000000000000031f
> > > > [ 7953.417760] #PF: supervisor read access in kernel mode
> > > > [ 7953.422900] #PF: error_code(0x0000) - not-present page
> > > > [ 7953.428038] PGD 0 P4D 0 
> > > > [ 7953.430579] Oops: 0000 [#1] SMP PTI
> > > > [ 7953.434070] CPU: 0 PID: 131627 Comm: kworker/u161:5 Tainted: G        W I       5.13.0-rc4+ #70
> > > > [ 7953.442764] Hardware name: Dell Inc. PowerEdge R740/01KPX8, BIOS 1.6.11 11/20/2018
> > > > [ 7953.450330] Workqueue: xfs-cil/dm-7 xlog_cil_push_work [xfs]
> > > > [ 7953.456058] RIP: 0010:xfs_trans_committed_bulk+0xcc/0x2c0 [xfs]
> > > > [ 7953.462036] Code: 41 83 c5 01 48 89 54 c4 50 41 83 fd 1f 0f 8f 11 01 00 00 4d 8b 36 4c 3b 34 24 74 28 4d 8b 66 20 40 84 ed 75 54 49 8b 44 24 60 <f6> 00 01 74 91 48 8b 40 38 4c 89 e7 e8 63 6b 42 f5 4d 8b 36 4c 3b
> > > > [ 7953.480783] RSP: 0018:ffffa57ccf99fa68 EFLAGS: 00010202
> > > > [ 7953.486009] RAX: 000000000000031f RBX: 0000000500003977 RCX: 0000000000000000
> > > > [ 7953.493141] RDX: 00000000ffffffc0 RSI: 0000000000000000 RDI: ffffffffc0c300e2
> > > > [ 7953.500274] RBP: 0000000000000001 R08: 0000000000000000 R09: 000000000000000a
> > > > [ 7953.507404] R10: 000000000000000a R11: f000000000000000 R12: ffff91c759fedb20
> > > > [ 7953.514536] R13: 0000000000000000 R14: ffff91c759fedb00 R15: ffff91c76dfccb40
> > > > [ 7953.521671] FS:  0000000000000000(0000) GS:ffff91f580800000(0000) knlGS:0000000000000000
> > > > [ 7953.529757] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > > [ 7953.535501] CR2: 000000000000031f CR3: 0000003d02826003 CR4: 00000000007706f0
> > > > [ 7953.542633] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > > > [ 7953.549768] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > > > [ 7953.556899] PKRU: 55555554
> > > > [ 7953.559612] Call Trace:
> > > > [ 7953.562064]  ? lock_release+0x1cd/0x2a0
> > > > [ 7953.565902]  ? _raw_spin_unlock+0x1f/0x30
> > > > [ 7953.569917]  ? xlog_write+0x1e2/0x630 [xfs]
> > > > [ 7953.574162]  ? lock_acquire+0x15d/0x380
> > > > [ 7953.578000]  ? lock_acquire+0x15d/0x380
> > > > [ 7953.581841]  ? lock_release+0x1cd/0x2a0
> > > > [ 7953.585680]  ? trace_hardirqs_on+0x1b/0xd0
> > > > [ 7953.589780]  ? _raw_spin_unlock_irqrestore+0x37/0x40
> > > > [ 7953.594744]  ? __wake_up_common_lock+0x7a/0x90
> > > > [ 7953.599192]  ? lock_release+0x1cd/0x2a0
> > > > [ 7953.603031]  xlog_cil_committed+0x34f/0x390 [xfs]
> > > > [ 7953.607798]  ? xlog_cil_push_work+0x715/0x8d0 [xfs]
> > > > [ 7953.612738]  xlog_cil_push_work+0x740/0x8d0 [xfs]
> > > > [ 7953.617504]  ? _raw_spin_unlock_irq+0x24/0x40
> > > > [ 7953.621862]  ? finish_task_switch.isra.0+0xa0/0x2c0
> > > > [ 7953.626745]  ? kmem_cache_free+0x247/0x5c0
> > > > [ 7953.630839]  ? fsnotify_final_mark_destroy+0x1c/0x30
> > > > [ 7953.635806]  ? lock_acquire+0x15d/0x380
> > > > [ 7953.639646]  ? lock_acquire+0x15d/0x380
> > > > [ 7953.643484]  ? lock_release+0x1cd/0x2a0
> > > > [ 7953.647323]  process_one_work+0x26e/0x560
> > > > [ 7953.651337]  worker_thread+0x52/0x3b0
> > > > [ 7953.655003]  ? process_one_work+0x560/0x560
> > > > [ 7953.659188]  kthread+0x12c/0x150
> > > > [ 7953.662421]  ? __kthread_bind_mask+0x60/0x60
> > > > [ 7953.666694]  ret_from_fork+0x22/0x30
> > > > [ 7953.670273] Modules linked in: rfkill dm_service_time dm_multipath scsi_dh_rdac scsi_dh_emc scsi_dh_alua rpcrdma sunrpc rdma_ucm ib_srpt ib_isert iscsi_target_mod target_core_mod ib_iser libiscsi scsi_transport_iscsi rdma_cm ib_umad ib_ipoib iw_cm ib_cm mlx5_ib intel_rapl_msr intel_rapl_common isst_if_common ib_uverbs ib_core skx_edac nfit libnvdimm x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel mlx5_core kvm ipmi_ssif iTCO_wdt intel_pmc_bxt irqbypass iTCO_vendor_support rapl acpi_ipmi intel_cstate psample intel_uncore mei_me wmi_bmof ipmi_si pcspkr mlxfw i2c_i801 tg3 pci_hyperv_intf mei lpc_ich intel_pch_thermal ipmi_devintf i2c_smbus ipmi_msghandler acpi_power_meter fuse zram ip_tables xfs lpfc mgag200 drm_kms_helper nvmet_fc nvmet cec nvme_fc crct10dif_pclmul crc32_pclmul nvme_fabrics drm crc32c_intel nvme_core ghash_clmulni_intel scsi_transport_fc megaraid_sas i2c_algo_bit wmi
> > > > [ 7953.749025] CR2: 000000000000031f
> > > > [ 7953.752345] ---[ end trace f04c960f66265f3b ]---
> > > > 
> > > 
> > 
> 

