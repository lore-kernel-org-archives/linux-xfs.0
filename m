Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1C15429DFB
	for <xfs@oss.sgi.com>; Wed,  4 Sep 2013 19:39:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E5CF2304084
	for <xfs@oss.sgi.com>; Wed,  4 Sep 2013 17:39:05 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	05MeiGGdAt2hlEly for <xfs@oss.sgi.com>;
	Wed, 04 Sep 2013 17:39:04 -0700 (PDT)
Date: Thu, 5 Sep 2013 10:39:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH 02/11] xfs: reserve v5 superblock read-only compat.
	feature bit for finobt
Message-ID: <20130905003902.GP23571@dastard>
References: <1378232708-57156-1-git-send-email-bfoster@redhat.com>
	<1378232708-57156-3-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1378232708-57156-3-git-send-email-bfoster@redhat.com>
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

On Tue, Sep 03, 2013 at 02:24:59PM -0400, Brian Foster wrote:
> Reserve a v5 read-only compatibility feature bit for the finobt and
> create the xfs_sb_version_hasfinobt() helper to determine whether
> an fs has the feature enabled.
> 
> The finobt does not change existing on-disk structures, but must
> remain consistent with the ialloc btree. Modifications from older
> kernels would violate that constrant. Therefore, we restrict older
> kernels to read-only mounts of finobt-enabled filesystems.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_sb.h | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_sb.h b/fs/xfs/xfs_sb.h
> index 6835b44..c48d95d 100644
> --- a/fs/xfs/xfs_sb.h
> +++ b/fs/xfs/xfs_sb.h
> @@ -585,7 +585,9 @@ xfs_sb_has_compat_feature(
>  	return (sbp->sb_features_compat & feature) != 0;
>  }
>  
> -#define XFS_SB_FEAT_RO_COMPAT_ALL 0
> +#define XFS_SB_FEAT_RO_COMPAT_FINOBT   (1 << 0)		/* free inode btree */
> +#define XFS_SB_FEAT_RO_COMPAT_ALL \
> +		(XFS_SB_FEAT_RO_COMPAT_FINOBT)
>  #define XFS_SB_FEAT_RO_COMPAT_UNKNOWN	~XFS_SB_FEAT_RO_COMPAT_ALL

The only thing I'd suggest here is that the last patch in the series
should add the XFS_SB_FEAT_RO_COMPAT_FINOBT bit to the
XFS_SB_FEAT_RO_COMPAT_ALL mask.

Otherwise we can have the problem of bisects landing in the middle
of the series and thinking that the feature is fully supported when
it isn't. So it's fine to add the xfs_sb_version_hasfinobt() helper
here and define the bit but don't add it to the supported mask
until all the changes for the feature are complete.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
