Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24830378D9A;
	Tue, 15 Sep 2026 05:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789450643; cv=none; b=D6c7JKMNTRvJrdw/GuVmnHKFSTLFrEkg2oJz4lLBReDXaz/FozafECMkX5JqL936/li9UbL6QEFBVqFh10zprxYHEHZySuBJ7Nwz7ch9hZvdRLHu4MtDhxG3DQoAT2PbU2OKf+bO1k18oohUB3BkZ3jGFMvtjibN/iVMWiYvB58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789450643; c=relaxed/simple;
	bh=IT/VdVKByWcd15P4fCmM0pEOWFjjky4nMRg33+gMW0k=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GpdfhPQZAJ5m9+VTdJ9TqtqrrbW2ILLliIJ0oKmsW02cLuVnCjza4UUrcwdQUX7bWcTajMMfY6nOGc9004XK+66XquG9piJlF11uQYGwnzq0drIkjirXHJdonZXQW/LVffnDgA9aAj/EUSKYmwnPANFL5D9nmGkQAzXqNmEy6bE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DrjHaUkw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DrjHaUkw"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 4A9361F000FF;
	Tue, 15 Sep 2026 05:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789450641;
	bh=YPWXWYoLgtCDuqFIVMVtLQTf89Aq/fJ9CdOec2P2btA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=DrjHaUkwPQL9JyJylzoYuL2Ik89dWgLBg42wHmw3HKD4Kwx1q+fF9+YuBJ77UiQFY
	 YYJq/JyEJtrSOX7AxfuMv4+2ELO8mYgGL0tQA0sW0PY7JePQpE6qijd4Gh8zBoyCga
	 17amGrBYf24v6e6OUgbmIX4w04pPrO/JtI9zVSNTurivuG2n3SqSjxDcsV/USMY5tI
	 b7UkaizE0gdN07Yq0HWSicDJUOeIEcK4ZDtIxZlLxrSZ2Soi5LNOO8M4HuVd/yXjQY
	 B6J4k9qj8mW33bXgG/WLyRRTyWJTM45/czq/Hfecsftt+HrCiJFmpNRZw5lI/Tamhq
	 2k6NvoTLk7+sQ==
Date: Mon, 14 Sep 2026 22:37:20 -0700
Subject: [PATCH 03/11] xfs: fix rtgroup repair estimations
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178945048564.3061055.17283791204360805735.stgit@frogsfrogsfrogs>
In-Reply-To: <178945048435.3061055.16384804993810925544.stgit@frogsfrogsfrogs>
References: <178945048435.3061055.16384804993810925544.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

When I added online fsck for realtime reflink, I forgot to update
xrep_calc_rtgroup_resblks to factor in the size of the refcount btree
when it guesses how much space we need to start a repair.  This hasn't
been a huge problem in practice because there are few filesystems with
(a) realtime, (b) rtgroups, (c) reflink, and (d) no rmap.  But let's fix
this before someone stumbles upon it, especially since LOLLM flagged
this for me.

Cc: <stable@vger.kernel.org> # v6.14
Fixes: 83ccffc489975d ("xfs: online repair of the realtime refcount btree")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/trace.h  |   12 ++++++++----
 fs/xfs/scrub/repair.c |   19 +++++++++++++++++--
 2 files changed, 25 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 0f5adc293962fa..cb85f75ce10180 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -2376,25 +2376,29 @@ TRACE_EVENT(xrep_calc_ag_resblks_btsize,
 #ifdef CONFIG_XFS_RT
 TRACE_EVENT(xrep_calc_rtgroup_resblks_btsize,
 	TP_PROTO(struct xfs_mount *mp, xfs_rgnumber_t rgno,
-		 xfs_rgblock_t usedlen, xfs_rgblock_t rmapbt_sz),
-	TP_ARGS(mp, rgno, usedlen, rmapbt_sz),
+		 xfs_rgblock_t usedlen, xfs_rgblock_t rmapbt_sz,
+		 xfs_rgblock_t refcbt_sz),
+	TP_ARGS(mp, rgno, usedlen, rmapbt_sz, refcbt_sz),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_rgnumber_t, rgno)
 		__field(xfs_rgblock_t, usedlen)
 		__field(xfs_rgblock_t, rmapbt_sz)
+		__field(xfs_rgblock_t, refcbt_sz)
 	),
 	TP_fast_assign(
 		__entry->dev = mp->m_super->s_dev;
 		__entry->rgno = rgno;
 		__entry->usedlen = usedlen;
 		__entry->rmapbt_sz = rmapbt_sz;
+		__entry->refcbt_sz = refcbt_sz;
 	),
-	TP_printk("dev %d:%d rgno 0x%x usedlen %u rmapbt %u",
+	TP_printk("dev %d:%d rgno 0x%x usedlen %u rmapbt %u refcountbt %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->rgno,
 		  __entry->usedlen,
-		  __entry->rmapbt_sz)
+		  __entry->rmapbt_sz,
+		  __entry->refcbt_sz)
 );
 #endif /* CONFIG_XFS_RT */
 
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 11697a8b2a1d13..c2a437416227a8 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -399,6 +399,7 @@ xrep_calc_rtgroup_resblks(
 	struct xfs_mount		*mp = sc->mp;
 	struct xfs_scrub_metadata	*sm = sc->sm;
 	uint64_t			usedlen;
+	xfs_extlen_t			refcbt_sz = 0;
 	xfs_extlen_t			rmapbt_sz = 0;
 
 	if (!(sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR))
@@ -411,13 +412,27 @@ xrep_calc_rtgroup_resblks(
 	usedlen = xfs_rtbxlen_to_blen(mp, xfs_rtgroup_extents(mp, sm->sm_agno));
 	ASSERT(usedlen <= XFS_MAX_RGBLOCKS);
 
+	if (xfs_has_reflink(mp))
+		refcbt_sz = xfs_rtrefcountbt_calc_size(mp, usedlen);
+
 	if (xfs_has_rmapbt(mp))
 		rmapbt_sz = xfs_rtrmapbt_calc_size(mp, usedlen);
 
+	/*
+	 * Guess how many blocks we need to rebuild the rmapbt.  For
+	 * non-reflink filesystems we can't have more records than used blocks.
+	 * However, with reflink it's possible to have more than one rmap
+	 * record per rtgroup block.  We don't know how many rmaps there could
+	 * be in the rtgroup, so we start off with what we hope is an generous
+	 * over-estimation.
+	 */
+	if (refcbt_sz > 0 && rmapbt_sz > 0)
+		rmapbt_sz *= 2;
+
 	trace_xrep_calc_rtgroup_resblks_btsize(mp, sm->sm_agno, usedlen,
-			rmapbt_sz);
+			rmapbt_sz, refcbt_sz);
 
-	return rmapbt_sz;
+	return max(rmapbt_sz, refcbt_sz);
 }
 #endif /* CONFIG_XFS_RT */
 

