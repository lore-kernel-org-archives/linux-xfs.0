Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60F8AC38A24
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:20:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A93A21582
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:20:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iIe+V7T1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbgEGMUM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 May 2020 08:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725903AbgEGMUM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 May 2020 08:20:12 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94AC7C05BD43
        for <linux-xfs@vger.kernel.org>; Thu,  7 May 2020 05:20:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=t3RYsR646/PNB4Yy5xnyLvHO5zver5Sk20y6Qxbu4As=; b=iIe+V7T15V5tLJ9Wi3sPSnvXJ1
        GNF3cVLoE2fVAvoW0USsD0z/pqlutHJihzilK/DufPmNFctXYk5Z4EYeFXbW6WNHoBL5to2I24zBb
        hKn/IHgsp3xUxpAvqRtxKgEafKLbBCY+sUEX0uaz17Le0rBL9NFRBd0B7eTo4K3yYjt0Kk0t7segx
        gJF7+oCrcJ/X/EbJzpo2Z0ODUqfCFNXAytbZFdL99dLUyP4CqYoXh7Bfx4ukVBKF947FKnhNqneGL
        nGZC/9Q1EL3dOWZgj4ji9lL1JoOyYoA8fQ+7MWaaLlCkMltQOv+83N7naxoQwbTwJAD4UEwOsXQSG
        ZPvraMiw==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWfVc-0007Ij-2W; Thu, 07 May 2020 12:20:12 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 32/58] xfs: fix xfs_rmap_has_other_keys usage of ECANCELED
Date:   Thu,  7 May 2020 14:18:25 +0200
Message-Id: <20200507121851.304002-33-hch@lst.de>
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

From: "Darrick J. Wong" <darrick.wong@oracle.com>

Source kernel commit: a71e4228e6f2a4fe6519d8ed081d0a164967fa31

In e7ee96dfb8c26, we converted all ITER_ABORT users to use ECANCELED
instead, but we forgot to teach xfs_rmap_has_other_keys not to return
that magic value to callers.  Fix it now by using ECANCELED both to
abort the iteration and to signal that we found another reverse mapping.
This enables us to drop the separate boolean flag.

Fixes: e7ee96dfb8c26 ("xfs: remove all *_ITER_ABORT values")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_rmap.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index 10a17e41..c485c29d 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -2693,7 +2693,6 @@ struct xfs_rmap_key_state {
 	uint64_t			owner;
 	uint64_t			offset;
 	unsigned int			flags;
-	bool				has_rmap;
 };
 
 /* For each rmap given, figure out if it doesn't match the key we want. */
@@ -2708,7 +2707,6 @@ xfs_rmap_has_other_keys_helper(
 	if (rks->owner == rec->rm_owner && rks->offset == rec->rm_offset &&
 	    ((rks->flags & rec->rm_flags) & XFS_RMAP_KEY_FLAGS) == rks->flags)
 		return 0;
-	rks->has_rmap = true;
 	return -ECANCELED;
 }
 
@@ -2730,7 +2728,7 @@ xfs_rmap_has_other_keys(
 	int				error;
 
 	xfs_owner_info_unpack(oinfo, &rks.owner, &rks.offset, &rks.flags);
-	rks.has_rmap = false;
+	*has_rmap = false;
 
 	low.rm_startblock = bno;
 	memset(&high, 0xFF, sizeof(high));
@@ -2738,11 +2736,12 @@ xfs_rmap_has_other_keys(
 
 	error = xfs_rmap_query_range(cur, &low, &high,
 			xfs_rmap_has_other_keys_helper, &rks);
-	if (error < 0)
-		return error;
+	if (error == -ECANCELED) {
+		*has_rmap = true;
+		return 0;
+	}
 
-	*has_rmap = rks.has_rmap;
-	return 0;
+	return error;
 }
 
 const struct xfs_owner_info XFS_RMAP_OINFO_SKIP_UPDATE = {
-- 
2.26.2

