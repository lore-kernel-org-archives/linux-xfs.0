Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:50772 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752417AbeEOUun (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 15 May 2018 16:50:43 -0400
Subject: Re: [PATCH] xfs: change xfs_update_secondary_supers to use
 xfS_sb_read_secondary
References: <20180515204721.GM4933@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <512fcda2-e649-846d-65f8-6c927779e6cb@sandeen.net>
Date: Tue, 15 May 2018 15:50:40 -0500
MIME-Version: 1.0
In-Reply-To: <20180515204721.GM4933@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On 5/15/18 3:47 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Use the new helper to read secondary superblocks instead of opencoding
> it ourselves.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, sorry I forgot^Wdidn't know that existed.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>   fs/xfs/xfs_fsops.c |   10 ++++------
>   1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index 056a76689197..40c131ebf772 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -191,18 +191,15 @@ xfs_growfs_data_private(
>    */
>   int
>   xfs_update_secondary_supers(
> -	xfs_mount_t		*mp)
> +	struct xfs_mount	*mp)
>   {
> -	int			error, saved_error;
> +	struct xfs_buf		*bp;
>   	xfs_agnumber_t		agno;
> -	xfs_buf_t		*bp;
> +	int			error, saved_error;
>   
>   	error = saved_error = 0;
>   
>   	for (agno = 1; agno < mp->m_sb.sb_agcount; agno++) {
> -		error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp,
> -			  XFS_AGB_TO_DADDR(mp, agno, XFS_SB_BLOCK(mp)),
> -			  XFS_FSS_TO_BB(mp, 1), 0, &bp, &xfs_sb_buf_ops);
>   		/*
>   		 * If we get an error reading or writing alternate superblocks,
>   		 * continue.  xfs_repair chooses the "best" superblock based
> @@ -210,6 +207,7 @@ xfs_update_secondary_supers(
>   		 * superblocks un-updated than updated, and xfs_repair may
>   		 * pick them over the properly-updated primary.
>   		 */
> +		error = xfs_sb_read_secondary(mp, NULL, agno, &bp);
>   		if (error) {
>   			xfs_warn(mp,
>   		"error %d reading secondary superblock for ag %d",
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
