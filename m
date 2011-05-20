Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4K0PX1w060911 for <xfs@oss.sgi.com>; Thu, 19 May 2011 19:25:33 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4FD581E3185E
	for <xfs@oss.sgi.com>; Thu, 19 May 2011 17:25:31 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	5WK8mGEoUOV79lro for <xfs@oss.sgi.com>;
	Thu, 19 May 2011 17:25:31 -0700 (PDT)
Date: Fri, 20 May 2011 10:25:28 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: btree re-write and XFS_WANT_CORRUPTED_GOTO
Message-ID: <20110520002528.GM32466@dastard>
References: <BANLkTinb3aQc9GSy4dqFVeVpGk8W4M92fA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <BANLkTinb3aQc9GSy4dqFVeVpGk8W4M92fA@mail.gmail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Peter Watkins <treestem@gmail.com>
Cc: xfs@oss.sgi.com

On Thu, May 19, 2011 at 11:59:18AM -0400, Peter Watkins wrote:
> Hello again,
> 
> I've occasionally seen the XFS_WANT_CORRUPTED_GOTO error from
> xfs_free_extent, usually when cleaning up an unlinked file or
> truncating a file.
> 
> Is the btree rewrite known to fix any WANT_CORRUPTED problems? More

No.

> generally, why was the btree code reworked?

Three copies of the almost the same btree code, spanning 15,000 lines
of code, reduced to one btree core file and three ~1,000 line
functions per btree type. All btrees get WANT_CORRUPTED coverage
instead of just the freespace btree. Much easier to implement new
btrees (~1,000 lines of code instead of ~4-7000 lines). Bug fixes to
the btree core get fixed in all types, instead of a just the one
tree it was discovered for. Optimisations need to touch one piece of
code, not three, etc, etc.

> going from 2.6.27 to 2.6.32 (still old I know), which seems to span
> the btree re-write.
> 
> Are any particular patches recommended for this problem? I came across
> 24446fc66fdebbdd8baca0f44fd2a47ad77ba580. It's discussed at
> http://oss.sgi.com/archives/xfs/2011-01/msg00266.html  Do any others
> come to mind?

That problem required CXFS to reproduce - mainline XFS never
executes the particular code path that triggered the bug.

Seriously, if you are having problems with btree corruption, the
first thin you need to do is run with the latest and greatest code.
We fix problems all the time, so asking "what commits from the past
12 releases will fix this problem" is kinda pointless - we can't
give you any sort of reasonable answer to that.

If you can reproduce the problem on a recent kernel (2.6.38 or .39)
then we know we've got a bug that has not been fixed yet, and that
means we need to do spend the effort to fiadn it. However, if you
can't reproduce it on a current kernel, then theres really nothing
much we can do to help you identify the cause - you can run a bisect
on your reproducing workload and find the exact patch that fixed the
problem much more easily than we can....

Of course, if you really want someone to do all this work and fix
these sort of problems on older kernels for you, then that's the
value proposition that using RHEL or SLES bring to the table.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
