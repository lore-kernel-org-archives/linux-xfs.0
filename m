Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6ENk5Eg171281 for <xfs@oss.sgi.com>; Wed, 14 Jul 2010 18:46:06 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A41BE15CD82E
	for <xfs@oss.sgi.com>; Wed, 14 Jul 2010 16:49:00 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	0C3i0h4goAFtZTys for <xfs@oss.sgi.com>;
	Wed, 14 Jul 2010 16:49:00 -0700 (PDT)
Date: Thu, 15 Jul 2010 09:48:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] XFS: _xfs_buf_find ignores XBF_DONT_BLOCK flag
Message-ID: <20100714234857.GD30737@dastard>
References: <1279134201-6890-1-git-send-email-treestem@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1279134201-6890-1-git-send-email-treestem@gmail.com>
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
To: Peter Watkins <treestem@gmail.com>
Cc: xfs@oss.sgi.com

On Wed, Jul 14, 2010 at 03:03:21PM -0400, Peter Watkins wrote:
> Hello again,
> 
> Occasionally, when one of our machines is under memory pressure and an "rm" 
> command is used, it will deadlock. Maybe someone familiar with the code can
> take a look.
> 
> In the trace below, it looks like kswapd was shrinking the inode cache, took 
> iprune_mutex, and while calling clear_inode on a list of inodes to dispose, 
> he blocked on an xfs_buf lock for the on-disk inode data.
> 
> Meanwhile "rm" is trying to read in the inode using xfs_iread, has the xfs_buf 
> locked, and is trying to allocate memory to copy the contents to an in-memory 
> inode. But that allocation makes a trip through shrink icache and blocks on the 
> iprune_mutex held by kswapd.
> 
> kswapd is calling a path in _xfs_buf_find which is ignoring the XBF_DONT_BLOCK 
> flag, even though that path seems fully prepared to fail if the buffer is locked.

I think you misunderstand what XBF_DONT_BLOCK is for - that's not
hard because it's not particularly well commented. FYI, it's to
prevent memory reclaim recursion back into the filesystem during
memory allocation in the buffer layer while we hold locked items.
The buffer cache implementation of the flag has changed over time
(originally an Irix flag, IIRC) so it doesn't quite describe what it
does on linux anymore.  See xb_to_gfp() and xb_to_km() to find out
what it triggers.

FWIW, if we wanted to avoid blocking on buffer locks, then we'd be
passing XBF_TRYLOCK....

> The patch is against 2.6.27, but it applies OK to "mainline" from kernel.org.
> 
> PID: 239    TASK: f7924b60  CPU: 0   COMMAND: "kswapd0"
>  #0 [f58adadc] schedule at c03abd22
>  #1 [f58adb38] schedule_timeout at c03ac4ec
>  #2 [f58adb80] __down at c03acc9a
>  #3 [f58adba4] down at c015690c
>  #4 [f58adbb4] xfs_buf_lock at f8de2912         not honoring the XBF_BUSY flag
>  #5 [f58adbc0] _xfs_buf_find at f8de2284
>  #6 [f58adbf4] xfs_buf_get_flags at f8de2357
>  #7 [f58adc1c] xfs_buf_read_flags at f8de245d   XFS_BUF_LOCK|BUF_BUSY ie don't block
>  #8 [f58adc34] xfs_trans_read_buf at f8dd74b5
>  #9 [f58adc5c] xfs_imap_to_bp at f8dbc575       get the locked xfs_buf for inode
> #10 [f58adc88] xfs_inotobp at f8dbc6db
> #11 [f58adcd0] xfs_iunlink_remove at f8dbeb86
> #12 [f58add38] xfs_ifree at f8dbf27a
> #13 [f58add78] xfs_inactive at f8ddb643
> #14 [f58addc4] xfs_fs_clear_inode at f8dea765
> #15 [f58adde4] clear_inode at c01d4099
> #16 [f58addf4] generic_delete_inode at c01d4ecd
> #17 [f58ade08] generic_drop_inode at c01d50af
> #18 [f58ade10] iput at c01d5115
> #19 [f58ade1c] gridfs_clear_inode at f8e4d67a
> #20 [f58adefc] balance_pgdat at c019ab1e        called shrink_icache/prune_icache/dispose_list
> #21 [f58adf78] kswapd at c019ad7f
> #22 [f58adfd0] kthread at c0151a82
> #23 [f58adfe4] kernel_thread_helper at c010aa55
> 
> 
> PID: 22357  TASK: f41d6480  CPU: 0   COMMAND: "rm"
>  #0 [e980d934] schedule at c03abd22
>  #1 [e980d990] __mutex_lock_slowpath at c03ac8d1
>  #2 [e980d9b8] mutex_lock at c03ac78d
>  #3 [e980d9c0] prune_icache at c01d437f
>  #4 [e980d9e8] shrink_icache_memory at c01d4537
>  #5 [e980d9f0] shrink_slab at c0198e57
>  #6 [e980da3c] do_try_to_free_pages at c019a698
>  #7 [e980da74] try_to_free_pages at c019a867
>  #8 [e980dac4] __alloc_pages_internal at c0194112
>  #9 [e980db10] allocate_slab at c01b8040
> #10 [e980db30] new_slab at c01b8122
> #11 [e980db50] __slab_alloc at c01b8769
> #12 [e980db70] kmem_cache_alloc at c01b88dd
> #13 [e980db90] kmem_zone_alloc at f8ddf9e9
> #14 [e980dbb4] kmem_zone_zalloc at f8ddfa38
> #15 [e980dbc8] xfs_iformat at f8dbca9a
> #16 [e980dc1c] xfs_iread at f8dbda96            did xfs_itobp to get locked xfs_buf
> #17 [e980dc50] xfs_iget_core at f8dbba2b
> #18 [e980dca0] xfs_iget at f8dbbf66
> #19 [e980dcd8] xfs_lookup at f8ddb9c1
> #20 [e980dd14] xfs_vn_lookup at f8de726b
> #21 [e980dd34] __lookup_hash at c01c89f3
> #22 [e980dd50] lookup_one_len at c01c8b07

Ok, so the problem here is that we are trying a memory allocation
with a locked inode buffer, and memory reclaim can trip over that
locked inode buffer and deadlock. That means we should not allow
allocation recursion from within xfs_iformat() even though we are
not in a tranaction context.

The following patch converts the allocations during inode
initialisation to use KM_NOFS. It applies to a 2.6.35-rc3 kernel,
but might apply to a 2.6.27 kernel. Can you test it?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: fix memory reclaim recursion deadlock on locked inode buffer

From: Dave Chinner <dchinner@redhat.com>

Calling into memory reclaim with a locked inode buffer can deadlock
if memory reclaim tries to lock the inode buffer during inode
teardown. Convert the relevant memory allocations to use KM_NOFS to
avoid this deadlock condition.

Reported-by: Peter Watkins <treestem@gmail.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_inode.c |   20 +++++++++++---------
 1 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 5715a9d..3c206b3 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -422,7 +422,7 @@ xfs_iformat(
 	if (!XFS_DFORK_Q(dip))
 		return 0;
 	ASSERT(ip->i_afp == NULL);
-	ip->i_afp = kmem_zone_zalloc(xfs_ifork_zone, KM_SLEEP);
+	ip->i_afp = kmem_zone_zalloc(xfs_ifork_zone, KM_SLEEP|KM_NOFS);
 	ip->i_afp->if_ext_max =
 		XFS_IFORK_ASIZE(ip) / (uint)sizeof(xfs_bmbt_rec_t);
 	switch (dip->di_aformat) {
@@ -505,7 +505,7 @@ xfs_iformat_local(
 		ifp->if_u1.if_data = ifp->if_u2.if_inline_data;
 	else {
 		real_size = roundup(size, 4);
-		ifp->if_u1.if_data = kmem_alloc(real_size, KM_SLEEP);
+		ifp->if_u1.if_data = kmem_alloc(real_size, KM_SLEEP|KM_NOFS);
 	}
 	ifp->if_bytes = size;
 	ifp->if_real_bytes = real_size;
@@ -632,7 +632,7 @@ xfs_iformat_btree(
 	}
 
 	ifp->if_broot_bytes = size;
-	ifp->if_broot = kmem_alloc(size, KM_SLEEP);
+	ifp->if_broot = kmem_alloc(size, KM_SLEEP|KM_NOFS);
 	ASSERT(ifp->if_broot != NULL);
 	/*
 	 * Copy and convert from the on-disk structure
@@ -2191,7 +2191,7 @@ xfs_iroot_realloc(
 		 */
 		if (ifp->if_broot_bytes == 0) {
 			new_size = (size_t)XFS_BMAP_BROOT_SPACE_CALC(rec_diff);
-			ifp->if_broot = kmem_alloc(new_size, KM_SLEEP);
+			ifp->if_broot = kmem_alloc(new_size, KM_SLEEP|KM_NOFS);
 			ifp->if_broot_bytes = (int)new_size;
 			return;
 		}
@@ -2207,7 +2207,7 @@ xfs_iroot_realloc(
 		new_size = (size_t)XFS_BMAP_BROOT_SPACE_CALC(new_max);
 		ifp->if_broot = kmem_realloc(ifp->if_broot, new_size,
 				(size_t)XFS_BMAP_BROOT_SPACE_CALC(cur_max), /* old size */
-				KM_SLEEP);
+				KM_SLEEP|KM_NOFS);
 		op = (char *)XFS_BMAP_BROOT_PTR_ADDR(mp, ifp->if_broot, 1,
 						     ifp->if_broot_bytes);
 		np = (char *)XFS_BMAP_BROOT_PTR_ADDR(mp, ifp->if_broot, 1,
@@ -2233,7 +2233,7 @@ xfs_iroot_realloc(
 	else
 		new_size = 0;
 	if (new_size > 0) {
-		new_broot = kmem_alloc(new_size, KM_SLEEP);
+		new_broot = kmem_alloc(new_size, KM_SLEEP|KM_NOFS);
 		/*
 		 * First copy over the btree block header.
 		 */
@@ -2337,7 +2337,8 @@ xfs_idata_realloc(
 		real_size = roundup(new_size, 4);
 		if (ifp->if_u1.if_data == NULL) {
 			ASSERT(ifp->if_real_bytes == 0);
-			ifp->if_u1.if_data = kmem_alloc(real_size, KM_SLEEP);
+			ifp->if_u1.if_data = kmem_alloc(real_size,
+							KM_SLEEP|KM_NOFS);
 		} else if (ifp->if_u1.if_data != ifp->if_u2.if_inline_data) {
 			/*
 			 * Only do the realloc if the underlying size
@@ -2348,11 +2349,12 @@ xfs_idata_realloc(
 					kmem_realloc(ifp->if_u1.if_data,
 							real_size,
 							ifp->if_real_bytes,
-							KM_SLEEP);
+							KM_SLEEP|KM_NOFS);
 			}
 		} else {
 			ASSERT(ifp->if_real_bytes == 0);
-			ifp->if_u1.if_data = kmem_alloc(real_size, KM_SLEEP);
+			ifp->if_u1.if_data = kmem_alloc(real_size,
+							KM_SLEEP|KM_NOFS);
 			memcpy(ifp->if_u1.if_data, ifp->if_u2.if_inline_data,
 				ifp->if_bytes);
 		}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
