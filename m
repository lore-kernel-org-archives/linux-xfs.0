Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0AIrBPl029335 for <xfs@oss.sgi.com>; Mon, 10 Jan 2011 12:53:12 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4225FFCDDB5
	for <xfs@oss.sgi.com>; Mon, 10 Jan 2011 10:55:24 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id aspbWQoZ7IzHyClu for
	<xfs@oss.sgi.com>; Mon, 10 Jan 2011 10:55:24 -0800 (PST)
Date: Mon, 10 Jan 2011 13:55:22 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs_repair: multithread phase 2
Message-ID: <20110110185522.GC31325@infradead.org>
References: <1294620248-17098-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1294620248-17098-1-git-send-email-david@fromorbit.com>
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


Looks good except for some trivial nitpicks below,


Reviewed-by: Christoph Hellwig <hch@lst.de>

Btw, your previous patch used just

"repair:" as the Subject prefix, while this one uses xfs_repair.  I
don't really care about, but we should standardize on one.  The more
recent usage seems to include the xfs_ prefix.

> +				     scanfunc_bno : scanfunc_cnt, 0,
> +				     (void *)agcnts);

no need for the void cast.

> +#define SCAN_THREADS 32

this is unused now.

> +	agcnts = malloc(mp->m_sb.sb_agcount * sizeof(*agcnts));
> +	if (!agcnts) {
> +		do_abort(_("no memory for ag header counts\n"));
> +		return;
> +	}
> +	memset(agcnts, 0, mp->m_sb.sb_agcount * sizeof(*agcnts));

this could use a calloc.

>  					break;
> +				case PHASE2_THREADS:
> +					phase2_threads = (int)strtol(val, NULL, 0);
> +					break;

This option also needs to be documented in the man page.  Also shouldn't
we try to handle errors from strtol?  Also maybe strtoul would be a
better choice as we certainly don't want a negative number of threads.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
