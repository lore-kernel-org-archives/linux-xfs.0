Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ed1-f49.google.com ([209.85.208.49]:42855 "EHLO
        mail-ed1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729218AbfARTmW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Jan 2019 14:42:22 -0500
Received: by mail-ed1-f49.google.com with SMTP id y20so12029397edw.9
        for <linux-xfs@vger.kernel.org>; Fri, 18 Jan 2019 11:42:20 -0800 (PST)
From: =?UTF-8?Q?Arkadiusz_Mi=c5=9bkiewicz?= <a.miskiewicz@gmail.com>
Subject: 4.9.13: general protection fault: RIP:
 0010:xfs_fs_destroy_inode+0x41/0x1c0 [xfs]
Message-ID: <3aff45c7-5d6a-adbc-d409-cec0bb9726cb@gmail.com>
Date: Fri, 18 Jan 2019 20:42:16 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Sami Farin <hvtaifwkbgefbaei@gmail.com>


Hello.

It was reported earlier, on 4.9.5:
https://www.spinics.net/lists/linux-xfs/msg03790.html
There was no followup.

First time seeing this, so adding "me, too":

> [417811.981029] general protection fault: 0000 [#1] SMP PTI
> [417811.984193] CPU: 7 PID: 25354 Comm: httpd71 Tainted: G                T 4.19.13-1 #1
> [417811.984193] Hardware name: Intel S5000VSA/S5000VSA, BIOS S5000.86B.15.00.0101.110920101604 11/09/2010
> [417811.984193] RIP: 0010:xfs_fs_destroy_inode+0x41/0x1c0 [xfs]
> [417811.984193] Code: 90 48 8b 15 11 19 0c 00 65 8b 05 ca 28 a4 3f 48 98 48 8b 34 c5 00 f7 ea 9c 48 01 d6 83 86 fc 00 00 00 01 48 8b 83 c8 fe ff ff <48> 8b 80 f8 08 00 00 65 8b 0d a1 28 a4 3f 48 63 c9 48 03 04 cd 00
> [417811.984193] RSP: 0000:ffffb49507aa3988 EFLAGS: 00010206
> [417811.984193] RAX: 1e8b66085c89667c RBX: ffff957c8288c938 RCX: 0000000000000000
> [417811.984193] RDX: 00003f1020002000 RSI: ffffd494ffdc2000 RDI: ffff957c8288c938
> [417811.984193] RBP: 0000000000d45f6d R08: 0000000000000000 R09: ffff957ff311afc8
> [417811.984193] R10: 0000000000000228 R11: 0000000000000000 R12: ffff957c8288c800
> [417811.984193] R13: ffff9584b5afb800 R14: 0000000000000000 R15: 0000000000000000
> [417811.984193] FS:  00007f610d8c1400(0000) GS:ffff9584dfdc0000(0000) knlGS:0000000000000000
> [417811.984193] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [417811.984193] CR2: 00007f60da600000 CR3: 00000001bd516000 CR4: 00000000000006e0
> [417811.984193] Call Trace:
> [417811.984193]  dispose_list+0x35/0x50
> [417811.984193]  prune_icache_sb+0x52/0x70
> [417811.984193]  super_cache_scan+0x125/0x1a0
> [417811.984193]  do_shrink_slab+0x132/0x280
> [417811.984193]  shrink_slab+0x26d/0x2f0
> [417811.984193]  shrink_node+0xe6/0x4a0
> [417811.984193]  do_try_to_free_pages+0xc6/0x370
> [417811.984193]  try_to_free_pages+0xcd/0x1b0
> [417811.984193]  __alloc_pages_nodemask+0x6d7/0x1090
> [417811.984193]  do_huge_pmd_anonymous_page+0x127/0x760
> [417811.984193]  ? unmap_region+0xf3/0x130
> [417811.984193]  __handle_mm_fault+0x10ac/0x16b0
> [417811.984193]  handle_mm_fault+0xd9/0x220
> [417811.984193]  __do_page_fault+0x250/0x4b0
> [417811.984193]  ? page_fault+0x8/0x30
> [417811.984193]  page_fault+0x1e/0x30
> [417811.984193] RIP: 0033:0x7f6105f90a3d
> [417811.984193] Code: 89 91 4c 01 00 00 48 8b 0c 24 31 f6 41 b8 00 10 00 00 bd ff 01 00 00 41 b9 01 00 00 00 41 ba 01 00 00 00 4c 8b b1 38 01 00 00 <48> 89 08 48 b9 ff 01 00 00 01 00 00 00 49 8b 56 10 4c 89 70 08 48
> [417811.984193] RSP: 002b:00007ffcabdb4930 EFLAGS: 00010246
> [417811.984193] RAX: 00007f60da600000 RBX: 0000000000000002 RCX: 00007f60f7200040
> [417811.984193] RDX: 0000000000000002 RSI: 0000000000000000 RDI: 0000000000000001
> [417811.984193] RBP: 00000000000001ff R08: 0000000000001000 R09: 0000000000000001
> [417811.984193] R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000000
> [417811.984193] R13: 00007f60f73e3400 R14: 00007f60f7200000 R15: 00000000ffffffff
> [417811.984193] Modules linked in: fuse btrfs xor raid6_pq ufs qnx4 hfsplus hfs minix ntfs vfat msdos fat jfs tcp_diag inet_diag softdog xt_multiport dlm xt_comment ipt_REJECT nf_reject_ipv4 nf_log_ipv4 nf_log_common xt_LOG xt_limit xt_conntrack xt_owner xt_tcpudp iptable_filter xt_CLASSIFY iptable_mangle ip_tables x_tables bpfilter sch_sfq ext4 crc16 mbcache jbd2 fscrypto raid1 dm_mod cpufreq_ondemand nf_nat_ftp nf_conntrack_ftp nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 i5000_edac e1000e ipmi_si ipmi_devintf ipmi_msghandler sch_fq_codel xfs libcrc32c crc32c_generic sd_mod mptsas mptscsih mptbase scsi_transport_sas ahci libahci libata aacraid scsi_mod raid10 md_mod
> [417812.283995] ---[ end trace c69da1b751edd3c7 ]---
> [417812.363050] RIP: 0010:xfs_fs_destroy_inode+0x41/0x1c0 [xfs]
> [417812.368800] Code: 90 48 8b 15 11 19 0c 00 65 8b 05 ca 28 a4 3f 48 98 48 8b 34 c5 00 f7 ea 9c 48 01 d6 83 86 fc 00 00 00 01 48 8b 83 c8 fe ff ff <48> 8b 80 f8 08 00 00 65 8b 0d a1 28 a4 3f 48 63 c9 48 03 04 cd 00
> [417812.387768] RSP: 0000:ffffb49507aa3988 EFLAGS: 00010206
> [417812.393167] RAX: 1e8b66085c89667c RBX: ffff957c8288c938 RCX: 0000000000000000
> [417812.400488] RDX: 00003f1020002000 RSI: ffffd494ffdc2000 RDI: ffff957c8288c938
> [417812.407810] RBP: 0000000000d45f6d R08: 0000000000000000 R09: ffff957ff311afc8
> [417812.415131] R10: 0000000000000228 R11: 0000000000000000 R12: ffff957c8288c800
> [417812.422452] R13: ffff9584b5afb800 R14: 0000000000000000 R15: 0000000000000000
> [417812.429777] FS:  00007f610d8c1400(0000) GS:ffff9584dfdc0000(0000) knlGS:0000000000000000
> [417812.438052] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [417812.443970] CR2: 00007f60da600000 CR3: 00000001bd516000 CR4: 00000000000006e0



-- 
Arkadiusz Miśkiewicz, arekm / ( maven.pl | pld-linux.org )
