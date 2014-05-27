Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 26CFC7F4E
	for <xfs@oss.sgi.com>; Tue, 27 May 2014 11:01:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EB23730405F
	for <xfs@oss.sgi.com>; Tue, 27 May 2014 09:01:10 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id CCWKWHhiDuMZcx0l for
	<xfs@oss.sgi.com>; Tue, 27 May 2014 09:01:10 -0700 (PDT)
Date: Tue, 27 May 2014 12:01:01 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 14/16] xfs: use xfs_da_geometry for block size in attr code
Message-ID: <20140527160100.GF11265@laptop.bfoster>
References: <1400803432-20048-1-git-send-email-david@fromorbit.com>
	<1400803432-20048-15-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1400803432-20048-15-git-send-email-david@fromorbit.com>
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

On Fri, May 23, 2014 at 10:03:50AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Rather than using the superblock value obtained through the
> xfs_mount.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_attr.c       | 12 ++++++------
>  fs/xfs/xfs_attr_leaf.c  |  6 +++---
>  fs/xfs/xfs_log_rlimit.c |  2 +-
>  3 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_attr.c b/fs/xfs/xfs_attr.c
> index 8bb9ae6..ccfc2c9 100644
> --- a/fs/xfs/xfs_attr.c
> +++ b/fs/xfs/xfs_attr.c
> @@ -175,11 +175,11 @@ xfs_attr_calc_size(
>  	 * "local" or "remote" (note: local != inline).
>  	 */
>  	size = xfs_attr_leaf_newentsize(args->namelen, args->valuelen,
> -					mp->m_sb.sb_blocksize, local);
> +					args->geo->blksize, local);
>  
>  	nblks = XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK);
>  	if (*local) {
> -		if (size > (mp->m_sb.sb_blocksize >> 1)) {
> +		if (size > (args->geo->blksize / 2)) {
>  			/* Double split possible */
>  			nblks *= 2;
>  		}
> @@ -898,7 +898,7 @@ restart:
>  	state = xfs_da_state_alloc();
>  	state->args = args;
>  	state->mp = mp;
> -	state->blocksize = state->mp->m_sb.sb_blocksize;
> +	state->blocksize = args->geo->blksize;
>  	state->node_ents = args->geo->node_ents;
>  
>  	/*
> @@ -1077,7 +1077,7 @@ restart:
>  		state = xfs_da_state_alloc();
>  		state->args = args;
>  		state->mp = mp;
> -		state->blocksize = state->mp->m_sb.sb_blocksize;
> +		state->blocksize = args->geo->blksize;
>  		state->node_ents = args->geo->node_ents;
>  		state->inleaf = 0;
>  		error = xfs_da3_node_lookup_int(state, &retval);
> @@ -1169,7 +1169,7 @@ xfs_attr_node_removename(xfs_da_args_t *args)
>  	state = xfs_da_state_alloc();
>  	state->args = args;
>  	state->mp = dp->i_mount;
> -	state->blocksize = state->mp->m_sb.sb_blocksize;
> +	state->blocksize = args->geo->blksize;
>  	state->node_ents = args->geo->node_ents;
>  
>  	/*
> @@ -1432,7 +1432,7 @@ xfs_attr_node_get(xfs_da_args_t *args)
>  	state = xfs_da_state_alloc();
>  	state->args = args;
>  	state->mp = args->dp->i_mount;
> -	state->blocksize = state->mp->m_sb.sb_blocksize;
> +	state->blocksize = args->geo->blksize;
>  	state->node_ents = args->geo->node_ents;
>  
>  	/*
> diff --git a/fs/xfs/xfs_attr_leaf.c b/fs/xfs/xfs_attr_leaf.c
> index 5be77b3..88cd84a 100644
> --- a/fs/xfs/xfs_attr_leaf.c
> +++ b/fs/xfs/xfs_attr_leaf.c
> @@ -1077,7 +1077,7 @@ xfs_attr3_leaf_add(
>  	xfs_attr3_leaf_hdr_from_disk(&ichdr, leaf);
>  	ASSERT(args->index >= 0 && args->index <= ichdr.count);
>  	entsize = xfs_attr_leaf_newentsize(args->namelen, args->valuelen,
> -			   args->trans->t_mountp->m_sb.sb_blocksize, NULL);
> +			   args->geo->blksize, NULL);
>  
>  	/*
>  	 * Search through freemap for first-fit on new name length.
> @@ -1180,13 +1180,13 @@ xfs_attr3_leaf_add_work(
>  	ASSERT((ichdr->freemap[mapindex].base & 0x3) == 0);
>  	ASSERT(ichdr->freemap[mapindex].size >=
>  		xfs_attr_leaf_newentsize(args->namelen, args->valuelen,
> -					 mp->m_sb.sb_blocksize, NULL));
> +					 args->geo->blksize, NULL));
>  	ASSERT(ichdr->freemap[mapindex].size < XFS_LBSIZE(mp));
>  	ASSERT((ichdr->freemap[mapindex].size & 0x3) == 0);
>  
>  	ichdr->freemap[mapindex].size -=
>  			xfs_attr_leaf_newentsize(args->namelen, args->valuelen,
> -						 mp->m_sb.sb_blocksize, &tmp);
> +						 args->geo->blksize, &tmp);
>  
>  	entry->nameidx = cpu_to_be16(ichdr->freemap[mapindex].base +
>  				     ichdr->freemap[mapindex].size);
> diff --git a/fs/xfs/xfs_log_rlimit.c b/fs/xfs/xfs_log_rlimit.c
> index 2af1a0a..ee7e0e8 100644
> --- a/fs/xfs/xfs_log_rlimit.c
> +++ b/fs/xfs/xfs_log_rlimit.c
> @@ -42,7 +42,7 @@ xfs_log_calc_max_attrsetm_res(
>  	int			size;
>  	int			nblks;
>  
> -	size = xfs_attr_leaf_entsize_local_max(mp->m_sb.sb_blocksize) -
> +	size = xfs_attr_leaf_entsize_local_max(mp->m_attr_geo->blksize) -
>  	       MAXNAMELEN - 1;
>  	nblks = XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK);
>  	nblks += XFS_B_TO_FSB(mp, size);
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
