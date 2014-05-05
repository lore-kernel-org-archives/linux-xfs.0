Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D955629DFD
	for <xfs@oss.sgi.com>; Mon,  5 May 2014 16:10:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 906A0304032
	for <xfs@oss.sgi.com>; Mon,  5 May 2014 14:10:38 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ttk4sFBMQbmpBski for
	<xfs@oss.sgi.com>; Mon, 05 May 2014 14:10:37 -0700 (PDT)
Date: Mon, 5 May 2014 17:10:31 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 5/6] xfsprogs: use xfs_icluster_size_fsb in
	xfs_ialloc_inode_init
Message-ID: <20140505211030.GF13973@laptop.bfoster>
References: <536784D9.1030502@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <536784D9.1030502@oracle.com>
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

On Mon, May 05, 2014 at 08:32:25PM +0800, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> Use xfs_icluster_size_fsb() in xfs_ialloc_inode_init(), rename variable
> ninodes to inodes_per_cluster as the latter is more  meaningful.
> 
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  libxfs/xfs_ialloc.c | 17 +++++------------
>  1 file changed, 5 insertions(+), 12 deletions(-)
> 
> diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
> index a3a1c75..7d2ae8d 100644
> --- a/libxfs/xfs_ialloc.c
> +++ b/libxfs/xfs_ialloc.c
> @@ -146,7 +146,7 @@ xfs_ialloc_inode_init(
>  {
>  	struct xfs_buf		*fbuf;
>  	struct xfs_dinode	*free;
> -	int			blks_per_cluster, nbufs, ninodes;
> +	int			nbufs, blks_per_cluster, inodes_per_cluster;
>  	int			version;
>  	int			i, j;
>  	xfs_daddr_t		d;
> @@ -157,16 +157,9 @@ xfs_ialloc_inode_init(
>  	 * For small block sizes, manipulate the inodes in buffers
>  	 * which are multiples of the blocks size.
>  	 */
> -	if (mp->m_sb.sb_blocksize >= mp->m_inode_cluster_size) {
> -		blks_per_cluster = 1;
> -		nbufs = length;
> -		ninodes = mp->m_sb.sb_inopblock;
> -	} else {
> -		blks_per_cluster = mp->m_inode_cluster_size /
> -				   mp->m_sb.sb_blocksize;
> -		nbufs = length / blks_per_cluster;
> -		ninodes = blks_per_cluster * mp->m_sb.sb_inopblock;
> -	}
> +	blks_per_cluster = xfs_icluster_size_fsb(mp);
> +	inodes_per_cluster = blks_per_cluster << mp->m_sb.sb_inopblog;
> +	nbufs = length / blks_per_cluster;
>  
>  	/*
>  	 * Figure out what version number to use in the inodes we create.  If
> @@ -222,7 +215,7 @@ xfs_ialloc_inode_init(
>  		/* Initialize the inode buffers and log them appropriately. */
>  		fbuf->b_ops = &xfs_inode_buf_ops;
>  		xfs_buf_zero(fbuf, 0, BBTOB(fbuf->b_length));
> -		for (i = 0; i < ninodes; i++) {
> +		for (i = 0; i < inodes_per_cluster; i++) {
>  			int	ioffset = i << mp->m_sb.sb_inodelog;
>  			uint	isize = xfs_dinode_size(version);
>  
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
