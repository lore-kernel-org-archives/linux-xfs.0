Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B43CDC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:01:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236274AbiLaDBa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:01:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbiLaDB3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:01:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85ECD15816
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 19:01:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4233AB81E84
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 03:01:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04D90C433D2;
        Sat, 31 Dec 2022 03:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672455686;
        bh=xdumLeCMdzrkSLUwXOLY3P85Qs35mIlr37WG+DvKz88=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=GVG+DtZqJ5p+bL3cxbmWvottMINwH1oxGB687Lg7vXbumyxHYzlkxM85VQw9uJod7
         dYjQSUI1BibHJJg8MEjKMu4nIzgKmR54nLQx6rmfhfYr/nO2v1vPLVriSsFFzKmmDn
         5f1gtR4jKK+YmwL1qwxAreLdibOwCP5IiBot5e3Wsf1iIfkUFlwDbhTf6hL2x7oo8U
         ahuz4LKlw9VN+iKrCyBbNmBIkHpyeHRpnOFWJGwqGdOdr9g5/rHymR5UCwwiNnuwCu
         gOa+6LiD3NOpXWE2ORY9DnIl5JjBtmPM1ZKu7P1CqaD4r03pdIi2YelyTcYKv9xnTb
         AqHpIPm+Q7S+Q==
Subject: [PATCH 28/41] xfs_db: copy the realtime refcount btree
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:20:11 -0800
Message-ID: <167243881140.734096.9246369470014803879.stgit@magnolia>
In-Reply-To: <167243880752.734096.171910706541747310.stgit@magnolia>
References: <167243880752.734096.171910706541747310.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Copy the realtime refcountbt when we're metadumping the filesystem.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/metadump.c |  125 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 125 insertions(+)


diff --git a/db/metadump.c b/db/metadump.c
index e8663e11a3f..b4549117117 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -717,6 +717,54 @@ copy_refcount_btree(
 	return scan_btree(agno, root, levels, TYP_REFCBT, agf, scanfunc_refcntbt);
 }
 
+static int
+scanfunc_rtrefcbt(
+	struct xfs_btree_block	*block,
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		agbno,
+	int			level,
+	typnm_t			btype,
+	void			*arg)
+{
+	xfs_rtrefcount_ptr_t	*pp;
+	int			i;
+	int			numrecs;
+
+	if (level == 0)
+		return 1;
+
+	numrecs = be16_to_cpu(block->bb_numrecs);
+	if (numrecs > mp->m_rtrefc_mxr[1]) {
+		if (show_warnings)
+			print_warning("invalid numrecs (%u) in %s block %u/%u",
+				numrecs, typtab[btype].name, agno, agbno);
+		return 1;
+	}
+
+	pp = xfs_rtrefcount_ptr_addr(block, 1, mp->m_rtrefc_mxr[1]);
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
+				scanfunc_rtrefcbt))
+			return 0;
+	}
+	return 1;
+}
+
 /* filename and extended attribute obfuscation routines */
 
 struct name_ent {
@@ -2458,6 +2506,80 @@ process_rtrmap(
 	return 1;
 }
 
+static int
+process_rtrefc(
+	struct xfs_dinode	*dip,
+	typnm_t			itype)
+{
+	struct xfs_rtrefcount_root	*dib;
+	int			i;
+	xfs_rtrefcount_ptr_t	*pp;
+	int			level;
+	int			nrecs;
+	int			maxrecs;
+	int			whichfork;
+	typnm_t			btype;
+
+	if (itype == TYP_ATTR && show_warnings) {
+		print_warning("ignoring rtrefcbt root in inode %llu attr fork",
+				(long long)cur_ino);
+		return 1;
+	}
+
+	whichfork = XFS_DATA_FORK;
+	btype = TYP_RTREFCBT;
+
+	dib = (struct xfs_rtrefcount_root *)XFS_DFORK_PTR(dip, whichfork);
+	level = be16_to_cpu(dib->bb_level);
+	nrecs = be16_to_cpu(dib->bb_numrecs);
+
+	if (level > mp->m_rtrefc_maxlevels) {
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
+	maxrecs = libxfs_rtrefcountbt_droot_maxrecs(
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
+	pp = xfs_rtrefcount_droot_ptr_addr(dib, 1, maxrecs);
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
+				scanfunc_rtrefcbt))
+			return 0;
+	}
+	return 1;
+}
+
 static int
 process_inode_data(
 	struct xfs_dinode	*dip,
@@ -2505,6 +2627,9 @@ process_inode_data(
 
 		case XFS_DINODE_FMT_RMAP:
 			return process_rtrmap(dip, itype);
+
+		case XFS_DINODE_FMT_REFCOUNT:
+			return process_rtrefc(dip, itype);
 	}
 	return 1;
 }

