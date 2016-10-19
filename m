Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:47572 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753233AbcJSCoy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 18 Oct 2016 22:44:54 -0400
Subject: Re: [PATCH] libxfs: clean up _calc_dquots_per_chunk
References: <20161018233554.GD20337@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <ae361df5-0808-7886-c297-4a87ca6fb903@sandeen.net>
Date: Tue, 18 Oct 2016 21:44:50 -0500
MIME-Version: 1.0
In-Reply-To: <20161018233554.GD20337@birch.djwong.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

Well it's not a cleanup - it's fix ;)

On 10/18/16 6:35 PM, Darrick J. Wong wrote:
> The function xfs_calc_dquots_per_chunk takes a parameter in units
> of basic blocks.  The kernel seems to get the units wrong, but
> userspace got 'fixed' by commenting out the unnecessary conversion.
> Fix both.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  fs/xfs/libxfs/xfs_dquot_buf.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
> index 3cc3cf7..ac9a003 100644
> --- a/fs/xfs/libxfs/xfs_dquot_buf.c
> +++ b/fs/xfs/libxfs/xfs_dquot_buf.c
> @@ -191,8 +191,7 @@ xfs_dquot_buf_verify_crc(
>  	if (mp->m_quotainfo)
>  		ndquots = mp->m_quotainfo->qi_dqperchunk;
>  	else
> -		ndquots = xfs_calc_dquots_per_chunk(
> -					XFS_BB_TO_FSB(mp, bp->b_length));
> +		ndquots = xfs_calc_dquots_per_chunk(bp->b_length);
>  
>  	for (i = 0; i < ndquots; i++, d++) {
>  		if (!xfs_verify_cksum((char *)d, sizeof(struct xfs_dqblk),
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
