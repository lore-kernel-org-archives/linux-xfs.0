Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:39420 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725892AbfBVQrk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Feb 2019 11:47:40 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x1MGiBN8154826
        for <linux-xfs@vger.kernel.org>; Fri, 22 Feb 2019 16:47:39 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2qp9xugauv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 22 Feb 2019 16:47:38 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x1MGlcaw010924
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 22 Feb 2019 16:47:38 GMT
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x1MGlcTv025192
        for <linux-xfs@vger.kernel.org>; Fri, 22 Feb 2019 16:47:38 GMT
Subject: [PATCH 3/4] xfs_restore: fix unsupported ioctl detection
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 22 Feb 2019 08:47:37 -0800
Message-ID: <155085405698.5141.702624754882653044.stgit@magnolia>
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

Linux ioctls can return ENOTTY or EOPNOTSUPP, so filter both of them
when logging reservation failure.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 restore/dirattr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/restore/dirattr.c b/restore/dirattr.c
index 4257a1b..3fa8fb6 100644
--- a/restore/dirattr.c
+++ b/restore/dirattr.c
@@ -76,7 +76,7 @@ create_filled_file(
 		return fd;
 
 	ret = ioctl(fd, XFS_IOC_RESVSP64, &fl);
-	if (ret && errno != ENOTTY)
+	if (ret && (errno != EOPNOTSUPP && errno != ENOTTY))
 		mlog(MLOG_VERBOSE | MLOG_NOTE,
 _("attempt to reserve %lld bytes for %s using %s failed: %s (%d)\n"),
 				size, pathname, "XFS_IOC_RESVSP64",
