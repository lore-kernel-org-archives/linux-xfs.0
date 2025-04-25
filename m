Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4461D13633F
	for <linux-xfs@vger.kernel.org>; Fri, 25 Apr 2025 15:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745596102; cv=none; b=nnmkU4UMvfo6o+rmv+4cb5WtFRdMWOlLWYpQYfGOi8aN84SU1sIUnfhKvDaBuiCr1FGMn8wdAqmDrkjYC3Yb8HWgWZpnB3QF1cZ9iPk6ilUM+PghYKZwsgHeBJve7jYcHtLmKmij2sVSG+kbpHWNrNtXUi8DrwIzLplY4UQOTL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745596102; c=relaxed/simple;
	bh=WqEcs6SNEmuiOVs7JM0Czva+0T4jvOJ+1xnzfXe4NAk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k7DGxwnYgDHRJsRzxES3SuXXgBDgeg4NwuqEtYTaV6xIIJXKupBtDoSMNtb13NL3BsBX/WYU9H8Q8N7Trmfx8DHxlwiXhcXQz7V1YOxOjwoCHr7Bv8GSIcq5HS1O2i1SRdkAa6lZ9HqkG/fQxWtVU+BVT1pHNYWk81h8kaChHls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IvcAahTY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IvcAahTY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF861C4CEE4;
	Fri, 25 Apr 2025 15:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745596101;
	bh=WqEcs6SNEmuiOVs7JM0Czva+0T4jvOJ+1xnzfXe4NAk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IvcAahTYn3lheuDGRApJzx65u/TV2sW+/QPHFo3V/Xs9pZzneEHkiAvspcihytxTe
	 HGDnwocDyGobohtOv+dyWfYO7iBYUszWjEY01IDiAJ8zxUEjiMEMa8c22U09G+qGNs
	 dFRCkdc/A/SpQBse4oVkzKUREAgaii8sZHEYPqfpZUUp037Rt5nv6p9cyR6nnwSOqk
	 xNWSvvid+E1WsviEAJtHnlNxILsGpjy8+6Q353RgQF7u1MY+WJ3+dMoqaEoOZkv3fT
	 ix8Lwv6LzKnVxPaLKSt+6hqm+9rkpnIGcbSdAqCg/hC3shjs3ydgfl05k1B0CZJqen
	 9bYPpfqQX+LBw==
Date: Fri, 25 Apr 2025 08:48:18 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: [PATCH 44/43] xfs_repair: fix libxfs abstraction mess
Message-ID: <20250425154818.GP25675@frogsfrogsfrogs>
References: <20250414053629.360672-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250414053629.360672-1-hch@lst.de>

From: Darrick J. Wong <djwong@kernel.org>

Do some xfs -> libxfs callsite conversions to shut up xfs/437.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libxfs/libxfs_api_defs.h |    1 +
 repair/zoned.c           |    6 +++---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index dcb5dec0a7abd2..c5fcb5e3229ae4 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -407,6 +407,7 @@
 #define xfs_verify_rgbno		libxfs_verify_rgbno
 #define xfs_verify_rtbno		libxfs_verify_rtbno
 #define xfs_zero_extent			libxfs_zero_extent
+#define xfs_zone_validate		libxfs_zone_validate
 
 /* Please keep this list alphabetized. */
 
diff --git a/repair/zoned.c b/repair/zoned.c
index 456076b9817d76..206b0158f95f84 100644
--- a/repair/zoned.c
+++ b/repair/zoned.c
@@ -30,7 +30,7 @@ report_zones_cb(
 	}
 
 	rgno = xfs_rtb_to_rgno(mp, zsbno);
-	rtg = xfs_rtgroup_grab(mp, rgno);
+	rtg = libxfs_rtgroup_grab(mp, rgno);
 	if (!rtg) {
 		do_error(_("realtime group not found for zone %u."), rgno);
 		return;
@@ -39,8 +39,8 @@ report_zones_cb(
 	if (!rtg_rmap(rtg))
 		do_warn(_("no rmap inode for zone %u."), rgno);
 	else
-		xfs_zone_validate(zone, rtg, &write_pointer);
-	xfs_rtgroup_rele(rtg);
+		libxfs_zone_validate(zone, rtg, &write_pointer);
+	libxfs_rtgroup_rele(rtg);
 }
 
 void
