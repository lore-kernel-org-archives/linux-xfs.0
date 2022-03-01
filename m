Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95BB0C433F5
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Mar 2022 00:42:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbiCAAnh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Feb 2022 19:43:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbiCAAnf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Feb 2022 19:43:35 -0500
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AC326CE8
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 16:42:53 -0800 (PST)
Received: from dread.disaster.area (pa49-186-17-0.pa.vic.optusnet.com.au [49.186.17.0])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 1969910C7BD1;
        Tue,  1 Mar 2022 11:42:50 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nOqbJ-0002Um-UK; Tue, 01 Mar 2022 11:42:49 +1100
Date:   Tue, 1 Mar 2022 11:42:49 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, Christoph Hellwig <hch@lst.de>,
        Dave Chinner <dchinner@redhat.com>,
        Theodore Ts'o <tytso@mit.edu>, linux-xfs@vger.kernel.org,
        allison.henderson@oracle.com
Subject: Re: [PATCH 19/17] mkfs: increase default log size for new (aka
 bigtime) filesystems
Message-ID: <20220301004249.GT59715@dread.disaster.area>
References: <20220226213720.GQ59715@dread.disaster.area>
 <20220228232211.GA117732@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220228232211.GA117732@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=621d6c0c
        a=+dVDrTVfsjPpH/ci3UuFng==:117 a=+dVDrTVfsjPpH/ci3UuFng==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=KM7FsSbDbDw--HxBGP0A:9 a=7Zwj6sZBwVKJAoWSPKxL6X1jA+E=:19
        a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 28, 2022 at 03:22:11PM -0800, Darrick J. Wong wrote:
> On Sun, Feb 27, 2022 at 08:37:20AM +1100, Dave Chinner wrote:
> > On Fri, Feb 25, 2022 at 06:54:50PM -0800, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Recently, the upstream kernel maintainer has been taking a lot of heat on
> > > account of writer threads encountering high latency when asking for log
> > > grant space when the log is small.  The reported use case is a heavily
> > > threaded indexing product logging trace information to a filesystem
> > > ranging in size between 20 and 250GB.  The meetings that result from the
> > > complaints about latency and stall warnings in dmesg both from this use
> > > case and also a large well known cloud product are now consuming 25% of
> > > the maintainer's weekly time and have been for months.
> > 
> > Is the transaction reservation space exhaustion caused by, as I
> > pointed out in another thread yesterday, the unbound concurrency in
> > IO completion?
> 
> No.  They're using synchronous directio writes to write trace data in 4k

synchronous as in O_(D)SYNC or as in "not using AIO"? Is is also
append data, and is it one file per logging thread or multiple
threads writing to a single file?

> chunks.  The number of files does not exceed the number of writer
> threads, and the number of writer threads can be up to 10*NR_CPUS (~400
> on the test system).  If I'm reading the iomap directio code correctly,
> the writer threads block and do not issue more IO until the first IO
> completes...

So, up to 400 threads concurrently issuing IO that does block
allocation and performing unwritten extent conversion, so up to ~800
concurrent running allocation related transactions at a time?

> > i.e. we have hundreds of active concurrent
> > transactions that then block on common objects between them (e.g.
> > inode locks) and serialise?
> 
> ...so yes, there are hundreds of active transactions, but (AFAICT) they
> mostly don't share objects, other than the log itself.  Once we made the
> log bigger, the hotspot moved to the AGF buffers.  I'm not sure what to
> do about /that/, since a 5GB AG is pretty small.  That aside...

No surprise, AG selection is based on the is based on trying to get
an adjacent extent for file extension. Hence assuming random
distribution because of contention and skipping done by the search
algorithm, then if we have ~50 AGs and 400 writers trying to
allocate at the same time then you've got, on average, 8 allocations
per AG being attempted roughly concurrently.

Of course, append write workloads tend to respond really well to
extent size hints - make sure you allocate a large chunk that
extents beyond EOF on the first write, then subsequent extending
writes only need unwritten extent conversion which shouldn't need
AGF access because it won't require BMBT block allocation during
conversion because it's just taking away from the unwritten extent
and putting the space into the adjacent written extent.

> > Hence only handful of completions can
> > actually run concurrently, depsite every completion holding a full
> > reservation of log space to allow them to run concurrently?
> 
> ...this is still an issue for different scenarios.  I would still be
> interested in experimenting with constraining the number of writeback
> completion workers that get started, even though that isn't at play
> here.

Well, the "running out of log space" problem is still going to
largely be caused by having up to 400 concurrent unwritten extent
conversion transactions running at any given point in time...

> > I also wonder if the right thing to do here is just set a minimum
> > log size of 32MB? The worst of the long tail latencies are mitigated
> > by this point, and so even small filesystems grown out to 200GB will
> > have a log size that results in decent performance for this sort of
> > workload.
> 
> Are you asking for a second patch where mkfs refuses to format a log
> smaller than 32MB (e.g. 8GB with the x86 defaults)?  Or a second patch
> that cranks the minimum log size up to 32MB, even if that leads to
> absurd results (e.g. 66MB filesystems with 2 AGs and a 32MB log)?

I'm suggesting the latter.

Along with a refusal to make an XFS filesystem smaller than, say,
256MB, because allowing users to make tiny XFS filesystems seems to
always just lead to future troubles.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
