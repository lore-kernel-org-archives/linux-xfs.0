Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 612F8BA2E
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TICCqyLl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3C8AC433C7;
	Sun, 31 Dec 2023 21:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704058714;
	bh=GdqA0Mu8ofmYcySdlvHf9Q9hGB++9U2cIUDkgRsOOgM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TICCqyLlfFJ3B61jrCvBoTVcYcvy2ownjgt46R/RWNbtpIKLBSJEWXznBvy2XhptJ
	 WA/CZLJNCm2KVLZlP8rXkRMMQi/1wglFsZH8Si6UAsSXNFAImhmNHssqUByHBG99iS
	 DYEmI+myrMRMBaL16ZEoBM9/VdKanC3GJqYu7KO3o71CFLq+E6it7zxhNjfrA5viVQ
	 TyG3XiaL0PCSSSt8FqoaCQk7sCqzs6gOILH/gvClk/CFGjYix5NwdU3c72au2hbk0L
	 50N2hzVjmDmMWyi1d9oooLhfZygUAZeE1npEQ1pDbFa83kMuzCwp0r7RUcl8EJdjSi
	 ul/C/bkkuxT+w==
Date: Sun, 31 Dec 2023 13:38:34 -0800
Subject: [PATCH 26/39] xfs: cross-reference realtime bitmap to realtime rmapbt
 scrubber
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404850320.1764998.10421725619605918249.stgit@frogsfrogsfrogs>
In-Reply-To: <170404849811.1764998.10873316890301599216.stgit@frogsfrogsfrogs>
References: <170404849811.1764998.10873316890301599216.stgit@frogsfrogsfrogs>
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

When we're checking the realtime rmap btree entries, cross-reference
those entries with the realtime bitmap too.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/rtrmap.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)


diff --git a/fs/xfs/scrub/rtrmap.c b/fs/xfs/scrub/rtrmap.c
index 7c7da0b232321..6009d458605e4 100644
--- a/fs/xfs/scrub/rtrmap.c
+++ b/fs/xfs/scrub/rtrmap.c
@@ -151,6 +151,23 @@ xchk_rtrmapbt_check_mergeable(
 	memcpy(&cr->prev_rec, irec, sizeof(struct xfs_rmap_irec));
 }
 
+/* Cross-reference with other metadata. */
+STATIC void
+xchk_rtrmapbt_xref(
+	struct xfs_scrub	*sc,
+	struct xfs_rmap_irec	*irec)
+{
+	xfs_rtblock_t		rtbno;
+
+	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		return;
+
+	rtbno = xfs_rgbno_to_rtb(sc->mp, sc->sr.rtg->rtg_rgno,
+			irec->rm_startblock);
+
+	xchk_xref_is_used_rt_space(sc, rtbno, irec->rm_blockcount);
+}
+
 /* Scrub a realtime rmapbt record. */
 STATIC int
 xchk_rtrmapbt_rec(
@@ -171,6 +188,7 @@ xchk_rtrmapbt_rec(
 
 	xchk_rtrmapbt_check_mergeable(bs, cr, &irec);
 	xchk_rtrmapbt_check_overlapping(bs, cr, &irec);
+	xchk_rtrmapbt_xref(bs->sc, &irec);
 	return 0;
 }
 

