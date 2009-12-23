Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBNM8FSN009988 for <xfs@oss.sgi.com>; Wed, 23 Dec 2009 16:08:15 -0600
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH 5/6] XFS: Replace per-ag array with a radix tree
Date: Wed, 23 Dec 2009 16:08:54 -0600
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE012A68D1@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <1260857477-2368-6-git-send-email-david@fromorbit.com>
From: "Alex Elder" <aelder@sgi.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Dave Chinner wrote:
> The use of an array for the per-ag structures requires reallocation of the
> array when growing the filesystem. This requires locking access to the array to
> avoid use after free situations, and the locking is difficult to get right. To
> avoid needing to reallocate an array, change the per-ag structures to an
> allocated object per ag and index them using a tree structure.
> 
> The AGs are always densely indexed (hence the use of an array), but the number
> supported is 2^32 and lookups tend to be random and hence indexing needs to
> scale. A simple choice is a radix tree - it works well with this sort of index.
> This change also removes another large contiguous allocation from the
> mount/growfs path in XFS.
> 
> The growing process now needs to change to only initialise the new AGs required
> for the extra space, and as such only needs to exclusively lock the tree for
> inserts. The rest of the code only needs to lock the tree while doing lookups,
> and hence this will remove all the deadlocks that currently occur on the
> m_perag_lock as it is now an innermost lock. The lock is also changed to a
> spinlock from a read/write lock as the hold time is now extremely short.
> 
> To complete the picture, the per-ag structures will need to be reference
> counted to ensure that we don't free/modify them while they are still in use.
> This will be done in subsequent patch.

In general, this looks good, and I especially like that you have added
some new comments to help explain what's going on in a few places.

I have a few concerns though, and I have some questions/suggestions below.

> Signed-off-by: Dave Chinner <david@fromorbit.com>
. . .
> diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
> index e61f2aa..914d00d 100644
> --- a/fs/xfs/xfs_filestream.c
> +++ b/fs/xfs/xfs_filestream.c
. . .
> @@ -456,10 +455,10 @@ xfs_filestream_unmount(
>  }
> 
>  /*
> - * If the mount point's m_perag array is going to be reallocated, all
> + * If the mount point's m_perag tree is going to be modified, all
>   * outstanding cache entries must be flushed to avoid accessing reference count
>   * addresses that have been freed.  The call to xfs_filestream_flush() must be
> - * made inside the block that holds the m_peraglock in write mode to do the
> + * made inside the block that holds the m_perag_lock in write mode to do the

Your change actually gets rid of the need to do this flush in the grow case
(which is great), so this comment is no longer pertinent and should be killed
off.

>   * reallocation.
>   */
>  void
. . .
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index a13919a..37a6f62 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -167,27 +167,14 @@ xfs_growfs_data_private(
>  	}
>  	new = nb - mp->m_sb.sb_dblocks;
>  	oagcount = mp->m_sb.sb_agcount;
> -	if (nagcount > oagcount) {
> -		void *new_perag, *old_perag;
> -
> -		xfs_filestream_flush(mp);
> -
> -		new_perag = kmem_zalloc(sizeof(xfs_perag_t) * nagcount,
> -					KM_MAYFAIL);
> -		if (!new_perag)
> -			return XFS_ERROR(ENOMEM);
> -
> -		down_write(&mp->m_peraglock);
> -		memcpy(new_perag, mp->m_perag, sizeof(xfs_perag_t) * oagcount);
> -		old_perag = mp->m_perag;
> -		mp->m_perag = new_perag;
> -
> -		mp->m_flags |= XFS_MOUNT_32BITINODES;

I'm not sure why this flag was getting set, but your change
does not implement this, at least not unconditionally.  (It
is getting set based on mp->m_flags in xfs_initialize_perag()).
Is that OK?

> -		nagimax = xfs_initialize_perag(mp, nagcount);
> -		up_write(&mp->m_peraglock);
> 
> -		kmem_free(old_perag);
> +	/* allocate the new per-ag structures */
> +	if (nagcount > oagcount) {

Maybe this occurs in another way, but in order to allow for the
incremental update I think something needs to be done to prevent
concurrent grow requests, possibly here.  (See more about this below.)

> +		error = xfs_initialize_perag(mp, nagcount, &nagimax);
> +		if (error)
> +			return error;
>  	}
> +
>  	tp = xfs_trans_alloc(mp, XFS_TRANS_GROWFS);
>  	tp->t_flags |= XFS_TRANS_RESERVE;
>  	if ((error = xfs_trans_reserve(tp, XFS_GROWFS_SPACE_RES(mp),
. . .
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 4739c2c..73d61d4 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -209,13 +209,16 @@ STATIC void
>  xfs_free_perag(
>  	xfs_mount_t	*mp)
>  {
> -	if (mp->m_perag) {
> -		int	agno;
> +	xfs_agnumber_t	agno;
> +	struct xfs_perag *pag;
> 
> -		for (agno = 0; agno < mp->m_maxagi; agno++)
> -			if (mp->m_perag[agno].pagb_list)
> -				kmem_free(mp->m_perag[agno].pagb_list);
> -		kmem_free(mp->m_perag);
> +	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {

Why do you switch to using m_sb.sb_agcount rather than mp->m_maxagi?
Can we get rid of the latter at some point, or is there a window
of time where it is possible and meaningful for them to be
different?  (The change is fine--I guess this is more like a
possibly unrelated question...)

> +		spin_lock(&mp->m_perag_lock);
> +		pag = radix_tree_delete(&mp->m_perag_tree, agno);
> +		spin_unlock(&mp->m_perag_lock);
> +		ASSERT(pag);
> +		kmem_free(pag->pagb_list);
> +		kmem_free(pag);
>  	}
>  }
> 
> @@ -389,10 +392,11 @@ xfs_initialize_perag_icache(
>  	}
>  }
> 
> -xfs_agnumber_t
> +int
>  xfs_initialize_perag(
>  	xfs_mount_t	*mp,
> -	xfs_agnumber_t	agcount)
> +	xfs_agnumber_t	agcount,
> +	xfs_agnumber_t	*maxagi)

Now that you're returning an errno...  If this function is
successful, it simply returns agcount in this location.  If
it fails, it returns nothing meaningful.  I'd say there is
no real need to have maxagi in the function definition any
more (though it may just be a convenience for the caller).

>  {
>  	xfs_agnumber_t	index, max_metadata;
>  	xfs_perag_t	*pag;
> @@ -405,6 +409,33 @@ xfs_initialize_perag(
>  	agino = XFS_OFFBNO_TO_AGINO(mp, sbp->sb_agblocks - 1, 0);
>  	ino = XFS_AGINO_TO_INO(mp, agcount - 1, agino);
> 
> +	/*
> +	 * Walk the current per-ag tree so we don't try to initialise AGs
> +	 * that already exist (growfs case). Allocate and insert all the
> +	 * AGs we don't find ready for initialisation.
> +	 */
> +	for (index = 0; index < agcount; index++) {
> +		pag = xfs_perag_get(mp, index);
> +		if (pag) {
> +			xfs_perag_put(pag);
> +			continue;
> +		}
> +		pag = kmem_zalloc(sizeof(*pag), KM_MAYFAIL);
> +		if (!pag)
> +			return -ENOMEM;

Suppose we're adding two AG's to the file system.  What if
the first one gets its per-ag structure successfully
inserted, and the second one fails.  Then the call to
xfs_initalize_perag() will fail but the mount struct's
perag information will not be consistent.  Neither
m_sb.sb_agcount nor mp->m_maxagi will reflect the presence
of this allocated perag structure, yet it could interfere
with subsequent attempts to grow the file system.  If
the index value were returned in *maxagi at this point
then maybe the caller could try to recover or something,
but I think logic to handle this case is better
incorporated/hidden in or under this function.

> +		if (radix_tree_preload(GFP_NOFS))
> +			return -ENOMEM;
> +		spin_lock(&mp->m_perag_lock);
> +		if (radix_tree_insert(&mp->m_perag_tree, index, pag)) {
> +			BUG();

There's a window between the xfs_perag_get() above and here in
which, if concurrent grows were allowed, the insert could fail.
This is why I said above that there needs to be protection from
concurrent grows.  Does that already get taken care of somewhere?

> +			spin_unlock(&mp->m_perag_lock);
> +			kmem_free(pag);
> +			return -EEXIST;
> +		}
> +		spin_unlock(&mp->m_perag_lock);
> +		radix_tree_preload_end();
> +	}
> +
>  	/* Clear the mount flag if no inode can overflow 32 bits
>  	 * on this filesystem, or if specifically requested..
>  	 */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
