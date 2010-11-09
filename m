Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA90NA11126365 for <xfs@oss.sgi.com>; Mon, 8 Nov 2010 18:23:11 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 04612139C71D
	for <xfs@oss.sgi.com>; Mon,  8 Nov 2010 16:24:36 -0800 (PST)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	4arZLCL9dZFxsgji for <xfs@oss.sgi.com>;
	Mon, 08 Nov 2010 16:24:36 -0800 (PST)
Date: Tue, 9 Nov 2010 11:24:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 07/16] xfs: convert inode cache lookups to use RCU locking
Message-ID: <20101109002425.GA2715@dastard>
References: <1289206519-18377-1-git-send-email-david@fromorbit.com>
	<1289206519-18377-8-git-send-email-david@fromorbit.com>
	<20101108230929.GA13299@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101108230929.GA13299@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: paulmck@linux.vnet.ibm.com, eric.dumazet@gmail.com, xfs@oss.sgi.com

On Mon, Nov 08, 2010 at 06:09:29PM -0500, Christoph Hellwig wrote:
> This patch generally looks good to me, but with so much RCU magic I'd prefer
> if Paul & Eric could look over it.
> 
> On Mon, Nov 08, 2010 at 07:55:10PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > With delayed logging greatly increasing the sustained parallelism of inode
> > operations, the inode cache locking is showing significant read vs write
> > contention when inode reclaim runs at the same time as lookups. There is
> > also a lot more write lock acquistions than there are read locks (4:1 ratio)
> > so the read locking is not really buying us much in the way of parallelism.
> > 
> > To avoid the read vs write contention, change the cache to use RCU locking on
> > the read side. To avoid needing to RCU free every single inode, use the built
> > in slab RCU freeing mechanism. This requires us to be able to detect lookups of
> > freed inodes, so en??ure that ever freed inode has an inode number of zero and
> > the XFS_IRECLAIM flag set. We already check the XFS_IRECLAIM flag in cache hit
> > lookup path, but also add a check for a zero inode number as well.
> > 
> > We canthen convert all the read locking lockups to use RCU read side locking
> > and hence remove all read side locking.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > Reviewed-by: Alex Elder <aelder@sgi.com>
> > ---
> >  fs/xfs/linux-2.6/xfs_iops.c    |    7 +++++-
> >  fs/xfs/linux-2.6/xfs_sync.c    |   13 +++++++++--
> >  fs/xfs/quota/xfs_qm_syscalls.c |    3 ++
> >  fs/xfs/xfs_iget.c              |   44 ++++++++++++++++++++++++++++++---------
> >  fs/xfs/xfs_inode.c             |   22 ++++++++++++-------
> >  5 files changed, 67 insertions(+), 22 deletions(-)
> > 
> > diff --git a/fs/xfs/linux-2.6/xfs_iops.c b/fs/xfs/linux-2.6/xfs_iops.c
> > index 8b46867..909bd9c 100644
> > --- a/fs/xfs/linux-2.6/xfs_iops.c
> > +++ b/fs/xfs/linux-2.6/xfs_iops.c
> > @@ -757,6 +757,8 @@ xfs_diflags_to_iflags(
> >   * We don't use the VFS inode hash for lookups anymore, so make the inode look
> >   * hashed to the VFS by faking it. This avoids needing to touch inode hash
> >   * locks in this path, but makes the VFS believe the inode is validly hashed.
> > + * We initialise i_state and i_hash under the i_lock so that we follow the same
> > + * setup rules that the rest of the VFS follows.
> >   */
> >  void
> >  xfs_setup_inode(
> > @@ -765,10 +767,13 @@ xfs_setup_inode(
> >  	struct inode		*inode = &ip->i_vnode;
> >  
> >  	inode->i_ino = ip->i_ino;
> > +
> > +	spin_lock(&inode->i_lock);
> >  	inode->i_state = I_NEW;
> > +	hlist_nulls_add_fake(&inode->i_hash);
> > +	spin_unlock(&inode->i_lock);
> 
> This screams for another VFS helper, even if it's XFS-specific for now.
> Having to duplicate inode.c-private locking rules in XFS seems a bit
> nasty to me.

Agreed. I was thinking that it would be a good idea to do this, but
I hadn't decided on how to do it yet....

> > diff --git a/fs/xfs/quota/xfs_qm_syscalls.c b/fs/xfs/quota/xfs_qm_syscalls.c
> > index bdebc18..8b207fc 100644
> > --- a/fs/xfs/quota/xfs_qm_syscalls.c
> > +++ b/fs/xfs/quota/xfs_qm_syscalls.c
> > @@ -875,6 +875,9 @@ xfs_dqrele_inode(
> >  	struct xfs_perag	*pag,
> >  	int			flags)
> >  {
> > +	if (!ip->i_ino)
> > +		return ENOENT;
> > +
> 
> Why do we need the check here again?  Having it in
> xfs_inode_ag_walk_grab should be enough.

Yes, you are right. I'll fix that.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
