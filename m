Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56807C433F5
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:38:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbiJBSiD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:38:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230116AbiJBSiC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:38:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A0B53C141
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:38:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DC252B80D7E
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:38:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8025DC433D6;
        Sun,  2 Oct 2022 18:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735879;
        bh=LlYoSdmC6B+IRobr561x0/ulHv+yfwY183bA+rhs2BE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=TXy47JoPS5M/Gqntlsydsf1keWgxjWDQu0/MHAnt+h861YC/DFIVBtJAFt+4UYJkJ
         HxzmbMtjyUsl2uMUbbV9HS7r93FIBhIXAmo/8Y0pvf4IK/udCwpO0NRU+dmoPECVQE
         thKiOFoMAoyT58FXN028bBmC0mHJggHjW2i9IQOT4EJE5upVA9Kr/HDID/BZMGZ7Lo
         dA/IRIRQZqI9LG5hz4uTb46GzUUIKu84RJXZo1lCA1HQAGbHS/U52qkjHZoObULLm9
         AEBeeXdimZ72BW9VeoiiGMVjMNqe3KiD/Ocdji64P82EKV+hJpB1XIls+4g9rLNbcu
         QhkZdNXmk9zlg==
Subject: [PATCH 9/9] xfs: only allocate free space bitmap for xattr scrub if
 needed
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:20:41 -0700
Message-ID: <166473484120.1085108.12625299349355602768.stgit@magnolia>
In-Reply-To: <166473483982.1085108.101544412199880535.stgit@magnolia>
References: <166473483982.1085108.101544412199880535.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The free space bitmap is only required if we're going to check the
bestfree space at the end of an xattr leaf block.  Therefore, we can
reduce the memory requirements of this scrubber if we can determine that
the xattr is in short format.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/attr.c |   31 ++++++++++++++++++++++++++++---
 1 file changed, 28 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index f6eb6070488b..b315a499ba32 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -37,6 +37,29 @@ xchk_xattr_buf_cleanup(
 	ab->value_sz = 0;
 }
 
+/*
+ * Allocate the free space bitmap if we're trying harder; there are leaf blocks
+ * in the attr fork; or we can't tell if there are leaf blocks.
+ */
+static inline bool
+xchk_xattr_want_freemap(
+	struct xfs_scrub	*sc)
+{
+	struct xfs_ifork	*ifp;
+
+	if (sc->flags & XCHK_TRY_HARDER)
+		return true;
+
+	if (!sc->ip)
+		return true;
+
+	ifp = xfs_ifork_ptr(sc->ip, XFS_ATTR_FORK);
+	if (!ifp)
+		return false;
+
+	return xfs_ifork_has_extents(ifp);
+}
+
 /*
  * Allocate enough memory to hold an attr value and attr block bitmaps,
  * reallocating the buffer if necessary.  Buffer contents are not preserved
@@ -66,9 +89,11 @@ xchk_setup_xattr_buf(
 	if (!ab->usedmap)
 		return -ENOMEM;
 
-	ab->freemap = kvmalloc(bmp_sz, XCHK_GFP_FLAGS);
-	if (!ab->freemap)
-		return -ENOMEM;
+	if (xchk_xattr_want_freemap(sc)) {
+		ab->freemap = kvmalloc(bmp_sz, XCHK_GFP_FLAGS);
+		if (!ab->freemap)
+			return -ENOMEM;
+	}
 
 resize_value:
 	if (ab->value_sz >= value_size)

