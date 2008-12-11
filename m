Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBBAH8q0002991 for <xfs@oss.sgi.com>; Thu, 11 Dec 2008 04:17:09 -0600
Received: from yx-out-1718.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E43AB170FB43
	for <xfs@oss.sgi.com>; Thu, 11 Dec 2008 02:17:07 -0800 (PST)
Received: from yx-out-1718.google.com (yx-out-1718.google.com [74.125.44.156])
	by cuda.sgi.com with ESMTP id suDCBxnsnXu1lnm4 for
	<xfs@oss.sgi.com>; Thu, 11 Dec 2008 02:17:07 -0800 (PST)
Received: by yx-out-1718.google.com with SMTP id 36so424312yxh.32
	for <xfs@oss.sgi.com>; Thu, 11 Dec 2008 02:17:07 -0800 (PST)
Message-ID: <a4423d670812110210g50d66304pb0a7d96b3dde00c7@mail.gmail.com>
Date: Thu, 11 Dec 2008 13:10:23 +0300
From: "Alexander Beregalov" <a.beregalov@gmail.com>
Subject: next-20081210: BUG: sleeping function called from invalid context at
	mm/slub.c:1619 (XFS)
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>, xfs@oss.sgi.com, xfs-masters@oss.sgi.com

BUG: sleeping function called from invalid context at mm/slub.c:1619
in_atomic(): 1, irqs_disabled(): 0, pid: 8096, name: sh
INFO: lockdep is turned off.
Pid: 8096, comm: sh Tainted: G        W  2.6.28-rc7-next-20081210 #2
Call Trace:
 [<ffffffff80256e5a>] ? __debug_show_held_locks+0x1b/0x24
 [<ffffffff8022fb55>] __might_sleep+0x120/0x122
 [<ffffffff8029c526>] __kmalloc+0x70/0xfc
 [<ffffffff803534d2>] kmem_alloc+0x75/0xd7
 [<ffffffff803350ba>] xfs_fs_vcmn_err+0x46/0x94
 [<ffffffff80335297>] xfs_fs_cmn_err+0x59/0x5e
 [<ffffffff802578a1>] ? trace_hardirqs_on_caller+0x1f/0x15f
 [<ffffffff803434c0>] ? xlog_grant_push_ail+0x26/0xed
 [<ffffffff804e55d3>] ? _spin_lock+0x68/0x70
 [<ffffffff803416e6>] xlog_space_left+0x62/0x6b
 [<ffffffff803434d8>] xlog_grant_push_ail+0x3e/0xed
 [<ffffffff80343c6f>] xfs_log_reserve+0xa8/0xbc
 [<ffffffff8034cc4e>] xfs_trans_reserve+0xe0/0x1bb
 [<ffffffff80350059>] xfs_create+0x138/0x431
 [<ffffffff802ad852>] ? d_rehash+0x23/0x44
 [<ffffffff8035a090>] xfs_vn_mknod+0xc9/0x139
 [<ffffffff8035a11b>] xfs_vn_create+0xb/0xd
 [<ffffffff802a89dd>] vfs_create+0x58/0x7e
 [<ffffffff802a94f7>] do_filp_open+0x249/0x7d0
 [<ffffffff8022fbec>] ? get_parent_ip+0x11/0x41
 [<ffffffff80231651>] ? sub_preempt_count+0xba/0xce
 [<ffffffff802b2a0a>] ? alloc_fd+0x11d/0x12e
 [<ffffffff8029e19e>] do_sys_open+0x53/0xda
 [<ffffffff80224b3d>] ? do_page_fault+0x394/0x887
 [<ffffffff8029e24e>] sys_open+0x1b/0x1d
 [<ffffffff8020b85b>] system_call_fastpath+0x16/0x1b
Filesystem "sda2": xlog_space_left: head behind tail
  tail_cycle = 1802201963, tail_bytes = -690563584
  GH   cycle = 3078, GH   bytes = 69183384

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
