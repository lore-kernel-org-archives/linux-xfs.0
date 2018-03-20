Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:60226 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751269AbeCTTyb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 20 Mar 2018 15:54:31 -0400
Subject: Re: [PATCH 1/4] xfs_repair: implement custom ifork verifiers
References: <152151529988.18312.2660325658864402943.stgit@magnolia>
 <152151530602.18312.5227395146899805650.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <f8a05fc0-9d82-da7f-9ac7-9be2328cf2ef@sandeen.net>
Date: Tue, 20 Mar 2018 14:54:30 -0500
MIME-Version: 1.0
In-Reply-To: <152151530602.18312.5227395146899805650.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 3/19/18 10:08 PM, Darrick J. Wong wrote:
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
> ---
>  libxfs/libxfs_api_defs.h |    2 +
>  repair/phase6.c          |   66 +++++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 67 insertions(+), 1 deletion(-)
> 
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
> index aff83bc..e9189af 100644
> --- a/repair/phase6.c
> +++ b/repair/phase6.c
> @@ -39,6 +39,70 @@ static struct xfs_name		xfs_name_dot = {(unsigned char *)".",
>  						XFS_DIR3_FT_DIR};
>  
>  /*
> + * When we're checking directory inodes, we're allowed to set a directory's

(a shortform directory only?)

> + * dotdot entry to zero to signal that the parent needs to be reconnected
> + * during phase 6.  The ifork verifiers would normally fail that, but we'll
> + * accept this canary so that we can fix the dir.

hm we actually just replace it temporarily, potato/potahto?

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
> +	/* Don't let the NULLFSINO .. entry blow everything up. */

NULLFSINO is ((xfs_ino_t)-1) not zero, so is this comment accurate?

Maybe an explicit comment here about this being for shortform dirs?

	/*
	 * If this is a shortform directory, phase4 may have set the parent
	 * inode to zero to indicate that it must be fixed.  Temporarily
	 * set a valid parent so that the directory verifier will pass.
	 */

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

	/* Put the special parent == 0 back in place */

> +	if (parent_bypass)
> +		dops->sf_put_parent_ino(sfp, old_parent);
> +
> +	return fa;
> +}
> +
> +static xfs_failaddr_t
> +phase6_verify_attr(
> +	struct xfs_inode		*ip)
> +{
> +	return libxfs_default_ifork_ops.verify_attr(ip);
> +}

Is there a reason for these wrappers vs. just populating the
custom ifork_ops with xfs_attr_shortform_verify and
xfs_symlink_shortform_verify?

> +
> +static xfs_failaddr_t
> +phase6_verify_symlink(
> +	struct xfs_inode		*ip)
> +{
> +	return libxfs_default_ifork_ops.verify_symlink(ip);
> +}
> +
> +struct xfs_ifork_ops phase6_default_ifork_ops = {

Naming a "custom" verifier "default" seems counterintuitive,
is there a reason for the "default" semantics I'm missing?  Not
a huge deal, just makes me go "hmmm...."

> +	.verify_attr	= phase6_verify_attr,
> +	.verify_dir	= phase6_verify_dir,
> +	.verify_symlink	= phase6_verify_symlink,
> +};
> +
> +/*
>   * Data structures used to keep track of directories where the ".."
>   * entries are updated. These must be rebuilt after the initial pass
>   */
> @@ -2833,7 +2897,7 @@ process_dir_inode(
>  
>  	ASSERT(!is_inode_refchecked(irec, ino_offset) || dotdot_update);
>  
> -	error = -libxfs_iget(mp, NULL, ino, 0, &ip, NULL);
> +	error = -libxfs_iget(mp, NULL, ino, 0, &ip, &phase6_default_ifork_ops);
>  	if (error) {
>  		if (!no_modify)
>  			do_error(
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
