Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 11 Nov 2007 20:05:28 -0800 (PST)
Received: from itchy (dhcp17.melbourne.sgi.com [134.14.55.17])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lAC45CKU027726
	for <xfs@oss.sgi.com>; Sun, 11 Nov 2007 20:05:16 -0800
From: xaiki@sgi.com
Subject: [[PATCH, RESEND]] Default to version 2 attributes.
Date: Mon, 12 Nov 2007 14:48:45 +1100
Message-Id: <1194839329-22003-2-git-send-email-xaiki@sgi.com>
In-Reply-To: <1194839329-22003-1-git-send-email-xaiki@sgi.com>
References: <20071031233516.GB88034736@melbourne.sgi.com>
 <1194839329-22003-1-git-send-email-xaiki@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: Niv Sardi <xaiki@sgi.com>

From: Niv Sardi <xaiki@sgi.com>

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
