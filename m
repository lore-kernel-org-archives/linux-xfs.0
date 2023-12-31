Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE8E4C8CB
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g91tbVwq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FBBBC433C8;
	Sun, 31 Dec 2023 21:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704059559;
	bh=MnzpG1AuU4zOHOFyjFX+FAxXdwC2ovwMXJj+3j65ezA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=g91tbVwqoIxICQL8lfcin4UW6h0C6WmRIYuxKG2vgF+9I03Qt/WsYGKWEZXZc00q8
	 RT8wtwZ1fPa7aGIyljImtT58tOUpM0VtO2qs+Tjhu6EPFNtoiTsBlMJslzO/Zup8bH
	 Wuk3boLQJqrpkcQ71Z5QAfIThFiEvj2XzvIWVLPe/1rVxdC0y08HNc9lx4EHPmA50e
	 E2Dv9io4VeJcGGp8M4OONwQ7KDHmlIMlGkBLI1fL8LjMgC86O4EEIdTeLIjxzArE7f
	 a1Njv7H/rOhF+JKM1WUPcKWmqoKwtnJAyUe2S0ZyXMlqLZ3dYxqyncFezjaHF9TR0R
	 N3rM+mR7iMemQ==
Date: Sun, 31 Dec 2023 13:52:39 -0800
Subject: [PATCH 31/44] xfs: allow overlapping rtrmapbt records for shared data
 extents
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404852081.1766284.6803325257041389359.stgit@frogsfrogsfrogs>
In-Reply-To: <170404851479.1766284.4860754291017677928.stgit@frogsfrogsfrogs>
References: <170404851479.1766284.4860754291017677928.stgit@frogsfrogsfrogs>
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

Allow overlapping realtime reverse mapping records if they both describe
shared data extents and the fs supports reflink on the realtime volume.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/rtrmap.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/rtrmap.c b/fs/xfs/scrub/rtrmap.c
index 60751c21fe52e..773be13c3be74 100644
--- a/fs/xfs/scrub/rtrmap.c
+++ b/fs/xfs/scrub/rtrmap.c
@@ -87,6 +87,18 @@ struct xchk_rtrmap {
 	struct xfs_rmap_irec	prev_rec;
 };
 
+static inline bool
+xchk_rtrmapbt_is_shareable(
+	struct xfs_scrub		*sc,
+	const struct xfs_rmap_irec	*irec)
+{
+	if (!xfs_has_rtreflink(sc->mp))
+		return false;
+	if (irec->rm_flags & XFS_RMAP_UNWRITTEN)
+		return false;
+	return true;
+}
+
 /* Flag failures for records that overlap but cannot. */
 STATIC void
 xchk_rtrmapbt_check_overlapping(
@@ -108,7 +120,10 @@ xchk_rtrmapbt_check_overlapping(
 	if (pnext <= irec->rm_startblock)
 		goto set_prev;
 
-	xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
+	/* Overlap is only allowed if both records are data fork mappings. */
+	if (!xchk_rtrmapbt_is_shareable(bs->sc, &cr->overlap_rec) ||
+	    !xchk_rtrmapbt_is_shareable(bs->sc, irec))
+		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 
 	/* Save whichever rmap record extends furthest. */
 	inext = irec->rm_startblock + irec->rm_blockcount;

