Return-Path: <SRS0=uP9V=ZB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCD8CC43331
	for <linux-xfs@archiver.kernel.org>; Sat,  9 Nov 2019 22:38:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7AEA9206DF
	for <linux-xfs@archiver.kernel.org>; Sat,  9 Nov 2019 22:38:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726135AbfKIWik convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 Nov 2019 17:38:40 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:50572 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726448AbfKIWik (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 Nov 2019 17:38:40 -0500
Received: from dread.disaster.area (pa49-180-67-183.pa.nsw.optusnet.com.au [49.180.67.183])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id A7B6F7EA7E9;
        Sun, 10 Nov 2019 09:38:36 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1iTZNL-0007ZA-M9; Sun, 10 Nov 2019 09:38:35 +1100
Date:   Sun, 10 Nov 2019 09:38:35 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Arkadiusz =?utf-8?Q?Mi=C5=9Bkiewicz?= <a.miskiewicz@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: WARNING: CPU: 5 PID: 25802 at fs/xfs/libxfs/xfs_bmap.c:4530
 xfs_bmapi_convert_delalloc+0x434/0x4a0 [xfs]
Message-ID: <20191109223835.GI4614@dread.disaster.area>
References: <3c58ebc4-ff95-b443-b08d-81f5169d3d01@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <3c58ebc4-ff95-b443-b08d-81f5169d3d01@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=G6BsK5s5 c=1 sm=1 tr=0
        a=3wLbm4YUAFX2xaPZIabsgw==:117 a=3wLbm4YUAFX2xaPZIabsgw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=IkcTkHD0fZMA:10 a=MeAgGD-zjQ4A:10
        a=F0ztWRBfAAAA:8 a=7-415B0cAAAA:8 a=C513XtdOnDj8mWjpy7gA:9
        a=QEXdDO2ut3YA:10 a=00Z7dZjzjG_pPJ-L4ie0:22 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 08, 2019 at 07:01:15AM +0100, Arkadiusz Miśkiewicz wrote:
> 
> Hello.
> 
> I have two servers:
> 
> backup4 - one with Adaptec ASR8885Q (that's the one which breaks so
> often but this time adaptes works)
> 
> backup3 - other with software raid only
> 
> Both are now running 5.3.8 kernels and both end up like this log below.
> It takes ~ up to day to reproduce.
> 
> Here are more complete logs and kernel configs:
> 
> https://ixion.pld-linux.org/~arekm/p2/xfs/
> 
> Any ideas what is happening and what can I do to help debug the problem?
> 
> > Nov  8 00:55:19 backup4 kernel: WARNING: CPU: 5 PID: 25802 at fs/xfs/libxfs/xfs_bmap.c:4530 xfs_bmapi_convert_delalloc+0x434/0x4a0 [xfs]
> > Nov  8 00:55:19 backup4 kernel: Modules linked in: nfsd auth_rpcgss nfs_acl lockd grace sunrpc sch_sfq nfnetlink_log nfnetlink xt_NFLOG xt_comment xt_tcpudp xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 iptable_filter ip_tables x_tables bpfilter xfs mlx4_ib ib_uverbs ib_core mlx4_en ses enclosure scsi_transport_sas joydev input_leds hid_generic usbhid hid coretemp intel_rapl_msr intel_rapl_common sb_edac x86_pkg_temp_thermal intel_powerclamp kvm_intel kvm iTCO_wdt iTCO_vendor_support mxm_wmi ipmi_ssif irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel aes_x86_64 crypto_simd cryptd glue_helper xhci_pci mlx4_core intel_cstate xhci_hcd intel_uncore ehci_pci ehci_hcd igb intel_rapl_perf pcspkr ipmi_si usbcore i2c_i801 mei_me ioatdma acpi_power_meter aacraid i2c_algo_bit ipmi_devintf mei dca lpc_ich i2c_core evdev ipmi_msghandler wmi hwmon acpi_pad button sch_fq_codel ext4 libcrc32c crc32c_generic crc32c_intel crc16 mbcache jbd2 sd_mod raid1 md_mod ahci 
 libahci libata
> > Nov  8 00:55:19 backup4 kernel:  scsi_mod
> > Nov  8 00:55:19 backup4 kernel: CPU: 5 PID: 25802 Comm: kworker/u65:3 Tainted: G                T 5.3.8-1 #1
> > Nov  8 00:55:19 backup4 kernel: Hardware name: Supermicro X10DRi/X10DRi, BIOS 3.0a 02/06/2018
> > Nov  8 00:55:19 backup4 kernel: Workqueue: writeback wb_workfn (flush-8:48)
> > Nov  8 00:55:19 backup4 kernel: RIP: 0010:xfs_bmapi_convert_delalloc+0x434/0x4a0 [xfs]
> > Nov  8 00:55:19 backup4 kernel: Code: b7 c0 83 c0 01 e9 9c fd ff ff 41 80 bc 24 e9 00 00 00 03 49 8d 44 24 48 74 d9 c7 84 24 c0 00 00 00 01 00 00 00 e9 94 fd ff ff <0f> 0b 41 be e4 ff ff ff 48 8d 7c 24 30 44 89 f2 44 89 ee e8 84 6f
> > Nov  8 00:55:19 backup4 kernel: RSP: 0018:ffffac6346a5b838 EFLAGS: 00010246
> > Nov  8 00:55:19 backup4 kernel: RAX: 0000000000000000 RBX: ffff95c8f972a000 RCX: 0000000000000022
> > Nov  8 00:55:19 backup4 kernel: RDX: 0000000000001fda RSI: ffffffffffffffff RDI: ffff95c8f93b0600
> > Nov  8 00:55:19 backup4 kernel: RBP: ffffac6346a5b938 R08: 0000000000000000 R09: 0000000000000001
> > Nov  8 00:55:19 backup4 kernel: R10: ffff95c33e6f41d8 R11: 0000000000000026 R12: ffff95be37512a80
> > Nov  8 00:55:19 backup4 kernel: R13: 0000000000000000 R14: 0000000000000000 R15: ffff95be37512ac8
> > Nov  8 00:55:19 backup4 kernel: FS:  0000000000000000(0000) GS:ffff95c8ff940000(0000) knlGS:0000000000000000
> > Nov  8 00:55:19 backup4 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > Nov  8 00:55:19 backup4 kernel: CR2: 00007ff938389000 CR3: 000000048720a001 CR4: 00000000003606e0
> > Nov  8 00:55:19 backup4 kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > Nov  8 00:55:19 backup4 kernel: DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > Nov  8 00:55:19 backup4 kernel: Call Trace:
> > Nov  8 00:55:19 backup4 kernel:  xfs_map_blocks+0x18e/0x420 [xfs]
> > Nov  8 00:55:19 backup4 kernel:  xfs_do_writepage+0x11c/0x440 [xfs]
> > Nov  8 00:55:19 backup4 kernel:  write_cache_pages+0x185/0x430
> > Nov  8 00:55:19 backup4 kernel:  ? xfs_vm_writepages+0x90/0x90 [xfs]
> > Nov  8 00:55:19 backup4 kernel:  xfs_vm_writepages+0x5e/0x90 [xfs]
> > Nov  8 00:55:19 backup4 kernel:  do_writepages+0x1c/0x60
> > Nov  8 00:55:19 backup4 kernel:  __writeback_single_inode+0x41/0x360
> > Nov  8 00:55:19 backup4 kernel:  writeback_sb_inodes+0x20c/0x490
> > Nov  8 00:55:19 backup4 kernel:  wb_writeback+0x12a/0x320
> > Nov  8 00:55:19 backup4 kernel:  wb_workfn+0xdd/0x4a0
> > Nov  8 00:55:19 backup4 kernel:  process_one_work+0x1d5/0x370
> > Nov  8 00:55:19 backup4 kernel:  worker_thread+0x4d/0x3d0
> > Nov  8 00:55:19 backup4 kernel:  kthread+0xfb/0x140
> > Nov  8 00:55:19 backup4 kernel:  ? process_one_work+0x370/0x370
> > Nov  8 00:55:19 backup4 kernel:  ? kthread_park+0x80/0x80
> > Nov  8 00:55:19 backup4 kernel:  ret_from_fork+0x35/0x40
> > Nov  8 00:55:19 backup4 kernel: ---[ end trace a08de0c8c2851936 ]---
> > Nov  8 00:55:19 backup4 kernel: XFS (sdd1): page discard on page 00000000e56e0621, inode 0x7a17f4206, offset 10354688.

This goes with what you reported on #xfs:

[9/11/19 08:04] <arekm> [   54.777715] Filesystem "sdd1": reserve blocks depleted! Consider increasing reserve pool size.

And:

[9/11/19 08:16] <arekm> ah, yes [   54.777720] XFS (sdd1): Per-AG reservation for AG 38 failed.  Filesystem may run out of space


which implies that we are regularly under-estimating delayed
allocation metadata reservations, or a large delalloc extent is
being split repeatedly on writeback. e.g. severe file fragmentation
due to operating at/near ENOSPC resulting in a 100MB delalloc extent
being split into individual single block allocations.

Eventually this will deplete the reserve pool and trigger ENOSPC,
which will eventually result in a dirty allocation transaction being
cancelled and shutdown occurring.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
