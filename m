Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CEE6C38A24
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:19:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CDF120CC7
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:19:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dDisz/mq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbgEGMTj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 May 2020 08:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725857AbgEGMTi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 May 2020 08:19:38 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C11FEC05BD43
        for <linux-xfs@vger.kernel.org>; Thu,  7 May 2020 05:19:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=gMBn9lcQJOZufcEXuf+hyb6EmC451D/u63hNcOUaTu4=; b=dDisz/mq65KSk8yoc/JM3IAXjh
        yy2Zw0H1/DAL5LyLyv6WYX3vgjw4NNJsczyWzS7NnhlgsF2mpyMra3WolBDfmRbAS95cLcaIin0bL
        1FHY4H4NgrDU2CguPhRO2eyGT544S2YKEMmFqXOQGT3Acsprx8H7RWVpbqVKkHC35vofrdbsTEGYK
        SPaCS5sy0SIAw7mCa9S88RNiLQ6RuwVqC3MSPTGv1Y38yu6+gvChMSt6NwiXI7HWSQYub7M9W3om3
        lFzNiqKdvyh3MOpUQ+r55ygaG38LHE046PTgq3RiVUWSTKDbMlGmybQGXErfT5ArMkVeBgEE6iaPt
        uzPMwauQ==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWfV4-0005Ah-9q; Thu, 07 May 2020 12:19:38 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 18/58] xfs: factor out a xfs_attr_match helper
Date:   Thu,  7 May 2020 14:18:11 +0200
Message-Id: <20200507121851.304002-19-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200507121851.304002-1-hch@lst.de>
References: <20200507121851.304002-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Source kernel commit: 377f16ac67237c8cda05daf363bcbea95212b000

Factor out a helper that compares an on-disk attr vs the name, length and
flags specified in struct xfs_da_args.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_attr_leaf.c | 80 ++++++++++++++++--------------------------
 1 file changed, 30 insertions(+), 50 deletions(-)

diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index fb07d1de..86e31353 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -442,14 +442,21 @@ xfs_attr3_leaf_read(
  * Namespace helper routines
  *========================================================================*/
 
-/*
- * If namespace bits don't match return 0.
- * If all match then return 1.
- */
-STATIC int
-xfs_attr_namesp_match(int arg_flags, int ondisk_flags)
+static bool
+xfs_attr_match(
+	struct xfs_da_args	*args,
+	uint8_t			namelen,
+	unsigned char		*name,
+	int			flags)
 {
-	return XFS_ATTR_NSP_ONDISK(ondisk_flags) == XFS_ATTR_NSP_ARGS_TO_ONDISK(arg_flags);
+	if (args->namelen != namelen)
+		return false;
+	if (memcmp(args->name, name, namelen) != 0)
+		return false;
+	if (XFS_ATTR_NSP_ARGS_TO_ONDISK(args->flags) !=
+	    XFS_ATTR_NSP_ONDISK(flags))
+		return false;
+	return true;
 }
 
 static int
@@ -675,15 +682,8 @@ xfs_attr_shortform_add(xfs_da_args_t *args, int forkoff)
 	sf = (xfs_attr_shortform_t *)ifp->if_u1.if_data;
 	sfe = &sf->list[0];
 	for (i = 0; i < sf->hdr.count; sfe = XFS_ATTR_SF_NEXTENTRY(sfe), i++) {
-#ifdef DEBUG
-		if (sfe->namelen != args->namelen)
-			continue;
-		if (memcmp(args->name, sfe->nameval, args->namelen) != 0)
-			continue;
-		if (!xfs_attr_namesp_match(args->flags, sfe->flags))
-			continue;
-		ASSERT(0);
-#endif
+		ASSERT(!xfs_attr_match(args, sfe->namelen, sfe->nameval,
+			sfe->flags));
 	}
 
 	offset = (char *)sfe - (char *)sf;
@@ -746,13 +746,9 @@ xfs_attr_shortform_remove(xfs_da_args_t *args)
 	for (i = 0; i < end; sfe = XFS_ATTR_SF_NEXTENTRY(sfe),
 					base += size, i++) {
 		size = XFS_ATTR_SF_ENTSIZE(sfe);
-		if (sfe->namelen != args->namelen)
-			continue;
-		if (memcmp(sfe->nameval, args->name, args->namelen) != 0)
-			continue;
-		if (!xfs_attr_namesp_match(args->flags, sfe->flags))
-			continue;
-		break;
+		if (xfs_attr_match(args, sfe->namelen, sfe->nameval,
+				sfe->flags))
+			break;
 	}
 	if (i == end)
 		return -ENOATTR;
@@ -813,13 +809,9 @@ xfs_attr_shortform_lookup(xfs_da_args_t *args)
 	sfe = &sf->list[0];
 	for (i = 0; i < sf->hdr.count;
 				sfe = XFS_ATTR_SF_NEXTENTRY(sfe), i++) {
-		if (sfe->namelen != args->namelen)
-			continue;
-		if (memcmp(args->name, sfe->nameval, args->namelen) != 0)
-			continue;
-		if (!xfs_attr_namesp_match(args->flags, sfe->flags))
-			continue;
-		return -EEXIST;
+		if (xfs_attr_match(args, sfe->namelen, sfe->nameval,
+				sfe->flags))
+			return -EEXIST;
 	}
 	return -ENOATTR;
 }
@@ -844,14 +836,10 @@ xfs_attr_shortform_getvalue(
 	sfe = &sf->list[0];
 	for (i = 0; i < sf->hdr.count;
 				sfe = XFS_ATTR_SF_NEXTENTRY(sfe), i++) {
-		if (sfe->namelen != args->namelen)
-			continue;
-		if (memcmp(args->name, sfe->nameval, args->namelen) != 0)
-			continue;
-		if (!xfs_attr_namesp_match(args->flags, sfe->flags))
-			continue;
-		return xfs_attr_copy_value(args, &sfe->nameval[args->namelen],
-						sfe->valuelen);
+		if (xfs_attr_match(args, sfe->namelen, sfe->nameval,
+				sfe->flags))
+			return xfs_attr_copy_value(args,
+				&sfe->nameval[args->namelen], sfe->valuelen);
 	}
 	return -ENOATTR;
 }
@@ -2406,23 +2394,15 @@ xfs_attr3_leaf_lookup_int(
 		}
 		if (entry->flags & XFS_ATTR_LOCAL) {
 			name_loc = xfs_attr3_leaf_name_local(leaf, probe);
-			if (name_loc->namelen != args->namelen)
-				continue;
-			if (memcmp(args->name, name_loc->nameval,
-							args->namelen) != 0)
-				continue;
-			if (!xfs_attr_namesp_match(args->flags, entry->flags))
+			if (!xfs_attr_match(args, name_loc->namelen,
+					name_loc->nameval, entry->flags))
 				continue;
 			args->index = probe;
 			return -EEXIST;
 		} else {
 			name_rmt = xfs_attr3_leaf_name_remote(leaf, probe);
-			if (name_rmt->namelen != args->namelen)
-				continue;
-			if (memcmp(args->name, name_rmt->name,
-							args->namelen) != 0)
-				continue;
-			if (!xfs_attr_namesp_match(args->flags, entry->flags))
+			if (!xfs_attr_match(args, name_rmt->namelen,
+					name_rmt->name, entry->flags))
 				continue;
 			args->index = probe;
 			args->rmtvaluelen = be32_to_cpu(name_rmt->valuelen);
-- 
2.26.2

