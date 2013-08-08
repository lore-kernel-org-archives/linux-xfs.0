Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 783DE7F91
	for <xfs@oss.sgi.com>; Thu,  8 Aug 2013 17:28:24 -0500 (CDT)
Date: Thu, 8 Aug 2013 17:28:21 -0500
From: Ben Myers <bpm@sgi.com>
Subject: [v2 PATCH 8/14] xfsprogs: fix issues with e0607266f23
Message-ID: <20130808222821.GY3111@sgi.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
	<20130806214154.GM3111@sgi.com> <20130808210600.GN3111@sgi.com>
	<20130808215330.GV3111@sgi.com> <52041686.4040703@sandeen.net>
	<5204183E.2000902@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5204183E.2000902@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

* remove unused uuid unparse in xfs_agf_verify
* fix an unnecessary loop in clear_dinode_core

Signed-off-by: Ben Myers <bpm@sgi.com>

---
[v2: address Eric's suggestions]

Eric,
	Seems like you are correct, we should get this in pronto.
-Ben

 libxfs/xfs_alloc.c |    9 ++-------
 repair/dinode.c    |   10 +++-------
 2 files changed, 5 insertions(+), 14 deletions(-)

Index: b/libxfs/xfs_alloc.c
===================================================================
--- a/libxfs/xfs_alloc.c	2013-08-08 17:23:56.860817670 -0500
+++ b/libxfs/xfs_alloc.c	2013-08-08 17:23:57.800818754 -0500
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
--- a/repair/dinode.c	2013-08-08 17:23:56.870818288 -0500
+++ b/repair/dinode.c	2013-08-08 17:23:57.810818146 -0500
@@ -88,7 +88,6 @@ static int
 clear_dinode_core(struct xfs_mount *mp, xfs_dinode_t *dinoc, xfs_ino_t ino_num)
 {
 	int dirty = 0;
-	int i;
 
 #define __dirty_no_modify_ret(dirty) \
 	({ (dirty) = 1; if (no_modify) return 1; })
@@ -182,12 +181,9 @@ clear_dinode_core(struct xfs_mount *mp, 
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
+		memset(dinoc->di_pad2, 0, sizeof(dinoc->di_pad2));
 	}
 
 	if (be64_to_cpu(dinoc->di_flags2) != 0)  {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
