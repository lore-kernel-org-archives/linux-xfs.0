Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A77077F52
	for <xfs@oss.sgi.com>; Tue, 30 Apr 2013 06:39:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4B038AC004
	for <xfs@oss.sgi.com>; Tue, 30 Apr 2013 04:39:43 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	RlHNKGSpOlfJvSYB for <xfs@oss.sgi.com>;
	Tue, 30 Apr 2013 04:39:41 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UX8uI-0005sN-Th
	for xfs@oss.sgi.com; Tue, 30 Apr 2013 21:39:38 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UX8uI-0004lL-Po
	for xfs@oss.sgi.com; Tue, 30 Apr 2013 21:39:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/4] xfs: Teach dquot recovery about CONFIG_XFS_QUOTA
Date: Tue, 30 Apr 2013 21:39:33 +1000
Message-Id: <1367321976-18268-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1367321976-18268-1-git-send-email-david@fromorbit.com>
References: <1367321976-18268-1-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Fix a build error when CONFIG_XFS_QUOTA=n:

fs/built-in.o: In function `xlog_recovery_validate_buf_type':
/home/dave/src/build/x86-64/xfsdev/fs/xfs/xfs_log_recover.c:1948: undefined
reference to `xfs_dquot_buf_ops'

Reported-by: Michael L. Semon <mlsemon35@gmail.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log_recover.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 35ac504..ecaa4d4 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1940,12 +1940,18 @@ xlog_recovery_validate_buf_type(
 	case XFS_BLFT_UDQUOT_BUF:
 	case XFS_BLFT_PDQUOT_BUF:
 	case XFS_BLFT_GDQUOT_BUF:
+#ifdef CONFIG_XFS_QUOTA
 		if (magic16 != XFS_DQUOT_MAGIC) {
 			xfs_warn(mp, "Bad DQUOT block magic!");
 			ASSERT(0);
 			break;
 		}
 		bp->b_ops = &xfs_dquot_buf_ops;
+#else
+		xfs_alert(mp,
+	"Trying to recover dquots without QUOTA support built in!");
+		ASSERT(0);
+#endif
 		break;
 	case XFS_BLFT_DINO_BUF:
 		/*
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
