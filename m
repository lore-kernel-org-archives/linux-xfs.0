Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 712407F37
	for <xfs@oss.sgi.com>; Mon, 20 May 2013 18:00:47 -0500 (CDT)
Date: Mon, 20 May 2013 18:00:46 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 10/14] xfs: remote attribute read too short
Message-ID: <20130520230046.GH20028@sgi.com>
References: <1369007481-15185-1-git-send-email-david@fromorbit.com>
	<1369007481-15185-11-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1369007481-15185-11-git-send-email-david@fromorbit.com>
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

On Mon, May 20, 2013 at 09:51:17AM +1000, Dave Chinner wrote:
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
>  }

xfs_attr_rmtval_set, previously the only caller of xfs_attr3_rmt_blocks already
checks for crcs.  Can one of the two conditionals be dispensed with?


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
