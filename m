Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8BMDJtU162664 for <xfs@oss.sgi.com>; Tue, 11 Sep 2012 17:13:19 -0500
Received: from mail-pb0-f53.google.com (mail-pb0-f53.google.com
	[209.85.160.53]) by cuda.sgi.com with ESMTP id qXgut4l0huItlX4r
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 11 Sep 2012 15:14:23 -0700 (PDT)
Received: by mail-pb0-f53.google.com with SMTP id ro2so1775487pbb.26
	for <xfs@oss.sgi.com>; Tue, 11 Sep 2012 15:14:23 -0700 (PDT)
From: raghu.prabhu13@gmail.com
Subject: [PATCH 3/3] XFS: Print error when unable to allocate inodes or out of
	free inodes.
Date: Wed, 12 Sep 2012 03:43:24 +0530
Message-Id: <93d9b37ce9ad720e14e2f9311e623a8e3e3139f5.1347396641.git.rprabhu@wnohang.net>
In-Reply-To: <cover.1347396641.git.rprabhu@wnohang.net>
References: <cover.1347396641.git.rprabhu@wnohang.net>
In-Reply-To: <cover.1347396641.git.rprabhu@wnohang.net>
References: <cover.1347396641.git.rprabhu@wnohang.net>
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
Cc: Raghavendra D Prabhu <rprabhu@wnohang.net>, Alex Elder <elder@kernel.org>, Ben Myers <bpm@sgi.com>, open list <linux-kernel@vger.kernel.org>

From: Raghavendra D Prabhu <rprabhu@wnohang.net>

When xfs_dialloc is unable to allocate required number of inodes or there are no
AGs with free inodes, printk the error in ratelimited manner.

Signed-off-by: Raghavendra D Prabhu <rprabhu@wnohang.net>
---
 fs/xfs/xfs_ialloc.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index e75a39d..034131b 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -990,8 +990,11 @@ xfs_dialloc(
 				goto out_error;
 
 			xfs_perag_put(pag);
-			*inop = NULLFSINO;
-			return 0;
+
+			xfs_err_ratelimited(mp,
+				"Unable to allocate inodes in AG %d: Required %d, Current %llu, Maximum %llu",
+				agno, XFS_IALLOC_INODES(mp), mp->m_sb.sb_icount, mp->m_maxicount);
+			goto out_spc;
 		}
 
 		if (ialloced) {
@@ -1016,11 +1019,19 @@ nextag:
 		if (++agno == mp->m_sb.sb_agcount)
 			agno = 0;
 		if (agno == start_agno) {
-			*inop = NULLFSINO;
-			return noroom ? ENOSPC : 0;
+			if (noroom) {
+				xfs_err_ratelimited(mp,
+					"Out of AGs with free inodes: Required %d, Current %llu, Maximum %llu",
+					 XFS_IALLOC_INODES(mp), mp->m_sb.sb_icount, mp->m_maxicount);
+				goto out_spc;
+			}
+			return 0;
 		}
 	}
 
+out_spc:
+	*inop = NULLFSINO;
+	return ENOSPC;
 out_alloc:
 	*IO_agbp = NULL;
 	return xfs_dialloc_ag(tp, agbp, parent, inop);
-- 
1.7.12

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
