Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46A0EC433E0
	for <linux-xfs@archiver.kernel.org>; Sat,  2 Jan 2021 19:14:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF4E72075E
	for <linux-xfs@archiver.kernel.org>; Sat,  2 Jan 2021 19:14:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbhABTNp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 2 Jan 2021 14:13:45 -0500
Received: from mx3.molgen.mpg.de ([141.14.17.11]:39497 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726642AbhABTNn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 2 Jan 2021 14:13:43 -0500
Received: from [192.168.0.8] (ip5f5aef2f.dynamic.kabel-deutschland.de [95.90.239.47])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: buczek)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 82EAB20647B65;
        Sat,  2 Jan 2021 20:12:57 +0100 (CET)
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
From:   Donald Buczek <buczek@molgen.mpg.de>
Message-ID: <def7bbfc-c57e-bcec-f81b-b5ccb0e562e8@molgen.mpg.de>
Date:   Sat, 2 Jan 2021 20:12:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201231215919.GA331610@dread.disaster.area>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 31.12.20 22:59, Dave Chinner wrote:

Hey, funny, your email could celebrate New Year a second time :-)

> On Thu, Dec 31, 2020 at 12:48:56PM +0100, Donald Buczek wrote:
>> On 30.12.20 23:16, Dave Chinner wrote:
>>> On Wed, Dec 30, 2020 at 12:56:27AM +0100, Donald Buczek wrote:
>>>> Threads, which committed items to the CIL, wait in the
>>>> xc_push_wait waitqueue when used_space in the push context
>>>> goes over a limit. These threads need to be woken when the CIL
>>>> is pushed.
>>>>
>>>> The CIL push worker tries to avoid the overhead of calling
>>>> wake_all() when there are no waiters waiting. It does so by
>>>> checking the same condition which caused the waits to happen.
>>>> This, however, is unreliable, because ctx->space_used can
>>>> actually decrease when items are recommitted.
>>>
>>> When does this happen?
>>>
>>> Do you have tracing showing the operation where the relogged
>>> item has actually gotten smaller? By definition, relogging in
>>> the CIL should only grow the size of the object in the CIL
>>> because it must relog all the existing changes on top of the new
>>> changed being made to the object. Hence the CIL reservation
>>> should only ever grow.
>>
>> I have (very ugly printk based) log (see below), but it only
>> shows, that it happened (space_used decreasing), not what caused
>> it.
>>
>> I only browsed the ( xfs_*_item.c ) code and got the impression
>> that the size of a log item is rather dynamic (e.g. number of
>> extends in an inode, extended attributes in an inode, continuity
>> of chunks in a buffer) and wasn't surprised that a relogged item
>> might need less space from time to time.
>>
>>> IOWs, returning negative lengths from the formatting code is
>>> unexpected and probably a bug and requires further
>>> investigation, not papering over the occurrence with broadcast
>>> wakeups...
>>
>> One could argue that the code is more robust after the change,
>> because it wakes up every thread which is waiting on the next push
>> to happen when the next push is happening without making
>> assumption of why these threads are waiting by duplicating code
>> from that waiters side. The proposed waitqueue_active() is inlined
>> to two instructions and avoids the call overhead if there are no
>> waiters as well.
> 
> One could argue that, but one should also understand the design
> constraints for a particular algorithm are before suggesting that
> their solution is "robust". :)

Yes, but an understanding to the extend required by the argument should be sufficient :-)

>> # seq 29
>>
>> 2020-12-29T20:08:15.652167+01:00 deadbird kernel: [ 1053.860637] XXX trigger cil 00000000e374c6f1 ctx 000000004967d650  ctx->space_used=33554656      , push_seq=29, ctx->sequence=29
> 
> So, at 20:08:15 we get a push trigger and the work is queued. But...
> 
> .....
>> 2020-12-29T20:09:04.961088+01:00 deadbird kernel: [ 1103.168964] XXX wake    cil 00000000e374c6f1 ctx 000000004967d650  ctx->space_used=67109136 >= 67108864, push_seq=29, ctx->sequence=29
> 
> It takes the best part of *50 seconds* before the push work actually
> runs?
> 
> That's .... well and truly screwed up - the work should run on that
> CPU on the very next time it yeilds the CPU. If we're holding the
> CPU without yeilding it for that long, hangcheck and RCU warnings
> should be going off...

No such warnings.

But the load is probably I/O bound to the log:

- creates `cp -a` copies of a directory tree with small files (linux source repository)
- source tree probably completely cached.
- two copies in parallel
- slow log (on software raid6)

Isn't it to be expected that sooner or later you need to wait for log writes when you write as fast as possible with lots of metadata updates and not so much data?

I'm a bit concerned, though, that there seem to be a rather unlimited (~ 1000) number of kernel worker threads waiting for the cil push and indirectly for log writes.

>> # seq 30
>>
>> 2020-12-29T20:09:39.305108+01:00 deadbird kernel: [ 1137.514718] XXX trigger cil 00000000e374c6f1 ctx 00000000c46ab121  ctx->space_used=33554480      , push_seq=30, ctx->sequence=30
> 
> 20:09:39 for the next trigger,
> 
>> 2020-12-29T20:10:20.389104+01:00 deadbird kernel: [ 1178.597976] XXX pushw   cil 00000000e374c6f1 ctx 00000000c46ab121  ctx->space_used=67108924 >= 67108864, push_seq=30, ctx->sequence=30
>> 2020-12-29T20:10:20.389117+01:00 deadbird kernel: [ 1178.613792] XXX pushw   cil 00000000e374c6f1 ctx 00000000c46ab121  ctx->space_used=67108924 >= 67108864, push_seq=30, ctx->sequence=30
>> 2020-12-29T20:10:20.619077+01:00 deadbird kernel: [ 1178.827935] XXX pushw   cil 00000000e374c6f1 ctx 00000000c46ab121  ctx->space_used=67108924 >= 67108864, push_seq=30, ctx->sequence=30
>> 2020-12-29T20:10:21.129074+01:00 deadbird kernel: [ 1179.337996] XXX pushw   cil 00000000e374c6f1 ctx 00000000c46ab121  ctx->space_used=67108924 >= 67108864, push_seq=30, ctx->sequence=30
>> 2020-12-29T20:10:21.190101+01:00 deadbird kernel: [ 1179.398869] XXX pushw   cil 00000000e374c6f1 ctx 00000000c46ab121  ctx->space_used=67108924 >= 67108864, push_seq=30, ctx->sequence=30
>> 2020-12-29T20:10:21.866096+01:00 deadbird kernel: [ 1180.074325] XXX pushw   cil 00000000e374c6f1 ctx 00000000c46ab121  ctx->space_used=67108924 >= 67108864, push_seq=30, ctx->sequence=30
>> 2020-12-29T20:10:22.076095+01:00 deadbird kernel: [ 1180.283748] XXX pushw   cil 00000000e374c6f1 ctx 00000000c46ab121  ctx->space_used=67108924 >= 67108864, push_seq=30, ctx->sequence=30
>> 2020-12-29T20:10:22.193070+01:00 deadbird kernel: [ 1180.401590] XXX pushw   cil 00000000e374c6f1 ctx 00000000c46ab121  ctx->space_used=67108924 >= 67108864, push_seq=30, ctx->sequence=30
>> 2020-12-29T20:10:22.421082+01:00 deadbird kernel: [ 1180.629682] XXX pushw   cil 00000000e374c6f1 ctx 00000000c46ab121  ctx->space_used=67108908 >= 67108864, push_seq=30, ctx->sequence=30
> 
> So it dropped by 16 bytes (seems to be common) which is unexpected.
> I wonder if it filled a hole in a buffer and so needed one less
> xlog_op_header()? But then the size would have gone up by at least
> 128 bytes for the hole that was filled, so it still shouldn't go
> down in size.
> 
> I think you need to instrument xlog_cil_insert_items() and catch
> a negative length here:
> 
> 	/* account for space used by new iovec headers  */
> 	iovhdr_res = diff_iovecs * sizeof(xlog_op_header_t);
> 	len += iovhdr_res;
> 	ctx->nvecs += diff_iovecs;
> 
> (diff_iovecs will be negative if the number of xlog_op_header
> structures goes down)
> 
> And if this happens, then dump the transaction ticket via
> xlog_print_trans(tp) so we can see all the log items types and
> vectors that the transaction has formatted...

I tried that, but the output was difficult to understand, because at that point you can only log the complete transaction with the items already updated. And a shrinking item is not switched to the shadow vector, so the formatted content is already overwritten and not available for analysis.

So I've added some code to dump an item in its old and its new state in xlog_cil_insert_format_items when either the requested buffer len or the number of vectors decreased.

Several examples of different kind with a little bit of manual annotation following

Best
   Donald

- XFS_LI_INODE.XLOG_REG_TYPE_ILOCAL from 32 to 20 bytes

[   29.606212] XFS (sda1): XXX required buf size 184 -> 172
[   29.612591] XFS (sda1): XXX niovecs           3 -> 3

[   29.618570] XFS (sda1): XXX old log item:
[   29.623469] XFS (sda1): log item:
[   29.627683] XFS (sda1):   type       = 0x123b                                               # XFS_LI_INODE
[   29.632375] XFS (sda1):   flags      = 0x8
[   29.636858] XFS (sda1):   niovecs    = 3
[   29.647442] XFS (sda1):   size       = 312
[   29.651814] XFS (sda1):   bytes      = 184
[   29.656278] XFS (sda1):   buf len    = 184
[   29.660927] XFS (sda1):   iovec[0]
[   29.665071] XFS (sda1):     type     = 0x5                                                  # XLOG_REG_TYPE_IFORMAT
[   29.669592] XFS (sda1):     len      = 56
[   29.673914] XFS (sda1):     first 32 bytes of iovec[0]:
[   29.680079] 00000000: 3b 12 03 00 03 00 00 00 00 00 20 00 00 00 00 00  ;......... .....
[   29.689363] 00000010: 37 ab 20 00 00 00 00 00 00 00 00 00 00 00 00 00  7. .............
[   29.698633] XFS (sda1):   iovec[1]
[   29.702756] XFS (sda1):     type     = 0x6                                                  # XLOG_REG_TYPE_ICORE
[   29.707263] XFS (sda1):     len      = 96
[   29.711571] XFS (sda1):     first 32 bytes of iovec[1]:
[   29.717720] 00000000: 4e 49 ed 41 02 01 00 00 00 00 00 00 00 00 00 00  NI.A............
[   29.726986] 00000010: 02 00 00 00 00 00 00 00 00 00 00 00 00 00 05 00  ................
[   29.736241] XFS (sda1):   iovec[2]
[   29.740364] XFS (sda1):     type     = 0x9                                                  # XLOG_REG_TYPE_ILOCAL
[   29.744873] XFS (sda1):     len      = 32
[   29.749184] XFS (sda1):     first 32 bytes of iovec[2]:
[   29.755336] 00000000: 02 00 30 e7 02 26 06 00 40 73 65 72 76 65 72 00  ..0..&..@server.
[   29.764612] 00000010: 08 92 ef 04 00 58 6d 78 36 34 00 d3 93 58 00 58  .....Xmx64...X.X

[   29.773900] XFS (sda1): XXX new log item:
[   29.778718] XFS (sda1): log item:
[   29.782856] XFS (sda1):   type       = 0x123b
[   29.787478] XFS (sda1):   flags      = 0x8
[   29.791902] XFS (sda1):   niovecs    = 3
[   29.796321] XFS (sda1):   size       = 312
[   29.800640] XFS (sda1):   bytes      = 172
[   29.805052] XFS (sda1):   buf len    = 176
[   29.809659] XFS (sda1):   iovec[0]
[   29.813781] XFS (sda1):     type     = 0x5
[   29.818289] XFS (sda1):     len      = 56
[   29.822599] XFS (sda1):     first 32 bytes of iovec[0]:
[   29.828754] 00000000: 3b 12 03 00 03 00 00 00 00 00 14 00 00 00 00 00  ;...............
[   29.838024] 00000010: 37 ab 20 00 00 00 00 00 00 00 00 00 00 00 00 00  7. .............
[   29.847292] XFS (sda1):   iovec[1]
[   29.851420] XFS (sda1):     type     = 0x6
[   29.855933] XFS (sda1):     len      = 96
[   29.860247] XFS (sda1):     first 32 bytes of iovec[1]:
[   29.866406] 00000000: 4e 49 ed 41 02 01 00 00 00 00 00 00 00 00 00 00  NI.A............
[   29.875677] 00000010: 02 00 00 00 00 00 00 00 00 00 00 00 00 00 05 00  ................
[   29.884949] XFS (sda1):   iovec[2]
[   29.889081] XFS (sda1):     type     = 0x9
[   29.893601] XFS (sda1):     len      = 20
[   29.897924] XFS (sda1):     first 20 bytes of iovec[2]:
[   29.904096] 00000000: 01 00 30 e7 02 26 04 00 58 6d 78 36 34 00 d3 93  ..0..&..Xmx64...
[   29.913381] 00000010: 58 92 ef 04                                      X...

- (then) XFS_LI_INODE.XLOG_REG_TYPE_ILOCAL from 20 to 8 bytes

[   29.982907] XFS (sda1): XXX required buf size 172 -> 160
[   29.992716] XFS (sda1): XXX niovecs           3 -> 3

[   29.998728] XFS (sda1): XXX old log item:
[   30.003624] XFS (sda1): log item:
[   30.007835] XFS (sda1):   type       = 0x123b
[   30.012654] XFS (sda1):   flags      = 0x8
[   30.017145] XFS (sda1):   niovecs    = 3
[   30.021638] XFS (sda1):   size       = 312
[   30.026012] XFS (sda1):   bytes      = 172
[   30.030610] XFS (sda1):   buf len    = 176
[   30.035292] XFS (sda1):   iovec[0]
[   30.039480] XFS (sda1):     type     = 0x5
[   30.044054] XFS (sda1):     len      = 56
[   30.048534] XFS (sda1):     first 32 bytes of iovec[0]:
[   30.054749] 00000000: 3b 12 03 00 03 00 00 00 00 00 14 00 00 00 00 00  ;...............
[   30.064091] 00000010: 37 ab 20 00 00 00 00 00 00 00 00 00 00 00 00 00  7. .............
[   30.073545] XFS (sda1):   iovec[1]
[   30.077744] XFS (sda1):     type     = 0x6
[   30.082455] XFS (sda1):     len      = 96
[   30.086824] XFS (sda1):     first 32 bytes of iovec[1]:
[   30.093025] 00000000: 4e 49 ed 41 02 01 00 00 00 00 00 00 00 00 00 00  NI.A............
[   30.102346] 00000010: 02 00 00 00 00 00 00 00 00 00 00 00 00 00 05 00  ................
[   30.111801] XFS (sda1):   iovec[2]
[   30.115989] XFS (sda1):     type     = 0x9
[   30.120715] XFS (sda1):     len      = 20
[   30.125102] XFS (sda1):     first 20 bytes of iovec[2]:
[   30.131331] 00000000: 01 00 30 e7 02 26 04 00 58 6d 78 36 34 00 d3 93  ..0..&..Xmx64...
[   30.140808] 00000010: 58 92 ef 04                                      X...

[   30.149006] XFS (sda1): XXX new log item:
[   30.154039] XFS (sda1): log item:
[   30.154039] XFS (sda1):   type       = 0x123b
[   30.154041] XFS (sda1):   flags      = 0x8
[   30.167436] XFS (sda1):   niovecs    = 3
[   30.167437] XFS (sda1):   size       = 312
[   30.167438] XFS (sda1):   bytes      = 160
[   30.180881] XFS (sda1):   buf len    = 160
[   30.180882] XFS (sda1):   iovec[0]
[   30.180882] XFS (sda1):     type     = 0x5
[   30.180883] XFS (sda1):     len      = 56
[   30.180884] XFS (sda1):     first 32 bytes of iovec[0]:
[   30.180884] 00000000: 3b 12 03 00 03 00 00 00 00 00 08 00 00 00 00 00  ;...............
[   30.180885] 00000010: 37 ab 20 00 00 00 00 00 00 00 00 00 00 00 00 00  7. .............
[   30.180886] XFS (sda1):   iovec[1]
[   30.180886] XFS (sda1):     type     = 0x6
[   30.180887] XFS (sda1):     len      = 96
[   30.180887] XFS (sda1):     first 32 bytes of iovec[1]:
[   30.180888] 00000000: 4e 49 ed 41 02 01 00 00 00 00 00 00 00 00 00 00  NI.A............
[   30.180889] 00000010: 02 00 00 00 00 00 00 00 00 00 00 00 00 00 05 00  ................
[   30.180889] XFS (sda1):   iovec[2]
[   30.180890] XFS (sda1):     type     = 0x9
[   30.180890] XFS (sda1):     len      = 8
[   30.180890] XFS (sda1):     first 8 bytes of iovec[2]:
[   30.180891] 00000000: 00 00 30 e7 02 26 04 00                          ..0..&..

- (then) XFS_LI_INODE.XLOG_REG_TYPE_ILOCAL removed - niovecs from 3 to 2

[   30.197403] XFS (sda1): XXX required buf size 160 -> 152
[   30.296091] XFS (sda1): XXX niovecs           3 -> 2

[   30.296092] XFS (sda1): XXX old log item:
[   30.296093] XFS (sda1): log item:
[   30.297552] ixgbe 0000:01:00.1 net03: renamed from eth3
[   30.317524] XFS (sda1):   type       = 0x123b
[   30.317524] XFS (sda1):   flags      = 0x8
[   30.317525] XFS (sda1):   niovecs    = 3
[   30.317525] XFS (sda1):   size       = 304
[   30.317526] XFS (sda1):   bytes      = 160
[   30.317526] XFS (sda1):   buf len    = 160
[   30.317527] XFS (sda1):   iovec[0]
[   30.317527] XFS (sda1):     type     = 0x5
[   30.317528] XFS (sda1):     len      = 56
[   30.317528] XFS (sda1):     first 32 bytes of iovec[0]:
[   30.317529] 00000000: 3b 12 03 00 03 00 00 00 00 00 08 00 00 00 00 00  ;...............
[   30.317530] 00000010: 37 ab 20 00 00 00 00 00 00 00 00 00 00 00 00 00  7. .............
[   30.317531] XFS (sda1):   iovec[1]
[   30.317531] XFS (sda1):     type     = 0x6
[   30.317531] XFS (sda1):     len      = 96
[   30.317532] XFS (sda1):     first 32 bytes of iovec[1]:
[   30.317533] 00000000: 4e 49 ed 41 02 01 00 00 00 00 00 00 00 00 00 00  NI.A............
[   30.317533] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 05 00  ................
[   30.317533] XFS (sda1):   iovec[2]
[   30.317534] XFS (sda1):     type     = 0x9
[   30.317534] XFS (sda1):     len      = 8
[   30.317535] XFS (sda1):     first 8 bytes of iovec[2]:
[   30.317535] 00000000: 00 00 30 e7 02 26 04 00                          ..0..&..

[   30.317536] XFS (sda1): XXX new log item:
[   30.317537] XFS (sda1): log item:
[   30.317537] XFS (sda1):   type       = 0x123b
[   30.317538] XFS (sda1):   flags      = 0x8
[   30.317539] XFS (sda1):   niovecs    = 2
[   30.317539] XFS (sda1):   size       = 304
[   30.317540] XFS (sda1):   bytes      = 152
[   30.317540] XFS (sda1):   buf len    = 152
[   30.317541] XFS (sda1):   iovec[0]
[   30.317541] XFS (sda1):     type     = 0x5
[   30.317542] XFS (sda1):     len      = 56
[   30.317542] XFS (sda1):     first 32 bytes of iovec[0]:
[   30.317543] 00000000: 3b 12 02 00 01 00 00 00 00 00 00 00 00 00 00 00  ;...............
[   30.317543] 00000010: 37 ab 20 00 00 00 00 00 00 00 00 00 00 00 00 00  7. .............
[   30.317544] XFS (sda1):   iovec[1]
[   30.317544] XFS (sda1):     type     = 0x6
[   30.317545] XFS (sda1):     len      = 96
[   30.317545] XFS (sda1):     first 32 bytes of iovec[1]:
[   30.317546] 00000000: 4e 49 00 00 02 02 00 00 00 00 00 00 00 00 00 00  NI..............
[   30.317546] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 05 00  ................

- XFS_LI_INODE.XLOG_REG_TYPE_IEXT removed - niovecs from 3 to 2

[   37.983756] XFS (sda1): XXX required buf size 168 -> 152
[   37.990253] XFS (sda1): XXX niovecs           3 -> 2

[   37.996202] XFS (sda1): XXX old log item:
[   38.001061] XFS (sda1): log item:
[   38.005239] XFS (sda1):   type       = 0x123b
[   38.009885] XFS (sda1):   flags      = 0x9
[   38.014330] XFS (sda1):   niovecs    = 3
[   38.018764] XFS (sda1):   size       = 440
[   38.023100] XFS (sda1):   bytes      = 168
[   38.027533] XFS (sda1):   buf len    = 168
[   38.032157] XFS (sda1):   iovec[0]
[   38.036286] XFS (sda1):     type     = 0x5
[   38.040796] XFS (sda1):     len      = 56
[   38.045114] XFS (sda1):     first 32 bytes of iovec[0]:
[   38.051277] 00000000: 3b 12 03 00 05 00 00 00 00 00 10 00 00 00 00 00  ;...............
[   38.060562] 00000010: cb 91 08 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   38.069853] XFS (sda1):   iovec[1]
[   38.073989] XFS (sda1):     type     = 0x6
[   38.078525] XFS (sda1):     len      = 96
[   38.082871] XFS (sda1):     first 32 bytes of iovec[1]:
[   38.089052] 00000000: 4e 49 a4 81 02 02 00 00 62 00 00 00 62 00 00 00  NI......b...b...
[   38.098331] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 42 09  ..............B.
[   38.107611] XFS (sda1):   iovec[2]
[   38.111754] XFS (sda1):     type     = 0x7                                                # XLOG_REG_TYPE_IEXT
[   38.116285] XFS (sda1):     len      = 16
[   38.120608] XFS (sda1):     first 16 bytes of iovec[2]:
[   38.126770] 00000000: 00 00 00 00 00 00 00 00 00 00 00 11 31 80 00 01  ............1...

[   38.136054] XFS (sda1): XXX new log item:
[   38.140878] XFS (sda1): log item:
[   38.145025] XFS (sda1):   type       = 0x123b
[   38.149645] XFS (sda1):   flags      = 0x9
[   38.154067] XFS (sda1):   niovecs    = 2
[   38.158490] XFS (sda1):   size       = 440
[   38.162799] XFS (sda1):   bytes      = 152
[   38.167202] XFS (sda1):   buf len    = 152
[   38.171801] XFS (sda1):   iovec[0]
[   38.175911] XFS (sda1):     type     = 0x5
[   38.180409] XFS (sda1):     len      = 56
[   38.184708] XFS (sda1):     first 32 bytes of iovec[0]:
[   38.190852] 00000000: 3b 12 02 00 01 00 00 00 00 00 00 00 00 00 00 00  ;...............
[   38.200115] 00000010: cb 91 08 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   38.209373] XFS (sda1):   iovec[1]
[   38.213488] XFS (sda1):     type     = 0x6
[   38.217990] XFS (sda1):     len      = 96
[   38.222297] XFS (sda1):     first 32 bytes of iovec[1]:
[   38.228442] 00000000: 4e 49 a4 81 02 02 00 00 62 00 00 00 62 00 00 00  NI......b...b...
[   38.237707] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 42 09  ..............B.

- XFS_LI_BUF.XLOG_REG_TYPE_BCHUNK removed - niovecs from 3 to 2

[ 2120.030590] XFS (md0): XXX required buf size 3992 -> 4120
[ 2120.037257] XFS (md0): XXX niovecs           3 -> 2

[ 2120.043295] XFS (md0): XXX old log item:
[ 2120.048235] XFS (md0): log item:
[ 2120.052394] XFS (md0):   type        = 0x123c                                             # XFS_LI_BUF
[ 2120.057112] XFS (md0):   flags       = 0x8
[ 2120.061624] XFS (md0):   niovecs     = 3
[ 2120.066029] XFS (md0):   size        = 4120
[ 2120.070528] XFS (md0):   bytes       = 3992
[ 2120.075120] XFS (md0):   buf len     = 3992
[ 2120.079990] XFS (md0):   iovec[0]
[ 2120.084200] XFS (md0):     type      = 0x1                                                # XLOG_REG_TYPE_BFORMAT
[ 2120.088891] XFS (md0):     len       = 24
[ 2120.093287] XFS (md0):     first 24 bytes of iovec[0]:
[ 2120.099622] 00000000: 3c 12 03 00 00 50 08 00 78 dc ff 7f 04 00 00 00  <....P..x.......
[ 2120.109088] 00000010: 01 00 00 00 ff ff ff fe                          ........
[ 2120.117878] XFS (md0):   iovec[1]
[ 2120.122012] XFS (md0):     type      = 0x2                                                # XLOG_REG_TYPE_BCHUNK
[ 2120.126532] XFS (md0):     len       = 3072
[ 2120.131130] XFS (md0):     first 32 bytes of iovec[1]:
[ 2120.137376] 00000000: 58 44 42 33 00 00 00 00 00 00 00 04 7f ff dc 78  XDB3...........x
[ 2120.146740] 00000010: 00 00 00 00 00 00 00 00 58 03 ee 68 c3 6b 48 0c  ........X..h.kH.
[ 2120.156111] XFS (md0):   iovec[2]
[ 2120.160339] XFS (md0):     type      = 0x2                                                # XLOG_REG_TYPE_BCHUNK
[ 2120.164860] XFS (md0):     len       = 896
[ 2120.169354] XFS (md0):     first 32 bytes of iovec[2]:
[ 2120.175509] 00000000: 00 00 00 00 00 00 0b 80 00 00 00 2e 00 00 00 08  ................
[ 2120.184963] 00000010: 00 00 17 2e 00 00 00 0a 04 7c 79 34 00 00 00 16  .........|y4....

[ 2120.194426] XFS (md0): XXX new log item:
[ 2120.199236] XFS (md0): log item:
[ 2120.203459] XFS (md0):   type        = 0x123c
[ 2120.208064] XFS (md0):   flags       = 0x8
[ 2120.212465] XFS (md0):   niovecs     = 2
[ 2120.216949] XFS (md0):   size        = 4224
[ 2120.221434] XFS (md0):   bytes       = 4120
[ 2120.225921] XFS (md0):   buf len     = 4120
[ 2120.230695] XFS (md0):   iovec[0]
[ 2120.234780] XFS (md0):     type      = 0x1
[ 2120.239256] XFS (md0):     len       = 24
[ 2120.243619] XFS (md0):     first 24 bytes of iovec[0]:
[ 2120.249735] 00000000: 3c 12 02 00 00 50 08 00 78 dc ff 7f 04 00 00 00  <....P..x.......
[ 2120.259148] 00000010: 01 00 00 00 ff ff ff ff                          ........
[ 2120.267776] XFS (md0):   iovec[1]
[ 2120.271845] XFS (md0):     type      = 0x2
[ 2120.276287] XFS (md0):     len       = 4096
[ 2120.280803] XFS (md0):     first 32 bytes of iovec[1]:
[ 2120.286884] 00000000: 58 44 42 33 00 00 00 00 00 00 00 04 7f ff dc 78  XDB3...........x
[ 2120.296254] 00000010: 00 00 00 00 00 00 00 00 58 03 ee 68 c3 6b 48 0c  ........X..h.kH.

- only XFS_LI_BUF.XLOG_REG_TYPE_BCHUNK removed - niovecs from 2 to 1

[ 2279.729095] XFS (sda1): XXX required buf size 152 -> 24
[ 2279.735437] XFS (sda1): XXX niovecs           2 -> 1

[ 2279.741360] XFS (sda1): XXX old log item:
[ 2279.746199] XFS (sda1): log item:
[ 2279.750512] XFS (sda1):   type       = 0x123c
[ 2279.755181] XFS (sda1):   flags      = 0x8
[ 2279.759644] XFS (sda1):   niovecs    = 2
[ 2279.764246] XFS (sda1):   size       = 256
[ 2279.768625] XFS (sda1):   bytes      = 152
[ 2279.773094] XFS (sda1):   buf len    = 152
[ 2279.777741] XFS (sda1):   iovec[0]
[ 2279.782044] XFS (sda1):     type     = 0x1
[ 2279.786607] XFS (sda1):     len      = 24
[ 2279.790980] XFS (sda1):     first 24 bytes of iovec[0]:
[ 2279.797290] 00000000: 3c 12 02 00 00 20 08 00 b0 41 f8 08 00 00 00 00  <.... ...A......
[ 2279.806730] 00000010: 01 00 00 00 01 00 00 00                          ........
[ 2279.815287] XFS (sda1):   iovec[1]
[ 2279.819604] XFS (sda1):     type     = 0x2
[ 2279.824408] XFS (sda1):     len      = 128
[ 2279.828888] XFS (sda1):     first 32 bytes of iovec[1]:
[ 2279.835126] 00000000: 42 4d 41 50 00 00 00 09 ff ff ff ff ff ff ff ff  BMAP............
[ 2279.844617] 00000010: ff ff ff ff ff ff ff ff 00 00 00 00 00 00 00 00  ................

[ 2279.853964] XFS (sda1): XXX new log item:
[ 2279.858958] XFS (sda1): log item:
[ 2279.863149] XFS (sda1):   type       = 0x123c
[ 2279.867834] XFS (sda1):   flags      = 0x8
[ 2279.872410] XFS (sda1):   niovecs    = 1
[ 2279.876874] XFS (sda1):   size       = 256
[ 2279.881242] XFS (sda1):   bytes      = 24
[ 2279.885585] XFS (sda1):   buf len    = 24
[ 2279.890248] XFS (sda1):   iovec[0]
[ 2279.894408] XFS (sda1):     type     = 0x1
[ 2279.898954] XFS (sda1):     len      = 24
[ 2279.903291] XFS (sda1):     first 24 bytes of iovec[0]:
[ 2279.909608] 00000000: 3c 12 01 00 02 00 08 00 b0 41 f8 08 00 00 00 00  <........A......
[ 2279.918937] 00000010: 01 00 00 00 00 00 00 00                          ........

Log code for reference

commit 137ce3815d4d3ec47a2cf043a9c26aff1892eabe
Author: Donald Buczek <buczek@molgen.mpg.de>
Date:   Fri Jan 1 15:36:30 2021 +0100

     log negativ log items

diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index 58c3fcbec94a..d2e6c7d78047 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -17,6 +17,7 @@ struct xfs_log_vec {
  	int			lv_bytes;	/* accounted space in buffer */
  	int			lv_buf_len;	/* aligned size of buffer */
  	int			lv_size;	/* size of allocated lv */
+	int			lv_debug_required_bytes;
  };
  
  #define XFS_LOG_VEC_ORDERED	(-1)
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index d620de8e217c..3931ae9c8996 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -17,6 +17,8 @@
  #include "xfs_log_priv.h"
  #include "xfs_trace.h"
  
+#include <linux/ratelimit_types.h>
+
  struct workqueue_struct *xfs_discard_wq;
  
  /*
@@ -133,6 +135,7 @@ xlog_cil_alloc_shadow_bufs(
  		int	nbytes = 0;
  		int	buf_size;
  		bool	ordered = false;
+		int	debug_required_bytes;
  
  		/* Skip items which aren't dirty in this transaction. */
  		if (!test_bit(XFS_LI_DIRTY, &lip->li_flags))
@@ -141,6 +144,8 @@ xlog_cil_alloc_shadow_bufs(
  		/* get number of vecs and size of data to be stored */
  		lip->li_ops->iop_size(lip, &niovecs, &nbytes);
  
+		debug_required_bytes = nbytes;
+
  		/*
  		 * Ordered items need to be tracked but we do not wish to write
  		 * them. We need a logvec to track the object, but we do not
@@ -208,6 +213,7 @@ xlog_cil_alloc_shadow_bufs(
  
  		/* Ensure the lv is set up according to ->iop_size */
  		lv->lv_niovecs = niovecs;
+		lv->lv_debug_required_bytes = debug_required_bytes;
  
  		/* The allocated data region lies beyond the iovec region */
  		lv->lv_buf = (char *)lv + xlog_cil_iovec_space(niovecs);
@@ -266,6 +272,39 @@ xfs_cil_prepare_item(
  		lv->lv_item->li_seq = log->l_cilp->xc_ctx->sequence;
  }
  
+static void xlog_print_logitem(
+	struct xfs_log_item *lip) {
+
+	struct xfs_mount	*mp = lip->li_mountp;
+	struct xfs_log_vec	*lv = lip->li_lv;
+	struct xfs_log_iovec	*vec;
+	int			i;
+
+	xfs_warn(mp, "log item: ");
+	xfs_warn(mp, "  type	= 0x%x", lip->li_type);
+	xfs_warn(mp, "  flags	= 0x%lx", lip->li_flags);
+	if (!lv)
+		return;
+	xfs_warn(mp, "  niovecs	= %d", lv->lv_niovecs);
+	xfs_warn(mp, "  size	= %d", lv->lv_size);
+	xfs_warn(mp, "  bytes	= %d", lv->lv_bytes);
+	xfs_warn(mp, "  buf len	= %d", lv->lv_buf_len);
+
+	/* dump each iovec for the log item */
+	vec = lv->lv_iovecp;
+	for (i = 0; i < lv->lv_niovecs; i++) {
+		int dumplen = min(vec->i_len, 32);
+
+		xfs_warn(mp, "  iovec[%d]", i);
+		xfs_warn(mp, "    type	= 0x%x", vec->i_type);
+		xfs_warn(mp, "    len	= %d", vec->i_len);
+		xfs_warn(mp, "    first %d bytes of iovec[%d]:", dumplen, i);
+		xfs_hex_dump(vec->i_addr, dumplen);
+
+		vec++;
+	}
+}
+
  /*
   * Format log item into a flat buffers
   *
@@ -315,6 +354,8 @@ xlog_cil_insert_format_items(
  		struct xfs_log_vec *old_lv = NULL;
  		struct xfs_log_vec *shadow;
  		bool	ordered = false;
+		bool	want_dump = false;
+		static DEFINE_RATELIMIT_STATE(_rs, 1*HZ, 5);
  
  		/* Skip items which aren't dirty in this transaction. */
  		if (!test_bit(XFS_LI_DIRTY, &lip->li_flags))
@@ -334,6 +375,21 @@ xlog_cil_insert_format_items(
  
  		/* compare to existing item size */
  		old_lv = lip->li_lv;
+
+		if (lip->li_lv
+			&& (
+				shadow->lv_debug_required_bytes < old_lv->lv_bytes
+				|| shadow->lv_niovecs < old_lv->lv_niovecs )
+			&& __ratelimit(&_rs) ) {
+			xfs_warn(lip->li_mountp, "XXX required buf size %d -> %d",
+				old_lv->lv_bytes, shadow->lv_debug_required_bytes);
+			xfs_warn(lip->li_mountp, "XXX niovecs           %d -> %d",
+				old_lv->lv_niovecs, shadow->lv_niovecs);
+			xfs_warn(lip->li_mountp, "XXX old log item:");
+			xlog_print_logitem(lip);
+			want_dump = true;
+		}
+
  		if (lip->li_lv && shadow->lv_size <= lip->li_lv->lv_size) {
  			/* same or smaller, optimise common overwrite case */
  			lv = lip->li_lv;
@@ -372,6 +428,10 @@ xlog_cil_insert_format_items(
  		lip->li_ops->iop_format(lip, lv);
  insert:
  		xfs_cil_prepare_item(log, lv, old_lv, diff_len, diff_iovecs);
+		if (want_dump) {
+			xfs_warn(lip->li_mountp, "XXX new log item:");
+			xlog_print_logitem(lip);
+		}
  	}
  }
  

