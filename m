Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6726C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:48:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236241AbiLaCsb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:48:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236240AbiLaCsb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:48:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27697DF76
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:48:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0E79B81E6E
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:48:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A597DC433D2;
        Sat, 31 Dec 2022 02:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672454907;
        bh=asUAk8XKZnILEMWyIKJziw4/RaBhgk9mMyknFp5jMnI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=LcnXF3m2FIvjzt5Y+8UTHZMf+LH+Mdam6g6jeEfRuCdCwfhje7BHLDRMVyT9PZLBx
         RjPqyodlHprE077IFJqLyU188+FBAGQZ5guk3BGHqppUvxzenVHFazyF7Udx62e/wX
         Z3Ox+OPZW6e18spOSPOWK00X1wpuzlLmb2xkIECmyuBxLhJ4DAt6WU97vReKUdZ2gi
         /hQRGN25wtN9uNHXIOPVb0TRM17A7n+T3hLKhr3bxrMfYcrrmAVY7yo2jfGmHYaQvD
         p5BeT329AVR9tq8g9GjbXZDpDoOSFtHuRMiXKMZnijPtaQHWj/3iUO99QkAZ3kS/FY
         MfD++h24ZxN1A==
Subject: [PATCH 23/41] xfs_db: copy the realtime rmap btree
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:59 -0800
Message-ID: <167243879899.732820.12331275928002360334.stgit@magnolia>
In-Reply-To: <167243879574.732820.4725863402652761218.stgit@magnolia>
References: <167243879574.732820.4725863402652761218.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Copy the realtime rmapbt when we're metadumping the filesystem.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/metadump.c |  125 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 125 insertions(+)


diff --git a/db/metadump.c b/db/metadump.c
index 15e3b302d61..e8663e11a3f 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -597,6 +597,54 @@ copy_rmap_btree(
 	return scan_btree(agno, root, levels, TYP_RMAPBT, agf, scanfunc_rmapbt);
 }
 
+static int
+scanfunc_rtrmapbt(
+	struct xfs_btree_block	*block,
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		agbno,
+	int			level,
+	typnm_t			btype,
+	void			*arg)
+{
+	xfs_rtrmap_ptr_t	*pp;
+	int			i;
+	int			numrecs;
+
+	if (level == 0)
+		return 1;
+
+	numrecs = be16_to_cpu(block->bb_numrecs);
+	if (numrecs > mp->m_rtrmap_mxr[1]) {
+		if (show_warnings)
+			print_warning("invalid numrecs (%u) in %s block %u/%u",
+				numrecs, typtab[btype].name, agno, agbno);
+		return 1;
+	}
+
+	pp = xfs_rtrmap_ptr_addr(block, 1, mp->m_rtrmap_mxr[1]);
+	for (i = 0; i < numrecs; i++) {
+		xfs_agnumber_t	pagno;
+		xfs_agblock_t	pbno;
+
+		pagno = XFS_FSB_TO_AGNO(mp, get_unaligned_be64(&pp[i]));
+		pbno = XFS_FSB_TO_AGBNO(mp, get_unaligned_be64(&pp[i]));
+
+		if (pbno == 0 || pbno > mp->m_sb.sb_agblocks ||
+		    pagno > mp->m_sb.sb_agcount) {
+			if (show_warnings)
+				print_warning("invalid block number (%u/%u) "
+						"in inode %llu %s block %u/%u",
+						pagno, pbno, (long long)cur_ino,
+						typtab[btype].name, agno, agbno);
+			continue;
+		}
+		if (!scan_btree(pagno, pbno, level, btype, arg,
+				scanfunc_rtrmapbt))
+			return 0;
+	}
+	return 1;
+}
+
 static int
 scanfunc_refcntbt(
 	struct xfs_btree_block	*block,
@@ -2336,6 +2384,80 @@ process_exinode(
 					whichfork), nex, itype, is_meta);
 }
 
+static int
+process_rtrmap(
+	struct xfs_dinode	*dip,
+	typnm_t			itype)
+{
+	struct xfs_rtrmap_root	*dib;
+	int			i;
+	xfs_rtrmap_ptr_t	*pp;
+	int			level;
+	int			nrecs;
+	int			maxrecs;
+	int			whichfork;
+	typnm_t			btype;
+
+	if (itype == TYP_ATTR && show_warnings) {
+		print_warning("ignoring rtrmapbt root in inode %llu attr fork",
+				(long long)cur_ino);
+		return 1;
+	}
+
+	whichfork = XFS_DATA_FORK;
+	btype = TYP_RTRMAPBT;
+
+	dib = (struct xfs_rtrmap_root *)XFS_DFORK_PTR(dip, whichfork);
+	level = be16_to_cpu(dib->bb_level);
+	nrecs = be16_to_cpu(dib->bb_numrecs);
+
+	if (level > mp->m_rtrmap_maxlevels) {
+		if (show_warnings)
+			print_warning("invalid level (%u) in inode %lld %s "
+					"root", level, (long long)cur_ino,
+					typtab[btype].name);
+		return 1;
+	}
+
+	if (level == 0)
+		return 1;
+
+	maxrecs = libxfs_rtrmapbt_droot_maxrecs(
+			XFS_DFORK_SIZE(dip, mp, whichfork),
+			false);
+	if (nrecs > maxrecs) {
+		if (show_warnings)
+			print_warning("invalid numrecs (%u) in inode %lld %s "
+					"root", nrecs, (long long)cur_ino,
+					typtab[btype].name);
+		return 1;
+	}
+
+	pp = xfs_rtrmap_droot_ptr_addr(dib, 1, maxrecs);
+	for (i = 0; i < nrecs; i++) {
+		xfs_agnumber_t	ag;
+		xfs_agblock_t	bno;
+
+		ag = XFS_FSB_TO_AGNO(mp, get_unaligned_be64(&pp[i]));
+		bno = XFS_FSB_TO_AGBNO(mp, get_unaligned_be64(&pp[i]));
+
+		if (bno == 0 || bno > mp->m_sb.sb_agblocks ||
+				ag > mp->m_sb.sb_agcount) {
+			if (show_warnings)
+				print_warning("invalid block number (%u/%u) "
+						"in inode %llu %s root", ag,
+						bno, (long long)cur_ino,
+						typtab[btype].name);
+			continue;
+		}
+
+		if (!scan_btree(ag, bno, level, btype, &itype,
+				scanfunc_rtrmapbt))
+			return 0;
+	}
+	return 1;
+}
+
 static int
 process_inode_data(
 	struct xfs_dinode	*dip,
@@ -2380,6 +2502,9 @@ process_inode_data(
 
 		case XFS_DINODE_FMT_BTREE:
 			return process_btinode(dip, itype);
+
+		case XFS_DINODE_FMT_RMAP:
+			return process_rtrmap(dip, itype);
 	}
 	return 1;
 }

