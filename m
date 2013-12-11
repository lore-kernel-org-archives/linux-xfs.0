Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B3D827F4E
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 17:14:51 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 821C98F8035
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 15:14:48 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	yPeDOG9DecEUsFAM for <xfs@oss.sgi.com>;
	Wed, 11 Dec 2013 15:14:46 -0800 (PST)
Date: Thu, 12 Dec 2013 10:14:10 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/5] xfs: introduce xfs_ialloc_blks_per_cluster
Message-ID: <20131211231409.GN10988@dastard>
References: <52A86D11.1040504@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52A86D11.1040504@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Wed, Dec 11, 2013 at 09:48:01PM +0800, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> Introduce a common routine xfs_ialloc_blks_per_cluster() to calculate
> and return the number of blocks per inode cluster.
> 
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> ---
>  fs/xfs/xfs_ialloc.h | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/fs/xfs/xfs_ialloc.h b/fs/xfs/xfs_ialloc.h
> index a8f76a5..f4bfd32 100644
> --- a/fs/xfs/xfs_ialloc.h
> +++ b/fs/xfs/xfs_ialloc.h
> @@ -37,6 +37,16 @@ struct xfs_btree_cur;
>  #define	XFS_INODE_BIG_CLUSTER_SIZE	8192
>  #define	XFS_INODE_CLUSTER_SIZE(mp)	(mp)->m_inode_cluster_size
>  
> +/* Calculate and return the number of blocks per inode cluster */
> +static inline int
> +xfs_ialloc_blks_per_cluster(
> +	struct xfs_mount	*mp)
> +{
> +	if (mp->m_sb.sb_blocksize >= XFS_INODE_CLUSTER_SIZE(mp))
> +		return 1;
> +	return XFS_INODE_CLUSTER_SIZE(mp) >> mp->m_sb.sb_blocklog;
> +}

I'd avoid using the XFS_INODE_CLUSTER_SIZE() macro - it's just a
useless wrapper around mp->m_inode_cluster_size. Hence if you are
cleaning this code up, the first thing I'd do is remove the macro.

/* Calculate and return the number of blocks per inode cluster */
static inline int
xfs_ialloc_blks_per_cluster(
	struct xfs_mount	*mp)
{
	if (mp->m_sb.sb_blocksize >= mp->m_inode_cluster_size)
		return 1;
	return mp->m_inode_cluster_size >> mp->m_sb.sb_blocklog;
}

Is much less shouty, and just as easy to read ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
