Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6VKgqTB170541 for <xfs@oss.sgi.com>; Fri, 31 Jul 2009 15:42:54 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 55711143CA87
	for <xfs@oss.sgi.com>; Fri, 31 Jul 2009 13:43:40 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id APwFBVIMhU63TPOa for
	<xfs@oss.sgi.com>; Fri, 31 Jul 2009 13:43:40 -0700 (PDT)
Date: Fri, 31 Jul 2009 16:43:39 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs_db: do bounds checking in frag's scanfunc_bmap
Message-ID: <20090731204339.GA31179@infradead.org>
References: <4A708247.7040509@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A708247.7040509@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs mailing list <xfs@oss.sgi.com>

> @@ -437,15 +437,29 @@ scanfunc_bmap(
>  	int			i;
>  	xfs_bmbt_ptr_t		*pp;
>  	xfs_bmbt_rec_t		*rp;
> +	int			nrecs;
> +
> +	nrecs = be16_to_cpu(block->bb_numrecs);
>  
>  	if (level == 0) {
> +		if (nrecs > mp->m_bmap_dmxr[0]) {
> +			dbprintf(_("invalid numrecs (%u) in %s block\n"),
> +				   nrecs, typtab[btype].name);
> +			return;
> +		}
>  		rp = XFS_BMBT_REC_ADDR(mp, block, 1);
>  		process_bmbt_reclist((xfs_bmbt_rec_32_t *)rp, 
> -				be16_to_cpu(block->bb_numrecs), extmapp);
> +				nrecs, extmapp);
> +		return;
> +	}
> +
> +	if (nrecs > mp->m_bmap_dmxr[1]) {
> +		dbprintf(_("invalid numrecs (%u) in %s block\n"),
> +			   nrecs, typtab[btype].name);
>  		return;
>  	}
>  	pp = XFS_BMBT_PTR_ADDR(mp, block, 1, mp->m_bmap_dmxr[0]);
> -	for (i = 0; i < be16_to_cpu(block->bb_numrecs); i++)
> +	for (i = 0; i < nrecs; i++)
>  		scan_lbtree(be64_to_cpu(pp[i]), level, scanfunc_bmap, extmapp, 
>  									btype);
>  }

Looks good to me.


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
