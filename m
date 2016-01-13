Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D53E57F50
	for <xfs@oss.sgi.com>; Wed, 13 Jan 2016 10:15:50 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 54ECDAC00C
	for <xfs@oss.sgi.com>; Wed, 13 Jan 2016 08:15:47 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id vnMMUsOp9WR8G7Oy (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 13 Jan 2016 08:15:45 -0800 (PST)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] xfs: always invalidate buffer in xfs_refcountbt_free_block
Date: Wed, 13 Jan 2016 17:13:49 +0100
Message-Id: <1452701629-11537-2-git-send-email-hch@lst.de>
In-Reply-To: <1452701629-11537-1-git-send-email-hch@lst.de>
References: <1452701629-11537-1-git-send-email-hch@lst.de>
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

Simplify the return value from xfs_perag_pool_free_block to a bool so that
we can easily call xfs_trans_binval for both the per-AG pool and the real
freeing case.  Without this we fail to invalidate the btree buffer and
will trip over the write verifier on a shrinking refcount btree.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_perag_pool.c     | 22 ++++++++++------------
 fs/xfs/libxfs/xfs_perag_pool.h     |  2 +-
 fs/xfs/libxfs/xfs_refcount_btree.c | 20 +++++++-------------
 3 files changed, 18 insertions(+), 26 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_perag_pool.c b/fs/xfs/libxfs/xfs_perag_pool.c
index b49ffd2..41c4e5e 100644
--- a/fs/xfs/libxfs/xfs_perag_pool.c
+++ b/fs/xfs/libxfs/xfs_perag_pool.c
@@ -338,7 +338,7 @@ err:
  * @tp: Transaction to record the free operation.
  * @bno: Block to put back.
  */
-int
+bool
 xfs_perag_pool_free_block(
 	struct xfs_perag_pool		*p,
 	struct xfs_trans		*tp,
@@ -348,7 +348,7 @@ xfs_perag_pool_free_block(
 	struct xfs_perag_pool_entry	*ppe;
 
 	if (p == NULL)
-		return -EINVAL;
+		return false;
 
 	mp = p->pp_mount;
 	mp = mp;
@@ -356,18 +356,12 @@ xfs_perag_pool_free_block(
 
 	list_for_each_entry(ppe, &p->pp_entries, ppe_list) {
 		if (ppe->ppe_bno - 1 == bno) {
-
 			/* Adjust bookkeeping. */
-			p->pp_inuse--;
 			ppe->ppe_bno--;
-			ppe->ppe_len++;
-			return 0;
-		}
-		if (ppe->ppe_bno + ppe->ppe_len == bno) {
-			p->pp_inuse--;
-			ppe->ppe_len++;
-			return 0;
+			goto adjust;
 		}
+		if (ppe->ppe_bno + ppe->ppe_len == bno)
+			goto adjust;
 	}
 	ppe = kmem_alloc(sizeof(struct xfs_perag_pool_entry), KM_SLEEP);
 	ppe->ppe_bno = bno;
@@ -375,5 +369,9 @@ xfs_perag_pool_free_block(
 	p->pp_inuse--;
 
 	list_add_tail(&ppe->ppe_list, &p->pp_entries);
-	return 0;
+	return true;
+adjust:
+	p->pp_inuse--;
+	ppe->ppe_len++;
+	return true;
 }
diff --git a/fs/xfs/libxfs/xfs_perag_pool.h b/fs/xfs/libxfs/xfs_perag_pool.h
index ecdcd2a..665ea16 100644
--- a/fs/xfs/libxfs/xfs_perag_pool.h
+++ b/fs/xfs/libxfs/xfs_perag_pool.h
@@ -43,5 +43,5 @@ int xfs_perag_pool_ensure_capacity(struct xfs_perag_pool *p, xfs_extlen_t sz);
 
 int xfs_perag_pool_alloc_block(struct xfs_perag_pool *p, struct xfs_trans *tp,
 		xfs_agblock_t *bno);
-int xfs_perag_pool_free_block(struct xfs_perag_pool *p, struct xfs_trans *tp,
+bool xfs_perag_pool_free_block(struct xfs_perag_pool *p, struct xfs_trans *tp,
 		xfs_agblock_t bno);
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 2379488..4a31164 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -141,27 +141,21 @@ xfs_refcountbt_free_block(
 	struct xfs_perag	*pag;
 	xfs_fsblock_t		fsbno = XFS_DADDR_TO_FSB(mp, XFS_BUF_ADDR(bp));
 	struct xfs_owner_info	oinfo;
-	int			error;
+	bool			freed;
 
 	/* Try to give it back to the pool. */
 	pag = xfs_perag_get(cur->bc_mp, cur->bc_private.a.agno);
-	error = xfs_perag_pool_free_block(pag->pagf_refcountbt_pool, cur->bc_tp,
+	freed = xfs_perag_pool_free_block(pag->pagf_refcountbt_pool, cur->bc_tp,
 			XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno));
 	xfs_perag_put(pag);
 
-	switch (error) {
-	case 0:
-		return 0;
-	case -EINVAL:
-		break;
-	default:
-		return error;
+	if (!freed) {
+		/* Return it to the AG. */
+		XFS_RMAP_AG_OWNER(&oinfo, XFS_RMAP_OWN_REFC);
+		xfs_bmap_add_free(mp, cur->bc_private.a.flist, fsbno, 1,
+				&oinfo);
 	}
 
-	/* Return it to the AG. */
-	XFS_RMAP_AG_OWNER(&oinfo, XFS_RMAP_OWN_REFC);
-	xfs_bmap_add_free(mp, cur->bc_private.a.flist, fsbno, 1,
-			&oinfo);
 	xfs_trans_binval(tp, bp);
 	return 0;
 }
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
