Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3QBrprt081886 for <xfs@oss.sgi.com>; Mon, 26 Apr 2010 06:53:51 -0500
Received: from rcsinet10.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5DA002F02CD
	for <xfs@oss.sgi.com>; Mon, 26 Apr 2010 04:55:52 -0700 (PDT)
Received: from rcsinet10.oracle.com (rcsinet10.oracle.com [148.87.113.121]) by
	cuda.sgi.com with ESMTP id xSJsLQl8pIa8LbAT for
	<xfs@oss.sgi.com>; Mon, 26 Apr 2010 04:55:52 -0700 (PDT)
Received: from rcsinet15.oracle.com (rcsinet15.oracle.com [148.87.113.117])
	by rcsinet10.oracle.com (Switch-3.4.2/Switch-3.4.1) with ESMTP id
	o3QBtj4f018815
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 26 Apr 2010 11:55:49 GMT
Received: from acsmt354.oracle.com (acsmt354.oracle.com [141.146.40.154])
	by rcsinet15.oracle.com (Switch-3.4.2/Switch-3.4.1) with ESMTP id
	o3QBFk83032745 for <xfs@oss.sgi.com>; Mon, 26 Apr 2010 11:55:45 GMT
Message-Id: <201004261155.o3QBFk83032745@rcsinet15.oracle.com>
Date: Mon, 26 Apr 2010 19:53:25 +0800
From: Wengang Wang <wen.gang.wang@oracle.com>
Subject: [PATCH] xfsprogs: mkfs manpage -nsize/log
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
Cc: greg.marsden@oracle.com, joe.jin@oracle.com, wen.gang.wang@oracle.com

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 man/man8/mkfs.xfs.8 |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
index 4b147e9..bdaa153 100644
--- a/man/man8/mkfs.xfs.8
+++ b/man/man8/mkfs.xfs.8
@@ -478,6 +478,8 @@ in bytes with
 or as a base two logarithm
 .I value
 .RB "with " log= .
+The block size must be a power of 2 size and cannot be made less than the
+filesystem block size.
 The default size
 .I value
 for version 2 directories is 4096 bytes (4 KiB),
-- 
1.6.6.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
