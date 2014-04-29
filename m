Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 441AE29E02
	for <xfs@oss.sgi.com>; Tue, 29 Apr 2014 09:06:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1618B8F8035
	for <xfs@oss.sgi.com>; Tue, 29 Apr 2014 07:06:31 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id WwoD7CgyTaqCFt0K for
	<xfs@oss.sgi.com>; Tue, 29 Apr 2014 07:06:30 -0700 (PDT)
Date: Tue, 29 Apr 2014 10:06:27 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 8/9] repair: handle remote symlink CRC errors
Message-ID: <20140429140627.GD59046@bfoster.bfoster>
References: <1398719099-19194-1-git-send-email-david@fromorbit.com>
	<1398719099-19194-9-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1398719099-19194-9-git-send-email-david@fromorbit.com>
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

On Tue, Apr 29, 2014 at 07:04:58AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We can't really repair broken symlink buffer contents, but we can at
> least warn about it and correct the CRC error so the symlink is
> again readable.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  repair/dinode.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/repair/dinode.c b/repair/dinode.c
> index b086bec..8891e84 100644
> --- a/repair/dinode.c
> +++ b/repair/dinode.c
> @@ -1254,6 +1254,7 @@ process_symlink_remote(
>  	while (pathlen > 0) {
>  		int	blk_cnt = 1;
>  		int	byte_cnt;
> +		int	badcrc = 0;
>  
>  		fsbno = blkmap_get(blkmap, i);
>  		if (fsbno == NULLDFSBNO) {
> @@ -1284,6 +1285,12 @@ _("cannot read inode %" PRIu64 ", file block %d, disk block %" PRIu64 "\n"),
>  				lino, i, fsbno);
>  			return 1;
>  		}
> +		if (bp->b_error == EFSBADCRC) {
> +			do_warn(
> +_("Bad symlink buffer CRC, block %" PRIu64 ", inode %" PRIu64 ".\n"
> +  "Correcting CRC, but symlink may be bad.\n"), fsbno, lino);
> +			badcrc = 1;
> +		}
>  
>  		byte_cnt = XFS_SYMLINK_BUF_SPACE(mp, byte_cnt);
>  		byte_cnt = MIN(pathlen, byte_cnt);
> @@ -1307,7 +1314,10 @@ _("bad symlink header ino %" PRIu64 ", file block %d, disk block %" PRIu64 "\n")
>  		offset += byte_cnt;
>  		i++;
>  
> -		libxfs_putbuf(bp);
> +		if (badcrc && !no_modify)
> +			libxfs_writebuf(bp, 0);
> +		else
> +			libxfs_putbuf(bp);
>  	}
>  	return 0;
>  }
> -- 
> 1.9.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
