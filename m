Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q98HAKFD117920 for <xfs@oss.sgi.com>; Mon, 8 Oct 2012 12:10:20 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id wI91z4jadPGYlAUI for
	<xfs@oss.sgi.com>; Mon, 08 Oct 2012 10:11:49 -0700 (PDT)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q98HBmhx009398
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 8 Oct 2012 13:11:49 -0400
Received: from andromeda.usersys.redhat.com (ovpn-113-140.phx2.redhat.com
	[10.3.113.140])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id q98HBjEW013360
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 8 Oct 2012 13:11:47 -0400
Date: Mon, 8 Oct 2012 14:11:44 -0300
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfs: growfs: don't read garbage for new secondary
	superblocks
Message-ID: <20121008171144.GA8313@andromeda.usersys.redhat.com>
References: <1349697436-14203-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1349697436-14203-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On Mon, Oct 08, 2012 at 10:57:16PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When updating new secondary superblocks in a growfs operation, the
> sueprblock buffer is read from the newly grown region of the
> underlying device. This is not guaranteed to be zero, so violates
> the underlying assumption that the unused parts of superblocks are
> zero filled. Get a new buffer for these secondary superblocks to
> ensure that the unused regions are zero filled correctly.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_fsops.c |   21 +++++++++++++++++++--
>  1 file changed, 19 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index c25b094..4beaede 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -399,9 +399,26 @@ xfs_growfs_data_private(
>  
>  	/* update secondary superblocks. */
>  	for (agno = 1; agno < nagcount; agno++) {
> -		error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp,
> +		error = 0;
> +		/*
> +		 * new secondary superblocks need to be zeroed, not read from
> +		 * disk as the contents of the new area we are growing into is
> +		 * completely unknown.
> +		 */
> +		if (agno < oagcount) {
> +			error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp,
>  				  XFS_AGB_TO_DADDR(mp, agno, XFS_SB_BLOCK(mp)),
>  				  XFS_FSS_TO_BB(mp, 1), 0, &bp);
> +		} else {
> +			bp = xfs_trans_get_buf(NULL, mp->m_ddev_targp,
> +				  XFS_AGB_TO_DADDR(mp, agno, XFS_SB_BLOCK(mp)),
> +				  XFS_FSS_TO_BB(mp, 1), 0);
> +			if (bp)
> +				xfs_buf_zero(bp, 0, BBTOB(bp->b_length));
> +			else
> +				error = ENOMEM;
> +		}
> +
>  		if (error) {
>  			xfs_warn(mp,
>  		"error %d reading secondary superblock for ag %d",
> @@ -423,7 +440,7 @@ xfs_growfs_data_private(
>  			break; /* no point in continuing */
>  		}
>  	}
> -	return 0;
> +	return error;
>  
>   error0:
>  	xfs_trans_cancel(tp, XFS_TRANS_ABORT);
> -- 
> 1.7.10
> 

Looks good.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

-- 
--Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
