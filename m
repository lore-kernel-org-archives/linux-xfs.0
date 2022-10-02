Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C14DC433FE
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:37:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbiJBShc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:37:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbiJBShb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:37:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 753C23BC71
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:37:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 210F0B80D82
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:37:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0736C433D6;
        Sun,  2 Oct 2022 18:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735847;
        bh=S0cLeQ8kBXBfeClMzmX1JW8lUTZGlnsM0ti7Qg7UrTk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=FEUBzDIygxjT7p0Urme2lxIKxE2f8NDD0p7uLKOZanUf+XXPPJsQx56hPJTkpogkF
         eLGz2fe0wtxFkLuHvDzLBy65KQ6aNNrtjS8MWHiofhSWG3urhNG5KEu0PMCKUVnLcE
         jGkMukwAJetdoVGsP2AEvSBRPwDwSxbx/TLhKalKAYsdR7buNP/UWvLxwXyT0BEkDs
         Dxve03lJmaj8zPqlZnT1H0Nxit9yI08vZtMWImAOD97/fjgQp6+ny1M6TqBz+9xjsq
         inlVnSryN1TT5xBwPf0VeqK02C1wxvN6TPVdpYSz6dia9nP9PxAesDYR6RxcTRf/eR
         n3pKzIV8KBh5g==
Subject: [PATCH 6/9] xfs: move xattr scrub buffer allocation to top level
 function
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:20:40 -0700
Message-ID: <166473484079.1085108.2152028934457458728.stgit@magnolia>
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

Move the xchk_setup_xattr_buf call from xchk_xattr_block to xchk_xattr,
since we only need to set up the leaf block bitmaps once.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/attr.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 80f39a2c377f..f99961ac11c1 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -340,18 +340,10 @@ xchk_xattr_block(
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
 
@@ -501,6 +493,13 @@ xchk_xattr(
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

