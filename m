Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14260C2C0
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CjXeAAvy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DBE1C433C7;
	Sun, 31 Dec 2023 23:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704066720;
	bh=JRtCfU6DDjNuO75Z5jDi8e6x8ymRT95d647uU/r4bkY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CjXeAAvyg9Y566eqzasFQi/2vpcs8N6S6JtWX4F7Ppc2Epf4+vbze0dGybJeXTQ/b
	 o8WEZ8xOoGfKG3IkkFzk7A5ZUaLcNZ8LZR0+xnIftvjfNTGrzlL1fJ4SO9MLrL9oc9
	 OqLSNPIIZ7gYVszqpBDgKmB5jrfYm2xHzxDnyR66WDUIp3oyMCuMO4dreO2olx06qF
	 BCfCop8PItApLkUyMuuRLNEY4OBRgLp7Zes1KqEGC6WQAGzM7+pJqRcxxgW/5U3xSn
	 yEVanu/rThsFdXndimz6e6pwhemRV/0hZXs4+ZnajPdKK5V9XzRV2wXhMDteT9/YSF
	 yuvs4dWKnkmrw==
Date: Sun, 31 Dec 2023 15:51:59 -0800
Subject: [PATCH 17/52] xfs: store rtgroup information with a bmap intent
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405012396.1811243.3971205341311733974.stgit@frogsfrogsfrogs>
In-Reply-To: <170405012128.1811243.5724050972228209086.stgit@frogsfrogsfrogs>
References: <170405012128.1811243.5724050972228209086.stgit@frogsfrogsfrogs>
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
 libxfs/defer_item.c |   17 +++++++++++++++--
 libxfs/xfs_bmap.h   |    5 ++++-
 2 files changed, 19 insertions(+), 3 deletions(-)


diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index 49e6cf02dc8..fbd035d9b94 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -492,8 +492,18 @@ xfs_bmap_update_get_group(
 {
 	xfs_agnumber_t		agno;
 
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
 
 	agno = XFS_FSB_TO_AGNO(mp, bi->bi_bmap.br_startblock);
 
@@ -524,8 +534,11 @@ static inline void
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
diff --git a/libxfs/xfs_bmap.h b/libxfs/xfs_bmap.h
index bd7f936262c..61c195198db 100644
--- a/libxfs/xfs_bmap.h
+++ b/libxfs/xfs_bmap.h
@@ -246,7 +246,10 @@ struct xfs_bmap_intent {
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
 

