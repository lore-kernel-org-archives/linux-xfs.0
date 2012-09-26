Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8Q6txlD168193 for <xfs@oss.sgi.com>; Wed, 26 Sep 2012 01:55:59 -0500
Received: from mail-pa0-f53.google.com (mail-pa0-f53.google.com
	[209.85.220.53]) by cuda.sgi.com with ESMTP id MYCe4sbc0iFCzGOE
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 25 Sep 2012 23:57:17 -0700 (PDT)
Received: by mail-pa0-f53.google.com with SMTP id bj3so305745pad.26
	for <xfs@oss.sgi.com>; Tue, 25 Sep 2012 23:57:17 -0700 (PDT)
From: raghu.prabhu13@gmail.com
Subject: [PATCH v3 3/3] xfs: Print error when unable to allocate inodes or out
	of free inodes.
Date: Wed, 26 Sep 2012 12:26:49 +0530
Message-Id: <f0a97d0a46ee8f8bbc42a742274dde7a4c76801b.1348641483.git.rprabhu@wnohang.net>
In-Reply-To: <cover.1348639531.git.rprabhu@wnohang.net>
References: <cover.1348639531.git.rprabhu@wnohang.net>
In-Reply-To: <cover.1348641483.git.rprabhu@wnohang.net>
References: <cover.1348641483.git.rprabhu@wnohang.net>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: bpm@sgi.com, elder@kernel.org, Raghavendra D Prabhu <rprabhu@wnohang.net>

From: Raghavendra D Prabhu <rprabhu@wnohang.net>

When xfs_dialloc is unable to allocate required number of inodes due to global
ceiling, or AGs are out of free inodes but not allowed to allocate inodes or
unable to allocate without continguous free space, printk the error in
ratelimited manner.

Signed-off-by: Raghavendra D Prabhu <rprabhu@wnohang.net>
---
 fs/xfs/xfs_ialloc.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index e75a39d..e9f911b2 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -991,7 +991,7 @@ xfs_dialloc(
 
 			xfs_perag_put(pag);
 			*inop = NULLFSINO;
-			return 0;
+			goto out_spc;
 		}
 
 		if (ialloced) {
@@ -1017,7 +1017,7 @@ nextag:
 			agno = 0;
 		if (agno == start_agno) {
 			*inop = NULLFSINO;
-			return noroom ? ENOSPC : 0;
+			goto out_spc;
 		}
 	}
 
@@ -1027,6 +1027,28 @@ out_alloc:
 out_error:
 	xfs_perag_put(pag);
 	return XFS_ERROR(error);
+out_spc:
+	if (noroom) {
+		xfs_err_ratelimited(mp, "Hit global inode ceiling:");
+		error = ENOSPC;
+	} else if (!okalloc) {
+		/*
+		 * implies noroom=0 && (!pag->pagi_freecount && !okalloc) for
+		 * all pag
+		 */
+		xfs_err_ratelimited(mp,
+			"No AGs with free inodes and allocation not allowed:");
+		error = 0;
+	} else {
+		xfs_err_ratelimited(mp,
+			"Unable to allocate continguous space for inodes:");
+		error = 0;
+	}
+
+	xfs_err_ratelimited(mp, "Required %d, Current %llu, Maximum %llu",
+		XFS_IALLOC_INODES(mp), mp->m_sb.sb_icount, mp->m_maxicount);
+	return error;
+
 }
 
 /*
-- 
1.7.12.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
