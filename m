Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D5F1493D5A;
	Mon, 12 Oct 2026 15:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791818547; cv=none; b=ZKMM3J6Q8IREs7079bQt4ooosq+b1MkhOKe4UZDWCUf/85gwhyftB6bdddCDLs5OqAf+k0nLDh/gh/Er5b4fmQfd7emVywFcDYxdaLxFUfT73YaP9xUnHDiSmoyJkzSlGjFjo//ofcIx45bu4TxknWNXc5W7ZFdmOWTMF7GYA04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791818547; c=relaxed/simple;
	bh=HT7IxYUi3zGTA8FOAaPbajatjzMw22Fbn5XRehifbL0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q4fvqmZi5RJibYnNElmJoQKazBGzf0YyMvKioVDJKsp+cd2Ga+MbOoPtz0Oab1+moNT5eeh487CBR3OvLlWSmL46QFxSiMxC7UJjx3v0kt9m05C1iilWYJBH//UkELEFPYBwPfh222X2Ujp5csIqkW49a35sNPMC0PPx3n4pOwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JcfCBsaU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JcfCBsaU"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id DB17D1F0089E;
	Mon, 12 Oct 2026 15:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791818545;
	bh=t73XSYnuU/zGE15MC1Gk/YkpGAWaCgHM6ACpaStLWSQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=JcfCBsaU1aI44tGgImkNCL3KOcB/eNjxhXLGtnX5vFb2AZBcpHiega/dit2Hr0qBz
	 /+uToUoZd6s4Mh6ck5FRrJ2zDgF8NBHRCResY04nns0aSIZ0BnBn7lFs9rHQUHGy9j
	 vxjunn0vGsw9xikXbmbWcYxbEYUtzfIWN+7Il6hMiYSex1FfFKZM0pbXeV5hHzPBGX
	 k2EXECjt6x7eSqzZoh9n4ZXWei7QjcQhBF8xdGWh7QeVT67PUAhMqbZAH4hu0CoV3N
	 lzFKco+lRuevieW0BzZLZpCLx0rnWrqSNRaQEoS+BHxAhH3bD5tPvvMMwOu7uZfYpK
	 t2EiTgERxOWLA==
Date: Mon, 12 Oct 2026 08:22:25 -0700
Subject: [PATCH 08/13] xfs: range-check bc_levels array access in scrub
 tracepoints
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179181839420.1417179.15421817368554524568.stgit@frogsfrogsfrogs>
In-Reply-To: <179181839163.1417179.9019753534701755931.stgit@frogsfrogsfrogs>
References: <179181839163.1417179.9019753534701755931.stgit@frogsfrogsfrogs>
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

