Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:42890 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726121AbfBAX7D (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Feb 2019 18:59:03 -0500
Date: Sat, 2 Feb 2019 10:59:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 8/8] xfs: cache unlinked pointers in an rhashtable
Message-ID: <20190201235900.GX6173@dastard>
References: <154897667054.26065.13164381203002725289.stgit@magnolia>
 <154897672012.26065.1375987197453969157.stgit@magnolia>
 <20190201080343.GD22295@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190201080343.GD22295@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Fri, Feb 01, 2019 at 12:03:43AM -0800, Christoph Hellwig wrote:
> On Thu, Jan 31, 2019 at 03:18:40PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Use a rhashtable to cache the unlinked list incore.  This should speed
> > up unlinked processing considerably when there are a lot of inodes on
> > the unlinked list because iunlink_remove no longer has to traverse an
> > entire bucket list to find which inode points to the one being removed.
> 
> This sounds pretty reasonable and a real review will follow.  But can
> you quantify the considerably speedups for real life workloads?

When you have more than a few hundred open-but-unlinked inodes in an
AG, the unlinked list walking starts to take a significant amount of
time when the final reference to an inode goes away. It's
essentially an O(N) buffer walk, so takes a lot of CPU time when a
list gets more than a few inode long.

With darrick's background inactivation, the lists grow to tens of
thousands of inodes very quickly. I was seeing >95% of CPU time
being spend in unlinked list walking on large scale 'rm -rf'
workloads and performance absolutely dropped off a cliff. My initial
code (from years and years ago) used a
double linked list, and when I forward ported that and ran it up,
the CPU overhead of unlink list removal was cut to almost nothing and
all the performance regressions with background inactivation went
away. i.e. Unlink list removal went from an O(N) overhead to always
being O(1), so the length of the list didnt' affect performance any
more.

Darrick's code replaces the list_head in each inode I used with a
rhashtable - it removes the 16 bytes per-inode memory footprint my
implementation required, but otherwise is identical.  Hence I expect
that it'll show exactly the same performance characteristics as the
existing code.

IOWs, it's really required for backgrounding and parallelising inode
inactivation, but otherwise it won't make any noticable/measurable
difference to most workloads because the unlinked lists almost never
grows more than one inode in length and so O(N) ~= O(1) almost all
the time...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
