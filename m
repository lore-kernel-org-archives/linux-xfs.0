Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 19 Oct 2008 22:27:55 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9K5Ro6Z014150
	for <xfs@oss.sgi.com>; Sun, 19 Oct 2008 22:27:51 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0091D519FD4
	for <xfs@oss.sgi.com>; Sun, 19 Oct 2008 22:29:33 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id PbiKeLhih1Bivg1F for <xfs@oss.sgi.com>; Sun, 19 Oct 2008 22:29:33 -0700 (PDT)
Date: Mon, 20 Oct 2008 16:29:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Re: another problem with latest code drops
Message-ID: <20081020052929.GN31761@disturbed>
References: <20081016072019.GH25906@disturbed> <48F6FCB7.6050905@sgi.com> <20081016222904.GA31761@disturbed> <48F7E7BA.4070209@sgi.com> <20081017012141.GJ25906@disturbed> <20081017020434.GD31761@disturbed> <20081017020718.GE31761@disturbed> <48FBEED9.30609@sgi.com> <20081020031757.GM31761@disturbed> <48FC0B16.9090102@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <48FC0B16.9090102@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Mon, Oct 20, 2008 at 02:37:42PM +1000, Lachlan McIlroy wrote:
> Dave Chinner wrote:
>> On Mon, Oct 20, 2008 at 12:37:13PM +1000, Lachlan McIlroy wrote:
>>> I also hit this panic where we have taken a reference on an inode
>>> that has I_CLEAR set.  I suspect we've made it into xfs_iget_cache_hit()
>>
>> I don't think there is an iput() in that path.  The only iput() call
>> should be the IRELE() I added to xfs_iget_cache_miss(). Can you make
>> sure the compiler is not inlining functions so we can pin-point
>> where the iput() call is coming from? (i.e. static > STATIC on the
>> hit/miss functions)
> Just disassembled xfs_iget() and xfs_iget_cache_miss() has been inlined
> and we're calling the IRELE() at the end of that function.

Ok, that makes more sense.

>>> and found an inode with XFS_IRECLAIMABLE set and since we don't call
>>> igrab() we don't do the I_CLEAR check.
>>
>> In that case, we call inode_init_always() instead which sets the
>> state to I_NEW and the reference count to 1. In the error case,
>> the inode will have already been freed and we make
> We don't set inode->i_state to i_NEW.  We're stuffing XFS_INEW into
> the XFS inode's i_flags field and not removing the I_CLEAR from the
> linux inode.  Note that inode_init_always() doesn't touch i_state.

Yeah, xfs_setup_inode() is what is doing:

	inode->i_state = I_NEW|I_LOCK;

which happens after the cache miss has been processed.

Ok, so the initialisation code needs to clear іnode->i_state
during allocation so that iput() does not complain. The i_state
field is not accessed by anything until the inode is inserted
into the superblock lists, so it should be safe to zero it
in xfs_inode_alloc(). I missed that new_inode() returns an
inode with a zeroed i_state....

Updated patch below, just starting a QA run on it.

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

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
Version 3:
o initialise i_state early so that we don't trip a BUG in iput()
  when destroying an inode due to a failed initialisation.

Version 2:
o use reference counted destroys in xfs_iread() instead of
  xfs_idestroy() calls as well.

 fs/xfs/xfs_iget.c  |    9 ++++++++-
 fs/xfs/xfs_inode.c |   50 ++++++++++++++++++++++++++++++++------------------
 2 files changed, 40 insertions(+), 19 deletions(-)

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
index c83f699..d9ffd55 100644
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
@@ -860,6 +852,21 @@ xfs_inode_alloc(
 	ip->i_dir_trace = ktrace_alloc(XFS_DIR2_KTRACE_SIZE, KM_NOFS);
 #endif
 
+	/*
+	 * Now initialise the VFS inode. We do this after the xfs_inode
+	 * initialisation as internal failures will result in ->destroy_inode
+	 * being called and that will pass down through the reclaim path and
+	 * free the XFS inode. This path requires the XFS inode to already be
+	 * initialised. Hence if this call fails, the xfs_inode has already
+	 * been freed and we should not reference it at all in the error
+	 * handling. Note that we need to manually initialise the VFS inode
+	 * state to prevent triggering a BUG in iput() if we fail the inode
+	 * instantiation later on.
+	 */
+	if (!inode_init_always(mp->m_super, VFS_I(ip)))
+		return NULL;
+	VFS_I(ip)->i_state = 0;
+
 	return ip;
 }
 
@@ -897,18 +904,16 @@ xfs_iread(
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
@@ -916,7 +921,7 @@ xfs_iread(
 				be16_to_cpu(dip->di_core.di_magic),
 				XFS_DINODE_MAGIC);
 #endif /* DEBUG */
-		return XFS_ERROR(EINVAL);
+		goto out_error_relse;
 	}
 
 	/*
@@ -930,14 +935,12 @@ xfs_iread(
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
@@ -1003,6 +1006,17 @@ xfs_iread(
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
