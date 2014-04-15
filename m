Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 607EE7F3F
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 11:18:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 414B230406B
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 09:18:30 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 1fc2zkB9F4jg90tS for
	<xfs@oss.sgi.com>; Tue, 15 Apr 2014 09:18:29 -0700 (PDT)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s3FGISci002008
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 12:18:28 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s3FGISJD022752
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 12:18:28 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3 3/4] xfs: replace on-stack xfs_trans_res with pointer in
	xfs_create()
Date: Tue, 15 Apr 2014 12:18:25 -0400
Message-Id: <1397578706-5385-4-git-send-email-bfoster@redhat.com>
In-Reply-To: <1397578706-5385-1-git-send-email-bfoster@redhat.com>
References: <1397578706-5385-1-git-send-email-bfoster@redhat.com>
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

There's no need to store a full struct xfs_trans_res on the stack in
xfs_create() and copy the fields. Use a pointer to the appropriate
structures embedded in the xfs_mount.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_inode.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 0e63c7d..f8a232a 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1158,7 +1158,7 @@ xfs_create(
 	struct xfs_dquot	*udqp = NULL;
 	struct xfs_dquot	*gdqp = NULL;
 	struct xfs_dquot	*pdqp = NULL;
-	struct xfs_trans_res	tres;
+	struct xfs_trans_res	*tres;
 	uint			resblks;
 
 	trace_xfs_create(dp, name);
@@ -1181,13 +1181,11 @@ xfs_create(
 	if (is_dir) {
 		rdev = 0;
 		resblks = XFS_MKDIR_SPACE_RES(mp, name->len);
-		tres.tr_logres = M_RES(mp)->tr_mkdir.tr_logres;
-		tres.tr_logcount = XFS_MKDIR_LOG_COUNT;
+		tres = &M_RES(mp)->tr_mkdir;
 		tp = xfs_trans_alloc(mp, XFS_TRANS_MKDIR);
 	} else {
 		resblks = XFS_CREATE_SPACE_RES(mp, name->len);
-		tres.tr_logres = M_RES(mp)->tr_create.tr_logres;
-		tres.tr_logcount = XFS_CREATE_LOG_COUNT;
+		tres = &M_RES(mp)->tr_create;
 		tp = xfs_trans_alloc(mp, XFS_TRANS_CREATE);
 	}
 
@@ -1199,17 +1197,16 @@ xfs_create(
 	 * the case we'll drop the one we have and get a more
 	 * appropriate transaction later.
 	 */
-	tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
-	error = xfs_trans_reserve(tp, &tres, resblks, 0);
+	error = xfs_trans_reserve(tp, tres, resblks, 0);
 	if (error == ENOSPC) {
 		/* flush outstanding delalloc blocks and retry */
 		xfs_flush_inodes(mp);
-		error = xfs_trans_reserve(tp, &tres, resblks, 0);
+		error = xfs_trans_reserve(tp, tres, resblks, 0);
 	}
 	if (error == ENOSPC) {
 		/* No space at all so try a "no-allocation" reservation */
 		resblks = 0;
-		error = xfs_trans_reserve(tp, &tres, 0, 0);
+		error = xfs_trans_reserve(tp, tres, 0, 0);
 	}
 	if (error) {
 		cancel_flags = 0;
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
