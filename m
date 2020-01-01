Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99095C2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:21:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E514206EE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:21:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IGJtU3EE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727134AbgAABVo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:21:44 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:58434 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727132AbgAABVn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:21:43 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011FRMw092835;
        Wed, 1 Jan 2020 01:21:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=LBDGGvPLgWnqH0N0uccKi+QcZvR1/Vi91i19VdVLu0I=;
 b=IGJtU3EExxcQnUvGWj7dTC6cjNXtIQ8LA2Ipt428/kT1QOhhoDjrPxFBl3nkuoaGK31Y
 RV4TdTKH5y5k25h4Nq5XU1/aozwYuVq/AFKfs57r0O9YsoYzy6OS7q6/42IspJpnOKS0
 aSAFordtzL93QEVcg2wAX1uzXeAjlcSINmdnA9c020ksoKMHTvw4a+PRZmJs7QaszWgp
 t8JCpTG8MN5xHvHEI2qLqnMyMap1IJoKgl1Ctzf25NPGfnAhP6yK2zjUpOE4/aTzFFAE
 +JsJatROOXjDpXErzHmjVmXK3avCAcpTjSWbC7hyNNY6dEFrCLb7P3jAgxjj8v4WS6X8 Og== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2x5y0pjy7b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Jan 2020 01:21:40 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011J6Qv184883;
        Wed, 1 Jan 2020 01:21:39 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2x8gj91dm0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Jan 2020 01:21:39 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0011Lc2r016603;
        Wed, 1 Jan 2020 01:21:38 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:21:38 -0800
Subject: [PATCH 2/9] xfs_repair: unindent phase 5 function
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:21:35 -0800
Message-ID: <157784169578.1371226.3643697529335091364.stgit@magnolia>
In-Reply-To: <157784168333.1371226.17162288990534822154.stgit@magnolia>
References: <157784168333.1371226.17162288990534822154.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010010
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010010
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Remove the unnecessary indent in phase5_func.  No functional changes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/phase5.c |  309 +++++++++++++++++++++++++++----------------------------
 1 file changed, 154 insertions(+), 155 deletions(-)


diff --git a/repair/phase5.c b/repair/phase5.c
index 7f7d3d18..4108e22b 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -2237,201 +2237,200 @@ phase5_func(
 	if (verbose)
 		do_log(_("        - agno = %d\n"), agno);
 
-	{
-		/*
-		 * build up incore bno and bcnt extent btrees
-		 */
-		num_extents = mk_incore_fstree(mp, agno);
+	/*
+	 * build up incore bno and bcnt extent btrees
+	 */
+	num_extents = mk_incore_fstree(mp, agno);
 
 #ifdef XR_BLD_FREE_TRACE
-		fprintf(stderr, "# of bno extents is %d\n",
-				count_bno_extents(agno));
+	fprintf(stderr, "# of bno extents is %d\n",
+			count_bno_extents(agno));
 #endif
 
-		if (num_extents == 0)  {
-			/*
-			 * XXX - what we probably should do here is pick an
-			 * inode for a regular file in the allocation group
-			 * that has space allocated and shoot it by traversing
-			 * the bmap list and putting all its extents on the
-			 * incore freespace trees, clearing the inode,
-			 * and clearing the in-use bit in the incore inode
-			 * tree.  Then try mk_incore_fstree() again.
-			 */
-			do_error(_("unable to rebuild AG %u.  "
-				  "Not enough free space in on-disk AG.\n"),
-				agno);
-		}
-
+	if (num_extents == 0)  {
 		/*
-		 * ok, now set up the btree cursors for the
-		 * on-disk btrees (includs pre-allocating all
-		 * required blocks for the trees themselves)
+		 * XXX - what we probably should do here is pick an
+		 * inode for a regular file in the allocation group
+		 * that has space allocated and shoot it by traversing
+		 * the bmap list and putting all its extents on the
+		 * incore freespace trees, clearing the inode,
+		 * and clearing the in-use bit in the incore inode
+		 * tree.  Then try mk_incore_fstree() again.
 		 */
-		init_ino_cursor(mp, agno, &ino_btree_curs, &num_inos,
-				&num_free_inos, 0);
+		do_error(_("unable to rebuild AG %u.  "
+			  "Not enough free space in on-disk AG.\n"),
+			agno);
+	}
 
-		if (xfs_sb_version_hasfinobt(&mp->m_sb))
-			init_ino_cursor(mp, agno, &fino_btree_curs,
-					&finobt_num_inos, &finobt_num_free_inos,
-					1);
+	/*
+	 * ok, now set up the btree cursors for the
+	 * on-disk btrees (includs pre-allocating all
+	 * required blocks for the trees themselves)
+	 */
+	init_ino_cursor(mp, agno, &ino_btree_curs, &num_inos,
+			&num_free_inos, 0);
 
-		sb_icount_ag[agno] += num_inos;
-		sb_ifree_ag[agno] += num_free_inos;
+	if (xfs_sb_version_hasfinobt(&mp->m_sb))
+		init_ino_cursor(mp, agno, &fino_btree_curs,
+				&finobt_num_inos, &finobt_num_free_inos,
+				1);
 
-		/*
-		 * Set up the btree cursors for the on-disk rmap btrees,
-		 * which includes pre-allocating all required blocks.
-		 */
-		init_rmapbt_cursor(mp, agno, &rmap_btree_curs);
+	sb_icount_ag[agno] += num_inos;
+	sb_ifree_ag[agno] += num_free_inos;
 
-		/*
-		 * Set up the btree cursors for the on-disk refcount btrees,
-		 * which includes pre-allocating all required blocks.
-		 */
-		init_refc_cursor(mp, agno, &refcnt_btree_curs);
+	/*
+	 * Set up the btree cursors for the on-disk rmap btrees,
+	 * which includes pre-allocating all required blocks.
+	 */
+	init_rmapbt_cursor(mp, agno, &rmap_btree_curs);
 
-		num_extents = count_bno_extents_blocks(agno, &num_freeblocks);
+	/*
+	 * Set up the btree cursors for the on-disk refcount btrees,
+	 * which includes pre-allocating all required blocks.
+	 */
+	init_refc_cursor(mp, agno, &refcnt_btree_curs);
+
+	num_extents = count_bno_extents_blocks(agno, &num_freeblocks);
+	/*
+	 * lose two blocks per AG -- the space tree roots
+	 * are counted as allocated since the space trees
+	 * always have roots
+	 */
+	sb_fdblocks_ag[agno] += num_freeblocks - 2;
+
+	if (num_extents == 0)  {
 		/*
-		 * lose two blocks per AG -- the space tree roots
-		 * are counted as allocated since the space trees
-		 * always have roots
+		 * XXX - what we probably should do here is pick an
+		 * inode for a regular file in the allocation group
+		 * that has space allocated and shoot it by traversing
+		 * the bmap list and putting all its extents on the
+		 * incore freespace trees, clearing the inode,
+		 * and clearing the in-use bit in the incore inode
+		 * tree.  Then try mk_incore_fstree() again.
 		 */
-		sb_fdblocks_ag[agno] += num_freeblocks - 2;
-
-		if (num_extents == 0)  {
-			/*
-			 * XXX - what we probably should do here is pick an
-			 * inode for a regular file in the allocation group
-			 * that has space allocated and shoot it by traversing
-			 * the bmap list and putting all its extents on the
-			 * incore freespace trees, clearing the inode,
-			 * and clearing the in-use bit in the incore inode
-			 * tree.  Then try mk_incore_fstree() again.
-			 */
-			do_error(
-			_("unable to rebuild AG %u.  No free space.\n"), agno);
-		}
+		do_error(
+		_("unable to rebuild AG %u.  No free space.\n"), agno);
+	}
 
 #ifdef XR_BLD_FREE_TRACE
-		fprintf(stderr, "# of bno extents is %d\n", num_extents);
+	fprintf(stderr, "# of bno extents is %d\n", num_extents);
 #endif
 
-		/*
-		 * track blocks that we might really lose
-		 */
-		extra_blocks = calculate_freespace_cursor(mp, agno,
-					&num_extents, &bno_btree_curs);
+	/*
+	 * track blocks that we might really lose
+	 */
+	extra_blocks = calculate_freespace_cursor(mp, agno,
+				&num_extents, &bno_btree_curs);
 
-		/*
-		 * freespace btrees live in the "free space" but
-		 * the filesystem treats AGFL blocks as allocated
-		 * since they aren't described by the freespace trees
-		 */
+	/*
+	 * freespace btrees live in the "free space" but
+	 * the filesystem treats AGFL blocks as allocated
+	 * since they aren't described by the freespace trees
+	 */
 
-		/*
-		 * see if we can fit all the extra blocks into the AGFL
-		 */
-		extra_blocks = (extra_blocks - libxfs_agfl_size(mp) > 0)
-				? extra_blocks - libxfs_agfl_size(mp)
-				: 0;
+	/*
+	 * see if we can fit all the extra blocks into the AGFL
+	 */
+	extra_blocks = (extra_blocks - libxfs_agfl_size(mp) > 0)
+			? extra_blocks - libxfs_agfl_size(mp)
+			: 0;
 
-		if (extra_blocks > 0)
-			sb_fdblocks_ag[agno] -= extra_blocks;
+	if (extra_blocks > 0)
+		sb_fdblocks_ag[agno] -= extra_blocks;
 
-		bcnt_btree_curs = bno_btree_curs;
+	bcnt_btree_curs = bno_btree_curs;
 
-		bno_btree_curs.owner = XFS_RMAP_OWN_AG;
-		bcnt_btree_curs.owner = XFS_RMAP_OWN_AG;
-		setup_cursor(mp, agno, &bno_btree_curs);
-		setup_cursor(mp, agno, &bcnt_btree_curs);
+	bno_btree_curs.owner = XFS_RMAP_OWN_AG;
+	bcnt_btree_curs.owner = XFS_RMAP_OWN_AG;
+	setup_cursor(mp, agno, &bno_btree_curs);
+	setup_cursor(mp, agno, &bcnt_btree_curs);
 
 #ifdef XR_BLD_FREE_TRACE
-		fprintf(stderr, "# of bno extents is %d\n",
-				count_bno_extents(agno));
-		fprintf(stderr, "# of bcnt extents is %d\n",
-				count_bcnt_extents(agno));
+	fprintf(stderr, "# of bno extents is %d\n",
+			count_bno_extents(agno));
+	fprintf(stderr, "# of bcnt extents is %d\n",
+			count_bcnt_extents(agno));
 #endif
 
-		/*
-		 * now rebuild the freespace trees
-		 */
-		freeblks1 = build_freespace_tree(mp, agno,
-					&bno_btree_curs, XFS_BTNUM_BNO);
+	/*
+	 * now rebuild the freespace trees
+	 */
+	freeblks1 = build_freespace_tree(mp, agno,
+				&bno_btree_curs, XFS_BTNUM_BNO);
 #ifdef XR_BLD_FREE_TRACE
-		fprintf(stderr, "# of free blocks == %d\n", freeblks1);
+	fprintf(stderr, "# of free blocks == %d\n", freeblks1);
 #endif
-		write_cursor(&bno_btree_curs);
+	write_cursor(&bno_btree_curs);
 
 #ifdef DEBUG
-		freeblks2 = build_freespace_tree(mp, agno,
-					&bcnt_btree_curs, XFS_BTNUM_CNT);
+	freeblks2 = build_freespace_tree(mp, agno,
+				&bcnt_btree_curs, XFS_BTNUM_CNT);
 #else
-		(void) build_freespace_tree(mp, agno,
-					&bcnt_btree_curs, XFS_BTNUM_CNT);
+	(void) build_freespace_tree(mp, agno,
+				&bcnt_btree_curs, XFS_BTNUM_CNT);
 #endif
-		write_cursor(&bcnt_btree_curs);
+	write_cursor(&bcnt_btree_curs);
 
-		ASSERT(freeblks1 == freeblks2);
+	ASSERT(freeblks1 == freeblks2);
 
-		if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
-			build_rmap_tree(mp, agno, &rmap_btree_curs);
-			write_cursor(&rmap_btree_curs);
-			sb_fdblocks_ag[agno] += (rmap_btree_curs.num_tot_blocks -
-					rmap_btree_curs.num_free_blocks) - 1;
-		}
+	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
+		build_rmap_tree(mp, agno, &rmap_btree_curs);
+		write_cursor(&rmap_btree_curs);
+		sb_fdblocks_ag[agno] += (rmap_btree_curs.num_tot_blocks -
+				rmap_btree_curs.num_free_blocks) - 1;
+	}
 
-		if (xfs_sb_version_hasreflink(&mp->m_sb)) {
-			build_refcount_tree(mp, agno, &refcnt_btree_curs);
-			write_cursor(&refcnt_btree_curs);
-		}
+	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
+		build_refcount_tree(mp, agno, &refcnt_btree_curs);
+		write_cursor(&refcnt_btree_curs);
+	}
 
-		/*
-		 * set up agf and agfl
-		 */
-		build_agf_agfl(mp, agno, &bno_btree_curs,
-				&bcnt_btree_curs, freeblks1, extra_blocks,
-				&rmap_btree_curs, &refcnt_btree_curs, lost_fsb);
-		/*
-		 * build inode allocation tree.
-		 */
-		build_ino_tree(mp, agno, &ino_btree_curs, XFS_BTNUM_INO,
-				&agi_stat);
-		write_cursor(&ino_btree_curs);
+	/*
+	 * set up agf and agfl
+	 */
+	build_agf_agfl(mp, agno, &bno_btree_curs,
+			&bcnt_btree_curs, freeblks1, extra_blocks,
+			&rmap_btree_curs, &refcnt_btree_curs, lost_fsb);
+	/*
+	 * build inode allocation tree.
+	 */
+	build_ino_tree(mp, agno, &ino_btree_curs, XFS_BTNUM_INO,
+			&agi_stat);
+	write_cursor(&ino_btree_curs);
 
-		/*
-		 * build free inode tree
-		 */
-		if (xfs_sb_version_hasfinobt(&mp->m_sb)) {
-			build_ino_tree(mp, agno, &fino_btree_curs,
-					XFS_BTNUM_FINO, NULL);
-			write_cursor(&fino_btree_curs);
-		}
+	/*
+	 * build free inode tree
+	 */
+	if (xfs_sb_version_hasfinobt(&mp->m_sb)) {
+		build_ino_tree(mp, agno, &fino_btree_curs,
+				XFS_BTNUM_FINO, NULL);
+		write_cursor(&fino_btree_curs);
+	}
 
-		/* build the agi */
-		build_agi(mp, agno, &ino_btree_curs, &fino_btree_curs,
-			  &agi_stat);
+	/* build the agi */
+	build_agi(mp, agno, &ino_btree_curs, &fino_btree_curs,
+		  &agi_stat);
 
-		/*
-		 * tear down cursors
-		 */
-		finish_cursor(&bno_btree_curs);
-		finish_cursor(&ino_btree_curs);
-		if (xfs_sb_version_hasrmapbt(&mp->m_sb))
-			finish_cursor(&rmap_btree_curs);
-		if (xfs_sb_version_hasreflink(&mp->m_sb))
-			finish_cursor(&refcnt_btree_curs);
-		if (xfs_sb_version_hasfinobt(&mp->m_sb))
-			finish_cursor(&fino_btree_curs);
-		finish_cursor(&bcnt_btree_curs);
+	/*
+	 * tear down cursors
+	 */
+	finish_cursor(&bno_btree_curs);
+	finish_cursor(&ino_btree_curs);
+	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
+		finish_cursor(&rmap_btree_curs);
+	if (xfs_sb_version_hasreflink(&mp->m_sb))
+		finish_cursor(&refcnt_btree_curs);
+	if (xfs_sb_version_hasfinobt(&mp->m_sb))
+		finish_cursor(&fino_btree_curs);
+	finish_cursor(&bcnt_btree_curs);
+
+	/*
+	 * release the incore per-AG bno/bcnt trees so
+	 * the extent nodes can be recycled
+	 */
+	release_agbno_extent_tree(agno);
+	release_agbcnt_extent_tree(agno);
 
-		/*
-		 * release the incore per-AG bno/bcnt trees so
-		 * the extent nodes can be recycled
-		 */
-		release_agbno_extent_tree(agno);
-		release_agbcnt_extent_tree(agno);
-	}
 	PROG_RPT_INC(prog_rpt_done[agno], 1);
 }
 

