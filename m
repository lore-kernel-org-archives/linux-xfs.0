Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8Q6ttSm168165 for <xfs@oss.sgi.com>; Wed, 26 Sep 2012 01:55:55 -0500
Received: from mail-pb0-f53.google.com (mail-pb0-f53.google.com
	[209.85.160.53]) by cuda.sgi.com with ESMTP id IGFmqEZp8cbI8VvL
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 25 Sep 2012 23:57:12 -0700 (PDT)
Received: by pbcwz12 with SMTP id wz12so1807693pbc.26
	for <xfs@oss.sgi.com>; Tue, 25 Sep 2012 23:57:12 -0700 (PDT)
From: raghu.prabhu13@gmail.com
Subject: [PATCH v3 2/3] xfs: Print error when xfs_ialloc_ag_select fails to
	find continuous free space.
Date: Wed, 26 Sep 2012 12:26:48 +0530
Message-Id: <9acdfb22ee7a1fbf777f866182d01009a3bea879.1348641483.git.rprabhu@wnohang.net>
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

When xfs_ialloc_ag_select fails to find any AG with continuous free blocks
required for inode allocation, printk the error in ratelimited manner.

Signed-off-by: Raghavendra D Prabhu <rprabhu@wnohang.net>
---
 fs/xfs/xfs_ialloc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index 5aceb3f..e75a39d 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -539,8 +539,11 @@ nextag:
 		if (agno >= agcount)
 			agno = 0;
 		if (agno == pagno) {
-			if (flags == 0)
+			if (flags == 0) {
+				xfs_err_ratelimited(mp,
+					"Out of continuous free blocks for inode allocation");
 				return NULLAGNUMBER;
+			}
 			flags = 0;
 		}
 	}
-- 
1.7.12.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
