Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:40766 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753870AbeGFDMx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Jul 2018 23:12:53 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w6638vKf176363
        for <linux-xfs@vger.kernel.org>; Fri, 6 Jul 2018 03:12:52 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2130.oracle.com with ESMTP id 2k0dnjg050-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 06 Jul 2018 03:12:52 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w663Cq9B006502
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 6 Jul 2018 03:12:52 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w663Cq5d006336
        for <linux-xfs@vger.kernel.org>; Fri, 6 Jul 2018 03:12:52 GMT
From: Shan Hai <shan.hai@oracle.com>
Subject: [PATCH RFC 8/8] xfs: skip local format inode for reflinking
Date: Fri,  6 Jul 2018 11:12:29 +0800
Message-Id: <1530846750-6686-9-git-send-email-shan.hai@oracle.com>
In-Reply-To: <1530846750-6686-1-git-send-email-shan.hai@oracle.com>
References: <1530846750-6686-1-git-send-email-shan.hai@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The local format inode holds the data inline in its data fork and
has no extents at all, so skip the inode for reflinking.

Signed-off-by: Shan Hai <shan.hai@oracle.com>
---
 fs/xfs/xfs_reflink.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 592fb2071a03..dfb3a85ec0e6 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1507,6 +1507,12 @@ xfs_reflink_inode_has_shared_extents(
 	int				error;
 
 	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
+
+	if (ifp->if_flags & XFS_IFINLINE) {
+		*has_shared = false;
+		return 0;
+	}
+
 	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
 		error = xfs_iread_extents(tp, ip, XFS_DATA_FORK);
 		if (error)
-- 
2.11.0

