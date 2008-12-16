Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBGK8uuN010639
	for <linux-xfs@oss.sgi.com>; Tue, 16 Dec 2008 14:08:56 -0600
Received: from carme.pld-linux.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 365DA27B4F
	for <linux-xfs@oss.sgi.com>; Tue, 16 Dec 2008 12:08:54 -0800 (PST)
Received: from carme.pld-linux.org (carme.pld-linux.org [193.239.45.140]) by
	cuda.sgi.com with ESMTP id FBsLDTSj9YEm1Djl for
	<linux-xfs@oss.sgi.com>; Tue, 16 Dec 2008 12:08:54 -0800 (PST)
From: Arkadiusz Miskiewicz <arekm@maven.pl>
Subject: [PATCH] EXCLUDED_FILE_TYPES: Fix macro for negation case.
Date: Tue, 16 Dec 2008 21:08:21 +0100
Message-Id: <1229458101-80355-1-git-send-email-arekm@maven.pl>
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

Fix EXCLUDED_FILE_TYPES in case when someone will
try to do if (!EXCLUDED_FILE_TYPES()).
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
