Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8BMDB3q162643 for <xfs@oss.sgi.com>; Tue, 11 Sep 2012 17:13:11 -0500
Received: from mail-pz0-f53.google.com (mail-pz0-f53.google.com
	[209.85.210.53]) by cuda.sgi.com with ESMTP id a5ZJ9VYo7KmP5UFA
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 11 Sep 2012 15:14:15 -0700 (PDT)
Received: by mail-pz0-f53.google.com with SMTP id g9so810705dad.26
	for <xfs@oss.sgi.com>; Tue, 11 Sep 2012 15:14:15 -0700 (PDT)
From: raghu.prabhu13@gmail.com
Subject: [PATCH 2/3] XFS: Print error when xfs_ialloc_ag_select fails to find
	continuous free space.
Date: Wed, 12 Sep 2012 03:43:23 +0530
Message-Id: <b4227a4a67fb7b50bcf83fa369ba8999d3409d64.1347396641.git.rprabhu@wnohang.net>
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
1.7.12

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
