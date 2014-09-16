Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 19FF87F47
	for <xfs@oss.sgi.com>; Tue, 16 Sep 2014 12:43:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id ECBE78F8035
	for <xfs@oss.sgi.com>; Tue, 16 Sep 2014 10:43:10 -0700 (PDT)
Received: from mailrelay005.isp.belgacom.be (mailrelay005.isp.belgacom.be
	[195.238.6.171]) by cuda.sgi.com with ESMTP id L7IXi6x26cV80WIv
	for <xfs@oss.sgi.com>; Tue, 16 Sep 2014 10:43:09 -0700 (PDT)
From: Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 1/1] xfs: remove second xfs_quota.h inclusion in xfs_icache.c
Date: Tue, 16 Sep 2014 19:42:24 +0200
Message-Id: <1410889344-28339-1-git-send-email-fabf@skynet.be>
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
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, xfs@oss.sgi.com

xfs_quota.h was included twice.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/xfs/xfs_icache.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 981b2cf..b45f7b2 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -33,7 +33,6 @@
 #include "xfs_trace.h"
 #include "xfs_icache.h"
 #include "xfs_bmap_util.h"
-#include "xfs_quota.h"
 #include "xfs_dquot_item.h"
 #include "xfs_dquot.h"
 
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
