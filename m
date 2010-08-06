Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o76D0k7J140954 for <xfs@oss.sgi.com>; Fri, 6 Aug 2010 08:00:48 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E2795F67B1B
	for <xfs@oss.sgi.com>; Fri,  6 Aug 2010 06:01:08 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id lMY4vXejcnDpMsy5 for
	<xfs@oss.sgi.com>; Fri, 06 Aug 2010 06:01:08 -0700 (PDT)
Date: Fri, 6 Aug 2010 09:01:06 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: Reduce log force overhead for delayed logging
Message-ID: <20100806130106.GA16818@infradead.org>
References: <1280801234-23568-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1280801234-23568-1-git-send-email-david@fromorbit.com>
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
Cc: npiggin@kernel.de, xfs@oss.sgi.com

Looks good to me,


Reviewed-by: Christoph Hellwig <hch@lst.de>

minor nitpicks below:

>  int
>  xlog_cil_push(

This can be marked STATIC now.

> +/*
> + * CIL force routines
> + */
> +xfs_lsn_t xlog_cil_force_lsn(struct log *log, xfs_lsn_t sequence);
> +
> +static inline void
> +xlog_cil_force(struct log	*log)
> +{
> +	if (log->l_cilp)
> +		xlog_cil_force_lsn(log, log->l_cilp->xc_current_sequence);
> +}

I'd move the if (log->l_cilp) check to the caller.  One of the two
already does so, as does the caller of xlog_cil_force_lsn.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
