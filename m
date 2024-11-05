Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 695C021219E
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730844577; cv=none; b=bd49+W8fK4FcTv7Af6wJKHnaFOu+y28D6aJCSLbUkhZhOTeMKRqy1jS05xmWsPiZT5ywbyhu04B7nepzfyFUXr7RwmDODyHS5b1INE2vsfmPJST79M/6kVacxxjMxRK3Tdap5wEbz7/1yn+LSd6VxK14dxC3jBu3B0/2U0e6GNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730844577; c=relaxed/simple;
	bh=A1yr2AA0YmsL1xnmGErgOCy2HX11K2oeKHKBCcnIWMk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sotHjCPDjYwWMFFroErOz+DxX7XGBC2DWctBXVF/cqTrhJSTOnyuvc/3Sr9wo/wPJarInZEOpqjOBYhArAwLVpl2XNJh5uUzFah0jcIcT4+iv/7SFIYzm53PDi1OKPR8pf4ELtPv6yiFqx/Ir9BDPYzg7iTr1AbOwO97vMTYghc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UxYYgbBu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UxYYgbBu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3755C4CECF;
	Tue,  5 Nov 2024 22:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730844577;
	bh=A1yr2AA0YmsL1xnmGErgOCy2HX11K2oeKHKBCcnIWMk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=UxYYgbBuxovmJv/BVYE2ljLXFr4/hYzTCIjGlpLrIqJJupox5lJawrKDlpcH2NsMU
	 zOUynmMDb5icMiki2c3rYSUV4T6QqqlZlS03zuDNVKvunLFeKnHrbybvxgDw+qy5qc
	 /ebui50ELgeNrCQF6I26YhHWAJT5r2HyRI9mA5oXW0esTs4fe8lO8PqZ62HX77Evg2
	 s8ENS14pNTdYRXQie+IYDJU4Lljj45AVVxSdasZu2N90aXpC11m9C1R7QQSmkJRruF
	 FrXwusf0t6pfIeakg2COlmzOmlGI93DaLlyF3XrRM8g2tnjpjUNw2joD2zqJ18XM0L
	 6nNe+DhqgFPww==
Date: Tue, 05 Nov 2024 14:09:36 -0800
Subject: [PATCH 12/23] xfs: remove the unused trace_xfs_iwalk_ag trace point
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084394657.1868694.14448352472864463318.stgit@frogsfrogsfrogs>
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

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_trace.h |   19 -------------------
 1 file changed, 19 deletions(-)


diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index b9baafba031b25..35b07af3b71d51 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -4237,25 +4237,6 @@ DEFINE_INODE_CORRUPT_EVENT(xfs_inode_mark_corrupt);
 DEFINE_INODE_CORRUPT_EVENT(xfs_inode_mark_healthy);
 DEFINE_INODE_CORRUPT_EVENT(xfs_inode_unfixed_corruption);
 
-TRACE_EVENT(xfs_iwalk_ag,
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
-		 xfs_agino_t startino),
-	TP_ARGS(mp, agno, startino),
-	TP_STRUCT__entry(
-		__field(dev_t, dev)
-		__field(xfs_agnumber_t, agno)
-		__field(xfs_agino_t, startino)
-	),
-	TP_fast_assign(
-		__entry->dev = mp->m_super->s_dev;
-		__entry->agno = agno;
-		__entry->startino = startino;
-	),
-	TP_printk("dev %d:%d agno 0x%x startino 0x%x",
-		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->agno,
-		  __entry->startino)
-)
-
 TRACE_EVENT(xfs_iwalk_ag_rec,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
 		 struct xfs_inobt_rec_incore *irec),

