Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46053C433E0
	for <linux-xfs@archiver.kernel.org>; Sat,  9 Jan 2021 14:41:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC87123998
	for <linux-xfs@archiver.kernel.org>; Sat,  9 Jan 2021 14:41:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725852AbhAIOkq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 Jan 2021 09:40:46 -0500
Received: from mx3.molgen.mpg.de ([141.14.17.11]:56025 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725780AbhAIOkq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 9 Jan 2021 09:40:46 -0500
Received: from [192.168.0.8] (ip5f5ae8a8.dynamic.kabel-deutschland.de [95.90.232.168])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: buczek)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id C6EAA20647DBE;
        Sat,  9 Jan 2021 15:39:59 +0100 (CET)
Subject: Re: [PATCH] xfs: Wake CIL push waiters more reliably
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        it+linux-xfs@molgen.mpg.de
References: <1705b481-16db-391e-48a8-a932d1f137e7@molgen.mpg.de>
 <20201229235627.33289-1-buczek@molgen.mpg.de>
 <20201230221611.GC164134@dread.disaster.area>
 <7bd30426-11dc-e482-dcc8-55d279bc75bd@molgen.mpg.de>
 <20201231215919.GA331610@dread.disaster.area>
 <def7bbfc-c57e-bcec-f81b-b5ccb0e562e8@molgen.mpg.de>
 <20210102224421.GC331610@dread.disaster.area>
 <f74bfdf9-d6ae-67eb-2dbd-559c6d58f45d@molgen.mpg.de>
 <20210107221957.GH331610@dread.disaster.area>
From:   Donald Buczek <buczek@molgen.mpg.de>
Message-ID: <f56e0c15-5e0e-8120-4360-452b29ef55cb@molgen.mpg.de>
Date:   Sat, 9 Jan 2021 15:39:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210107221957.GH331610@dread.disaster.area>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 07.01.21 23:19, Dave Chinner wrote:
> On Sun, Jan 03, 2021 at 05:03:33PM +0100, Donald Buczek wrote:
>> On 02.01.21 23:44, Dave Chinner wrote:
>>> On Sat, Jan 02, 2021 at 08:12:56PM +0100, Donald Buczek wrote:
>>>> On 31.12.20 22:59, Dave Chinner wrote:
>>>>> On Thu, Dec 31, 2020 at 12:48:56PM +0100, Donald Buczek wrote:
>>>>>> On 30.12.20 23:16, Dave Chinner wrote:
>>>
>>>>> One could argue that, but one should also understand the design
>>>>> constraints for a particular algorithm are before suggesting
>>>>> that their solution is "robust". :)
>>>>
>>>> Yes, but an understanding to the extend required by the
>>>> argument should be sufficient :-)
>>>
>>> And that's the fundamental conceit described by Dunning-Kruger.
>>>
>>> I.e. someone thinks they know enough to understand the argument,
>>> when in fact they don't understand enough about the subject matter
>>> to realise they don't understand what the expert at the other end is
>>> saying at all....
>>>
>>>>>> # seq 29
>>>>>>
>>>>>> 2020-12-29T20:08:15.652167+01:00 deadbird kernel: [ 1053.860637] XXX trigger cil 00000000e374c6f1 ctx 000000004967d650  ctx->space_used=33554656      , push_seq=29, ctx->sequence=29
>>>>>
>>>>> So, at 20:08:15 we get a push trigger and the work is queued. But...
>>>>>
>>>>> .....
>>>>>> 2020-12-29T20:09:04.961088+01:00 deadbird kernel: [ 1103.168964] XXX wake    cil 00000000e374c6f1 ctx 000000004967d650  ctx->space_used=67109136 >= 67108864, push_seq=29, ctx->sequence=29
>>>>>
>>>>> It takes the best part of *50 seconds* before the push work actually
>>>>> runs?
>>>>>
>>>>> That's .... well and truly screwed up - the work should run on that
>>>>> CPU on the very next time it yeilds the CPU. If we're holding the
>>>>> CPU without yeilding it for that long, hangcheck and RCU warnings
>>>>> should be going off...
>>>>
>>>> No such warnings.
>>>>
>>>> But the load is probably I/O bound to the log:
>>>>
>>>> - creates `cp -a` copies of a directory tree with small files (linux source repository)
>>>> - source tree probably completely cached.
>>>> - two copies in parallel
>>>> - slow log (on software raid6)
>>>>
>>>> Isn't it to be expected that sooner or later you need to wait for
>>>> log writes when you write as fast as possible with lots of
>>>> metadata updates and not so much data?
>>>
>>> No, incoming transactions waits for transaction reservation space,
>>> not log writes. Reservation space is freed up by metadata writeback.
>>> So if you have new transactions blocking in xfs_trans_reserve(),
>>> then we are blocking on metadata writeback.
>>>
>>> The CIL worker thread may be waiting for log IO completion before it
>>> issues more log IO, and in that case it is waiting on iclog buffer
>>> space (i.e. only waiting on internal log state, not metadata
>>> writeback).  Can you find that kworker thread stack and paste it? If
>>> bound on log IO, it will be blocked in xlog_get_iclog_space().
>>>
>>> Please paste the entire stack output, too, not just the bits you
>>> think are relevant or understand....
>>
>> That would be a kworker on the "xfs-cil/%s" workqueue, correct?
>> And you mean before the lockup, when the I/O is still active, correct?
>>
>> This is the usual stack output from that thread:
>>
>> # # /proc/2080/task/2080: kworker/u82:3+xfs-cil/md0 :
>> # cat /proc/2080/task/2080/stack
>>
>> [<0>] md_flush_request+0x87/0x190
>> [<0>] raid5_make_request+0x61b/0xb30
>> [<0>] md_handle_request+0x127/0x1a0
>> [<0>] md_submit_bio+0xbd/0x100
>> [<0>] submit_bio_noacct+0x151/0x410
>> [<0>] submit_bio+0x4b/0x1a0
>> [<0>] xlog_state_release_iclog+0x87/0xb0
>> [<0>] xlog_write+0x452/0x6d0
>> [<0>] xlog_cil_push_work+0x2e0/0x4d0
>> [<0>] process_one_work+0x1dd/0x3e0
>> [<0>] worker_thread+0x23f/0x3b0
>> [<0>] kthread+0x118/0x130
>> [<0>] ret_from_fork+0x22/0x30
>>
>> sampled three times with a few seconds in between, stack identical.
> 
> Yeah, so that is MD blocking waiting for a running device cache
> flush to finish before submitting the iclog IO. IOWs, it's waiting
> for hardware to flush volatile caches to stable storage. Every log
> IO has a cache flush preceding it, and if the device doesn't support
> FUA, then there is a post-IO cache flush as well. These flushes are
> necessary for correct IO ordering between the log and metadata/data
> writeback.
> 
> Essentially, you're waiting for MD to flush all it's dirty stripe
> cache to the backing devices and then flush the backing device
> caches as well. Nothing can be done at the filesystem level to make
> this faster....
> 
>>> Also, cp -a of a linux source tree is just as data intensive as it
>>> is metadata intensive. There's probably more data IO than metadata
>>> IO, so that's more likely to be what is slowing the disks down as
>>> metadata writeback is...
>>>
>>>> I'm a bit concerned, though, that there seem to be a rather
>>>> unlimited (~ 1000) number of kernel worker threads waiting for the
>>>> cil push and indirectly for log writes.
>>>
>>> That's normal - XFS is highly asynchronous and defers a lot of work
>>> to completion threads.
>>>
>>>>> So it dropped by 16 bytes (seems to be common) which is
>>>>> unexpected.  I wonder if it filled a hole in a buffer and so
>>>>> needed one less xlog_op_header()? But then the size would have
>>>>> gone up by at least 128 bytes for the hole that was filled, so
>>>>> it still shouldn't go down in size.
>>>>>
>>>>> I think you need to instrument xlog_cil_insert_items() and catch
>>>>> a negative length here:
>>>>>
>>>>> 	/* account for space used by new iovec headers  */
>>>>> 	iovhdr_res = diff_iovecs * sizeof(xlog_op_header_t); len +=
>>>>> 	iovhdr_res; ctx->nvecs += diff_iovecs;
>>>>>
>>>>> (diff_iovecs will be negative if the number of xlog_op_header
>>>>> structures goes down)
>>>>>
>>>>> And if this happens, then dump the transaction ticket via
>>>>> xlog_print_trans(tp) so we can see all the log items types and
>>>>> vectors that the transaction has formatted...
>>>>
>>>> I tried that, but the output was difficult to understand, because
>>>> at that point you can only log the complete transaction with the
>>>> items already updated.  And a shrinking item is not switched to the
>>>> shadow vector, so the formatted content is already overwritten and
>>>> not available for analysis.
>>>
>>> Yes, that's exactly the information I need to see.
>>>
>>> But the fact you think this is something I don't need to know about
>>> is classic Dunning-Kruger in action. You don't understand why I
>>> asked for this information, and found the information "difficult to
>>> understand", so you decided I didn't need it either, despite the
>>> fact I asked explicitly for it.
>>>
>>> What I first need to know is what operations are being performed by
>>> the transaciton that shrunk and what all the items in it are, not
>>> which specific items shrunk and by how much. There can be tens to
>>> hundreds of items in a single transaction, and it's the combination
>>> of the transaction state, the reservation, the amount of the
>>> reservation that has been consumed, what items are consuming that
>>> reservation, etc. that I need to first see and analyse.
>>>
>>> I don't ask for specific information just for fun - I ask for
>>> specific information because it is *necessary*. If you want the
>>> problem triaged and fixed, then please supply the information you
>>> are asked for, even if you don't understand why or what it means.
>>
>> I see. I hope, you can make use of the following.
> 
> ....
>> Last two events before the lockup:
>>
>> 2021-01-03T14:48:43.098887+01:00 deadbird kernel: [ 3194.831260] XFS (md0): XXX diff_iovecs 0 diff_len -16
>> 2021-01-03T14:48:43.109363+01:00 deadbird kernel: [ 3194.837364] XFS (md0): transaction summary:
>> 2021-01-03T14:48:43.109367+01:00 deadbird kernel: [ 3194.842544] XFS (md0):   log res   = 212728
>> 2021-01-03T14:48:43.118996+01:00 deadbird kernel: [ 3194.847617] XFS (md0):   log count = 8
>> 2021-01-03T14:48:43.119010+01:00 deadbird kernel: [ 3194.852193] XFS (md0):   flags     = 0x25
>> 2021-01-03T14:48:43.129701+01:00 deadbird kernel: [ 3194.857156] XFS (md0): ticket reservation summary:
>> 2021-01-03T14:48:43.129714+01:00 deadbird kernel: [ 3194.862890] XFS (md0):   unit res    = 225140 bytes
>> 2021-01-03T14:48:43.135515+01:00 deadbird kernel: [ 3194.868710] XFS (md0):   current res = 225140 bytes
>> 2021-01-03T14:48:43.148684+01:00 deadbird kernel: [ 3194.874702] XFS (md0):   total reg   = 0 bytes (o/flow = 0 bytes)
>> 2021-01-03T14:48:43.148700+01:00 deadbird kernel: [ 3194.881885] XFS (md0):   ophdrs      = 0 (ophdr space = 0 bytes)
>> 2021-01-03T14:48:43.155781+01:00 deadbird kernel: [ 3194.888975] XFS (md0):   ophdr + reg = 0 bytes
>> 2021-01-03T14:48:43.161210+01:00 deadbird kernel: [ 3194.894404] XFS (md0):   num regions = 0
>> 2021-01-03T14:48:43.165948+01:00 deadbird kernel: [ 3194.899141] XFS (md0): log item:
>> 2021-01-03T14:48:43.169996+01:00 deadbird kernel: [ 3194.903203] XFS (md0):   type      = 0x123b
>> 2021-01-03T14:48:43.174544+01:00 deadbird kernel: [ 3194.907741] XFS (md0):   flags     = 0x8
>> 2021-01-03T14:48:43.178996+01:00 deadbird kernel: [ 3194.912191] XFS (md0):   niovecs   = 3
>> 2021-01-03T14:48:43.183347+01:00 deadbird kernel: [ 3194.916546] XFS (md0):   size      = 696
>> 2021-01-03T14:48:43.187598+01:00 deadbird kernel: [ 3194.920791] XFS (md0):   bytes     = 248
>> 2021-01-03T14:48:43.191932+01:00 deadbird kernel: [ 3194.925131] XFS (md0):   buf len   = 248
>> 2021-01-03T14:48:43.196581+01:00 deadbird kernel: [ 3194.929776] XFS (md0):   iovec[0]
>> 2021-01-03T14:48:43.200633+01:00 deadbird kernel: [ 3194.933832] XFS (md0):     type    = 0x5
>> 2021-01-03T14:48:43.205069+01:00 deadbird kernel: [ 3194.938264] XFS (md0):     len     = 56
>> 2021-01-03T14:48:43.209293+01:00 deadbird kernel: [ 3194.942497] XFS (md0):     first 32 bytes of iovec[0]:
>> 2021-01-03T14:48:43.215494+01:00 deadbird kernel: [ 3194.948690] 00000000: 3b 12 03 00 05 00 00 00 00 00 10 00 00 00 00 00  ;...............
>> 2021-01-03T14:48:43.224801+01:00 deadbird kernel: [ 3194.957997] 00000010: 35 e3 ba 80 2e 00 00 00 00 00 00 00 00 00 00 00  5...............
>> 2021-01-03T14:48:43.234100+01:00 deadbird kernel: [ 3194.967297] XFS (md0):   iovec[1]
>> 2021-01-03T14:48:43.238293+01:00 deadbird kernel: [ 3194.971484] XFS (md0):     type    = 0x6
>> 2021-01-03T14:48:43.242744+01:00 deadbird kernel: [ 3194.975942] XFS (md0):     len     = 176
>> 2021-01-03T14:48:43.247108+01:00 deadbird kernel: [ 3194.980295] XFS (md0):     first 32 bytes of iovec[1]:
>> 2021-01-03T14:48:43.253304+01:00 deadbird kernel: [ 3194.986506] 00000000: 4e 49 b0 81 03 02 00 00 7d 00 00 00 7d 00 00 00  NI......}...}...
>> 2021-01-03T14:48:43.262648+01:00 deadbird kernel: [ 3194.995835] 00000010: 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>> 2021-01-03T14:48:43.272064+01:00 deadbird kernel: [ 3195.005267] XFS (md0):   iovec[2]
>> 2021-01-03T14:48:43.276174+01:00 deadbird kernel: [ 3195.009366] XFS (md0):     type    = 0x7
>> 2021-01-03T14:48:43.280649+01:00 deadbird kernel: [ 3195.013848] XFS (md0):     len     = 16
>> 2021-01-03T14:48:43.285042+01:00 deadbird kernel: [ 3195.018243] XFS (md0):     first 16 bytes of iovec[2]:
>> 2021-01-03T14:48:43.291166+01:00 deadbird kernel: [ 3195.024364] 00000000: 00 00 00 00 00 00 00 00 00 ba 02 ef e0 01 23 ef  ..............#.
> 
> Ok, they are all of this type - same transaction type/size, same
> form, all a reduction in the size of the inode data fork in extent
> format. I suspect this is trimming speculative block preallocation
> beyond EOF on final close of a written file.

Btw: I looked up such a file by its inode number and it was a rather
long one (git pack).

But please keep in mind, that this log was restricted to the "only
write to fresh filesystem" scenario. If you do something else on the
filesystem, there appear to be other cases than just the trimming
of the last extent.

I've collected some more log at
http://owww.molgen.mpg.de/~buczek/2021-01-03_13-09/log2.txt

The swap to the shadow buffer was made unconditional so that the
old vectors could be logged together with the new vectors. And I
logged a few bytes more from the buffer. A post-processing
script provided the summary header and removed duplicates.

The first events are from the "cp" with the truncation of the data
fork as seen before. But starting with the transaction at 881.111968
there are six of another kind with a very high diff_len (and
apparently items without an allocated vector).

After 945.723769 I playfully tried to force truncation events at
the attribute fork, so this is not new, just the other fork.

Donald

> Ok, that matches the case from the root directory you gave earlier,
> where the inode data fork was reducing in size from unlinks in a
> shortform directory.  Different vector, different inode fork format,
> but it appears to result in the same thing where just an inode with
> a reducing inode fork size is relogged.
> 
> 
> I'll think about this over the weekend and look at it more closely
> next week when I'm back from PTO...
> 
> Thanks for following up and providing this information, Donald!
> 
> Cheers,
> 
> Dave.
> 
