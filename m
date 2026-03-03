Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 614C61B4224
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 00:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772496980; cv=none; b=RxlZRjKritc0Ap0FFroXb2q63aLzb9341wGDu72hi6EPXtqDAfuVq9vvePX+OK4dzL5padZgMUn4VIiUrtg9rurGwdxODdl2c1qQHmE6sY9gaH3uNvvYLWL+WsVQ9XEqBD22W0Lmyham9Lon3och27czG3Z5kVViURL2YoS8E28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772496980; c=relaxed/simple;
	bh=Y61BWESALPa/nC7w/5ZAuiSZHPS5VehBmOZe4VQ0yD4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jYAggzveqHilKfzxwgm+2v3bBXSh+x3y9vwjGYlJ2LwsY2U5GYYQWi+XJxNYyXRBeetuPihxuJQ7tB7YORnO6jZ20TWor5hsjZKq1gwTkM4tJqkzrWt0sn7FClRvdRtOvcLPkYVoZHEe0DlhUJjIlxsjMU/K/rLfPingmmXw4LA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tx0gML9P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tx0gML9P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06ECEC19423;
	Tue,  3 Mar 2026 00:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772496980;
	bh=Y61BWESALPa/nC7w/5ZAuiSZHPS5VehBmOZe4VQ0yD4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=tx0gML9P166YDo+81N2Ymp+hKlrcHFUmPj3kxSFzJzPtrTvukAMkaxJWHovSe+FaN
	 6Cp33GUNIPOHQul7OiwjSSCwei1Ah+stVzd5Fb3R0bym+3UCy8vC9oXjl3YbvhCulL
	 dpdhIkyCD2y2xtwacfH6waXu0T//K2HOAf/EhDICuVSMQLQ2Dehp+mPrO63mTpxIjn
	 Gh4NBLmcrdKqPtaOpzNDcRvHIqSkRw3XPw+GjnreviYjGBWIaBlzbV9ywdR9FtMPpT
	 9bry/1S2ZiibUgqEau2J8f5h3paJIBg8rddusrzitTi4TE1wD0AYvNA+aB5mfx62VU
	 JKcp45dodlqqg==
Date: Mon, 02 Mar 2026 16:16:19 -0800
Subject: [PATCH 16/36] xfs: add a xfs_rtgroup_raw_size helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: cem@kernel.org, cmaiolino@redhat.com, dlemoal@kernel.org, hch@lst.de,
 linux-xfs@vger.kernel.org
Message-ID: <177249638073.457970.14209039264983882920.stgit@frogsfrogsfrogs>
In-Reply-To: <177249637597.457970.8500158485809720053.stgit@frogsfrogsfrogs>
References: <177249637597.457970.8500158485809720053.stgit@frogsfrogsfrogs>
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

