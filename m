Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 705B37CA4
	for <xfs@oss.sgi.com>; Wed, 10 Feb 2016 12:35:46 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 65CC68F804C
	for <xfs@oss.sgi.com>; Wed, 10 Feb 2016 10:35:43 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id dTFHk73dLcrzTObs (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 10 Feb 2016 10:35:42 -0800 (PST)
From: Mateusz Guzik <mguzik@redhat.com>
Subject: [PATCH] xfs: fix two memory leaks in xfs_attr_list.c error paths
Date: Wed, 10 Feb 2016 19:35:37 +0100
Message-Id: <1455129337-19255-1-git-send-email-mguzik@redhat.com>
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
Cc: stable@vger.kernel.org

This plugs 2 trivial leaks in xfs_attr_shortform_list and
xfs_attr3_leaf_list_int.

Signed-off-by: Mateusz Guzik <mguzik@redhat.com>
Cc: <stable@vger.kernel.org>

---
 fs/xfs/xfs_attr_list.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 0ef7c2e..4fa1482 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -202,8 +202,10 @@ xfs_attr_shortform_list(xfs_attr_list_context_t *context)
 					sbp->namelen,
 					sbp->valuelen,
 					&sbp->name[sbp->namelen]);
-		if (error)
+		if (error) {
+			kmem_free(sbuf);
 			return error;
+		}
 		if (context->seen_enough)
 			break;
 		cursor->offset++;
@@ -454,14 +456,13 @@ xfs_attr3_leaf_list_int(
 				args.rmtblkcnt = xfs_attr3_rmt_blocks(
 							args.dp->i_mount, valuelen);
 				retval = xfs_attr_rmtval_get(&args);
-				if (retval)
-					return retval;
-				retval = context->put_listent(context,
-						entry->flags,
-						name_rmt->name,
-						(int)name_rmt->namelen,
-						valuelen,
-						args.value);
+				if (!retval)
+					retval = context->put_listent(context,
+							entry->flags,
+							name_rmt->name,
+							(int)name_rmt->namelen,
+							valuelen,
+							args.value);
 				kmem_free(args.value);
 			} else {
 				retval = context->put_listent(context,
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
