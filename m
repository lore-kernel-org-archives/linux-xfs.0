Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:47596 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753233AbcJSCpI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 18 Oct 2016 22:45:08 -0400
Subject: Re: [PATCH] libxfs: clean up _calc_dquots_per_chunk
References: <20161018233635.GE20337@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <25a4d3b7-4789-f585-9b71-352a2b4240ec@sandeen.net>
Date: Tue, 18 Oct 2016 21:45:05 -0500
MIME-Version: 1.0
In-Reply-To: <20161018233635.GE20337@birch.djwong.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On 10/18/16 6:36 PM, Darrick J. Wong wrote:
> The function xfs_calc_dquots_per_chunk takes a parameter in units
> of basic blocks.  The kernel seems to get the units wrong, but
> userspace got 'fixed' by commenting out the unnecessary conversion.
> Fix both.
> 
> (This is the xfsprogs patch.)
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

ok that's a cleanup ;)

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  libxfs/xfs_dquot_buf.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/libxfs/xfs_dquot_buf.c b/libxfs/xfs_dquot_buf.c
> index 433abe4..aae8854 100644
> --- a/libxfs/xfs_dquot_buf.c
> +++ b/libxfs/xfs_dquot_buf.c
> @@ -200,7 +200,6 @@ xfs_dquot_buf_verify_crc(
>  		ndquots = mp->m_quotainfo->qi_dqperchunk;
>  	else
>  		ndquots = xfs_calc_dquots_per_chunk(bp->b_length);
> -//					XFS_BB_TO_FSB(mp, bp->b_length));
>  
>  	for (i = 0; i < ndquots; i++, d++) {
>  		if (!xfs_verify_cksum((char *)d, sizeof(struct xfs_dqblk),
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
