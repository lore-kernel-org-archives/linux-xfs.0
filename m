Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F0C9D7F37
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2015 14:39:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E6B84304067
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2015 12:39:14 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id ErvLrLFfpGwOTFs3 (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 17 Aug 2015 12:39:13 -0700 (PDT)
Date: Mon, 17 Aug 2015 12:39:13 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 11/11] xfsprogs: Add a way to compile without blkid
Message-ID: <20150817193913.GD8444@infradead.org>
References: <1439828606-7886-1-git-send-email-jtulak@redhat.com>
	<1439828606-7886-12-git-send-email-jtulak@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1439828606-7886-12-git-send-email-jtulak@redhat.com>
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
To: Jan Tulak <jtulak@redhat.com>
Cc: hch@infradead.org, xfs@oss.sgi.com

On Mon, Aug 17, 2015 at 06:23:26PM +0200, Jan Tulak wrote:
> UPDATE: default to "signature found", so without blkid is
>         -f mandatory.

Belongs in the cover letter, not this patch.

>  		} else
>  			ft->psectorsize = ft->lsectorsize = BBSIZE;
>  	} else {
> +#ifdef ENABLE_BLKID
>  		blkid_get_topology(dfile, &ft->dsunit, &ft->dswidth,
>  				   &ft->lsectorsize, &ft->psectorsize,
>  				   force_overwrite);
> +#endif /* ENABLE_BLKID */
>  	}
>  
>  	if (xi->rtname && !xi->risfile) {
>  		int sunit, lsectorsize, psectorsize;
>  
> +#ifdef ENABLE_BLKID
>  		blkid_get_topology(xi->rtname, &sunit, &ft->rtswidth,
>  				   &lsectorsize, &psectorsize, force_overwrite);
> +#endif /* ENABLE_BLKID */

I think you need to proide a dummy blkid_get_topology which at least
sets the two sector sizes to 512.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
