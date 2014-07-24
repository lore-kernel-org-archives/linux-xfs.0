Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A7C797F5A
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 17:50:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 43153AC005
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 15:50:46 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	auWqM6a9N6U7EIKA for <xfs@oss.sgi.com>;
	Thu, 24 Jul 2014 15:50:43 -0700 (PDT)
Date: Fri, 25 Jul 2014 08:50:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 11/18] xfs: reduce min. inode allocation space
	requirement for sparse inode chunks
Message-ID: <20140724225038.GT20518@dastard>
References: <1406211788-63206-1-git-send-email-bfoster@redhat.com>
	<1406211788-63206-12-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1406211788-63206-12-git-send-email-bfoster@redhat.com>
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

On Thu, Jul 24, 2014 at 10:23:01AM -0400, Brian Foster wrote:
> xfs_ialloc_ag_select() iterates through the allocation groups looking
> for free inodes or free space to determine whether to allow an inode
> allocation to proceed. If no free inodes are available, it assumes that
> an AG must have an extent longer than mp->m_ialloc_blks.
> 
> Sparse inode chunk support currently allows for allocations as small as
> the cluster size. If sparse inodes are supported, use the cluster
> alignment as a minimum extent size limit to determine whether an inode
> chunk allocation attempt can proceed.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_ialloc.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index 4dd45c2..4e98a21 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -770,9 +770,15 @@ xfs_ialloc_ag_select(
>  
>  		/*
>  		 * Is there enough free space for the file plus a block of
> -		 * inodes? (if we need to allocate some)?
> +		 * inodes? (if we need to allocate some)? If sparse inode chunks
> +		 * are supported, we only require an extent of length equal to
> +		 * the cluster size.
>  		 */
> -		ineed = mp->m_ialloc_blks;
> +		if (xfs_sb_version_hassparseinodes(&mp->m_sb))
> +			ineed = xfs_ialloc_cluster_alignment(mp);
> +		else
> +			ineed = mp->m_ialloc_blks;

Why wouldn't we calculate this once at mount time and dump it in
mp->m_ialloc_min_blks? And if we don't have sparse inodes enabled,
when would be ever select an AG that would trigger a sparse
allocation and then turn the feature bit on?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
