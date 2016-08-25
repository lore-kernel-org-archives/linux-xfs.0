Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 31D367CA0
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 07:38:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CD29330405F
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 05:38:03 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id wnGbHh4A9CIhGX6e (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 05:38:02 -0700 (PDT)
Date: Thu, 25 Aug 2016 08:38:00 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/4] xfs: move xfs_bmbt_to_iomap up
Message-ID: <20160825123800.GA25041@bfoster.bfoster>
References: <1471816273-28940-1-git-send-email-hch@lst.de>
	<1471816273-28940-2-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1471816273-28940-2-git-send-email-hch@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Sun, Aug 21, 2016 at 11:51:10PM +0200, Christoph Hellwig wrote:
> We'll need it earlier in the file soon, so the unchanged function to the
> top of xfs_iomap.c
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_iomap.c | 52 ++++++++++++++++++++++++++--------------------------
>  1 file changed, 26 insertions(+), 26 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 2af0dda..ba3592f 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -44,6 +44,32 @@
>  						<< mp->m_writeio_log)
>  #define XFS_WRITE_IMAPS		XFS_BMAP_MAX_NMAP
>  
> +void
> +xfs_bmbt_to_iomap(
> +	struct xfs_inode	*ip,
> +	struct iomap		*iomap,
> +	struct xfs_bmbt_irec	*imap)
> +{
> +	struct xfs_mount	*mp = ip->i_mount;
> +
> +	if (imap->br_startblock == HOLESTARTBLOCK) {
> +		iomap->blkno = IOMAP_NULL_BLOCK;
> +		iomap->type = IOMAP_HOLE;
> +	} else if (imap->br_startblock == DELAYSTARTBLOCK) {
> +		iomap->blkno = IOMAP_NULL_BLOCK;
> +		iomap->type = IOMAP_DELALLOC;
> +	} else {
> +		iomap->blkno = xfs_fsb_to_db(ip, imap->br_startblock);
> +		if (imap->br_state == XFS_EXT_UNWRITTEN)
> +			iomap->type = IOMAP_UNWRITTEN;
> +		else
> +			iomap->type = IOMAP_MAPPED;
> +	}
> +	iomap->offset = XFS_FSB_TO_B(mp, imap->br_startoff);
> +	iomap->length = XFS_FSB_TO_B(mp, imap->br_blockcount);
> +	iomap->bdev = xfs_find_bdev_for_inode(VFS_I(ip));
> +}
> +
>  STATIC int
>  xfs_iomap_eof_align_last_fsb(
>  	xfs_mount_t	*mp,
> @@ -947,32 +973,6 @@ error_on_bmapi_transaction:
>  	return error;
>  }
>  
> -void
> -xfs_bmbt_to_iomap(
> -	struct xfs_inode	*ip,
> -	struct iomap		*iomap,
> -	struct xfs_bmbt_irec	*imap)
> -{
> -	struct xfs_mount	*mp = ip->i_mount;
> -
> -	if (imap->br_startblock == HOLESTARTBLOCK) {
> -		iomap->blkno = IOMAP_NULL_BLOCK;
> -		iomap->type = IOMAP_HOLE;
> -	} else if (imap->br_startblock == DELAYSTARTBLOCK) {
> -		iomap->blkno = IOMAP_NULL_BLOCK;
> -		iomap->type = IOMAP_DELALLOC;
> -	} else {
> -		iomap->blkno = xfs_fsb_to_db(ip, imap->br_startblock);
> -		if (imap->br_state == XFS_EXT_UNWRITTEN)
> -			iomap->type = IOMAP_UNWRITTEN;
> -		else
> -			iomap->type = IOMAP_MAPPED;
> -	}
> -	iomap->offset = XFS_FSB_TO_B(mp, imap->br_startoff);
> -	iomap->length = XFS_FSB_TO_B(mp, imap->br_blockcount);
> -	iomap->bdev = xfs_find_bdev_for_inode(VFS_I(ip));
> -}
> -
>  static inline bool imap_needs_alloc(struct xfs_bmbt_irec *imap, int nimaps)
>  {
>  	return !nimaps ||
> -- 
> 2.1.4
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
