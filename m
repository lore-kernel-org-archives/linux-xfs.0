Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AB40A7F58
	for <xfs@oss.sgi.com>; Tue, 17 Jun 2014 08:26:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A3F518F8040
	for <xfs@oss.sgi.com>; Tue, 17 Jun 2014 06:26:29 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	rM8gZfbZQFRywv3a for <xfs@oss.sgi.com>;
	Tue, 17 Jun 2014 06:26:26 -0700 (PDT)
Date: Tue, 17 Jun 2014 23:26:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs: two deadlock problems occur when kswapd writebacks XFS pages.
Message-ID: <20140617132609.GI9508@dastard>
References: <53A0013A.1010100@jp.fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53A0013A.1010100@jp.fujitsu.com>
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
To: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
Cc: linux-mm@kvack.org, xfs@oss.sgi.com

On Tue, Jun 17, 2014 at 05:50:02PM +0900, Masayoshi Mizuma wrote:
> I found two deadlock problems occur when kswapd writebacks XFS pages.
> I detected these problems on RHEL kernel actually, and I suppose these
> also happen on upstream kernel (3.16-rc1).
> 
> 1.
> 
> A process (processA) has acquired read semaphore "xfs_cil.xc_ctx_lock"
> at xfs_log_commit_cil() and it is waiting for the kswapd. Then, a
> kworker has issued xlog_cil_push_work() and it is waiting for acquiring
> the write semaphore. kswapd is waiting for acquiring the read semaphore
> at xfs_log_commit_cil() because the kworker has been waiting before for
> acquiring the write semaphore at xlog_cil_push(). Therefore, a deadlock
> happens.
> 
> The deadlock flow is as follows.
> 
>   processA              | kworker                  | kswapd              
>   ----------------------+--------------------------+----------------------
> | xfs_trans_commit      |                          |
> | xfs_log_commit_cil    |                          |
> | down_read(xc_ctx_lock)|                          |
> | xlog_cil_insert_items |                          |
> | xlog_cil_insert_format_items                     |
> | kmem_alloc            |                          |
> | :                     |                          |
> | shrink_inactive_list  |                          |
> | congestion_wait       |                          |
> | # waiting for kswapd..|                          |
> |                       | xlog_cil_push_work       |
> |                       | xlog_cil_push            |
> |                       | xfs_trans_commit         |
> |                       | down_write(xc_ctx_lock)  |
> |                       | # waiting for processA...|
> |                       |                          | shrink_page_list
> |                       |                          | xfs_vm_writepage
> |                       |                          | xfs_map_blocks
> |                       |                          | xfs_iomap_write_allocate
> |                       |                          | xfs_trans_commit
> |                       |                          | xfs_log_commit_cil
> |                       |                          | down_read(xc_ctx_lock)
> V(time)                 |                          | # waiting for kworker...
>   ----------------------+--------------------------+-----------------------

Where's the deadlock here? congestion_wait() simply times out and
processA continues onward doing memory reclaim. It should continue
making progress, albeit slowly, and if it isn't then the allocation
will fail. If the allocation repeatedly fails then you should be
seeing this in the logs:

XFS: possible memory allocation deadlock in <func> (mode:0x%x)

If you aren't seeing that in the logs a few times a second and never
stopping, then the system is still making progress and isn't
deadlocked.

> To fix this, should we up the read semaphore before calling kmem_alloc()
> at xlog_cil_insert_format_items() to avoid blocking the kworker? Or,
> should we the second argument of kmem_alloc() from KM_SLEEP|KM_NOFS
> to KM_NOSLEEP to avoid waiting for the kswapd. Or...

Can't do that - it's in transaction context and so reclaim can't
recurse into the fs. Even if you do remove the flag, kmem_alloc()
will re-add the GFP_NOFS silently because of the PF_FSTRANS flag on
the task, so it won't affect anything...

We might be able to do a down_write_trylock() in xlog_cil_push(),
but we can't delay the push for an arbitrary amount of time - the
write lock needs to be a barrier otherwise we'll get push
starvation and that will lead to checkpoint size overruns (i.e.
temporary journal corruption).

> 2. 
> 
> A kworker (kworkerA), whish is a writeback thread, is waiting for
> the XFS allocation thread (kworkerB) while it writebacks XFS pages.
> kworkerB has started the allocation and it is waiting for kswapd to
> allocate free pages. kswapd has started writeback XFS pages and
> it is waiting for more log space. The reason why exhaustion of the
> log space is both the writeback thread and kswapd are stuck, so
> some processes, who have allocated the log space and are requesting
> free pages, are also stuck.
> 
> The deadlock flow is as follows.
> 
>   kworkerA              | kworkerB                 | kswapd            
>   ----------------------+--------------------------+-----------------------
> | wb_writeback          |                          |
> | :                     |                          |
> | xfs_vm_writepage      |                          |
> | xfs_map_blocks        |                          |
> | xfs_iomap_write_allocate                         |
> | xfs_bmapi_write       |                          |
> | xfs_bmapi_allocate    |                          |
> | wait_for_completion   |                          |
> | # waiting for kworkerB...                        |
> |                       | xfs_bmapi_allocate_worker|
> |                       | :                        |
> |                       | xfs_buf_get_map          |
> |                       | xfs_buf_allocate_memory  |
> |                       | alloc_pages_current      |
> |                       | :                        |
> |                       | shrink_inactive_list     |
> |                       | congestion_wait          |
> |                       | # waiting for kswapd...  |
> |                       |                          | shrink_page_list
> |                       |                          | xfs_vm_writepage
> |                       |                          | :
> |                       |                          | xfs_log_reserve
> |                       |                          | :
> |                       |                          | xlog_grant_head_check
> |                       |                          | xlog_grant_head_wait
> |                       |                          | # waiting for more
> |                       |                          | # space...
> V(time)                 |                          |
>   ----------------------+--------------------------+-----------------------

Again, anything in congestion_wait() is not stuck and if the
allocations here are repeatedly failing and progress is not being
made, then there should be log messages from XFS indicating this.

I need more information about your test setup to understand what is
going on here. Can you provide:

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

The output of sysrq-w would also be useful here, because the above
abridged stack traces do not tell me everything about the state of
the system I need to know.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
