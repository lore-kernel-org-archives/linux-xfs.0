Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 275A9C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:50:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235589AbiL3WuW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:50:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235583AbiL3WuV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:50:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E29C017890
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:50:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7E138B81D94
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BDB6C433EF;
        Fri, 30 Dec 2022 22:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672440618;
        bh=82nmgHGstiIcIvJW23aRqLOgMxNzPaHHa1LMGWJlACs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=W3rvI4iepm4WqpwnNPYqgHcicF34M4HZen8DcYNH0l2bSbEPGNURdI0BghognHh6g
         HXdHJbMI+gSZ/sFfUnAApYoIw2vs3ApLj/kNuI/Fhe4vtH5f6WTjJL5IIsd8Y+UJWZ
         FrtLrKUxMNL4FcKSi9IWuEaGgEV915KQS733dtzRH+XAXcs9EPEtmc1LCfcEM7m/Qr
         zYrCaFYp+wHvFwtVz4yH624+s+q52EmWq4lgMAlbIPH91ILUUSwcKZB7PNZ/+U8WeC
         bWX0MCJF5F4VEonR6o5aGyxTfJr+ytL4+zIeQucl2dPrztCjL2pKp9I/TIRdJUlzqs
         jeUBE4rCzmuxg==
Subject: [PATCH 08/11] xfs: move xattr scrub buffer allocation to top level
 function
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:47 -0800
Message-ID: <167243830719.687022.12351669386465585056.stgit@magnolia>
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

Move the xchk_setup_xattr_buf call from xchk_xattr_block to xchk_xattr,
since we only need to set up the leaf block bitmaps once.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/attr.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index df2f21296b30..a98ea78c41a0 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -346,18 +346,10 @@ xchk_xattr_block(
 	unsigned int			usedbytes = 0;
 	unsigned int			hdrsize;
 	int				i;
-	int				error;
 
 	if (*last_checked == blk->blkno)
 		return 0;
 
-	/* Allocate memory for block usage checking. */
-	error = xchk_setup_xattr_buf(ds->sc, 0);
-	if (error == -ENOMEM)
-		return -EDEADLOCK;
-	if (error)
-		return error;
-
 	*last_checked = blk->blkno;
 	bitmap_zero(ab->usedmap, mp->m_attr_geo->blksize);
 
@@ -507,6 +499,13 @@ xchk_xattr(
 	if (!xfs_inode_hasattr(sc->ip))
 		return -ENOENT;
 
+	/* Allocate memory for xattr checking. */
+	error = xchk_setup_xattr_buf(sc, 0);
+	if (error == -ENOMEM)
+		return -EDEADLOCK;
+	if (error)
+		return error;
+
 	memset(&sx, 0, sizeof(sx));
 	/* Check attribute tree structure */
 	error = xchk_da_btree(sc, XFS_ATTR_FORK, xchk_xattr_rec,

