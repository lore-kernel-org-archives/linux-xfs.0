Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58AFEC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:58:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236296AbiLaC6y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:58:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236248AbiLaC6y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:58:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D53DB1929B
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:58:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8F1ABB81E6F
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:58:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 452D7C433D2;
        Sat, 31 Dec 2022 02:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672455530;
        bh=Xsgo/8F732CaALh4MUfQwgr3YL8tWsqfay0AfPxkh24=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Mimtd//pqclsRiRZPtgfyWFaIwO9w0epho3V8n9I5XXlth5xMKvt4+ONm5ATfu2en
         iiG2yCVfwSfBQBN6mrWF9qyQnNEH2pNBxJmyraUd+nHeuCR6RDjdBlVpmgnn7VVDiO
         RVj29dvqjyB/9U37zpLSIYV3skqAL4N8RSBjzfWiW19D1FfKsTfbpadmzDJWY+gkBT
         C5xvDq55V5kCgKhrS+rBP8tWF2Yt8IUcMPfoUTWIwxuWdYqEaTr2nVMrhRqHHJYvaR
         p+SsqH2iAcv/QhiqVhrM1fJF8uTJWVvoumHf8EwKyd/gFQOgW2h3rd7/LAMAIjrYVT
         +2PYjk8FH9T8w==
Subject: [PATCH 18/41] xfs: apply rt extent alignment constraints to CoW
 extsize hint
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:20:10 -0800
Message-ID: <167243881008.734096.10908414936699863035.stgit@magnolia>
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

The copy-on-write extent size hint is subject to the same alignment
constraints as the regular extent size hint.  Since we're in the process
of adding reflink (and therefore CoW) to the realtime device, we must
apply the same scattered rextsize alignment validation strategies to
both hints to deal with the possibility of rextsize changing.

Therefore, fix the inode validator to perform rextsize alignment checks
on regular realtime files, and to remove misaligned directory hints.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_inode_buf.c   |   25 ++++++++++++++++++++-----
 libxfs/xfs_trans_inode.c |   14 ++++++++++++++
 2 files changed, 34 insertions(+), 5 deletions(-)


diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index b2e47c3adca..ba4df981bd0 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -828,11 +828,29 @@ xfs_inode_validate_cowextsize(
 	bool				rt_flag;
 	bool				hint_flag;
 	uint32_t			cowextsize_bytes;
+	uint32_t			blocksize_bytes;
 
 	rt_flag = (flags & XFS_DIFLAG_REALTIME);
 	hint_flag = (flags2 & XFS_DIFLAG2_COWEXTSIZE);
 	cowextsize_bytes = XFS_FSB_TO_B(mp, cowextsize);
 
+	/*
+	 * Similar to extent size hints, a directory can be configured to
+	 * propagate realtime status and a CoW extent size hint to newly
+	 * created files even if there is no realtime device, and the hints on
+	 * disk can become misaligned if the sysadmin changes the rt extent
+	 * size while adding the realtime device.
+	 *
+	 * Therefore, we can only enforce the rextsize alignment check against
+	 * regular realtime files, and rely on callers to decide when alignment
+	 * checks are appropriate, and fix things up as needed.
+	 */
+
+	if (rt_flag)
+		blocksize_bytes = XFS_FSB_TO_B(mp, mp->m_sb.sb_rextsize);
+	else
+		blocksize_bytes = mp->m_sb.sb_blocksize;
+
 	if (hint_flag && !xfs_has_reflink(mp))
 		return __this_address;
 
@@ -846,16 +864,13 @@ xfs_inode_validate_cowextsize(
 	if (mode && !hint_flag && cowextsize != 0)
 		return __this_address;
 
-	if (hint_flag && rt_flag)
-		return __this_address;
-
-	if (cowextsize_bytes % mp->m_sb.sb_blocksize)
+	if (cowextsize_bytes % blocksize_bytes)
 		return __this_address;
 
 	if (cowextsize > XFS_MAX_BMBT_EXTLEN)
 		return __this_address;
 
-	if (cowextsize > mp->m_sb.sb_agblocks / 2)
+	if (!rt_flag && cowextsize > mp->m_sb.sb_agblocks / 2)
 		return __this_address;
 
 	return NULL;
diff --git a/libxfs/xfs_trans_inode.c b/libxfs/xfs_trans_inode.c
index e2d5d3efaab..04d5449e3bc 100644
--- a/libxfs/xfs_trans_inode.c
+++ b/libxfs/xfs_trans_inode.c
@@ -157,6 +157,20 @@ xfs_trans_log_inode(
 		flags |= XFS_ILOG_CORE;
 	}
 
+	/*
+	 * Inode verifiers do not check that the CoW extent size hint is an
+	 * integer multiple of the rt extent size on a directory with both
+	 * rtinherit and cowextsize flags set.  If we're logging a directory
+	 * that is misconfigured in this way, clear the hint.
+	 */
+	if ((ip->i_diflags & XFS_DIFLAG_RTINHERIT) &&
+	    (ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE) &&
+	    (ip->i_cowextsize % ip->i_mount->m_sb.sb_rextsize) > 0) {
+		ip->i_diflags2 &= ~XFS_DIFLAG2_COWEXTSIZE;
+		ip->i_cowextsize = 0;
+		flags |= XFS_ILOG_CORE;
+	}
+
 	/*
 	 * Record the specific change for fdatasync optimisation. This allows
 	 * fdatasync to skip log forces for inodes that are only timestamp

