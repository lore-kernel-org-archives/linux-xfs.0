Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68DF612839E
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711422107; cv=none; b=A6XrIXOUEQFUFMpGDwLr35foiegtIC929m4x/28fnie+NHjTQQxECVzXBqqIPAxErc9bsznGImVO+j+DkTh7fyrCLtZooI55/qQpEncT2roN5ciXszjqByTMVSxihfrIcxVzqWLbUD8DLtHwyp5H+TNMscDF3cB4cgzP1/dMjuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711422107; c=relaxed/simple;
	bh=nt5thrjbwtx1a/h/g2IQPN/ZCJtigiQVtO6qgequNoI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fPrIXcKTKasHI62pjngiIKIo9HpaJXL417JLR6ZvemVQZYl2qTb/m6tOwXKL5tjta3y4SpqLLtaw8qbsjCtxhr3xwYhm4AA7sZi8e2vHkILQ9hMUQbAUb9HGILzCCrXR9d7glEFXjngMQAXz8cYHnhQUjm7RDOwvo4uTIWGlL+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RbbJF0Z9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RbbJF0Z9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 430BEC43394;
	Tue, 26 Mar 2024 03:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711422107;
	bh=nt5thrjbwtx1a/h/g2IQPN/ZCJtigiQVtO6qgequNoI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=RbbJF0Z9zS5Pd8+zW1C5kCFtwSzAm5dfIUig0NWMDgONT8CSgy/uTo+oc+nrIX2LM
	 y9tkc4ja4pYHaysTtv+R8HJ+LkULloDCRXBU4uaeCjdjcIqVZ+tWKXAsRLN+jSwMH4
	 iNjAVOBfTQJLAHhvIobG8o3MFfC2EpbymZ09bDodt/L+kz3iptw29z+/nxf/B4JcsB
	 3+uC8FZP/n6wBNibTg7ABcIuuFC1H2cX9p8qeYzLTSyp2M3a/DsviLaSJVMNyA3kQ6
	 dQR5KFpKFzQDe/3nCg5jAExvFt3lVGkdSUN1lAJIfS7mxxaJgyGY5IIq8S7YLwCukT
	 oYn2ehmYTx4uA==
Date: Mon, 25 Mar 2024 20:01:46 -0700
Subject: [PATCH 09/13] xfs_repair: convert helpers for rtbitmap
 block/wordcount computations
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Bill O'Donnell <bodonnel@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171142126438.2211955.1751695329324386711.stgit@frogsfrogsfrogs>
In-Reply-To: <171142126291.2211955.14829143192552278353.stgit@frogsfrogsfrogs>
References: <171142126291.2211955.14829143192552278353.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
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
 

