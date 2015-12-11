Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 65E187F56
	for <xfs@oss.sgi.com>; Fri, 11 Dec 2015 05:11:20 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DA188AC004
	for <xfs@oss.sgi.com>; Fri, 11 Dec 2015 03:11:19 -0800 (PST)
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33]) by
	cuda.sgi.com with ESMTP id IV7qyFC83vXeeeiJ (version=TLSv1
	cipher=DHE-RSA-AES128-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 11 Dec 2015 03:11:17 -0800 (PST)
Received: from epcpsbgr4.samsung.com
	(u144.gpu120.samsung.co.kr [203.254.230.144])
	by mailout3.samsung.com (Oracle Communications Messaging Server
	7.0.5.31.0 64bit (built May  5 2014))
	with ESMTP id <0NZ6014BAXQRFJA0@mailout3.samsung.com> for
	xfs@oss.sgi.com; Fri, 11 Dec 2015 20:11:15 +0900 (KST)
From: Vivek Trivedi <t.vivek@samsung.com>
Subject: [PATCH v2 3/4] xfsprogs: mkfs: fix unintentional integer overflow
Date: Fri, 11 Dec 2015 16:39:02 +0530
Message-id: <1449832143-26356-4-git-send-email-t.vivek@samsung.com>
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

Fix unintentional integer overflow  in mkfs.
reported by coverity.

Signed-off-by: Vivek Trivedi <t.vivek@samsung.com>
---
 mkfs/xfs_mkfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 7cba41a..35dafb4 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2022,7 +2022,7 @@ _("warning: sparse inodes not supported without CRC support, disabled.\n"));
 		 * and the underlying volume is striped, then set rtextblocks
 		 * to the stripe width.
 		 */
-		int		rswidth;
+		__uint64_t	rswidth;
 		__uint64_t	rtextbytes;
 
 		if (!norsflag && !xi.risfile && !(!rtsize && xi.disfile))
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
