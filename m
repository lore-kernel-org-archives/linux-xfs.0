Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5120D7F4E
	for <xfs@oss.sgi.com>; Thu,  5 Sep 2013 19:17:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1F96A8F8039
	for <xfs@oss.sgi.com>; Thu,  5 Sep 2013 17:17:22 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	HfWNknrZx02TWr9J for <xfs@oss.sgi.com>;
	Thu, 05 Sep 2013 17:17:20 -0700 (PDT)
Date: Fri, 6 Sep 2013 10:17:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH 07/11] xfs: retry trans reservation on ENOSPC in
	xfs_inactive()
Message-ID: <20130906001718.GQ12779@dastard>
References: <1378232708-57156-1-git-send-email-bfoster@redhat.com>
	<1378232708-57156-8-git-send-email-bfoster@redhat.com>
	<20130905014016.GU23571@dastard> <5228AED7.1010700@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5228AED7.1010700@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Thu, Sep 05, 2013 at 12:18:31PM -0400, Brian Foster wrote:
> On 09/04/2013 09:40 PM, Dave Chinner wrote:
> > On Tue, Sep 03, 2013 at 02:25:04PM -0400, Brian Foster wrote:
> >> An ifree data block reservation can fail with ENOSPC. Flush inodes
> >> to try and free up space or attempt without a data block
> >> reservation to avoid failing out of xfs_inactive().
> >>
> >> Signed-off-by: Brian Foster <bfoster@redhat.com>
> >> ---
> >>  fs/xfs/xfs_inode.c | 11 +++++++++++
> >>  1 file changed, 11 insertions(+)
> >>
> >> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> >> index 56cbf63..92de4b7 100644
> >> --- a/fs/xfs/xfs_inode.c
> >> +++ b/fs/xfs/xfs_inode.c
> >> @@ -1779,7 +1779,18 @@ xfs_inactive(
> >>  	tp = xfs_trans_alloc(mp, XFS_TRANS_INACTIVE);
> >>  	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_ifree,
> >>  				  XFS_IFREE_SPACE_RES(mp), 0);
> >> +	if (error == ENOSPC) {
> >> +		/* flush outstanding delalloc blocks and retry */
> >> +		xfs_flush_inodes(mp);
> >> +		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_ifree,
> >> +					  XFS_IFREE_SPACE_RES(mp), 0);
> >> +	}
> > 
> > We don't want to be blocking for inode flushes here. We might be in
> > a shrinker context, for example, and blocking those for a filesystem
> > sync is going to be unfriendly.
> > 
> 
> Ok.
> 
> > If this really is a problem, then the right thing to do is to allow
> > this transaction to dip into the reserve block pool so the
> > transaction can complete and make progress - other write operations
> > will trigger the flushing of the filesystem, and freeing of whole
> > inode chunks should return more free space than we need for the
> > finobt modifications in the removing lots of zero length inodes
> > at ENOSPC case....
> > 
> 
> I did have one of the enospc xfstests lead to this situation, though I
> don't have the particular test in my notes. It initially manifested as
> an assert failure due to the fs not being shutdown after an
> xfs_trans_reserve() ENOSPC failure.

Ok. I can see how ENOSPC might occur here :)

> Subsequent to avoiding that, I
> believe there were inconsistent fs issues called out due to the unlinked
> lists being populated after umount.

That sounds like a recovery failure, not so much an ENOSPC failure.
i.e. that recovery only looks at the log to see if it's clean, and
only recovers unlinked lists if it's dirty. There is the
*possibility* of having a clean log with inodes on the unlinked
list, and log recovery doesn't run the unlinked list processing in
that case.

This is one of the issues we'll need to fix for O_TMPFILE support
as it will actively use inodes on unlinked list for potentially long
periods of time.

> Taking a further look, I missed the XFS_TRANS_RESERVE flag and whole
> m_resblks mechanism. I'll take a closer look at that and see if that
> works to resolve the problem instead of the flush.

It should - the only time it won't is if we exhaust the pool, but
that doesn't happen in normal ENOSPC situations and any blocks we do
end up freeing will immediately refill the reserve pool...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
