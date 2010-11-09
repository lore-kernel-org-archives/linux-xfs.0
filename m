Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA9Drs7t157118 for <xfs@oss.sgi.com>; Tue, 9 Nov 2010 07:53:54 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1C0444CE0C6
	for <xfs@oss.sgi.com>; Tue,  9 Nov 2010 05:55:22 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id YaE4CslPCT2CUIF9 for
	<xfs@oss.sgi.com>; Tue, 09 Nov 2010 05:55:22 -0800 (PST)
Date: Tue, 9 Nov 2010 08:55:20 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH, RFC] xfs: fix failed write handling
Message-ID: <20101109135520.GA7418@infradead.org>
References: <20101109002559.GA30016@infradead.org>
	<20101109055142.GJ2715@dastard> <20101109113530.GK2715@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101109113530.GK2715@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

> @@ -1020,6 +974,7 @@ out_invalidate:
>  	return;
>  }
>  
> +
>  /*
>   * Write out a dirty page.
>   *

Spurious whitespace change.

> +int
> +xfs_bmap_punch_delalloc_range(
> +	struct xfs_inode	*ip,
> +	xfs_fileoff_t		start,
> +	ssize_t			end)

Making this helper work in terms of FSBs seem a lot cleaner than
making it work in terms of bytes.  Both callers already deal with
FSBs, as does xfs_bunmapi.


Otherwise looks good to me.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
