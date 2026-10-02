Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 400BC448D03
	for <linux-xfs@vger.kernel.org>; Fri,  2 Oct 2026 21:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790975450; cv=none; b=WQFdY/yq3aiBQ4QCuYpqkNid48Ww07W5UUC6jP1kjufaPPAqPvURishCuzS4rW8tEcC6BGhFInOi/h5Tf22l3epXTcSzteTdVgMfaZZ8q+9S/BnApD2UVfbRlODnlMTR9EmfR+LfbHYBey9hYL0P1HhZbuDFc/2OH1zrbTRlc7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790975450; c=relaxed/simple;
	bh=7bZefcGJ/IbYbl4M0DF/pFkMfYTC0o4vyXs1aM92v7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tu8b5Fy1BBhPeo0/njPSym1Iyhn5wkCp0eC9jaDCdsOz5u0Pj1pXU7CelpOGBTFs+e17EDxjzjJm+ER/4FeTbkupjesVaJG/QYewvtC5UqNr9zE+cwLyVswSODQpXI1qiwgsJ4f3MBh2X4U94jDpe82OmfxgXhTDzFGhR+jElR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NLikvJ6M; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZjaZ0hSK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NLikvJ6M";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZjaZ0hSK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790975446;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wag/pJIKkhzAy+SLdADmnU83kmcQhcqkbux9Q3GsgPM=;
	b=NLikvJ6MVwhyHS5YRPfRKYF7PVzJobfC0dqT2IeI9naxrAmu4cQoNLVX+fJETqD+05DO3y
	jXHS7u6iijD9ke7qhd21Gj2qlv2mpJ9+bqYXfb7VWCrjNm16p6U6AOaO36kDTt46AZKshd
	qK0HqUgrnAEGAccgE+AbsMG0sRT3J2E=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-292-y7F7sspjNPyRaIoF_lAN8w-1; Fri, 02 Oct 2026 17:10:45 -0400
X-MC-Unique: y7F7sspjNPyRaIoF_lAN8w-1
X-Mimecast-MFC-AGG-ID: y7F7sspjNPyRaIoF_lAN8w_1790975445
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-8223f4fb134so461366a34.1
        for <linux-xfs@vger.kernel.org>; Fri, 02 Oct 2026 14:10:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1790975445; x=1791580245; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wag/pJIKkhzAy+SLdADmnU83kmcQhcqkbux9Q3GsgPM=;
        b=ZjaZ0hSKCIbjzgbIKqRSCFNVRcbeB9KeybGECgwdgKifQcsP/MP7si3HhNQ8mibnE2
         Qd372pwjNamA4zHJceZrbKrUXokUoBlhbKQpLuQPWqL90lXLoBDJcKWGZMWk3C/6hpfN
         at+i7hfrAMzfr0EMo8Ot541IljTfGXuvTQ4chVGK5iARrwAHncltMqo2ege3hKx8NHau
         bbtv4yjW1Ksdqb0BXvpPQocNzHGUeggA1atT0UeWxEII6ErsoWDk3NVO/BJBa3WV2/p3
         jYWnWgdMBcS8SWERA3jLY3uGkKjcOojapxnaqXdyk4mtYCe6xZ6GgPqvDiq2IuPxboQf
         8nXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790975445; x=1791580245;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wag/pJIKkhzAy+SLdADmnU83kmcQhcqkbux9Q3GsgPM=;
        b=WWNsN9SqdCXT7zDy18d1pU5hTB2tSyTt6+hEwm1FbLy7WWvNiZdqx8HjWsThRnycmk
         RK27OB6tpYtDNbZ9woSYgX2uakpfRXie+fLoLPYchtqAC0eBe1jrIcpu0M69x/d8qEa/
         oe414xoVARq3Q+3qD3KmPYAGE2HoZMoyYReAwGnvkw73rulMeauhPwNUTnovhqXqxHw9
         L22OXThzrU54RBsyAv83T7wCaOtoPZ78k8lOdcU0f7ZjN0/LmRJnCgASdQIvCWBM50yq
         jeOz+9mobF3beN5G2Phpmjom4ACXEXa2uv0qA1ymFQ0KpXzRwyOzZ91nW3zgsT5HgBOO
         970Q==
X-Gm-Message-State: AFuF++l+SydTo0RR1J8vTVYrnwX8PUdHxFDNuCLcaHvEEox0rEEJcaLv
	razbssQhU8lsDnCm0T7N04R7T79u8iRaR/HmhWnyU7fEfjLFSwJiCG/IJ869Tz8a6o2l/T6u4Km
	QaI2fFzfIV75LVb2jTDQq/HSHS/qGsW93NQDW6HmgDZGEIVzKxukIe7y4BAyQnLSiamQxVj5SbJ
	EejI/vGV9rFhayrwjtG4SGwSAi8Asqz7aypbkPILHv60AEqmM=
X-Gm-Gg: AYBFou39iq8eutC6hlOT1ZeW7iT0IHgNxoyAbub7GATL5fUFZQR1O/Xnvdp89qrvTDP
	++SQLkCx9104GKiZoOE4R4rwAaNzMlJ05n6Jpo6PvoaxmVvNorx7M8i5uHn/XTIbsoz5YGYN2x5
	5fhwyuSdE9DSJbLiJY2L3IOQax0CS9G6uMv/kUUvbygS8fe8sFQts6nfru/JQ/F0A6D7Z1FEGc0
	9DI5iGTnCrryI9kXVGd3pfXiA4YvjomDiuEo4/fH05ilAGhYMIXMJn8ZXfCdTkvbjTscInI5RgY
	6ESQ/08sUptjj20yXwQGTWkDhtu5SrAPxvsOATiydycSD/JJDom2+kWICF2Q19XWirMNeDpmuTk
	osaMvO8fciNa9zi/SJ7ty5q8727g3p1J5YomdRQ==
X-Received: by 2002:a05:6830:81f0:b0:806:e047:cd7d with SMTP id 46e09a7af769-823fc53544amr691029a34.7.1790975444507;
        Fri, 02 Oct 2026 14:10:44 -0700 (PDT)
X-Received: by 2002:a05:6830:81f0:b0:806:e047:cd7d with SMTP id 46e09a7af769-823fc53544amr690991a34.7.1790975443771;
        Fri, 02 Oct 2026 14:10:43 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-8227aa72075sm4456044a34.27.2026.10.02.14.10.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2026 14:10:43 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	djwong@kernel.org,
	Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 3/3] xfs: re-use refcount scrub/repair code for rtrefcount
Date: Fri,  2 Oct 2026 16:08:11 -0500
Message-ID: <20261002211038.2139655-4-sandeen@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261002211038.2139655-1-sandeen@redhat.com>
References: <20261002211038.2139655-1-sandeen@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Some code in scrub/rtrefcount.c is copied from scrub/refcount.c; it
differs only in function & structure names and a couple types and
macros, which share the same underlying types and values.

Similarly for code in fs/xfs/scrub/[rt]refcount_repair.c

Export the refcount versions, use them for rtrefcount scrubbing,
eliminate the copies, and add build-time asserts so that the type/value
matches mentioned above do not drift.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/scrub/refcount.c          |  27 +---
 fs/xfs/scrub/refcount.h          |  56 +++++++
 fs/xfs/scrub/refcount_repair.c   |   3 +-
 fs/xfs/scrub/rtrefcount.c        | 263 +------------------------------
 fs/xfs/scrub/rtrefcount_repair.c |  39 +----
 5 files changed, 72 insertions(+), 316 deletions(-)
 create mode 100644 fs/xfs/scrub/refcount.h

diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
index f8c51d8fbb3d..c18bb89325a5 100644
--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -20,6 +20,7 @@
 #include "scrub/btree.h"
 #include "scrub/trace.h"
 #include "scrub/repair.h"
+#include "scrub/refcount.h"
 
 /*
  * Set us up to scrub reference count btrees.
@@ -80,24 +81,6 @@ xchk_setup_ag_refcountbt(
  * If the refcount is correct, all the check conditions in the algorithm
  * should always hold true.  If not, the refcount is incorrect.
  */
-struct xchk_refcnt_frag {
-	struct list_head	list;
-	struct xfs_rmap_irec	rm;
-};
-
-struct xchk_refcnt_check {
-	struct xfs_scrub	*sc;
-	struct list_head	fragments;
-
-	/* refcount extent we're examining */
-	xfs_agblock_t		bno;
-	xfs_extlen_t		len;
-	xfs_nlink_t		refcount;
-
-	/* number of owners seen */
-	xfs_nlink_t		seen;
-};
-
 /*
  * Decide if the given rmap is large enough that we can redeem it
  * towards refcount verification now, or if it's a fragment, in
@@ -105,7 +88,7 @@ struct xchk_refcnt_check {
  * discover that we've collected exactly the correct number of
  * fragments as the refcountbt says we should have.
  */
-STATIC int
+int
 xchk_refcountbt_rmap_check(
 	struct xfs_btree_cur		*cur,
 	const struct xfs_rmap_irec	*rec,
@@ -159,7 +142,7 @@ xchk_refcountbt_rmap_check(
  * number of extents that totally covered the refcountbt extent),
  * we have a refcountbt error.
  */
-STATIC void
+void
 xchk_refcountbt_process_rmap_fragments(
 	struct xchk_refcnt_check	*refchk)
 {
@@ -290,7 +273,7 @@ xchk_refcountbt_xref_rmap(
 		.bno			= irec->rc_startblock,
 		.len			= irec->rc_blockcount,
 		.refcount		= irec->rc_refcount,
-		.seen = 0,
+		.seen			= 0,
 	};
 	struct xfs_rmap_irec		low;
 	struct xfs_rmap_irec		high;
@@ -355,7 +338,7 @@ struct xchk_refcbt_records {
 	enum xfs_refc_domain	prev_domain;
 };
 
-STATIC int
+int
 xchk_refcountbt_rmap_check_gap(
 	struct xfs_btree_cur		*cur,
 	const struct xfs_rmap_irec	*rec,
diff --git a/fs/xfs/scrub/refcount.h b/fs/xfs/scrub/refcount.h
new file mode 100644
index 000000000000..0706afd9f80b
--- /dev/null
+++ b/fs/xfs/scrub/refcount.h
@@ -0,0 +1,56 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2017-2023 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __XFS_SCRUB_REFCOUNT_H__
+#define __XFS_SCRUB_REFCOUNT_H__
+
+/*
+ * Ensure that types and macros match across rt and non-rt variants,
+ * as this code is shared for both.
+ */
+static_assert(__same_type(xfs_agblock_t, xfs_rgblock_t));
+static_assert(NULLAGBLOCK == NULLRGBLOCK);
+
+/*
+ * Confirming reference counts via reverse mappings.
+ *
+ * These helpers are shared by the AG (refcount.c) and realtime
+ * (rtrefcount.c) refcount scrubbers.  Both the rmap and refcount incore
+ * records use xfs_agblock_t for their start block regardless of whether the
+ * data lives in an allocation group or a realtime group, so the fragment
+ * bookkeeping here uses xfs_agblock_t for group-relative block numbers.
+ */
+struct xchk_refcnt_frag {
+	struct list_head	list;
+	struct xfs_rmap_irec	rm;
+};
+
+struct xchk_refcnt_check {
+	struct xfs_scrub	*sc;
+	struct list_head	fragments;
+
+	/* refcount extent we're examining */
+	xfs_agblock_t		bno;
+	xfs_extlen_t		len;
+	xfs_nlink_t		refcount;
+
+	/* number of owners seen */
+	xfs_nlink_t		seen;
+};
+
+int xchk_refcountbt_rmap_check(struct xfs_btree_cur *cur,
+		const struct xfs_rmap_irec *rec, void *priv);
+void xchk_refcountbt_process_rmap_fragments(struct xchk_refcnt_check *refchk);
+int xchk_refcountbt_rmap_check_gap(struct xfs_btree_cur *cur,
+		const struct xfs_rmap_irec *rec, void *priv);
+
+/*
+ * Compare two refcount records so that both the AG (refcount_repair.c) and
+ * realtime (rtrefcount_repair.c) rebuilders sort staged records into the same
+ * order as the ondisk records.
+ */
+int xrep_refc_extent_cmp(const void *a, const void *b);
+
+#endif /* __XFS_SCRUB_REFCOUNT_H__ */
diff --git a/fs/xfs/scrub/refcount_repair.c b/fs/xfs/scrub/refcount_repair.c
index ca9c382005ff..72de263117a7 100644
--- a/fs/xfs/scrub/refcount_repair.c
+++ b/fs/xfs/scrub/refcount_repair.c
@@ -39,6 +39,7 @@
 #include "scrub/newbt.h"
 #include "scrub/reap.h"
 #include "scrub/rcbag.h"
+#include "scrub/refcount.h"
 
 /*
  * Rebuilding the Reference Count Btree
@@ -295,7 +296,7 @@ xrep_refc_encode_startblock(
 }
 
 /* Sort in the same order as the ondisk records. */
-static int
+int
 xrep_refc_extent_cmp(
 	const void			*a,
 	const void			*b)
diff --git a/fs/xfs/scrub/rtrefcount.c b/fs/xfs/scrub/rtrefcount.c
index 460e3f094adf..b78784051308 100644
--- a/fs/xfs/scrub/rtrefcount.c
+++ b/fs/xfs/scrub/rtrefcount.c
@@ -25,6 +25,7 @@
 #include "scrub/common.h"
 #include "scrub/btree.h"
 #include "scrub/repair.h"
+#include "scrub/refcount.h"
 
 /* Set us up with the realtime refcount metadata locked. */
 int
@@ -59,248 +60,13 @@ xchk_setup_rtrefcountbt(
 
 /* Realtime Reference count btree scrubber. */
 
-/*
- * Confirming Reference Counts via Reverse Mappings
- *
- * We want to count the reverse mappings overlapping a refcount record
- * (bno, len, refcount), allowing for the possibility that some of the
- * overlap may come from smaller adjoining reverse mappings, while some
- * comes from single extents which overlap the range entirely.  The
- * outer loop is as follows:
- *
- * 1. For all reverse mappings overlapping the refcount extent,
- *    a. If a given rmap completely overlaps, mark it as seen.
- *    b. Otherwise, record the fragment (in agbno order) for later
- *       processing.
- *
- * Once we've seen all the rmaps, we know that for all blocks in the
- * refcount record we want to find $refcount owners and we've already
- * visited $seen extents that overlap all the blocks.  Therefore, we
- * need to find ($refcount - $seen) owners for every block in the
- * extent; call that quantity $target_nr.  Proceed as follows:
- *
- * 2. Pull the first $target_nr fragments from the list; all of them
- *    should start at or before the start of the extent.
- *    Call this subset of fragments the working set.
- * 3. Until there are no more unprocessed fragments,
- *    a. Find the shortest fragments in the set and remove them.
- *    b. Note the block number of the end of these fragments.
- *    c. Pull the same number of fragments from the list.  All of these
- *       fragments should start at the block number recorded in the
- *       previous step.
- *    d. Put those fragments in the set.
- * 4. Check that there are $target_nr fragments remaining in the list,
- *    and that they all end at or beyond the end of the refcount extent.
- *
- * If the refcount is correct, all the check conditions in the algorithm
- * should always hold true.  If not, the refcount is incorrect.
- */
-struct xchk_rtrefcnt_frag {
-	struct list_head	list;
-	struct xfs_rmap_irec	rm;
-};
-
-struct xchk_rtrefcnt_check {
-	struct xfs_scrub	*sc;
-	struct list_head	fragments;
-
-	/* refcount extent we're examining */
-	xfs_rgblock_t		bno;
-	xfs_extlen_t		len;
-	xfs_nlink_t		refcount;
-
-	/* number of owners seen */
-	xfs_nlink_t		seen;
-};
-
-/*
- * Decide if the given rmap is large enough that we can redeem it
- * towards refcount verification now, or if it's a fragment, in
- * which case we'll hang onto it in the hopes that we'll later
- * discover that we've collected exactly the correct number of
- * fragments as the rtrefcountbt says we should have.
- */
-STATIC int
-xchk_rtrefcountbt_rmap_check(
-	struct xfs_btree_cur		*cur,
-	const struct xfs_rmap_irec	*rec,
-	void				*priv)
-{
-	struct xchk_rtrefcnt_check	*refchk = priv;
-	struct xchk_rtrefcnt_frag	*frag;
-	xfs_rgblock_t			rm_last;
-	xfs_rgblock_t			rc_last;
-	int				error = 0;
-
-	if (xchk_should_terminate(refchk->sc, &error))
-		return error;
-
-	rm_last = rec->rm_startblock + rec->rm_blockcount - 1;
-	rc_last = refchk->bno + refchk->len - 1;
-
-	/* Confirm that a single-owner refc extent is a CoW stage. */
-	if (refchk->refcount == 1 && rec->rm_owner != XFS_RMAP_OWN_COW) {
-		xchk_btree_xref_set_corrupt(refchk->sc, cur, 0);
-		return 0;
-	}
-
-	if (rec->rm_startblock <= refchk->bno && rm_last >= rc_last) {
-		/*
-		 * The rmap overlaps the refcount record, so we can confirm
-		 * one refcount owner seen.
-		 */
-		refchk->seen++;
-	} else {
-		/*
-		 * This rmap covers only part of the refcount record, so
-		 * save the fragment for later processing.  If the rmapbt
-		 * is healthy each rmap_irec we see will be in agbno order
-		 * so we don't need insertion sort here.
-		 */
-		frag = kmalloc_obj(struct xchk_rtrefcnt_frag, XCHK_GFP_FLAGS);
-		if (!frag)
-			return -ENOMEM;
-		memcpy(&frag->rm, rec, sizeof(frag->rm));
-		list_add_tail(&frag->list, &refchk->fragments);
-	}
-
-	return 0;
-}
-
-/*
- * Given a bunch of rmap fragments, iterate through them, keeping
- * a running tally of the refcount.  If this ever deviates from
- * what we expect (which is the rtrefcountbt's refcount minus the
- * number of extents that totally covered the rtrefcountbt extent),
- * we have a rtrefcountbt error.
- */
-STATIC void
-xchk_rtrefcountbt_process_rmap_fragments(
-	struct xchk_rtrefcnt_check	*refchk)
-{
-	struct list_head		worklist;
-	struct xchk_rtrefcnt_frag	*frag;
-	struct xchk_rtrefcnt_frag	*n;
-	xfs_rgblock_t			bno;
-	xfs_rgblock_t			rbno;
-	xfs_rgblock_t			next_rbno;
-	xfs_nlink_t			nr;
-	xfs_nlink_t			target_nr;
-
-	target_nr = refchk->refcount - refchk->seen;
-	if (target_nr == 0)
-		return;
-
-	/*
-	 * There are (refchk->rc.rc_refcount - refchk->nr refcount)
-	 * references we haven't found yet.  Pull that many off the
-	 * fragment list and figure out where the smallest rmap ends
-	 * (and therefore the next rmap should start).  All the rmaps
-	 * we pull off should start at or before the beginning of the
-	 * refcount record's range.
-	 */
-	INIT_LIST_HEAD(&worklist);
-	rbno = NULLRGBLOCK;
-
-	/* Make sure the fragments actually /are/ in bno order. */
-	bno = 0;
-	list_for_each_entry(frag, &refchk->fragments, list) {
-		if (frag->rm.rm_startblock < bno)
-			goto done;
-		bno = frag->rm.rm_startblock;
-	}
-
-	/*
-	 * Find all the rmaps that start at or before the refc extent,
-	 * and put them on the worklist.
-	 */
-	nr = 0;
-	list_for_each_entry_safe(frag, n, &refchk->fragments, list) {
-		if (frag->rm.rm_startblock > refchk->bno || nr > target_nr)
-			break;
-		bno = frag->rm.rm_startblock + frag->rm.rm_blockcount;
-		if (bno < rbno)
-			rbno = bno;
-		list_move_tail(&frag->list, &worklist);
-		nr++;
-	}
-
-	/*
-	 * We should have found exactly $target_nr rmap fragments starting
-	 * at or before the refcount extent.
-	 */
-	if (nr != target_nr)
-		goto done;
-
-	while (!list_empty(&refchk->fragments)) {
-		/* Discard any fragments ending at rbno from the worklist. */
-		nr = 0;
-		next_rbno = NULLRGBLOCK;
-		list_for_each_entry_safe(frag, n, &worklist, list) {
-			bno = frag->rm.rm_startblock + frag->rm.rm_blockcount;
-			if (bno != rbno) {
-				if (bno < next_rbno)
-					next_rbno = bno;
-				continue;
-			}
-			list_del(&frag->list);
-			kfree(frag);
-			nr++;
-		}
-
-		/* Try to add nr rmaps starting at rbno to the worklist. */
-		list_for_each_entry_safe(frag, n, &refchk->fragments, list) {
-			bno = frag->rm.rm_startblock + frag->rm.rm_blockcount;
-			if (frag->rm.rm_startblock != rbno)
-				goto done;
-			list_move_tail(&frag->list, &worklist);
-			if (next_rbno > bno)
-				next_rbno = bno;
-			nr--;
-			if (nr == 0)
-				break;
-		}
-
-		/*
-		 * If we get here and nr > 0, this means that we added fewer
-		 * items to the worklist than we discarded because the fragment
-		 * list ran out of items.  Therefore, we cannot maintain the
-		 * required refcount.  Something is wrong, so we're done.
-		 */
-		if (nr)
-			goto done;
-
-		rbno = next_rbno;
-	}
-
-	/*
-	 * Make sure the last extent we processed ends at or beyond
-	 * the end of the refcount extent.
-	 */
-	if (rbno < refchk->bno + refchk->len)
-		goto done;
-
-	/* Actually record us having seen the remaining refcount. */
-	refchk->seen = refchk->refcount;
-done:
-	/* Delete fragments and work list. */
-	list_for_each_entry_safe(frag, n, &worklist, list) {
-		list_del(&frag->list);
-		kfree(frag);
-	}
-	list_for_each_entry_safe(frag, n, &refchk->fragments, list) {
-		list_del(&frag->list);
-		kfree(frag);
-	}
-}
-
 /* Use the rmap entries covering this extent to verify the refcount. */
 STATIC void
 xchk_rtrefcountbt_xref_rmap(
 	struct xfs_scrub		*sc,
 	const struct xfs_refcount_irec	*irec)
 {
-	struct xchk_rtrefcnt_check	refchk = {
+	struct xchk_refcnt_check	refchk = {
 		.sc			= sc,
 		.bno			= irec->rc_startblock,
 		.len			= irec->rc_blockcount,
@@ -309,8 +75,8 @@ xchk_rtrefcountbt_xref_rmap(
 	};
 	struct xfs_rmap_irec		low;
 	struct xfs_rmap_irec		high;
-	struct xchk_rtrefcnt_frag	*frag;
-	struct xchk_rtrefcnt_frag	*n;
+	struct xchk_refcnt_frag		*frag;
+	struct xchk_refcnt_frag		*n;
 	int				error;
 
 	if (!sc->sr.rmap_cur || xchk_skip_xref(sc->sm))
@@ -324,11 +90,11 @@ xchk_rtrefcountbt_xref_rmap(
 
 	INIT_LIST_HEAD(&refchk.fragments);
 	error = xfs_rmap_query_range(sc->sr.rmap_cur, &low, &high,
-			xchk_rtrefcountbt_rmap_check, &refchk);
+			xchk_refcountbt_rmap_check, &refchk);
 	if (!xchk_should_check_xref(sc, &error, &sc->sr.rmap_cur))
 		goto out_free;
 
-	xchk_rtrefcountbt_process_rmap_fragments(&refchk);
+	xchk_refcountbt_process_rmap_fragments(&refchk);
 	if (irec->rc_refcount != refchk.seen)
 		xchk_btree_xref_set_corrupt(sc, sc->sr.rmap_cur, 0);
 
@@ -408,21 +174,6 @@ xchk_rtrefcountbt_check_mergeable(
 	memcpy(&rrc->prev_rec, irec, sizeof(struct xfs_refcount_irec));
 }
 
-STATIC int
-xchk_rtrefcountbt_rmap_check_gap(
-	struct xfs_btree_cur		*cur,
-	const struct xfs_rmap_irec	*rec,
-	void				*priv)
-{
-	xfs_rgblock_t			*next_bno = priv;
-
-	if (*next_bno != NULLRGBLOCK && rec->rm_startblock < *next_bno)
-		return -ECANCELED;
-
-	*next_bno = rec->rm_startblock + rec->rm_blockcount;
-	return 0;
-}
-
 /*
  * Make sure that a gap in the reference count records does not correspond to
  * overlapping records (i.e. shared extents) in the reverse mappings.
@@ -448,7 +199,7 @@ xchk_rtrefcountbt_xref_gaps(
 	high.rm_startblock = bno - 1;
 
 	error = xfs_rmap_query_range(sc->sr.rmap_cur, &low, &high,
-			xchk_rtrefcountbt_rmap_check_gap, &next_bno);
+			xchk_refcountbt_rmap_check_gap, &next_bno);
 	if (error == -ECANCELED)
 		xchk_btree_xref_set_corrupt(sc, sc->sr.rmap_cur, 0);
 	else
diff --git a/fs/xfs/scrub/rtrefcount_repair.c b/fs/xfs/scrub/rtrefcount_repair.c
index c78a6d2990c5..5ca9959dfacc 100644
--- a/fs/xfs/scrub/rtrefcount_repair.c
+++ b/fs/xfs/scrub/rtrefcount_repair.c
@@ -44,6 +44,7 @@
 #include "scrub/newbt.h"
 #include "scrub/reap.h"
 #include "scrub/rcbag.h"
+#include "scrub/refcount.h"
 
 /*
  * Rebuilding the Reference Count Btree
@@ -266,42 +267,6 @@ xrep_rtrefc_walk_rmaps(
 	return 0;
 }
 
-static inline uint32_t
-xrep_rtrefc_encode_startblock(
-	const struct xfs_refcount_irec	*irec)
-{
-	uint32_t			start;
-
-	start = irec->rc_startblock & ~XFS_REFC_COWFLAG;
-	if (irec->rc_domain == XFS_REFC_DOMAIN_COW)
-		start |= XFS_REFC_COWFLAG;
-
-	return start;
-}
-
-/*
- * Compare two refcount records.  We want to sort in order of increasing block
- * number.
- */
-static int
-xrep_rtrefc_extent_cmp(
-	const void			*a,
-	const void			*b)
-{
-	const struct xfs_refcount_irec	*ap = a;
-	const struct xfs_refcount_irec	*bp = b;
-	uint32_t			sa, sb;
-
-	sa = xrep_rtrefc_encode_startblock(ap);
-	sb = xrep_rtrefc_encode_startblock(bp);
-
-	if (sa > sb)
-		return 1;
-	if (sa < sb)
-		return -1;
-	return 0;
-}
-
 /*
  * Sort the refcount extents by startblock or else the btree records will be in
  * the wrong order.  Make sure the records do not overlap in physical space.
@@ -316,7 +281,7 @@ xrep_rtrefc_sort_records(
 	xfs_rgblock_t			next_rgbno = 0;
 	int				error;
 
-	error = xfarray_sort(rr->refcount_records, xrep_rtrefc_extent_cmp,
+	error = xfarray_sort(rr->refcount_records, xrep_refc_extent_cmp,
 			XFARRAY_SORT_KILLABLE);
 	if (error)
 		return error;
-- 
2.55.0

