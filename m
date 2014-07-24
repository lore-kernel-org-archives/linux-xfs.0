Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 29AD67F58
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 18:35:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C6EF6AC006
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 16:35:56 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	EI9XN6zPopdicMWu for <xfs@oss.sgi.com>;
	Thu, 24 Jul 2014 16:35:55 -0700 (PDT)
Date: Fri, 25 Jul 2014 09:35:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 03/18] xfs: define sparse inode chunks v5 sb feature bit
	and helper function
Message-ID: <20140724233533.GY20518@dastard>
References: <1406211788-63206-1-git-send-email-bfoster@redhat.com>
	<1406211788-63206-4-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1406211788-63206-4-git-send-email-bfoster@redhat.com>
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

On Thu, Jul 24, 2014 at 10:22:53AM -0400, Brian Foster wrote:
> The sparse inode chunks feature will use the helper function to enable
> the allocation of sparse inode chunks. The incompatible feature bit is
> set on disk once a sparse inode chunk is allocated to prevent older
> drivers from mounting an fs with sparse chunks.
> 
> Note that the feature is hardcoded disabled and the feature bit not
> included in the all features mask until fully implemented.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_sb.h | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_sb.h b/fs/xfs/libxfs/xfs_sb.h
> index c43c2d6..6f48de9 100644
> --- a/fs/xfs/libxfs/xfs_sb.h
> +++ b/fs/xfs/libxfs/xfs_sb.h
> @@ -509,6 +509,7 @@ xfs_sb_has_ro_compat_feature(
>  }
>  
>  #define XFS_SB_FEAT_INCOMPAT_FTYPE	(1 << 0)	/* filetype in dirent */
> +#define XFS_SB_FEAT_INCOMPAT_SPINODES	(1 << 1)	/* sparse inode chunks */
>  #define XFS_SB_FEAT_INCOMPAT_ALL \
>  		(XFS_SB_FEAT_INCOMPAT_FTYPE)
>  
> @@ -558,6 +559,11 @@ static inline int xfs_sb_version_hasfinobt(xfs_sb_t *sbp)
>  		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_FINOBT);
>  }
>  
> +static inline int xfs_sb_version_hassparseinodes(struct xfs_sb *sbp)

static inline bool ...

> +{
> +	return 0; /* not yet enabled */

	return false;

-Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
