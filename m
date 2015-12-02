Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1577529E12
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 05:27:00 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E1B988F80CA
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 03:26:59 -0800 (PST)
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25]) by
	cuda.sgi.com with ESMTP id a4NlVTXsU5jr20O5 (version=TLSv1
	cipher=DHE-RSA-AES128-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 02 Dec 2015 03:26:58 -0800 (PST)
Received: from epcpsbgr3.samsung.com
	(u143.gpu120.samsung.co.kr [203.254.230.143])
	by mailout2.samsung.com (Oracle Communications Messaging Server
	7.0.5.31.0 64bit (built May  5 2014))
	with ESMTP id <0NYQ033KKADF65B0@mailout2.samsung.com> for
	xfs@oss.sgi.com; Wed, 02 Dec 2015 20:24:51 +0900 (KST)
From: Vivek Trivedi <t.vivek@samsung.com>
Subject: [PATCH 09/11] xfsprogs: xfs_repair: fix possible null dereference in
	traverse_int_dir2block
Date: Wed, 02 Dec 2015 16:49:25 +0530
Message-id: <1449055167-19936-10-git-send-email-t.vivek@samsung.com>
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

Fix possible null dereference in traverse_int_dir2block if buffer pointer is NULL.
Reported by coverity.

Signed-off-by: Vivek Trivedi <t.vivek@samsung.com>
---
 repair/dir2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/repair/dir2.c b/repair/dir2.c
index 61912d1..fe360dc 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -1300,7 +1300,7 @@ _("block %" PRIu64 " for directory inode %" PRIu64 " is missing\n"),
 		bp = da_read_buf(mp, nex, bmp, &xfs_dir3_data_buf_ops);
 		if (bmp != &lbmp)
 			free(bmp);
-		if (bp == NULL) {
+		if (bp == NULL || !bp->b_addr) {
 			do_warn(
 _("can't read block %" PRIu64 " for directory inode %" PRIu64 "\n"),
 				dbno, ino);
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
