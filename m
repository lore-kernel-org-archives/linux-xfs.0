Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CAA1C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Dec 2020 22:17:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1EBD9207A1
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Dec 2020 22:17:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbgL3WQz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Dec 2020 17:16:55 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:35327 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726197AbgL3WQz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Dec 2020 17:16:55 -0500
Received: from dread.disaster.area (pa49-179-167-107.pa.nsw.optusnet.com.au [49.179.167.107])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id D2E913C3A3D;
        Thu, 31 Dec 2020 09:16:11 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kujlL-001OGL-2h; Thu, 31 Dec 2020 09:16:11 +1100
Date:   Thu, 31 Dec 2020 09:16:11 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Donald Buczek <buczek@molgen.mpg.de>
Cc:     linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        it+linux-xfs@molgen.mpg.de
Subject: Re: [PATCH] xfs: Wake CIL push waiters more reliably
Message-ID: <20201230221611.GC164134@dread.disaster.area>
References: <1705b481-16db-391e-48a8-a932d1f137e7@molgen.mpg.de>
 <20201229235627.33289-1-buczek@molgen.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201229235627.33289-1-buczek@molgen.mpg.de>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Ubgvt5aN c=1 sm=1 tr=0 cx=a_idp_d
        a=+wqVUQIkAh0lLYI+QRsciw==:117 a=+wqVUQIkAh0lLYI+QRsciw==:17
        a=kj9zAlcOel0A:10 a=zTNgK-yGK50A:10 a=7-415B0cAAAA:8
        a=vjpBid7DwhPUkeZ-FCcA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 30, 2020 at 12:56:27AM +0100, Donald Buczek wrote:
> Threads, which committed items to the CIL, wait in the xc_push_wait
> waitqueue when used_space in the push context goes over a limit. These
> threads need to be woken when the CIL is pushed.
> 
> The CIL push worker tries to avoid the overhead of calling wake_all()
> when there are no waiters waiting. It does so by checking the same
> condition which caused the waits to happen. This, however, is
> unreliable, because ctx->space_used can actually decrease when items are
> recommitted.

When does this happen?

Do you have tracing showing the operation where the relogged item
has actually gotten smaller? By definition, relogging in the CIL
should only grow the size of the object in the CIL because it must
relog all the existing changes on top of the new changed being made
to the object. Hence the CIL reservation should only ever grow.

IOWs, returning negative lengths from the formatting code is
unexpected and probably a bug and requires further investigation,
not papering over the occurrence with broadcast wakeups...

> If the value goes below the limit while some threads are
> already waiting but before the push worker gets to it, these threads are
> not woken.
> 
> Always wake all CIL push waiters. Test with waitqueue_active() as an
> optimization. This is possible, because we hold the xc_push_lock
> spinlock, which prevents additions to the waitqueue.
> 
> Signed-off-by: Donald Buczek <buczek@molgen.mpg.de>
> ---
>  fs/xfs/xfs_log_cil.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index b0ef071b3cb5..d620de8e217c 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -670,7 +670,7 @@ xlog_cil_push_work(
>  	/*
>  	 * Wake up any background push waiters now this context is being pushed.
>  	 */
> -	if (ctx->space_used >= XLOG_CIL_BLOCKING_SPACE_LIMIT(log))
> +	if (waitqueue_active(&cil->xc_push_wait))
>  		wake_up_all(&cil->xc_push_wait);

That just smells wrong to me. It *might* be correct, but this
condition should pair with the sleep condition, as space used by a
CIL context should never actually decrease....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
