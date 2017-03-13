Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41258 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753061AbdCMMjm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 13 Mar 2017 08:39:42 -0400
Date: Mon, 13 Mar 2017 08:39:40 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [RFC PATCH] xfs: don't run off the end of the buffer reading
 inline dirents
Message-ID: <20170313123940.GB4153@bfoster.bfoster>
References: <20170308210112.GR5280@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170308210112.GR5280@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Wed, Mar 08, 2017 at 01:01:12PM -0800, Darrick J. Wong wrote:
> Check that we don't run off the end of the inline data buffer when we're
> trying to read directory entries.  xfs/348 triggered kernel memory being
> exposed to userspace and a related complaint from the usercopy code.
> 
> Evidently once we call dir_emit, the VFS ignores error return values
> since it's already begun copying data back to userspace.
> 

How do we get into this situation in the first place?

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_dir2_readdir.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
> index 003a99b..70bdd21 100644
> --- a/fs/xfs/xfs_dir2_readdir.c
> +++ b/fs/xfs/xfs_dir2_readdir.c
> @@ -69,6 +69,7 @@ xfs_dir2_sf_getdents(
>  	xfs_dir2_dataptr_t	dotdot_offset;
>  	xfs_ino_t		ino;
>  	struct xfs_da_geometry	*geo = args->geo;
> +	char *endp;
>  
>  	ASSERT(dp->i_df.if_flags & XFS_IFINLINE);
>  	/*
> @@ -83,6 +84,7 @@ xfs_dir2_sf_getdents(
>  	ASSERT(dp->i_df.if_u1.if_data != NULL);
>  
>  	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
> +	endp = dp->i_df.if_u1.if_data + dp->i_df.if_bytes;
>  
>  	if (dp->i_d.di_size < xfs_dir2_sf_hdr_size(sfp->i8count))
>  		return -EFSCORRUPTED;
> @@ -130,6 +132,12 @@ xfs_dir2_sf_getdents(
>  	for (i = 0; i < sfp->count; i++) {
>  		__uint8_t filetype;
>  
> +		/* If we pass the end of the buffer, we're done. */
> +		if (((char *)sfep + sizeof(*sfep)) >= endp ||
> +		    (char *)dp->d_ops->sf_nextentry(sfp, sfep) > endp) {
> +			break;
> +		}
> +

What's the reason for checking ->sf_nextentry()?

Brian

>  		off = xfs_dir2_db_off_to_dataptr(geo, geo->datablk,
>  				xfs_dir2_sf_get_offset(sfep));
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
