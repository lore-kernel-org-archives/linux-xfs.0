Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 19 Oct 2008 20:16:26 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9K3GLWV029993
	for <xfs@oss.sgi.com>; Sun, 19 Oct 2008 20:16:23 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8B0B1519920
	for <xfs@oss.sgi.com>; Sun, 19 Oct 2008 20:18:05 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id 3onnJpbrcDSKM9Al for <xfs@oss.sgi.com>; Sun, 19 Oct 2008 20:18:05 -0700 (PDT)
Date: Mon, 20 Oct 2008 14:17:57 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Re: another problem with latest code drops
Message-ID: <20081020031757.GM31761@disturbed>
References: <20081016060247.GF25906@disturbed> <48F6EF7F.4070008@sgi.com> <20081016072019.GH25906@disturbed> <48F6FCB7.6050905@sgi.com> <20081016222904.GA31761@disturbed> <48F7E7BA.4070209@sgi.com> <20081017012141.GJ25906@disturbed> <20081017020434.GD31761@disturbed> <20081017020718.GE31761@disturbed> <48FBEED9.30609@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48FBEED9.30609@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Mon, Oct 20, 2008 at 12:37:13PM +1000, Lachlan McIlroy wrote:
> Dave Chinner wrote:
>> On Fri, Oct 17, 2008 at 01:04:34PM +1100, Dave Chinner wrote:
>>> On Fri, Oct 17, 2008 at 12:21:41PM +1100, Dave Chinner wrote:
>>>> On Fri, Oct 17, 2008 at 11:17:46AM +1000, Lachlan McIlroy wrote:
>>>>> Dave Chinner wrote:
>>>>>>> I am seeing a lot of memory used here though:
>>>>>>>
>>>>>>> 116605669 116605669  26%    0.23K 6859157       17  27436628K selinux_inode_security
>>>>>> Ah - I don't run selinux. Sounds like a bug that needs reporting
>>>>>> to lkml...
>>>>> I'm sure this is caused by your changes that introduced inode_init_always().
>>>>> It re-initialises an existing inode without destroying it first so it calls
>>>>> security_inode_alloc() without calling security_inode_free().
>>>> I can't think of how. The layers above XFS are symmetric:
>>> .....
>>>> And we should have this symmetry everywhere.
>>>>
>>>> <thinks for a bit>
>>>>
>>>> Hmmmm - maybe the xfs_iget_cache_miss failure paths where we call
>>>> xfs_idestroy() could leak contexts. We should really call xfs_iput()
>>>> because we have an initialised linux inode at this point and so
>>>> we need to go through destroy_inode(). I'll have a bit more of
>>>> a look, but this doesn't seem to account for the huge number of
>>>> leaked contexts you reported....
>>> Patch below that replaces xfs_idestroy() with IRELE() to destroy
>>> the inode via the normal iput() path. It also fixes a second issue
>>> that I found by inspection related to security contexts as a result
>>> of hooking up ->destroy_inode.
>>>
>>> It's running QA now.
>>>
>>> FWIW, I'm not sure if this patch will apply cleanly - I'm still
>>> running of my stack of patches and not what has been checked into
>>> ptools. Any idea of when all the patches in ptools will be pushed
>>> out to the git tree?
>>
>> And now with the patch.
>
> Nope, that didn't help.  The system still leaks - and at the same
> apparent rate too.

I didn't fix xfs_iread() properly - it still calls xfs_idestroy()
directly rather than dropping reference counts. Updated patch below
that should fix this.

> I also hit this panic where we have taken a reference on an inode
> that has I_CLEAR set.  I suspect we've made it into xfs_iget_cache_hit()

I don't think there is an iput() in that path.  The only iput() call
should be the IRELE() I added to xfs_iget_cache_miss(). Can you make
sure the compiler is not inlining functions so we can pin-point
where the iput() call is coming from? (i.e. static > STATIC on the
hit/miss functions)

> and found an inode with XFS_IRECLAIMABLE set and since we don't call
> igrab() we don't do the I_CLEAR check.

In that case, we call inode_init_always() instead which sets the
state to I_NEW and the reference count to 1. In the error case,
the inode will have already been freed and we make

> I'm not really convinced that
> activating dead inodes is such a good idea.

By the time the XFS_IRECLAIMABLE flag is set, I_CLEAR has been set
on the VFS inode. It is safe to re-use the inode at this point as
the VFS inode has been "destroyed" and hence all we need to do is
re-initialise it. We've always done this for inodes in reclaim so
we don't have to re-read them off disk...

Cheers,

Dave.
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

Version 2:
o use reference counted destroys in xfs_iread() instead of
  xfs_idestroy() calls as well.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_iget.c  |    9 ++++++++-
 fs/xfs/xfs_inode.c |   46 ++++++++++++++++++++++++++++------------------
 2 files changed, 36 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/xfs_iget.c b/fs/xfs/xfs_iget.c
index a1f209b..bf41ae4 100644
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
index c83f699..920a0ae 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -813,14 +813,6 @@ xfs_inode_alloc(
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
@@ -860,6 +852,17 @@ xfs_inode_alloc(
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
 
@@ -897,18 +900,16 @@ xfs_iread(
 	 * know that this is a new incore inode.
 	 */
 	error = xfs_itobp(mp, tp, ip, &dip, &bp, bno, imap_flags, XFS_BUF_LOCK);
-	if (error) {
-		xfs_idestroy(ip);
-		return error;
-	}
+	if (error)
+		goto out_error;
+
 
 	/*
 	 * If we got something that isn't an inode it means someone
 	 * (nfs or dmi) has a stale handle.
 	 */
 	if (be16_to_cpu(dip->di_core.di_magic) != XFS_DINODE_MAGIC) {
-		xfs_idestroy(ip);
-		xfs_trans_brelse(tp, bp);
+		error = EINVAL;
 #ifdef DEBUG
 		xfs_fs_cmn_err(CE_ALERT, mp, "xfs_iread: "
 				"dip->di_core.di_magic (0x%x) != "
@@ -916,7 +917,7 @@ xfs_iread(
 				be16_to_cpu(dip->di_core.di_magic),
 				XFS_DINODE_MAGIC);
 #endif /* DEBUG */
-		return XFS_ERROR(EINVAL);
+		goto out_error_relse;
 	}
 
 	/*
@@ -930,14 +931,12 @@ xfs_iread(
 		xfs_dinode_from_disk(&ip->i_d, &dip->di_core);
 		error = xfs_iformat(ip, dip);
 		if (error)  {
-			xfs_idestroy(ip);
-			xfs_trans_brelse(tp, bp);
 #ifdef DEBUG
 			xfs_fs_cmn_err(CE_ALERT, mp, "xfs_iread: "
 					"xfs_iformat() returned error %d",
 					error);
 #endif /* DEBUG */
-			return error;
+			goto out_error_relse;
 		}
 	} else {
 		ip->i_d.di_magic = be16_to_cpu(dip->di_core.di_magic);
@@ -1003,6 +1002,17 @@ xfs_iread(
 	xfs_trans_brelse(tp, bp);
 	*ipp = ip;
 	return 0;
+
+out_error_relse:
+	xfs_trans_brelse(tp, bp);
+out_error:
+	/*
+	 * As per xfs_iget_cache_miss(), we have a valid reference count on
+	 * the inode now so  need to destroy it by dropping the reference
+	 * count.
+	 */
+	IRELE(ip);
+	return XFS_ERROR(error);
 }
 
 /*
