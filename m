Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAB51242D65;
	Thu, 10 Sep 2026 06:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789020017; cv=none; b=dVyAJ3bJpPkCvNjJFPdW/71OZlvnlJHhxA9jjGeiDLpTMLtg9HJEi5jq29q+vmDJBVOQIPGhdb0dYfgHEY4rRAuMkrxsj+NftCj/bMnFuR93FB24rQtQd5q/fmDjIoW6Xgzz3EVlV1qNOwZYoecJLXfM3ImuTKEunTonebf1meY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789020017; c=relaxed/simple;
	bh=CX3WLflffXniiy16N50vMY0ZwW1LY3lajRI3jigFg6Y=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NmjOMN204F/VIjCT3beUaCA7jsKHuawoAWD4mIUhiFhtL+m9eigMqKzynX3kKrG617mY+UM+wIydKAzeMDrUjQv0qSBR08GGZcTWRW11ZQjm1yUSGc5oEk5xcFtc1hRrYaVxKU3JhKqZwHvFmc0sPnj1HiUi5Qmiqey8IrVFX6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iaCDeR+A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iaCDeR+A"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7FA171F000FF;
	Thu, 10 Sep 2026 06:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789020016;
	bh=BIHA5hOyF89+QV4B5PGIdZgguTEzNFEBV8qT28guHkY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=iaCDeR+Aw4ON34c+QLg0JGw/0kY5dsonju7sU0Q0Afnv4LdjD4OcHJfl4R77TwLH0
	 BErJPsNSIbT1jw6GxFqjkTmroZg94GMt2TIV3G6GMOmGGR8kdsbBJTgUFW2/GZYpdr
	 ghX1sLsJsoGn+odGxzlcFDotSN7X15WUedGk+RE/zQRxHq8add9w6zXA20vfp6OX8h
	 VSm1R5dnQYxhFtHfYYQD2q5O8vlikyhpB2JiVriIPcCFKjUJuuK8XhSJ6t4z0mshdY
	 DNWTlTlEtST2UEGaQg6qP3uXTSk9BCsaYBTCu5ln1mRPMbuTIYEbokkXQuom9DMk+Y
	 oif7c3HoQa6hg==
Date: Wed, 09 Sep 2026 23:00:16 -0700
Subject: [PATCH 2/6] xfs: don't assert when XFS_SCRUB_TYPE_HEALTHY scans
 return corruption
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org, hch@lst.de
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178901989870.361651.11385462411416248705.stgit@frogsfrogsfrogs>
In-Reply-To: <178901989791.361651.4660674894120948649.stgit@frogsfrogsfrogs>
References: <178901989791.361651.4660674894120948649.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

XFS_SCRUB_TYPE_HEALTHY is a synthentic scrub type so that xfs_scrub can
tell the kernel "Hey, I finished a scan and saw no problems" and have
the kernel forget that it saw indirect evidence of corruption.

Unfortunately, as LOLLM points out, it's possible for the health system
to record a new corruption just before xfs_scrub gets to
XFS_SCRUB_TYPE_HEALTHY.  In this case, the existing logic doesn't return
early and instead wanders into unknown regions of type_to_health_flag
and trips the assert because HEALTHY doesn't have a group assignment.

Fix the logic so that we always return early for a HEALTHY scrub type,
even if we decide not to call xchk_mark_all_healthy.

Cc: <stable@vger.kernel.org> # v6.9
Fixes: a1f3e0cca41036 ("xfs: update health status if we get a clean bill of health")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/health.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/scrub/health.c b/fs/xfs/scrub/health.c
index 2171bcf0f6c1f2..487ecc5f9f3c29 100644
--- a/fs/xfs/scrub/health.c
+++ b/fs/xfs/scrub/health.c
@@ -202,9 +202,9 @@ xchk_update_health(
 	 * there's no sick flag defined for it, so we branch here ahead of the
 	 * mask check.
 	 */
-	if (sc->sm->sm_type == XFS_SCRUB_TYPE_HEALTHY &&
-	    !(sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)) {
-		xchk_mark_all_healthy(sc->mp);
+	if (sc->sm->sm_type == XFS_SCRUB_TYPE_HEALTHY) {
+		if (!(sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
+			xchk_mark_all_healthy(sc->mp);
 		return;
 	}
 

