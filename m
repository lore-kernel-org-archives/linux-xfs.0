Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8DF727F3F
	for <xfs@oss.sgi.com>; Wed, 24 Jul 2013 15:53:58 -0500 (CDT)
Date: Wed, 24 Jul 2013 15:53:58 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 09/48] xfs: add CRC checks to block format directory blocks
Message-ID: <20130724205358.GR3111@sgi.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
	<1370564771-4929-10-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1370564771-4929-10-git-send-email-david@fromorbit.com>
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

On Fri, Jun 07, 2013 at 10:25:32AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now that directory buffers are made from a single struct xfs_buf, we
> can add CRC calculation and checking callbacks. While there, add all
> the fields to the on disk structures for future functionality such
> as d_type support, uuids, block numbers, owner inode, etc.
> 
> To distinguish between the different on disk formats, change the
> magic numbers for the new format directory blocks.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

corresponds to commit f5f3d9b016

> ---
>  include/xfs_dir2_format.h |  155 +++++++++++++++++++++++++++++++++++++++++--
>  libxfs/xfs_dir2_block.c   |  126 +++++++++++++++++++++++++----------
>  libxfs/xfs_dir2_data.c    |  160 ++++++++++++++++++++++++++++-----------------
>  libxfs/xfs_dir2_leaf.c    |    6 +-
>  libxfs/xfs_dir2_node.c    |    2 +-
>  libxfs/xfs_dir2_priv.h    |    4 +-
>  libxfs/xfs_dir2_sf.c      |    2 +-
>  7 files changed, 346 insertions(+), 109 deletions(-)
> 
> diff --git a/include/xfs_dir2_format.h b/include/xfs_dir2_format.h
> index f5c264a..da928c7 100644
> --- a/include/xfs_dir2_format.h
> +++ b/include/xfs_dir2_format.h

...

> @@ -215,11 +247,43 @@ typedef struct xfs_dir2_data_free {
>   */
>  typedef struct xfs_dir2_data_hdr {
>  	__be32			magic;		/* XFS_DIR2_DATA_MAGIC or */
> -						/* XFS_DIR2_BLOCK_MAGIC */
> +	/* XFS_DIR2_BLOCK_MAGIC */

This change to remove some tabs does not match the kernel code.  Suggest you
remove it.  Maybe you have done that in one of the syncs later.

> @@ -287,7 +340,7 @@ xfs_dir2_block_addname(
>  	mp = dp->i_mount;
>  
>  	/* Read the (one and only) directory block into bp. */
> -	error = xfs_dir2_block_read(tp, dp, &bp);
> +	error = xfs_dir3_block_read(tp, dp, &bp);
>  	if (error)
>  		return error;
>  
> @@ -597,7 +650,7 @@ xfs_dir2_block_lookup_int(

It looks like there are a couple changes to xfs_dir2_block_getdents() that are
in the corresponding kernel commit but not reflected here.  Seems like this
function isn't called in the userspace code, so maybe it doesn't matter.

>  	tp = args->trans;
>  	mp = dp->i_mount;
>  
> -	error = xfs_dir2_block_read(tp, dp, &bp);
> +	error = xfs_dir3_block_read(tp, dp, &bp);
>  	if (error)
>  		return error;
>  
> @@ -860,9 +913,12 @@ xfs_dir2_leaf_to_block(

...

> diff --git a/libxfs/xfs_dir2_data.c b/libxfs/xfs_dir2_data.c
> index eb86739..66aab07 100644
> --- a/libxfs/xfs_dir2_data.c
> +++ b/libxfs/xfs_dir2_data.c
> @@ -1,5 +1,6 @@
>  /*
>   * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
> + * Copyright (c) 2013 Red Hat, Inc.
>   * All Rights Reserved.
>   *
>   * This program is free software; you can redistribute it and/or
> @@ -49,11 +50,12 @@ __xfs_dir2_data_check(
>  
>  	mp = bp->b_target->bt_mount;
>  	hdr = bp->b_addr;
> -	bf = hdr->bestfree;
> -	p = (char *)(hdr + 1);
> +	bf = xfs_dir3_data_bestfree_p(hdr);
> +	p = (char *)xfs_dir3_data_entry_p(hdr);
>  
>  	switch (be32_to_cpu(hdr->magic)) {
>  	case XFS_DIR2_BLOCK_MAGIC:
> +	case XFS_DIR3_BLOCK_MAGIC:
	    ^^^^^

In the kernel the endian flip is done here, not in the switch parens.

>  		btp = xfs_dir2_block_tail_p(mp, hdr);
>  		lep = xfs_dir2_block_leaf_p(btp);
>  		endp = (char *)lep;
> @@ -132,7 +134,8 @@ __xfs_dir2_data_check(
>  					       (char *)dep - (char *)hdr);
>  		count++;
>  		lastfree = 0;
> -		if (hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC)) {
> +		if (hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC) ||
> +		    hdr->magic == cpu_to_be32(XFS_DIR3_BLOCK_MAGIC)) {
>  			addr = xfs_dir2_db_off_to_dataptr(mp, mp->m_dirdatablk,
>  				(xfs_dir2_data_aoff_t)
>  				((char *)dep - (char *)hdr));
> @@ -152,7 +155,8 @@ __xfs_dir2_data_check(
>  	 * Need to have seen all the entries and all the bestfree slots.
>  	 */
>  	XFS_WANT_CORRUPTED_RETURN(freeseen == 7);
> -	if (hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC)) {
> +	if (hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC) ||
> +	    hdr->magic == cpu_to_be32(XFS_DIR3_BLOCK_MAGIC)) {
>  		for (i = stale = 0; i < be32_to_cpu(btp->count); i++) {
>  			if (lep[i].address ==
>  			    cpu_to_be32(XFS_DIR2_NULL_DATAPTR))
> @@ -200,7 +204,8 @@ xfs_dir2_data_reada_verify(
>  
>  	switch (be32_to_cpu(hdr->magic)) {
>  	case XFS_DIR2_BLOCK_MAGIC:
> -		bp->b_ops = &xfs_dir2_block_buf_ops;
> +	case XFS_DIR3_BLOCK_MAGIC:

Also here the endian switch was done differently in the kernel.

Other than those nits this looks fine.

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
