Received: from beige.elm.relay.mailchannels.net (beige.elm.relay.mailchannels.net [23.83.212.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C23A2F50
	for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2024 20:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.212.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718310911; cv=pass; b=Eh8otyRy/0AOZ8OiyVKAUzaE4+ysIVPkBHkmEEP6omcoQDLl/tgO8VxT+Tgz1Xs3nYNCvexYG9mgeFNdiXVI7/5kRC7R9b5I/NRNKOLASdCtG9sBjq3M3bhh3aLZCK5kD0ETcJi8SKf8AzrsDYsMIE/aKpkF11eGXKrkoGXt7dI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718310911; c=relaxed/simple;
	bh=kgQYnBrCdFlJPQrtHghs5FV9jeOUmrC41FJ6dOK2GAU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J3Go8UBDOkpKfgvO5WZJpyQz2ut4qzMHmeatydlHzeqyyK28cHm1ZGZ+bRu+NybROURy+MnYE/jAfh4WCYs56IrnDvbCXUoCmwff1O9XMWFCZPnwzYcry32qsX70X7R+z/z3broTRQyL/LL1RGNOHe9LXvqfL6qMRreJMihOlGw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=templeofstupid.com; spf=pass smtp.mailfrom=templeofstupid.com; dkim=pass (2048-bit key) header.d=templeofstupid.com header.i=@templeofstupid.com header.b=jY6y+7iR; arc=pass smtp.client-ip=23.83.212.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=templeofstupid.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=templeofstupid.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=templeofstupid.com header.i=@templeofstupid.com header.b="jY6y+7iR"
X-Sender-Id: dreamhost|x-authsender|kjlx@templeofstupid.com
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id A95D8943416
	for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2024 20:27:37 +0000 (UTC)
Received: from pdx1-sub0-mail-a231.dreamhost.com (unknown [127.0.0.6])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 9BD8A94336C
	for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2024 20:27:36 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1718310456; a=rsa-sha256;
	cv=none;
	b=mkNpErKHpa1D9HGP4PW/6DBfaPFIFfQoG5dOXqmAn4qTPzWQAmxI2VaboKvHA1f2ZSTnmw
	jTf9P2mC9aHER5rRobcPO5SvRFgS4KpkSLAv5jOta7dK/xpknIkqogkmicqnjVDNKQRD4i
	6SDZeax59OV5O/OEEUDPoVegvBqXG/xpUk+0DGwvwTl91UeRwvhTItZitEYnfLMm7nmGzW
	X70SewaioMW+k9fv0Oyj8ip7pOUcMe6Tmcb82ByQqrNoclnuOeUlAbPL5dufVI34ohnxPw
	6lcASgOSrL8Y1L0eMLM/U+tPi6RQ/bAYRUpogLxrZjWjaNVLJ9vfkmfZJbDrlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1718310456;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1iSCtRGrKFJDNMmzLAtrQCKn5WonABpNq9YSs++ns8w=;
	b=pbVfKSjoqE2bVD5Pn69d4ahg+x+UXd8tRTMsznFeE9lRhMUqnT04LW/IF90ipD63Kpn+Tm
	sQgFwb9tVZOaVMnscbiGzX36Bi5LjtPYEx3JgmFOM1pk8yho5YSHqzUONIMzoWviCLPLsE
	OQw6omyTJotkWftKEHA4geUiCOKC+T6aAUu0oD0g8To1KiW4Z+uvEu/+lhnNXnRAD2Vlza
	myU0W8nF6G5/HlRbkodozQO4yrryxb8AlGY0OXBHmnp4HHv9uGlX9QlNbPXImp4+JTo9qY
	8CCG1irSGq475K08KfJxhpyPlxwY/EsQKKlmBKONcjUlJGRR0uYdJoxSJizeAA==
ARC-Authentication-Results: i=1;
	rspamd-79677bdb95-kt8wt;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=kjlx@templeofstupid.com
X-Sender-Id: dreamhost|x-authsender|kjlx@templeofstupid.com
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|kjlx@templeofstupid.com
X-MailChannels-Auth-Id: dreamhost
X-Trade-Grain: 71b4e99938561c5f_1718310457630_367315211
X-MC-Loop-Signature: 1718310457629:4223977573
X-MC-Ingress-Time: 1718310457629
Received: from pdx1-sub0-mail-a231.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.110.173.217 (trex/6.9.2);
	Thu, 13 Jun 2024 20:27:37 +0000
Received: from kmjvbox.templeofstupid.com (c-73-70-109-47.hsd1.ca.comcast.net [73.70.109.47])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kjlx@templeofstupid.com)
	by pdx1-sub0-mail-a231.dreamhost.com (Postfix) with ESMTPSA id 4W0Yqr2vs5z1y
	for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2024 13:27:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=templeofstupid.com;
	s=dreamhost; t=1718310456;
	bh=1iSCtRGrKFJDNMmzLAtrQCKn5WonABpNq9YSs++ns8w=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=jY6y+7iR9wSvTbZn7xqUy/wEJfrO9RhC2WG9v0puqW22MS5zcFTTLiU6MbpEXpgqE
	 3p80As4RfjzqVUrBNQlGeozlXVRVdmoJSd1dWNmTifgRcRFveY/7LIacfNkd6uo6ea
	 FIHPTm1KpfXovJ0mflyri0ADrVp6dLsJrpNkv6vKKCCZYfa+JRnM6NkqAvCyB9H1zK
	 WbIgPh6luZ3kPCV4WM/jTMYCw7xvU6qOGcTy60hhBcBIwvbh+KvLC3tvwOGCNHnBtR
	 3iQU7R59mWvQ/VDiq7uz0mMMJFEgpIdbYqe4x8A5M4n32DR2Uvk1COXEIKXfnAiCzn
	 H7A/e7aStmBYQ==
Received: from johansen (uid 1000)
	(envelope-from kjlx@templeofstupid.com)
	id e006b
	by kmjvbox.templeofstupid.com (DragonFly Mail Agent v0.12);
	Thu, 13 Jun 2024 13:27:26 -0700
Date: Thu, 13 Jun 2024 13:27:26 -0700
From: Krister Johansen <kjlx@templeofstupid.com>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>
Cc: Gao Xiang <xiang@kernel.org>, linux-xfs@vger.kernel.org
Subject: [RFC PATCH 1/4] xfs: resurrect the AGFL reservation
Message-ID: <0dfbe8d00d2be53999b20e336641ba3d60306ffa.1718232004.git.kjlx@templeofstupid.com>
References: <cover.1718232004.git.kjlx@templeofstupid.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1718232004.git.kjlx@templeofstupid.com>

Transactions that perform multiple allocations may inadvertently run out
of space after the first allocation selects an AG that appears to have
enough available space.  The problem occurs when the allocation in the
transaction splits freespace b-trees but the second allocation does not
have enough available space to refill the AGFL.  This results in an
aborted transaction and a filesystem shutdown.  In this author's case,
it's frequently encountered in the xfs_bmap_extents_to_btree path on a
write to an AG that's almost reached its limits.

The AGFL reservation allows us to save some blocks to refill the AGFL to
its minimum level in an Nth allocation, and to prevent allocations from
proceeding when there's not enough reserved space to accommodate the
refill.

This patch just brings back the reservation and does the plumbing.  The
policy decisions about which allocations to allow will be in a
subsequent patch.

This implementation includes space for the bnobt and cnobt in the
reserve.  This was done largely because the AGFL reserve stubs appeared
to already be doing it this way.

Signed-off-by: Krister Johansen <kjlx@templeofstupid.com>
---
 fs/xfs/libxfs/xfs_ag.h          |  2 ++
 fs/xfs/libxfs/xfs_ag_resv.c     | 54 ++++++++++++++++++++++--------
 fs/xfs/libxfs/xfs_ag_resv.h     |  4 +++
 fs/xfs/libxfs/xfs_alloc.c       | 43 +++++++++++++++++++++++-
 fs/xfs/libxfs/xfs_alloc.h       |  3 +-
 fs/xfs/libxfs/xfs_alloc_btree.c | 59 +++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_alloc_btree.h |  5 +++
 fs/xfs/libxfs/xfs_rmap_btree.c  |  5 +++
 fs/xfs/scrub/fscounters.c       |  1 +
 9 files changed, 161 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index 35de09a2516c..40bff82f2b7e 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -62,6 +62,8 @@ struct xfs_perag {
 	struct xfs_ag_resv	pag_meta_resv;
 	/* Blocks reserved for the reverse mapping btree. */
 	struct xfs_ag_resv	pag_rmapbt_resv;
+	/* Blocks reserved for the AGFL. */
+	struct xfs_ag_resv	pag_agfl_resv;
 
 	/* for rcu-safe freeing */
 	struct rcu_head	rcu_head;
diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
index 216423df939e..db1d416f6ac8 100644
--- a/fs/xfs/libxfs/xfs_ag_resv.c
+++ b/fs/xfs/libxfs/xfs_ag_resv.c
@@ -17,6 +17,7 @@
 #include "xfs_trans.h"
 #include "xfs_rmap_btree.h"
 #include "xfs_btree.h"
+#include "xfs_alloc_btree.h"
 #include "xfs_refcount_btree.h"
 #include "xfs_ialloc_btree.h"
 #include "xfs_ag.h"
@@ -75,12 +76,14 @@ xfs_ag_resv_critical(
 
 	switch (type) {
 	case XFS_AG_RESV_METADATA:
-		avail = pag->pagf_freeblks - pag->pag_rmapbt_resv.ar_reserved;
+		avail = pag->pagf_freeblks - pag->pag_rmapbt_resv.ar_reserved -
+		    pag->pag_agfl_resv.ar_reserved;
 		orig = pag->pag_meta_resv.ar_asked;
 		break;
 	case XFS_AG_RESV_RMAPBT:
 		avail = pag->pagf_freeblks + pag->pagf_flcount -
-			pag->pag_meta_resv.ar_reserved;
+			pag->pag_meta_resv.ar_reserved -
+			pag->pag_agfl_resv.ar_reserved;
 		orig = pag->pag_rmapbt_resv.ar_asked;
 		break;
 	default:
@@ -107,10 +110,14 @@ xfs_ag_resv_needed(
 {
 	xfs_extlen_t			len;
 
-	len = pag->pag_meta_resv.ar_reserved + pag->pag_rmapbt_resv.ar_reserved;
+	len = pag->pag_meta_resv.ar_reserved +
+	    pag->pag_rmapbt_resv.ar_reserved +
+	    pag->pag_agfl_resv.ar_reserved;
+
 	switch (type) {
 	case XFS_AG_RESV_METADATA:
 	case XFS_AG_RESV_RMAPBT:
+	case XFS_AG_RESV_AGFL:
 		len -= xfs_perag_resv(pag, type)->ar_reserved;
 		break;
 	case XFS_AG_RESV_NONE:
@@ -144,7 +151,7 @@ __xfs_ag_resv_free(
 	 * considered "free", so whatever was reserved at mount time must be
 	 * given back at umount.
 	 */
-	if (type == XFS_AG_RESV_RMAPBT)
+	if (type == XFS_AG_RESV_RMAPBT || type == XFS_AG_RESV_AGFL)
 		oldresv = resv->ar_orig_reserved;
 	else
 		oldresv = resv->ar_reserved;
@@ -161,6 +168,7 @@ xfs_ag_resv_free(
 {
 	__xfs_ag_resv_free(pag, XFS_AG_RESV_RMAPBT);
 	__xfs_ag_resv_free(pag, XFS_AG_RESV_METADATA);
+	__xfs_ag_resv_free(pag, XFS_AG_RESV_AGFL);
 }
 
 static int
@@ -180,11 +188,13 @@ __xfs_ag_resv_init(
 
 	switch (type) {
 	case XFS_AG_RESV_RMAPBT:
+	case XFS_AG_RESV_AGFL:
 		/*
-		 * Space taken by the rmapbt is not subtracted from fdblocks
-		 * because the rmapbt lives in the free space.  Here we must
-		 * subtract the entire reservation from fdblocks so that we
-		 * always have blocks available for rmapbt expansion.
+		 * Space taken by the rmapbt and agfl are not subtracted from
+		 * fdblocks because they both live in the free space.  Here we
+		 * must subtract the entire reservation from fdblocks so that we
+		 * always have blocks available for rmapbt expansion and agfl
+		 * refilling.
 		 */
 		hidden_space = ask;
 		break;
@@ -299,6 +309,25 @@ xfs_ag_resv_init(
 			has_resv = true;
 	}
 
+	/* Create the AGFL reservation */
+	if (pag->pag_agfl_resv.ar_asked == 0) {
+		ask = used = 0;
+
+		error = xfs_allocbt_calc_reserves(mp, tp, pag, &ask, &used);
+		if (error)
+			goto out;
+
+		error = xfs_alloc_agfl_calc_reserves(mp, tp, pag, &ask, &used);
+		if (error)
+			goto out;
+
+		error = __xfs_ag_resv_init(pag, XFS_AG_RESV_AGFL, ask, used);
+		if (error)
+			goto out;
+		if (ask)
+			has_resv = true;
+	}
+
 out:
 	/*
 	 * Initialize the pagf if we have at least one active reservation on the
@@ -324,7 +353,8 @@ xfs_ag_resv_init(
 		 */
 		if (!error &&
 		    xfs_perag_resv(pag, XFS_AG_RESV_METADATA)->ar_reserved +
-		    xfs_perag_resv(pag, XFS_AG_RESV_RMAPBT)->ar_reserved >
+		    xfs_perag_resv(pag, XFS_AG_RESV_RMAPBT)->ar_reserved +
+		    xfs_perag_resv(pag, XFS_AG_RESV_AGFL)->ar_reserved >
 		    pag->pagf_freeblks + pag->pagf_flcount)
 			error = -ENOSPC;
 	}
@@ -347,7 +377,6 @@ xfs_ag_resv_alloc_extent(
 
 	switch (type) {
 	case XFS_AG_RESV_AGFL:
-		return;
 	case XFS_AG_RESV_METADATA:
 	case XFS_AG_RESV_RMAPBT:
 		resv = xfs_perag_resv(pag, type);
@@ -364,7 +393,7 @@ xfs_ag_resv_alloc_extent(
 
 	len = min_t(xfs_extlen_t, args->len, resv->ar_reserved);
 	resv->ar_reserved -= len;
-	if (type == XFS_AG_RESV_RMAPBT)
+	if (type == XFS_AG_RESV_RMAPBT || type == XFS_AG_RESV_AGFL)
 		return;
 	/* Allocations of reserved blocks only need on-disk sb updates... */
 	xfs_trans_mod_sb(args->tp, XFS_TRANS_SB_RES_FDBLOCKS, -(int64_t)len);
@@ -389,7 +418,6 @@ xfs_ag_resv_free_extent(
 
 	switch (type) {
 	case XFS_AG_RESV_AGFL:
-		return;
 	case XFS_AG_RESV_METADATA:
 	case XFS_AG_RESV_RMAPBT:
 		resv = xfs_perag_resv(pag, type);
@@ -406,7 +434,7 @@ xfs_ag_resv_free_extent(
 
 	leftover = min_t(xfs_extlen_t, len, resv->ar_asked - resv->ar_reserved);
 	resv->ar_reserved += leftover;
-	if (type == XFS_AG_RESV_RMAPBT)
+	if (type == XFS_AG_RESV_RMAPBT || type == XFS_AG_RESV_AGFL)
 		return;
 	/* Freeing into the reserved pool only requires on-disk update... */
 	xfs_trans_mod_sb(tp, XFS_TRANS_SB_RES_FDBLOCKS, len);
diff --git a/fs/xfs/libxfs/xfs_ag_resv.h b/fs/xfs/libxfs/xfs_ag_resv.h
index ff20ed93de77..ea2c16dfb843 100644
--- a/fs/xfs/libxfs/xfs_ag_resv.h
+++ b/fs/xfs/libxfs/xfs_ag_resv.h
@@ -28,6 +28,8 @@ xfs_perag_resv(
 		return &pag->pag_meta_resv;
 	case XFS_AG_RESV_RMAPBT:
 		return &pag->pag_rmapbt_resv;
+	case XFS_AG_RESV_AGFL:
+		return &pag->pag_agfl_resv;
 	default:
 		return NULL;
 	}
@@ -48,6 +50,8 @@ xfs_ag_resv_rmapbt_alloc(
 
 	args.len = 1;
 	pag = xfs_perag_get(mp, agno);
+	/* Transfer this reservation from the AGFL to RMAPBT */
+	xfs_ag_resv_free_extent(pag, XFS_AG_RESV_AGFL, NULL, 1);
 	xfs_ag_resv_alloc_extent(pag, XFS_AG_RESV_RMAPBT, &args);
 	xfs_perag_put(pag);
 }
diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 6c55a6e88eba..d70d027a8178 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1176,12 +1176,14 @@ xfs_alloc_ag_vextent_small(
 
 	/*
 	 * If we're feeding an AGFL block to something that doesn't live in the
-	 * free space, we need to clear out the OWN_AG rmap.
+	 * free space, we need to clear out the OWN_AG rmap and remove it from
+	 * the AGFL reservation.
 	 */
 	error = xfs_rmap_free(args->tp, args->agbp, args->pag, fbno, 1,
 			      &XFS_RMAP_OINFO_AG);
 	if (error)
 		goto error;
+	xfs_ag_resv_free_extent(args->pag, XFS_AG_RESV_AGFL, args->tp, 1);
 
 	*stat = 0;
 	return 0;
@@ -2778,6 +2780,43 @@ xfs_exact_minlen_extent_available(
 }
 #endif
 
+/*
+ * Work out how many blocks to reserve for the AGFL as well as how many are in
+ * use currently.
+ */
+int
+xfs_alloc_agfl_calc_reserves(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	struct xfs_perag	*pag,
+	xfs_extlen_t		*ask,
+	xfs_extlen_t		*used)
+{
+	struct xfs_buf		*agbp;
+	struct xfs_agf		*agf;
+	xfs_extlen_t		agfl_blocks;
+	xfs_extlen_t		list_len;
+	int			error;
+
+	error = xfs_alloc_read_agf(pag, tp, 0, &agbp);
+	if (error)
+		return error;
+
+	agf = agbp->b_addr;
+	agfl_blocks = xfs_alloc_min_freelist(mp, NULL);
+	list_len = be32_to_cpu(agf->agf_flcount);
+	xfs_trans_brelse(tp, agbp);
+
+	/*
+	 * Reserve enough space to refill AGFL to minimum fullness if btrees are
+	 * at maximum height.
+	 */
+	*ask += agfl_blocks;
+	*used += list_len;
+
+	return error;
+}
+
 /*
  * Decide whether to use this allocation group for this allocation.
  * If so, fix up the btree freelist's size.
@@ -2944,6 +2983,8 @@ xfs_alloc_fix_freelist(
 		if (error)
 			goto out_agflbp_relse;
 
+		xfs_ag_resv_alloc_extent(targs.pag, targs.resv, &targs);
+
 		/*
 		 * Put each allocated block on the list.
 		 */
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index 0b956f8b9d5a..8cbdfb62ac14 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -80,7 +80,8 @@ int xfs_alloc_get_freelist(struct xfs_perag *pag, struct xfs_trans *tp,
 int xfs_alloc_put_freelist(struct xfs_perag *pag, struct xfs_trans *tp,
 		struct xfs_buf *agfbp, struct xfs_buf *agflbp,
 		xfs_agblock_t bno, int btreeblk);
-
+int xfs_alloc_agfl_calc_reserves(struct xfs_mount *mp, struct xfs_trans *tp,
+		struct xfs_perag *pag, xfs_extlen_t *ask, xfs_extlen_t *used);
 /*
  * Compute and fill in value of m_alloc_maxlevels.
  */
diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index 6ef5ddd89600..9c20f85a459d 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -671,6 +671,65 @@ xfs_allocbt_calc_size(
 	return xfs_btree_calc_size(mp->m_alloc_mnr, len);
 }
 
+/*
+ * Calculate the maximum alloc btree size.  This is for a single allocbt.
+ * Callers wishing to compute both the size of the bnobt and cnobt must double
+ * this result.
+ */
+xfs_extlen_t
+xfs_allocbt_max_size(
+	struct xfs_mount	*mp,
+	xfs_agblock_t		agblocks)
+{
+
+	/* Don't proceed if uninitialized.  Can happen in mkfs. */
+	if (mp->m_alloc_mxr[0] == 0)
+		return 0;
+
+	return xfs_allocbt_calc_size(mp, agblocks);
+}
+
+/*
+ * Work out how many blocks to reserve for the bnobt and the cnobt as well as
+ * how many blocks are in use by these trees.
+ */
+int
+xfs_allocbt_calc_reserves(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	struct xfs_perag	*pag,
+	xfs_extlen_t		*ask,
+	xfs_extlen_t		*used)
+{
+	struct xfs_buf		*agbp;
+	struct xfs_agf		*agf;
+	xfs_agblock_t		agblocks;
+	xfs_extlen_t		tree_len;
+	int			error;
+
+	error = xfs_alloc_read_agf(pag, tp, 0, &agbp);
+	if (error)
+		return error;
+
+	agf = agbp->b_addr;
+	agblocks = be32_to_cpu(agf->agf_length);
+	tree_len = be32_to_cpu(agf->agf_btreeblks);
+	xfs_trans_brelse(tp, agbp);
+
+	/*
+	 * The log is permanently allocated. The space it occupies will never be
+	 * available for btree expansion.  Pretend the space is not there.
+	 */
+	if (xfs_ag_contains_log(mp, pag->pag_agno))
+		agblocks -= mp->m_sb.sb_logblocks;
+
+	/* Reserve 1% of the AG or enough for one block per record per tree. */
+	*ask += max(agblocks / 100, 2 * xfs_allocbt_max_size(mp, agblocks));
+	*used += tree_len;
+
+	return error;
+}
+
 int __init
 xfs_allocbt_init_cur_cache(void)
 {
diff --git a/fs/xfs/libxfs/xfs_alloc_btree.h b/fs/xfs/libxfs/xfs_alloc_btree.h
index 155b47f231ab..8334195e2462 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.h
+++ b/fs/xfs/libxfs/xfs_alloc_btree.h
@@ -56,6 +56,11 @@ struct xfs_btree_cur *xfs_cntbt_init_cursor(struct xfs_mount *mp,
 extern int xfs_allocbt_maxrecs(struct xfs_mount *, int, int);
 extern xfs_extlen_t xfs_allocbt_calc_size(struct xfs_mount *mp,
 		unsigned long long len);
+extern xfs_extlen_t xfs_allocbt_max_size(struct xfs_mount *mp,
+		xfs_agblock_t agblocks);
+
+extern int xfs_allocbt_calc_reserves(struct xfs_mount *mp, struct xfs_trans *tp,
+		struct xfs_perag *pag, xfs_extlen_t *ask, xfs_extlen_t *used);
 
 void xfs_allocbt_commit_staged_btree(struct xfs_btree_cur *cur,
 		struct xfs_trans *tp, struct xfs_buf *agbp);
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index 9e759efa81cc..49b1652f715a 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -121,6 +121,7 @@ xfs_rmapbt_free_block(
 	struct xfs_buf		*agbp = cur->bc_ag.agbp;
 	struct xfs_agf		*agf = agbp->b_addr;
 	struct xfs_perag	*pag = cur->bc_ag.pag;
+	struct xfs_alloc_arg	args = { NULL };
 	xfs_agblock_t		bno;
 	int			error;
 
@@ -135,6 +136,10 @@ xfs_rmapbt_free_block(
 			      XFS_EXTENT_BUSY_SKIP_DISCARD);
 
 	xfs_ag_resv_free_extent(pag, XFS_AG_RESV_RMAPBT, NULL, 1);
+	args.len = 1;
+	/* Transfer this reservation back to the AGFL. */
+	xfs_ag_resv_alloc_extent(pag, XFS_AG_RESV_AGFL, &args);
+
 	return 0;
 }
 
diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
index 1d3e98346933..fec4aa13052a 100644
--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -338,6 +338,7 @@ xchk_fscount_aggregate_agcounts(
 		 */
 		fsc->fdblocks -= pag->pag_meta_resv.ar_reserved;
 		fsc->fdblocks -= pag->pag_rmapbt_resv.ar_orig_reserved;
+		fsc->fdblocks -= pag->pag_agfl_resv.ar_orig_reserved;
 
 	}
 	if (pag)
-- 
2.25.1

