Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8FA830ACE6
	for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2026 06:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791871335; cv=none; b=RAkRx7J/N66Vxh5UvJGzJl28mjoa1ODDPGf+8leesx3naKpNf7kaP/xVfrnti2ijFOsj+7WqDdR5TSiHcW1XbAS93SmUIXKYSftPQ53clqrTxqoTemV1OFfG9P6+Jp+S63R4rJGgS+DOH12oVy+NfpsNUumOruBKO+h7Opcnhu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791871335; c=relaxed/simple;
	bh=GSYuFoP6YqiaH0ZbSe/d8p+lEf0g/Uv5omw23j3QZJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WvDeJCgOBSGNBT4oR2VVl+AOPkxogAuqO9O1kmlFopEVo2zk4dNW19T/75wlyg+BXDRL+yumOBi0TCO4YNPsaFEB4Xcg88WZG9HCILZaiqGTY997o4ZHl35TyaYZfS1Paa3RR2v8L8cekHmYrlm6/aF1GtNy8Cn8Ba3Wu/E8S/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mpeb0Q8/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mpeb0Q8/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D07271F000FF;
	Tue, 13 Oct 2026 06:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791871333;
	bh=2Zp9JOYxtEN7zv+t5LtlZkkXdXMafMpohoQkdBYoG8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mpeb0Q8/vLQwup0K4iI2ItyjPnujbA0+ubf8uyafsgEkLDZciCsdPb+IGHYZ8i0UE
	 DTMsXoHzwnHKudFH2OFuj8joOkZats1aLKHXBzgKO+6t6RTUcFuD4It4OXKjE3X2Zb
	 tSluqMBxxZsHaGMfvnIK1J+cXFqn4bySBpMadHokn7exeLxLRZW8OLIo6oPGZTseDn
	 9mQUBQt/TRqWjXcxj3v8Em4SQ3E4pNaWsWaXdx35gwAN+kq72MmOTWVPezlYgNd0jY
	 /orhPt02nRn0Mc1FYeOEzOLqdWKY4Ij2u987/JW5ay4z1ZZwZJTzS8ou1KP24aF69D
	 Co/h7YCBN1hFw==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 03/48] xfs: lift transaction header parsing out of the region assembly
Date: Tue, 13 Oct 2026 17:00:53 +1100
Message-ID: <20261013060204.3138690-4-dgc@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261013060204.3138690-1-dgc@kernel.org>
References: <20261013060204.3138690-1-dgc@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The transaction header at the start of a recovered transaction is not a log
item, but its parsing is currently tangled into the generic log item region
assembly: xlog_recover_add_to_trans() and xlog_recover_add_to_cont_trans()
each carry a special list_empty() branch that decodes the header instead of
a log item region.

Lift all of that into a single xlog_recover_init_new_trans() helper called
from xlog_recovery_process_trans() before the log item switch. When the item
queue is empty the incoming op record is (a fragment of) the transaction
header, so it is routed to the new helper; XLOG_WAS_CONT_TRANS distinguishes
a continuation fragment from the initial one.

The two former header branches are merged. Their common length validation is
done once: a fragment must be at least 4 bytes (all regions are 32 bit
aligned, and 4 bytes is the minimum needed to read the magic number) and no
larger than the whole header. The magic number is only checked on the
initial fragment. The bad-magic warning now reports the observed and
expected values. The redundant ASSERT(0) calls on the corruption paths are
removed so debug builds exercise the error paths.

This is a behaviour-preserving refactor: the header is still reassembled
directly into r_theader and the placeholder item is still added to the queue
when the header completes, exactly as before. It removes the header special
cases from the region assembly functions so they can be simplified in
following patches.

Changes:
- Add xlog_recover_init_new_trans() combining the two header decode paths
- Route header ophdrs to it from xlog_recovery_process_trans() via the
  empty item queue check, above the log item switch
- Remove the transaction header branches from xlog_recover_add_to_trans()
  and xlog_recover_add_to_cont_trans()

Created-by-AI: Claude Opus 4.8 (1M context)

Prompt: ok, I think we need to do a bit of refactoring before this new infra
patch. We need to lift the empty transaction case up out of add_to_trans
and add_to_cont_trans. [Refactor patch 1 of 4: lift transaction header
parsing.]
---
 fs/xfs/xfs_log_recover.c | 113 +++++++++++++++++++++++++--------------
 1 file changed, 73 insertions(+), 40 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 457617979668..b3e35df7a91b 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2108,35 +2108,76 @@ xlog_recover_add_item(
 	list_add_tail(&item->ri_list, head);
 }
 
+/*
+ * Decode the transaction header at the start of a new transaction.
+ *
+ * The transaction header is not a log item. It can be arbitrarily split across
+ * op records, so it may arrive whole in a single op record, or as an initial
+ * fragment (cont == false) followed by one or more continuation fragments
+ * (cont == true). Reassemble it directly into r_theader where the rest of
+ * recovery expects to find it.
+ */
 STATIC int
-xlog_recover_add_to_cont_trans(
+xlog_recover_init_new_trans(
 	struct xlog		*log,
 	struct xlog_recover	*trans,
 	char			*dp,
-	int			len)
+	int			len,
+	bool			cont)
 {
-	struct xlog_recover_item *item;
-	char			*ptr, *old_ptr;
-	int			old_len;
+	char			*ptr;
 
 	/*
-	 * If the transaction is empty, the header was split across this and the
-	 * previous record. Copy the rest of the header.
+	 * All regions are 32 bit aligned, so the smallest valid fragment is 4
+	 * bytes; that is also the minimum needed to read the magic number. A
+	 * fragment larger than the whole header is corruption in either case.
 	 */
-	if (list_empty(&trans->r_itemq)) {
-		ASSERT(len <= sizeof(struct xfs_trans_header));
-		if (len > sizeof(struct xfs_trans_header)) {
-			xfs_warn(log->l_mp, "%s: bad header length", __func__);
+	if (len < 4 || len > sizeof(struct xfs_trans_header)) {
+		xfs_warn(log->l_mp, "%s: bad header length %d", __func__, len);
+		return -EFSCORRUPTED;
+	}
+
+	if (!cont) {
+		/*
+		 * Initial fragment. The magic number is at the start of the
+		 * header, which lands at the start of r_theader.
+		 */
+		if (*(uint *)dp != XFS_TRANS_HEADER_MAGIC) {
+			xfs_warn(log->l_mp,
+			"%s: bad header magic number 0x%x, expected 0x%x",
+				__func__, *(uint *)dp, XFS_TRANS_HEADER_MAGIC);
 			return -EFSCORRUPTED;
 		}
-
-		xlog_recover_add_item(&trans->r_itemq);
+		ptr = (char *)&trans->r_theader;
+	} else {
+		/* continuation fragment completes the tail of the header */
 		ptr = (char *)&trans->r_theader +
 				sizeof(struct xfs_trans_header) - len;
-		memcpy(ptr, dp, len);
-		return 0;
 	}
 
+	/*
+	 * Add an item to the transaction once the header is complete: for an
+	 * unsplit header that is this initial fragment (len == full header),
+	 * and for a split header it is the continuation fragment that finishes
+	 * it.
+	 */
+	if (cont || len == sizeof(struct xfs_trans_header))
+		xlog_recover_add_item(&trans->r_itemq);
+	memcpy(ptr, dp, len);
+	return 0;
+}
+
+STATIC int
+xlog_recover_add_to_cont_trans(
+	struct xlog		*log,
+	struct xlog_recover	*trans,
+	char			*dp,
+	int			len)
+{
+	struct xlog_recover_item *item;
+	char			*ptr, *old_ptr;
+	int			old_len;
+
 	/* take the tail entry */
 	item = list_entry(trans->r_itemq.prev, struct xlog_recover_item,
 			  ri_list);
@@ -2180,31 +2221,6 @@ xlog_recover_add_to_trans(
 
 	if (!len)
 		return 0;
-	if (list_empty(&trans->r_itemq)) {
-		/* we need to catch log corruptions here */
-		if (*(uint *)dp != XFS_TRANS_HEADER_MAGIC) {
-			xfs_warn(log->l_mp, "%s: bad header magic number",
-				__func__);
-			ASSERT(0);
-			return -EFSCORRUPTED;
-		}
-
-		if (len > sizeof(struct xfs_trans_header)) {
-			xfs_warn(log->l_mp, "%s: bad header length", __func__);
-			ASSERT(0);
-			return -EFSCORRUPTED;
-		}
-
-		/*
-		 * The transaction header can be arbitrarily split across op
-		 * records. If we don't have the whole thing here, copy what we
-		 * do have and handle the rest in the next record.
-		 */
-		if (len == sizeof(struct xfs_trans_header))
-			xlog_recover_add_item(&trans->r_itemq);
-		memcpy(&trans->r_theader, dp, len);
-		return 0;
-	}
 
 	ptr = xlog_kvmalloc(len);
 	memcpy(ptr, dp, len);
@@ -2302,6 +2318,21 @@ xlog_recovery_process_trans(
 	if (flags & XLOG_WAS_CONT_TRANS)
 		flags &= ~XLOG_CONTINUE_TRANS;
 
+	/*
+	 * An empty item queue means we are still decoding the transaction
+	 * header at the start of the transaction rather than a log item. The
+	 * header can arrive whole (flags == 0), as an initial fragment
+	 * (XLOG_CONTINUE_TRANS) or as a continuation fragment
+	 * (XLOG_WAS_CONT_TRANS); XLOG_WAS_CONT_TRANS distinguishes the
+	 * continuation.
+	 */
+	if (list_empty(&trans->r_itemq) &&
+	    (!flags || (flags & (XLOG_CONTINUE_TRANS | XLOG_WAS_CONT_TRANS)))) {
+		error = xlog_recover_init_new_trans(log, trans, dp, len,
+					flags & XLOG_WAS_CONT_TRANS);
+		goto out_error;
+	}
+
 	/*
 	 * Callees must not free the trans structure. We'll decide if we need to
 	 * free it or not based on the operation being done and it's result.
@@ -2335,6 +2366,8 @@ xlog_recovery_process_trans(
 		error = -EFSCORRUPTED;
 		break;
 	}
+
+out_error:
 	if (error || freeit)
 		xlog_recover_free_trans(trans);
 	return error;
-- 
2.55.0

