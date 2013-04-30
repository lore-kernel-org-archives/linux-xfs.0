Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4B62E7F5E
	for <xfs@oss.sgi.com>; Tue, 30 Apr 2013 16:31:13 -0500 (CDT)
Date: Tue, 30 Apr 2013 16:31:09 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 3/4] xfs: Remote attr validation fixes and optimisations
Message-ID: <20130430213109.GL29359@sgi.com>
References: <1367321976-18268-1-git-send-email-david@fromorbit.com>
	<1367321976-18268-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1367321976-18268-4-git-send-email-david@fromorbit.com>
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

Hi Dave,

On Tue, Apr 30, 2013 at 09:39:35PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> - optimise the calcuation for the number of blocks in a remote
>   xattr.
> - check attribute length against MAX_XATTR_SIZE, not MAXPATHLEN
> - whitespace fixes
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
  Signed-off-by:

I guess this is what you intended?

Else, looks good to me.

Reviewed-by: Ben Myers <bpm@sgi.com>

Thanks,
	Ben

> ---
>  fs/xfs/xfs_attr_remote.c |   19 +++++--------------
>  1 file changed, 5 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/xfs/xfs_attr_remote.c b/fs/xfs/xfs_attr_remote.c
> index 53da46b..dee8446 100644
> --- a/fs/xfs/xfs_attr_remote.c
> +++ b/fs/xfs/xfs_attr_remote.c
> @@ -52,15 +52,9 @@ xfs_attr3_rmt_blocks(
>  	struct xfs_mount *mp,
>  	int		attrlen)
>  {
> -	int		fsblocks = 0;
> -	int		len = attrlen;
> -
> -	do {
> -		fsblocks++;
> -		len -= XFS_ATTR3_RMT_BUF_SPACE(mp, mp->m_sb.sb_blocksize);
> -	} while (len > 0);
> -
> -	return fsblocks;
> +	int		buflen = XFS_ATTR3_RMT_BUF_SPACE(mp,
> +							 mp->m_sb.sb_blocksize);
> +	return (attrlen + buflen - 1) / buflen;
>  }
>  
>  static bool
> @@ -79,7 +73,7 @@ xfs_attr3_rmt_verify(
>  	if (bp->b_bn != be64_to_cpu(rmt->rm_blkno))
>  		return false;
>  	if (be32_to_cpu(rmt->rm_offset) +
> -				be32_to_cpu(rmt->rm_bytes) >= MAXPATHLEN)
> +				be32_to_cpu(rmt->rm_bytes) >= XATTR_SIZE_MAX)
>  		return false;
>  	if (rmt->rm_owner == 0)
>  		return false;
> @@ -183,7 +177,6 @@ xfs_attr3_rmt_hdr_ok(
>  
>  	/* ok */
>  	return true;
> -
>  }
>  
>  /*
> @@ -367,7 +360,6 @@ xfs_attr_rmtval_set(
>  		 * spill for another block every 9 headers we require in this
>  		 * loop.
>  		 */
> -
>  		if (crcs && blkcnt == 0) {
>  			int total_len;
>  
> @@ -422,9 +414,8 @@ xfs_attr_rmtval_set(
>  
>  		byte_cnt = BBTOB(bp->b_length);
>  		byte_cnt = XFS_ATTR3_RMT_BUF_SPACE(mp, byte_cnt);
> -		if (valuelen < byte_cnt) {
> +		if (valuelen < byte_cnt)
>  			byte_cnt = valuelen;
> -		}
>  
>  		buf = bp->b_addr;
>  		buf += xfs_attr3_rmt_hdr_set(mp, dp->i_ino, offset,
> -- 
> 1.7.10.4
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
