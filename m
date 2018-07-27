Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:50576 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730850AbeG0XsP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 Jul 2018 19:48:15 -0400
Subject: [PATCH 1/2] misc: use xfs_agfl_walk where appropriate
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 27 Jul 2018 15:24:13 -0700
Message-ID: <153273025311.29060.14065633572750924491.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Use the xfs_agfl_walk function to iterate every block in the AGFL,
instead of open-coding it db and repair.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/check.c               |   60 ++++++++++++++++++++++--------------------
 db/freesp.c              |   31 ++++++++--------------
 libxfs/libxfs_api_defs.h |    1 +
 repair/scan.c            |   66 +++++++++++++++++++++++++---------------------
 4 files changed, 81 insertions(+), 77 deletions(-)


diff --git a/db/check.c b/db/check.c
index 9846d672..76c28d49 100644
--- a/db/check.c
+++ b/db/check.c
@@ -4010,16 +4010,30 @@ scan_ag(
 	pop_cur();
 }
 
+struct agfl_state {
+	xfs_agnumber_t	agno;
+	unsigned int	count;
+};
+
+static int
+scan_agfl(
+	struct xfs_mount	*mp,
+	xfs_agblock_t		bno,
+	void			*priv)
+{
+	struct agfl_state	*as = priv;
+
+	set_dbmap(as->agno, bno, 1, DBM_FREELIST, as->agno, XFS_AGFL_BLOCK(mp));
+	as->count++;
+	return 0;
+}
+
 static void
 scan_freelist(
-	xfs_agf_t	*agf)
+	xfs_agf_t		*agf)
 {
-	xfs_agnumber_t	seqno = be32_to_cpu(agf->agf_seqno);
-	xfs_agfl_t	*agfl;
-	xfs_agblock_t	bno;
-	uint		count;
-	int		i;
-	__be32		*freelist;
+	xfs_agnumber_t		seqno = be32_to_cpu(agf->agf_seqno);
+	struct agfl_state	state;
 
 	if (XFS_SB_BLOCK(mp) != XFS_AGFL_BLOCK(mp) &&
 	    XFS_AGF_BLOCK(mp) != XFS_AGFL_BLOCK(mp) &&
@@ -4032,46 +4046,36 @@ scan_freelist(
 	set_cur(&typtab[TYP_AGFL],
 		XFS_AG_DADDR(mp, seqno, XFS_AGFL_DADDR(mp)),
 		XFS_FSS_TO_BB(mp, 1), DB_RING_IGN, NULL);
-	if ((agfl = iocur_top->data) == NULL) {
+	if (iocur_top->data == NULL) {
 		dbprintf(_("can't read agfl block for ag %u\n"), seqno);
 		serious_error++;
 		pop_cur();
 		return;
 	}
-	i = be32_to_cpu(agf->agf_flfirst);
 
 	/* verify agf values before proceeding */
 	if (be32_to_cpu(agf->agf_flfirst) >= libxfs_agfl_size(mp) ||
 	    be32_to_cpu(agf->agf_fllast) >= libxfs_agfl_size(mp)) {
 		dbprintf(_("agf %d freelist blocks bad, skipping "
-			  "freelist scan\n"), i);
+			  "freelist scan\n"), seqno);
 		pop_cur();
 		return;
 	}
 
 	/* open coded XFS_BUF_TO_AGFL_BNO */
-	freelist = xfs_sb_version_hascrc(&((mp)->m_sb)) ? &agfl->agfl_bno[0]
-							: (__be32 *)agfl;
-	count = 0;
-	for (;;) {
-		bno = be32_to_cpu(freelist[i]);
-		set_dbmap(seqno, bno, 1, DBM_FREELIST, seqno,
-			XFS_AGFL_BLOCK(mp));
-		count++;
-		if (i == be32_to_cpu(agf->agf_fllast))
-			break;
-		if (++i == libxfs_agfl_size(mp))
-			i = 0;
-	}
-	if (count != be32_to_cpu(agf->agf_flcount)) {
+	state.count = 0;
+	state.agno = seqno;
+	libxfs_agfl_walk(mp, agf, iocur_top->bp, scan_agfl, &state);
+	if (state.count != be32_to_cpu(agf->agf_flcount)) {
 		if (!sflag)
 			dbprintf(_("freeblk count %u != flcount %u in ag %u\n"),
-				count, be32_to_cpu(agf->agf_flcount),
-				seqno);
+					state.count,
+					be32_to_cpu(agf->agf_flcount),
+					seqno);
 		error++;
 	}
-	fdblocks += count;
-	agf_aggr_freeblks += count;
+	fdblocks += state.count;
+	agf_aggr_freeblks += state.count;
 	pop_cur();
 }
 
diff --git a/db/freesp.c b/db/freesp.c
index de0d5e10..903c60d7 100644
--- a/db/freesp.c
+++ b/db/freesp.c
@@ -219,45 +219,38 @@ scan_ag(
 	pop_cur();
 }
 
+static int
+scan_agfl(
+	struct xfs_mount	*mp,
+	xfs_agblock_t		bno,
+	void			*priv)
+{
+	addtohist(*(xfs_agnumber_t *)priv, bno, 1);
+	return 0;
+}
+
 static void
 scan_freelist(
 	xfs_agf_t	*agf)
 {
 	xfs_agnumber_t	seqno = be32_to_cpu(agf->agf_seqno);
-	xfs_agfl_t	*agfl;
-	xfs_agblock_t	bno;
-	int		i;
-	__be32		*agfl_bno;
 
 	if (be32_to_cpu(agf->agf_flcount) == 0)
 		return;
 	push_cur();
 	set_cur(&typtab[TYP_AGFL], XFS_AG_DADDR(mp, seqno, XFS_AGFL_DADDR(mp)),
 				XFS_FSS_TO_BB(mp, 1), DB_RING_IGN, NULL);
-	agfl = iocur_top->data;
-	i = be32_to_cpu(agf->agf_flfirst);
-
-	/* open coded XFS_BUF_TO_AGFL_BNO */
-	agfl_bno = xfs_sb_version_hascrc(&mp->m_sb) ? &agfl->agfl_bno[0]
-						   : (__be32 *)agfl;
 
 	/* verify agf values before proceeding */
 	if (be32_to_cpu(agf->agf_flfirst) >= libxfs_agfl_size(mp) ||
 	    be32_to_cpu(agf->agf_fllast) >= libxfs_agfl_size(mp)) {
 		dbprintf(_("agf %d freelist blocks bad, skipping "
-			  "freelist scan\n"), i);
+			  "freelist scan\n"), seqno);
 		pop_cur();
 		return;
 	}
 
-	for (;;) {
-		bno = be32_to_cpu(agfl_bno[i]);
-		addtohist(seqno, bno, 1);
-		if (i == be32_to_cpu(agf->agf_fllast))
-			break;
-		if (++i == libxfs_agfl_size(mp))
-			i = 0;
-	}
+	libxfs_agfl_walk(mp, agf, iocur_top->bp, scan_agfl, &seqno);
 	pop_cur();
 }
 
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 74a5af16..e5cf1554 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -54,6 +54,7 @@
 #define xfs_attr_remove			libxfs_attr_remove
 #define xfs_attr_leaf_newentsize	libxfs_attr_leaf_newentsize
 
+#define xfs_agfl_walk			libxfs_agfl_walk
 #define xfs_alloc_fix_freelist		libxfs_alloc_fix_freelist
 #define xfs_alloc_min_freelist		libxfs_alloc_min_freelist
 #define xfs_alloc_read_agf		libxfs_alloc_read_agf
diff --git a/repair/scan.c b/repair/scan.c
index 7b671123..63d20071 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -2095,17 +2095,36 @@ _("inode btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
 	}
 }
 
+struct agfl_state {
+	unsigned int	count;
+	xfs_agnumber_t	agno;
+};
+
+static int
+scan_agfl(
+	struct xfs_mount	*mp,
+	xfs_agblock_t		bno,
+	void			*priv)
+{
+	struct agfl_state	*as = priv;
+
+	if (verify_agbno(mp, as->agno, bno))
+		set_bmap(as->agno, bno, XR_E_FREE);
+	else
+		do_warn(_("bad agbno %u in agfl, agno %d\n"),
+			bno, as->agno);
+	as->count++;
+	return 0;
+}
+
 static void
 scan_freelist(
-	xfs_agf_t	*agf,
-	struct aghdr_cnts *agcnts)
+	xfs_agf_t		*agf,
+	struct aghdr_cnts	*agcnts)
 {
-	xfs_buf_t	*agflbuf;
-	xfs_agnumber_t	agno;
-	xfs_agblock_t	bno;
-	int		count;
-	int		i;
-	__be32		*freelist;
+	xfs_buf_t		*agflbuf;
+	xfs_agnumber_t		agno;
+	struct agfl_state	state;
 
 	agno = be32_to_cpu(agf->agf_seqno);
 
@@ -2127,39 +2146,26 @@ scan_freelist(
 	if (agflbuf->b_error == -EFSBADCRC)
 		do_warn(_("agfl has bad CRC for ag %d\n"), agno);
 
-	freelist = XFS_BUF_TO_AGFL_BNO(mp, agflbuf);
-	i = be32_to_cpu(agf->agf_flfirst);
-
 	if (no_modify) {
 		/* agf values not fixed in verify_set_agf, so recheck */
 		if (be32_to_cpu(agf->agf_flfirst) >= libxfs_agfl_size(mp) ||
 		    be32_to_cpu(agf->agf_fllast) >= libxfs_agfl_size(mp)) {
 			do_warn(_("agf %d freelist blocks bad, skipping "
-				  "freelist scan\n"), i);
+				  "freelist scan\n"), agno);
 			return;
 		}
 	}
 
-	count = 0;
-	for (;;) {
-		bno = be32_to_cpu(freelist[i]);
-		if (verify_agbno(mp, agno, bno))
-			set_bmap(agno, bno, XR_E_FREE);
-		else
-			do_warn(_("bad agbno %u in agfl, agno %d\n"),
-				bno, agno);
-		count++;
-		if (i == be32_to_cpu(agf->agf_fllast))
-			break;
-		if (++i == libxfs_agfl_size(mp))
-			i = 0;
-	}
-	if (count != be32_to_cpu(agf->agf_flcount)) {
-		do_warn(_("freeblk count %d != flcount %d in ag %d\n"), count,
-			be32_to_cpu(agf->agf_flcount), agno);
+	state.count = 0;
+	state.agno = agno;
+	libxfs_agfl_walk(mp, agf, agflbuf, scan_agfl, &state);
+	if (state.count != be32_to_cpu(agf->agf_flcount)) {
+		do_warn(_("freeblk count %d != flcount %d in ag %d\n"),
+				state.count, be32_to_cpu(agf->agf_flcount),
+				agno);
 	}
 
-	agcnts->fdblocks += count;
+	agcnts->fdblocks += state.count;
 
 	libxfs_putbuf(agflbuf);
 }

