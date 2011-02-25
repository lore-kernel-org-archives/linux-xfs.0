Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1P24NhH173288 for <xfs@oss.sgi.com>; Thu, 24 Feb 2011 20:04:24 -0600
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CCDF62FB8AF
	for <xfs@oss.sgi.com>; Thu, 24 Feb 2011 18:07:07 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	vKOymDem3sFWjAgk for <xfs@oss.sgi.com>;
	Thu, 24 Feb 2011 18:07:07 -0800 (PST)
Date: Fri, 25 Feb 2011 13:06:49 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfstests 011 trips an ASSERT
Message-ID: <20110225020649.GB3087@dastard>
References: <1298584480.32230.416.camel@chandra-lucid.beaverton.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1298584480.32230.416.camel@chandra-lucid.beaverton.ibm.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: XFS Mailing List <xfs@oss.sgi.com>

On Thu, Feb 24, 2011 at 01:54:40PM -0800, Chandra Seetharaman wrote:
> Hello,
> 
> I ran the xfs tests on my POWER box and was tripped by an ASSERT while
> running test 011. I have not seen it before in 2.6.37, so started with a
> git-bisect from 2.6.37 to 2.6.38-rc6 and ended at this commit:
> --------------------
> Author  Linus Torvalds <torvalds@linux-foundation.org>
>         Tue, 11 Jan 2011 19:42:06 +0000 (11:42 -0800)   
> committer       Linus Torvalds <torvalds@linux-foundation.org>
>         Tue, 11 Jan 2011 19:42:06 +0000 (11:42 -0800)   
> commit  7bc4a4ce68f8c6d064ea949446852e996526f692        
> Merge branch 'for-linus-merged' of git://oss.sgi.com/xfs/xfs
> 
> * 'for-linus-merged' of git://oss.sgi.com/xfs/xfs: (47 commits)
>   xfs: convert grant head manipulations to lockless algorithm
>   xfs: introduce new locks for the log grant ticket wait queues
>   xfs: convert log grant heads to atomic variables
>   xfs: convert l_tail_lsn to an atomic variable.
>   xfs: convert l_last_sync_lsn to an atomic variable
>   xfs: make AIL tail pushing independent of the grant lock
>   xfs: use wait queues directly for the log wait queues
>   xfs: combine grant heads into a single 64 bit integer
>   xfs: rework log grant space calculations
>   xfs: fact out common grant head/log tail verification code
>   xfs: convert log grant ticket queues to list heads
>   xfs: use AIL bulk delete function to implement single delete
>   xfs: use AIL bulk update function to implement single updates
>   xfs: remove all the inodes on a buffer from the AIL in bulk
>   xfs: consume iodone callback items on buffers as they are processed
>   xfs: reduce the number of AIL push wakeups
>   xfs: bulk AIL insertion during transaction commit
>   xfs: clean up xfs_ail_delete()
>   xfs: Pull EFI/EFD handling out from under the AIL lock
>   xfs: fix EFI transaction cancellation.
>   ...
> -----------------------------
> 
> Since it included so many patches, I thought i will start a git-bisect
> on xfs git tree at git://oss.sgi.com/xfs/xfs, and ended up at
> 92f1c008ae79e32b83c0607d184b194f302bb3ee, which is the same commit as
> above.

you landed on the the merge commit. mark that commit as bad, and the
bisect should continue down the merged branch. Otherwise you could
try skipping the merge commit and again the bisect should continue
down the branch.

> Two questions:
> 1. Has anybody seen this problem ? I see this ASSERT has been added in
> that patch set, is it a false-positive ?

The ASSERT() being triggered is racy. We are comparing the state of
two different atomic variables that are updated without
synchronisation. Hence after sampling the first, the second could be
changed before it is sampled and hence cause the assert to fail.

I've never seen it be triggered, so I'm interested to know if this
is reproducable (i.e. a real problem) or whether it is a false
trigger (i.e. update race).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
