Return-Path: <SRS0=pQq2=7P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC931C433DF
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 04:27:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF5D520738
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 04:27:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="wxh3XvbE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725937AbgFBE11 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Jun 2020 00:27:27 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:34504 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbgFBE11 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jun 2020 00:27:27 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0524GXMd106477;
        Tue, 2 Jun 2020 04:27:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Kn4GOgNYCh5zOHKH+aWQkq420kNcVf5RxGZ4P5An9Dw=;
 b=wxh3XvbE3/iTF9voAXE3wpYgKW0m/8mnM3VUNHbQIVa9A/lJxAZZ0yAZFnUZE+uDVzrO
 +UGN7GDs2SFCIgdZaQ5NZL85lklLA/zb6OMXt0Qr+wcmILyOkgPYssTZ7Soob0E/SfWU
 FJn7qtgYOfUoN3d5HkNphVsglNLeV/FWO+R6Jx4ZFa3iae7WzQpawDezO6qUMXukiPzE
 0K7me9jjgIk2rbLrtIZOaYz5VMuU+bmJBa+JFlO1fS4TYrVgEFRMmt2HUqTvb+1pV0Mm
 EWq4V3sn/HL69BCe3JT9DgVbo2khy5ADG7a8UeIhn8QDQTQprqxmh74/xPRf4ge1Q14y HA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 31bfem1tbd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 02 Jun 2020 04:27:21 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0524JMKw102112;
        Tue, 2 Jun 2020 04:27:21 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 31c12ng4x2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jun 2020 04:27:20 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0524RJkA021125;
        Tue, 2 Jun 2020 04:27:19 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Jun 2020 21:27:19 -0700
Subject: [PATCH 04/12] xfs_repair: remove gratuitous code block in phase5
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     Eric Sandeen <sandeen@redhat.com>,
        Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        bfoster@redhat.com
Date:   Mon, 01 Jun 2020 21:27:18 -0700
Message-ID: <159107203834.315004.13769720827269505969.stgit@magnolia>
In-Reply-To: <159107201290.315004.4447998785149331259.stgit@magnolia>
References: <159107201290.315004.4447998785149331259.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9639 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 adultscore=0 suspectscore=2 spamscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006020024
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9639 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=2
 mlxlogscore=999 priorityscore=1501 bulkscore=0 phishscore=0 clxscore=1015
 impostorscore=0 adultscore=0 spamscore=0 mlxscore=0 lowpriorityscore=0
 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006020024
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Eric Sandeen <sandeen@redhat.com>

A commit back in 2008 removed a "for" loop ahead of this code block, but
left the indented code block in place. Remove it for clarity and reflow
comments & lines as needed.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 repair/phase5.c |  316 ++++++++++++++++++++++++++-----------------------------
 1 file changed, 150 insertions(+), 166 deletions(-)


diff --git a/repair/phase5.c b/repair/phase5.c
index 169a2d89..44a6bda8 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -2314,201 +2314,185 @@ phase5_func(
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
+	fprintf(stderr, "# of bno extents is %d\n", count_bno_extents(agno));
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
-		/*
-		 * ok, now set up the btree cursors for the
-		 * on-disk btrees (includs pre-allocating all
-		 * required blocks for the trees themselves)
-		 */
-		init_ino_cursor(mp, agno, &ino_btree_curs, &num_inos,
-				&num_free_inos, 0);
-
-		if (xfs_sb_version_hasfinobt(&mp->m_sb))
-			init_ino_cursor(mp, agno, &fino_btree_curs,
-					&finobt_num_inos, &finobt_num_free_inos,
-					1);
-
-		sb_icount_ag[agno] += num_inos;
-		sb_ifree_ag[agno] += num_free_inos;
-
-		/*
-		 * Set up the btree cursors for the on-disk rmap btrees,
-		 * which includes pre-allocating all required blocks.
-		 */
-		init_rmapbt_cursor(mp, agno, &rmap_btree_curs);
-
+	if (num_extents == 0)  {
 		/*
-		 * Set up the btree cursors for the on-disk refcount btrees,
-		 * which includes pre-allocating all required blocks.
+		 * XXX - what we probably should do here is pick an inode for
+		 * a regular file in the allocation group that has space
+		 * allocated and shoot it by traversing the bmap list and
+		 * putting all its extents on the incore freespace trees,
+		 * clearing the inode, and clearing the in-use bit in the
+		 * incore inode tree.  Then try mk_incore_fstree() again.
 		 */
-		init_refc_cursor(mp, agno, &refcnt_btree_curs);
-
-		num_extents = count_bno_extents_blocks(agno, &num_freeblocks);
+		do_error(
+_("unable to rebuild AG %u.  Not enough free space in on-disk AG.\n"),
+			agno);
+	}
+
+	/*
+	 * ok, now set up the btree cursors for the on-disk btrees (includes
+	 * pre-allocating all required blocks for the trees themselves)
+	 */
+	init_ino_cursor(mp, agno, &ino_btree_curs, &num_inos,
+			&num_free_inos, 0);
+
+	if (xfs_sb_version_hasfinobt(&mp->m_sb))
+		init_ino_cursor(mp, agno, &fino_btree_curs, &finobt_num_inos,
+				&finobt_num_free_inos, 1);
+
+	sb_icount_ag[agno] += num_inos;
+	sb_ifree_ag[agno] += num_free_inos;
+
+	/*
+	 * Set up the btree cursors for the on-disk rmap btrees, which includes
+	 * pre-allocating all required blocks.
+	 */
+	init_rmapbt_cursor(mp, agno, &rmap_btree_curs);
+
+	/*
+	 * Set up the btree cursors for the on-disk refcount btrees,
+	 * which includes pre-allocating all required blocks.
+	 */
+	init_refc_cursor(mp, agno, &refcnt_btree_curs);
+
+	num_extents = count_bno_extents_blocks(agno, &num_freeblocks);
+	/*
+	 * lose two blocks per AG -- the space tree roots are counted as
+	 * allocated since the space trees always have roots
+	 */
+	sb_fdblocks_ag[agno] += num_freeblocks - 2;
+
+	if (num_extents == 0)  {
 		/*
-		 * lose two blocks per AG -- the space tree roots
-		 * are counted as allocated since the space trees
-		 * always have roots
+		 * XXX - what we probably should do here is pick an inode for
+		 * a regular file in the allocation group that has space
+		 * allocated and shoot it by traversing the bmap list and
+		 * putting all its extents on the incore freespace trees,
+		 * clearing the inode, and clearing the in-use bit in the
+		 * incore inode tree.  Then try mk_incore_fstree() again.
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
+		do_error(_("unable to rebuild AG %u.  No free space.\n"), agno);
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
+	 * freespace btrees live in the "free space" but the filesystem treats
+	 * AGFL blocks as allocated since they aren't described by the
+	 * freespace trees
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
+	extra_blocks = (extra_blocks - libxfs_agfl_size(mp) > 0) ?
+			extra_blocks - libxfs_agfl_size(mp) : 0;
 
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
+	fprintf(stderr, "# of bno extents is %d\n", count_bno_extents(agno));
+	fprintf(stderr, "# of bcnt extents is %d\n", count_bcnt_extents(agno));
 #endif
 
-		/*
-		 * now rebuild the freespace trees
-		 */
-		freeblks1 = build_freespace_tree(mp, agno,
+	/*
+	 * now rebuild the freespace trees
+	 */
+	freeblks1 = build_freespace_tree(mp, agno,
 					&bno_btree_curs, XFS_BTNUM_BNO);
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
+	(void) build_freespace_tree(mp, agno, &bcnt_btree_curs, XFS_BTNUM_CNT);
 #endif
-		write_cursor(&bcnt_btree_curs);
-
-		ASSERT(freeblks1 == freeblks2);
-
-		if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
-			build_rmap_tree(mp, agno, &rmap_btree_curs);
-			write_cursor(&rmap_btree_curs);
-			sb_fdblocks_ag[agno] += (rmap_btree_curs.num_tot_blocks -
-					rmap_btree_curs.num_free_blocks) - 1;
-		}
-
-		if (xfs_sb_version_hasreflink(&mp->m_sb)) {
-			build_refcount_tree(mp, agno, &refcnt_btree_curs);
-			write_cursor(&refcnt_btree_curs);
-		}
-
-		/*
-		 * set up agf and agfl
-		 */
-		build_agf_agfl(mp, agno, &bno_btree_curs, &bcnt_btree_curs,
-				freeblks1, &rmap_btree_curs,
-				&refcnt_btree_curs, lost_fsb);
-		/*
-		 * build inode allocation tree.
-		 */
-		build_ino_tree(mp, agno, &ino_btree_curs, XFS_BTNUM_INO,
-				&agi_stat);
-		write_cursor(&ino_btree_curs);
-
-		/*
-		 * build free inode tree
-		 */
-		if (xfs_sb_version_hasfinobt(&mp->m_sb)) {
-			build_ino_tree(mp, agno, &fino_btree_curs,
-					XFS_BTNUM_FINO, NULL);
-			write_cursor(&fino_btree_curs);
-		}
-
-		/* build the agi */
-		build_agi(mp, agno, &ino_btree_curs, &fino_btree_curs,
-			  &agi_stat);
-
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
-
-		/*
-		 * release the incore per-AG bno/bcnt trees so
-		 * the extent nodes can be recycled
-		 */
-		release_agbno_extent_tree(agno);
-		release_agbcnt_extent_tree(agno);
+	write_cursor(&bcnt_btree_curs);
+
+	ASSERT(freeblks1 == freeblks2);
+
+	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
+		build_rmap_tree(mp, agno, &rmap_btree_curs);
+		write_cursor(&rmap_btree_curs);
+		sb_fdblocks_ag[agno] += (rmap_btree_curs.num_tot_blocks -
+				rmap_btree_curs.num_free_blocks) - 1;
+	}
+
+	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
+		build_refcount_tree(mp, agno, &refcnt_btree_curs);
+		write_cursor(&refcnt_btree_curs);
 	}
+
+	/*
+	 * set up agf and agfl
+	 */
+	build_agf_agfl(mp, agno, &bno_btree_curs, &bcnt_btree_curs, freeblks1,
+			&rmap_btree_curs, &refcnt_btree_curs, lost_fsb);
+	/*
+	 * build inode allocation tree.
+	 */
+	build_ino_tree(mp, agno, &ino_btree_curs, XFS_BTNUM_INO, &agi_stat);
+	write_cursor(&ino_btree_curs);
+
+	/*
+	 * build free inode tree
+	 */
+	if (xfs_sb_version_hasfinobt(&mp->m_sb)) {
+		build_ino_tree(mp, agno, &fino_btree_curs,
+				XFS_BTNUM_FINO, NULL);
+		write_cursor(&fino_btree_curs);
+	}
+
+	/* build the agi */
+	build_agi(mp, agno, &ino_btree_curs, &fino_btree_curs, &agi_stat);
+
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
+	 * release the incore per-AG bno/bcnt trees so the extent nodes
+	 * can be recycled
+	 */
+	release_agbno_extent_tree(agno);
+	release_agbcnt_extent_tree(agno);
 	PROG_RPT_INC(prog_rpt_done[agno], 1);
 }
 

