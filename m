Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49F87C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Dec 2020 11:49:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B7092242A
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Dec 2020 11:49:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbgLaLtl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 31 Dec 2020 06:49:41 -0500
Received: from mx3.molgen.mpg.de ([141.14.17.11]:40053 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726071AbgLaLtk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 31 Dec 2020 06:49:40 -0500
Received: from [192.168.0.8] (ip5f5aef2f.dynamic.kabel-deutschland.de [95.90.239.47])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: buczek)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 9493A202254D6;
        Thu, 31 Dec 2020 12:48:56 +0100 (CET)
Subject: Re: [PATCH] xfs: Wake CIL push waiters more reliably
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        it+linux-xfs@molgen.mpg.de
References: <1705b481-16db-391e-48a8-a932d1f137e7@molgen.mpg.de>
 <20201229235627.33289-1-buczek@molgen.mpg.de>
 <20201230221611.GC164134@dread.disaster.area>
From:   Donald Buczek <buczek@molgen.mpg.de>
Message-ID: <7bd30426-11dc-e482-dcc8-55d279bc75bd@molgen.mpg.de>
Date:   Thu, 31 Dec 2020 12:48:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201230221611.GC164134@dread.disaster.area>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 30.12.20 23:16, Dave Chinner wrote:
> On Wed, Dec 30, 2020 at 12:56:27AM +0100, Donald Buczek wrote:
>> Threads, which committed items to the CIL, wait in the xc_push_wait
>> waitqueue when used_space in the push context goes over a limit. These
>> threads need to be woken when the CIL is pushed.
>>
>> The CIL push worker tries to avoid the overhead of calling wake_all()
>> when there are no waiters waiting. It does so by checking the same
>> condition which caused the waits to happen. This, however, is
>> unreliable, because ctx->space_used can actually decrease when items are
>> recommitted.
> 
> When does this happen?
> 
> Do you have tracing showing the operation where the relogged item
> has actually gotten smaller? By definition, relogging in the CIL
> should only grow the size of the object in the CIL because it must
> relog all the existing changes on top of the new changed being made
> to the object. Hence the CIL reservation should only ever grow.

I have (very ugly printk based) log (see below), but it only shows, that it happened (space_used decreasing), not what caused it.

I only browsed the ( xfs_*_item.c ) code and got the impression that the size of a log item is rather dynamic (e.g. number of extends in an inode, extended attributes in an inode, continuity of chunks in a buffer) and wasn't surprised that a relogged item might need less space from time to time.

> IOWs, returning negative lengths from the formatting code is
> unexpected and probably a bug and requires further investigation,
> not papering over the occurrence with broadcast wakeups...

One could argue that the code is more robust after the change, because it wakes up every thread which is waiting on the next push to happen when the next push is happening without making assumption of why these threads are waiting by duplicating code from that waiters side. The proposed waitqueue_active() is inlined to two instructions and avoids the call overhead if there are no waiters as well.

But, of course, if the size is not expected to decrease, this discrepancy must be clarified anyway. I am sure, I can find out the exact circumstances, this does happen. I will follow up on this.

Happy New Year!

   Donald

Log extract following....

========

+++ b/fs/xfs/xfs_log_cil.c
@@ -17,6 +17,8 @@
  #include "xfs_log_priv.h"
  #include "xfs_trace.h"
  
+#include <linux/printk.h>
+
  struct workqueue_struct *xfs_discard_wq;
  
  /*
@@ -670,8 +672,25 @@ xlog_cil_push_work(
         /*
          * Wake up any background push waiters now this context is being pushed.
          */
-       if (ctx->space_used >= XLOG_CIL_BLOCKING_SPACE_LIMIT(log))
+       if (ctx->space_used >= XLOG_CIL_BLOCKING_SPACE_LIMIT(log)) {
                 wake_up_all(&cil->xc_push_wait);
+               pr_warn("XXX wake    cil %p ctx %p  ctx->space_used=%d >= %d, push_seq=%lld, ctx->sequence=%lld\n",
+                       cil, ctx,
+                       ctx->space_used,
+                       XLOG_CIL_BLOCKING_SPACE_LIMIT(log),
+                       cil->xc_push_seq,
+                       ctx->sequence);
+       } else {
+               pr_warn("XXX no wake cil %p ctx %p ctx->space_used=%d < %d, push_seq=%lld, ctx->sequence=%lld\n",
+                       cil, ctx,
+                       ctx->space_used,
+                       XLOG_CIL_BLOCKING_SPACE_LIMIT(log),
+                       cil->xc_push_seq,
+                       ctx->sequence);
+               if (waitqueue_active(&cil->xc_push_wait)) {
+                       pr_warn("XXX xc_push_wait ACTIVE!\n");
+               }
+       }
  
         /*
          * Check if we've anything to push. If there is nothing, then we don't
@@ -918,6 +937,11 @@ xlog_cil_push_background(
         spin_lock(&cil->xc_push_lock);
         if (cil->xc_push_seq < cil->xc_current_sequence) {
                 cil->xc_push_seq = cil->xc_current_sequence;
+               pr_warn("XXX trigger cil %p ctx %p  ctx->space_used=%d      , push_seq=%lld, ctx->sequence=%lld\n",
+                       cil, cil->xc_ctx,
+                       cil->xc_ctx->space_used,
+                       cil->xc_push_seq,
+                       cil->xc_ctx->sequence);
                 queue_work(log->l_mp->m_cil_workqueue, &cil->xc_push_work);
         }
  
@@ -936,6 +960,12 @@ xlog_cil_push_background(
         if (cil->xc_ctx->space_used >= XLOG_CIL_BLOCKING_SPACE_LIMIT(log)) {
                 trace_xfs_log_cil_wait(log, cil->xc_ctx->ticket);
                 ASSERT(cil->xc_ctx->space_used < log->l_logsize);
+               pr_warn("XXX pushw   cil %p ctx %p  ctx->space_used=%d >= %d, push_seq=%lld, ctx->sequence=%lld\n",
+                       cil, cil->xc_ctx,
+                       cil->xc_ctx->space_used,
+                       XLOG_CIL_BLOCKING_SPACE_LIMIT(log),
+                       cil->xc_push_seq,
+                       cil->xc_ctx->sequence);
                 xlog_wait(&cil->xc_push_wait, &cil->xc_push_lock);
                 return;
         }

=====

14606 "XXX" lines logged before deadlock
4847 "XXX" lines logged for the deadlocked filesystem (CIL 00000000e374c6f1) before deadlock

relevant lines:

# seq 29

2020-12-29T20:08:15.652167+01:00 deadbird kernel: [ 1053.860637] XXX trigger cil 00000000e374c6f1 ctx 000000004967d650  ctx->space_used=33554656      , push_seq=29, ctx->sequence=29
2020-12-29T20:08:33.392095+01:00 deadbird kernel: [ 1071.600503] XXX pushw   cil 00000000e374c6f1 ctx 000000004967d650  ctx->space_used=67109068 >= 67108864, push_seq=29, ctx->sequence=29
2020-12-29T20:08:33.392120+01:00 deadbird kernel: [ 1071.616245] XXX pushw   cil 00000000e374c6f1 ctx 000000004967d650  ctx->space_used=67109108 >= 67108864, push_seq=29, ctx->sequence=29
2020-12-29T20:08:33.408102+01:00 deadbird kernel: [ 1071.632024] XXX pushw   cil 00000000e374c6f1 ctx 000000004967d650  ctx->space_used=67109108 >= 67108864, push_seq=29, ctx->sequence=29
2020-12-29T20:08:33.425086+01:00 deadbird kernel: [ 1071.648913] XXX pushw   cil 00000000e374c6f1 ctx 000000004967d650  ctx->space_used=67109108 >= 67108864, push_seq=29, ctx->sequence=29
2020-12-29T20:08:33.442109+01:00 deadbird kernel: [ 1071.666410] XXX pushw   cil 00000000e374c6f1 ctx 000000004967d650  ctx->space_used=67109108 >= 67108864, push_seq=29, ctx->sequence=29
2020-12-29T20:08:33.482769+01:00 deadbird kernel: [ 1071.706666] XXX pushw   cil 00000000e374c6f1 ctx 000000004967d650  ctx->space_used=67109136 >= 67108864, push_seq=29, ctx->sequence=29
2020-12-29T20:08:33.501063+01:00 deadbird kernel: [ 1071.725484] XXX pushw   cil 00000000e374c6f1 ctx 000000004967d650  ctx->space_used=67109136 >= 67108864, push_seq=29, ctx->sequence=29
2020-12-29T20:08:33.535711+01:00 deadbird kernel: [ 1071.742926] XXX pushw   cil 00000000e374c6f1 ctx 000000004967d650  ctx->space_used=67109136 >= 67108864, push_seq=29, ctx->sequence=29
2020-12-29T20:08:33.535728+01:00 deadbird kernel: [ 1071.760346] XXX pushw   cil 00000000e374c6f1 ctx 000000004967d650  ctx->space_used=67109136 >= 67108864, push_seq=29, ctx->sequence=29
2020-12-29T20:08:33.552079+01:00 deadbird kernel: [ 1071.776167] XXX pushw   cil 00000000e374c6f1 ctx 000000004967d650  ctx->space_used=67109136 >= 67108864, push_seq=29, ctx->sequence=29
2020-12-29T20:08:33.569070+01:00 deadbird kernel: [ 1071.793576] XXX pushw   cil 00000000e374c6f1 ctx 000000004967d650  ctx->space_used=67109136 >= 67108864, push_seq=29, ctx->sequence=29
[ 953 more of these ...]
2020-12-29T20:08:50.368192+01:00 deadbird kernel: [ 1088.576346] XXX pushw   cil 00000000e374c6f1 ctx 000000004967d650  ctx->space_used=67109136 >= 67108864, push_seq=29, ctx->sequence=29
2020-12-29T20:08:50.385023+01:00 deadbird kernel: [ 1088.593009] XXX pushw   cil 00000000e374c6f1 ctx 000000004967d650  ctx->space_used=67109136 >= 67108864, push_seq=29, ctx->sequence=29
2020-12-29T20:08:50.418318+01:00 deadbird kernel: [ 1088.609811] XXX pushw   cil 00000000e374c6f1 ctx 000000004967d650  ctx->space_used=67109136 >= 67108864, push_seq=29, ctx->sequence=29
2020-12-29T20:08:50.418330+01:00 deadbird kernel: [ 1088.626431] XXX pushw   cil 00000000e374c6f1 ctx 000000004967d650  ctx->space_used=67109136 >= 67108864, push_seq=29, ctx->sequence=29
2020-12-29T20:09:04.961088+01:00 deadbird kernel: [ 1103.168964] XXX wake    cil 00000000e374c6f1 ctx 000000004967d650  ctx->space_used=67109136 >= 67108864, push_seq=29, ctx->sequence=29

# seq 30

2020-12-29T20:09:39.305108+01:00 deadbird kernel: [ 1137.514718] XXX trigger cil 00000000e374c6f1 ctx 00000000c46ab121  ctx->space_used=33554480      , push_seq=30, ctx->sequence=30
2020-12-29T20:10:20.389104+01:00 deadbird kernel: [ 1178.597976] XXX pushw   cil 00000000e374c6f1 ctx 00000000c46ab121  ctx->space_used=67108924 >= 67108864, push_seq=30, ctx->sequence=30
2020-12-29T20:10:20.389117+01:00 deadbird kernel: [ 1178.613792] XXX pushw   cil 00000000e374c6f1 ctx 00000000c46ab121  ctx->space_used=67108924 >= 67108864, push_seq=30, ctx->sequence=30
2020-12-29T20:10:20.619077+01:00 deadbird kernel: [ 1178.827935] XXX pushw   cil 00000000e374c6f1 ctx 00000000c46ab121  ctx->space_used=67108924 >= 67108864, push_seq=30, ctx->sequence=30
2020-12-29T20:10:21.129074+01:00 deadbird kernel: [ 1179.337996] XXX pushw   cil 00000000e374c6f1 ctx 00000000c46ab121  ctx->space_used=67108924 >= 67108864, push_seq=30, ctx->sequence=30
2020-12-29T20:10:21.190101+01:00 deadbird kernel: [ 1179.398869] XXX pushw   cil 00000000e374c6f1 ctx 00000000c46ab121  ctx->space_used=67108924 >= 67108864, push_seq=30, ctx->sequence=30
2020-12-29T20:10:21.866096+01:00 deadbird kernel: [ 1180.074325] XXX pushw   cil 00000000e374c6f1 ctx 00000000c46ab121  ctx->space_used=67108924 >= 67108864, push_seq=30, ctx->sequence=30
2020-12-29T20:10:22.076095+01:00 deadbird kernel: [ 1180.283748] XXX pushw   cil 00000000e374c6f1 ctx 00000000c46ab121  ctx->space_used=67108924 >= 67108864, push_seq=30, ctx->sequence=30
2020-12-29T20:10:22.193070+01:00 deadbird kernel: [ 1180.401590] XXX pushw   cil 00000000e374c6f1 ctx 00000000c46ab121  ctx->space_used=67108924 >= 67108864, push_seq=30, ctx->sequence=30
2020-12-29T20:10:22.421082+01:00 deadbird kernel: [ 1180.629682] XXX pushw   cil 00000000e374c6f1 ctx 00000000c46ab121  ctx->space_used=67108908 >= 67108864, push_seq=30, ctx->sequence=30
2020-12-29T20:10:22.507085+01:00 deadbird kernel: [ 1180.715657] XXX pushw   cil 00000000e374c6f1 ctx 00000000c46ab121  ctx->space_used=67108892 >= 67108864, push_seq=30, ctx->sequence=30
2020-12-29T20:10:22.507094+01:00 deadbird kernel: [ 1180.731757] XXX pushw   cil 00000000e374c6f1 ctx 00000000c46ab121  ctx->space_used=67108876 >= 67108864, push_seq=30, ctx->sequence=30
2020-12-29T20:10:22.659070+01:00 deadbird kernel: [ 1180.867812] XXX pushw   cil 00000000e374c6f1 ctx 00000000c46ab121  ctx->space_used=67108872 >= 67108864, push_seq=30, ctx->sequence=30
2020-12-29T20:10:22.771081+01:00 deadbird kernel: [ 1180.980187] XXX pushw   cil 00000000e374c6f1 ctx 00000000c46ab121  ctx->space_used=67108872 >= 67108864, push_seq=30, ctx->sequence=30
2020-12-29T20:10:22.791116+01:00 deadbird kernel: [ 1180.996535] XXX pushw   cil 00000000e374c6f1 ctx 00000000c46ab121  ctx->space_used=67108872 >= 67108864, push_seq=30, ctx->sequence=30
2020-12-29T20:10:32.512085+01:00 deadbird kernel: [ 1190.725044] XXX no wake cil 00000000e374c6f1 ctx 00000000c46ab121 ctx->space_used=67108856 < 67108864, push_seq=30, ctx->sequence=30
2020-12-29T20:10:32.528119+01:00 deadbird kernel: [ 1190.753321] XXX xc_push_wait ACTIVE!

After this "xc_push_wait ACTIVE!" the I/O to the filesystem ceased.

space_used was reduced from 67108924 .. 67108908 .. 67108892 .. 67108876 .. 67108872 as seen by waiters to 67108856 as seen by the push worker. Presumably by other calls to xfs_log_commit_cil which did not produce log, because they neither triggered the worker nor waitetd for the push.
