Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4036E7F50
	for <xfs@oss.sgi.com>; Sun, 20 Oct 2013 21:56:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 21035304059
	for <xfs@oss.sgi.com>; Sun, 20 Oct 2013 19:56:20 -0700 (PDT)
Received: from mail-bk0-f54.google.com (mail-bk0-f54.google.com
	[209.85.214.54]) by cuda.sgi.com with ESMTP id GeP1COEHl36Fdjd5
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 20 Oct 2013 19:56:17 -0700 (PDT)
Received: by mail-bk0-f54.google.com with SMTP id mz12so506618bkb.41
	for <xfs@oss.sgi.com>; Sun, 20 Oct 2013 19:56:16 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 21 Oct 2013 10:56:15 +0800
Message-ID: <CAPgLHd-Pe_oBza-esdghKzFq5T2-Pj26YSBuEggAC9qR7vAdeg@mail.gmail.com>
Subject: [PATCH -next] xfs: remove duplicated include from xfs_bmap.c
From: Wei Yongjun <weiyj.lk@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: bpm@sgi.com, elder@kernel.org
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove duplicated include.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 fs/xfs/xfs_bmap.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index e6b4202..92b97f7 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -34,7 +34,6 @@
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_btree.h"
-#include "xfs_mount.h"
 #include "xfs_itable.h"
 #include "xfs_inode_item.h"
 #include "xfs_extfree_item.h"

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
