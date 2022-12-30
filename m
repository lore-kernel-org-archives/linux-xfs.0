Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A67CC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:23:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236074AbiLaBXx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:23:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236061AbiLaBXw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:23:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 267729FE3
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:23:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B29CB61C3A
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:23:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2036AC433EF;
        Sat, 31 Dec 2022 01:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672449830;
        bh=e+isMWqVFggsZJ+AjPhRJSF+JQxCVJ/ay4ONlO5XjAE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=EX5SQNU5OA9c/wOEpx9SofRN8Uclv4WN639KGbql6v6PENKpnH+LO/JrbeEEC8LFk
         WZjLRbFsl/NOp7xjrmcSRt1LRAGk9IaH1ro9Ndy8qaslC0HYfcWWP7DojXF4gqvf80
         LOxZshrfwdCeIcgFDWFBUN10qoU3wpvlAMHm8Sgzypalfge0Ds83IMPch9274O3i0Q
         iBrfdTjCtoVNnO4Ell2Y5w9AzLY5tbSVIo/AVRug+fwylKYO9t0674aOrGwvULgN4h
         c3MrEn+yHsN01lN1AOtmlkoDJy///rvnPhiQkLbiL/oDiBGsvZ+W6G0ldScB3b0Oj9
         dUdOVXhcULmvA==
Subject: [PATCH 4/7] xfs: create helpers to convert rt block numbers to rt
 extent numbers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:41 -0800
Message-ID: <167243866132.711673.12003671223787619617.stgit@magnolia>
In-Reply-To: <167243866067.711673.17279545989126573423.stgit@magnolia>
References: <167243866067.711673.17279545989126573423.stgit@magnolia>
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
 fs/xfs/libxfs/xfs_bmap.c     |    7 +++----
 fs/xfs/libxfs/xfs_rtbitmap.c |    4 ++--
 fs/xfs/libxfs/xfs_rtbitmap.h |   17 +++++++++++++++++
 fs/xfs/libxfs/xfs_swapext.c  |    7 ++++---
 fs/xfs/xfs_rtalloc.c         |    8 ++++----
 5 files changed, 30 insertions(+), 13 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 888b51a09acb..055432476ef0 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5371,7 +5371,6 @@ __xfs_bunmapi(
 	int			tmp_logflags;	/* partial logging flags */
 	int			wasdel;		/* was a delayed alloc extent */
 	int			whichfork;	/* data or attribute fork */
-	xfs_fsblock_t		sum;
 	xfs_filblks_t		len = *rlen;	/* length to unmap in file */
 	xfs_fileoff_t		end;
 	struct xfs_iext_cursor	icur;
@@ -5468,8 +5467,7 @@ __xfs_bunmapi(
 		if (!isrt || (flags & XFS_BMAPI_REMAP))
 			goto delete;
 
-		sum = del.br_startblock + del.br_blockcount;
-		div_u64_rem(sum, mp->m_sb.sb_rextsize, &mod);
+		xfs_rtb_to_rtx(mp, del.br_startblock + del.br_blockcount, &mod);
 		if (mod) {
 			/*
 			 * Realtime extent not lined up at the end.
@@ -5516,7 +5514,8 @@ __xfs_bunmapi(
 				goto error0;
 			goto nodelete;
 		}
-		div_u64_rem(del.br_startblock, mp->m_sb.sb_rextsize, &mod);
+
+		xfs_rtb_to_rtx(mp, del.br_startblock, &mod);
 		if (mod) {
 			xfs_extlen_t off = mp->m_sb.sb_rextsize - mod;
 
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index ce1443681131..de54386cf52f 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -1031,13 +1031,13 @@ xfs_rtfree_blocks(
 
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
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index e2a36fc157c4..bdd4858a794c 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
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
diff --git a/fs/xfs/libxfs/xfs_swapext.c b/fs/xfs/libxfs/xfs_swapext.c
index 42df372d1a89..36f03b0bf4ed 100644
--- a/fs/xfs/libxfs/xfs_swapext.c
+++ b/fs/xfs/libxfs/xfs_swapext.c
@@ -30,6 +30,7 @@
 #include "xfs_dir2_priv.h"
 #include "xfs_dir2.h"
 #include "xfs_symlink_remote.h"
+#include "xfs_rtbitmap.h"
 
 struct kmem_cache	*xfs_swapext_intent_cache;
 
@@ -215,19 +216,19 @@ xfs_swapext_check_rt_extents(
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
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 40b6df0ad633..04a468f4cb8a 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1494,16 +1494,16 @@ xfs_rtfile_want_conversion(
 	struct xfs_bmbt_irec	*irec)
 {
 	xfs_fileoff_t		rext_next;
-	uint32_t		modoff, modcnt;
+	xfs_extlen_t		modoff, modcnt;
 
 	if (irec->br_state != XFS_EXT_UNWRITTEN)
 		return false;
 
-	div_u64_rem(irec->br_startoff, mp->m_sb.sb_rextsize, &modoff);
+	xfs_rtb_to_rtx(mp, irec->br_startoff, &modoff);
 	if (modoff == 0) {
-		uint64_t	rexts = div_u64_rem(irec->br_blockcount,
-						mp->m_sb.sb_rextsize, &modcnt);
+		xfs_rtbxlen_t	rexts;
 
+		rexts = xfs_rtb_to_rtx(mp, irec->br_blockcount, &modcnt);
 		if (rexts > 0) {
 			/*
 			 * Unwritten mapping starts at an rt extent boundary

