Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CD45C433B4
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Apr 2021 01:12:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F1296143B
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Apr 2021 01:12:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbhD2BNT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Apr 2021 21:13:19 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:60171 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229479AbhD2BNT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Apr 2021 21:13:19 -0400
Received: from dread.disaster.area (pa49-179-143-157.pa.nsw.optusnet.com.au [49.179.143.157])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 6BF9B108F1C;
        Thu, 29 Apr 2021 11:12:32 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lbvEF-00CTt1-FB; Thu, 29 Apr 2021 11:12:31 +1000
Date:   Thu, 29 Apr 2021 11:12:31 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: Prevent deadlock when allocating blocks for AGFL
Message-ID: <20210429011231.GF63242@dread.disaster.area>
References: <20210428065152.77280-1-chandanrlinux@gmail.com>
 <20210428065152.77280-2-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210428065152.77280-2-chandanrlinux@gmail.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0 cx=a_idp_f
        a=I9rzhn+0hBG9LkCzAun3+g==:117 a=I9rzhn+0hBG9LkCzAun3+g==:17
        a=kj9zAlcOel0A:10 a=3YhXtTcJ-WEA:10 a=7-415B0cAAAA:8
        a=2jf4_g5q8-ABnYk9AVwA:9 a=7Zwj6sZBwVKJAoWSPKxL6X1jA+E=:19
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 28, 2021 at 12:21:52PM +0530, Chandan Babu R wrote:
> Executing xfs/538 after disabling injection of bmap_alloc_minlen_extent error
> can cause several tasks to trigger hung task timeout. Most of the tasks are
> blocked on getting a lock on an AG's AGF buffer. However, The task which has
> the lock on the AG's AGF buffer has the following call trace,
> 
> PID: 1341   TASK: ffff8881073f3700  CPU: 1   COMMAND: "fsstress"
>    __schedule+0x22f at ffffffff81f75e8f
>    schedule+0x46 at ffffffff81f76366
>    xfs_extent_busy_flush+0x69 at ffffffff81477d99
>    xfs_alloc_ag_vextent_size+0x16a at ffffffff8141711a
>    xfs_alloc_ag_vextent+0x19b at ffffffff81417edb
>    xfs_alloc_fix_freelist+0x22f at ffffffff8141896f
>    xfs_free_extent_fix_freelist+0x6a at ffffffff8141939a
>    __xfs_free_extent+0x99 at ffffffff81419499
>    xfs_trans_free_extent+0x3e at ffffffff814a6fee
>    xfs_extent_free_finish_item+0x24 at ffffffff814a70d4
>    xfs_defer_finish_noroll+0x1f7 at ffffffff81441407
>    xfs_defer_finish+0x11 at ffffffff814417e1
>    xfs_itruncate_extents_flags+0x13d at ffffffff8148b7dd
>    xfs_inactive_truncate+0xb9 at ffffffff8148bb89
>    xfs_inactive+0x227 at ffffffff8148c4f7
>    xfs_fs_destroy_inode+0xb8 at ffffffff81496898
>    destroy_inode+0x3b at ffffffff8127d2ab
>    do_unlinkat+0x1d1 at ffffffff81270df1
>    do_syscall_64+0x40 at ffffffff81f6b5f0
>    entry_SYSCALL_64_after_hwframe+0x44 at ffffffff8200007c
> 
> The following sequence of events lead to the above listed call trace,
> 
> 1. The task frees atleast two extents belonging to the file being truncated.
> 2. The corresponding xfs_extent_free_items are stored in the list pointed to
>    by xfs_defer_pending->dfp_work.
> 3. When executing the next step of the rolling transaction, The first of the
>    above mentioned extents is freed. The corresponding busy extent entry is
>    added to the current transaction's tp->t_busy list as well as to the perag
>    rb tree at xfs_perag->pagb_tree.
> 4. When trying to free the second extent, XFS determines that the AGFL needs
>    to be populated and hence tries to allocate free blocks.
> 5. The only free extent whose size is >= xfs_alloc_arg->maxlen
>    happens to be the first extent that was freed by the current transaction.
> 6. Hence xfs_alloc_ag_vextent_size() flushes the CIL in the hope of clearing
>    the busy status of the extent and waits for the busy generation number to
>    change.
> 7. However, flushing the CIL is futile since the busy extent is still in the
>    current transaction's tp->t_busy list.
> 
> Here the task ends up waiting indefinitely.
> 
> This commit fixes the bug by preventing a CIL flush if all free extents are
> busy and all of them are in the transaction's tp->t_busy list.

Hmmm. I don't doubt that this fixes the symptom you are seeing, but
the way it is being fixed doesn't seem right to me at all.

We're rtying to populate the AGFL here, and the fact is that a
multi-block allocation is simply an optimisation to minimise the
number of extents we need to allocate to fill the AGFL. The extent
that gets allocated gets broken up into single blocks to be inserted
into the AGFL, so we don't actually need a continuguous extent to be
allocated here.

Hence, if the extent we find is busy when allocating for the AGFL,
we should just skip it and choose another extent. args->minlen is
set to zero for the allocation, so we can actually return any extent
that has a length <= args->maxlen. We know this is an AGFL
allocation because args->resv == XFS_AG_RESV_AGFL, so if we find a
busy extent that would require a log force to be able to use before
we can place it in the AGFL, we should just skip it entirely and
select another extent to allocate from.

Adding another two boolean conditionals to the already complex
extent selection for this specific case makes the code much harder
to follow and reason about. I'd much prefer that we just do
something like:

	if (busy && args->resv == XFS_AG_RESV_AGFL) {
		/*
		 * Extent might have just been freed in this
		 * transaction so we can't use it. Move to the next
		 * best extent candidate and try that instead.
		 */
		<increment/decrement and continue the search loop>
	}

IOWs, we should not be issuing a log force to flush busy extents if
we can't use the largest candidate free extent for the AGFL - we
should just keep searching until we find one we can use....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
