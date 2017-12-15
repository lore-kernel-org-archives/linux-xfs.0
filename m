Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:45150 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755449AbdLORLl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Dec 2017 12:11:41 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBFH77HV012866
        for <linux-xfs@vger.kernel.org>; Fri, 15 Dec 2017 17:11:40 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2evj6tr7xw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 15 Dec 2017 17:11:40 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vBFHBdkF015664
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 15 Dec 2017 17:11:39 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vBFHBdkV000657
        for <linux-xfs@vger.kernel.org>; Fri, 15 Dec 2017 17:11:39 GMT
Subject: [PATCH 4/4] xfs: set cowblocks tag for direct cow writes too
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 15 Dec 2017 09:11:37 -0800
Message-ID: <151335789785.26575.9168288718937543398.stgit@magnolia>
In-Reply-To: <151335786780.26575.15542999972223359181.stgit@magnolia>
References: <151335786780.26575.15542999972223359181.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

If a user performs a direct CoW write, we end up loading the CoW fork
with preallocated extents.  Therefore, we must set the cowblocks tag so
that they can be cleared out if we run low on space.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_reflink.c |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index e49e6db..47aea2e 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -454,6 +454,8 @@ xfs_reflink_allocate_cow(
 	if (error)
 		goto out_bmap_cancel;
 
+	xfs_inode_set_cowblocks_tag(ip);
+
 	/* Finish up. */
 	error = xfs_defer_finish(&tp, &dfops);
 	if (error)

