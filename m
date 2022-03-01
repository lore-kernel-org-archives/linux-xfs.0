Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F0F2C433F5
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Mar 2022 02:38:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbiCACjG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Feb 2022 21:39:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbiCACjF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Feb 2022 21:39:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B81FF277
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 18:38:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D51CB8123F
        for <linux-xfs@vger.kernel.org>; Tue,  1 Mar 2022 02:38:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2993C340EE;
        Tue,  1 Mar 2022 02:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646102303;
        bh=+Pj1s6cpMMvI3oL8RWsAiplLDaDu+99Nw3Gy99UeCBc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kbxRxMA8Nj1QeMA05rxmdXQe9DLXZgown4HLceL59XsEGDTUi9oP79D8nnnl/Y5rf
         VsgNjl0eSlBVYolzTv1tt2mVu2Uzn7ZNjSXVfiBj7uhIwvfI1hS2+H+8KUfWfOSiFF
         RTgj6hFUNOEU8DX203SwGp7mNuyOH15UewllCgayVuGKfvfkfWNo0FPznkS9IKrXtO
         qdIofAj1p8O//T3OxiPYUNb5zjYtIovUiyv+zXl6QpSsPG+gvvLbDvuf7D0VVRxUr0
         FyRV/Gm3ctbUZ26nkQmH0lEehQIaZGdeNtqqxyPP3euFa52BWcBrBhoQnp+5ffodDr
         /5rfhjHyftQbA==
Date:   Mon, 28 Feb 2022 18:38:22 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     sandeen@sandeen.net, Christoph Hellwig <hch@lst.de>,
        Dave Chinner <dchinner@redhat.com>,
        Theodore Ts'o <tytso@mit.edu>, linux-xfs@vger.kernel.org,
        allison.henderson@oracle.com
Subject: Re: [PATCH 19/17] mkfs: increase default log size for new (aka
 bigtime) filesystems
Message-ID: <20220301023822.GD117732@magnolia>
References: <20220226213720.GQ59715@dread.disaster.area>
 <20220228232211.GA117732@magnolia>
 <20220301004249.GT59715@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220301004249.GT59715@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 01, 2022 at 11:42:49AM +1100, Dave Chinner wrote:
> On Mon, Feb 28, 2022 at 03:22:11PM -0800, Darrick J. Wong wrote:
> > On Sun, Feb 27, 2022 at 08:37:20AM +1100, Dave Chinner wrote:
> > > On Fri, Feb 25, 2022 at 06:54:50PM -0800, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > Recently, the upstream kernel maintainer has been taking a lot of heat on
> > > > account of writer threads encountering high latency when asking for log
> > > > grant space when the log is small.  The reported use case is a heavily
> > > > threaded indexing product logging trace information to a filesystem
> > > > ranging in size between 20 and 250GB.  The meetings that result from the
> > > > complaints about latency and stall warnings in dmesg both from this use
> > > > case and also a large well known cloud product are now consuming 25% of
> > > > the maintainer's weekly time and have been for months.
> > > 
> > > Is the transaction reservation space exhaustion caused by, as I
> > > pointed out in another thread yesterday, the unbound concurrency in
> > > IO completion?
> > 
> > No.  They're using synchronous directio writes to write trace data in 4k
> 
> synchronous as in O_(D)SYNC or as in "not using AIO"? Is is also
> append data, and is it one file per logging thread or multiple
> threads writing to a single file?

One file per <cough> tenant, and multiple threads spread across all the
tenants on a system.  This means that all the threads can end up
pounding on a single file, or each thread can write to a single file.
The scenario that generated all those numbers (I think) is opening the
file O_DIRECT|O_SYNC and pwrite()ing blocks at EOF.

> > chunks.  The number of files does not exceed the number of writer
> > threads, and the number of writer threads can be up to 10*NR_CPUS (~400
> > on the test system).  If I'm reading the iomap directio code correctly,
> > the writer threads block and do not issue more IO until the first IO
> > completes...
> 
> So, up to 400 threads concurrently issuing IO that does block
> allocation and performing unwritten extent conversion, so up to ~800
> concurrent running allocation related transactions at a time?

Assuming you got 800 from the 400 writers + 400 bmbt allocations, yes.
Though I wouldn't count /quite/ that high for bmbt expansions.

> > > i.e. we have hundreds of active concurrent
> > > transactions that then block on common objects between them (e.g.
> > > inode locks) and serialise?
> > 
> > ...so yes, there are hundreds of active transactions, but (AFAICT) they
> > mostly don't share objects, other than the log itself.  Once we made the
> > log bigger, the hotspot moved to the AGF buffers.  I'm not sure what to
> > do about /that/, since a 5GB AG is pretty small.  That aside...
> 
> No surprise, AG selection is based on the is based on trying to get
> an adjacent extent for file extension. Hence assuming random
> distribution because of contention and skipping done by the search
> algorithm, then if we have ~50 AGs and 400 writers trying to
> allocate at the same time then you've got, on average, 8 allocations
> per AG being attempted roughly concurrently.
> 
> Of course, append write workloads tend to respond really well to
> extent size hints - make sure you allocate a large chunk that
> extents beyond EOF on the first write, then subsequent extending
> writes only need unwritten extent conversion which shouldn't need
> AGF access because it won't require BMBT block allocation during
> conversion because it's just taking away from the unwritten extent
> and putting the space into the adjacent written extent.

Yes, I know, I've been battling $internalgroups for over a year now to
get extent size hints turned on for things like append logs and VM
images.  If the IO sizes get larger (or they turn on extent size hints)
then the heat goes down...

> > > Hence only handful of completions can
> > > actually run concurrently, depsite every completion holding a full
> > > reservation of log space to allow them to run concurrently?
> > 
> > ...this is still an issue for different scenarios.  I would still be
> > interested in experimenting with constraining the number of writeback
> > completion workers that get started, even though that isn't at play
> > here.
> 
> Well, the "running out of log space" problem is still going to
> largely be caused by having up to 400 concurrent unwritten extent
> conversion transactions running at any given point in time...

I know!  But right now the default log size you get with a 220G volume
is 110MB.  An 800MB log just pushes the scaling problems around the
system, but on the plus side the latency is no longer so high that the
heartbeat timers trip, which causes node evictions, which leads to even
/worse/ escalations from customers whose systems experience high rates
of failure.  Every single customer who escalates this causes another
round of bug reports and another round of meetings for me, even though
the causes and the bandaids are the same.

> > > I also wonder if the right thing to do here is just set a minimum
> > > log size of 32MB? The worst of the long tail latencies are mitigated
> > > by this point, and so even small filesystems grown out to 200GB will
> > > have a log size that results in decent performance for this sort of
> > > workload.
> > 
> > Are you asking for a second patch where mkfs refuses to format a log
> > smaller than 32MB (e.g. 8GB with the x86 defaults)?  Or a second patch
> > that cranks the minimum log size up to 32MB, even if that leads to
> > absurd results (e.g. 66MB filesystems with 2 AGs and a 32MB log)?
> 
> I'm suggesting the latter.
> 
> Along with a refusal to make an XFS filesystem smaller than, say,
> 256MB, because allowing users to make tiny XFS filesystems seems to
> always just lead to future troubles.

I'm going to drop this patch, because I don't have the strength to push
back against you /and/ Eric.  I'm once again in a crunch because I've
spent so much of the past few weeks in meetings about bugs that I didn't
have time to try out Allison's LARP patches so I basically have nothing
to push for 5.18 because we're past -rc6 and it's too late, too late for
anything.  Hell, I can't even get that capable() thing reviewed, and
(right now) that's causing me even more meetingsgalore pain.

Is it so dangerous to turn this on so that real users can experiment
with the new setting?

Frankly I'm also thinking about throwing away six years of online repair
work because I just don't see myself being able to summon the mental
energy to run the review process when simple things are this hard.
Every week I sit down and ask myself if I really have what it takes to
keep going, and I've reached the point where the answer is NO.  I was
really hoping that some of our discussions about process improvements
would have made things better, but instead I realize that I have failed
as maintainer.

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
