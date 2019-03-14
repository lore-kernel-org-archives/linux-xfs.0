Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl6.internode.on.net ([150.101.137.136]:40372 "EHLO
        ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727489AbfCNXIo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Mar 2019 19:08:44 -0400
Date: Fri, 15 Mar 2019 10:08:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/4] xfs: force writes to delalloc regions to unwritten
Message-ID: <20190314230841.GJ23020@dastard>
References: <155259893433.30230.6566995969675098053.stgit@magnolia>
 <155259894630.30230.10064390935593758177.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155259894630.30230.10064390935593758177.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Mar 14, 2019 at 02:29:06PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When writing to a delalloc region in the data fork, commit the new
> allocations (of the da reservation) as unwritten so that the mappings
> are only marked written once writeback completes successfully.  This
> fixes the problem of stale data exposure if the system goes down during
> targeted writeback of a specific region of a file, as tested by
> generic/042.

So what does this do to buffered sequential and random write
performance?

Next, if the entire delalloc extent being allocated is beyond the
on-disk EOF (typical for extending sequential buffered writes), why
do we want those to be allocated as unwritten? i.e. isn't "allocate
as unwritten" only necessary for delalloc extent allocation
inside EOF?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
