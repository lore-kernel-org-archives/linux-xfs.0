Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62B111D53C
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711424159; cv=none; b=IM7ISC2B90UIq2f0zUttX0gD+XY29uMngfUbQ3RfOO6ERpvEPstc4OtZrpWSNgZw3D1V/MuiDgH2GMTqBhS3YLvd8u70AcaukOPn7Ky6ZOImyG4qitNNZCz0el1OlIYlI9HqV5eiO94C0IHYZl9PRm11zaYZHz/DS5vZ+1mHox0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711424159; c=relaxed/simple;
	bh=4Ekpzz1Z0QCSiX2CiuBdEPd23BR1+qL5phPHyOhD6KQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AWoM4lw8CAlkRm0BLftWtwihP7eoHdmA/jxKfe0I9Hiep60eJgaDHMleUvQGElj/+ZPcD4xaPo6fwjMwROY18sSAGaS3Xn3EgXUsVUWB11PMJoeW6QG1F5A6srOiI3geZqog+7wPqBQTCfbsbucPRucMju5dj78v2Z6rHSQhqD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f6/6qpz0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f6/6qpz0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F4154C433C7;
	Tue, 26 Mar 2024 03:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711424159;
	bh=4Ekpzz1Z0QCSiX2CiuBdEPd23BR1+qL5phPHyOhD6KQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=f6/6qpz0El4j8GtnJw3r6rSeQkrWqs8Wk0ABqCRLHRBRNA8F/UtxrjL9V4HTRVq/e
	 QkmujmMGMDqMpEZhy/K+aqjG/DmmlrI+vwa/UYHeoj9m1mByOEcd8Tudddm6JiaAAo
	 H+jkCqLYq2PjH6q68nyVoWNJ0h7b7nXvErvA74N/4M1dAjHhc/ZqI6EayHXCbFISrS
	 Oyz+ItI7ZW7I3olHZG1GRyJom9xCcqR8sYX5hthHTb/yYP8yrmnP7ptEtmiK5f6DYX
	 u3Ipl9PVTgocIbyowjt5h1HhR3os3kDvfgQ0Wj1QlD+79FYGMlSLfIsRXxyXtJ3wc5
	 WJBp3qW1JPJHw==
Date: Mon, 25 Mar 2024 20:35:58 -0700
Subject: [PATCH 029/110] xfs: consolidate btree block allocation tracepoints
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142131802.2215168.11974263705676509595.stgit@frogsfrogsfrogs>
In-Reply-To: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
References: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
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

Source kernel commit: 2ed0b2c7f33159825af1a1a83face66edb52348a

Don't waste tracepoint segment memory on per-btree block allocation
tracepoints when we can do it from the generic btree code.

With this patch applied, two tracepoints are collapsed into one
tracepoint, with the following effects on objdump -hx xfs.ko output:

Before:

10 __tracepoints_ptrs 00000b38  0000000000000000  0000000000000000  001412f0  2**2
14 __tracepoints_strings 00005433  0000000000000000  0000000000000000  001689a0  2**5
29 __tracepoints 00010d30  0000000000000000  0000000000000000  0023fe00  2**5

After:

10 __tracepoints_ptrs 00000b34  0000000000000000  0000000000000000  001417b0  2**2
14 __tracepoints_strings 00005413  0000000000000000  0000000000000000  00168e80  2**5
29 __tracepoints 00010cd0  0000000000000000  0000000000000000  00240760  2**5

Column 3 is the section size in bytes; removing these two tracepoints
reduces the size of the ELF segments by 132 bytes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/xfs_trace.h         |    4 +---
 libxfs/xfs_btree.c          |   20 +++++++++++++++++---
 libxfs/xfs_refcount_btree.c |    2 --
 libxfs/xfs_rmap_btree.c     |    2 --
 4 files changed, 18 insertions(+), 10 deletions(-)


diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index 98819653bcb0..e7cbd0d9d416 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -69,6 +69,7 @@
 #define trace_xfs_btree_bload_level_geometry(a,b,c,d,e,f,g) ((void) 0)
 #define trace_xfs_btree_bload_block(a,b,c,d,e,f) ((void) 0)
 #define trace_xfs_btree_free_block(...)		((void) 0)
+#define trace_xfs_btree_alloc_block(...)	((void) 0)
 
 #define trace_xfs_free_extent(a,b,c,d,e,f,g)	((void) 0)
 #define trace_xfs_agf(a,b,c,d)			((void) 0)
@@ -257,8 +258,6 @@
 #define trace_xfs_rmap_find_left_neighbor_result(...)	((void) 0)
 #define trace_xfs_rmap_lookup_le_range_result(...)	((void) 0)
 
-#define trace_xfs_rmapbt_alloc_block(...)	((void) 0)
-
 #define trace_xfs_ag_resv_critical(...)		((void) 0)
 #define trace_xfs_ag_resv_needed(...)		((void) 0)
 #define trace_xfs_ag_resv_free(...)		((void) 0)
@@ -276,7 +275,6 @@
 #define trace_xfs_refcount_insert_error(...)	((void) 0)
 #define trace_xfs_refcount_delete(...)		((void) 0)
 #define trace_xfs_refcount_delete_error(...)	((void) 0)
-#define trace_xfs_refcountbt_alloc_block(...)	((void) 0)
 #define trace_xfs_refcount_rec_order_error(...)	((void) 0)
 
 #define trace_xfs_refcount_lookup(...)		((void) 0)
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index fb36a3b69ea0..3a2b627fd6be 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -2690,6 +2690,20 @@ xfs_btree_rshift(
 	return error;
 }
 
+static inline int
+xfs_btree_alloc_block(
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_ptr	*hint_block,
+	union xfs_btree_ptr		*new_block,
+	int				*stat)
+{
+	int				error;
+
+	error = cur->bc_ops->alloc_block(cur, hint_block, new_block, stat);
+	trace_xfs_btree_alloc_block(cur, new_block, *stat, error);
+	return error;
+}
+
 /*
  * Split cur/level block in half.
  * Return new block number and the key to its first
@@ -2733,7 +2747,7 @@ __xfs_btree_split(
 	xfs_btree_buf_to_ptr(cur, lbp, &lptr);
 
 	/* Allocate the new block. If we can't do it, we're toast. Give up. */
-	error = cur->bc_ops->alloc_block(cur, &lptr, &rptr, stat);
+	error = xfs_btree_alloc_block(cur, &lptr, &rptr, stat);
 	if (error)
 		goto error0;
 	if (*stat == 0)
@@ -3013,7 +3027,7 @@ xfs_btree_new_iroot(
 	pp = xfs_btree_ptr_addr(cur, 1, block);
 
 	/* Allocate the new block. If we can't do it, we're toast. Give up. */
-	error = cur->bc_ops->alloc_block(cur, pp, &nptr, stat);
+	error = xfs_btree_alloc_block(cur, pp, &nptr, stat);
 	if (error)
 		goto error0;
 	if (*stat == 0)
@@ -3113,7 +3127,7 @@ xfs_btree_new_root(
 	cur->bc_ops->init_ptr_from_cur(cur, &rptr);
 
 	/* Allocate the new block. If we can't do it, we're toast. Give up. */
-	error = cur->bc_ops->alloc_block(cur, &rptr, &lptr, stat);
+	error = xfs_btree_alloc_block(cur, &rptr, &lptr, stat);
 	if (error)
 		goto error0;
 	if (*stat == 0)
diff --git a/libxfs/xfs_refcount_btree.c b/libxfs/xfs_refcount_btree.c
index 67551df02bde..9a3c2270c254 100644
--- a/libxfs/xfs_refcount_btree.c
+++ b/libxfs/xfs_refcount_btree.c
@@ -76,8 +76,6 @@ xfs_refcountbt_alloc_block(
 					xfs_refc_block(args.mp)));
 	if (error)
 		goto out_error;
-	trace_xfs_refcountbt_alloc_block(cur->bc_mp, cur->bc_ag.pag->pag_agno,
-			args.agbno, 1);
 	if (args.fsbno == NULLFSBLOCK) {
 		*stat = 0;
 		return 0;
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index 7966a3e6a474..e894a22e087c 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -92,8 +92,6 @@ xfs_rmapbt_alloc_block(
 				       &bno, 1);
 	if (error)
 		return error;
-
-	trace_xfs_rmapbt_alloc_block(cur->bc_mp, pag->pag_agno, bno, 1);
 	if (bno == NULLAGBLOCK) {
 		*stat = 0;
 		return 0;

