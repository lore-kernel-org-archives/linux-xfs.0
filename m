Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C420CC433F5
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:37:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbiJBShn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:37:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbiJBShm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:37:42 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DACF73BC5E
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:37:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 32EB8CE0A51
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:37:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A3AAC433D6;
        Sun,  2 Oct 2022 18:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735858;
        bh=b9u8fOvDeyZPFVyTTQsSftjiA5j3WxwGE3Myd+qzhDQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=LBdqd13xgMicWnkkmdJ0CQk1ztfoNG4wCtH3duj1u5aIsHJZSszJi90OxeOlZlXvH
         aHYaNQS43s92JeUDFtCs5n8lPtywJjmdx2JA+Ws0KiNlwJNFj7sMZPPMjKexeBflry
         0fDK1/zb3JVkm9HbykIdVSxBBX87TkAEcqdtDO563BJQx3VLWP4FFxQFEOmwo4A5ve
         319R3uPuo2KQ/PYtpdnligLaARAUUUTDGrG6oQ/pPUuLsdnRe2cgxfj8KD2Q21AtDz
         aC0YjewXcv/vys/hvMGdJS4AaOtwrFt6072xBR6fiG2qe2ScuAfx9DWD1fikdnSyE6
         7Mgz3hbGvWuMg==
Subject: [PATCH 7/9] xfs: check used space of shortform xattr structures
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:20:40 -0700
Message-ID: <166473484093.1085108.5089524375028440719.stgit@magnolia>
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

Make sure that the records used inside a shortform xattr structure do
not overlap.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/attr.c |   79 ++++++++++++++++++++++++++++++++++++++++++++++++---
 fs/xfs/scrub/attr.h |    2 +
 2 files changed, 76 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index f99961ac11c1..23c559c4ce80 100644
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
@@ -481,6 +482,73 @@ xchk_xattr_rec(
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
@@ -500,10 +568,12 @@ xchk_xattr(
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
 
@@ -511,6 +581,7 @@ xchk_xattr(
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

