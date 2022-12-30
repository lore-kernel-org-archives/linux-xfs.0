Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46128C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:50:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235583AbiL3Wui (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:50:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbiL3Wuh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:50:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65B1A18E31
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:50:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1097AB81D95
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:50:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0FDEC433D2;
        Fri, 30 Dec 2022 22:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672440633;
        bh=IK45BXZCs17zXLUlaU16nNQb8U6/jtJKtTYHKVTslw8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=m5NnARdW/hOlo3zZfW2kXQrqrNuIauyVShA5BhKeolgYhe+nfA1nebftewlKmF5Xk
         7E3wkv0Ihf/eobfKT/xA59Fy9vjjKtaXwozeoLfao69fRU+RNt1TloEWCPqyFs6Rkg
         KkSJpVePGBcXhEEI1Ehx4NVOIHtKoLPy/Zp1EsTd/L7KbfIgSM6z8MQTsn7XFfyYKf
         H6NPsUCquguEoj5k4wE1dqV276voaOKxNF5INNQYrHZW0dula9UjqpZ3MVQRcxvZgp
         XX0WcAt0eego8ZeBM+kH0AZ7BEGvAmnAU/pvtXLGTVY8txH+Jpv7FH+hQ+Xf9Kgfen
         Q5qdNXwkklz4w==
Subject: [PATCH 09/11] xfs: check used space of shortform xattr structures
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:47 -0800
Message-ID: <167243830732.687022.11163737318692641827.stgit@magnolia>
In-Reply-To: <167243830598.687022.17067931640967897645.stgit@magnolia>
References: <167243830598.687022.17067931640967897645.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Make sure that the records used inside a shortform xattr structure do
not overlap.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/attr.c |   79 ++++++++++++++++++++++++++++++++++++++++++++++++---
 fs/xfs/scrub/attr.h |    2 +
 2 files changed, 76 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index a98ea78c41a0..3e568c78210b 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -15,6 +15,7 @@
 #include "xfs_da_btree.h"
 #include "xfs_attr.h"
 #include "xfs_attr_leaf.h"
+#include "xfs_attr_sf.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/dabtree.h"
@@ -487,6 +488,73 @@ xchk_xattr_rec(
 	return error;
 }
 
+/* Check space usage of shortform attrs. */
+STATIC int
+xchk_xattr_check_sf(
+	struct xfs_scrub		*sc)
+{
+	struct xchk_xattr_buf		*ab = sc->buf;
+	struct xfs_attr_shortform	*sf;
+	struct xfs_attr_sf_entry	*sfe;
+	struct xfs_attr_sf_entry	*next;
+	struct xfs_ifork		*ifp;
+	unsigned char			*end;
+	int				i;
+	int				error = 0;
+
+	ifp = xfs_ifork_ptr(sc->ip, XFS_ATTR_FORK);
+
+	bitmap_zero(ab->usedmap, ifp->if_bytes);
+	sf = (struct xfs_attr_shortform *)sc->ip->i_af.if_u1.if_data;
+	end = (unsigned char *)ifp->if_u1.if_data + ifp->if_bytes;
+	xchk_xattr_set_map(sc, ab->usedmap, 0, sizeof(sf->hdr));
+
+	sfe = &sf->list[0];
+	if ((unsigned char *)sfe > end) {
+		xchk_fblock_set_corrupt(sc, XFS_ATTR_FORK, 0);
+		return 0;
+	}
+
+	for (i = 0; i < sf->hdr.count; i++) {
+		unsigned char		*name = sfe->nameval;
+		unsigned char		*value = &sfe->nameval[sfe->namelen];
+
+		if (xchk_should_terminate(sc, &error))
+			return error;
+
+		next = xfs_attr_sf_nextentry(sfe);
+		if ((unsigned char *)next > end) {
+			xchk_fblock_set_corrupt(sc, XFS_ATTR_FORK, 0);
+			break;
+		}
+
+		if (!xchk_xattr_set_map(sc, ab->usedmap,
+				(char *)sfe - (char *)sf,
+				sizeof(struct xfs_attr_sf_entry))) {
+			xchk_fblock_set_corrupt(sc, XFS_ATTR_FORK, 0);
+			break;
+		}
+
+		if (!xchk_xattr_set_map(sc, ab->usedmap,
+				(char *)name - (char *)sf,
+				sfe->namelen)) {
+			xchk_fblock_set_corrupt(sc, XFS_ATTR_FORK, 0);
+			break;
+		}
+
+		if (!xchk_xattr_set_map(sc, ab->usedmap,
+				(char *)value - (char *)sf,
+				sfe->valuelen)) {
+			xchk_fblock_set_corrupt(sc, XFS_ATTR_FORK, 0);
+			break;
+		}
+
+		sfe = next;
+	}
+
+	return 0;
+}
+
 /* Scrub the extended attribute metadata. */
 int
 xchk_xattr(
@@ -506,10 +574,12 @@ xchk_xattr(
 	if (error)
 		return error;
 
-	memset(&sx, 0, sizeof(sx));
-	/* Check attribute tree structure */
-	error = xchk_da_btree(sc, XFS_ATTR_FORK, xchk_xattr_rec,
-			&last_checked);
+	/* Check the physical structure of the xattr. */
+	if (sc->ip->i_af.if_format == XFS_DINODE_FMT_LOCAL)
+		error = xchk_xattr_check_sf(sc);
+	else
+		error = xchk_da_btree(sc, XFS_ATTR_FORK, xchk_xattr_rec,
+				&last_checked);
 	if (error)
 		goto out;
 
@@ -517,6 +587,7 @@ xchk_xattr(
 		goto out;
 
 	/* Check that every attr key can also be looked up by hash. */
+	memset(&sx, 0, sizeof(sx));
 	sx.context.dp = sc->ip;
 	sx.context.resynch = 1;
 	sx.context.put_listent = xchk_xattr_listent;
diff --git a/fs/xfs/scrub/attr.h b/fs/xfs/scrub/attr.h
index 18445cc3d33b..5f6835752738 100644
--- a/fs/xfs/scrub/attr.h
+++ b/fs/xfs/scrub/attr.h
@@ -10,7 +10,7 @@
  * Temporary storage for online scrub and repair of extended attributes.
  */
 struct xchk_xattr_buf {
-	/* Bitmap of used space in xattr leaf blocks. */
+	/* Bitmap of used space in xattr leaf blocks and shortform forks. */
 	unsigned long		*usedmap;
 
 	/* Bitmap of free space in xattr leaf blocks. */

