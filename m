Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 459CF212F88
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733528708; cv=none; b=nk4I7urh/UJ9jf33eoc7gvlIlhGgQCVYKbjo/qMTL1LL8auGWTnXSFL03g3dAIsIKj18dOBD3ynG22Masw4p3usdNl3W1VH9CSGyz3VsqPJHYuQBRLBk2JrvsJZ9A0NfgoDWaGpQvpDodC4SU4tzf24cs5yDHMM9JTglWrP5XIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733528708; c=relaxed/simple;
	bh=EmmV2JvkdwZS+En8V02iMSK3qIQ5mrPRcT7kC99aqIE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jnFKAtUI27UlEIiOmfEETgqdG49vP8X67jcvty7Otqc636rEYfhQP458BCmC9XOOOICb+8G89ij1E+ukLwZ16xaguGVxHl9GcdX6k6N2g/gcCTv2LZVjn4WkJshjlpGyEDxOQvPiCICttkRETfpyrPNXwWdshz8Vhwut1RvtMbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u6O3G1Qr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u6O3G1Qr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C13B6C4CED1;
	Fri,  6 Dec 2024 23:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733528707;
	bh=EmmV2JvkdwZS+En8V02iMSK3qIQ5mrPRcT7kC99aqIE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=u6O3G1QrWnwv9XMyr6p6P+QWtjWqSRJuAW/32FF6AARR1uncWkKe9C0QuqHWvHKhh
	 QQQ9YKylnrvM2PT5HWRFpyO60/zo0L7sKEwXKCi70ssJhu/iTK2ygNO9e+YIV1HhcW
	 YEwxYlXSQGY7xUIbGvz8zCmX6u76rGjpmMQed9GXHC/pebAND5x6EFLCSqu3wz/YVb
	 ztEANsf0NbddnkGVzqTKJ4gfvsnQMnslyXr1X2HDRntRIuUAksjYpq8g9Zw0rYBbHt
	 NuYmUqYDDCls1+epB/d9gYLpkciCmdVn9ID0uv/OqqZeg7jaj6HOuuAZo43ETWKcI6
	 2fts07ymH6vVw==
Date: Fri, 06 Dec 2024 15:45:07 -0800
Subject: [PATCH 21/41] xfs_repair: preserve the metadirino field when zeroing
 supers
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352748558.122992.7333141265239426688.stgit@frogsfrogsfrogs>
In-Reply-To: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
References: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

The metadata directory root inumber is now the last field in the
superblock, so extend the zeroing code to know about that.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 repair/agheader.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)


diff --git a/repair/agheader.c b/repair/agheader.c
index 3930a0ac0919b4..fe58d833b8bafa 100644
--- a/repair/agheader.c
+++ b/repair/agheader.c
@@ -319,6 +319,12 @@ check_v5_feature_mismatch(
 	return XR_AG_SB_SEC;
 }
 
+static inline bool xfs_sb_version_hasmetadir(const struct xfs_sb *sbp)
+{
+	return xfs_sb_is_v5(sbp) &&
+		(sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR);
+}
+
 /*
  * Possible fields that may have been set at mkfs time,
  * sb_inoalignmt, sb_unit, sb_width and sb_dirblklog.
@@ -357,7 +363,10 @@ secondary_sb_whack(
 	 *
 	 * size is the size of data which is valid for this sb.
 	 */
-	if (xfs_sb_version_hasmetauuid(sb))
+	if (xfs_sb_version_hasmetadir(sb))
+		size = offsetof(struct xfs_dsb, sb_metadirino)
+			+ sizeof(sb->sb_metadirino);
+	else if (xfs_sb_version_hasmetauuid(sb))
 		size = offsetof(struct xfs_dsb, sb_meta_uuid)
 			+ sizeof(sb->sb_meta_uuid);
 	else if (xfs_sb_version_hascrc(sb))

