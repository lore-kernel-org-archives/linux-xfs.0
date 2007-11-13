Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 12 Nov 2007 20:11:15 -0800 (PST)
Received: from itchy (dhcp17.melbourne.sgi.com [134.14.55.17])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lAD4B2oa012297
	for <xfs@oss.sgi.com>; Mon, 12 Nov 2007 20:11:04 -0800
From: xaiki@sgi.com
Subject: [PATCH TAKE 2 2/6] Default to version 2 attributes.
Date: Tue, 13 Nov 2007 15:10:53 +1100
Message-Id: <1194927057-26415-3-git-send-email-xaiki@sgi.com>
In-Reply-To: <1194927057-26415-2-git-send-email-xaiki@sgi.com>
References: <20071029075657.GA84369978@melbourne.sgi.com>
 <1194927057-26415-1-git-send-email-xaiki@sgi.com>
 <1194927057-26415-2-git-send-email-xaiki@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: Niv Sardi <xaiki@sgi.com>

From: Niv Sardi <xaiki@sgi.com>

Change attrversion from 0 to 2 in xfs_mkfs.c
---
 xfsprogs/mkfs/xfs_mkfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/xfsprogs/mkfs/xfs_mkfs.c b/xfsprogs/mkfs/xfs_mkfs.c
index 5f3299d..b378800 100644
--- a/xfsprogs/mkfs/xfs_mkfs.c
+++ b/xfsprogs/mkfs/xfs_mkfs.c
@@ -677,7 +677,7 @@ main(
 	bindtextdomain(PACKAGE, LOCALEDIR);
 	textdomain(PACKAGE);
 
-	attrversion = 0;
+	attrversion = 2;
 	blflag = bsflag = slflag = ssflag = lslflag = lssflag = 0;
 	blocklog = blocksize = 0;
 	sectorlog = lsectorlog = XFS_MIN_SECTORSIZE_LOG;
-- 
1.5.3.5
