Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10D9031D74F
	for <linux-xfs@vger.kernel.org>; Fri,  5 Sep 2025 15:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757087848; cv=none; b=bfakWxfPm1fC4xhUEwoLlg3ksV7IWJlqEBQ4h/CViecChU9bqUHDekWJlMxKGx5Tobk6gRzIK+VP1tKy72Y9f7WQC+ggjXlRPCiIPE2T2VuSpz02FIsokD8j2L4L0bDvimzeu77oJrVA+CkfDNaNvsvgd/+XOBxNHOMxdro13LY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757087848; c=relaxed/simple;
	bh=2wVLz37fguDDNIB3a50u4IinXFafMByunDV30d137Kw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dbzvgRvq5GNZ2FQ+mptPup5uiM8q/xHcfVT62s7xAdBoE4/X8pkX8BDHVR+Oc+GexRcicNIjq/phS5WqNQn/SoBZ2PTtVAsz1J42E+vuJ8Ei1BzpH/G6AW0xLrlIB8Bj8Wu55D/+F6GHaq+fGmWeWXnb2lfq95WKxBKB/5GiWU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JctrapP1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JctrapP1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F0C9C4CEF1;
	Fri,  5 Sep 2025 15:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757087847;
	bh=2wVLz37fguDDNIB3a50u4IinXFafMByunDV30d137Kw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=JctrapP1DQYONdnFYa3128PJHUKIdBqp7KmFhHXvydyXqYQgBJj/VYGwo3CQs0ywW
	 9dUaViipR2uCjTQnTguAfBYd+pDtpms5DVSpyrwpiHrJOsgApeTPEekqJznuQf99KI
	 TK3Zx+5Rg4Pq/e13EVGx6GsItC5onp9AxSXNNTB2nUcTeMES9etCh4wV9J40n1+uo8
	 IOElLuljCK/E9XwcVKcxAX8DVF/s/eudV8cr2cX4Mroe3N0MS/BDYq798SgWEj4eKX
	 nBpNtHH6l3HraLOlYlQuinniRzAyjO+mrsVCsUXQlcG+2PZXDqTqHSleqeuJZZeX0m
	 vziksYsFzcurQ==
Date: Fri, 05 Sep 2025 08:57:27 -0700
Subject: [PATCH 8/9] xfs: remove static reap limits from repair.h
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <175708765225.3402543.1736815337844003920.stgit@frogsfrogsfrogs>
In-Reply-To: <175708765008.3402543.1267087240583066803.stgit@frogsfrogsfrogs>
References: <175708765008.3402543.1267087240583066803.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Delete XREAP_MAX_BINVAL and XREAP_MAX_DEFER_CHAIN because the reap code
now calculates those limits dynamically, so they're no longer needed.

Move the third limit (XREP_MAX_ITRUNCATE_EFIS) to the one file that uses
it.  Note that the btree rebuilding code should reserve exactly the
number of blocks needed to rebuild a btree, so it is rare that the newbt
code will need to add any EFIs to the commit transaction.  That's why
that static limit remains.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/repair.h |    8 --------
 fs/xfs/scrub/newbt.c  |    9 +++++++++
 fs/xfs/scrub/reap.c   |    4 ----
 3 files changed, 9 insertions(+), 12 deletions(-)


diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 9c04295742c85f..2bb125c4f9bf2b 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -18,14 +18,6 @@ static inline int xrep_notsupported(struct xfs_scrub *sc)
 
 #ifdef CONFIG_XFS_ONLINE_REPAIR
 
-/*
- * This is the maximum number of deferred extent freeing item extents (EFIs)
- * that we'll attach to a transaction without rolling the transaction to avoid
- * overrunning a tr_itruncate reservation.
- */
-#define XREP_MAX_ITRUNCATE_EFIS	(128)
-
-
 /* Repair helpers */
 
 int xrep_attempt(struct xfs_scrub *sc, struct xchk_stats_run *run);
diff --git a/fs/xfs/scrub/newbt.c b/fs/xfs/scrub/newbt.c
index 1588ce971cb8e1..951ae8b71566c2 100644
--- a/fs/xfs/scrub/newbt.c
+++ b/fs/xfs/scrub/newbt.c
@@ -27,6 +27,15 @@
 #include "scrub/repair.h"
 #include "scrub/newbt.h"
 
+/*
+ * This is the maximum number of deferred extent freeing item extents (EFIs)
+ * that we'll attach to a transaction without rolling the transaction to avoid
+ * overrunning a tr_itruncate reservation.  The newbt code should reserve
+ * exactly the correct number of blocks to rebuild the btree, so there should
+ * not be any excess blocks to free when committing a new btree.
+ */
+#define XREP_MAX_ITRUNCATE_EFIS	(128)
+
 /*
  * Estimate proper slack values for a btree that's being reloaded.
  *
diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
index d58fd57aaebb43..82910188111dd7 100644
--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -171,8 +171,6 @@ static inline bool xreap_is_dirty(const struct xreap_state *rs)
 	return rs->nr_binval > 0 || rs->nr_deferred > 0;
 }
 
-#define XREAP_MAX_BINVAL	(2048)
-
 /*
  * Decide if we need to roll the transaction to clear out the the log
  * reservation that we allocated to buffer invalidations.
@@ -198,8 +196,6 @@ static inline bool xreap_inc_binval(struct xreap_state *rs)
 	return rs->nr_binval < rs->max_binval;
 }
 
-#define XREAP_MAX_DEFER_CHAIN		(2048)
-
 /*
  * Decide if we want to finish the deferred ops that are attached to the scrub
  * transaction.  We don't want to queue huge chains of deferred ops because

