Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78D924A06
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 00:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728607609; cv=none; b=Xco4tNaZo6ZNmbKxJb8af0WajQ7AGuwPkzlLCStohZnSxf0J9QApNcoDEKC/aKJt0z1hGpmyNf65fju5kosc057/775OIoGbEeT4xlK1Bx2LTy1hJKlJuBLapNhoCOzunUGA/PjxkJ0BF4jbUl9CHQNZo3hBlgUBAXow5r1a/9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728607609; c=relaxed/simple;
	bh=RfLhlXRHQREtTDijfDJAgAEQru3mO0J0zvdHKfwTvTo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O3L8my0mKzbxyPFb9oYl0BeFlYFKTsPBd3ZDU49l9TRVqmvrwuM54m78Q1w2PQqA9u96+DBPmixYFaxZI1uaN+4grpbYyUBr7X22+KkTlubg9ejQvj7gBat/dDWkTNDeIWiyjlkVFUUUt3YuJGmtAlUdUfW8ob7WPfUTF/j/NDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l07IjGFq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l07IjGFq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56A95C4CEC5;
	Fri, 11 Oct 2024 00:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728607609;
	bh=RfLhlXRHQREtTDijfDJAgAEQru3mO0J0zvdHKfwTvTo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=l07IjGFqWe+y69n3021fUqdrjKUl4sbeZaq02utgmONO6J+ljlFmA2b6rXGdig9xI
	 33wOifRz1xVvRrm3oFR5wokxDM78Rx/tH6SM4/khZpmqVxHJRWsZv3wmpWAYV78JRS
	 fOycqDE+VJdVEh+nOYRx7HSBnVJH+W/wfVN6BkXglnwp7qFIlk2PCmxSE2KmSVE9YM
	 PCkhA1f6C3O63gCL6ifo8u4MqbJ2ZksY2By6qBg3U33Ke+e8wOd/AGP++TQenI8ixx
	 a8Ta2WBQSSi1mLAq+LTlHgXVT1hkNrfSKirmejT6DRxLf+JSVk7NZTHi/g/q6f1tW5
	 8kriUD0YlYK3Q==
Date: Thu, 10 Oct 2024 17:46:48 -0700
Subject: [PATCH 10/16] xfs: convert extent busy tracking to the generic group
 structure
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860641435.4176300.8386911960329501440.stgit@frogsfrogsfrogs>
In-Reply-To: <172860641207.4176300.780787546464458623.stgit@frogsfrogsfrogs>
References: <172860641207.4176300.780787546464458623.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
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
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_extent_busy.c |   12 +++++++-----
 fs/xfs/xfs_trace.h       |   34 +++++++++++++++++++++-------------
 2 files changed, 28 insertions(+), 18 deletions(-)


diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
index 2806fc6ab4800d..ff10307702f011 100644
--- a/fs/xfs/xfs_extent_busy.c
+++ b/fs/xfs/xfs_extent_busy.c
@@ -41,7 +41,7 @@ xfs_extent_busy_insert_list(
 	new->flags = flags;
 
 	/* trace before insert to be able to see failed inserts */
-	trace_xfs_extent_busy(pag, bno, len);
+	trace_xfs_extent_busy(&pag->pag_group, bno, len);
 
 	spin_lock(&pag->pagb_lock);
 	rbp = &pag->pagb_tree.rb_node;
@@ -278,13 +278,13 @@ xfs_extent_busy_update_extent(
 		ASSERT(0);
 	}
 
-	trace_xfs_extent_busy_reuse(pag, fbno, flen);
+	trace_xfs_extent_busy_reuse(&pag->pag_group, fbno, flen);
 	return true;
 
 out_force_log:
 	spin_unlock(&pag->pagb_lock);
 	xfs_log_force(pag_mount(pag), XFS_LOG_SYNC);
-	trace_xfs_extent_busy_force(pag, fbno, flen);
+	trace_xfs_extent_busy_force(&pag->pag_group, fbno, flen);
 	spin_lock(&pag->pagb_lock);
 	return false;
 }
@@ -496,7 +496,8 @@ xfs_extent_busy_trim(
 out:
 
 	if (fbno != *bno || flen != *len) {
-		trace_xfs_extent_busy_trim(args->pag, *bno, *len, fbno, flen);
+		trace_xfs_extent_busy_trim(&args->pag->pag_group, *bno, *len,
+				fbno, flen);
 		*bno = fbno;
 		*len = flen;
 		*busy_gen = args->pag->pagb_gen;
@@ -525,7 +526,8 @@ xfs_extent_busy_clear_one(
 			busyp->flags = XFS_EXTENT_BUSY_DISCARDED;
 			return false;
 		}
-		trace_xfs_extent_busy_clear(pag, busyp->bno, busyp->length);
+		trace_xfs_extent_busy_clear(&pag->pag_group, busyp->bno,
+				busyp->length);
 		rb_erase(&busyp->rb_node, &pag->pagb_tree);
 	}
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 40f535538dc0ec..4674ef01e38d9c 100644
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
+		__entry->agno = xg->xg_index;
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
+		__entry->agno = xg->xg_index;
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

