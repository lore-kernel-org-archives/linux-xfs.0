Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46308 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750991AbeCTOVl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 20 Mar 2018 10:21:41 -0400
Date: Tue, 20 Mar 2018 10:21:40 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/2] xfs: don't shrink the inode cache until after setup
 completes
Message-ID: <20180320142140.GB6454@bfoster.bfoster>
References: <20180320050021.982-1-david@fromorbit.com>
 <20180320050021.982-3-david@fromorbit.com>
 <20180320120820.GB6107@bfoster.bfoster>
 <20180320132114.GS18129@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180320132114.GS18129@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Mar 21, 2018 at 12:21:14AM +1100, Dave Chinner wrote:
> On Tue, Mar 20, 2018 at 08:08:20AM -0400, Brian Foster wrote:
> > On Tue, Mar 20, 2018 at 04:00:21PM +1100, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > We recently came across an oops on a 4.14 kernel in
> > > xfs_reclaim_inodes_count() where sb->s_fs_info pointed to garbage
> > > and so the m_perag_tree lookup walked into lala land.
> > > 
> > > We found a mount in a failed state, blocked on teh shrinker rwsem
> > > here:
> > > 
> > > mount_bdev()
> > >   deactivate_locked_super()
> > >     unregister_shrinker()
> > > 
> > > Essentially, the machine was under memory pressure when the mount
> > > was being run, xfs_fs_fill_super() failed after allocating the
> > > xfs_mount and attaching it to sb->s_fs_info. It then cleaned up and
> > > freed the xfs_mount, but the sb->s_fs_info field still pointed to
> > > the freed memory. Hence when the superblock shrinker then ran
> > > it fell off the bad pointer.
> > > 
> > 
> > So this sounds like the root cause of the crash is a use after free and
> > not necessarily a "use before initialized," correct? I see that
> > ->m_perag_tree should be zeroed on allocation, but I have no idea if the
> > radix tree code is robust enough to deal with that.
> 
> Well, one symptom is use after free. It can also be used before it's
> initialised.
> 

Right.. but the user reproduced one was the use-after-free variant..?

> > > Setting sb->s_fs_info to NULL in this case won't solve the problem;
> > > we'll still crash on a null pointer in xfs_reclaim_inodes_count().
> > 
> > But the patch adds a NULL check..? I think this could be worded more
> > clearly.
> 
> Yes, that catches the case would have been a user after free. :)
> 

So what you're saying is that setting s_fs_info to NULL at least partly
solves the problem. ;P (But anyways, just wording confusion).

> > > The problem is that the superblock shrinker is running before the
> > > filesystem structures it depends on have been fully set up. i.e.
> > > the shrinker is registered in sget(), before ->fill_super() has been
> > > called, and the shrinker can call into the filesystem before
> > > fill_super() does it's setup work.
> > > 
> > > The twist here is that we need the sb shrinker to run in the XFS
> > > mount process because of the memory pressure that log recovery and
> > > quota check can create. Hence we need to prevent the indoe cache
> > > scanning from occurring until after we've set up the per-ag
> > > structures and caches that it depends on. We also need to ensure
> > > that we clear the flag and sb->s_fs_info on failure so that we
> > > can do the right thing in all cases in xfs_reclaim_inodes_count().
> > > 
> > 
> > Makes sense...
> > 
> > > Signed-Off-By: Dave Chinner <dchinner@redhat.com>
> > > ---
> > >  fs/xfs/xfs_mount.c | 2 ++
> > >  fs/xfs/xfs_mount.h | 1 +
> > >  fs/xfs/xfs_super.c | 9 +++++++++
> > >  3 files changed, 12 insertions(+)
> > > 
> > > diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> > > index 6f5a5e6764d8..35a263c90fc0 100644
> > > --- a/fs/xfs/xfs_mount.c
> > > +++ b/fs/xfs/xfs_mount.c
> > > @@ -155,6 +155,7 @@ xfs_free_perag(
> > >  	xfs_agnumber_t	agno;
> > >  	struct xfs_perag *pag;
> > >  
> > > +	mp->m_flags &= ~XFS_MOUNT_PERAG_DONE;
> > >  	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
> > >  		spin_lock(&mp->m_perag_lock);
> > >  		pag = radix_tree_delete(&mp->m_perag_tree, agno);
> > > @@ -244,6 +245,7 @@ xfs_initialize_perag(
> > >  		*maxagi = index;
> > >  
> > >  	mp->m_ag_prealloc_blocks = xfs_prealloc_blocks(mp);
> > > +	mp->m_flags |= XFS_MOUNT_PERAG_DONE;
> > 
> > But why not just move the radix tree root (and lock) initialization to
> > where the rest of the xfs_mount static structure initializations occur
> > (or at least the ones we expect to be accessible)? It looks to me that
> > intentionally occurs before the mp is attached to the superblock and
> > essentially fixes the problem the flag is trying to fix.
> 
> Could be done that way, but I still think we've got a general
> problem we need to deal with here. i.e. that we can't allow the
> shrinker to do anything until we actually initialised the parts of
> the xfs_mount that it uses.
> 

I actually think it might be useful to initialize the static/low-level
data structures (i.e., locks, radix bits, etc.) as such regardless.
There's only a couple places where we don't do that already (the perag
radix tree root being one), and that doesn't preclude higher level XFS
state management such as is being done by the XFS_MOUNT_PERAG_DONE flag,
if necessary. See the appended diff for reference.

I'm also wondering if there's value in doing a memset() (as your
previous patch) over the entire xfs_mount in DEBUG mode, immediately
after it's allocated, to facilitate catching this type of thing in the
future. That would require more of an audit to verify that we don't rely
on the kzalloc to correctly initialize certain fields (bools, ints,
etc.) though..

> I need to look further, because I think we're actually in a state
> where the shrinker scan cannot run at all during ->fill_super, which
> means we might actually be able to fix this at the VFS level by
> checking the SB_ACTIVE flag. I need to look a bit further on that,
> and if that's the case all this XFS stuff goes away....
> 

I'm pretty sure the dquot shrinker can run during quotacheck because we
had to make the previous delwri queue handling fixes to deal with that.
Though that shrinker is registered dynamically and so may have nothing
to do with the superblock inode shrinker for all I'm aware. Just a note,
FWIW.

Brian

--- 8< ---

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index a55f7a45fa78..53433cc024fd 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -731,7 +731,6 @@ xfs_sb_mount_common(
 	struct xfs_sb	*sbp)
 {
 	mp->m_agfrotor = mp->m_agirotor = 0;
-	spin_lock_init(&mp->m_agirotor_lock);
 	mp->m_maxagi = mp->m_sb.sb_agcount;
 	mp->m_blkbit_log = sbp->sb_blocklog + XFS_NBBYLOG;
 	mp->m_blkbb_log = sbp->sb_blocklog - BBSHIFT;
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 6f5a5e6764d8..a901b86772f8 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -817,8 +817,6 @@ xfs_mountfs(
 	/*
 	 * Allocate and initialize the per-ag data.
 	 */
-	spin_lock_init(&mp->m_perag_lock);
-	INIT_RADIX_TREE(&mp->m_perag_tree, GFP_ATOMIC);
 	error = xfs_initialize_perag(mp, sbp->sb_agcount, &mp->m_maxagi);
 	if (error) {
 		xfs_warn(mp, "Failed per-ag init: %d", error);
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 951271f57d00..3dd9544be9ec 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1579,29 +1579,44 @@ xfs_destroy_percpu_counters(
 	percpu_counter_destroy(&mp->m_fdblocks);
 }
 
-STATIC int
-xfs_fs_fill_super(
-	struct super_block	*sb,
-	void			*data,
-	int			silent)
+static struct xfs_mount *
+xfs_mount_alloc(
+	struct super_block	*sb)
 {
-	struct inode		*root;
-	struct xfs_mount	*mp = NULL;
-	int			flags = 0, error = -ENOMEM;
+	struct xfs_mount	*mp;
 
 	mp = kzalloc(sizeof(struct xfs_mount), GFP_KERNEL);
 	if (!mp)
-		goto out;
+		return NULL;
 
+	mp->m_super = sb;
 	spin_lock_init(&mp->m_sb_lock);
+	spin_lock_init(&mp->m_agirotor_lock);
+	INIT_RADIX_TREE(&mp->m_perag_tree, GFP_ATOMIC);
+	spin_lock_init(&mp->m_perag_lock);
 	mutex_init(&mp->m_growlock);
 	atomic_set(&mp->m_active_trans, 0);
 	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
 	INIT_DELAYED_WORK(&mp->m_eofblocks_work, xfs_eofblocks_worker);
 	INIT_DELAYED_WORK(&mp->m_cowblocks_work, xfs_cowblocks_worker);
 	mp->m_kobj.kobject.kset = xfs_kset;
+	return mp;
+}
 
-	mp->m_super = sb;
+
+STATIC int
+xfs_fs_fill_super(
+	struct super_block	*sb,
+	void			*data,
+	int			silent)
+{
+	struct inode		*root;
+	struct xfs_mount	*mp = NULL;
+	int			flags = 0, error = -ENOMEM;
+
+	mp = xfs_mount_alloc(sb);
+	if (!mp)
+		goto out;
 	sb->s_fs_info = mp;
 
 	error = xfs_parseargs(mp, (char *)data);
