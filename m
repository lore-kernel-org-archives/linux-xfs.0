Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4958EB652
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 01:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710294721; cv=none; b=kJXYHiebL4n9sSWe4d5/POhkJ5YnCaL3WqZyQvnMKS8lONk6GZAFZzt6wB+lIRrc0iqrLbJl2u3WNZwNfMLxFgOYKZad+hj5tJopCjZjWTljmtqyAg10v23PXP0Uac00ge2ONXKk372UCI5k97mqtWZdsFRnPM32bv5izXDe6q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710294721; c=relaxed/simple;
	bh=kgcWgEY1kGdy/4RC3+Fx8MJ2OmIAPSkceooW/nX6YHw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZyXqnO5XxCpIdf12xWviumDvEFzlRB6kycFPvoHwI6HbHB9rXsr2lpBP/qin0PFUUS23vv0uPZwaiU43vUy5064WvRgt4dPqWYe8sy1/2Nk37/mmpSRMfccyByOlskSnzzfJ4OVuiDaHhfSv1LazicXl2PpvSPMTrTEbBrgc5+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CBeTbc0L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CBeTbc0L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D510AC433F1;
	Wed, 13 Mar 2024 01:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710294720;
	bh=kgcWgEY1kGdy/4RC3+Fx8MJ2OmIAPSkceooW/nX6YHw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CBeTbc0LExYsjw5Da4NBYSzo+4e6fqy63ROpOiZSM0fMK48tL2Ly4jbOlcUxrDJqF
	 B6/4gfAVaUSGeo07YbCXVMQtOVZ26Yxs7tUcdl+y/bsWaqm5zXOJoxM9geXQ3uDAio
	 yeTIY+nvZDObZbOpdYYxBP+Eems0IXCkekFrD6dDcruUlTIeHpBaJx36pOSgzb8zy9
	 spzbxHWvdTPhasw3wRUlswkJYsI2Jl24hdtZ5Z6rHSfrmdPpwZiRGsH8u/DZujuUcz
	 ezJIJPU3J9YppIjCfOH5h5jV2AYj2RTWTQRAIoEiuJgB5W2p+oBmMSBZu8w4o9Gp2q
	 freSzr+Q1S7xA==
Date: Tue, 12 Mar 2024 18:52:00 -0700
Subject: [PATCH 09/13] xfs_repair: convert helpers for rtbitmap
 block/wordcount computations
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <171029430686.2061422.7471647213070466430.stgit@frogsfrogsfrogs>
In-Reply-To: <171029430538.2061422.12034783293720244471.stgit@frogsfrogsfrogs>
References: <171029430538.2061422.12034783293720244471.stgit@frogsfrogsfrogs>
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

Port xfs_repair to use the new helper functions that compute the number
of blocks or words necessary to store the rt bitmap.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_api_defs.h |    2 ++
 repair/rt.c              |   10 +++++-----
 2 files changed, 7 insertions(+), 5 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index a16efa007572..5180da2fcea6 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -175,6 +175,8 @@
 #define xfs_rmap_lookup_le_range	libxfs_rmap_lookup_le_range
 #define xfs_rmap_query_range		libxfs_rmap_query_range
 
+#define xfs_rtbitmap_wordcount		libxfs_rtbitmap_wordcount
+
 #define xfs_rtfree_extent		libxfs_rtfree_extent
 #define xfs_rtfree_blocks		libxfs_rtfree_blocks
 #define xfs_sb_from_disk		libxfs_sb_from_disk
diff --git a/repair/rt.c b/repair/rt.c
index 8f3b9082a9b8..244b59f04ce5 100644
--- a/repair/rt.c
+++ b/repair/rt.c
@@ -19,6 +19,8 @@
 void
 rtinit(xfs_mount_t *mp)
 {
+	unsigned long long	wordcnt;
+
 	if (mp->m_sb.sb_rblocks == 0)
 		return;
 
@@ -26,11 +28,9 @@ rtinit(xfs_mount_t *mp)
 	 * realtime init -- blockmap initialization is
 	 * handled by incore_init()
 	 */
-	/*
-	sumfile = calloc(mp->m_rsumsize, 1);
-	*/
-	if ((btmcompute = calloc(mp->m_sb.sb_rbmblocks *
-			mp->m_sb.sb_blocksize, 1)) == NULL)
+	wordcnt = libxfs_rtbitmap_wordcount(mp, mp->m_sb.sb_rextents);
+	btmcompute = calloc(wordcnt, sizeof(xfs_rtword_t));
+	if (!btmcompute)
 		do_error(
 	_("couldn't allocate memory for incore realtime bitmap.\n"));
 

