Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1080D7F83
	for <xfs@oss.sgi.com>; Thu,  8 Aug 2013 16:53:31 -0500 (CDT)
Date: Thu, 8 Aug 2013 16:53:30 -0500
From: Ben Myers <bpm@sgi.com>
Subject: [PATCH 8/14] xfsprogs: fix issues with e0607266f23
Message-ID: <20130808215330.GV3111@sgi.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
	<20130806214154.GM3111@sgi.com> <20130808210600.GN3111@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130808210600.GN3111@sgi.com>
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
To: xfs@oss.sgi.com
Cc: Eric Sandeen <sandeen@sandeen.net>

A couple of issues found in review.

Signed-off-by: Ben Myers <bpm@sgi.com>

---
 libxfs/xfs_alloc.c |    9 ++-------
 repair/dinode.c    |    9 +++------
 2 files changed, 5 insertions(+), 13 deletions(-)

Index: b/libxfs/xfs_alloc.c
===================================================================
--- a/libxfs/xfs_alloc.c	2013-08-06 14:42:30.200817922 -0500
+++ b/libxfs/xfs_alloc.c	2013-08-06 14:42:39.090877575 -0500
@@ -2173,13 +2173,8 @@ xfs_agf_verify(
 	struct xfs_agf	*agf = XFS_BUF_TO_AGF(bp);
 
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
-	    !uuid_equal(&agf->agf_uuid, &mp->m_sb.sb_uuid)) {
-		char uu[64], uu2[64];
-		platform_uuid_unparse(&agf->agf_uuid, uu);
-		platform_uuid_unparse(&mp->m_sb.sb_uuid, uu2);
-
-			return false;
-	}
+	    !uuid_equal(&agf->agf_uuid, &mp->m_sb.sb_uuid))
+		return false;
 
 	if (!(agf->agf_magicnum == cpu_to_be32(XFS_AGF_MAGIC) &&
 	      XFS_AGF_GOOD_VERSION(be32_to_cpu(agf->agf_versionnum)) &&
Index: b/repair/dinode.c
===================================================================
--- a/repair/dinode.c	2013-08-06 14:43:09.910817602 -0500
+++ b/repair/dinode.c	2013-08-06 14:44:49.660857353 -0500
@@ -182,12 +182,9 @@ clear_dinode_core(struct xfs_mount *mp, 
 		platform_uuid_copy(&dinoc->di_uuid, &mp->m_sb.sb_uuid);
 	}
 
-	for (i = 0; i < 16; i++) {
-		if (dinoc->di_pad[i] != 0) {
-			__dirty_no_modify_ret(dirty);
-			memset(dinoc->di_pad, 0, 16);
-			break;
-		}
+	if (dinoc->di_pad2 != 0) {
+		__dirty_no_modify_ret(dirty);
+		dinoc->di_pad2 = 0;
 	}
 
 	if (be64_to_cpu(dinoc->di_flags2) != 0)  {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
