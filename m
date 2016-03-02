Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E33127CB4
	for <xfs@oss.sgi.com>; Wed,  2 Mar 2016 09:28:39 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A6869304039
	for <xfs@oss.sgi.com>; Wed,  2 Mar 2016 07:28:36 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id nskFujAOOoa5JFBQ (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 02 Mar 2016 07:28:35 -0800 (PST)
From: Mateusz Guzik <mguzik@redhat.com>
Subject: [PATCH] xfs: tidy up xfs_attr_shortform_list
Date: Wed,  2 Mar 2016 16:28:31 +0100
Message-Id: <1456932511-19305-1-git-send-email-mguzik@redhat.com>
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
Cc: Christoph Hellwig <hch@infradead.org>

Remove an unnecessary i == nsbuf test and replace a common label for error
handling after sbuf is allocated.

Signed-off-by: Mateusz Guzik <mguzik@redhat.com>
---
 fs/xfs/xfs_attr_list.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 4fa1482..7129fbc 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -74,7 +74,7 @@ xfs_attr_shortform_list(xfs_attr_list_context_t *context)
 	xfs_attr_sf_entry_t *sfe;
 	xfs_inode_t *dp;
 	int sbsize, nsbuf, count, i;
-	int error;
+	int error = 0;
 
 	ASSERT(context != NULL);
 	dp = context->dp;
@@ -146,8 +146,8 @@ xfs_attr_shortform_list(xfs_attr_list_context_t *context)
 			XFS_CORRUPTION_ERROR("xfs_attr_shortform_list",
 					     XFS_ERRLEVEL_LOW,
 					     context->dp->i_mount, sfe);
-			kmem_free(sbuf);
-			return -EFSCORRUPTED;
+			error = -EFSCORRUPTED;
+			goto out;
 		}
 
 		sbp->entno = i;
@@ -183,10 +183,6 @@ xfs_attr_shortform_list(xfs_attr_list_context_t *context)
 			break;
 		}
 	}
-	if (i == nsbuf) {
-		kmem_free(sbuf);
-		return 0;
-	}
 
 	/*
 	 * Loop putting entries into the user buffer.
@@ -202,17 +198,16 @@ xfs_attr_shortform_list(xfs_attr_list_context_t *context)
 					sbp->namelen,
 					sbp->valuelen,
 					&sbp->name[sbp->namelen]);
-		if (error) {
-			kmem_free(sbuf);
-			return error;
-		}
+		if (error)
+			break;
 		if (context->seen_enough)
 			break;
 		cursor->offset++;
 	}
 
+out:
 	kmem_free(sbuf);
-	return 0;
+	return error;
 }
 
 STATIC int
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
