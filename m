Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 81E4D7F57
	for <xfs@oss.sgi.com>; Tue, 27 May 2014 10:59:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 47D6E30405F
	for <xfs@oss.sgi.com>; Tue, 27 May 2014 08:59:45 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id J32XODN8RE3vOaAB for
	<xfs@oss.sgi.com>; Tue, 27 May 2014 08:59:45 -0700 (PDT)
Date: Tue, 27 May 2014 11:59:41 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 11/16] xfs: move node entry counts to xfs_da_geometry
Message-ID: <20140527155941.GC11265@laptop.bfoster>
References: <1400803432-20048-1-git-send-email-david@fromorbit.com>
	<1400803432-20048-12-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1400803432-20048-12-git-send-email-david@fromorbit.com>
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
Cc: xfs@oss.sgi.com

On Fri, May 23, 2014 at 10:03:47AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Are the state->blocksize and node_ents fields redundant with the
associated geo fields? On a quick scan, it seems like they don't ever
change. Patch looks fine either way...

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_attr.c      |  8 ++++----
>  fs/xfs/xfs_da_btree.c  |  4 ++--
>  fs/xfs/xfs_dir2.c      |  3 ---
>  fs/xfs/xfs_dir2_node.c | 10 +++++-----
>  fs/xfs/xfs_mount.h     |  2 --
>  5 files changed, 11 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/xfs/xfs_attr.c b/fs/xfs/xfs_attr.c
> index c547498..8bb9ae6 100644
> --- a/fs/xfs/xfs_attr.c
> +++ b/fs/xfs/xfs_attr.c
> @@ -899,7 +899,7 @@ restart:
>  	state->args = args;
>  	state->mp = mp;
>  	state->blocksize = state->mp->m_sb.sb_blocksize;
> -	state->node_ents = state->mp->m_attr_node_ents;
> +	state->node_ents = args->geo->node_ents;
>  
>  	/*
>  	 * Search to see if name already exists, and get back a pointer
> @@ -1078,7 +1078,7 @@ restart:
>  		state->args = args;
>  		state->mp = mp;
>  		state->blocksize = state->mp->m_sb.sb_blocksize;
> -		state->node_ents = state->mp->m_attr_node_ents;
> +		state->node_ents = args->geo->node_ents;
>  		state->inleaf = 0;
>  		error = xfs_da3_node_lookup_int(state, &retval);
>  		if (error)
> @@ -1170,7 +1170,7 @@ xfs_attr_node_removename(xfs_da_args_t *args)
>  	state->args = args;
>  	state->mp = dp->i_mount;
>  	state->blocksize = state->mp->m_sb.sb_blocksize;
> -	state->node_ents = state->mp->m_attr_node_ents;
> +	state->node_ents = args->geo->node_ents;
>  
>  	/*
>  	 * Search to see if name exists, and get back a pointer to it.
> @@ -1433,7 +1433,7 @@ xfs_attr_node_get(xfs_da_args_t *args)
>  	state->args = args;
>  	state->mp = args->dp->i_mount;
>  	state->blocksize = state->mp->m_sb.sb_blocksize;
> -	state->node_ents = state->mp->m_attr_node_ents;
> +	state->node_ents = args->geo->node_ents;
>  
>  	/*
>  	 * Search to see if name exists, and get back a pointer to it.
> diff --git a/fs/xfs/xfs_da_btree.c b/fs/xfs/xfs_da_btree.c
> index b9b007d..f935370 100644
> --- a/fs/xfs/xfs_da_btree.c
> +++ b/fs/xfs/xfs_da_btree.c
> @@ -167,8 +167,8 @@ xfs_da3_node_verify(
>  	 * we don't know if the node is for and attribute or directory tree,
>  	 * so only fail if the count is outside both bounds
>  	 */
> -	if (ichdr.count > mp->m_dir_node_ents &&
> -	    ichdr.count > mp->m_attr_node_ents)
> +	if (ichdr.count > mp->m_dir_geo->node_ents &&
> +	    ichdr.count > mp->m_attr_geo->node_ents)
>  		return false;
>  
>  	/* XXX: hash order check? */
> diff --git a/fs/xfs/xfs_dir2.c b/fs/xfs/xfs_dir2.c
> index 0230342..90d426d 100644
> --- a/fs/xfs/xfs_dir2.c
> +++ b/fs/xfs/xfs_dir2.c
> @@ -144,9 +144,6 @@ xfs_da_mount(
>  	else
>  		mp->m_dirnameops = &xfs_default_nameops;
>  
> -	/* XXX: these are to be removed as code is converted to use geo */
> -	mp->m_dir_node_ents = mp->m_dir_geo->node_ents;
> -	mp->m_attr_node_ents = mp->m_attr_geo->node_ents;
>  	return 0;
>  }
>  
> diff --git a/fs/xfs/xfs_dir2_node.c b/fs/xfs/xfs_dir2_node.c
> index de5b2996..eff6b8d 100644
> --- a/fs/xfs/xfs_dir2_node.c
> +++ b/fs/xfs/xfs_dir2_node.c
> @@ -1596,8 +1596,8 @@ xfs_dir2_node_addname(
>  	state = xfs_da_state_alloc();
>  	state->args = args;
>  	state->mp = args->dp->i_mount;
> -	state->blocksize = state->args->geo->blksize;
> -	state->node_ents = state->mp->m_dir_node_ents;
> +	state->blocksize = args->geo->blksize;
> +	state->node_ents = args->geo->node_ents;
>  	/*
>  	 * Look up the name.  We're not supposed to find it, but
>  	 * this gives us the insertion point.
> @@ -2043,7 +2043,7 @@ xfs_dir2_node_lookup(
>  	state->args = args;
>  	state->mp = args->dp->i_mount;
>  	state->blocksize = args->geo->blksize;
> -	state->node_ents = state->mp->m_dir_node_ents;
> +	state->node_ents = args->geo->node_ents;
>  	/*
>  	 * Fill in the path to the entry in the cursor.
>  	 */
> @@ -2098,7 +2098,7 @@ xfs_dir2_node_removename(
>  	state->args = args;
>  	state->mp = args->dp->i_mount;
>  	state->blocksize = args->geo->blksize;
> -	state->node_ents = state->mp->m_dir_node_ents;
> +	state->node_ents = args->geo->node_ents;
>  
>  	/* Look up the entry we're deleting, set up the cursor. */
>  	error = xfs_da3_node_lookup_int(state, &rval);
> @@ -2168,7 +2168,7 @@ xfs_dir2_node_replace(
>  	state->args = args;
>  	state->mp = args->dp->i_mount;
>  	state->blocksize = args->geo->blksize;
> -	state->node_ents = state->mp->m_dir_node_ents;
> +	state->node_ents = args->geo->node_ents;
>  	inum = args->inumber;
>  	/*
>  	 * Lookup the entry to change in the btree.
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 3b690c36..6d7e5d7 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -134,8 +134,6 @@ typedef struct xfs_mount {
>  	int			m_fixedfsid[2];	/* unchanged for life of FS */
>  	uint			m_dmevmask;	/* DMI events for this FS */
>  	__uint64_t		m_flags;	/* global mount flags */
> -	uint			m_dir_node_ents; /* #entries in a dir danode */
> -	uint			m_attr_node_ents; /* #entries in attr danode */
>  	int			m_ialloc_inos;	/* inodes in inode allocation */
>  	int			m_ialloc_blks;	/* blocks in inode allocation */
>  	int			m_inoalign_mask;/* mask sb_inoalignmt if used */
> -- 
> 1.9.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
