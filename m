Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35826 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754586AbdJLVvy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Oct 2017 17:51:54 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v9CLpqk5006437
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2017 21:51:52 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v9CLppZp011660
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2017 21:51:52 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v9CLppw2001709
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2017 21:51:51 GMT
From: Liu Bo <bo.li.liu@oracle.com>
Subject: [PATCH] xfs_io: report io error for pwrite -W and -w
Date: Thu, 12 Oct 2017 14:49:49 -0600
Message-Id: <20171012204949.8225-1-bo.li.liu@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

When IO error occurs, xfs_io -c "pwrite -W/w" doesn't report errors
while xfs_io -c "pwrite" -c "fsync" does.

This changes "pwrite -W/w" to report errors when it should.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 io/pwrite.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/io/pwrite.c b/io/pwrite.c
index 1c5dfca..71bcccc 100644
--- a/io/pwrite.c
+++ b/io/pwrite.c
@@ -379,11 +379,18 @@ pwrite_f(
 	}
 	if (c < 0)
 		goto done;
-	if (Wflag)
-		fsync(file->fd);
-	if (wflag)
-		fdatasync(file->fd);
+	if (Wflag) {
+		if (fsync(file->fd) < 0) {
+			perror("fsync");
+			goto done;
+		}
+	}
+	if (wflag) {
+		if (fdatasync(file->fd) < 0) {
+			perror("fdatasync");
+			goto done;
+		}
+	}
 	if (qflag)
 		goto done;
 	gettimeofday(&t2, NULL);
-- 
2.9.4

@@ -390,0 +397,0 @@
