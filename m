Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8F9E625
	for <linux-xfs@vger.kernel.org>; Sat, 24 Feb 2024 01:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708738466; cv=none; b=PhKoCi82w/wyHIVJV7ZIBYfpITe2D1YDJe42+DWDqxfOIFXVrZWzddazxNk1kRE77euuxBBU3VU3LS/lOdtTwlGWpwlR/gZisFlQ8/8krNCM459pDR3TuMozlzBNCrIr5JVC1kkpUc8i4ATyJjVTH6mCbOYEmtFeMlx25HVniXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708738466; c=relaxed/simple;
	bh=fqH0tWYNvUGIyEXyP/tqKmiaNAXnn0u4C+owsVetZ8Y=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D5wchm/JVc9pwXojSDE8PA+OoA/Qbm9xmVrFMU3h8xaB5XgedWZlVSC2TnP2I/+f8fLIYTIB6lKtf7ibdA/npwTyJJghP91OztyrEATfpSXYws5k+IF9bpIyn/EF2HnE2cOFJL52o3IQ+7Hm2aTl73d/3qN3JyplPXFgyRqkmow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g6Umxtk5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g6Umxtk5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91A17C433F1;
	Sat, 24 Feb 2024 01:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708738466;
	bh=fqH0tWYNvUGIyEXyP/tqKmiaNAXnn0u4C+owsVetZ8Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=g6Umxtk59SW/EY/lTh0z9E3jqhtx/UjEAimV2llfGjF6Db4BaB+kbE/NPzcT1gUO0
	 rE41jWkl8KYBmc6uL7Pnj+xBMDGu83EI5Uu0ilK91nvyLHkRyvYxOMZR/dI6KT35fF
	 Fexx4NaaexZRGDEdZNlpY54b5Gy5ZD/7kldVW2QTJyrYlHskP33RWlROxgyvGzV6oC
	 qK2SXjzt/SzThhfWnCy7jnFZ56yo5u9xm+jlpaqCXTp6izracTv5O+7Y3h1drWcn17
	 wCZ6AK0Vvzytpc7Jgy1Ef1A6UXXUwjQo4Pfl0HQ/4UFhIH+rCIGLb3KUzijUizf5IQ
	 1cUq88dieAfwA==
Date: Fri, 23 Feb 2024 17:34:26 -0800
Subject: [PATCH 1/7] xfs: use thread_with_file to create a monitoring file
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, kent.overstreet@linux.dev, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170873836569.1902540.8467775124085893468.stgit@frogsfrogsfrogs>
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

Use Kent Overstreet's thread_with_file abstraction to provide a magic
file from which we can read filesystem health events.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_fs.h         |    1 +
 libxfs/xfs_fs_staging.h |   10 ++++++++++
 2 files changed, 11 insertions(+)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 246c2582abbe..b9d9bc511475 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -855,6 +855,7 @@ struct xfs_scrub_metadata {
 #define XFS_IOC_FSGETXATTRA	_IOR ('X', 45, struct fsxattr)
 /*	XFS_IOC_SETBIOSIZE ---- deprecated 46	   */
 /*	XFS_IOC_GETBIOSIZE ---- deprecated 47	   */
+/*	XFS_IOC_HEALTHMON -------- staging 48	   */
 #define XFS_IOC_GETBMAPX	_IOWR('X', 56, struct getbmap)
 #define XFS_IOC_ZERO_RANGE	_IOW ('X', 57, struct xfs_flock64)
 #define XFS_IOC_FREE_EOFBLOCKS	_IOR ('X', 58, struct xfs_fs_eofblocks)
diff --git a/libxfs/xfs_fs_staging.h b/libxfs/xfs_fs_staging.h
index 1da182c77934..84b99816eec2 100644
--- a/libxfs/xfs_fs_staging.h
+++ b/libxfs/xfs_fs_staging.h
@@ -303,4 +303,14 @@ struct xfs_map_freesp {
  */
 #define XFS_IOC_MAP_FREESP	_IOWR('X', 64, struct xfs_map_freesp)
 
+struct xfs_health_monitor {
+	__u64	flags;		/* flags */
+	__u8	format;		/* output format */
+	__u8	pad1[7];	/* zeroes */
+	__u64	pad2[2];	/* zeroes */
+};
+
+/* Monitor for health events. */
+#define XFS_IOC_HEALTH_MONITOR		_IOR ('X', 48, struct xfs_health_monitor)
+
 #endif /* __XFS_FS_STAGING_H__ */

