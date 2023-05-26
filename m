Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7452CC7EE29
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:12:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234138AbjEZBMm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:12:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231712AbjEZBMl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:12:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F805D8
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:12:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3488560B88
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:12:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 933BFC433D2;
        Fri, 26 May 2023 01:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685063559;
        bh=J8vNkrwB6dw5gTOlDteIHMuOF4jFKHkKLW3b3hRvC+8=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=ng1sr6DCXh1frUpOnSylCHSjPc9uznk3bGvzhwvyAyVAmIgJPiCtxH9ipLAigbmK0
         Ds9B4JHWrj423Ip1xfjxbpWebIW/+B9Th4fn7T4RPLLQ0O2IX+0sXL43g8luq3Inm7
         uBWAPbSnrku8Pr8oNTpy9i9SlMjYgsDmLfPkZ/5BN6CbdWuIlxGpDwk33vNiTQOESp
         HDUsL5eL/3AFhG2wBuf9F0d0S/DmvcI3Ik9uLnSBf8tbOJZcxHCTcga29aFrLCx27q
         fh1yrPHFA+K1aHsn74MGoXRIddDSgJnmtoXNAjCdd01YI/uMFc1JbIC3Jbaa6EpyFE
         PVdlPhYvCDUdQ==
Date:   Thu, 25 May 2023 18:12:39 -0700
Subject: [PATCH 2/4] xfs: hoist freeing of rt data fork extent mappings
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506063879.3734058.12377591220031199185.stgit@frogsfrogsfrogs>
In-Reply-To: <168506063846.3734058.6853885983674617900.stgit@frogsfrogsfrogs>
References: <168506063846.3734058.6853885983674617900.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Currently, xfs_bmap_del_extent_real contains a bunch of code to convert
the physical extent of a data fork mapping for a realtime file into rt
extents and pass that to the rt extent freeing function.  Since the
details of this aren't needed when CONFIG_XFS_REALTIME=n, move it to
xfs_rtbitmap.c to reduce code size when realtime isn't enabled.

This will (one day) enable realtime EFIs to reuse the same
unit-converting call with less code duplication.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c     |   21 +++------------------
 fs/xfs/libxfs/xfs_rtbitmap.c |   33 +++++++++++++++++++++++++++++++++
 fs/xfs/xfs_rtalloc.h         |    5 +++++
 3 files changed, 41 insertions(+), 18 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 2beff0cfdf38..8f07d6cd969f 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5121,33 +5121,18 @@ xfs_bmap_del_extent_real(
 	flags = XFS_ILOG_CORE;
 	if (xfs_ifork_is_realtime(ip, whichfork)) {
 		if (!(bflags & XFS_BMAPI_REMAP)) {
-			xfs_fsblock_t	bno;
-			xfs_filblks_t	len;
-			xfs_extlen_t	mod;
-
-			len = div_u64_rem(del->br_blockcount,
-					mp->m_sb.sb_rextsize, &mod);
-			ASSERT(mod == 0);
-
-			bno = div_u64_rem(del->br_startblock,
-					mp->m_sb.sb_rextsize, &mod);
-			ASSERT(mod == 0);
-
-			error = xfs_rtfree_extent(tp, bno, (xfs_extlen_t)len);
+			error = xfs_rtfree_blocks(tp, del->br_startblock,
+					del->br_blockcount);
 			if (error)
 				goto done;
-			nblks = len * mp->m_sb.sb_rextsize;
-		} else {
-			nblks = del->br_blockcount;
 		}
-
 		do_fx = 0;
 		qfield = XFS_TRANS_DQ_RTBCOUNT;
 	} else {
 		do_fx = 1;
-		nblks = del->br_blockcount;
 		qfield = XFS_TRANS_DQ_BCOUNT;
 	}
+	nblks = del->br_blockcount;
 
 	del_endblock = del->br_startblock + del->br_blockcount;
 	if (cur) {
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 99a0af8d9028..c0bd7c44a6b8 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -1012,6 +1012,39 @@ xfs_rtfree_extent(
 	return 0;
 }
 
+/*
+ * Free some blocks in the realtime subvolume.  rtbno and rtlen are in units of
+ * rt blocks, not rt extents; must be aligned to the rt extent size; and rtlen
+ * cannot exceed XFS_MAX_BMBT_EXTLEN.
+ */
+int
+xfs_rtfree_blocks(
+	struct xfs_trans	*tp,
+	xfs_fsblock_t		rtbno,
+	xfs_filblks_t		rtlen)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	xfs_rtblock_t		bno;
+	xfs_filblks_t		len;
+	xfs_extlen_t		mod;
+
+	ASSERT(rtlen <= XFS_MAX_BMBT_EXTLEN);
+
+	len = div_u64_rem(rtlen, mp->m_sb.sb_rextsize, &mod);
+	if (mod) {
+		ASSERT(mod == 0);
+		return -EIO;
+	}
+
+	bno = div_u64_rem(rtbno, mp->m_sb.sb_rextsize, &mod);
+	if (mod) {
+		ASSERT(mod == 0);
+		return -EIO;
+	}
+
+	return xfs_rtfree_extent(tp, bno, len);
+}
+
 /* Find all the free records within a given range. */
 int
 xfs_rtalloc_query_range(
diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
index 62c7ad79cbb6..3b2f1b499a11 100644
--- a/fs/xfs/xfs_rtalloc.h
+++ b/fs/xfs/xfs_rtalloc.h
@@ -58,6 +58,10 @@ xfs_rtfree_extent(
 	xfs_rtblock_t		bno,	/* starting block number to free */
 	xfs_extlen_t		len);	/* length of extent freed */
 
+/* Same as above, but in units of rt blocks. */
+int xfs_rtfree_blocks(struct xfs_trans *tp, xfs_fsblock_t rtbno,
+		xfs_filblks_t rtlen);
+
 /*
  * Initialize realtime fields in the mount structure.
  */
@@ -139,6 +143,7 @@ int xfs_rtalloc_reinit_frextents(struct xfs_mount *mp);
 #else
 # define xfs_rtallocate_extent(t,b,min,max,l,f,p,rb)    (ENOSYS)
 # define xfs_rtfree_extent(t,b,l)                       (ENOSYS)
+# define xfs_rtfree_blocks(t,rb,rl)			(ENOSYS)
 # define xfs_rtpick_extent(m,t,l,rb)                    (ENOSYS)
 # define xfs_growfs_rt(mp,in)                           (ENOSYS)
 # define xfs_rtalloc_query_range(t,l,h,f,p)             (ENOSYS)

