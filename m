Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 45F8A7CA0
	for <xfs@oss.sgi.com>; Wed, 24 Aug 2016 13:07:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 167F28F8035
	for <xfs@oss.sgi.com>; Wed, 24 Aug 2016 11:07:42 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id xg1wTHg4epGakkYi (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 24 Aug 2016 11:07:41 -0700 (PDT)
Date: Wed, 24 Aug 2016 14:07:38 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: fix superblock inprogress check
Message-ID: <20160824180738.GB8982@bfoster.bfoster>
References: <1471844367-9679-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1471844367-9679-1-git-send-email-david@fromorbit.com>
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
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

On Mon, Aug 22, 2016 at 03:39:27PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> From inspection, the superblock sb_inprogress check is done in the
> verifier and triggered only for the primary superblock via a
> "bp->b_bn == XFS_SB_DADDR" check.
> 
> Unfortunately, the primary superblock is an uncached buffer, and
> hence it is configured by xfs_buf_read_uncached() with:
> 
> 	bp->b_bn = XFS_BUF_DADDR_NULL;  /* always null for uncached buffers */
> 
> And so this check never triggers. Fix it.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_sb.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index 0e3d4f5..4aecc5f 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -583,7 +583,8 @@ xfs_sb_verify(
>  	 * Only check the in progress field for the primary superblock as
>  	 * mkfs.xfs doesn't clear it from secondary superblocks.
>  	 */
> -	return xfs_mount_validate_sb(mp, &sb, bp->b_bn == XFS_SB_DADDR,
> +	return xfs_mount_validate_sb(mp, &sb,
> +				     bp->b_maps[0].bm_bn == XFS_SB_DADDR,
>  				     check_version);
>  }
>  
> -- 
> 2.8.0.rc3
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
