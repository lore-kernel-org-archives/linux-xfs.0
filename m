Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 364BAC12002
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Jul 2021 07:40:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25667613ED
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Jul 2021 07:40:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235441AbhGPHnZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Jul 2021 03:43:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231888AbhGPHnZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Jul 2021 03:43:25 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 151CEC06175F;
        Fri, 16 Jul 2021 00:40:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=0ed4XWJs/YGIMlo3OUkRs+lwUd38dyycltAhImfV3A8=; b=aYH/vqt8s2bvRPeqcgf07IVzgb
        f1Xs3S4K7P3l6QFakRTIuk0e/mdE6UcIkskhAYSyX9GE8Sg4OAo2BOv+yDmI3fHf4ZfNvkdjKByDv
        5IHaVGX2wkAjD/2DjaXSY5tj3MTKPshg36RRyGMzC/nrS+Gh2q/IsD/kvEMTxoE/eo31rOd6oiu7p
        2YXD3qIqZ4BvdPMkVbh2FFTK/QmE7yIWxgoUZmnSPXk06pNL8/9eu3qgDPXOwEZ8X47kntulJvE9L
        dGX35+SkggR4ZJ00dTrJAdPrgLoRtR+dbzyl6cgBgFkrkd0EEu/efGF3rAhXD87ondqEyUSCs2g4q
        HvLEFVbw==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m4IR5-004GOo-AU; Fri, 16 Jul 2021 07:39:17 +0000
Date:   Fri, 16 Jul 2021 08:39:03 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     cl@linux.com, glittao@gmail.com, iamjoonsoo.kim@lge.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, penberg@kernel.org,
        rdunlap@infradead.org, rientjes@google.com,
        torvalds@linux-foundation.org, vbabka@suse.cz,
        linux-xfs@vger.kernel.org
Subject: Re: [patch 07/54] mm/slub: use stackdepot to save stack trace in
 objects
Message-ID: <YPE3l82acwgI2OiV@infradead.org>
References: <20210707175950.eceddb86c6c555555d4730e2@linux-foundation.org>
 <20210708010747.zIP9yxsci%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210708010747.zIP9yxsci%akpm@linux-foundation.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This somewhat unexpectedly causes a crash when running the xfs/433 test
in xfstests for me.  Reverting the commit fixes the problem:

xfs/433 files ... [  138.422742] run fstests xfs/433 at 2021-07-16 07:30:42
[  140.128145] XFS (vdb): Mounting V5 Filesystem
[  140.160450] XFS (vdb): Ending clean mount
[  140.171782] xfs filesystem being mounted at /mnt/test supports timestamps un)
[  140.966560] XFS (vdc): Mounting V5 Filesystem
[  140.987911] XFS (vdc): Ending clean mount
[  141.000104] xfs filesystem being mounted at /mnt/scratch supports timestamps)
[  145.130156] XFS (vdc): Unmounting Filesystem
[  145.365230] XFS (vdc): Mounting V5 Filesystem
[  145.394542] XFS (vdc): Ending clean mount
[  145.409232] xfs filesystem being mounted at /mnt/scratch supports timestamps)
[  145.471384] XFS (vdc): Injecting error (false) at file fs/xfs/xfs_buf.c, lin"
[  145.478561] XFS (vdc): Injecting error (false) at file fs/xfs/xfs_buf.c, lin"
[  145.486070] XFS (vdc): Injecting error (false) at file fs/xfs/xfs_buf.c, lin"
[  145.492248] XFS (vdc): Injecting error (false) at file fs/xfs/xfs_buf.c, lin"
[  145.599964] XFS (vdb): Unmounting Filesystem
[  145.958340] BUG: kernel NULL pointer dereference, address: 0000000000000020
[  145.961760] #PF: supervisor read access in kernel mode
[  145.964278] #PF: error_code(0x0000) - not-present page
[  145.966758] PGD 0 P4D 0 
[  145.968041] Oops: 0000 [#1] PREEMPT SMP PTI
[  145.970077] CPU: 3 PID: 14172 Comm: xfs_scrub Not tainted 5.13.0+ #601
[  145.973243] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.144
[  145.977312] RIP: 0010:xfs_inode_hasattr+0x19/0x30
[  145.979626] Code: 83 c6 05 b2 55 75 02 01 e8 39 40 e4 00 eb b6 66 90 31 c0 80
[  145.989446] RSP: 0018:ffffc900070eba08 EFLAGS: 00010206
[  145.992280] RAX: ffffffff00ff0000 RBX: 0000000000000000 RCX: 0000000000000001
[  145.995970] RDX: 0000000000000000 RSI: ffffffff82fdd33f RDI: ffff88810dbe16c0
[  145.999945] RBP: ffff88810dbe16c0 R08: ffff888110e14348 R09: ffff888110e14348
[  146.003932] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000000
[  146.007854] R13: ffff888110d99000 R14: ffff888110d99000 R15: ffffffff834acd60
[  146.011765] FS:  00007f2bf29d7700(0000) GS:ffff88813bd80000(0000) knlGS:00000
[  146.016127] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  146.019297] CR2: 0000000000000020 CR3: 0000000110c96000 CR4: 00000000000006e0
[  146.023315] Call Trace:
[  146.024726]  xfs_attr_inactive+0x152/0x350
[  146.027059]  xfs_inactive+0x18a/0x240
[  146.029141]  xfs_fs_destroy_inode+0xcc/0x2d0
[  146.031311]  destroy_inode+0x36/0x70
[  146.033130]  xfs_bulkstat_one_int+0x243/0x340
[  146.035342]  xfs_bulkstat_iwalk+0x19/0x30
[  146.037562]  xfs_iwalk_ag_recs+0xef/0x1e0
[  146.039845]  xfs_iwalk_run_callbacks+0x9f/0x140
[  146.042550]  xfs_iwalk_ag+0x230/0x2f0
[  146.044601]  xfs_iwalk+0x139/0x200
[  146.046505]  ? xfs_bulkstat_one_int+0x340/0x340
[  146.049151]  xfs_bulkstat+0xc4/0x130
[  146.050771]  ? xfs_flags2diflags+0xe0/0xe0
[  146.052309]  xfs_ioc_bulkstat.constprop.0.isra.0+0xbf/0x120
[  146.054200]  xfs_file_ioctl+0xb6/0xef0
[  146.055474]  ? lock_is_held_type+0xd5/0x130
[  146.056867]  ? find_held_lock+0x2b/0x80
[  146.058241]  ? lock_release+0x13c/0x2e0
[  146.059385]  ? lock_is_held_type+0xd5/0x130
[  146.060435]  ? __fget_files+0xce/0x1d0
[  146.061385]  __x64_sys_ioctl+0x7e/0xb0
[  146.062333]  do_syscall_64+0x3b/0x90
[  146.063284]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  146.064572] RIP: 0033:0x7f2bf2df5427
[  146.065600] Code: 00 00 90 48 8b 05 69 aa 0c 00 64 c7 00 26 00 00 00 48 c7 c8
[  146.070244] RSP: 002b:00007f2bf29d6bd8 EFLAGS: 00000246 ORIG_RAX: 00000000000
[  146.072015] RAX: ffffffffffffffda RBX: 00007fffe44b8010 RCX: 00007f2bf2df5427
[  146.073692] RDX: 00007f2be4000b20 RSI: 000000008040587f RDI: 0000000000000003
[  146.075322] RBP: 00007f2be4000b20 R08: 00007f2be4003b70 R09: 0000000000000077
[  146.076962] R10: 0000000000000001 R11: 0000000000000246 R12: 00007f2be4003b70
[  146.078480] R13: 00007fffe44b8010 R14: 00007f2be4000b60 R15: 0000000000000018
[  146.079803] Modules linked in:
[  146.080379] CR2: 0000000000000020
[  146.081196] ---[ end trace 80a6ea90b0ea2a03 ]---
[  146.082130] RIP: 0010:xfs_inode_hasattr+0x19/0x30
[  146.083144] Code: 83 c6 05 b2 55 75 02 01 e8 39 40 e4 00 eb b6 66 90 31 c0 80
[  146.086831] RSP: 0018:ffffc900070eba08 EFLAGS: 00010206
[  146.087816] RAX: ffffffff00ff0000 RBX: 0000000000000000 RCX: 0000000000000001
[  146.089122] RDX: 0000000000000000 RSI: ffffffff82fdd33f RDI: ffff88810dbe16c0
[  146.090477] RBP: ffff88810dbe16c0 R08: ffff888110e14348 R09: ffff888110e14348
[  146.091794] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000000
[  146.093096] R13: ffff888110d99000 R14: ffff888110d99000 R15: ffffffff834acd60
[  146.094429] FS:  00007f2bf29d7700(0000) GS:ffff88813bd80000(0000) knlGS:00000
[  146.096002] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  146.097079] CR2: 0000000000000020 CR3: 0000000110c96000 CR4: 00000000000006e0
[  146.098479] Kernel panic - not syncing: Fatal exception
[  146.099677] Kernel Offset: disabled
[  146.100397] ---[ end Kernel panic - not syncing: Fatal exception ]---


