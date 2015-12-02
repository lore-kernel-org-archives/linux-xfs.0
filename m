Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E734A805D
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 05:22:41 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BACF78F80CF
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 03:22:38 -0800 (PST)
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34]) by
	cuda.sgi.com with ESMTP id mxW58jzwLSiBSyls (version=TLSv1
	cipher=DHE-RSA-AES128-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 02 Dec 2015 03:22:32 -0800 (PST)
Received: from epcpsbgr3.samsung.com
	(u143.gpu120.samsung.co.kr [203.254.230.143])
	by mailout4.samsung.com (Oracle Communications Messaging Server
	7.0.5.31.0 64bit (built May  5 2014))
	with ESMTP id <0NYQ02QKMA7SSMC0@mailout4.samsung.com> for
	xfs@oss.sgi.com; Wed, 02 Dec 2015 20:21:28 +0900 (KST)
From: Vivek Trivedi <t.vivek@samsung.com>
Subject: [PATCH 02/11] xfsprogs: fix integer overflow in xlog_find_verify_cycle
Date: Wed, 02 Dec 2015 16:49:18 +0530
Message-id: <1449055167-19936-3-git-send-email-t.vivek@samsung.com>
In-reply-to: <1449055167-19936-1-git-send-email-t.vivek@samsung.com>
References: <1449055167-19936-1-git-send-email-t.vivek@samsung.com>
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
Cc: Vivek Trivedi <t.vivek@samsung.com>, a.sahrawat@samsung.com, pankaj.m@samsung.com

Fix unintentional integer overflow in xlog_find_verify_cycle.
Reported by coverity.

Signed-off-by: Vivek Trivedi <t.vivek@samsung.com>
---
 libxlog/xfs_log_recover.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libxlog/xfs_log_recover.c b/libxlog/xfs_log_recover.c
index ef7cf68..73f4d36 100644
--- a/libxlog/xfs_log_recover.c
+++ b/libxlog/xfs_log_recover.c
@@ -254,7 +254,7 @@ xlog_find_verify_cycle(
 	 * try a smaller size.  We need to be able to read at least
 	 * a log sector, or we're out of luck.
 	 */
-	bufblks = 1 << ffs(nbblks);
+	bufblks = (xfs_daddr_t)1 << ffs(nbblks);
 	while (bufblks > log->l_logBBsize)
 		bufblks >>= 1;
 	while (!(bp = xlog_get_bp(log, bufblks))) {
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
