Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24037 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933223AbdKBNy6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 2 Nov 2017 09:54:58 -0400
Date: Thu, 2 Nov 2017 09:54:57 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 11/18] xfs: iterate over extents in
 xfs_bmap_extents_to_btree
Message-ID: <20171102135457.GF16645@bfoster.bfoster>
References: <20171031142230.11755-1-hch@lst.de>
 <20171031142230.11755-12-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171031142230.11755-12-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Tue, Oct 31, 2017 at 04:22:23PM +0200, Christoph Hellwig wrote:
> This actually makes the function very slightly less efficient for now as we
> detour through the expanded irect format between the in-core extent format
> and the on-disk one instead of just endian swapping them.  But with the
> incore extent btree the in-core one will use a different format and the
> representation will be entirely hidden.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_bmap.c | 20 ++++++++------------
>  1 file changed, 8 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 14428d72cf33..56482bf6280d 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -666,14 +666,13 @@ xfs_bmap_extents_to_btree(
>  	xfs_bmbt_rec_t		*arp;		/* child record pointer */
>  	struct xfs_btree_block	*block;		/* btree root block */
>  	xfs_btree_cur_t		*cur;		/* bmap btree cursor */
> -	xfs_bmbt_rec_host_t	*ep;		/* extent record pointer */
>  	int			error;		/* error return value */
> -	xfs_extnum_t		i, cnt;		/* extent record index */
>  	xfs_ifork_t		*ifp;		/* inode fork pointer */
>  	xfs_bmbt_key_t		*kp;		/* root block key pointer */
>  	xfs_mount_t		*mp;		/* mount structure */
> -	xfs_extnum_t		nextents;	/* number of file extents */
>  	xfs_bmbt_ptr_t		*pp;		/* root block address pointer */
> +	struct xfs_bmbt_irec	rec;
> +	xfs_extnum_t		i = 0, cnt = 0;
>  
>  	mp = ip->i_mount;
>  	ASSERT(whichfork != XFS_COW_FORK);
> @@ -752,15 +751,12 @@ xfs_bmap_extents_to_btree(
>  				XFS_BTNUM_BMAP, 0, 0, ip->i_ino,
>  				XFS_BTREE_LONG_PTRS);
>  
> -	arp = XFS_BMBT_REC_ADDR(mp, ablock, 1);
> -	nextents =  xfs_iext_count(ifp);
> -	for (cnt = i = 0; i < nextents; i++) {
> -		ep = xfs_iext_get_ext(ifp, i);
> -		if (!isnullstartblock(xfs_bmbt_get_startblock(ep))) {
> -			arp->l0 = cpu_to_be64(ep->l0);
> -			arp->l1 = cpu_to_be64(ep->l1);
> -			arp++; cnt++;
> -		}
> +	while (xfs_iext_get_extent(ifp, i++, &rec)) {
> +		if (isnullstartblock(rec.br_startblock))
> +			continue;
> +		arp = XFS_BMBT_REC_ADDR(mp, ablock, 1 + cnt);
> +		xfs_bmbt_disk_set_all(arp, &rec);
> +		cnt++;
>  	}
>  	ASSERT(cnt == XFS_IFORK_NEXTENTS(ip, whichfork));
>  	xfs_btree_set_numrecs(ablock, cnt);
> -- 
> 2.14.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
