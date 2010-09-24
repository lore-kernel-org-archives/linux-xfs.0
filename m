Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8O9EV86174394 for <xfs@oss.sgi.com>; Fri, 24 Sep 2010 04:14:32 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 92ADA14FB24A
	for <xfs@oss.sgi.com>; Fri, 24 Sep 2010 02:28:04 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	1QoA2EQ2utSOX6mr for <xfs@oss.sgi.com>;
	Fri, 24 Sep 2010 02:28:04 -0700 (PDT)
Date: Fri, 24 Sep 2010 19:15:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 12/16] xfs: implement batched inode lookups for AG walking
Message-ID: <20100924091522.GT2614@dastard>
References: <1285137869-10310-1-git-send-email-david@fromorbit.com>
	<1285137869-10310-13-git-send-email-david@fromorbit.com>
	<1285262225.1973.60.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1285262225.1973.60.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Sep 23, 2010 at 12:17:05PM -0500, Alex Elder wrote:
> On Wed, 2010-09-22 at 16:44 +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > With the reclaim code separated from the generic walking code, it is
> > simple to implement batched lookups for the generic walk code.
> > Separate out the inode validation from the execute operations and
> > modify the tree lookups to get a batch of inodes at a time.
> 
> Two comments below.  I noticed your discussion with Christoph
> so I'll look for the new version before I stamp it "reviewed."
> 
> > Reclaim operations will be optimised separately.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/linux-2.6/xfs_sync.c    |  104 +++++++++++++++++++++++-----------------
> >  fs/xfs/linux-2.6/xfs_sync.h    |    3 +-
> >  fs/xfs/quota/xfs_qm_syscalls.c |   26 +++++-----
> >  3 files changed, 75 insertions(+), 58 deletions(-)
> > 
> > diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
> > index 7737a13..227ecde 100644
> > --- a/fs/xfs/linux-2.6/xfs_sync.c
> > +++ b/fs/xfs/linux-2.6/xfs_sync.c
> > @@ -39,11 +39,19 @@
> >  #include <linux/kthread.h>
> >  #include <linux/freezer.h>
> >  
> > +/*
> > + * The inode lookup is done in batches to keep the amount of lock traffic and
> > + * radix tree lookups to a minimum. The batch size is a trade off between
> > + * lookup reduction and stack usage. This is in the reclaim path, so we can't
> > + * be too greedy.
> > + */
> > +#define XFS_LOOKUP_BATCH	32
> 
> Did you come up with 32 empirically?  As the OS evolves might another
> value be better?  And if a larger value would improve things, how
> would allocating the arrays rather than making them automatic (stack)
> affect things?  (Just a discussion point, I think it's fine as-is.)

It's a trade off between stack space and efficiency. It uses 256
bytes of stack space to reduce lock traffic by a factor fo 32. For
the rea side walks, stack space is not an issue because the call
paths are all shallow.

For the write side (reclaim) walks, we are in memory reclaim, so we
cannot rely on memory allocations, and we have relatively limited
stack space to work in. However we have much more contention on that
side, so the importance of large batches is higher.

Hence a batch size of 32 seems like a decent tradeoff between stack
usage and efficiency gains. We can't make it much larger because of
the reclaim path stack usage, we can't make it allocated because of
the reclaim path usage, and we can't make it much smaller otherwise
we don't get much improvement in efficiency....

> > +			if (done || grab(ip))
> > +				batch[i] = NULL;
> > +
> > +			/*
> > +			 * Update the index for the next lookup. Catch overflows
> > +			 * into the next AG range which can occur if we have inodes
> > +			 * in the last block of the AG and we are currently
> > +			 * pointing to the last inode.
> > +			 */
> > +			first_index = XFS_INO_TO_AGINO(mp, ip->i_ino + 1);
> > +			if (first_index < XFS_INO_TO_AGINO(mp, ip->i_ino))
> > +				done = 1;
> 
> It sounds like you're going to re-work this, but
> I'll mention this for you to consider anyway.  I
> don't know that the "done" flag here should be
> needed.

This check was added because if we don't detect the special case of
the last valid inode _number_ in the AG, first_index will loop back
to 0 and we'll start searching the AG again.  IOWs, we're not
looking for the last inode in the cache, we're looking for the last
valid inode number.

Hence the done flag is ensuring that:
	a) we terminate the walk at the last valid inode
	b) if there are inodes at indexes above the last valid inode
	number, we do not grab them or continue walking them.

Yes, b) should never happen, but I've had bugs in development code
that have put inodes in stange places before...

> The gang lookup should never return
> anything beyond the end of the AG.  It seems
> like you ought to be able to detect when you've
> covered all the whole AG elsewhere,

AFAICT, there are only two ways - the gang lookup returns nothing,
or we see the last valid inode number in the AG. If you can come up
with something that doesn't invlove a tree or inode number lookup,
I'm all ears....

> *not*
> on every entry found in this inner loop and
> also *not* while holding the lock.

It has to be done while holding the lock because if we cannot grab
the inode then the only way we can safely derefence the inode is
by still holding the inode cache lock. Once we drop the lock, the
inodes we failed to grab can be removed from the cache and we cannot
safely dereference them to get the inode number from them.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
