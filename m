Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBMGiA2L006529 for <xfs@oss.sgi.com>; Mon, 22 Dec 2008 10:44:10 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 690121775793
	for <xfs@oss.sgi.com>; Mon, 22 Dec 2008 08:44:09 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Ahr4dcZFqmFZ4ydG for
	<xfs@oss.sgi.com>; Mon, 22 Dec 2008 08:44:09 -0800 (PST)
Message-Id: <20081222164408.619124000@bombadil.infradead.org>
References: <20081222163831.755809000@bombadil.infradead.org>
Date: Mon, 22 Dec 2008 11:38:43 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 12/20] EXCLUDED_FILE_TYPES: Fix macro for negation case
Content-Disposition: inline; filename=xfsprogs-quota-fix-macro-bracing
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
To: xfs@oss.sgi.com

From: Arkadiusz Miskiewicz <arekm@maven.pl

Fix EXCLUDED_FILE_TYPES in case when someone will
try to do if (!EXCLUDED_FILE_TYPES()).


Reviewed-by: Christoph Hellwig <hch@lst.de>

---
 xfsprogs/quota/project.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/xfsprogs/quota/project.c b/xfsprogs/quota/project.c
index 7eac8e4..b4171e5 100644
--- a/xfsprogs/quota/project.c
+++ b/xfsprogs/quota/project.c
@@ -31,11 +31,11 @@ enum {
 };
 
 #define EXCLUDED_FILE_TYPES(x) \
-	   S_ISCHR((x)) \
+	   (S_ISCHR((x)) \
 	|| S_ISBLK((x)) \
 	|| S_ISFIFO((x)) \
 	|| S_ISLNK((x)) \
-	|| S_ISSOCK((x))
+	|| S_ISSOCK((x)))
 
 static void
 project_help(void)
-- 
1.6.0.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
