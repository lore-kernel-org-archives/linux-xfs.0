Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5555C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:23:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236071AbiLaBXX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:23:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236061AbiLaBXW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:23:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94CE526ED
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:23:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4CD87B81A16
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:23:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7576C433D2;
        Sat, 31 Dec 2022 01:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672449799;
        bh=svI/uBGxKXGDHCPgSMIldvbWV8xWaULv0uiid4SaR6s=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=n3oEe3Vm4PVUDOkuC1Y20yv8nVQ15yMfK2V3rEwsXIymxlYo9jaASqhynVt04cR+f
         i35IZEWMW3E2rsO0Y5+sNglvHpIS9Os0y77uB+PXVmg9vYb+zjBWbBO5gDmiP+dsTI
         6qTCqaYmki0mppQfZeUrdohyf+ljHRLpTnQh4sDvoqQHWsJc1s5GyvIuoVk5Fcpdu2
         KCMqZJ7G50egTM6v/dEn4Du6TsK3sITFRb2/7llfzsy4Px2BIqlvWwweym684QM+Av
         t10N8KLj2bnEQMJ1E2oRDyzWsN7kBg/QlM52cpQ/no6PiRFdu6u8DbdVNlYHgss4Ri
         rfO+F0doXZLWQ==
Subject: [PATCH 2/7] xfs: create a helper to compute leftovers of realtime
 extents
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:41 -0800
Message-ID: <167243866104.711673.4239897118139435118.stgit@magnolia>
In-Reply-To: <167243866067.711673.17279545989126573423.stgit@magnolia>
References: <167243866067.711673.17279545989126573423.stgit@magnolia>
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
 fs/xfs/libxfs/xfs_trans_inode.c |    3 ++-
 fs/xfs/scrub/inode.c            |    3 ++-
 fs/xfs/scrub/inode_repair.c     |    3 ++-
 fs/xfs/xfs_bmap_util.c          |    2 +-
 fs/xfs/xfs_ioctl.c              |    5 +++--
 7 files changed, 21 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 7f7f0d435b33..888b51a09acb 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3058,7 +3058,7 @@ xfs_bmap_extsize_align(
 	 * If realtime, and the result isn't a multiple of the realtime
 	 * extent size we need to remove blocks until it is.
 	 */
-	if (rt && (temp = (align_alen % mp->m_sb.sb_rextsize))) {
+	if (rt && (temp = xfs_extlen_to_rtxmod(mp, align_alen))) {
 		/*
 		 * We're not covering the original request, or
 		 * we won't be able to once we fix the length.
@@ -3085,7 +3085,7 @@ xfs_bmap_extsize_align(
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
diff --git a/fs/xfs/libxfs/xfs_trans_inode.c b/fs/xfs/libxfs/xfs_trans_inode.c
index 6a3a869635bf..4571db873f14 100644
--- a/fs/xfs/libxfs/xfs_trans_inode.c
+++ b/fs/xfs/libxfs/xfs_trans_inode.c
@@ -14,6 +14,7 @@
 #include "xfs_trans.h"
 #include "xfs_trans_priv.h"
 #include "xfs_inode_item.h"
+#include "xfs_rtbitmap.h"
 
 #include <linux/iversion.h>
 
@@ -152,7 +153,7 @@ xfs_trans_log_inode(
 	 */
 	if ((ip->i_diflags & XFS_DIFLAG_RTINHERIT) &&
 	    (ip->i_diflags & XFS_DIFLAG_EXTSZINHERIT) &&
-	    (ip->i_extsize % ip->i_mount->m_sb.sb_rextsize) > 0) {
+	    xfs_extlen_to_rtxmod(ip->i_mount, ip->i_extsize) > 0) {
 		ip->i_diflags &= ~(XFS_DIFLAG_EXTSIZE |
 				   XFS_DIFLAG_EXTSZINHERIT);
 		ip->i_extsize = 0;
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index d86a2e1572ee..4e534ec642e2 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -19,6 +19,7 @@
 #include "xfs_reflink.h"
 #include "xfs_rmap.h"
 #include "xfs_bmap_util.h"
+#include "xfs_rtbitmap.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/btree.h"
@@ -224,7 +225,7 @@ xchk_inode_extsize(
 	 */
 	if ((flags & XFS_DIFLAG_RTINHERIT) &&
 	    (flags & XFS_DIFLAG_EXTSZINHERIT) &&
-	    value % sc->mp->m_sb.sb_rextsize > 0)
+	    xfs_extlen_to_rtxmod(sc->mp, value) > 0)
 		xchk_ino_set_warning(sc, ino);
 }
 
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index e9225536dc65..ef10f031146e 100644
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
@@ -1506,7 +1507,7 @@ xrep_inode_extsize(
 	/* Fix misaligned extent size hints on a directory. */
 	if ((sc->ip->i_diflags & XFS_DIFLAG_RTINHERIT) &&
 	    (sc->ip->i_diflags & XFS_DIFLAG_EXTSZINHERIT) &&
-	    sc->ip->i_extsize % sc->mp->m_sb.sb_rextsize > 0) {
+	    xfs_extlen_to_rtxmod(sc->mp, sc->ip->i_extsize) > 0) {
 		sc->ip->i_extsize = 0;
 		sc->ip->i_diflags &= ~XFS_DIFLAG_EXTSZINHERIT;
 	}
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index e0d3c60c7d9c..cc158e5e095f 100644
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
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 37af6b7e6dbe..e3e6d377d958 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -38,6 +38,7 @@
 #include "xfs_reflink.h"
 #include "xfs_ioctl.h"
 #include "xfs_xattr.h"
+#include "xfs_rtbitmap.h"
 
 #include <linux/mount.h>
 #include <linux/namei.h>
@@ -1013,7 +1014,7 @@ xfs_fill_fsxattr(
 		 * later.
 		 */
 		if ((ip->i_diflags & XFS_DIFLAG_RTINHERIT) &&
-		    ip->i_extsize % mp->m_sb.sb_rextsize > 0) {
+		    xfs_extlen_to_rtxmod(mp, ip->i_extsize) > 0) {
 			fa->fsx_xflags &= ~(FS_XFLAG_EXTSIZE |
 					    FS_XFLAG_EXTSZINHERIT);
 			fa->fsx_extsize = 0;
@@ -1079,7 +1080,7 @@ xfs_ioctl_setattr_xflags(
 	/* If realtime flag is set then must have realtime device */
 	if (fa->fsx_xflags & FS_XFLAG_REALTIME) {
 		if (mp->m_sb.sb_rblocks == 0 || mp->m_sb.sb_rextsize == 0 ||
-		    (ip->i_extsize % mp->m_sb.sb_rextsize))
+		    xfs_extlen_to_rtxmod(mp, ip->i_extsize))
 			return -EINVAL;
 	}
 

