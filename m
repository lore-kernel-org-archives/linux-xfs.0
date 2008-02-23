Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 23 Feb 2008 14:00:50 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1NM0dCd012290
	for <xfs@oss.sgi.com>; Sat, 23 Feb 2008 14:00:43 -0800
Received: from el-out-1112.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4E19611EBFEA
	for <xfs@oss.sgi.com>; Sat, 23 Feb 2008 14:00:30 -0800 (PST)
Received: from el-out-1112.google.com (el-out-1112.google.com [209.85.162.181]) by cuda.sgi.com with ESMTP id sr9kD2srBSlw1wFC for <xfs@oss.sgi.com>; Sat, 23 Feb 2008 14:00:30 -0800 (PST)
Received: by el-out-1112.google.com with SMTP id y26so863187ele.18
        for <xfs@oss.sgi.com>; Sat, 23 Feb 2008 14:00:30 -0800 (PST)
Message-ID: <2db2c6b80802231400j1885390dy971b4d7efb1eb67e@mail.gmail.com>
Date: Sat, 23 Feb 2008 23:00:29 +0100
From: Rekrutacja119 <rekrutacja119@gmail.com>
Subject: Fwd: xfs I/O error
In-Reply-To: <2db2c6b80802231346r78d59381j49927e15f40e7ef8@mail.gmail.com>
MIME-Version: 1.0
References: <2db2c6b80802231346r78d59381j49927e15f40e7ef8@mail.gmail.com>
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

one more thing, i got it from logs when the XFS got down:

Feb 23 22:58:20 debian kernel: [<c021f67e>] xfs_free_ag_extent+0x49e/0x750
Feb 23 22:58:20 debian kernel: [<c0221270>] xfs_free_extent+0xe0/0x110
Feb 23 22:58:20 debian kernel: [<c0221270>] xfs_free_extent+0xe0/0x110
Feb 23 22:58:20 debian kernel: [<c025d24c>] xlog_grant_push_ail+0x3c/0x140
Feb 23 22:58:20 debian kernel: [<c022c1fa>] xfs_bmap_finish+0x13a/0x190
Feb 23 22:58:20 debian kernel: [<c0236730>] xfs_bunmapi+0x0/0xfb0
Feb 23 22:58:20 debian kernel: [<c025442a>] xfs_itruncate_finish+0x27a/0x400
Feb 23 22:58:20 debian kernel: [<c0276b3c>] xfs_inactive+0x49c/0x510
Feb 23 22:58:20 debian kernel: [<c0282697>] xfs_fs_clear_inode+0x77/0xc0
Feb 23 22:58:20 debian kernel: [<c017976f>] clear_inode+0x8f/0x140
Feb 23 22:58:20 debian kernel: [<c014f827>] truncate_inode_pages+0x17/0x20
Feb 23 22:58:20 debian kernel: [<c017990d>] generic_delete_inode+0xed/0x100
Feb 23 22:58:20 debian kernel: [<c0178f4c>] iput+0x5c/0x70
Feb 23 22:58:20 debian kernel: [<c017052f>] do_unlinkat+0xef/0x150
Feb 23 22:58:20 debian kernel: [<c0102972>] sysenter_past_esp+0x5f/0x85
Feb 23 22:58:20 debian kernel: [<c0390000>] nf_nat_ftp+0xd0/0x100
Feb 23 22:58:20 debian kernel: =======================
Feb 23 22:58:20 debian kernel: xfs_force_shutdown(md0,0x8) called from line
4258 of file fs/xfs/xfs_bmap.c.  Return address = 0xc02830bc


please, can i change it somehow? i'm so desperate i think i will try to
change this line in kernel, no matter what consequences it might have (if i
don't allow access to this disk right away, i might as well delete the whole
thing, so it's very important)

also, xfs_repair stops on :

cannot read inode 44610144, disk block 22305072, cnt 16


---------- Forwarded message ----------
From: Rekrutacja119 <rekrutacja119@gmail.com>
Date: 23-02-2008 22:46
Subject: xfs I/O error
To: xfs@oss.sgi.com


hello, is there any way to force XFS to ignore I/O errors? it seems it is
shutting down the fs when it encounters any error.
The problem is that i can't mark badsectors, as XFS doesn't support bad
sector marking, but i also cannot access any correct data on partition,
because when i try to access damaged sector, the whole fs goes down.

any idea why?

i use xfsprogs 2.9.4, my xfs is array made from 3 HDs, RAID 0, and one of
them is getting some bad sectors. i cannot replace it currently.

after i run xfs_repair on it, i was able to mount it and access the data,
but when somebody tries to access bad data, the whole XFS goes down. i don't
want that, i also dont have place to xfsmetadump the whole array to another
disks.

i tried scaning whole disk with badblocks (badblocks -c 1 -s -v /dev/sdb),
and then running dd if=/dev/zero of=/dev/sdb count=1 bs=1
seek=NUMBER_FROM_BADBLOCKOUTPUT

but every block was written fine! (which is strange i guess), and it didnt
help.

please advise me anything other than switching the drive (i will do it,
can't now though) or dumping the whole thing as i need to much space.

the easiest solution would be to just ignore errors, and if not, then to
somehow force xfs to mark them as bad sectors (smartctl is showing errors
like for example

# 2  Extended offline    Completed: unknown failure    90%      9395
-

or


Error 8324 occurred at disk power-on lifetime: 9398 hours (391 days + 14
hours)
  When the command that caused the error occurred, the device was active or
idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 00 30 33 59 e6  Error: UNC at LBA = 0x06593330 = 106509104


[[HTML alternate version deleted]]
