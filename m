Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E7ED27F3F
	for <xfs@oss.sgi.com>; Tue, 17 Jun 2014 03:51:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D63AF304059
	for <xfs@oss.sgi.com>; Tue, 17 Jun 2014 01:51:42 -0700 (PDT)
Received: from fgwmail2.fujitsu.co.jp (fgwmail2.fujitsu.co.jp [164.71.1.135])
	by cuda.sgi.com with ESMTP id 8TVwVLEz1wobUhpX (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 17 Jun 2014 01:51:41 -0700 (PDT)
Received: from kw-mxauth.gw.nic.fujitsu.com (unknown [10.0.237.134])
	by fgwmail2.fujitsu.co.jp (Postfix) with ESMTP id 53F653EE0C7
	for <xfs@oss.sgi.com>; Tue, 17 Jun 2014 17:51:39 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.nic.fujitsu.com [10.0.50.94])
	by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 6B800AC02CD
	for <xfs@oss.sgi.com>; Tue, 17 Jun 2014 17:51:38 +0900 (JST)
Received: from g01jpfmpwyt02.exch.g01.fujitsu.local
	(g01jpfmpwyt02.exch.g01.fujitsu.local [10.128.193.56])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 128851DB8037
	for <xfs@oss.sgi.com>; Tue, 17 Jun 2014 17:51:38 +0900 (JST)
Message-ID: <53A0013A.1010100@jp.fujitsu.com>
Date: Tue, 17 Jun 2014 17:50:02 +0900
From: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
MIME-Version: 1.0
Subject: xfs: two deadlock problems occur when kswapd writebacks XFS pages.
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-mm@kvack.org, xfs@oss.sgi.com

I found two deadlock problems occur when kswapd writebacks XFS pages.
I detected these problems on RHEL kernel actually, and I suppose these
also happen on upstream kernel (3.16-rc1).

1.

A process (processA) has acquired read semaphore "xfs_cil.xc_ctx_lock"
at xfs_log_commit_cil() and it is waiting for the kswapd. Then, a
kworker has issued xlog_cil_push_work() and it is waiting for acquiring
the write semaphore. kswapd is waiting for acquiring the read semaphore
at xfs_log_commit_cil() because the kworker has been waiting before for
acquiring the write semaphore at xlog_cil_push(). Therefore, a deadlock
happens.

The deadlock flow is as follows.

  processA              | kworker                  | kswapd              
  ----------------------+--------------------------+----------------------
| xfs_trans_commit      |                          |
| xfs_log_commit_cil    |                          |
| down_read(xc_ctx_lock)|                          |
| xlog_cil_insert_items |                          |
| xlog_cil_insert_format_items                     |
| kmem_alloc            |                          |
| :                     |                          |
| shrink_inactive_list  |                          |
| congestion_wait       |                          |
| # waiting for kswapd..|                          |
|                       | xlog_cil_push_work       |
|                       | xlog_cil_push            |
|                       | xfs_trans_commit         |
|                       | down_write(xc_ctx_lock)  |
|                       | # waiting for processA...|
|                       |                          | shrink_page_list
|                       |                          | xfs_vm_writepage
|                       |                          | xfs_map_blocks
|                       |                          | xfs_iomap_write_allocate
|                       |                          | xfs_trans_commit
|                       |                          | xfs_log_commit_cil
|                       |                          | down_read(xc_ctx_lock)
V(time)                 |                          | # waiting for kworker...
  ----------------------+--------------------------+-----------------------

To fix this, should we up the read semaphore before calling kmem_alloc()
at xlog_cil_insert_format_items() to avoid blocking the kworker? Or,
should we the second argument of kmem_alloc() from KM_SLEEP|KM_NOFS
to KM_NOSLEEP to avoid waiting for the kswapd. Or...

2. 

A kworker (kworkerA), whish is a writeback thread, is waiting for
the XFS allocation thread (kworkerB) while it writebacks XFS pages.
kworkerB has started the allocation and it is waiting for kswapd to
allocate free pages. kswapd has started writeback XFS pages and
it is waiting for more log space. The reason why exhaustion of the
log space is both the writeback thread and kswapd are stuck, so
some processes, who have allocated the log space and are requesting
free pages, are also stuck.

The deadlock flow is as follows.

  kworkerA              | kworkerB                 | kswapd            
  ----------------------+--------------------------+-----------------------
| wb_writeback          |                          |
| :                     |                          |
| xfs_vm_writepage      |                          |
| xfs_map_blocks        |                          |
| xfs_iomap_write_allocate                         |
| xfs_bmapi_write       |                          |
| xfs_bmapi_allocate    |                          |
| wait_for_completion   |                          |
| # waiting for kworkerB...                        |
|                       | xfs_bmapi_allocate_worker|
|                       | :                        |
|                       | xfs_buf_get_map          |
|                       | xfs_buf_allocate_memory  |
|                       | alloc_pages_current      |
|                       | :                        |
|                       | shrink_inactive_list     |
|                       | congestion_wait          |
|                       | # waiting for kswapd...  |
|                       |                          | shrink_page_list
|                       |                          | xfs_vm_writepage
|                       |                          | :
|                       |                          | xfs_log_reserve
|                       |                          | :
|                       |                          | xlog_grant_head_check
|                       |                          | xlog_grant_head_wait
|                       |                          | # waiting for more
|                       |                          | # space...
V(time)                 |                          |
  ----------------------+--------------------------+-----------------------

I don't have any ideas to fix this...

Thanks,
Masayoshi Mizuma

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
