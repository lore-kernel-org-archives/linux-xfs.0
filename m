Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E4BDC433DB
	for <linux-xfs@archiver.kernel.org>; Sun,  3 Jan 2021 16:04:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5399E208D5
	for <linux-xfs@archiver.kernel.org>; Sun,  3 Jan 2021 16:04:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726042AbhACQEX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 3 Jan 2021 11:04:23 -0500
Received: from mx3.molgen.mpg.de ([141.14.17.11]:41701 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726008AbhACQEX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 3 Jan 2021 11:04:23 -0500
Received: from [192.168.0.8] (ip5f5aef2f.dynamic.kabel-deutschland.de [95.90.239.47])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: buczek)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 7396820647B5F;
        Sun,  3 Jan 2021 17:03:34 +0100 (CET)
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
From:   Donald Buczek <buczek@molgen.mpg.de>
Message-ID: <f74bfdf9-d6ae-67eb-2dbd-559c6d58f45d@molgen.mpg.de>
Date:   Sun, 3 Jan 2021 17:03:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210102224421.GC331610@dread.disaster.area>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 02.01.21 23:44, Dave Chinner wrote:
> On Sat, Jan 02, 2021 at 08:12:56PM +0100, Donald Buczek wrote:
>> On 31.12.20 22:59, Dave Chinner wrote:
>>> On Thu, Dec 31, 2020 at 12:48:56PM +0100, Donald Buczek wrote:
>>>> On 30.12.20 23:16, Dave Chinner wrote:
> 
>>> One could argue that, but one should also understand the design
>>> constraints for a particular algorithm are before suggesting
>>> that their solution is "robust". :)
>>
>> Yes, but an understanding to the extend required by the
>> argument should be sufficient :-)
> 
> And that's the fundamental conceit described by Dunning-Kruger.
> 
> I.e. someone thinks they know enough to understand the argument,
> when in fact they don't understand enough about the subject matter
> to realise they don't understand what the expert at the other end is
> saying at all....
> 
>>>> # seq 29
>>>>
>>>> 2020-12-29T20:08:15.652167+01:00 deadbird kernel: [ 1053.860637] XXX trigger cil 00000000e374c6f1 ctx 000000004967d650  ctx->space_used=33554656      , push_seq=29, ctx->sequence=29
>>>
>>> So, at 20:08:15 we get a push trigger and the work is queued. But...
>>>
>>> .....
>>>> 2020-12-29T20:09:04.961088+01:00 deadbird kernel: [ 1103.168964] XXX wake    cil 00000000e374c6f1 ctx 000000004967d650  ctx->space_used=67109136 >= 67108864, push_seq=29, ctx->sequence=29
>>>
>>> It takes the best part of *50 seconds* before the push work actually
>>> runs?
>>>
>>> That's .... well and truly screwed up - the work should run on that
>>> CPU on the very next time it yeilds the CPU. If we're holding the
>>> CPU without yeilding it for that long, hangcheck and RCU warnings
>>> should be going off...
>>
>> No such warnings.
>>
>> But the load is probably I/O bound to the log:
>>
>> - creates `cp -a` copies of a directory tree with small files (linux source repository)
>> - source tree probably completely cached.
>> - two copies in parallel
>> - slow log (on software raid6)
>>
>> Isn't it to be expected that sooner or later you need to wait for
>> log writes when you write as fast as possible with lots of
>> metadata updates and not so much data?
> 
> No, incoming transactions waits for transaction reservation space,
> not log writes. Reservation space is freed up by metadata writeback.
> So if you have new transactions blocking in xfs_trans_reserve(),
> then we are blocking on metadata writeback.
> 
> The CIL worker thread may be waiting for log IO completion before it
> issues more log IO, and in that case it is waiting on iclog buffer
> space (i.e. only waiting on internal log state, not metadata
> writeback).  Can you find that kworker thread stack and paste it? If
> bound on log IO, it will be blocked in xlog_get_iclog_space().
> 
> Please paste the entire stack output, too, not just the bits you
> think are relevant or understand....

That would be a kworker on the "xfs-cil/%s" workqueue, correct?
And you mean before the lockup, when the I/O is still active, correct?

This is the usual stack output from that thread:

# # /proc/2080/task/2080: kworker/u82:3+xfs-cil/md0 :
# cat /proc/2080/task/2080/stack

[<0>] md_flush_request+0x87/0x190
[<0>] raid5_make_request+0x61b/0xb30
[<0>] md_handle_request+0x127/0x1a0
[<0>] md_submit_bio+0xbd/0x100
[<0>] submit_bio_noacct+0x151/0x410
[<0>] submit_bio+0x4b/0x1a0
[<0>] xlog_state_release_iclog+0x87/0xb0
[<0>] xlog_write+0x452/0x6d0
[<0>] xlog_cil_push_work+0x2e0/0x4d0
[<0>] process_one_work+0x1dd/0x3e0
[<0>] worker_thread+0x23f/0x3b0
[<0>] kthread+0x118/0x130
[<0>] ret_from_fork+0x22/0x30

sampled three times with a few seconds in between, stack identical.

> Also, cp -a of a linux source tree is just as data intensive as it
> is metadata intensive. There's probably more data IO than metadata
> IO, so that's more likely to be what is slowing the disks down as
> metadata writeback is...
> 
>> I'm a bit concerned, though, that there seem to be a rather
>> unlimited (~ 1000) number of kernel worker threads waiting for the
>> cil push and indirectly for log writes.
> 
> That's normal - XFS is highly asynchronous and defers a lot of work
> to completion threads.
> 
>>> So it dropped by 16 bytes (seems to be common) which is
>>> unexpected.  I wonder if it filled a hole in a buffer and so
>>> needed one less xlog_op_header()? But then the size would have
>>> gone up by at least 128 bytes for the hole that was filled, so
>>> it still shouldn't go down in size.
>>>
>>> I think you need to instrument xlog_cil_insert_items() and catch
>>> a negative length here:
>>>
>>> 	/* account for space used by new iovec headers  */
>>> 	iovhdr_res = diff_iovecs * sizeof(xlog_op_header_t); len +=
>>> 	iovhdr_res; ctx->nvecs += diff_iovecs;
>>>
>>> (diff_iovecs will be negative if the number of xlog_op_header
>>> structures goes down)
>>>
>>> And if this happens, then dump the transaction ticket via
>>> xlog_print_trans(tp) so we can see all the log items types and
>>> vectors that the transaction has formatted...
>>
>> I tried that, but the output was difficult to understand, because
>> at that point you can only log the complete transaction with the
>> items already updated.  And a shrinking item is not switched to the
>> shadow vector, so the formatted content is already overwritten and
>> not available for analysis.
> 
> Yes, that's exactly the information I need to see.
> 
> But the fact you think this is something I don't need to know about
> is classic Dunning-Kruger in action. You don't understand why I
> asked for this information, and found the information "difficult to
> understand", so you decided I didn't need it either, despite the
> fact I asked explicitly for it.
> 
> What I first need to know is what operations are being performed by
> the transaciton that shrunk and what all the items in it are, not
> which specific items shrunk and by how much. There can be tens to
> hundreds of items in a single transaction, and it's the combination
> of the transaction state, the reservation, the amount of the
> reservation that has been consumed, what items are consuming that
> reservation, etc. that I need to first see and analyse.
> 
> I don't ask for specific information just for fun - I ask for
> specific information because it is *necessary*. If you want the
> problem triaged and fixed, then please supply the information you
> are asked for, even if you don't understand why or what it means.

I see. I hope, you can make use of the following.

Attempt 1 ( base: Linux v5.1.10 + smartpqi driver 2.1.6-005)

+++ b/fs/xfs/xfs_log_cil.c
@@ -405,6 +405,11 @@ xlog_cil_insert_items(
  
         spin_lock(&cil->xc_cil_lock);
  
+       if (diff_iovecs < 0 && strcmp(tp->t_mountp->m_super->s_id, "md0") == 0) {
+               xfs_warn (tp->t_mountp, "XXX diff_iovecs %d", diff_iovecs);
+               xlog_print_trans(tp);
+       }
+
         /* account for space used by new iovec headers  */
         iovhdr_res = diff_iovecs * sizeof(xlog_op_header_t);
         len += iovhdr_res;

Result: No log output before filesystem locked up after 15 iterations of the copy loop.

Attempt 2 ( base: previous patch):

--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -405,8 +405,8 @@ xlog_cil_insert_items(
  
         spin_lock(&cil->xc_cil_lock);
  
-       if (diff_iovecs < 0 && strcmp(tp->t_mountp->m_super->s_id, "md0") == 0) {
-               xfs_warn (tp->t_mountp, "XXX diff_iovecs %d", diff_iovecs);
+       if ((diff_iovecs < 0 || len < 0) && strcmp(tp->t_mountp->m_super->s_id, "md0") == 0) {
+               xfs_warn (tp->t_mountp, "XXX diff_iovecs %d diff_len %d", diff_iovecs, len);
                 xlog_print_trans(tp);
         }

Result: 594 rather similar events logged before filesystem locked up after 29 iterations of the copy loop

The third iovec sometimes has len=48 instead of len=16.

Last two events before the lockup:

2021-01-03T14:48:43.098887+01:00 deadbird kernel: [ 3194.831260] XFS (md0): XXX diff_iovecs 0 diff_len -16
2021-01-03T14:48:43.109363+01:00 deadbird kernel: [ 3194.837364] XFS (md0): transaction summary:
2021-01-03T14:48:43.109367+01:00 deadbird kernel: [ 3194.842544] XFS (md0):   log res   = 212728
2021-01-03T14:48:43.118996+01:00 deadbird kernel: [ 3194.847617] XFS (md0):   log count = 8
2021-01-03T14:48:43.119010+01:00 deadbird kernel: [ 3194.852193] XFS (md0):   flags     = 0x25
2021-01-03T14:48:43.129701+01:00 deadbird kernel: [ 3194.857156] XFS (md0): ticket reservation summary:
2021-01-03T14:48:43.129714+01:00 deadbird kernel: [ 3194.862890] XFS (md0):   unit res    = 225140 bytes
2021-01-03T14:48:43.135515+01:00 deadbird kernel: [ 3194.868710] XFS (md0):   current res = 225140 bytes
2021-01-03T14:48:43.148684+01:00 deadbird kernel: [ 3194.874702] XFS (md0):   total reg   = 0 bytes (o/flow = 0 bytes)
2021-01-03T14:48:43.148700+01:00 deadbird kernel: [ 3194.881885] XFS (md0):   ophdrs      = 0 (ophdr space = 0 bytes)
2021-01-03T14:48:43.155781+01:00 deadbird kernel: [ 3194.888975] XFS (md0):   ophdr + reg = 0 bytes
2021-01-03T14:48:43.161210+01:00 deadbird kernel: [ 3194.894404] XFS (md0):   num regions = 0
2021-01-03T14:48:43.165948+01:00 deadbird kernel: [ 3194.899141] XFS (md0): log item:
2021-01-03T14:48:43.169996+01:00 deadbird kernel: [ 3194.903203] XFS (md0):   type      = 0x123b
2021-01-03T14:48:43.174544+01:00 deadbird kernel: [ 3194.907741] XFS (md0):   flags     = 0x8
2021-01-03T14:48:43.178996+01:00 deadbird kernel: [ 3194.912191] XFS (md0):   niovecs   = 3
2021-01-03T14:48:43.183347+01:00 deadbird kernel: [ 3194.916546] XFS (md0):   size      = 696
2021-01-03T14:48:43.187598+01:00 deadbird kernel: [ 3194.920791] XFS (md0):   bytes     = 248
2021-01-03T14:48:43.191932+01:00 deadbird kernel: [ 3194.925131] XFS (md0):   buf len   = 248
2021-01-03T14:48:43.196581+01:00 deadbird kernel: [ 3194.929776] XFS (md0):   iovec[0]
2021-01-03T14:48:43.200633+01:00 deadbird kernel: [ 3194.933832] XFS (md0):     type    = 0x5
2021-01-03T14:48:43.205069+01:00 deadbird kernel: [ 3194.938264] XFS (md0):     len     = 56
2021-01-03T14:48:43.209293+01:00 deadbird kernel: [ 3194.942497] XFS (md0):     first 32 bytes of iovec[0]:
2021-01-03T14:48:43.215494+01:00 deadbird kernel: [ 3194.948690] 00000000: 3b 12 03 00 05 00 00 00 00 00 10 00 00 00 00 00  ;...............
2021-01-03T14:48:43.224801+01:00 deadbird kernel: [ 3194.957997] 00000010: 35 e3 ba 80 2e 00 00 00 00 00 00 00 00 00 00 00  5...............
2021-01-03T14:48:43.234100+01:00 deadbird kernel: [ 3194.967297] XFS (md0):   iovec[1]
2021-01-03T14:48:43.238293+01:00 deadbird kernel: [ 3194.971484] XFS (md0):     type    = 0x6
2021-01-03T14:48:43.242744+01:00 deadbird kernel: [ 3194.975942] XFS (md0):     len     = 176
2021-01-03T14:48:43.247108+01:00 deadbird kernel: [ 3194.980295] XFS (md0):     first 32 bytes of iovec[1]:
2021-01-03T14:48:43.253304+01:00 deadbird kernel: [ 3194.986506] 00000000: 4e 49 b0 81 03 02 00 00 7d 00 00 00 7d 00 00 00  NI......}...}...
2021-01-03T14:48:43.262648+01:00 deadbird kernel: [ 3194.995835] 00000010: 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
2021-01-03T14:48:43.272064+01:00 deadbird kernel: [ 3195.005267] XFS (md0):   iovec[2]
2021-01-03T14:48:43.276174+01:00 deadbird kernel: [ 3195.009366] XFS (md0):     type    = 0x7
2021-01-03T14:48:43.280649+01:00 deadbird kernel: [ 3195.013848] XFS (md0):     len     = 16
2021-01-03T14:48:43.285042+01:00 deadbird kernel: [ 3195.018243] XFS (md0):     first 16 bytes of iovec[2]:
2021-01-03T14:48:43.291166+01:00 deadbird kernel: [ 3195.024364] 00000000: 00 00 00 00 00 00 00 00 00 ba 02 ef e0 01 23 ef  ..............#.

2021-01-03T14:48:43.300880+01:00 deadbird kernel: [ 3195.033706] XFS (md0): XXX diff_iovecs 0 diff_len -16
2021-01-03T14:48:43.311716+01:00 deadbird kernel: [ 3195.039849] XFS (md0): transaction summary:
2021-01-03T14:48:43.311732+01:00 deadbird kernel: [ 3195.044919] XFS (md0):   log res   = 212728
2021-01-03T14:48:43.316784+01:00 deadbird kernel: [ 3195.049982] XFS (md0):   log count = 8
2021-01-03T14:48:43.321455+01:00 deadbird kernel: [ 3195.054663] XFS (md0):   flags     = 0x25
2021-01-03T14:48:43.326316+01:00 deadbird kernel: [ 3195.059519] XFS (md0): ticket reservation summary:
2021-01-03T14:48:43.332050+01:00 deadbird kernel: [ 3195.065247] XFS (md0):   unit res    = 225140 bytes
2021-01-03T14:48:43.337873+01:00 deadbird kernel: [ 3195.071065] XFS (md0):   current res = 225140 bytes
2021-01-03T14:48:43.343762+01:00 deadbird kernel: [ 3195.076967] XFS (md0):   total reg   = 0 bytes (o/flow = 0 bytes)
2021-01-03T14:48:43.350951+01:00 deadbird kernel: [ 3195.084148] XFS (md0):   ophdrs      = 0 (ophdr space = 0 bytes)
2021-01-03T14:48:43.358036+01:00 deadbird kernel: [ 3195.091238] XFS (md0):   ophdr + reg = 0 bytes
2021-01-03T14:48:43.363476+01:00 deadbird kernel: [ 3195.096671] XFS (md0):   num regions = 0
2021-01-03T14:48:43.368213+01:00 deadbird kernel: [ 3195.101416] XFS (md0): log item:
2021-01-03T14:48:43.372263+01:00 deadbird kernel: [ 3195.105465] XFS (md0):   type      = 0x123b
2021-01-03T14:48:43.376895+01:00 deadbird kernel: [ 3195.110101] XFS (md0):   flags     = 0x8
2021-01-03T14:48:43.381240+01:00 deadbird kernel: [ 3195.114443] XFS (md0):   niovecs   = 3
2021-01-03T14:48:43.385587+01:00 deadbird kernel: [ 3195.118788] XFS (md0):   size      = 696
2021-01-03T14:48:43.389830+01:00 deadbird kernel: [ 3195.123026] XFS (md0):   bytes     = 248
2021-01-03T14:48:43.394355+01:00 deadbird kernel: [ 3195.127469] XFS (md0):   buf len   = 248
2021-01-03T14:48:43.398909+01:00 deadbird kernel: [ 3195.132100] XFS (md0):   iovec[0]
2021-01-03T14:48:43.402967+01:00 deadbird kernel: [ 3195.136147] XFS (md0):     type    = 0x5
2021-01-03T14:48:43.407367+01:00 deadbird kernel: [ 3195.140574] XFS (md0):     len     = 56
2021-01-03T14:48:43.411704+01:00 deadbird kernel: [ 3195.144903] XFS (md0):     first 32 bytes of iovec[0]:
2021-01-03T14:48:43.417812+01:00 deadbird kernel: [ 3195.151002] 00000000: 3b 12 03 00 05 00 00 00 00 00 10 00 00 00 00 00  ;...............
2021-01-03T14:48:43.427114+01:00 deadbird kernel: [ 3195.160302] 00000010: 57 b1 d6 80 2b 00 00 00 00 00 00 00 00 00 00 00  W...+...........
2021-01-03T14:48:43.440572+01:00 deadbird kernel: [ 3195.169704] XFS (md0):   iovec[1]
2021-01-03T14:48:43.440581+01:00 deadbird kernel: [ 3195.173774] XFS (md0):     type    = 0x6
2021-01-03T14:48:43.449478+01:00 deadbird kernel: [ 3195.178225] XFS (md0):     len     = 176
2021-01-03T14:48:43.449481+01:00 deadbird kernel: [ 3195.182687] XFS (md0):     first 32 bytes of iovec[1]:
2021-01-03T14:48:43.464908+01:00 deadbird kernel: [ 3195.188797] 00000000: 4e 49 20 81 03 02 00 00 7d 00 00 00 7d 00 00 00  NI .....}...}...
2021-01-03T14:48:43.464910+01:00 deadbird kernel: [ 3195.198116] 00000010: 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
2021-01-03T14:48:43.478436+01:00 deadbird kernel: [ 3195.207555] XFS (md0):   iovec[2]
2021-01-03T14:48:43.478438+01:00 deadbird kernel: [ 3195.211645] XFS (md0):     type    = 0x7
2021-01-03T14:48:43.487300+01:00 deadbird kernel: [ 3195.216229] XFS (md0):     len     = 16
2021-01-03T14:48:43.487303+01:00 deadbird kernel: [ 3195.220509] XFS (md0):     first 16 bytes of iovec[2]:
2021-01-03T14:48:43.502751+01:00 deadbird kernel: [ 3195.226631] 00000000: 00 00 00 00 00 00 00 00 00 ae 04 29 00 00 da 24  ...........)...$

Full output available at https://owww.molgen.mpg.de/~buczek/2021-01-03_13-09/log.txt (2.2M)

>> So I've added some code to dump an item in its old and its new
>> state in xlog_cil_insert_format_items when either the requested
>> buffer len or the number of vectors decreased.
> 
> Yes, that would be useful when trying to understand the low level
> details of where a specific operation might be doing something
> unexpected, but I don't have a high level picture of what operations
> are triggering this issue so have no clue about the context in which
> these isolated, context free changes are occuring.
> 
> That said ....
> 
>> Several examples of different kind with a little bit of manual annotation following
>>
>> Best
>>    Donald
>>
>> - XFS_LI_INODE.XLOG_REG_TYPE_ILOCAL from 32 to 20 bytes
>>
>> [   29.606212] XFS (sda1): XXX required buf size 184 -> 172
>> [   29.612591] XFS (sda1): XXX niovecs           3 -> 3
>>
>> [   29.618570] XFS (sda1): XXX old log item:
>> [   29.623469] XFS (sda1): log item:
>> [   29.627683] XFS (sda1):   type       = 0x123b                                               # XFS_LI_INODE
>> [   29.632375] XFS (sda1):   flags      = 0x8
>> [   29.636858] XFS (sda1):   niovecs    = 3
>> [   29.647442] XFS (sda1):   size       = 312
>> [   29.651814] XFS (sda1):   bytes      = 184
>> [   29.656278] XFS (sda1):   buf len    = 184
>> [   29.660927] XFS (sda1):   iovec[0]
>> [   29.665071] XFS (sda1):     type     = 0x5                                                  # XLOG_REG_TYPE_IFORMAT
>> [   29.669592] XFS (sda1):     len      = 56
>> [   29.673914] XFS (sda1):     first 32 bytes of iovec[0]:
>> [   29.680079] 00000000: 3b 12 03 00 03 00 00 00 00 00 20 00 00 00 00 00  ;......... .....
>> [   29.689363] 00000010: 37 ab 20 00 00 00 00 00 00 00 00 00 00 00 00 00  7. .............
>> [   29.698633] XFS (sda1):   iovec[1]
>> [   29.702756] XFS (sda1):     type     = 0x6                                                  # XLOG_REG_TYPE_ICORE
>> [   29.707263] XFS (sda1):     len      = 96
>> [   29.711571] XFS (sda1):     first 32 bytes of iovec[1]:
>> [   29.717720] 00000000: 4e 49 ed 41 02 01 00 00 00 00 00 00 00 00 00 00  NI.A............
>> [   29.726986] 00000010: 02 00 00 00 00 00 00 00 00 00 00 00 00 00 05 00  ................
>> [   29.736241] XFS (sda1):   iovec[2]
>> [   29.740364] XFS (sda1):     type     = 0x9                                                  # XLOG_REG_TYPE_ILOCAL
>> [   29.744873] XFS (sda1):     len      = 32
>> [   29.749184] XFS (sda1):     first 32 bytes of iovec[2]:
>> [   29.755336] 00000000: 02 00 30 e7 02 26 06 00 40 73 65 72 76 65 72 00  ..0..&..@server.
>> [   29.764612] 00000010: 08 92 ef 04 00 58 6d 78 36 34 00 d3 93 58 00 58  .....Xmx64...X.X
>>
>> [   29.773900] XFS (sda1): XXX new log item:
>> [   29.778718] XFS (sda1): log item:
>> [   29.782856] XFS (sda1):   type       = 0x123b
>> [   29.787478] XFS (sda1):   flags      = 0x8
>> [   29.791902] XFS (sda1):   niovecs    = 3
>> [   29.796321] XFS (sda1):   size       = 312
>> [   29.800640] XFS (sda1):   bytes      = 172
>> [   29.805052] XFS (sda1):   buf len    = 176
>> [   29.809659] XFS (sda1):   iovec[0]
>> [   29.813781] XFS (sda1):     type     = 0x5
>> [   29.818289] XFS (sda1):     len      = 56
>> [   29.822599] XFS (sda1):     first 32 bytes of iovec[0]:
>> [   29.828754] 00000000: 3b 12 03 00 03 00 00 00 00 00 14 00 00 00 00 00  ;...............
>> [   29.838024] 00000010: 37 ab 20 00 00 00 00 00 00 00 00 00 00 00 00 00  7. .............
>> [   29.847292] XFS (sda1):   iovec[1]
>> [   29.851420] XFS (sda1):     type     = 0x6
>> [   29.855933] XFS (sda1):     len      = 96
>> [   29.860247] XFS (sda1):     first 32 bytes of iovec[1]:
>> [   29.866406] 00000000: 4e 49 ed 41 02 01 00 00 00 00 00 00 00 00 00 00  NI.A............
>> [   29.875677] 00000010: 02 00 00 00 00 00 00 00 00 00 00 00 00 00 05 00  ................
>> [   29.884949] XFS (sda1):   iovec[2]
>> [   29.889081] XFS (sda1):     type     = 0x9
>> [   29.893601] XFS (sda1):     len      = 20
>> [   29.897924] XFS (sda1):     first 20 bytes of iovec[2]:
>> [   29.904096] 00000000: 01 00 30 e7 02 26 04 00 58 6d 78 36 34 00 d3 93  ..0..&..Xmx64...
>> [   29.913381] 00000010: 58 92 ef 04                                      X...
> 
> That may be removal of a directory entry from a local form
> directory. Hmmm - local form inode forks only log the active byte
> range so that could be the issue here.
> 
> Hold on - where did this come from? "cp -a" doesn't result in file
> and directory removals, right?

Correct. In the above part of the mail, where I described the load, that was reffering to your question "It takes the best part of *50 seconds* before the push work actually runs?". So this was related to the specific test from which the quoted loglines were.

The second part of the email was just about the question, whether it can be demonstrated that items in the CIL shrink. This was the followup to "Do you have tracing showing the operation where the relogged item has actually gotten smaller?" and "But, of course, if the size is not expected to decrease, this discrepancy must be clarified anyway. I am sure, I can find out the exact circumstances, this does happen. I will follow up on this. "

As soon as I added that logging, I got events from the system disk ("sda1") during boot activity. This already seemed to answer the question whether log items shrink (rightfully or wrongfully). So I didn't even start the described workload on the md devices. I should have made this difference clear and apologize that you needed to spend time to figure that out.

>> - (then) XFS_LI_INODE.XLOG_REG_TYPE_ILOCAL from 20 to 8 bytes
>>
>> [   29.982907] XFS (sda1): XXX required buf size 172 -> 160
>> [   29.992716] XFS (sda1): XXX niovecs           3 -> 3
>>
>> [   29.998728] XFS (sda1): XXX old log item:
>> [   30.003624] XFS (sda1): log item:
>> [   30.007835] XFS (sda1):   type       = 0x123b
>> [   30.012654] XFS (sda1):   flags      = 0x8
>> [   30.017145] XFS (sda1):   niovecs    = 3
>> [   30.021638] XFS (sda1):   size       = 312
>> [   30.026012] XFS (sda1):   bytes      = 172
>> [   30.030610] XFS (sda1):   buf len    = 176
>> [   30.035292] XFS (sda1):   iovec[0]
>> [   30.039480] XFS (sda1):     type     = 0x5
>> [   30.044054] XFS (sda1):     len      = 56
>> [   30.048534] XFS (sda1):     first 32 bytes of iovec[0]:
>> [   30.054749] 00000000: 3b 12 03 00 03 00 00 00 00 00 14 00 00 00 00 00  ;...............
>> [   30.064091] 00000010: 37 ab 20 00 00 00 00 00 00 00 00 00 00 00 00 00  7. .............
>> [   30.073545] XFS (sda1):   iovec[1]
>> [   30.077744] XFS (sda1):     type     = 0x6
>> [   30.082455] XFS (sda1):     len      = 96
>> [   30.086824] XFS (sda1):     first 32 bytes of iovec[1]:
>> [   30.093025] 00000000: 4e 49 ed 41 02 01 00 00 00 00 00 00 00 00 00 00  NI.A............
>> [   30.102346] 00000010: 02 00 00 00 00 00 00 00 00 00 00 00 00 00 05 00  ................
>> [   30.111801] XFS (sda1):   iovec[2]
>> [   30.115989] XFS (sda1):     type     = 0x9
>> [   30.120715] XFS (sda1):     len      = 20
>> [   30.125102] XFS (sda1):     first 20 bytes of iovec[2]:
>> [   30.131331] 00000000: 01 00 30 e7 02 26 04 00 58 6d 78 36 34 00 d3 93  ..0..&..Xmx64...
>> [   30.140808] 00000010: 58 92 ef 04                                      X...
>>
>> [   30.149006] XFS (sda1): XXX new log item:
>> [   30.154039] XFS (sda1): log item:
>> [   30.154039] XFS (sda1):   type       = 0x123b
>> [   30.154041] XFS (sda1):   flags      = 0x8
>> [   30.167436] XFS (sda1):   niovecs    = 3
>> [   30.167437] XFS (sda1):   size       = 312
>> [   30.167438] XFS (sda1):   bytes      = 160
>> [   30.180881] XFS (sda1):   buf len    = 160
>> [   30.180882] XFS (sda1):   iovec[0]
>> [   30.180882] XFS (sda1):     type     = 0x5
>> [   30.180883] XFS (sda1):     len      = 56
>> [   30.180884] XFS (sda1):     first 32 bytes of iovec[0]:
>> [   30.180884] 00000000: 3b 12 03 00 03 00 00 00 00 00 08 00 00 00 00 00  ;...............
>> [   30.180885] 00000010: 37 ab 20 00 00 00 00 00 00 00 00 00 00 00 00 00  7. .............
>> [   30.180886] XFS (sda1):   iovec[1]
>> [   30.180886] XFS (sda1):     type     = 0x6
>> [   30.180887] XFS (sda1):     len      = 96
>> [   30.180887] XFS (sda1):     first 32 bytes of iovec[1]:
>> [   30.180888] 00000000: 4e 49 ed 41 02 01 00 00 00 00 00 00 00 00 00 00  NI.A............
>> [   30.180889] 00000010: 02 00 00 00 00 00 00 00 00 00 00 00 00 00 05 00  ................
>> [   30.180889] XFS (sda1):   iovec[2]
>> [   30.180890] XFS (sda1):     type     = 0x9
>> [   30.180890] XFS (sda1):     len      = 8
>> [   30.180890] XFS (sda1):     first 8 bytes of iovec[2]:
>> [   30.180891] 00000000: 00 00 30 e7 02 26 04 00                          ..0..&..
> 
> And that looks to be another unlink in the same directory inode, now
> empty.
> 
>>
>> - (then) XFS_LI_INODE.XLOG_REG_TYPE_ILOCAL removed - niovecs from 3 to 2
>>
>> [   30.197403] XFS (sda1): XXX required buf size 160 -> 152
>> [   30.296091] XFS (sda1): XXX niovecs           3 -> 2
>>
>> [   30.296092] XFS (sda1): XXX old log item:
>> [   30.296093] XFS (sda1): log item:
>> [   30.297552] ixgbe 0000:01:00.1 net03: renamed from eth3
>> [   30.317524] XFS (sda1):   type       = 0x123b
>> [   30.317524] XFS (sda1):   flags      = 0x8
>> [   30.317525] XFS (sda1):   niovecs    = 3
>> [   30.317525] XFS (sda1):   size       = 304
>> [   30.317526] XFS (sda1):   bytes      = 160
>> [   30.317526] XFS (sda1):   buf len    = 160
>> [   30.317527] XFS (sda1):   iovec[0]
>> [   30.317527] XFS (sda1):     type     = 0x5
>> [   30.317528] XFS (sda1):     len      = 56
>> [   30.317528] XFS (sda1):     first 32 bytes of iovec[0]:
>> [   30.317529] 00000000: 3b 12 03 00 03 00 00 00 00 00 08 00 00 00 00 00  ;...............
>> [   30.317530] 00000010: 37 ab 20 00 00 00 00 00 00 00 00 00 00 00 00 00  7. .............
>> [   30.317531] XFS (sda1):   iovec[1]
>> [   30.317531] XFS (sda1):     type     = 0x6
>> [   30.317531] XFS (sda1):     len      = 96
>> [   30.317532] XFS (sda1):     first 32 bytes of iovec[1]:
>> [   30.317533] 00000000: 4e 49 ed 41 02 01 00 00 00 00 00 00 00 00 00 00  NI.A............
>> [   30.317533] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 05 00  ................
>> [   30.317533] XFS (sda1):   iovec[2]
>> [   30.317534] XFS (sda1):     type     = 0x9
>> [   30.317534] XFS (sda1):     len      = 8
>> [   30.317535] XFS (sda1):     first 8 bytes of iovec[2]:
>> [   30.317535] 00000000: 00 00 30 e7 02 26 04 00                          ..0..&..
>>
>> [   30.317536] XFS (sda1): XXX new log item:
>> [   30.317537] XFS (sda1): log item:
>> [   30.317537] XFS (sda1):   type       = 0x123b
>> [   30.317538] XFS (sda1):   flags      = 0x8
>> [   30.317539] XFS (sda1):   niovecs    = 2
>> [   30.317539] XFS (sda1):   size       = 304
>> [   30.317540] XFS (sda1):   bytes      = 152
>> [   30.317540] XFS (sda1):   buf len    = 152
>> [   30.317541] XFS (sda1):   iovec[0]
>> [   30.317541] XFS (sda1):     type     = 0x5
>> [   30.317542] XFS (sda1):     len      = 56
>> [   30.317542] XFS (sda1):     first 32 bytes of iovec[0]:
>> [   30.317543] 00000000: 3b 12 02 00 01 00 00 00 00 00 00 00 00 00 00 00  ;...............
>> [   30.317543] 00000010: 37 ab 20 00 00 00 00 00 00 00 00 00 00 00 00 00  7. .............
>> [   30.317544] XFS (sda1):   iovec[1]
>> [   30.317544] XFS (sda1):     type     = 0x6
>> [   30.317545] XFS (sda1):     len      = 96
>> [   30.317545] XFS (sda1):     first 32 bytes of iovec[1]:
>> [   30.317546] 00000000: 4e 49 00 00 02 02 00 00 00 00 00 00 00 00 00 00  NI..............
>> [   30.317546] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 05 00  ................
> 
> And maybe that's an rmdir() triggering an unlink on the same - now
> empty - directory.
> 
> Does your workload also do 'rm -rf' anywhere because I can't explain
> how a concurrent 'cp -a' workload would trigger this behaviour...
> 
>> - XFS_LI_INODE.XLOG_REG_TYPE_IEXT removed - niovecs from 3 to 2
>>
>> [   37.983756] XFS (sda1): XXX required buf size 168 -> 152
>> [   37.990253] XFS (sda1): XXX niovecs           3 -> 2
>>
>> [   37.996202] XFS (sda1): XXX old log item:
>> [   38.001061] XFS (sda1): log item:
>> [   38.005239] XFS (sda1):   type       = 0x123b
>> [   38.009885] XFS (sda1):   flags      = 0x9
>> [   38.014330] XFS (sda1):   niovecs    = 3
>> [   38.018764] XFS (sda1):   size       = 440
>> [   38.023100] XFS (sda1):   bytes      = 168
>> [   38.027533] XFS (sda1):   buf len    = 168
>> [   38.032157] XFS (sda1):   iovec[0]
>> [   38.036286] XFS (sda1):     type     = 0x5
>> [   38.040796] XFS (sda1):     len      = 56
>> [   38.045114] XFS (sda1):     first 32 bytes of iovec[0]:
>> [   38.051277] 00000000: 3b 12 03 00 05 00 00 00 00 00 10 00 00 00 00 00  ;...............
>> [   38.060562] 00000010: cb 91 08 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>> [   38.069853] XFS (sda1):   iovec[1]
>> [   38.073989] XFS (sda1):     type     = 0x6
>> [   38.078525] XFS (sda1):     len      = 96
>> [   38.082871] XFS (sda1):     first 32 bytes of iovec[1]:
>> [   38.089052] 00000000: 4e 49 a4 81 02 02 00 00 62 00 00 00 62 00 00 00  NI......b...b...
>> [   38.098331] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 42 09  ..............B.
>> [   38.107611] XFS (sda1):   iovec[2]
>> [   38.111754] XFS (sda1):     type     = 0x7                                                # XLOG_REG_TYPE_IEXT
>> [   38.116285] XFS (sda1):     len      = 16
>> [   38.120608] XFS (sda1):     first 16 bytes of iovec[2]:
>> [   38.126770] 00000000: 00 00 00 00 00 00 00 00 00 00 00 11 31 80 00 01  ............1...
>>
>> [   38.136054] XFS (sda1): XXX new log item:
>> [   38.140878] XFS (sda1): log item:
>> [   38.145025] XFS (sda1):   type       = 0x123b
>> [   38.149645] XFS (sda1):   flags      = 0x9
>> [   38.154067] XFS (sda1):   niovecs    = 2
>> [   38.158490] XFS (sda1):   size       = 440
>> [   38.162799] XFS (sda1):   bytes      = 152
>> [   38.167202] XFS (sda1):   buf len    = 152
>> [   38.171801] XFS (sda1):   iovec[0]
>> [   38.175911] XFS (sda1):     type     = 0x5
>> [   38.180409] XFS (sda1):     len      = 56
>> [   38.184708] XFS (sda1):     first 32 bytes of iovec[0]:
>> [   38.190852] 00000000: 3b 12 02 00 01 00 00 00 00 00 00 00 00 00 00 00  ;...............
>> [   38.200115] 00000010: cb 91 08 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>> [   38.209373] XFS (sda1):   iovec[1]
>> [   38.213488] XFS (sda1):     type     = 0x6
>> [   38.217990] XFS (sda1):     len      = 96
>> [   38.222297] XFS (sda1):     first 32 bytes of iovec[1]:
>> [   38.228442] 00000000: 4e 49 a4 81 02 02 00 00 62 00 00 00 62 00 00 00  NI......b...b...
>> [   38.237707] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 42 09  ..............B.
> 
> truncate() or directory entry removal resulting in block to
> shortform conversion, maybe? Implies 'rm -rf', too.
> 
>>
>> - XFS_LI_BUF.XLOG_REG_TYPE_BCHUNK removed - niovecs from 3 to 2
>>
>> [ 2120.030590] XFS (md0): XXX required buf size 3992 -> 4120
>> [ 2120.037257] XFS (md0): XXX niovecs           3 -> 2
> 
> Logged buffer size went up because a hole was filled. Not a
> candidate. Was a directory buffer.
> 
>>
>> [ 2279.729095] XFS (sda1): XXX required buf size 152 -> 24
>> [ 2279.735437] XFS (sda1): XXX niovecs           2 -> 1
>>
>> [ 2279.741360] XFS (sda1): XXX old log item:
>> [ 2279.746199] XFS (sda1): log item:
>> [ 2279.750512] XFS (sda1):   type       = 0x123c
>> [ 2279.755181] XFS (sda1):   flags      = 0x8
>> [ 2279.759644] XFS (sda1):   niovecs    = 2
>> [ 2279.764246] XFS (sda1):   size       = 256
>> [ 2279.768625] XFS (sda1):   bytes      = 152
>> [ 2279.773094] XFS (sda1):   buf len    = 152
>> [ 2279.777741] XFS (sda1):   iovec[0]
>> [ 2279.782044] XFS (sda1):     type     = 0x1
>> [ 2279.786607] XFS (sda1):     len      = 24
>> [ 2279.790980] XFS (sda1):     first 24 bytes of iovec[0]:
>> [ 2279.797290] 00000000: 3c 12 02 00 00 20 08 00 b0 41 f8 08 00 00 00 00  <.... ...A......
>> [ 2279.806730] 00000010: 01 00 00 00 01 00 00 00                          ........
>> [ 2279.815287] XFS (sda1):   iovec[1]
>> [ 2279.819604] XFS (sda1):     type     = 0x2
>> [ 2279.824408] XFS (sda1):     len      = 128
>> [ 2279.828888] XFS (sda1):     first 32 bytes of iovec[1]:
>> [ 2279.835126] 00000000: 42 4d 41 50 00 00 00 09 ff ff ff ff ff ff ff ff  BMAP............
>> [ 2279.844617] 00000010: ff ff ff ff ff ff ff ff 00 00 00 00 00 00 00 00  ................
> 
> Hold on - BMAP?
> 
> But the directory buffer above was a XDB3, and so a matching BMAP
> btree buffer should have a BMA3 signature. So this is output from
> two different filesystems, one formatted with crc=0, the other with
> crc=1....
> 
> Oh, wait, now that I look at it, all the inodes in the output are v2
> inodes. Yet your testing is supposed to be running on CRC+reflink
> enabled filesystems, which use v3 inodes. So none of these traces
> come from the filesystem under your 'cp -a' workload, right?
> 
> Fmeh, it's right there - "XFS (sda1)...". These are all traces from
> your root directory, not md0/md1 which are your RAID6 devices
> running the 'cp -a' workload. The only trace from md0 was the hole
> filling buffer which grew the size of the log vector.
> 
> Ok, can you plese filter the output to limit it to just the RAID6
> filesystem under test so we get the transaction dumps just before it
> hangs? If you want to, create a separate dump output from the root
> device to capture the things it is doing, but the first thing is to
> isolate the 'cp -a' hang vector...
Okay, the (transaction-) logs for the `cp -a` load to the (empty) raid is above.

When this is understood, you probably also know, whether other transactions might still cause a problem and are of interest. So I suggest to postpone these for now.

Best

   Donald

> Cheers,
> 
> Dave.

