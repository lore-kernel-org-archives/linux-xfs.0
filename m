Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p99NpSJq132643 for <xfs@oss.sgi.com>; Sun, 9 Oct 2011 18:51:28 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9A93A4EF0EE
	for <xfs@oss.sgi.com>; Sun,  9 Oct 2011 16:51:27 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	3psXnyPVFlxTNGtl for <xfs@oss.sgi.com>;
	Sun, 09 Oct 2011 16:51:27 -0700 (PDT)
Date: Sun, 9 Oct 2011 19:51:26 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/5] repair: handle memory allocation failure from
	blkmap_grow
Message-ID: <20111009235126.GC13527@infradead.org>
References: <1318201910-11144-1-git-send-email-david@fromorbit.com>
	<1318201910-11144-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1318201910-11144-4-git-send-email-david@fromorbit.com>
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

>  static blkmap_t *
>  blkmap_grow(
> -	blkmap_t	**blkmapp)
> +	blkmap_t	*blkmap)
>  {
>  	pthread_key_t	key = dblkmap_key;
> -	blkmap_t	*blkmap = *blkmapp;
> +	blkmap_t	*new_blkmap;
> +	int		new_naexts = blkmap->naexts + 4;
>  
>  	if (pthread_getspecific(key) != blkmap) {
>  		key = ablkmap_key;
>  		ASSERT(pthread_getspecific(key) == blkmap);
>  	}
>  
> -	blkmap->naexts += 4;
> -	blkmap = realloc(blkmap, BLKMAP_SIZE(blkmap->naexts));
> -	if (blkmap == NULL)
> - 		do_error(_("realloc failed in blkmap_grow\n"));
> -	*blkmapp = blkmap;
> -	pthread_setspecific(key, blkmap);
> -	return blkmap;
> +	new_blkmap = realloc(blkmap, BLKMAP_SIZE(new_naexts));
> +	if (!new_blkmap) {
> + 		do_error(_("realloc failed in blkmap_grow\n"));
> +		return NULL;
> +	}
> +	blkmap->naexts = new_naexts;

Why would we modify naexts in the old blkmap?

Otherwise looks fine.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
