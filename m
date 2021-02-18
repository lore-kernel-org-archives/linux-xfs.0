Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6320EC433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 16:42:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 198916146D
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 16:42:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233661AbhBRQls (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Feb 2021 11:41:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55189 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231318AbhBRNi7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Feb 2021 08:38:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613655421;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uQFnZjpH4Gf5hTsUPJw1aNpejMHwdsLxk438b1Hd8Jk=;
        b=RL6XciBP5UTWauqezc8CiaeKd24tuuReTMbiXrZ9cV/wJ3+Q7cA+lN0pEajHEl/OLqD9eq
        J8RHnZWj0mvpNML3/CshdIzJXmXNg3Aze3fU6SDmSvHt4r3cHy4KT8Ge6JoI9BPnjbUQc0
        7k/Be/5rBXXWOfrq/J2qOtXRW3Ez+6U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-380-uRBLm_t6PLeVxATV0QLBmQ-1; Thu, 18 Feb 2021 08:25:24 -0500
X-MC-Unique: uRBLm_t6PLeVxATV0QLBmQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 28CF510066F0;
        Thu, 18 Feb 2021 13:25:23 +0000 (UTC)
Received: from bfoster (ovpn-113-234.rdu2.redhat.com [10.10.113.234])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C11151001E73;
        Thu, 18 Feb 2021 13:25:22 +0000 (UTC)
Date:   Thu, 18 Feb 2021 08:25:20 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: set aside allocation btree blocks from block
 reservation
Message-ID: <20210218132520.GD685651@bfoster>
References: <20210217132339.651020-1-bfoster@redhat.com>
 <20210218003451.GC4662@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210218003451.GC4662@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 18, 2021 at 11:34:51AM +1100, Dave Chinner wrote:
> On Wed, Feb 17, 2021 at 08:23:39AM -0500, Brian Foster wrote:
> > The blocks used for allocation btrees (bnobt and countbt) are
> > technically considered free space. This is because as free space is
> > used, allocbt blocks are removed and naturally become available for
> > traditional allocation. However, this means that a significant
> > portion of free space may consist of in-use btree blocks if free
> > space is severely fragmented.
> > 
> > On large filesystems with large perag reservations, this can lead to
> > a rare but nasty condition where a significant amount of physical
> > free space is available, but the majority of actual usable blocks
> > consist of in-use allocbt blocks. We have a record of a (~12TB, 32
> > AG) filesystem with multiple AGs in a state with ~2.5GB or so free
> > blocks tracked across ~300 total allocbt blocks, but effectively at
> > 100% full because the the free space is entirely consumed by
> > refcountbt perag reservation.
> > 
> > Such a large perag reservation is by design on large filesystems.
> > The problem is that because the free space is so fragmented, this AG
> > contributes the 300 or so allocbt blocks to the global counters as
> > free space. If this pattern repeats across enough AGs, the
> > filesystem lands in a state where global block reservation can
> > outrun physical block availability. For example, a streaming
> > buffered write on the affected filesystem continues to allow delayed
> > allocation beyond the point where writeback starts to fail due to
> > physical block allocation failures. The expected behavior is for the
> > delalloc block reservation to fail gracefully with -ENOSPC before
> > physical block allocation failure is a possibility.
> 
> *nod*
> 
> > To address this problem, introduce a percpu counter to track the sum
> > of the allocbt block counters already tracked in the AGF. Use the
> > new counter to set these blocks aside at reservation time and thus
> > ensure they cannot be allocated until truly available. Since this is
> > only necessary when large reflink perag reservations are in place
> > and the counter requires a read of each AGF to fully populate, only
> > enforce on reflink enabled filesystems. This allows initialization
> > of the counter at ->pagf_init time because the refcountbt perag
> > reservation init code reads each AGF at mount time.
> 
> Ok, so the mechanism sounds ok, but a per-cpu counter seems like
> premature optimisation. How often are we really updating btree block
> counts? An atomic counter is good for at least a million updates a
> second across a 2 socket 32p machine, and I highly doubt we're
> incrementing/decrementing btree block counts that often on such a
> machine. 
> 
> While per-cpu counters have a fast write side, they come with
> additional algorithmic complexity. Hence if the update rate of the
> counter is not fast enough to need per-cpu counters, we should avoid
> them. just because other free space counters use per-cpu counters,
> it doesn't mean everything in that path needs to use them...
> 

The use of the percpu counter was more for the read side than the write
side. I think of it more of an abstraction to avoid having to open code
and define a new spin lock just for this. I actually waffled a bit on
just setting a batch count of 0 to get roughly equivalent behavior, but
didn't think it would make much difference.

> > Note that the counter uses a small percpu batch size to allow the
> > allocation paths to keep the primary count accurate enough that the
> > reservation path doesn't ever need to lock and sum the counter.
> > Absolute accuracy is not required here, just that the counter
> > reflects the majority of unavailable blocks so the reservation path
> > fails first.
> 
> And this makes the per-cpu counter scale almost no better than an
> simple atomic counter, because a spinlock requires two atomic
> operations (lock and unlock). Hence a batch count of 4 only reduces
> the atomic op count by half but introduces at lot of extra
> complexity. It won't make a difference to the scalability of
> workloads that hammer the btree block count because contention on
> the internal counter spinlock will occur at close to the same
> concurrency rate as would occur on an atomic counter.
> 

Right, but percpu_counter_read_positive() allows a fast read in the
xfs_mod_fdblocks() path. I didn't use an atomic because I was concerned
about introducing overhead in that path. If we're Ok with whatever
overhead an atomic read might introduce (a spin lock in the worst case
for some arches), then I don't mind switching over to that. I also don't
mind defining a new spin lock and explicitly implementing the lockless
read in xfs_mod_fdblocks(), I just thought it was extra code for little
benefit over the percpu counter. Preference?

Brian

> Hence a per-cpu counter used in this manner seems like a premature
> optimisation to me...
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

