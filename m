Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=117.135.210.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795656649;
	b=1nj7WImYg5Bg/nHePJowLaLcbDVzg1wV1kxx61+ZhaCtgZVxCw6422kmZ1iYCUHsKmVI
	 dWoenvg2vVP1mKPcej/oLzj6rH8q6T9SCk3WNS7Dc3K38GxU2FaWAX+/r/NurVO0XeBnz
	 QRtNDNJV5em+QJ2CQe+n85QkK5SlH6huKFwAlLy72Y1os+tu/s+cqEETzxo/YG1y6PMJe
	 0N2l+RDumId6al064aCQcpNLe4pZ9+qngLAgBEQ/gUJM8p7g8kwNanHob25mM1C+mOegU
	 vZLedxEiz/SCdQhpaf57xBeSO9q/4LpmESikMN3NEHFtD6TyVmKRyWzGNsiSj8bntlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795656649;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:
	 X-CM-SenderInfo;
	bh=GypcnqFjoNXrJCdnWLV+9/1ab0TYNk9hOLWPR/NLbWs=;
	b=vl3oJZXuhi+9fvmMxC6dbD9vlSDPkt8/1rEH9dAJFQSIFQlwG7rfIT+WSIrhGfJLeQDN
	 iv/BjpH+CA9VrGYn/zh21VCiD2CcjmXU88FfIPbG0epkkDY8104GUMWo6o7vectQZN/Sd
	 m6DNzm/nVbTulZiPBYrFLUbiNT3AT6lTuv9LDPoSWYkdnNM9d6V5Ckr128X6TA/GTiEnv
	 pj8dvNURt1U4QNhVi9RqHQFFerHnQXQCdEZsJ2Y300xQNYeovm/wrLvcOKb3uciZtbWUM
	 so8V7VkB4rfTOkSw5MRrnPo/FUTVx6IkMQH7kWn9QbAWVFklThRqLcYVo9rN/RoM7Jg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=LwqeaRU3;
	arc=none smtp.remote-ip=117.135.210.5
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9AF0606A326;
	Thu, 26 Nov 2026 01:30:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C9AF0606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=LwqeaRU3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Gy
	pcnqFjoNXrJCdnWLV+9/1ab0TYNk9hOLWPR/NLbWs=; b=LwqeaRU3LNYLzlMw8T
	sjr4UyT42S+dqSOTGNtZ3df7f7EdVNK+aVCAbqdB4Bu08xqNcE7ycOb/9rtOG/Nh
	sVkLjp9iJ6QSNp55yaOqCqPhSncvj1Jbiqb0Wcsvhbt7l+fTN0deY5utCWFgG0R+
	YlP2fz07xvt7ttCM5Bv2NQ9go=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wB3VCGhiwdr3Kw5KQ--.18805S4;
	Thu, 26 Nov 2026 09:30:10 +0800 (CST)
From: zhangshida2026@163.com
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhangshida2026@163.com,
	Shida Zhang <zhangshida@kylinos.cn>
Subject: [PATCH v2 2/2] xfs: optimize getfsmap by reusing and advancing the refcount cursor
Date: Thu, 26 Nov 2026 09:30:09 +0800
Message-Id: <20261126013009.533557-3-zhangshida2026@163.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261126013009.533557-1-zhangshida2026@163.com>
References: <20261123075048.3658960-1-zhangshida@kylinos.cn>
 <20261126013009.533557-1-zhangshida2026@163.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wB3VCGhiwdr3Kw5KQ--.18805S4
X-Coremail-Antispam: 1Uf129KBjvJXoW3Ww15WF1xKrWxAw43try7Wrg_yoW3tF4xpF
	ZrtasxKw4ktF92grn7J34jvF4fX34Fyw4rJr9xGas3Z347tr1aqwn5KFyF9FZrCrWfArZF
	qrW5C34rK34S9aDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zRVyIUUUUUU=
X-CM-SenderInfo: x2kd0wxvklvtasqslqqrwthudrp/xtbC5wKns2sHi6Lx0QAA3U

From: Shida Zhang <zhangshida@kylinos.cn>

GETFSMAP walks the rmap btree in increasing startblock order and asks
the refcount btree whether each record's blocks are shared.  For every
record, xfs_getfsmap_is_shared() allocates a refcount cursor and calls
xfs_refcount_find_shared(), which searches the btree from the root.
Both costs are paid per record even though the next query is almost
always the next refcount record.

Keep the refcount cursor in xfs_getfsmap_info for the whole group walk.
Position it once with xfs_refcount_lookup_le(), cache the record it
points at, and advance with xfs_btree_increment() as the rmap walk
moves forward.  Skip COW records and SHARED records that end before the
current block; the first SHARED record ending after it decides: shared
iff it overlaps the query range.  This gives the same answer as
xfs_refcount_find_shared().  The cursor is dropped when the walk leaves
the group, before the AGF buffer is released.

For example, with foo at blocks 10-19, bar a reflink copy of foo, and
baz alone at 20-29, one GETFSMAP call walks three rmap records:

  rmap record     shared?  old code        new code
  10-19 -> foo    yes      alloc + lookup  lookup once, cache
  10-19 -> bar    yes      alloc + lookup  cache hit
  20-29 -> baz    no       alloc + lookup  one step, EOF

A walk over 3000 reflinked files asks the question ~6000 times; the old
code does ~6000 cursor allocs and ~6000 root-to-leaf descents, the new
code one cursor and one descent per group.

Measured with a kernel-isolated FS_IOC_GETFSMAP loop over the whole data
device (3000 reflinked 256KB files, mkfs -m rmapbt=1,reflink=1 -d
agcount=4, Kunpeng 920 + NVMe), mean of three interleaved A/B runs:

                      original    this patch
  walk time           3048 us     324 us   (9.4x)
  xfs_btree_lookup    10.7%       ~0%      (% of cycles)

The cursor alloc/free and root-block get/put are gone too:
_raw_spin_unlock_irqrestore 14.1% -> 1.0%, kmem_cache_alloc 4.5% -> gone.
The full fsmap output is byte-identical before and after (6421 records).

Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
---
 fs/xfs/xfs_fsmap.c | 139 +++++++++++++++++++++++++++++++++++++--------
 1 file changed, 116 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index fe9093c0987..8f5d212bce3 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -13,6 +13,8 @@
 #include "xfs_inode.h"
 #include "xfs_trans.h"
 #include "xfs_btree.h"
+#include "xfs_error.h"
+#include "xfs_health.h"
 #include "xfs_rmap_btree.h"
 #include "xfs_trace.h"
 #include "xfs_rmap.h"
@@ -161,6 +163,9 @@ struct xfs_getfsmap_info {
 	struct xfs_fsmap_head	*head;
 	struct fsmap		*fsmap_recs;	/* mapping records */
 	struct xfs_buf		*agf_bp;	/* AGF, for refcount queries */
+	struct xfs_btree_cur	*refcount_cur;	/* cached refcountbt cursor */
+	struct xfs_refcount_irec rc_cur;	/* current refcount record */
+	bool			rc_eof;		/* refcount cursor past end */
 	struct xfs_group	*group;		/* group info, if applicable */
 	xfs_daddr_t		next_daddr;	/* next daddr we expect */
 	/* daddr of low fsmap key when we're using the rtbitmap */
@@ -205,15 +210,79 @@ xfs_getfsmap_dev_compare(
 /* Delete the btree cursors used by a getfsmap group walk. */
 static void
 xfs_getfsmap_del_cursors(
-	struct xfs_btree_cur	*bt_cur,
-	int			error)
+	struct xfs_getfsmap_info	*info,
+	struct xfs_btree_cur		*bt_cur,
+	int				error)
 {
+	if (info->refcount_cur) {
+		xfs_btree_del_cursor(info->refcount_cur, error < 0 ?
+				XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
+		info->refcount_cur = NULL;
+		info->rc_eof = false;
+	}
 	if (bt_cur)
 		xfs_btree_del_cursor(bt_cur, error < 0 ?
 				XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
 }
 
-/* Decide if this mapping is shared. */
+/*
+ * Allocate the refcount cursor for this group and position it at the last
+ * record at or before agbno, or the first record if there is none.  Set
+ * rc_eof if the btree has no records at or after agbno.
+ */
+static int
+xfs_getfsmap_refcount_init(
+	struct xfs_trans		*tp,
+	struct xfs_getfsmap_info	*info,
+	xfs_agblock_t			agbno)
+{
+	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_btree_cur		*cur;
+	int				have, i, error;
+
+	if (info->group->xg_type == XG_TYPE_RTG)
+		cur = xfs_rtrefcountbt_init_cursor(tp, to_rtg(info->group));
+	else
+		cur = xfs_refcountbt_init_cursor(mp, tp, info->agf_bp,
+				to_perag(info->group));
+	info->refcount_cur = cur;
+
+	error = xfs_refcount_lookup_le(cur, XFS_REFC_DOMAIN_SHARED, agbno,
+			&have);
+	if (error)
+		goto out_error;
+	if (!have) {
+		error = xfs_btree_increment(cur, 0, &have);
+		if (error)
+			goto out_error;
+		if (!have) {
+			info->rc_eof = true;
+			return 0;
+		}
+	}
+	error = xfs_refcount_get_rec(cur, &info->rc_cur, &i);
+	if (error)
+		goto out_error;
+	if (XFS_IS_CORRUPT(mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
+		error = -EFSCORRUPTED;
+		goto out_error;
+	}
+	return 0;
+
+out_error:
+	xfs_getfsmap_del_cursors(info, NULL, error);
+	return error;
+}
+
+/*
+ * Decide if this mapping is shared.
+ *
+ * The rmapbt walk visits records in increasing startblock order, so the
+ * refcount cursor cached in @info only ever advances forward: position it
+ * once per group, then step with xfs_btree_increment() instead of
+ * re-searching from the root for every record.
+ */
 STATIC int
 xfs_getfsmap_is_shared(
 	struct xfs_trans		*tp,
@@ -223,31 +292,55 @@ xfs_getfsmap_is_shared(
 {
 	struct xfs_mount		*mp = tp->t_mountp;
 	struct xfs_btree_cur		*cur;
-	xfs_agblock_t			fbno;
-	xfs_extlen_t			flen = 0;
-	int				error;
+	struct xfs_refcount_irec *rc = &info->rc_cur;
+	xfs_agblock_t			agbno = frec->rec_key;
+	xfs_extlen_t		aglen = XFS_BB_TO_FSBT(mp, frec->len_daddr);
+	int				have, i, error;
 
 	*stat = false;
 	if (!xfs_has_reflink(mp) || !info->group)
 		return 0;
 
-	if (info->group->xg_type == XG_TYPE_RTG)
-		cur = xfs_rtrefcountbt_init_cursor(tp, to_rtg(info->group));
-	else
-		cur = xfs_refcountbt_init_cursor(mp, tp, info->agf_bp,
-				to_perag(info->group));
+	if (info->rc_eof)
+		return 0;
 
-	/* Are there any shared blocks here? */
-	error = xfs_refcount_find_shared(cur, frec->rec_key,
-			XFS_BB_TO_FSBT(mp, frec->len_daddr), &fbno, &flen,
-			false);
+	if (!info->refcount_cur) {
+		error = xfs_getfsmap_refcount_init(tp, info, agbno);
+		if (error)
+			return error;
+		if (info->rc_eof)
+			return 0;
+	}
+	cur = info->refcount_cur;
 
-	xfs_btree_del_cursor(cur, error);
-	if (error)
-		return error;
+	/* Advance to the first SHARED record that ends after agbno. */
+	while (rc->rc_domain != XFS_REFC_DOMAIN_SHARED ||
+	       rc->rc_startblock + rc->rc_blockcount <= agbno) {
+		error = xfs_btree_increment(cur, 0, &have);
+		if (error)
+			goto out_error;
+		if (!have) {
+			info->rc_eof = true;
+			return 0;
+		}
+		error = xfs_refcount_get_rec(cur, &info->rc_cur, &i);
+		if (error)
+			goto out_error;
+		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
+			error = -EFSCORRUPTED;
+			goto out_error;
+		}
+	}
 
-	*stat = flen > 0;
+	/* Shared iff this SHARED record overlaps [agbno, agbno + aglen). */
+	if (rc->rc_startblock < agbno + aglen)
+		*stat = true;
 	return 0;
+
+out_error:
+	xfs_getfsmap_del_cursors(info, NULL, error);
+	return error;
 }
 
 static inline void
@@ -556,7 +649,7 @@ __xfs_getfsmap_datadev(
 		}
 
 		if (bt_cur) {
-			xfs_getfsmap_del_cursors(bt_cur, 0);
+			xfs_getfsmap_del_cursors(info, bt_cur, 0);
 			bt_cur = NULL;
 			xfs_trans_brelse(tp, info->agf_bp);
 			info->agf_bp = NULL;
@@ -596,7 +689,7 @@ __xfs_getfsmap_datadev(
 		info->group = NULL;
 	}
 
-	xfs_getfsmap_del_cursors(bt_cur, error);
+	xfs_getfsmap_del_cursors(info, bt_cur, error);
 	if (info->agf_bp) {
 		xfs_trans_brelse(tp, info->agf_bp);
 		info->agf_bp = NULL;
@@ -998,7 +1091,7 @@ xfs_getfsmap_rtdev_rmapbt(
 			xfs_rtgroup_unlock(to_rtg(bt_cur->bc_group),
 					XFS_RTGLOCK_RMAP |
 					XFS_RTGLOCK_REFCOUNT);
-			xfs_getfsmap_del_cursors(bt_cur, 0);
+			xfs_getfsmap_del_cursors(info, bt_cur, 0);
 			bt_cur = NULL;
 		}
 
@@ -1036,7 +1129,7 @@ xfs_getfsmap_rtdev_rmapbt(
 	if (bt_cur) {
 		xfs_rtgroup_unlock(to_rtg(bt_cur->bc_group),
 				XFS_RTGLOCK_RMAP | XFS_RTGLOCK_REFCOUNT);
-		xfs_getfsmap_del_cursors(bt_cur, error);
+		xfs_getfsmap_del_cursors(info, bt_cur, error);
 	}
 
 	/* loop termination case */
-- 
2.34.1

