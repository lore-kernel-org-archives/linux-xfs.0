Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 042774A06
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 00:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728607374; cv=none; b=scbpgqXvi8tk4AjM3wA216ST1CLteYh/8gBjsEF2ST4bZHtmZm5NubBvhkjfUSoZYTQ7h+JrmGIXLV7cHteY6naEC3TrxUFt6Vsstj/UyrAKPYPIcSnTRC531j9LOKD6EYIrAIFND/OnVlTxqff5w6UbdkECBFgljGox558om08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728607374; c=relaxed/simple;
	bh=4KiA5wQ0GpDMccpZCMTDosYKFE8sA+rkVlWAoVZySC0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WU6PK9qbPkxoL3bafI2Sq3Yuje/IBAU82CziW1jgsPQoVFIbA85ub0DpNPuQfQIHL8dIGI9dLBwAOtM/XnOnO5FY7TpCgcirfNxpkp80FQgBu8evSxKq7Wi5LFGV1Ogu1dqdAIcUvbv7hSup8JpEsNCrgCBA4r5QlTi8Dl6CC8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g64tsI21; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g64tsI21"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D68AAC4CEC5;
	Fri, 11 Oct 2024 00:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728607373;
	bh=4KiA5wQ0GpDMccpZCMTDosYKFE8sA+rkVlWAoVZySC0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=g64tsI21o9euxdRQYQ4CTR0D6j9BtCdyXdYAkw7jgh6L6QlHvwHup+xaaYocXE90H
	 Zmj3S7cS4E5Wy4nTwIHAiLVcw7y/gJNlZDj9lQ7V9Raz22KHAWAG5u/mjveRwLiIkd
	 6aOBzdfYkJPu/9KM1dC/9MQ6rzcZEyDAlIcW/6SWLndINIK+yzU+XN01lv2Jmyl8l6
	 MH6K1TfNyXdvRNbuxqiEkLA+l969luU8Z1C9awgUkUJgi3RanDZj5NwUxpB3rt9hx8
	 OFdyGrhrhM5wrVdnCeaxlBPKpW1dEqynXS35u66SI3cM05Q0gXGEueJmwqUz3JaRsO
	 /nhAdiywgCl6Q==
Date: Thu, 10 Oct 2024 17:42:53 -0700
Subject: [PATCH 20/25] xfs: pass objects to the xrep_ibt_walk_rmap tracepoint
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860640755.4175438.3902125554790817000.stgit@frogsfrogsfrogs>
In-Reply-To: <172860640343.4175438.4901957495273325461.stgit@frogsfrogsfrogs>
References: <172860640343.4175438.4901957495273325461.stgit@frogsfrogsfrogs>
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
index 98e0ee46375dab..c91eee019e37fe 100644
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

