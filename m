Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B285245C0B
	for <linux-xfs@vger.kernel.org>; Wed, 24 Jul 2024 05:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721797916; cv=none; b=jJs4a4qvu1nPEkz/5ltasf+ItqYKLy0cTfEX65EeOjj66RFxbRWHa7aZxfwzLmBxoZMpe/HUmfdZIWMb+8GWRsUzo8R8B2+tJgo7Yx5+pJDVe1EMx3j0NgKp7xGs9Z80GyhV3w0NmwP5wVAbHUCVbTSv7VEpMHrK9SXRDPAwcGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721797916; c=relaxed/simple;
	bh=kus8k/lpdvqWquxHPdOC/MCEpjsLalOOWMFAOqtmuUw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=OE09A5y9xAoy5NtSfvS5ui/oYZmyNuI0lckn5MxJeDt+IDlhjXWhDrOSrEh/F1kyNSDhMuMkVTMav37vCtguIs5Uoo9cA3/7oZTy0ofYAZsbfTTnlmbPFaM7tzTcvKCgnCeYDcPLQj7/dYuFGjLhsg2Nn0dMb0AXF2MJoOgRfsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FJ9arMyC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FJ9arMyC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 214B2C4AF09;
	Wed, 24 Jul 2024 05:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721797916;
	bh=kus8k/lpdvqWquxHPdOC/MCEpjsLalOOWMFAOqtmuUw=;
	h=Date:From:To:Cc:Subject:From;
	b=FJ9arMyCVksu2O0KQfaLJIaJHKPITg/Uoz7vP9eXi4e7QTadkrfSc0O68Htk40kcC
	 5S+ysLX2LlZQBU3RwawHoWfG93+3FcEEVRV+KGc9MqEalsuS7S6LUy37Jm26kSC55Q
	 h0rbPBkRHgllmBJeaq1vgSZiXIoHe7eg3S59fvryUC23kE0r+jJhbdyi01HkmFg4RP
	 PRrza3jWf4BjW0/jQegvvDXl33EvugqWLELVYVibComyboEBmtjpIMcStOUEledcBw
	 qN0GxjVRpNRH/rhcCJ4a/HRXqMPR8lPl+8gexbHztR3gGpO6mtOPAmTJrXNnJEhY6o
	 FtSEl4QqNAQJQ==
Date: Tue, 23 Jul 2024 22:11:55 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: fix a memory leak
Message-ID: <20240724051155.GX612460@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

kmemleak reported that we don't free the parent pointer names here if we
found corruption.

Fixes: 0d29a20fbdba8 ("xfs: scrub parent pointers")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/parent.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
index 9de1483b04d6d..3b692c4acc1e6 100644
--- a/fs/xfs/scrub/parent.c
+++ b/fs/xfs/scrub/parent.c
@@ -821,7 +821,7 @@ xchk_parent_pptr(
 	}
 
 	if (pp->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
-		goto out_pp;
+		goto out_names;
 
 	/*
 	 * Complain if the number of parent pointers doesn't match the link
