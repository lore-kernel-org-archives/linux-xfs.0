Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 26 Aug 2006 10:07:45 -0700 (PDT)
Received: from mailout.stusta.mhn.de (emailhub.stusta.mhn.de [141.84.69.5])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k7QH7RDW005103
	for <xfs@oss.sgi.com>; Sat, 26 Aug 2006 10:07:27 -0700
Date: Sat, 26 Aug 2006 17:06:55 +0200
From: Adrian Bunk <bunk@stusta.de>
Subject: [2.6 patch] fs/xfs/xfs_bmap.c:xfs_bmapi(): fix a bug
Message-ID: <20060826150654.GE4765@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nathan Scott <nathans@sgi.com>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org

This patch fixes the following bug introduced by commit 
39269e29d4aad04252e0debec4c9b01bac16a257:

Since bma.conv is a char and XFS_BMAPI_CONVERT is 0x1000, bma.conv was 
always assigned zero.

Spotted by the GNU C compiler (SVN version).

Signed-off-by: Adrian Bunk <bunk@stusta.de>

--- linux-2.6.18-rc4-mm2/fs/xfs/xfs_bmap.c.old	2006-08-26 03:31:23.000000000 +0200
+++ linux-2.6.18-rc4-mm2/fs/xfs/xfs_bmap.c	2006-08-26 03:31:28.000000000 +0200
@@ -4993,7 +4993,7 @@ xfs_bmapi(
 				bma.firstblock = *firstblock;
 				bma.alen = alen;
 				bma.off = aoff;
-				bma.conv = (flags & XFS_BMAPI_CONVERT);
+				bma.conv = !!(flags & XFS_BMAPI_CONVERT);
 				bma.wasdel = wasdelay;
 				bma.minlen = minlen;
 				bma.low = flist->xbf_low;
