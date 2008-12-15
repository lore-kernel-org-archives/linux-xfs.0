Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBFJxXMK001948
	for <linux-xfs@oss.sgi.com>; Mon, 15 Dec 2008 13:59:33 -0600
Received: from carme.pld-linux.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D31EE1733AD0
	for <linux-xfs@oss.sgi.com>; Mon, 15 Dec 2008 11:59:32 -0800 (PST)
Received: from carme.pld-linux.org (carme.pld-linux.org [193.239.45.140]) by
	cuda.sgi.com with ESMTP id Ag3B2P4ZmD4rUriF for
	<linux-xfs@oss.sgi.com>; Mon, 15 Dec 2008 11:59:32 -0800 (PST)
From: Arkadiusz Miskiewicz <arekm@maven.pl>
Subject: [PATCH 1/1] Include ctype.h for tolower(3).
Date: Mon, 15 Dec 2008 20:59:00 +0100
Message-Id: <1229371140-105409-1-git-send-email-arekm@maven.pl>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-xfs@oss.sgi.com

---
 xfsprogs/libxfs/xfs_dir2.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/xfsprogs/libxfs/xfs_dir2.c b/xfsprogs/libxfs/xfs_dir2.c
index 71134f8..eab4718 100644
--- a/xfsprogs/libxfs/xfs_dir2.c
+++ b/xfsprogs/libxfs/xfs_dir2.c
@@ -17,6 +17,7 @@
  */
 
 #include <xfs.h>
+#include <ctype.h>
 
 struct xfs_name xfs_name_dotdot = {"..", 2};
 
-- 
1.6.0.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
