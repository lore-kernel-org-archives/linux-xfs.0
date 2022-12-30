Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 360DEC3DA7D
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:44:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236198AbiLaCoX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:44:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236196AbiLaCoF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:44:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E9BE2DED
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:44:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DECE461D16
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:44:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CD49C433D2;
        Sat, 31 Dec 2022 02:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672454643;
        bh=35e3sfRaQYYydapqhPVrjADMLeeLJso9obNT/j3KI20=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=P46CHg5SP3JtweIBb7z9G9KFFEqmI8ntqdk0CDh614yUPw/Rz2L3VRHhkFFBTprvp
         DCeo14dTkeBeUjfnNv7fyuWbPw6ppJ7quHMbFuHFY5+I2ObSBhpr1eBw/Mu4ncXwlJ
         NFHhCF//JeTE3RcpfY3TZjmIOiToBbo7WEzN27KEinIro15RLHU5hhBtqZnZEjt3wa
         51yALnWiC6TbKbGdDtFF5TVWStE/uF4GK4Pd2HXIxf+gSfO67p7jucAdOtT8kQjOCq
         Do+m+YAc9JTfIyLM3PbpTZK7RqZa62Gy61L1d+MmoAglBSEwqozB9IHazn2nDwDfEu
         xmXLGxik4GvDQ==
Subject: [PATCH 06/41] xfs: prepare rmap functions to deal with rtrmapbt
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:56 -0800
Message-ID: <167243879675.732820.4803430458675120967.stgit@magnolia>
In-Reply-To: <167243879574.732820.4725863402652761218.stgit@magnolia>
References: <167243879574.732820.4725863402652761218.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Prepare the high-level rmap functions to deal with the new realtime
rmapbt and its slightly different conventions.  Provide the ability
to talk to either rmapbt or rtrmapbt formats from the same high
level code.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_rmap.c |   66 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)


diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index bce30dd66d6..be611b54a6c 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -23,6 +23,7 @@
 #include "xfs_inode.h"
 #include "xfs_ag.h"
 #include "xfs_health.h"
+#include "xfs_rtgroup.h"
 
 struct kmem_cache	*xfs_rmap_intent_cache;
 
@@ -261,12 +262,73 @@ xfs_rmap_check_perag_irec(
 	return NULL;
 }
 
+static inline xfs_failaddr_t
+xfs_rmap_check_rtgroup_irec(
+	struct xfs_rtgroup		*rtg,
+	const struct xfs_rmap_irec	*irec)
+{
+	struct xfs_mount		*mp = rtg->rtg_mount;
+	bool				is_inode;
+	bool				is_unwritten;
+	bool				is_bmbt;
+	bool				is_attr;
+
+	if (irec->rm_blockcount == 0)
+		return __this_address;
+
+	if (irec->rm_owner == XFS_RMAP_OWN_FS) {
+		if (irec->rm_startblock != 0)
+			return __this_address;
+		if (irec->rm_blockcount != mp->m_sb.sb_rextsize)
+			return __this_address;
+		if (irec->rm_offset != 0)
+			return __this_address;
+	} else {
+		if (!xfs_verify_rgbext(rtg, irec->rm_startblock,
+					    irec->rm_blockcount))
+			return __this_address;
+	}
+
+	if (!(xfs_verify_ino(mp, irec->rm_owner) ||
+	      (irec->rm_owner <= XFS_RMAP_OWN_FS &&
+	       irec->rm_owner >= XFS_RMAP_OWN_MIN)))
+		return __this_address;
+
+	/* Check flags. */
+	is_inode = !XFS_RMAP_NON_INODE_OWNER(irec->rm_owner);
+	is_bmbt = irec->rm_flags & XFS_RMAP_BMBT_BLOCK;
+	is_attr = irec->rm_flags & XFS_RMAP_ATTR_FORK;
+	is_unwritten = irec->rm_flags & XFS_RMAP_UNWRITTEN;
+
+	if (!is_inode && irec->rm_owner != XFS_RMAP_OWN_FS)
+		return __this_address;
+
+	if (!is_inode && irec->rm_offset != 0)
+		return __this_address;
+
+	if (is_bmbt || is_attr)
+		return __this_address;
+
+	if (is_unwritten && !is_inode)
+		return __this_address;
+
+	/* Check for a valid fork offset, if applicable. */
+	if (is_inode &&
+	    !xfs_verify_fileext(mp, irec->rm_offset, irec->rm_blockcount))
+		return __this_address;
+
+	return NULL;
+}
+
 /* Simple checks for rmap records. */
 xfs_failaddr_t
 xfs_rmap_check_irec(
 	struct xfs_btree_cur		*cur,
 	const struct xfs_rmap_irec	*irec)
 {
+	if (cur->bc_btnum == XFS_BTNUM_RTRMAP)
+		return xfs_rmap_check_rtgroup_irec(cur->bc_ino.rtg, irec);
+
 	if (cur->bc_flags & XFS_BTREE_IN_MEMORY)
 		return xfs_rmap_check_perag_irec(cur->bc_mem.pag, irec);
 	return xfs_rmap_check_perag_irec(cur->bc_ag.pag, irec);
@@ -283,6 +345,10 @@ xfs_rmap_complain_bad_rec(
 	if (cur->bc_flags & XFS_BTREE_IN_MEMORY)
 		xfs_warn(mp,
  "In-Memory Reverse Mapping BTree record corruption detected at %pS!", fa);
+	else if (cur->bc_btnum == XFS_BTNUM_RTRMAP)
+		xfs_warn(mp,
+ "RT Reverse Mapping BTree record corruption in rtgroup %u detected at %pS!",
+				cur->bc_ino.rtg->rtg_rgno, fa);
 	else
 		xfs_warn(mp,
  "Reverse Mapping BTree record corruption in AG %d detected at %pS!",

