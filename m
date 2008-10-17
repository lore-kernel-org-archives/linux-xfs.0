Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 16 Oct 2008 19:05:44 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9H25dnI030271
	for <xfs@oss.sgi.com>; Thu, 16 Oct 2008 19:05:41 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2489A504B93
	for <xfs@oss.sgi.com>; Thu, 16 Oct 2008 19:07:22 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id UojzhpZC0vzLzqzG for <xfs@oss.sgi.com>; Thu, 16 Oct 2008 19:07:22 -0700 (PDT)
Date: Fri, 17 Oct 2008 13:07:18 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Re: another problem with latest code drops
Message-ID: <20081017020718.GE31761@disturbed>
References: <48F6A19D.9080900@sgi.com> <20081016060247.GF25906@disturbed> <48F6EF7F.4070008@sgi.com> <20081016072019.GH25906@disturbed> <48F6FCB7.6050905@sgi.com> <20081016222904.GA31761@disturbed> <48F7E7BA.4070209@sgi.com> <20081017012141.GJ25906@disturbed> <20081017020434.GD31761@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081017020434.GD31761@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Fri, Oct 17, 2008 at 01:04:34PM +1100, Dave Chinner wrote:
> On Fri, Oct 17, 2008 at 12:21:41PM +1100, Dave Chinner wrote:
> > On Fri, Oct 17, 2008 at 11:17:46AM +1000, Lachlan McIlroy wrote:
> > > Dave Chinner wrote:
> > >>> I am seeing a lot of memory used here though:
> > >>>
> > >>> 116605669 116605669  26%    0.23K 6859157       17  27436628K selinux_inode_security
> > >>
> > >> Ah - I don't run selinux. Sounds like a bug that needs reporting
> > >> to lkml...
> > >
> > > I'm sure this is caused by your changes that introduced inode_init_always().
> > > It re-initialises an existing inode without destroying it first so it calls
> > > security_inode_alloc() without calling security_inode_free().
> > 
> > I can't think of how. The layers above XFS are symmetric:
> .....
> > And we should have this symmetry everywhere.
> > 
> > <thinks for a bit>
> > 
> > Hmmmm - maybe the xfs_iget_cache_miss failure paths where we call
> > xfs_idestroy() could leak contexts. We should really call xfs_iput()
> > because we have an initialised linux inode at this point and so
> > we need to go through destroy_inode(). I'll have a bit more of
> > a look, but this doesn't seem to account for the huge number of
> > leaked contexts you reported....
> 
> Patch below that replaces xfs_idestroy() with IRELE() to destroy
> the inode via the normal iput() path. It also fixes a second issue
> that I found by inspection related to security contexts as a result
> of hooking up ->destroy_inode.
> 
> It's running QA now.
> 
> FWIW, I'm not sure if this patch will apply cleanly - I'm still
> running of my stack of patches and not what has been checked into
> ptools. Any idea of when all the patches in ptools will be pushed
> out to the git tree?

And now with the patch.
-- 
Dave Chinner
david@fromorbit.com

XFS: Ensure that we destroy the linux inode after initialisation

Now that XFS initialises the struct inode prior to completing
all checks and insertion into caches, we need to destroy that
state if we fail to instantiate the inode completely. Hence
we cannot just call xfs_idestroy() to clean up state when
such an occurrence happens - we need to go through the normal
reclaim path by dropping the reference count on the linux inode
we now hold. This will prevent leaking security contexts on
failed lookups.

Also, now that we have a ->destroy_inode() method, failing to
allocate a security context for the inode will result in the
xfs_inode being freed via the ->destroy_inode() path internally
to inode_init_always(). Rearrange xfs_inode_alloc() to initialise
the xfs_inode prior to attempting to initialise the VFS inode
so that the reclaim path will work and remove the freeing
of the inode in xfs_inode_alloc() if VFS inode initialisation
fails.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_iget.c  |    9 ++++++++-
 fs/xfs/xfs_inode.c |   19 +++++++++++--------
 2 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_iget.c b/fs/xfs/xfs_iget.c
index b34b732..29afe4e 100644
--- a/fs/xfs/xfs_iget.c
+++ b/fs/xfs/xfs_iget.c
@@ -197,7 +197,14 @@ out_unlock:
 	write_unlock(&pag->pag_ici_lock);
 	radix_tree_preload_end();
 out_destroy:
-	xfs_idestroy(ip);
+	/*
+	 * we've already initialised the linux inode, so we have a valid
+	 * reference count of 1 and so we cannot destroy the inode with
+	 * xfs_idestroy. Kill it by dropping the reference count to push
+	 * it through the normal reclaim path so that state on the linux
+	 * inode is also destroyed.
+	 */
+	IRELE(ip);
 	return error;
 }
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 17dbf24..7a2aaae 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -812,14 +812,6 @@ xfs_inode_alloc(
 	ASSERT(!spin_is_locked(&ip->i_flags_lock));
 	ASSERT(completion_done(&ip->i_flush));
 
-	/*
-	 * initialise the VFS inode here to get failures
-	 * out of the way early.
-	 */
-	if (!inode_init_always(mp->m_super, VFS_I(ip))) {
-		kmem_zone_free(xfs_inode_zone, ip);
-		return NULL;
-	}
 
 	/* initialise the xfs inode */
 	ip->i_ino = ino;
@@ -859,6 +851,17 @@ xfs_inode_alloc(
 	ip->i_dir_trace = ktrace_alloc(XFS_DIR2_KTRACE_SIZE, KM_NOFS);
 #endif
 
+	/*
+	 * Now initialise the VFS inode. We do this after the xfs_inode
+	 * initialisation as internal failures will result in ->destroy_inode
+	 * being called and that will pass down through the reclaim path and
+	 * free the XFS inode. This path requires the XFS inode to already be
+	 * initialised. Hence if this call fails, the xfs_inode has already
+	 * been freed and we should not reference it at all in the error
+	 * handling.
+	 */
+	if (!inode_init_always(mp->m_super, VFS_I(ip)))
+		return NULL;
 	return ip;
 }
 
