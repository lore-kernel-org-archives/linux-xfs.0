Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F1D6357D11;
	Tue, 21 Jul 2026 03:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784604337; cv=none; b=XYzCNtF8XYXH2OvkJL8j9ic/FxFeZM0+4uWks3J+7QX6UCJz3yGNn4rGVCGKCdsk6sjlZt9fNz3fxaJb6hfUMqHfM0yNmMZlCS83qo6eDxw31aSc0sm1mDCNOGr7COd9On8VCqpaEbEgu+IkYWV6RZJlbMPtvnmwkGn0IBU1uNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784604337; c=relaxed/simple;
	bh=4flDY5XaAXuWbMW8pxoXGByZ+8tJKJ71Meo7KWSvcXY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FiLTMtD7ZHDtpBQ+qoNASEsALKTdK8E2J5rqtOTV4Ri9LXu7ixtYADy9BAAIwjbRLtFzAdOkWy0UPnQTflH0RWn0qauiwuOG7B3+O09hQr6nEO1tCR7ltUvIQheM2JTRPVLyPF92tUdO01TcdPqaxSVtp6VKICgu9WJ86rNu5ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cDx6l8Ey; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cDx6l8Ey"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E57401F000E9;
	Tue, 21 Jul 2026 03:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784604336;
	bh=yQs9giOEvwuwR01/kOWV8Ew24evuynjgsPiEeSqygDY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=cDx6l8EyLWcX8ZEhpudhXqaP9Merlq/4eAbfiTgGY8ktMyAw7gLmsgC1R9mI0hUXJ
	 aRr1Y+u44no3c1bEJa5oUApXUp+scSCO+ybOSjobgV/EdEYSrpEdljvpsBrK+mpsk6
	 /LS+52IFRYBh/PmYVBDzdQaXGyFh4UglSP5Yb3eJPcFTw8tBveOypcEB2H6ZlPsybE
	 t3fYzFIejcVAtSrBlAnapLju3p5iGiGFWbccV9OfCfZxTkTJ0Uxtzuc5CUr943P6ll
	 nEbWufS1XRyCYISQQJyikmV/iPcwIbhuh7LT/is9eykFP4uyN7A+RqSpMrxKolm3A2
	 oanX0YtcCTeKg==
Date: Mon, 20 Jul 2026 20:25:35 -0700
Subject: [PATCH 3/9] xfs: don't walk off the end of a null sc->sa.agi_bp in
 AGI repair
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, hch@lst.de, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178460419553.830862.9786705599369420927.stgit@frogsfrogsfrogs>
In-Reply-To: <178460419438.830862.6755198157088208229.stgit@frogsfrogsfrogs>
References: <178460419438.830862.6755198157088208229.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM noticed a longstanding bug where xrep_iunlink_walk_ondisk_bucket
tries to walk ragi->sc->sa.agi_bp to rebuild the unlinked inode lists.
Unfortunately, it's possible for agi_bp to be null if the buffer
verifier fails, so we have to use ragi->agi_bp (which skips verifier
checks) instead.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: ab97f4b1c03075 ("xfs: repair AGI unlinked inode bucket lists")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/agheader_repair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index 13074d5e319cc0..39468b8fa9863d 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -1082,7 +1082,7 @@ xrep_iunlink_walk_ondisk_bucket(
 {
 	struct xagino_bitmap	seen;
 	struct xfs_scrub	*sc = ragi->sc;
-	struct xfs_agi		*agi = sc->sa.agi_bp->b_addr;
+	struct xfs_agi		*agi = ragi->agi_bp->b_addr;
 	xfs_agino_t		prev_agino = NULLAGINO;
 	xfs_agino_t		next_agino;
 	int			error = 0;

