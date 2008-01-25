Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 Jan 2008 23:16:25 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0P7GKim001905
	for <xfs@oss.sgi.com>; Thu, 24 Jan 2008 23:16:23 -0800
Received: from m12-13.163.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id E2A8155C04C
	for <xfs@oss.sgi.com>; Thu, 24 Jan 2008 23:16:36 -0800 (PST)
Received: from m12-13.163.com (m12-13.163.com [220.181.12.13]) by cuda.sgi.com with SMTP id lWwzrAQYQCnuCmmP for <xfs@oss.sgi.com>; Thu, 24 Jan 2008 23:16:36 -0800 (PST)
Date: Fri, 25 Jan 2008 15:16:36 +0800
From: "lxh" <lxhzju@163.com>
Reply-To: lxhzju@163.com
Subject: kernel oops on debian, 2.6.18-5, large xfs volume
Message-ID: <200801251516352343935@163.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs <xfs@oss.sgi.com>

Hello, 
   we have dozens of file servers with a 1.5TB/2.5 TB large xfs file system volume running on a RAID6 SATA array.  Each volume contains about 10,000,000 files. The Operating system is debian GNU/Linux 2.6.18-5-amd64 #1 SMP. we got a kernel oops frequently last year. 

here is the oops :
 Filesystem "cciss/c0d1": XFS internal error xfs_trans_cancel at line 1138
 of file fs/xfs/xfs_trans.c.  Caller 0xffffffff881df006
 Call Trace:
 [<ffffffff881fed18>] :xfs:xfs_trans_cancel+0x5b/0xfe
 [<ffffffff88207006>] :xfs:xfs_create+0x58b/0x5dd
 [<ffffffff8820f496>] :xfs:xfs_vn_mknod+0x1bd/0x3c8
 [<ffffffff8027d27d>] default_wake_function+0x0/0xe
 [<ffffffff802200e5>] __up_read+0x13/0x8a
 [<ffffffff881eb682>] :xfs:xfs_iunlock+0x57/0x79
 [<ffffffff88204180>] :xfs:xfs_lookup+0x6c/0x7d
 [<ffffffff802200e5>] __up_read+0x13/0x8a
 [<ffffffff881eb682>] :xfs:xfs_iunlock+0x57/0x79
 [<ffffffff882041ce>] :xfs:xfs_access+0x3d/0x46
 [<ffffffff8820fa4b>] :xfs:xfs_vn_permission+0x14/0x18
 [<ffffffff8020cc7d>] permission+0x87/0xce
 [<ffffffff80208f26>] __link_path_walk+0x16a/0xf3c
 [<ffffffff8022ae52>] mntput_no_expire+0x19/0x8b
 [<ffffffff8020dd5f>] link_path_walk+0xd3/0xe5
 [<ffffffff802381ed>] vfs_create+0xe7/0x12c
 [<ffffffff80218efb>] open_namei+0x18d/0x69c
 [<ffffffff802252f1>] do_filp_open+0x1c/0x3d
 [<ffffffff80217baa>] do_sys_open+0x44/0xc5
 [<ffffffff802584d6>] system_call+0x7e/0x83
　　
 Every time the error occurs, the volume can not be accessed. So we have to umount this volume, run xfs_repair, and then remount it. This problem causes seriously impact of our service. 
  Could you help me resolve this problem ? 

　　　　　　　　Luo xiaohua
　　　　　　　　lxhzju@163.com
　　　　　　　　　　2008-01-25
