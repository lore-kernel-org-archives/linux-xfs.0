Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE8E81CCB2D
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730845857; cv=none; b=g3sO9m0/fQXH3ClH4RhHjwhWiXuH1LiXKtf7YWTdWT9zeAK6BBwmU1cSsQG6O8mGneTdIV3uqstc5PZiIxjxZfg7V0uEONry1iKp+OtjK9RkZY2aWCnW7lplpVu8ceMS+Ei23s7fGYgvwhzVvSabbAAhHVyw8hR02sLFVWJkHow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730845857; c=relaxed/simple;
	bh=3MhcNq9E7Zhfb3Wl3p4T7RJv8Gs3D/NgwmzTCH7Qs7Q=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qd+vihI0n5FMV6vShfMELzPxj92o+72GJ3+mDdt9FJftKsm6qb6SA5+aRIUW3PKoaiffUqKnmwVbSCmhI0P4GdtiiHYpdGvo8eShtl1gElE1l0e+5YiK/Ul5oHxy+bIHkhQTPy345DmM+dnMQGWDIGRjtdkJxE/chKYd0zsXIKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Oz5U0Mu3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Oz5U0Mu3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FB2EC4CECF;
	Tue,  5 Nov 2024 22:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730845857;
	bh=3MhcNq9E7Zhfb3Wl3p4T7RJv8Gs3D/NgwmzTCH7Qs7Q=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Oz5U0Mu3hewdRYQxkmIzOtEQuArpeIr7sL8ySNSOqdfCVZB6hiE5YU2828x6ZjYnf
	 rK/yORtKpsdIqhde0Ik/MMnKbypljIEqbB1ap2z0OnZRsjbPJtU7vnS4AsLazTMsIU
	 fcfjV8YwNMUBDsAmux6zeOeHnsjubrsI13mtqVQXspPhv8OVH8iRIoFyYpMqsnHveY
	 wi7j/QD0P2MkkKUX9VR8LrMx4BlioCnwg5bmO1EH03AxNGBHideCng7cm6nr9UCwg1
	 3xt1MGxyKf3vk1LmwPgsyFEGuOUaKCuOm869eJAT9CxsLX4xZ/0JCl2P/D8Kl5p54j
	 LLqKPaSQg5xZQ==
Date: Tue, 05 Nov 2024 14:30:56 -0800
Subject: [PATCH 04/34] xfs: export realtime group geometry via XFS_FSOP_GEOM
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084398253.1871887.1496042139054113574.stgit@frogsfrogsfrogs>
In-Reply-To: <173084398097.1871887.5832278892963229059.stgit@frogsfrogsfrogs>
References: <173084398097.1871887.5832278892963229059.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Export the realtime geometry information so that userspace can query it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_fs.h |    4 +++-
 fs/xfs/libxfs/xfs_sb.c |    5 +++++
 2 files changed, 8 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index faa38a7d1eb019..5c224d03270ce9 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -187,7 +187,9 @@ struct xfs_fsop_geom {
 	__u32		logsunit;	/* log stripe unit, bytes	*/
 	uint32_t	sick;		/* o: unhealthy fs & rt metadata */
 	uint32_t	checked;	/* o: checked fs & rt metadata	*/
-	__u64		reserved[17];	/* reserved space		*/
+	__u32		rgextents;	/* rt extents in a realtime group */
+	__u32		rgcount;	/* number of realtime groups	*/
+	__u64		reserved[16];	/* reserved space		*/
 };
 
 #define XFS_FSOP_GEOM_SICK_COUNTERS	(1 << 0)  /* summary counters */
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 6b0757d60cf3af..b1e12c7e7dbe23 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1413,6 +1413,11 @@ xfs_fs_geometry(
 		return;
 
 	geo->version = XFS_FSOP_GEOM_VERSION_V5;
+
+	if (xfs_has_rtgroups(mp)) {
+		geo->rgcount = sbp->sb_rgcount;
+		geo->rgextents = sbp->sb_rgextents;
+	}
 }
 
 /* Read a secondary superblock. */

