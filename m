Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 658AFC433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Dec 2020 22:00:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2861A208B8
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Dec 2020 22:00:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726423AbgLaWAG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 31 Dec 2020 17:00:06 -0500
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:34454 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726210AbgLaWAG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Dec 2020 17:00:06 -0500
Received: from dread.disaster.area (pa49-179-167-107.pa.nsw.optusnet.com.au [49.179.167.107])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 59428107992;
        Fri,  1 Jan 2021 08:59:20 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kv5yZ-001jAf-HV; Fri, 01 Jan 2021 08:59:19 +1100
Date:   Fri, 1 Jan 2021 08:59:19 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Donald Buczek <buczek@molgen.mpg.de>
Cc:     linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        it+linux-xfs@molgen.mpg.de
Subject: Re: [PATCH] xfs: Wake CIL push waiters more reliably
Message-ID: <20201231215919.GA331610@dread.disaster.area>
References: <1705b481-16db-391e-48a8-a932d1f137e7@molgen.mpg.de>
 <20201229235627.33289-1-buczek@molgen.mpg.de>
 <20201230221611.GC164134@dread.disaster.area>
 <7bd30426-11dc-e482-dcc8-55d279bc75bd@molgen.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7bd30426-11dc-e482-dcc8-55d279bc75bd@molgen.mpg.de>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Ubgvt5aN c=1 sm=1 tr=0 cx=a_idp_d
        a=+wqVUQIkAh0lLYI+QRsciw==:117 a=+wqVUQIkAh0lLYI+QRsciw==:17
        a=kj9zAlcOel0A:10 a=EmqxpYm9HcoA:10 a=7-415B0cAAAA:8
        a=kkUkhGpHuB7nuc3Oak8A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Dec 31, 2020 at 12:48:56PM +0100, Donald Buczek wrote:
> On 30.12.20 23:16, Dave Chinner wrote:
> > On Wed, Dec 30, 2020 at 12:56:27AM +0100, Donald Buczek wrote:
> > > Threads, which committed items to the CIL, wait in the
> > > xc_push_wait waitqueue when used_space in the push context
> > > goes over a limit. These threads need to be woken when the CIL
> > > is pushed.
> > > 
> > > The CIL push worker tries to avoid the overhead of calling
> > > wake_all() when there are no waiters waiting. It does so by
> > > checking the same condition which caused the waits to happen.
> > > This, however, is unreliable, because ctx->space_used can
> > > actually decrease when items are recommitted.
> > 
> > When does this happen?
> > 
> > Do you have tracing showing the operation where the relogged
> > item has actually gotten smaller? By definition, relogging in
> > the CIL should only grow the size of the object in the CIL
> > because it must relog all the existing changes on top of the new
> > changed being made to the object. Hence the CIL reservation
> > should only ever grow.
> 
> I have (very ugly printk based) log (see below), but it only
> shows, that it happened (space_used decreasing), not what caused
> it.
> 
> I only browsed the ( xfs_*_item.c ) code and got the impression
> that the size of a log item is rather dynamic (e.g. number of
> extends in an inode, extended attributes in an inode, continuity
> of chunks in a buffer) and wasn't surprised that a relogged item
> might need less space from time to time.
> 
> > IOWs, returning negative lengths from the formatting code is
> > unexpected and probably a bug and requires further
> > investigation, not papering over the occurrence with broadcast
> > wakeups...
> 
> One could argue that the code is more robust after the change,
> because it wakes up every thread which is waiting on the next push
> to happen when the next push is happening without making
> assumption of why these threads are waiting by duplicating code
> from that waiters side. The proposed waitqueue_active() is inlined
> to two instructions and avoids the call overhead if there are no
> waiters as well.

One could argue that, but one should also understand the design
constraints for a particular algorithm are before suggesting that
their solution is "robust". :)

> 
> # seq 29
> 
> 2020-12-29T20:08:15.652167+01:00 deadbird kernel: [ 1053.860637] XXX trigger cil 00000000e374c6f1 ctx 000000004967d650  ctx->space_used=33554656      , push_seq=29, ctx->sequence=29

So, at 20:08:15 we get a push trigger and the work is queued. But...

.....
> 2020-12-29T20:09:04.961088+01:00 deadbird kernel: [ 1103.168964] XXX wake    cil 00000000e374c6f1 ctx 000000004967d650  ctx->space_used=67109136 >= 67108864, push_seq=29, ctx->sequence=29

It takes the best part of *50 seconds* before the push work actually
runs?

That's .... well and truly screwed up - the work should run on that
CPU on the very next time it yeilds the CPU. If we're holding the
CPU without yeilding it for that long, hangcheck and RCU warnings
should be going off...

> # seq 30
> 
> 2020-12-29T20:09:39.305108+01:00 deadbird kernel: [ 1137.514718] XXX trigger cil 00000000e374c6f1 ctx 00000000c46ab121  ctx->space_used=33554480      , push_seq=30, ctx->sequence=30

20:09:39 for the next trigger,

> 2020-12-29T20:10:20.389104+01:00 deadbird kernel: [ 1178.597976] XXX pushw   cil 00000000e374c6f1 ctx 00000000c46ab121  ctx->space_used=67108924 >= 67108864, push_seq=30, ctx->sequence=30
> 2020-12-29T20:10:20.389117+01:00 deadbird kernel: [ 1178.613792] XXX pushw   cil 00000000e374c6f1 ctx 00000000c46ab121  ctx->space_used=67108924 >= 67108864, push_seq=30, ctx->sequence=30
> 2020-12-29T20:10:20.619077+01:00 deadbird kernel: [ 1178.827935] XXX pushw   cil 00000000e374c6f1 ctx 00000000c46ab121  ctx->space_used=67108924 >= 67108864, push_seq=30, ctx->sequence=30
> 2020-12-29T20:10:21.129074+01:00 deadbird kernel: [ 1179.337996] XXX pushw   cil 00000000e374c6f1 ctx 00000000c46ab121  ctx->space_used=67108924 >= 67108864, push_seq=30, ctx->sequence=30
> 2020-12-29T20:10:21.190101+01:00 deadbird kernel: [ 1179.398869] XXX pushw   cil 00000000e374c6f1 ctx 00000000c46ab121  ctx->space_used=67108924 >= 67108864, push_seq=30, ctx->sequence=30
> 2020-12-29T20:10:21.866096+01:00 deadbird kernel: [ 1180.074325] XXX pushw   cil 00000000e374c6f1 ctx 00000000c46ab121  ctx->space_used=67108924 >= 67108864, push_seq=30, ctx->sequence=30
> 2020-12-29T20:10:22.076095+01:00 deadbird kernel: [ 1180.283748] XXX pushw   cil 00000000e374c6f1 ctx 00000000c46ab121  ctx->space_used=67108924 >= 67108864, push_seq=30, ctx->sequence=30
> 2020-12-29T20:10:22.193070+01:00 deadbird kernel: [ 1180.401590] XXX pushw   cil 00000000e374c6f1 ctx 00000000c46ab121  ctx->space_used=67108924 >= 67108864, push_seq=30, ctx->sequence=30
> 2020-12-29T20:10:22.421082+01:00 deadbird kernel: [ 1180.629682] XXX pushw   cil 00000000e374c6f1 ctx 00000000c46ab121  ctx->space_used=67108908 >= 67108864, push_seq=30, ctx->sequence=30

So it dropped by 16 bytes (seems to be common) which is unexpected.
I wonder if it filled a hole in a buffer and so needed one less
xlog_op_header()? But then the size would have gone up by at least
128 bytes for the hole that was filled, so it still shouldn't go
down in size.

I think you need to instrument xlog_cil_insert_items() and catch
a negative length here:

	/* account for space used by new iovec headers  */
	iovhdr_res = diff_iovecs * sizeof(xlog_op_header_t);
	len += iovhdr_res;
	ctx->nvecs += diff_iovecs;

(diff_iovecs will be negative if the number of xlog_op_header
structures goes down)

And if this happens, then dump the transaction ticket via
xlog_print_trans(tp) so we can see all the log items types and
vectors that the transaction has formatted...

> 2020-12-29T20:10:22.507085+01:00 deadbird kernel: [ 1180.715657] XXX pushw   cil 00000000e374c6f1 ctx 00000000c46ab121  ctx->space_used=67108892 >= 67108864, push_seq=30, ctx->sequence=30
> 2020-12-29T20:10:22.507094+01:00 deadbird kernel: [ 1180.731757] XXX pushw   cil 00000000e374c6f1 ctx 00000000c46ab121  ctx->space_used=67108876 >= 67108864, push_seq=30, ctx->sequence=30
> 2020-12-29T20:10:22.659070+01:00 deadbird kernel: [ 1180.867812] XXX pushw   cil 00000000e374c6f1 ctx 00000000c46ab121  ctx->space_used=67108872 >= 67108864, push_seq=30, ctx->sequence=30
> 2020-12-29T20:10:22.771081+01:00 deadbird kernel: [ 1180.980187] XXX pushw   cil 00000000e374c6f1 ctx 00000000c46ab121  ctx->space_used=67108872 >= 67108864, push_seq=30, ctx->sequence=30
> 2020-12-29T20:10:22.791116+01:00 deadbird kernel: [ 1180.996535] XXX pushw   cil 00000000e374c6f1 ctx 00000000c46ab121  ctx->space_used=67108872 >= 67108864, push_seq=30, ctx->sequence=30
> 2020-12-29T20:10:32.512085+01:00 deadbird kernel: [ 1190.725044] XXX no wake cil 00000000e374c6f1 ctx 00000000c46ab121 ctx->space_used=67108856 < 67108864, push_seq=30, ctx->sequence=30
> 2020-12-29T20:10:32.528119+01:00 deadbird kernel: [ 1190.753321] XXX xc_push_wait ACTIVE!

Also, another 50s hold-off from push work being queued to the work
actually running. That also needs to be understood, because that's
clearly contributing to hitting the hard limit regularly and that
should mostly never happen....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
