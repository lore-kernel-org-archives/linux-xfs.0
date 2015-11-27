Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E15897F3F
	for <xfs@oss.sgi.com>; Fri, 27 Nov 2015 11:55:01 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CD8FC304039
	for <xfs@oss.sgi.com>; Fri, 27 Nov 2015 09:55:01 -0800 (PST)
Received: from mail-lf0-f41.google.com (mail-lf0-f41.google.com
	[209.85.215.41]) by cuda.sgi.com with ESMTP id aIPUcEIefxyaiBcw
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 27 Nov 2015 09:55:00 -0800 (PST)
Received: by lffu14 with SMTP id u14so137060136lff.1
	for <xfs@oss.sgi.com>; Fri, 27 Nov 2015 09:54:58 -0800 (PST)
From: Alexander Kuleshov <kuleshovmail@gmail.com>
Subject: [PATCH] xfs/xfs_buf: make xfs_buf_ioend_async() static
Date: Fri, 27 Nov 2015 23:52:29 +0600
Message-Id: <1448646749-18978-1-git-send-email-kuleshovmail@gmail.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Alexander Kuleshov <kuleshovmail@gmail.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

There are no callers of the xfs_buf_ioend_async() function outside
of the fs/xfs/xfs_buf.c. So, let's make it static.

Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
---
 fs/xfs/xfs_buf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 3243cdf..45a8ea7 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1045,7 +1045,7 @@ xfs_buf_ioend_work(
 	xfs_buf_ioend(bp);
 }
 
-void
+static void
 xfs_buf_ioend_async(
 	struct xfs_buf	*bp)
 {
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
