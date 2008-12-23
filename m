Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBN0hl71016920 for <xfs@oss.sgi.com>; Mon, 22 Dec 2008 18:43:47 -0600
Message-ID: <49503495.1050207@sgi.com>
Date: Tue, 23 Dec 2008 11:45:09 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] handle unaligned data in xfs_bmbt_disk_get_all
References: <20081222145906.GA18859@infradead.org>
In-Reply-To: <20081222145906.GA18859@infradead.org>
Reply-To: lachlan@sgi.com
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Looks good.

Christoph Hellwig wrote:
> In libxfs xfs_bmbt_disk_get_all needs to handle unaligned data and thus
> has been updated to use get_unaligned_be64.  In kernelspace we don't strictly
> need it as the routine is only used for tracing and xfsidbg, but let's keep
> the two implementations in sync.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfs/fs/xfs/xfs_bmap_btree.c
> --- xfs.orig/fs/xfs/xfs_bmap_btree.c	2008-12-19 15:02:53.998907997 +0100
> +++ xfs/fs/xfs/xfs_bmap_btree.c	2008-12-22 14:43:41.507247175 +0100
> @@ -208,7 +208,8 @@ xfs_bmbt_disk_get_all(
>  	xfs_bmbt_rec_t	*r,
>  	xfs_bmbt_irec_t *s)
>  {
> -	__xfs_bmbt_get_all(be64_to_cpu(r->l0), be64_to_cpu(r->l1), s);
> +	__xfs_bmbt_get_all(get_unaligned_be64(&r->l0),
> +				get_unaligned_be64(&r->l1), s);
>  }
>  
>  /*
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
