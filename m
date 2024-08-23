Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8274310953
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724372705; cv=none; b=tTm+UdlFsk1mdhV0gzwNu80mzv89UncXeMJ7I9qObep5pUexBetiRNZ6JoP9/O/J5ZGIcYxbLRZJc9Pv2qddXQJgw3m4N+tgQw6+ARr+shDiTPpSUckvSP32h4d92Tj4zwNl3aMFK+iEVtWNaaxgriwGCl4jwWSWIsSmi5hPtEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724372705; c=relaxed/simple;
	bh=V3uKaL//fBP0VYGoUwnehrtSQRaL0Am54ZMnCteBqNo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h9B2JxggZT46QJJjfPls5mpED9e71VLcA2VkuhpgQjghh3ua33bsYR+NELr7BDI3NRUr5UQlaFK7KLHS8kt8kqITrE4L8vHKnYRIP3ts0Z+5jzaTChjT7o6zvj5h4kHt5L+QxsWmw5qUykS+zAgaY1wx5QJqOIraVDPuVyuyPzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gslDYAxt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gslDYAxt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BC5DC32782;
	Fri, 23 Aug 2024 00:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724372705;
	bh=V3uKaL//fBP0VYGoUwnehrtSQRaL0Am54ZMnCteBqNo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=gslDYAxtKS1a8iciZfFFy/eIV/3h01Dp6Fg1ZGGSiB/TekZqs9cmbd7I5pGKSeclc
	 YW+JcLUN2NrURqT2fr5v25CMcELLMTMbA0duBUif6kzifCRbTz7QHfKgcilHVy+cLv
	 NBVczNEdJBWFvAqQ2gNwOpyeXB20eMInieRcOVrYmkSEIOUHHD4QP2S+065YZI2pIr
	 nK5Ndx/3Z5BBrKDE7w2DV3tPINtYSZgGiZcAMVk0n8BrutrLHAM6ORohiBaa6Mp+L0
	 GCEGnHGVQw7KUjj2mE+cQPqGII/eBdn2Yo09tXsmoQZ5FDiKbB2O20Q93TmrmkHBys
	 ZihOMeHzDrrZg==
Date: Thu, 22 Aug 2024 17:25:04 -0700
Subject: [PATCH 15/26] xfs: store rtgroup information with a bmap intent
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437088782.60592.3733953729473737601.stgit@frogsfrogsfrogs>
In-Reply-To: <172437088439.60592.14498225725916348568.stgit@frogsfrogsfrogs>
References: <172437088439.60592.14498225725916348568.stgit@frogsfrogsfrogs>
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

Make the bmap intent items take an active reference to the rtgroup
containing the space that is being mapped or unmapped.  We will need
this functionality once we start enabling rmap and reflink on the rt
volume.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.h |    5 ++++-
 fs/xfs/xfs_bmap_item.c   |   18 ++++++++++++++++--
 2 files changed, 20 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 7592d46e97c66..eb3670ecd1373 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -248,7 +248,10 @@ struct xfs_bmap_intent {
 	enum xfs_bmap_intent_type		bi_type;
 	int					bi_whichfork;
 	struct xfs_inode			*bi_owner;
-	struct xfs_perag			*bi_pag;
+	union {
+		struct xfs_perag		*bi_pag;
+		struct xfs_rtgroup		*bi_rtg;
+	};
 	struct xfs_bmbt_irec			bi_bmap;
 };
 
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index e224b49b7cff6..9a7e97a922b6d 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -26,6 +26,7 @@
 #include "xfs_log_recover.h"
 #include "xfs_ag.h"
 #include "xfs_trace.h"
+#include "xfs_rtgroup.h"
 
 struct kmem_cache	*xfs_bui_cache;
 struct kmem_cache	*xfs_bud_cache;
@@ -324,8 +325,18 @@ xfs_bmap_update_get_group(
 	struct xfs_mount	*mp,
 	struct xfs_bmap_intent	*bi)
 {
-	if (xfs_ifork_is_realtime(bi->bi_owner, bi->bi_whichfork))
+	if (xfs_ifork_is_realtime(bi->bi_owner, bi->bi_whichfork)) {
+		if (xfs_has_rtgroups(mp)) {
+			xfs_rgnumber_t	rgno;
+
+			rgno = xfs_rtb_to_rgno(mp, bi->bi_bmap.br_startblock);
+			bi->bi_rtg = xfs_rtgroup_get(mp, rgno);
+		} else {
+			bi->bi_rtg = NULL;
+		}
+
 		return;
+	}
 
 	/*
 	 * Bump the intent count on behalf of the deferred rmap and refcount
@@ -354,8 +365,11 @@ static inline void
 xfs_bmap_update_put_group(
 	struct xfs_bmap_intent	*bi)
 {
-	if (xfs_ifork_is_realtime(bi->bi_owner, bi->bi_whichfork))
+	if (xfs_ifork_is_realtime(bi->bi_owner, bi->bi_whichfork)) {
+		if (xfs_has_rtgroups(bi->bi_owner->i_mount))
+			xfs_rtgroup_put(bi->bi_rtg);
 		return;
+	}
 
 	xfs_perag_intent_put(bi->bi_pag);
 }

