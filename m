Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:42279 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726026AbfDYWnl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Apr 2019 18:43:41 -0400
Date: Fri, 26 Apr 2019 08:43:37 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/5] xfs: track delayed allocation reservations across
Message-ID: <20190425224337.GB29573@dread.disaster.area>
References: <155563325882.112668.3605935077532891922.stgit@magnolia>
 <155563326502.112668.15075629821207212917.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155563326502.112668.15075629821207212917.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Apr 18, 2019 at 05:21:05PM -0700, Darrick J. Wong wrote:
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

I don't really like the fact we're adding new (int64_t) casts to
the accounting code, but fixing that is a different problem.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
