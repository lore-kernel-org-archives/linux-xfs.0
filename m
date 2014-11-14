Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 555B37F3F
	for <xfs@oss.sgi.com>; Fri, 14 Nov 2014 10:37:29 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 42E4A8F8039
	for <xfs@oss.sgi.com>; Fri, 14 Nov 2014 08:37:26 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id x4DMjloKpTMFxXwM (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 14 Nov 2014 08:17:10 -0800 (PST)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id sAEGH9JG007842
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Fri, 14 Nov 2014 11:17:09 -0500
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id sAEGH8WR012329
	for <xfs@oss.sgi.com>; Fri, 14 Nov 2014 11:17:08 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 1/3] xfs: replace on-stack xfs_trans_res with pointer in
	xfs_create()
Date: Fri, 14 Nov 2014 11:17:05 -0500
Message-Id: <1415981827-52993-2-git-send-email-bfoster@redhat.com>
In-Reply-To: <1415981827-52993-1-git-send-email-bfoster@redhat.com>
References: <1415981827-52993-1-git-send-email-bfoster@redhat.com>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_inode.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 8ed049d..2ffb802 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1082,7 +1082,7 @@ xfs_create(
 	struct xfs_dquot	*udqp = NULL;
 	struct xfs_dquot	*gdqp = NULL;
 	struct xfs_dquot	*pdqp = NULL;
-	struct xfs_trans_res	tres;
+	struct xfs_trans_res	*tres;
 	uint			resblks;
 
 	trace_xfs_create(dp, name);
@@ -1105,13 +1105,11 @@ xfs_create(
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
 
@@ -1123,17 +1121,16 @@ xfs_create(
 	 * the case we'll drop the one we have and get a more
 	 * appropriate transaction later.
 	 */
-	tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
-	error = xfs_trans_reserve(tp, &tres, resblks, 0);
+	error = xfs_trans_reserve(tp, tres, resblks, 0);
 	if (error == -ENOSPC) {
 		/* flush outstanding delalloc blocks and retry */
 		xfs_flush_inodes(mp);
-		error = xfs_trans_reserve(tp, &tres, resblks, 0);
+		error = xfs_trans_reserve(tp, tres, resblks, 0);
 	}
 	if (error == -ENOSPC) {
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
