Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 296AF805D
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 05:24:28 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E79368F80D0
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 03:24:27 -0800 (PST)
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33]) by
	cuda.sgi.com with ESMTP id QAmbPG5Z3bGn1cH3 (version=TLSv1
	cipher=DHE-RSA-AES128-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 02 Dec 2015 03:24:25 -0800 (PST)
Received: from epcpsbgr4.samsung.com
	(u144.gpu120.samsung.co.kr [203.254.230.144])
	by mailout3.samsung.com (Oracle Communications Messaging Server
	7.0.5.31.0 64bit (built May  5 2014))
	with ESMTP id <0NYQ02UMQACO8PD0@mailout3.samsung.com> for
	xfs@oss.sgi.com; Wed, 02 Dec 2015 20:24:24 +0900 (KST)
From: Vivek Trivedi <t.vivek@samsung.com>
Subject: [PATCH 08/11] xfsprogs: xfs_repair: fix possible null dereference in
	build_ino_tree
Date: Wed, 02 Dec 2015 16:49:24 +0530
Message-id: <1449055167-19936-9-git-send-email-t.vivek@samsung.com>
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

Fix possible null dereference in build_ino_tree if ino_rec is NULL.
Reported by coverity.

Signed-off-by: Vivek Trivedi <t.vivek@samsung.com>
---
 repair/phase5.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/repair/phase5.c b/repair/phase5.c
index 109e37b..5d95e22 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -1235,7 +1235,7 @@ build_ino_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
 		if (lptr->modulo > 0)
 			lptr->modulo--;
 
-		if (lptr->num_recs_pb > 0)
+		if (lptr->num_recs_pb > 0 && ino_rec)
 			prop_ino_cursor(mp, agno, btree_curs,
 					ino_rec->ino_startnum, 0);
 
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
