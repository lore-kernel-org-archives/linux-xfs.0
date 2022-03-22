Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 142A1C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Mar 2022 14:33:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237057AbiCVOeg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Mar 2022 10:34:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237267AbiCVOee (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Mar 2022 10:34:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4B19737016
        for <linux-xfs@vger.kernel.org>; Tue, 22 Mar 2022 07:33:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647959585;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KAdD/+ldRUYo9+WBLoC2PRd2H4mVBpMr9RbtdPpwNTs=;
        b=h9MRMJ61VAu8X4S7nOwa+Acun3tSUFPRvfRn4Ef30QeGalnh3VRQKGdL240F058Tb+Dqwn
        N1rB6tt2wPoy+GsznvDbp9hotuaSlR2J20cFJ9tlCo8QzRfKyYI020S8UIX+Emkrso1VR7
        aW6Bv8xkU3Yyw30ApDy7iaR+UiM6nFA=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-417-ovofmiotPlqALgAXyXbNXA-1; Tue, 22 Mar 2022 10:33:04 -0400
X-MC-Unique: ovofmiotPlqALgAXyXbNXA-1
Received: by mail-qk1-f200.google.com with SMTP id q5-20020a05620a0d8500b004738c1b48beso11906858qkl.7
        for <linux-xfs@vger.kernel.org>; Tue, 22 Mar 2022 07:33:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=KAdD/+ldRUYo9+WBLoC2PRd2H4mVBpMr9RbtdPpwNTs=;
        b=0NotpGRzfysFDdrUE9oXOAtuegHTVMvPAcE06gnH4gXQImHAnhR60zM6RLNSz8A8Y4
         KVzZeWFqIxXJZT+zgaqZUifTxDnR2Ui89AVpw2PfijAi/Q5Q9VIYL1eOQ6iTMFE9L87V
         qdQT2XgmloEx47OWwlyHohIDsKlFSTizgLMT6oSi4PGipkvWZ04OHD/jjvzO2vvY0YCx
         gqKwOegTgeZMYa783O3MJCDBf3NWm3qHe5zw82vYxv0GfZye9P2bekN48AUYbvLM80/z
         Mq68bpCOqgRuCKTDpGl6dEjxzQTrBCcoSnmS+cEyIW3AFlF/gMtxdHNPysjyyQVxPe+J
         PETQ==
X-Gm-Message-State: AOAM532olCm6n/5ZmanwSg46Pi4xvVpmUE7AMZY561wzRwa1LRqOEh5r
        XXPqKI3AjsUYU2jhy8xi8OsJDB5xuyWn3o/ZcpP9a1OnQf1vkGsD1CHCsc1/+4pEcUNcN5Kwbup
        B1Gu11PY4mGSEW67jgxBt
X-Received: by 2002:a0c:c38d:0:b0:42c:1a57:24d2 with SMTP id o13-20020a0cc38d000000b0042c1a5724d2mr19474877qvi.1.1647959583195;
        Tue, 22 Mar 2022 07:33:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxNnxo8b6Bw/nib3eDSIbZ4murNlNX2wu45wXi6Edu5UMsUxzG4iZ8oeCnOO5YZ0jyI7xU2jw==
X-Received: by 2002:a0c:c38d:0:b0:42c:1a57:24d2 with SMTP id o13-20020a0cc38d000000b0042c1a5724d2mr19474835qvi.1.1647959582583;
        Tue, 22 Mar 2022 07:33:02 -0700 (PDT)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id w1-20020ac857c1000000b002e1e899badesm13961650qta.72.2022.03.22.07.33.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 07:33:02 -0700 (PDT)
Date:   Tue, 22 Mar 2022 10:33:00 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [BUG] log I/O completion GPF via xfs/006 and xfs/264 on
 5.17.0-rc8
Message-ID: <YjneHEoFRDXu+EcA@bfoster>
References: <YjSNTd+U3HBq/Gsv@bfoster>
 <YjSvG0wgm6epCa8X@bfoster>
 <20220318214253.GG1544202@dread.disaster.area>
 <YjjFaU/uGHALNVlx@bfoster>
 <20220321221433.GJ1544202@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20220321221433.GJ1544202@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 22, 2022 at 09:14:33AM +1100, Dave Chinner wrote:
> On Mon, Mar 21, 2022 at 02:35:21PM -0400, Brian Foster wrote:
> > On Sat, Mar 19, 2022 at 08:42:53AM +1100, Dave Chinner wrote:
> > > On Fri, Mar 18, 2022 at 12:11:07PM -0400, Brian Foster wrote:
> > > > On Fri, Mar 18, 2022 at 09:46:53AM -0400, Brian Foster wrote:
> > > > > Hi,
> > > > >=20
> > > > > I'm not sure if this is known and/or fixed already, but it didn't=
 look
> > > > > familiar so here is a report. I hit a splat when testing Willy's
> > > > > prospective folio bookmark change and it turns out it replicates =
on
> > > > > Linus' current master (551acdc3c3d2). This initially reproduced on
> > > > > xfs/264 (mkfs defaults) and I saw a soft lockup warning variant v=
ia
> > > > > xfs/006, but when I attempted to reproduce the latter a second ti=
me I
> > > > > hit what looks like the same problem as xfs/264. Both tests seem =
to
> > > > > involve some form of error injection, so possibly the same underl=
ying
> > > > > problem. The GPF splat from xfs/264 is below.
> > > > >=20
> > > >=20
> > > > Darrick pointed out this [1] series on IRC (particularly the final
> > > > patch) so I gave that a try. I _think_ that addresses the GPF issue
> > > > given it was nearly 100% reproducible before and I didn't see it in=
 a
> > > > few iterations, but once I started a test loop for a longer test I =
ran
> > > > into the aforementioned soft lockup again. A snippet of that one is
> > > > below [2]. When this occurs, the task appears to be stuck (i.e. the
> > > > warning repeats) indefinitely.
> > > >=20
> > > > Brian
> > > >=20
> > > > [1] https://lore.kernel.org/linux-xfs/20220317053907.164160-1-david=
@fromorbit.com/
> > > > [2] Soft lockup warning from xfs/264 with patches from [1] applied:
> > > >=20
> > > > watchdog: BUG: soft lockup - CPU#52 stuck for 134s! [kworker/52:1H:=
1881]
> > > > Modules linked in: rfkill rpcrdma sunrpc intel_rapl_msr intel_rapl_=
common rdma_ucm ib_srpt ib_isert iscsi_target_mod i10nm_edac target_core_mo=
d x86_pkg_temp_thermal intel_powerclamp ib_iser coretemp libiscsi scsi_tran=
sport_iscsi kvm_intel rdma_cm ib_umad ipmi_ssif ib_ipoib iw_cm ib_cm kvm iT=
CO_wdt iTCO_vendor_support irqbypass crct10dif_pclmul crc32_pclmul acpi_ipm=
i mlx5_ib ghash_clmulni_intel bnxt_re ipmi_si rapl intel_cstate ib_uverbs i=
pmi_devintf mei_me isst_if_mmio isst_if_mbox_pci i2c_i801 nd_pmem ib_core i=
ntel_uncore wmi_bmof pcspkr isst_if_common mei i2c_smbus intel_pch_thermal =
ipmi_msghandler nd_btt dax_pmem acpi_power_meter xfs libcrc32c sd_mod sg ml=
x5_core lpfc mgag200 i2c_algo_bit drm_shmem_helper nvmet_fc drm_kms_helper =
nvmet nvme_fc mlxfw nvme_fabrics syscopyarea sysfillrect pci_hyperv_intf sy=
simgblt fb_sys_fops nvme_core ahci tls t10_pi libahci crc32c_intel psample =
scsi_transport_fc bnxt_en drm megaraid_sas tg3 libata wmi nfit libnvdimm dm=
_mirror dm_region_hash
> > > >  dm_log dm_mod
> > > > CPU: 52 PID: 1881 Comm: kworker/52:1H Tainted: G S           L    5=
=2E17.0-rc8+ #17
> > > > Hardware name: Dell Inc. PowerEdge R750/06V45N, BIOS 1.2.4 05/28/20=
21
> > > > Workqueue: xfs-log/dm-5 xlog_ioend_work [xfs]
> > > > RIP: 0010:native_queued_spin_lock_slowpath+0x1b0/0x1e0
> > > > Code: c1 e9 12 83 e0 03 83 e9 01 48 c1 e0 05 48 63 c9 48 05 40 0d 0=
3 00 48 03 04 cd e0 ba 00 8c 48 89 10 8b 42 08 85 c0 75 09 f3 90 <8b> 42 08=
 85 c0 74 f7 48 8b 0a 48 85 c9 0f 84 6b ff ff ff 0f 0d 09
> > > > RSP: 0018:ff4ed0b360e4bb48 EFLAGS: 00000246
> > > > RAX: 0000000000000000 RBX: ff3413f05c684540 RCX: 0000000000001719
> > > > RDX: ff34142ebfeb0d40 RSI: ffffffff8bf826f6 RDI: ffffffff8bf54147
> > > > RBP: ff34142ebfeb0d40 R08: ff34142ebfeb0a68 R09: 00000000000001bc
> > > > R10: 00000000000001d1 R11: 0000000000000abd R12: 0000000000d40000
> > > > R13: 0000000000000008 R14: ff3413f04cd84000 R15: ff3413f059404400
> > > > FS:  0000000000000000(0000) GS:ff34142ebfe80000(0000) knlGS:0000000=
000000000
> > > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > > CR2: 00007f9200514f70 CR3: 0000000216c16005 CR4: 0000000000771ee0
> > > > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > > > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > > > PKRU: 55555554
> > > > Call Trace:
> > > >  <TASK>
> > > >  _raw_spin_lock+0x2c/0x30
> > > >  xfs_trans_ail_delete+0x2a/0xd0 [xfs]
> > >=20
> > > So what is running around in a tight circle holding the AIL lock?
> > >=20
> > > Or what assert failed before this while holding the AIL lock?
> > >=20
> >=20
> > I don't have much information beyond the test and resulting bug. There
> > are no assert failures before the bug occurs. An active CPU task dump
> > shows the stack from the soft lockup warning, the task running the dump
> > itself, and all other (94/96) CPUs appear idle. I tried the appended
> > patch on top of latest for-next (which now includes the other log
> > shutdown fix) and the problem still occurs.
>=20
> Yeah, I got another assert fail in xfs_ail_check() last night from:
>=20
>   xfs_ail_check+0xa8/0x180
>   xfs_ail_delete_one+0x3b/0xf0
>   xfs_buf_inode_iodone+0x329/0x3f0
>   xfs_buf_ioend+0x1f8/0x530
>   xfs_buf_ioend_work+0x15/0x20
>=20
> Finding an item that didn't have IN_AIL set on it. I think I've
> found another mount vs log shutdown case that can result in dirty
> aborted inodes that aren't in the AIL being flushed and bad things
> happen when we then try to remove them from the AIL and they aren't
> there...
>=20
> Whether that is this problem or not, I don't know, but the assert
> failures do end up with other threads spinning on the AIL lock
> because of the assert failures under the AIL lock...
>=20

Some updates.. I tried to reproduce with lock debugging and whatnot
enabled but the problem was no longer reproducible, probably due to
disruption of timing. When I went back to a reproducing kernel, I ended
up seeing a page fault variant crash via xfs/006 instead of the soft
lockup. This occurred shortly after the unmount attempt started, so I
retried again with KASAN enabled but ran into the same heisenbug
behavior. From there, I replaced the generic debug mechanisms with a
custom mount flag to set in xfs_trans_ail_destroy() immediately after
freeing the xfs_ail object and assert check on entry of
xfs_trans_ail_delete(). The next xfs/006 failure produced the splat
below [2]. I suspect that is the smoking gun [1] and perhaps we've
somehow broken serialization between in-core object teardown and
outstanding log I/O completion after the filesystem happens to shutdown.

Brian

[1] I've not reproduced the soft lockup variant with this hack in place,
but if the problem is a UAF then I'd expect the resulting behavior to be
somewhat erratic/unpredictable.

[2] xfs/006 custom assert and BUG splat:

XFS: Assertion failed: !mp->m_freed_ail, file: fs/xfs/xfs_trans_ail.c, line=
: 879
------------[ cut here ]------------
WARNING: CPU: 2 PID: 1289 at fs/xfs/xfs_message.c:97 asswarn+0x1a/0x1d [xfs]
Modules linked in: rfkill rpcrdma sunrpc rdma_ucm ib_srpt ib_isert iscsi_ta=
rget_mod target_core_mod ib_iser libiscsi scsi_transport_iscsi ib_umad rdma=
_cm ib_ipoib iw_cm ib_cm intel_rapl_msr iTCO_wdt iTCO_vendor_support inth
 dm_log dm_mod
CPU: 2 PID: 1289 Comm: kworker/2:1H Tainted: G S                5.17.0-rc6+=
 #29
Hardware name: Dell Inc. PowerEdge R750/06V45N, BIOS 1.2.4 05/28/2021
Workqueue: xfs-log/dm-5 xlog_ioend_work [xfs]
RIP: 0010:asswarn+0x1a/0x1d [xfs]
Code: e8 e8 13 8c c4 48 83 c4 60 5b 41 5c 41 5d 5d c3 0f 1f 44 00 00 41 89 =
c8 48 89 d1 48 89 f2 48 c7 c6 c0 a0 d8 c0 e8 19 fd ff ff <0f> 0b c3 0f 1f 4=
4 00 00 41 89 c8 48 89 d1 48 89 f2 48 c7 c6 c0 a0
RSP: 0018:ff5757be8f37fb70 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ff4847238f4b2940 RCX: 0000000000000000
RDX: 00000000ffffffc0 RSI: 000000000000000a RDI: ffffffffc0d7e076
RBP: ff4847341d6a0f80 R08: 0000000000000000 R09: 0000000000000000
R10: 000000000000000a R11: f000000000000000 R12: 0000000200002600
R13: ff484724b1c35000 R14: 0000000000000008 R15: ff4847238f4b2940
FS:  0000000000000000(0000) GS:ff484761ffc40000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f55c21f0f70 CR3: 0000000142c9c002 CR4: 0000000000771ee0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554
Call Trace:
 <TASK>
 xfs_trans_ail_delete+0x102/0x130 [xfs]
 xfs_buf_item_done+0x22/0x30 [xfs]
 xfs_buf_ioend+0x73/0x4d0 [xfs]
 xfs_trans_committed_bulk+0x17e/0x2f0 [xfs]
 ? enqueue_task_fair+0x91/0x680
 ? remove_entity_load_avg+0x2e/0x70
 ? __wake_up_common_lock+0x87/0xc0
 xlog_cil_committed+0x2a9/0x300 [xfs]
 ? __wake_up_common_lock+0x87/0xc0
 xlog_cil_process_committed+0x69/0x80 [xfs]
 xlog_state_shutdown_callbacks+0xce/0xf0 [xfs]
 xlog_force_shutdown+0xdf/0x150 [xfs]
 xfs_do_force_shutdown+0x5f/0x150 [xfs]
 xlog_ioend_work+0x71/0x80 [xfs]
 process_one_work+0x1c5/0x390
 ? process_one_work+0x390/0x390
 worker_thread+0x30/0x350
 ? process_one_work+0x390/0x390
 kthread+0xd7/0x100
 ? kthread_complete_and_exit+0x20/0x20
 ret_from_fork+0x1f/0x30
 </TASK>
---[ end trace 0000000000000000 ]---
BUG: unable to handle page fault for address: 0000000000030840
#PF: supervisor write access in kernel mode
#PF: error_code(0x0002) - not-present page
PGD 281cd3067 P4D 0=20
Oops: 0002 [#1] PREEMPT SMP NOPTI
CPU: 2 PID: 1289 Comm: kworker/2:1H Tainted: G S      W         5.17.0-rc6+=
 #29
Hardware name: Dell Inc. PowerEdge R750/06V45N, BIOS 1.2.4 05/28/2021
Workqueue: xfs-log/dm-5 xlog_ioend_work [xfs]
RIP: 0010:native_queued_spin_lock_slowpath+0x173/0x1b0
Code: f3 90 48 8b 32 48 85 f6 74 f6 eb d5 c1 ee 12 83 e0 03 83 ee 01 48 c1 =
e0 05 48 63 f6 48 05 00 08 03 00 48 03 04 f5 e0 5a ec 85 <48> 89 10 8b 42 0=
8 85 c0 75 09 f3 90 8b 42 08 85 c0 74 f7 48 8b 32
RSP: 0018:ff5757be8f37fb68 EFLAGS: 00010202
RAX: 0000000000030840 RBX: ff4847238f4b2940 RCX: 00000000000c0000
RDX: ff484761ffc70800 RSI: 0000000000000759 RDI: ff4847341d6a0fc0
RBP: ff4847341d6a0f80 R08: 0000000000000000 R09: 0000000000000000
R10: 000000000000000a R11: f000000000000000 R12: ff4847341d6a0fc0
R13: ff484724b1c35000 R14: 0000000000000008 R15: ff4847238f4b2940
FS:  0000000000000000(0000) GS:ff484761ffc40000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000030840 CR3: 0000000142c9c002 CR4: 0000000000771ee0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554
Call Trace:
 <TASK>
 _raw_spin_lock+0x21/0x30
 xfs_trans_ail_delete+0x38/0x130 [xfs]
 xfs_buf_item_done+0x22/0x30 [xfs]
 xfs_buf_ioend+0x73/0x4d0 [xfs]
 xfs_trans_committed_bulk+0x17e/0x2f0 [xfs]
 ? enqueue_task_fair+0x91/0x680
 ? remove_entity_load_avg+0x2e/0x70
 ? __wake_up_common_lock+0x87/0xc0
 xlog_cil_committed+0x2a9/0x300 [xfs]
 ? __wake_up_common_lock+0x87/0xc0
 xlog_cil_process_committed+0x69/0x80 [xfs]
 xlog_state_shutdown_callbacks+0xce/0xf0 [xfs]
 xlog_force_shutdown+0xdf/0x150 [xfs]
 xfs_do_force_shutdown+0x5f/0x150 [xfs]
 xlog_ioend_work+0x71/0x80 [xfs]
 process_one_work+0x1c5/0x390
 ? process_one_work+0x390/0x390
 worker_thread+0x30/0x350
 ? process_one_work+0x390/0x390
 kthread+0xd7/0x100
 ? kthread_complete_and_exit+0x20/0x20
 ret_from_fork+0x1f/0x30
 </TASK>
Modules linked in: rfkill rpcrdma sunrpc rdma_ucm ib_srpt ib_isert iscsi_ta=
rget_mod target_core_mod ib_iser libiscsi scsi_transport_iscsi ib_umad rdma=
_cm ib_ipoib iw_cm ib_cm intel_rapl_msr iTCO_wdt iTCO_vendor_support inth
 dm_log dm_mod
CR2: 0000000000030840
---[ end trace 0000000000000000 ]---
RIP: 0010:native_queued_spin_lock_slowpath+0x173/0x1b0
Code: f3 90 48 8b 32 48 85 f6 74 f6 eb d5 c1 ee 12 83 e0 03 83 ee 01 48 c1 =
e0 05 48 63 f6 48 05 00 08 03 00 48 03 04 f5 e0 5a ec 85 <48> 89 10 8b 42 0=
8 85 c0 75 09 f3 90 8b 42 08 85 c0 74 f7 48 8b 32
RSP: 0018:ff5757be8f37fb68 EFLAGS: 00010202
RAX: 0000000000030840 RBX: ff4847238f4b2940 RCX: 00000000000c0000
RDX: ff484761ffc70800 RSI: 0000000000000759 RDI: ff4847341d6a0fc0
RBP: ff4847341d6a0f80 R08: 0000000000000000 R09: 0000000000000000
R10: 000000000000000a R11: f000000000000000 R12: ff4847341d6a0fc0
R13: ff484724b1c35000 R14: 0000000000000008 R15: ff4847238f4b2940
FS:  0000000000000000(0000) GS:ff484761ffc40000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000030840 CR3: 0000000142c9c002 CR4: 0000000000771ee0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554
Kernel panic - not syncing: Fatal exception
Kernel Offset: 0x3c00000 from 0xffffffff81000000 (relocation range: 0xfffff=
fff80000000-0xffffffffbfffffff)
---[ end Kernel panic - not syncing: Fatal exception ]---

