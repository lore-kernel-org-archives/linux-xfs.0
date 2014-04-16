Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2DE4C7F37
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 08:24:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C9FEFAC004
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 06:24:01 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id GzhDPUc6618A4eXW for
	<xfs@oss.sgi.com>; Wed, 16 Apr 2014 06:24:00 -0700 (PDT)
Date: Wed, 16 Apr 2014 09:23:56 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 8/9] repair: handle remote sylmlink CRC errors
Message-ID: <20140416132356.GB4180@laptop.bfoster>
References: <1397550301-31883-1-git-send-email-david@fromorbit.com>
	<1397550301-31883-9-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1397550301-31883-9-git-send-email-david@fromorbit.com>
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

On Tue, Apr 15, 2014 at 06:25:00PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 

Just a couple nits... otherwise it looks good to me. There's a typo in
the patch subject...

> We can't really repair broken symlink buffer contents, but we can at
> least warn about it and correct the CRC error so the symlink is
> again readable.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  repair/dinode.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/repair/dinode.c b/repair/dinode.c
> index b086bec..51863c4 100644
> --- a/repair/dinode.c
> +++ b/repair/dinode.c
> @@ -1254,6 +1254,7 @@ process_symlink_remote(
>  	while (pathlen > 0) {
>  		int	blk_cnt = 1;
>  		int	byte_cnt;
> +		int	dirty = 0;
>  
>  		fsbno = blkmap_get(blkmap, i);
>  		if (fsbno == NULLDFSBNO) {
> @@ -1284,6 +1285,12 @@ _("cannot read inode %" PRIu64 ", file block %d, disk block %" PRIu64 "\n"),
>  				lino, i, fsbno);
>  			return 1;
>  		}
> +		if (bp->b_error == EFSBADCRC) {
> +			do_warn(
> +_("Bad symlink buffer CRC block %" PRIu64 ", inode %" PRIu64 ".\n"
     "Bad symlink buffer CRC, block ..."

... and sticking a comma or some separator in that message makes it a
little easier to read, IMO.

Brian

> +  "Correcting CRC, but symlink may be bad.\n"), fsbno, lino);
> +			dirty = 1;
> +		}
>  
>  		byte_cnt = XFS_SYMLINK_BUF_SPACE(mp, byte_cnt);
>  		byte_cnt = MIN(pathlen, byte_cnt);
> @@ -1307,7 +1314,10 @@ _("bad symlink header ino %" PRIu64 ", file block %d, disk block %" PRIu64 "\n")
>  		offset += byte_cnt;
>  		i++;
>  
> -		libxfs_putbuf(bp);
> +		if (dirty)
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
