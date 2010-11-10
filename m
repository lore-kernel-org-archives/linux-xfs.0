Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAA6J72I200012 for <xfs@oss.sgi.com>; Wed, 10 Nov 2010 00:19:07 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 51CEB13A5925
	for <xfs@oss.sgi.com>; Tue,  9 Nov 2010 22:20:33 -0800 (PST)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	wTc0zDjH6332635S for <xfs@oss.sgi.com>;
	Tue, 09 Nov 2010 22:20:33 -0800 (PST)
Date: Wed, 10 Nov 2010 17:20:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 07/16] xfs: convert inode cache lookups to use RCU locking
Message-ID: <20101110062025.GT2715@dastard>
References: <1289206519-18377-1-git-send-email-david@fromorbit.com>
	<1289206519-18377-8-git-send-email-david@fromorbit.com>
	<20101108230929.GA13299@infradead.org>
	<20101109033628.GN4032@linux.vnet.ibm.com>
	<20101109050417.GI2715@dastard>
	<20101110051242.GH4032@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101110051242.GH4032@linux.vnet.ibm.com>
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
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, eric.dumazet@gmail.com, xfs@oss.sgi.com

On Tue, Nov 09, 2010 at 09:12:42PM -0800, Paul E. McKenney wrote:
> On Tue, Nov 09, 2010 at 04:04:17PM +1100, Dave Chinner wrote:
> > On Mon, Nov 08, 2010 at 07:36:28PM -0800, Paul E. McKenney wrote:
> > > On Mon, Nov 08, 2010 at 06:09:29PM -0500, Christoph Hellwig wrote:
> > > > This patch generally looks good to me, but with so much RCU magic I'd prefer
> > > > if Paul & Eric could look over it.
> > > 
> > > Is there a git tree, tarball, or whatever? 
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/dgc/xfsdev.git working
> 
> Thank you -- I have downloaded this and will look it over.

fs/xfs/xfs_iget.c is the place to start - that's where the inode
cache lookups occur...

> Once the C++ guys get done grilling me on memory-model issues...
> 
> > contains the series that this patch is in.
> > 
> > > For example, I don't see
> > > how this patch handles the case of an inode being freed just as an RCU
> > > reader gains a reference to it,
> > 
> > XFS_IRECLAIM flag is set on inodes as they transition into the
> > reclaim state long before they are freed. The XFS_IRECLAIM flag is left there once
> > freed. Hence lookups in xfs_iget_cache_hit() will see this.
> > 
> > If the inode has been reallocated, the inode number will not yet be
> > set, or the inode state will have changed to XFS_INEW, both of which
> > xfs_iget_cache_hit() will also reject.
> > 
> > > but then reallocated as some other inode
> > > (so that ->ino is nonzero) before the RCU reader gets a chance to actually
> > > look at the inode.
> > 
> > XFS_INEW is not cleared until well after a new ->i_ino is set, so
> > the lookup should find trip over XFS_INEW in that case. I think that
> > I may need to move the inode number check under the i_flags_lock
> > after validating the flags - more to check that we've got the
> > correct inode than to validate we have a freed inode.
> 
> OK, this sounds promising.  Of course, the next question is "how quickly
> can the inode number be available for reuse?"

Immediately. Indeed, an inode number can be reused even before the
inode is reclaimed.  However, looking at the case of having already
freed the inode when the new lookup comes in, I think checking
everything under the i_flags_lock is safe.

That is, if we've freed inode #X (@ &A) and find &A during the RCU
protected lookup for inode #X, the only way the inode number in the
structure at &A would match #X is that if the new #X was reallocated
at &A again.  In that case, if the inode wasn't fully set up, we'd
find either XFS_INEW|XFS_IRECLAIM still set on it and we'd back off
and try the lookup again. However, if inode #X was reallocated at
address &B then the inode at &A would not match #X regardless of
whether &A had been reallocated or not.

Hence I think checking the inode number under the i_flags_lock after
checking XFS_INEW|XFS_IRECLAIM are not set is sufficient to validate
we have both an active inode and the correct inode.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
