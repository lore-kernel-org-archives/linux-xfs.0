Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4MHB4h5077318 for <xfs@oss.sgi.com>; Sat, 22 May 2010 12:11:04 -0500
Received: from mail-pw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3CDE7142D386
	for <xfs@oss.sgi.com>; Sat, 22 May 2010 10:13:24 -0700 (PDT)
Received: from mail-pw0-f53.google.com (mail-pw0-f53.google.com
	[209.85.160.53]) by cuda.sgi.com with ESMTP id RWWYS4vYnKDTqEqL
	for <xfs@oss.sgi.com>; Sat, 22 May 2010 10:13:24 -0700 (PDT)
Received: by pwj2 with SMTP id 2so1141909pwj.26
	for <xfs@oss.sgi.com>; Sat, 22 May 2010 10:13:24 -0700 (PDT)
From: Huang Weiyi <weiyi.huang@gmail.com>
Subject: [PATCH 11/12] xfs: xfs_trace.c: remove duplicated #include
Date: Sun, 23 May 2010 01:13:20 +0800
Message-Id: <1274548400-3404-1-git-send-email-weiyi.huang@gmail.com>
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
  fs/xfs/linux-2.6/xfs_trace.c

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
---
 fs/xfs/linux-2.6/xfs_trace.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_trace.c b/fs/xfs/linux-2.6/xfs_trace.c
index 207fa77..d12be84 100644
--- a/fs/xfs/linux-2.6/xfs_trace.c
+++ b/fs/xfs/linux-2.6/xfs_trace.c
@@ -50,7 +50,6 @@
 #include "quota/xfs_dquot_item.h"
 #include "quota/xfs_dquot.h"
 #include "xfs_log_recover.h"
-#include "xfs_buf_item.h"
 #include "xfs_inode_item.h"
 
 /*
-- 
1.6.1.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
