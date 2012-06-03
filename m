Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q53BDAqC098372 for <xfs@oss.sgi.com>; Sun, 3 Jun 2012 06:13:10 -0500
Received: from mail-pb0-f53.google.com (mail-pb0-f53.google.com
	[209.85.160.53]) by cuda.sgi.com with ESMTP id 9XXjO4EPuAQzfx0v
	(version=TLSv1 cipher=RC4-MD5 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 03 Jun 2012 04:13:09 -0700 (PDT)
Received: by mail-pb0-f53.google.com with SMTP id rr13so6066284pbb.26
	for <xfs@oss.sgi.com>; Sun, 03 Jun 2012 04:13:09 -0700 (PDT)
From: raghu.prabhu13@gmail.com
Subject: [PATCH 2/3] XFS: Print error when unable to allocate inodes.
Date: Sun,  3 Jun 2012 16:42:48 +0530
Message-Id: <1223a536d5d9722cc80d4edd29449d24284fefc5.1338721614.git.rprabhu@wnohang.net>
In-Reply-To: <cover.1338721614.git.rprabhu@wnohang.net>
References: <cover.1338721614.git.rprabhu@wnohang.net>
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
Cc: Raghavendra D Prabhu <rprabhu@wnohang.net>, raghu.prabhu13@gmail.com

From: Raghavendra D Prabhu <rprabhu@wnohang.net>

When xfs_ialloc_ag_alloc is unable to allocate required number of inodes, printk
error about it once.

Signed-off-by: Raghavendra D Prabhu <rprabhu@wnohang.net>
---
 fs/xfs/xfs_ialloc.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index a02180a..343d7a8 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -744,6 +744,8 @@ xfs_dialloc(
 				xfs_trans_brelse(tp, agbp);
 				if (error == ENOSPC) {
 					*inop = NULLFSINO;
+					pr_err_once("XFS (%s): Unable to allocate inodes: Required %d, Current %llu, Maximum %llu",
+							mp->m_fsname, XFS_IALLOC_INODES(mp), mp->m_sb.sb_icount, mp->m_maxicount);
 					return 0;
 				} else
 					return error;
-- 
1.7.10.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
