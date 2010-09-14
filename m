Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8EEtTZa131220 for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 09:55:29 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A9982DD89C1
	for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 08:08:03 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id i20nBqMNEOKW0OSL for
	<xfs@oss.sgi.com>; Tue, 14 Sep 2010 08:08:03 -0700 (PDT)
Date: Tue, 14 Sep 2010 10:56:17 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 08/18] xfs: rename xfs_buf_get_nodaddr to be more
	appropriate
Message-ID: <20100914145617.GF3400@infradead.org>
References: <1284461777-1496-1-git-send-email-david@fromorbit.com>
	<1284461777-1496-9-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1284461777-1496-9-git-send-email-david@fromorbit.com>
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
Cc: xfs@oss.sgi.com

>  xfs_buf_t *
> -xfs_buf_get_noaddr(
> +xfs_buf_get_uncached(
>  	size_t			len,
>  	xfs_buftarg_t		*target)
>  {
> @@ -725,7 +725,7 @@ xfs_buf_get_noaddr(
>  		goto fail_free_buf;
>  
>  	for (i = 0; i < page_count; i++) {
> -		bp->b_pages[i] = alloc_page(GFP_KERNEL);
> +		bp->b_pages[i] = alloc_page(GFP_NOFS);

Instead of doingthis unconditionally I think it's better to add a flags
aregument which can contain XBF_DONT_BLOCK, and then use xb_to_gfp for
the flags.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
