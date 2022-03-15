Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6639C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Mar 2022 19:13:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351255AbiCOTOi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Mar 2022 15:14:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351290AbiCOTOg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Mar 2022 15:14:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC77960C6
        for <linux-xfs@vger.kernel.org>; Tue, 15 Mar 2022 12:13:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C48CDB816D6
        for <linux-xfs@vger.kernel.org>; Tue, 15 Mar 2022 19:13:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81CA2C340EE;
        Tue, 15 Mar 2022 19:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647371600;
        bh=LwBOHov0gJHXRmgiIe4+jN4P0ONQ+thqIPu8L1tK+pk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IFwx5UPVroHRJccb17KYOv+LxcNcWyM3xJkD85voht/8a77E9YetMxTRnmUPBsTnt
         SXio32hlVgnrwDewiGluRyYadZW1sD2i6t/ttzu1t1hc812HG5O9dODXVPVMoju99M
         qzp1fr3+I0wmOf82glauQrhVGu288mg4rQ5Y10YwteW8gdCXqvBfCuC4J6nT3z/2Y+
         8l4UFw/TPyXrNdw5xZdIx3UqYqZslwxlKvAQiw99OoXYY0yCDyH4U0Y3ejdvpRQKDA
         YrYUwYb2z29raI8SjYkqHa9+PnYSuhGQXxa9Mb8YKpndOY3fjfH0p/FXQJYZ9UyZoa
         JTe348NuulbFg==
Date:   Tue, 15 Mar 2022 12:13:20 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/7] xfs: check buffer pin state after locking in
 delwri_submit
Message-ID: <20220315191320.GG8241@magnolia>
References: <20220315064241.3133751-1-david@fromorbit.com>
 <20220315064241.3133751-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220315064241.3133751-3-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 15, 2022 at 05:42:36PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> AIL flushing can get stuck here:
> 
> [316649.005769] INFO: task xfsaild/pmem1:324525 blocked for more than 123 seconds.
> [316649.007807]       Not tainted 5.17.0-rc6-dgc+ #975
> [316649.009186] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [316649.011720] task:xfsaild/pmem1   state:D stack:14544 pid:324525 ppid:     2 flags:0x00004000
> [316649.014112] Call Trace:
> [316649.014841]  <TASK>
> [316649.015492]  __schedule+0x30d/0x9e0
> [316649.017745]  schedule+0x55/0xd0
> [316649.018681]  io_schedule+0x4b/0x80
> [316649.019683]  xfs_buf_wait_unpin+0x9e/0xf0
> [316649.021850]  __xfs_buf_submit+0x14a/0x230
> [316649.023033]  xfs_buf_delwri_submit_buffers+0x107/0x280
> [316649.024511]  xfs_buf_delwri_submit_nowait+0x10/0x20
> [316649.025931]  xfsaild+0x27e/0x9d0
> [316649.028283]  kthread+0xf6/0x120
> [316649.030602]  ret_from_fork+0x1f/0x30
> 
> in the situation where flushing gets preempted between the unpin
> check and the buffer trylock under nowait conditions:
> 
> 	blk_start_plug(&plug);
> 	list_for_each_entry_safe(bp, n, buffer_list, b_list) {
> 		if (!wait_list) {
> 			if (xfs_buf_ispinned(bp)) {
> 				pinned++;
> 				continue;
> 			}
> Here >>>>>>
> 			if (!xfs_buf_trylock(bp))
> 				continue;
> 
> This means submission is stuck until something else triggers a log
> force to unpin the buffer.
> 
> To get onto the delwri list to begin with, the buffer pin state has
> already been checked, and hence it's relatively rare we get a race
> between flushing and encountering a pinned buffer in delwri
> submission to begin with. Further, to increase the pin count the
> buffer has to be locked, so the only way we can hit this race
> without failing the trylock is to be preempted between the pincount
> check seeing zero and the trylock being run.
> 
> Hence to avoid this problem, just invert the order of trylock vs
> pin check. We shouldn't hit that many pinned buffers here, so
> optimising away the trylock for pinned buffers should not matter for
> performance at all.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_buf.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index b45e0d50a405..8867f143598e 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -2094,12 +2094,13 @@ xfs_buf_delwri_submit_buffers(
>  	blk_start_plug(&plug);
>  	list_for_each_entry_safe(bp, n, buffer_list, b_list) {
>  		if (!wait_list) {
> +			if (!xfs_buf_trylock(bp))
 +				continue;
>  			if (xfs_buf_ispinned(bp)) {
> +				xfs_buf_unlock(bp);
>  				pinned++;
>  				continue;

Hmm.  So I think this means that this function willl skip buffers that
are locked or pinned.  The only way that the AIL would encounter this
situation is when a buffer on its list is now locked by a reader thread
or is participating in a transaction.  In the reader case this is (one
hopes) ok because the reader won't block on the AIL.

The tx case is trickier -- transaction allocation can result in an AIL
push if the head is too close to the tail, right?  Ordinarily, the AIL
won't find itself unable to write a buffer that's pinning the log
because a transaction holds that buffer -- eventually that tx should
commit, which will unlock the buffer and allow the AIL to make some
progress.

But -- what if the frontend is running a chained transaction, and it
bjoin'd the buffer to the transaction, tried to roll the transaction,
and the chain runs out of permanent log reservation (because we've
rolled more than logcount times) and we have to wait for more log grant
space?  The regrant for the successor tx happens before the commit of
the old tx, so can we livelock the log in this way?

And doesn't this potential exist regardless of this patch?

I suspect the answers are 'yes' and 'yes', which means this patch is ok
to move forward, but this has been bugging me since the V1 of this
patch, which is where I got stuck. :/

--D

>  			}
> -			if (!xfs_buf_trylock(bp))
> -				continue;
>  		} else {
>  			xfs_buf_lock(bp);
>  		}
> -- 
> 2.35.1
> 
