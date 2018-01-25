Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:33254 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751336AbeAYXtC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jan 2018 18:49:02 -0500
Subject: [PATCH 2/2] xfs_db: interpret inode timestamps as signed integers
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Jan 2018 15:48:57 -0800
Message-ID: <151692413760.32390.5793227794979561043.stgit@magnolia>
In-Reply-To: <151692412532.32390.5360363880930671862.stgit@magnolia>
References: <151692412532.32390.5360363880930671862.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The Linux kernel treats core.*time.sec as a signed integer value, so
xfs_db should do likewise, or else files will have inconsistent times
if the seconds count is negative.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/fprint.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/db/fprint.c b/db/fprint.c
index 261a31e..e8eb510 100644
--- a/db/fprint.c
+++ b/db/fprint.c
@@ -147,7 +147,8 @@ fp_time(
 	     i++, bitpos += size) {
 		if (array)
 			dbprintf("%d:", i + base);
-		t=(time_t)getbitval((char *)obj + byteize(bitpos), 0, sizeof(int32_t)*8, 0);
+		t = (time_t)getbitval((char *)obj + byteize(bitpos), 0,
+				sizeof(int32_t) * 8, BVSIGNED);
 		c = ctime(&t);
 		dbprintf("%24.24s", c);
 		if (i < count - 1)

