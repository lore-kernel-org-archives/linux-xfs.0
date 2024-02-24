Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5442246A2
	for <linux-xfs@vger.kernel.org>; Sat, 24 Feb 2024 01:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708738498; cv=none; b=e/RZCDkzTzFuRAc14kPp/omRU15ePAnhtxriti98ctyRbDq0rP8NmchPtYOi5TIlsC9soTWjo0ngRrmxq5w4eTuuXh1+0DEcLaI8o9bZCzTjzEAAkV4UZSQmFRQg9Kzet0Q1fjlepzGDjqVQMDbQYw6ZUYaDCEs1PtLGQTVGQNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708738498; c=relaxed/simple;
	bh=3fbLZGbKgqPSo3J/fXFsExqz8nvvPkHhcv8bLVfzE8c=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Gkb+Drld7RqrrcbC4YYStofOoHK7EnLO9/gue0OaUH4lDuseqGwzf5bHWP9PQTGCYgvxpavquwB3Njv3ZAfuaa/5DjfFmGzR1WcxNOoKno63TCjPvs/zndwx4ZRdFjRYm5mSOgIwosfzwtKoarrB5IML3ej1ZqUVDCJ1sr3Samc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UZkelbex; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UZkelbex"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8223C433F1;
	Sat, 24 Feb 2024 01:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708738498;
	bh=3fbLZGbKgqPSo3J/fXFsExqz8nvvPkHhcv8bLVfzE8c=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=UZkelbex/EH05B84NgtjwB0rGjHabJ/uq912O7o1wnDIvKE4BvqM9b7EMN1y7Pk6b
	 yOjw5mf6uf4s3ai6ZTDC2d6JpfzyvTC7hGF73ZgDy4dPyNkzQ1zAo0U6b2Sc1sPCuB
	 DlPdHe0xJDWe0i8sRkDpxQDCX9HubUrRoppnQYFbiD8PwVjFgGhPsyzxnzV6c/ZcpO
	 e0WnciAcAXKG4ps0YDs/rsSVczzkWo0YHYOTeMn2+SPi+j4HHqifzLLOhEAyQSp8Zs
	 tZNrrc0vWxnfZKE3oJvKH3r0Wcn/mCU2wFztY4F5fBd6brlNoWlrcKrl86IDMwQxen
	 U5Zu+DU5Iln6A==
Date: Fri, 23 Feb 2024 17:34:57 -0800
Subject: [PATCH 3/7] xfs: report shutdown events through healthmon
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, kent.overstreet@linux.dev, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170873836598.1902540.4172674196917244120.stgit@frogsfrogsfrogs>
In-Reply-To: <170873836546.1902540.13109376239205481967.stgit@frogsfrogsfrogs>
References: <170873836546.1902540.13109376239205481967.stgit@frogsfrogsfrogs>
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

Set up a shutdown hook so that we can send notifications to userspace.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_fs_staging.h |    8 ++++++++
 1 file changed, 8 insertions(+)


diff --git a/libxfs/xfs_fs_staging.h b/libxfs/xfs_fs_staging.h
index 84b99816eec2..684d6d22cc8d 100644
--- a/libxfs/xfs_fs_staging.h
+++ b/libxfs/xfs_fs_staging.h
@@ -310,6 +310,14 @@ struct xfs_health_monitor {
 	__u64	pad2[2];	/* zeroes */
 };
 
+/* Return all health status events, not just deltas */
+#define XFS_HEALTH_MONITOR_VERBOSE	(1ULL << 0)
+
+#define XFS_HEALTH_MONITOR_ALL		(XFS_HEALTH_MONITOR_VERBOSE)
+
+/* Return events in JSON format */
+#define XFS_HEALTH_MONITOR_FMT_JSON	(1)
+
 /* Monitor for health events. */
 #define XFS_IOC_HEALTH_MONITOR		_IOR ('X', 48, struct xfs_health_monitor)
 

