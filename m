Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795628778;
	b=ipRGlgk0eue5jgkY3wRSW3KzY+xoq4YOWJIzM4UFoIFkCgAiDD/413nuWAQdTcGMma79
	 RXhWyMxfjbUr4S47S02mGbSA4yXAz9UR+eo27WFHaRxEYOQRjH7es6IMk8cbZceW/lf38
	 P/xbFN7eR7njm9bRnhj80DLTNwpNlwQFmcEMGricL9DvNwO+QX+3h8aF63G1fBTG9i/BP
	 c+fOeDZuPh9Natd+o4HIm6ULyy8eWx8QjvxFQ6ZG0LreSZxbveLAqJ4qbvmXz4G67kgFf
	 pRFhPPqXX12GxgUnyaZQDbVJmmi4g7PpKxlOLCZtxshg9D5EqY2+L3oAIyBqBecUfBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795628778;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=Uf7PXqQ03rxpxo0dPAYhWiamIlQoRupx5ctHffgIu7s=;
	b=U6FDq8ihkY00x/X4gR5U0rVVSR3xG5hm0fsR1hcZv7q61NMKfXB/fDToUSiCBzLy6AF6
	 EM6D8pNptmMG7xek02R+ZY5zE8+YzAz5MsLQP/U9A6X+cWZ6RuxENiUnwIyEU1hA4qbQc
	 Ks7dYnAHEwIgj513Qv1HKE0x8KPXY3lTNMjtVkelTaoDOgIY/KVgFKuPUQTM8ZGXW5Qgj
	 6NwlfFMjV6wELbT+RN9HTaE6mBKa4FI/pMO6Ki8Tl3pBBQBH56gPr+bslPVzbjgRBuWQl
	 xORZ79FCHJgCPP+LkOdE4HtOV7TQUzTkxdxiP4kkB62z5a8BtF4IfASg4ThRE87bk3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eUwZtK1F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D3AE606A321;
	Wed, 25 Nov 2026 17:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eUwZtK1F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CC081F000CA;
	Wed, 25 Nov 2026 17:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795628777;
	bh=Uf7PXqQ03rxpxo0dPAYhWiamIlQoRupx5ctHffgIu7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eUwZtK1F/lqENLvYTU3s8rt5D1cKh2Set7DyX7Ko6tMH4whmPBHvaIi8CanVxmKWq
	 C3NTtJcj/OaQm23A/zdNG68YnsvlRTaQb5DtJiyLqO0A3PJBxlvWJUuZMd8R9EsJVG
	 NQfLZxL+WzlrDu3hsBjShKlkqasHNXKb6oU83l5e3AuEsXm0Cxt3lRhbFIXuXt7hVO
	 dR4vXP9oRWEtsQMxU4OUlEUaE95Su+WX95EYPsuUz6Wu93EJAKljgqpXmhPMhlTeIl
	 QwmXExIJtQnxlch3hvgHzQHcRTCZWeMRBT7jusfGBjiOxH5lHjfRcuEOp/Okvx0E51
	 iglclG4H2fYQA==
From: cem@kernel.org
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org,
	hch@lst.de,
	sandeen@sandeen.net,
	dgc@kernel.org,
	aalbersh@kernel.org,
	bfoster@redhat.com,
	stable@vger.kernel.org
Subject: [PATCH v3 1/2] xfs: move _right_neighbor_result trace before erroring out
Date: Wed, 25 Nov 2026 18:45:59 +0100
Message-ID: <20261125174607.135959-2-cem@kernel.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125174607.135959-1-cem@kernel.org>
References: <20261125174607.135959-1-cem@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

The tracepoint doesn't help much if we find an invalid right record.
Move it before we check the record so it can still be printed even if we
end up jumping to the error label.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
V3: No changes

V2: Initialize rmap records during definition so we can safely use them
    in the tracepoints

Signed-off-by: Carlos Maiolino <cem@kernel.org>
 fs/xfs/libxfs/xfs_rmap.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 14aef87837a9..aad6e7c0e1c9 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -1024,8 +1024,8 @@ xfs_rmap_map(
 	const struct xfs_owner_info	*oinfo)
 {
 	struct xfs_mount		*mp = cur->bc_mp;
-	struct xfs_rmap_irec		ltrec;
-	struct xfs_rmap_irec		gtrec;
+	struct xfs_rmap_irec		ltrec = {0};
+	struct xfs_rmap_irec		gtrec = {0};
 	int				have_gt;
 	int				have_lt;
 	int				error = 0;
@@ -1082,6 +1082,12 @@ xfs_rmap_map(
 		error = xfs_rmap_get_rec(cur, &gtrec, &have_gt);
 		if (error)
 			goto out_error;
+
+		trace_xfs_rmap_find_right_neighbor_result(cur,
+				gtrec.rm_startblock, gtrec.rm_blockcount,
+				gtrec.rm_owner, gtrec.rm_offset,
+				gtrec.rm_flags);
+
 		if (XFS_IS_CORRUPT(mp, have_gt != 1)) {
 			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
@@ -1092,10 +1098,6 @@ xfs_rmap_map(
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
-		trace_xfs_rmap_find_right_neighbor_result(cur,
-				gtrec.rm_startblock, gtrec.rm_blockcount,
-				gtrec.rm_owner, gtrec.rm_offset,
-				gtrec.rm_flags);
 		if (!xfs_rmap_is_mergeable(&gtrec, owner, flags))
 			have_gt = 0;
 	}
-- 
2.56.1

