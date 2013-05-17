Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C6B297F50
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 00:38:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 60DA8AC04D
	for <xfs@oss.sgi.com>; Thu, 16 May 2013 22:38:58 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id Rvec2hoPzhpRq5g5 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 16 May 2013 22:38:57 -0700 (PDT)
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id r4H5ctum006410
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 05:38:56 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r4H5ct47000266
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 05:38:55 GMT
Received: from abhmt104.oracle.com (abhmt104.oracle.com [141.146.116.56])
	by userz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r4H5ctPD009569 for <xfs@oss.sgi.com>; Fri, 17 May 2013 05:38:55 GMT
Message-ID: <5195C26C.4010406@oracle.com>
Date: Fri, 17 May 2013 13:38:52 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH v2 8/8] xfs: Validate log space at mount time
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
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

From: Jie Liu <jeff.liu@oracle.com>

Validate log space during log mount stage, the underlying function will
drop a warning message via syslog in critical level if the log space is
too small or too large.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_log.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 304b3d0..2a631d9 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -30,6 +30,7 @@
 #include "xfs_alloc_btree.h"
 #include "xfs_ialloc_btree.h"
 #include "xfs_log_recover.h"
+#include "xfs_log_rlimit.h"
 #include "xfs_trans_priv.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
@@ -631,6 +632,17 @@ xfs_log_mount(
 	}
 
 	/*
+	 * Validate the given log space and drop a critical message via syslog
+	 * if the log size is too small that would lead to some unexpected
+	 * situations in transaction log space reservation stage.
+	 * Note: we can't just reject the mount if the validation fails.  This
+	 * would mean that people would have to downgrade their kernel just to
+	 * remedy the situation as there is no way to grow the log (short of
+	 * black magic surgery with xfs_db).
+	 */
+	xfs_log_validate_logspace(mp);
+
+	/*
 	 * Initialize the AIL now we have a log.
 	 */
 	error = xfs_trans_ail_init(mp);
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
