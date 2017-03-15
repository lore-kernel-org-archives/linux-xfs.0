Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20943 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752345AbdCOH3q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Mar 2017 03:29:46 -0400
Date: Wed, 15 Mar 2017 00:29:34 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2] xfs: don't run off the end of the buffer reading
 inline dirents
Message-ID: <20170315072934.GB5280@birch.djwong.org>
References: <20170314200009.GX5280@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170314200009.GX5280@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>
Cc: Brian Foster <bfoster@redhat.com>

On Tue, Mar 14, 2017 at 01:00:09PM -0700, Darrick J. Wong wrote:
> Check that we don't run off the end of the inline data buffer when we're
> trying to read (apparently corrupt) directory entries.  xfs/348
> triggered kernel memory being exposed to userspace and a related
> complaint from the usercopy code when it corrupts an inline symlink
> into an inline dir.

Self-NAK, see "xfs: verify inline directory data forks" as its replacement.

--D

> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v2: improved comments
> ---
>  fs/xfs/xfs_dir2_readdir.c |   17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
> index 003a99b..26a280b 100644
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
> @@ -130,6 +132,21 @@ xfs_dir2_sf_getdents(
>  	for (i = 0; i < sfp->count; i++) {
>  		__uint8_t filetype;
>  
> +		/*
> +		 * If we pass the end of the buffer, we're done.
> +		 *
> +		 * struct xfs_dir2_sf_entry has a variable length.
> +		 * Therefore we must first check that the non-variable
> +		 * parts of the structure don't go off the end of the
> +		 * buffer, and then we must check that the name
> +		 * component also does not go off the end of the buffer,
> +		 * which we do by checking the nextentry pointer.
> +		 */
> +		if (((char *)sfep + sizeof(*sfep)) >= endp ||
> +		    (char *)dp->d_ops->sf_nextentry(sfp, sfep) > endp) {
> +			break;
> +		}
> +
>  		off = xfs_dir2_db_off_to_dataptr(geo, geo->datablk,
>  				xfs_dir2_sf_get_offset(sfep));
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
