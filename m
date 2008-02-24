Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 24 Feb 2008 01:58:47 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1O9weiB006213
	for <xfs@oss.sgi.com>; Sun, 24 Feb 2008 01:58:43 -0800
Received: from merkurneu.hrz.uni-giessen.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A9CE460F73D
	for <xfs@oss.sgi.com>; Sun, 24 Feb 2008 01:59:06 -0800 (PST)
Received: from merkurneu.hrz.uni-giessen.de (merkurneu.hrz.uni-giessen.de [134.176.2.3]) by cuda.sgi.com with ESMTP id WajaVFCUJ8MdWOOL for <xfs@oss.sgi.com>; Sun, 24 Feb 2008 01:59:06 -0800 (PST)
Received: from [134.176.2.168] by merkurneu.hrz.uni-giessen.de with ESMTP for xfs@oss.sgi.com; Sun, 24 Feb 2008 10:58:51 +0100
Received: from hermes.hrz.uni-giessen.de (hermes.hrz.uni-giessen.de [134.176.2.15])
	by mailgw22.hrz.uni-giessen.de (Postfix) with ESMTP id DAAF37EB8D7
	for <xfs@oss.sgi.com>; Sun, 24 Feb 2008 10:58:37 +0100 (CET)
Received: from [81.210.150.223] by hermes.hrz.uni-giessen.de with ESMTP for xfs@oss.sgi.com; Sun, 24 Feb 2008 10:58:39 +0100
Mime-Version: 1.0 (Apple Message framework v753)
Content-Transfer-Encoding: 7bit
Message-Id: <03F8FD43-322F-41E3-A7A0-CD4E9AD8B4DE@ap.physik.uni-giessen.de>
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
From: Marc Dietrich <Marc.Dietrich@ap.physik.uni-giessen.de>
Subject: filesystem corruption in linus tree
Date: Sun, 24 Feb 2008 10:58:26 +0100
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi,

somewhere after the release of 2.6.24 my xfs filesystem got  
corrupted. Initialy I thought it was only related to the readdir bug.  
(http://oss.sgi.com/archives/xfs/2008-02/msg00027.html) So I waited  
for the fix to go into mainline. Yesterday I tried again, but got  
this error during boot:

Feb 23 22:27:00 g3 kernel: Filesystem "sda5": XFS internal error  
xfs_bmapi at line 4757 of file fs/xfs/xfs_bmap.c.  Caller 0xc01199a8
Feb 23 22:27:00 g3 kernel: Call Trace:
Feb 23 22:27:00 g3 kernel: [df84fa20] [c0008260] show_stack 
+0x48/0x19c (unreliable)
Feb 23 22:27:00 g3 kernel: [df84fa60] [c0109c80] xfs_error_report 
+0x58/0x5c
Feb 23 22:27:00 g3 kernel: [df84fa70] [c00f6b04] xfs_bmapi+0x10a4/0x1128
Feb 23 22:27:00 g3 kernel: [df84fbd0] [c01199a8] xfs_iomap+0x13c/0x33c
Feb 23 22:27:00 g3 kernel: [df84fc50] [c01372c4] xfs_map_blocks 
+0x34/0xac
Feb 23 22:27:00 g3 kernel: [df84fc80] [c01384a0]  
xfs_page_state_convert+0x560/0x74c
Feb 23 22:27:00 g3 kernel: [df84fd40] [c01389e0] xfs_vm_writepage 
+0x70/0x11c
Feb 23 22:27:00 g3 kernel: [df84fd70] [c0063e7c] __writepage+0x24/0x8c
Feb 23 22:27:00 g3 kernel: [df84fd80] [c0064c48] write_cache_pages 
+0x284/0x360
Feb 23 22:27:00 g3 kernel: [df84fe20] [c0138930] xfs_vm_writepages 
+0x64/0x78
Feb 23 22:27:00 g3 kernel: [df84fe30] [c0064d98] do_writepages+0x4c/0x84
Feb 23 22:27:00 g3 kernel: [df84fe40] [c00aac48]  
__writeback_single_inode+0xa0/0x3f8
Feb 23 22:27:00 g3 kernel: [df84fea0] [c00ab53c] sync_sb_inodes 
+0x2b4/0x410
Feb 23 22:27:00 g3 kernel: [df84fee0] [c00ab9b4] writeback_inodes 
+0xb8/0x190
Feb 23 22:27:00 g3 kernel: [df84ff00] [c006547c] background_writeout 
+0xc4/0x104
Feb 23 22:27:00 g3 kernel: [df84ff70] [c0065ad8] pdflush+0x178/0x270
Feb 23 22:27:00 g3 kernel: [df84ffd0] [c0042ad8] kthread+0x50/0x88
Feb 23 22:27:00 g3 kernel: [df84fff0] [c00104b8] kernel_thread+0x44/0x60

I seems that the log is corrupted because I can't mount the  
filesystem anymore (blocks while replaying). Mounting with norecovery  
option works. I tried to repair the filesystem, but xfs_repair also  
hangs in "Phase 3 - scan and clear agi unlinks lists". Before, Phase  
2 reports some "ir_freecount/free.mismatch" lines.

This happens on a newly created filesystem with xfsprogs 2.6.9 (I  
also tested 2.5.22). I have a 32bit powermac, so it could be an  
endian issue.

Thanks

Marc
