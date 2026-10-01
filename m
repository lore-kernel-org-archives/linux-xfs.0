Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1BA13B19AC
	for <linux-xfs@vger.kernel.org>; Thu,  1 Oct 2026 14:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790866250; cv=none; b=jJsb4yPXYlySSII1JNy4RWC+BpZZHrBHLduDW0sydGCwUJ/9k2Jy4a+cpeDwKq2+BathsQJDcZ1K/Qm6ZIonyzs0L55UANLTCZeZrZBmBfRziAtaU4pGUazprhSiT85yrA+kSITInk5etkpLfomdAQvfvCGcpQUtmYp6uW/zvvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790866250; c=relaxed/simple;
	bh=kDc+x+WxiDzPE4n0d3xACs2pezqqeQ65H3kMGSmU3Pc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=keujSJfQdAxH5EPXNZDBuLvXxTYbAVgRPNShRrRgvrpvrOIydTbfEmjDcSiOlrmFvwEPsUI7+sl10igIa+eErZBWGQGNBAHGqHZpudq9xhIRfpH/8AHw/5D0AETh0uMpvGPNXVWRfXhUDlbHNrmod0vqDgadcRcocgfac5IYy9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NKViKUsQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NKViKUsQ"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 549541F000FF;
	Thu,  1 Oct 2026 14:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790866248;
	bh=7VDrx45IrY9ZDR8ab9hNk5j3QX1OmH86UfiG7Ze52fU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=NKViKUsQwEXItqaZUm/gpJJjxm2OFnkParDm8Zjyl5hBqDd9PuypjZYcwkdwy/00s
	 kW/cfP66JUbjz32eXMVvi2kQkkoqYtB3vOTzuZGN64oy72CQbSK9NB4sWjSHODSzQh
	 QhId8M9KWMohPDkzvxpCXGzLzpeO3lXc+z0WMA6PZ+4I89+nVCRQUanNCxukOGp559
	 yBbJATBNtRkiLTXHHKwY51JIEIT9SG1hh/9qP8cLsL6XyXBnEgdA+Bz5JNRqaAE5VK
	 9JIyjtBaQaZik7mim8eIZcQR+dV1thcYMY73YC++YqKBL1zVRSwcQHT7tFgnnva9Lj
	 7bRfERVWTZkKg==
Date: Thu, 01 Oct 2026 07:50:47 -0700
Subject: [PATCH 1/2] xfs_healer: correct xfd_ API usage
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@infradead.org, linux-xfs@vger.kernel.org
Message-ID: <179086618131.2606256.16059054100746680560.stgit@frogsfrogsfrogs>
In-Reply-To: <179086618105.2606256.7314766956448729435.stgit@frogsfrogsfrogs>
References: <179086618105.2606256.7314766956448729435.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

This callsite is wrong -- the xfd_* functions return 0 on success or
negative errno on failure, so we should be using strerror on the value
provided, and not perror, which uses errno.  Fix this to be consistent
with the other xfsprogs utilities.

Cc: <linux-xfs@vger.kernel.org> # v7.0.0
Fixes: b9b03770197d19 ("xfs_healer: create daemon to listen for health events")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 healer/xfs_healer.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/healer/xfs_healer.c b/healer/xfs_healer.c
index ec402a78d5d2bf..8fa58b742aea49 100644
--- a/healer/xfs_healer.c
+++ b/healer/xfs_healer.c
@@ -315,9 +315,9 @@ setup_monitor(
 	int			mon_fd;
 	int			ret;
 
-	ret = xfd_open(&ctx->mnt, ctx->mntpoint, O_RDONLY);
+	ret = -xfd_open(&ctx->mnt, ctx->mntpoint, O_RDONLY);
 	if (ret) {
-		perror(ctx->mntpoint);
+		fprintf(stderr, "%s: %s\n", ctx->mntpoint, strerror(ret));
 		return outcome;
 	}
 

