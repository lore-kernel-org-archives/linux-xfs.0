Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7D2CE29DF8
	for <xfs@oss.sgi.com>; Mon, 16 Jun 2014 14:30:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 75C45304039
	for <xfs@oss.sgi.com>; Mon, 16 Jun 2014 12:30:43 -0700 (PDT)
Received: from mail-pb0-f46.google.com (mail-pb0-f46.google.com
	[209.85.160.46]) by cuda.sgi.com with ESMTP id LGbW9tjWsfa9a7AS
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 16 Jun 2014 12:30:41 -0700 (PDT)
Received: by mail-pb0-f46.google.com with SMTP id md12so3974698pbc.33
	for <xfs@oss.sgi.com>; Mon, 16 Jun 2014 12:30:40 -0700 (PDT)
Message-ID: <539F45E2.5030909@kernel.dk>
Date: Mon, 16 Jun 2014 13:30:42 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] [RFC] xfs: wire up aio_fsync method
References: <1402562047-31276-1-git-send-email-david@fromorbit.com>
	<20140612141329.GA11676@infradead.org>
	<20140612234441.GT9508@dastard>
	<20140613162352.GB23394@infradead.org>
	<20140615223323.GB9508@dastard> <20140616020030.GC9508@dastard>
	<539E5D66.8040605@kernel.dk> <20140616071951.GD9508@dastard>
In-Reply-To: <20140616071951.GD9508@dastard>
Content-Type: multipart/mixed; boundary="------------070900050408020205000309"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, linux-man@vger.kernel.org

This is a multi-part message in MIME format.
--------------070900050408020205000309
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 06/16/2014 01:19 AM, Dave Chinner wrote:
> On Sun, Jun 15, 2014 at 08:58:46PM -0600, Jens Axboe wrote:
>> On 2014-06-15 20:00, Dave Chinner wrote:
>>> On Mon, Jun 16, 2014 at 08:33:23AM +1000, Dave Chinner wrote:
>>>> On Fri, Jun 13, 2014 at 09:23:52AM -0700, Christoph Hellwig wrote:
>>>>> On Fri, Jun 13, 2014 at 09:44:41AM +1000, Dave Chinner wrote:
>>>>>> On Thu, Jun 12, 2014 at 07:13:29AM -0700, Christoph Hellwig wrote:
>>>>>>> There doesn't really seem anything XFS specific here, so instead
>>>>>>> of wiring up ->aio_fsync I'd implement IOCB_CMD_FSYNC in fs/aio.c
>>>>>>> based on the workqueue and ->fsync.
>>>>>>
>>>>>> I really don't know whether the other ->fsync methods in other
>>>>>> filesystems can stand alone like that. I also don't have the
>>>>>> time to test that it works properly on all filesystems right now.
>>>>>
>>>>> Of course they can, as shown by various calls to vfs_fsync_range that
>>>>> is nothing but a small wrapper around ->fsync.
>>>>
>>>> Sure, but that's not getting 10,000 concurrent callers, is it? And
>>>> some fsync methods require journal credits, and others serialise
>>>> completely, and so on.
>>>>
>>>> Besides, putting an *unbound, highly concurrent* aio queue into the
>>>> kernel for an operation that can serialise the entire filesystem
>>>> seems like a pretty nasty user-level DOS vector to me.
>>>
>>> FWIW, the non-linear system CPU overhead of a fs_mark test I've been
>>> running isn't anything related to XFS.  The async fsync workqueue
>>> results in several thousand worker threads dispatching IO
>>> concurrently across 16 CPUs:
>>>
>>> $ ps -ef |grep kworker |wc -l
>>> 4693
>>> $
>>>
>>> Profiles from 3.15 + xfs for-next + xfs aio_fsync show:
>>>
>>> -  51.33%  [kernel]            [k] percpu_ida_alloc
>>>    - percpu_ida_alloc
>>>       + 85.73% blk_mq_wait_for_tags
>>>       + 14.23% blk_mq_get_tag
>>> -  14.25%  [kernel]            [k] _raw_spin_unlock_irqrestore
>>>    - _raw_spin_unlock_irqrestore
>>>       - 66.26% virtio_queue_rq
>>>          - __blk_mq_run_hw_queue
>>>             - 99.65% blk_mq_run_hw_queue
>>>                + 99.47% blk_mq_insert_requests
>>>                + 0.53% blk_mq_insert_request
>>> .....
>>> -   7.91%  [kernel]            [k] _raw_spin_unlock_irq
>>>    - _raw_spin_unlock_irq
>>>       - 69.59% __schedule
>>>          - 86.49% schedule
>>>             + 47.72% percpu_ida_alloc
>>>             + 21.75% worker_thread
>>>             + 19.12% schedule_timeout
>>> ....
>>>       + 18.06% blk_mq_make_request
>>>
>>> Runtime:
>>>
>>> real    4m1.243s
>>> user    0m47.724s
>>> sys     11m56.724s
>>>
>>> Most of the excessive CPU usage is coming from the blk-mq layer, and
>>> XFS is barely showing up in the profiles at all - the IDA tag
>>> allocator is burning 8 CPUs at about 60,000 write IOPS....
>>>
>>> I know that the tag allocator has been rewritten, so I tested
>>> against a current a current Linus kernel with the XFS aio-fsync
>>> patch. The results are all over the place - from several sequential
>>> runs of the same test (removing the files in between so each tests
>>> starts from an empty fs):
>>>
>>> Wall time	sys time	IOPS	 files/s
>>> 4m58.151s	11m12.648s	30,000	 13,500
>>> 4m35.075s	12m45.900s	45,000	 15,000
>>> 3m10.665s	11m15.804s	65,000	 21,000
>>> 3m27.384s	11m54.723s	85,000	 20,000
>>> 3m59.574s	11m12.012s	50,000	 16,500
>>> 4m12.704s	12m15.720s	50,000	 17,000
>>>
>>> The 3.15 based kernel was pretty consistent around the 4m10 mark,
>>> generally only +/-10s in runtime and not much change in system time.
>>> The files/s rate reported by fs_mark doesn't vary that much, either.
>>> So the new tag allocator seems to be no better in terms of IO
>>> dispatch scalability, yet adds significant variability to IO
>>> performance.
>>>
>>> What I noticed is a massive jump in context switch overhead: from
>>> around 250,000/s to over 800,000/s and the CPU profiles show that
>>> this comes from the new tag allocator:
>>>
>>> -  34.62%  [kernel]  [k] _raw_spin_unlock_irqrestore
>>>    - _raw_spin_unlock_irqrestore
>>>       - 58.22% prepare_to_wait
>>>            100.00% bt_get
>>>               blk_mq_get_tag
>>>               __blk_mq_alloc_request
>>>               blk_mq_map_request
>>>               blk_sq_make_request
>>>               generic_make_request
>>>       - 22.51% virtio_queue_rq
>>>            __blk_mq_run_hw_queue
>>> ....
>>> -  21.56%  [kernel]  [k] _raw_spin_unlock_irq
>>>    - _raw_spin_unlock_irq
>>>       - 58.73% __schedule
>>>          - 53.42% io_schedule
>>>               99.88% bt_get
>>>                  blk_mq_get_tag
>>>                  __blk_mq_alloc_request
>>>                  blk_mq_map_request
>>>                  blk_sq_make_request
>>>                  generic_make_request
>>>          - 35.58% schedule
>>>             + 49.31% worker_thread
>>>             + 32.45% schedule_timeout
>>>             + 10.35% _xfs_log_force_lsn
>>>             + 3.10% xlog_cil_force_lsn
>>> ....
>>>
>>> The new block-mq tag allocator is hammering the waitqueues and
>>> that's generating a large amount of lock contention. It looks like
>>> the new allocator replaces CPU burn doing work in the IDA allocator
>>> with the same amount of CPU burn from extra context switch
>>> overhead....
>>>
>>> Oh, OH. Now I understand!
>>>
>>> # echo 4 > /sys/block/vdc/queue/nr_requests
>>>
>>> <run workload>
>>>
>>> 80.56%  [kernel]  [k] _raw_spin_unlock_irqrestore
>>>    - _raw_spin_unlock_irqrestore
>>>       - 98.49% prepare_to_wait
>>>            bt_get
>>>            blk_mq_get_tag
>>>            __blk_mq_alloc_request
>>>            blk_mq_map_request
>>>            blk_sq_make_request
>>>            generic_make_request
>>>          + submit_bio
>>>       + 1.07% finish_wait
>>> +  13.63%  [kernel]  [k] _raw_spin_unlock_irq
>>> ...
>>>
>>> It's context switch bound at 800,000 context switches/s, burning all
>>> 16 CPUs waking up and going to sleep and doing very little real
>>> work. How little real work? About 3000 IOPS for 2MB/s of IO. That
>>> amount of IO should only take a single digit CPU percentage of one
>>> CPU.
>>
>> With thousands of threads? I think not. Sanely submitted 3000 IOPS,
>> correct, I would agree with you.
>>
>>> This seems like bad behaviour to have on a congested block device,
>>> even a high performance one....
>>
>> That is pretty much the suck. How do I reproduce this (eg what are
>> you running, and what are the xfs aio fsync patches)? Even if
> 
> http://oss.sgi.com/pipermail/xfs/2014-June/036773.html
> 
>> dispatching thousands of threads to do IO is a bad idea (it very
>> much is), gracefully handling is a must. I haven't seen any bad
>> behavior from the new allocator, it seems to be well behaved (for
>> most normal cases, anyway). I'd like to take a stab at ensuring this
>> works, too.
>>
>> If you tell me exactly what you are running, I'll reproduce and get
>> this fixed up tomorrow.
> 
> Test case - take fs_mark:
> 
> 	git://oss.sgi.com/dgc/fs_mark
> 
> Apply the patch for aio fsync support:
> 
> http://oss.sgi.com/pipermail/xfs/2014-June/036774.html
> 
> Run this test:
> 
> $ time ./fs_mark  -D  10000  -S5 -n  50000  -s  4096  -L  5 -A \
> -d /mnt/scratch/0 -d  /mnt/scratch/1 -d  /mnt/scratch/2 \
> -d /mnt/scratch/3 -d  /mnt/scratch/4 -d  /mnt/scratch/5 \
> -d /mnt/scratch/6 -d  /mnt/scratch/7 -d  /mnt/scratch/8 \
> -d /mnt/scratch/9 -d  /mnt/scratch/10 -d  /mnt/scratch/11 \
> -d /mnt/scratch/12 -d  /mnt/scratch/13 -d  /mnt/scratch/14 \
> -d /mnt/scratch/15
> 
> Drop the "-A" if you want to use normal fsync (but then you won't
> see the problem).
> 
> Use a XFS filesystem that has at least 32 AGs (I'm using
> a sparse 500TB fs image on a virtio device). I'm also using mkfs
> options of "-m crc=1,finobt=1", but to use that last one you'll need
> a mkfs built from the xfsprogs git tree. It shouldn't make any
> difference to the result, though. I'm running on a VM with 16 CPUs
> and 16GB RAM, using fakenuma=4.

Can you try with this patch?

-- 
Jens Axboe


--------------070900050408020205000309
Content-Type: text/x-patch;
 name="tag-batch-wakeup.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="tag-batch-wakeup.patch"

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index 1aab39f..4f90f91 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -242,7 +242,7 @@ static int bt_get(struct blk_mq_alloc_data *data,
 		bool was_empty;
 
 		was_empty = list_empty(&wait.task_list);
-		prepare_to_wait(&bs->wait, &wait, TASK_UNINTERRUPTIBLE);
+		prepare_to_wait_exclusive(&bs->wait, &wait, TASK_UNINTERRUPTIBLE);
 
 		tag = __bt_get(hctx, bt, last_tag);
 		if (tag != -1)
@@ -345,7 +345,7 @@ static void bt_clear_tag(struct blk_mq_bitmap_tags *bt, unsigned int tag)
 	if (bs && atomic_dec_and_test(&bs->wait_cnt)) {
 		atomic_set(&bs->wait_cnt, bt->wake_cnt);
 		bt_index_inc(&bt->wake_index);
-		wake_up(&bs->wait);
+		wake_up_nr(&bs->wait, bt->wake_cnt);
 	}
 }
 

--------------070900050408020205000309
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--------------070900050408020205000309--
