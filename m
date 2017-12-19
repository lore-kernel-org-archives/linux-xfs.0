Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:33884 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1759913AbdLSFXf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Dec 2017 00:23:35 -0500
Date: Tue, 19 Dec 2017 16:23:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 07/13] xfs: create structure verifier function for
 shortform xattrs
Message-ID: <20171219052329.GQ4094@dastard>
References: <151320949282.30654.14805160700975182459.stgit@magnolia>
 <151320953564.30654.16063573622569255317.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151320953564.30654.16063573622569255317.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Dec 13, 2017 at 03:58:55PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Create a function to perform structure verification for short form
> extended attributes.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr_leaf.c |   70 +++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_attr_leaf.h |    1 +
>  2 files changed, 71 insertions(+)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 1274872..a5033f0 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -873,6 +873,76 @@ xfs_attr_shortform_allfit(
>  	return xfs_attr_shortform_bytesfit(dp, bytes);
>  }
>  
> +/* Verify the consistency of an inline attribute fork. */
> +xfs_failaddr_t
> +xfs_attr_shortform_verify(
> +	struct xfs_inode		*ip)
> +{
> +	struct xfs_attr_shortform	*sfp;
> +	struct xfs_attr_sf_entry	*sfep;
> +	struct xfs_attr_sf_entry	*next_sfep;
> +	char				*endp;
> +	struct xfs_ifork		*ifp;
> +	int				i;
> +	int				size;
> +
> +	ASSERT(ip->i_d.di_aformat == XFS_DINODE_FMT_LOCAL);
> +	ifp = XFS_IFORK_PTR(ip, XFS_ATTR_FORK);
> +	sfp = (struct xfs_attr_shortform *)ifp->if_u1.if_data;
> +	size = ifp->if_bytes;
> +
> +	/*
> +	 * Give up if the attribute is way too short.
> +	 */
> +	if (size < sizeof(struct xfs_attr_sf_hdr))
> +		return __this_address;
> +
> +	endp = (char *)sfp + size;
> +
> +	/* Check all reported entries */
> +	sfep = &sfp->list[0];
> +	for (i = 0; i < sfp->hdr.count; i++) {
> +		/*
> +		 * struct xfs_attr_sf_entry has a variable length.
> +		 * Check the fixed-offset parts of the structure are
> +		 * within the data buffer.
> +		 */
> +		if (((char *)sfep + sizeof(*sfep)) >= endp)
> +			return __this_address;
> +
> +		/* Don't allow names with known bad length. */
> +		if (sfep->namelen == 0)
> +			return __this_address;
> +
> +		/*
> +		 * Check that the variable-length part of the structure is
> +		 * within the data buffer.  The next entry starts after the
> +		 * name component, so nextentry is an acceptable test.
> +		 */
> +		next_sfep = XFS_ATTR_SF_NEXTENTRY(sfep);
> +		if ((char *)next_sfep > endp)
> +			return __this_address;
> +
> +		/*
> +		 * Check for unknown flags.  Short form doesn't support
> +		 * the incomplete or local bits.
> +		 */
> +		if (sfep->flags & ~(XFS_ATTR_ROOT | XFS_ATTR_SECURE))
> +			return __this_address;
> +
> +		/* Check for invalid namespace combinations. */
> +		if ((sfep->flags & XFS_ATTR_ROOT) &&
> +		    (sfep->flags & XFS_ATTR_SECURE))
> +			return __this_address;

#define ATTR_SF_FLAGS	(XFS_ATTR_ROOT | XFS_ATTR_SECURE)

		if (sfep->flags & ~ATTR_SF_FLAGS)
			return __this_address;
		if ((sfep->flags & ATTR_SF_FLAGS) == ATTR_SF_FLAGS)
			return __this_address;

Otherwise looks ok.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
