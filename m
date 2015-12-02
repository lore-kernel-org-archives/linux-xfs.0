Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DA8718095
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 05:25:31 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A74DA8F80D0
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 03:25:31 -0800 (PST)
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34]) by
	cuda.sgi.com with ESMTP id H1uPRtKvtbI9OKNz (version=TLSv1
	cipher=DHE-RSA-AES128-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 02 Dec 2015 03:25:30 -0800 (PST)
Received: from epcpsbgr3.samsung.com
	(u143.gpu120.samsung.co.kr [203.254.230.143])
	by mailout4.samsung.com (Oracle Communications Messaging Server
	7.0.5.31.0 64bit (built May  5 2014))
	with ESMTP id <0NYQ02QL5AAYR1C0@mailout4.samsung.com> for
	xfs@oss.sgi.com; Wed, 02 Dec 2015 20:23:22 +0900 (KST)
From: Vivek Trivedi <t.vivek@samsung.com>
Subject: [PATCH 06/11] xfsprogs: xfs_db: check null derefernce after
	block_to_bt
Date: Wed, 02 Dec 2015 16:49:22 +0530
Message-id: <1449055167-19936-7-git-send-email-t.vivek@samsung.com>
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

add assert if block_to_bt returns NULL to avoid null pointer
dereference and get backtrace.
Reported by coverity.

Signed-off-by: Vivek Trivedi <t.vivek@samsung.com>
---
 db/btblock.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/db/btblock.c b/db/btblock.c
index 46140fc..91593f8 100644
--- a/db/btblock.c
+++ b/db/btblock.c
@@ -180,6 +180,7 @@ btblock_key_offset(
 	struct xfs_db_btree	*bt = block_to_bt(block);
 	int			offset;
 
+	ASSERT(bt != NULL);
 	ASSERT(startoff == 0);
 	ASSERT(block->bb_level != 0);
 
@@ -201,6 +202,7 @@ btblock_ptr_offset(
 	int			offset;
 	int			maxrecs;
 
+	ASSERT(bt != NULL);
 	ASSERT(startoff == 0);
 	ASSERT(block->bb_level != 0);
 
@@ -225,6 +227,7 @@ btblock_rec_offset(
 	struct xfs_db_btree	*bt = block_to_bt(block);
 	int			offset;
 
+	ASSERT(bt != NULL);
 	ASSERT(startoff == 0);
 	ASSERT(block->bb_level == 0);
 
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
