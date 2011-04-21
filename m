Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3L4mZ8Y134777 for <xfs@oss.sgi.com>; Wed, 20 Apr 2011 23:48:36 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B80BB150785C
	for <xfs@oss.sgi.com>; Wed, 20 Apr 2011 21:52:03 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 6Oy1XMFkjRTvJ7XZ for
	<xfs@oss.sgi.com>; Wed, 20 Apr 2011 21:52:03 -0700 (PDT)
Date: Thu, 21 Apr 2011 00:52:03 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/4] xfs: reset buffer pointers before freeing them
Message-ID: <20110421045203.GB28859@infradead.org>
References: <1303360144-10632-1-git-send-email-david@fromorbit.com>
	<1303360144-10632-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1303360144-10632-4-git-send-email-david@fromorbit.com>
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

>  		ealign = round_down(end_block, sectbb);
>  		if (j == 0 && (start_block + endcount > ealign)) {
> -			offset = XFS_BUF_PTR(bp);
> -			balign = BBTOB(ealign - start_block);
> -			error = XFS_BUF_SET_PTR(bp, offset + balign,
> -						BBTOB(sectbb));
> +			balign = ealign - start_block;
> +			offset = XFS_BUF_PTR(bp) + BBTOB(balign);
> +			error = xlog_bread_offset(log, ealign, sectbb,
> +							bp, offset);

I'd remove the use of balign entirely here.  The first use of this
variable earlier in the functions is for something entirely different,
so it's rather confusing.  (I only looked into that because I remember
some align variable beeing used later on, but that was elsewhere)

Otherwise looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
