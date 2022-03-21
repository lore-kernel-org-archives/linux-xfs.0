Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C926DC433FE
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Mar 2022 22:58:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231925AbiCUXAU convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Mar 2022 19:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232296AbiCUW6M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Mar 2022 18:58:12 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BD0E22F3BD
        for <linux-xfs@vger.kernel.org>; Mon, 21 Mar 2022 15:35:24 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-150-27.pa.vic.optusnet.com.au [49.186.150.27])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 7899B10E4937;
        Tue, 22 Mar 2022 09:14:36 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nWQIL-008HJP-OF; Tue, 22 Mar 2022 09:14:33 +1100
Date:   Tue, 22 Mar 2022 09:14:33 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [BUG] log I/O completion GPF via xfs/006 and xfs/264 on
 5.17.0-rc8
Message-ID: <20220321221433.GJ1544202@dread.disaster.area>
References: <YjSNTd+U3HBq/Gsv@bfoster>
 <YjSvG0wgm6epCa8X@bfoster>
 <20220318214253.GG1544202@dread.disaster.area>
 <YjjFaU/uGHALNVlx@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <YjjFaU/uGHALNVlx@bfoster>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=6238f8cc
        a=sPqof0Mm7fxWrhYUF33ZaQ==:117 a=sPqof0Mm7fxWrhYUF33ZaQ==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=RVpmHM-mVqAyLUFa8RIA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 21, 2022 at 02:35:21PM -0400, Brian Foster wrote:
> On Sat, Mar 19, 2022 at 08:42:53AM +1100, Dave Chinner wrote:
> > On Fri, Mar 18, 2022 at 12:11:07PM -0400, Brian Foster wrote:
> > > On Fri, Mar 18, 2022 at 09:46:53AM -0400, Brian Foster wrote:
> > > > Hi,
> > > > 
> > > > I'm not sure if this is known and/or fixed already, but it didn't look
> > > > familiar so here is a report. I hit a splat when testing Willy's
> > > > prospective folio bookmark change and it turns out it replicates on
> > > > Linus' current master (551acdc3c3d2). This initially reproduced on
> > > > xfs/264 (mkfs defaults) and I saw a soft lockup warning variant via
> > > > xfs/006, but when I attempted to reproduce the latter a second time I
> > > > hit what looks like the same problem as xfs/264. Both tests seem to
> > > > involve some form of error injection, so possibly the same underlying
> > > > problem. The GPF splat from xfs/264 is below.
> > > > 
> > > 
> > > Darrick pointed out this [1] series on IRC (particularly the final
> > > patch) so I gave that a try. I _think_ that addresses the GPF issue
> > > given it was nearly 100% reproducible before and I didn't see it in a
> > > few iterations, but once I started a test loop for a longer test I ran
> > > into the aforementioned soft lockup again. A snippet of that one is
> > > below [2]. When this occurs, the task appears to be stuck (i.e. the
> > > warning repeats) indefinitely.
> > > 
> > > Brian
> > > 
> > > [1] https://lore.kernel.org/linux-xfs/20220317053907.164160-1-david@fromorbit.com/
> > > [2] Soft lockup warning from xfs/264 with patches from [1] applied:
> > > 
> > > watchdog: BUG: soft lockup - CPU#52 stuck for 134s! [kworker/52:1H:1881]
> > > Modules linked in: rfkill rpcrdma sunrpc intel_rapl_msr intel_rapl_common rdma_ucm ib_srpt ib_isert iscsi_target_mod i10nm_edac target_core_mod x86_pkg_temp_thermal intel_powerclamp ib_iser coretemp libiscsi scsi_transport_iscsi kvm_intel rdma_cm ib_umad ipmi_ssif ib_ipoib iw_cm ib_cm kvm iTCO_wdt iTCO_vendor_support irqbypass crct10dif_pclmul crc32_pclmul acpi_ipmi mlx5_ib ghash_clmulni_intel bnxt_re ipmi_si rapl intel_cstate ib_uverbs ipmi_devintf mei_me isst_if_mmio isst_if_mbox_pci i2c_i801 nd_pmem ib_core intel_uncore wmi_bmof pcspkr isst_if_common mei i2c_smbus intel_pch_thermal ipmi_msghandler nd_btt dax_pmem acpi_power_meter xfs libcrc32c sd_mod sg mlx5_core lpfc mgag200 i2c_algo_bit drm_shmem_helper nvmet_fc drm_kms_helper nvmet nvme_fc mlxfw nvme_fabrics syscopyarea sysfillrect pci_hyperv_intf sysimgblt fb_sys_fops nvme_core ahci tls t10_pi libahci crc32c_intel psample scsi_transport_fc bnxt_en drm megaraid_sas tg3 libata wmi nfit libnvdimm dm_mirror dm_region_hash
> > >  dm_log dm_mod
> > > CPU: 52 PID: 1881 Comm: kworker/52:1H Tainted: G S           L    5.17.0-rc8+ #17
> > > Hardware name: Dell Inc. PowerEdge R750/06V45N, BIOS 1.2.4 05/28/2021
> > > Workqueue: xfs-log/dm-5 xlog_ioend_work [xfs]
> > > RIP: 0010:native_queued_spin_lock_slowpath+0x1b0/0x1e0
> > > Code: c1 e9 12 83 e0 03 83 e9 01 48 c1 e0 05 48 63 c9 48 05 40 0d 03 00 48 03 04 cd e0 ba 00 8c 48 89 10 8b 42 08 85 c0 75 09 f3 90 <8b> 42 08 85 c0 74 f7 48 8b 0a 48 85 c9 0f 84 6b ff ff ff 0f 0d 09
> > > RSP: 0018:ff4ed0b360e4bb48 EFLAGS: 00000246
> > > RAX: 0000000000000000 RBX: ff3413f05c684540 RCX: 0000000000001719
> > > RDX: ff34142ebfeb0d40 RSI: ffffffff8bf826f6 RDI: ffffffff8bf54147
> > > RBP: ff34142ebfeb0d40 R08: ff34142ebfeb0a68 R09: 00000000000001bc
> > > R10: 00000000000001d1 R11: 0000000000000abd R12: 0000000000d40000
> > > R13: 0000000000000008 R14: ff3413f04cd84000 R15: ff3413f059404400
> > > FS:  0000000000000000(0000) GS:ff34142ebfe80000(0000) knlGS:0000000000000000
> > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > CR2: 00007f9200514f70 CR3: 0000000216c16005 CR4: 0000000000771ee0
> > > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > > PKRU: 55555554
> > > Call Trace:
> > >  <TASK>
> > >  _raw_spin_lock+0x2c/0x30
> > >  xfs_trans_ail_delete+0x2a/0xd0 [xfs]
> > 
> > So what is running around in a tight circle holding the AIL lock?
> > 
> > Or what assert failed before this while holding the AIL lock?
> > 
> 
> I don't have much information beyond the test and resulting bug. There
> are no assert failures before the bug occurs. An active CPU task dump
> shows the stack from the soft lockup warning, the task running the dump
> itself, and all other (94/96) CPUs appear idle. I tried the appended
> patch on top of latest for-next (which now includes the other log
> shutdown fix) and the problem still occurs.

Yeah, I got another assert fail in xfs_ail_check() last night from:

  xfs_ail_check+0xa8/0x180
  xfs_ail_delete_one+0x3b/0xf0
  xfs_buf_inode_iodone+0x329/0x3f0
  xfs_buf_ioend+0x1f8/0x530
  xfs_buf_ioend_work+0x15/0x20

Finding an item that didn't have IN_AIL set on it. I think I've
found another mount vs log shutdown case that can result in dirty
aborted inodes that aren't in the AIL being flushed and bad things
happen when we then try to remove them from the AIL and they aren't
there...

Whether that is this problem or not, I don't know, but the assert
failures do end up with other threads spinning on the AIL lock
because of the assert failures under the AIL lock...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
