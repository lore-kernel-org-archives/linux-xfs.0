Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 12 Nov 2007 20:11:25 -0800 (PST)
Received: from itchy (dhcp17.melbourne.sgi.com [134.14.55.17])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lAD4B9aZ012368
	for <xfs@oss.sgi.com>; Mon, 12 Nov 2007 20:11:11 -0800
From: xaiki@sgi.com
Subject: [PATCH TAKE 2 1/6] Default to log version 2
Date: Tue, 13 Nov 2007 15:10:52 +1100
Message-Id: <1194927057-26415-2-git-send-email-xaiki@sgi.com>
In-Reply-To: <1194927057-26415-1-git-send-email-xaiki@sgi.com>
References: <20071029075657.GA84369978@melbourne.sgi.com>
 <1194927057-26415-1-git-send-email-xaiki@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: Niv Sardi <xaiki@sgi.com>

From: Niv Sardi <xaiki@sgi.com>

Change logversion to 2 in xfs_mkfs.c
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
