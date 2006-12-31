Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 31 Dec 2006 06:32:58 -0800 (PST)
Received: from tmailer.gwdg.de (tmailer.gwdg.de [134.76.10.23])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kBVEWpqw020522
	for <xfs@oss.sgi.com>; Sun, 31 Dec 2006 06:32:52 -0800
Received: from linux01.gwdg.de ([134.76.13.21])
	by mailer.gwdg.de with esmtps (TLSv1:AES256-SHA:256)
	(Exim 4.60)
	(envelope-from <jengelh@linux01.gwdg.de>)
	id 1H10w1-0003K3-4P
	for xfs@oss.sgi.com; Sun, 31 Dec 2006 14:41:09 +0100
Received: from linux01.gwdg.de (localhost [127.0.0.1])
	by linux01.gwdg.de (8.13.3/8.13.3/SuSE Linux 0.7) with ESMTP id kBVDf9Lr019441
	for <xfs@oss.sgi.com>; Sun, 31 Dec 2006 14:41:11 +0100
Received: from localhost (jengelh@localhost)
	by linux01.gwdg.de (8.13.3/8.13.3/Submit) with ESMTP id kBVDf9I4019435
	for <xfs@oss.sgi.com>; Sun, 31 Dec 2006 14:41:09 +0100
Date: Sun, 31 Dec 2006 14:41:09 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: xfs internal error on sparc64
Message-ID: <Pine.LNX.4.61.0612311413130.32449@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi list,


just catched this in dmesg:

xfs_da_do_buf: bno 16777216
dir: inode 134659821
Filesystem "sdf5": XFS internal error xfs_da_do_buf(1) at line 1992 of 
file fs/xfs/xfs_da_btree.c.  Caller 0x000000001002b53c
Call Trace:
 [00000000100325c4] xfs_dir2_node_removename+0x1e4/0x400 [xfs]
 [000000001002def4] xfs_dir_removename+0x12c/0x138 [xfs]
 [00000000100583e4] xfs_remove+0x258/0x410 [xfs]
 [0000000010061afc] xfs_vn_unlink+0x24/0x58 [xfs]
 [00000000004b2c40] vfs_unlink+0xf4/0x144
 [00000000004b4fa4] do_unlinkat+0xa8/0x148
 [0000000000406c54] linux_sparc_syscall32+0x3c/0x40
 [000000000001f898] 0x1f8a0
Filesystem "sdf5": XFS internal error xfs_trans_cancel at line 1138 of 
file fs/xfs/xfs_trans.c.  Caller 0x0000000010058568
Call Trace:
 [0000000010061afc] xfs_vn_unlink+0x24/0x58 [xfs]
 [00000000004b2c40] vfs_unlink+0xf4/0x144
 [00000000004b4fa4] do_unlinkat+0xa8/0x148
 [0000000000406c54] linux_sparc_syscall32+0x3c/0x40
 [000000000001f898] 0x1f8a0
xfs_force_shutdown(sdf5,0x8) called from line 1139 of file 
fs/xfs/xfs_trans.c.
Return address = 0x0000000010064ce4
Filesystem "sdf5": Corruption of in-memory data detected.  Shutting down 
filesystem: sdf5
Please umount the filesystem, and rectify the problem(s)
xfs_force_shutdown(sdf5,0x1) called from line 424 of file 
fs/xfs/xfs_rw.c.  Return address = 0x0000000010064ce4
xfs_force_shutdown(sdf5,0x1) called from line 424 of file 
fs/xfs/xfs_rw.c.  Return address = 0x0000000010064ce4

/proc/modules:
xfs 468241 1 - Live 0x000000001000a000

Currently-running kernel is 2.6.18-1.2798.al3.1smp. Beforehand, only 
2.6.16-1.2241sp7smp and 2.6.13-1.1603sp13smp were running, so I do not 
think it is the directory corruption bug that slipped in in 2.6.17.

# umount /dev/sdf5
# xfs_check /dev/sdf5
ERROR: The filesystem has valuable metadata changes in a log which needs 
to be replayed.  Mount the filesystem to replay the log, and unmount it 
before re-running xfs_ncheck.  If you are unable to mount the 
filesystem, then use the xfs_repair -L option to destroy the log and 
attempt a repair. Note that destroying the log may cause corruption -- 
please attempt a mount of the filesystem before doing this. must run 
blockget -n first
# mount /dev/sdf5
# umount /dev/sdf5
# xfs_check /dev/sdf5
bad free block nused 9 should be 31 for dir ino 520 block 16777216
bad free block nused 0 should be 32 for dir ino 17294340 block 16777216
bad free block nused 0 should be 26 for dir ino 17554166 block 16777216
bad free block nused 0 should be 32 for dir ino 17554169 block 16777216
bad free block nused 2 should be 9 for dir ino 33809210 block 16777216
bad free block nused 1 should be 16 for dir ino 33902514 block 16777216
bad free block nused 0 should be 26 for dir ino 50408697 block 16777216
bad free block nused 0 should be 45 for dir ino 83894051 block 16777216
bad free block nused 0 should be 43 for dir ino 100746327 block 16777216
bad free block nused 0 should be 5 for dir ino 134490771 block 16777216
missing free index for data block 0 in dir ino 134659821

It's still the 16777216 bug? Anyway, I am going to run xfs_repair 2.8.11 
now and see.


	-`J'
-- 
