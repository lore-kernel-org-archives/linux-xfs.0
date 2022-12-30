Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCD7BC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:22:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236217AbiLaCWe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:22:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236216AbiLaCWd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:22:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC9B519C12
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:22:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5335361C77
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:22:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEEBBC433EF;
        Sat, 31 Dec 2022 02:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672453351;
        bh=VdCpNsLQfwQwAOpdjNdrU6w8GGuls+JZyid9v0ramyU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=WbdaAtbys4YAGWjiGO3idlN8mClmRoKplYQMNh7kYayAkpG7akNuz3D0lNr+cX1ZG
         w72sMR6bFGKh+qBoCDvnhIlCQsJR3zX6IM+BrjVau/adF2I9O4VxFpTkLtHPWE0qvH
         RL1W8kpwOrURKHynWkxMm78Afq98EaZKNbPIrkmlLawAtR0MZ4F3YehrG7pDeFLoiL
         0C3B+hj+sI5ljurhUYdGPGuNzJWYZOrQfgUgboO12FFW5cS0DTOz5CxWLRDT+Gyw+r
         WV0wnwD0lxk6OIuQ8lcgrqEhjUI+ryAVPmbNQj4N/a/5WtiyJ9d633As2OJ5C+wVUy
         alKkwqnWB+1IA==
Subject: [PATCH 03/10] xfs: create a helper to compute leftovers of realtime
 extents
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:28 -0800
Message-ID: <167243876855.727509.16014981401064876176.stgit@magnolia>
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

Create a helper to compute the realtime extent (xfs_rtxlen_t) from an
extent length (xfs_extlen_t) value.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_rtbitmap.h   |    8 ++++++++
 libxfs/xfs_trans_resv.c |    3 ++-
 2 files changed, 10 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
index b6a4c46bddc..e2a36fc157c 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
@@ -31,6 +31,14 @@ xfs_extlen_to_rtxmod(
 	return len % mp->m_sb.sb_rextsize;
 }
 
+static inline xfs_rtxlen_t
+xfs_extlen_to_rtxlen(
+	struct xfs_mount	*mp,
+	xfs_extlen_t		len)
+{
+	return len / mp->m_sb.sb_rextsize;
+}
+
 /*
  * Functions for walking free space rtextents in the realtime bitmap.
  */
diff --git a/libxfs/xfs_trans_resv.c b/libxfs/xfs_trans_resv.c
index 2835d7754a8..be486ed42c3 100644
--- a/libxfs/xfs_trans_resv.c
+++ b/libxfs/xfs_trans_resv.c
@@ -18,6 +18,7 @@
 #include "xfs_trans.h"
 #include "xfs_trans_space.h"
 #include "xfs_quota_defs.h"
+#include "xfs_rtbitmap.h"
 
 #define _ALLOC	true
 #define _FREE	false
@@ -219,7 +220,7 @@ xfs_rtalloc_block_count(
 	unsigned int		blksz = XFS_FSB_TO_B(mp, 1);
 	unsigned int		rtbmp_bytes;
 
-	rtbmp_bytes = (XFS_MAX_BMBT_EXTLEN / mp->m_sb.sb_rextsize) / NBBY;
+	rtbmp_bytes = xfs_extlen_to_rtxlen(mp, XFS_MAX_BMBT_EXTLEN) / NBBY;
 	return (howmany(rtbmp_bytes, blksz) + 1) * num_ops;
 }
 

