Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=117.135.210.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795420278;
	b=r9OYS7nNvKRoB1wVfEZqYv1E8c2YujGKptpafhCHmzR3EoD8omLrXOBNhgEXFrkd784W
	 1POETbTotQQgRtNJnXgC6iNqmPpDQFHbSB0IZi3GfzBLPamLtbPKruiCKuoiCuW8fXTjY
	 0CCqmmnifsRHuM+O1krjTxzKsrBsTThSSia/L0fn2eVLUMtiYHsl9eEGAryhyNHp2TPEj
	 EdH4+7Nn8UJ2kSRzkbrJOMhzGOdxI/JguLvPW3z+La3G//aDy3NNhF7T2BcLwh1j+BeOp
	 2RaU+5D1HFyqktJzH5WncO+NVyZ7k6Kfe70ntzAtJJn6TVM9cP8Eqf0A4lRkig1uqhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795420278;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-CM-TRANSID:X-Coremail-Antispam:Sender:X-CM-SenderInfo;
	bh=Wk+Kom02UwBWvecuJrVi4OGzYoOWFszWZtMQo9dw0Rs=;
	b=WoEPE8WSiFCTh3pDaNum6n8NJ6LC4g9uuegJMchwC+Bp2GOi7TXF2lfs/kuDfKLha8TG
	 q3RV1c6O4Lw9hm4GHxkdOlsxLbRQxxtO6ENK+ykOFMGJ+ijy8Nxp/7wlb6FktGEqkWmbG
	 JsY5XY/lDLfcETzUjnki/Povlxqk4QmkbnhUiJRR5urBhmKOwmBsSBkSeE5yvoCEIOl9f
	 yNo9WESHUqzVmrmIAnYOU2qZnT3ysMRNJXLDbHz/uxyrnYFi/Wd6q6MU2EZw6t2mWEqlh
	 OUoCnTAL6miTQjQ7S5yftK38EJju/uo0TlT5T42YunA+cmg0qIoU5prxi85s1t0gAYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kylinos.cn;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=BCtPXayR;
	arc=none smtp.remote-ip=117.135.210.5
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 567CF606A31E;
	Mon, 23 Nov 2026 07:51:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 567CF606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=BCtPXayR
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Wk
	+Kom02UwBWvecuJrVi4OGzYoOWFszWZtMQo9dw0Rs=; b=BCtPXayRIaTkUHbUdi
	RD25TcM8oiTOpJel1wTfq/1ldYeYrhTIW/sueARPq0yZfRzomJuXAVkii/kE2One
	59WaRYNMUaK8mfI/DIYffgMAm0BreiQWVtAQuxnCDiWgTweaArFKhdj54/kt5Gli
	rcILIR0yzTX/v9at6zl0dqjt0=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-1 (Coremail) with SMTP id _____wDnr9JY8ANr8bKXJA--.6097S2;
	Mon, 23 Nov 2026 15:50:48 +0800 (CST)
From: Shida Zhang <zhangshida@kylinos.cn>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	djwong@kernel.org
Subject: [PATCH] xfs: optimize getfsmap by reusing and advancing the refcount cursor
Date: Mon, 23 Nov 2026 15:50:48 +0800
Message-Id: <20261123075048.3658960-1-zhangshida@kylinos.cn>
X-Mailer: git-send-email 2.25.1
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
X-CM-TRANSID:_____wDnr9JY8ANr8bKXJA--.6097S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxtrWftF4kAw4xJFyfZw4kXrb_yoW3tr18pF
	ZrtasxKw48tF1xKrn7A34jqF4rX34rAw4rGr9xG34fZw17tw1aqrn5tFyF9FWUCrWfJrZF
	qF45Cw1Fk3s2vaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jUSdkUUUUU=
Sender: zhangshida2026@163.com
X-CM-SenderInfo: x2kd0wxvklvtasqslqqrwthudrp/xtbC6Bnt+WsD8FnRKAAA3d

GETFSMAP sweeps the whole device: online fsck, dedup scanners and
imaging tools walk thousands of records per call.

Every record pays two costs.  xfs_getfsmap_is_shared() allocates and
frees a refcount btree cursor, and xfs_refcount_find_shared() searches
the refcount btree from the root via xfs_btree_lookup().  A fresh cursor
re-reads the root block each time; the search re-descends root to leaf
even when the answer is the next slot.

Keep one cursor per group and use its position: look up once, cache the
record, then step forward with xfs_btree_increment() instead of
re-searching from the root.  This gives the same answer as
xfs_refcount_find_shared(), with O(1) memory.  The cursor is dropped when
the group changes, before the AGF buffer is released.

One GETFSMAP call asks is_shared() once per rmap record: thousands of
questions per call, all about blocks, never files.

Small example: foo at blocks 10-19, bar a reflink copy of foo, baz alone
at 20-29.  Shared blocks have one rmap record per owner, so one call
walks three records:

  rmap record     answer   old code        new code
  10-19 -> foo    yes      alloc + lookup  lookup once, cache
  10-19 -> bar    yes      alloc + lookup  cache hit
  20-29 -> baz    no       alloc + lookup  one step, EOF

The real workload: one call over 3000 reflinked files walks ~6000
shareable records.  Old code: ~6000 cursor allocs and ~6000 root-to-leaf
descents per call.  New code: one cursor per group, 4 descents (one per
AG), and a cache hit or single forward step per question.

Measured with a kernel-isolated FS_IOC_GETFSMAP loop over the whole data
device (3000 reflinked 256KB files, mkfs -m rmapbt=1,reflink=1 -d
agcount=4, Kunpeng 920 + NVMe), mean of three interleaved A/B runs:

                      original    this patch
  walk time           3048 us     331 us   (9.2x)
  xfs_btree_lookup    8.2%        ~0%      (% of cycles)

The cursor alloc/free and root-block get/put are gone too:
_raw_spin_unlock_irqrestore 16.6% -> 0.8%, kmem_cache_alloc 5.6% -> 1.3%.
The full fsmap output is byte-identical before and after (6217 records).

Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
---
 fs/xfs/xfs_fsmap.c | 120 ++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 103 insertions(+), 17 deletions(-)

Testing: xfstests with rmapbt=1,reflink=1 passes the fsmap/rmap/clone subset
(xfs/271-274, 277, 114, 233, 234, 236, 517, 560, 600, generic/127, 129). The
full fsmap record set is byte-identical before and after.

Not tested: the rtrefcountbt advance path (no RT device on the test box).
It uses the same logic via the rtrefcountbt cursor, and the rtrmap walk is
also sorted.

diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 041bb2105ec..0a6a87c3a02 100644
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
@@ -161,6 +163,10 @@ struct xfs_getfsmap_info {
 	struct xfs_fsmap_head	*head;
 	struct fsmap		*fsmap_recs;	/* mapping records */
 	struct xfs_buf		*agf_bp;	/* AGF, for refcount queries */
+	struct xfs_btree_cur	*refcount_cur;	/* cached refcountbt cursor */
+	struct xfs_refcount_irec	rc_cur;		/* current refcount record */
+	bool			rc_positioned;	/* refcount cursor positioned */
+	bool			rc_eof;		/* refcount cursor past end */
 	struct xfs_group	*group;		/* group info, if applicable */
 	xfs_daddr_t		next_daddr;	/* next daddr we expect */
 	/* daddr of low fsmap key when we're using the rtbitmap */
@@ -202,7 +208,26 @@ xfs_getfsmap_dev_compare(
 	return d1->dev - d2->dev;
 }
 
-/* Decide if this mapping is shared. */
+/* Drop the cached refcount btree cursor when leaving a group. */
+static void
+xfs_getfsmap_put_refcount_cur(
+	struct xfs_getfsmap_info	*info,
+	int				error)
+{
+	if (info->refcount_cur) {
+		xfs_btree_del_cursor(info->refcount_cur, error < 0 ?
+				XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
+		info->refcount_cur = NULL;
+	}
+}
+
+/*
+ * Decide if this mapping is shared.
+ *
+ * The refcount cursor is cached across calls and only advances forward, so
+ * this must be called with non-decreasing agbno (frec->rec_key).  The rmapbt
+ * walk visits records in increasing startblock order, which guarantees it.
+ */
 STATIC int
 xfs_getfsmap_is_shared(
 	struct xfs_trans		*tp,
@@ -212,31 +237,88 @@ xfs_getfsmap_is_shared(
 {
 	struct xfs_mount		*mp = tp->t_mountp;
 	struct xfs_btree_cur		*cur;
-	xfs_agblock_t			fbno;
-	xfs_extlen_t			flen = 0;
-	int				error;
+	xfs_agblock_t			agbno = frec->rec_key;
+	xfs_extlen_t			aglen = XFS_BB_TO_FSBT(mp, frec->len_daddr);
+	int				have, i, error;
 
 	*stat = false;
 	if (!xfs_has_reflink(mp) || !info->group)
 		return 0;
 
-	if (info->group->xg_type == XG_TYPE_RTG)
-		cur = xfs_rtrefcountbt_init_cursor(tp, to_rtg(info->group));
-	else
-		cur = xfs_refcountbt_init_cursor(mp, tp, info->agf_bp,
-				to_perag(info->group));
+	if (!info->refcount_cur) {
+		if (info->group->xg_type == XG_TYPE_RTG)
+			cur = xfs_rtrefcountbt_init_cursor(tp,
+					to_rtg(info->group));
+		else
+			cur = xfs_refcountbt_init_cursor(mp, tp, info->agf_bp,
+					to_perag(info->group));
+		info->refcount_cur = cur;
+		info->rc_positioned = false;
+		info->rc_eof = false;
+	}
+	cur = info->refcount_cur;
+	if (info->rc_eof)
+		return 0;
 
-	/* Are there any shared blocks here? */
-	error = xfs_refcount_find_shared(cur, frec->rec_key,
-			XFS_BB_TO_FSBT(mp, frec->len_daddr), &fbno, &flen,
-			false);
+	/*
+	 * The rmapbt walk visits records in increasing startblock order, so the
+	 * refcount cursor only ever advances forward.  Position it once with a
+	 * full lookup, then advance incrementally rather than re-descending the
+	 * btree from the root for every record.
+	 */
+	if (!info->rc_positioned) {
+		error = xfs_refcount_lookup_le(cur, XFS_REFC_DOMAIN_SHARED, agbno,
+				&have);
+		if (error)
+			goto out_error;
+		if (!have) {
+			error = xfs_btree_increment(cur, 0, &have);
+			if (error)
+				goto out_error;
+			if (!have) {
+				info->rc_eof = true;
+				return 0;
+			}
+		}
+		info->rc_positioned = true;
+		error = xfs_refcount_get_rec(cur, &info->rc_cur, &i);
+		if (error)
+			goto out_error;
+		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
+			error = -EFSCORRUPTED;
+			goto out_error;
+		}
+	}
 
-	xfs_btree_del_cursor(cur, error);
-	if (error)
-		return error;
+	/* Advance to the first SHARED record that ends after agbno. */
+	while (info->rc_cur.rc_domain != XFS_REFC_DOMAIN_SHARED ||
+	       info->rc_cur.rc_startblock + info->rc_cur.rc_blockcount <= agbno) {
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
+	if (info->rc_cur.rc_startblock < agbno + aglen)
+		*stat = true;
 	return 0;
+
+out_error:
+	xfs_getfsmap_put_refcount_cur(info, error);
+	return error;
 }
 
 static inline void
@@ -547,6 +629,7 @@ __xfs_getfsmap_datadev(
 		if (bt_cur) {
 			xfs_btree_del_cursor(bt_cur, XFS_BTREE_NOERROR);
 			bt_cur = NULL;
+			xfs_getfsmap_put_refcount_cur(info, 0);
 			xfs_trans_brelse(tp, info->agf_bp);
 			info->agf_bp = NULL;
 		}
@@ -588,6 +671,7 @@ __xfs_getfsmap_datadev(
 	if (bt_cur)
 		xfs_btree_del_cursor(bt_cur, error < 0 ? XFS_BTREE_ERROR :
 							 XFS_BTREE_NOERROR);
+	xfs_getfsmap_put_refcount_cur(info, error);
 	if (info->agf_bp) {
 		xfs_trans_brelse(tp, info->agf_bp);
 		info->agf_bp = NULL;
@@ -986,6 +1070,7 @@ xfs_getfsmap_rtdev_rmapbt(
 		}
 
 		if (bt_cur) {
+			xfs_getfsmap_put_refcount_cur(info, 0);
 			xfs_rtgroup_unlock(to_rtg(bt_cur->bc_group),
 					XFS_RTGLOCK_RMAP |
 					XFS_RTGLOCK_REFCOUNT);
@@ -1025,6 +1110,7 @@ xfs_getfsmap_rtdev_rmapbt(
 	}
 
 	if (bt_cur) {
+		xfs_getfsmap_put_refcount_cur(info, error);
 		xfs_rtgroup_unlock(to_rtg(bt_cur->bc_group),
 				XFS_RTGLOCK_RMAP | XFS_RTGLOCK_REFCOUNT);
 		xfs_btree_del_cursor(bt_cur, error < 0 ? XFS_BTREE_ERROR :
-- 
2.34.1

