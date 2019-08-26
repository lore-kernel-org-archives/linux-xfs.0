Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81135C3A59F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 16:22:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4AC9A20874
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 16:22:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NV8y8rKL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730998AbfHZQWb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 12:22:31 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46874 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728683AbfHZQWb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 12:22:31 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QG3hQg113242;
        Mon, 26 Aug 2019 16:22:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=l2xnSIOwO4Ki8bM0ASTyliVOOzexfEwMajdnSM5cyWo=;
 b=NV8y8rKLMFLI4peeG6yfb/FwOc1ijCEYmVKiJaBm/iiIO7/VPmmgE2011RgR81r1AJdp
 1jILng37K3DfNuclXEP4ZOXsfxUQJtN1xn0+WdHIdwk7jCpwOj+ecppcQOHldFSg4PmU
 NwQoOt3+TGTU+8DfKvo/dw3u43wgkvTvCqQKVU7wxM+w59HsQtjUwxD/ZbfPK6EkB/jW
 JRW9caltaYUoX2sJHDaSEpp1Dj+kc2KsupJbyIoUppxFqidqKuNtL5HyuF657A5+Fa2j
 pvbgVNlxBzY6CbVeadQ4qI2yKd5/Qq1MtyOHLnclGum3mJBlVNVRASh2nx9S70WG+9yL Gw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2ujw702h0d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 16:22:25 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QG40fE005222;
        Mon, 26 Aug 2019 16:22:25 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2umj2xj4u9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 16:22:24 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7QGMOa3025083;
        Mon, 26 Aug 2019 16:22:24 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 09:22:23 -0700
Date:   Mon, 26 Aug 2019 09:22:22 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2] xfs: bmap scrub should only scrub records once
Message-ID: <20190826162222.GN1037350@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908260161
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908260161
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The inode block mapping scrub function does more work for btree format
extent maps than is absolutely necessary -- first it will walk the bmbt
and check all the entries, and then it will load the incore tree and
check every entry in that tree, possibly for a second time.

Simplify the code and decrease check runtime by separating the two
responsibilities.  The bmbt walk will make sure the incore extent
mappings are loaded, check the shape of the bmap btree (via xchk_btree)
and check that every bmbt record has a corresponding incore extent map;
and the incore extent map walk takes all the responsibility for checking
the mapping records and cross referencing them with other AG metadata.

This enables us to clean up some messy parameter handling and reduce
redundant code.  Rename a few functions to make the split of
responsibilities clearer.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: always load the extent cache and separate the bmbt/iext walk code
---
 fs/xfs/scrub/bmap.c |   76 ++++++++++++++++++++++++++++++---------------------
 1 file changed, 45 insertions(+), 31 deletions(-)

diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 1bd29fdc2ab5..f6ed6eb133a6 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -75,6 +75,7 @@ struct xchk_bmap_info {
 	xfs_fileoff_t		lastoff;
 	bool			is_rt;
 	bool			is_shared;
+	bool			was_loaded;
 	int			whichfork;
 };
 
@@ -213,25 +214,20 @@ xchk_bmap_xref_rmap(
 
 /* Cross-reference a single rtdev extent record. */
 STATIC void
-xchk_bmap_rt_extent_xref(
-	struct xchk_bmap_info	*info,
+xchk_bmap_rt_iextent_xref(
 	struct xfs_inode	*ip,
-	struct xfs_btree_cur	*cur,
+	struct xchk_bmap_info	*info,
 	struct xfs_bmbt_irec	*irec)
 {
-	if (info->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
-		return;
-
 	xchk_xref_is_used_rt_space(info->sc, irec->br_startblock,
 			irec->br_blockcount);
 }
 
 /* Cross-reference a single datadev extent record. */
 STATIC void
-xchk_bmap_extent_xref(
-	struct xchk_bmap_info	*info,
+xchk_bmap_iextent_xref(
 	struct xfs_inode	*ip,
-	struct xfs_btree_cur	*cur,
+	struct xchk_bmap_info	*info,
 	struct xfs_bmbt_irec	*irec)
 {
 	struct xfs_mount	*mp = info->sc->mp;
@@ -240,9 +236,6 @@ xchk_bmap_extent_xref(
 	xfs_extlen_t		len;
 	int			error;
 
-	if (info->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
-		return;
-
 	agno = XFS_FSB_TO_AGNO(mp, irec->br_startblock);
 	agbno = XFS_FSB_TO_AGBNO(mp, irec->br_startblock);
 	len = irec->br_blockcount;
@@ -300,20 +293,15 @@ xchk_bmap_dirattr_extent(
 
 /* Scrub a single extent record. */
 STATIC int
-xchk_bmap_extent(
+xchk_bmap_iextent(
 	struct xfs_inode	*ip,
-	struct xfs_btree_cur	*cur,
 	struct xchk_bmap_info	*info,
 	struct xfs_bmbt_irec	*irec)
 {
 	struct xfs_mount	*mp = info->sc->mp;
-	struct xfs_buf		*bp = NULL;
 	xfs_filblks_t		end;
 	int			error = 0;
 
-	if (cur)
-		xfs_btree_get_block(cur, 0, &bp);
-
 	/*
 	 * Check for out-of-order extents.  This record could have come
 	 * from the incore list, for which there is no ordering check.
@@ -364,10 +352,13 @@ xchk_bmap_extent(
 		xchk_fblock_set_corrupt(info->sc, info->whichfork,
 				irec->br_startoff);
 
+	if (info->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		return 0;
+
 	if (info->is_rt)
-		xchk_bmap_rt_extent_xref(info, ip, cur, irec);
+		xchk_bmap_rt_iextent_xref(ip, info, irec);
 	else
-		xchk_bmap_extent_xref(info, ip, cur, irec);
+		xchk_bmap_iextent_xref(ip, info, irec);
 
 	info->lastoff = irec->br_startoff + irec->br_blockcount;
 	return error;
@@ -380,10 +371,13 @@ xchk_bmapbt_rec(
 	union xfs_btree_rec	*rec)
 {
 	struct xfs_bmbt_irec	irec;
+	struct xfs_bmbt_irec	iext_irec;
+	struct xfs_iext_cursor	icur;
 	struct xchk_bmap_info	*info = bs->private;
 	struct xfs_inode	*ip = bs->cur->bc_private.b.ip;
 	struct xfs_buf		*bp = NULL;
 	struct xfs_btree_block	*block;
+	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, info->whichfork);
 	uint64_t		owner;
 	int			i;
 
@@ -402,9 +396,25 @@ xchk_bmapbt_rec(
 		}
 	}
 
-	/* Set up the in-core record and scrub it. */
+	/*
+	 * Check that the incore extent tree contains an extent that matches
+	 * this one exactly.  We validate those cached bmaps later, so we don't
+	 * need to check them here.  If the extent tree was freshly loaded by
+	 * the scrubber then we skip the check entirely.
+	 */
+	if (info->was_loaded)
+		return 0;
+
 	xfs_bmbt_disk_get_all(&rec->bmbt, &irec);
-	return xchk_bmap_extent(ip, bs->cur, info, &irec);
+	if (!xfs_iext_lookup_extent(ip, ifp, irec.br_startoff, &icur,
+				&iext_irec) ||
+	    irec.br_startoff != iext_irec.br_startoff ||
+	    irec.br_startblock != iext_irec.br_startblock ||
+	    irec.br_blockcount != iext_irec.br_blockcount ||
+	    irec.br_state != iext_irec.br_state)
+		xchk_fblock_set_corrupt(bs->sc, info->whichfork,
+				irec.br_startoff);
+	return 0;
 }
 
 /* Scan the btree records. */
@@ -415,15 +425,26 @@ xchk_bmap_btree(
 	struct xchk_bmap_info	*info)
 {
 	struct xfs_owner_info	oinfo;
+	struct xfs_ifork	*ifp = XFS_IFORK_PTR(sc->ip, whichfork);
 	struct xfs_mount	*mp = sc->mp;
 	struct xfs_inode	*ip = sc->ip;
 	struct xfs_btree_cur	*cur;
 	int			error;
 
+	/* Load the incore bmap cache if it's not loaded. */
+	info->was_loaded = ifp->if_flags & XFS_IFEXTENTS;
+	if (!info->was_loaded) {
+		error = xfs_iread_extents(sc->tp, ip, whichfork);
+		if (!xchk_fblock_process_error(sc, whichfork, 0, &error))
+			goto out;
+	}
+
+	/* Check the btree structure. */
 	cur = xfs_bmbt_init_cursor(mp, sc->tp, ip, whichfork);
 	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, whichfork);
 	error = xchk_btree(sc, cur, xchk_bmapbt_rec, &oinfo, info);
 	xfs_btree_del_cursor(cur, error);
+out:
 	return error;
 }
 
@@ -671,13 +692,6 @@ xchk_bmap(
 	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 		goto out;
 
-	/* Now try to scrub the in-memory extent list. */
-        if (!(ifp->if_flags & XFS_IFEXTENTS)) {
-		error = xfs_iread_extents(sc->tp, ip, whichfork);
-		if (!xchk_fblock_process_error(sc, whichfork, 0, &error))
-			goto out;
-	}
-
 	/* Find the offset of the last extent in the mapping. */
 	error = xfs_bmap_last_offset(ip, &endoff, whichfork);
 	if (!xchk_fblock_process_error(sc, whichfork, 0, &error))
@@ -689,7 +703,7 @@ xchk_bmap(
 	for_each_xfs_iext(ifp, &icur, &irec) {
 		if (xchk_should_terminate(sc, &error) ||
 		    (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
-			break;
+			goto out;
 		if (isnullstartblock(irec.br_startblock))
 			continue;
 		if (irec.br_startoff >= endoff) {
@@ -697,7 +711,7 @@ xchk_bmap(
 					irec.br_startoff);
 			goto out;
 		}
-		error = xchk_bmap_extent(ip, NULL, &info, &irec);
+		error = xchk_bmap_iextent(ip, &info, &irec);
 		if (error)
 			goto out;
 	}
