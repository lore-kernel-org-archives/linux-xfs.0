Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DE48C7F58
	for <xfs@oss.sgi.com>; Tue,  3 Sep 2013 13:25:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CDA38304087
	for <xfs@oss.sgi.com>; Tue,  3 Sep 2013 11:25:48 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id GX36YZAVfOkQgPFW for
	<xfs@oss.sgi.com>; Tue, 03 Sep 2013 11:25:48 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r83IPlNs027305
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 3 Sep 2013 14:25:47 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r83IPkRo004538
	for <xfs@oss.sgi.com>; Tue, 3 Sep 2013 14:25:47 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [RFC PATCH 07/11] xfs: retry trans reservation on ENOSPC in
	xfs_inactive()
Date: Tue,  3 Sep 2013 14:25:04 -0400
Message-Id: <1378232708-57156-8-git-send-email-bfoster@redhat.com>
In-Reply-To: <1378232708-57156-1-git-send-email-bfoster@redhat.com>
References: <1378232708-57156-1-git-send-email-bfoster@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

An ifree data block reservation can fail with ENOSPC. Flush inodes
to try and free up space or attempt without a data block
reservation to avoid failing out of xfs_inactive().

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_inode.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 56cbf63..92de4b7 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1779,7 +1779,18 @@ xfs_inactive(
 	tp = xfs_trans_alloc(mp, XFS_TRANS_INACTIVE);
 	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_ifree,
 				  XFS_IFREE_SPACE_RES(mp), 0);
+	if (error == ENOSPC) {
+		/* flush outstanding delalloc blocks and retry */
+		xfs_flush_inodes(mp);
+		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_ifree,
+					  XFS_IFREE_SPACE_RES(mp), 0);
+	}
+	if (error == ENOSPC) {
+		/* resort to a no alloc. reservation */
+		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_ifree, 0, 0);
+	}
 	if (error) {
+		ASSERT(XFS_FORCED_SHUTDOWN(mp));
 		xfs_trans_cancel(tp, 0);
 		goto out_unlock;
 	}
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
