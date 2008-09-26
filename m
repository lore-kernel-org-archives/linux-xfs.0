Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 26 Sep 2008 00:07:03 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8Q770SQ008166
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2008 00:07:00 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 59CA3120FE90
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2008 00:08:34 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id LViUBhHpiBB9StGs for <xfs@oss.sgi.com>; Fri, 26 Sep 2008 00:08:34 -0700 (PDT)
Date: Fri, 26 Sep 2008 17:08:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Running out of reserved data blocks
Message-ID: <20080926070831.GM27997@disturbed>
References: <48DC73AB.4050309@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48DC73AB.4050309@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Fri, Sep 26, 2008 at 03:31:23PM +1000, Lachlan McIlroy wrote:
> A while back I posted a patch to re-dirty pages on I/O error to handle errors from
> xfs_trans_reserve() that was failing with ENOSPC when trying to convert delayed
> allocations.  I'm now seeing xfs_trans_reserve() fail when converting unwritten
> extents and in that case we silently ignore the error and leave the extent as
> unwritten which effectively causes data corruption.  I can also get failures when
> trying to unreserve disk space.

Is this problem being seen in the real world, or just in artificial
test workloads?

What the reserve pool is supposed to do is provide sufficient blocks
to allow dirty data to be flushed, xattrs to be added, etc in the
immediately period after the ENOSPC occurs so that none of the
existing operations we've committed to fail.  The reserve pool is
not meant to be an endless source of space that allows the system to
continue operating permanently at ENOSPC.

If you start new operations like writing into unwritten extents once
you are already at ENOSPC, then you can consume the entire of the
reserve pool. There is nothing we can do to prevent that from
occurring, except by doing something like partially freezing the
filesystem (i.e. just the data write() level, not the transaction
level) until the ENOSPC condition goes away....

> I've tried increasing the size of the reserved data blocks pool
> but that only delays the inevitable.  Increasing the size to 65536
> blocks seems to avoid failures but that's getting to be a lot of
> disk space.

You're worried about reserving 20c worth of disk space and 10s of
time to change the config vs hours of enginnering and test time
to come up with a different solution that may or may not be
as effective?

Reserving a bit of extra space is a cheap, cost effective solution
to the problem.

> All of these ENOSPC errors should be transient and if we retried
> the operation - or waited for the reserved pool to refill - we
> could proceed with the transaction.  I was thinking about adding a
> retry loop in xfs_trans_reserve() so if XFS_TRANS_RESERVE is set
> and we fail to get space we just keep trying.

ENOSPC is not a transient condition unless you do something to
free up space. If the system is unattended, then ENOSPC can
persist for a long time. This is effectively silently livelocking
the system until the ENOSPC is cleared. That will have effect on
operations on other filesystems, too. e.g. pdflush gets stuck
in one of these loops...

Either increase the size of the reserved pool so your reserve pool
doesn't empty, or identify and prevent what-ever I/O is depleting
the reserve pool at ENOSPC....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
