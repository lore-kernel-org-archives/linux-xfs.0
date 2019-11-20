Return-Path: <SRS0=ArDI=ZM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECDE6C432C0
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Nov 2019 11:17:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C6CCC22460
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Nov 2019 11:17:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UV5wYXDG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728049AbfKTLRf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Nov 2019 06:17:35 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:47702 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726771AbfKTLRf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Nov 2019 06:17:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=9+9Sjr6+gfvGwLvaRxRlm4yyfB0FhE0nDm2+QhhFpso=; b=UV5wYXDG7OCDLRNaVKvEpZOSLK
        j7T7FmAkXA0ZSxF7t1+SYY6G7nUQAU99PoGGAKjt1YXwFIE2P98mP4x4rD3F/W6lM40PjdyDrvqhn
        mV++br3Aq24uLqqk51hu9hZS+k4XO1574hDdgB2BsKOKP1lm9y7y3nc7q4yYr9e5LL6qZDAc8tHqa
        5ZD3Gp/scVLeu89IgEY7pA+0KhfqWn7v6MnpAPef2CNdPAYj+TiC6AP2lphjDmVKTQsu5qKkHGXiY
        1m/cerol5dhwmqm/zGjfH1z1bkX4LTumRM8D38do+1QrIEHFnmMO9jYJBSra7cXltoQ0S6ypPFzDp
        ZPqDZ1Lw==;
Received: from clnet-p19-102.ikbnet.co.at ([83.175.77.102] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iXNzK-0001Ql-O5; Wed, 20 Nov 2019 11:17:35 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>
Subject: [PATCH 03/10] xfs: improve the xfs_dabuf_map calling conventions
Date:   Wed, 20 Nov 2019 12:17:20 +0100
Message-Id: <20191120111727.16119-4-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191120111727.16119-1-hch@lst.de>
References: <20191120111727.16119-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Use a flags argument with the XFS_DABUF_MAP_HOLE_OK flag to signal that
a hole is okay and not corruption, and return 0 with *nmap set to 0 to
signal that case in the return value instead of a nameless -1 return
code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_da_btree.c | 39 +++++++++++++-----------------------
 fs/xfs/libxfs/xfs_da_btree.h |  3 +++
 2 files changed, 17 insertions(+), 25 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index e078817fc26c..d85dd99d28a3 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -2460,19 +2460,11 @@ xfs_da_shrink_inode(
 	return error;
 }
 
-/*
- * Map the block we are given ready for reading. There are three possible return
- * values:
- *	-1 - will be returned if we land in a hole and mappedbno == -2 so the
- *	     caller knows not to execute a subsequent read.
- *	 0 - if we mapped the block successfully
- *	>0 - positive error number if there was an error.
- */
 static int
 xfs_dabuf_map(
 	struct xfs_inode	*dp,
 	xfs_dablk_t		bno,
-	xfs_daddr_t		mappedbno,
+	unsigned int		flags,
 	int			whichfork,
 	struct xfs_buf_map	**mapp,
 	int			*nmaps)
@@ -2527,7 +2519,7 @@ xfs_dabuf_map(
 
 invalid_mapping:
 	/* Caller ok with no mapping. */
-	if (XFS_IS_CORRUPT(mp, mappedbno != -2)) {
+	if (XFS_IS_CORRUPT(mp, !flags & XFS_DABUF_MAP_HOLE_OK)) {
 		error = -EFSCORRUPTED;
 		if (xfs_error_level >= XFS_ERRLEVEL_LOW) {
 			xfs_alert(mp, "%s: bno %u inode %llu",
@@ -2575,13 +2567,11 @@ xfs_da_get_buf(
 		goto done;
 	}
 
-	error = xfs_dabuf_map(dp, bno, mappedbno, whichfork, &mapp, &nmap);
-	if (error) {
-		/* mapping a hole is not an error, but we don't continue */
-		if (error == -1)
-			error = 0;
+	error = xfs_dabuf_map(dp, bno,
+			mappedbno == -1 ? XFS_DABUF_MAP_HOLE_OK : 0,
+			whichfork, &mapp, &nmap);
+	if (error || nmap == 0)
 		goto out_free;
-	}
 
 	bp = xfs_trans_get_buf_map(tp, mp->m_ddev_targp, mapp, nmap, 0);
 done:
@@ -2630,13 +2620,11 @@ xfs_da_read_buf(
 		goto done;
 	}
 
-	error = xfs_dabuf_map(dp, bno, mappedbno, whichfork, &mapp, &nmap);
-	if (error) {
-		/* mapping a hole is not an error, but we don't continue */
-		if (error == -1)
-			error = 0;
+	error = xfs_dabuf_map(dp, bno,
+			mappedbno == -1 ? XFS_DABUF_MAP_HOLE_OK : 0,
+			whichfork, &mapp, &nmap);
+	if (error || !nmap)
 		goto out_free;
-	}
 
 	error = xfs_trans_read_buf_map(mp, tp, mp->m_ddev_targp, mapp, nmap, 0,
 			&bp, ops);
@@ -2677,11 +2665,12 @@ xfs_da_reada_buf(
 
 	mapp = &map;
 	nmap = 1;
-	error = xfs_dabuf_map(dp, bno, mappedbno, whichfork,
-				&mapp, &nmap);
+	error = xfs_dabuf_map(dp, bno,
+			mappedbno == -1 ? XFS_DABUF_MAP_HOLE_OK : 0,
+			whichfork, &mapp, &nmap);
 	if (error) {
 		/* mapping a hole is not an error, but we don't continue */
-		if (error == -1)
+		if (error == -ENOENT)
 			error = 0;
 		goto out_free;
 	}
diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index ed3b558a9c1a..64624d5717c9 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -194,6 +194,9 @@ int	xfs_da3_node_read(struct xfs_trans *tp, struct xfs_inode *dp,
 /*
  * Utility routines.
  */
+
+#define XFS_DABUF_MAP_HOLE_OK	(1 << 0)
+
 int	xfs_da_grow_inode(xfs_da_args_t *args, xfs_dablk_t *new_blkno);
 int	xfs_da_grow_inode_int(struct xfs_da_args *args, xfs_fileoff_t *bno,
 			      int count);
-- 
2.20.1

