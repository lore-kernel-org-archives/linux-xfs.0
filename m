Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B90027F56
	for <xfs@oss.sgi.com>; Fri, 11 Dec 2015 05:11:36 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AB25F304032
	for <xfs@oss.sgi.com>; Fri, 11 Dec 2015 03:11:36 -0800 (PST)
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34]) by
	cuda.sgi.com with ESMTP id LtGN1GJABQAkZWhM (version=TLSv1
	cipher=DHE-RSA-AES128-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 11 Dec 2015 03:11:34 -0800 (PST)
Received: from epcpsbgr3.samsung.com
	(u143.gpu120.samsung.co.kr [203.254.230.143])
	by mailout4.samsung.com (Oracle Communications Messaging Server
	7.0.5.31.0 64bit (built May  5 2014))
	with ESMTP id <0NZ600LX4XR89880@mailout4.samsung.com> for
	xfs@oss.sgi.com; Fri, 11 Dec 2015 20:11:32 +0900 (KST)
From: Vivek Trivedi <t.vivek@samsung.com>
Subject: [PATCH v2 4/4] xfsprogs: xfsdb: remove unnessary checks in
	process_leaf_node_dir_v2_free
Date: Fri, 11 Dec 2015 16:39:03 +0530
Message-id: <1449832143-26356-5-git-send-email-t.vivek@samsung.com>
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

xfs_dir2_free_hdr_t entries are unsigned, so they can't be negative.
remove these unnessary checks in process_leaf_node_dir_v2_free.
Reported by coverity.

Signed-off-by: Vivek Trivedi <t.vivek@samsung.com>
---
 db/check.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/db/check.c b/db/check.c
index 9c1541d..9d986b9 100644
--- a/db/check.c
+++ b/db/check.c
@@ -3073,9 +3073,7 @@ process_leaf_node_dir_v3_free(
 		return;
 	}
 	if (be32_to_cpu(free->hdr.nvalid) > maxent || 
-				be32_to_cpu(free->hdr.nvalid) < 0 ||
 				be32_to_cpu(free->hdr.nused) > maxent || 
-				be32_to_cpu(free->hdr.nused) < 0 ||
 				be32_to_cpu(free->hdr.nused) > 
 					be32_to_cpu(free->hdr.nvalid)) {
 		if (!sflag || v)
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
