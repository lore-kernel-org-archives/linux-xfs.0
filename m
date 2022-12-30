Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3350C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:18:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236193AbiLaCSA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:18:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236195AbiLaCRh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:17:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D69D13F62
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:17:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E44461CA0
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:17:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A2F4C433D2;
        Sat, 31 Dec 2022 02:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672453056;
        bh=gf7JCAxiiirPeOz97jWFKMxBm+b9C2Q9rUWhdoAlg3Q=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=XHCBGt748qEMWFT+kBxqZWF0ZyxQXqOHz/TtlS7YBs3vEiItL+PJzHON4W2p5CSCG
         N7RK+OJl1OlbjwZQdXO7IDR1c5YnZgrfbr1i7VZPWLAIT7c2YSzYFv+6gLm+S0Suif
         OF7rpEbqKSMoJb2XQPUjW/ZYiZO+bDUfYp2dLc0J+9VP8YQvh5fWLjLQcOwzFDVeTY
         0iWrgDS5MoyK//fqfEXN2VesuS8dkQ1UOkPQnikElLmYk/x1fEyE1rXJ/aUuliRPwH
         GyTIDUjoZFY3JR92CYjf45zAV6xzs4Hg4FyO3qfnhsHJ6sqKTVtzQI+fvRoZKDZxNW
         hod9+JSgtWU2w==
Subject: [PATCH 30/46] xfs_repair: refactor marking of metadata inodes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:23 -0800
Message-ID: <167243876329.725900.13139575481332659655.stgit@magnolia>
In-Reply-To: <167243875924.725900.7061782826830118387.stgit@magnolia>
References: <167243875924.725900.7061782826830118387.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Refactor the mechanics of marking a metadata inode into a helper
function so that we don't have to open-code that for every single
metadata inode.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/phase6.c |   76 ++++++++++++++++++++-----------------------------------
 1 file changed, 28 insertions(+), 48 deletions(-)


diff --git a/repair/phase6.c b/repair/phase6.c
index 053e3ace8ee..d8df0f608f8 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -2952,6 +2952,22 @@ _("error %d fixing shortform directory %llu\n"),
 	libxfs_irele(ip);
 }
 
+static void
+mark_inode(
+	struct xfs_mount	*mp,
+	xfs_ino_t		ino)
+{
+	struct ino_tree_node	*irec;
+	int			offset;
+
+	irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp, ino),
+			XFS_INO_TO_AGINO(mp, ino));
+
+	offset = XFS_INO_TO_AGINO(mp, ino) - irec->ino_startnum;
+
+	add_inode_reached(irec, offset);
+}
+
 /*
  * mark realtime bitmap and summary inodes as reached.
  * quota inode will be marked here as well
@@ -2959,54 +2975,18 @@ _("error %d fixing shortform directory %llu\n"),
 static void
 mark_standalone_inodes(xfs_mount_t *mp)
 {
-	ino_tree_node_t		*irec;
-	int			offset;
-
-	irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rbmino),
-			XFS_INO_TO_AGINO(mp, mp->m_sb.sb_rbmino));
-
-	offset = XFS_INO_TO_AGINO(mp, mp->m_sb.sb_rbmino) -
-			irec->ino_startnum;
-
-	add_inode_reached(irec, offset);
-
-	irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rsumino),
-			XFS_INO_TO_AGINO(mp, mp->m_sb.sb_rsumino));
-
-	offset = XFS_INO_TO_AGINO(mp, mp->m_sb.sb_rsumino) -
-			irec->ino_startnum;
-
-	add_inode_reached(irec, offset);
-
-	if (fs_quotas)  {
-		if (mp->m_sb.sb_uquotino
-				&& mp->m_sb.sb_uquotino != NULLFSINO)  {
-			irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp,
-						mp->m_sb.sb_uquotino),
-				XFS_INO_TO_AGINO(mp, mp->m_sb.sb_uquotino));
-			offset = XFS_INO_TO_AGINO(mp, mp->m_sb.sb_uquotino)
-					- irec->ino_startnum;
-			add_inode_reached(irec, offset);
-		}
-		if (mp->m_sb.sb_gquotino
-				&& mp->m_sb.sb_gquotino != NULLFSINO)  {
-			irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp,
-						mp->m_sb.sb_gquotino),
-				XFS_INO_TO_AGINO(mp, mp->m_sb.sb_gquotino));
-			offset = XFS_INO_TO_AGINO(mp, mp->m_sb.sb_gquotino)
-					- irec->ino_startnum;
-			add_inode_reached(irec, offset);
-		}
-		if (mp->m_sb.sb_pquotino
-				&& mp->m_sb.sb_pquotino != NULLFSINO)  {
-			irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp,
-						mp->m_sb.sb_pquotino),
-				XFS_INO_TO_AGINO(mp, mp->m_sb.sb_pquotino));
-			offset = XFS_INO_TO_AGINO(mp, mp->m_sb.sb_pquotino)
-					- irec->ino_startnum;
-			add_inode_reached(irec, offset);
-		}
-	}
+	mark_inode(mp, mp->m_sb.sb_rbmino);
+	mark_inode(mp, mp->m_sb.sb_rsumino);
+
+	if (!fs_quotas)
+		return;
+
+	if (mp->m_sb.sb_uquotino && mp->m_sb.sb_uquotino != NULLFSINO)
+		mark_inode(mp, mp->m_sb.sb_uquotino);
+	if (mp->m_sb.sb_gquotino && mp->m_sb.sb_gquotino != NULLFSINO)
+		mark_inode(mp, mp->m_sb.sb_gquotino);
+	if (mp->m_sb.sb_pquotino && mp->m_sb.sb_pquotino != NULLFSINO)
+		mark_inode(mp, mp->m_sb.sb_pquotino);
 }
 
 static void

