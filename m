Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 05F1C29DFD
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 05:26:25 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8F24BAC005
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 03:26:24 -0800 (PST)
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33]) by
	cuda.sgi.com with ESMTP id i4OUzGaqVX08ELsd (version=TLSv1
	cipher=DHE-RSA-AES128-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 02 Dec 2015 03:26:22 -0800 (PST)
Received: from epcpsbgr3.samsung.com
	(u143.gpu120.samsung.co.kr [203.254.230.143])
	by mailout3.samsung.com (Oracle Communications Messaging Server
	7.0.5.31.0 64bit (built May  5 2014))
	with ESMTP id <0NYQ02TFIAE6GUD0@mailout3.samsung.com> for
	xfs@oss.sgi.com; Wed, 02 Dec 2015 20:25:18 +0900 (KST)
From: Vivek Trivedi <t.vivek@samsung.com>
Subject: [PATCH 10/11] xfsprogs: fix possible null pointer dereference in
	xfs_iformat_extents
Date: Wed, 02 Dec 2015 16:49:26 +0530
Message-id: <1449055167-19936-11-git-send-email-t.vivek@samsung.com>
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

Fix possible null pointer dereference in xfs_iformat_extents and
xfs_iext_get_ext if fail to locate inode record.
Reported by coverity.

Signed-off-by: Vivek Trivedi <t.vivek@samsung.com>
---
 libxfs/xfs_inode_fork.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index e1968b4..36aa0c8 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -331,6 +331,8 @@ xfs_iformat_extents(
 		xfs_validate_extents(ifp, nex, XFS_EXTFMT_INODE(ip));
 		for (i = 0; i < nex; i++, dp++) {
 			xfs_bmbt_rec_host_t *ep = xfs_iext_get_ext(ifp, i);
+			if (!ep)
+				return -EFSCORRUPTED;
 			ep->l0 = get_unaligned_be64(&dp->l0);
 			ep->l1 = get_unaligned_be64(&dp->l1);
 		}
@@ -890,6 +892,8 @@ xfs_iext_get_ext(
 		xfs_extnum_t	page_idx = idx;	/* ext index in target list */
 
 		erp = xfs_iext_idx_to_irec(ifp, &page_idx, &erp_idx, 0);
+		if (!erp)
+			return NULL;
 		return &erp->er_extbuf[page_idx];
 	} else if (ifp->if_bytes) {
 		return &ifp->if_u1.if_extents[idx];
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
