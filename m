Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55ED4C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:17:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236191AbiLaCRI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:17:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236193AbiLaCRG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:17:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1D2A13F7E
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:17:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9096C61C9C
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:17:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE746C433D2;
        Sat, 31 Dec 2022 02:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672453025;
        bh=0yeG2LER7iJLcny/pv5d/ofjBvsb8jXPCiheqjmqYvg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Mc9VGbsgy5zova861CydR1ZY6ywBEkzS57mvgoL25ErjCjFzqT6m6vJ7wut9OpvUa
         0r7SyrzZqCdrjqIfdvZSdZtoWbQaJRepkzHKduClz+Y8pUFfKqfe9T/FP3BvaUBwi/
         yQVTp5vI60eo3lGrCLT3a9IRQ43YXMHEMd82i0uw7hyp0yc0goKMVHheKUNGuiY++4
         qQs5QXhdss9CZFVRAiJYku8jUU/xnOVfeOYinaW4rQg5yWqEh+d8LrRmkt7aKxxNnX
         twrckbF2OaJiK7++5mbNHbgQJldNzQK0qFlPvAEQIJ7MNpkBdF3sjfMh0vtH0on/yT
         rvrymctkyhm2Q==
Subject: [PATCH 28/46] xfs_repair: refactor metadata inode tagging
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:23 -0800
Message-ID: <167243876303.725900.18033243717448110059.stgit@magnolia>
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

Refactor tagging of metadata inodes into a single helper function
instead of open-coding a if-else statement.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/dir2.c |   52 ++++++++++++++++++++++++++++------------------------
 1 file changed, 28 insertions(+), 24 deletions(-)


diff --git a/repair/dir2.c b/repair/dir2.c
index 022b61b885f..24d0dd84aaf 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -136,6 +136,31 @@ process_sf_dir2_fixoff(
 	}
 }
 
+static bool
+is_meta_ino(
+	struct xfs_mount	*mp,
+	xfs_ino_t		dirino,
+	xfs_ino_t		lino,
+	char			**junkreason)
+{
+	char			*reason = NULL;
+
+	if (lino == mp->m_sb.sb_rbmino)
+		reason = _("realtime bitmap");
+	else if (lino == mp->m_sb.sb_rsumino)
+		reason = _("realtime summary");
+	else if (lino == mp->m_sb.sb_uquotino)
+		reason = _("user quota");
+	else if (lino == mp->m_sb.sb_gquotino)
+		reason = _("group quota");
+	else if (lino == mp->m_sb.sb_pquotino)
+		reason = _("project quota");
+
+	if (reason)
+		*junkreason = reason;
+	return reason != NULL;
+}
+
 /*
  * this routine performs inode discovery and tries to fix things
  * in place.  available redundancy -- inode data size should match
@@ -227,21 +252,8 @@ process_sf_dir2(
 		} else if (!libxfs_verify_dir_ino(mp, lino)) {
 			junkit = 1;
 			junkreason = _("invalid");
-		} else if (lino == mp->m_sb.sb_rbmino)  {
+		} else if (is_meta_ino(mp, ino, lino, &junkreason)) {
 			junkit = 1;
-			junkreason = _("realtime bitmap");
-		} else if (lino == mp->m_sb.sb_rsumino)  {
-			junkit = 1;
-			junkreason = _("realtime summary");
-		} else if (lino == mp->m_sb.sb_uquotino)  {
-			junkit = 1;
-			junkreason = _("user quota");
-		} else if (lino == mp->m_sb.sb_gquotino)  {
-			junkit = 1;
-			junkreason = _("group quota");
-		} else if (lino == mp->m_sb.sb_pquotino)  {
-			junkit = 1;
-			junkreason = _("project quota");
 		} else if ((irec_p = find_inode_rec(mp,
 					XFS_INO_TO_AGNO(mp, lino),
 					XFS_INO_TO_AGINO(mp, lino))) != NULL) {
@@ -698,16 +710,8 @@ process_dir2_data(
 			 * directory since it's still structurally intact.
 			 */
 			clearreason = _("invalid");
-		} else if (ent_ino == mp->m_sb.sb_rbmino) {
-			clearreason = _("realtime bitmap");
-		} else if (ent_ino == mp->m_sb.sb_rsumino) {
-			clearreason = _("realtime summary");
-		} else if (ent_ino == mp->m_sb.sb_uquotino) {
-			clearreason = _("user quota");
-		} else if (ent_ino == mp->m_sb.sb_gquotino) {
-			clearreason = _("group quota");
-		} else if (ent_ino == mp->m_sb.sb_pquotino) {
-			clearreason = _("project quota");
+		} else if (is_meta_ino(mp, ino, ent_ino, &clearreason)) {
+			/* empty */
 		} else {
 			irec_p = find_inode_rec(mp,
 						XFS_INO_TO_AGNO(mp, ent_ino),

