Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1C4027CAE
	for <xfs@oss.sgi.com>; Thu,  2 Jun 2016 09:19:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CC0B5304067
	for <xfs@oss.sgi.com>; Thu,  2 Jun 2016 07:19:23 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id hKwiPmDWn1ptymqp (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 02 Jun 2016 07:19:21 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/3] xfs: refactor xfs_refcountbt_alloc_block
Date: Thu,  2 Jun 2016 16:19:09 +0200
Message-Id: <1464877150-20457-3-git-send-email-hch@lst.de>
In-Reply-To: <1464877150-20457-1-git-send-email-hch@lst.de>
References: <1464877150-20457-1-git-send-email-hch@lst.de>
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
To: darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

Split out a low level helper that we can use for enabling the reflink
btree at mount time.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_refcount_btree.c | 54 +++++++++++++++++++++++---------------
 1 file changed, 33 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index f83cb4b..7ae3ad7 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -66,49 +66,61 @@ xfs_refcountbt_set_root(
 }
 
 STATIC int
-xfs_refcountbt_alloc_block(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_ptr	*start,
-	union xfs_btree_ptr	*new,
+__xfs_refcountbt_alloc_block(
+	struct xfs_trans	*tp,
+	xfs_agnumber_t		agno,
+	enum xfs_ag_resv_type	resv,
+	__be32			*agbno,
 	int			*stat)
 {
+	struct xfs_mount	*mp = tp->t_mountp;
 	struct xfs_alloc_arg	args;		/* block allocation args */
 	int			error;		/* error return value */
 
-	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
-
 	memset(&args, 0, sizeof(args));
-	args.tp = cur->bc_tp;
-	args.mp = cur->bc_mp;
+	args.tp = tp;
+	args.mp = mp;
 	args.type = XFS_ALLOCTYPE_NEAR_BNO;
-	args.fsbno = XFS_AGB_TO_FSB(cur->bc_mp, cur->bc_private.a.agno,
-			xfs_refc_block(args.mp));
+	args.fsbno = XFS_AGB_TO_FSB(mp, agno, xfs_refc_block(mp));
 	args.firstblock = args.fsbno;
 	xfs_rmap_ag_owner(&args.oinfo, XFS_RMAP_OWN_REFC);
 	args.minlen = args.maxlen = args.prod = 1;
-	args.resv = XFS_AG_RESV_METADATA;
+	args.resv = resv;
 
 	error = xfs_alloc_vextent(&args);
 	if (error)
-		goto out_error;
-	trace_xfs_refcountbt_alloc_block(cur->bc_mp, cur->bc_private.a.agno,
-			args.agbno, 1);
+		return error;
+	trace_xfs_refcountbt_alloc_block(mp, agno, args.agbno, 1);
 	if (args.fsbno == NULLFSBLOCK) {
-		XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
 		*stat = 0;
 		return 0;
 	}
-	ASSERT(args.agno == cur->bc_private.a.agno);
+	ASSERT(args.agno == agno);
 	ASSERT(args.len == 1);
 
-	new->s = cpu_to_be32(args.agbno);
-
-	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+	*agbno = cpu_to_be32(args.agbno);
 	*stat = 1;
 	return 0;
+}
+
+STATIC int
+xfs_refcountbt_alloc_block(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*start,
+	union xfs_btree_ptr	*new,
+	int			*stat)
+{
+	int			error;
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
+
+	error = __xfs_refcountbt_alloc_block(cur->bc_tp, cur->bc_private.a.agno,
+			XFS_AG_RESV_METADATA, &new->s, stat);
+	if (error)
+		XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
+	else
+		XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
 
-out_error:
-	XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
 	return error;
 }
 
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
