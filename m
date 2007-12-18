Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 17 Dec 2007 17:51:17 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBI1pCov009561
	for <xfs@oss.sgi.com>; Mon, 17 Dec 2007 17:51:13 -0800
Received: from wa-out-1112.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1A0154941AC
	for <xfs@oss.sgi.com>; Mon, 17 Dec 2007 17:51:23 -0800 (PST)
Received: from wa-out-1112.google.com (wa-out-1112.google.com [209.85.146.182]) by cuda.sgi.com with ESMTP id oLF7u1tTo9fmp8d4 for <xfs@oss.sgi.com>; Mon, 17 Dec 2007 17:51:23 -0800 (PST)
Received: by wa-out-1112.google.com with SMTP id k22so4017158waf.18
        for <xfs@oss.sgi.com>; Mon, 17 Dec 2007 17:51:21 -0800 (PST)
Message-ID: <a727368a0712171751i3eb2633epaf31a6a48129c777@mail.gmail.com>
Date: Tue, 18 Dec 2007 07:21:21 +0530
From: sudheer <ssudheer@gmail.com>
Subject: xfs problem ?
MIME-Version: 1.0
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Sir ,

When i run  tail -f /var/log/messages
--------------------------------------------------------------
Dec 17 20:50:42 u15200848 kernel:  [<c014bb20>] pdflush+0x0/0x50
Dec 17 20:50:42 u15200848 kernel:  [<c014ba2c>] __pdflush+0xbc/0x1b0
Dec 17 20:50:42 u15200848 kernel:  [<c014bb5d>] pdflush+0x3d/0x50
Dec 17 20:50:42 u15200848 kernel:  [<c014afb0>] wb_kupdate+0x0/0x140
Dec 17 20:50:42 u15200848 kernel:  [<c0134fba>] kthread+0xba/0xc0
Dec 17 20:50:42 u15200848 kernel:  [<c0134f00>] kthread+0x0/0xc0
Dec 17 20:50:42 u15200848 kernel:  [<c0101255>]
kernel_thread_helper+0x5/0x10
Dec 17 20:50:42 u15200848 kernel: 0x0: 58 41 47 46 00 00 00 01 00 00 00 0a
00 18 c5 15
Dec 17 20:50:42 u15200848 kernel: Filesystem "hda7": XFS internal error
xfs_alloc_read_agf at line 2173 of file fs/xfs/xfs_alloc.c.  Caller
0xc01dc223
Dec 17 20:50:42 u15200848 kernel:  [<c01dc43d>]
xfs_alloc_read_agf+0xed/0x1b0
Dec 17 20:50:42 u15200848 kernel:  [<c01dc223>]
xfs_alloc_pagf_init+0x33/0x60
Dec 17 20:50:42 u15200848 last message repeated 2 times
Dec 17 20:50:42 u15200848 kernel:  [<c01ec744>] xfs_bmap_alloc+0x8e4/0xed0
Dec 17 20:50:42 u15200848 kernel:  [<c01ee970>]
xfs_bmap_search_extents+0x80/0x130
Dec 17 20:50:42 u15200848 kernel:  [<c01d0d10>] xfs_dqunlock+0x40/0x50
Dec 17 20:50:42 u15200848 kernel:  [<c01f0fe0>] xfs_bmapi+0x1270/0x1730
Dec 17 20:50:42 u15200848 kernel:  [<c01f76cf>] xfs_bmbt_get_state+0x2f/0x40
Dec 17 20:50:42 u15200848 kernel:  [<c01ee5a8>]
xfs_bmap_do_search_extents+0xf8/0x440
Dec 17 20:50:42 u15200848 kernel:  [<c0221184>]
xlog_grant_push_ail+0x44/0x130
Dec 17 20:50:42 u15200848 kernel:  [<c0220176>] xfs_log_reserve+0xc6/0xd0
Dec 17 20:50:42 u15200848 kernel:  [<c021d32e>]
xfs_iomap_write_allocate+0x2ee/0x5d0
Dec 17 20:50:42 u15200848 kernel:  [<c021be66>] xfs_iomap+0x406/0x540
Dec 17 20:50:42 u15200848 kernel:  [<c023d0d8>] xfs_map_blocks+0x58/0x90
Dec 17 20:50:42 u15200848 kernel:  [<c023e26c>]
xfs_page_state_convert+0x48c/0x7c0
Dec 17 20:50:42 u15200848 kernel:  [<c0256b92>] submit_bio+0x62/0x100
Dec 17 20:50:42 u15200848 kernel:  [<c01449c1>] find_get_pages_tag+0x41/0x90
-------------------------------------------------------------------------------------------------------------------------

Is this a problem with the xfs file system ? in the  hda7   partition ? .How
can i correct this on live server ?

Filesystem "hda7":

LABEL=/         /       ext3    defaults        1       1
none            /dev/pts        devpts  gid=5,mode=620  0       0
none            /dev/shm        tmpfs   defaults        0       0
none            /proc   proc    defaults        0       0
none            /sys    sysfs   defaults        0       0
/dev/hda2       swap    swap    defaults        0       0
LABEL=usr       /usr    xfs     defaults        1       2
LABEL=var       /var    xfs     defaults,usrquota       1       2
LABEL=home      /home   xfs     defaults,usrquota       1       2
---------------------------------------------------------------------------------------------------------------------------------------

Filesystem            Size  Used Avail Use% Mounted on
/dev/hda1             989M  513M  426M  55% /
none                 1010M     0 1010M   0% /dev/shm
/dev/hda5             4.9G  1.9G  3.0G  39% /usr
/dev/hda7             100G   50G   50G  50% /var
/dev/hda6             4.9G  148K  4.9G   1% /home
-------------------------------------------------------------------------------------------------------
Thanks for all the help
Sudheer


[[HTML alternate version deleted]]
