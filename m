Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 05 Nov 2007 14:20:32 -0800 (PST)
Received: from spike.grumly.eu.org (spike.grumly.eu.org [195.5.253.226])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lA5MKOe3026420
	for <xfs@oss.sgi.com>; Mon, 5 Nov 2007 14:20:27 -0800
Date: Mon, 5 Nov 2007 22:51:35 +0100
From: Cedric - Equinoxe Media <cedric@e-m.fr>
Subject: xfs crash
Message-ID: <20071105215135.GA12238@e-m.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi,

I got a crash with xfs serving nfs :

Hardware is Dell Poweredge 2950 with RAID5 SAS
Linux fng2 2.6.22-3-amd64 #1 SMP Wed Oct 31 13:43:07 UTC 2007 x86_64 GNU/Linux

Here is the dmesg :

NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
NFSD: starting 90-second grace period
XFS internal error XFS_WANT_CORRUPTED_GOTO at line 1563 of file
fs/xfs/xfs_alloc.c.  Caller 0xffffffff88113b35

Call Trace:
 [<ffffffff88111fcb>] :xfs:xfs_free_ag_extent+0x1a6/0x6b5
 [<ffffffff88113b35>] :xfs:xfs_free_extent+0xa9/0xc9
 [<ffffffff8811cf77>] :xfs:xfs_bmap_finish+0xee/0x167
 [<ffffffff8813c843>] :xfs:xfs_itruncate_finish+0x19b/0x2e0
 [<ffffffff881543c1>] :xfs:xfs_setattr+0x841/0xe57
 [<ffffffff8023a29e>] __mod_timer+0xc3/0xd3
 [<ffffffff80229db3>] task_rq_lock+0x3d/0x6f
 [<ffffffff80229976>] __activate_task+0x26/0x38
 [<ffffffff8815eae8>] :xfs:xfs_vn_setattr+0x121/0x144
 [<ffffffff80296791>] notify_change+0x156/0x2f1
 [<ffffffff88309aba>] :nfsd:nfsd_setattr+0x334/0x4b1
 [<ffffffff883102e2>] :nfsd:nfsd3_proc_setattr+0xa2/0xae
 [<ffffffff8830524d>] :nfsd:nfsd_dispatch+0xdd/0x19e
 [<ffffffff88283180>] :sunrpc:svc_process+0x3df/0x6ef
 [<ffffffff803f4cc2>] __down_read+0x12/0x9a
 [<ffffffff88305815>] :nfsd:nfsd+0x191/0x2ac
 [<ffffffff8020aba8>] child_rip+0xa/0x12
 [<ffffffff88305684>] :nfsd:nfsd+0x0/0x2ac
 [<ffffffff8020ab9e>] child_rip+0x0/0x12

xfs_force_shutdown(sda4,0x8) called from line 4258 of file
fs/xfs/xfs_bmap.c.  Return address = 0xffffffff8811cfb4
Filesystem "sda4": Corruption of in-memory data detected.  Shutting down
filesystem: sda4
Please umount the filesystem, and rectify the problem(s)
nfsd: non-standard errno: -117

----------------
Here I stopped nfs, umount -f /dev/sda4, mount /dev/sda4 then start nfs
again.
----------------

nfsd: last server has exited
nfsd: unexporting all filesystems
xfs_force_shutdown(sda4,0x1) called from line 423 of file
fs/xfs/xfs_rw.c.  Return address = 0xffffffff88158289
xfs_force_shutdown(sda4,0x1) called from line 423 of file
fs/xfs/xfs_rw.c.  Return address = 0xffffffff88158289
XFS mounting filesystem sda4
Starting XFS recovery on filesystem: sda4 (logdev: internal)
XFS internal error XFS_WANT_CORRUPTED_GOTO at line 1563 of file
fs/xfs/xfs_alloc.c.  Caller 0xffffffff88113b35

Call Trace:
 [<ffffffff88111fcb>] :xfs:xfs_free_ag_extent+0x1a6/0x6b5
 [<ffffffff88113b35>] :xfs:xfs_free_extent+0xa9/0xc9
 [<ffffffff88145edf>] :xfs:xlog_recover_process_efi+0xf7/0x12a
 [<ffffffff88147288>] :xfs:xlog_recover_process_efis+0x4f/0x81
 [<ffffffff881472d3>] :xfs:xlog_recover_finish+0x19/0x9a
 [<ffffffff8814bd22>] :xfs:xfs_mountfs+0x83d/0x91b
 [<ffffffff802f4b29>] _atomic_dec_and_lock+0x39/0x58
 [<ffffffff88151b34>] :xfs:xfs_mount+0x317/0x39d
 [<ffffffff88161889>] :xfs:xfs_fs_fill_super+0x0/0x1a7
 [<ffffffff88161907>] :xfs:xfs_fs_fill_super+0x7e/0x1a7
 [<ffffffff803f4c21>] __down_write_nested+0x12/0x9a
 [<ffffffff80297003>] get_filesystem+0x12/0x35
 [<ffffffff80284ff5>] sget+0x39d/0x3af
 [<ffffffff80284a0c>] set_bdev_super+0x0/0xf
 [<ffffffff80284a1b>] test_bdev_super+0x0/0xd
 [<ffffffff80285a35>] get_sb_bdev+0x105/0x152
 [<ffffffff8028542a>] vfs_kern_mount+0x93/0x11a
 [<ffffffff80285500>] do_kern_mount+0x43/0xdd
 [<ffffffff80298eda>] do_mount+0x691/0x708
 [<ffffffff80297a3c>] mntput_no_expire+0x1c/0x94
 [<ffffffff8028cba5>] link_path_walk+0xce/0xe0
 [<ffffffff80266af7>] activate_page+0xad/0xd4
 [<ffffffff8025ff17>] find_get_page+0x21/0x50
 [<ffffffff80262028>] filemap_nopage+0x180/0x2ab
 [<ffffffff8026c709>] __handle_mm_fault+0x3e6/0x9d9
 [<ffffffff80269c17>] zone_statistics+0x3f/0x60
 [<ffffffff802f796f>] __up_read+0x13/0x8a
 [<ffffffff802646fe>] __alloc_pages+0x5a/0x2bc
 [<ffffffff80298fdb>] sys_mount+0x8a/0xd7
 [<ffffffff80209d8e>] system_call+0x7e/0x83

Ending XFS recovery on filesystem: sda4 (logdev: internal)
NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery
directory
NFSD: starting 90-second grace period


I have no other message in the dmesg, the server has latest RAID
firmware from dell.

Cédric.
