Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D2271CF5FF
	for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 23:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730416748; cv=none; b=PX1FydMsyiKCq1cDVoWN5r75/Usny6OUru0TtXMkDxem7xse0Hx0/2xNnpOWPb8MZImh4YEJEUcH2l7iud+9F4L6DD3RBMfzqFAyCOSkTkz8CtCJi0IojwaTdOenKmgZtR+9jwGS3uGO9SoMRbPbQEuGhp3fu/Wptgpd6d/9KUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730416748; c=relaxed/simple;
	bh=RvN95GapFt+G4kAiKYmFIesJJeLx4msFOEJ3+nGhBXs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IeOoJloOC//QtHIBl4EGZ8bBJuGQ++/NMpAuKiehZU8PDPd6ZQNhlQv+JHkwlIuh1QoEsqNAw0a6Tm3vEq4mxKUjv3g7ptURM11rDfLTelNXnVs5EOQ9BeqGQJ7AagsfgDHrL73XDG0D3F1VRNe10xF3EF+JKZBKQvNJsX1XIlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vRgG18r5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vRgG18r5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95485C4CEC3;
	Thu, 31 Oct 2024 23:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730416747;
	bh=RvN95GapFt+G4kAiKYmFIesJJeLx4msFOEJ3+nGhBXs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=vRgG18r5+qsrx54loJ/j1szOq+DvZ5Kbwiqp00CVKiWgrrc/6weFxk/Hz6UKWsvhL
	 gOAIPxpEQIyEHtK3GVbebfGNSjpSZmIhUoLbo4/EW4uhm2FksoEbguvhzDnuaPIvGr
	 59Hgw9QvwtYyFQ+lFpENmRWwuiUqOEDkzDOywZiz1OPytSlDbmPWuUZtpH2Z/vGALC
	 tsHyXnl95jjTCPjMjd3/NXOrB8wc2tf0bzHJxfzGQjpxTMT1U7xEyV/Bcpq7lXZ0XH
	 +zHU98M/hBqZYN7v5HMMk4uXfQ1z2TdNp+2kB529MC98t/dSL3EHaKkQMmQw4uRy3M
	 kGenqsFYLUMGQ==
Date: Thu, 31 Oct 2024 16:19:07 -0700
Subject: [PATCH 40/41] xfs: don't use __GFP_RETRY_MAYFAIL in
 xfs_initialize_perag
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173041566528.962545.12921537556581219315.stgit@frogsfrogsfrogs>
In-Reply-To: <173041565874.962545.15559186670255081566.stgit@frogsfrogsfrogs>
References: <173041565874.962545.15559186670255081566.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 069cf5e32b700f94c6ac60f6171662bdfb04f325

__GFP_RETRY_MAYFAIL increases the likelyhood of allocations to fail,
which isn't really helpful during log recovery.  Remove the flag and
stick to the default GFP_KERNEL policies.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_ag.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index a9993215bf9a30..a22c2be153a50c 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -284,7 +284,7 @@ xfs_initialize_perag(
 	int			error;
 
 	for (index = old_agcount; index < new_agcount; index++) {
-		pag = kzalloc(sizeof(*pag), GFP_KERNEL | __GFP_RETRY_MAYFAIL);
+		pag = kzalloc(sizeof(*pag), GFP_KERNEL);
 		if (!pag) {
 			error = -ENOMEM;
 			goto out_unwind_new_pags;

