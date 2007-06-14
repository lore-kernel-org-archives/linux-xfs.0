Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 13 Jun 2007 23:02:10 -0700 (PDT)
Received: from astra.simleu.ro (astra.simleu.ro [80.97.18.177])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5E624Wt008138
	for <xfs@oss.sgi.com>; Wed, 13 Jun 2007 23:02:06 -0700
Date: Thu, 14 Jun 2007 08:01:58 +0200
From: Iustin Pop <iusty@k1024.org>
Subject: Re: [PATCH] Implement shrink of empty AGs
Message-ID: <20070614060158.GA12951@teal.hq.k1024.org>
References: <20070610164014.GA10936@teal.hq.k1024.org> <20070612024025.GM86004887@sgi.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="X1bOJ3K7DJ5YkBrT"
Content-Disposition: inline
In-Reply-To: <20070612024025.GM86004887@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com

--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 12, 2007 at 12:40:25PM +1000, David Chinner wrote:
> > diff -X ignore -urN linux-2.6-xfs.cvs-orig/fs/xfs/xfs_fsops.c linux-2.6-xfs.shrink/fs/xfs/xfs_fsops.c
> > --- linux-2.6-xfs.cvs-orig/fs/xfs/xfs_fsops.c	2007-06-09 18:56:21.509308225 +0200
> > +++ linux-2.6-xfs.shrink/fs/xfs/xfs_fsops.c	2007-06-10 18:32:36.074856477 +0200
> > @@ -112,6 +112,53 @@
> >  	return 0;
> >  }
> >  
> > +static void xfs_update_sb(
> 
> STATIC void
> xfs_growfs_update_sb(
this was because xfs_growfs_private is also static and not STATIC.
Should I change the def for it also?

> > +	xfs_mount_t		*mp,		/* mount point for filesystem */
> > +	xfs_agnumber_t		nagimax,
> > +	xfs_agnumber_t		nagcount)       /* new number of a.g. */
> 
> tabs, not spaces (and tabs are 8 spaces).
sorry, I though I got all of these. There are some more in the def of
xfs_reserve_blocks, btw.

> > +{
> > +	xfs_agnumber_t		agno;
> > +	xfs_buf_t		*bp;
> > +	xfs_sb_t		*sbp;
> > +	int			error;
> > +
> > +	/* New allocation groups fully initialized, so update mount struct */
> > +	if (nagimax)
> > +		mp->m_maxagi = nagimax;
> > +	if (mp->m_sb.sb_imax_pct) {
> > +		__uint64_t icount = mp->m_sb.sb_dblocks * mp->m_sb.sb_imax_pct;
> 
> I'd prefer to have long lines like this split.
Ok, I hope I split them ok.

> > +		do_div(icount, 100);
> > +		mp->m_maxicount = icount << mp->m_sb.sb_inopblog;
> > +	} else
> > +		mp->m_maxicount = 0;
> 
> Insert empty line.
done.

> > +	for (agno = 1; agno < nagcount; agno++) {
> > +		error = xfs_read_buf(mp, mp->m_ddev_targp,
> > +				  XFS_AGB_TO_DADDR(mp, agno, XFS_SB_BLOCK(mp)),
> > +				  XFS_FSS_TO_BB(mp, 1), 0, &bp);
> > +		if (error) {
> > +			xfs_fs_cmn_err(CE_WARN, mp,
> > +			"error %d reading secondary superblock for ag %d",
> > +				error, agno);
> > +			break;
> > +		}
> > +		sbp = XFS_BUF_TO_SBP(bp);
> > +		xfs_xlatesb(sbp, &mp->m_sb, -1, XFS_SB_ALL_BITS);
> 
> Insert empty line
done.

> > +		/*
> > +		 * If we get an error writing out the alternate superblocks,
> > +		 * just issue a warning and continue.  The real work is
> > +		 * already done and committed.
> > +		 */
> > +		if (!(error = xfs_bwrite(mp, bp))) {
> > +			continue;
> > +		} else {
> > +			xfs_fs_cmn_err(CE_WARN, mp,
> > +		"write error %d updating secondary superblock for ag %d",
> > +				error, agno);
> > +			break; /* no point in continuing */
> > +		}
> > +	}
> 
> 		error = xfs_bwrite(mp, bp);
> 		if (error) {
> 			xfs_fs_cmn_err(...)
> 			break;
ok. (the original version was purely a move from xfs_growfs_data_private
to a separate function)

> 		}
> 	}
> > +}
> > +
> >  static int
> >  xfs_growfs_data_private(
> >  	xfs_mount_t		*mp,		/* mount point for filesystem */
> > @@ -135,7 +182,6 @@
> >  	xfs_rfsblock_t		nfree;
> >  	xfs_agnumber_t		oagcount;
> >  	int			pct;
> > -	xfs_sb_t		*sbp;
> >  	xfs_trans_t		*tp;
> >  
> >  	nb = in->newblocks;
> > @@ -356,44 +402,228 @@
> >  	if (error) {
> >  		return error;
> >  	}
> > -	/* New allocation groups fully initialized, so update mount struct */
> > -	if (nagimax)
> > -		mp->m_maxagi = nagimax;
> > -	if (mp->m_sb.sb_imax_pct) {
> > -		__uint64_t icount = mp->m_sb.sb_dblocks * mp->m_sb.sb_imax_pct;
> > -		do_div(icount, 100);
> > -		mp->m_maxicount = icount << mp->m_sb.sb_inopblog;
> > -	} else
> > -		mp->m_maxicount = 0;
> > -	for (agno = 1; agno < nagcount; agno++) {
> > -		error = xfs_read_buf(mp, mp->m_ddev_targp,
> > -				  XFS_AGB_TO_DADDR(mp, agno, XFS_SB_BLOCK(mp)),
> > -				  XFS_FSS_TO_BB(mp, 1), 0, &bp);
> > +	xfs_update_sb(mp, nagimax, nagcount);
> > +	return 0;
> > +
> > + error0:
> > +	xfs_trans_cancel(tp, XFS_TRANS_ABORT);
> > +	return error;
> > +}
> > +
> > +static int
> 
> STATIC int
done.

> > +xfs_shrinkfs_data_private(
> > +			  xfs_mount_t		*mp,		/* mount point for filesystem */
> > +			  xfs_growfs_data_t	*in)		/* growfs data input struct */
> 
> whitespace issues
fixed (I think you were referring to the alignement of the two argument
lines).

> > +{
> > +	xfs_agf_t		*agf;
> > +	xfs_agnumber_t		agno;
> > +	xfs_buf_t		*bp;
> > +	int			dpct;
> > +	int			error;
> > +	xfs_agnumber_t		nagcount;       /* new AG count */
> > +	xfs_agnumber_t		oagcount;       /* old AG count */
> > +	xfs_agnumber_t		nagimax = 0;
> > +	xfs_rfsblock_t		nb, nb_mod;
> > +	xfs_rfsblock_t		dbdelta;        /* will be used as a
> > +						   check that we
> > +						   shrink the fs by
> > +						   the correct number
> > +						   of blocks */
> > +	xfs_rfsblock_t		fdbdelta;       /* will keep track of
> > +						   how many ag blocks
> > +						   we need to
> > +						   remove */
> 
> Long comments like this don't go on the declaration. Put them where
> the variable is initialised or first used.
ok.

> > +	int			pct;
> > +	xfs_trans_t		*tp;
> > +
> > +	nb = in->newblocks;
> > +	pct = in->imaxpct;
> > +	if (nb >= mp->m_sb.sb_dblocks || pct < 0 || pct > 100)
> > +		return XFS_ERROR(EINVAL);
> > +	dpct = pct - mp->m_sb.sb_imax_pct;
> 
> This next bit:
> 
> > +	error = xfs_read_buf(mp, mp->m_ddev_targp,
> > +			     XFS_FSB_TO_BB(mp, nb) - XFS_FSS_TO_BB(mp, 1),
> > +			     XFS_FSS_TO_BB(mp, 1), 0, &bp);
> > +	if (error)
> > +		return error;
> > +	ASSERT(bp);
> > +	/* FIXME: we release the buffer here manually because we are
> > +	 * outside of a transaction? The other buffers read using the
> > +	 * functions which take a tp parameter are not released in
> > +	 * growfs
> > +	 */
> > +	xfs_buf_relse(bp);
> 
> Should not be necessary - we don't need to check if the new last
> filesystem block is beyond EOF because we are shrinking....
Ah, now I understand what this does. I just copied it from growfs
without realising what it does. Removed.

> To answer the FIXME - xfs_trans_commit() releases locked buffers and
> inodes that have been joined ot the transaction unless they have
> also been held. So if you are outside a transaction, you do have to
> ensure you release any buffers you read.
Thanks for the clarification!

> > +	/* Do basic checks (at the fs level) */
> > +	oagcount = mp->m_sb.sb_agcount;
> > +	nagcount = nb;
> > +	nb_mod = do_div(nagcount, mp->m_sb.sb_agblocks);
> > +	if(nb_mod) {
> > +		printk("not shrinking on an AG boundary (diff=%d)\n", nb_mod);
> > +		return XFS_ERROR(ENOSPC);
> 
> EINVAL, I think.
fixed.

> > +	}
> > +	if(nagcount < 2) {
> > +		printk("refusing to shrink below 2 AGs\n");
> > +		return XFS_ERROR(ENOSPC);
> 
> EINVAL.
fixed.

> > +	}
> > +	if(nagcount >= oagcount) {
> > +		printk("number of AGs will not decrease\n");
> > +		return XFS_ERROR(EINVAL);
> > +	}
> > +	printk("Cur ag=%d, cur blocks=%llu\n",
> > +	       mp->m_sb.sb_agcount, mp->m_sb.sb_dblocks);
> > +	printk("New ag=%d, new blocks=%d\n", nagcount, nb);
> > +
> > +	printk("Will resize from %llu to %d, delta is %llu\n",
> > +               mp->m_sb.sb_dblocks, nb, mp->m_sb.sb_dblocks - nb);
> > +	/* Check to see if we trip over the log section */
> > +	printk("logstart=%llu logblocks=%u\n",
> > +               mp->m_sb.sb_logstart, mp->m_sb.sb_logblocks);
> > +	if (nb < mp->m_sb.sb_logstart + mp->m_sb.sb_logblocks)
> > +		return XFS_ERROR(EINVAL);
> 
> Insert empty line
Done.

> > +	/* dbdelta starts at the diff and must become zero */
> > +	dbdelta = mp->m_sb.sb_dblocks - nb;
> > +	tp = xfs_trans_alloc(mp, XFS_TRANS_GROWFS);
> > +	printk("reserving %d\n", XFS_GROWFS_SPACE_RES(mp) + dbdelta);
> > +	if ((error = xfs_trans_reserve(tp, XFS_GROWFS_SPACE_RES(mp) + dbdelta,
> > +				       XFS_GROWDATA_LOG_RES(mp), 0, 0, 0))) {
> > +		xfs_trans_cancel(tp, 0);
> > +		return error;
> > +	}
> 
> What's the dbdelta part of the reservation for? That's reserving dbdelta
> blocks for *allocations*, so I don't think this is right....
Well, we'll shrink the filesystem by dbdelta, so the filesystem needs to
have enough free space to do it. Whether this space is in the correct
place (the AGs we want to shrink) or not is a question answered by the
per-AG checking, but since we will reduce the freespace by this amount,
I thought that it's safer to mark this space in use. Did I misread the
intent of xfs_trans_reserve?

Also, unless I'm mistaken and don't remember correctly, you have to
reserve the amount of space one will pass to xfs_trans_mod_sb(tp,
XFS_TRANS_SB_FDBLOCKS, ...) otherwise the transaction code complains
about exceeding your reservation.

> > +
> > +	fdbdelta = 0;
> > +
> > +	/* Per-AG checks */
> > +	/* FIXME: do we need to hold m_peraglock while doing this? */
> 
> Yes.
> 
> > +	/* I think that since we do read and write to the m_perag
> > +	 * stuff, we should be holding the lock for the entire walk &
> > +	 * modify of the fs
> > +	 */
> 
> Deadlock warning! holding the m_peraglock in write mode will cause
> allocation deadlocks if you are not careful as all allocation/free
> operations take the m_peraglock in read mode. (And yes, growing
> an active, loaded filesystem can deadlock because of this.)
How can we ensure then that no one modifies the AGs while we walk them?
I hoped that we can do it without the per-AG not-avail flag, by just
holding the perag lock.

Or you mean we should keep the read lock, and grab also the write lock
when actually modifying the perag structure? (Or should that be grab
read lock for checking, release read lock - hope nobody modifies AGs -
grab write lock?)

> > +	/* Note that because we hold the lock, on any error+early
> > +	 *  return, we must either release manually and return, or
> > +	 *  jump to error0
> > +	 */
> 
> whitespace.
fixed.

> > +	down_write(&mp->m_peraglock);
> > +	for(agno = oagcount - 1; agno >= nagcount; agno--) {
> > +		xfs_extlen_t	usedblks; /* total used blocks in this a.g. */
> > +		xfs_extlen_t	freeblks; /* free blocks in this a.g. */
> > +		xfs_agblock_t	aglen;    /* this ag's len */
> > +		struct xfs_perag *pag;  /* the m_perag structure */
> > +
> > +		printk("doing agno=%d\n", agno);
> > +
> > +		pag = &mp->m_perag[agno];
> > +
> > +		error = xfs_alloc_read_agf(mp, tp, agno, 0, &bp);
> >  		if (error) {
> > -			xfs_fs_cmn_err(CE_WARN, mp,
> > -			"error %d reading secondary superblock for ag %d",
> > -				error, agno);
> > -			break;
> > +			goto error0;
> >  		}
> > -		sbp = XFS_BUF_TO_SBP(bp);
> > -		xfs_xlatesb(sbp, &mp->m_sb, -1, XFS_SB_ALL_BITS);
> > +		ASSERT(bp);
> > +		agf = XFS_BUF_TO_AGF(bp);
> > +		aglen = INT_GET(agf->agf_length, ARCH_CONVERT);
> > +
> > +		/* read the pagf/pagi if not already initialized */
> > +		/* agf should be initialized because of the ablove read_agf */
> > +		ASSERT(pag->pagf_init);
> > +		if (!pag->pagi_init) {
> > +			if ((error = xfs_ialloc_read_agi(mp, tp, agno, &bp)))
> > +				goto error0;
> 
> I don't think you should be overwriting bp here....
> 
> > +			ASSERT(pag->pagi_init);
> > +		}
> > +
> 
> Because now you have bp potentially pointing to two different buffers.
Yes, indeed, sloppy programming. Fixed.

> >  		/*
> > -		 * If we get an error writing out the alternate superblocks,
> > -		 * just issue a warning and continue.  The real work is
> > -		 * already done and committed.
> > +		 * Check the inodes: as long as we have pagi_count ==
> > +		 * pagi_freecount == 0, then: a) we don't have to
> > +		 * update any global inode counters, and b) there are
> > +		 * no extra blocks in inode btrees
> >  		 */
> > -		if (!(error = xfs_bwrite(mp, bp))) {
> > -			continue;
> > -		} else {
> > -			xfs_fs_cmn_err(CE_WARN, mp,
> > -		"write error %d updating secondary superblock for ag %d",
> > -				error, agno);
> > -			break; /* no point in continuing */
> > +		if(pag->pagi_count > 0 ||
> > +		   pag->pagi_freecount > 0) {
> > +			printk("agi %d has %d inodes in total and %d free\n",
> > +			       agno, pag->pagi_count, pag->pagi_freecount);
> > +			error = XFS_ERROR(ENOSPC);
> > +			goto error0;
> > +		}
> > +
> > +		/* Check the AGF: if levels[] == 1, then there should
> > +		 *  be no extra blocks in the btrees beyond the ones
> > +		 *  at the beggining of the AG
> > +		 */
> > +		if(pag->pagf_levels[XFS_BTNUM_BNOi] > 1 ||
> > +		   pag->pagf_levels[XFS_BTNUM_CNTi] > 1) {
> > +			printk("agf %d has level %d bt and %d cnt\n",
> > +			       agno,
> > +			       pag->pagf_levels[XFS_BTNUM_BNOi],
> > +			       pag->pagf_levels[XFS_BTNUM_CNTi]);
> > +			error = XFS_ERROR(ENOSPC);
> > +			goto error0;
> >  		}
> 
> ok, so we have empty ag's here. You might want to check that the
> inode btree is empty and that the AGI unlinked list is empty.
I thought that inode btree is empty by virtue of pag->pagi_count == 0.
Is this not always so? Furthermore, also since agi_count == agi_free +
actual used inodes + number of unlinked inodes, I think we don't need to
check the unlinked list.

> > +
> > +		freeblks = pag->pagf_freeblks;
> > +		printk("Usage: %d prealloc, %d flcount\n",
> > +		       XFS_PREALLOC_BLOCKS(mp), pag->pagf_flcount);
> > +
> > +		/* Done gathering data, check sizes */
> > +		usedblks = XFS_PREALLOC_BLOCKS(mp) + pag->pagf_flcount;
> > +		printk("agno=%d agf_length=%d computed used=%d"
> > +		       " known free=%d\n", agno, aglen, usedblks, freeblks);
> > +
> > +		if(usedblks + freeblks != aglen) {
> > +			printk("agno %d is not free (%d blocks allocated)\n",
> > +			       agno, aglen-usedblks-freeblks);
> > +			error = XFS_ERROR(ENOSPC);
> > +			goto error0;
> > +		}
> > +		dbdelta -= aglen;
> > +		printk("will lower with %d\n",
> > +		       aglen - XFS_PREALLOC_BLOCKS(mp));
> > +		fdbdelta += aglen - XFS_PREALLOC_BLOCKS(mp);
> 
> Ok, so why not just
> 
> 	fdbdelta += mp->m_sb.sb_agblocks - XFS_PREALLOC_BLOCKS(mp);
Because the last AG can be smaller than the sb_agblocks. It's true
that this holds only for the last one, but having two cases is uglier
than just always reading this size from the AG.

> > +	}
> > +	/*
> > +	 * Check that we removed all blocks
> > +	 */
> > +	ASSERT(!dbdelta);
> > +	ASSERT(nagcount < oagcount);
> 
> Error out, not assert, because at this point we have not changed anything.
Actually here, !dbdelta or nacount < oagacount are programming errors
and not possible correct conditions.  They could be removed, sine the
checks before the per-AG for loop ensure these conditions are not met.
But I used them just to be sure.

> > +
> > +	printk("to free: %d, oagcount=%d, nagcount=%d\n",
> > +	       fdbdelta, oagcount, nagcount);
> > +
> > +	xfs_trans_agblocks_delta(tp, -((long)fdbdelta));
> > +	xfs_trans_mod_sb(tp, XFS_TRANS_SB_AGCOUNT, nagcount - oagcount);
> > +	xfs_trans_mod_sb(tp, XFS_TRANS_SB_DBLOCKS, nb - mp->m_sb.sb_dblocks);
> > +	xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS, -((int64_t)fdbdelta));
> > +
> > +	if (dpct)
> > +		xfs_trans_mod_sb(tp, XFS_TRANS_SB_IMAXPCT, dpct);
> > +	error = xfs_trans_commit(tp, 0);
> > +	if (error) {
> > +		up_write(&mp->m_peraglock);
> > +		return error;
> >  	}
> > +	/* Free memory as the number of AG has changed */
> > +	for (agno = nagcount; agno < oagcount; agno++)
> > +		if (mp->m_perag[agno].pagb_list)
> > +			kmem_free(mp->m_perag[agno].pagb_list,
> > +				  sizeof(xfs_perag_busy_t) *
> > +				  XFS_PAGB_NUM_SLOTS);
> > +
> > +	mp->m_perag = kmem_realloc(mp->m_perag,
> > +				   sizeof(xfs_perag_t) * nagcount,
> > +				   sizeof(xfs_perag_t) * oagcount,
> > +				   KM_SLEEP);
> 
> This is not really safe - how do we know if all the users of the
> higher AGs have gone away? I think we should simply just zero out
> the unused AGs and don't worry about a realloc().
The problem that I saw is that if you do shrink+grow+shrink+grow+... you
will leak a small amount of memory (or corrupt kernel mem allocation?)
since the growfs code does a realloc from what it thinks is the size of
m_perag, which it computes solely from the current number of AGs. Should
we have a size in the mp struct for this and not assume it's the
agcount?

> > +	/* FIXME: here we could instead just lower
> > +	 * nagimax to nagcount; is it better this way?
> > +	 */
> 
> Not really.
Ok, removed comment.

> > +	/* FIXME: why is this flag unconditionally set in growfs? */
> > +	mp->m_flags |= XFS_MOUNT_32BITINODES;
> 
> good question. I don't think it should be there but I'll have to
> do some digging....
Per Eric's mail, I removed both the comment and the flag setting.

> > +	nagimax = xfs_initialize_perag(XFS_MTOVFS(mp), mp, nagcount);
> > +	up_write(&mp->m_peraglock);
> > +
> > +	xfs_update_sb(mp, nagimax, nagcount);
> >  	return 0;
> >  
> >   error0:
> > +	up_write(&mp->m_peraglock);
> >  	xfs_trans_cancel(tp, XFS_TRANS_ABORT);
> >  	return error;
> >  }
> > @@ -435,7 +665,10 @@
> >  	int error;
> >  	if (!cpsema(&mp->m_growlock))
> >  		return XFS_ERROR(EWOULDBLOCK);
> > -	error = xfs_growfs_data_private(mp, in);
> > +	if(in->newblocks < mp->m_sb.sb_dblocks)
> > +		error = xfs_shrinkfs_data_private(mp, in);
> > +	else
> > +		error = xfs_growfs_data_private(mp, in);
> 
> Hmmm - that's using the one ioctl to do both grow and shrink. I'd
> prefer a new shrink ioctl rather than changing the behaviour of an
> existing ioctl.
Well, I chose this way because I see it as the ioctl that changes the
data size of the filesystem. It may be lower or higher than the current
size, but that is not so important :), and if another ioctl there would
be the need for another tool.

> Looks like a good start ;)
thanks! and also thanks for taking time to look at this.

updated patch (without the separation of the IOCTL and without the
rework of the perag lock) is attached.

iustin

--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-nice-5

diff -X ignore -urN linux-2.6-xfs.cvs-orig/fs/xfs/xfs_fsops.c linux-2.6-xfs.shrink/fs/xfs/xfs_fsops.c
--- linux-2.6-xfs.cvs-orig/fs/xfs/xfs_fsops.c	2007-06-09 18:56:21.509308225 +0200
+++ linux-2.6-xfs.shrink/fs/xfs/xfs_fsops.c	2007-06-14 07:54:50.580420252 +0200
@@ -112,6 +112,55 @@
 	return 0;
 }
 
+STATIC void xfs_growfs_update_sb(
+	xfs_mount_t		*mp,		/* mount point for filesystem */
+	xfs_agnumber_t		nagimax,
+	xfs_agnumber_t		nagcount)       /* new number of a.g. */
+{
+	xfs_agnumber_t		agno;
+	xfs_buf_t		*bp;
+	xfs_sb_t		*sbp;
+	int			error;
+
+	/* New allocation groups fully initialized, so update mount struct */
+	if (nagimax)
+		mp->m_maxagi = nagimax;
+	if (mp->m_sb.sb_imax_pct) {
+		__uint64_t icount = mp->m_sb.sb_dblocks *
+			mp->m_sb.sb_imax_pct;
+		do_div(icount, 100);
+		mp->m_maxicount = icount << mp->m_sb.sb_inopblog;
+	} else
+		mp->m_maxicount = 0;
+
+	for (agno = 1; agno < nagcount; agno++) {
+		error = xfs_read_buf(mp, mp->m_ddev_targp,
+				  XFS_AGB_TO_DADDR(mp, agno, XFS_SB_BLOCK(mp)),
+				  XFS_FSS_TO_BB(mp, 1), 0, &bp);
+		if (error) {
+			xfs_fs_cmn_err(CE_WARN, mp,
+			"error %d reading secondary superblock for ag %d",
+				error, agno);
+			break;
+		}
+		sbp = XFS_BUF_TO_SBP(bp);
+		xfs_xlatesb(sbp, &mp->m_sb, -1, XFS_SB_ALL_BITS);
+
+		/*
+		 * If we get an error writing out the alternate superblocks,
+		 * just issue a warning and continue.  The real work is
+		 * already done and committed.
+		 */
+		error = xfs_bwrite(mp, bp);
+		if(error) {
+			xfs_fs_cmn_err(CE_WARN, mp,
+		"write error %d updating secondary superblock for ag %d",
+				error, agno);
+			break; /* no point in continuing */
+		}
+	}
+}
+
 static int
 xfs_growfs_data_private(
 	xfs_mount_t		*mp,		/* mount point for filesystem */
@@ -135,7 +184,6 @@
 	xfs_rfsblock_t		nfree;
 	xfs_agnumber_t		oagcount;
 	int			pct;
-	xfs_sb_t		*sbp;
 	xfs_trans_t		*tp;
 
 	nb = in->newblocks;
@@ -356,44 +404,210 @@
 	if (error) {
 		return error;
 	}
-	/* New allocation groups fully initialized, so update mount struct */
-	if (nagimax)
-		mp->m_maxagi = nagimax;
-	if (mp->m_sb.sb_imax_pct) {
-		__uint64_t icount = mp->m_sb.sb_dblocks * mp->m_sb.sb_imax_pct;
-		do_div(icount, 100);
-		mp->m_maxicount = icount << mp->m_sb.sb_inopblog;
-	} else
-		mp->m_maxicount = 0;
-	for (agno = 1; agno < nagcount; agno++) {
-		error = xfs_read_buf(mp, mp->m_ddev_targp,
-				  XFS_AGB_TO_DADDR(mp, agno, XFS_SB_BLOCK(mp)),
-				  XFS_FSS_TO_BB(mp, 1), 0, &bp);
+	xfs_growfs_update_sb(mp, nagimax, nagcount);
+	return 0;
+
+ error0:
+	xfs_trans_cancel(tp, XFS_TRANS_ABORT);
+	return error;
+}
+
+STATIC int
+xfs_shrinkfs_data_private(
+	xfs_mount_t		*mp,		/* mount point for filesystem */
+	xfs_growfs_data_t	*in)		/* growfs data input struct */
+{
+	xfs_agf_t		*agf;
+	xfs_agnumber_t		agno;
+	int			dpct;
+	int			error;
+	xfs_agnumber_t		nagcount;       /* new AG count */
+	xfs_agnumber_t		oagcount;       /* old AG count */
+	xfs_agnumber_t		nagimax = 0;
+	xfs_rfsblock_t		nb, nb_mod;
+	xfs_rfsblock_t		dbdelta;
+	xfs_rfsblock_t		fdbdelta;
+	int			pct;
+	xfs_trans_t		*tp;
+
+	nb = in->newblocks;
+	pct = in->imaxpct;
+	if (nb >= mp->m_sb.sb_dblocks || pct < 0 || pct > 100)
+		return XFS_ERROR(EINVAL);
+	dpct = pct - mp->m_sb.sb_imax_pct;
+
+	/* Do basic checks (at the fs level) */
+	oagcount = mp->m_sb.sb_agcount;
+	nagcount = nb;
+	nb_mod = do_div(nagcount, mp->m_sb.sb_agblocks);
+	if(nb_mod) {
+		printk("not shrinking on an AG boundary (diff=%d)\n", nb_mod);
+		return XFS_ERROR(EINVAL);
+	}
+	if(nagcount < 2) {
+		printk("refusing to shrink below 2 AGs\n");
+		return XFS_ERROR(EINVAL);
+	}
+	if(nagcount >= oagcount) {
+		printk("number of AGs will not decrease\n");
+		return XFS_ERROR(EINVAL);
+	}
+	printk("Cur ag=%d, cur blocks=%llu\n",
+	       mp->m_sb.sb_agcount, mp->m_sb.sb_dblocks);
+	printk("New ag=%d, new blocks=%d\n", nagcount, nb);
+
+	printk("Will resize from %llu to %d, delta is %llu\n",
+		mp->m_sb.sb_dblocks, nb, mp->m_sb.sb_dblocks - nb);
+	/* Check to see if we trip over the log section */
+	printk("logstart=%llu logblocks=%u\n",
+		mp->m_sb.sb_logstart, mp->m_sb.sb_logblocks);
+	if (nb < mp->m_sb.sb_logstart + mp->m_sb.sb_logblocks)
+		return XFS_ERROR(EINVAL);
+
+	/* dbdelta starts at the diff and must become zero */
+	dbdelta = mp->m_sb.sb_dblocks - nb;
+	tp = xfs_trans_alloc(mp, XFS_TRANS_GROWFS);
+	printk("reserving %d\n", XFS_GROWFS_SPACE_RES(mp) + dbdelta);
+	if ((error = xfs_trans_reserve(tp, XFS_GROWFS_SPACE_RES(mp) + dbdelta,
+				       XFS_GROWDATA_LOG_RES(mp), 0, 0, 0))) {
+		xfs_trans_cancel(tp, 0);
+		return error;
+	}
+
+	/* fbdelta keeps track of how many ag blocks we need to remove
+	 * (this is different from the number of filesystem blocks)
+	 */
+	fdbdelta = 0;
+
+	/* Per-AG checks */
+	/* FIXME: do we need to hold m_peraglock while doing this? */
+	/* I think that since we do read and write to the m_perag
+	 * stuff, we should be holding the lock for the entire walk &
+	 * modify of the fs
+	 */
+	/* Note that because we hold the lock, on any error+early
+	 * return, we must either release manually and return, or jump
+	 * to error0
+	 */
+	down_write(&mp->m_peraglock);
+	for(agno = oagcount - 1; agno >= nagcount; agno--) {
+		xfs_extlen_t	usedblks; /* total used blocks in this a.g. */
+		xfs_extlen_t	freeblks; /* free blocks in this a.g. */
+		xfs_agblock_t	aglen;    /* this ag's len */
+		struct xfs_perag *pag;  /* the m_perag structure */
+		xfs_buf_t	*bpf;
+		xfs_buf_t	*bpi;
+
+		printk("doing agno=%d\n", agno);
+
+		pag = &mp->m_perag[agno];
+
+		error = xfs_alloc_read_agf(mp, tp, agno, 0, &bpf);
 		if (error) {
-			xfs_fs_cmn_err(CE_WARN, mp,
-			"error %d reading secondary superblock for ag %d",
-				error, agno);
-			break;
+			goto error0;
 		}
-		sbp = XFS_BUF_TO_SBP(bp);
-		xfs_xlatesb(sbp, &mp->m_sb, -1, XFS_SB_ALL_BITS);
+		ASSERT(bpf);
+		agf = XFS_BUF_TO_AGF(bpf);
+		aglen = INT_GET(agf->agf_length, ARCH_CONVERT);
+
+		/* read the pagf/pagi if not already initialized */
+		/* agf should be initialized because of the ablove read_agf */
+		ASSERT(pag->pagf_init);
+		if (!pag->pagi_init) {
+			if ((error = xfs_ialloc_read_agi(mp, tp, agno, &bpi)))
+				goto error0;
+			ASSERT(pag->pagi_init);
+		}
+
 		/*
-		 * If we get an error writing out the alternate superblocks,
-		 * just issue a warning and continue.  The real work is
-		 * already done and committed.
+		 * Check the inodes: as long as we have pagi_count ==
+		 * pagi_freecount == 0, then: a) we don't have to
+		 * update any global inode counters, and b) there are
+		 * no extra blocks in inode btrees
 		 */
-		if (!(error = xfs_bwrite(mp, bp))) {
-			continue;
-		} else {
-			xfs_fs_cmn_err(CE_WARN, mp,
-		"write error %d updating secondary superblock for ag %d",
-				error, agno);
-			break; /* no point in continuing */
+		if(pag->pagi_count > 0 ||
+		   pag->pagi_freecount > 0) {
+			printk("agi %d has %d inodes in total and %d free\n",
+			       agno, pag->pagi_count, pag->pagi_freecount);
+			error = XFS_ERROR(ENOSPC);
+			goto error0;
 		}
+
+		/* Check the AGF: if levels[] == 1, then there should
+		 *  be no extra blocks in the btrees beyond the ones
+		 *  at the beggining of the AG
+		 */
+		if(pag->pagf_levels[XFS_BTNUM_BNOi] > 1 ||
+		   pag->pagf_levels[XFS_BTNUM_CNTi] > 1) {
+			printk("agf %d has level %d bt and %d cnt\n",
+			       agno,
+			       pag->pagf_levels[XFS_BTNUM_BNOi],
+			       pag->pagf_levels[XFS_BTNUM_CNTi]);
+			error = XFS_ERROR(ENOSPC);
+			goto error0;
+		}
+
+		freeblks = pag->pagf_freeblks;
+		printk("Usage: %d prealloc, %d flcount\n",
+		       XFS_PREALLOC_BLOCKS(mp), pag->pagf_flcount);
+
+		/* Done gathering data, check sizes */
+		usedblks = XFS_PREALLOC_BLOCKS(mp) + pag->pagf_flcount;
+		printk("agno=%d agf_length=%d computed used=%d"
+		       " known free=%d\n", agno, aglen, usedblks, freeblks);
+
+		if(usedblks + freeblks != aglen) {
+			printk("agno %d is not free (%d blocks allocated)\n",
+			       agno, aglen-usedblks-freeblks);
+			error = XFS_ERROR(ENOSPC);
+			goto error0;
+		}
+		dbdelta -= aglen;
+		printk("will lower with %d\n",
+		       aglen - XFS_PREALLOC_BLOCKS(mp));
+		fdbdelta += aglen - XFS_PREALLOC_BLOCKS(mp);
 	}
+	/*
+	 * Check that we removed all blocks
+	 */
+	ASSERT(!dbdelta);
+	ASSERT(nagcount < oagcount);
+
+	printk("to free: %d, oagcount=%d, nagcount=%d\n",
+	       fdbdelta, oagcount, nagcount);
+
+	xfs_trans_agblocks_delta(tp, -((long)fdbdelta));
+	xfs_trans_mod_sb(tp, XFS_TRANS_SB_AGCOUNT, nagcount - oagcount);
+	xfs_trans_mod_sb(tp, XFS_TRANS_SB_DBLOCKS, nb - mp->m_sb.sb_dblocks);
+	xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS, -((int64_t)fdbdelta));
+
+	if (dpct)
+		xfs_trans_mod_sb(tp, XFS_TRANS_SB_IMAXPCT, dpct);
+	error = xfs_trans_commit(tp, 0);
+	if (error) {
+		up_write(&mp->m_peraglock);
+		return error;
+	}
+	/* Free memory as the number of AG has changed */
+	for (agno = nagcount; agno < oagcount; agno++)
+		if (mp->m_perag[agno].pagb_list)
+			kmem_free(mp->m_perag[agno].pagb_list,
+				  sizeof(xfs_perag_busy_t) *
+				  XFS_PAGB_NUM_SLOTS);
+
+	mp->m_perag = kmem_realloc(mp->m_perag,
+				   sizeof(xfs_perag_t) * nagcount,
+				   sizeof(xfs_perag_t) * oagcount,
+				   KM_SLEEP);
+
+	nagimax = xfs_initialize_perag(XFS_MTOVFS(mp), mp, nagcount);
+	up_write(&mp->m_peraglock);
+
+	xfs_growfs_update_sb(mp, nagimax, nagcount);
 	return 0;
 
  error0:
+	up_write(&mp->m_peraglock);
 	xfs_trans_cancel(tp, XFS_TRANS_ABORT);
 	return error;
 }
@@ -435,7 +649,10 @@
 	int error;
 	if (!cpsema(&mp->m_growlock))
 		return XFS_ERROR(EWOULDBLOCK);
-	error = xfs_growfs_data_private(mp, in);
+	if(in->newblocks < mp->m_sb.sb_dblocks)
+		error = xfs_shrinkfs_data_private(mp, in);
+	else
+		error = xfs_growfs_data_private(mp, in);
 	vsema(&mp->m_growlock);
 	return error;
 }
@@ -633,7 +850,7 @@
 			xfs_force_shutdown(mp, SHUTDOWN_FORCE_UMOUNT);
 			thaw_bdev(sb->s_bdev, sb);
 		}
-	
+
 		break;
 	}
 	case XFS_FSOP_GOING_FLAGS_LOGFLUSH:
diff -X ignore -urN linux-2.6-xfs.cvs-orig/fs/xfs/xfs_trans.c linux-2.6-xfs.shrink/fs/xfs/xfs_trans.c
--- linux-2.6-xfs.cvs-orig/fs/xfs/xfs_trans.c	2007-06-05 17:40:51.000000000 +0200
+++ linux-2.6-xfs.shrink/fs/xfs/xfs_trans.c	2007-06-07 23:01:03.000000000 +0200
@@ -503,11 +503,9 @@
 		tp->t_res_frextents_delta += delta;
 		break;
 	case XFS_TRANS_SB_DBLOCKS:
-		ASSERT(delta > 0);
 		tp->t_dblocks_delta += delta;
 		break;
 	case XFS_TRANS_SB_AGCOUNT:
-		ASSERT(delta > 0);
 		tp->t_agcount_delta += delta;
 		break;
 	case XFS_TRANS_SB_IMAXPCT:

--X1bOJ3K7DJ5YkBrT--
