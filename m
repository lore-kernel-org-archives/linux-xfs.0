Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 11 Nov 2007 20:05:30 -0800 (PST)
Received: from itchy (dhcp17.melbourne.sgi.com [134.14.55.17])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lAC45CMH027728
	for <xfs@oss.sgi.com>; Sun, 11 Nov 2007 20:05:16 -0800
From: xaiki@sgi.com
Subject: [[PATCH, RESEND]] V2 inodes per default, and move DFL bits to XFS_DFL_SB_VERSION_BITS,
Date: Mon, 12 Nov 2007 14:48:47 +1100
Message-Id: <1194839329-22003-4-git-send-email-xaiki@sgi.com>
In-Reply-To: <1194839329-22003-3-git-send-email-xaiki@sgi.com>
References: <20071031233516.GB88034736@melbourne.sgi.com>
 <1194839329-22003-1-git-send-email-xaiki@sgi.com>
 <1194839329-22003-2-git-send-email-xaiki@sgi.com>
 <1194839329-22003-3-git-send-email-xaiki@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: Niv Sardi <xaiki@sgi.com>

From: Niv Sardi <xaiki@sgi.com>

Activate XFS_SB_VERSION_NLINKBIT per default, witch will enable V2 INODES.
refactor bits that we want everytime in XFS_DFL_SB_VERSION_BITS.
---
 xfsprogs/mkfs/xfs_mkfs.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/xfsprogs/mkfs/xfs_mkfs.h b/xfsprogs/mkfs/xfs_mkfs.h
index f19f917..9291e33 100644
--- a/xfsprogs/mkfs/xfs_mkfs.h
+++ b/xfsprogs/mkfs/xfs_mkfs.h
@@ -18,17 +18,19 @@
 #ifndef __XFS_MKFS_H__
 #define	__XFS_MKFS_H__
 
+#define XFS_DFL_SB_VERSION_BITS XFS_SB_VERSION_NLINKBIT|XFS_SB_VERSION_EXTFLGBIT
+
 #define XFS_SB_VERSION_MKFS(ia,dia,dir2,log2,attr1,sflag,more) (\
 	((ia)||(dia)||(dir2)||(log2)||(attr1)||(sflag)||(more)) ? \
 	( XFS_SB_VERSION_4 |						\
 		((ia) ? XFS_SB_VERSION_ALIGNBIT : 0) |			\
 		((dia) ? XFS_SB_VERSION_DALIGNBIT : 0) |		\
-	        (XFS_SB_VERSION_EXTFLGBIT) |				\
 		((dir2) ? XFS_SB_VERSION_DIRV2BIT : 0) |		\
 		((log2) ? XFS_SB_VERSION_LOGV2BIT : 0) |		\
 		((attr1) ? XFS_SB_VERSION_ATTRBIT : 0) |		\
 		((sflag) ? XFS_SB_VERSION_SECTORBIT : 0) |		\
 		((more) ? XFS_SB_VERSION_MOREBITSBIT : 0) |		\
+	        XFS_DFL_SB_VERSION_BITS |                               \
 	0 ) : XFS_SB_VERSION_1 )
 
 #define XFS_SB_VERSION2_MKFS(lazycount, attr2, parent) (\
-- 
1.5.3.5
