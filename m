Return-Path: <SRS0=xOwi=4F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F060DC33FE1
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Feb 2020 13:00:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4F5C20578
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Feb 2020 13:00:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Svfy2e3C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728754AbgBQNAu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Feb 2020 08:00:50 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:58896 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728115AbgBQNAu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Feb 2020 08:00:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=lboHQ+jzGHlPKFkUzvhq2m13Wlw+hs38LGJpUWXV8Kw=; b=Svfy2e3CwBNEMxFJ/z3m9wtF5c
        8u514A2eVQZ2magcD1+5lVeFjh1H208erJlMWCvXrqViZZEnI1DKJaiC/4v9jn82szWB6HhKwsbR6
        IyHE0NFl3oY9sj5kQJSkZOcC0EGMcRfj79RQpI+9DKUB5p4Tn12aope+7p6Mkxuty/FGdQ2hlyrOf
        ZRqGFzsMtlvevxKz51f1YMqHtYmMR0mk6Bbum4LY+BgGaw77IwJTFjm49+DtmphNFdOS8kPIFU22J
        KBzQi8ghT9/qEkJZ3h4vq9dHZo0VD/DwooLAGo0EAzNIIV5yOzzCaJsxRse1RIkP2UyzShs+DtJ3w
        wMNbISDg==;
Received: from [88.128.92.35] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j3g13-0001wR-NW; Mon, 17 Feb 2020 13:00:50 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 17/31] xfs: factor out a xfs_attr_match helper
Date:   Mon, 17 Feb 2020 13:59:43 +0100
Message-Id: <20200217125957.263434-18-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200217125957.263434-1-hch@lst.de>
References: <20200217125957.263434-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Factor out a helper that compares an on-disk attr vs the name, length and
flags specified in struct xfs_da_args.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_attr_leaf.c | 80 +++++++++++++----------------------
 1 file changed, 30 insertions(+), 50 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index b0658eb8fbcc..8852754153ba 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -445,14 +445,21 @@ xfs_attr3_leaf_read(
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
@@ -678,15 +685,8 @@ xfs_attr_shortform_add(xfs_da_args_t *args, int forkoff)
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
@@ -749,13 +749,9 @@ xfs_attr_shortform_remove(xfs_da_args_t *args)
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
@@ -816,13 +812,9 @@ xfs_attr_shortform_lookup(xfs_da_args_t *args)
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
@@ -847,14 +839,10 @@ xfs_attr_shortform_getvalue(
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
@@ -2409,23 +2397,15 @@ xfs_attr3_leaf_lookup_int(
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
2.24.1

