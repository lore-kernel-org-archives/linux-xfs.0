Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:51118 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750865AbeFVGd6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Jun 2018 02:33:58 -0400
From: Allison Henderson <allison.henderson@oracle.com>
Subject: Re: [PATCH 4/8] xfs: don't allow insert-range to shift extents past
 the maximum offset
References: <152960586416.26246.8634761888260524091.stgit@magnolia>
 <152960588873.26246.17582272219031862067.stgit@magnolia>
Message-ID: <4126b4b1-e789-1bcc-d8bf-51a44399c18f@oracle.com>
Date: Thu, 21 Jun 2018 23:33:36 -0700
MIME-Version: 1.0
In-Reply-To: <152960588873.26246.17582272219031862067.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, zlang@redhat.com

Ok, you can add my review
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

On 06/21/2018 11:31 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Zorro Lang reports that generic/485 blows an assert on a filesystem with
> 512 byte blocks.  The test tries to fallocate a post-eof extent at the
> maximum file size and calls insert range to shift the extents right by
> two blocks.  On a 512b block filesystem this causes startoff to overflow
> the 54-bit startoff field, leading to the assert.
> 
> Therefore, always check the rightmost extent to see if it would overflow
> prior to invoking the insert range machinery.
> 
> Reported-by: zlang@redhat.com
> Bugzilla: https://urldefense.proofpoint.com/v2/url?u=https-3A__bugzilla.kernel.org_show-5Fbug.cgi-3Fid-3D200137&d=DwICaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=LHZQ8fHvy6wDKXGTWcm97burZH5sQKHRDMaY1UthQxc&m=YCaDC-F1dLxMWur8rwN6LkUZEkB0mCLT1kaX18afe3Y&s=21OAUtb7E_eZcNMI0iepr7J9fg90RHPo0hUJBgJxDrI&e=
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>   fs/xfs/libxfs/xfs_bmap.c |   40 ++++++++++++++++++++++++++++++++++++++++
>   fs/xfs/libxfs/xfs_bmap.h |    2 ++
>   fs/xfs/xfs_bmap_util.c   |    4 ++++
>   3 files changed, 46 insertions(+)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 01628f0c9a0c..b7f094e19bab 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -5780,6 +5780,46 @@ xfs_bmap_collapse_extents(
>   	return error;
>   }
>   
> +#define BMBT_STARTOFF_MASK	((1ULL << BMBT_STARTOFF_BITLEN) - 1)
> +/* Make sure we won't be right-shifting an extent past the maximum bound. */
> +int
> +xfs_bmap_can_insert_extents(
> +	struct xfs_inode	*ip,
> +	xfs_fileoff_t		off,
> +	xfs_fileoff_t		shift)
> +{
> +	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
> +	struct xfs_bmbt_irec	got;
> +	struct xfs_iext_cursor	icur;
> +	xfs_fileoff_t		new_off;
> +	int			error = 0;
> +
> +	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
> +		return -EIO;
> +
> +	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
> +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> +
> +	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
> +		error = xfs_iread_extents(NULL, ip, XFS_DATA_FORK);
> +		if (error)
> +			goto out;
> +	}
> +
> +	xfs_iext_last(ifp, &icur);
> +	if (!xfs_iext_get_extent(ifp, &icur, &got) || off > got.br_startoff)
> +		goto out;
> +
> +	/* Make sure we can't overflow the 54-bit offset field. */
> +	new_off = (got.br_startoff + shift) & BMBT_STARTOFF_MASK;
> +	if (new_off < got.br_startoff)
> +		error = -EINVAL;
> +
> +out:
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +	return error;
> +}
> +
>   int
>   xfs_bmap_insert_extents(
>   	struct xfs_trans	*tp,
> diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
> index 99dddbd0fcc6..9b49ddf99c41 100644
> --- a/fs/xfs/libxfs/xfs_bmap.h
> +++ b/fs/xfs/libxfs/xfs_bmap.h
> @@ -227,6 +227,8 @@ int	xfs_bmap_collapse_extents(struct xfs_trans *tp, struct xfs_inode *ip,
>   		xfs_fileoff_t *next_fsb, xfs_fileoff_t offset_shift_fsb,
>   		bool *done, xfs_fsblock_t *firstblock,
>   		struct xfs_defer_ops *dfops);
> +int	xfs_bmap_can_insert_extents(struct xfs_inode *ip, xfs_fileoff_t off,
> +		xfs_fileoff_t shift);
>   int	xfs_bmap_insert_extents(struct xfs_trans *tp, struct xfs_inode *ip,
>   		xfs_fileoff_t *next_fsb, xfs_fileoff_t offset_shift_fsb,
>   		bool *done, xfs_fileoff_t stop_fsb, xfs_fsblock_t *firstblock,
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index c35009a86699..abc37b0899c0 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1404,6 +1404,10 @@ xfs_insert_file_space(
>   
>   	trace_xfs_insert_file_space(ip);
>   
> +	error = xfs_bmap_can_insert_extents(ip, stop_fsb, shift_fsb);
> +	if (error)
> +		return error;
> +
>   	error = xfs_prepare_shift(ip, offset);
>   	if (error)
>   		return error;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  https://urldefense.proofpoint.com/v2/url?u=http-3A__vger.kernel.org_majordomo-2Dinfo.html&d=DwICaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=LHZQ8fHvy6wDKXGTWcm97burZH5sQKHRDMaY1UthQxc&m=YCaDC-F1dLxMWur8rwN6LkUZEkB0mCLT1kaX18afe3Y&s=RhleurH5wYku58VywlbdBFmjaXSEGIfX7SCThJq1clE&e=
> 
