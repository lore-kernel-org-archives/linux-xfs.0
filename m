Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41193 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753655AbdEJXS7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 May 2017 19:18:59 -0400
Date: Wed, 10 May 2017 16:18:52 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Null pointer dereference in xfs_da3_node_read
Message-ID: <20170510231852.GA22718@birch.djwong.org>
References: <6AC5B066-4C60-4D73-9343-C405D4E787FB@jabberwocky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6AC5B066-4C60-4D73-9343-C405D4E787FB@jabberwocky.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Shaw <dshaw@jabberwocky.com>
Cc: linux-xfs@vger.kernel.org

On Wed, May 10, 2017 at 06:59:57PM -0400, David Shaw wrote:
> Hello,
> 
> I've been getting many examples of this failure.  The kernel is
> 3.10.0-514.2.2 and xfsprogs is 4.5.0-9 (Centos 7.3).  It's always the same
> backtrace, and always triggered by the same process, though it's intermittent
> and I can run for a while without seeing it, and then get a cluster of 3
> panics in a day.  This process (webread) doesn't do very much beyond request
> files from a web server and write them to an XFS v5 filesystem.  One thing
> that may be relevant here is that the files the process is writing have quite
> large extended attributes - in the 10k and up range.
> 
> Unfortunately, I do not have a reproduction case beyond waiting for it to
> happen again.  Any advice would be very welcomed.

Could you capture a metadump of the filesystem, please?  I have a
sneaking suspicion that there's a file with a hole in the xattr block
map that xfs_attr3_node_inactive is stumbling over.  Callers of
xfs_da_read_buf don't seem to check that they actually got a buffer
back...

--D

> 
> David
> 
> [97688.563958] BUG: unable to handle kernel NULL pointer dereference at 00000000000000a0
> [97688.564027] IP: [<ffffffffa03b7320>] xfs_da3_node_read+0x30/0xd0 [xfs]
> [97688.564095] PGD 85af5e067 PUD 846ba2067 PMD 0 
> [97688.564134] Oops: 0000 [#1] SMP 
> [97688.564159] Modules linked in: dm_snapshot dm_bufio iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 ipt_REJECT nf_reject_ipv4 xt_comment xt_recent xt_conntrack nf_conntrack fuse(OE) bonding iptable_filter ifb intel_powerclamp coretemp intel_rapl iosf_mbi iTCO_wdt kvm_intel iTCO_vendor_support kvm sg irqbypass crc32_pclmul ghash_clmulni_intel mei_me mei aesni_intel lrw gf128mul glue_helper ablk_helper cryptd sb_edac lpc_ich mxm_wmi edac_core pcspkr shpchp wmi acpi_power_meter nfsd(OE) auth_rpcgss nfs_acl lockd grace sunrpc ip_tables xfs sd_mod crc_t10dif crct10dif_generic ipmi_devintf crct10dif_pclmul crct10dif_common crc32c_intel mgag200 i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm ahci tg3 uas drm libahci bnx2x usb_storage libata i2c_core mdio ptp
> [97688.564906]  megaraid_sas pps_core ipmi_si libcrc32c ipmi_msghandler fjes dm_mirror dm_region_hash dm_log dm_mod
> [97688.565005] CPU: 7 PID: 94655 Comm: webread Tainted: G        W  OE  ------------   3.10.0-514.2.2.el7.x86_64 #1
> [97688.565064] Hardware name: Dell Inc. PowerEdge R730xd, BIOS 2.3.4 11/08/2016
> [97688.565106] task: ffff88090852de20 ti: ffff880985fe0000 task.ti: ffff880985fe0000
> [97688.565150] RIP: 0010:[<ffffffffa03b7320>]  [<ffffffffa03b7320>] xfs_da3_node_read+0x30/0xd0 [xfs]
> [97688.565223] RSP: 0018:ffff880985fe3c98  EFLAGS: 00010286
> [97688.565255] RAX: 0000000000000000 RBX: ffff8808a3a07748 RCX: 0000000000000001
> [97688.565297] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff880985fe3c48
> [97688.565339] RBP: ffff880985fe3cb8 R08: 0000000000000001 R09: ffff880985fe3b20
> [97688.565380] R10: fffffffffffffffe R11: 0000000000000001 R12: ffff880985fe3ce8
> [97688.565421] R13: 0000000000000001 R14: 0000000000000001 R15: 0000000010420e08
> [97688.565463] FS:  00007f5732ffd700(0000) GS:ffff88105dec0000(0000) knlGS:0000000000000000
> [97688.565507] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [97688.565542] CR2: 00000000000000a0 CR3: 000000084cf5e000 CR4: 00000000001407e0
> [97688.565582] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [97688.565623] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [97688.565664] Stack:
> [97688.565681]  ffffffffa041bab0 ffffffffa03f780c ffff880985fe3d80 ffff880125d26a40
> [97688.565737]  ffff880985fe3d30 ffffffffa03d2b2b 0000000200000008 ffff880956123040
> [97688.565792]  00000000d0622a88 ffff880985423180 0000000000000000 0000000000000000
> [97688.565847] Call Trace:
> [97688.565890]  [<ffffffffa03f780c>] ? xfs_trans_roll+0x2c/0x50 [xfs]
> [97688.565942]  [<ffffffffa03d2b2b>] xfs_attr3_node_inactive+0x18b/0x230 [xfs]
> [97688.565999]  [<ffffffffa03d2c86>] xfs_attr3_root_inactive+0xb6/0x120 [xfs]
> [97688.566054]  [<ffffffffa03d2e37>] xfs_attr_inactive+0x147/0x1b0 [xfs]
> [97688.566111]  [<ffffffffa03eccc1>] xfs_inactive+0x81/0x130 [xfs]
> [97688.566164]  [<ffffffffa03f2346>] xfs_fs_evict_inode+0xa6/0xe0 [xfs]
> [97688.567468]  [<ffffffff8121a247>] evict+0xa7/0x170
> [97688.568419]  [<ffffffff8121aae5>] iput+0xf5/0x180
> [97688.569234]  [<ffffffff812155c8>] dentry_kill+0x168/0x1b0
> [97688.570047]  [<ffffffff8121566c>] dput+0x5c/0xd0
> [97688.570859]  [<ffffffff812000fb>] __fput+0x17b/0x260
> [97688.571665]  [<ffffffff8120031e>] ____fput+0xe/0x10
> [97688.572464]  [<ffffffff810acde7>] task_work_run+0xa7/0xe0
> [97688.573261]  [<ffffffff8102ab22>] do_notify_resume+0x92/0xb0
> [97688.574043]  [<ffffffff81696a7d>] int_signal+0x12/0x17
> [97688.574853] Code: 55 48 89 e5 41 54 4d 89 c4 53 48 89 fb 48 83 ec 10 48 c7 04 24 b0 ba 41 a0 e8 dd fe ff ff 85 c0 75 49 48 85 db 74 44 49 8b 34 24 <48> 8b 96 a0 00 00 00 0f b7 52 08 66 c1 c2 08 66 81 fa be 3e 74 
> [97688.576495] RIP  [<ffffffffa03b7320>] xfs_da3_node_read+0x30/0xd0 [xfs]
> [97688.577256]  RSP <ffff880985fe3c98>
> [97688.578007] CR2: 00000000000000a0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
