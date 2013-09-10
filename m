Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9BB997F53
	for <xfs@oss.sgi.com>; Tue, 10 Sep 2013 18:11:26 -0500 (CDT)
Date: Tue, 10 Sep 2013 18:11:22 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH v2] xfs: don't leak root inode reference
Message-ID: <20130910231122.GY1935@sgi.com>
References: <20130826204730.GZ7153@sgi.com> <20130826212423.GX6023@dastard>
	<20130827212558.GY5262@sgi.com> <20130827220833.GY6023@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130827220833.GY6023@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, xfs@oss.sgi.com

Hi Dave,

On Wed, Aug 28, 2013 at 08:08:33AM +1000, Dave Chinner wrote:
> On Tue, Aug 27, 2013 at 04:25:58PM -0500, Ben Myers wrote:
> > On Tue, Aug 27, 2013 at 07:24:23AM +1000, Dave Chinner wrote:
> > > On Mon, Aug 26, 2013 at 03:47:30PM -0500, Ben Myers wrote:
> > > > Looks like in 48fde701 we removed the iput of the root inode in
> > > > xfs_fs_fill_super for the error case.  Add it back.
> > > > 
> > > > Signed-off-by: Ben Myers <bpm@sgi.com>
> > > > 
> > > > ---
> > > >  fs/xfs/xfs_super.c |    6 ++++--
> > > >  1 file changed, 4 insertions(+), 2 deletions(-)
> > > > 
> > > > Index: b/fs/xfs/xfs_super.c
> > > > ===================================================================
> > > > --- a/fs/xfs/xfs_super.c	2013-08-26 15:36:09.170848579 -0500
> > > > +++ b/fs/xfs/xfs_super.c	2013-08-26 15:40:19.450817933 -0500
> > > > @@ -1493,12 +1493,12 @@ xfs_fs_fill_super(
> > > >  	}
> > > >  	if (is_bad_inode(root)) {
> > > >  		error = EINVAL;
> > > > -		goto out_unmount;
> > > > +		goto out_iput;
> > > >  	}
> > > >  	sb->s_root = d_make_root(root);
> > > >  	if (!sb->s_root) {
> > > >  		error = ENOMEM;
> > > > -		goto out_unmount;
> > > > +		goto out_iput;
> > > >  	}
> > > 
> > > That's wrong. d_make_root() drops the reference to the inode on
> > > failure itself, and so the change in 48fde701 is correct and valid.
> > > 
> > > The leak on bad inodes (which, AFAICT, can never happen on XFS) has
> > > been around a lot longer than Al's change - this commit introduced
> > > it:
> > > 
> > > 	2bcf6e9 xfs: start periodic workers later
> > > 
> > > with this hunk:
> > > 
> > >         if (is_bad_inode(root)) {
> > >                 error = EINVAL;
> > > -               goto fail_vnrele;
> > > +               goto out_syncd_stop;
> > >         }
> > 
> > Thanks Gents.  Here's another try:
> > 
> > xfs: don't leak root inode reference
> > 
> > Looks like in 2bcf6e9 we removed the iput of the root inode in
> > xfs_fs_fill_super for the is_bad_inode error case.  Add it back.
> > 
> > Signed-off-by: Ben Myers <bpm@sgi.com>
> 
> I don't think this is right, either.
> 
> As I said in my previous reply, I don't think that XFS can ever see
> a bad inode. The fact is that we're grabbing mp->m_rootip, which is
> we already have a reference to and is in cache and validated thanks
> to an xfs_iget() call in xfs_mountfs().  If we fail validation when
> reading the root inode into cache then xfs_mountfs() will fail and
> we won't ever get to this check.
> 
> Further, XFS never marks inodes bad - even on a failed lookup or a
> shut down filesystem - and so AFAICT we cannot ever see the root
> inode (or any other XFS inode) as a bad inode.
> 
> Hence I think that the is_bad_inode(root) check should just go away.

Ok.  Lets try this.  ;)

xfs: remove usage of is_bad_inode

XFS never calls mark_inode_bad or iget_failed, so it will never see a
bad inode.  Remove all checks for is_bad_inode because they are
unnecessary.

Signed-off-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/xfs_icache.c |    7 -------
 fs/xfs/xfs_inode.c  |    2 +-
 fs/xfs/xfs_super.c  |    9 ---------
 3 files changed, 1 insertion(+), 17 deletions(-)

Index: b/fs/xfs/xfs_icache.c
===================================================================
--- a/fs/xfs/xfs_icache.c	2013-09-10 14:55:38.574338256 -0500
+++ b/fs/xfs/xfs_icache.c	2013-09-10 14:56:09.514377472 -0500
@@ -501,11 +501,6 @@ xfs_inode_ag_walk_grab(
 	if (!igrab(inode))
 		return ENOENT;
 
-	if (is_bad_inode(inode)) {
-		IRELE(ip);
-		return ENOENT;
-	}
-
 	/* inode is valid */
 	return 0;
 
@@ -919,8 +914,6 @@ restart:
 		xfs_iflock(ip);
 	}
 
-	if (is_bad_inode(VFS_I(ip)))
-		goto reclaim;
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount)) {
 		xfs_iunpin_wait(ip);
 		xfs_iflush_abort(ip, false);
Index: b/fs/xfs/xfs_inode.c
===================================================================
--- a/fs/xfs/xfs_inode.c	2013-09-10 14:56:38.124337715 -0500
+++ b/fs/xfs/xfs_inode.c	2013-09-10 14:56:40.777424778 -0500
@@ -1687,7 +1687,7 @@ xfs_inactive(
 	 * If the inode is already free, then there can be nothing
 	 * to clean up here.
 	 */
-	if (ip->i_d.di_mode == 0 || is_bad_inode(VFS_I(ip))) {
+	if (ip->i_d.di_mode == 0) {
 		ASSERT(ip->i_df.if_real_bytes == 0);
 		ASSERT(ip->i_df.if_broot_bytes == 0);
 		return VN_INACTIVE_CACHE;
Index: b/fs/xfs/xfs_super.c
===================================================================
--- a/fs/xfs/xfs_super.c	2013-09-10 14:38:48.144338844 -0500
+++ b/fs/xfs/xfs_super.c	2013-09-10 14:57:06.793813184 -0500
@@ -946,10 +946,6 @@ xfs_fs_destroy_inode(
 
 	XFS_STATS_INC(vn_reclaim);
 
-	/* bad inode, get out here ASAP */
-	if (is_bad_inode(inode))
-		goto out_reclaim;
-
 	ASSERT(XFS_FORCED_SHUTDOWN(ip->i_mount) || ip->i_delayed_blks == 0);
 
 	/*
@@ -965,7 +961,6 @@ xfs_fs_destroy_inode(
 	 * this more efficiently than we can here, so simply let background
 	 * reclaim tear down all inodes.
 	 */
-out_reclaim:
 	xfs_inode_set_reclaim_tag(ip);
 }
 
@@ -1491,10 +1486,6 @@ xfs_fs_fill_super(
 		error = ENOENT;
 		goto out_unmount;
 	}
-	if (is_bad_inode(root)) {
-		error = EINVAL;
-		goto out_unmount;
-	}
 	sb->s_root = d_make_root(root);
 	if (!sb->s_root) {
 		error = ENOMEM;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
