Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA952wMJ135749 for <xfs@oss.sgi.com>; Mon, 8 Nov 2010 23:02:59 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E653F164DE2
	for <xfs@oss.sgi.com>; Mon,  8 Nov 2010 21:04:24 -0800 (PST)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	UzE5zzirSSn7Pixc for <xfs@oss.sgi.com>;
	Mon, 08 Nov 2010 21:04:24 -0800 (PST)
Date: Tue, 9 Nov 2010 16:04:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 07/16] xfs: convert inode cache lookups to use RCU locking
Message-ID: <20101109050417.GI2715@dastard>
References: <1289206519-18377-1-git-send-email-david@fromorbit.com>
	<1289206519-18377-8-git-send-email-david@fromorbit.com>
	<20101108230929.GA13299@infradead.org>
	<20101109033628.GN4032@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101109033628.GN4032@linux.vnet.ibm.com>
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

On Mon, Nov 08, 2010 at 07:36:28PM -0800, Paul E. McKenney wrote:
> On Mon, Nov 08, 2010 at 06:09:29PM -0500, Christoph Hellwig wrote:
> > This patch generally looks good to me, but with so much RCU magic I'd prefer
> > if Paul & Eric could look over it.
> 
> Is there a git tree, tarball, or whatever? 

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/xfsdev.git working

contains the series that this patch is in.

> For example, I don't see
> how this patch handles the case of an inode being freed just as an RCU
> reader gains a reference to it,

XFS_IRECLAIM flag is set on inodes as they transition into the
reclaim state long before they are freed. The XFS_IRECLAIM flag is left there once
freed. Hence lookups in xfs_iget_cache_hit() will see this.

If the inode has been reallocated, the inode number will not yet be
set, or the inode state will have changed to XFS_INEW, both of which
xfs_iget_cache_hit() will also reject.

> but then reallocated as some other inode
> (so that ->ino is nonzero) before the RCU reader gets a chance to actually
> look at the inode.

XFS_INEW is not cleared until well after a new ->i_ino is set, so
the lookup should find trip over XFS_INEW in that case. I think that
I may need to move the inode number check under the i_flags_lock
after validating the flags - more to check that we've got the
correct inode than to validate we have a freed inode.

> But such a check might well be in the code that this
> patch didn't change...

Yeah, most of the XFS code is already in a form compatible with such
RCU use because inodes have always had a quiescent "reclaimable"
state between active and reclaim (XFS_INEW -> active ->
XFS_IRECLAIMABLE -> XFS_IRECLAIM) where the inode can be reused
before being freed. The result is that lookups have always had to
handle races with inodes that have just transitioned into the
XFS_IRECLAIM state and hence cannot be immediately reused...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
