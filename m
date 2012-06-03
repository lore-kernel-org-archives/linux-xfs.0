Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q53BD6pg098357 for <xfs@oss.sgi.com>; Sun, 3 Jun 2012 06:13:06 -0500
Received: from mail-pb0-f53.google.com (mail-pb0-f53.google.com
	[209.85.160.53]) by cuda.sgi.com with ESMTP id HgCdaUwjw3kZ5SYl
	(version=TLSv1 cipher=RC4-MD5 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 03 Jun 2012 04:13:05 -0700 (PDT)
Received: by mail-pb0-f53.google.com with SMTP id rr13so6066284pbb.26
	for <xfs@oss.sgi.com>; Sun, 03 Jun 2012 04:13:05 -0700 (PDT)
From: raghu.prabhu13@gmail.com
Subject: [PATCH 1/3] XFS: Print error when xfs_ialloc_ag_select fails to find
	continuous free space.
Date: Sun,  3 Jun 2012 16:42:47 +0530
Message-Id: <2dabcd19de5dafab66154800d4985dff58343dc0.1338721614.git.rprabhu@wnohang.net>
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

When xfs_ialloc_ag_select fails to find any AG with continuous free blocks for
needed inode allocation, printk error about it once.

Signed-off-by: Raghavendra D Prabhu <rprabhu@wnohang.net>
---
 fs/xfs/xfs_ialloc.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index 177a21a..a02180a 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -543,8 +543,11 @@ nextag:
 		if (agno >= agcount)
 			agno = 0;
 		if (agno == pagno) {
-			if (flags == 0)
+			if (flags == 0) {
+				pr_err_once("XFS (%s): Out of continuous free blocks for inode allocation",
+						mp->m_fsname);
 				return NULL;
+			}
 			flags = 0;
 		}
 	}
-- 
1.7.10.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
