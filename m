Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 12 Nov 2007 20:11:26 -0800 (PST)
Received: from itchy (dhcp17.melbourne.sgi.com [134.14.55.17])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lAD4B2T5012300
	for <xfs@oss.sgi.com>; Mon, 12 Nov 2007 20:11:04 -0800
From: xaiki@sgi.com
Subject: [PATCH TAKE 2 4/6] V2 inodes per default, and move DFL bits to XFS_DFL_SB_VERSION_BITS,
Date: Tue, 13 Nov 2007 15:10:55 +1100
Message-Id: <1194927057-26415-5-git-send-email-xaiki@sgi.com>
In-Reply-To: <1194927057-26415-4-git-send-email-xaiki@sgi.com>
References: <20071029075657.GA84369978@melbourne.sgi.com>
 <1194927057-26415-1-git-send-email-xaiki@sgi.com>
 <1194927057-26415-2-git-send-email-xaiki@sgi.com>
 <1194927057-26415-3-git-send-email-xaiki@sgi.com>
 <1194927057-26415-4-git-send-email-xaiki@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: Niv Sardi <xaiki@sgi.com>

From: Niv Sardi <xaiki@sgi.com>

Activate XFS_SB_VERSION_NLINKBIT per default, which will enable V2 INODES.
refactor bits that we want everytime in XFS_DFL_SB_VERSION_BITS.
---
 xfsprogs/mkfs/xfs_mkfs.h |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/xfsprogs/mkfs/xfs_mkfs.h b/xfsprogs/mkfs/xfs_mkfs.h
index f19f917..5cc841c 100644
--- a/xfsprogs/mkfs/xfs_mkfs.h
+++ b/xfsprogs/mkfs/xfs_mkfs.h
@@ -18,17 +18,21 @@
 #ifndef __XFS_MKFS_H__
 #define	__XFS_MKFS_H__
 
+#define XFS_DFL_SB_VERSION_BITS \
+                (XFS_SB_VERSION_NLINKBIT | \
+                 XFS_SB_VERSION_EXTFLGBIT)
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
