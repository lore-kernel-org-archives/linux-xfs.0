Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 89CA37F3F
	for <xfs@oss.sgi.com>; Wed, 18 Jun 2014 04:37:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 735178F8065
	for <xfs@oss.sgi.com>; Wed, 18 Jun 2014 02:37:52 -0700 (PDT)
Received: from fgwmail.fujitsu.co.jp (fgwmail.fujitsu.co.jp [164.71.1.133]) by
	cuda.sgi.com with ESMTP id JDwdtEhKNChFGnKs (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 18 Jun 2014 02:37:49 -0700 (PDT)
Received: from kw-mxoi1.gw.nic.fujitsu.com (unknown [10.0.237.133])
	by fgwmail.fujitsu.co.jp (Postfix) with ESMTP id 201B63EE0BD
	for <xfs@oss.sgi.com>; Wed, 18 Jun 2014 18:37:48 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.nic.fujitsu.com [10.0.50.93])
	by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 39101AC060F
	for <xfs@oss.sgi.com>; Wed, 18 Jun 2014 18:37:47 +0900 (JST)
Received: from g01jpfmpwyt03.exch.g01.fujitsu.local
	(g01jpfmpwyt03.exch.g01.fujitsu.local [10.128.193.57])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id DCC69E18002
	for <xfs@oss.sgi.com>; Wed, 18 Jun 2014 18:37:46 +0900 (JST)
Message-ID: <53A15DC7.50001@jp.fujitsu.com>
Date: Wed, 18 Jun 2014 18:37:11 +0900
From: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
MIME-Version: 1.0
Subject: Re: xfs: two deadlock problems occur when kswapd writebacks XFS pages.
References: <53A0013A.1010100@jp.fujitsu.com> <20140617132609.GI9508@dastard>
In-Reply-To: <20140617132609.GI9508@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-mm@kvack.org, xfs@oss.sgi.com


On Tue, 17 Jun 2014 23:26:09 +1000 Dave Chinner wrote:
> On Tue, Jun 17, 2014 at 05:50:02PM +0900, Masayoshi Mizuma wrote:
>> I found two deadlock problems occur when kswapd writebacks XFS pages.
>> I detected these problems on RHEL kernel actually, and I suppose these
>> also happen on upstream kernel (3.16-rc1).
>>
>> 1.
>>
>> A process (processA) has acquired read semaphore "xfs_cil.xc_ctx_lock"
>> at xfs_log_commit_cil() and it is waiting for the kswapd. Then, a
>> kworker has issued xlog_cil_push_work() and it is waiting for acquiring
>> the write semaphore. kswapd is waiting for acquiring the read semaphore
>> at xfs_log_commit_cil() because the kworker has been waiting before for
>> acquiring the write semaphore at xlog_cil_push(). Therefore, a deadlock
>> happens.
>>
>> The deadlock flow is as follows.
>>
>>    processA              | kworker                  | kswapd
>>    ----------------------+--------------------------+----------------------
>> | xfs_trans_commit      |                          |
>> | xfs_log_commit_cil    |                          |
>> | down_read(xc_ctx_lock)|                          |
>> | xlog_cil_insert_items |                          |
>> | xlog_cil_insert_format_items                     |
>> | kmem_alloc            |                          |
>> | :                     |                          |
>> | shrink_inactive_list  |                          |
>> | congestion_wait       |                          |
>> | # waiting for kswapd..|                          |
>> |                       | xlog_cil_push_work       |
>> |                       | xlog_cil_push            |
>> |                       | xfs_trans_commit         |
>> |                       | down_write(xc_ctx_lock)  |
>> |                       | # waiting for processA...|
>> |                       |                          | shrink_page_list
>> |                       |                          | xfs_vm_writepage
>> |                       |                          | xfs_map_blocks
>> |                       |                          | xfs_iomap_write_allocate
>> |                       |                          | xfs_trans_commit
>> |                       |                          | xfs_log_commit_cil
>> |                       |                          | down_read(xc_ctx_lock)
>> V(time)                 |                          | # waiting for kworker...
>>    ----------------------+--------------------------+-----------------------
>
> Where's the deadlock here? congestion_wait() simply times out and
> processA continues onward doing memory reclaim. It should continue
> making progress, albeit slowly, and if it isn't then the allocation
> will fail. If the allocation repeatedly fails then you should be
> seeing this in the logs:
>
> XFS: possible memory allocation deadlock in <func> (mode:0x%x)
>
> If you aren't seeing that in the logs a few times a second and never
> stopping, then the system is still making progress and isn't
> deadlocked.

processA is stuck at following while loop. In this situation,
too_many_isolated() always returns true because kswapd is also stuck...

---
static noinline_for_stack unsigned long
shrink_inactive_list(unsigned long nr_to_scan, struct lruvec *lruvec,
                      struct scan_control *sc, enum lru_list lru)
{
...
         while (unlikely(too_many_isolated(zone, file, sc))) {
                 congestion_wait(BLK_RW_ASYNC, HZ/10);

                 /* We are about to die and free our memory. Return now. */
                 if (fatal_signal_pending(current))
                         return SWAP_CLUSTER_MAX;
         }
---

On that point, this problem is similar to the problem fixed by
the following commit.

1f6d64829d xfs: block allocation work needs to be kswapd aware

So, the same solution, for example we add PF_KSWAPD to current->flags
before calling kmem_alloc(), may fix this problem1...

>
>> To fix this, should we up the read semaphore before calling kmem_alloc()
>> at xlog_cil_insert_format_items() to avoid blocking the kworker? Or,
>> should we the second argument of kmem_alloc() from KM_SLEEP|KM_NOFS
>> to KM_NOSLEEP to avoid waiting for the kswapd. Or...
>
> Can't do that - it's in transaction context and so reclaim can't
> recurse into the fs. Even if you do remove the flag, kmem_alloc()
> will re-add the GFP_NOFS silently because of the PF_FSTRANS flag on
> the task, so it won't affect anything...

I think kmem_alloc() doesn't re-add the GFP_NOFS if the second argument
is set to KM_NOSLEEP. kmem_alloc() will re-add GFP_ATOMIC and __GFP_NOWARN.

---
static inline gfp_t
kmem_flags_convert(xfs_km_flags_t flags)
{
         gfp_t   lflags;

         BUG_ON(flags & ~(KM_SLEEP|KM_NOSLEEP|KM_NOFS|KM_MAYFAIL|KM_ZERO));

         if (flags & KM_NOSLEEP) {
                 lflags = GFP_ATOMIC | __GFP_NOWARN;
         } else {
                 lflags = GFP_KERNEL | __GFP_NOWARN;
                 if ((current->flags & PF_FSTRANS) || (flags & KM_NOFS))
                         lflags &= ~__GFP_FS;
         }

         if (flags & KM_ZERO)
                 lflags |= __GFP_ZERO;

         return lflags;
}
---

>
> We might be able to do a down_write_trylock() in xlog_cil_push(),
> but we can't delay the push for an arbitrary amount of time - the
> write lock needs to be a barrier otherwise we'll get push
> starvation and that will lead to checkpoint size overruns (i.e.
> temporary journal corruption).

I understand, thanks.

>
>> 2.
>>
>> A kworker (kworkerA), whish is a writeback thread, is waiting for
>> the XFS allocation thread (kworkerB) while it writebacks XFS pages.
>> kworkerB has started the allocation and it is waiting for kswapd to
>> allocate free pages. kswapd has started writeback XFS pages and
>> it is waiting for more log space. The reason why exhaustion of the
>> log space is both the writeback thread and kswapd are stuck, so
>> some processes, who have allocated the log space and are requesting
>> free pages, are also stuck.
>>
>> The deadlock flow is as follows.
>>
>>    kworkerA              | kworkerB                 | kswapd
>>    ----------------------+--------------------------+-----------------------
>> | wb_writeback          |                          |
>> | :                     |                          |
>> | xfs_vm_writepage      |                          |
>> | xfs_map_blocks        |                          |
>> | xfs_iomap_write_allocate                         |
>> | xfs_bmapi_write       |                          |
>> | xfs_bmapi_allocate    |                          |
>> | wait_for_completion   |                          |
>> | # waiting for kworkerB...                        |
>> |                       | xfs_bmapi_allocate_worker|
>> |                       | :                        |
>> |                       | xfs_buf_get_map          |
>> |                       | xfs_buf_allocate_memory  |
>> |                       | alloc_pages_current      |
>> |                       | :                        |
>> |                       | shrink_inactive_list     |
>> |                       | congestion_wait          |
>> |                       | # waiting for kswapd...  |
>> |                       |                          | shrink_page_list
>> |                       |                          | xfs_vm_writepage
>> |                       |                          | :
>> |                       |                          | xfs_log_reserve
>> |                       |                          | :
>> |                       |                          | xlog_grant_head_check
>> |                       |                          | xlog_grant_head_wait
>> |                       |                          | # waiting for more
>> |                       |                          | # space...
>> V(time)                 |                          |
>>    ----------------------+--------------------------+-----------------------
>
> Again, anything in congestion_wait() is not stuck and if the
> allocations here are repeatedly failing and progress is not being
> made, then there should be log messages from XFS indicating this.

kworkerB is stuck at the same reason as above processA.

>
> I need more information about your test setup to understand what is
> going on here. Can you provide:
>
> http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F
>
> The output of sysrq-w would also be useful here, because the above
> abridged stack traces do not tell me everything about the state of
> the system I need to know.

OK, I will try to get the information when this problem2 is reproduced.

Thanks,
Masayoshi Mizuma

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
