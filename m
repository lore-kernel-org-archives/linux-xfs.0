Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D471547C0
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 03:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773114515; cv=none; b=qQGBBPDRG77pIpTtS/+w294swoY1GsqHZL/wkgJp8s9fkNdt01h6EsLFhMY5X85eKk/Xxo/eBQpJ0Ie7IZBcCRL2g9vXS/4YTIfJSH22Nqgo/cZY+FNT7PwJx4HMJ17LubFTDNQ6idsLSop9Hs9Y/sgDaVOZXAHWIHAmD7VVMgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773114515; c=relaxed/simple;
	bh=d3Stuw2ztCVwp/8yKafpEalsnp2cJiAnECam3p2L5ew=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=npWvTHcV+wLcBQMViePeWshFmd7nGdCxlhHByX4G9psOFiRlBtgaqiL569Thm88LXWpkhCN4byzrTV0/TIMssm56eh6TX5IsnNmEbPA/hMFH1zUkoxfqDc7QZgACK9yLlZ1iuE2vcoSkuPQANf+imggP4KqzsnJCEEjDXKdi/7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=twDGBpkB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="twDGBpkB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDDBAC19423;
	Tue, 10 Mar 2026 03:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773114514;
	bh=d3Stuw2ztCVwp/8yKafpEalsnp2cJiAnECam3p2L5ew=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=twDGBpkBW8Q+aE4SQEvQAw3/a44KCSqV+K6bSNlHYnMObPePlMq8kFjU/wW8yW6Ne
	 bVenTTSYgup90jYGJ/HScICWnPfO6HjWpj8ojlZMdXZg9VxMKieyavFUZVEVuP4Uaj
	 MaKF7hhYazYmaT2NaguyLH655jX89xJTV+idnqZev4filMV0hf2AE6eViG8SeY/Ihy
	 bQAedm/Vdy/sWA0mjKq7/r1TYS7jWy5kwnCvbLkya4oezyL2QQkVuxfrXvI1BxZytd
	 zSu7y2LgcQTW0DpbHmKpLLNjP8JSxd/qNZZcVb4FecfbllZuBTs8he14CBt5YE9mG5
	 xtiMSADhgvc6A==
Date: Mon, 09 Mar 2026 20:48:34 -0700
Subject: [PATCH 23/28] xfs_scrub: perform media scanning of the log region
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177311401877.1183235.10946702921661932045.stgit@frogsfrogsfrogs>
In-Reply-To: <177311401331.1183235.13382695982141268952.stgit@frogsfrogsfrogs>
References: <177311401331.1183235.13382695982141268952.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

