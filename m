Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:52012 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726229AbfBVQrc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Feb 2019 11:47:32 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x1MGiL6R159692
        for <linux-xfs@vger.kernel.org>; Fri, 22 Feb 2019 16:47:31 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2qpb5s071p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 22 Feb 2019 16:47:31 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x1MGlVcZ010477
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 22 Feb 2019 16:47:31 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x1MGlVEV016733
        for <linux-xfs@vger.kernel.org>; Fri, 22 Feb 2019 16:47:31 GMT
Subject: [PATCH 2/4] xfs_restore: check return value
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 22 Feb 2019 08:47:30 -0800
Message-ID: <155085405082.5141.12150949924461780415.stgit@magnolia>
In-Reply-To: <155085403848.5141.1866278990901950186.stgit@magnolia>
References: <155085403848.5141.1866278990901950186.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Check the return value of the unlink call when creating a new file.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 restore/dirattr.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/restore/dirattr.c b/restore/dirattr.c
index 0fb2877..4257a1b 100644
--- a/restore/dirattr.c
+++ b/restore/dirattr.c
@@ -67,7 +67,9 @@ create_filled_file(
 	int		fd;
 	int		ret;
 
-	(void)unlink(pathname);
+	ret = unlink(pathname);
+	if (ret && errno != ENOENT)
+		return ret;
 
 	fd = open(pathname, O_RDWR | O_CREAT | O_EXCL, S_IRUSR | S_IWUSR);
 	if (fd < 0)
