Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D53F1CDB482
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Oct 2023 15:50:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235003AbjJQPuf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Oct 2023 11:50:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235082AbjJQPua (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Oct 2023 11:50:30 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9AAEB0
        for <linux-xfs@vger.kernel.org>; Tue, 17 Oct 2023 08:50:28 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81261C433CA;
        Tue, 17 Oct 2023 15:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697557828;
        bh=NF/6SB7CibgfspvNWwstARi7Z+Si7NkDzSMjTkNBpLQ=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=TMmOfg1VURho6eBPkOVa2id/Mve/hPiwuZWn8Y+CmFnO7swXMC+j4VW9lB9NAD6Nr
         7nXlxwblBHwU/q8E5Ep9fQ/EqNcYv8Ar3YLwKyN69XRUInfX5wONMdlTmNHxh1pWJh
         wWlibpU+cF66BJQaSUXCcM4hoqNR4PB6KkYvz0kzV/8bei0R7lXdwhVVYsEOfBL1g6
         z/j+SKHWGJ10qp2ikL9d6eQ+z0jYsIOT2GkCJS940799hqwxrdABG8G1PyHPJ2h/24
         FlbmBuE+8zKDioNbBlj1ynZA2qbwhDuTsQjn4xHkaMowCtEt7dOFhnsvciNHK8zLH5
         XQe0Ic5GFY/nA==
Date:   Tue, 17 Oct 2023 08:50:27 -0700
Subject: [PATCH 2/7] xfs: create a helper to compute leftovers of realtime
 extents
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, osandov@fb.com,
        linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <169755741757.3165781.17462185762294040685.stgit@frogsfrogsfrogs>
In-Reply-To: <169755741717.3165781.12142780069035126128.stgit@frogsfrogsfrogs>
References: <169755741717.3165781.12142780069035126128.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create a helper to compute the misalignment between a file extent
(xfs_extlen_t) and a realtime extent.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c     |    4 ++--
 fs/xfs/libxfs/xfs_rtbitmap.h |    9 +++++++++
 fs/xfs/scrub/inode.c         |    3 ++-
 fs/xfs/xfs_bmap_util.c       |    2 +-
 fs/xfs/xfs_inode_item.c      |    3 ++-
 fs/xfs/xfs_ioctl.c           |    5 +++--
 6 files changed, 19 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 4e7de4f2fd7a..19203699b992 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -2989,7 +2989,7 @@ xfs_bmap_extsize_align(
 	 * If realtime, and the result isn't a multiple of the realtime
 	 * extent size we need to remove blocks until it is.
 	 */
-	if (rt && (temp = (align_alen % mp->m_sb.sb_rextsize))) {
+	if (rt && (temp = xfs_extlen_to_rtxmod(mp, align_alen))) {
 		/*
 		 * We're not covering the original request, or
 		 * we won't be able to once we fix the length.
@@ -3016,7 +3016,7 @@ xfs_bmap_extsize_align(
 		else {
 			align_alen -= orig_off - align_off;
 			align_off = orig_off;
-			align_alen -= align_alen % mp->m_sb.sb_rextsize;
+			align_alen -= xfs_extlen_to_rtxmod(mp, align_alen);
 		}
 		/*
 		 * Result doesn't cover the request, fail it.
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index 099ea8902aaa..b6a4c46bddc0 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -22,6 +22,15 @@ xfs_rtxlen_to_extlen(
 	return rtxlen * mp->m_sb.sb_rextsize;
 }
 
+/* Compute the misalignment between an extent length and a realtime extent .*/
+static inline unsigned int
+xfs_extlen_to_rtxmod(
+	struct xfs_mount	*mp,
+	xfs_extlen_t		len)
+{
+	return len % mp->m_sb.sb_rextsize;
+}
+
 /*
  * Functions for walking free space rtextents in the realtime bitmap.
  */
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 59d7912fb75f..889f556bc98f 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -20,6 +20,7 @@
 #include "xfs_reflink.h"
 #include "xfs_rmap.h"
 #include "xfs_bmap_util.h"
+#include "xfs_rtbitmap.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/btree.h"
@@ -225,7 +226,7 @@ xchk_inode_extsize(
 	 */
 	if ((flags & XFS_DIFLAG_RTINHERIT) &&
 	    (flags & XFS_DIFLAG_EXTSZINHERIT) &&
-	    value % sc->mp->m_sb.sb_rextsize > 0)
+	    xfs_extlen_to_rtxmod(sc->mp, value) > 0)
 		xchk_ino_set_warning(sc, ino);
 }
 
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 2d747084c199..8895184ff90a 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -97,7 +97,7 @@ xfs_bmap_rtalloc(
 	if (error)
 		return error;
 	ASSERT(ap->length);
-	ASSERT(ap->length % mp->m_sb.sb_rextsize == 0);
+	ASSERT(xfs_extlen_to_rtxmod(mp, ap->length) == 0);
 
 	/*
 	 * If we shifted the file offset downward to satisfy an extent size
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 127b2410eb20..3183d0b03e0b 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -19,6 +19,7 @@
 #include "xfs_log.h"
 #include "xfs_log_priv.h"
 #include "xfs_error.h"
+#include "xfs_rtbitmap.h"
 
 #include <linux/iversion.h>
 
@@ -107,7 +108,7 @@ xfs_inode_item_precommit(
 	 */
 	if ((ip->i_diflags & XFS_DIFLAG_RTINHERIT) &&
 	    (ip->i_diflags & XFS_DIFLAG_EXTSZINHERIT) &&
-	    (ip->i_extsize % ip->i_mount->m_sb.sb_rextsize) > 0) {
+	    xfs_extlen_to_rtxmod(ip->i_mount, ip->i_extsize) > 0) {
 		ip->i_diflags &= ~(XFS_DIFLAG_EXTSIZE |
 				   XFS_DIFLAG_EXTSZINHERIT);
 		ip->i_extsize = 0;
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 55bb01173cde..a82470e027f7 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -38,6 +38,7 @@
 #include "xfs_reflink.h"
 #include "xfs_ioctl.h"
 #include "xfs_xattr.h"
+#include "xfs_rtbitmap.h"
 
 #include <linux/mount.h>
 #include <linux/namei.h>
@@ -1004,7 +1005,7 @@ xfs_fill_fsxattr(
 		 * later.
 		 */
 		if ((ip->i_diflags & XFS_DIFLAG_RTINHERIT) &&
-		    ip->i_extsize % mp->m_sb.sb_rextsize > 0) {
+		    xfs_extlen_to_rtxmod(mp, ip->i_extsize) > 0) {
 			fa->fsx_xflags &= ~(FS_XFLAG_EXTSIZE |
 					    FS_XFLAG_EXTSZINHERIT);
 			fa->fsx_extsize = 0;
@@ -1130,7 +1131,7 @@ xfs_ioctl_setattr_xflags(
 	/* If realtime flag is set then must have realtime device */
 	if (fa->fsx_xflags & FS_XFLAG_REALTIME) {
 		if (mp->m_sb.sb_rblocks == 0 || mp->m_sb.sb_rextsize == 0 ||
-		    (ip->i_extsize % mp->m_sb.sb_rextsize))
+		    xfs_extlen_to_rtxmod(mp, ip->i_extsize))
 			return -EINVAL;
 	}
 

