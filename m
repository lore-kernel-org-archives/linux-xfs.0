Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4PMDAfj044558 for <xfs@oss.sgi.com>; Tue, 25 May 2010 17:13:10 -0500
Received: from mail-px0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EE708371329
	for <xfs@oss.sgi.com>; Tue, 25 May 2010 15:15:32 -0700 (PDT)
Received: from mail-px0-f181.google.com (mail-px0-f181.google.com
	[209.85.212.181]) by cuda.sgi.com with ESMTP id
	0VSkdCvb6NSOeqjF for <xfs@oss.sgi.com>;
	Tue, 25 May 2010 15:15:32 -0700 (PDT)
Received: by pxi15 with SMTP id 15so2959758pxi.26
	for <xfs@oss.sgi.com>; Tue, 25 May 2010 15:15:31 -0700 (PDT)
From: Huang Weiyi <weiyi.huang@gmail.com>
Subject: [PATCH] xfs: remove duplicated #include
Date: Wed, 26 May 2010 06:15:26 +0800
Message-Id: <1274825726-4364-1-git-send-email-weiyi.huang@gmail.com>
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
To: aelder@sgi.com
Cc: Huang Weiyi <weiyi.huang@gmail.com>, xfs@oss.sgi.com

Remove duplicated #include('s) in
  fs/xfs/linux-2.6/xfs_quotaops.c

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
---
 fs/xfs/linux-2.6/xfs_quotaops.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_quotaops.c b/fs/xfs/linux-2.6/xfs_quotaops.c
index 9ac8aea..067cafb 100644
--- a/fs/xfs/linux-2.6/xfs_quotaops.c
+++ b/fs/xfs/linux-2.6/xfs_quotaops.c
@@ -23,7 +23,6 @@
 #include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_quota.h"
-#include "xfs_log.h"
 #include "xfs_trans.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_inode.h"
-- 
1.6.1.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
