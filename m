Return-Path: <SRS0=KB2e=YT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB7CBCA9EB9
	for <linux-xfs@archiver.kernel.org>; Sat, 26 Oct 2019 21:59:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0E1C214DA
	for <linux-xfs@archiver.kernel.org>; Sat, 26 Oct 2019 21:59:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbfJZV7N (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 26 Oct 2019 17:59:13 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:53605 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726434AbfJZV7N (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 26 Oct 2019 17:59:13 -0400
Received: from dread.disaster.area (pa49-181-161-154.pa.nsw.optusnet.com.au [49.181.161.154])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 69A7243EFCD;
        Sun, 27 Oct 2019 08:59:10 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1iOU5V-0006Vn-BF; Sun, 27 Oct 2019 08:59:09 +1100
Date:   Sun, 27 Oct 2019 08:59:09 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Gionatan Danti <g.danti@assyoma.it>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: Question about logbsize default value
Message-ID: <20191026215909.GK4614@dread.disaster.area>
References: <00242d70-1d8e-231d-7ba0-1594412714ad@assyoma.it>
 <20191024215027.GC4614@dread.disaster.area>
 <eb0ef021-27be-c0bd-5950-103cd8b04594@assyoma.it>
 <20191025233934.GI4614@dread.disaster.area>
 <51fef5c8e58db12a72b693680c2feaa5@assyoma.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51fef5c8e58db12a72b693680c2feaa5@assyoma.it>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=l3vQdJ1SkhDHY1nke8Lmag==:117 a=l3vQdJ1SkhDHY1nke8Lmag==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=XobE76Q3jBoA:10
        a=7-415B0cAAAA:8 a=3okUCA9Tfv1AStXs2ZoA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Oct 26, 2019 at 11:54:02AM +0200, Gionatan Danti wrote:
> Il 26-10-2019 01:39 Dave Chinner ha scritto:
> > Again, it's a trade-off.
> > 
> > 256kB iclogs mean that a crash can leave an unrecoverable 2MB hole
> > in the journal, while 32kB iclogs means it's only 256kB.
> 
> Sure, but a crash will always cause the loss of unsynced data, especially
> when using deferred logging and/or deferred allocation, right?

Yes, but there's a big difference between 2MB and 256KB, especially
if it's a small filesystem (very common) and the log is only ~10MB
in size.

> > 256kB iclogs mean 2MB of memory usage per filesystem, 32kB is only
> > 256kB. We have users with hundreds of individual XFS filesystems
> > mounted on single machines, and so 256kB iclogs is a lot of wasted
> > memory...
> 
> Just wondering: 1000 filesystems with 256k logbsize would result in 2 GB of
> memory consumed by journal buffers. Is this considered too much memory for a
> system managing 1000 filesystems? The pagecache write back memory
> consumption on these systems (probably equipped with 10s GB of RAM) would
> dwarfs any journal buffers, no?

Log buffers are static memory footprint. Page cache memory is
dynamic and can be trimmed to nothing when there is memory pressure
However, memory allocated to log buffers is pinned for the life
of the mount, whether that filesystem is busy or not - the memory is
not reclaimable.

THe 8 log buffers of 32kB each is a good trade-off between
minimising memory footprint and maintaining performance over a wide
range of storage and use cases. If that's still too much memory per
filesystem, then the user can compromise on performance by reducing
the number of logbufs. If performance is too slow, then the user can
increase the memory footprint to improve performance.

The default values sit in the middle ground on both axis - enough
logbufs and iclog size for decent performance but with a small
enough memory footprint that dense or resource constrained
installations are possible to deploy without needing any tweaking.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
