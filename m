Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:55589 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1761338AbdLSGWH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Dec 2017 01:22:07 -0500
Date: Tue, 19 Dec 2017 17:22:05 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 12/13] xfs: create a new buf_ops pointer to verify
 structure metadata
Message-ID: <20171219062205.GV4094@dastard>
References: <151320949282.30654.14805160700975182459.stgit@magnolia>
 <151320956591.30654.3796756077270484760.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151320956591.30654.3796756077270484760.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Dec 13, 2017 at 03:59:25PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Expose all metadata structure buffer verifier functions via buf_ops.
> These will be used by the online scrub mechanism to look for problems
> with buffers that are already sitting around in memory.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
....
> @@ -2468,7 +2478,7 @@ xfs_agf_read_verify(
>  	.verify_write = xfs_attr3_leaf_write_verify,
> +	.verify_struct = xfs_attr3_leaf_verify,
>  };
>  
>  int
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> index d4d2902..1be995b 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> @@ -204,10 +204,42 @@ xfs_attr3_rmt_write_verify(
>  	ASSERT(len == 0);
>  }
>  
> +static xfs_failaddr_t
> +xfs_attr3_rmt_verify_struct(
> +	struct xfs_buf	*bp)
> +{
> +	struct xfs_mount *mp = bp->b_target->bt_mount;
> +	char		*ptr;
> +	void		*failed_at;
> +	int		len;
> +	xfs_daddr_t	bno;
> +	int		blksize = mp->m_attr_geo->blksize;
> +
> +	/* no verification of non-crc buffers */
> +	if (!xfs_sb_version_hascrc(&mp->m_sb))
> +		return NULL;
> +
> +	ptr = bp->b_addr;
> +	bno = bp->b_bn;
> +	len = BBTOB(bp->b_length);
> +	ASSERT(len >= blksize);
> +
> +	while (len > 0) {
> +		if ((failed_at = xfs_attr3_rmt_verify(mp, ptr, blksize, bno)))
> +			return failed_at;
> +		len -= blksize;
> +		ptr += blksize;
> +		bno += BTOBB(blksize);
> +	}
> +
> +	return NULL;
> +}

I'd much prefer to see this combined with
xfs_attr3_rmt_read_verify() rather than having another copy of this
iteration code. They really only vary by whether the CRC is checked
in the loop....

....

> +static xfs_failaddr_t
> +xfs_dquot_buf_verify_struct(
> +	struct xfs_buf	*bp)
> +{
> +	struct xfs_mount	*mp = bp->b_target->bt_mount;
> +
> +	if (!xfs_dquot_buf_verify(mp, bp, 0))
> +		return __this_address;
> +	return NULL;
> +}

I can't remember what happened exactly with dquot buffers earlire in
the patchset, but why isn't it returning a failaddr like all the
other structure verifiers?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
