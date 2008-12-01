Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB1C4vOt021423 for <xfs@oss.sgi.com>; Mon, 1 Dec 2008 06:05:01 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C7DC71BE76C3
	for <xfs@oss.sgi.com>; Mon,  1 Dec 2008 04:04:56 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id K3654jZDyogzNAqT for
	<xfs@oss.sgi.com>; Mon, 01 Dec 2008 04:04:56 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat
	Linux)) id 1L77Vq-0006X6-1S
	for xfs@oss.sgi.com; Mon, 01 Dec 2008 12:04:26 +0000
Date: Mon, 1 Dec 2008 07:04:26 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfsidbg: fix uninitialized variable warning
Message-ID: <20081201120426.GA19856@infradead.org>
References: <20081112114609.GB15216@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20081112114609.GB15216@infradead.org>
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
To: xfs@oss.sgi.com

On Wed, Nov 12, 2008 at 06:46:09AM -0500, Christoph Hellwig wrote:
> We don't initializ s.br_state in xfsidbg_btree_trace_record so gcc
> rightly complains about accessing it in xfsidbg_xbirec.  Given that we
> don't get the state value from the tracing code just opencode printing
> the other which actually reduces code size and makes the XFS_BTNUM_BMAP
> case in xfsidbg_btree_trace_record more similar to the others.

Ping?

> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6-xfs/fs/xfs/xfsidbg.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfsidbg.c	2008-11-12 11:14:39.000000000 +0100
> +++ linux-2.6-xfs/fs/xfs/xfsidbg.c	2008-11-12 11:17:14.000000000 +0100
> @@ -2759,16 +2759,11 @@ xfsidbg_btree_trace_record(
>  {
>  	switch (btnum) {
>  	case XFS_BTNUM_BMAP:
> -	{
> -		struct xfs_bmbt_irec s;
> -
> -		s.br_startoff = ((xfs_dfiloff_t)l0 << 32) | (xfs_dfiloff_t)l1;
> -		s.br_startblock = ((xfs_dfsbno_t)l2 << 32) | (xfs_dfsbno_t)l3;
> -		s.br_blockcount = ((xfs_dfilblks_t)l4 << 32) | (xfs_dfilblks_t)l5;
> -
> -		xfsidbg_xbirec(&s);
> +		kdb_printf("startoff %Ld startblock %Lx blockcount %Ld\n",
> +			   ((xfs_dfiloff_t)l0 << 32) | (xfs_dfiloff_t)l1,
> +			   ((xfs_dfsbno_t)l2 << 32) | (xfs_dfsbno_t)l3,
> +			   ((xfs_dfilblks_t)l4 << 32) | (xfs_dfilblks_t)l5);
>  		break;
> -	}
>  	case XFS_BTNUM_BNO:
>  	case XFS_BTNUM_CNT:
>  		qprintf(" startblock = %d, blockcount = %d\n",
> 
> 
---end quoted text---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
