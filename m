Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:51638 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1032509AbeEXSQm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 24 May 2018 14:16:42 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3962ABB41F
        for <linux-xfs@vger.kernel.org>; Thu, 24 May 2018 18:16:41 +0000 (UTC)
Received: from localhost (hp-dl360g9-06.rhts.eng.pek2.redhat.com [10.73.4.165])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9AFBF111AF17
        for <linux-xfs@vger.kernel.org>; Thu, 24 May 2018 18:16:40 +0000 (UTC)
Date: Fri, 25 May 2018 02:16:39 +0800
From: Zorro Lang <zlang@redhat.com>
Subject: [Bug report] XFS: Assertion failed: XFS_FORCED_SHUTDOWN(ip->i_mount)
 || ip->i_delayed_blks == 0
Message-ID: <20180524181639.GW4893@hp-dl360g9-06.rhts.eng.pek2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi,

I just hit a XFS crash [1] when I tested XFS on a 500T storage. And a XFS
corruption [2] can be found by "xfs_repair -n".

Tested on 4.17-rc6, xfsprogs-4.16.1. mkfs.xfs options are "-m crc=1,finobt=1,
rmapbt=1,reflink=1 -i sparse=1".

I've report a bug as below:
https://bugzilla.kernel.org/show_bug.cgi?id=199825

[1]
 kernel: XFS: Assertion failed: XFS_FORCED_SHUTDOWN(ip->i_mount) || ip->i_delayed_blks == 0, file: fs/xfs/xfs_super.c, line: 984
 kernel: WARNING: CPU: 39 PID: 487 at fs/xfs/xfs_message.c:105 asswarn+0x1e/0x30 [xfs]
 kernel: Modules linked in: loop intel_powerclamp coretemp kvm_intel sunrpc kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel pcbc aesni_intel crypto_simd cryptd glue_helper iTCO_wdt gpio_ich iTCO_vendor_support dm_service_time pcspkr ipmi_ssif ipmi_si ipmi_devintf hpilo hpwdt sg i7core_edac lpc_ich ipmi_msghandler shpchp acpi_power_meter pcc_cpufreq dm_multipath ip_tables xfs libcrc32c sr_mod cdrom ata_generic pata_acpi radeon i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm ata_piix sd_mod drm mpt3sas libata crc32c_intel serio_raw hpsa netxen_nic i2c_core raid_class scsi_transport_sas dm_mirror dm_region_hash dm_log dm_mod
 kernel: CPU: 39 PID: 487 Comm: kswapd0 Not tainted 4.17.0-rc6+ #2
 kernel: Hardware name: HP ProLiant DL580 G7, BIOS P65 10/01/2013
 kernel: RIP: 0010:asswarn+0x1e/0x30 [xfs]
 kernel: RSP: 0018:ffff9b9887d9fbc0 EFLAGS: 00010246
 kernel: RAX: 0000000000000000 RBX: ffff882b91e009d8 RCX: 0000000000000000
 kernel: RDX: ffff9b9887d9fae0 RSI: 000000000000000a RDI: ffffffffc05ecff9
 kernel: RBP: ffff882b91e008c8 R08: 0000000000000000 R09: 0000000000000021
 kernel: R10: 0000000000000000 R11: 000000000000000a R12: ffff882b91e00780
 kernel: R13: 000000000000ce58 R14: 000000000000000c R15: 00000000000000e5
 kernel: FS:  0000000000000000(0000) GS:ffff882f6fbc0000(0000) knlGS:0000000000000000
 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 kernel: CR2: 00007f832588eff0 CR3: 0000000a2dc0a002 CR4: 00000000000206e0
 kernel: Call Trace:
 kernel: xfs_fs_destroy_inode+0x1db/0x200 [xfs]
 kernel: dispose_list+0x48/0x60
 kernel: prune_icache_sb+0x52/0x70
 kernel: super_cache_scan+0x139/0x190
 kernel: shrink_slab+0x249/0x430
 kernel: shrink_node+0x44a/0x490
 kernel: balance_pgdat+0x188/0x360
 kernel: kswapd+0x171/0x410
 kernel: ? remove_wait_queue+0x60/0x60
 kernel: kthread+0xf8/0x130
 kernel: ? balance_pgdat+0x360/0x360
 kernel: ? kthread_bind+0x10/0x10
 kernel: ret_from_fork+0x35/0x40
 kernel: Code: 99 f9 ff ff 0f 0b e8 c2 d4 4e c8 66 90 66 66 66 66 90 48 89 f1 41 89 d0 48 c7 c6 08 7f 5f c0 48 89 fa 31 c0 31 ff e8 b2 fc ff ff <0f> 0b c3 0f 1f 44 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 
 kernel: ---[ end trace 6d72efdc406c28bc ]---

[2]

Phase 1 - find and verify superblock...
        - reporting progress in intervals of 15 minutes
Memory available for repair (48300MB) may not be sufficient.
At least 64121MB is needed to repair this filesystem efficiently
If repair fails due to lack of memory, please
turn prefetching off (-P) to reduce the memory footprint.
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
sb_fdblocks 2570207456, counted 2570207543
        - 10:12:40: scanning filesystem freespace - 501 of 501 allocation groups done
        - found root inode chunk
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
        - 10:12:40: scanning agi unlinked lists - 501 of 501 allocation groups done
        - process known inodes and perform inode discovery...
        - agno = 0
        - agno = 15
        ...
        (501 AGs)
        ...
        - agno = 254                           
        - 10:57:14: process known inodes and inode discovery - 21719296 of 19087328 inodes done
        - process newly discovered inodes...   
        - 10:57:14: process newly discovered inodes - 501 of 501 allocation groups done        
Phase 4 - check for duplicate blocks...        
        - setting up duplicate extent list...  
        - 10:57:17: setting up duplicate extent list - 501 of 501 allocation groups done       
        - check for inodes claiming duplicate blocks...                                        
        - agno = 30                            
        - agno = 0                             
        - agno = 45
        ...                                    
        (501 AGs)                              
        ...
        - agno = 253                           
        - agno = 254                           
        - 11:42:57: check for inodes claiming duplicate blocks - 21719296 of 19087328 inodes done
No modify flag set, skipping phase 5           
Phase 6 - check inode connectivity...          
        - traversing filesystem ...            
        - traversal finished ...               
        - moving disconnected inodes to lost+found ...                                         
Phase 7 - verify link counts...                
        - 11:52:50: verify and correct link counts - 501 of 501 allocation groups done         
No modify flag set, skipping filesystem flush and exiting.
--
To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
