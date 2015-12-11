Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3BA927F56
	for <xfs@oss.sgi.com>; Fri, 11 Dec 2015 05:11:03 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 12789304032
	for <xfs@oss.sgi.com>; Fri, 11 Dec 2015 03:11:02 -0800 (PST)
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24]) by
	cuda.sgi.com with ESMTP id V99v2QjQXMzcwl1l (version=TLSv1
	cipher=DHE-RSA-AES128-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 11 Dec 2015 03:11:00 -0800 (PST)
Received: from epcpsbgr3.samsung.com
	(u143.gpu120.samsung.co.kr [203.254.230.143])
	by mailout1.samsung.com (Oracle Communications Messaging Server
	7.0.5.31.0 64bit (built May  5 2014))
	with ESMTP id <0NZ6017DFXQBWSA0@mailout1.samsung.com> for
	xfs@oss.sgi.com; Fri, 11 Dec 2015 20:10:59 +0900 (KST)
From: Vivek Trivedi <t.vivek@samsung.com>
Subject: [PATCH v2 2/4] xfsprogs: fix integer overflow in
	xlog_find_verify_cycle
Date: Fri, 11 Dec 2015 16:39:01 +0530
Message-id: <1449832143-26356-3-git-send-email-t.vivek@samsung.com>
In-reply-to: <1449832143-26356-1-git-send-email-t.vivek@samsung.com>
References: <1449832143-26356-1-git-send-email-t.vivek@samsung.com>
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
index ef7cf68..6116ecd 100644
--- a/libxlog/xfs_log_recover.c
+++ b/libxlog/xfs_log_recover.c
@@ -244,7 +244,7 @@ xlog_find_verify_cycle(
 	xfs_daddr_t	i, j;
 	uint		cycle;
 	xfs_buf_t	*bp;
-	xfs_daddr_t	bufblks;
+	int		bufblks;
 	char		*buf = NULL;
 	int		error = 0;
 
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
