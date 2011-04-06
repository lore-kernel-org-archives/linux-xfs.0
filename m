Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p36DuZ6e037711 for <xfs@oss.sgi.com>; Wed, 6 Apr 2011 08:56:35 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 64C2C3AB4DC
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2011 06:59:52 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id LFdRlzGtES8WxNgF for
	<xfs@oss.sgi.com>; Wed, 06 Apr 2011 06:59:52 -0700 (PDT)
Date: Wed, 6 Apr 2011 09:59:51 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 8/9] xfs: catch bad block numbers freeing extents.
Message-ID: <20110406135951.GA24618@infradead.org>
References: <1302070758-17312-1-git-send-email-david@fromorbit.com>
	<1302070758-17312-9-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1302070758-17312-9-git-send-email-david@fromorbit.com>
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

> +	/* validate the extent size is legal now we have the agf locked */
> +	if (!args.agbp) {
> +		error = EFSCORRUPTED;
> +		goto error0;
> +	}

This is not a corruption case, but would require someone changing
xfs_fix_freelist and messing up.  I think the check can be removed
given that the potentially added bug would trivially trip up as
a NULL pointer dereference.

Otherwise looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
