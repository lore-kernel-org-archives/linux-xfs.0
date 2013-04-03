Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7B04B7F3F
	for <xfs@oss.sgi.com>; Wed,  3 Apr 2013 14:33:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 679BF8F8049
	for <xfs@oss.sgi.com>; Wed,  3 Apr 2013 12:33:13 -0700 (PDT)
Received: from mail-ve0-f172.google.com (mail-ve0-f172.google.com
	[209.85.128.172]) by cuda.sgi.com with ESMTP id
	Jk5yEXcJlS9sy9KT (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 03 Apr 2013 12:33:12 -0700 (PDT)
Received: by mail-ve0-f172.google.com with SMTP id oz10so2051665veb.3
	for <xfs@oss.sgi.com>; Wed, 03 Apr 2013 12:33:11 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 3 Apr 2013 15:33:11 -0400
Message-ID: <CAH4wwdF+gQTnbUR89e2KCUUJfS_cT_09wzmS55vys5rfbStW7Q@mail.gmail.com>
Subject: xfs_iomap_write_unwritten stuck in congestion_wait?
From: Peter Watkins <treestem@gmail.com>
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
To: xfs@oss.sgi.com

Hello,

Wondering if anyone has a suggestion for when
xfs_iomap_write_unwritten gets into congestion_wait.

In this case the system has almost half of normal zone pages in
NR_WRITEBACK with pretty much everybody held up in either
congestion_wait or balance_dirty_pages.

Since there are some free pages, seems like we'd be better off just
using a little more memory to finish this IO and in turn reduce pages
under write-back and add to free memory, rather than holding up here.
So maybe PF_MEMALLOC?

It also looks like this path allocates log vectors with KM_SLEEP but
lv_buf's with KM_SLEEP|KM_NOFS. Why is that?

PID: 7011   TASK: ffff880226282040  CPU: 2   COMMAND: "xfsconvertd/2"
 #0 [ffff88022629b550] schedule at ffffffff814f5862
 #1 [ffff88022629b618] schedule_timeout at ffffffff814f66a2
 #2 [ffff88022629b6c8] io_schedule_timeout at ffffffff814f532f
 #3 [ffff88022629b6f8] congestion_wait at ffffffff81137450
 #4 [ffff88022629b758] throttle_vm_writeout at ffffffff81128c78
 #5 [ffff88022629b798] shrink_zone at ffffffff8112ea3b
 #6 [ffff88022629b848] do_try_to_free_pages at ffffffff8112ecfe
 #7 [ffff88022629b8d8] try_to_free_pages at ffffffff8112f30d
 #8 [ffff88022629b988] __alloc_pages_nodemask at ffffffff81126797
 #9 [ffff88022629ba98] kmem_getpages at ffffffff8115db12
#10 [ffff88022629bac8] fallback_alloc at ffffffff8115e72a
#11 [ffff88022629bb48] ____cache_alloc_node at ffffffff8115e4a9
#12 [ffff88022629bba8] __kmalloc at ffffffff8115f0d9
#13 [ffff88022629bbf8] kmem_alloc at ffffffffa02d69f7
#14 [ffff88022629bc38] xfs_log_commit_cil at ffffffffa02c3ebd
#15 [ffff88022629bcb8] _xfs_trans_commit at ffffffffa02cfe99
#16 [ffff88022629bd18] xfs_iomap_write_unwritten at ffffffffa02bce01
#17 [ffff88022629be18] xfs_end_io at ffffffffa02d72bb
#18 [ffff88022629be38] worker_thread at ffffffff8108c6a0
#19 [ffff88022629bee8] kthread at ffffffff81091ca6
#20 [ffff88022629bf48] kernel_thread at ffffffff8100c14a

Apologies in advance, this is an older kernel (2.6.32-279) but has
many more recent patches (thank-you!)

-Peter

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
