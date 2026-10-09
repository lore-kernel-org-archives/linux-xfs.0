Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3E9837A822;
	Fri,  9 Oct 2026 06:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791526616; cv=none; b=JPHLFhVYj/0/w3QZb1WR4xedVyzbWPw+l3vVYglsc36WIMXje6WgqyzSxA/fJyHPqJrAMau5rSXsMsDe2XtEJtyJT9JWy3DcIvVVbM/zqa9Q3XimjjK2OSzI/kiEHm8jBHWDX2zAIiC3vyNBfn4/AilkrvXamQUO38mVF/Y3BOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791526616; c=relaxed/simple;
	bh=HT7IxYUi3zGTA8FOAaPbajatjzMw22Fbn5XRehifbL0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p5R1pU8u+B3wKlRnXIvPBrx7FmiQWVtoIubPdCBB9jA5thZGdBbTrHjcz3aRY1AMoEzB/vyRctk0/bUZymGqX81k23sCv8oPQmoYjKXU0rA3RfKv0Q2bPrBi2fyB/zpgQVxm5sKWhxvvcivBVjOGY3T9JAzeYDgTbRKGt5pXFHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MAAyoXFO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MAAyoXFO"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 329421F000FF;
	Fri,  9 Oct 2026 06:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791526615;
	bh=t73XSYnuU/zGE15MC1Gk/YkpGAWaCgHM6ACpaStLWSQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=MAAyoXFOVogc/zjcBJlAQc383VYswff+obzklAlijmnz+oDgR0OMj4CG8d+TrVTVf
	 xfbz19AutniIrxvYLfVJAnyUZGV/jlqKJ8Hhwr5ul9ryaq9c98h2zFaPADl6jgimMH
	 3JlEk1Nhz1c9acYBeBUasV3VVR32iHNqdB4o6Xbl+MBs+RHci0VA+dPKVridPjKQJu
	 LdLURLOY3PDf6kWY+vbPCVM7Qvi0VDZsu69829teX4s6zYGgkz0OCt5i6Y0a3CbORH
	 pGZw3dfqGM25p9gZ+Bp0Jq5QjrdK9vbI57Yf34nJNEVMLvA0WeTvS3jEfwwuZenA8H
	 JVsFjC2ihZZkw==
Date: Thu, 08 Oct 2026 23:16:54 -0700
Subject: [PATCH 08/13] xfs: range-check bc_levels array access in scrub
 tracepoints
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179151614793.3163896.17851091791534417053.stgit@frogsfrogsfrogs>
In-Reply-To: <179151614535.3163896.2744921556354655977.stgit@frogsfrogsfrogs>
References: <179151614535.3163896.2744921556354655977.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM noticed xchk_btree()'s odd habit of passing cur->bc_nlevels to
xchk_btree_ptr_ok when we're checking the pointer to the root block at
the start of the btree scan.  This enables us to skip checking the
pointer for an inode btree's root (since it doesn't have one) but
doesn't handle per-AG btrees quite correctly.  There isn't a problem for
__xfs_btree_check_ptr itself, but the corruption tracepoint naively
walks off the end of bc_level[].  Fix that by adding a helper to do an
implicit range check.

Cc: <stable@vger.kernel.org> # v5.16
Fixes: 6ca444cfd66354 ("xfs: prepare xfs_btree_cur for dynamic cursor heights")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/trace.h |   10 +++++-----
 fs/xfs/scrub/trace.c |   13 +++++++++++++
 2 files changed, 18 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index cb85f75ce10180..6b14b149b6000f 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -577,7 +577,7 @@ TRACE_EVENT(xchk_btree_op_error,
 		__entry->level = level;
 		__entry->agno = XFS_FSB_TO_AGNO(cur->bc_mp, fsbno);
 		__entry->bno = XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno);
-		__entry->ptr = cur->bc_levels[level].ptr;
+		__entry->ptr = xchk_btree_cur_ptr(cur, level);
 		__entry->error = error;
 		__entry->ret_ip = ret_ip;
 	),
@@ -618,7 +618,7 @@ TRACE_EVENT(xchk_ifork_btree_op_error,
 		__entry->type = sc->sm->sm_type;
 		__assign_str(name);
 		__entry->level = level;
-		__entry->ptr = cur->bc_levels[level].ptr;
+		__entry->ptr = xchk_btree_cur_ptr(cur, level);
 		__entry->agno = XFS_FSB_TO_AGNO(cur->bc_mp, fsbno);
 		__entry->bno = XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno);
 		__entry->error = error;
@@ -660,7 +660,7 @@ TRACE_EVENT(xchk_btree_error,
 		__entry->level = level;
 		__entry->agno = XFS_FSB_TO_AGNO(cur->bc_mp, fsbno);
 		__entry->bno = XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno);
-		__entry->ptr = cur->bc_levels[level].ptr;
+		__entry->ptr = xchk_btree_cur_ptr(cur, level);
 		__entry->ret_ip = ret_ip;
 	),
 	TP_printk("dev %d:%d type %s %sbt level %d ptr %d agno 0x%x agbno 0x%x ret_ip %pS",
@@ -700,7 +700,7 @@ TRACE_EVENT(xchk_ifork_btree_error,
 		__entry->level = level;
 		__entry->agno = XFS_FSB_TO_AGNO(cur->bc_mp, fsbno);
 		__entry->bno = XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno);
-		__entry->ptr = cur->bc_levels[level].ptr;
+		__entry->ptr = xchk_btree_cur_ptr(cur, level);
 		__entry->ret_ip = ret_ip;
 	),
 	TP_printk("dev %d:%d ino 0x%llx fork %s type %s %sbt level %d ptr %d agno 0x%x agbno 0x%x ret_ip %pS",
@@ -740,7 +740,7 @@ DECLARE_EVENT_CLASS(xchk_sbtree_class,
 		__entry->bno = XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno);
 		__entry->level = level;
 		__entry->nlevels = cur->bc_nlevels;
-		__entry->ptr = cur->bc_levels[level].ptr;
+		__entry->ptr = xchk_btree_cur_ptr(cur, level);
 	),
 	TP_printk("dev %d:%d type %s %sbt agno 0x%x agbno 0x%x level %d nlevels %d ptr %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
diff --git a/fs/xfs/scrub/trace.c b/fs/xfs/scrub/trace.c
index e5efc680651fce..92a70e4b19d99a 100644
--- a/fs/xfs/scrub/trace.c
+++ b/fs/xfs/scrub/trace.c
@@ -42,6 +42,9 @@ xchk_btree_cur_fsbno(
 	struct xfs_btree_cur	*cur,
 	int			level)
 {
+	if (level < 0)
+		return NULLFSBLOCK;
+
 	if (level < cur->bc_nlevels && cur->bc_levels[level].bp)
 		return XFS_DADDR_TO_FSB(cur->bc_mp,
 				xfs_buf_daddr(cur->bc_levels[level].bp));
@@ -53,6 +56,16 @@ xchk_btree_cur_fsbno(
 	return NULLFSBLOCK;
 }
 
+static inline int
+xchk_btree_cur_ptr(
+	const struct xfs_btree_cur	*cur,
+	int				level)
+{
+	if (level >= 0 && level < cur->bc_nlevels)
+		return cur->bc_levels[level].ptr;
+	return -1;
+}
+
 /*
  * We include this last to have the helpers above available for the trace
  * event implementations.

