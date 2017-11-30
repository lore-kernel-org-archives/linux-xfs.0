Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37724 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751456AbdK3NrD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 30 Nov 2017 08:47:03 -0500
Date: Thu, 30 Nov 2017 08:47:03 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/3] xfs: ubsan fixes
Message-ID: <20171130134702.GA3516@bfoster.bfoster>
References: <151189079681.14861.10709810493861130558.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151189079681.14861.10709810493861130558.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Nov 28, 2017 at 09:39:56AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Fix some complaints from the UBSAN about signed integer addition overflows.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Seems Ok:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_aops.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index a3eeaba..b0cccf8 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -399,7 +399,7 @@ xfs_map_blocks(
>  	       (ip->i_df.if_flags & XFS_IFEXTENTS));
>  	ASSERT(offset <= mp->m_super->s_maxbytes);
>  
> -	if (offset + count > mp->m_super->s_maxbytes)
> +	if ((xfs_ufsize_t)offset + count > mp->m_super->s_maxbytes)
>  		count = mp->m_super->s_maxbytes - offset;
>  	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)offset + count);
>  	offset_fsb = XFS_B_TO_FSBT(mp, offset);
> @@ -1265,7 +1265,7 @@ xfs_map_trim_size(
>  	if (mapping_size > size)
>  		mapping_size = size;
>  	if (offset < i_size_read(inode) &&
> -	    offset + mapping_size >= i_size_read(inode)) {
> +	    (xfs_ufsize_t)offset + mapping_size >= i_size_read(inode)) {
>  		/* limit mapping to block that spans EOF */
>  		mapping_size = roundup_64(i_size_read(inode) - offset,
>  					  i_blocksize(inode));
> @@ -1312,7 +1312,7 @@ xfs_get_blocks(
>  	lockmode = xfs_ilock_data_map_shared(ip);
>  
>  	ASSERT(offset <= mp->m_super->s_maxbytes);
> -	if (offset + size > mp->m_super->s_maxbytes)
> +	if ((xfs_ufsize_t)offset + size > mp->m_super->s_maxbytes)
>  		size = mp->m_super->s_maxbytes - offset;
>  	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)offset + size);
>  	offset_fsb = XFS_B_TO_FSBT(mp, offset);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
