Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 820B5F9E9
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 18:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717441177; cv=none; b=hVuJSdkKTmLCM7t1UnOIFGaLnOwZzgnqU8HakHSsGt39Mca7F2TzYtKWGGGpqTDgSMMG+vGpMCUzFB+PpZqjzYOQZk6MgENv8cc2EmrH9tj5avNSKdNk3UUOkoLKtoDtVfgkjBSAK1l6EdCrptvBFZaJGZA5fJLwu+ie51vCmFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717441177; c=relaxed/simple;
	bh=IGqW+OXbUa2NkzGb786vxznXZM3OchtyK8LmM1NUA6I=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JZSiq+CLPSQwjRAEjqZG5BOKpc+dx1aRZu6po5zUA7L5kN25sDfvF28Sh3p1Vrm5k3puBYMhnAkswFrt9w4UOx9W+IzJH9d0pGQXCOsE5yFR8gI1eiEF3nUx5U9UD/H+Xly2kShWaboglcqcn7vt39DhM9nOi5jNITtMJIVlgY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j56JpUjp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j56JpUjp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59512C2BD10;
	Mon,  3 Jun 2024 18:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717441177;
	bh=IGqW+OXbUa2NkzGb786vxznXZM3OchtyK8LmM1NUA6I=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=j56JpUjpUTsL5vK12xroVUUMyq5kYXxCMM7eCk/F6IoHZ+we+bCFDjP5nVvr/JBSE
	 y5tZIg8OjdeewcJoUY/Y35nxYtSeP+869q4ubgcRxoxzjuJJb9Hd7aXlcfD933xt/e
	 spFhXlv4wbCTCJca0b50sAGQcyGGpu2cum5k9MElgBXkQFej/DbK3ljSXAVdFbRTPb
	 S/tYuEgg2oj2exPrvdXAXpCzApt6JvGTtre0GEh77RYTZS43ODktalh7yx2qyI4Cs+
	 GSjftfCgEM6motJDwQW7/WR2BlomQBgs1YnVa6TrJ2XHdPobiwGXYK5EiHAqxwUJck
	 xdvL5aOumo3cA==
Date: Mon, 03 Jun 2024 11:59:36 -0700
Subject: [PATCH 029/111] xfs: consolidate btree block allocation tracepoints
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cmaiolino@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171744039806.1443973.18189565954175495498.stgit@frogsfrogsfrogs>
In-Reply-To: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
References: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
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
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 include/xfs_trace.h         |    4 +---
 libxfs/xfs_btree.c          |   20 +++++++++++++++++---
 libxfs/xfs_refcount_btree.c |    2 --
 libxfs/xfs_rmap_btree.c     |    2 --
 4 files changed, 18 insertions(+), 10 deletions(-)


diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index 98819653b..e7cbd0d9d 100644
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
index fb36a3b69..3a2b627fd 100644
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
index 67551df02..9a3c2270c 100644
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
index 7966a3e6a..e894a22e0 100644
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

