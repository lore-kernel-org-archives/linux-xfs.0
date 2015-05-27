Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 802127F50
	for <xfs@oss.sgi.com>; Wed, 27 May 2015 13:15:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 42A028F8033
	for <xfs@oss.sgi.com>; Wed, 27 May 2015 11:15:22 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id p7PccdenVW0Znzqm (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 27 May 2015 11:15:17 -0700 (PDT)
Date: Wed, 27 May 2015 11:15:03 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v3 1/5] xfs_repair: refuse to run if we don't recognize
	version or feature flags
Message-ID: <20150527181503.GE10175@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150526225132.26434.82404.stgit@birch.djwong.org>
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
To: david@fromorbit.com
Cc: Fanael Linithien <fanael4@gmail.com>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

Apparently xfs_repair running on a v5 filesystem doesn't check the
compat, rocompat, or incompat feature flags for bits that it doesn't
know about, which means that old xfs_repairs can wreak havoc.  So,
strengthen the checks to prevent repair from "repairing" anything it
doesn't understand.

v2: Move the complaint code after the version number check, and print
the actual feature bits that we don't recognize.

v3: Fix some copy-pasta errors, and simpify the warning messages.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/versions.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/repair/versions.c b/repair/versions.c
index c1dff72..10bcd29 100644
--- a/repair/versions.c
+++ b/repair/versions.c
@@ -175,6 +175,20 @@ _("WARNING:  you have disallowed superblock-feature-bits-allowed\n"
 		}
 	}
 
+	/* Look for V5 feature flags we don't know about */
+	if (XFS_SB_VERSION_NUM(sb) >= XFS_SB_VERSION_5 &&
+	    (xfs_sb_has_compat_feature(sb, XFS_SB_FEAT_COMPAT_UNKNOWN) ||
+	     xfs_sb_has_ro_compat_feature(sb, XFS_SB_FEAT_RO_COMPAT_UNKNOWN) ||
+	     xfs_sb_has_incompat_feature(sb, XFS_SB_FEAT_INCOMPAT_UNKNOWN))) {
+		do_warn(
+_("Superblock has unknown compat/rocompat/incompat features (0x%x/0x%x/0x%x).\n"
+  "Using a more recent xfs_repair is recommended.\n"),
+			sb->sb_features_compat & XFS_SB_FEAT_COMPAT_UNKNOWN,
+			sb->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_UNKNOWN,
+			sb->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_UNKNOWN);
+		return 1;
+	}
+
 	if (xfs_sb_version_hasattr(sb))  {
 		if (!fs_attributes_allowed)  {
 			if (!no_modify)  {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
