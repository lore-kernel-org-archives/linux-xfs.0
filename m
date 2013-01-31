Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 71C627F4E
	for <xfs@oss.sgi.com>; Wed, 30 Jan 2013 21:16:53 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 01B7FAC001
	for <xfs@oss.sgi.com>; Wed, 30 Jan 2013 19:16:49 -0800 (PST)
Received: from mx4-phx2.redhat.com (mx4-phx2.redhat.com [209.132.183.25]) by
	cuda.sgi.com with ESMTP id LXqB7LszWobDnexv for
	<xfs@oss.sgi.com>; Wed, 30 Jan 2013 19:16:48 -0800 (PST)
Date: Wed, 30 Jan 2013 22:16:47 -0500 (EST)
From: CAI Qian <caiqian@redhat.com>
Message-ID: <473604401.11548931.1359602207833.JavaMail.root@redhat.com>
In-Reply-To: <614607656.11545086.1359601991846.JavaMail.root@redhat.com>
Subject: 3.8-rc5 xfs corruption
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com, linux-xfs@vger.kernel.org
Cc: linux-kernel <linux-kernel@vger.kernel.org>

Hello,

(Sorry to post to xfs mailing lists but unsure about which one is the
best for this.)

I have seen something like this once during testing on a system with a
EMC VNX FC/multipath back-end. Kernel config file is here,
http://people.redhat.com/qcai/stable/.config

[ 3025.063024] ffff8801a0d50000: 2e 2e 2f 2e 2e 2f 75 73 72 2f 6c 69 62 2f 6d 6f  ../../usr/lib/mo 
[ 3025.071743] XFS (dm-1): Internal error xfs_bmbt_verify at line 747 of file fs/xfs/xfs_bmap_btree.c.  Caller 0xffffffffa01c375e 
[ 3025.071743]  
[ 3025.084589] Pid: 275, comm: xfsaild/dm-1 Tainted: GF            3.8.0-rc5 #1 
[ 3025.091636] Call Trace: 
[ 3025.094176]  [<ffffffffa019910f>] xfs_error_report+0x3f/0x50 [xfs] 
[ 3025.100415]  [<ffffffffa01c375e>] ? xfs_bmbt_write_verify+0xe/0x10 [xfs] 
[ 3025.107163]  [<ffffffffa019917e>] xfs_corruption_error+0x5e/0x90 [xfs] 
[ 3025.113744]  [<ffffffffa01c375e>] ? xfs_bmbt_write_verify+0xe/0x10 [xfs] 
[ 3025.120495]  [<ffffffffa01c3606>] xfs_bmbt_verify+0x76/0x1c0 [xfs] 
[ 3025.126737]  [<ffffffffa01c375e>] ? xfs_bmbt_write_verify+0xe/0x10 [xfs] 
[ 3025.133481]  [<ffffffffa01975e5>] ? xfs_bdstrat_cb+0x65/0xd0 [xfs] 
[ 3025.139714]  [<ffffffffa01c375e>] xfs_bmbt_write_verify+0xe/0x10 [xfs] 
[ 3025.146287]  [<ffffffffa019713e>] _xfs_buf_ioapply+0x5e/0x370 [xfs] 
[ 3025.152565]  [<ffffffff81097c70>] ? try_to_wake_up+0x2d0/0x2d0 
[ 3025.158442]  [<ffffffffa01975e5>] ? xfs_bdstrat_cb+0x65/0xd0 [xfs] 
[ 3025.164669]  [<ffffffffa019752a>] xfs_buf_iorequest+0x4a/0xa0 [xfs] 
[ 3025.170979]  [<ffffffffa01975e5>] xfs_bdstrat_cb+0x65/0xd0 [xfs] 
[ 3025.177032]  [<ffffffffa01977c1>] __xfs_buf_delwri_submit+0x171/0x1e0 [xfs] 
[ 3025.184038]  [<ffffffffa0198110>] ? xfs_buf_delwri_submit_nowait+0x20/0x30 [xfs] 
[ 3025.191491]  [<ffffffffa01f1100>] ? xfs_trans_ail_cursor_first+0x80/0xb0 [xfs] 
[ 3025.198755]  [<ffffffffa0198110>] xfs_buf_delwri_submit_nowait+0x20/0x30 [xfs] 
[ 3025.206030]  [<ffffffffa01f1352>] xfsaild+0x222/0x5e0 [xfs] 
[ 3025.211665]  [<ffffffffa01f1130>] ? xfs_trans_ail_cursor_first+0xb0/0xb0 [xfs] 
[ 3025.218890]  [<ffffffff81085b10>] kthread+0xc0/0xd0 
[ 3025.223784]  [<ffffffff81085a50>] ? kthread_create_on_node+0x120/0x120 
[ 3025.230317]  [<ffffffff816176ec>] ret_from_fork+0x7c/0xb0 
[ 3025.235721]  [<ffffffff81085a50>] ? kthread_create_on_node+0x120/0x120 
[ 3025.242248] XFS (dm-1): Corruption detected. Unmount and run xfs_repair 
[ 3025.248865] XFS (dm-1): xfs_do_force_shutdown(0x8) called from line 1340 of file fs/xfs/xfs_buf.c.  Return address = 0xffffffffa0197411 

Does this ring any bell?

Regards,
CAI Qian

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
