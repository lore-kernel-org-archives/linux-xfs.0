Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 29 Jun 2008 18:50:38 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m5U1oUV9016399
	for <xfs@oss.sgi.com>; Sun, 29 Jun 2008 18:50:31 -0700
Received: from pc-bnaujok.melbourne.sgi.com (pc-bnaujok.melbourne.sgi.com [134.14.55.58]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id LAA17088 for <xfs@oss.sgi.com>; Mon, 30 Jun 2008 11:51:31 +1000
Date: Mon, 30 Jun 2008 11:51:32 +1000
Subject: REVIEW: Fix xfs_check SEGV when encountering an unreadable block
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: multipart/mixed; boundary=----------emVJWnFPfvdRW8j9NxjBBH
MIME-Version: 1.0
Message-ID: <op.udjgr6qc3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

------------emVJWnFPfvdRW8j9NxjBBH
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
Content-Transfer-Encoding: Quoted-Printable

xfs_check (xfs_db "check" command) internally uses a stack for I/Os
it reads/writes. In the check command, there are a few places where
the I/O stack is pushed, a read is issued and the read fails but
does not pop the stack location back.

In nested uses of this stack, the caller then accesses this un-popped
block which the data pointer is "NULL" causing a SEGV.

I've checked all calls to push_cur()/set_cur() to make sure all
failures call pop_cur().

--
  check.c |   45 +++++++++++++++++++++++----------------------
  1 file changed, 23 insertions(+), 22 deletions(-)

--- a/xfsprogs/db/check.c	2008-06-30 11:46:26.000000000 +1000
+++ b/xfsprogs/db/check.c	2008-06-30 11:44:58.759289182 +1000
@@ -1991,6 +1991,7 @@ process_block_dir_v2(
  				 "%lld\n",
  				id->ino);
  		error++;
+		pop_cur();
  		return 0;
  	}
  	dir_hash_init();
@@ -2951,6 +2952,7 @@ process_leaf_dir_v1(
  				 "%lld\n",
  				id->ino);
  		error++;
+		pop_cur();
  		return 0;
  	}
  	parent =3D process_leaf_dir_v1_int(dot, dotdot, id);
@@ -3322,6 +3324,7 @@ process_node_dir_v1(
  	v =3D verbose || id->ilist;
  	parent =3D 0;
  	dbno =3D NULLFILEOFF;
+	push_cur();
  	while ((dbno =3D blkmap_next_off(blkmap, dbno, &t)) !=3D NULLFILEOFF) {
  		bno =3D blkmap_get(blkmap, dbno);
  		v2 =3D bno !=3D NULLFSBLOCK && CHECK_BLIST(bno);
@@ -3337,6 +3340,7 @@ process_node_dir_v1(
  				(__uint32_t)dbno, (xfs_dfsbno_t)bno);
  		if (bno =3D=3D NULLFSBLOCK)
  			continue;
+		pop_cur();
  		push_cur();
  		set_cur(&typtab[TYP_DIR], XFS_FSB_TO_DADDR(mp, bno), blkbb,
  			DB_RING_IGN, NULL);
@@ -3353,10 +3357,7 @@ process_node_dir_v1(
  #else
  		if (INT_GET(node->hdr.info.magic, ARCH_CONVERT) =3D=3D XFS_DIR_NODE_MAG=
IC)
  #endif
-		{
-			pop_cur();
  			continue;
-		}
  		lino =3D process_leaf_dir_v1_int(dot, dotdot, id);
  		if (lino) {
  			if (parent) {
@@ -3368,8 +3369,8 @@ process_node_dir_v1(
  			} else
  				parent =3D lino;
  		}
-		pop_cur();
  	}
+	pop_cur();
  	return parent;
  }

@@ -3411,8 +3412,7 @@ process_quota(
  	perblock =3D (uint)(mp->m_sb.sb_blocksize / sizeof(*dqb));
  	dqid =3D 0;
  	qbno =3D NULLFILEOFF;
-	while ((qbno =3D blkmap_next_off(blkmap, qbno, &t)) !=3D
-	       NULLFILEOFF) {
+	while ((qbno =3D blkmap_next_off(blkmap, qbno, &t)) !=3D NULLFILEOFF) {
  		bno =3D blkmap_get(blkmap, qbno);
  		dqid =3D (xfs_dqid_t)qbno * perblock;
  		cb =3D CHECK_BLIST(bno);
@@ -3421,13 +3421,13 @@ process_quota(
  		set_cur(&typtab[TYP_DQBLK], XFS_FSB_TO_DADDR(mp, bno), blkbb,
  			DB_RING_IGN, NULL);
  		if ((dqb =3D iocur_top->data) =3D=3D NULL) {
-			pop_cur();
  			if (scicb)
  				dbprintf("can't read block %lld for %s quota "
  					 "inode (fsblock %lld)\n",
  					(xfs_dfiloff_t)qbno, s,
  					(xfs_dfsbno_t)bno);
  			error++;
+			pop_cur();
  			continue;
  		}
  		for (i =3D 0; i < perblock; i++, dqid++, dqb++) {
@@ -3525,12 +3525,12 @@ process_rtbitmap(
  		set_cur(&typtab[TYP_RTBITMAP], XFS_FSB_TO_DADDR(mp, bno), blkbb,
  			DB_RING_IGN, NULL);
  		if ((words =3D iocur_top->data) =3D=3D NULL) {
-			pop_cur();
  			if (!sflag)
  				dbprintf("can't read block %lld for rtbitmap "
  					 "inode\n",
  					(xfs_dfiloff_t)bmbno);
  			error++;
+			pop_cur();
  			continue;
  		}
  		for (bit =3D 0;
@@ -3578,8 +3578,7 @@ process_rtsummary(
  	int		t;

  	sumbno =3D NULLFILEOFF;
-	while ((sumbno =3D blkmap_next_off(blkmap, sumbno, &t)) !=3D
-	       NULLFILEOFF) {
+	while ((sumbno =3D blkmap_next_off(blkmap, sumbno, &t)) !=3D NULLFILEOFF)=
 {
  		bno =3D blkmap_get(blkmap, sumbno);
  		if (bno =3D=3D NULLFSBLOCK) {
  			if (!sflag)
@@ -3598,6 +3597,7 @@ process_rtsummary(
  					 "inode\n",
  					(xfs_dfiloff_t)sumbno);
  			error++;
+			pop_cur();
  			continue;
  		}
  		memcpy((char *)sumfile + sumbno * mp->m_sb.sb_blocksize, bytes,
@@ -3906,16 +3906,15 @@ scan_ag(
  	agffreeblks =3D agflongest =3D 0;
  	agfbtreeblks =3D -2;
  	agicount =3D agifreecount =3D 0;
-	push_cur();
+	push_cur();	/* 1 pushed */
  	set_cur(&typtab[TYP_SB],
  		XFS_AG_DADDR(mp, agno, XFS_SB_DADDR),
  		XFS_FSS_TO_BB(mp, 1), DB_RING_IGN, NULL);

  	if (!iocur_top->data) {
  		dbprintf("can't read superblock for ag %u\n", agno);
-		pop_cur();
  		serious_error++;
-		return;
+		goto pop1_out;
  	}

  	libxfs_xlate_sb(iocur_top->data, sb, 1, XFS_SB_ALL_BITS);
@@ -3945,16 +3944,14 @@ scan_ag(
  	if (sb->sb_logstart && XFS_FSB_TO_AGNO(mp, sb->sb_logstart) =3D=3D agno)
  		set_dbmap(agno, XFS_FSB_TO_AGBNO(mp, sb->sb_logstart),
  			sb->sb_logblocks, DBM_LOG, agno, XFS_SB_BLOCK(mp));
-	push_cur();
+	push_cur();	/* 2 pushed */
  	set_cur(&typtab[TYP_AGF],
  		XFS_AG_DADDR(mp, agno, XFS_AGF_DADDR(mp)),
  		XFS_FSS_TO_BB(mp, 1), DB_RING_IGN, NULL);
  	if ((agf =3D iocur_top->data) =3D=3D NULL) {
  		dbprintf("can't read agf block for ag %u\n", agno);
-		pop_cur();
-		pop_cur();
  		serious_error++;
-		return;
+		goto pop2_out;
  	}
  	if (INT_GET(agf->agf_magicnum, ARCH_CONVERT) !=3D XFS_AGF_MAGIC) {
  		if (!sflag)
@@ -3975,17 +3972,14 @@ scan_ag(
  		set_dbmap(agno, INT_GET(agf->agf_length, ARCH_CONVERT),
  			sb->sb_agblocks - INT_GET(agf->agf_length, ARCH_CONVERT),
  			DBM_MISSING, agno, XFS_SB_BLOCK(mp));
-	push_cur();
+	push_cur();	/* 3 pushed */
  	set_cur(&typtab[TYP_AGI],
  		XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp)),
  		XFS_FSS_TO_BB(mp, 1), DB_RING_IGN, NULL);
  	if ((agi =3D iocur_top->data) =3D=3D NULL) {
  		dbprintf("can't read agi block for ag %u\n", agno);
  		serious_error++;
-		pop_cur();
-		pop_cur();
-		pop_cur();
-		return;
+		goto pop3_out;
  	}
  	if (INT_GET(agi->agi_magicnum, ARCH_CONVERT) !=3D XFS_AGI_MAGIC) {
  		if (!sflag)
@@ -4066,8 +4060,11 @@ scan_ag(
  			error++;
  		}
  	}
+pop3_out:
  	pop_cur();
+pop2_out:
  	pop_cur();
+pop1_out:
  	pop_cur();
  }

@@ -4095,6 +4092,7 @@ scan_freelist(
  	if ((agfl =3D iocur_top->data) =3D=3D NULL) {
  		dbprintf("can't read agfl block for ag %u\n", seqno);
  		serious_error++;
+		pop_cur();
  		return;
  	}
  	i =3D INT_GET(agf->agf_flfirst, ARCH_CONVERT);
@@ -4144,6 +4142,7 @@ scan_lbtree(
  				XFS_FSB_TO_AGNO(mp, root),
  				XFS_FSB_TO_AGBNO(mp, root));
  		error++;
+		pop_cur();
  		return;
  	}
  	(*func)(iocur_top->data, nlevels - 1, type, root, id, totd, toti, nex,
@@ -4169,6 +4168,7 @@ scan_sbtree(
  		if (!sflag)
  			dbprintf("can't read btree block %u/%u\n", seqno, root);
  		error++;
+		pop_cur();
  		return;
  	}
  	(*func)(iocur_top->data, nlevels - 1, agf, root, isroot);
@@ -4484,6 +4484,7 @@ scanfunc_ino(
  						seqno,
  						XFS_AGINO_TO_AGBNO(mp, agino));
  				error++;
+				pop_cur();
  				continue;
  			}
  			for (j =3D 0, nfree =3D 0; j < XFS_INODES_PER_CHUNK; j++) {
------------emVJWnFPfvdRW8j9NxjBBH
Content-Disposition: attachment; filename=fix_check_segv.patch
Content-Type: text/x-patch; name=fix_check_segv.patch
Content-Transfer-Encoding: Quoted-Printable

--- a/xfsprogs/db/check.c	2008-06-30 11:46:26.000000000 +1000
+++ b/xfsprogs/db/check.c	2008-06-30 11:44:58.759289182 +1000
@@ -1991,6 +1991,7 @@ process_block_dir_v2(
 				 "%lld\n",
 				id->ino);
 		error++;
+		pop_cur();
 		return 0;
 	}
 	dir_hash_init();
@@ -2951,6 +2952,7 @@ process_leaf_dir_v1(
 				 "%lld\n",
 				id->ino);
 		error++;
+		pop_cur();
 		return 0;
 	}
 	parent =3D process_leaf_dir_v1_int(dot, dotdot, id);
@@ -3322,6 +3324,7 @@ process_node_dir_v1(
 	v =3D verbose || id->ilist;
 	parent =3D 0;
 	dbno =3D NULLFILEOFF;
+	push_cur();
 	while ((dbno =3D blkmap_next_off(blkmap, dbno, &t)) !=3D NULLFILEOFF) {
 		bno =3D blkmap_get(blkmap, dbno);
 		v2 =3D bno !=3D NULLFSBLOCK && CHECK_BLIST(bno);
@@ -3337,6 +3340,7 @@ process_node_dir_v1(
 				(__uint32_t)dbno, (xfs_dfsbno_t)bno);
 		if (bno =3D=3D NULLFSBLOCK)
 			continue;
+		pop_cur();
 		push_cur();
 		set_cur(&typtab[TYP_DIR], XFS_FSB_TO_DADDR(mp, bno), blkbb,
 			DB_RING_IGN, NULL);
@@ -3353,10 +3357,7 @@ process_node_dir_v1(
 #else
 		if (INT_GET(node->hdr.info.magic, ARCH_CONVERT) =3D=3D XFS_DIR_NODE_MAGI=
C)
 #endif
-		{
-			pop_cur();
 			continue;
-		}
 		lino =3D process_leaf_dir_v1_int(dot, dotdot, id);
 		if (lino) {
 			if (parent) {
@@ -3368,8 +3369,8 @@ process_node_dir_v1(
 			} else
 				parent =3D lino;
 		}
-		pop_cur();
 	}
+	pop_cur();
 	return parent;
 }
=20
@@ -3411,8 +3412,7 @@ process_quota(
 	perblock =3D (uint)(mp->m_sb.sb_blocksize / sizeof(*dqb));
 	dqid =3D 0;
 	qbno =3D NULLFILEOFF;
-	while ((qbno =3D blkmap_next_off(blkmap, qbno, &t)) !=3D
-	       NULLFILEOFF) {
+	while ((qbno =3D blkmap_next_off(blkmap, qbno, &t)) !=3D NULLFILEOFF) {
 		bno =3D blkmap_get(blkmap, qbno);
 		dqid =3D (xfs_dqid_t)qbno * perblock;
 		cb =3D CHECK_BLIST(bno);
@@ -3421,13 +3421,13 @@ process_quota(
 		set_cur(&typtab[TYP_DQBLK], XFS_FSB_TO_DADDR(mp, bno), blkbb,
 			DB_RING_IGN, NULL);
 		if ((dqb =3D iocur_top->data) =3D=3D NULL) {
-			pop_cur();
 			if (scicb)
 				dbprintf("can't read block %lld for %s quota "
 					 "inode (fsblock %lld)\n",
 					(xfs_dfiloff_t)qbno, s,
 					(xfs_dfsbno_t)bno);
 			error++;
+			pop_cur();
 			continue;
 		}
 		for (i =3D 0; i < perblock; i++, dqid++, dqb++) {
@@ -3525,12 +3525,12 @@ process_rtbitmap(
 		set_cur(&typtab[TYP_RTBITMAP], XFS_FSB_TO_DADDR(mp, bno), blkbb,
 			DB_RING_IGN, NULL);
 		if ((words =3D iocur_top->data) =3D=3D NULL) {
-			pop_cur();
 			if (!sflag)
 				dbprintf("can't read block %lld for rtbitmap "
 					 "inode\n",
 					(xfs_dfiloff_t)bmbno);
 			error++;
+			pop_cur();
 			continue;
 		}
 		for (bit =3D 0;
@@ -3578,8 +3578,7 @@ process_rtsummary(
 	int		t;
=20
 	sumbno =3D NULLFILEOFF;
-	while ((sumbno =3D blkmap_next_off(blkmap, sumbno, &t)) !=3D
-	       NULLFILEOFF) {
+	while ((sumbno =3D blkmap_next_off(blkmap, sumbno, &t)) !=3D NULLFILEOFF)=
 {
 		bno =3D blkmap_get(blkmap, sumbno);
 		if (bno =3D=3D NULLFSBLOCK) {
 			if (!sflag)
@@ -3598,6 +3597,7 @@ process_rtsummary(
 					 "inode\n",
 					(xfs_dfiloff_t)sumbno);
 			error++;
+			pop_cur();
 			continue;
 		}
 		memcpy((char *)sumfile + sumbno * mp->m_sb.sb_blocksize, bytes,
@@ -3906,16 +3906,15 @@ scan_ag(
 	agffreeblks =3D agflongest =3D 0;
 	agfbtreeblks =3D -2;
 	agicount =3D agifreecount =3D 0;
-	push_cur();
+	push_cur();	/* 1 pushed */
 	set_cur(&typtab[TYP_SB],
 		XFS_AG_DADDR(mp, agno, XFS_SB_DADDR),
 		XFS_FSS_TO_BB(mp, 1), DB_RING_IGN, NULL);
=20
 	if (!iocur_top->data) {
 		dbprintf("can't read superblock for ag %u\n", agno);
-		pop_cur();
 		serious_error++;
-		return;
+		goto pop1_out;
 	}
=20
 	libxfs_xlate_sb(iocur_top->data, sb, 1, XFS_SB_ALL_BITS);
@@ -3945,16 +3944,14 @@ scan_ag(
 	if (sb->sb_logstart && XFS_FSB_TO_AGNO(mp, sb->sb_logstart) =3D=3D agno)
 		set_dbmap(agno, XFS_FSB_TO_AGBNO(mp, sb->sb_logstart),
 			sb->sb_logblocks, DBM_LOG, agno, XFS_SB_BLOCK(mp));
-	push_cur();
+	push_cur();	/* 2 pushed */
 	set_cur(&typtab[TYP_AGF],
 		XFS_AG_DADDR(mp, agno, XFS_AGF_DADDR(mp)),
 		XFS_FSS_TO_BB(mp, 1), DB_RING_IGN, NULL);
 	if ((agf =3D iocur_top->data) =3D=3D NULL) {
 		dbprintf("can't read agf block for ag %u\n", agno);
-		pop_cur();
-		pop_cur();
 		serious_error++;
-		return;
+		goto pop2_out;
 	}
 	if (INT_GET(agf->agf_magicnum, ARCH_CONVERT) !=3D XFS_AGF_MAGIC) {
 		if (!sflag)
@@ -3975,17 +3972,14 @@ scan_ag(
 		set_dbmap(agno, INT_GET(agf->agf_length, ARCH_CONVERT),
 			sb->sb_agblocks - INT_GET(agf->agf_length, ARCH_CONVERT),
 			DBM_MISSING, agno, XFS_SB_BLOCK(mp));
-	push_cur();
+	push_cur();	/* 3 pushed */
 	set_cur(&typtab[TYP_AGI],
 		XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp)),
 		XFS_FSS_TO_BB(mp, 1), DB_RING_IGN, NULL);
 	if ((agi =3D iocur_top->data) =3D=3D NULL) {
 		dbprintf("can't read agi block for ag %u\n", agno);
 		serious_error++;
-		pop_cur();
-		pop_cur();
-		pop_cur();
-		return;
+		goto pop3_out;
 	}
 	if (INT_GET(agi->agi_magicnum, ARCH_CONVERT) !=3D XFS_AGI_MAGIC) {
 		if (!sflag)
@@ -4066,8 +4060,11 @@ scan_ag(
 			error++;
 		}
 	}
+pop3_out:
 	pop_cur();
+pop2_out:
 	pop_cur();
+pop1_out:
 	pop_cur();
 }
=20
@@ -4095,6 +4092,7 @@ scan_freelist(
 	if ((agfl =3D iocur_top->data) =3D=3D NULL) {
 		dbprintf("can't read agfl block for ag %u\n", seqno);
 		serious_error++;
+		pop_cur();
 		return;
 	}
 	i =3D INT_GET(agf->agf_flfirst, ARCH_CONVERT);
@@ -4144,6 +4142,7 @@ scan_lbtree(
 				XFS_FSB_TO_AGNO(mp, root),
 				XFS_FSB_TO_AGBNO(mp, root));
 		error++;
+		pop_cur();
 		return;
 	}
 	(*func)(iocur_top->data, nlevels - 1, type, root, id, totd, toti, nex,
@@ -4169,6 +4168,7 @@ scan_sbtree(
 		if (!sflag)
 			dbprintf("can't read btree block %u/%u\n", seqno, root);
 		error++;
+		pop_cur();
 		return;
 	}
 	(*func)(iocur_top->data, nlevels - 1, agf, root, isroot);
@@ -4484,6 +4484,7 @@ scanfunc_ino(
 						seqno,
 						XFS_AGINO_TO_AGBNO(mp, agino));
 				error++;
+				pop_cur();
 				continue;
 			}
 			for (j =3D 0, nfree =3D 0; j < XFS_INODES_PER_CHUNK; j++) {

------------emVJWnFPfvdRW8j9NxjBBH--
