Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D178012BF12
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 12:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707998966; cv=none; b=LVMz0Vj8dlJyWv6zGMkjwmIX/BiOD1ObFfWL0J6zQxGg+YHFfK+L4lKkDbT6hWgRtywqxTg+0M3BeaV7ozcz89NzTTYjWqp2iUJtm11WVCPocprnlSGmLfi1n0NN+E9K4a0chYcGORwat3FmF16qnA9H983hPD7Easl64fe1Ydw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707998966; c=relaxed/simple;
	bh=++EEa5bXqdIYjo7MtuUYygu+PMTyK4qiPTg/SvOtpcI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TC3okc+QS25vjsHVbzLw86d9GM2jJ9SY6I8RHQp4mAYAp6sJBFThUIP8KSPhAwyimUrNFP7iFFPI9dHaDcU96dE8kwqfFHgRaAkgNUyv6SlGaRunGo+zOEP3P7WXP0QKMqoTcu3bvqTo9I8wl6bW8Xi0+V3pJ+RkhN5d0RWJJ2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kTrqmI8B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kTrqmI8B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D400C433C7
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 12:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707998966;
	bh=++EEa5bXqdIYjo7MtuUYygu+PMTyK4qiPTg/SvOtpcI=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=kTrqmI8Bqvfs7EZLWlKs8pOg4EKi7SljqiA8D8OHhHYV1C0gxpMLiPITIV7h1TWW2
	 oehdyXEy8ulsmBnJZG4QZiPP/9PjJXXX7lwNlZXnVWjZZvsXHG5CqFpxBfV/NSIn3Z
	 4nNkqyjMKzEYh3+ST+ZU4r7JeZdFFLrgZ9etzw6rA2Ik14ve3rtB/sbTj1aqmlxRin
	 Kj3GXgbck9LxP+ENfvYQjcpZTlrP9IgO21w73LHU7Uu72BgUSkhvE4Yn/Ca/ZTILyU
	 aK6K09nPZXsU6waOP0adVY0tOIfhTsVxV5dAbGg+NEX+hh48Nnk+upOmKLn2dh6WD3
	 mue9/hixa8V9Q==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [PATCH 11/35] xfs: create a helper to compute leftovers of realtime extents
Date: Thu, 15 Feb 2024 13:08:23 +0100
Message-ID: <20240215120907.1542854-12-cem@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240215120907.1542854-1-cem@kernel.org>
References: <20240215120907.1542854-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

Source kernel commit: 68db60bf01c131c09bbe35adf43bd957a4c124bc

Create a helper to compute the misalignment between a file extent
(xfs_extlen_t) and a realtime extent.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_bmap.c     | 4 ++--
 libxfs/xfs_rtbitmap.h | 9 +++++++++
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 69549a94a..6e863c8a4 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -2983,7 +2983,7 @@ xfs_bmap_extsize_align(
 	 * If realtime, and the result isn't a multiple of the realtime
 	 * extent size we need to remove blocks until it is.
 	 */
-	if (rt && (temp = (align_alen % mp->m_sb.sb_rextsize))) {
+	if (rt && (temp = xfs_extlen_to_rtxmod(mp, align_alen))) {
 		/*
 		 * We're not covering the original request, or
 		 * we won't be able to once we fix the length.
@@ -3010,7 +3010,7 @@ xfs_bmap_extsize_align(
 		else {
 			align_alen -= orig_off - align_off;
 			align_off = orig_off;
-			align_alen -= align_alen % mp->m_sb.sb_rextsize;
+			align_alen -= xfs_extlen_to_rtxmod(mp, align_alen);
 		}
 		/*
 		 * Result doesn't cover the request, fail it.
diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
index 099ea8902..b6a4c46bd 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
@@ -22,6 +22,15 @@ xfs_rtxlen_to_extlen(
 	return rtxlen * mp->m_sb.sb_rextsize;
 }
 
+/* Compute the misalignment between an extent length and a realtime extent .*/
+static inline unsigned int
+xfs_extlen_to_rtxmod(
+	struct xfs_mount	*mp,
+	xfs_extlen_t		len)
+{
+	return len % mp->m_sb.sb_rextsize;
+}
+
 /*
  * Functions for walking free space rtextents in the realtime bitmap.
  */
-- 
2.43.0

