Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7C2F376EA
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 05:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706591385; cv=none; b=D2zOFOKAbmVi2uYxZvtz8eTWPmReA6uNAPxKtqq96sG/XHOud9x2ejPspysVe4j5tVa6SaFLTQRY41UElBuCfZV7sNTkqNZxEPy3+zPfmRV6KSZ0noApxsrQ8FHPECVrYV9UUiWBLOw4vuHZxy8a0EzIyy8i3MYu/gpP309y4ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706591385; c=relaxed/simple;
	bh=Cb8iTmHD4QdN2MZctxkcfWe3WkBh/tgJIxM5/BZwg0M=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PKKgYwwwuQqlTCd1X6x/+0SkHeiGRwBC3ZoB4WDcszuYsIdebCwNvikuj/wkTge3M5dJTRABaX6rxF3JYWaf1WhzxrclUhA6IqGPbbXrJ/qrjorZfexb7h0hoUX2T2Fsx+5GAWpfPh3u/McXh/hArz7Chy3y9f49od33Lik0JXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q47LnFf0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q47LnFf0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D063C433C7;
	Tue, 30 Jan 2024 05:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706591385;
	bh=Cb8iTmHD4QdN2MZctxkcfWe3WkBh/tgJIxM5/BZwg0M=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Q47LnFf0efG4XHmG3GEbAa2rsw15RwitUYSpju69ooRdqVGJ7YFha31AA+BfJi+Z/
	 W57lhKsjSRAZ7GrBlALaCG5Ov4UbJl8AQHEfA0ZnLrhCczNDvurr3mprH4y5A1vsbB
	 LShWOh2e0L8HAhZaX2OKDMKvFtPLZQMYYt8mY0dL/5f+p1bSb0e2KfLqjRDMTb08q9
	 jZGZn4RmEu92PQTAly8yKywSG/YmPlBWkS+35qMMxRPkxJkMrFoBAUvayAtmRAqPGv
	 cxDGJD609gd4PmSpOMi/GXHk+roFOTbc57Nw3NuWM/1esIHPw4MAvJYc/IU/NYMeSg
	 6xi8ICWcCE+mA==
Date: Mon, 29 Jan 2024 21:09:45 -0800
Subject: [PATCH 02/11] xfs: report fs corruption errors to the health tracking
 system
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <170659063758.3353909.14059656562432690759.stgit@frogsfrogsfrogs>
In-Reply-To: <170659063695.3353909.12657412146136100266.stgit@frogsfrogsfrogs>
References: <170659063695.3353909.12657412146136100266.stgit@frogsfrogsfrogs>
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

Whenever we encounter corrupt fs metadata, we should report that to the
health monitoring system for later reporting.  A convenient program for
identifying places to insert xfs_*_mark_sick calls is as follows:

#!/bin/bash

# Detect missing calls to xfs_*_mark_sick

filter=cat
tty -s && filter=less

git grep -B3 EFSCORRUPTED fs/xfs/*.[ch] fs/xfs/libxfs/*.[ch] fs/xfs/scrub/*.[ch] | awk '
BEGIN {
	ignore = 0;
	lineno = 0;
	delete lines;
}
{
	if ($0 == "--") {
		if (!ignore) {
			for (i = 0; i < lineno; i++) {
				print(lines[i]);
			}
			printf("--\n");
		}
		delete lines;
		lineno = 0;
		ignore = 0;
	} else if ($0 ~ /mark_sick/) {
		ignore = 1;
	} else if ($0 ~ /if .fa/) {
		ignore = 1;
	} else if ($0 ~ /failaddr/) {
		ignore = 1;
	} else if ($0 ~ /_verifier_error/) {
		ignore = 1;
	} else if ($0 ~ /^ \* .*EFSCORRUPTED/) {
		ignore = 1;
	} else if ($0 ~ /== -EFSCORRUPTED/) {
		ignore = 1;
	} else if ($0 ~ /!= -EFSCORRUPTED/) {
		ignore = 1;
	} else {
		lines[lineno++] = $0;
	}
}
' | $filter

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_ag.c |    1 +
 1 file changed, 1 insertion(+)


diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 39d9525270b74..842e79f639475 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -217,6 +217,7 @@ xfs_initialize_perag_data(
 	 */
 	if (fdblocks > sbp->sb_dblocks || ifree > ialloc) {
 		xfs_alert(mp, "AGF corruption. Please run xfs_repair.");
+		xfs_fs_mark_sick(mp, XFS_SICK_FS_COUNTERS);
 		error = -EFSCORRUPTED;
 		goto out;
 	}

