Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:14819 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729863AbfDDVRe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Apr 2019 17:17:34 -0400
Date: Fri, 5 Apr 2019 08:17:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [POC][PATCH] xfs: reduce ilock contention on buffered randrw
 workload
Message-ID: <20190404211730.GD26298@dastard>
References: <20190404165737.30889-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190404165737.30889-1-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Matthew Wilcox <willy@infradead.org>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Thu, Apr 04, 2019 at 07:57:37PM +0300, Amir Goldstein wrote:
> This patch improves performance of mixed random rw workload
> on xfs without relaxing the atomic buffered read/write guaranty
> that xfs has always provided.
> 
> We achieve that by calling generic_file_read_iter() twice.
> Once with a discard iterator to warm up page cache before taking
> the shared ilock and once again under shared ilock.

This will race with thing like truncate, hole punching, etc that
serialise IO and invalidate the page cache for data integrity
reasons under the IOLOCK. These rely on there being no IO to the
inode in progress at all to work correctly, which this patch
violates. IOWs, while this is fast, it is not safe and so not a
viable approach to solving the problem.

FYI, I'm working on a range lock implementation that should both
solve the performance issue and the reader starvation issue at the
same time by allowing concurrent buffered reads and writes to
different file ranges.

IO range locks will allow proper exclusion for other extent
manipulation operations like fallocate and truncate, and eventually
even allow truncate, hole punch, file extension, etc to run
concurrently with other non-overlapping IO. They solve more than
just the performance issue you are seeing....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
