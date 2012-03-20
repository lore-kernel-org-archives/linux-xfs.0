Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2KGYJmt254539 for <xfs@oss.sgi.com>; Tue, 20 Mar 2012 11:34:19 -0500
Message-ID: <4F68B188.4020407@sgi.com>
Date: Tue, 20 Mar 2012 11:34:16 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 05/10] xfs: introduce an allocation workqueue
References: <1331095828-28742-1-git-send-email-david@fromorbit.com>
	<1331095828-28742-6-git-send-email-david@fromorbit.com>
	<4F676330.1070005@sgi.com> <20120319222016.GZ3592@dastard>
In-Reply-To: <20120319222016.GZ3592@dastard>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 03/19/12 17:20, Dave Chinner wrote:
> On Mon, Mar 19, 2012 at 11:47:44AM -0500, Mark Tinguely wrote:
>> On 03/06/12 22:50, Dave Chinner wrote:
>>> From: Dave Chinner<dchinner@redhat.com>
>>>
>>> We currently have significant issues with the amount of stack that
>>> allocation in XFS uses, especially in the writeback path. We can
>>> easily consume 4k of stack between mapping the page, manipulating
>>> the bmap btree and allocating blocks from the free list. Not to
>>> mention btree block readahead and other functionality that issues IO
>>> in the allocation path.
>>>
>>> As a result, we can no longer fit allocation in the writeback path
>>> in the stack space provided on x86_64. To alleviate this problem,
>>> introduce an allocation workqueue and move all allocations to a
>>> seperate context. This can be easily added as an interposing layer
>>> into xfs_alloc_vextent(), which takes a single argument structure
>>> and does not return until the allocation is complete or has failed.
>>>
>>> To do this, add a work structure and a completion to the allocation
>>> args structure. This allows xfs_alloc_vextent to queue the args onto
>>> the workqueue and wait for it to be completed by the worker. This
>>> can be done completely transparently to the caller.
>>>
>>> The worker function needs to ensure that it sets and clears the
>>> PF_TRANS flag appropriately as it is being run in an active
>>> transaction context. Work can also be queued in a memory reclaim
>>> context, so a rescuer is needed for the workqueue.
>>>
>>> Signed-off-by: Dave Chinner<dchinner@redhat.com>
>>
>>
>> #include<std/disclaimer>	# speaking for myself
>>
>> As the problem is described above, it sounds like the STANDARD x86_64
>> configuration is in stack crisis needing to put a worker in-line to
>> solve the stack issue.
>>
>> Adding an in-line worker to fix a "stack crisis" without any other
>> measures and the Linux's implementation of the kernel stack (not
>> configurable on compilation, and requiring order of magnitude physical
>> allocation), sent me into a full blown rant last week.
>
> You think I like it?

No, no at all. Half of my ranting was about the kernel page limit.

>
>> The standard,
>> what? when? why? how? WTF? - you know the standard rant. I even
>> generated a couple yawns of response from people! :)
>
> Yeah, I know. Stack usage has been a problem for years and years. I
> even mentioned at last year's Kernel Summit that we needed to
> consider increasing the size of the kernel stack to 16KB to support
> typical storage configurations. That was met with the same old "so
> what?" response: "your filesystem code is broken". I still haven;t
> been able to get across that it isn't the filesystems that are
> causing the problems.
>
> For example, what's a typical memory allocation failure stack look
> like? Try this:
>
>
>    0)     5152     256   get_page_from_freelist+0x52d/0x840
>    1)     4896     272   __alloc_pages_nodemask+0x10e/0x760
>    2)     4624      48   kmem_getpages+0x70/0x170
>    3)     4576     112   cache_grow+0x2a9/0x2d0
>    4)     4464      80   cache_alloc_refill+0x1a3/0x1ea
>    5)     4384      80   kmem_cache_alloc+0x181/0x190
>    6)     4304      16   mempool_alloc_slab+0x15/0x20
>    7)     4288     128   mempool_alloc+0x5e/0x160
>    8)     4160      16   scsi_sg_alloc+0x44/0x50
>    9)     4144     112   __sg_alloc_table+0x67/0x140
>   10)     4032      32   scsi_init_sgtable+0x33/0x90
>   11)     4000      48   scsi_init_io+0x28/0xc0
>   12)     3952      32   scsi_setup_fs_cmnd+0x63/0xa0
>   13)     3920     112   sd_prep_fn+0x158/0xa70
>   14)     3808      64   blk_peek_request+0xb8/0x230
>   15)     3744      80   scsi_request_fn+0x54/0x3f0
>   16)     3664      80   queue_unplugged+0x55/0xf0
>   17)     3584     112   blk_flush_plug_list+0x1c3/0x220
>   18)     3472      32   io_schedule+0x78/0xd0
>   19)     3440      16   sleep_on_page+0xe/0x20
>   20)     3424      80   __wait_on_bit+0x5f/0x90
>   21)     3344      80   wait_on_page_bit+0x78/0x80
>   22)     3264     288   shrink_page_list+0x445/0x950
>   23)     2976     192   shrink_inactive_list+0x448/0x520
>   24)     2784     256   shrink_mem_cgroup_zone+0x421/0x520
>   25)     2528     144   do_try_to_free_pages+0x12f/0x3e0
>   26)     2384     192   try_to_free_pages+0xab/0x170
>   27)     2192     272   __alloc_pages_nodemask+0x4a8/0x760
>   28)     1920      48   kmem_getpages+0x70/0x170
>   29)     1872     112   fallback_alloc+0x1ff/0x220
>   30)     1760      96   ____cache_alloc_node+0x9a/0x150
>   31)     1664      32   __kmalloc+0x185/0x200
>   32)     1632     112   kmem_alloc+0x67/0xe0
>   33)     1520     144   xfs_log_commit_cil+0xfe/0x540
>   34)     1376      80   xfs_trans_commit+0xc2/0x2a0
>   35)     1296     192   xfs_dir_ialloc+0x120/0x320
>   36)     1104     208   xfs_create+0x4df/0x6b0
>   37)      896     112   xfs_vn_mknod+0x8f/0x1c0
>   38)      784      16   xfs_vn_create+0x13/0x20
>   39)      768      64   vfs_create+0xb4/0xf0
> ....


Wow, that much stack to clean and allocate a page. I am glad I did not
know that week, I would have had a stroke instead of a rant.

>
> That's just waiting for a page flag to clear triggering a plug
> flush, and that requires ~3600 bytes of stack. This is the swap
> path, not a filesystem path. This is also on a single SATA drive
> with no NFS, MD/DM, etc. What this says is that we cannot commit a
> transaction with more than 4300 bytes of stack consumed, otherwise
> we risk overflowing the stack.
>
> It's when you start seeing fragments like this that you start to
> realise the depth of the problem:
>
>    2)     5136     112   get_request+0x2a5/0x560
>    3)     5024     176   get_request_wait+0x32/0x240
>    4)     4848      96   blk_queue_bio+0x73/0x400
>    5)     4752      48   generic_make_request+0xc7/0x100
>    6)     4704      96   submit_bio+0x66/0xe0
>    7)     4608     112   _xfs_buf_ioapply+0x15c/0x1c0
>    8)     4496      64   xfs_buf_iorequest+0x7b/0xf0
>    9)     4432      32   xlog_bdstrat+0x23/0x60
>   10)     4400      96   xlog_sync+0x2e4/0x520
>   11)     4304      48   xlog_state_release_iclog+0xeb/0x130
>   12)     4256     208   xlog_write+0x6a3/0x750
>   13)     4048     192   xlog_cil_push+0x264/0x3a0
>   14)     3856     144   xlog_cil_force_lsn+0x144/0x150
>   15)     3712     144   _xfs_log_force+0x6a/0x280
>   16)     3568      32   xfs_log_force+0x18/0x40
>   17)     3536      80   xfs_buf_trylock+0x9a/0xf0

Thank-you for documenting this.

>
> Any metadata read we do that hits a pinned buffer needs a minimum
> 1500 bytes of stack before we hit the driver code, which from the
> above swap trace, requires around 1300 bytes to dispatch safely for
> the SCSI stack. So we can't safely issue a metadata *read* without
> having about 3KB of stack available. And given that if we do a
> double btree split and have to read in a metadata buffer, that means
> we can't start the allocation with more than about 2KB of stack
> consumed. And that is questionable when we add MD/DM layers into the
> picture as well....
>
> IOWs, there is simply no way we can fit an allocation call chain
> into an 8KB stack when even a small amount of stack is consumed
> prior to triggering allocation. Pushing the allocation off into it's
> own context is, AFAICT, the only choice we have here to avoid stack
> overruns because nobody else wants to acknowledge there is a
> problem.

Sigh. Also part of my rant that I can't believe that this is an issue
in LINUX.

>
> As it is, even pushing the allocation off into it's own context is
> questionable as to whether it will fit in the 8KB stack given the
> crazy amount of stack that the memory allocation path can consume
> and we can hit that path deep in the allocation stack....
>
>> x86_64, x86_32 (and untested ARM) code can be sent to anyone who wants
>> to try this at home. I would say, a generic configuration is using at
>> most 3KB of the stack is being used by the time xfs_alloc_vextent()
>> is being called and that includes the nested calls of the routine. So
>> for most setups, we can say the standard 8KB stacks is in no danger of
>> depletion and will not benefit from this feature.
>
> You should be able to see how easy it is to put together a call stack
> that blows 8k now...
>
>> Let us talk about 4KB stacks....
>
> No, let's not.
>
>> I believe that the kernel stacks do not need to be physically
>> contiguous.
>
> Sure, but the problem is that making them vmalloc'd memory will
> reduce performance and no change that reduces performance will ever
> be accepted. So contiguous kernel mapped stacks are here to stay.
>
>> Would 8KB stacks be used in this environment if the Linux
>> did not implement them as physically contiguous? What is the plan
>> when the 8KB limits become threatened?
>
> The current plan appears to be to stick our fingers in our ears,
> and then stick our heads in the sand....
>
>> This feature and the related nuances are good topics for the
>> upcoming Linux Filesystem and MM forum next month.
>
> I'm not sure that there is much to be gained by discussing it with
> people that already agree that there is a problem. I'll try, though.
>
> Cheers,
>
> Dave.

The other half of my rant is:

I haven't seen XFS on a stack reduction in new code nor existing code
(splitting routines and local variables) but I know that can only go
so far.

Filesystems, network stacks, well any kernel services, can't play
"Whack-a-mole" with the stack issues for long. The problems will just
pop up somewhere else.

I suspect it will take a big group of choir-members, the companies
they work for and the customers they represent to change the situation.
Sad. How can we get everyone in a rant over this situation?

Also thank-you for not biting my head off.

--Mark Tinguely.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
