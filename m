Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1KB0t8i171776 for <xfs@oss.sgi.com>; Fri, 20 Feb 2009 05:00:55 -0600
Received: from mail-ew0-f21.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9746D1BBFCC6
	for <xfs@oss.sgi.com>; Fri, 20 Feb 2009 03:00:22 -0800 (PST)
Received: from mail-ew0-f21.google.com (mail-ew0-f21.google.com
	[209.85.219.21]) by cuda.sgi.com with ESMTP id P28tJCeZ1AAT3myp
	for <xfs@oss.sgi.com>; Fri, 20 Feb 2009 03:00:22 -0800 (PST)
Received: by ewy14 with SMTP id 14so794959ewy.20
	for <xfs@oss.sgi.com>; Fri, 20 Feb 2009 03:00:21 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 20 Feb 2009 14:00:21 +0300
Message-ID: <a4423d670902200300n1d1bfdeeg6daca4b32989c9d3@mail.gmail.com>
Subject: next-20090220: XFS, IMA: BUG: sleeping function called from invalid
	context at mm/slub.c:1613
From: Alexander Beregalov <a.beregalov@gmail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: LKML <linux-kernel@vger.kernel.org>, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>, xfs@oss.sgi.com, Mimi Zohar <zohar@linux.vnet.ibm.com>

Hi

I have applied the following patch from Mimi Zohar
http://marc.info/?l=linux-next&m=123509665514552

That is why it is dirty.
The kernel can not boot without it when IMA is enabled.


BUG: sleeping function called from invalid context at mm/slub.c:1613
in_atomic(): 1, irqs_disabled(): 0, pid: 1514, name: mkdir
3 locks held by mkdir/1514:
 #0:  (&type->i_mutex_dir_key#2/1){+.+.+.}, at: [<ffffffff802d3460>]
lookup_create+0x30/0xd0
 #1:  (&(&ip->i_lock)->mr_lock/1){+.+.+.}, at: [<ffffffff803ca77f>]
xfs_ilock+0xdf/0x120
 #2:  (&pag->pag_ici_lock){++++.+}, at: [<ffffffff803caed6>]
xfs_iget+0x156/0x650
Pid: 1514, comm: mkdir Not tainted 2.6.29-rc5-next-20090220-dirty #1
Call Trace:
 [<ffffffff8026ad33>] ? __debug_show_held_locks+0x13/0x30
 [<ffffffff80234fe5>] __might_sleep+0x105/0x140
 [<ffffffff802c6191>] kmem_cache_alloc+0xd1/0x100
 [<ffffffff8045fb29>] ima_iint_insert+0x49/0xf0
 [<ffffffff8045fbed>] ima_inode_alloc+0x1d/0x30
 [<ffffffff802dfa5f>] inode_init_always+0xaf/0x250
 [<ffffffff803caf86>] xfs_iget+0x206/0x650
 [<ffffffff803eb8e8>] xfs_trans_iget+0x208/0x250
 [<ffffffff803ce571>] xfs_ialloc+0xc1/0x700
 [<ffffffff803ec6f9>] xfs_dir_ialloc+0xa9/0x340
 [<ffffffff8025e009>] ? down_write_nested+0x79/0x90
 [<ffffffff803ef0c1>] xfs_create+0x3e1/0x690
 [<ffffffff803fb813>] xfs_vn_mknod+0x63/0xf0
 [<ffffffff803fb8ae>] xfs_vn_mkdir+0xe/0x10
 [<ffffffff802d487c>] vfs_mkdir+0x8c/0xd0
 [<ffffffff802d6a56>] sys_mkdirat+0x106/0x120
 [<ffffffff8020bc0c>] ? sysret_check+0x27/0x62
 [<ffffffff8026c79d>] ? trace_hardirqs_on_caller+0x17d/0x1e0
 [<ffffffff802d6a83>] sys_mkdir+0x13/0x20
 [<ffffffff8020bbdb>] system_call_fastpath+0x16/0x1b
BUG: sleeping function called from invalid context at mm/slub.c:1613
in_atomic(): 1, irqs_disabled(): 0, pid: 1514, name: mkdir
3 locks held by mkdir/1514:
 #0:  (&type->i_mutex_dir_key#2/1){+.+.+.}, at: [<ffffffff802d3460>]
lookup_create+0x30/0xd0
 #1:  (&(&ip->i_lock)->mr_lock/1){+.+.+.}, at: [<ffffffff803ca77f>]
xfs_ilock+0xdf/0x120
 #2:  (&pag->pag_ici_lock){++++.+}, at: [<ffffffff803caed6>]
xfs_iget+0x156/0x650
Pid: 1514, comm: mkdir Not tainted 2.6.29-rc5-next-20090220-dirty #1
Call Trace:
 [<ffffffff8026ad33>] ? __debug_show_held_locks+0x13/0x30
 [<ffffffff80234fe5>] __might_sleep+0x105/0x140
 [<ffffffff802c6191>] kmem_cache_alloc+0xd1/0x100
 [<ffffffff8048131a>] radix_tree_preload+0x6a/0xf0
 [<ffffffff8045fb3b>] ima_iint_insert+0x5b/0xf0
 [<ffffffff8045fbed>] ima_inode_alloc+0x1d/0x30
 [<ffffffff802dfa5f>] inode_init_always+0xaf/0x250
 [<ffffffff803caf86>] xfs_iget+0x206/0x650
 [<ffffffff803eb8e8>] xfs_trans_iget+0x208/0x250
 [<ffffffff803ce571>] xfs_ialloc+0xc1/0x700
 [<ffffffff803ec6f9>] xfs_dir_ialloc+0xa9/0x340
 [<ffffffff8025e009>] ? down_write_nested+0x79/0x90
 [<ffffffff803ef0c1>] xfs_create+0x3e1/0x690
 [<ffffffff803fb813>] xfs_vn_mknod+0x63/0xf0
 [<ffffffff803fb8ae>] xfs_vn_mkdir+0xe/0x10
 [<ffffffff802d487c>] vfs_mkdir+0x8c/0xd0
 [<ffffffff802d6a56>] sys_mkdirat+0x106/0x120
 [<ffffffff8020bc0c>] ? sysret_check+0x27/0x62
 [<ffffffff8026c79d>] ? trace_hardirqs_on_caller+0x17d/0x1e0
 [<ffffffff802d6a83>] sys_mkdir+0x13/0x20
 [<ffffffff8020bbdb>] system_call_fastpath+0x16/0x1b

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
