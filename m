Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C5FCCDB470
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Oct 2023 18:05:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232891AbjJKSFA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Oct 2023 14:05:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235022AbjJKSE6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2023 14:04:58 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7E12BA
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 11:04:56 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AC5FC433C8;
        Wed, 11 Oct 2023 18:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697047496;
        bh=NgQ9Q/ebYRPTuw2IhlGgJfaSbKmPfqTwGyDrsOWZFac=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=ZDKF1vMcfVMR37oP435n50dhF8EN3vMKu1ukby+i6Z7wNj07YAtHgIdqu0r6LbE5M
         udY27HcJzgimW37SngclKq21cFdBfzPh1DxiYwHEuC9PG0BD3UG6G2t5kmTBhyLNc7
         XXT1l7Aua0W2UzIY6O3yXmS0GQZyhN8AV3hzF5nQL5VFAxOhbpGLJ7DPH1TG96yLhH
         uJSGBqaoKz82LIKMha8hS9EME5HZ6x2KgGP5cLoNPfxfAZJYCkH0r8ng2uaMx/L3aB
         w2zvLKvWPLApZtwxyvN9F1Kfys/AErG0kTsK77LQ9pYwYmazx0u1kXmVwDC8Jq1p0p
         FSyGDQcKPNlZw==
Date:   Wed, 11 Oct 2023 11:04:55 -0700
Subject: [PATCH 2/7] xfs: create a helper to compute leftovers of realtime
 extents
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, osandov@osandov.com, hch@lst.de
Message-ID: <169704721209.1773611.10988808692731283385.stgit@frogsfrogsfrogs>
In-Reply-To: <169704721170.1773611.12311239321983752854.stgit@frogsfrogsfrogs>
References: <169704721170.1773611.12311239321983752854.stgit@frogsfrogsfrogs>
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
---
 fs/xfs/libxfs/xfs_bmap.c        |    4 ++--
 fs/xfs/libxfs/xfs_rtbitmap.h    |    9 +++++++++
 fs/xfs/libxfs/xfs_trans_inode.c |    1 +
 fs/xfs/scrub/inode.c            |    3 ++-
 fs/xfs/scrub/inode_repair.c     |    3 ++-
 fs/xfs/xfs_bmap_util.c          |    2 +-
 fs/xfs/xfs_inode_item.c         |    3 ++-
 fs/xfs/xfs_ioctl.c              |    5 +++--
 8 files changed, 22 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index fd083a3c554e0..82dc95944374e 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3038,7 +3038,7 @@ xfs_bmap_extsize_align(
 	 * If realtime, and the result isn't a multiple of the realtime
 	 * extent size we need to remove blocks until it is.
 	 */
-	if (rt && (temp = (align_alen % mp->m_sb.sb_rextsize))) {
+	if (rt && (temp = xfs_extlen_to_rtxmod(mp, align_alen))) {
 		/*
 		 * We're not covering the original request, or
 		 * we won't be able to once we fix the length.
@@ -3065,7 +3065,7 @@ xfs_bmap_extsize_align(
 		else {
 			align_alen -= orig_off - align_off;
 			align_off = orig_off;
-			align_alen -= align_alen % mp->m_sb.sb_rextsize;
+			align_alen -= xfs_extlen_to_rtxmod(mp, align_alen);
 		}
 		/*
 		 * Result doesn't cover the request, fail it.
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index 099ea8902aaaf..b6a4c46bddc0a 100644
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
diff --git a/fs/xfs/libxfs/xfs_trans_inode.c b/fs/xfs/libxfs/xfs_trans_inode.c
index 3e07e7c6a5d53..29f1aa290ce6d 100644
--- a/fs/xfs/libxfs/xfs_trans_inode.c
+++ b/fs/xfs/libxfs/xfs_trans_inode.c
@@ -14,6 +14,7 @@
 #include "xfs_trans.h"
 #include "xfs_trans_priv.h"
 #include "xfs_inode_item.h"
+#include "xfs_rtbitmap.h"
 
 #include <linux/iversion.h>
 
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 3cb75c559a32f..e8da1ae3c5c01 100644
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
@@ -254,7 +255,7 @@ xchk_inode_extsize(
 	 */
 	if ((flags & XFS_DIFLAG_RTINHERIT) &&
 	    (flags & XFS_DIFLAG_EXTSZINHERIT) &&
-	    value % sc->mp->m_sb.sb_rextsize > 0)
+	    xfs_extlen_to_rtxmod(sc->mp, value) > 0)
 		xchk_ino_set_warning(sc, ino);
 }
 
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index 6787abbc6d6ff..7f1f7cec822a2 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -36,6 +36,7 @@
 #include "xfs_attr_leaf.h"
 #include "xfs_log_priv.h"
 #include "xfs_symlink_remote.h"
+#include "xfs_rtbitmap.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -1599,7 +1600,7 @@ xrep_inode_extsize(
 	/* Fix misaligned extent size hints on a directory. */
 	if ((sc->ip->i_diflags & XFS_DIFLAG_RTINHERIT) &&
 	    (sc->ip->i_diflags & XFS_DIFLAG_EXTSZINHERIT) &&
-	    sc->ip->i_extsize % sc->mp->m_sb.sb_rextsize > 0) {
+	    xfs_extlen_to_rtxmod(sc->mp, sc->ip->i_extsize) > 0) {
 		sc->ip->i_extsize = 0;
 		sc->ip->i_diflags &= ~XFS_DIFLAG_EXTSZINHERIT;
 	}
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index cd4136b2b39c4..0590d55cd88f6 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -98,7 +98,7 @@ xfs_bmap_rtalloc(
 	if (error)
 		return error;
 	ASSERT(ap->length);
-	ASSERT(ap->length % mp->m_sb.sb_rextsize == 0);
+	ASSERT(xfs_extlen_to_rtxmod(mp, ap->length) == 0);
 
 	/*
 	 * If we shifted the file offset downward to satisfy an extent size
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 127b2410eb206..3183d0b03e0bc 100644
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
index a2c7508527f8c..cbfa8500e2354 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -41,6 +41,7 @@
 #include "xfs_xattr.h"
 #include "xfs_xchgrange.h"
 #include "xfs_file.h"
+#include "xfs_rtbitmap.h"
 
 #include <linux/mount.h>
 #include <linux/namei.h>
@@ -1017,7 +1018,7 @@ xfs_fill_fsxattr(
 		 * later.
 		 */
 		if ((ip->i_diflags & XFS_DIFLAG_RTINHERIT) &&
-		    ip->i_extsize % mp->m_sb.sb_rextsize > 0) {
+		    xfs_extlen_to_rtxmod(mp, ip->i_extsize) > 0) {
 			fa->fsx_xflags &= ~(FS_XFLAG_EXTSIZE |
 					    FS_XFLAG_EXTSZINHERIT);
 			fa->fsx_extsize = 0;
@@ -1083,7 +1084,7 @@ xfs_ioctl_setattr_xflags(
 	/* If realtime flag is set then must have realtime device */
 	if (fa->fsx_xflags & FS_XFLAG_REALTIME) {
 		if (mp->m_sb.sb_rblocks == 0 || mp->m_sb.sb_rextsize == 0 ||
-		    (ip->i_extsize % mp->m_sb.sb_rextsize))
+		    xfs_extlen_to_rtxmod(mp, ip->i_extsize))
 			return -EINVAL;
 	}
 

