Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2727CC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:22:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236211AbiLaCWV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:22:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236217AbiLaCWU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:22:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC9561A833
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:22:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65277B81E0A
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:22:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10158C433D2;
        Sat, 31 Dec 2022 02:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672453336;
        bh=u3MNaCQd66e07cqc9QhEL31yHRDcbkEaLgjh0JHD+tk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Qv/9WMdB7Xs53LEB8oucjyopajufwGYAhxhe8XxQXxcI0Mh8BsTT4T+J5N8k9ffN+
         Lu2r3jdKH5hi/AluUcpec7el5ybNnnqPGIBdGtH7S+YRDdDAM3SZnK3V/7ZKpVNj9v
         Y9fAT3s6HzgWiQtHeakMtW4zj3IvrzhGefuT29r7UEm9bfh76A6NX47z79cJGPNU3J
         uKXlSa24u/1heX1HxpkUBKU1xt8r2HmG5rXUs4PRTcbBWQbuPCzmFmnB4+zGiRO5eE
         qKhV0Z4IbyP6CD3T7/+WyYP2rBkzahUuB6u9hMJmziDOGBFzzx9U3+YtIgUAC0VrC8
         Qfln19uaUo1uQ==
Subject: [PATCH 02/10] xfs: create a helper to compute leftovers of realtime
 extents
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:28 -0800
Message-ID: <167243876841.727509.4018694486761266328.stgit@magnolia>
In-Reply-To: <167243876812.727509.17144221830951566022.stgit@magnolia>
References: <167243876812.727509.17144221830951566022.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create a helper to compute the misalignment between a file extent
(xfs_extlen_t) and a realtime extent.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_bmap.c        |    4 ++--
 libxfs/xfs_rtbitmap.h    |    9 +++++++++
 libxfs/xfs_trans_inode.c |    3 ++-
 3 files changed, 13 insertions(+), 3 deletions(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 25b89d5ee13..025298db1e8 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -3052,7 +3052,7 @@ xfs_bmap_extsize_align(
 	 * If realtime, and the result isn't a multiple of the realtime
 	 * extent size we need to remove blocks until it is.
 	 */
-	if (rt && (temp = (align_alen % mp->m_sb.sb_rextsize))) {
+	if (rt && (temp = xfs_extlen_to_rtxmod(mp, align_alen))) {
 		/*
 		 * We're not covering the original request, or
 		 * we won't be able to once we fix the length.
@@ -3079,7 +3079,7 @@ xfs_bmap_extsize_align(
 		else {
 			align_alen -= orig_off - align_off;
 			align_off = orig_off;
-			align_alen -= align_alen % mp->m_sb.sb_rextsize;
+			align_alen -= xfs_extlen_to_rtxmod(mp, align_alen);
 		}
 		/*
 		 * Result doesn't cover the request, fail it.
diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
index 099ea8902aa..b6a4c46bddc 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
@@ -22,6 +22,15 @@ xfs_rtxlen_to_extlen(
 	return rtxlen * mp->m_sb.sb_rextsize;
 }
 
+/* Compute the misalignment between an extent length and a realtime extent .*/
+static inline unsigned int
+xfs_extlen_to_rtxmod(
+	struct xfs_mount	*mp,
+	xfs_extlen_t		len)
+{
+	return len % mp->m_sb.sb_rextsize;
+}
+
 /*
  * Functions for walking free space rtextents in the realtime bitmap.
  */
diff --git a/libxfs/xfs_trans_inode.c b/libxfs/xfs_trans_inode.c
index 6fc7a65d517..e2d5d3efaab 100644
--- a/libxfs/xfs_trans_inode.c
+++ b/libxfs/xfs_trans_inode.c
@@ -12,6 +12,7 @@
 #include "xfs_mount.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
+#include "xfs_rtbitmap.h"
 
 
 /*
@@ -149,7 +150,7 @@ xfs_trans_log_inode(
 	 */
 	if ((ip->i_diflags & XFS_DIFLAG_RTINHERIT) &&
 	    (ip->i_diflags & XFS_DIFLAG_EXTSZINHERIT) &&
-	    (ip->i_extsize % ip->i_mount->m_sb.sb_rextsize) > 0) {
+	    xfs_extlen_to_rtxmod(ip->i_mount, ip->i_extsize) > 0) {
 		ip->i_diflags &= ~(XFS_DIFLAG_EXTSIZE |
 				   XFS_DIFLAG_EXTSZINHERIT);
 		ip->i_extsize = 0;

