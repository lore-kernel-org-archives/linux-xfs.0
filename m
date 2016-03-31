Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 668E27CA3
	for <xfs@oss.sgi.com>; Thu, 31 Mar 2016 11:33:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3B26C304032
	for <xfs@oss.sgi.com>; Thu, 31 Mar 2016 09:33:04 -0700 (PDT)
Received: from mail-wm0-f48.google.com (mail-wm0-f48.google.com
	[74.125.82.48]) by cuda.sgi.com with ESMTP id TszAF46BKElG0FIM
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 31 Mar 2016 09:33:02 -0700 (PDT)
Received: by mail-wm0-f48.google.com with SMTP id p65so121738585wmp.0
	for <xfs@oss.sgi.com>; Thu, 31 Mar 2016 09:33:02 -0700 (PDT)
From: Avi Kivity <avi@scylladb.com>
Subject: Internal error at xfs_trans_cancel
Message-ID: <56FD513B.40805@scylladb.com>
Date: Thu, 31 Mar 2016 19:32:59 +0300
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Saw this nice gift this morning:

[2121372.825904] XFS (dm-10): Internal error xfs_trans_cancel at line 
1007 of file fs/xfs/xfs_trans.c.  Caller xfs_create+0x40e/0x710 [xfs]
[2121372.827209] CPU: 0 PID: 32020 Comm: java Tainted: G W      
------------   3.10.0-327.10.1.el7.x86_64 #1
[2121372.828529] Hardware name:                  /DH77EB, BIOS 
EBH7710H.86A.0099.2013.0125.1400 01/25/2013
[2121372.829873]  ffff8807b2b11e80 00000000470753cc ffff88031058bb48 
ffffffff816352cc
[2121372.831232]  ffff88031058bb60 ffffffffa084be5b ffffffffa085b7ee 
ffff88031058bb88
[2121372.832542]  ffffffffa0866909 ffff88014a2f3b80 ffff8807f29a2800 
0000000000000000
[2121372.833850] Call Trace:
[2121372.835125]  [<ffffffff816352cc>] dump_stack+0x19/0x1b
[2121372.836397]  [<ffffffffa084be5b>] xfs_error_report+0x3b/0x40 [xfs]
[2121372.837654]  [<ffffffffa085b7ee>] ? xfs_create+0x40e/0x710 [xfs]
[2121372.838915]  [<ffffffffa0866909>] xfs_trans_cancel+0xd9/0x100 [xfs]
[2121372.840178]  [<ffffffffa085b7ee>] xfs_create+0x40e/0x710 [xfs]
[2121372.841444]  [<ffffffffa0857d8b>] xfs_vn_mknod+0xbb/0x250 [xfs]
[2121372.842683]  [<ffffffffa0857f53>] xfs_vn_create+0x13/0x20 [xfs]
[2121372.843887]  [<ffffffff811eacdd>] vfs_create+0xcd/0x130
[2121372.845103]  [<ffffffff811ec36f>] do_last+0xbef/0x1270
[2121372.846324]  [<ffffffff811ee6d2>] path_openat+0xc2/0x490
[2121372.847538]  [<ffffffff811efda2>] ? user_path_at_empty+0x72/0xc0
[2121372.848746]  [<ffffffff811efe9b>] do_filp_open+0x4b/0xb0
[2121372.849917]  [<ffffffff811fca27>] ? __alloc_fd+0xa7/0x130
[2121372.851090]  [<ffffffff811dd843>] do_sys_open+0xf3/0x1f0
[2121372.852227]  [<ffffffff811dd95e>] SyS_open+0x1e/0x20
[2121372.853356]  [<ffffffff81645a49>] system_call_fastpath+0x16/0x1b
[2121372.854486] XFS (dm-10): xfs_do_force_shutdown(0x8) called from 
line 1008 of file fs/xfs/xfs_trans.c.  Return address = 0xffffffffa0866922

Filesystem appeared full, but after a reboot (critical server) it went 
back down to 420GB free.  I did not spend a lot of time analyzing this 
as I needed the machine back up, unfortunately.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
