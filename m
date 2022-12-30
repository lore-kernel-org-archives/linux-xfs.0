Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F7C6C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:38:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236114AbiLaBim (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:38:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236119AbiLaBil (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:38:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6E5013DD9
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:38:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 834B961CCB
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:38:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8A39C433F1;
        Sat, 31 Dec 2022 01:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672450719;
        bh=0oV0Cy/aDCYdSfP/UqpqNiUEV3mbgKZxbEoUrHml6zE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=UqiMpDXSTltsF09ZxL969mKZL7fKuUt3WBiROMt9i+Y9JJCxJYONSu5EY4tjJLrBT
         eyph1oOeGfORxQlI98gXy8y9WwYOIUBdTzU11QrqbW9Q9X7IalgeSpaTkfVNDBSn1c
         4iiX3tWjFmdIZKwIipAt0O8UcL+/MxKxOKpIXAtsEaK6bvU+oJD6aC3sxrL9OZQoK5
         oLvPErkpluJZp6VKJfdctsz5KXOIo5Nqfe9Mq2tEmKcsMIJF3MMAQ2qaNS4GK2um3Y
         x3QD6dZgiLfUq3FUWfAPn74eZS/U++dW3TObybtdz26thEc/rySN51AmwKxtiIU9Kd
         3zjj6k04V1CwQ==
Subject: [PATCH 07/38] xfs: prepare rmap functions to deal with rtrmapbt
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:17 -0800
Message-ID: <167243869701.715303.7065506301518081631.stgit@magnolia>
In-Reply-To: <167243869558.715303.13347105677486333748.stgit@magnolia>
References: <167243869558.715303.13347105677486333748.stgit@magnolia>
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
 fs/xfs/libxfs/xfs_rmap.c |   66 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index a2a863e0c7fb..31194cc14c0b 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -24,6 +24,7 @@
 #include "xfs_inode.h"
 #include "xfs_ag.h"
 #include "xfs_health.h"
+#include "xfs_rtgroup.h"
 
 struct kmem_cache	*xfs_rmap_intent_cache;
 
@@ -262,12 +263,73 @@ xfs_rmap_check_perag_irec(
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
@@ -284,6 +346,10 @@ xfs_rmap_complain_bad_rec(
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

