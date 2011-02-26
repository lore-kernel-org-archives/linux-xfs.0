Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1Q1wF34235047 for <xfs@oss.sgi.com>; Fri, 25 Feb 2011 19:58:16 -0600
Received: from e7.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5FB1B157405E
	for <xfs@oss.sgi.com>; Fri, 25 Feb 2011 18:01:01 -0800 (PST)
Received: from e7.ny.us.ibm.com (e7.ny.us.ibm.com [32.97.182.137]) by
	cuda.sgi.com with ESMTP id tFg7koGrPxMqpHTF for
	<xfs@oss.sgi.com>; Fri, 25 Feb 2011 18:01:01 -0800 (PST)
Received: from d01dlp01.pok.ibm.com (d01dlp01.pok.ibm.com [9.56.224.56])
	by e7.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p1Q1egSd014890
	for <xfs@oss.sgi.com>; Fri, 25 Feb 2011 20:40:42 -0500
Received: from d01relay05.pok.ibm.com (d01relay05.pok.ibm.com [9.56.227.237])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id DE68238C8036
	for <xfs@oss.sgi.com>; Fri, 25 Feb 2011 21:01:00 -0500 (EST)
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p1Q2100N213200 for <xfs@oss.sgi.com>; Fri, 25 Feb 2011 21:01:00 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	p1Q210sB012775 for <xfs@oss.sgi.com>; Fri, 25 Feb 2011 23:01:00 -0300
Subject: Re: xfstests 011 trips an ASSERT
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <20110225020649.GB3087@dastard>
References: <1298584480.32230.416.camel@chandra-lucid.beaverton.ibm.com>
	<20110225020649.GB3087@dastard>
Date: Fri, 25 Feb 2011 18:00:44 -0800
Message-ID: <1298685644.32230.420.camel@chandra-lucid.beaverton.ibm.com>
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

Hi Dave,

Did the git bisect on the merge tree and end up up on this commit as the
offensive one.

----------------------------
3f16b9850743b702380f098ab5e0308cd6af1792 is the first bad commit
commit 3f16b9850743b702380f098ab5e0308cd6af1792
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue Dec 21 12:29:01 2010 +1100

    xfs: introduce new locks for the log grant ticket wait queues
    
    The log grant ticket wait queues are currently protected by the log
    grant lock.  However, the queues are functionally independent from
    each other, and operations on them only require serialisation
    against other queue operations now that all of the other log
    variables they use are atomic values.
    
    Hence, we can make them independent of the grant lock by introducing
    new locks just to protect the lists operations. because the lists
    are independent, we can use a lock per list and ensure that reserve
    and write head queuing do not contend.
    
    To ensure forced shutdowns work correctly in conjunction with the
    new fast paths, ensure that we check whether the log has been shut
    down in the grant functions once we hold the relevant spin locks but
    before we go to sleep. This is needed to co-ordinate correctly with
    the wakeups that are issued on the ticket queues so we don't leave
    any processes sleeping on the queues during a shutdown.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
------------------------------

Thanks
chandra
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
> 
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
> 
> Cheers,
> 
> Dave.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
