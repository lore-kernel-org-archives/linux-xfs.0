Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B02228504F
	for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2026 22:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782428117; cv=none; b=qcblDrD9nmfSVGfcT2jXlokGBspPsAYl6N0XUceuuBJYZ+XjZ06OLve8tMhX9WpX+7W2RZIv/0DnhYphImMR9TXOVDvUc9uxlkmmHLxgRHU7hDbTgI4lMipPrHoRRFzTsdENMGfEYTaUjFwZrtHmr6ReL+oPng8BIsWLkR9H6uQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782428117; c=relaxed/simple;
	bh=Uu18YYsE54GmZBstFFRGWXtIvj1vgQ/o/R8j5AvAqdo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gyJllD8b1RAPtltQmt493pCadPr0PwNvNApCXj5uLHScAowxpwL9Fb5h4HmsO5rjg5xSPBlQ3PkfREi4OwSlmKtr612sVfD13Bkb1g/fm2IpOapz1OV4TbPZK4nJUzdotquMCfyfW+KjpuW+LoX+BcNmR5tl0hVNpfJXjebCuzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VAbrr4r5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VAbrr4r5"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D5DD11F000E9;
	Thu, 25 Jun 2026 22:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782428115;
	bh=XlpqDcZcoQyNFsMee/+ndjO4rpsuspjbWS9GNz0aWWU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=VAbrr4r51uHmL42zoIK7KqFede6CjI1Q/Uk9E1oQ4gaBLWfaJHo0FAFrui5MoSc3r
	 vVyyv5I42sCIfd5oCLcveKddeL25d5/suDOW97O4YRv88S7zuxZ0lDzx2oNKUyKu8o
	 hLEnQGUZoM5FaLd8KkTNwzlUjaMOBMLP/rh3gRyhvDNkqIxG6yGHz5/XRQvGjxx+up
	 kYs4BOwDiJeEtG2MDNGSzvJa4Kt6lmQF4OFiwGOaTm99Vt4Lun0EDD03PG4pWNUE62
	 ucVZMkMF4MePZ6ejH4t/43cuMB3z7Yips9MpiC9pPhnGgcu6/eCbNpwwXufESd3Iyt
	 ewNta8X/R5Ylg==
Date: Thu, 25 Jun 2026 15:55:15 -0700
Subject: [PATCH 4/8] xfs_scrub: fix spacemap external log device scan dev key
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <178242801378.1981574.12871573702305819173.stgit@frogsfrogsfrogs>
In-Reply-To: <178242801268.1981574.8079691316092703702.stgit@frogsfrogsfrogs>
References: <178242801268.1981574.8079691316092703702.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Codex bizarrely complains about the rtstart>0 logic in scan_log_rmaps,
because it gets confused about the difference between internal logs
(which are scanned by scan_ag_rmaps) and external logs, which this
function handles.  I'm ignoring the report, but we shouldn't open-code
the synthetic device keys so let's fix that.

Cc: <linux-xfs@vger.kernel.org> # v6.15.0
Fixes: 37591ef3f4f14c ("xfs_scrub: support internal RT device")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/spacemap.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)


diff --git a/scrub/spacemap.c b/scrub/spacemap.c
index 8f595ad94c5991..5f6399821dc45a 100644
--- a/scrub/spacemap.c
+++ b/scrub/spacemap.c
@@ -213,7 +213,7 @@ scan_rt_rmaps(
 	scan_dev_rmaps(ctx, ctx->fsinfo.fs_rtdev, arg);
 }
 
-/* Iterate all the reverse mappings of the log device. */
+/* Iterate all the reverse mappings of the external log device. */
 static void
 scan_log_rmaps(
 	struct workqueue	*wq,
@@ -222,7 +222,12 @@ scan_log_rmaps(
 {
 	struct scrub_ctx	*ctx = (struct scrub_ctx *)wq->wq_ctx;
 
-	scan_dev_rmaps(ctx, ctx->mnt.fsgeom.rtstart ? 2 : ctx->fsinfo.fs_logdev,
+	/*
+	 * Internal rt sections (rtstart != 0) means we use synthetic device
+	 * keys for external devices.
+	 */
+	scan_dev_rmaps(ctx, ctx->mnt.fsgeom.rtstart ? XFS_DEV_LOG :
+						      ctx->fsinfo.fs_logdev,
 			arg);
 }
 

