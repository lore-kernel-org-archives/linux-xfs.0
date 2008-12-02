Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB26qFC4027696 for <xfs@oss.sgi.com>; Tue, 2 Dec 2008 00:52:17 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3ABED1641B11
	for <xfs@oss.sgi.com>; Mon,  1 Dec 2008 22:52:14 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 0jNFG00rCF8T6fuD for
	<xfs@oss.sgi.com>; Mon, 01 Dec 2008 22:52:14 -0800 (PST)
Date: Tue, 2 Dec 2008 01:46:35 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [REVIEW] Fix unaligned accesses in IA64 in xfsprogs
Message-ID: <20081202064634.GA10115@infradead.org>
References: <op.ulg0j1bf3jf8g2@pc-bnaujok.melbourne.sgi.com>
	<20081201134205.GA7528@infradead.org>
	<op.ulieotl73jf8g2@pc-bnaujok.melbourne.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <op.ulieotl73jf8g2@pc-bnaujok.melbourne.sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Barry Naujok <bnaujok@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

This patch looks good to go to me.

On Tue, Dec 02, 2008 at 11:37:31AM +1100, Barry Naujok wrote:
> Obviously modifying xfs_bmbt_disk_get_all yields a much smaller patch:
> 
> ===========================================================================
> xfsprogs/db/bmap.c
> ===========================================================================
> 
> --- a/xfsprogs/db/bmap.c	2008-12-02 11:21:00.000000000 +1100
> +++ b/xfsprogs/db/bmap.c	2008-12-02 11:20:41.324928232 +1100
> @@ -277,21 +277,14 @@ convert_extent(
>   	xfs_dfilblks_t		*cp,
>   	int			*fp)
>   {
> -	xfs_bmbt_irec_t irec, *s = &irec;
> -	xfs_bmbt_rec_t rpcopy, *p = &rpcopy;
> +	xfs_bmbt_irec_t		irec;
> 
> -	memmove(&rpcopy, rp, sizeof(rpcopy));
> -	libxfs_bmbt_disk_get_all(p, s);
> +	libxfs_bmbt_disk_get_all(rp, &irec);
> 
> -	if (s->br_state == XFS_EXT_UNWRITTEN) {
> -		*fp = 1;
> -	} else {
> -		*fp = 0;
> -	}
> -
> -	*op = s->br_startoff;
> -	*sp = s->br_startblock;
> -	*cp = s->br_blockcount;
> +	*fp = irec.br_state == XFS_EXT_UNWRITTEN;
> +	*op = irec.br_startoff;
> +	*sp = irec.br_startblock;
> +	*cp = irec.br_blockcount;
>   }
> 
>   void
> 
> ===========================================================================
> xfsprogs/libxfs/xfs_bmap_btree.c
> ===========================================================================
> 
> --- a/xfsprogs/libxfs/xfs_bmap_btree.c	2008-12-02 11:21:00.000000000 +1100
> +++ b/xfsprogs/libxfs/xfs_bmap_btree.c	2008-12-02 11:20:09.553355392 +1100
> @@ -181,7 +181,8 @@ xfs_bmbt_disk_get_all(
>   	xfs_bmbt_rec_t	*r,
>   	xfs_bmbt_irec_t *s)
>   {
> -	__xfs_bmbt_get_all(be64_to_cpu(r->l0), be64_to_cpu(r->l1), s);
> +	__xfs_bmbt_get_all(get_unaligned_be64(&r->l0),
> +				get_unaligned_be64(&r->l1), s);
>   }
> 
>   /*
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
---end quoted text---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
