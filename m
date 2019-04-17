Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:46209 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725848AbfDQVkd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Apr 2019 17:40:33 -0400
Date: Thu, 18 Apr 2019 07:40:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] xfs: track delayed allocation reservations across
Message-ID: <20190417214031.GR29573@dread.disaster.area>
References: <155546519998.176278.8300210828717055034.stgit@magnolia>
 <155546520611.176278.16800498529488238281.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155546520611.176278.16800498529488238281.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Apr 16, 2019 at 06:40:06PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add a percpu counter to track the number of blocks directly reserved for
> delayed allocations on the data device.  This counter (in contrast to
> i_delayed_blks) does not track allocated CoW staging extents or anything
> going on with the realtime device.  It will be used in the upcoming
> summary counter scrub function to check the free block counts without
> having to freeze the filesystem or walk all the inodes to find the
> delayed allocations.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Hmmm. Given that a lot of modifcations to this counter are going to
be large quantities (much greater than the percpu counter batch size
of 32) this effectively just degrades to spin lock protected global
counter, yes? This is the reason we have XFS_FDBLOCKS_BATCH (1024)
for the free block percpu counter so that changes from frequent
updates via lots of smallish write()s don't need to take the global
aggregation lock very often...

So I'm guessing that this counter needs similar treatment for
scalability on large machines. If it doesn't then an atomic64_t
is all that is necessary here...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
