Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 18 Oct 2006 02:08:08 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k9I97vaG012625
	for <xfs@oss.sgi.com>; Wed, 18 Oct 2006 02:08:01 -0700
Date: Wed, 18 Oct 2006 19:07:01 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [patch] Fix xfs_iunpin() sets I_DIRTY_SYNC after clear_inode().
Message-ID: <20061018090701.GU11034@melbourne.sgi.com>
References: <45237CCE.4010007@ah.jp.nec.com> <20061006032617.GC11034@melbourne.sgi.com> <20061011064357.GN19345@melbourne.sgi.com> <452E32FF.8010109@ah.jp.nec.com> <20061013014651.GC19345@melbourne.sgi.com> <452F83BD.8050501@ah.jp.nec.com> <20061017020218.GE8394166@melbourne.sgi.com> <20061018023325.GL8394166@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20061018023325.GL8394166@melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Takenori Nagano <t-nagano@ah.jp.nec.com>
Cc: xfs@oss.sgi.com

On Wed, Oct 18, 2006 at 12:33:25PM +1000, David Chinner wrote:
> On Tue, Oct 17, 2006 at 12:02:18PM +1000, David Chinner wrote:
> > So, here's another patch that doesn't have the performance problems,
> > but removes the iput/igrab while still (I think) fixing the use
> > after free problem. Can you try this one out, Takenori? I've
> > run it through some stress tests and haven't been able to trigger
> > problems.
> 
> I just hit the BUG_ON(vp == NULL) that I put in xfs_iunpin()
> in this patch. The xfs inode had no link to the bhv_vnode, nor
> did it have either XFS_IRECLAIM* flag set, and hence it triggered
> the BUG.

And again. The xfs_iget_core change is valid - there's still a
race in xfs_iunpin (how many of them can we find?):

   xfs_iunpin				xfs_iget_core
   if(atomic_dec_and_test(pincount))
					if (vp == NULL)
					   if(IRECLAIMABLE)
					       if(pincount)
					    	   force+restart
					   .....
					   clear IRECLAIMABLE

   	spin_lock(i_flags_lock)
	If (IRECLAIMABLE)
		BUG_ON(vp == NULL)


So the solution is this:

---
 fs/xfs/xfs_inode.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/xfs_inode.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_inode.c	2006-10-18 11:27:04.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_inode.c	2006-10-18 16:45:12.658102093 +1000
@@ -2738,7 +2738,7 @@ xfs_iunpin(
 {
 	ASSERT(atomic_read(&ip->i_pincount) > 0);
 
-	if (atomic_dec_and_test(&ip->i_pincount)) {
+	if (atomic_dec_and_lock(&ip->i_pincount, &ip->i_flags_lock)) {
 
 		/*
 		 * If the inode is currently being reclaimed, the link between
@@ -2757,7 +2757,6 @@ xfs_iunpin(
 		 * unpinned.
 		 */
 
-		spin_lock(&ip->i_flags_lock);
 		if (!__xfs_iflags_test(ip, XFS_IRECLAIM|XFS_IRECLAIMABLE)) {
 			bhv_vnode_t	*vp = XFS_ITOV_NULL(ip);
 			struct inode *inode = NULL;

I'm running stress tests on this now - it it survives until morning
I'll send out a new set of patches for testing...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
