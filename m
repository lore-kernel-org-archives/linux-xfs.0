Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F392F7F51
	for <xfs@oss.sgi.com>; Mon,  4 Nov 2013 03:12:46 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AFCB68F8040
	for <xfs@oss.sgi.com>; Mon,  4 Nov 2013 01:12:46 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id xR67t8Bjq9aQmGGC (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 04 Nov 2013 01:12:45 -0800 (PST)
Date: Mon, 4 Nov 2013 01:12:45 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 26/30] xfs_db: avoid libxfs buffer lookup warnings
Message-ID: <20131104091245.GF23564@infradead.org>
References: <1383107481-28937-1-git-send-email-david@fromorbit.com>
	<1383107481-28937-27-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1383107481-28937-27-git-send-email-david@fromorbit.com>
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

>  
> +/*
> + * We are now using libxfs for our IO backend, so we should always try to use
> + * inode cluster buffers rather than filesystem block sized buffers for reading
> + * inodes. This means that we always use the same buffers as libxfs operations
> + * does, and that avoids buffer cache issues caused by overlapping buffers. This
> + * can be seen clearly when trying to read the root inode. Much of this logic is
> + * similar to libxfs_imap().
> + */
>  void
>  set_cur_inode(
>  	xfs_ino_t	ino)
> @@ -632,6 +640,9 @@ set_cur_inode(
>  	xfs_agnumber_t	agno;
>  	xfs_dinode_t	*dip;
>  	int		offset;
> +	int		numblks = blkbb;
> +	xfs_agblock_t	cluster_agbno;
> +
>  
>  	agno = XFS_INO_TO_AGNO(mp, ino);
>  	agino = XFS_INO_TO_AGINO(mp, ino);
> @@ -644,6 +655,24 @@ set_cur_inode(
>  		return;
>  	}
>  	cur_agno = agno;
> +
> +	if (mp->m_inode_cluster_size > mp->m_sb.sb_blocksize &&
> +	    mp->m_inoalign_mask) {
> +		xfs_agblock_t	chunk_agbno;
> +		xfs_agblock_t	offset_agbno;
> +		int		blks_per_cluster;
> +
> +		blks_per_cluster = mp->m_inode_cluster_size >>
> +							mp->m_sb.sb_blocklog;
> +		offset_agbno = agbno & mp->m_inoalign_mask;
> +		chunk_agbno = agbno - offset_agbno;
> +		cluster_agbno = chunk_agbno +
> +			((offset_agbno / blks_per_cluster) * blks_per_cluster);
> +		offset += ((agbno - cluster_agbno) * mp->m_sb.sb_inopblock);
> +		numblks = XFS_FSB_TO_BB(mp, blks_per_cluster);
> +	} else
> +		cluster_agbno = agbno;
> +

Seems like this should be a separate patch?

> -	if (iocur_top->bp)
> +	if (iocur_top->bp) {
>  		libxfs_putbuf(iocur_top->bp);
> +		iocur_top->bp = NULL;
> +	}

This should probably be folded into the patch that started using buffers
in xfs_db.

> +	int		icache_flags;	/* cache init flags */
> +	int		bcache_flags;	/* cache init flags */

The icache_flags aren't used anywhere.  Also I'd really prefer to have
my patch to kill the inode cache istead of adding more changes to it.

> +#ifdef IO_BCOMPARE_CHECK
> +		if (!(libxfs_bcache->c_flags & CACHE_MISCOMPARE_PURGE)) {
> +			fprintf(stderr,
> +	"%lx: Badness in key lookup (length)\n"
> +	"bp=(bno 0x%llx, len %u bytes) key=(bno 0x%llx, len %u bytes)\n",
> +				pthread_self(),
> +				(unsigned long long)bp->b_bn, (int)bp->b_bcount,
> +				(unsigned long long)bkey->blkno,
> +				BBTOB(bkey->bblen));
> +		}
>  #endif

What is the point of the IO_BCOMPARE_CHECK ifdef if we unconditionally
define it?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
