Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 10 Jun 2007 09:40:54 -0700 (PDT)
Received: from astra.simleu.ro (astra.simleu.ro [80.97.18.177])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5AGeoWt024818
	for <xfs@oss.sgi.com>; Sun, 10 Jun 2007 09:40:51 -0700
Received: from teal.hq.k1024.org (84-75-124-135.dclient.hispeed.ch [84.75.124.135])
	by astra.simleu.ro (Postfix) with ESMTP id 7700A69
	for <xfs@oss.sgi.com>; Sun, 10 Jun 2007 19:40:45 +0300 (EEST)
Date: Sun, 10 Jun 2007 18:40:14 +0200
From: Iustin Pop <iusty@k1024.org>
Subject: [PATCH] Implement shrink of empty AGs
Message-ID: <20070610164014.GA10936@teal.hq.k1024.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eHhjakXzOLJAF9wJ"
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

--eHhjakXzOLJAF9wJ
Content-Type: multipart/mixed; boundary="mojUlQ0s9EVzWg2t"
Content-Disposition: inline

--mojUlQ0s9EVzWg2t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The attached patch implements shrinking of completely empty allocation
groups. The patch is against current CVS and modifies two files:
  - xfs_trans.c to remove two asserts in which prevent lowering the
    number of AGs or filesystem blocks;
  - xfs_fsops.c where it does:
    - modify xfs_growfs_data() to branch to either
      xfs_growfs_data_private or xfs_shrinkfs_data private depending on
      the new size of the fs
    - abstract the last part of xfs_growfs_data_private (the modify of
      all the superblocks) into a separate function, xfs_update_sb(),
      which is called both from shrink and grow
    - add the new xfs_shrinkfs_data_private function, mostly based on
      the growfs function

There are many printk()'s left in the patch, I left them as they show
where I compute some important values. There are also many FIXMEs in the
comments showing what parts I didn't understand or was not sure about
(not that these are the only ones...). Probably for a real patch,
xfs-specific debug hooks need to be added and the printk()s removed.

The patch works on UML and QEMU virtual machines, both in UP and SMP. I
just tested many shrink/grow operations and verified with xfs_repair
that the fs is not corrupted. The free space counters seem to be correct
after shrink.

Note that you also need to remove the check from xfs_growfs.c of not
allowing to shrink the filesystem.

regards,
iustin

--mojUlQ0s9EVzWg2t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-nice-4
Content-Transfer-Encoding: quoted-printable

diff -X ignore -urN linux-2.6-xfs.cvs-orig/fs/xfs/xfs_fsops.c linux-2.6-xfs=
.shrink/fs/xfs/xfs_fsops.c
--- linux-2.6-xfs.cvs-orig/fs/xfs/xfs_fsops.c	2007-06-09 18:56:21.509308225=
 +0200
+++ linux-2.6-xfs.shrink/fs/xfs/xfs_fsops.c	2007-06-10 18:32:36.074856477 +=
0200
@@ -112,6 +112,53 @@
 	return 0;
 }
=20
+static void xfs_update_sb(
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
+		mp->m_maxagi =3D nagimax;
+	if (mp->m_sb.sb_imax_pct) {
+		__uint64_t icount =3D mp->m_sb.sb_dblocks * mp->m_sb.sb_imax_pct;
+		do_div(icount, 100);
+		mp->m_maxicount =3D icount << mp->m_sb.sb_inopblog;
+	} else
+		mp->m_maxicount =3D 0;
+	for (agno =3D 1; agno < nagcount; agno++) {
+		error =3D xfs_read_buf(mp, mp->m_ddev_targp,
+				  XFS_AGB_TO_DADDR(mp, agno, XFS_SB_BLOCK(mp)),
+				  XFS_FSS_TO_BB(mp, 1), 0, &bp);
+		if (error) {
+			xfs_fs_cmn_err(CE_WARN, mp,
+			"error %d reading secondary superblock for ag %d",
+				error, agno);
+			break;
+		}
+		sbp =3D XFS_BUF_TO_SBP(bp);
+		xfs_xlatesb(sbp, &mp->m_sb, -1, XFS_SB_ALL_BITS);
+		/*
+		 * If we get an error writing out the alternate superblocks,
+		 * just issue a warning and continue.  The real work is
+		 * already done and committed.
+		 */
+		if (!(error =3D xfs_bwrite(mp, bp))) {
+			continue;
+		} else {
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
@@ -135,7 +182,6 @@
 	xfs_rfsblock_t		nfree;
 	xfs_agnumber_t		oagcount;
 	int			pct;
-	xfs_sb_t		*sbp;
 	xfs_trans_t		*tp;
=20
 	nb =3D in->newblocks;
@@ -356,44 +402,228 @@
 	if (error) {
 		return error;
 	}
-	/* New allocation groups fully initialized, so update mount struct */
-	if (nagimax)
-		mp->m_maxagi =3D nagimax;
-	if (mp->m_sb.sb_imax_pct) {
-		__uint64_t icount =3D mp->m_sb.sb_dblocks * mp->m_sb.sb_imax_pct;
-		do_div(icount, 100);
-		mp->m_maxicount =3D icount << mp->m_sb.sb_inopblog;
-	} else
-		mp->m_maxicount =3D 0;
-	for (agno =3D 1; agno < nagcount; agno++) {
-		error =3D xfs_read_buf(mp, mp->m_ddev_targp,
-				  XFS_AGB_TO_DADDR(mp, agno, XFS_SB_BLOCK(mp)),
-				  XFS_FSS_TO_BB(mp, 1), 0, &bp);
+	xfs_update_sb(mp, nagimax, nagcount);
+	return 0;
+
+ error0:
+	xfs_trans_cancel(tp, XFS_TRANS_ABORT);
+	return error;
+}
+
+static int
+xfs_shrinkfs_data_private(
+			  xfs_mount_t		*mp,		/* mount point for filesystem */
+			  xfs_growfs_data_t	*in)		/* growfs data input struct */
+{
+	xfs_agf_t		*agf;
+	xfs_agnumber_t		agno;
+	xfs_buf_t		*bp;
+	int			dpct;
+	int			error;
+	xfs_agnumber_t		nagcount;       /* new AG count */
+	xfs_agnumber_t		oagcount;       /* old AG count */
+	xfs_agnumber_t		nagimax =3D 0;
+	xfs_rfsblock_t		nb, nb_mod;
+	xfs_rfsblock_t		dbdelta;        /* will be used as a
+						   check that we
+						   shrink the fs by
+						   the correct number
+						   of blocks */
+	xfs_rfsblock_t		fdbdelta;       /* will keep track of
+						   how many ag blocks
+						   we need to
+						   remove */
+	int			pct;
+	xfs_trans_t		*tp;
+
+	nb =3D in->newblocks;
+	pct =3D in->imaxpct;
+	if (nb >=3D mp->m_sb.sb_dblocks || pct < 0 || pct > 100)
+		return XFS_ERROR(EINVAL);
+	dpct =3D pct - mp->m_sb.sb_imax_pct;
+	error =3D xfs_read_buf(mp, mp->m_ddev_targp,
+			     XFS_FSB_TO_BB(mp, nb) - XFS_FSS_TO_BB(mp, 1),
+			     XFS_FSS_TO_BB(mp, 1), 0, &bp);
+	if (error)
+		return error;
+	ASSERT(bp);
+	/* FIXME: we release the buffer here manually because we are
+	 * outside of a transaction? The other buffers read using the
+	 * functions which take a tp parameter are not released in
+	 * growfs
+	 */
+	xfs_buf_relse(bp);
+
+	/* Do basic checks (at the fs level) */
+	oagcount =3D mp->m_sb.sb_agcount;
+	nagcount =3D nb;
+	nb_mod =3D do_div(nagcount, mp->m_sb.sb_agblocks);
+	if(nb_mod) {
+		printk("not shrinking on an AG boundary (diff=3D%d)\n", nb_mod);
+		return XFS_ERROR(ENOSPC);
+	}
+	if(nagcount < 2) {
+		printk("refusing to shrink below 2 AGs\n");
+		return XFS_ERROR(ENOSPC);
+	}
+	if(nagcount >=3D oagcount) {
+		printk("number of AGs will not decrease\n");
+		return XFS_ERROR(EINVAL);
+	}
+	printk("Cur ag=3D%d, cur blocks=3D%llu\n",
+	       mp->m_sb.sb_agcount, mp->m_sb.sb_dblocks);
+	printk("New ag=3D%d, new blocks=3D%d\n", nagcount, nb);
+
+	printk("Will resize from %llu to %d, delta is %llu\n",
+               mp->m_sb.sb_dblocks, nb, mp->m_sb.sb_dblocks - nb);
+	/* Check to see if we trip over the log section */
+	printk("logstart=3D%llu logblocks=3D%u\n",
+               mp->m_sb.sb_logstart, mp->m_sb.sb_logblocks);
+	if (nb < mp->m_sb.sb_logstart + mp->m_sb.sb_logblocks)
+		return XFS_ERROR(EINVAL);
+	/* dbdelta starts at the diff and must become zero */
+	dbdelta =3D mp->m_sb.sb_dblocks - nb;
+	tp =3D xfs_trans_alloc(mp, XFS_TRANS_GROWFS);
+	printk("reserving %d\n", XFS_GROWFS_SPACE_RES(mp) + dbdelta);
+	if ((error =3D xfs_trans_reserve(tp, XFS_GROWFS_SPACE_RES(mp) + dbdelta,
+				       XFS_GROWDATA_LOG_RES(mp), 0, 0, 0))) {
+		xfs_trans_cancel(tp, 0);
+		return error;
+	}
+
+	fdbdelta =3D 0;
+
+	/* Per-AG checks */
+	/* FIXME: do we need to hold m_peraglock while doing this? */
+	/* I think that since we do read and write to the m_perag
+	 * stuff, we should be holding the lock for the entire walk &
+	 * modify of the fs
+	 */
+	/* Note that because we hold the lock, on any error+early
+	 *  return, we must either release manually and return, or
+	 *  jump to error0
+	 */
+	down_write(&mp->m_peraglock);
+	for(agno =3D oagcount - 1; agno >=3D nagcount; agno--) {
+		xfs_extlen_t	usedblks; /* total used blocks in this a.g. */
+		xfs_extlen_t	freeblks; /* free blocks in this a.g. */
+		xfs_agblock_t	aglen;    /* this ag's len */
+		struct xfs_perag *pag;  /* the m_perag structure */
+
+		printk("doing agno=3D%d\n", agno);
+
+		pag =3D &mp->m_perag[agno];
+
+		error =3D xfs_alloc_read_agf(mp, tp, agno, 0, &bp);
 		if (error) {
-			xfs_fs_cmn_err(CE_WARN, mp,
-			"error %d reading secondary superblock for ag %d",
-				error, agno);
-			break;
+			goto error0;
 		}
-		sbp =3D XFS_BUF_TO_SBP(bp);
-		xfs_xlatesb(sbp, &mp->m_sb, -1, XFS_SB_ALL_BITS);
+		ASSERT(bp);
+		agf =3D XFS_BUF_TO_AGF(bp);
+		aglen =3D INT_GET(agf->agf_length, ARCH_CONVERT);
+
+		/* read the pagf/pagi if not already initialized */
+		/* agf should be initialized because of the ablove read_agf */
+		ASSERT(pag->pagf_init);
+		if (!pag->pagi_init) {
+			if ((error =3D xfs_ialloc_read_agi(mp, tp, agno, &bp)))
+				goto error0;
+			ASSERT(pag->pagi_init);
+		}
+
 		/*
-		 * If we get an error writing out the alternate superblocks,
-		 * just issue a warning and continue.  The real work is
-		 * already done and committed.
+		 * Check the inodes: as long as we have pagi_count =3D=3D
+		 * pagi_freecount =3D=3D 0, then: a) we don't have to
+		 * update any global inode counters, and b) there are
+		 * no extra blocks in inode btrees
 		 */
-		if (!(error =3D xfs_bwrite(mp, bp))) {
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
+			error =3D XFS_ERROR(ENOSPC);
+			goto error0;
+		}
+
+		/* Check the AGF: if levels[] =3D=3D 1, then there should
+		 *  be no extra blocks in the btrees beyond the ones
+		 *  at the beggining of the AG
+		 */
+		if(pag->pagf_levels[XFS_BTNUM_BNOi] > 1 ||
+		   pag->pagf_levels[XFS_BTNUM_CNTi] > 1) {
+			printk("agf %d has level %d bt and %d cnt\n",
+			       agno,
+			       pag->pagf_levels[XFS_BTNUM_BNOi],
+			       pag->pagf_levels[XFS_BTNUM_CNTi]);
+			error =3D XFS_ERROR(ENOSPC);
+			goto error0;
 		}
+
+		freeblks =3D pag->pagf_freeblks;
+		printk("Usage: %d prealloc, %d flcount\n",
+		       XFS_PREALLOC_BLOCKS(mp), pag->pagf_flcount);
+
+		/* Done gathering data, check sizes */
+		usedblks =3D XFS_PREALLOC_BLOCKS(mp) + pag->pagf_flcount;
+		printk("agno=3D%d agf_length=3D%d computed used=3D%d"
+		       " known free=3D%d\n", agno, aglen, usedblks, freeblks);
+
+		if(usedblks + freeblks !=3D aglen) {
+			printk("agno %d is not free (%d blocks allocated)\n",
+			       agno, aglen-usedblks-freeblks);
+			error =3D XFS_ERROR(ENOSPC);
+			goto error0;
+		}
+		dbdelta -=3D aglen;
+		printk("will lower with %d\n",
+		       aglen - XFS_PREALLOC_BLOCKS(mp));
+		fdbdelta +=3D aglen - XFS_PREALLOC_BLOCKS(mp);
+	}
+	/*
+	 * Check that we removed all blocks
+	 */
+	ASSERT(!dbdelta);
+	ASSERT(nagcount < oagcount);
+
+	printk("to free: %d, oagcount=3D%d, nagcount=3D%d\n",
+	       fdbdelta, oagcount, nagcount);
+
+	xfs_trans_agblocks_delta(tp, -((long)fdbdelta));
+	xfs_trans_mod_sb(tp, XFS_TRANS_SB_AGCOUNT, nagcount - oagcount);
+	xfs_trans_mod_sb(tp, XFS_TRANS_SB_DBLOCKS, nb - mp->m_sb.sb_dblocks);
+	xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS, -((int64_t)fdbdelta));
+
+	if (dpct)
+		xfs_trans_mod_sb(tp, XFS_TRANS_SB_IMAXPCT, dpct);
+	error =3D xfs_trans_commit(tp, 0);
+	if (error) {
+		up_write(&mp->m_peraglock);
+		return error;
 	}
+	/* Free memory as the number of AG has changed */
+	for (agno =3D nagcount; agno < oagcount; agno++)
+		if (mp->m_perag[agno].pagb_list)
+			kmem_free(mp->m_perag[agno].pagb_list,
+				  sizeof(xfs_perag_busy_t) *
+				  XFS_PAGB_NUM_SLOTS);
+
+	mp->m_perag =3D kmem_realloc(mp->m_perag,
+				   sizeof(xfs_perag_t) * nagcount,
+				   sizeof(xfs_perag_t) * oagcount,
+				   KM_SLEEP);
+	/* FIXME: here we could instead just lower
+	 * nagimax to nagcount; is it better this way?
+	 */
+	/* FIXME: why is this flag unconditionally set in growfs? */
+	mp->m_flags |=3D XFS_MOUNT_32BITINODES;
+	nagimax =3D xfs_initialize_perag(XFS_MTOVFS(mp), mp, nagcount);
+	up_write(&mp->m_peraglock);
+
+	xfs_update_sb(mp, nagimax, nagcount);
 	return 0;
=20
  error0:
+	up_write(&mp->m_peraglock);
 	xfs_trans_cancel(tp, XFS_TRANS_ABORT);
 	return error;
 }
@@ -435,7 +665,10 @@
 	int error;
 	if (!cpsema(&mp->m_growlock))
 		return XFS_ERROR(EWOULDBLOCK);
-	error =3D xfs_growfs_data_private(mp, in);
+	if(in->newblocks < mp->m_sb.sb_dblocks)
+		error =3D xfs_shrinkfs_data_private(mp, in);
+	else
+		error =3D xfs_growfs_data_private(mp, in);
 	vsema(&mp->m_growlock);
 	return error;
 }
@@ -633,7 +866,7 @@
 			xfs_force_shutdown(mp, SHUTDOWN_FORCE_UMOUNT);
 			thaw_bdev(sb->s_bdev, sb);
 		}
-=09
+
 		break;
 	}
 	case XFS_FSOP_GOING_FLAGS_LOGFLUSH:
diff -X ignore -urN linux-2.6-xfs.cvs-orig/fs/xfs/xfs_trans.c linux-2.6-xfs=
.shrink/fs/xfs/xfs_trans.c
--- linux-2.6-xfs.cvs-orig/fs/xfs/xfs_trans.c	2007-06-05 17:40:51.000000000=
 +0200
+++ linux-2.6-xfs.shrink/fs/xfs/xfs_trans.c	2007-06-07 23:01:03.000000000 +=
0200
@@ -503,11 +503,9 @@
 		tp->t_res_frextents_delta +=3D delta;
 		break;
 	case XFS_TRANS_SB_DBLOCKS:
-		ASSERT(delta > 0);
 		tp->t_dblocks_delta +=3D delta;
 		break;
 	case XFS_TRANS_SB_AGCOUNT:
-		ASSERT(delta > 0);
 		tp->t_agcount_delta +=3D delta;
 		break;
 	case XFS_TRANS_SB_IMAXPCT:

--mojUlQ0s9EVzWg2t--

--eHhjakXzOLJAF9wJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGbClu4mx23Z34NMIRAjkXAKCEQ32nH3pbybjrl8aqLDx2rdLGfwCgjfye
BFVIpTFuy+oLETPTf3BF+yA=
=bsEN
-----END PGP SIGNATURE-----

--eHhjakXzOLJAF9wJ--
