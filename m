Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9088C47096
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 17:05:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC419613F4
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 17:05:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbhFCRG7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Jun 2021 13:06:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:39652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229849AbhFCRG7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 3 Jun 2021 13:06:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3CBAD613BA;
        Thu,  3 Jun 2021 17:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622739914;
        bh=LEwiG1zRY7lqdjkNZytw93zU6BXTzKdo/JcWVcyHg6M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bg10Ww0uUwcvr03IyJjg0JIvCIzw2xQ5gZhweg28srQby0p5aglpFASQT0SBLbeg7
         NkuAYBlyedh+KbdS1yPyUYVF7Shl/0uqhtaLDCk/TJEo7fpWjuSAVCDiwb/R1fvzCX
         3aMP56T3ZGtSsvVDhl3fMnNr/OZEhIi5OhdTsb28RzyeTI1XIP0Xl4vUrkRkfQ6GD+
         G4mVe505Pgc8WxZnqR2TmvcHm8a3Ixu5yWwKN8+McNdnZ1dqgvh0gIxDQXnnCy3cHy
         P2aE4WVnzIzvvt84dj9p9UPI04avE2P64RnUWC2tGhufmN4YwRgj45JFoHVFswP1Vy
         +mhRuIN/rnsaQ==
Date:   Thu, 3 Jun 2021 10:05:13 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 00/39 v5] xfs: CIL and log optimisations
Message-ID: <20210603170513.GH26402@locust>
References: <20210603052240.171998-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210603052240.171998-1-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 03, 2021 at 03:22:01PM +1000, Dave Chinner wrote:
> Hi folks,
> 
> This is an update of the consolidated log scalability patchset I've been working
> on. Version 4 was posted here:
> 
> https://lore.kernel.org/linux-xfs/20210519121317.585244-1-david@fromorbit.com/
> 
> This version contains the changes Darrick requested during review. The only
> patch remaining without at least one RVB tag is patch 30.
> 
> Performance improvements are largely documented in the change logs of the
> individual patches. Headline numbers are an increase in transaction rate from
> 700k commits/s to 1.7M commits/s, and a reduction in fua/flush operations by
> 2-3 orders of magnitude on metadata heavy workloads that don't use fsync.
> 
> Summary of series:
> 
> Patches		Modifications
> -------		-------------
> 1-7:		log write FUA/FLUSH optimisations
> 8:		bug fix
> 9-11:		Async CIL pushes
> 12-25:		xlog_write() rework
> 26-39:		CIL commit scalability

From this latest posting, I see that the first nine patches all have
multiple reviews.  Some of patches 10-19 have review tags split between
Brian and Christoph, but neither have added them all the way through.
I think I'm the only one who has supplied RVB tags for all forty.

So my question is: at what point would you like me to pull the segments
of this patchset into upstream?  "The maintainer reviewed everything" is
of course our usual standard, but this touches a /lot/ of core logging
code, and logging isn't one of my stronger areas of familiarity.

I think 1-8 look fine for 5.14.  Do you want me to wait for Brian and/or
Christoph (or really, any third pair of eyes) to finish working their
way through 9-11 and 12-25 before merging them?

--D

> 
> Change log is below.
> 
> Cheers,
> 
> Dave.
> 
> Version 5:
> - fix typo in comment (patch 4)
> - fix typo in commit msg (patch 7)
> - removed unnecessary update of num_iovecs (patch 20)
> - fixed whitespace (patch 29)
> - removed unused space_used/curr_res from CIL pcp structure (patch 29)
> - added space_used to CIL pcp structure (patch 30)
> - add comment to xlog_cil_pcp_aggregate() (patch 30)
> - added space_reserved to CIL pcp structure (patch 31)
> - removed unnecessary commentary about CIL ordering issues from commit msg in
>   patch 33 as patch 35 addresses these issues..
> - fix whitespace in xlog_cil_free_logvec() (patch 35)
> - fix weird sentence in docco (patch 39)
> - propagate changes through patches to fix conflicts due to dependent changes.
>   (various patches)
> 
> 
> Version 4:
> - rebase on 5.13-rc2+
> - fixed completion logic for async cache flush
> - trimmed superflous comments about not requiring REQ_PREFLUSH for iclog IO
>   anymore.
> - ensure that setting/clearing XLOG_ICL_NEED_FLUSH is atomic (i.e. only modified
>   while holding the icloglock)
> - ensure callers only add iclog flush/fua flags appropriately before releasing
>   the iclog so that multiple independent writes to an iclog doesn't clear flags
>   other writes into the iclog depend on.
> - buffer log item dirty tracking patches merged so removed from series
> - replaced XFS_LSN_CMP() checks with direct lsn1 == lsn2 comparisons to simplify
>   the code
> - changed "push_async" to "push_commit_stable" to indicate that the push caller
>   wants the entire CIL checkpoint and commit record to be on stable storage when
>   it completes.
> - updated comment to indicate that iclog sync state is set according to the
>   caller's desire for a stable checkpoint to be performed.
> - Added comment explaining why the CIL workqueue is limited to 4 concurrent
>   works per filesystem.
> - debug overhead reduction patches merged so removed from series
> - cleaned up a couple of typedef uses.
> - updated pahole output for checkpoint header in commit message
> - Added BUILD_BUG_ON() to check the size of unmount records.
> - got rid of XFS_VOLUME define.
> - got rid of XLOG_TIC_LEN_MAX define.
> - cleaned up extra blank lines.
> - fixed double initialisation of lv in xlog_write_single().
> - removed the unnecessary change for reserved iclog space in
>   xlog_state_get_iclog_space().
> - no need to check for XLOG_CONTINUE_TRANS in xlog_write_partial() as it will
>   always be set.
> - added a patch for removing the optype parameter from xlog_write()
> - removed unused nvecs from struct xfs_cil_ctx
> - fixed whitespace damage in xlog_cil_pcp_dead()
> - added missing cpu dead accounting transfer in xlog_cil_pcp_dead().
> - factored out CIL push percpu structure aggregation into
>   xlog_cil_pcp_aggregate()
> - added the ctx->ticket->t_unit_res update back into the code even though it is
>   largely unnecessary.
> - cleaned up the pcp, cilpcp, pcptr mess in xlog_cil_pcp_alloc() and elsewhere
>   to use variable names consistently.
> - simplified the CIL sort comparison functions to a single comparison operation
> - fixed percpu CIL item list sort order where items in the same transaction
>   (order id) were reversed, leading to intents being replayed in the wrong
>   order.
> - split out log vector chain conversion to list_head into separate patch
> - Updated documentation with all the fixes and suggestions made.
> 
> 
> Version 3:
> - rebase onto 5.12-rc1+
> - aggregate many small dependent patchsets in one large one.
> - simplify xlog_wait_on_iclog_lsn() back to just a call to xlog_wait_on_iclog()
> - remove xfs_blkdev_issue_flush() instead of moving and renaming it.
> - pass bio to xfs_flush_bdev_async() so it doesn't need allocation.
> - skip cache flush in xfs_flush_bdev_async() if the underlying queue does not
>   require it.
> - fixed whitespace in xfs_flush_bdev_async()
> - remove the implicit external log's data device cache flush code and replace it
>   with an explicit flush in the unmount record write so that it works the same
>   as the new CIL checkpoint cache pre-flush mechanism. This mechanism now
>   guarantees metadata vs journal ordering for both internal and external logs.
> - updated various commit messages
> - fixed incorrect/unintended changes to xfs_log_force() behaviour
> - typedef uint64_t xfs_csn_t; and conversion.
> - removed stray trace_printk()s that were used for debugging.
> - fixed minor formatting details.
> - uninlined xlog_prepare_iovec()
> - fixed up "lv chain vector and size calculation" commit message to reflect we
>   are only calculating and passin gin the vector byte count.
> - reworked the loop in xlog_write_single() based on Christoph's suggestion. Much
>   cleaner!
> - added patch to pass log ticket down to xlog_sync() so that it accounts the
>   roundoff to the log ticket rather than directly modifying grant heads. Grant
>   heads are hot, so every little bit helps.
> - added patch to update delayed logging design doc with background material on
>   how transactions and log space accounting works in XFS.
> 
> Version 2:
> - fix ticket reservation roundoff to include 2 roundoffs
> - removed stale copied comment from roundoff initialisation.
> - clarified "separation" to mean "separation for ordering purposes" in commit
>   message.
> - added comment that newly activated, clean, empty iclogs have a LSN of 0 so are
>   captured by the "iclog lsn < start_lsn" case that avoids needing to wait
>   before releasing the commit iclog to be written.
> - added async cache flush infrastructure
> - convert CIL checkpoint push work it issue an unconditional metadata device
>   cache flush rather than asking the first iclog write to issue it via
>   REQ_PREFLUSH.
> - cleaned up xlog_write() to remove a redundant parameter and prepare the logic
>   for setting flags on the iclog based on the type of operational data is being
>   written to the log.
> - added XLOG_ICL_NEED_FUA flag to complement the NEED_FLUSH flag, allowing
>   callers to issue explicit flushes and clear the NEED_FLUSH flag before the
>   iclog is written without dropping the REQ_FUA requirement in /dev/null...
> - added CIL commit-in-start-iclog optimisation that clears the NEED_FLUSH flag
>   to avoid an unnecessary cache flush when issuing the iclog.
> - fixed typo in CIL throttle bugfix comment.
> - fixed trailing whitespace in commit message.
> 
> 
