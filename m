Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFB688627C
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713929264; cv=none; b=pU0MuFbGeazME73Y2LogMgVELp7mzobJAxVthEhVY1PO1mpvmg1u0KOqnzle4JnsFw2esvxRnEA60c37CNSLWlRVE99m2bzcrbV3Z9AfdkKMaoc7IOMYHuZFSEojrd2Je0e6hY1ilq51Nl7NXKxLemju7g4eat1RgGa/cNhBHAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713929264; c=relaxed/simple;
	bh=U458JQ2oUNNvBsNmjKDYksrV2HNO/9gQw3rvnuMImu8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZKqgA29IEuZPLiYyB+jimeXBwX/t4ZEwIHHZyr7wCzzdbYaw832MINrtnYwPMu4EeAj/ttABgYivQHltBRTG9g3FEdatASDOM4bOttkrl6cgncd3zbqXsSkZojARdbYDP7n1+N4zHcyXIk+WsWpAgJ7L3F+F+0dzicWDUW4ijiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S54/LP4y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S54/LP4y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC77FC3277B;
	Wed, 24 Apr 2024 03:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713929263;
	bh=U458JQ2oUNNvBsNmjKDYksrV2HNO/9gQw3rvnuMImu8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=S54/LP4yYp1QwAa4sN5KTjrT5jT+8kFTkdo+D6Yt/UjY1B3whxyB0UtntE7RFwpAd
	 1aXkShc4JM5jw9z/9wiQNIwFq5U33KUXx/eqOoPPxV754s0YxuiXbr3THFc57rXlX5
	 rdy6fSkL1vDtFoHjohs13ZB+RjPi5MeqtQG/MQe/NrhKihGykhNwJ92ywIEUTfGDU/
	 aOyQkRUUre5/0dBFyL1zZzdJrmTB1T6wOKqapJtMYn/3NmP0r/ca9HtY4fcT5n+MQr
	 47izefDcUaeB3/faV+yBdH017DTcs2p4F+/Hxu12AjXLqFY8Cj+heWDg1P5tlDi9j7
	 uifYdDobyWOMw==
Date: Tue, 23 Apr 2024 20:27:43 -0700
Subject: [PATCH 1/3] xfs: reduce the rate of cond_resched calls inside scrub
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392785674.1907196.7779572889993967696.stgit@frogsfrogsfrogs>
In-Reply-To: <171392785649.1907196.827031134623701813.stgit@frogsfrogsfrogs>
References: <171392785649.1907196.827031134623701813.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

We really don't want to call cond_resched every single time we go
through a loop in scrub -- there may be billions of records, and probing
into the scheduler itself has overhead.  Reduce this overhead by only
calling cond_resched 10x per second; and add a counter so that we only
check jiffies once every 1000 records or so.

Surprisingly, this reduces scrub-only fstests runtime by about 2%.  I
used the bmapinflate xfs_db command to produce a billion-extent file and
this stupid gadget reduced the scrub runtime by about 4%.

From a stupid microbenchmark of calling these things 1 billion times, I
estimate that cond_resched costs about 5.5ns per call; jiffes costs
about 0.3ns per read; and fatal_signal_pending costs about 0.4ns per
call.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/common.h  |   25 -------------------
 fs/xfs/scrub/scrub.c   |    1 +
 fs/xfs/scrub/scrub.h   |   64 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/xfarray.c |   10 ++++----
 fs/xfs/scrub/xfarray.h |    3 ++
 fs/xfs/scrub/xfile.c   |    2 +-
 6 files changed, 74 insertions(+), 31 deletions(-)


diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 39465e39dc5f..3d5f1f6b4b7b 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -6,31 +6,6 @@
 #ifndef __XFS_SCRUB_COMMON_H__
 #define __XFS_SCRUB_COMMON_H__
 
-/*
- * We /could/ terminate a scrub/repair operation early.  If we're not
- * in a good place to continue (fatal signal, etc.) then bail out.
- * Note that we're careful not to make any judgements about *error.
- */
-static inline bool
-xchk_should_terminate(
-	struct xfs_scrub	*sc,
-	int			*error)
-{
-	/*
-	 * If preemption is disabled, we need to yield to the scheduler every
-	 * few seconds so that we don't run afoul of the soft lockup watchdog
-	 * or RCU stall detector.
-	 */
-	cond_resched();
-
-	if (fatal_signal_pending(current)) {
-		if (*error == 0)
-			*error = -EINTR;
-		return true;
-	}
-	return false;
-}
-
 int xchk_trans_alloc(struct xfs_scrub *sc, uint resblks);
 int xchk_trans_alloc_empty(struct xfs_scrub *sc);
 void xchk_trans_cancel(struct xfs_scrub *sc);
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index e813b66b603a..4a81f828f9f1 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -620,6 +620,7 @@ xfs_scrub_metadata(
 	sc->sm = sm;
 	sc->ops = &meta_scrub_ops[sm->sm_type];
 	sc->sick_mask = xchk_health_mask_for_scrub_type(sm->sm_type);
+	sc->relax = INIT_XCHK_RELAX;
 retry_op:
 	/*
 	 * When repairs are allowed, prevent freezing or readonly remount while
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 391027047146..4e7e3edb6350 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -8,6 +8,49 @@
 
 struct xfs_scrub;
 
+struct xchk_relax {
+	unsigned long	next_resched;
+	unsigned int	resched_nr;
+	bool		interruptible;
+};
+
+/* Yield to the scheduler at most 10x per second. */
+#define XCHK_RELAX_NEXT		(jiffies + (HZ / 10))
+
+#define INIT_XCHK_RELAX	\
+	(struct xchk_relax){ \
+		.next_resched	= XCHK_RELAX_NEXT, \
+		.resched_nr	= 0, \
+		.interruptible	= true, \
+	}
+
+/*
+ * Relax during a scrub operation and exit if there's a fatal signal pending.
+ *
+ * If preemption is disabled, we need to yield to the scheduler every now and
+ * then so that we don't run afoul of the soft lockup watchdog or RCU stall
+ * detector.  cond_resched calls are somewhat expensive (~5ns) so we want to
+ * ratelimit this to 10x per second.  Amortize the cost of the other checks by
+ * only doing it once every 100 calls.
+ */
+static inline int xchk_maybe_relax(struct xchk_relax *widget)
+{
+	/* Amortize the cost of scheduling and checking signals. */
+	if (likely(++widget->resched_nr < 100))
+		return 0;
+	widget->resched_nr = 0;
+
+	if (unlikely(widget->next_resched <= jiffies)) {
+		cond_resched();
+		widget->next_resched = XCHK_RELAX_NEXT;
+	}
+
+	if (widget->interruptible && fatal_signal_pending(current))
+		return -EINTR;
+
+	return 0;
+}
+
 /*
  * Standard flags for allocating memory within scrub.  NOFS context is
  * configured by the process allocation scope.  Scrub and repair must be able
@@ -123,6 +166,9 @@ struct xfs_scrub {
 	 */
 	unsigned int			sick_mask;
 
+	/* next time we want to cond_resched() */
+	struct xchk_relax		relax;
+
 	/* State tracking for single-AG operations. */
 	struct xchk_ag			sa;
 };
@@ -167,6 +213,24 @@ struct xfs_scrub_subord *xchk_scrub_create_subord(struct xfs_scrub *sc,
 		unsigned int subtype);
 void xchk_scrub_free_subord(struct xfs_scrub_subord *sub);
 
+/*
+ * We /could/ terminate a scrub/repair operation early.  If we're not
+ * in a good place to continue (fatal signal, etc.) then bail out.
+ * Note that we're careful not to make any judgements about *error.
+ */
+static inline bool
+xchk_should_terminate(
+	struct xfs_scrub	*sc,
+	int			*error)
+{
+	if (xchk_maybe_relax(&sc->relax)) {
+		if (*error == 0)
+			*error = -EINTR;
+		return true;
+	}
+	return false;
+}
+
 /* Metadata scrubbers */
 int xchk_tester(struct xfs_scrub *sc);
 int xchk_superblock(struct xfs_scrub *sc);
diff --git a/fs/xfs/scrub/xfarray.c b/fs/xfs/scrub/xfarray.c
index b65cd3fc5ac9..9185ae7088d4 100644
--- a/fs/xfs/scrub/xfarray.c
+++ b/fs/xfs/scrub/xfarray.c
@@ -7,9 +7,9 @@
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
+#include "scrub/scrub.h"
 #include "scrub/xfile.h"
 #include "scrub/xfarray.h"
-#include "scrub/scrub.h"
 #include "scrub/trace.h"
 
 /*
@@ -486,6 +486,9 @@ xfarray_sortinfo_alloc(
 
 	xfarray_sortinfo_lo(si)[0] = 0;
 	xfarray_sortinfo_hi(si)[0] = array->nr - 1;
+	si->relax = INIT_XCHK_RELAX;
+	if (flags & XFARRAY_SORT_KILLABLE)
+		si->relax.interruptible = false;
 
 	trace_xfarray_sort(si, nr_bytes);
 	*infop = si;
@@ -503,10 +506,7 @@ xfarray_sort_terminated(
 	 * few seconds so that we don't run afoul of the soft lockup watchdog
 	 * or RCU stall detector.
 	 */
-	cond_resched();
-
-	if ((si->flags & XFARRAY_SORT_KILLABLE) &&
-	    fatal_signal_pending(current)) {
+	if (xchk_maybe_relax(&si->relax)) {
 		if (*error == 0)
 			*error = -EINTR;
 		return true;
diff --git a/fs/xfs/scrub/xfarray.h b/fs/xfs/scrub/xfarray.h
index 8f54c8fc888f..5eeeeed13ae2 100644
--- a/fs/xfs/scrub/xfarray.h
+++ b/fs/xfs/scrub/xfarray.h
@@ -127,6 +127,9 @@ struct xfarray_sortinfo {
 	/* XFARRAY_SORT_* flags; see below. */
 	unsigned int		flags;
 
+	/* next time we want to cond_resched() */
+	struct xchk_relax	relax;
+
 	/* Cache a folio here for faster scanning for pivots */
 	struct folio		*folio;
 
diff --git a/fs/xfs/scrub/xfile.c b/fs/xfs/scrub/xfile.c
index 4e254a0ba003..d848222f802b 100644
--- a/fs/xfs/scrub/xfile.c
+++ b/fs/xfs/scrub/xfile.c
@@ -10,9 +10,9 @@
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
+#include "scrub/scrub.h"
 #include "scrub/xfile.h"
 #include "scrub/xfarray.h"
-#include "scrub/scrub.h"
 #include "scrub/trace.h"
 #include <linux/shmem_fs.h>
 

