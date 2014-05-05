Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4689D29E0F
	for <xfs@oss.sgi.com>; Mon,  5 May 2014 16:47:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 22CAB304043
	for <xfs@oss.sgi.com>; Mon,  5 May 2014 14:47:01 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id zVf4xRyGcqwJCLoO for
	<xfs@oss.sgi.com>; Mon, 05 May 2014 14:47:00 -0700 (PDT)
Date: Mon, 5 May 2014 17:10:24 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 4/6] xfsprogs: introduce xfs_icluster_size_fsb()
Message-ID: <20140505211023.GE13973@laptop.bfoster>
References: <536784D4.1050405@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <536784D4.1050405@oracle.com>
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

On Mon, May 05, 2014 at 08:32:20PM +0800, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> Introduce a common routine xfs_icluster_size_fsb() to calculate
> and return the number of file system blocks per inode cluster.
> 
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  include/xfs_ialloc.h | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/include/xfs_ialloc.h b/include/xfs_ialloc.h
> index 0498f20..9dee62f 100644
> --- a/include/xfs_ialloc.h
> +++ b/include/xfs_ialloc.h
> @@ -30,6 +30,16 @@ struct xfs_btree_cur;
>   */
>  #define	XFS_INODE_BIG_CLUSTER_SIZE	8192
>  
> +/* Calculate and return the number of filesystem blocks per inode cluster */
> +static inline int
> +xfs_icluster_size_fsb(
> +	struct xfs_mount	*mp)
> +{
> +	if (mp->m_sb.sb_blocksize >= mp->m_inode_cluster_size)
> +		return 1;
> +	return mp->m_inode_cluster_size >> mp->m_sb.sb_blocklog;
> +}
> +
>  /*
>   * Make an inode pointer out of the buffer/offset.
>   */
> -- 
> 1.8.3.2
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
