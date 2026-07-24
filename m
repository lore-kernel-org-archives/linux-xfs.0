Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D63325487C;
	Fri, 24 Jul 2026 06:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784874109; cv=none; b=fdBs9egXdCIyTcbJh6mAon3PvAWzAv4WScGN4bRMlVsGajvDosYlo5nJmoAsQrZFqFTfLaRASnsOgivf4U0ITuBqiFKNVV1Gx+Km3y14Le+dI5bEKkYmpUOmdURya3mNwwxZruyTDeWqHDIn9jErRi7Hkri0cL4YuLppCPnLs7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784874109; c=relaxed/simple;
	bh=DObU18GHqDVNvbyOTrTZXZQE9Hgb2SqBsjZ3jIcnGoI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C6CIyx3m5LD+/BFPUanjUyE2ErJCu3F3RCLwehTBFILwfaOnfQ0YHjymwjuKNdDHPfnjPi1SC4d8x1Ox7+8cgxZgiM7CWNcW63MIcXM0Zr91JEmcXZFsGFoGDMV81jLHZ9O2JJGuW8zA0hn02dM7CMl/lS8ii+IWQKDWqhUOrUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LUbZ/c1p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LUbZ/c1p"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D382C1F000E9;
	Fri, 24 Jul 2026 06:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784874107;
	bh=z019ErpwWcOIaTT73HgJ4NzKsSsqBptdz1hZWeAhnkY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=LUbZ/c1p6I46ngFXs2oE5d0g4HzsCRabqQnPlMpusjUj9IempM/fVpbi13F6HRymt
	 Xuw9IaNhq09Afhuh5JB+6wzNIV+iPK/mGoR2sVfz47uDTD2CdC1BhQXX+3W+Mz/1wR
	 6XciZH57q/iLbxVkQmvDFFTq4W89p/K4m1xj3tctG8R6Qa3sSLw8W42PXlLWMlnmNb
	 NZrsUfzMU50gjODCbni5+vnghBBNa5S0IGfcY6TQvlvdrPAowas79twf+dcXsFRphv
	 HSImaHzwUw0PBFZpUNUfA6gHljpOWYnXw/X111SxOeNwAzgVw4Yx2Yau5ZHpgJnGbI
	 D66rsMGd7AncQ==
Date: Thu, 23 Jul 2026 23:21:47 -0700
Subject: [PATCH 3/6] xfs: don't return EFSCORRUPTED when scrubbing corrupt
 parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, hch@lst.de, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178487405441.3442778.15813909876284949564.stgit@frogsfrogsfrogs>
In-Reply-To: <178487405343.3442778.10258954219942220821.stgit@frogsfrogsfrogs>
References: <178487405343.3442778.10258954219942220821.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM noticed that scrub sets the CORRUPT flag when xfs_parent_from_attr
thinks it's been given a corrupt parent pointer.  This eliminates the
potential to repair the filesystem because that error code is bubbled up
the call stack.  Fix this by collapsing them all to ECANCELED in
xchk_parent_pptr, which doesn't have that trait.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: 0d29a20fbdba89 ("xfs: scrub parent pointers")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/parent.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
index a8c4807e1d9464..99b60773b7158d 100644
--- a/fs/xfs/scrub/parent.c
+++ b/fs/xfs/scrub/parent.c
@@ -485,7 +485,7 @@ xchk_parent_scan_attr(
 			valuelen, &parent_ino, NULL);
 	if (error) {
 		xchk_fblock_set_corrupt(sc, XFS_ATTR_FORK, 0);
-		return error;
+		return -ECANCELED;
 	}
 
 	/* No self-referential parent pointers. */

