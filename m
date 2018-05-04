Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:43302 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751621AbeEDWKA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 May 2018 18:10:00 -0400
Date: Fri, 4 May 2018 15:09:38 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 4/5] xfs: add full xfs_dqblk verifier
Message-ID: <20180504220938.GR26569@magnolia>
References: <f5d059e3-28de-e365-acd4-d82aa9d17db7@redhat.com>
 <e3e2b0af-c505-8164-5868-c9e05fc1edcc@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e3e2b0af-c505-8164-5868-c9e05fc1edcc@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Fri, May 04, 2018 at 12:35:05PM -0500, Eric Sandeen wrote:
> Add an xfs_dqblk verifier so that it can check the uuid on V5 filesystems;
> it calls the existing xfs_dquot_verify verifier to validate the
> xfs_disk_dquot_t contained inside it.  This lets us move the uuid
> verification out of the crc verifier, which makes little sense.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_dquot_buf.c  | 27 ++++++++++++++++++++++-----
>  fs/xfs/libxfs/xfs_quota_defs.h |  2 ++
>  fs/xfs/xfs_dquot.c             | 10 +++++-----
>  fs/xfs/xfs_qm.c                |  2 +-
>  4 files changed, 30 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
> index 3b92427883fa..d71c0b53536b 100644
> --- a/fs/xfs/libxfs/xfs_dquot_buf.c
> +++ b/fs/xfs/libxfs/xfs_dquot_buf.c
> @@ -41,7 +41,12 @@ xfs_calc_dquots_per_chunk(
>  
>  /*
>   * Do some primitive error checking on ondisk dquot data structures.
> + *
> + * The xfs_dqblk structure /contains/ the xfs_disk_dquot structure;
> + * we verify them separately because at some points we have only the
> + * smaller xfs_disk_dquot structure available.
>   */
> +
>  xfs_failaddr_t
>  xfs_dquot_verify(
>  	struct xfs_mount *mp,
> @@ -100,6 +105,20 @@ xfs_dquot_verify(
>  	return NULL;
>  }
>  
> +xfs_failaddr_t
> +xfs_dqblk_verify(
> +	struct xfs_mount	*mp,
> +	struct xfs_dqblk	*dqb,
> +	xfs_dqid_t	 	id,
> +	uint		 	type)	/* used only during quotacheck */
> +{
> +	if (xfs_sb_version_hascrc(&mp->m_sb) &&
> +	    !uuid_equal(&dqb->dd_uuid, &mp->m_sb.sb_meta_uuid))
> +			return __this_address;
> +
> +	return xfs_dquot_verify(mp, &dqb->dd_diskdq, id, type);
> +}
> +
>  /*
>   * Do some primitive error checking on ondisk dquot data structures.
>   */
> @@ -156,8 +175,6 @@ xfs_dquot_buf_verify_crc(
>  		if (!xfs_verify_cksum((char *)d, sizeof(struct xfs_dqblk),
>  				 XFS_DQUOT_CRC_OFF))
>  			return false;
> -		if (!uuid_equal(&d->dd_uuid, &mp->m_sb.sb_meta_uuid))
> -			return false;
>  	}
>  	return true;
>  }
> @@ -167,7 +184,7 @@ xfs_dquot_buf_verify(
>  	struct xfs_mount	*mp,
>  	struct xfs_buf		*bp)
>  {
> -	struct xfs_dqblk	*d = (struct xfs_dqblk *)bp->b_addr;
> +	struct xfs_dqblk	*dqb = (struct xfs_dqblk *)bp->b_addr;
>  	xfs_failaddr_t		fa;
>  	xfs_dqid_t		id = 0;
>  	int			ndquots;
> @@ -193,12 +210,12 @@ xfs_dquot_buf_verify(
>  	for (i = 0; i < ndquots; i++) {
>  		struct xfs_disk_dquot	*ddq;
>  
> -		ddq = &d[i].dd_diskdq;
> +		ddq = &dqb[i].dd_diskdq;
>  
>  		if (i == 0)
>  			id = be32_to_cpu(ddq->d_id);
>  
> -		fa = xfs_dquot_verify(mp, ddq, id + i, 0);
> +		fa = xfs_dqblk_verify(mp, &dqb[i], id + i, 0);
>  		if (fa)
>  			return fa;
>  	}
> diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
> index a2f8cb334bb3..1aac52d7fef4 100644
> --- a/fs/xfs/libxfs/xfs_quota_defs.h
> +++ b/fs/xfs/libxfs/xfs_quota_defs.h
> @@ -153,6 +153,8 @@ typedef uint16_t	xfs_qwarncnt_t;
>  
>  extern xfs_failaddr_t xfs_dquot_verify(struct xfs_mount *mp,
>  		struct xfs_disk_dquot *ddq, xfs_dqid_t id, uint type);
> +extern xfs_failaddr_t xfs_dqblk_verify(struct xfs_mount *mp,
> +		struct xfs_dqblk *dqb, xfs_dqid_t id, uint type);
>  extern int xfs_calc_dquots_per_chunk(unsigned int nbblks);
>  extern int xfs_dqblk_repair(struct xfs_mount *mp, struct xfs_dqblk *dqb,
>  		xfs_dqid_t id, uint type);
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 8d378f485260..d0880c1add41 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -953,6 +953,7 @@ xfs_qm_dqflush(
>  {
>  	struct xfs_mount	*mp = dqp->q_mount;
>  	struct xfs_buf		*bp;
> +	struct xfs_dqblk	*dqb;
>  	struct xfs_disk_dquot	*ddqp;
>  	xfs_failaddr_t		fa;
>  	int			error;
> @@ -996,12 +997,13 @@ xfs_qm_dqflush(
>  	/*
>  	 * Calculate the location of the dquot inside the buffer.
>  	 */
> -	ddqp = bp->b_addr + dqp->q_bufoffset;
> +	dqb = bp->b_addr + dqp->q_bufoffset;
> +	ddqp = &dqb->dd_diskdq;
>  
>  	/*
> -	 * A simple sanity check in case we got a corrupted dquot..
> +	 * A simple sanity check in case we got a corrupted dquot.
>  	 */
> -	fa = xfs_dquot_verify(mp, &dqp->q_core, be32_to_cpu(ddqp->d_id), 0);
> +	fa = xfs_dqblk_verify(mp, dqb, be32_to_cpu(ddqp->d_id), 0);
>  	if (fa) {
>  		xfs_alert(mp, "corrupt dquot ID 0x%x in memory at %pS",
>  				be32_to_cpu(ddqp->d_id), fa);
> @@ -1032,8 +1034,6 @@ xfs_qm_dqflush(
>  	 * of a dquot without an up-to-date CRC getting to disk.
>  	 */
>  	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> -		struct xfs_dqblk *dqb = (struct xfs_dqblk *)ddqp;
> -
>  		dqb->dd_lsn = cpu_to_be64(dqp->q_logitem.qli_item.li_lsn);
>  		xfs_update_cksum((char *)dqb, sizeof(struct xfs_dqblk),
>  				 XFS_DQUOT_CRC_OFF);
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 6690b938d450..3138c06b68a6 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -865,7 +865,7 @@ xfs_qm_reset_dqcounts(
>  		 * find uninitialised dquot blks. See comment in
>  		 * xfs_dquot_verify.
>  		 */
> -		fa = xfs_dquot_verify(mp, ddq, id + j, type);
> +		fa = xfs_dqblk_verify(mp, &dqb[j], id + j, type);
>  		if (fa)
>  			xfs_dqblk_repair(mp, &dqb[j], id + j, type);
>  
> -- 
> 2.17.0
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
