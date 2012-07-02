Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q62JEIhJ261124 for <xfs@oss.sgi.com>; Mon, 2 Jul 2012 14:14:24 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 949EpmZPXKGNFKXN for
	<xfs@oss.sgi.com>; Mon, 02 Jul 2012 12:14:18 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q62JEIaD029675
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 2 Jul 2012 15:14:18 -0400
Date: Mon, 2 Jul 2012 15:14:12 -0400
From: Mike Snitzer <snitzer@redhat.com>
Subject: xfs_btree_cur leak with 3.5-rc4
Message-ID: <20120702191412.GA3617@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com
Cc: dm-devel@redhat.com

I get kmemleak reports against XFS when I run the thinp-test-suite
against 3.5-rc4.  I didn't see any XFS leaks with 3.4.

kmemleak reports:

unreferenced object 0xffff8802767798a0 (size 208):
  comm "kworker/4:1", pid 25239, jiffies 4799921469 (age 5830.005s)
  hex dump (first 32 bytes):
    70 5c 6b ab 02 88 ff ff 00 58 0d 2c 03 88 ff ff  p\k......X.,....
    c0 8e 7d a0 ff ff ff ff 04 00 00 00 00 00 00 00  ..}.............
  backtrace:
    [<ffffffff814b6e3e>] kmemleak_alloc+0x5e/0xc0
    [<ffffffff8114c4b3>] kmem_cache_alloc+0x103/0x1d0
    [<ffffffffa078d987>] kmem_zone_alloc+0x77/0xf0 [xfs]
    [<ffffffffa078da1e>] kmem_zone_zalloc+0x1e/0x50 [xfs]
    [<ffffffffa0791c4c>] xfs_allocbt_init_cursor+0x4c/0xd0 [xfs]
    [<ffffffffa07902a8>] xfs_alloc_ag_vextent_near+0x68/0xb70 [xfs]
    [<ffffffffa0790e85>] xfs_alloc_ag_vextent+0xd5/0x100 [xfs]
    [<ffffffffa0791744>] __xfs_alloc_vextent+0x2a4/0x5f0 [xfs]
    [<ffffffffa0791ada>] xfs_alloc_vextent_worker+0x4a/0x80 [xfs]
    [<ffffffff8105a3f2>] process_one_work+0x132/0x450
    [<ffffffff8105c1fb>] worker_thread+0x17b/0x3c0
    [<ffffffff8106137e>] kthread+0x9e/0xb0
    [<ffffffff814d7ca4>] kernel_thread_helper+0x4/0x10
    [<ffffffffffffffff>] 0xffffffffffffffff

unloading the xfs module reports:

slab error in kmem_cache_destroy(): cache `xfs_btree_cur': Can't free all objects
Pid: 26305, comm: modprobe Tainted: G        W  O 3.5.0-rc4.cache+ #2
Call Trace:
 [<ffffffff8114ca3f>] kmem_cache_destroy+0xaf/0xe0
 [<ffffffffa0788074>] xfs_destroy_zones+0xc4/0x110 [xfs]
 [<ffffffffa07d32b3>] exit_xfs_fs+0x33/0x35 [xfs]
 [<ffffffff8109f82f>] sys_delete_module+0x1cf/0x2c0
 [<ffffffff810bb39c>] ? __audit_syscall_entry+0xcc/0x210
 [<ffffffff814d69a9>] system_call_fastpath+0x16/0x1b

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
