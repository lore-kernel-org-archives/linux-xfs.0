Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 11 Nov 2007 20:05:27 -0800 (PST)
Received: from itchy (dhcp17.melbourne.sgi.com [134.14.55.17])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lAC45Cb7027727
	for <xfs@oss.sgi.com>; Sun, 11 Nov 2007 20:05:16 -0800
From: xaiki@sgi.com
Subject: [[PATCH, RESEND]] Default to log version 2
Date: Mon, 12 Nov 2007 14:48:44 +1100
Message-Id: <1194839329-22003-1-git-send-email-xaiki@sgi.com>
In-Reply-To: <20071031233516.GB88034736@melbourne.sgi.com>
References: <20071031233516.GB88034736@melbourne.sgi.com>
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
index 6e84a4e..5f3299d 100644
--- a/xfsprogs/mkfs/xfs_mkfs.c
+++ b/xfsprogs/mkfs/xfs_mkfs.c
@@ -686,7 +686,7 @@ main(
 	ilflag = imflag = ipflag = isflag = 0;
 	liflag = laflag = lsflag = ldflag = lvflag = 0;
 	loginternal = 1;
-	logversion = 1;
+	logversion = 2;
 	logagno = logblocks = rtblocks = rtextblocks = 0;
 	Nflag = nlflag = nsflag = nvflag = 0;
 	dirblocklog = dirblocksize = dirversion = 0;
-- 
1.5.3.5
