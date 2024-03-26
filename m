Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22DD512838F
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711425507; cv=none; b=qXKDk9d3/YbggW+En5EAKB9OmnEsz0HSnIDC1r07roiTTjDoaCqrmQucfSk4mUmBp3zEJFCW4/m2Of4vUfryASRO6AAVM2fCGEbO+pZNOaO7Le2YVfq7Prha1b6G57gfVkqXtBuEP51ouOxDn4+fcE3KIiaMBa5ukRM6WDXo0tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711425507; c=relaxed/simple;
	bh=yPJCwn0zwUeAUpQGKD9dXegI5MvA70/YM/74n8fNMmQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mu+gJijUInCUnl+Ic2v4S8In5mU3tm38RTod2bDnYcDxrPhoLYZhE87RPNTvfGeOCP9WDPLrKvTwbkRiKnjSip9XtE6zoBlaO+OVvgEpCGpDR1Od8Rrf8xxwQfUiaQp+r1+KThK14uFxukvSkQ4ZCMZ3JNwjBeqihGSY8n2uzDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mt+8/+TJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mt+8/+TJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE0EEC433F1;
	Tue, 26 Mar 2024 03:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711425507;
	bh=yPJCwn0zwUeAUpQGKD9dXegI5MvA70/YM/74n8fNMmQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mt+8/+TJftVQyVxZpIVCIJNy7XRkV5cfcCicvc7MuV+cgfcynNIrWgTe16xTqrC2/
	 qGAYLc3+bNd+3lJQEAOMkxM8CpEOiWvQQl0RleccBNMSOoMy6lQV/O3RTRaiGrTw5T
	 m22p0SX0FnQhccScydVG4C4Oaw3rPgp2dWuejHZsGdZbMRz48a/rfBTxi07WxBaNvm
	 P3fkX8V4073Qr93YNGesMXlDdzSHPyUyETQvNwEv2Mbwa6nvPIQNvDwWOK7Cu6QDpt
	 A/bqS7soCwwADBNTdJi45kQt3mjf04kpDFhaKNuun6gQLF1gpdtEiWKUcH7pxeg1cZ
	 90B0MN6tmpy7Q==
Date: Mon, 25 Mar 2024 20:58:26 -0700
Subject: [PATCH 1/1] xfs: add a realtime flag to the bmap update log redo
 items
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <171142133677.2218014.4422121913066180413.stgit@frogsfrogsfrogs>
In-Reply-To: <171142133662.2218014.2765506825958026665.stgit@frogsfrogsfrogs>
References: <171142133662.2218014.2765506825958026665.stgit@frogsfrogsfrogs>
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

Extend the bmap update (BUI) log items with a new realtime flag that
indicates that the updates apply against a realtime file's data fork.
We'll wire up the actual code later.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/defer_item.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)


diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index fdb922f08c39..21dd1d0f416e 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -490,6 +490,9 @@ xfs_bmap_update_get_group(
 {
 	xfs_agnumber_t		agno;
 
+	if (xfs_ifork_is_realtime(bi->bi_owner, bi->bi_whichfork))
+		return;
+
 	agno = XFS_FSB_TO_AGNO(mp, bi->bi_bmap.br_startblock);
 
 	/*
@@ -519,10 +522,13 @@ static inline void
 xfs_bmap_update_put_group(
 	struct xfs_bmap_intent	*bi)
 {
+	if (xfs_ifork_is_realtime(bi->bi_owner, bi->bi_whichfork))
+		return;
+
 	xfs_perag_intent_put(bi->bi_pag);
 }
 
-/* Cancel a deferred rmap update. */
+/* Cancel a deferred bmap update. */
 STATIC void
 xfs_bmap_update_cancel_item(
 	struct list_head		*item)

