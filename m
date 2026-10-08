Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 409A03B9930;
	Thu,  8 Oct 2026 05:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791439017; cv=none; b=D6ZBImsaoi216nywDF26zLQeasaotECT9oBkXCTzzkBgDsDXZ+SwTgiwW9f7HO716p0Vq9es1c8o+ioREnz50v8KpD5Lg/uVH6r6CTcTPXp1Md7elkeJnTfAfd66XpnMZePpV14Y8peqvY6icCGJ7DqIENB0Kga4SBcxesyYips=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791439017; c=relaxed/simple;
	bh=mCL6TxOpvbl7FEnUjqlniB3OM9HP+aOdbx7RslFELwY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=azdLiBbp95/gGftADObzHKEixTu66oN1N3akMr9oFjbbe5lCBkTJRionBnt8LSZ9T2fhTze3X1kE/MLOEO/OpKV9yxq8kRI4LuGvdZLcQX9yXEXHZPePL2YCaDgCX7pNtmuUq/4y8WDYqyISmRFySBmtKRHWV4HP1Y7ic7Cu2no=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iWEDL9mr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iWEDL9mr"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C13491F000FF;
	Thu,  8 Oct 2026 05:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791439015;
	bh=RfITWGDe2txKdya7mXf/+HOMYUXPffpGFkrNIKmtol8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=iWEDL9mrw/jxRsFRpC96l55q6hH3LRsuOEZoGxaMyUSyghorFbMlW18DHko+s1c6A
	 9/ACcrlo6xM5EJwGvjqe2PObjQ7242jlkHpRc5BXtAnUZka4YZIwUOrz+Kmf54H8qp
	 o50Us0uFFja5WgVcx0O6YfkntcdKfWaEua0FFeWB7aNLfLN8czeykwDX9mJhTo+vUx
	 NWtsus6OC2s3Qobx/E64orhR99x2mzvslQ7HbXYaoHVmFABTR2K46MpPbF1Vy2yaVl
	 3lwNa8NNp7t6L9VgSdUAe1VbiTft+2VtuadHPaIn1D2kKs9ePr26a8971kfhJI+NpQ
	 o0gznAtNd4fCw==
Date: Wed, 07 Oct 2026 22:56:55 -0700
Subject: [PATCH 08/12] xfs: range-check bc_levels array access in scrub
 tracepoints
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179141521429.2728617.9805637853982654466.stgit@frogsfrogsfrogs>
In-Reply-To: <179141521177.2728617.11116041790027402666.stgit@frogsfrogsfrogs>
References: <179141521177.2728617.11116041790027402666.stgit@frogsfrogsfrogs>
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
---
 fs/xfs/scrub/trace.h |   10 +++++-----
 fs/xfs/scrub/trace.c |   10 ++++++++++
 2 files changed, 15 insertions(+), 5 deletions(-)


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
index e5efc680651fce..29bcff41302394 100644
--- a/fs/xfs/scrub/trace.c
+++ b/fs/xfs/scrub/trace.c
@@ -53,6 +53,16 @@ xchk_btree_cur_fsbno(
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

