Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69F2AC433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 00:35:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 292FE64E45
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 00:35:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbhBRAfg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 17 Feb 2021 19:35:36 -0500
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:33542 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229889AbhBRAfg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Feb 2021 19:35:36 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 7F743FEF6DE;
        Thu, 18 Feb 2021 11:34:53 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lCXHP-009hEh-7x; Thu, 18 Feb 2021 11:34:51 +1100
Date:   Thu, 18 Feb 2021 11:34:51 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: set aside allocation btree blocks from block
 reservation
Message-ID: <20210218003451.GC4662@dread.disaster.area>
References: <20210217132339.651020-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210217132339.651020-1-bfoster@redhat.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=kj9zAlcOel0A:10 a=qa6Q16uM49sA:10 a=7-415B0cAAAA:8
        a=e7UYYdGWpKD-mvA_MSEA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 17, 2021 at 08:23:39AM -0500, Brian Foster wrote:
> The blocks used for allocation btrees (bnobt and countbt) are
> technically considered free space. This is because as free space is
> used, allocbt blocks are removed and naturally become available for
> traditional allocation. However, this means that a significant
> portion of free space may consist of in-use btree blocks if free
> space is severely fragmented.
> 
> On large filesystems with large perag reservations, this can lead to
> a rare but nasty condition where a significant amount of physical
> free space is available, but the majority of actual usable blocks
> consist of in-use allocbt blocks. We have a record of a (~12TB, 32
> AG) filesystem with multiple AGs in a state with ~2.5GB or so free
> blocks tracked across ~300 total allocbt blocks, but effectively at
> 100% full because the the free space is entirely consumed by
> refcountbt perag reservation.
> 
> Such a large perag reservation is by design on large filesystems.
> The problem is that because the free space is so fragmented, this AG
> contributes the 300 or so allocbt blocks to the global counters as
> free space. If this pattern repeats across enough AGs, the
> filesystem lands in a state where global block reservation can
> outrun physical block availability. For example, a streaming
> buffered write on the affected filesystem continues to allow delayed
> allocation beyond the point where writeback starts to fail due to
> physical block allocation failures. The expected behavior is for the
> delalloc block reservation to fail gracefully with -ENOSPC before
> physical block allocation failure is a possibility.

*nod*

> To address this problem, introduce a percpu counter to track the sum
> of the allocbt block counters already tracked in the AGF. Use the
> new counter to set these blocks aside at reservation time and thus
> ensure they cannot be allocated until truly available. Since this is
> only necessary when large reflink perag reservations are in place
> and the counter requires a read of each AGF to fully populate, only
> enforce on reflink enabled filesystems. This allows initialization
> of the counter at ->pagf_init time because the refcountbt perag
> reservation init code reads each AGF at mount time.

Ok, so the mechanism sounds ok, but a per-cpu counter seems like
premature optimisation. How often are we really updating btree block
counts? An atomic counter is good for at least a million updates a
second across a 2 socket 32p machine, and I highly doubt we're
incrementing/decrementing btree block counts that often on such a
machine. 

While per-cpu counters have a fast write side, they come with
additional algorithmic complexity. Hence if the update rate of the
counter is not fast enough to need per-cpu counters, we should avoid
them. just because other free space counters use per-cpu counters,
it doesn't mean everything in that path needs to use them...

> Note that the counter uses a small percpu batch size to allow the
> allocation paths to keep the primary count accurate enough that the
> reservation path doesn't ever need to lock and sum the counter.
> Absolute accuracy is not required here, just that the counter
> reflects the majority of unavailable blocks so the reservation path
> fails first.

And this makes the per-cpu counter scale almost no better than an
simple atomic counter, because a spinlock requires two atomic
operations (lock and unlock). Hence a batch count of 4 only reduces
the atomic op count by half but introduces at lot of extra
complexity. It won't make a difference to the scalability of
workloads that hammer the btree block count because contention on
the internal counter spinlock will occur at close to the same
concurrency rate as would occur on an atomic counter.

Hence a per-cpu counter used in this manner seems like a premature
optimisation to me...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
