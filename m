Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:38358 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751637AbdLKCQ6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Dec 2017 21:16:58 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBB2CgKw010593
        for <linux-xfs@vger.kernel.org>; Mon, 11 Dec 2017 02:16:57 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2esh08r0nv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Mon, 11 Dec 2017 02:16:57 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vBB2Gu6D021202
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 11 Dec 2017 02:16:57 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vBB2Gu3s010293
        for <linux-xfs@vger.kernel.org>; Mon, 11 Dec 2017 02:16:56 GMT
Subject: [PATCH 6/6] xfs: allow CoW remap transactions to use reserve blocks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 10 Dec 2017 18:16:59 -0800
Message-ID: <151295861910.30614.17925324546800268919.stgit@magnolia>
In-Reply-To: <151295857424.30614.8269461794142248028.stgit@magnolia>
References: <151295857424.30614.8269461794142248028.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: darrick.wong@oracle.com

From: Darrick J. Wong <darrick.wong@oracle.com>

Since we as yet have no way of holding on to the indlen blocks that are
reserved as part of CoW fork delalloc reservations, let the CoW remap
transaction dip into the reserves so that we avoid failing writes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_reflink.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 6931b0c..e49e6db 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -729,7 +729,7 @@ xfs_reflink_end_cow(
 			(unsigned int)(end_fsb - offset_fsb),
 			XFS_DATA_FORK);
 	error = xfs_trans_alloc(ip->i_mount, &M_RES(ip->i_mount)->tr_write,
-			resblks, 0, 0, &tp);
+			resblks, 0, XFS_TRANS_RESERVE, &tp);
 	if (error)
 		goto out;
 

