Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1PHEqqG213265 for <xfs@oss.sgi.com>; Fri, 25 Feb 2011 11:14:53 -0600
Received: from e6.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F0D021302136
	for <xfs@oss.sgi.com>; Fri, 25 Feb 2011 09:17:38 -0800 (PST)
Received: from e6.ny.us.ibm.com (e6.ny.us.ibm.com [32.97.182.146]) by
	cuda.sgi.com with ESMTP id IeJEUKf6IHYpm0IS for
	<xfs@oss.sgi.com>; Fri, 25 Feb 2011 09:17:38 -0800 (PST)
Received: from d01dlp01.pok.ibm.com (d01dlp01.pok.ibm.com [9.56.224.56])
	by e6.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p1PGrFPV023442
	for <xfs@oss.sgi.com>; Fri, 25 Feb 2011 11:53:21 -0500
Received: from d01relay06.pok.ibm.com (d01relay06.pok.ibm.com [9.56.227.116])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id 7920638C8042
	for <xfs@oss.sgi.com>; Fri, 25 Feb 2011 12:17:37 -0500 (EST)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay06.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p1PHHHGi2515186
	for <xfs@oss.sgi.com>; Fri, 25 Feb 2011 12:17:18 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	p1PHHHiU018195 for <xfs@oss.sgi.com>; Fri, 25 Feb 2011 12:17:17 -0500
Subject: Re: xfstests 011 trips an ASSERT
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <20110225020649.GB3087@dastard>
References: <1298584480.32230.416.camel@chandra-lucid.beaverton.ibm.com>
	<20110225020649.GB3087@dastard>
Date: Fri, 25 Feb 2011 09:16:55 -0800
Message-ID: <1298654215.32230.419.camel@chandra-lucid.beaverton.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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
To: Dave Chinner <david@fromorbit.com>
Cc: XFS Mailing List <xfs@oss.sgi.com>

Thanks for the response Dave.

On Fri, 2011-02-25 at 13:06 +1100, Dave Chinner wrote:
> On Thu, Feb 24, 2011 at 01:54:40PM -0800, Chandra Seetharaman wrote:
> > Hello,
> > 
> > I ran the xfs tests on my POWER box and was tripped by an ASSERT while
> > running test 011. I have not seen it before in 2.6.37, so started with a
> > git-bisect from 2.6.37 to 2.6.38-rc6 and ended at this commit:
> > --------------------
> > Author  Linus Torvalds <torvalds@linux-foundation.org>
> >         Tue, 11 Jan 2011 19:42:06 +0000 (11:42 -0800)   
> > committer       Linus Torvalds <torvalds@linux-foundation.org>
> >         Tue, 11 Jan 2011 19:42:06 +0000 (11:42 -0800)   
> > commit  7bc4a4ce68f8c6d064ea949446852e996526f692        
> > Merge branch 'for-linus-merged' of git://oss.sgi.com/xfs/xfs
> > 
> > * 'for-linus-merged' of git://oss.sgi.com/xfs/xfs: (47 commits)
> >   xfs: convert grant head manipulations to lockless algorithm
> >   xfs: introduce new locks for the log grant ticket wait queues
> >   xfs: convert log grant heads to atomic variables
> >   xfs: convert l_tail_lsn to an atomic variable.
> >   xfs: convert l_last_sync_lsn to an atomic variable
> >   xfs: make AIL tail pushing independent of the grant lock
> >   xfs: use wait queues directly for the log wait queues
> >   xfs: combine grant heads into a single 64 bit integer
> >   xfs: rework log grant space calculations
> >   xfs: fact out common grant head/log tail verification code
> >   xfs: convert log grant ticket queues to list heads
> >   xfs: use AIL bulk delete function to implement single delete
> >   xfs: use AIL bulk update function to implement single updates
> >   xfs: remove all the inodes on a buffer from the AIL in bulk
> >   xfs: consume iodone callback items on buffers as they are processed
> >   xfs: reduce the number of AIL push wakeups
> >   xfs: bulk AIL insertion during transaction commit
> >   xfs: clean up xfs_ail_delete()
> >   xfs: Pull EFI/EFD handling out from under the AIL lock
> >   xfs: fix EFI transaction cancellation.
> >   ...
> > -----------------------------
> > 
> > Since it included so many patches, I thought i will start a git-bisect
> > on xfs git tree at git://oss.sgi.com/xfs/xfs, and ended up at
> > 92f1c008ae79e32b83c0607d184b194f302bb3ee, which is the same commit as
> > above.
> 
> you landed on the the merge commit. mark that commit as bad, and the
> bisect should continue down the merged branch. Otherwise you could
> try skipping the merge commit and again the bisect should continue
> down the branch.

I will try that route and see.

> > Two questions:
> > 1. Has anybody seen this problem ? I see this ASSERT has been added in
> > that patch set, is it a false-positive ?
> 
> The ASSERT() being triggered is racy. We are comparing the state of
> two different atomic variables that are updated without
> synchronisation. Hence after sampling the first, the second could be
> changed before it is sampled and hence cause the assert to fail.
> 
> I've never seen it be triggered, so I'm interested to know if this
> is reproducable (i.e. a real problem) or whether it is a false
> trigger (i.e. update race).

It is consistently reproducible. it _always_ fails with that commit in
my POWER hardware.
> 
> Cheers,
> 
> Dave.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
