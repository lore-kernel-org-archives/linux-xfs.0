Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D5C2E7F9D
	for <xfs@oss.sgi.com>; Mon,  4 Nov 2013 18:52:55 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4FB27AC002
	for <xfs@oss.sgi.com>; Mon,  4 Nov 2013 16:52:55 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	GQMBVEXIPm9t2jKf for <xfs@oss.sgi.com>;
	Mon, 04 Nov 2013 16:52:53 -0800 (PST)
Date: Tue, 5 Nov 2013 11:52:48 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 26/30] xfs_db: avoid libxfs buffer lookup warnings
Message-ID: <20131105005248.GV6188@dastard>
References: <1383107481-28937-1-git-send-email-david@fromorbit.com>
	<1383107481-28937-27-git-send-email-david@fromorbit.com>
	<20131104091245.GF23564@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131104091245.GF23564@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Nov 04, 2013 at 01:12:45AM -0800, Christoph Hellwig wrote:
> >  
> > +/*
> > + * We are now using libxfs for our IO backend, so we should always try to use
> > + * inode cluster buffers rather than filesystem block sized buffers for reading
> > + * inodes. This means that we always use the same buffers as libxfs operations
> > + * does, and that avoids buffer cache issues caused by overlapping buffers. This
> > + * can be seen clearly when trying to read the root inode. Much of this logic is
> > + * similar to libxfs_imap().
> > + */
> >  void
> >  set_cur_inode(
> >  	xfs_ino_t	ino)
> > @@ -632,6 +640,9 @@ set_cur_inode(
> >  	xfs_agnumber_t	agno;
> >  	xfs_dinode_t	*dip;
> >  	int		offset;
> > +	int		numblks = blkbb;
> > +	xfs_agblock_t	cluster_agbno;
> > +
> >  
> >  	agno = XFS_INO_TO_AGNO(mp, ino);
> >  	agino = XFS_INO_TO_AGINO(mp, ino);
> > @@ -644,6 +655,24 @@ set_cur_inode(
> >  		return;
> >  	}
> >  	cur_agno = agno;
> > +
> > +	if (mp->m_inode_cluster_size > mp->m_sb.sb_blocksize &&
> > +	    mp->m_inoalign_mask) {
> > +		xfs_agblock_t	chunk_agbno;
> > +		xfs_agblock_t	offset_agbno;
> > +		int		blks_per_cluster;
> > +
> > +		blks_per_cluster = mp->m_inode_cluster_size >>
> > +							mp->m_sb.sb_blocklog;
> > +		offset_agbno = agbno & mp->m_inoalign_mask;
> > +		chunk_agbno = agbno - offset_agbno;
> > +		cluster_agbno = chunk_agbno +
> > +			((offset_agbno / blks_per_cluster) * blks_per_cluster);
> > +		offset += ((agbno - cluster_agbno) * mp->m_sb.sb_inopblock);
> > +		numblks = XFS_FSB_TO_BB(mp, blks_per_cluster);
> > +	} else
> > +		cluster_agbno = agbno;
> > +
> 
> Seems like this should be a separate patch?

Yes, probably should be.

> > -	if (iocur_top->bp)
> > +	if (iocur_top->bp) {
> >  		libxfs_putbuf(iocur_top->bp);
> > +		iocur_top->bp = NULL;
> > +	}
> 
> This should probably be folded into the patch that started using buffers
> in xfs_db.

Will do.

> 
> > +	int		icache_flags;	/* cache init flags */
> > +	int		bcache_flags;	/* cache init flags */
> 
> The icache_flags aren't used anywhere.  Also I'd really prefer to have
> my patch to kill the inode cache istead of adding more changes to it.

Sure - should I prepend your series to kill the icache to this one?

> > +#ifdef IO_BCOMPARE_CHECK
> > +		if (!(libxfs_bcache->c_flags & CACHE_MISCOMPARE_PURGE)) {
> > +			fprintf(stderr,
> > +	"%lx: Badness in key lookup (length)\n"
> > +	"bp=(bno 0x%llx, len %u bytes) key=(bno 0x%llx, len %u bytes)\n",
> > +				pthread_self(),
> > +				(unsigned long long)bp->b_bn, (int)bp->b_bcount,
> > +				(unsigned long long)bkey->blkno,
> > +				BBTOB(bkey->bblen));
> > +		}
> >  #endif
> 
> What is the point of the IO_BCOMPARE_CHECK ifdef if we unconditionally
> define it?

I'd like to - eventually - turn it off. In fact, I'd like to end up
with a real debug xfsprogs build like we do for the kernel code so
that the version that distros ship don't have this noise enabled but
developers can easily enable all the different debug/tracing stuff
to be able to find problems in the code....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
