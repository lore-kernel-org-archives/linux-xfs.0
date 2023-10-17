Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5C98CDB474
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Oct 2023 15:47:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235094AbjJQPrX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Oct 2023 11:47:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235034AbjJQPrV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Oct 2023 11:47:21 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 070FFF2
        for <linux-xfs@vger.kernel.org>; Tue, 17 Oct 2023 08:47:20 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98876C433C8;
        Tue, 17 Oct 2023 15:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697557639;
        bh=u8ud6/sYqCOPMJ8Znw+bHEyoT6TwdQvhkFh6BUf9qEU=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=Yxw5mwCTc8yVocix6xtCz0NWigS7ES2b81kZksPQkWFaeE7YLp3ehg1BapP2JV7UX
         S1dALz89Q9BNyYDg/ZnNQH04nCaa8QROSst7ic8Dv/isLBbeRdB3853d/mrn1Bo/3W
         RaLsCYsC7wdI09HBke+0eQJOZ2/trzgwX0NMTe6r8Kd/zO0EGCo2wpvz3bmqj7sWK6
         1WwxrBTBzkQiVcHZh2ycu1ZSY/QbA1nVNPsrsIKc+WMVSqCoB5bRogn8UQfHcyZoUr
         rVVM87yoHzkM2LYwVHqu5k+V4c5lJMeyvWl6cA39IK1nIcL4s6gJJL4zAm/QVMgodx
         n77ySL4ZeZUcQ==
Date:   Tue, 17 Oct 2023 08:47:19 -0700
Subject: [PATCH 2/4] xfs: hoist freeing of rt data fork extent mappings
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     osandov@fb.com, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <169755740928.3165385.11991202448392574091.stgit@frogsfrogsfrogs>
In-Reply-To: <169755740893.3165385.15959700242470322359.stgit@frogsfrogsfrogs>
References: <169755740893.3165385.15959700242470322359.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_bmap.c     |   19 +++----------------
 fs/xfs/libxfs/xfs_rtbitmap.c |   33 +++++++++++++++++++++++++++++++++
 fs/xfs/xfs_rtalloc.h         |    5 +++++
 3 files changed, 41 insertions(+), 16 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 30c931b38853..26bfa34b4bbf 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5057,33 +5057,20 @@ xfs_bmap_del_extent_real(
 
 	flags = XFS_ILOG_CORE;
 	if (whichfork == XFS_DATA_FORK && XFS_IS_REALTIME_INODE(ip)) {
-		xfs_filblks_t	len;
-		xfs_extlen_t	mod;
-
-		len = div_u64_rem(del->br_blockcount, mp->m_sb.sb_rextsize,
-				  &mod);
-		ASSERT(mod == 0);
-
 		if (!(bflags & XFS_BMAPI_REMAP)) {
-			xfs_fsblock_t	bno;
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
 		}
 
 		do_fx = 0;
-		nblks = len * mp->m_sb.sb_rextsize;
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
index fa180ab66b73..655108a4cd05 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -1005,6 +1005,39 @@ xfs_rtfree_extent(
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

