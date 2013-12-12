Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 829297F4E
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 23:31:05 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1B333AC008
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 21:31:05 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	5ToKXNVYEmkruA3I for <xfs@oss.sgi.com>;
	Wed, 11 Dec 2013 21:31:02 -0800 (PST)
Date: Thu, 12 Dec 2013 16:30:47 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: FAST paper on ffsck
Message-ID: <20131212053047.GI31386@dastard>
References: <20131209180149.GA6096@thunk.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131209180149.GA6096@thunk.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Theodore Ts'o <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On Mon, Dec 09, 2013 at 01:01:49PM -0500, Theodore Ts'o wrote:
> Andreas brought up on today's conference call Kirk McKusick's recent
> changes[1] to try to improve fsck times for FFS, in response to the
> recent FAST paper covering fsck speed ups for ext3, "ffsck: The Fast
> Filesystem Checker"[2]
> 
> [1] http://www.mckusick.com/publications/faster_fsck.pdf
> [2] https://www.usenix.org/system/files/conference/fast13/fast13-final52_0.pdf

Interesting - it's all about trying to lay out data to get
sequential disk access patterns during scanning (i.e. minimise disk
seeks) to reduce fsck runtime. Fine in principle, but I think that
it's a dead end you don't want to go down.

Why? Because it's the exact opposite of what you need for SSD based
filesystems.  What fsck really needs is to be able to saturate the
IOPS capability of the underlying device rather than optimising for
bandwidth, and that means driving deep IO queue depths.

e.g I've dropped xfs_repair times on a 100TB test filesystem with 50
million inodes from 25 minutes to 5 minutes simply by adding gobs of
additional concurrency and ignoring sequential IO optimisations.
It's driving bandwidth rates of 200-250MB/s simply due to the IOPS
rate it is acheiving, not because I'm optimising IO patterns for
sequential IO.

In fact, it dispatches so much IO now that the limitation is not the
60,000 IOPS that it is pulling from the underlying SSDs, but
mmap_sem contention caused by 30-odd threads doing concurrent memory
allocation to cache and store all the information that is being read
from disk...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
