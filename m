Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:47240 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933596AbeF1RaX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Jun 2018 13:30:23 -0400
Date: Thu, 28 Jun 2018 10:30:08 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 12/10] xfs_repair: use libxfs extsize/cowextsize validation
 helpers
Message-ID: <20180628173008.GJ5711@magnolia>
References: <153006766483.20121.9285982017465570544.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153006766483.20121.9285982017465570544.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Now that we've ported the extent size hint verifiers to libxfs, call
them from xfs_repair instead of open-coding the checks.  Tweak the
repair message slightly to reflect the fact that we zero the field and
clear the inode flag if the hint is garbage or is inconsistent with the
inode flags.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/libxfs_api_defs.h |    2 +
 repair/dinode.c          |   75 ++++++++++++++++------------------------------
 2 files changed, 28 insertions(+), 49 deletions(-)

diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index e5cf1554..fe8336ab 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -98,6 +98,8 @@
 #define xfs_dinode_calc_crc		libxfs_dinode_calc_crc
 #define xfs_idata_realloc		libxfs_idata_realloc
 #define xfs_idestroy_fork		libxfs_idestroy_fork
+#define xfs_inode_validate_extsize	libxfs_inode_validate_extsize
+#define xfs_inode_validate_cowextsize	libxfs_inode_validate_cowextsize
 
 #define xfs_rmap_ag_owner		libxfs_rmap_ag_owner
 #define xfs_rmap_alloc			libxfs_rmap_alloc
diff --git a/repair/dinode.c b/repair/dinode.c
index 4118db7c..14c055bd 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -2853,24 +2853,21 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
 	 * only regular files with REALTIME or EXTSIZE flags set can have
 	 * extsize set, or directories with EXTSZINHERIT.
 	 */
-	if (be32_to_cpu(dino->di_extsize) != 0) {
-		if ((type == XR_INO_RTDATA) ||
-		    (type == XR_INO_DIR && (be16_to_cpu(dino->di_flags) &
-					XFS_DIFLAG_EXTSZINHERIT)) ||
-		    (type == XR_INO_DATA && (be16_to_cpu(dino->di_flags) &
-				 XFS_DIFLAG_EXTSIZE)))  {
-			/* s'okay */ ;
-		} else {
-			do_warn(
-_("bad non-zero extent size %u for non-realtime/extsize inode %" PRIu64 ", "),
-					be32_to_cpu(dino->di_extsize), lino);
-			if (!no_modify)  {
-				do_warn(_("resetting to zero\n"));
-				dino->di_extsize = 0;
-				*dirty = 1;
-			} else
-				do_warn(_("would reset to zero\n"));
-		}
+	if (libxfs_inode_validate_extsize(mp,
+			be32_to_cpu(dino->di_extsize),
+			be16_to_cpu(dino->di_mode),
+			be16_to_cpu(dino->di_flags)) != NULL) {
+		do_warn(
+_("Bad extent size %u for non-realtime/extsize inode %" PRIu64 ", "),
+				be32_to_cpu(dino->di_extsize), lino);
+		if (!no_modify)  {
+			do_warn(_("resetting to zero\n"));
+			dino->di_extsize = 0;
+			dino->di_flags &= ~cpu_to_be16(XFS_DIFLAG_EXTSIZE |
+						       XFS_DIFLAG_EXTSZINHERIT);
+			*dirty = 1;
+		} else
+			do_warn(_("would reset to zero\n"));
 	}
 
 	/*
@@ -2878,41 +2875,21 @@ _("bad non-zero extent size %u for non-realtime/extsize inode %" PRIu64 ", "),
 	 * set can have extsize set.
 	 */
 	if (dino->di_version >= 3 &&
-	    be32_to_cpu(dino->di_cowextsize) != 0) {
-		if ((type == XR_INO_DIR || type == XR_INO_DATA) &&
-		    (be64_to_cpu(dino->di_flags2) &
-					XFS_DIFLAG2_COWEXTSIZE)) {
-			/* s'okay */ ;
-		} else {
-			do_warn(
-_("Cannot have non-zero CoW extent size %u on non-cowextsize inode %" PRIu64 ", "),
-					be32_to_cpu(dino->di_cowextsize), lino);
-			if (!no_modify)  {
-				do_warn(_("resetting to zero\n"));
-				dino->di_flags2 &= ~cpu_to_be64(XFS_DIFLAG2_COWEXTSIZE);
-				dino->di_cowextsize = 0;
-				*dirty = 1;
-			} else
-				do_warn(_("would reset to zero\n"));
-		}
-	}
-
-	/*
-	 * Can't have the COWEXTSIZE flag set with no hint.
-	 */
-	if (dino->di_version >= 3 &&
-	    be32_to_cpu(dino->di_cowextsize) == 0 &&
-	    (be64_to_cpu(dino->di_flags2) & XFS_DIFLAG2_COWEXTSIZE)) {
+	    libxfs_inode_validate_cowextsize(mp,
+			be32_to_cpu(dino->di_cowextsize),
+			be16_to_cpu(dino->di_mode),
+			be16_to_cpu(dino->di_flags),
+			be64_to_cpu(dino->di_flags2)) != NULL) {
 		do_warn(
-_("Cannot have CoW extent size of zero on cowextsize inode %" PRIu64 ", "),
-				lino);
+_("Bad CoW extent size %u on non-cowextsize inode %" PRIu64 ", "),
+				be32_to_cpu(dino->di_cowextsize), lino);
 		if (!no_modify)  {
-			do_warn(_("clearing cowextsize flag\n"));
+			do_warn(_("resetting to zero\n"));
 			dino->di_flags2 &= ~cpu_to_be64(XFS_DIFLAG2_COWEXTSIZE);
+			dino->di_cowextsize = 0;
 			*dirty = 1;
-		} else {
-			do_warn(_("would clear cowextsize flag\n"));
-		}
+		} else
+			do_warn(_("would reset to zero\n"));
 	}
 
 	/* nsec fields cannot be larger than 1 billion */
