Return-Path: <SRS0=dZhK=A2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38CF0C433E6
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 18:34:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 110AC20672
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 18:34:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jDGr0MLh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbgGOSeU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jul 2020 14:34:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726034AbgGOSeU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jul 2020 14:34:20 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AEC2C061755
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jul 2020 11:34:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=mfQF2DUDZo/+QyzegmToFckYJ6Zd7Ptz0P5PWbZypbE=; b=jDGr0MLhNl5m975Ae4mBqERPvB
        fRjOS9GUrX64lQQT5g9LMTMP4YRXkZv43P4rvyLMejHHJDiXsG7Bypz6P/sHuAD3TEQCOuvb356NH
        oNpMEb8mxIJf9yYBG1La/3P8r/6zCKZA0nJizAEn4Lp1I7OPMWci4oV2/Tqi8oGgNBsCKZBxvSyBL
        WrqT21wQt5MMNc08I2s2OuPUsTGRrma9vkbhfrVmGd3tH8V2Rl/g/IaoXbe+yBRJW6NSxK7yL/rOO
        2k8b1TdVK8rOUjJDf/Hj6Q62HMxudSRmZA8N2oBZiZtHA1y9eig11BSrl0OB8R1WO4zmiS0HfHbpO
        HNtUdqsw==;
Received: from [2001:4bb8:105:4a81:85a7:b0e2:b303:4d14] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jvmEU-0005n1-Kn; Wed, 15 Jul 2020 18:34:19 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: [PATCH] repair: simplify bmap_next_offset
Date:   Wed, 15 Jul 2020 20:34:17 +0200
Message-Id: <20200715183417.79701-1-hch@lst.de>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The tp argument is always NULL, and the whichfork argument is always
XFS_DATA_FORK, so simplify and cleanup the function based on those
assumptions.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 repair/phase6.c | 51 +++++++++++++++++++++++--------------------------
 1 file changed, 24 insertions(+), 27 deletions(-)

diff --git a/repair/phase6.c b/repair/phase6.c
index 446bcfcb7..952af590f 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -406,46 +406,43 @@ dir_hash_dup_names(dir_hash_tab_t *hashtab)
 }
 
 /*
- * Given a block number in a fork, return the next valid block number
- * (not a hole).
- * If this is the last block number then NULLFILEOFF is returned.
- *
- * This was originally in the kernel, but only used in xfs_repair.
+ * Given a block number in a fork, return the next valid block number (not a
+ * hole).  If this is the last block number then NULLFILEOFF is returned.
  */
 static int
 bmap_next_offset(
-	xfs_trans_t	*tp,			/* transaction pointer */
-	xfs_inode_t	*ip,			/* incore inode */
-	xfs_fileoff_t	*bnop,			/* current block */
-	int		whichfork)		/* data or attr fork */
+	struct xfs_inode	*ip,
+	xfs_fileoff_t		*bnop)
 {
-	xfs_fileoff_t	bno;			/* current block */
-	int		error;			/* error return value */
-	xfs_bmbt_irec_t got;			/* current extent value */
-	struct xfs_ifork	*ifp;		/* inode fork pointer */
+	xfs_fileoff_t		bno;
+	int			error;
+	struct xfs_bmbt_irec	got;	
 	struct xfs_iext_cursor	icur;
 
-	if (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE &&
-	    XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
-	    XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_LOCAL)
-	       return EIO;
-	if (XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_LOCAL) {
+	switch (ip->i_d.di_format) {
+	case XFS_DINODE_FMT_LOCAL:
 		*bnop = NULLFILEOFF;
 		return 0;
+	case XFS_DINODE_FMT_BTREE:
+	case XFS_DINODE_FMT_EXTENTS:
+		break;
+	default:
+		return EIO;
+	}
+
+	if (!(ip->i_df.if_flags & XFS_IFEXTENTS)) {
+		error = -libxfs_iread_extents(NULL, ip, XFS_DATA_FORK);
+		if (error)
+			return error;
 	}
-	ifp = XFS_IFORK_PTR(ip, whichfork);
-	if (!(ifp->if_flags & XFS_IFEXTENTS) &&
-	    (error = -libxfs_iread_extents(tp, ip, whichfork)))
-		return error;
 	bno = *bnop + 1;
-	if (!libxfs_iext_lookup_extent(ip, ifp, bno, &icur, &got))
+	if (!libxfs_iext_lookup_extent(ip, &ip->i_df, bno, &icur, &got))
 		*bnop = NULLFILEOFF;
 	else
 		*bnop = got.br_startoff < bno ? bno : got.br_startoff;
 	return 0;
 }
 
-
 static void
 res_failed(
 	int	err)
@@ -2054,7 +2051,7 @@ longform_dir2_check_node(
 			next_da_bno != NULLFILEOFF && da_bno < mp->m_dir_geo->freeblk;
 			da_bno = (xfs_dablk_t)next_da_bno) {
 		next_da_bno = da_bno + mp->m_dir_geo->fsbcount - 1;
-		if (bmap_next_offset(NULL, ip, &next_da_bno, XFS_DATA_FORK))
+		if (bmap_next_offset(ip, &next_da_bno))
 			break;
 
 		/*
@@ -2129,7 +2126,7 @@ longform_dir2_check_node(
 	     next_da_bno != NULLFILEOFF;
 	     da_bno = (xfs_dablk_t)next_da_bno) {
 		next_da_bno = da_bno + mp->m_dir_geo->fsbcount - 1;
-		if (bmap_next_offset(NULL, ip, &next_da_bno, XFS_DATA_FORK))
+		if (bmap_next_offset(ip, &next_da_bno))
 			break;
 
 		error = dir_read_buf(ip, da_bno, &bp, &xfs_dir3_free_buf_ops,
@@ -2261,7 +2258,7 @@ longform_dir2_entry_check(xfs_mount_t	*mp,
 		struct xfs_dir2_data_hdr *d;
 
 		next_da_bno = da_bno + mp->m_dir_geo->fsbcount - 1;
-		if (bmap_next_offset(NULL, ip, &next_da_bno, XFS_DATA_FORK)) {
+		if (bmap_next_offset(ip, &next_da_bno)) {
 			/*
 			 * if this is the first block, there isn't anything we
 			 * can recover so we just trash it.
-- 
2.27.0

