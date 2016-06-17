Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AAA65846A
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:44:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 72E738F8050
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:44:47 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id m6plnk4s8txckiGS (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:44:46 -0700 (PDT)
Subject: [PATCH 132/145] xfs_repair: check the CoW extent size hint
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:44:38 -0700
Message-ID: <146612787853.16048.11239305835199080494.stgit@birch.djwong.org>
In-Reply-To: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
References: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/dinode.c |   55 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)


diff --git a/repair/dinode.c b/repair/dinode.c
index d48e415..9973f3e 100644
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
