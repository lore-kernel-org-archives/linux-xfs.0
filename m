Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C80A77CA0
	for <xfs@oss.sgi.com>; Fri, 25 Mar 2016 13:05:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3B566AC002
	for <xfs@oss.sgi.com>; Fri, 25 Mar 2016 11:05:16 -0700 (PDT)
Received: from mail-pf0-f177.google.com (mail-pf0-f177.google.com
	[209.85.192.177]) by cuda.sgi.com with ESMTP id
	XNF8zfRVHaSAqDfF (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 25 Mar 2016 11:05:09 -0700 (PDT)
Received: by mail-pf0-f177.google.com with SMTP id x3so87267626pfb.1
	for <xfs@oss.sgi.com>; Fri, 25 Mar 2016 11:05:09 -0700 (PDT)
From: Eryu Guan <guaneryu@gmail.com>
Subject: [PATCH] xfs: mute some sparse warnings
Date: Sat, 26 Mar 2016 02:04:02 +0800
Message-Id: <1458929042-23991-1-git-send-email-guaneryu@gmail.com>
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
Cc: Eryu Guan <guaneryu@gmail.com>

These three warnings are fixed:

fs/xfs/xfs_inode.c:1033:44: warning: Using plain integer as NULL pointer
fs/xfs/xfs_inode_item.c:525:20: warning: context imbalance in 'xfs_inode_item_push' - unexpected unlock
fs/xfs/xfs_dquot.c:696:1: warning: symbol 'xfs_dq_get_next_id' was not declared. Should it be static?

Signed-off-by: Eryu Guan <guaneryu@gmail.com>
---
 fs/xfs/xfs_dquot.c      | 2 +-
 fs/xfs/xfs_inode.c      | 2 +-
 fs/xfs/xfs_inode_item.c | 3 ++-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 316b2a1..8f51370 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -692,7 +692,7 @@ error0:
  * end of the chunk, skip ahead to first id in next allocated chunk
  * using the SEEK_DATA interface.
  */
-int
+static int
 xfs_dq_get_next_id(
 	xfs_mount_t		*mp,
 	uint			type,
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 96f606d..1445a99 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1030,7 +1030,7 @@ xfs_dir_ialloc(
 			tp->t_flags &= ~(XFS_TRANS_DQ_DIRTY);
 		}
 
-		code = xfs_trans_roll(&tp, 0);
+		code = xfs_trans_roll(&tp, NULL);
 		if (committed != NULL)
 			*committed = 1;
 
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index c48b5b1..e91c1e6 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -478,7 +478,8 @@ xfs_inode_item_unpin(
 STATIC uint
 xfs_inode_item_push(
 	struct xfs_log_item	*lip,
-	struct list_head	*buffer_list)
+	struct list_head	*buffer_list) __releases(&lip->li_ailp->xa_lock)
+					      __acquires(&lip->li_ailp->xa_lock)
 {
 	struct xfs_inode_log_item *iip = INODE_ITEM(lip);
 	struct xfs_inode	*ip = iip->ili_inode;
-- 
2.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
