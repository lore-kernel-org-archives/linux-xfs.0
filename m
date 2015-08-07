Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 489627F56
	for <xfs@oss.sgi.com>; Fri,  7 Aug 2015 16:15:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 33C8D8F8052
	for <xfs@oss.sgi.com>; Fri,  7 Aug 2015 14:15:33 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id zPuZBvHECKEW24SS (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 07 Aug 2015 14:15:32 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (Postfix) with ESMTPS id 1902D3BF552
	for <xfs@oss.sgi.com>; Fri,  7 Aug 2015 21:15:32 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-76.bos.redhat.com [10.18.41.76])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t77LFVeW020055
	for <xfs@oss.sgi.com>; Fri, 7 Aug 2015 17:15:31 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 11/12] xfs: fix btree cursor error cleanups
Date: Fri,  7 Aug 2015 17:15:27 -0400
Message-Id: <1438982128-38618-12-git-send-email-bfoster@redhat.com>
In-Reply-To: <1438982128-38618-1-git-send-email-bfoster@redhat.com>
References: <1438982128-38618-1-git-send-email-bfoster@redhat.com>
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

The btree cursor cleanup function takes an error parameter that affects
how buffers are released from the cursor. All buffers are released in
the event of error. Several callers do not specify the XFS_BTREE_ERROR
flag in the event of error, however. This can cause buffers to hang
around locked or with an elevated hold count and thus lead to umount
hangs in the event of errors.

Fix up the xfs_btree_del_cursor() callers to pass XFS_BTREE_ERROR if the
cursor is being torn down due to error.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_ialloc.c | 2 +-
 fs/xfs/xfs_itable.c        | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index ce63e04..54deb2d 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2233,7 +2233,7 @@ xfs_imap_lookup(
 	}
 
 	xfs_trans_brelse(tp, agbp);
-	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+	xfs_btree_del_cursor(cur, error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index f41b0c3..930ebd8 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -473,7 +473,8 @@ xfs_bulkstat(
 		 * pending error, then we are done.
 		 */
 del_cursor:
-		xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+		xfs_btree_del_cursor(cur, error ?
+					  XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
 		xfs_buf_relse(agbp);
 		if (error)
 			break;
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
