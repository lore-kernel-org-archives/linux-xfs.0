Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40364 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752517AbeCUShr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Mar 2018 14:37:47 -0400
Subject: Re: [PATCH v2 1/4] xfs_repair: implement custom ifork verifiers
References: <152151529988.18312.2660325658864402943.stgit@magnolia>
 <152151530602.18312.5227395146899805650.stgit@magnolia>
 <20180320214712.GK1757@magnolia>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <2bff591c-9875-1381-c43e-634d2db9da59@redhat.com>
Date: Wed, 21 Mar 2018 13:37:46 -0500
MIME-Version: 1.0
In-Reply-To: <20180320214712.GK1757@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 3/20/18 4:47 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> There are a few cases where an early stage of xfs_repair will write an
> invalid inode fork buffer to signal to a later stage that it needs to
> correct the value.  This happens in phase 4 when we detect an inline
> format directory with an invalid .. pointer.  To avoid triggering the
> ifork verifiers on this, inject a custom verifier for phase 6 that lets
> this pass for now.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good, thanks.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
> v2: fix misleading comments, remove pointless wrappers
> ---
>  libxfs/libxfs_api_defs.h |    2 ++
>  repair/phase6.c          |   57 +++++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 58 insertions(+), 1 deletion(-)
> 
> diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
> index 5d56340..78daca0 100644
> --- a/libxfs/libxfs_api_defs.h
> +++ b/libxfs/libxfs_api_defs.h
> @@ -150,5 +150,7 @@
>  #define xfs_rmap_lookup_le_range	libxfs_rmap_lookup_le_range
>  #define xfs_refc_block			libxfs_refc_block
>  #define xfs_rmap_compare		libxfs_rmap_compare
> +#define xfs_dir_get_ops			libxfs_dir_get_ops
> +#define xfs_default_ifork_ops		libxfs_default_ifork_ops
>  
>  #endif /* __LIBXFS_API_DEFS_H__ */
> diff --git a/repair/phase6.c b/repair/phase6.c
> index aff83bc..ed005e8 100644
> --- a/repair/phase6.c
> +++ b/repair/phase6.c
> @@ -39,6 +39,61 @@ static struct xfs_name		xfs_name_dot = {(unsigned char *)".",
>  						XFS_DIR3_FT_DIR};
>  
>  /*
> + * When we're checking directory inodes, we're allowed to set a directory's
> + * dotdot entry to zero to signal that the parent needs to be reconnected
> + * during phase 6.  If we're handling a shortform directory the ifork
> + * verifiers will fail, so temporarily patch out this canary so that we can
> + * verify the rest of the fork and move on to fixing the dir.
> + */
> +static xfs_failaddr_t
> +phase6_verify_dir(
> +	struct xfs_inode		*ip)
> +{
> +	struct xfs_mount		*mp = ip->i_mount;
> +	const struct xfs_dir_ops	*dops;
> +	struct xfs_ifork		*ifp;
> +	struct xfs_dir2_sf_hdr		*sfp;
> +	xfs_failaddr_t			fa;
> +	xfs_ino_t			old_parent;
> +	bool				parent_bypass = false;
> +	int				size;
> +
> +	dops = libxfs_dir_get_ops(mp, NULL);
> +
> +	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
> +	sfp = (struct xfs_dir2_sf_hdr *)ifp->if_u1.if_data;
> +	size = ifp->if_bytes;
> +
> +	/*
> +	 * If this is a shortform directory, phase4 may have set the parent
> +	 * inode to zero to indicate that it must be fixed.  Temporarily
> +	 * set a valid parent so that the directory verifier will pass.
> +	 */
> +	if (size > offsetof(struct xfs_dir2_sf_hdr, parent) &&
> +	    size >= xfs_dir2_sf_hdr_size(sfp->i8count)) {
> +		old_parent = dops->sf_get_parent_ino(sfp);
> +		if (old_parent == 0) {
> +			dops->sf_put_parent_ino(sfp, mp->m_sb.sb_rootino);
> +			parent_bypass = true;
> +		}
> +	}
> +
> +	fa = libxfs_default_ifork_ops.verify_dir(ip);
> +
> +	/* Put it back. */
> +	if (parent_bypass)
> +		dops->sf_put_parent_ino(sfp, old_parent);
> +
> +	return fa;
> +}
> +
> +static struct xfs_ifork_ops phase6_ifork_ops = {
> +	.verify_attr	= xfs_attr_shortform_verify,
> +	.verify_dir	= phase6_verify_dir,
> +	.verify_symlink	= xfs_symlink_shortform_verify,
> +};
> +
> +/*
>   * Data structures used to keep track of directories where the ".."
>   * entries are updated. These must be rebuilt after the initial pass
>   */
> @@ -2833,7 +2888,7 @@ process_dir_inode(
>  
>  	ASSERT(!is_inode_refchecked(irec, ino_offset) || dotdot_update);
>  
> -	error = -libxfs_iget(mp, NULL, ino, 0, &ip, NULL);
> +	error = -libxfs_iget(mp, NULL, ino, 0, &ip, &phase6_ifork_ops);
>  	if (error) {
>  		if (!no_modify)
>  			do_error(
> 

