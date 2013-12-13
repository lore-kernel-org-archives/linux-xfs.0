Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1C3307F75
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 06:01:51 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 10A79304059
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 04:01:39 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id 0sp9PSCq1OCdl4b2 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 13 Dec 2013 04:01:24 -0800 (PST)
Date: Fri, 13 Dec 2013 04:01:23 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/6] xfs: swalloc doesn't align allocations properly
Message-ID: <20131213120123.GA32749@infradead.org>
References: <1386826478-13846-1-git-send-email-david@fromorbit.com>
	<1386826478-13846-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1386826478-13846-5-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Looks good.

Reviewed-by: Christoph Hellwig <hch@lst.de>

Two very minor nitpicks below:

> +	int		stripe_align;
>  
>  	ASSERT(ap->length);
>  
>  	mp = ap->ip->i_mount;
> +
> +	/* stripe alignment for allocation is determined by mount parameters */
> +	stripe_align = 0;
> +	if (mp->m_swidth && (mp->m_flags & XFS_MOUNT_SWALLOC))
> +		stripe_align = mp->m_swidth;
> +	else if (mp->m_dalign)
> +		stripe_align = mp->m_dalign;

nipick: I'd either initialize the variable to zero at the point of the
declaration or do if .. else if .. else here.

>  	}
> +
> +
>  	nullfb = *ap->firstblock == NULLFSBLOCK;

Two newlines seem odd here.  I'd support one even if that's an unrelated
change :)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
