Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D901929E19
	for <xfs@oss.sgi.com>; Wed, 18 Sep 2013 17:51:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6A183AC004
	for <xfs@oss.sgi.com>; Wed, 18 Sep 2013 15:51:30 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	QB7hfcVZbYIruwK7 for <xfs@oss.sgi.com>;
	Wed, 18 Sep 2013 15:51:25 -0700 (PDT)
Date: Thu, 19 Sep 2013 08:51:20 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] xfs: push down inactive transaction mgmt for remote
	symlinks
Message-ID: <20130918225120.GC9901@dastard>
References: <1379520960-22972-1-git-send-email-bfoster@redhat.com>
	<1379520960-22972-2-git-send-email-bfoster@redhat.com>
	<5239EBA2.4070207@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5239EBA2.4070207@redhat.com>
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

On Wed, Sep 18, 2013 at 02:06:26PM -0400, Brian Foster wrote:
> On 09/18/2013 12:15 PM, Brian Foster wrote:
> > Push down the transaction management for remote symlinks from
> > xfs_inactive() down to xfs_inactive_symlink_rmt(). The latter is
> > cleaned up to avoid transaction management intended for the
> > calling context (i.e., trans duplication, reservation, item
> > attachment).
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/xfs_inode.c   | 15 ++++++------
> >  fs/xfs/xfs_symlink.c | 64 ++++++++++++++++++----------------------------------
> >  fs/xfs/xfs_symlink.h |  2 +-
> >  3 files changed, 31 insertions(+), 50 deletions(-)
> > 
> ...
> > diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> > index f622a97..f85f6f2 100644
> > --- a/fs/xfs/xfs_symlink.c
> > +++ b/fs/xfs/xfs_symlink.c
> > @@ -424,8 +424,7 @@ xfs_symlink(
> >   */
> ...
> >  
> > @@ -563,16 +546,13 @@ xfs_inactive_symlink_rmt(
> >   */
> >  int
> >  xfs_inactive_symlink(
> > -	struct xfs_inode	*ip,
> > -	struct xfs_trans	**tp)
> > +	struct xfs_inode	*ip)
> >  {
> >  	struct xfs_mount	*mp = ip->i_mount;
> >  	int			pathlen;
> >  
> >  	trace_xfs_inactive_symlink(ip);
> >  
> > -	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
> > -
> 
> I just want to call out one thing here in case it isn't noticed on
> review... the safety of this is something I was curious about.
> Specifically, note that I've removed the inode locking from
> xfs_inactive(), which previously covered xfs_inactive_symlink() (for
> xfs_idata_realloc()), down into xfs_inactive_symlink_rmt().

see my comments about idata_realloc() in the previous email. It
might be safe, but it's better not to leave a landmine if we add
some other caller to the function in the future.

> My assumption was that this is currently ok since at this point we have
> an inode with di_nlink == 0.

It's not an entirely correct assumption. The end result is likely
the same, but di_nlink has no influence here. i.e. the inode
lifecycle is rather complex and there is an interesting condition
that covers inodes going through xfs_inactive().

xfs_inactive() is called when the VFS reference count goes to zero
and the VFS inode is being reclaimed, but the XFS_IRECLAIMABLE flag
is not yet set on it. This doesn't happen until after xfs_inactive()
completes and the VFS calls ->destroy_inode. Hence the inode is in a
limbo state where calls to igrab() will fail but the inode can be
found in the inode radix trees without being marked as "under
reclaim conditions".

We handle this with xfs_iget_cache_hit() by the use of igrab(),
which will fail on such an inode, and we use the same logic in
xfs_inode_ag_walk_grab() to avoid this hole. That said,
xfs_reclaim_inode_grab() does no such thing - it only checks for
XFS_IRECLAIMABLE under an RCU traversal, and so may find inodes for
which that the radix tree reclaimable tag is stale. hence that
check is always done under a spinlock.

IOWs, the only thing that protects us from outside interference in
xfs_inactive() is the logic in the XFS inode cache lookups
specifically avoiding inodes in the transient state that
xfs_inactive() is called under. It doesn't matter what the contents
of the inode are - it's the safe transition from one lifecycle state
to the next that is important at this point.

So, like I said in the previous email, we have to be careful with
cache lookups to prevent races with the work xfs_inactive() is
doing, but that doesn't mean we shouldn't still lock the inodes
correctly when modifying them...

> If that's not accurate or not expected to
> remain so after O_TMPFILE related work, I suppose I could pull the
> locking back up into xfs_inactive_symlink().

O_TMPFILE itself won't change anything - they will look just like
any other unlinked inode going through xfs_inactive() on their way
to the XFS_IRECLAIMABLE state.

It's when we start separating the xfs_inactive() work into multiple
distinct stages to allow for optimisation of inode freeing that we
need to be careful as these introduce new states into the lifecycle
state machine. These will most likely involve new state flags and
radix tree tags and walks, but AFAICT, overall concept that
xfs_inactive/xfs_inactive_symlink is run from the same special
isolated "limbo" context should not change....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
