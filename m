Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47013 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752173AbcJYXH0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2016 19:07:26 -0400
Subject: [PATCH 35/39] xfs_repair: check the CoW extent size hint
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 25 Oct 2016 16:07:20 -0700
Message-ID: <147743684072.11035.2798529745917001253.stgit@birch.djwong.org>
In-Reply-To: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
References: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/dinode.c |   55 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)


diff --git a/repair/dinode.c b/repair/dinode.c
index 64fc983..11b60ce 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -2531,6 +2531,38 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
 			goto clear_bad_out;
 		}
 
+		if ((flags2 & XFS_DIFLAG2_COWEXTSIZE) &&
+		    !xfs_sb_version_hasreflink(&mp->m_sb)) {
+			if (!uncertain) {
+				do_warn(
+	_("inode %" PRIu64 " has CoW extent size hint but file system does not support reflink\n"),
+					lino);
+			}
+			flags2 &= ~XFS_DIFLAG2_COWEXTSIZE;
+		}
+
+		if (flags2 & XFS_DIFLAG2_COWEXTSIZE) {
+			/* must be a directory or file */
+			if (di_mode && !S_ISDIR(di_mode) && !S_ISREG(di_mode)) {
+				if (!uncertain) {
+					do_warn(
+	_("CoW extent size flag set on non-file, non-directory inode %" PRIu64 "\n" ),
+						lino);
+				}
+				flags2 &= ~XFS_DIFLAG2_COWEXTSIZE;
+			}
+		}
+
+		if ((flags2 & XFS_DIFLAG2_COWEXTSIZE) &&
+		    (flags & (XFS_DIFLAG_REALTIME | XFS_DIFLAG_RTINHERIT))) {
+			if (!uncertain) {
+				do_warn(
+	_("Cannot have CoW extent size hint on a realtime inode %" PRIu64 "\n"),
+					lino);
+			}
+			flags2 &= ~XFS_DIFLAG2_COWEXTSIZE;
+		}
+
 		if (!verify_mode && flags2 != be64_to_cpu(dino->di_flags2)) {
 			if (!no_modify) {
 				do_warn(_("fixing bad flags2.\n"));
@@ -2624,6 +2656,29 @@ _("bad non-zero extent size %u for non-realtime/extsize inode %" PRIu64 ", "),
 	}
 
 	/*
+	 * Only (regular files and directories) with COWEXTSIZE flags
+	 * set can have extsize set.
+	 */
+	if (dino->di_version >= 3 &&
+	    be32_to_cpu(dino->di_cowextsize) != 0) {
+		if ((type == XR_INO_DIR || type == XR_INO_DATA) &&
+		    (be64_to_cpu(dino->di_flags2) &
+					XFS_DIFLAG2_COWEXTSIZE)) {
+			/* s'okay */ ;
+		} else {
+			do_warn(
+_("Cannot have non-zero CoW extent size %u on non-cowextsize inode %" PRIu64 ", "),
+					be32_to_cpu(dino->di_cowextsize), lino);
+			if (!no_modify)  {
+				do_warn(_("resetting to zero\n"));
+				dino->di_cowextsize = 0;
+				*dirty = 1;
+			} else
+				do_warn(_("would reset to zero\n"));
+		}
+	}
+
+	/*
 	 * general size/consistency checks:
 	 */
 	if (process_check_inode_sizes(mp, dino, lino, type) != 0)

