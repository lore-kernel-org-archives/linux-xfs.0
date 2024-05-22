Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EABA64C62
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 03:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716347692; cv=none; b=Iad/rAoB9dh+fTM7Kl3gTSYn/ek1Z10fd5UHHSuEinIofhJPAj/F5f2NbjSLDQfEFVQhZc0QzwtwKxRxBb/F8jJlVh4juBIiuxdO80ch4CJbcNLXHgYW9H9fASAhFoqdWNKcpNptDzGMd3w+yZ7NeMA/5gF6FWS0iHgv/2QscFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716347692; c=relaxed/simple;
	bh=B8GHR0sKqAK9lDwjYLdNShw5lVKqEmj2q2H1P6i1f3M=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P4hicxvgseTKq4d6LM5630LnDUvHe8/w7i0d6TXwPVv/KReFCk3M6iXmDOPDqMV3Vvcom+1ukDjnRX5cLb0BkfUqEGU/kpIgOW6nrySgidt9tFb9YF7eLsoAlJvCR3uwfmfjCdRCWgwrDkOp/upQj0/odX9/iONmaZo0qsO3NaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=inK5MUDM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="inK5MUDM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B605EC2BD11;
	Wed, 22 May 2024 03:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716347691;
	bh=B8GHR0sKqAK9lDwjYLdNShw5lVKqEmj2q2H1P6i1f3M=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=inK5MUDMQKAIIz6PKZWj6sthUPbcS8mfRsE16FtX9+LGTmk4p9RlhzvalSNf7QjLr
	 GuE2Vf78wf6rAFMqV7lwrIeU5WoRXK71E7jPcMt78AEkOoT0oFnIBkyVi4eMRX7xsB
	 5pQRShqP8Vtjmp4Y8IQjnNJwilell9j8/mO4yriO0e69R/N5HVf5eCMMq+l9rGN/NK
	 iL7TD9D1v52AnYT0id96yeYUHRPBkPs3xqFZsOo/koeJV2CIk6BI5buAQv0NPpgIKc
	 MYBfixzhDn+zfM+eeE6PD5vhAN3DxGMfDFXqvsPEmOpgosGiSFOkRc7vhwhVfkoyU7
	 IcbIQBREFDasA==
Date: Tue, 21 May 2024 20:14:51 -0700
Subject: [PATCH 100/111] xfs: clean up bmap log intent item tracepoint
 callsites
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634533203.2478931.3593974094648975937.stgit@frogsfrogsfrogs>
In-Reply-To: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
References: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
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

