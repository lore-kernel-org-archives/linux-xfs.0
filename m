Return-Path: <SRS0=IYS1=XL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1144FC49ED7
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Sep 2019 12:16:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DEC47214DE
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Sep 2019 12:16:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732408AbfIPMQj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Sep 2019 08:16:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48596 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731379AbfIPMQj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 16 Sep 2019 08:16:39 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4EE4E89AC6
        for <linux-xfs@vger.kernel.org>; Mon, 16 Sep 2019 12:16:38 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0EB2F5C21A
        for <linux-xfs@vger.kernel.org>; Mon, 16 Sep 2019 12:16:37 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v4 05/11] xfs: refactor cntbt lastblock scan best extent logic into helper
Date:   Mon, 16 Sep 2019 08:16:29 -0400
Message-Id: <20190916121635.43148-6-bfoster@redhat.com>
In-Reply-To: <20190916121635.43148-1-bfoster@redhat.com>
References: <20190916121635.43148-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Mon, 16 Sep 2019 12:16:38 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The cntbt lastblock scan checks the size, alignment, locality, etc.
of each free extent in the block and compares it with the current
best candidate. This logic will be reused by the upcoming optimized
cntbt algorithm, so refactor it into a separate helper.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 113 +++++++++++++++++++++++++++++---------
 fs/xfs/xfs_trace.h        |  25 +++++++++
 2 files changed, 111 insertions(+), 27 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index ee46989ab723..2fa7bb6a00a8 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -791,6 +791,89 @@ xfs_alloc_cur_close(
 	acur->cnt = acur->bnolt = acur->bnogt = NULL;
 }
 
+/*
+ * Check an extent for allocation and track the best available candidate in the
+ * allocation structure. The cursor is deactivated if it has entered an out of
+ * range state based on allocation arguments. Optionally return the extent
+ * extent geometry and allocation status if requested by the caller.
+ */
+static int
+xfs_alloc_cur_check(
+	struct xfs_alloc_arg		*args,
+	struct xfs_alloc_cur		*acur,
+	struct xfs_btree_cur		*cur,
+	int				*new)
+{
+	int			error, i;
+	xfs_agblock_t		bno, bnoa, bnew;
+	xfs_extlen_t		len, lena, diff = -1;
+	bool			busy;
+	unsigned		busy_gen = 0;
+	bool			deactivate = false;
+
+	*new = 0;
+
+	error = xfs_alloc_get_rec(cur, &bno, &len, &i);
+	if (error)
+		return error;
+	XFS_WANT_CORRUPTED_RETURN(args->mp, i == 1);
+
+	/*
+	 * Check minlen and deactivate a cntbt cursor if out of acceptable size
+	 * range (i.e., walking backwards looking for a minlen extent).
+	 */
+	if (len < args->minlen) {
+		deactivate = true;
+		goto out;
+	}
+
+	busy = xfs_alloc_compute_aligned(args, bno, len, &bnoa, &lena,
+					 &busy_gen);
+	acur->busy |= busy;
+	if (busy)
+		acur->busy_gen = busy_gen;
+	/* deactivate a bnobt cursor outside of locality range */
+	if (bnoa < args->min_agbno || bnoa > args->max_agbno)
+		goto out;
+	if (lena < args->minlen)
+		goto out;
+
+	args->len = XFS_EXTLEN_MIN(lena, args->maxlen);
+	xfs_alloc_fix_len(args);
+	ASSERT(args->len >= args->minlen);
+	if (args->len < acur->len)
+		goto out;
+
+	/*
+	 * We have an aligned record that satisfies minlen and beats or matches
+	 * the candidate extent size. Compare locality for near allocation mode.
+	 */
+	ASSERT(args->type == XFS_ALLOCTYPE_NEAR_BNO);
+	diff = xfs_alloc_compute_diff(args->agbno, args->len,
+				      args->alignment, args->datatype,
+				      bnoa, lena, &bnew);
+	if (bnew == NULLAGBLOCK)
+		goto out;
+	if (diff > acur->diff)
+		goto out;
+
+	ASSERT(args->len > acur->len ||
+	       (args->len == acur->len && diff <= acur->diff));
+	acur->rec_bno = bno;
+	acur->rec_len = len;
+	acur->bno = bnew;
+	acur->len = args->len;
+	acur->diff = diff;
+	*new = 1;
+
+out:
+	if (deactivate)
+		cur->bc_private.a.priv.abt.active = false;
+	trace_xfs_alloc_cur_check(args->mp, cur->bc_btnum, bno, len, diff,
+				  *new);
+	return 0;
+}
+
 /*
  * Deal with the case where only small freespaces remain. Either return the
  * contents of the last freespace record, or allocate space from the freelist if
@@ -1257,8 +1340,6 @@ xfs_alloc_ag_vextent_near(
 	 * but we never loop back to the top.
 	 */
 	while (xfs_btree_islastblock(acur.cnt, 0)) {
-		xfs_extlen_t	diff;
-
 #ifdef DEBUG
 		if (dofirst)
 			break;
@@ -1289,38 +1370,16 @@ xfs_alloc_ag_vextent_near(
 		}
 		i = acur.cnt->bc_ptrs[0];
 		for (j = 1;
-		     !error && j && (acur.len < args->maxlen || acur.diff > 0);
+		     !error && j && xfs_alloc_cur_active(acur.cnt) &&
+		     (acur.len < args->maxlen || acur.diff > 0);
 		     error = xfs_btree_increment(acur.cnt, 0, &j)) {
 			/*
 			 * For each entry, decide if it's better than
 			 * the previous best entry.
 			 */
-			error = xfs_alloc_get_rec(acur.cnt, &ltbno, &ltlen, &i);
+			error = xfs_alloc_cur_check(args, &acur, acur.cnt, &i);
 			if (error)
 				goto out;
-			XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, out);
-			acur.busy = xfs_alloc_compute_aligned(args, ltbno, ltlen,
-					&ltbnoa, &ltlena, &acur.busy_gen);
-			if (ltlena < args->minlen)
-				continue;
-			if (ltbnoa < args->min_agbno || ltbnoa > args->max_agbno)
-				continue;
-			args->len = XFS_EXTLEN_MIN(ltlena, args->maxlen);
-			xfs_alloc_fix_len(args);
-			ASSERT(args->len >= args->minlen);
-			if (args->len < acur.len)
-				continue;
-			diff = xfs_alloc_compute_diff(args->agbno, args->len,
-				args->alignment, args->datatype, ltbnoa,
-				ltlena, &ltnew);
-			if (ltnew != NULLAGBLOCK &&
-			    (args->len > acur.len || diff < acur.diff)) {
-				acur.rec_bno = ltbno;
-				acur.rec_len = ltlen;
-				acur.diff = diff;
-				acur.bno = ltnew;
-				acur.len = args->len;
-			}
 		}
 		/*
 		 * It didn't work.  We COULD be in a case where
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index eaae275ed430..b12fad3e45cb 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1663,6 +1663,31 @@ DEFINE_ALLOC_EVENT(xfs_alloc_vextent_noagbp);
 DEFINE_ALLOC_EVENT(xfs_alloc_vextent_loopfailed);
 DEFINE_ALLOC_EVENT(xfs_alloc_vextent_allfailed);
 
+TRACE_EVENT(xfs_alloc_cur_check,
+	TP_PROTO(struct xfs_mount *mp, xfs_btnum_t btnum, xfs_agblock_t bno,
+		 xfs_extlen_t len, xfs_extlen_t diff, bool new),
+	TP_ARGS(mp, btnum, bno, len, diff, new),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_btnum_t, btnum)
+		__field(xfs_agblock_t, bno)
+		__field(xfs_extlen_t, len)
+		__field(xfs_extlen_t, diff)
+		__field(bool, new)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->btnum = btnum;
+		__entry->bno = bno;
+		__entry->len = len;
+		__entry->diff = diff;
+		__entry->new = new;
+	),
+	TP_printk("dev %d:%d btnum %d bno 0x%x len 0x%x diff 0x%x new %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->btnum,
+		  __entry->bno, __entry->len, __entry->diff, __entry->new)
+)
+
 DECLARE_EVENT_CLASS(xfs_da_class,
 	TP_PROTO(struct xfs_da_args *args),
 	TP_ARGS(args),
-- 
2.20.1

