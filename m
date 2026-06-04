Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5997D3CF660
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jun 2026 06:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780553171; cv=none; b=MCPOr6H0JFJZYv1WuqL9LrxY+EOinFFZELK6AXKSkA1jrjtZgoN81Aj8oRvXMEGf6nRzGlpT1deQ6y16ph8H+HCsDsErwZR8Yt6e0yxklSlIsH6r95Grr117zYIf0Ts7fGZ/JEDiMrkTca1un5XKg8XeQdchni6nrvrNPhCtV+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780553171; c=relaxed/simple;
	bh=E8vRO3K6Nph4n3MtSbJHRQNKAQMc45ln3GbgEu9ZWqc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hj6TnRo3A0O1YMWhnH2yQ3ud61E4luHaUPYaRIYMRKCpHrGsB2qmAUnGuNd3zLzvYjbyYmyQjByRMvD6g40GDBHg63qo+Y04W8dcJSz0LmkndJ9fiiMrV+p6U5zEivRAYJj0AMKbPdQtX5JJ0vsITtdRwnnExdasx8dU3Dz40AE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eiCCB4Bc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eiCCB4Bc"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 2F8EF1F00893;
	Thu,  4 Jun 2026 06:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780553170;
	bh=9nKswZ39XrqkdZQEW8XjDvR/+/dPotiJk3TgGz7t0eQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=eiCCB4BcOdCQXe7zoj9VY9o8GXzXtA8HvvI6hwZVAM9LuS5E0zOSB1V9fqOgrl8bX
	 oUu+uNN+kSiwgV4flLyrl99L2oCaWm5bU4+3Iv5rNF/vC8cdV34e5i9BkKhavxtpd/
	 G8Vz7BwUNAJbuhbrHa25ef+dbHZxiCRbBweTS9FFBOjgy2ZiAsDjWYGpB+UIxtf9KB
	 K9E4uo/Qcj3TPA6jo2n9ttQmJEdMpXEBBY/avGth2lmB26yWwqdmVi1npfg3pHbyqK
	 AjUIKdT8akq55ssC9G1La8lVjrNaqMcQM7GFp8UAZV9RBFqBrTSKEpIzb59piWsJvA
	 0R4MMiMq36bIA==
Date: Wed, 03 Jun 2026 23:06:09 -0700
Subject: [PATCH 07/21] xfs_scrub: don't count internal log space in the data
 device used count
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <178055303238.2608728.8986838126430623871.stgit@frogsfrogsfrogs>
In-Reply-To: <178055303007.2608728.11678159907532979668.stgit@frogsfrogsfrogs>
References: <178055303007.2608728.11678159907532979668.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Internal logs are not considered free space, so for the data device
they've already been subtracted from xfs_fsop_counts::freedata by
XFS_IOC_FSCOUNTS.  This causes overcounting in the phase 7 reporting.

Cc: <linux-xfs@vger.kernel.org> # v7.0.0
Fixes: 95a92c5cecb2e1 ("xfs_scrub: perform media scanning of the log region")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/phase7.c |    4 ----
 1 file changed, 4 deletions(-)


diff --git a/scrub/phase7.c b/scrub/phase7.c
index d52c142cc36114..e16ca28aa28371 100644
--- a/scrub/phase7.c
+++ b/scrub/phase7.c
@@ -244,10 +244,6 @@ phase7_func(
 	stat_data = totalcount.dbytes;
 	stat_rt = totalcount.rbytes;
 
-	/* only count internal logs for data device summary */
-	if (!ctx->fsinfo.fs_log)
-		used_data += cvt_off_fsb_to_b(&ctx->mnt, l_blocks);
-
 	/*
 	 * Complain if the counts are off by more than 10% unless
 	 * the inaccuracy is less than 32MB worth of blocks or 100 inodes.

