Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 553CE219C8A
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 18:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729191215; cv=none; b=OEU0pjJ2OdyP5N0JKCe6ju0Iy9vBseUM0uRrqtbSa1wux2shwmpZfMn7M1L9hQI65YcUw6yb1EOAnEGDsMdiJw7gYprX9yIrg6bDPU/AI+N8t3G/2YpWXCNyS2irC+uwQDwTLIouG+C3AuqN9DUamTH5zb1hCAWLDHcJzdnCwiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729191215; c=relaxed/simple;
	bh=PhQUS5YKmS5STARqXaJ/JnvOEY4zxV7LKRvO2HzOfcE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JWrIONfBbTjmdEMABO1PCahXd55CH12s5oAnySV1SaxzYWR6svT2O02cvVNAsprb2WOYyMHbF3xLNy7O+5svWH4JM56v4wvDMflSGhkfhHcO6nNfn7UjUaEtdEA89GTEtKl1kJxIfTk642YeY6s2zK/+oOiNO0xjiMyOVLQe86s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tLCOgbjf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tLCOgbjf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0D42C4CECD;
	Thu, 17 Oct 2024 18:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729191214;
	bh=PhQUS5YKmS5STARqXaJ/JnvOEY4zxV7LKRvO2HzOfcE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=tLCOgbjfJSXa0eLcgnd9QMjghlY0d4f70qe1nBrhR/1hu4uiwBWAwVxzk+LI4Lkm4
	 A3TVfcZ2t3TvmCd41AGFsBaW1vUsGOvuj8Sd6x7WMy3lQGFfIHuFGxGJs3JlGo3WqW
	 BbG7HIGgmgL/dP5FTvEftZVyFiSXuDaTtQjZpoIjL1ZlTvFCNmoJI4f0Vd+Ts/UxV7
	 bRoVCVQ9eKIhmrxuMMmNH1zTMkSccUbDDcBxBw4f3PxwWiTUPo8tUeAseKA4CzDlbV
	 IoGdlo1OyTy7BFwpVgu1GUT494BiOebBMkEDzi7xvasShurgi3uwvwQacRdD5iMZI8
	 jyk+8ex74YYgg==
Date: Thu, 17 Oct 2024 11:53:34 -0700
Subject: [PATCH 10/16] xfs: convert extent busy tracepoints to the generic
 group structure
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919068848.3450737.1766717923414504586.stgit@frogsfrogsfrogs>
In-Reply-To: <172919068618.3450737.15265130869882039127.stgit@frogsfrogsfrogs>
References: <172919068618.3450737.15265130869882039127.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Prepare for tracking busy RT extents by passing the generic group
structure to the xfs_extent_busy_class tracepoints.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_extent_busy.c |   12 +++++++-----
 fs/xfs/xfs_trace.h       |   34 +++++++++++++++++++++-------------
 2 files changed, 28 insertions(+), 18 deletions(-)


diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
index 2806fc6ab4800d..9c5c6279ae216e 100644
--- a/fs/xfs/xfs_extent_busy.c
+++ b/fs/xfs/xfs_extent_busy.c
@@ -41,7 +41,7 @@ xfs_extent_busy_insert_list(
 	new->flags = flags;
 
 	/* trace before insert to be able to see failed inserts */
-	trace_xfs_extent_busy(pag, bno, len);
+	trace_xfs_extent_busy(pag_group(pag), bno, len);
 
 	spin_lock(&pag->pagb_lock);
 	rbp = &pag->pagb_tree.rb_node;
@@ -278,13 +278,13 @@ xfs_extent_busy_update_extent(
 		ASSERT(0);
 	}
 
-	trace_xfs_extent_busy_reuse(pag, fbno, flen);
+	trace_xfs_extent_busy_reuse(pag_group(pag), fbno, flen);
 	return true;
 
 out_force_log:
 	spin_unlock(&pag->pagb_lock);
 	xfs_log_force(pag_mount(pag), XFS_LOG_SYNC);
-	trace_xfs_extent_busy_force(pag, fbno, flen);
+	trace_xfs_extent_busy_force(pag_group(pag), fbno, flen);
 	spin_lock(&pag->pagb_lock);
 	return false;
 }
@@ -496,7 +496,8 @@ xfs_extent_busy_trim(
 out:
 
 	if (fbno != *bno || flen != *len) {
-		trace_xfs_extent_busy_trim(args->pag, *bno, *len, fbno, flen);
+		trace_xfs_extent_busy_trim(pag_group(args->pag), *bno, *len,
+					   fbno, flen);
 		*bno = fbno;
 		*len = flen;
 		*busy_gen = args->pag->pagb_gen;
@@ -525,7 +526,8 @@ xfs_extent_busy_clear_one(
 			busyp->flags = XFS_EXTENT_BUSY_DISCARDED;
 			return false;
 		}
-		trace_xfs_extent_busy_clear(pag, busyp->bno, busyp->length);
+		trace_xfs_extent_busy_clear(pag_group(pag), busyp->bno,
+				busyp->length);
 		rb_erase(&busyp->rb_node, &pag->pagb_tree);
 	}
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index ed452bbfa4ffb3..96d94d9085c2d2 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1678,43 +1678,48 @@ TRACE_EVENT(xfs_bunmap,
 );
 
 DECLARE_EVENT_CLASS(xfs_extent_busy_class,
-	TP_PROTO(const struct xfs_perag *pag, xfs_agblock_t agbno,
+	TP_PROTO(const struct xfs_group *xg, xfs_agblock_t agbno,
 		 xfs_extlen_t len),
-	TP_ARGS(pag, agbno, len),
+	TP_ARGS(xg, agbno, len),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
+		__field(enum xfs_group_type, type)
 		__field(xfs_agnumber_t, agno)
 		__field(xfs_agblock_t, agbno)
 		__field(xfs_extlen_t, len)
 	),
 	TP_fast_assign(
-		__entry->dev = pag_mount(pag)->m_super->s_dev;
-		__entry->agno = pag_agno(pag);
+		__entry->dev = xg->xg_mount->m_super->s_dev;
+		__entry->type = xg->xg_type;
+		__entry->agno = xg->xg_gno;
 		__entry->agbno = agbno;
 		__entry->len = len;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno 0x%x fsbcount 0x%x",
+	TP_printk("dev %d:%d %sno 0x%x %sbno 0x%x fsbcount 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __print_symbolic(__entry->type, XG_TYPE_STRINGS),
 		  __entry->agno,
+		  __print_symbolic(__entry->type, XG_TYPE_STRINGS),
 		  __entry->agbno,
 		  __entry->len)
 );
 #define DEFINE_BUSY_EVENT(name) \
 DEFINE_EVENT(xfs_extent_busy_class, name, \
-	TP_PROTO(const struct xfs_perag *pag, xfs_agblock_t agbno, \
-			xfs_extlen_t len), \
-	TP_ARGS(pag, agbno, len))
+	TP_PROTO(const struct xfs_group *xg, xfs_agblock_t agbno, \
+		 xfs_extlen_t len), \
+	TP_ARGS(xg, agbno, len))
 DEFINE_BUSY_EVENT(xfs_extent_busy);
 DEFINE_BUSY_EVENT(xfs_extent_busy_force);
 DEFINE_BUSY_EVENT(xfs_extent_busy_reuse);
 DEFINE_BUSY_EVENT(xfs_extent_busy_clear);
 
 TRACE_EVENT(xfs_extent_busy_trim,
-	TP_PROTO(const struct xfs_perag *pag, xfs_agblock_t agbno,
+	TP_PROTO(const struct xfs_group *xg, xfs_agblock_t agbno,
 		 xfs_extlen_t len, xfs_agblock_t tbno, xfs_extlen_t tlen),
-	TP_ARGS(pag, agbno, len, tbno, tlen),
+	TP_ARGS(xg, agbno, len, tbno, tlen),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
+		__field(enum xfs_group_type, type)
 		__field(xfs_agnumber_t, agno)
 		__field(xfs_agblock_t, agbno)
 		__field(xfs_extlen_t, len)
@@ -1722,16 +1727,19 @@ TRACE_EVENT(xfs_extent_busy_trim,
 		__field(xfs_extlen_t, tlen)
 	),
 	TP_fast_assign(
-		__entry->dev = pag_mount(pag)->m_super->s_dev;
-		__entry->agno = pag_agno(pag);
+		__entry->dev = xg->xg_mount->m_super->s_dev;
+		__entry->type = xg->xg_type;
+		__entry->agno = xg->xg_gno;
 		__entry->agbno = agbno;
 		__entry->len = len;
 		__entry->tbno = tbno;
 		__entry->tlen = tlen;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno 0x%x fsbcount 0x%x found_agbno 0x%x found_fsbcount 0x%x",
+	TP_printk("dev %d:%d %sno 0x%x %sbno 0x%x fsbcount 0x%x found_agbno 0x%x found_fsbcount 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __print_symbolic(__entry->type, XG_TYPE_STRINGS),
 		  __entry->agno,
+		  __print_symbolic(__entry->type, XG_TYPE_STRINGS),
 		  __entry->agbno,
 		  __entry->len,
 		  __entry->tbno,

