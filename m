Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:57096 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751598AbdLFXtW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Dec 2017 18:49:22 -0500
Date: Wed, 6 Dec 2017 15:49:17 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] libxfs: libxfs_nproc should never return negative numbers
Message-ID: <20171206234917.GM4910@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

Prevent libxfs_nproc from returning a negative/zero CPU count if
platform_nproc happens to error out.

Fixes-coverity-id: 1425909
Fixes-coverity-id: 1425910
Fixes-coverity-id: 1425913
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/init.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/libxfs/init.c b/libxfs/init.c
index a007b3b..302f088 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -910,7 +910,12 @@ libxfs_report(FILE *fp)
 int
 libxfs_nproc(void)
 {
-	return platform_nproc();
+	int	nr;
+
+	nr = platform_nproc();
+	if (nr < 1)
+		nr = 1;
+	return nr;
 }
 
 unsigned long
