Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E527C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:24:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236061AbiLaBY1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:24:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236072AbiLaBYZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:24:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B623D1E3C5
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:24:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7B8DFB81DB1
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:24:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C3ECC433EF;
        Sat, 31 Dec 2022 01:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672449861;
        bh=xP8Y42l9MPvlD+O5Btq2MQ6ilRIkEkYu2Z8XSHz8vjY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=gD5x3xyWigeB1nGVrItldAxN/O3NF8YUpEbx5Ig+ggma8w9VvcScvQNQuxtLZfTZ1
         IUfmZKaOm4TtWLXHCDKjunsqMVzQJysXTvaqJl6THJdVUD62v9NpOqRmvCE8j6vBo3
         1yZ4SF8pWYnpn2DRWvWTlvi97Bs8AC3HNo1/iCP3Vk+6XdV88Asl//f+jYtBicQnEW
         oDBVqJM25SMObmsHPgWiGQG9YSGEjGK6GXEqBNfQ6LA9MKISoWqtxPnOhEVQ1uH/9E
         UCDK/UiSM+Of3eQQPMe+qZqCDYKzjASxOrC2T0kidDPUdk9mMs2EHx8FF4HMlfRxvu
         1V9U11KhMpidQ==
Subject: [PATCH 6/7] xfs: create rt extent rounding helpers for realtime
 extent blocks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:41 -0800
Message-ID: <167243866158.711673.5707259870014785828.stgit@magnolia>
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

Create a pair of functions to round rtblock numbers up or down to the
nearest rt extent.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rtbitmap.h |   18 ++++++++++++++++++
 fs/xfs/xfs_bmap_util.c       |    8 +++-----
 fs/xfs/xfs_rtalloc.c         |    4 ++--
 fs/xfs/xfs_xchgrange.c       |    4 ++--
 4 files changed, 25 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index bdd4858a794c..bc51d3bfc7c4 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -56,6 +56,24 @@ xfs_rtb_to_rtxt(
 	return div_u64(rtbno, mp->m_sb.sb_rextsize);
 }
 
+/* Round this rtblock up to the nearest rt extent size. */
+static inline xfs_rtblock_t
+xfs_rtb_roundup_rtx(
+	struct xfs_mount	*mp,
+	xfs_rtblock_t		rtbno)
+{
+	return roundup_64(rtbno, mp->m_sb.sb_rextsize);
+}
+
+/* Round this rtblock down to the nearest rt extent size. */
+static inline xfs_rtblock_t
+xfs_rtb_rounddown_rtx(
+	struct xfs_mount	*mp,
+	xfs_rtblock_t		rtbno)
+{
+	return rounddown_64(rtbno, mp->m_sb.sb_rextsize);
+}
+
 /*
  * Functions for walking free space rtextents in the realtime bitmap.
  */
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index e595625048f8..1bfdd31723f5 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -685,7 +685,7 @@ xfs_can_free_eofblocks(
 	 */
 	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)XFS_ISIZE(ip));
 	if (XFS_IS_REALTIME_INODE(ip) && mp->m_sb.sb_rextsize > 1)
-		end_fsb = roundup_64(end_fsb, mp->m_sb.sb_rextsize);
+		end_fsb = xfs_rtb_roundup_rtx(mp, end_fsb);
 	last_fsb = XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes);
 	if (last_fsb <= end_fsb)
 		return false;
@@ -984,10 +984,8 @@ xfs_free_file_space(
 
 	/* We can only free complete realtime extents. */
 	if (xfs_inode_has_bigrtextents(ip)) {
-		startoffset_fsb = roundup_64(startoffset_fsb,
-					     mp->m_sb.sb_rextsize);
-		endoffset_fsb = rounddown_64(endoffset_fsb,
-					     mp->m_sb.sb_rextsize);
+		startoffset_fsb = xfs_rtb_roundup_rtx(mp, startoffset_fsb);
+		endoffset_fsb = xfs_rtb_rounddown_rtx(mp, endoffset_fsb);
 	}
 
 	/*
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 1953a00755f4..b74ba5e51cf8 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1552,8 +1552,8 @@ xfs_rtfile_convert_unwritten(
 	if (mp->m_sb.sb_rextsize == 1)
 		return 0;
 
-	off = rounddown_64(XFS_B_TO_FSBT(mp, pos), mp->m_sb.sb_rextsize);
-	endoff = roundup_64(XFS_B_TO_FSB(mp, pos + len), mp->m_sb.sb_rextsize);
+	off = xfs_rtb_rounddown_rtx(mp, XFS_B_TO_FSBT(mp, pos));
+	endoff = xfs_rtb_roundup_rtx(mp, XFS_B_TO_FSB(mp, pos + len));
 
 	trace_xfs_rtfile_convert_unwritten(ip, pos, len);
 
diff --git a/fs/xfs/xfs_xchgrange.c b/fs/xfs/xfs_xchgrange.c
index ae030a6f607e..829a17ac7406 100644
--- a/fs/xfs/xfs_xchgrange.c
+++ b/fs/xfs/xfs_xchgrange.c
@@ -29,6 +29,7 @@
 #include "xfs_icache.h"
 #include "xfs_log.h"
 #include "xfs_rtalloc.h"
+#include "xfs_rtbitmap.h"
 
 /* Lock (and optionally join) two inodes for a file range exchange. */
 void
@@ -802,8 +803,7 @@ xfs_xchg_range(
 	 * offsets and length in @fxr are safe to round up.
 	 */
 	if (XFS_IS_REALTIME_INODE(ip2))
-		req.blockcount = roundup_64(req.blockcount,
-					    mp->m_sb.sb_rextsize);
+		req.blockcount = xfs_rtb_roundup_rtx(mp, req.blockcount);
 
 	error = xfs_xchg_range_estimate(&req);
 	if (error)

