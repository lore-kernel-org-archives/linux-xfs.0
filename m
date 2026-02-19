Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E324C31A813
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 23:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771544658; cv=none; b=dtylOGI/mfP6Zk6EUUWLpSJV8GySV/7P+8hoeJJ8wjQCiXL5wKZBz0KRtF1Qm6+7p0jhgcRXmshohpGLisLmo+BD+nHmpnlJDnxn6Z5uVPSFTUe9Nm0bksIY7xpmHCoSNTwMORD8t9Dhq9aoBD/7VPDiuNC8RDOdUItTZO7fQmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771544658; c=relaxed/simple;
	bh=1L1bl2qSLLHqAt3WJhk6ya35HtMUqIbKqaG+hxe3l30=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IRfPRrn2IPxlpuyq8AyQL5e9T++PzlJcaJAEjhQ9TNOGNlefCoyn6qVqWit8l+Xk2g+kAR9pFLrrEE3J+uNkd5ZVMqS30bQGkYGedxyFim6RDOIsiyiDa9GxvtfFql+s4C8f7ODbYX68awPmvtDOVRlkLssgtqU1c0kc+FYxtSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rINGBIKC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rINGBIKC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F944C4CEF7;
	Thu, 19 Feb 2026 23:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771544657;
	bh=1L1bl2qSLLHqAt3WJhk6ya35HtMUqIbKqaG+hxe3l30=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rINGBIKCvlNPfU+n8CsvgWH/+dzIX8W6JVBmQLTX/tubHO/g8wpVv9v9rbTX4uQDN
	 LoSkzA2MbZMqzAYQ0LCoJ8b+rZSqlUpcp+O6mWe3WkuDKfqwc11SrJC9K9QJRbxAwj
	 5oc2uSbILz82yEPSrEP6enSTyH8BpiFOeLWW8L5rFH5pWGE5RbfsCS9Y+Eaj4wASWt
	 hPNfxPvmWIoJklpZCtxjH9ojsw/FsOBUDTcLD7gNxFThjGxkcMRo99nVGr0+vXX7S4
	 1f7XyrpTaIHa1kVDpE7zxHPj4gKZFHvvR2A5K+sScy/47OUeJicTodc3n+jPjnP9h6
	 lEscSZ0jFeazA==
Date: Thu, 19 Feb 2026 15:44:17 -0800
Subject: [PATCH 03/12] xfs: add a xfs_groups_to_rfsbs helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: cem@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177154456784.1285810.10733186950417915854.stgit@frogsfrogsfrogs>
In-Reply-To: <177154456673.1285810.13156117508727707417.stgit@frogsfrogsfrogs>
References: <177154456673.1285810.13156117508727707417.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 0ec73eb3f12350799c4b3fb764225f6e38b42d1e

Plus a rtgroup wrapper and use that to avoid overflows when converting
zone/rtg counts to block counts.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_group.h   |    9 +++++++++
 libxfs/xfs_rtgroup.h |    8 ++++++++
 2 files changed, 17 insertions(+)


diff --git a/libxfs/xfs_group.h b/libxfs/xfs_group.h
index 4423932a231300..4ae638f1c2c519 100644
--- a/libxfs/xfs_group.h
+++ b/libxfs/xfs_group.h
@@ -98,6 +98,15 @@ xfs_group_max_blocks(
 	return xg->xg_mount->m_groups[xg->xg_type].blocks;
 }
 
+static inline xfs_rfsblock_t
+xfs_groups_to_rfsbs(
+	struct xfs_mount	*mp,
+	uint32_t		nr_groups,
+	enum xfs_group_type	type)
+{
+	return (xfs_rfsblock_t)mp->m_groups[type].blocks * nr_groups;
+}
+
 static inline xfs_fsblock_t
 xfs_group_start_fsb(
 	struct xfs_group	*xg)
diff --git a/libxfs/xfs_rtgroup.h b/libxfs/xfs_rtgroup.h
index d4fcf591e63d08..a94e925ae67cb6 100644
--- a/libxfs/xfs_rtgroup.h
+++ b/libxfs/xfs_rtgroup.h
@@ -371,4 +371,12 @@ static inline int xfs_initialize_rtgroups(struct xfs_mount *mp,
 # define xfs_rtgroup_get_geometry(rtg, rgeo)	(-EOPNOTSUPP)
 #endif /* CONFIG_XFS_RT */
 
+static inline xfs_rfsblock_t
+xfs_rtgs_to_rfsbs(
+	struct xfs_mount	*mp,
+	uint32_t		nr_groups)
+{
+	return xfs_groups_to_rfsbs(mp, nr_groups, XG_TYPE_RTG);
+}
+
 #endif /* __LIBXFS_RTGROUP_H */

