Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 11 Jun 2007 19:40:44 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5C2ebWt005900
	for <xfs@oss.sgi.com>; Mon, 11 Jun 2007 19:40:39 -0700
Date: Tue, 12 Jun 2007 12:40:25 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] Implement shrink of empty AGs
Message-ID: <20070612024025.GM86004887@sgi.com>
References: <20070610164014.GA10936@teal.hq.k1024.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070610164014.GA10936@teal.hq.k1024.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: iusty@k1024.org

On Sun, Jun 10, 2007 at 06:40:14PM +0200, Iustin Pop wrote:
> The attached patch implements shrinking of completely empty allocation
> groups. The patch is against current CVS and modifies two files:
>   - xfs_trans.c to remove two asserts in which prevent lowering the
>     number of AGs or filesystem blocks;
>   - xfs_fsops.c where it does:
>     - modify xfs_growfs_data() to branch to either
>       xfs_growfs_data_private or xfs_shrinkfs_data private depending on
>       the new size of the fs
>     - abstract the last part of xfs_growfs_data_private (the modify of
>       all the superblocks) into a separate function, xfs_update_sb(),
>       which is called both from shrink and grow
>     - add the new xfs_shrinkfs_data_private function, mostly based on
>       the growfs function

comments are all inline....

> 
> There are many printk()'s left in the patch, I left them as they show
> where I compute some important values. There are also many FIXMEs in the
> comments showing what parts I didn't understand or was not sure about
> (not that these are the only ones...). Probably for a real patch,
> xfs-specific debug hooks need to be added and the printk()s removed.
> 
> The patch works on UML and QEMU virtual machines, both in UP and SMP. I
> just tested many shrink/grow operations and verified with xfs_repair
> that the fs is not corrupted. The free space counters seem to be correct
> after shrink.
> 
> Note that you also need to remove the check from xfs_growfs.c of not
> allowing to shrink the filesystem.
> 
> regards,
> iustin

> diff -X ignore -urN linux-2.6-xfs.cvs-orig/fs/xfs/xfs_fsops.c linux-2.6-xfs.shrink/fs/xfs/xfs_fsops.c
> --- linux-2.6-xfs.cvs-orig/fs/xfs/xfs_fsops.c	2007-06-09 18:56:21.509308225 +0200
> +++ linux-2.6-xfs.shrink/fs/xfs/xfs_fsops.c	2007-06-10 18:32:36.074856477 +0200
> @@ -112,6 +112,53 @@
>  	return 0;
>  }
>  
> +static void xfs_update_sb(

STATIC void
xfs_growfs_update_sb(

> +	xfs_mount_t		*mp,		/* mount point for filesystem */
> +	xfs_agnumber_t		nagimax,
> +	xfs_agnumber_t		nagcount)       /* new number of a.g. */

tabs, not spaces (and tabs are 8 spaces).

> +{
> +	xfs_agnumber_t		agno;
> +	xfs_buf_t		*bp;
> +	xfs_sb_t		*sbp;
> +	int			error;
> +
> +	/* New allocation groups fully initialized, so update mount struct */
> +	if (nagimax)
> +		mp->m_maxagi = nagimax;
> +	if (mp->m_sb.sb_imax_pct) {
> +		__uint64_t icount = mp->m_sb.sb_dblocks * mp->m_sb.sb_imax_pct;

I'd prefer to have long lines like this split.

> +		do_div(icount, 100);
> +		mp->m_maxicount = icount << mp->m_sb.sb_inopblog;
> +	} else
> +		mp->m_maxicount = 0;

Insert empty line.

> +	for (agno = 1; agno < nagcount; agno++) {
> +		error = xfs_read_buf(mp, mp->m_ddev_targp,
> +				  XFS_AGB_TO_DADDR(mp, agno, XFS_SB_BLOCK(mp)),
> +				  XFS_FSS_TO_BB(mp, 1), 0, &bp);
> +		if (error) {
> +			xfs_fs_cmn_err(CE_WARN, mp,
> +			"error %d reading secondary superblock for ag %d",
> +				error, agno);
> +			break;
> +		}
> +		sbp = XFS_BUF_TO_SBP(bp);
> +		xfs_xlatesb(sbp, &mp->m_sb, -1, XFS_SB_ALL_BITS);

Insert empty line

> +		/*
> +		 * If we get an error writing out the alternate superblocks,
> +		 * just issue a warning and continue.  The real work is
> +		 * already done and committed.
> +		 */
> +		if (!(error = xfs_bwrite(mp, bp))) {
> +			continue;
> +		} else {
> +			xfs_fs_cmn_err(CE_WARN, mp,
> +		"write error %d updating secondary superblock for ag %d",
> +				error, agno);
> +			break; /* no point in continuing */
> +		}
> +	}

		error = xfs_bwrite(mp, bp);
		if (error) {
			xfs_fs_cmn_err(...)
			break;
		}
	}
> +}
> +
>  static int
>  xfs_growfs_data_private(
>  	xfs_mount_t		*mp,		/* mount point for filesystem */
> @@ -135,7 +182,6 @@
>  	xfs_rfsblock_t		nfree;
>  	xfs_agnumber_t		oagcount;
>  	int			pct;
> -	xfs_sb_t		*sbp;
>  	xfs_trans_t		*tp;
>  
>  	nb = in->newblocks;
> @@ -356,44 +402,228 @@
>  	if (error) {
>  		return error;
>  	}
> -	/* New allocation groups fully initialized, so update mount struct */
> -	if (nagimax)
> -		mp->m_maxagi = nagimax;
> -	if (mp->m_sb.sb_imax_pct) {
> -		__uint64_t icount = mp->m_sb.sb_dblocks * mp->m_sb.sb_imax_pct;
> -		do_div(icount, 100);
> -		mp->m_maxicount = icount << mp->m_sb.sb_inopblog;
> -	} else
> -		mp->m_maxicount = 0;
> -	for (agno = 1; agno < nagcount; agno++) {
> -		error = xfs_read_buf(mp, mp->m_ddev_targp,
> -				  XFS_AGB_TO_DADDR(mp, agno, XFS_SB_BLOCK(mp)),
> -				  XFS_FSS_TO_BB(mp, 1), 0, &bp);
> +	xfs_update_sb(mp, nagimax, nagcount);
> +	return 0;
> +
> + error0:
> +	xfs_trans_cancel(tp, XFS_TRANS_ABORT);
> +	return error;
> +}
> +
> +static int

STATIC int

> +xfs_shrinkfs_data_private(
> +			  xfs_mount_t		*mp,		/* mount point for filesystem */
> +			  xfs_growfs_data_t	*in)		/* growfs data input struct */

whitespace issues

> +{
> +	xfs_agf_t		*agf;
> +	xfs_agnumber_t		agno;
> +	xfs_buf_t		*bp;
> +	int			dpct;
> +	int			error;
> +	xfs_agnumber_t		nagcount;       /* new AG count */
> +	xfs_agnumber_t		oagcount;       /* old AG count */
> +	xfs_agnumber_t		nagimax = 0;
> +	xfs_rfsblock_t		nb, nb_mod;
> +	xfs_rfsblock_t		dbdelta;        /* will be used as a
> +						   check that we
> +						   shrink the fs by
> +						   the correct number
> +						   of blocks */
> +	xfs_rfsblock_t		fdbdelta;       /* will keep track of
> +						   how many ag blocks
> +						   we need to
> +						   remove */

Long comments like this don't go on the declaration. Put them where
the variable is initialised or first used.

> +	int			pct;
> +	xfs_trans_t		*tp;
> +
> +	nb = in->newblocks;
> +	pct = in->imaxpct;
> +	if (nb >= mp->m_sb.sb_dblocks || pct < 0 || pct > 100)
> +		return XFS_ERROR(EINVAL);
> +	dpct = pct - mp->m_sb.sb_imax_pct;

This next bit:

> +	error = xfs_read_buf(mp, mp->m_ddev_targp,
> +			     XFS_FSB_TO_BB(mp, nb) - XFS_FSS_TO_BB(mp, 1),
> +			     XFS_FSS_TO_BB(mp, 1), 0, &bp);
> +	if (error)
> +		return error;
> +	ASSERT(bp);
> +	/* FIXME: we release the buffer here manually because we are
> +	 * outside of a transaction? The other buffers read using the
> +	 * functions which take a tp parameter are not released in
> +	 * growfs
> +	 */
> +	xfs_buf_relse(bp);

Should not be necessary - we don't need to check if the new last
filesystem block is beyond EOF because we are shrinking....

To answer the FIXME - xfs_trans_commit() releases locked buffers and
inodes that have been joined ot the transaction unless they have
also been held. So if you are outside a transaction, you do have to
ensure you release any buffers you read.

> +	/* Do basic checks (at the fs level) */
> +	oagcount = mp->m_sb.sb_agcount;
> +	nagcount = nb;
> +	nb_mod = do_div(nagcount, mp->m_sb.sb_agblocks);
> +	if(nb_mod) {
> +		printk("not shrinking on an AG boundary (diff=%d)\n", nb_mod);
> +		return XFS_ERROR(ENOSPC);

EINVAL, I think.

> +	}
> +	if(nagcount < 2) {
> +		printk("refusing to shrink below 2 AGs\n");
> +		return XFS_ERROR(ENOSPC);

EINVAL.

> +	}
> +	if(nagcount >= oagcount) {
> +		printk("number of AGs will not decrease\n");
> +		return XFS_ERROR(EINVAL);
> +	}
> +	printk("Cur ag=%d, cur blocks=%llu\n",
> +	       mp->m_sb.sb_agcount, mp->m_sb.sb_dblocks);
> +	printk("New ag=%d, new blocks=%d\n", nagcount, nb);
> +
> +	printk("Will resize from %llu to %d, delta is %llu\n",
> +               mp->m_sb.sb_dblocks, nb, mp->m_sb.sb_dblocks - nb);
> +	/* Check to see if we trip over the log section */
> +	printk("logstart=%llu logblocks=%u\n",
> +               mp->m_sb.sb_logstart, mp->m_sb.sb_logblocks);
> +	if (nb < mp->m_sb.sb_logstart + mp->m_sb.sb_logblocks)
> +		return XFS_ERROR(EINVAL);

Insert empty line

> +	/* dbdelta starts at the diff and must become zero */
> +	dbdelta = mp->m_sb.sb_dblocks - nb;
> +	tp = xfs_trans_alloc(mp, XFS_TRANS_GROWFS);
> +	printk("reserving %d\n", XFS_GROWFS_SPACE_RES(mp) + dbdelta);
> +	if ((error = xfs_trans_reserve(tp, XFS_GROWFS_SPACE_RES(mp) + dbdelta,
> +				       XFS_GROWDATA_LOG_RES(mp), 0, 0, 0))) {
> +		xfs_trans_cancel(tp, 0);
> +		return error;
> +	}

What's the dbdelta part of the reservation for? That's reserving dbdelta
blocks for *allocations*, so I don't think this is right....

> +
> +	fdbdelta = 0;
> +
> +	/* Per-AG checks */
> +	/* FIXME: do we need to hold m_peraglock while doing this? */

Yes.

> +	/* I think that since we do read and write to the m_perag
> +	 * stuff, we should be holding the lock for the entire walk &
> +	 * modify of the fs
> +	 */

Deadlock warning! holding the m_peraglock in write mode will cause
allocation deadlocks if you are not careful as all allocation/free
operations take the m_peraglock in read mode. (And yes, growing
an active, loaded filesystem can deadlock because of this.)

> +	/* Note that because we hold the lock, on any error+early
> +	 *  return, we must either release manually and return, or
> +	 *  jump to error0
> +	 */

whitespace.

> +	down_write(&mp->m_peraglock);
> +	for(agno = oagcount - 1; agno >= nagcount; agno--) {
> +		xfs_extlen_t	usedblks; /* total used blocks in this a.g. */
> +		xfs_extlen_t	freeblks; /* free blocks in this a.g. */
> +		xfs_agblock_t	aglen;    /* this ag's len */
> +		struct xfs_perag *pag;  /* the m_perag structure */
> +
> +		printk("doing agno=%d\n", agno);
> +
> +		pag = &mp->m_perag[agno];
> +
> +		error = xfs_alloc_read_agf(mp, tp, agno, 0, &bp);
>  		if (error) {
> -			xfs_fs_cmn_err(CE_WARN, mp,
> -			"error %d reading secondary superblock for ag %d",
> -				error, agno);
> -			break;
> +			goto error0;
>  		}
> -		sbp = XFS_BUF_TO_SBP(bp);
> -		xfs_xlatesb(sbp, &mp->m_sb, -1, XFS_SB_ALL_BITS);
> +		ASSERT(bp);
> +		agf = XFS_BUF_TO_AGF(bp);
> +		aglen = INT_GET(agf->agf_length, ARCH_CONVERT);
> +
> +		/* read the pagf/pagi if not already initialized */
> +		/* agf should be initialized because of the ablove read_agf */
> +		ASSERT(pag->pagf_init);
> +		if (!pag->pagi_init) {
> +			if ((error = xfs_ialloc_read_agi(mp, tp, agno, &bp)))
> +				goto error0;

I don't think you should be overwriting bp here....

> +			ASSERT(pag->pagi_init);
> +		}
> +

Because now you have bp potentially pointing to two different buffers.

>  		/*
> -		 * If we get an error writing out the alternate superblocks,
> -		 * just issue a warning and continue.  The real work is
> -		 * already done and committed.
> +		 * Check the inodes: as long as we have pagi_count ==
> +		 * pagi_freecount == 0, then: a) we don't have to
> +		 * update any global inode counters, and b) there are
> +		 * no extra blocks in inode btrees
>  		 */
> -		if (!(error = xfs_bwrite(mp, bp))) {
> -			continue;
> -		} else {
> -			xfs_fs_cmn_err(CE_WARN, mp,
> -		"write error %d updating secondary superblock for ag %d",
> -				error, agno);
> -			break; /* no point in continuing */
> +		if(pag->pagi_count > 0 ||
> +		   pag->pagi_freecount > 0) {
> +			printk("agi %d has %d inodes in total and %d free\n",
> +			       agno, pag->pagi_count, pag->pagi_freecount);
> +			error = XFS_ERROR(ENOSPC);
> +			goto error0;
> +		}
> +
> +		/* Check the AGF: if levels[] == 1, then there should
> +		 *  be no extra blocks in the btrees beyond the ones
> +		 *  at the beggining of the AG
> +		 */
> +		if(pag->pagf_levels[XFS_BTNUM_BNOi] > 1 ||
> +		   pag->pagf_levels[XFS_BTNUM_CNTi] > 1) {
> +			printk("agf %d has level %d bt and %d cnt\n",
> +			       agno,
> +			       pag->pagf_levels[XFS_BTNUM_BNOi],
> +			       pag->pagf_levels[XFS_BTNUM_CNTi]);
> +			error = XFS_ERROR(ENOSPC);
> +			goto error0;
>  		}

ok, so we have empty ag's here. You might want to check that the
inode btree is empty and that the AGI unlinked list is empty.

> +
> +		freeblks = pag->pagf_freeblks;
> +		printk("Usage: %d prealloc, %d flcount\n",
> +		       XFS_PREALLOC_BLOCKS(mp), pag->pagf_flcount);
> +
> +		/* Done gathering data, check sizes */
> +		usedblks = XFS_PREALLOC_BLOCKS(mp) + pag->pagf_flcount;
> +		printk("agno=%d agf_length=%d computed used=%d"
> +		       " known free=%d\n", agno, aglen, usedblks, freeblks);
> +
> +		if(usedblks + freeblks != aglen) {
> +			printk("agno %d is not free (%d blocks allocated)\n",
> +			       agno, aglen-usedblks-freeblks);
> +			error = XFS_ERROR(ENOSPC);
> +			goto error0;
> +		}
> +		dbdelta -= aglen;
> +		printk("will lower with %d\n",
> +		       aglen - XFS_PREALLOC_BLOCKS(mp));
> +		fdbdelta += aglen - XFS_PREALLOC_BLOCKS(mp);

Ok, so why not just

	fdbdelta += mp->m_sb.sb_agblocks - XFS_PREALLOC_BLOCKS(mp);

> +	}
> +	/*
> +	 * Check that we removed all blocks
> +	 */
> +	ASSERT(!dbdelta);
> +	ASSERT(nagcount < oagcount);

Error out, not assert, because at this point we have not changed anything.

> +
> +	printk("to free: %d, oagcount=%d, nagcount=%d\n",
> +	       fdbdelta, oagcount, nagcount);
> +
> +	xfs_trans_agblocks_delta(tp, -((long)fdbdelta));
> +	xfs_trans_mod_sb(tp, XFS_TRANS_SB_AGCOUNT, nagcount - oagcount);
> +	xfs_trans_mod_sb(tp, XFS_TRANS_SB_DBLOCKS, nb - mp->m_sb.sb_dblocks);
> +	xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS, -((int64_t)fdbdelta));
> +
> +	if (dpct)
> +		xfs_trans_mod_sb(tp, XFS_TRANS_SB_IMAXPCT, dpct);
> +	error = xfs_trans_commit(tp, 0);
> +	if (error) {
> +		up_write(&mp->m_peraglock);
> +		return error;
>  	}
> +	/* Free memory as the number of AG has changed */
> +	for (agno = nagcount; agno < oagcount; agno++)
> +		if (mp->m_perag[agno].pagb_list)
> +			kmem_free(mp->m_perag[agno].pagb_list,
> +				  sizeof(xfs_perag_busy_t) *
> +				  XFS_PAGB_NUM_SLOTS);
> +
> +	mp->m_perag = kmem_realloc(mp->m_perag,
> +				   sizeof(xfs_perag_t) * nagcount,
> +				   sizeof(xfs_perag_t) * oagcount,
> +				   KM_SLEEP);

This is not really safe - how do we know if all the users of the
higher AGs have gone away? I think we should simply just zero out
the unused AGs and don't worry about a realloc().

> +	/* FIXME: here we could instead just lower
> +	 * nagimax to nagcount; is it better this way?
> +	 */

Not really.

> +	/* FIXME: why is this flag unconditionally set in growfs? */
> +	mp->m_flags |= XFS_MOUNT_32BITINODES;

good question. I don't think it should be there but I'll have to
do some digging....

> +	nagimax = xfs_initialize_perag(XFS_MTOVFS(mp), mp, nagcount);
> +	up_write(&mp->m_peraglock);
> +
> +	xfs_update_sb(mp, nagimax, nagcount);
>  	return 0;
>  
>   error0:
> +	up_write(&mp->m_peraglock);
>  	xfs_trans_cancel(tp, XFS_TRANS_ABORT);
>  	return error;
>  }
> @@ -435,7 +665,10 @@
>  	int error;
>  	if (!cpsema(&mp->m_growlock))
>  		return XFS_ERROR(EWOULDBLOCK);
> -	error = xfs_growfs_data_private(mp, in);
> +	if(in->newblocks < mp->m_sb.sb_dblocks)
> +		error = xfs_shrinkfs_data_private(mp, in);
> +	else
> +		error = xfs_growfs_data_private(mp, in);

Hmmm - that's using the one ioctl to do both grow and shrink. I'd
prefer a new shrink ioctl rather than changing the behaviour of an
existing ioctl.

Looks like a good start ;)

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
