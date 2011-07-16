Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6GH3sNV003364 for <xfs@oss.sgi.com>; Sat, 16 Jul 2011 12:03:54 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6280316805FD
	for <xfs@oss.sgi.com>; Sat, 16 Jul 2011 10:03:53 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	BTeHxpeFnXCVMVy1 for <xfs@oss.sgi.com>;
	Sat, 16 Jul 2011 10:03:53 -0700 (PDT)
Date: Sat, 16 Jul 2011 13:03:52 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 07/12] xfs: Remove the macro XFS_BUF_PTR
Message-ID: <20110716170352.GB15094@infradead.org>
References: <20110716012105.6629.24407.sendpatchset@chandra-lucid.beaverton.ibm.com>
	<20110716012147.6629.12496.sendpatchset@chandra-lucid.beaverton.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110716012147.6629.12496.sendpatchset@chandra-lucid.beaverton.ibm.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: xfs@oss.sgi.com

> -			memcpy((char *)dabuf->data + off, XFS_BUF_PTR(bp),
> +			memcpy((char *)dabuf->data + off, bp->b_addr,
>  				XFS_BUF_COUNT(bp));
>  		}
>  	}
> @@ -2317,7 +2317,7 @@ xfs_da_buf_clean(xfs_dabuf_t *dabuf)
>  		for (i = off = 0; i < dabuf->nbuf;
>  				i++, off += XFS_BUF_COUNT(bp)) {
>  			bp = dabuf->bps[i];
> -			memcpy(XFS_BUF_PTR(bp), (char *)dabuf->data + off,
> +			memcpy(bp->b_addr, (char *)dabuf->data + off,
>  				XFS_BUF_COUNT(bp));

While not strictly related it would be nice to kill tha (char *) casts
here while you're at it.

Otherwise the patch looks go,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
