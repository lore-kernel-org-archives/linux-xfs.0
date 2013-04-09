Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 819FC7F9B
	for <xfs@oss.sgi.com>; Tue,  9 Apr 2013 02:33:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 080C8AC002
	for <xfs@oss.sgi.com>; Tue,  9 Apr 2013 00:33:40 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	WXeI7mqpeic0vRkA for <xfs@oss.sgi.com>;
	Tue, 09 Apr 2013 00:33:39 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.76)
	(envelope-from <david@fromorbit.com>) id 1UPT3S-0007tV-7X
	for xfs@oss.sgi.com; Tue, 09 Apr 2013 17:33:22 +1000
Date: Tue, 9 Apr 2013 17:33:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 24/22] xfs: Teach dquot recovery about CONFIG_XFS_QUOTA
Message-ID: <20130409073322.GJ17758@dastard>
References: <1364965892-19623-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1364965892-19623-1-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Fix a build error when CONFIG_XFS_QUOTA=n:

fs/built-in.o: In function `xlog_recovery_validate_buf_type':
/home/dave/src/build/x86-64/xfsdev/fs/xfs/xfs_log_recover.c:1948: undefined
reference to `xfs_dquot_buf_ops'

Reported-by: Michael L. Semon <mlsemon35@gmail.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log_recover.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 35ac504..1b32239 100644
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
