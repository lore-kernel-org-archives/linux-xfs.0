Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07F681386B9
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717442288; cv=none; b=OqsWGIivzsmWNCIfZ/ibjLOWH12YJxcwRcIHQ3yJzYZed56a3c2ha6Go+qAxPMyk90po9ebVuFtRBh2cPQQelgH1WtnN4Nbs+Uru6/tD/hBqeo3j9TcLZtfbrzXHAFsTFdbhLCLxEIiboOLSVuHPp0VXSlj4Q5u6Qkpu3UnPgq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717442288; c=relaxed/simple;
	bh=SjfQhq8S1UfRXbkfUJFBW6wE7L65XwHvafZqI7VdPLw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fjd8OqZekNhdBPF6qSajr/dj6LNjvjg+A+rMxczWiweLS88Ea0Yi6feSdCog6GU9zh0qQEdOdRPv+fFiJiKQfzo+I5WciKEqT3S7LCEUTvGLFkzgMDEMJdZ6cLC7xs6UklltU8AsLt6KIm6aT5E6hHt78zVs525+Du6I4NxGepI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U9F2OnXw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U9F2OnXw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF7CDC2BD10;
	Mon,  3 Jun 2024 19:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717442287;
	bh=SjfQhq8S1UfRXbkfUJFBW6wE7L65XwHvafZqI7VdPLw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=U9F2OnXwg/puseXM0ExiNpKWyK67/CdhAS8VmEy0Ap9Z83Pm1SKg9DV5PJt/hgnHf
	 QkwATMzBZPfhyEm3ScFxBzzLYhtx2yvYyaka/efa9I9W8b1rOire5oePEZ85t47pcD
	 7ZTZTaIBpIP0w7YM3sCMtRvlBkmGMUSEIvguqzJqRS5ozr/awCS9+UXFNYknH/jh7G
	 CheFs3Als5M8WnZhpQTQU4bWTUnD/SgzpIQ1CESHvYEP1Kb2ChrYNnzXiyfcDAH9d4
	 juKk2JTp5blnXMgdE7Fwiv6n1GRE/Iixh1Z0rju/2js9poTXB+HnRW4Rp1MBKsYtgk
	 E8iyx5ouyYH9g==
Date: Mon, 03 Jun 2024 12:18:07 -0700
Subject: [PATCH 100/111] xfs: clean up bmap log intent item tracepoint
 callsites
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cmaiolino@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171744040868.1443973.2162551662274447566.stgit@frogsfrogsfrogs>
In-Reply-To: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
References: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
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

Source kernel commit: 2a15e7686094d1362b5026533b96f57ec989a245

Pass the incore bmap structure to the tracepoints instead of open-coding
the argument passing.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 libxfs/xfs_bmap.c |   19 +++----------------
 libxfs/xfs_bmap.h |    4 ++++
 2 files changed, 7 insertions(+), 16 deletions(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index a82a41249..ae4f7e699 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -6185,15 +6185,6 @@ __xfs_bmap_add(
 {
 	struct xfs_bmap_intent		*bi;
 
-	trace_xfs_bmap_defer(tp->t_mountp,
-			XFS_FSB_TO_AGNO(tp->t_mountp, bmap->br_startblock),
-			type,
-			XFS_FSB_TO_AGBNO(tp->t_mountp, bmap->br_startblock),
-			ip->i_ino, whichfork,
-			bmap->br_startoff,
-			bmap->br_blockcount,
-			bmap->br_state);
-
 	bi = kmem_cache_alloc(xfs_bmap_intent_cache, GFP_KERNEL | __GFP_NOFAIL);
 	INIT_LIST_HEAD(&bi->bi_list);
 	bi->bi_type = type;
@@ -6201,6 +6192,8 @@ __xfs_bmap_add(
 	bi->bi_whichfork = whichfork;
 	bi->bi_bmap = *bmap;
 
+	trace_xfs_bmap_defer(bi);
+
 	xfs_bmap_update_get_group(tp->t_mountp, bi);
 	xfs_defer_add(tp, &bi->bi_list, &xfs_bmap_update_defer_type);
 	return 0;
@@ -6246,13 +6239,7 @@ xfs_bmap_finish_one(
 
 	ASSERT(tp->t_highest_agno == NULLAGNUMBER);
 
-	trace_xfs_bmap_deferred(tp->t_mountp,
-			XFS_FSB_TO_AGNO(tp->t_mountp, bmap->br_startblock),
-			bi->bi_type,
-			XFS_FSB_TO_AGBNO(tp->t_mountp, bmap->br_startblock),
-			bi->bi_owner->i_ino, bi->bi_whichfork,
-			bmap->br_startoff, bmap->br_blockcount,
-			bmap->br_state);
+	trace_xfs_bmap_deferred(bi);
 
 	if (WARN_ON_ONCE(bi->bi_whichfork != XFS_DATA_FORK)) {
 		xfs_bmap_mark_sick(bi->bi_owner, bi->bi_whichfork);
diff --git a/libxfs/xfs_bmap.h b/libxfs/xfs_bmap.h
index 10b858652..0a2fd9304 100644
--- a/libxfs/xfs_bmap.h
+++ b/libxfs/xfs_bmap.h
@@ -232,6 +232,10 @@ enum xfs_bmap_intent_type {
 	XFS_BMAP_UNMAP,
 };
 
+#define XFS_BMAP_INTENT_STRINGS \
+	{ XFS_BMAP_MAP,		"map" }, \
+	{ XFS_BMAP_UNMAP,	"unmap" }
+
 struct xfs_bmap_intent {
 	struct list_head			bi_list;
 	enum xfs_bmap_intent_type		bi_type;

