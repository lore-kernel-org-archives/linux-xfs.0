Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A2EF529E07
	for <xfs@oss.sgi.com>; Tue, 21 May 2013 15:59:25 -0500 (CDT)
Date: Tue, 21 May 2013 15:59:24 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 03/11] xfs: remote attribute read too short
Message-ID: <20130521205924.GM20028@sgi.com>
References: <1369123330-9579-1-git-send-email-david@fromorbit.com>
	<1369123330-9579-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1369123330-9579-4-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, May 21, 2013 at 06:02:02PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Reading a maximally size remote attribute fails when CRCs are
> enabled with this verification error:
> 
> XFS (vdb): remote attribute header does not match required off/len/owner)
> 
> There are two reasons for this, the first being that the
> length of the buffer being read is determined from the
> args->rmtblkcnt which doesn't take into account CRC headers. Hence
> the mapped length ends up being too short and so we need to
> calculate it directly from the value length.
> 
> The second is that the byte count of valid data within a buffer is
> capped by the length of the data and so doesn't take into account
> that the buffer might be longer due to headers. Hence we need to
> calculate the data space in the buffer first before calculating the
> actual byte count of data.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_attr_remote.c |   15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_attr_remote.c b/fs/xfs/xfs_attr_remote.c
> index aad95b0..bcdc07c 100644
> --- a/fs/xfs/xfs_attr_remote.c
> +++ b/fs/xfs/xfs_attr_remote.c
> @@ -52,9 +52,11 @@ xfs_attr3_rmt_blocks(
>  	struct xfs_mount *mp,
>  	int		attrlen)
>  {
> -	int		buflen = XFS_ATTR3_RMT_BUF_SPACE(mp,
> -							 mp->m_sb.sb_blocksize);
> -	return (attrlen + buflen - 1) / buflen;
> +	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> +		int buflen = XFS_ATTR3_RMT_BUF_SPACE(mp, mp->m_sb.sb_blocksize);
> +		return (attrlen + buflen - 1) / buflen;
> +	}
> +	return XFS_B_TO_FSB(mp, attrlen);

xfs_attr_rmtval_set, xfs_attr3_rmt_blocks, and XFS_ATTR3_RMT_BUF_SPACE all have
checks for crcs on the superblock.  It's like I'm seeing stars.

>  }
>  
>  static bool
> @@ -206,8 +208,9 @@ xfs_attr_rmtval_get(
>  
>  	while (valuelen > 0) {
>  		nmap = ATTR_RMTVALUE_MAPSIZE;
> +		blkcnt = xfs_attr3_rmt_blocks(mp, valuelen);
>  		error = xfs_bmapi_read(args->dp, (xfs_fileoff_t)lblkno,
> -				       args->rmtblkcnt, map, &nmap,
> +				       blkcnt, map, &nmap,

Isn't blkcnt wrong on the 2nd or greater iteration of this loop?  Looks like an old bug.

>  				       XFS_BMAPI_ATTRFORK);
>  		if (error)
>  			return error;
> @@ -227,8 +230,8 @@ xfs_attr_rmtval_get(
>  			if (error)
>  				return error;
>  
> -			byte_cnt = min_t(int, valuelen, BBTOB(bp->b_length));
> -			byte_cnt = XFS_ATTR3_RMT_BUF_SPACE(mp, byte_cnt);
> +			byte_cnt = XFS_ATTR3_RMT_BUF_SPACE(mp, BBTOB(bp->b_length));
> +			byte_cnt = min_t(int, valuelen, byte_cnt);

And now byte_cnt reflects the number of bytes in the mapping, less the size of
a header..

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
