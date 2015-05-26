Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 05DBD29DFC
	for <xfs@oss.sgi.com>; Tue, 26 May 2015 17:51:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E8F9A304043
	for <xfs@oss.sgi.com>; Tue, 26 May 2015 15:51:41 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id xklKcwFfzIJZAFuC (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 26 May 2015 15:51:37 -0700 (PDT)
Subject: [PATCH 1/5] xfs_repair: refuse to run if we don't recognize version
	or feature flags
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 26 May 2015 15:51:32 -0700
Message-ID: <20150526225132.26434.82404.stgit@birch.djwong.org>
In-Reply-To: <20150526225126.26434.69010.stgit@birch.djwong.org>
References: <20150526225126.26434.69010.stgit@birch.djwong.org>
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

Apparently xfs_repair running on a v5 filesystem doesn't check the
compat, rocompat, or incompat feature flags for bits that it doesn't
know about, which means that old xfs_repairs can wreak havoc.  So,
strengthen the checks to prevent repair from "repairing" anything it
doesn't understand.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/versions.c |    7 +++++++
 1 file changed, 7 insertions(+)


diff --git a/repair/versions.c b/repair/versions.c
index c1dff72..e60574d 100644
--- a/repair/versions.c
+++ b/repair/versions.c
@@ -141,6 +141,13 @@ parse_sb_version(xfs_sb_t *sb)
 		}
 	}
 
+	/* Look for V5 feature flags we don't know about */
+	if (XFS_SB_VERSION_NUM(sb) >= XFS_SB_VERSION_5 &&
+	    (xfs_sb_has_ro_compat_feature(sb, XFS_SB_FEAT_RO_COMPAT_UNKNOWN) ||
+	     xfs_sb_has_incompat_feature(sb, XFS_SB_FEAT_INCOMPAT_UNKNOWN) ||
+	     xfs_sb_has_compat_feature(sb, XFS_SB_FEAT_COMPAT_UNKNOWN)))
+		issue_warning = 1;
+
 	if (issue_warning)  {
 		do_warn(
 _("This filesystem uses feature(s) not yet supported in this release.\n"

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
