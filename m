Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F87BC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:36:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236252AbiLaCgU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:36:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236249AbiLaCgT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:36:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E129BD6
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:36:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4BFF6B81E03
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:36:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 117E8C433D2;
        Sat, 31 Dec 2022 02:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672454176;
        bh=UOh8gVVglWhlDKiPwgQg2uDuz6QF0rh4YNhHtY0VabU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=dZfv4RacwIiHF8/VilzBKwKIrOKNzuiPWLx/jqOrOP45EmF1tfzrJbcqQzgtlNVE9
         NMjHy6z9421rk6s4GqOM/wX9fON7goYguVsv76+aRi3qV3bul31SEufYh5CGlfAni+
         R6AktyUbYmHg+dD0DZdbqySwSAeHfvSvJNgbv12z7vb/zCQWOOg9KnVr6zAUFJvBX/
         1RSeh21ZwyeJD2xdhzTQiOmIOZW8BUNjXpd1KyYSk89u4QABepPQGwNHOy6GLP8ik0
         iB+YKOisEFyJT+Vo2d7dyQYiW+S2wK/UyY1vDkAVdz4lALxXGa986/JS9e5UAPU11R
         cWerNKiaavolQ==
Subject: [PATCH 24/45] xfs_repair: repair rtsummary block headers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:46 -0800
Message-ID: <167243878679.731133.13989206969699276767.stgit@magnolia>
In-Reply-To: <167243878346.731133.14642166452774753637.stgit@magnolia>
References: <167243878346.731133.14642166452774753637.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Check and repair the new block headers attached to rtsummary blocks.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/phase6.c |   19 ++++++++++++++++---
 repair/rt.c     |    6 +++++-
 2 files changed, 21 insertions(+), 4 deletions(-)


diff --git a/repair/phase6.c b/repair/phase6.c
index ad70b22a953..1dbd600915d 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -886,6 +886,8 @@ fill_rsumino(xfs_mount_t *mp)
 	}
 
 	while (bno < end_bno)  {
+		xfs_daddr_t	daddr;
+
 		/*
 		 * fill the file one block at a time
 		 */
@@ -899,9 +901,8 @@ fill_rsumino(xfs_mount_t *mp)
 
 		ASSERT(map.br_startblock != HOLESTARTBLOCK);
 
-		error = -libxfs_trans_read_buf(
-				mp, tp, mp->m_dev,
-				XFS_FSB_TO_DADDR(mp, map.br_startblock),
+		daddr = XFS_FSB_TO_DADDR(mp, map.br_startblock);
+		error = -libxfs_trans_read_buf(mp, tp, mp->m_dev, daddr,
 				XFS_FSB_TO_BB(mp, 1), 1, &bp, NULL);
 
 		if (error) {
@@ -915,6 +916,18 @@ _("can't access block %" PRIu64 " (fsbno %" PRIu64 ") of realtime summary inode
 		memcpy(xfs_rsumblock_infoptr(bp, 0), smp,
 				mp->m_blockwsize << XFS_WORDLOG);
 
+		if (xfs_has_rtgroups(mp)) {
+			struct xfs_rtbuf_blkinfo *hdr = bp->b_addr;
+
+			bp->b_ops = &xfs_rtsummary_buf_ops;
+			hdr->rt_magic = cpu_to_be32(XFS_RTSUMMARY_MAGIC);
+			hdr->rt_owner = cpu_to_be64(ip->i_ino);
+			hdr->rt_lsn = 0;
+			hdr->rt_blkno = cpu_to_be64(daddr);
+			platform_uuid_copy(&hdr->rt_uuid,
+					&mp->m_sb.sb_meta_uuid);
+		}
+
 		libxfs_trans_log_buf(tp, bp, 0, mp->m_sb.sb_blocksize - 1);
 
 		smp += mp->m_blockwsize;
diff --git a/repair/rt.c b/repair/rt.c
index e7190383da3..33641031731 100644
--- a/repair/rt.c
+++ b/repair/rt.c
@@ -261,11 +261,15 @@ void
 check_rtsummary(
 	struct xfs_mount	*mp)
 {
+	const struct xfs_buf_ops *buf_ops = NULL;
+
 	if (need_rsumino)
 		return;
+	if (xfs_has_rtgroups(mp))
+		buf_ops = &xfs_rtsummary_buf_ops;
 
 	check_rtfile_contents(mp, "rtsummary", mp->m_sb.sb_rsumino, sumcompute,
-			XFS_B_TO_FSB(mp, mp->m_rsumsize), NULL);
+			XFS_B_TO_FSB(mp, mp->m_rsumsize), buf_ops);
 }
 
 void

