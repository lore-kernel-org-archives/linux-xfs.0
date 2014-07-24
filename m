Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 93D4C7F58
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 17:46:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2DDE4AC005
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 15:46:32 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	G3145LhP74Go5AT5 for <xfs@oss.sgi.com>;
	Thu, 24 Jul 2014 15:46:30 -0700 (PDT)
Date: Fri, 25 Jul 2014 08:46:28 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 10/18] xfs: set sparse inodes feature bit when a sparse
	chunk is allocated
Message-ID: <20140724224628.GS20518@dastard>
References: <1406211788-63206-1-git-send-email-bfoster@redhat.com>
	<1406211788-63206-11-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1406211788-63206-11-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Thu, Jul 24, 2014 at 10:23:00AM -0400, Brian Foster wrote:
> The sparse chunk inode record format is backwards compatible with old
> format inobt records as long as full chunks are allocated. The holemask
> field uses higher order bytes of the freecount. While sparse chunks can
> be enabled on previously unsupported fs, older kernel drivers cannot
> parse sparse inode records.
> 
> Set the feature incompatible bit once a sparse inode chunk is allocated
> to prevent older XFS drivers from tripping over the new format.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_ialloc.c | 33 +++++++++++++++++++++++++++++++++
>  1 file changed, 33 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index 4226b1b..4dd45c2 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -407,6 +407,27 @@ error:
>  	return error;
>  }
>  
> +STATIC void
> +xfs_sbversion_add_spinodes(
> +	struct xfs_trans	*tp,
> +	struct xfs_mount	*mp)
> +{
> +	if (xfs_sb_has_incompat_log_feature(&mp->m_sb,
> +					    XFS_SB_FEAT_INCOMPAT_SPINODES))

wrong function. xfs_sb_has_incompat_feature().

> +		return;
> +
> +	spin_lock(&mp->m_sb_lock);
> +	if (xfs_sb_has_incompat_log_feature(&mp->m_sb,
> +					    XFS_SB_FEAT_INCOMPAT_SPINODES)) {
> +		spin_unlock(&mp->m_sb_lock);
> +		return;
> +	}
> +
> +	mp->m_sb.sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_SPINODES;
> +	spin_unlock(&mp->m_sb_lock);
> +	xfs_mod_sb(tp, XFS_SB_FEATURES_INCOMPAT);
> +}
> +
>  /*
>   * Allocate new inodes in the allocation group specified by agbp.
>   * Return 0 for success, else error code.
> @@ -631,6 +652,18 @@ xfs_ialloc_ag_alloc(
>  		if (error)
>  			return error;
>  	}
> +
> +	/*
> +	 * Set an incompat feature bit as old drivers can't parse sparse
> +	 * records. Pre-sparse inode chunk drivers will include the
> +	 * holemask in the higher order freecount bits, resulting in a
> +	 * bogus value.
> +	 *
> +	 * XXX: when is this bit removed?
> +	 */
> +	if (xfs_inobt_issparse(&rec))
> +		xfs_sbversion_add_spinodes(tp, args.mp);

I'd like to avoid this dynamic feature bit adding if possible. Do we
really need it?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
