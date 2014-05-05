Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 51B6A29E17
	for <xfs@oss.sgi.com>; Mon,  5 May 2014 16:10:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3EFAA30404E
	for <xfs@oss.sgi.com>; Mon,  5 May 2014 14:10:43 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id HkF4xPeTv1f9Csoq for
	<xfs@oss.sgi.com>; Mon, 05 May 2014 14:10:42 -0700 (PDT)
Date: Mon, 5 May 2014 17:10:39 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 6/6] use xfs_icluster_size_fsb in xfs_imap
Message-ID: <20140505211038.GG13973@laptop.bfoster>
References: <536784DF.5040509@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <536784DF.5040509@oracle.com>
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

On Mon, May 05, 2014 at 08:32:31PM +0800, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> Use xfs_icluster_size_fsb() in xfs_imap().
> 
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  libxfs/xfs_ialloc.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
> index 7d2ae8d..c8967db 100644
> --- a/libxfs/xfs_ialloc.c
> +++ b/libxfs/xfs_ialloc.c
> @@ -1353,7 +1353,7 @@ xfs_imap(
>  		return XFS_ERROR(EINVAL);
>  	}
>  
> -	blks_per_cluster = mp->m_inode_cluster_size >> mp->m_sb.sb_blocklog;
> +	blks_per_cluster = xfs_icluster_size_fsb(mp);
>  
>  	/*
>  	 * For bulkstat and handle lookups, we have an untrusted inode number
> @@ -1374,7 +1374,7 @@ xfs_imap(
>  	 * If the inode cluster size is the same as the blocksize or
>  	 * smaller we get to the buffer by simple arithmetics.
>  	 */
> -	if (mp->m_inode_cluster_size <= mp->m_sb.sb_blocksize) {
> +	if (blks_per_cluster == 1) {
>  		offset = XFS_INO_TO_OFFSET(mp, ino);
>  		ASSERT(offset < mp->m_sb.sb_inopblock);
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
