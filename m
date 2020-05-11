Return-Path: <SRS0=Jrso=6Z=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5303C47255
	for <linux-xfs@archiver.kernel.org>; Mon, 11 May 2020 19:21:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94EEE20720
	for <linux-xfs@archiver.kernel.org>; Mon, 11 May 2020 19:21:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SfRhtwFn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731337AbgEKTVD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 May 2020 15:21:03 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:30416 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728613AbgEKTVC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 May 2020 15:21:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589224860;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=lpfFaJmoA/4imnXVZm1P8gnn5QPbJnAyXlLBmTYKii4=;
        b=SfRhtwFn8gnHWsmoPC9AdAOsNqA2ZiiwI6VyvlvFW71d+hGLWqZzKEO4DrQa9XUyIuY7/1
        aigrN8DgNBwQ6Ei8jztnsQGrl1gvDI6PuJZkbc3DesMiJpr+lf8CcK49eAB3wDqFputQYn
        zuLY8GZv1/bO3Zmm+tM9zFEpe0MZNwc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-359-JRftfLFNMAq4lg0hOMAXhQ-1; Mon, 11 May 2020 15:20:58 -0400
X-MC-Unique: JRftfLFNMAq4lg0hOMAXhQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7875C461
        for <linux-xfs@vger.kernel.org>; Mon, 11 May 2020 19:20:57 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3BD739CB9
        for <linux-xfs@vger.kernel.org>; Mon, 11 May 2020 19:20:57 +0000 (UTC)
To:     linux-xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs_repair: remove gratuitous code block in phase5
Message-ID: <1dc0bb1a-ce6f-5e22-77ff-b8bb408a3e03@redhat.com>
Date:   Mon, 11 May 2020 14:20:56 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

A commit back in 2008 removed a "for" loop ahead of this code block, but
left the indented code block in place. Remove it for clarity and reflow
comments & lines as needed.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

(Probably easiest to review this by applying it and then doing 
git show -w $COMMIT to see only the non-whitespace differences)

diff --git a/repair/phase5.c b/repair/phase5.c
index 677297fe..84c05a13 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -2313,201 +2313,186 @@ phase5_func(
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
+	if (num_extents == 0)  {
 		/*
-		 * ok, now set up the btree cursors for the
-		 * on-disk btrees (includs pre-allocating all
-		 * required blocks for the trees themselves)
+		 * XXX - what we probably should do here is pick an inode for
+		 * a regular file in the allocation group that has space
+		 * allocated and shoot it by traversing the bmap list and
+		 * putting all its extents on the incore freespace trees,
+		 * clearing the inode, and clearing the in-use bit in the
+		 * incore inode tree.  Then try mk_incore_fstree() again.
 		 */
-		init_ino_cursor(mp, agno, &ino_btree_curs, &num_inos,
-				&num_free_inos, 0);
+		do_error(
+_("unable to rebuild AG %u.  Not enough free space in on-disk AG.\n"),
+			agno);
+	}
 
-		if (xfs_sb_version_hasfinobt(&mp->m_sb))
-			init_ino_cursor(mp, agno, &fino_btree_curs,
-					&finobt_num_inos, &finobt_num_free_inos,
-					1);
+	/*
+	 * ok, now set up the btree cursors for the on-disk btrees (includes
+	 * pre-allocating all required blocks for the trees themselves)
+	 */
+	init_ino_cursor(mp, agno, &ino_btree_curs, &num_inos,
+			&num_free_inos, 0);
 
-		sb_icount_ag[agno] += num_inos;
-		sb_ifree_ag[agno] += num_free_inos;
+	if (xfs_sb_version_hasfinobt(&mp->m_sb))
+		init_ino_cursor(mp, agno, &fino_btree_curs, &finobt_num_inos,
+				&finobt_num_free_inos, 1);
 
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
+	 * Set up the btree cursors for the on-disk rmap btrees, which includes
+	 * pre-allocating all required blocks.
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
+		&bcnt_btree_curs, freeblks1, extra_blocks,
+		&rmap_btree_curs, &refcnt_btree_curs, lost_fsb);
+	/*
+	 * build inode allocation tree.
+	 */
+	build_ino_tree(mp, agno, &ino_btree_curs, XFS_BTNUM_INO, &agi_stat);
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
+	build_agi(mp, agno, &ino_btree_curs, &fino_btree_curs, &agi_stat);
 
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
 
-		/*
-		 * release the incore per-AG bno/bcnt trees so
-		 * the extent nodes can be recycled
-		 */
-		release_agbno_extent_tree(agno);
-		release_agbcnt_extent_tree(agno);
-	}
+	/*
+	 * release the incore per-AG bno/bcnt trees so the extent nodes
+	 * can be recycled
+	 */
+	release_agbno_extent_tree(agno);
+	release_agbcnt_extent_tree(agno);
 	PROG_RPT_INC(prog_rpt_done[agno], 1);
 }
 

