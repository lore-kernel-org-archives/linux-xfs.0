Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19174191F84
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 00:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772498359; cv=none; b=muQDLwhllBK0rJsloWywEd04zQK7OSC6FbnJOoEEawP9VzLlu1vuMtXzXJgayuvUF1K7e4A9YMG9rVTTgf53wxWZpr/+V3NXA4xplKJgKVl0opvIlc5OgHir40z5S1B662MbrqbO4PV/BUaav8d/7GnHB9WjX6TTxHoGVn63m2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772498359; c=relaxed/simple;
	bh=5+ZjbhAmIPbIvUttPWHGSVJzdYg2hO8cNFPoCuWIlBY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P9Nat6l5PporR6fTszG+IIw4DYUbpEnNbMdlfe622QbRC4BKQomSw536CsPRigu5sXcMqATgQWXjiYOd2AaQV4UXTHZVJb/pa1cEm8dwU6P2hbscNS2LA15G964C2/DdsV0jgNhsCdb1uBLE1nYEvHdviVEeXvJtDNbrY1YeEN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Eo2Dt1G1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Eo2Dt1G1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A550DC2BC86;
	Tue,  3 Mar 2026 00:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772498358;
	bh=5+ZjbhAmIPbIvUttPWHGSVJzdYg2hO8cNFPoCuWIlBY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Eo2Dt1G1KX9wlJrZDePtF7TsLkZGeXyklxRzstg+rotIgF/TYcB+7TyKSwymewMds
	 lKnQUKxpCDDZGestPxZ31jPY4Pv/qQJMNkwuQLit/xA9qvGI/h619Y6W9409mECU8k
	 00Kpg+uJiTlx/AL9PpKZHSrlADaUntK4PAg3Lzr1006sF5WF/NzobwRpkS7ooH3RFB
	 r0lhKbRy4sjfiALEkTx0iFTcaJvt6D2WD0Xlp4tpHrJWOIc/AmvZoCAigA2TlaTvCk
	 Nv8LINfs2uLShzcNtDe55+4ziH1gy98bCb+GLSlVla2dnZRB8cW6MgCn88AEiOkC+l
	 sKvqVEs4eEpSg==
Date: Mon, 02 Mar 2026 16:39:18 -0800
Subject: [PATCH 21/26] xfs_scrub: perform media scanning of the log region
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177249783674.482027.12478934497941662983.stgit@frogsfrogsfrogs>
In-Reply-To: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
References: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Scan the log area for media errors because a defect in a region could
prevent the user from being able to perform log recovery.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/phase6.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)


diff --git a/scrub/phase6.c b/scrub/phase6.c
index abf6f9713f1a4d..59e05e8aa2f54d 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -616,9 +616,14 @@ check_rmap(
 			map->fmr_flags);
 
 	/* "Unknown" extents should be verified; they could be data. */
-	if ((map->fmr_flags & FMR_OF_SPECIAL_OWNER) &&
-			map->fmr_owner == XFS_FMR_OWN_UNKNOWN)
-		map->fmr_flags &= ~FMR_OF_SPECIAL_OWNER;
+	if ((map->fmr_flags & FMR_OF_SPECIAL_OWNER)) {
+		switch (map->fmr_owner) {
+		case XFS_FMR_OWN_UNKNOWN:
+		case XFS_FMR_OWN_LOG:
+			map->fmr_flags &= ~FMR_OF_SPECIAL_OWNER;
+			break;
+		}
+	}
 
 	/*
 	 * We only care about read-verifying data extents that have been

