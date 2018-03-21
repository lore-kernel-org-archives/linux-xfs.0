Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:33416 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751416AbeCUR1e (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Mar 2018 13:27:34 -0400
Date: Wed, 21 Mar 2018 10:27:28 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: clean up xfs_mount allocation and dynamic
 initializers
Message-ID: <20180321172728.GF4818@magnolia>
References: <20180321161325.12773-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180321161325.12773-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Mar 21, 2018 at 12:13:25PM -0400, Brian Foster wrote:
> Most of the generic data structures embedded in xfs_mount are
> dynamically initialized immediately after mp is allocated. A few
> fields are left out and initialized during the xfs_mountfs()
> sequence, after mp has been attached to the superblock.
> 
> To clean this up and help prevent premature access of associated
> fields, refactor xfs_mount allocation and all dependent init calls
> into a new helper. This self-documents that all low level data
> structures (i.e., locks, trees, etc.) should be initialized before
> xfs_mount is attached to the superblock.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
> 
> I realized after the fact that this steps on the ability to instrument
> the use-before-init variant[1] of the problematic radix tree access on
> failed mount issue that Dave tracked down. This is because we'd
> immediately initialize the structure and thus a subsequent memset()
> would ultimately require another proper initialization.

That's simply a matter of re-calling

	INIT_RADIX_TREE(&mp->m_perag_tree, GFP_ATOMIC);

after the msleep, right?

> As Dave noted in that thread, we could alternatively instrument the
> use-after-free variant of the problem with a post-free delay of the mp.
> I actually wonder if a last step instrumented failure in fill_super()
> might be a more broadly useful test because it provides future coverage
> of the entire mount teardown sequence rather than just the bad radix
> tree access.

That sounds like a very good idea, there's a lot of complex stuff that
has to be unwound and at least I've stumbled over getting it right.

> On the flipside, this patch isn't the cleanup of the century so I'd be
> fine with dropping it in favor of [1], but I think it's worthy enough to
> consider.
> 
> Brian
> 
> [1] https://marc.info/?l=linux-xfs&m=152152202700598&w=2
> 
>  fs/xfs/libxfs/xfs_sb.c |  1 -
>  fs/xfs/xfs_mount.c     |  2 --
>  fs/xfs/xfs_super.c     | 39 +++++++++++++++++++++++++++++----------
>  3 files changed, 29 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index a55f7a45fa78..53433cc024fd 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -731,7 +731,6 @@ xfs_sb_mount_common(
>  	struct xfs_sb	*sbp)
>  {
>  	mp->m_agfrotor = mp->m_agirotor = 0;

Can this be removed since we're using kzalloc now?

Mostly looks ok to me, though I wonder if the INIT_DONE flag can be
replaced with radix_tree_empty() now that we're guaranteed never to see
an mp with an uninitialized perag radix tree?

--D

> -	spin_lock_init(&mp->m_agirotor_lock);
>  	mp->m_maxagi = mp->m_sb.sb_agcount;
>  	mp->m_blkbit_log = sbp->sb_blocklog + XFS_NBBYLOG;
>  	mp->m_blkbb_log = sbp->sb_blocklog - BBSHIFT;
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 6f5a5e6764d8..a901b86772f8 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -817,8 +817,6 @@ xfs_mountfs(
>  	/*
>  	 * Allocate and initialize the per-ag data.
>  	 */
> -	spin_lock_init(&mp->m_perag_lock);
> -	INIT_RADIX_TREE(&mp->m_perag_tree, GFP_ATOMIC);
>  	error = xfs_initialize_perag(mp, sbp->sb_agcount, &mp->m_maxagi);
>  	if (error) {
>  		xfs_warn(mp, "Failed per-ag init: %d", error);
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 951271f57d00..612c1d5348b3 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1579,29 +1579,48 @@ xfs_destroy_percpu_counters(
>  	percpu_counter_destroy(&mp->m_fdblocks);
>  }
>  
> -STATIC int
> -xfs_fs_fill_super(
> -	struct super_block	*sb,
> -	void			*data,
> -	int			silent)
> +static struct xfs_mount *
> +xfs_mount_alloc(
> +	struct super_block	*sb)
>  {
> -	struct inode		*root;
> -	struct xfs_mount	*mp = NULL;
> -	int			flags = 0, error = -ENOMEM;
> +	struct xfs_mount	*mp;
>  
>  	mp = kzalloc(sizeof(struct xfs_mount), GFP_KERNEL);
>  	if (!mp)
> -		goto out;
> +		return NULL;
>  
> +	mp->m_super = sb;
>  	spin_lock_init(&mp->m_sb_lock);
> +	spin_lock_init(&mp->m_agirotor_lock);
> +	INIT_RADIX_TREE(&mp->m_perag_tree, GFP_ATOMIC);
> +	spin_lock_init(&mp->m_perag_lock);
>  	mutex_init(&mp->m_growlock);
>  	atomic_set(&mp->m_active_trans, 0);
>  	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
>  	INIT_DELAYED_WORK(&mp->m_eofblocks_work, xfs_eofblocks_worker);
>  	INIT_DELAYED_WORK(&mp->m_cowblocks_work, xfs_cowblocks_worker);
>  	mp->m_kobj.kobject.kset = xfs_kset;
> +	return mp;
> +}
>  
> -	mp->m_super = sb;
> +
> +STATIC int
> +xfs_fs_fill_super(
> +	struct super_block	*sb,
> +	void			*data,
> +	int			silent)
> +{
> +	struct inode		*root;
> +	struct xfs_mount	*mp = NULL;
> +	int			flags = 0, error = -ENOMEM;
> +
> +	/*
> +	 * allocate mp and do all low-level struct initializations before we
> +	 * attach it to the super
> +	 */
> +	mp = xfs_mount_alloc(sb);
> +	if (!mp)
> +		goto out;
>  	sb->s_fs_info = mp;
>  
>  	error = xfs_parseargs(mp, (char *)data);
> -- 
> 2.13.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
