Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D9E6C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:23:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236220AbiLaCXI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:23:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236216AbiLaCXH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:23:07 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 104CB19C12
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:23:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 81D34CE1A95
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:23:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C672BC433D2;
        Sat, 31 Dec 2022 02:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672453382;
        bh=S6ctwEH7xSaFsi45TnKQonX8jDlQbZATy9XhNJscNic=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=lJ8CGmj/LZfgG0vTBLtD7uLq6tF/4k4c7dA2GKEl/mzSZ6652PkrBeg3Zu0w2BREE
         DdHoU+ii4x3YHK0kfHfBtEIfhHSqZpeDtpD5joyNqXs/ZK3wh+5WKIsK8hlIrrIhP/
         rcBGch/Zd/XJvr0dRBUBHUneXvRJvSagfu2L0hdg9erSrhyrrgtreOKJNNGki8RXXN
         R5efufwbdmV8wHuJ17XWR6XQeirnfsov86P8aphqpJbQunkTRE15QI9rsPzdW6s1W1
         +1r8n553hKUHTLCtNbum/klce/IcjNJOSB/yhzlrjIcV0eUIallNgYbA7bnRf0nzgw
         WH/7Vo3W5fXBw==
Subject: [PATCH 05/10] xfs: create helpers to convert rt block numbers to rt
 extent numbers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:28 -0800
Message-ID: <167243876881.727509.13937918096939769614.stgit@magnolia>
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

Create helpers to do unit conversions of rt block numbers to rt extent
numbers.  There are two variations -- the suffix "t" denotes the one
that returns only the truncated extent number; the other one also
returns the misalignment.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/libxfs.h      |    1 +
 libxfs/xfs_bmap.c     |    7 +++----
 libxfs/xfs_rtbitmap.c |    4 ++--
 libxfs/xfs_rtbitmap.h |   17 +++++++++++++++++
 libxfs/xfs_swapext.c  |    7 ++++---
 5 files changed, 27 insertions(+), 9 deletions(-)


diff --git a/include/libxfs.h b/include/libxfs.h
index 661964b8a1e..26202dede67 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -20,6 +20,7 @@
 #include "bitops.h"
 #include "kmem.h"
 #include "libfrog/radix-tree.h"
+#include "libfrog/div64.h"
 #include "atomic.h"
 #include "spinlock.h"
 
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 025298db1e8..5fbfc5372c9 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -5365,7 +5365,6 @@ __xfs_bunmapi(
 	int			tmp_logflags;	/* partial logging flags */
 	int			wasdel;		/* was a delayed alloc extent */
 	int			whichfork;	/* data or attribute fork */
-	xfs_fsblock_t		sum;
 	xfs_filblks_t		len = *rlen;	/* length to unmap in file */
 	xfs_fileoff_t		end;
 	struct xfs_iext_cursor	icur;
@@ -5462,8 +5461,7 @@ __xfs_bunmapi(
 		if (!isrt || (flags & XFS_BMAPI_REMAP))
 			goto delete;
 
-		sum = del.br_startblock + del.br_blockcount;
-		div_u64_rem(sum, mp->m_sb.sb_rextsize, &mod);
+		xfs_rtb_to_rtx(mp, del.br_startblock + del.br_blockcount, &mod);
 		if (mod) {
 			/*
 			 * Realtime extent not lined up at the end.
@@ -5510,7 +5508,8 @@ __xfs_bunmapi(
 				goto error0;
 			goto nodelete;
 		}
-		div_u64_rem(del.br_startblock, mp->m_sb.sb_rextsize, &mod);
+
+		xfs_rtb_to_rtx(mp, del.br_startblock, &mod);
 		if (mod) {
 			xfs_extlen_t off = mp->m_sb.sb_rextsize - mod;
 
diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index 70424ffb7d3..f74618323b4 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -1029,13 +1029,13 @@ xfs_rtfree_blocks(
 
 	ASSERT(rtlen <= XFS_MAX_BMBT_EXTLEN);
 
-	len = div_u64_rem(rtlen, mp->m_sb.sb_rextsize, &mod);
+	len = xfs_rtb_to_rtx(mp, rtlen, &mod);
 	if (mod) {
 		ASSERT(mod == 0);
 		return -EIO;
 	}
 
-	start = div_u64_rem(rtbno, mp->m_sb.sb_rextsize, &mod);
+	start = xfs_rtb_to_rtx(mp, rtbno, &mod);
 	if (mod) {
 		ASSERT(mod == 0);
 		return -EIO;
diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
index e2a36fc157c..bdd4858a794 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
@@ -39,6 +39,23 @@ xfs_extlen_to_rtxlen(
 	return len / mp->m_sb.sb_rextsize;
 }
 
+static inline xfs_rtxnum_t
+xfs_rtb_to_rtx(
+	struct xfs_mount	*mp,
+	xfs_rtblock_t		rtbno,
+	xfs_extlen_t		*mod)
+{
+	return div_u64_rem(rtbno, mp->m_sb.sb_rextsize, mod);
+}
+
+static inline xfs_rtxnum_t
+xfs_rtb_to_rtxt(
+	struct xfs_mount	*mp,
+	xfs_rtblock_t		rtbno)
+{
+	return div_u64(rtbno, mp->m_sb.sb_rextsize);
+}
+
 /*
  * Functions for walking free space rtextents in the realtime bitmap.
  */
diff --git a/libxfs/xfs_swapext.c b/libxfs/xfs_swapext.c
index d2f0c89571d..718600019a7 100644
--- a/libxfs/xfs_swapext.c
+++ b/libxfs/xfs_swapext.c
@@ -28,6 +28,7 @@
 #include "xfs_dir2_priv.h"
 #include "xfs_dir2.h"
 #include "xfs_symlink_remote.h"
+#include "xfs_rtbitmap.h"
 
 struct kmem_cache	*xfs_swapext_intent_cache;
 
@@ -213,19 +214,19 @@ xfs_swapext_check_rt_extents(
 					  irec2.br_blockcount);
 
 		/* Both mappings must be aligned to the realtime extent size. */
-		div_u64_rem(irec1.br_startoff, mp->m_sb.sb_rextsize, &mod);
+		xfs_rtb_to_rtx(mp, irec1.br_startoff, &mod);
 		if (mod) {
 			ASSERT(mod == 0);
 			return -EINVAL;
 		}
 
-		div_u64_rem(irec2.br_startoff, mp->m_sb.sb_rextsize, &mod);
+		xfs_rtb_to_rtx(mp, irec1.br_startoff, &mod);
 		if (mod) {
 			ASSERT(mod == 0);
 			return -EINVAL;
 		}
 
-		div_u64_rem(irec1.br_blockcount, mp->m_sb.sb_rextsize, &mod);
+		xfs_rtb_to_rtx(mp, irec1.br_blockcount, &mod);
 		if (mod) {
 			ASSERT(mod == 0);
 			return -EINVAL;

