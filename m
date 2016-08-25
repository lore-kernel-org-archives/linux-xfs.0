Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8C9B682BA
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:54:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1108DAC002
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:54:00 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id srZLeCAf0QBoPJ2z (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:53:59 -0700 (PDT)
Subject: [PATCH 68/71] xfs_repair: check the CoW extent size hint
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:53:54 -0700
Message-ID: <147216923461.4420.8008292314107955095.stgit@birch.djwong.org>
In-Reply-To: <147216879156.4420.2446767701729565218.stgit@birch.djwong.org>
References: <147216879156.4420.2446767701729565218.stgit@birch.djwong.org>
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
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
