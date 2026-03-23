Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E82031F98B
	for <linux-xfs@vger.kernel.org>; Mon, 23 Mar 2026 18:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774291560; cv=none; b=Do6TN6JOtjKnuWXBgQTjFO/P2EMVgh113hvKcOfwihlpXT8F1425AMw3XCowI8phQdO6YU8mgrEiH594lv4J5PwYbXCNBh/ZG/FiWRPEmRSmAkNtsjRaHOZc9YtX/ZLBvmNpcomRlWjwAq3tVzkizxUa0ZKsH3PCX0l2klHa4cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774291560; c=relaxed/simple;
	bh=Y61BWESALPa/nC7w/5ZAuiSZHPS5VehBmOZe4VQ0yD4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sTpsBdjnT1iMCd8dv22y5aFnKW4yy3lFFhfenuluw/7B9kxgxazMQBUx48IU+iJ+8dIskTad/bfSYRjqQdu1mhPvhXJroC3e5QcSdi9hI971fwLIXMW9IcSVDc87yGutMC66ASXbgwHtAETbaAU1ZcEgv3dMAkda6VNuw+obbyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ePbafQri; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ePbafQri"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C5B1C4CEF7;
	Mon, 23 Mar 2026 18:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774291560;
	bh=Y61BWESALPa/nC7w/5ZAuiSZHPS5VehBmOZe4VQ0yD4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ePbafQrikkdv10v0q5fovbX66DXfDvA3LS8CPE9tEhOy1fYraunQ6FsPiOP+MuN+K
	 OqUF9BfW7wKdSp29l3f1Lpxf9i0797+6s9yrBqbTChD3xzkKUjgFTFCaMs9HAPaYGO
	 OM2W0QkGNqR3hVSuO5nzvz9HQY9kPm/gSD/Gbr3SNojtYv1ASPZoZhnziEJWKDV5Ck
	 3PIzLm7TZ0QhWO9DAbw1KyLLRKGsXl7C6QFC4EfZqTRbNi71UK+wMHzBDH+JnJXENI
	 NMvbnwMPgRl3XgST7ZNUbL880tVwroA7NOW1GfVI0CEg1zYVa2CUIRPTPjoRgvzmDw
	 Uih/RQZI8SfdA==
Date: Mon, 23 Mar 2026 11:45:59 -0700
Subject: [PATCH 18/40] xfs: add a xfs_rtgroup_raw_size helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: cem@kernel.org, cmaiolino@redhat.com, dlemoal@kernel.org, hch@lst.de,
 linux-xfs@vger.kernel.org
Message-ID: <177429121072.2266274.18185230737281132292.stgit@frogsfrogsfrogs>
In-Reply-To: <177429120538.2266274.13630957356122775655.stgit@frogsfrogsfrogs>
References: <177429120538.2266274.13630957356122775655.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: fc633b5c5b80c1d840b7a8bc2828be96582c6b55

Add a helper to figure the on-disk size of a group, accounting for the
XFS_SB_FEAT_INCOMPAT_ZONE_GAPS feature if needed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_rtgroup.h |   15 +++++++++++++++
 1 file changed, 15 insertions(+)


diff --git a/libxfs/xfs_rtgroup.h b/libxfs/xfs_rtgroup.h
index 73cace4d25c791..c0b9f9f2c4131b 100644
--- a/libxfs/xfs_rtgroup.h
+++ b/libxfs/xfs_rtgroup.h
@@ -371,4 +371,19 @@ xfs_rtgs_to_rfsbs(
 	return xfs_groups_to_rfsbs(mp, nr_groups, XG_TYPE_RTG);
 }
 
+/*
+ * Return the "raw" size of a group on the hardware device.  This includes the
+ * daddr gaps present for XFS_SB_FEAT_INCOMPAT_ZONE_GAPS file systems.
+ */
+static inline xfs_rgblock_t
+xfs_rtgroup_raw_size(
+	struct xfs_mount	*mp)
+{
+	struct xfs_groups	*g = &mp->m_groups[XG_TYPE_RTG];
+
+	if (g->has_daddr_gaps)
+		return 1U << g->blklog;
+	return g->blocks;
+}
+
 #endif /* __LIBXFS_RTGROUP_H */

