Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB8F41F667B
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730844670; cv=none; b=sEE/lz7NbAoveya40CqpKfMO266pBPVL0OQqKdQTmQxrsrd9TDfuIlfqVAidzTASlb5/rW9+MVSeLEDH3lBj4dKhANM178YgZeA70WG9WZF1ndmnpTStjG4G2iugoOa8zxEkizw0f4QrnnCNKHppqAHRtckITBJfNDZCxeFNWqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730844670; c=relaxed/simple;
	bh=Y2hY0rpFV+AJCf8uudehelOhKnXgtYyafuEwbL4a97o=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YON/A2MJvdCHGHnQ6VOuDiTGf11Hql/LZHz+pmh+MlW2NRH4l+CuRnE8+kXPd8KWmIrvT96vcrLf7qrjBbbiA1wUJO5frkwnIkykoRSJ5Uma63haVBn0IgshI0uK1LyisyCx4XDE9rVavBNQu2b3EFjEtYVjqbSn5zwKGD7HDtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y8iJ+ISl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y8iJ+ISl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94FEFC4CED1;
	Tue,  5 Nov 2024 22:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730844670;
	bh=Y2hY0rpFV+AJCf8uudehelOhKnXgtYyafuEwbL4a97o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Y8iJ+ISlkMilhNP7/ohnzg3fGUV0RHhX+MOR6p1+Y/Kzv+mCEBQSOmvWv5lZyevfr
	 LzpNcZDq0AAct//nyQYloJfNJi6pmulhdHhWCdei61WQYIuhvzlIBUzpCUQwnv+rpT
	 aoDaCCWiQju0rBlryI9WHooNNpzQQq38ggSnZ880YTS6DmFfwD1HE4AT2hnleW1e4Z
	 /uSJvMGR6qIH9P6RxKOe1/tUW1pZnO40P43Uz6MKvW8BAYGffPnl7cTGpGLh3v6APM
	 PoBssD3eX2aaE8MJyTepgsZYPtgzzSmTF39kxrQwkJcCsYOi9FyDu8gJxdIYa2gLd+
	 /mQ94/WRGbyDA==
Date: Tue, 05 Nov 2024 14:11:10 -0800
Subject: [PATCH 18/23] xfs: pass objects to the xrep_ibt_walk_rmap tracepoint
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084394760.1868694.14829522146310026260.stgit@frogsfrogsfrogs>
In-Reply-To: <173084394391.1868694.10289808022146677978.stgit@frogsfrogsfrogs>
References: <173084394391.1868694.10289808022146677978.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Pass the perag structure and the irec so that the decoding is only done
when tracing is actually enabled and the call sites look a lot neater,
and remove the pointless class indirection.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/ialloc_repair.c |    4 +---
 fs/xfs/scrub/trace.h         |   29 ++++++++++-------------------
 2 files changed, 11 insertions(+), 22 deletions(-)


diff --git a/fs/xfs/scrub/ialloc_repair.c b/fs/xfs/scrub/ialloc_repair.c
index eac5c6f75a35ef..f1c24f2da497ed 100644
--- a/fs/xfs/scrub/ialloc_repair.c
+++ b/fs/xfs/scrub/ialloc_repair.c
@@ -421,9 +421,7 @@ xrep_ibt_record_inode_blocks(
 	if (error)
 		return error;
 
-	trace_xrep_ibt_walk_rmap(mp, ri->sc->sa.pag->pag_agno,
-			rec->rm_startblock, rec->rm_blockcount, rec->rm_owner,
-			rec->rm_offset, rec->rm_flags);
+	trace_xrep_ibt_walk_rmap(ri->sc->sa.pag, rec);
 
 	/*
 	 * Record the free/hole masks for each inode cluster that could be
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index ae8b850fdd85ae..992f87f52b7656 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -1984,11 +1984,9 @@ DEFINE_EVENT(xrep_reap_find_class, name, \
 DEFINE_REPAIR_REAP_FIND_EVENT(xreap_agextent_select);
 DEFINE_REPAIR_REAP_FIND_EVENT(xreap_bmapi_select);
 
-DECLARE_EVENT_CLASS(xrep_rmap_class,
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
-		 xfs_agblock_t agbno, xfs_extlen_t len,
-		 uint64_t owner, uint64_t offset, unsigned int flags),
-	TP_ARGS(mp, agno, agbno, len, owner, offset, flags),
+TRACE_EVENT(xrep_ibt_walk_rmap,
+	TP_PROTO(const struct xfs_perag *pag, const struct xfs_rmap_irec *rec),
+	TP_ARGS(pag, rec),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_agnumber_t, agno)
@@ -1999,13 +1997,13 @@ DECLARE_EVENT_CLASS(xrep_rmap_class,
 		__field(unsigned int, flags)
 	),
 	TP_fast_assign(
-		__entry->dev = mp->m_super->s_dev;
-		__entry->agno = agno;
-		__entry->agbno = agbno;
-		__entry->len = len;
-		__entry->owner = owner;
-		__entry->offset = offset;
-		__entry->flags = flags;
+		__entry->dev = pag->pag_mount->m_super->s_dev;
+		__entry->agno = pag->pag_agno;
+		__entry->agbno = rec->rm_startblock;
+		__entry->len = rec->rm_blockcount;
+		__entry->owner = rec->rm_owner;
+		__entry->offset = rec->rm_offset;
+		__entry->flags = rec->rm_flags;
 	),
 	TP_printk("dev %d:%d agno 0x%x agbno 0x%x fsbcount 0x%x owner 0x%llx fileoff 0x%llx flags 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
@@ -2016,13 +2014,6 @@ DECLARE_EVENT_CLASS(xrep_rmap_class,
 		  __entry->offset,
 		  __entry->flags)
 );
-#define DEFINE_REPAIR_RMAP_EVENT(name) \
-DEFINE_EVENT(xrep_rmap_class, name, \
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
-		 xfs_agblock_t agbno, xfs_extlen_t len, \
-		 uint64_t owner, uint64_t offset, unsigned int flags), \
-	TP_ARGS(mp, agno, agbno, len, owner, offset, flags))
-DEFINE_REPAIR_RMAP_EVENT(xrep_ibt_walk_rmap);
 
 TRACE_EVENT(xrep_abt_found,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,

